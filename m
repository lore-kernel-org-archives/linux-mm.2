Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3082D6555F
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 12:27:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 659EC6B0089; Wed, 17 Dec 2025 07:27:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 604936B008A; Wed, 17 Dec 2025 07:27:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DC576B008C; Wed, 17 Dec 2025 07:27:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 372696B0089
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:27:35 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E9F5260B4F
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 12:27:34 +0000 (UTC)
X-FDA: 84228888828.12.61CED7F
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 69462180002
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 12:27:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kzCw3zjg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=kW3Da5AW;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765974451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5mofdfm8PzE3XZU/Dd/QGkn14JUwlGIldrCDZKmAfLA=;
	b=4R8QSi+nKIFiJVX0n55WFjzc5xVe4eQ/dk3KWlOdfxTlpEdHT5isO572CpEibjEW1baF2W
	F+PhfV9OPFHuV0I+ACRG2XhoxIYxloQRD9HP7NjhlTq2iY24P7gp2zP8UNB8ngFzvj0tj1
	kjF4sfsPWOOFAaai5fQwaocC4stS18g=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kzCw3zjg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=kW3Da5AW;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765974451; a=rsa-sha256;
	cv=pass;
	b=L4LfjtLCSZwdAybksShDTDOSZ2YsGZUTbt8mxeN+FjqeYY/wsnweTGdbQ9YhcELQPW//zS
	4+rEZwLjZ8RMJaRcFw3bC/5WvDgdwROs2Q1kUh+H9rykZRwzRTetaN79iH9diinqmHHVda
	Xw46FqQmCknVomtSA8CZ1gpkbtBhvaI=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BH6O9ke2184117;
	Wed, 17 Dec 2025 12:27:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5mofdfm8PzE3XZU/Dd/QGkn14JUwlGIldrCDZKmAfLA=; b=
	kzCw3zjgkJvnlllnp8foE1v1/53g0j/XkE697UxMUbeiXjs5BGSFwlW9be7PAQpM
	FwrfntNELNpWR53myMPpqAoCpbTyftAM5Ya3HOsxBdv940FE1Wvxbvm9fmeWoAsY
	YRhruz14PYk8usI5r/P0CJP9lMaoyrJYmSCDnD4EGr6XfLzKnG77Es4q2JsMcQgt
	HkceTA1Zf7lfsyNwP572sU6jwKCMiUGDkMesMv+uJ9HTnnpcoAZfLY8/pAEHrS/C
	e+xCbDG79IgW3weI8naMwGHlstw5V11MpoPinhv5oAZ11qTdWlVFuGNCEHG+lCT7
	UBnhKQ7bsJRKbpSvdb7S2w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b1015wryc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 12:27:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BHBx2It006126;
	Wed, 17 Dec 2025 12:27:24 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012030.outbound.protection.outlook.com [52.101.48.30])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkegbs9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 12:27:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RQmpGZ5F+wIb0UZo2CCwVTsDutf+O6ZJ2haYpF1bmH6iQBtVXV0gFJQrhm/sBSXCjLZkkG9RaD/NtfmSsrC1jq2GjvXGJW8ybTRyPsBcl4/7o1nCG8hGQDNX066q20lLCZeKff52Bah+fCffUunEmpJDhJdLP693je+qCgZRkI7VnOviGik+aUoEdKBhzIX6FgMz1eOjDo5NV/x2CEzf0Ghjn1Rq6RlUGBTEcC2/ywn62rD4BDXQIdyl6xKKPIG5CosHY2gkMk1UFzDEB22oNachgaDQ61El/mKv3d30JeSir+FlmzRYazBTVsrpQJ/ex2qin2nJ5hqP0ckjuORQjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5mofdfm8PzE3XZU/Dd/QGkn14JUwlGIldrCDZKmAfLA=;
 b=yC0hwMKSfOgUUNJCXtvF3U0LNDQ9hAmhW8CPc/JgzN2tQT5e3UhfatpnjKdvz0H5brrU8qUUVT/vrmCFiCm6BhGi67L635ajd+UVRHKjTsGz4xmMJKCpJtddS9WJkQ7MQYHUmemaOKHuhDVANDPrtHVTMYi5gz/tDt23G+CtowMkJSeTR1b9c0A3OM6Z/573qEdbKZh9ozvDmb4haOb/BYjeHy0F3nw/SJv2SrqxKsUBMghbfC0jTU8T7qhhvTqb0sgrb3OOIeT0kiP8IxffiHHSm2gfYObE5J+5G2KI+EjG26VmTRfHvyZuuotkk0/C7+rR+xHeIn5A2gtLYvi0uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5mofdfm8PzE3XZU/Dd/QGkn14JUwlGIldrCDZKmAfLA=;
 b=kW3Da5AWOWLz+Wv74e6LbUOMtMrTg7vxtePrJzQ51iUf1/7Tavqw+TX1dmKFSEln3dbJpLVMth7G5Ebml1Fynmldu3MrzEBREEhNO5IIuANRXRP2/ZvzQPiMfZTcN463XCOpSsfWqj93wLjQ++3OU8MdIi76at1yWQpy1S4wNZA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM3PPF545856187.namprd10.prod.outlook.com (2603:10b6:f:fc00::c27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.7; Wed, 17 Dec
 2025 12:27:18 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 12:27:18 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] mm/rmap: improve anon_vma_clone(), unlink_anon_vmas() comments, add asserts
