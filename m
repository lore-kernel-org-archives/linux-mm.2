Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 280F5C44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:51:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 516006B00B2; Wed, 21 Jan 2026 11:51:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44D1B6B00B4; Wed, 21 Jan 2026 11:51:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 224A36B00B5; Wed, 21 Jan 2026 11:51:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 066F66B00B2
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:51:24 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AFF0FC2AAF
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:51:23 +0000 (UTC)
X-FDA: 84356561646.15.2F427E7
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id 35121140007
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:51:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VmTaOgl+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nLVVJRwr;
	spf=pass (imf09.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vy3h/3dMA1JkUw6OcY2FbjpfJW8L8hjcjTXe8NStvfw=;
	b=xUPqkfgMou0d7KnZWPeiG/8piQJBajaFfDs4EsyqsOkcUiFFlwi1DaLGgG49hkQYGZx+xc
	DuN47kuTzOc7SLdWRmca2ZqC68y6ehtDKKSgfq2kpjCEKxMKnsPnFaRazbN2+r5efu8DzV
	EHlBLiHR4XDh3rIAyfJfQTXY6I1iKvI=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VmTaOgl+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nLVVJRwr;
	spf=pass (imf09.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014280; a=rsa-sha256;
	cv=pass;
	b=Bf2HsZC27WqV1g4Du48i8VINyE+MlWTaWawUeFPGpHdNNNGMJdvvjiwkI6X4ngQQZ9QDW8
	R3dNZR43hp8Iqw5jSd6GAyBHeFNp6qZZBQ6N5wYqcO9HJdI5F4sbDrbnN/baZsdELL7/Y0
	xSy2fAkpSEgCYmZG4O5n3S16fcRAbCg=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LFIpPa3264903;
	Wed, 21 Jan 2026 16:50:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vy3h/3dMA1JkUw6OcY2FbjpfJW8L8hjcjTXe8NStvfw=; b=
	VmTaOgl+xpDRz+Xd1CITyHG8Vc2omtlL13nMkCbBZw4OuQ3CUMaHUAiRK0jsg1y2
	bSd8NOD85iRXnWw4oJEjSzVyrskKf7AlbVDLMzLroUJXb9cQ3tTmQUhoyT3qUUoc
	da3jieHzAeUWwluRQ1C7bbeqUPgwhzdP83ISlIUzzur8yeHFfatHoY6Qt3kObQPl
	+Flv1m073FLCVdXiysE4M6bK7JafaS0JLpkHwNb4j/MvwFkVEyC7Qpsy+LinTlSL
	6Y+e2EYXen59VakhHzBauMRxGOo/E0JfvdYYK+IBE12z3WjoENO7QSmQZorStKy/
	CYRAjDVq7ppQupLPlJRBOw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br1b8e8j8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:50:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LG5fpF007822;
	Wed, 21 Jan 2026 16:50:59 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010046.outbound.protection.outlook.com [52.101.46.46])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vbhj7c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:50:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fmtq93XkfYT0PU25obS19CsM6/qX0WQTO1bf7IQjNEGm+S5J1gSV08rg0XA/T1D3OFuFjqYi2q25dCyZiRgwd0yOfUvu9J+bg9M4Q6PF3yFNtnVrCbc9ztKZNiMC9m7it+3/gR07l/TVi+pAF6pquKOdAXDoxdm2wWv/qKcBnA4rAJ4UGy4mELTCyIfATvsWOqbgpQSGxxsW6mW9goaeBgLH00DgLc/IWmvqJNOIIKRHiZtvvJHjeYWtsDN/wyL15u0Z0PpiTQKld18PyN98+rNvnAZrbKkQB1eECCmBk0/dcew3kr7Y9C9zDeQO9/mPplHyb4F7wpm8EATlGOpuIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vy3h/3dMA1JkUw6OcY2FbjpfJW8L8hjcjTXe8NStvfw=;
 b=FCLpZXDx+Cktz98J3ZLGwUa/9f5qDfZERyTLATgCxRH5uFjftL0a8O09pVS2MBQowxzyYiS7vbIw+4cyj2EvmZMjwh9kEhxY1A+DDKx/AqExTB88Xz+gTnbjyXNmEPUUgWJmZVbOOE6TTGmVIkGh1jMfdT6P4quGs0r7i0ql6OQD+U3gkcac1JNcUdJoayonV01977MAnzKpIIWMLQJUY4wBDtFwScACEjXOl4/g+/oR36d7rxmDuKWdKquxWR7mUIl3A1ugs/pYcZ8yZAp0oxMPgzEmKj+PhCKgkEFgVEiPK8gv5L5P5CbLZ31k1kG01q8tFi/kpEuxlGrDT9rJDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vy3h/3dMA1JkUw6OcY2FbjpfJW8L8hjcjTXe8NStvfw=;
 b=nLVVJRwrjZJsb2zmDDkQyq+yAnA9KPlE6OZjq1IUIHFY2Pg/btE1yvBGge89LvziX22OzGKfrDrydSACHLxWala/Y/3u8aEdijJ158Lt0H48t1O0oKzFeYU2Co9IB+7Bva7BiMm4UB9cneygkxoEHBcA7daTJz7uAP/BHmroWuY=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by MN2PR10MB4255.namprd10.prod.outlook.com (2603:10b6:208:1d2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Wed, 21 Jan
 2026 16:50:55 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:50:55 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Suren Baghdasaryan <surenb@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, shikemeng@huaweicloud.com,
        kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
        baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v3 05/11] mm/memory: Add tree limit to free_pgtables()
Date: Wed, 21 Jan 2026 11:49:40 -0500
Message-ID: <20260121164946.2093480-6-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164946.2093480-1-Liam.Howlett@oracle.com>
References: <20260121164946.2093480-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0319.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10a::22) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|MN2PR10MB4255:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e926548-11a7-4247-a8fc-08de590d3e60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3H3j+OuOV8L8qZfwf/G8am2QGZW3VOrfsp3kdjdlUiBV4ICmfLpIlqGj/J60?=
 =?us-ascii?Q?84PHB7ELWuFOy9tLcjhiKWjdtNnR/idTUS4aVt+4CE+HIxnWSse+RgeTN1ly?=
 =?us-ascii?Q?ziCTY8tivnyHUPOeLoHkFg4Fikt+P0+fErq1solrgJ7qQc5URuVPOA9/vlX0?=
 =?us-ascii?Q?+BhprYpje+mm5yJhIeHNyWd3kS3/pdQiCKClz+gc3WNdShTPKLgt9wQk+fGE?=
 =?us-ascii?Q?x/Zzp5V0D5pgUqnJQLkVT/k6JnjMgXaq8AjUGDq7em6WhzkW2WuxjVlHGmc2?=
 =?us-ascii?Q?J1pfGuwFjVLI1z35jVvbDkmWHptXtoqo4dXxPOaataUUlHR1dFm5iFG+pT23?=
 =?us-ascii?Q?Am4xTgbChYRy8xxhbHnQ7sAXZn2aWn+Ol4BBKmyNL4Wes3FFMNQzcGZjNIJH?=
 =?us-ascii?Q?12uOEO1Rv2Der3IhtbBDPtZcXTwDJqbBv8jK4KOShfM03XLyivHwWupkU8Le?=
 =?us-ascii?Q?jD0XTzL4+uo4hmnZ59w7HvGfcvq0IiDTgVJLjEEuiT0wrv0Z37eo+WWeMjnt?=
 =?us-ascii?Q?xRl2fiZ+KkQiDu9b4uj5hq2Y+afmoqoAXACITW4aziVe/5F+UhurPHPq0f8n?=
 =?us-ascii?Q?CjMrn7ktboWU49AVAhqouDCKT9pMLFEjSVLTQYacd9TdLC/8A9esBporWL30?=
 =?us-ascii?Q?tv3w0qwZi52HYipmvBrtlGRJqF5MEacPvMhLHAl3GdOp4CZzk7l7ecNXiLn3?=
 =?us-ascii?Q?hCabVeEy4g65WOzMcmyHCEuHXoev3svXp+8o5OQb61ABsYwUud5cO8Lh21sN?=
 =?us-ascii?Q?ZpkedHCCqUdepugeJHFaTonXo7GCmjZi9eLkql4B6f+G0XXBPHlewQfV2ja4?=
 =?us-ascii?Q?WFqRs6DmQSg6Qz+usA2KmN+MihuFkUqHAYUWTV6JJmyLcRumnPXC4cPbJiuF?=
 =?us-ascii?Q?o+NDBSy3KTn2q8vB4JX4kgQ60kGE1S4XwzDFyCSLjrduOpuzlFyqOGtdJmeR?=
 =?us-ascii?Q?a/c7w+lauCDtiDF5HkQR8BIVqR96pRjU4VEC0H52r1uyTLynUnM6FyaUMMhm?=
 =?us-ascii?Q?QbDIyzOmiEMjLNn3yYTyOCtgcTTvihMUEFCGRoqXLmSwoDL5HGY7kptHnhOx?=
 =?us-ascii?Q?VsrpZ4Y8aY7zsuQMxXarD+nOkC/fomOlQDjbrG7ewWbACuKhwWGB8hYVxXZr?=
 =?us-ascii?Q?bTRJaohPFPH46aQfvOPela/YDVhpYaDFRkuGjOWJaxihKBkZ8TCo65kFOEfX?=
 =?us-ascii?Q?6AZpIbXIX70prlGi16QZUfm/K9GOA4/qyqZ3we/fgXUaZ125bOFcS39t9KmH?=
 =?us-ascii?Q?g1ttWu7lIXmsCDc5pqi2Jy7GdHfCTFXPAu+xOjvN9idfT7gBqCDtVm5MmLIc?=
 =?us-ascii?Q?vsTVX3Yp9Jv1UH5BxgnvS+dYC0HRU+6kGybINkivoZjmQW3ld62WjkJsFrB4?=
 =?us-ascii?Q?h54JEQjXducnb4Y8XxJu4SYNCVDT+N66cXPa35OWOQ/v0njzufRatuKAk7aL?=
 =?us-ascii?Q?5Bd/mPRte7lUPk2U2Xv/EV9HhEVIIcki380MQ/UcdA2Rb7asLoI/bG26YZem?=
 =?us-ascii?Q?IbJjTkCCG0pck5LXV+wSR72bqDPGLej62nEJ2XBc8vMXjAR7nfCLnkNyX9P7?=
 =?us-ascii?Q?H6m5odxmlWkXLpIjrBg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?72gKkNUCQDwiEdFELJYHbfHuQfmspa5ya+KCCqja0NAL7ujybEpoueG6FGKv?=
 =?us-ascii?Q?0mSZ3+Nj6kY9D9cBNLhzjgszjfo6nUNm9B/EbKXRbq8O8qLChtoFkKcD4one?=
 =?us-ascii?Q?Ipbmwy2QkN/dy3GoZ3ayh8bm+Sqn404VCj6eNRQSYkbLMZhDcB/5UOJdXqlE?=
 =?us-ascii?Q?KN2eaPWrr/4E7azOauIwC5Fyr3/ammHvnmcXUonPEsN6EM7QigPlEtYzEdXY?=
 =?us-ascii?Q?gYdtFHswk4Qqh6eHbQH/3YmBi16OCVGDaQMbvZl82eokuSk3mieDM0phCmOW?=
 =?us-ascii?Q?iFNoDBa8FHp0x9jzbMBB7dxj28IGr0q0x7PV0ow+cqRqrILlkh681CgDuzAh?=
 =?us-ascii?Q?E/R5jEC1CcixJRKGzV3UsOmUcPh6saSWmOYIa4a5MPo3jO35f6i6oHJQ1q3E?=
 =?us-ascii?Q?UHEX4HZqLon93eYWXdJR89V/wuHz5OwTBhyYTroOGUSMVFHmrNX0jpzaW/hP?=
 =?us-ascii?Q?3wkz8qwiEVG1enGBgssFG+K5gvKVqEoFsHq7edcHwsk5GXC3/jHgAMC1DpOG?=
 =?us-ascii?Q?WtubPCGKOhG/UjCsOGSsYQv+PCsDU3r+8pURAa15EYODlcS+q+wT2vyMhxZc?=
 =?us-ascii?Q?tWyMBZZbWUXK8M06UnCM9SUinELJJ0OPKXbJ/oZ1xNJ50JwPr39QlVMspd+V?=
 =?us-ascii?Q?DurQlSBstDPayp+4a7QXryvsBNLdkwnG/iEtp3vm/G7rhmnuJf1YT6qQzfOO?=
 =?us-ascii?Q?SQH739kD6/q6KmtRgC2KAmFCBJIXe6gMbKiFtgbAFp0gvkSbntsyYGB7NaNp?=
 =?us-ascii?Q?irRiJggI+wJkG/CykryD9SIn/FXakOTigQ+yTwXhvAmg25pvBVIzsQbz4TGF?=
 =?us-ascii?Q?lC+2tqTwHZZbXn7fjaFG/qeZXp1oHf00ESQOE6ukcBq9OqBhDdyNCpuBNZMH?=
 =?us-ascii?Q?Q2ZHtgn1xeBymLpQoS+OyHhNNMlTVpkhocyPK3IrT6CnCllnM2gXiruwcOkg?=
 =?us-ascii?Q?FBP8QzZzQsiPoA/bWZgh8KCezU6YKRnK8yXu43Fjp3dN8mMiYXjxLrIrc+p3?=
 =?us-ascii?Q?wP5zPhuIKETE6D29mEqQRvDZmD418LAPsIMT3BNlouacPRuDtUwyj9+5oBqM?=
 =?us-ascii?Q?yQlSAr9xxr6+qF6dECr4IEyD1gpY+XZ71+YE+4ESDKqMHxVEHXdpZ5q4OpyN?=
 =?us-ascii?Q?WVyUMrlfrOA3ZEXAA8+TMYsceU97BFbqU4KchQyGsqqeylAtD/IF9FLzweM3?=
 =?us-ascii?Q?QkbWFNGc4Vh2k4I2WAOWwmNgtSxvwL0sDyTL/MFlRV5QOgNCmPalbHj2vOEX?=
 =?us-ascii?Q?dnC8XL88UrOxlUO5Jbnpl3wRf1Xh+sTKQRPH12kt4IxWCChvOPMWc4Z2mnPb?=
 =?us-ascii?Q?BRGBH0tA+1GM3tI5yg8SAP1jXJcdLzpotfWxhxpdXJ0gelIozsj7fR4dKUXP?=
 =?us-ascii?Q?SSHv154ZwMVcsRMWffp3mGf4xYVGNPHLT4WE0XDeI31IHoxz/HOtZ02NuwFX?=
 =?us-ascii?Q?mQqG8SNgiBPEtN5BLmFvKKMD9UTyHj2U2QGZNxFAKhzyB6/F7ED0uI9UzGHa?=
 =?us-ascii?Q?cfQWly8ck3nKPZkHSunkBPbA57Rsp11lYlffyUeu+1x6r4OFAc4xbnOvFDKV?=
 =?us-ascii?Q?XcFdm4sgAEyq1oVAILgiN8ei5az5B5XNsYD/g4t8fX+XVl3dkLvm2PZjzggl?=
 =?us-ascii?Q?NXMdnDar46isg1JBYhyZySIEtj3muoXNRl0mPvTlgw8rr55HfWciqnrheBZG?=
 =?us-ascii?Q?SGe8sWFSIGWCQiSn/ibae/Y7VPAgN/O4Gv/oBMFUp4CQFjzPcH4XtZATce5f?=
 =?us-ascii?Q?3WL+SUithg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pKMSGWU1SGtLOsLH8y0nmnbGs4C3OZCGztmJSMfbwiWTHqcYN7yz2kK4gse9qLIA1oUkazf5eCxp6wn/pvafLo8h7YWnpv/jZWRKztsnl/ZPbCyafcvbMzfW+fpNbCa0dGCC2H1QjZSbRK0JHhsfoNVghE3yAuDcA8bF8P9AliiHECqaSN7fxXns6yWYxf5fdNwCSNVhbGvFNHNtMeMs7FkfGZ9L4XC8Co0Ygz7ouPW1mMSZX44HVxVZZr4OoZeaUNVk5yeeM8kabvfWIZqR4XkbG9uBRjq6swy1DwQivohWQ+pXeXz41ZYWVpPIXqgsqbOoRGHAq8+iFMVuw1wRJaz+wX3Hl06ZmkT+bEa2qdp+RAA+rF7gsQLejzJBn6k6MGEDy9UGFXUP1c/QqtpnFWu8Rm1ObN09gMyRb43QqVM0eT1EY4cMfq86p87oI2XdQ8CDSIjNKoHPAmHQqnTli7EZP/hRG/G89Q26L+rTfxsJh/PZNoPLM4n+tYbUpoGhUp6ReJ1xCeSRoM4oHCfkOtW2b77cgcT7lP0WHRgt7fOaoAI2xjTwXJUkXju9beI8SV87+KfK1EFyVmm4KO4nhtXSdkA9VFJnmi8eH5u0jPw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e926548-11a7-4247-a8fc-08de590d3e60
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:50:54.9959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XZSU4y5Lc9U06CkzX0zTlbAE2rt/XHnGTpDuFbDoHlAeOQjnBf9su2ai9hcG5V3haMAZlJqhC65L66Ear4Vgpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4255
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210142
X-Authority-Analysis: v=2.4 cv=WbcBqkhX c=1 sm=1 tr=0 ts=697103f3 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=jQEhaW4UhibMOa9XUgMA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MiBTYWx0ZWRfX4WXRtadflHFL
 AyOdVlb875Ra5hwSm+8y8s1Im7Mdqg4YquCMrBsnry0pQPtenMbFF+5/kllHuMEx1CoNV9eUKyL
 1YiM6mIHM5rzL4JTqTd7lBXMs5k+fHnVuzigFgmPDCPPrZocOd0fRymWGS9SVc57D514O4O3kQ7
 EjZVDz5WhfndJ3dOqg7Z2jshg/jgiT0IPE7dl/AdQBQNhNo65GVWQDraCp3AZ7AP5qxke8BCAzm
 KwKkIjHBYCw0cVwnk+WK1P34rd7bWhtD0PRClwnGYRJ0l27MTrvfALpJ30mKsqh+/AcCivJt2/p
 VM3P5398tnfrmyMp9v91sA97GwTl4zquivsvN4+FsDjl0gC30d7aabUhw0g/4angbhdwhN0d5lk
 THe098MAqmBnkNUtZ4qQnbU4zW2CDG2X4BXTu+slKG5aQYHZCq8nVwYpuVi/va5Luc3bQ4d74R0
 6Z3sMdvMH8Ob/hRkNVg==
