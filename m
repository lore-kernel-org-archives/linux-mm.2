Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 457EAE6BF10
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 21:01:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 826BC6B00B2; Fri, 30 Jan 2026 16:01:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AB046B00B4; Fri, 30 Jan 2026 16:01:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 486D46B00B5; Fri, 30 Jan 2026 16:01:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 32A976B00B2
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:01:12 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F3CDF8BF93
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:01:11 +0000 (UTC)
X-FDA: 84389850342.13.F19DFF5
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8919B1C000A
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:01:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qhM0L+W4;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pmN+XkmV;
	spf=pass (imf20.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769806868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a09mnnTsWNk8ZDi1O5yzp+1ctxr1LUvOzgOJrfdz7X0=;
	b=4y/zqBipz27jOR+mKMGmOHmXGuJd5Xthkfmf89MJ/S62T05xlypJnaGrE0z/GZkhjsmSQx
	CxQ6hGrixLf6+jbqcJUA3HC7FWYawUwx2vSqdhmVkb9Kd0Hb/XaMSRLf6ctQlM930pY1CO
	jXe0M2o9ykys7NRaP3rebNiJoX+JkUI=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qhM0L+W4;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pmN+XkmV;
	spf=pass (imf20.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769806868; a=rsa-sha256;
	cv=pass;
	b=JZSZqS4vRZjqP/ntgQKuYvrBOQU2TaLswjTeGUZtUggciOY2vuMIlG1hYk3GtfwOS5ZqXc
	72MLPEYmeXYlT6/hWOU+3ZYIhe6Evu0u1cKmT+z87Lapk4DgKaPG4INh/WKXd8P9r+lrOX
	XgalTQB2eYpZSXlU7tQth9Jd1lN6zxQ=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60UKDSp83338145;
	Fri, 30 Jan 2026 21:00:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=a09mnnTsWNk8ZDi1O5yzp+1ctxr1LUvOzgOJrfdz7X0=; b=
	qhM0L+W4GWcgvPOMpq41b3r/+2s1aPxYtfrbH5THd85Pfar9IhXqUWuPR9rhF7my
	6119bKte4t1/CHsiWiWmuySEJ5ZJ8fP0VPS5pHcLHICVHVn8oF0go1CV85wQlZ9M
	2gSf95jgXhTzpMlQhSqz8RrWX19vdwouf1JBNo5r+uW1wRcvCgZFzaTsZMjufgqK
	lAHPsj3eAKSgKQVVtJKghToub0ujnoPx0kx7AVs4p3W2ET7IiCOZBkRIKIWxX9Wc
	JI0FVOyaMAPUrM9G7s3y3lEPgPsgTbIx4US73iAK6IB6+lhKpZkR/4wdmoDZO9UH
	9ELiEoPx7LWan/OLuJ1w/g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4by39rdw48-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60UIkbKJ032726;
	Fri, 30 Jan 2026 21:00:36 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010008.outbound.protection.outlook.com [40.93.198.8])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhe4g0t-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZXHWMuMew5nxCRl9WbIzlXFTfak7kDsJOPKfoB26aUwaBlVBeUVMnTvzIr3sP0o8pA84ixAET6f698OAFzA/566vQDc1GKjaWBZHhGn+V7J7yUnIGaWVI5pMC7PPQ8JmZPMqHkMRmGtFaGgHaWbJu5A4THB/AQIwjuMqZ2x3Fw74KYot+TMsq6VZLku1Ey9D/7JAlcS2GnA0NTPnwIk8mDG8FFBiopkOCYO1vJKpB4bOc535ko9PbG5BKiRc2640tD1MTxfCWKm3qhgBqogAgL3IP6/6YS1ka5OwVxIqx0wvsVRZi/ZF3hb9w+Dl3o9Rt1VLRTleZNkpCAzLkUbccw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a09mnnTsWNk8ZDi1O5yzp+1ctxr1LUvOzgOJrfdz7X0=;
 b=lOfEPkGaQvhvZYhTTNeXikwX4ZiflfvgbNdfUsnL6VIQuwlevrR/oitj6FLQVXg2WP80LKTKCZEt0dLqWaqUY9mg9ReZYmRix355jPhYknXIKDKp5FPGXFC1r7Z4ohJsrhwBfgTy88iM1mUB9DhU3KIjJPrjxBSvETiQAoK7WQGperVaoQ3jCT4toQs17jAmKBlul7a+GffMOW4jQVFH4Tg1LVr0rVINop/OIQ9oBjinXaM8q7hTInuk0y+F5r6vHOSO/shV8BBXZ7mXtcO5wWS0zfknOdQW+Cr9eNr9ZxjNl2iW9pVFvTk7ThBZU3eX+r2qMsv71vUF6GR3o1vDIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a09mnnTsWNk8ZDi1O5yzp+1ctxr1LUvOzgOJrfdz7X0=;
 b=pmN+XkmVxy0xhDM80Z8Edx7cXlC4h4KgO5bJjMOMTq2uJ1R335sugobcw+79hiKGxFYSZNe5twxkI/1Rw23yIDhBidrndmhnGq5dwt8KT80gvCdnjLIR1GbYLiAqsGZiecjZO/vrU89TKsLAg1W8RBL6t9uPx8aUFjXZgyxfiVI=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA6PR10MB8061.namprd10.prod.outlook.com (2603:10b6:806:43a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 21:00:30 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.007; Fri, 30 Jan 2026
 21:00:30 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        SeongJae Park <sj@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v3 15/30] maple_tree: Introduce ma_leaf_max_gap()
Date: Fri, 30 Jan 2026 15:59:20 -0500
Message-ID: <20260130205935.2559335-16-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
References: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0078.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d0::11) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA6PR10MB8061:EE_
X-MS-Office365-Filtering-Correlation-Id: ad42c22a-368a-4d68-a247-08de604299a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eDdkVIhuNfGXNLOf0gVfeV/BiU4gBzzuXgA6qF0GmB9z+71l8T2GNjTamwnR?=
 =?us-ascii?Q?7Ue6kQoMRvNRFDlsqb8NZ1BSTx1gSv1hnrT/68PynWKj6DmKA/vEEZ9RNKku?=
 =?us-ascii?Q?EFfLN+rqravPu7V17jDyWUVVJgWtv5GkF2IcRZ26+D3gmVClc/czC2njrVKx?=
 =?us-ascii?Q?Xq0mZB8cHIDq7scUgtupR9qS5j7ZEWzURfsSYZHTqHtbUl+/lCPm317ByHUX?=
 =?us-ascii?Q?pVd6Pft0dYlRfGMjUDuG51hP8Qv58ISI4ghEA22wryLTk8ZJwgfG1dMfEZ8w?=
 =?us-ascii?Q?3R5wpOP1xGKjc5wzvZB6FMNGvKSuCJs6oL/ALP9Z++4wnnj/3FdAhRsnV2uY?=
 =?us-ascii?Q?HSy9cv/UmkhjQbGsZNCE+3oSnMIuQnhuGM0kC3qkXLu+hI4U/9gYKQAwgnUo?=
 =?us-ascii?Q?fobQJGWJtUhO5/ioP/TowD+NlWg3K/4381LCd9k6J9mgpyphq51O55y2aehp?=
 =?us-ascii?Q?QmUwI4q0Xfv0UuMzL+LqgyLsDLVXQngnP4vG27uZZEmDr2/q3y+UcgaSmcR4?=
 =?us-ascii?Q?4FPIwhob2PXTew15gGxMauQCwkb3l1KeEQUNY1JOC8iy1/TJvKI6D8nTH/BM?=
 =?us-ascii?Q?wZtX/n1ZAid2GDCzC28LQDHGUbqz5uoGrVmOMrbUG9Dx3CPl0AYmN3SHUYgb?=
 =?us-ascii?Q?u7d2zO5qjt1IMJlisk0t5UvpVovg5S3n3d3zyd42YA4eodEu08h00d7+iwL1?=
 =?us-ascii?Q?+5W//k640qRn/3q/O8u4+3Cj2L45CFzABBnViujQFP6eiecDDu4vwMqkl4PI?=
 =?us-ascii?Q?7is6j3zL8Z8gZ5UdpIEJsFGpJjRdOVRqTDdfGZiOpTvQ60ZisCDMpxXliFsq?=
 =?us-ascii?Q?rmqCoOdUNhNLVH5lvZyICf0yl1+9EnuZK1qUVfhJGGhXB25IgjiOK9MmuBD+?=
 =?us-ascii?Q?v23qyLvCgpyE4RGRu9k/kapZHOBay/CdzFHVP2oufGJv3t4pyoitgauJzckB?=
 =?us-ascii?Q?6umJ/T10s3HLI1MBn14DwtGK9eFlxc83cZwwOHnjYzC4yJKOjTzxUfaphsvl?=
 =?us-ascii?Q?omYK9QvkZLD5B4fsfvdyY6Ph36+3f5x0++d1zWPGzTE8Q3vF09ymHs1/j3to?=
 =?us-ascii?Q?gZRNWBd0weDZwhdGZRkkeqV/SDwol+JWlCY6xLwRq7og2SAE3EmMVy1ka5F+?=
 =?us-ascii?Q?IXqDiNbwHvqaUj0j17+xMWqxDk3NWFmk0xCGZdoMLFdYYswFieXpMfZiiKo6?=
 =?us-ascii?Q?lSOYIdwNAn+OOoiijSBYQclNB2Gr6ja1rPXgSXKxn1/G3ZO8UuDUSXDMtAYa?=
 =?us-ascii?Q?WhTZK3HEFAs0BfPCJMOoUcteRlx1HqabyVhU3KhX64BCvWRxaGdoogc4vvMF?=
 =?us-ascii?Q?lBY7RzDTQILzHjsPNTLydbWLkvcyCRWOK7KBOGMGc/MQrJ7FI1a8h1UP2+WV?=
 =?us-ascii?Q?skBqONSUSxbStTV677uxWOgX5S/2Vc7FIuZ5x/v6q8joRtbQD/I4s4MqQmvB?=
 =?us-ascii?Q?kaYXY/745ZoeXD/9sUXgMRNt/XpS0aVVVA8yLETEmUgfH9MPBdOReNJ/6zFb?=
 =?us-ascii?Q?8fF1VP3H58ieCk1nvfpQdtx63nNYlHYjhKS+jmpwLYzmNhafSG0gSeA3jJNP?=
 =?us-ascii?Q?CG+c0JCOUoBcG6IVh84=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QiSl965y9VQt6rgnq96RRO6GXc+2qGigqk69zzU+0yAiBoVi7HUY4TW6/oCe?=
 =?us-ascii?Q?RqGMswhoW1EjYRHDCCAKShFsjZvER3tjBOkkkAD9DPSAY3sWSm4jHOLxN7Xr?=
 =?us-ascii?Q?ZBd17FeNMzh65Xyul4O9wlsiEWLaPphaKsmXSLQ6KH7PNUxTCcLODMc3/WGN?=
 =?us-ascii?Q?Q23oBvUisQ5z/HmjZ4AdXsmxbCypuhgXb287xb7Ni64IDnsJyvegrxo35IDF?=
 =?us-ascii?Q?c7RNRuHQvqYz1ElhtsCpiIVGfkJHOWPIJh7JMsBv5EdaxAqYb28g9Msffn0l?=
 =?us-ascii?Q?0Cc56WjsVTlhl0/2AxSei8YQcFyEaaQtDMEP+0GTLSy24dbMbyVMT94T9kgQ?=
 =?us-ascii?Q?EV9PvR7j3N4zWJC3jZzeIsBC2WywgOCJe8N0lBZBAu4wk6XSyCWMlBzzpEBZ?=
 =?us-ascii?Q?CwvnZ3RdUocaNIX0hzMdzEzt5zvj/ttVpI8zmKWKBhINUm61ZJ1IEyByMAiP?=
 =?us-ascii?Q?YxwvrA1tE2xKU+7yi+4fczDNVSfBEgMQtfbidlAyfi5ocRZ/hbCo0MY+M6Gh?=
 =?us-ascii?Q?wMq8gb8lUCEeQj2AYq4vil1wP8UDBO7VrBfQ0BkAlLL4MV2gxJ+QXzgJteDo?=
 =?us-ascii?Q?UFCYo3ZRFBj1dky9+z90QLO9Je2buSPlJhDdOerwM3DZqKBK6s8jnfzUyjZI?=
 =?us-ascii?Q?infMzB2rBLyMj7tX4Y8n6OUecEweJAue/H9Ca9uNZCFigO+i/zVc3mC/ByXD?=
 =?us-ascii?Q?tv7O+HJ5on6b2H3FswdU+hTzpNvpih1XfP/I6rBy/5MgWD8/VJ0e8ELieCfr?=
 =?us-ascii?Q?1h8eyuy8RNPHvt6LygDWVZwtyzGkNsLMHYjZcPsNhtq68kMGW9QUZhHCmCMX?=
 =?us-ascii?Q?PMtI3anIF2BwfH8ZZh/5soFHtTjRAWto2p/V6aq8V8Knd34C3DGN+JbRfbaq?=
 =?us-ascii?Q?DK4QdlZ7CAnsauLbLOKOwnJaV7WbmBSTxRGjJZLjSRODo9TsCJSSa1NbIyfO?=
 =?us-ascii?Q?Kwa7pK+4LlZytFXbnTdJZtYblaqfVDUSSbHR9F5dB7S9vagX6HbOOuauHTs/?=
 =?us-ascii?Q?4bTxOxVB4B9f8R7Eo+Hy/po0n32RV0cbOOMXYO47IUH9nmwbWSPKgF+Z+UuE?=
 =?us-ascii?Q?SzAxwJsGS3LVywR6+tCIs24C4thDUaz/FipG/oRxEOhBkdac1YcgMZcPXeir?=
 =?us-ascii?Q?gT3UtZ9ncJjVraDZOifasnJm2OnZcQ7YavkpDtRSbvnH3Nfj8oUMeL06RZxG?=
 =?us-ascii?Q?/PfELocApRZmjYaKbQNLSq6jyQ4oQcqOSHb3PFhnWTkJ47dw6HpCbLH/bcBG?=
 =?us-ascii?Q?TRhrxQTuMR33iN1X+F/995kVkldxrpSJt3XDgK0IkoCV8iQgXqsBg+1s/suP?=
 =?us-ascii?Q?bF51ey3rjSDRy4M1Lfqm/Kd1mLUYMj7xfmkg3Q6/u5RkFad5c8h+9CGqKzvp?=
 =?us-ascii?Q?jRyiE8fTUvzgJcS4aOrvsJJwQ9UIoWNAVQY8prIyBaN/ee1IDf7h4oBUwnBd?=
 =?us-ascii?Q?4fwssNrIdZ9WMbnxZ1iV54QWHgIPFTluE1L5N5K52L7KMJ7K/0v4qZ23VuX3?=
 =?us-ascii?Q?XE1ZVZfJBTdDn27XPTYs8GPuvp9oK6d/2iwwBLWnTCSE3OVdru9NHaeXC287?=
 =?us-ascii?Q?FhpFy0ND16h3icM4gmqi39jomrF4zhgLzG+LwR+nFkoyqYgE5qTiT2OKYiPV?=
 =?us-ascii?Q?FAEIoya5J6V4h1RJPvp3FpKsOSSRcCBwRYt5qXyEggfNTZCgUZbaH6sYce9B?=
 =?us-ascii?Q?PrpoBZdwToa30tVO1MRKd/qrMwREh/B2nUrPMrcyMwRuBgjagKVGZRwPZ7AB?=
 =?us-ascii?Q?CWdhn4IdWQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9n64N7BJ5+p6wFGxDM8JtOp9gjRj2SMY7RrHh25fp2EU0yMBHQZtFJrmyFuwPEXysw+x0yQEY9x5Td0VZCkZ1Mmz26QbQty5U2+0Cu1VTLPr2SXeObtTa7ID0AqLbcxzUZd2vVOY9uz5Fhk/Tjzta4AnvuXbQK1ggkKphtN59LxGEuOVevP6+UAjA0fE11KvnwhPWjpUxap1rXuOXWgsvY7QzJ3Agur5mo53WVSb/H6legvnxLdfnKTB7kL1DhX9zm8T5brFX5RPhlj/BW/Tf2ITHAQ0xmOGC0ZNo2gVVFHDctUJIokPAVnvtd88zHIgy7YRI+Rf6ZiE7OaNaqcoEB7pj6gZJLgfvfnGHZslVdYCh4RUU11btLHVANxJ66PilIKMOtofHKhrx8XXV5Hj2Z6d7r0eE20qOX9XIeNqglUN4V2+jFWByLoBxWD9BGoh6ukR7QtC9XlAV1gpq4q9U2FJNMK9fjkvBT/b9y/DUzKIwPCP2p5ZIQ0miBBojJ7WpXte5BZXfUqAGF7F7QxyeoFlJ1h7TYJTDWvfMspTSkL4hCQFD5epb3PyAGTC+K6EAyeoFqCFW+XQ9M32Bggiv/HJRP6shfJ7eyX7Sh1bssI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad42c22a-368a-4d68-a247-08de604299a5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 21:00:29.6201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MJJa4M5VejeUPWVo7yvhNfZE1Iqjt33GZpZ7i3MU6iWszMR29/GhKHmOBXu2xd7M1d9kIk3Y46sxNX6sxIdUSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8061
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601300172
X-Authority-Analysis: v=2.4 cv=LaoxKzfi c=1 sm=1 tr=0 ts=697d1bf4 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=-3J-9aNdBi9tGdEVLXQA:9
X-Proofpoint-GUID: JwCDEaAwPog_-JOh2GCKsOB2Xo32psU1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDE3MyBTYWx0ZWRfXzhCn1JBZHRhg
 ridEsm2woTjZzEScoMFXb1gSBz4suNcO/+s/+4sTecJ9ybAai9nPCOPaZKUmB/m2Vnpzad3ZMNH
 uaR+wfU1s+zciO/jURpvKzJWo4G6wXqG2VmJ0D32LJ/HwWuQsAT15mZyydFndG3gE6vuQ5CBtSA
 M0vGB+H0U3S9ZVMxDyhd/VRJo1h3OQA/NSh0CVooZvHZBQHi+b2Q/qfB0lC4OUAkSJsUG8BGpuV
 kpUJOEWcgPDms16M+jOs8Bh4TnKp/g5cDhT2RL5/CFeRptyMT3mGMf4imZzVFxqRBLk7cJBRTTK
 9sKPoMLyYJ4pXI4Ma4GgzuoNO5FeOnZf8Rw4X8qH1FDHbhbbh8eTlPNXJlU7ODQBi6rm+6Y5ptB
 QTiP7Z8ygc9/55IMobRXGuF4TnfqN26yaCtn4/xlQZHpo2cumrO6JDylb/Fn2NbRtn7eFiaQ6UQ
 FmRLCIRpIJrlJQmemww==
