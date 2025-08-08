Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52131C87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 09:41:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E36596B007B; Fri,  8 Aug 2025 05:41:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC0826B0088; Fri,  8 Aug 2025 05:41:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C60B96B0089; Fri,  8 Aug 2025 05:41:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AFA706B007B
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 05:41:14 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5F82C117D3A
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 09:41:14 +0000 (UTC)
X-FDA: 83753096868.23.40C30AB
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id BE6F91C0007
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 09:41:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="J9BGv/WY";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=A9FfQxUS;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754646071; a=rsa-sha256;
	cv=pass;
	b=rIR7RlcByeLGd7atCTE9oPJ6cXrbZfHRGaOpfm/I3V0VaEkPvrdNvtpgFacF/QRuYVJJo6
	kKtJvvi66pr0zuK8k8m7b7DfYR0hll20nKyAHL0DevCQp4BFD7gF0o265dQ0nvs+sRKGBO
	pLCJSjZt703Ubsdz/HUnREwfOKOBL+E=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="J9BGv/WY";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=A9FfQxUS;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754646071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+15/hbPuLpmLrauAiabvn7+xETHc3Qmbm6qs6If4/Gs=;
	b=Rz2Y6tJve5IaSge3pUBK2ImWNhKSYnWqRqH1eLRIDAChZwa50Of3uOFUDKfj9KZlN9QELe
	Aq1Dy7wnBd38TP8ypcpM8xSYDNnuikgQXkxWF8KFCOjc233l8YdNcTsIp3IuDaKPXO4rSk
	TUZQ05o6iJAxurCmiKwf1LXHFI3GgTs=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5786YiiK002776;
	Fri, 8 Aug 2025 09:41:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=+15/hbPuLpmLrauAia
	bvn7+xETHc3Qmbm6qs6If4/Gs=; b=J9BGv/WYxar9R9+jI/hyXbqoLBIxf9uUZz
	mY7/02jGBX3ZREOWnFowAtgXkP1iX3rJGUbduLTkcG/SqNNzQvwPYSRaI3sgpJW4
	GxA8Qodghvdf4HtJairHEkP9lEvoTq/f06Pyo+vlCgo1cbgBE6yG8icrlwHjMggB
	x+DpMGnJ1NYoJxZJrbufe1cF9HL2D4aIjOo9kRZbv7P2SfjmYtB1ucHUg7VhTVpN
	7n1fPw2L66edXjQox6NbW9VZzZIhpKTS3Rvg8FcD6NKcPLHJIHzS41p0WZYn8TRQ
	RoKbAV7TC47mXXpuJYjQUMYsrrtXr6f1gPTM93b1g+9py3XS3oXg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvf5v68-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Aug 2025 09:41:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5788d4gR009798;
	Fri, 8 Aug 2025 09:40:45 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2069.outbound.protection.outlook.com [40.107.244.69])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwph4js-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Aug 2025 09:40:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eRaOdFJV8wBmlUTuOTZldk86hKYDHbSK5aO4lreG747TgCuBOya64bUzOZHTvBEAIvKu7dIwWfhZrzogE4hO52qpIjz6KLduQkOTOKH8h628rV56CzCCnvWy13kOvgehxFD5pcNNeBnE8zWpYtv7f4RCz/SAdoJkCjujcIL1TgGzZ78tV3gWlXnPv7hjcqOPuqoFihkdgS85lpuzmAZVwsDNIjE4PdyMQ6Iwd/5jtYjbcXuCfdgUa2zghtiddW1CLMQ4lTGgtL+cTgkt9nl0eo1uwgymt43hD9DdXutO+/NPd1d6qdna4z8QCRsdXUo6kmWrVzjKzXDGNSok8XcBPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+15/hbPuLpmLrauAiabvn7+xETHc3Qmbm6qs6If4/Gs=;
 b=V0NJx6gUoAzX1ZjZlVtMjBqKYre0+FFlG++4JtnWYCxazn4QRHZffs/xN9wNNYXO6VXj+Fv2UhVGVki+2S/nDNtlgWz538/o+vShU32tjU2kL32nZwb7/vjA7PvZq9RyG09lTAy4Ult5To/cqVWiAgK38/jw/V8s8L6qSNZg8Mto+IOh/Z/aMl2kWGD3dcYkZQBFfGPFKe8QN4GguOXXCUvpgy53l1empI9hOZgunbyLj5NNJxVghdAO6OSCqxdfG2mkPpVb2RVYQ7PIjXh0E8c1oJk11fUnQ23tGZa1khkNqlSBvKJecPQJ8Zup4nwGdzmVtoIIkkrrZyJhw+OqMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+15/hbPuLpmLrauAiabvn7+xETHc3Qmbm6qs6If4/Gs=;
 b=A9FfQxUSPQkf5yg9ZBqaIw98HrrnG7Iagg/lrkPzNXkOyC8JT8+TDm7A8FUZVGCVaFdvSnC2jAgsA3r5ZzmZmRg25Mtq2Nxu5COPRHQPsa4n0a8tP/+OUiJr8EekqU6FoEaTY5usqf8Cu95asgp/N6qnsc4pIohjnQCo/0WFCbw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB5658.namprd10.prod.outlook.com (2603:10b6:510:fd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.15; Fri, 8 Aug
 2025 09:40:42 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.013; Fri, 8 Aug 2025
 09:40:42 +0000
Date: Fri, 8 Aug 2025 10:40:34 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Barry Song <baohua@kernel.org>,
        Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH HOTFIX 6.17] mm/mremap: avoid expensive folio lookup on
 mremap folio pte batch