X-Proofpoint-ORIG-GUID: li-1dbrwQ7NkKOOhUQ-lo5aMfhNDguNK
X-Proofpoint-GUID: li-1dbrwQ7NkKOOhUQ-lo5aMfhNDguNK
X-Rspamd-Server: rspam12
X-Stat-Signature: wfn5d9woxp45iec1jigg9r9663fky8qh
X-Rspamd-Queue-Id: 35121140007
X-Rspam-User: 
X-HE-Tag: 1769014280-202992
X-HE-Meta: U2FsdGVkX1+U1BkPLaHtpx2fZHn4Ly18Wl6XYJKcdlxtbq1NW/xjmOmc8e3EL2kvhOmoaHVkOQH0I/L13fJWVzdfsm0bDqxUKrbMp3c+x6rJ9GHEyAliN54PxZhyu5usCFfZz4oL0Uz4+qJ/14lDUwtqjmuUQbDm7kOqRqc1r+W6QWjVSVx8c8w0YbgDXWCmU8HkBO2mWfT6Y1CKkedgdt6BEOFiSZ6I0pZ7k5CRTgtWFVMwmDJFtMoK7qTrbwMqKAUKlNzE22aLNwl9jmNvvWreuCTzPhQhcUHXq55IyD5oaiFs4V0xUwfHOsM5NsSLCDilFLfF0c3GG9kosKtKJ2wN4OBzURG3oqqWcb3QVs+yw5PVf0mH1m+QoZBh06arFWJfpQBp6vnlNZNWjtZR5sJ2KZ3G6xBKGNHV6EgWfo9ck5Y7DtSbNvUnUTbP5rF9V2trhG2d+Cag7vKIgHhBD9ay/nL5E2XfkPTTV3NRMJoiowKA5ymWC27KIHH++2eSNYVS15s8Sp6ZIFP+ESHk9q66PzFdf+Ebv7Ro3InOH4kaHOOcIFQe5BJizTdqXCncZkiNOQ4cusLqEyhQTrVffu4j4C5yMSdmEs6BAxYWmy/QfNwMytwHqFAAIJgFPTGbVNSrR72k8RI/bwXqXOBCbNdsNkGJUrWP5T9FQhllalXJAUYwy5DQdhfaY2NT8gga57yqHU2suafYJBZyoNIpqQKj66R1eKNIfnw1h8HLcp4Ku/eX01obvYOpzdMiKSou8vapR8ll6Fh0d2zkMD2zFx19QeoMnSHf82yr/HQRyFTcJ54uIyl1WWu5Y/Dqu/ntkbBEU+DfJtu0+bcY3XmFgz4gBDe97QR5pGx10P27rL4vg2OX+fuhkMow1/RgQu/VPFpt6QO85gNg0DOss519zx/JkunCJ3WY8+jaqmSldZV6M3GNtl1Ejf4rISSfWlwujTvTAjhiWG4PIAxAkcl
 haluGtip
 WkgFzuOikb7YAdZRE54eGmIyP0Pf21GFb/P0Zj3hQ1lXRmCaDsVjJuFnACASC7qViqQ7I/4rtxq0TdK6aMdrKH8DufhUCGaXrCkxK711X7kEuNZoXJzZ65WsKhVGI9UgJ4o9672yhgrTeeoxn5VyoppeIGoWvFgBK3QMaY5UHYVZEtnga2lPiWXtgP1gksOXb9QlU68+YcFMl1K+1DnFWOY3kry40zJlj3iC4N8uqDPj2qhsDWtK6QgBEVHuvmlOF8FyZyc5tA1YvubCrCmaOQveY1qY9cW8/bb8YuQG2IrhJwyckMtL30svNmJMsgd3lPXoiKVPdXKLgBhJq45gyJdOwqrj1dGqy4yUHLoeXBRU9jGP+QmJaNb4tYixFIzwZguPqbAlejtL7WgGaHaUZXsQkxQy1pYw4+CzLKPj6ZSeN0tRaWvYev/jZ3Bf6z2RCJuEWmej5GGHlIKfg9T4SgZmbjiNqqs9X10gk+76Q0/xUZ16THXFdk+VFOg9pKKBKvwP5okAyNn5Okp6bIt0qfaHbLjwX3VWjXSKX7lkAoPB/Jqhm9EdGjPD8Nf+Z/aSIgQ7EPpQ78unxUZaLRLNW9jmaQtAk2Qd/WjimfW14IZUVnwfmArNr6pA46CxRp+DZXxZox9MFXvTYch34pjcn8LI9BJpdGj/mgxoBuAgtLsMIUi/uJHn529tGsAEsg0meoxB+YwIorT3wZ0h9iBFzHtbG5XQda8w03oc+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The ceiling and tree search limit need to be different arguments for the