X-Proofpoint-ORIG-GUID: JwCDEaAwPog_-JOh2GCKsOB2Xo32psU1
X-Rspamd-Server: rspam11
X-Stat-Signature: dgddwq78hsoe1r49319p7qj37qxawj6m
X-Rspam-User: 
X-Rspamd-Queue-Id: 8919B1C000A
X-HE-Tag: 1769806868-237847
X-HE-Meta: U2FsdGVkX1/yomkoDYMqGlK2yeWbrYwtTia0qSXZZlEV11m7hmpC8K0lTrXj1FrDQxGkHS+UQ+Of6LyBQCZ1+WW1tb9EJyfWBSxlVRPxHpRwwT5yghQabdKlylfzZ5fM8c0OwYEmwfx4XvogIKR8Z6Kkw/jTYE8GBAxaW/al6Hp4mCsijRTo7LUXTEXk0h5rY9o74GPJgLM7mWpNyaC1NcuN+hyY748Y/NcxSKbv/m4APQsKCPk79/Dkt0avGZo7asz0zvW8gUXF02SMFIOcLT+knR65QsOuVweTZD/srpX9B1Kgfo5heyG1jiGeA7ajbpYZyeexFYRBo6NAzkp1QK2aBm5BdfYiZiP1SrWd0fgYzMEgYjUrP6Y+zS2noieqnmg4Eft0bJQ9OOC9DKdy6rJFT+xWDgAPDyEEVTzoIkYlIV2Z116+5fPjTzt6rEWS4E8DQSBxYNo57NVjaXbvwb3NzOxuJrYDFPvQBL6yP7fTomxL2o+iY2jG7Ylet0rgEKVfa8zAbF+onSGinz0YwIv0uGy5iy20eBwZkirEIHeos+q00+xdNwOM/DV5MI//nXDZh5xmfQaqRdgBT5ESV/GWUNsKgowMNKLHmeCIXfFPYQKOTNkCfj1Sa4EgPKKvyK7rC3R4+cZTqvmcEFs/BgNU1zdTWJkUvdipo8IHxWAe3CYRlTriOUuEjLMRx5GKyzR6pZsfrD5fhKHwdXa+EbG9zsvwHGo1qf003mHCMbzTEP5pAqOpQnZ2Ge4b94xg3BPtQKbPyOhzyuVxs0IKOELjSSUx6swwchRDDFDZU4Vv5Gazzz+kz5MkTXPMQB508TDPQlbdJfOcjyy+nCZtjFiByWzUoGx2d51Lj2nT2E4yGRR6/tzglVx6rfj35SaGMpEcPQ+isUqF+TU+cF7iXyJUof0TNifX83FwDw/MCQ+VCTqC1t1dOA5gRnrCMNwCR3X4rsuugAqZunXZTej
 G8P6A1t4
 PDP2hzmj0KYbsjh/Kasx3cKqnqYzdMtA7uH9WP6Z8BwBhDskiwZa42SJ7GAy1EDhNdKjupfYSwN6F37ChELnjhxXLC0j7SkZGWL8yoeAuohMJ2lT/uuACJj3XJzXTi516U3GRFWRAP7gpwb5ISTUiM3f0dGXjG++c+ssxGTIFdUQ3haIqzfIrhFIj6WyDS+cs052nhkYRBp0mZPGI7xLEHRTml4cNMwHcOsti6cHVDTk7XoztzDbF/GHsVhAeiCuPlaalbBKjFVOJ09qbYZNAlnO/FNnugcAMb8kJymW/ZYYU9qS6kDA0eimntSmT9DDB+ImcvD0mUPJasQTwdPL+/rnqpN/5TZ0KGN6lG0o1vsNCNuX55I5jubGAfKNbrkvCSvmTNKiJZq4A4/i0RtaSZtCtMqAnJnnps6SbZiAeOF1WVly7ZQS9wJBy/YxKY67xe5hMjwbQNCKOI64fxA0ZQ/rNpKQCSxXS2ZUDcFesw3b9A9EI9go1meUuCVKqtoOFITBc0I+WsMb9Yhr88wOF6Eh5BouQQoHKOEwHEpfF4fP6Pwz/GsA97IjPRwDzmQ6FiNAYB6IdAzQcSTLsjKKkvau46Nc5bZWgokH4A+49f4SP3l/UROH5FZ1Tr2NUTd+kvR2L3JNqAD2pmqy2B7N/nNQGJeL653tb3mfewHWOub2+BXD9pTGp8+SsWg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is the same as mas_leaf_max_gap(), but the information necessary is