Message-ID: <2117e7ac-a848-4acd-8ec5-7ae88a0bf4a9@lucifer.local>
References: <20250807185819.199865-1-lorenzo.stoakes@oracle.com>
 <158e6422-fc82-4d6c-a442-2ebe956a66da@redhat.com>
 <3fc75720-8da7-4f6c-bdce-1e1280b8e28f@lucifer.local>
 <6870e24f-dda6-421c-8df8-58294927b62d@arm.com>
 <ae01c6bc-019a-4263-8083-8ab073e72729@lucifer.local>
 <303b1764-6471-421f-b4c3-6a2585cee2ae@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <303b1764-6471-421f-b4c3-6a2585cee2ae@arm.com>
X-ClientProxiedBy: MM0P280CA0108.SWEP280.PROD.OUTLOOK.COM (2603:10a6:190:9::9)
 To DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB5658:EE_
X-MS-Office365-Filtering-Correlation-Id: c715521d-f4f6-48d2-cd3c-08ddd65fa44d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ez+7f3f1SNRjGiZ+vH1P1016D4dWRs6yPMutPHz8T0T/HSGQb525/5QakXu9?=
 =?us-ascii?Q?Ss54F4bPm6kKvUiO5Rs51+TJTPVl5DznFRGg9DsOUojRDNL32DD1LEk7a7Gp?=
 =?us-ascii?Q?jiYF20gA8bRR/+LSiQT9gGGgQR2LxK8/7URmYcOESxUWBOEg888BJP+uZ8o8?=
 =?us-ascii?Q?zfRgHY15K0EhIbmhv/gRD9oZR9ARrkQk+c1j9hw34xUB7kYtc66DYHX1VjGo?=
 =?us-ascii?Q?u+R8F3aCAbgXhRViEjDZE49S63mUUKjh4nfUKZF5h7aIEdiP4vldd/mm6mqa?=
 =?us-ascii?Q?cK4bQG8/dxAiZ4e3ZDA263P8SK9/NfBgUt1/lp5LnS6KT6JlwmPrTT2vgaJa?=
 =?us-ascii?Q?boWC+kE5wMjJJsQgTQ14bZNGkLZ0lDki38Zj5QyxW+alNbzqiq+lR7dHQWl/?=
 =?us-ascii?Q?JlhskhOgJod3iP0hBMNRqu6jc6Tjw7/0wrwyhOFmJlda8jMcG7KHy/0JOtHQ?=
 =?us-ascii?Q?Iw+fRN8EclKkxyq/d8szZyVVzpmuQLQMkJ4YDV083+FfTbr1iYk/Cqv7a5ig?=
 =?us-ascii?Q?lt88EhXsLu46B0dftXDxLtrst8iyfkwOa4SrGNIYgxwGtxk/R3SYGxfURkDR?=
 =?us-ascii?Q?qBO9g+zD9gZ7huBdYhTOgjQZ6h3xVR4WA5wcLWJNB1xBAfsXEOOZRRxvCq/c?=
 =?us-ascii?Q?fHFtu4/hCcqpZndsis5lFvGWwL3a2RPc3jXZnnmI1FRnyE3nhC/iyIuU0xTj?=
 =?us-ascii?Q?Z7HuCqt3g+fB5fcsgkLO9v4otmrnFxtW1cQ/KzzN22TuTw+nBfnh2NNqI/gB?=
 =?us-ascii?Q?AKGLYkBmyQy9EilBDfCOsWF9pwYhw3JwwidSxsp72fkJm8UnFdym+ZRCNxFw?=
 =?us-ascii?Q?Jmea2PlvnxJo7zQzK+1pxIjwDgmz9Drj7eCahhebGusJu6tBgY1cPMpZX4+V?=
 =?us-ascii?Q?b1bZ13yG+5ctVSdqbc+oWxYZ5axC4HDOiiI09OSgtxQJO4ctvIA/sPr3y87K?=
 =?us-ascii?Q?oZt3H2TWQc/Oo53MHHskORW0vPWKtgNzTw4AJ6nEJLPgI8kYgh/SvNrxTsrc?=
 =?us-ascii?Q?XVExXDsRUdt38LkF6XHdVIasZi60wZdw9xkGIGjjb8Z7fiPWegTXTzdVj8IG?=
 =?us-ascii?Q?1cc7ryLedK0m6CStQ8mRPd+Y9+WIJNDxZJMNWUCvkfXGwwONXTk+idEUK2zU?=
 =?us-ascii?Q?/2TMi6ODgWhzcKuKLNlipzAWd8T+gGxHk1dRN91zWf3qOXjZvENL6NdCr8q9?=
 =?us-ascii?Q?vC0IXXfSJFYvRZ9dt8iNeNhGa22AACJ+SciuGkf2RQQQWpzGSGlMATejDrP2?=
 =?us-ascii?Q?+GZdu1rpPBiVw3b3+sHyNqYbn09+/ik9aT7FEdPB1Gi5KFU2PsKrE6sCCq9J?=
 =?us-ascii?Q?PidDjvBArkMG/5CNKlc1+FOq/rAxAmgEVJVhmWbY5yXujQgrMMOy96W2d8gq?=
 =?us-ascii?Q?OpgZ0RbDDyA+8j1XG/07yWfvSDuPsVBg1cPigr2Q2qNO1uXFI+O1udox4Mqj?=
 =?us-ascii?Q?uW0qVGVsnq4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0S/7J5NtWCkKuBf+6zr021ZSSxGim9TmA+ZaLfsEsSA/2woGNIG/Vabt2iJ3?=
 =?us-ascii?Q?7qrN75sUB+Xj5I4yfWZWqQLxGyIruihHtv8REtfdNAe+GtIRudZctO86ieiZ?=
 =?us-ascii?Q?n49pzDJ6uVGIqS67URSEHIs+a9lvBpsbJcX82/vclwALxrI9WfFuxJCJB2yn?=
 =?us-ascii?Q?Vmxe+Y5VssmJFub4Bk62lWtzdFNehbv3OiG9xZGeihbfGgcQgG6OGdlhDQ2P?=
 =?us-ascii?Q?f7tDgY+nncXI/KVX2MATYgXdVZdO1aOJe/LprwqgIsfI1GP5/uL/9xqraruV?=
 =?us-ascii?Q?xBsvSJsJDPSmemuNK2Bw3qLuH4CHCBo9AWzk0OozHAVXwXw/GG6gCxs7YgI/?=
 =?us-ascii?Q?G5FDHc46LghofwoeKBqM2CStRuu4IdSwM1wfiratjco8YY74JXn/ZWaW5Zys?=
 =?us-ascii?Q?iWi4/oGX3HnUjgM5ty0QbrXM9NcnKyzKP0FZVWSPXmRZG8rXcOPbebe7D+dm?=
 =?us-ascii?Q?rlRrTjfnXXfYULd4sWEFfNqWCml0138k+emlLqPgYvWHU59DefrwsViIy01L?=
 =?us-ascii?Q?+FFi7Tqs8nTf0jkqBfzpftedgH3MZCOVaP4vMsLT4pRpqFFyQ7irGf76GyOO?=
 =?us-ascii?Q?l58cp5OUhiAn9pK32V7oJIisow7KlHSw7ZB9F5K80nDda+g9V+AcHDn0ldNI?=
 =?us-ascii?Q?PU2OoaZ8qDtbEJ1SO57TQfiB3ghtXmatYz7pMoQ8zdP9mIys+hR+D3qsdQQX?=
 =?us-ascii?Q?2VKqsGgX9MYc/o+CEtTBoJFJlFjSBhwJ0t7gaGBkl9/3BPTXJdF8sk0DJYw4?=
 =?us-ascii?Q?5hvxuMn08EJIUsq8fjJTpc8vdHF2bXFpjLKHHFGuUYSk8ggGEBkD6vsAqdno?=
 =?us-ascii?Q?aX67xPWeZiL/OpuYGh6plZ4Xk8gnyAD24vB84bU2q+i4onabOhlLgc4bdIZ2?=
 =?us-ascii?Q?+hzAR7kgdo7mZHExopd41XWor6uSfDqJfSdrNb7W6AkcnnojmBRaxFbcz79a?=
 =?us-ascii?Q?SDXtOXGm3XtQ1hWSmcw85B7DsZGfwPtp77GN5IFCqCsVyob9RRRlmf2wEXI9?=
 =?us-ascii?Q?QlmbzCPDCFuIq9uyDVH9FA1qTV3xIlZ5gxiDYgtsbFoy1gNSoDpXDc7mnQan?=
 =?us-ascii?Q?iMAPsfXtmdY3gahCBntrUEkwJm508t9vkZ0TwLbGRKxLPU951S6rFeUAAxm5?=
 =?us-ascii?Q?CN8G8CXAxDueMl2ydaJYzuKpINkjXXiCkBXC4qE6svPbQDDlH/NXsUGZwZ0t?=
 =?us-ascii?Q?3Y+rtUp6FCF+kSpf7dOy4XdtOR+alJCYUTPJ6UZu3ixNyaVZmNePE84uQ9Ez?=
 =?us-ascii?Q?xGsAAsQt5fYz/2+NQ3p/xcPMbolMsyA0JqPZmbPyC8NI4V2jnq3JKPDG8bbK?=
 =?us-ascii?Q?lJJ94PkWTl/ti+l/qnssjLnbWrpwj7L0FF4v1kI342+G7eQzJY01fxkti4yB?=
 =?us-ascii?Q?XUccbkOgPt4LOjS3JUpdaKMmZvqgAfwHQ6lNdRI9i3+vwA/q5OFXZiAjv4Av?=
 =?us-ascii?Q?QdlXXnI2A0hb6r7XtVZqlx/viriagjhuGcWOUd2JcCWkslxYGVWtf+SjYOj0?=
 =?us-ascii?Q?sXuzMbb5UiDMccLjD65+khjFjYxvnnOJ8SiNX10+MWtiMSmgRdtT9Ydb/IdL?=
 =?us-ascii?Q?Nxwwta9BWe7GJELxzCxv7TVUD6O0bRm3wX8Ww9GZkG3XG1S4gS8ZjWFZ3P8o?=
 =?us-ascii?Q?+Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	izXjTzGIeKYBc9DfHTYfBrmwyLbGg+7XNxaSUuUTx7Svk7aFktu8WLPWL1+W3JuJ/ewwNv0Ioy4j2VN0ngOPQcuo2MB2kQa82L97JoLDruw2QKPqqh9ANu2DZPzH3G6usMiCmYxor9YpdnF5xlZkLqtQ8cxCzNPTlZaIrhD99lGi2CKjD/ty5UapKVsKUZjLyiK0l3LL9C9eOA4T3L3vBHygKk4y0wLFCRAmTAzuPeh5+s73k87JpnYv7Y74arPkEg2H8e1ar/D95RWxmSMERb6ppuJZzzwbegsL0qn3+EU+OmLFl5uSTMtgRk8eCP5r3eflpbQhNXURfqaR7uZnWGfP9yDqCqpqyuGmk3+Ka62wixvmK8b0J76xF3VTBQnYYmlp1bSvJek6g4DQxArvmnaQZUAilK1vulC9rqtCHobqu32ZVJi1YZVVloRSwQ8lWR8qJXUGzxdVvJhiy+jLICm5hmDfCGHJc1zawAMdU5cqj5GxoR9lIl4iZn20wi28FQbxQZJ6ROOMFjnjIctcS/QUAVzZRw2nQGf8tLvdu5j7tBv+cU7T8IT2EH2ozs8f9PnIDK1ytIzOTPC5iBlj0Sq8+/1hUKLjgoxhuZJ/Gn0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c715521d-f4f6-48d2-cd3c-08ddd65fa44d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2025 09:40:42.5094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iakEkSHy2zn0rNrRJ0S+McsPqm53p3dOaWObUEGhPwzi/VZq3nN4SwXlLlyr7b7OfUlJlVW20KJQYDA1JzhT3ElN2lQmJFmmGipObjZjuQQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5658
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-08_02,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508080079
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA4MDA3OSBTYWx0ZWRfX3FdZHNl0J3p6
 DsK7x09TmA0nBKaavZN3kbfwuPvZc535zIIfM1Mf6xZGU2DzBoAzKM0aDwRphoidO6sVEzPEZey
 6HKCING5V9nBmeMhm0akykFNFqZY2yw1OJBkmii3ODzpXPsp8zBf+gU2fy7XGs1bZN2Yg0uxIxd
 bHLNosxP2oRMYFdi2Bdpu2CLyVhx/nA4GgdYr76pzT5BTtCftel4125yfYTLfum0ZFikCK9yr17
 turfmnsT7cB/ZicOF4sNj2Bs9arjimgaHzGn8E90h83CQQaNY/tDT5erO8Z2eOID+3KVdu6xvEn
 1Su/8xpHGTkwJ9BP1zdJCNfsSIBYBR6aHwWTplG2LxLC07JCCu/zq+O597PSNzA748hbNNjIIW0
 iHhs14f4c0kX358SJsaob3slgKi/8x1du/740HilAZUwmdjHUAaQIM8qpmeVBJkUaSRomAiU