future change in the failed fork attempt.  The ceiling and floor
variables are not very descriptive, so change them to pg_start/pg_end.

Adding a new variable for the vma_end to the function as it will differ
from the pg_end in the later patches in the series.

Add a kernel doc about the free_pgtables() function.

Test code also updated.

No functional changes intended.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/internal.h                    |  6 +++--
 mm/memory.c                      | 42 +++++++++++++++++++++++++-------
 mm/mmap.c                        |  2 +-
 mm/vma.c                         |  3 ++-
 tools/testing/vma/vma_internal.h |  3 ++-
 5 files changed, 42 insertions(+), 14 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 5afe55751fe08..2cdc5c9396f10 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -510,8 +510,10 @@ void deactivate_file_folio(struct folio *folio);
 void folio_activate(struct folio *folio);
 
 void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
-		   struct vm_area_struct *start_vma, unsigned long floor,
-		   unsigned long ceiling, bool mm_wr_locked);
+		   struct vm_area_struct *vma, unsigned long pg_start,
+		   unsigned long pg_end, unsigned long vma_end,
+		   bool mm_wr_locked);
+
 void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
 
 struct zap_details;
diff --git a/mm/memory.c b/mm/memory.c
index 4b0790c8fa48e..9043cfda65b94 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -370,23 +370,47 @@ void free_pgd_range(struct mmu_gather *tlb,
 	} while (pgd++, addr = next, addr != end);
 }
 