known without a maple state in future code.  Adding this function now
simplifies the review for a subsequent patch.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 48 ++++++++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 0d6f810a4a1fc..499cae720251f 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1315,26 +1315,14 @@ void wr_mas_setup(struct ma_wr_state *wr_mas, struct ma_state *mas)
 	wr_mas->r_max = mas_safe_pivot(mas, wr_mas->pivots, mas->offset,
 				       wr_mas->type);
 }
-
-/*
- * mas_leaf_max_gap() - Returns the largest gap in a leaf node
- * @mas: the maple state
- *
- * Return: The maximum gap in the leaf.
- */
-static unsigned long mas_leaf_max_gap(struct ma_state *mas)
+static inline unsigned long ma_leaf_max_gap(struct maple_node *mn,
+		enum maple_type mt, unsigned long min, unsigned long max,
+		unsigned long *pivots, void __rcu **slots)
 {
-	enum maple_type mt;
 	unsigned long pstart, gap, max_gap;
-	struct maple_node *mn;
-	unsigned long *pivots;
-	void __rcu **slots;
 	unsigned char i;
 	unsigned char max_piv;
 
-	mt = mte_node_type(mas->node);
-	mn = mas_mn(mas);
-	slots = ma_slots(mn, mt);
 	max_gap = 0;
 	if (unlikely(ma_is_dense(mt))) {
 		gap = 0;
@@ -1356,26 +1344,25 @@ static unsigned long mas_leaf_max_gap(struct ma_state *mas)
 	 * Check the first implied pivot optimizes the loop below and slot 1 may
 	 * be skipped if there is a gap in slot 0.
 	 */
-	pivots = ma_pivots(mn, mt);
 	if (likely(!slots[0])) {
-		max_gap = pivots[0] - mas->min + 1;
+		max_gap = pivots[0] - min + 1;
 		i = 2;
 	} else {
 		i = 1;
 	}
 
 	/* reduce max_piv as the special case is checked before the loop */
-	max_piv = ma_data_end(mn, mt, pivots, mas->max) - 1;
+	max_piv = ma_data_end(mn, mt, pivots, max) - 1;
 	/*
 	 * Check end implied pivot which can only be a gap on the right most
 	 * node.
 	 */
-	if (unlikely(mas->max == ULONG_MAX) && !slots[max_piv + 1]) {
+	if (unlikely(max == ULONG_MAX) && !slots[max_piv + 1]) {
 		gap = ULONG_MAX - pivots[max_piv];
 		if (gap > max_gap)
 			max_gap = gap;
 
-		if (max_gap > pivots[max_piv] - mas->min)
+		if (max_gap > pivots[max_piv] - min)
 			return max_gap;
 	}
 
@@ -1395,6 +1382,27 @@ static unsigned long mas_leaf_max_gap(struct ma_state *mas)
 	return max_gap;
 }
 
+/*
+ * mas_leaf_max_gap() - Returns the largest gap in a leaf node
+ * @mas: the maple state
+ *
+ * Return: The maximum gap in the leaf.
+ */
+static inline unsigned long mas_leaf_max_gap(struct ma_state *mas)
+{
+	enum maple_type mt;
+	struct maple_node *mn;
+	unsigned long *pivots;
+	void __rcu **slots;
+
+	mn = mas_mn(mas);
+	mt = mte_node_type(mas->node);
+	slots = ma_slots(mn, mt);
+	pivots = ma_pivots(mn, mt);
+
+	return ma_leaf_max_gap(mn, mt, mas->min, mas->max, pivots, slots);
+}
+
 /*
  * ma_max_gap() - Get the maximum gap in a maple node (non-leaf)
  * @node: The maple node
-- 
2.47.3