X-Authority-Analysis: v=2.4 cv=RtTFLDmK c=1 sm=1 tr=0 ts=6895c62e cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=CEhHzXULe2qCZuwJhVsA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: _wsbf63YZaKJU_xInYHefHEOLs1g8YmU
X-Proofpoint-GUID: _wsbf63YZaKJU_xInYHefHEOLs1g8YmU
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BE6F91C0007
X-Stat-Signature: f8tqgbiq4zwtcz61u6bt1nr9jry96jso
X-Rspam-User: 
X-HE-Tag: 1754646070-895917
X-HE-Meta: U2FsdGVkX19k9kwqSup4OX9iCImPFq8xeALVmoa+CL+5MUmduLO9tQs1b64pRG64/jXb5lKU2RC78nkbnQL2YJ0QCmKGzZy/ko5m2U4pE5orWW0fI0MPgOczTYbBsfFh9qkIcJGrP8tkk4aLoCqK/mOzIm6rKMwCpQAfFWZKx41lhDgw90i0cfjURtn/w6HhPwkFAvL89gpZGFsEamkCvyBBN3j2IUTR4OFFLKdmKRgk2cvNpzc0CBp386+Pi13XaAslMCdYfhUFWUIqsnc5NYHrLQ+MWV0Mp0iLBTO5WTejuk5/GMPWa9Ni3+TAHzXqn/WROnNT79rn6sk9+hItW4cwkc9gtrqO8PHAof/If2Au5iFHh0iIiYVcVlbDNrhy/qaJnehnDfsWlSw2OSky38jfvY1XnfGsXto2fiaWdG88PJApjkHwRoSyyPjSZ894po8iHEG6H6BiT9ZqpfNmEL/NWzyXgPZ07cBD3YfKfSGq/DxHTVge+Oib5u1fDy7U7hVHopONBBLBbXPwRzFjgszehRz98TDq1HXkf+4HkOiTJMc9Y2Pqsp60i9q0BkAJZ7n4XDnW1BLOUQFhs6SU3oc0ArOQOEOF1RBz3LPyJMpw9OJJf6VGLctNxZjS8J0eWIBBfaT/uqihIWdqO/KjDN2xdJAazwvCn+oIK6mxwVsMCNJObLMwOjDKI6hK7xdx1KjcSitRyDWAjWsiVnXdnQYQOK7HfGgMjxAtOC58pRr7FZ31pwx9E+ntftvU/nrpZJ8YXxKzarrANFZH4oaUaI+hOO0deP1Jjv8Sh49WaGsBz+RMe8FsYII7b1O1VU93buPMLJiDe939/MgjLB1yjyNbD+3GluC/ONkPKVzp8EBg0HvhLcujupRYzkhVuvQyyRUCCbXf0o0/zhqMtY+hagdfLJAA+glYrMWOvELeBOIrO8ZxfZV7XmlqIY7BciwN5sw6E/2WpejkRheNp2j
 91NMEsuB
 J3gO6Y7So1h3Kf1sxHqE+u50XYtsE3jWmqsnF7GYqLr2iyJWZSqiMK+iBq6keB0DOZDrIFinilfcX8MCeAEWd9Pyor4Kd5wkEXg4QmNKaLwnqpKyBraOtolOjjCTGQ3dmqAbjY4Av8s431/Us38Ud1a2Lf4o7Zl5M2FhumM9Nwz7eidOVAXFH5uOV2xnWnhIfB9fb3Cwd8tIgMmIOEWMi6DDC5XcBOuHknfoZA5SVrjUTJd/2jPNx3QIgKkKBCv6DLsSFIKxAUf6Teno1Hn1DpJ77AJOQnhsQsiSduASA8EPm+UfNbzluNBE0YY2gfEK2zSEcUfwgpSRTXKUhuBiCRBfV7GMOFICOwoqf3tjhVGgNpQ3IIqmttiZAy59y/DgRNDDhEo8yyY9gj2BPxPiWZovc3h7Wl3sT2LaY035sd3p/hW0xE0MfvVm/gfAHUb2DOznITSIdauQTQKPmts1YS8GTFnov9FRsjnhGl9M9k1xisbLybOO0PcSyYL5ezGIgnrrM+44//dUfqP84rWEOQ9p69p4zqBaoS8y611pq7tFVE1XvwKxWIc4YUYPmMMhF0XyNkYqUNi1am6t6u97Txu5D4pD1fhs1aowsWhZygJIMB+FqDzT4EttnwxA4DcmQMoM6bmTT39733kGKulocYJmEAtzNgXi4nxRyXLSPUK0gLXA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 08, 2025 at 08:19:47AM +0100, Ryan Roberts wrote:
> > Yup David explained.
> >
> > I suggest you rename this from 'hint', because that's not what hint means
> > :) unless I'm really misunderstanding what this word means (it's 10pm and I
> > started work at 6am so it's currently rather possible).
>
> That's a lot of hours; I certainly appreciate you for putting the effort in and
> figuring out the root cause so quickly.

Thanks. Of course not all these hours were spent on this, it was really my
very sincere attempt to help out Dev who might not have an x86-64 bare
metal box as readily available (literally, physically next to me) as I did.

I'm glad I could help identify this! Jann, Dev and David gave very
insightful analysis also, and all happened to be entirely correct!

>
> Not sure if some sleep has changed your mind on what "hint" means? I'm pretty
> sure David named this function, but for me the name makes sense. The arch is
> saying "I know that the pte batch is at least N ptes. It's up to you if you use
> that information. I'll still work correctly if you ignore it".
>
> For me, your interpretation of 'the most number of PTEs that _might_ coalesce'
> would be a guess, not a hint.

I feel we need to drop this subject for sanity's sake... :)

In my view the crux of this is that a reasonable definition of hint (and
first that appears on google) is that _partial_ information is provided,
which I interpreted as a bound.

Of course it's 'partial' in that there may be adjacent physically
contiguous PTE entries, and the whole thing is made murkier by the fact
that the cont PTE bit itself is a hint, which is again presumably why we
named it so.