Date: Wed, 17 Dec 2025 12:27:03 +0000
Message-ID: <3acc90a8613d5e2ea8882d60b5677228e6fe624d.1765970117.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
References: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0200.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a5::7) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM3PPF545856187:EE_
X-MS-Office365-Filtering-Correlation-Id: 13fbba9d-9705-4fb9-5df9-08de3d679ea1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wr/HcpEDB36gEXD1BrRWmp0zRzzkCDYQFM76wHQ3eXtbx4RWamuEov2Kz0U4?=
 =?us-ascii?Q?lHi8lnifyaaz0q3XHVsYGh0LdwOoRC6j/+FEaMrcJQiASPd8xKo6RaUN9W+3?=
 =?us-ascii?Q?fjxzQ5nC4cgFoIwUrAlXPkHpHX4c+XbcoQQaXWAr6PeKGF6oNir1KPkk2xa9?=
 =?us-ascii?Q?CeXU0pgOBVnThOREiW3vFViI0oir2K1bm+ZDFR1vl7jIP9z4Yw9dtAvuEWXY?=
 =?us-ascii?Q?8FCG9txlxE25dw1nCpYJ+pRWewT8Lv8/AP9ONH61LNVGN/uBnd6knCFjNfxb?=
 =?us-ascii?Q?/kZXnhxiseQHyE3/2NhIMOGdnz8i7ltgawDfASNp5aa+/mMM0R4a9BvihnvU?=
 =?us-ascii?Q?og9g5EaPJUw3yqXb1wucNpYTN9DV77mw7wRjWLL7dEuuyO82ALZaUFyGTHKq?=
 =?us-ascii?Q?Pz6PvlZkbvw4WgnNHEbdbZcTDB7bBhejr6ibADflPiRIMEm6JSwEDmPRWAex?=
 =?us-ascii?Q?FwTbXLMT+5GNPfoIgPJfPMpCnGtcndq0+ygmovDeiziQnfAXnhgt4IkK63K2?=
 =?us-ascii?Q?YPyP9ViDHPNY9/SxS+T1Ef23W7HV0LAfeTHBbxAYd8ckIuqOWmzWZXf7viVz?=
 =?us-ascii?Q?bnvQn0Id+ReOcMMfDTXL778UHj06C2M/gulQPFC4iuqDrrxssDzIRaFfCCod?=
 =?us-ascii?Q?eanA3ifT+/iiSvCkNokwAGD+YKotdbR/VgrMTbohzAFh8Kw1Og6EZfkVDr6K?=
 =?us-ascii?Q?+NkcXw9uhOQBbrzh30PI7VQfqSEk/1gJlnVSTSYLmH7Sxq/E/J9thu/+mlzF?=
 =?us-ascii?Q?d8JzV5BRmCy11UIflLECkui8nRg3VyrQISDdfJlv22JskHV5KdI2/0jQl5Oh?=
 =?us-ascii?Q?Brevh/JzkZ3/F5t3u/+XNXHcVEG489E+deB/jKQ/I5Vzb28hlnIDTWx1JmG8?=
 =?us-ascii?Q?W41Of8EloubyAWY8eC1bDbOsXHM5E7eC2nzzFdf59GxJNlCMeI7Sj9bLIlDx?=
 =?us-ascii?Q?6vUpw+HSoHWNrlDARQbJylO4qf6XEKpUpZjAPNVjVUzcXwYMSP5lVh3BTamj?=
 =?us-ascii?Q?ZdgC2G20sCP1M5jA5iY+3fMUs1AJumdW33sCMAF41cG/bTR6FdbcgFvW+cK9?=
 =?us-ascii?Q?Mfqx/LJpDOVEavAddV4hElFxJTmdhjGZRkLrqiDMNRuibU/UGWQEvBA9tT56?=
 =?us-ascii?Q?8ns2RM7aQFvTcXPCMNfq8/pBQkqNmplZTBVnbSv+BAPMG1jvgzNamZ5+SPzi?=
 =?us-ascii?Q?A/UreiTWCz622pozESNRNqotT+g4VRSxK94x+y9YmxFVeGjvzcpM2ueD5faW?=
 =?us-ascii?Q?QZN3dnV1jEbmKJNxZImZQaaVfZgumyzvrbok0LZsSbHjU3AblhFijup7ECyA?=
 =?us-ascii?Q?SdVJUDzF7qObCkiXjEsOvVjKiP4qddKEGtIZ7h533BWHVrof8ui0rdbanU8/?=
 =?us-ascii?Q?DAUjpI34xYOjSnm+1XGGKDiLV2nKjLcG1Stl4NeJwNyuZaSje4LvLjoBiO/N?=
 =?us-ascii?Q?xrl0Ax5wEqLWr5nSvVD1Hf/MdXffuRex?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kl7AvviL/8+AHZ7kYFo9/oHRSleXu4wXMgMg930dBiLBJt4qnJd16zVzV+Lt?=
 =?us-ascii?Q?+47BjWpMOVleMR/RRQZElNxrcQQNPXQaGkJcmZ2HXAfq/so2mOuo3LE76RDS?=
 =?us-ascii?Q?xHmZZKxmNXEEWsfD/92WpHD7EbmwwS03oF/HAzOg5aVG+XsraT7yJ8tS32vn?=
 =?us-ascii?Q?alcHuj1ZkMe+9mxlmxOGv0tU2oOhQlAQPck5zaqjoAyBRoP33FPoCKpqpe8P?=
 =?us-ascii?Q?0p2UjF8ItJCJeLMjkljk+6Rfn8cXuXezXCTstHl6SWUDzwpJM3P3KKf8V9Af?=
 =?us-ascii?Q?Hmv5lEA2tFBzdk6k9ODdSUgQe0aYTeY48DH19yNYjLfo315OB5N47l3tZ7Y3?=
 =?us-ascii?Q?DCgrP7KySjdpKln2j0ytHSBzPwf57FM5SJrfqX/9wWLAoW5ieD9FYHzgTAC2?=
 =?us-ascii?Q?GPeFUS9aUVE5ulxnZkA0Lhp7qoSjVMk0QCeBakMVoUvkwcXJEHPjXeUjNRT2?=
 =?us-ascii?Q?WRBF4HrtunYEmIh8nvaR7GtNfCiTSBvWVxevL9Ky5Xp8F4NxbqNchMSpq66i?=
 =?us-ascii?Q?ueNvw5jPOWXCbW4cJMowIAUhpBN0oUjmC2qeXwZrqfAXDI3jNbI3ut4KjUPy?=
 =?us-ascii?Q?xbhd7Pk4J9nKyID73VL3TSONdKMjxNiHDtXekSnhSORDac1Xfh+7aKsKZl5O?=
 =?us-ascii?Q?koI9pSpyZFHVjxDkvHycJpF1unZRXgyhdyrJ9pzCIA5jtK/zBSevTXiHGwCv?=
 =?us-ascii?Q?4lSBOBbDnOUuHgTg2W5516YfeTgUfdOq7FAhcYlzhGCrPa6QXb1tLVOQvSJ5?=
 =?us-ascii?Q?yGU+ax7gMvvJ8qnM1++k5ruB9+sUflsXHU6yAKDyfucmQ78a/auOJ0gXBqmA?=
 =?us-ascii?Q?n+9CQ2B0u/xNljdVbXwuM23Qylcd8eXka/1AstPfr0SDQh7zf3jHRG4UbJym?=
 =?us-ascii?Q?a6cy5Lai0jKiPqpbDGSEEQGcKonQBgAmqNk5StW1lJf04xgne2s0xITRLvA5?=
 =?us-ascii?Q?KSImSu/hKiRaHGVl1L+cf/BdFMG4LilWm4GId3FU21szmiwbj0KD3WosXxaa?=
 =?us-ascii?Q?arxvfg2Z/rQgglGIs+B3YW+NwY+T7e8hr/kml1v7A6NDHY0IyUIps91Y6Nca?=
 =?us-ascii?Q?rxChXHmtyJZKKkITyg0bq53y2AYGyLsI5yYduHQ5fbZroCReK3iHQLVpWXth?=
 =?us-ascii?Q?8mPKeql1uETX0W0jF/yIy+bmX949U4HBWz7ULCZH87bT6KVQZxhHlEZ6hryk?=
 =?us-ascii?Q?CWSWNGG4s9ptRSSu6a5YznQ+mjodeYwaD+poFEec8gVmY5R4ZtVAZGv8/yVR?=
 =?us-ascii?Q?/PmvYfQm2l4b77vikI1MCGGLWjZaidE/LPtyFFiB5+mLDLzW7Nt7/ClA0cp2?=
 =?us-ascii?Q?+mFGh+uLYhpCodDj2lgnpuXcM7a9/MYVO1usn9AHdUbLE2NsPtNOLTyrxRJQ?=
 =?us-ascii?Q?nNSyCbBR7QGXrCtOZH/JuS0zx9GJRfUEPxLgh1MBwSAAJ2hzSDLmOpyu9cZK?=
 =?us-ascii?Q?IHrU9HMTMD2SLb2GKd58nY8pl2e9Rs5O/rS0HrLKbfKppBdXUOoXEM+oLHWf?=
 =?us-ascii?Q?jxq7kHDqiKFwLQ8WjcQG2S13U6wVsAtTorX7tofbolsWVKxX4YyYsKJT8yTB?=
 =?us-ascii?Q?8vjL0674CKs2WZ1XzhTP+0VX78dw9a5SDG5xigjs1Un+ZIlayT0UjliDsFp5?=
 =?us-ascii?Q?rA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YOdMYldxZkHhORgybByTGvhPeI5KluVOpK2s2QCi/r4LmJOLV4zyrHv2sygG6rc/4mUtED20WUg+KZZgFrrExNB+CpchoACphVE5l4PN++R7Kq0F+ZkoZMmAvzx6GDGZ/zRcfaMh2aFgS5DuHMt21TRcCkqpEErygbUJ5fQaO5eF+Zesg/AYcunSivPwoMb1wShhw8zqGmZDg6nGp1m/aptKkzDDR7eh1E70vXRFAhadyjUrm8Rtxv/GuSvAh6854qaUTw2MwJA+2ihRVx8K4X7w2L9PiTb0ElVzoOCy+ie9QOCUaL8ScsU7wyBS7Ly8PfBtPyxF2g4SxtQC/GVSPWK+Ii5pCv8fLRbG7reCmb0AVOr7TntPb46LQgpCbU1kwA6XIrua4tG3TWGpeVQxF14CwlxnUo4iogo3FUeBYS1J7zdfPqFw9wM71GceGyXhMbVERm8MYFRlnNe15mOQOTVtxZVPg3ibWhIfZ9o9ij+A/NHaLS2F09Eycv2GnJ9gXFJvi1T6hEIRL23YQWdRnFEkVyf64WyxuUHboXQajXC23b4ONppqOMS+9DINmMX/QzVKMZ6wK11nj3+6EhEe5DQmTYhnpBCN/A35xAmGG0g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13fbba9d-9705-4fb9-5df9-08de3d679ea1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 12:27:18.7592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZI5KmAIqZ2l+euCNoCiwhv9PZ8xXixcpvRXymb4cHb177Oml/SSscCYfjUwvcyaW7PTuhR9CHtiJsmlvug7A9ZUX2TtchsYJ0zKWsxMi2ag=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF545856187
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-17_01,2025-12-16_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512170096
X-Proofpoint-GUID: CUytYROgTfFhmPF9jX0RSYEAeuRfvkWp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE3MDA5NyBTYWx0ZWRfX+hKaTECYQAKL
 hxCc/3nxPSbHDUYPSkhj6dc9cO6PC8YEN9BY/7pnkGCm5hbzeb15B29x9ipJZlrF3LblebfNkXU
 oVQoV0E9UTMW2bOZpUs23wja3xJwqd0xN/ld3Ycz7rKfWuSm2S3kkWFVxDV+qYmX6jcc8IID62Y
 GZnuO6o/9LAOGELpZScQi4cU9ZDPEcBL17leNUn+nfcDRl7k6tjjk++Tb7m72KgsQY9WiMriMnu
 Z5fkO0qu6YdRD7edw8BBxuEap4JV+Mwt0OM3cCvdnOwVVs0GmdNMFJxjeBzwQVLC5YbDgaXE4YV
 Gx6hwr+qtdkw4q3Rsg52PNfEt7IM5ABoU49A0jZJAowuaf2HNm5wMFprFDHlTDE6VBUb/7u2FdF
 KFSijMejRa34wjanEPsq9vCMi00YYAzARLd4MXMS8FypjeXd7Ac=