+/**
+ * free_pgtables() - Free a range of page tables
+ * @tlb: The mmu gather
+ * @mas: The maple state
+ * @vma: The first vma
+ * @pg_start: The lowest page table address (floor)
+ * @pg_end: The highest page table address (ceiling)
+ * @vma_end: The highest vma tree search address
+ * @mm_wr_locked: boolean indicating if the mm is write locked
+ *
+ * Note: pg_start and pg_end are provided to indicate the absolute range of the
+ * page tables that should be removed.  This can differ from the vma mappings on
+ * some archs that may have mappings that need to be removed outside the vmas.
+ * Note that the prev->vm_end and next->vm_start are often used.
+ *
+ * The vma_end differs from the pg_end when a dup_mmap() failed and the tree has
+ * unrelated data to the mm_struct being torn down.
+ */
 void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
-		   struct vm_area_struct *vma, unsigned long floor,
-		   unsigned long ceiling, bool mm_wr_locked)
+		   struct vm_area_struct *vma, unsigned long pg_start,
+		   unsigned long pg_end, unsigned long vma_end,
+		   bool mm_wr_locked)
 {
 	struct unlink_vma_file_batch vb;
 
+	/*
+	 * Note: USER_PGTABLES_CEILING may be passed as the value of pg_end and
+	 * may be 0.  Underflow is expected in this case.  Otherwise the
+	 * pagetable end is exclusive.
+	 * vma_end is exclusive.
+	 * The last vma address should never be larger than the pagetable end.
+	 */
+	WARN_ON_ONCE(vma_end - 1 > pg_end - 1);
+
 	tlb_free_vmas(tlb);
 
 	do {
 		unsigned long addr = vma->vm_start;
 		struct vm_area_struct *next;
 
-		/*
-		 * Note: USER_PGTABLES_CEILING may be passed as ceiling and may
-		 * be 0.  This will underflow and is okay.
-		 */
-		next = mas_find(mas, ceiling - 1);
+		next = mas_find(mas, vma_end - 1);
 		if (unlikely(xa_is_zero(next)))
 			next = NULL;
 
@@ -406,7 +430,7 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
 		 */
 		while (next && next->vm_start <= vma->vm_end + PMD_SIZE) {
 			vma = next;
-			next = mas_find(mas, ceiling - 1);
+			next = mas_find(mas, vma_end - 1);
 			if (unlikely(xa_is_zero(next)))
 				next = NULL;
 			if (mm_wr_locked)
@@ -417,7 +441,7 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
 		unlink_file_vma_batch_final(&vb);
 
 		free_pgd_range(tlb, addr, vma->vm_end,
-			floor, next ? next->vm_start : ceiling);
+			pg_start, next ? next->vm_start : pg_end);
 		vma = next;
 	} while (vma);
 }