However, if you, David, Dev and possibly _everybody else_ interprets this
differently, then I'm happy to concede perhaps it's just me getting hung up
on semantics here.

So I won't insist on this changing, though personally I'd still prefer it.

At any rate what it does is now abundantly clear :)

The comment is good by the way, I kicked myself for only reading it after
the fact.

From my perspective, I think a misinterpreted conversation (from whichever
side) was the underlying issue, and I've again had it reinforced the need
to always work from first principles on review.

[snip]

>
> >
> > I see that folio_pte_batch() can get _more_, is this on the basis of there
> > being adjacent, physically contiguous contPTE entries that can also be
> > batched up?
>
> From folio_pte_batch()'s perspective, they just have to be physically contiguous
> and part of the same folio; they are not *required* to be contpte. They could
> even have different read/write permissions in the middle of the batch (if the
> flags permit); that's one reason why such a batch wouldn't be mapped contpte (a
> contpte mapping is logically a single mapping so the permissions must all be the
> same).

Yeah I suspected this might be the case.

Sooo. Now we're rejecting if the first PTE isn't contPTE, is this a problem?

I remember Dev's first attempt at this checked hint, if == 1 I believe it would
then manually look ahead to see if there was a possible batch.


>
> >
> >>
> >> This function is looking to see if ptep is inside a conpte mapping, and if it
> >> is, it's returning the number of ptes to the end of the contpte mapping (which
> >> is of 64K size and alignment on 4K kernels). A contpte mapping will only exist
> >> if the physical memory is appropriately aligned/sized and all belongs to a
> >> single folio.
> >>
> >>>
> >>> (note that a bit grossly we'll call it _again_ in folio_pte_batch_flags()).
> >>>
> >>> I suppose we could not even bother with checking if same folio and _just_ check
> >>> if PTEs have consecutive PFNs, which is not very likely if different folio
> >>> but... could that break something?
> >>
> >> Yes something could break; the batch must *all* belong to the same folio.
> >> Functions like set_ptes() require that in their documentation, and arm64 depends
> >> upon it in order not to screw up the access/dirty bits.
> >
> > Turning this around - is a cont pte range guaranteed to belong to only one
> > folio?
>
> Yes.

Great

>
> >
> > If so then we can just limit the range to one batched block for the sake of
> > mremap that perhaps doesn't necessarily hugely benefit from further
> > batching anyway?
>
> Yes.

Also great.

>
> >
> > Let's take the time to check performance on arm64 hardware.
> >
> > Are we able to check to see how things behave if we have small folios only
> > in the tested range on arm64
>
> I thought Dev provided numbers for that, but I'll chat with him and ensure we
> re-test (and broaden the testing if needed) with the new patch.

Thanks.


> >>>> Not sure if that was discussed at some point before we went into the
> >>>> direction of using folios. But there really doesn't seem to be anything
> >>>> gained for other architectures here (as raised by Jann).
> >>>
> >>> Yup... I wonder about the other instances of this... ruh roh.
> >>
> >> IIRC prior to Dev's mprotect and mremap optimizations, I believe all sites
> >> already needed the folio. I haven't actually looked at how mprotect ended up,
> >> but maybe worth checking to see if it should protect with pte_batch_hint() too.
> >
> > mprotect didn't? I mean let's check.
>
> I think for mprotect, the folio was only previously needed for the numa case. I
> have a vague memory that either Dev of I proposed wrapping folio_pte_batch() to
> only get the folio and call it if the next PTE had an adjacent PFN (or something
> like that). But it was deemed to complex. I might be misremembering... could
> have been an internal conversation. I'll chat with Dev about it and revisit.

OK thanks.

Cheers, Lorenzo