X-Authority-Analysis: v=2.4 cv=GbUaXAXL c=1 sm=1 tr=0 ts=6942a1ad b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=5zoo0ztvSZEHwY7eWAEA:9 cc=ntf awl=host:12109
X-Proofpoint-ORIG-GUID: CUytYROgTfFhmPF9jX0RSYEAeuRfvkWp
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 69462180002
X-Stat-Signature: ccb7t5ayoz5jt5za11tg8sjkmrojwtub
X-Rspam-User: 
X-HE-Tag: 1765974451-26232
X-HE-Meta: U2FsdGVkX1/RcNdZ/M/ukWZoo1sMHFX9Dz+Jf3mWH0oECq9lg4ayu1Uvwe5g+HffsLkffzN+Qemz+aybVSb0uIS5tbEyhWjoKhFlLYLqPl59fffPR3nu+gPYYVWZZvJh680x98lhZwEoqZYybpHdekYhQzYRpiiEXriirauaE35/MjiVOziZ/3VhMhtBBDjMZNS2sz0BQWgUBKdIavFdZrW8WDztoQUuFN/KWFTHWneljtEKPWGzLZktdh+j2sHrLT0OLMZibgt+W7j4uEQKXrFGe6qFTzhhY1qz2shAhykLEvbsIU/mekd5v4bVrS1B7LB9t/Qh436kCIUsCtNtbDZp9Id/iZWu7Zx/JmIwxnQBFO9ArX35743+u8u8633yPySjMLBwx6Pw7O45HoYudQ/lOA/K0u7yOH/TRO6wLHHOS2GZ2Q/Z1dWcvuOZZtqYNBP1jUX3o90ag8uGk29cZsAMNSKtjc8EF/0eQN+VobpM+Zl7oVbKg8a2qT1APP+UkR4WjxgXzUVM9fEfxEiZlEGiKPbighQoMWo55iZIIfwo0ww02hzJL0fAOxg2qaO5fBiMVjjVBtF9+DnJeIt/tl4yDmMAlIAD3I6GGsjN3rQBMK+0EW3pvJBOEGAjm8LfakM8qTAtdnSi+jz79bLRtj91Kb0m0prFTpRcnQ3P8N+0nwqcHAlYcPg0kjI3Gk6UoYWPSzDBQhwtnhkYy2JV/NF3vvSPpw/hxbbjKrOSIl2rEqr0B412695FUNVG20U/FkadeIH+jUtCquoAr1kToHDVLlKJWQ0usSUIEXnSxIo53CAZP/8Lf052SFajpdDl4r5I8eyqjZmvA+2J5WCQXCDlgIORON3lU65RlpfmJJtkfGyktOuNVwFA11Rr3GEARpYK892OrR40PpfpFx2IZP2F2kEhzg93NOjHqZ6V08SSkKy2enYyOnRu2w+eQxzaz2tOQxrRzvqU0Vl/Suw
 j5LIOkZB
 BVnqRndNdhy9L5hx/r+zywjrxm3K5JgF69w00Uoy8vdM2wfQSTB85hUtnl7vmp1KEAIluDZn4HHRmvsKAURaTE4QrZzDTQCFq4Po13lJw2n00w9j3ofReBUqV8JId25k839hCneemHHhyehfYJkklF/Ix3leY19fJDEob/mlsqjA6DoaxnlucGgfVr4nVPyVGQTkQDbvJxKKv+hQrSwg+5YwVaAMcUfEUKzCWSLr3q31Ml/uiyBJYQ9KDWdLcsRBWBmMjgs6sj7ay/jcjSINwRZcR6SrRzoJ46oMgUzXgI7u2uA+cwXcjKT/SFIDffV7H94qNgtt7kWURnSw8ABP5Z6ASHrJ8R/0Rc4vn7yiMa0ZHoigyc9EU2skY0PzM4Y30eZwMnDaP1lOjzZBG8mviDVm6p++v03ghnd7emQSh2920oYXxxlqF3d4cIAwv0PNrpslIgasXx7jMHzj4fi5pA7WqRL6d4Dv2qP37GXyDhhHNCpwQjtcCl4c8vrayQrDsv9mLLSmJD8Hn+JHj4zQadOYfbTYbyzvNE0hBmkpfthHt9jMPh8US5AQlHBPheeSwUhTmaUuc4K7DTDq6Z2x/g+WN3hdNYmjUTpTorYyRuvuDkv92ItWfKrJ7yTnCZEKQpTKBC9W6plNxyqtqSrXCJ51WmUO7eiWlbnzT+JHwH8toaul2vj/oHn5oyA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add kdoc comments, describe exactly what these functinos are used for in