diff --git a/mm/mmap.c b/mm/mmap.c
index 9c8adc505d3de..827a64cdcc681 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1308,7 +1308,7 @@ void exit_mmap(struct mm_struct *mm)
 	mt_clear_in_rcu(&mm->mm_mt);
 	vma_iter_set(&vmi, vma->vm_end);
 	free_pgtables(&tlb, &vmi.mas, vma, FIRST_USER_ADDRESS,
-		      USER_PGTABLES_CEILING, true);
+		      USER_PGTABLES_CEILING, USER_PGTABLES_CEILING, true);
 	tlb_finish_mmu(&tlb);
 
 	/*
diff --git a/mm/vma.c b/mm/vma.c
index 0c35cdc0d3b7b..b2b9e7b3284f3 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -484,6 +484,7 @@ void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
 	unmap_vmas(&tlb, mas, vma, vma_start, vma_end, vma_end);
 	mas_set(mas, vma->vm_end);
 	free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
+		      next ? next->vm_start : USER_PGTABLES_CEILING,
 		      next ? next->vm_start : USER_PGTABLES_CEILING,
 		      /* mm_wr_locked = */ true);
 	tlb_finish_mmu(&tlb);
@@ -1275,7 +1276,7 @@ static inline void vms_clear_ptes(struct vma_munmap_struct *vms,
 	mas_set(mas_detach, 1);
 	/* start and end may be different if there is no prev or next vma. */
 	free_pgtables(&tlb, mas_detach, vms->vma, vms->unmap_start,
-		      vms->unmap_end, mm_wr_locked);
+		      vms->unmap_end, vms->unmap_end, mm_wr_locked);
 	tlb_finish_mmu(&tlb);
 	vms->clear_ptes = false;
 }
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index 7fa56dcc53a6b..f50b8ddee6120 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -1139,7 +1139,8 @@ static inline void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
 
 static inline void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
 		   struct vm_area_struct *vma, unsigned long floor,
-		   unsigned long ceiling, bool mm_wr_locked)
+		   unsigned long ceiling, unsigned long tree_max,
+		   bool mm_wr_locked)
 {
 }
 
-- 
2.47.3