detail, pointing out importantly that the anon_vma_clone() !dst->anon_vma
&& src->anon_vma dance is ONLY for fork.

Both are confusing functions that will be refactored in a subsequent patch
but the first stage is establishing documentation and some invariatns.

Add some basic CONFIG_DEBUG_VM asserts that help document expected state,
specifically:

anon_vma_clone()
- mmap write lock held.
- We do nothing if src VMA is not faulted.
- The destination VMA has no anon_vma_chain yet.
- We are always operating on the same active VMA (i.e. vma->anon-vma).
- If not forking, must operate on the same mm_struct.

unlink_anon_vmas()
- mmap lock held (read on unmap downgraded).
- That unfaulted VMAs are no-ops.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 mm/rmap.c | 82 +++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 64 insertions(+), 18 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index d6799afe1114..0e34c0a69fbc 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -257,30 +257,60 @@ static inline void unlock_anon_vma_root(struct anon_vma *root)
 		up_write(&root->rwsem);
 }
 
-/*
- * Attach the anon_vmas from src to dst.
- * Returns 0 on success, -ENOMEM on failure.
- *
- * anon_vma_clone() is called by vma_expand(), vma_merge(), __split_vma(),
- * copy_vma() and anon_vma_fork(). The first four want an exact copy of src,
- * while the last one, anon_vma_fork(), may try to reuse an existing anon_vma to
- * prevent endless growth of anon_vma. Since dst->anon_vma is set to NULL before
- * call, we can identify this case by checking (!dst->anon_vma &&
- * src->anon_vma).
- *
- * If (!dst->anon_vma && src->anon_vma) is true, this function tries to find
- * and reuse existing anon_vma which has no vmas and only one child anon_vma.
- * This prevents degradation of anon_vma hierarchy to endless linear chain in
- * case of constantly forking task. On the other hand, an anon_vma with more
- * than one child isn't reused even if there was no alive vma, thus rmap
- * walker has a good chance of avoiding scanning the whole hierarchy when it
- * searches where page is mapped.
+static void check_anon_vma_clone(struct vm_area_struct *dst,
+				 struct vm_area_struct *src)
+{
+	/* The write lock must be held. */
+	mmap_assert_write_locked(src->vm_mm);
+	/* If not a fork (implied by dst->anon_vma) then must be on same mm. */
+	VM_WARN_ON_ONCE(dst->anon_vma && dst->vm_mm != src->vm_mm);
+
+	/* No source anon_vma is a no-op. */
+	VM_WARN_ON_ONCE(!src->anon_vma && !list_empty(&src->anon_vma_chain));
+	VM_WARN_ON_ONCE(!src->anon_vma && dst->anon_vma);
+	/* We are establishing a new anon_vma_chain. */
+	VM_WARN_ON_ONCE(!list_empty(&dst->anon_vma_chain));
+	/*
+	 * On fork, dst->anon_vma is set NULL (temporarily). Otherwise, anon_vma
+	 * must be the same across dst and src.
+	 */
+	VM_WARN_ON_ONCE(dst->anon_vma && dst->anon_vma != src->anon_vma);
+}
+
+/**
+ * anon_vma_clone - Establishes new anon_vma_chain objects in @dst linking to
+ * all of the anon_vma objects contained within @src anon_vma_chain's.
+ * @dst: The destination VMA with an empty anon_vma_chain.
+ * @src: The source VMA we wish to duplicate.
+ *
+ * This is the heart of the VMA side of the anon_vma implementation - we invoke
+ * this function whenever we need to set up a new VMA's anon_vma state.
+ *
+ * This is invoked for:
+ *
+ * - VMA Merge, but only when @dst is unfaulted and @src is faulted - meaning we
+ *   clone @src into @dst.
+ * - VMA split.
+ * - VMA (m)remap.
+ * - Fork of faulted VMA.
+ *
+ * In all cases other than fork this is simply a duplication. Fork additionally
+ * adds a new active anon_vma.
+ *
+ * ONLY in the case of fork do we try to 'reuse' existing anon_vma's in an
+ * anon_vma hierarchy, reusing anon_vma's which have no VMA associated with them
+ * but do have a single child. This is to avoid waste of memory when repeatedly
+ * forking.
+ *
+ * Returns: 0 on success, -ENOMEM on failure.
  */
 int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
 {
 	struct anon_vma_chain *avc, *pavc;
 	struct anon_vma *root = NULL;
 
+	check_anon_vma_clone(dst, src);
+
 	list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma;
 
@@ -392,11 +422,27 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 	return -ENOMEM;
 }
 
+/**
+ * unlink_anon_vmas() - remove all links between a VMA and anon_vma's, freeing
+ * anon_vma_chain objects.
+ * @vma: The VMA whose links to anon_vma objects is to be severed.
+ *
+ * As part of the process anon_vma_chain's are freed,
+ * anon_vma->num_children,num_active_vmas is updated as required and, if the
+ * relevant anon_vma references no further VMAs, its reference count is
+ * decremented.
+ */
 void unlink_anon_vmas(struct vm_area_struct *vma)
 {
 	struct anon_vma_chain *avc, *next;
 	struct anon_vma *root = NULL;
 
+	/* Always hold mmap lock, read-lock on unmap possibly. */
+	mmap_assert_locked(vma->vm_mm);
+
+	/* Unfaulted is a no-op. */
+	VM_WARN_ON_ONCE(!vma->anon_vma && !list_empty(&vma->anon_vma_chain));
+
 	/*
 	 * Unlink each anon_vma chained to the VMA.  This list is ordered
 	 * from newest to oldest, ensuring the root anon_vma gets freed last.
-- 
2.52.0


