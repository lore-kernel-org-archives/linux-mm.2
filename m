Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4CC5CCD1AB
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 11:31:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41AD98E007A; Fri, 24 Oct 2025 07:31:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CBA98E0042; Fri, 24 Oct 2025 07:31:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BA858E007A; Fri, 24 Oct 2025 07:31:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 173618E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 07:31:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DFBF688588
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:31:10 +0000 (UTC)
X-FDA: 84032791500.03.87F754F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id C64121C0007
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:31:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SGDh2wkE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tyChKqnk;
	spf=pass (imf20.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761305467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=RJ2y7nNzYYbitU5d3TTR2RsaOiaivwhdzr+WbyDIKIw=;
	b=BKLdKWc/7hhlASLOM/1ekZ7+1wQRN1sKrlA2DAdyFzU0DJwTkNiBs3dpfCzmNyncbG0Yoj
	xaapTDnqvB7q6WIy/6hDYWZ+ldrdF211BmY6okA8IRSymlxd2PBw/hAMX882990DAzhLDI
	Xiwoms//0gq6N+YPbygW86632G9iZXE=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SGDh2wkE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tyChKqnk;
	spf=pass (imf20.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761305467; a=rsa-sha256;
	cv=pass;
	b=T1hVtbWwnSS/ysf+6ELD71t7J3AMYWn4TZTxF30a3L/ZKADmA7SahDLlq+10nQ106psoqW
	rhI9W5/ap4aGZgixCEUi2JBcuQvezQsHqkmehEe7t817wI5/iOj+uN1a8vVInp5AfykwA8
	yp/ZMwlcF9WEx9oNm/qwW5g0DgxJNEo=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59O3NT9A021637;
	Fri, 24 Oct 2025 11:31:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=RJ2y7nNzYYbitU5d
	3TTR2RsaOiaivwhdzr+WbyDIKIw=; b=SGDh2wkE7oH1CpVuFnxKHAQj4Em0zcMe
	wS/kRlyNHS2eQVR4kJb2EJVAdc5n4IHktttbCFxHEA6ZEB/NsaMLgnmbmP+6DcCU
	pcyqrNmQvGh75xdBeH2H34rG057/4PeAaDDom2LZK0koTYAoNWkdA7EmYtg+wlDX
	3q2DvYYXmjJIX2c0A3r+tOT6TJzq0De98rY9lkcUhqXN6/PWaAD/ZakdpSrisIm3
	nGKytud9xEyaILnwxo/OL7dMCJcL0FRXegG1KAaC1YU0C4tr2kKfMkCLVFvKxHhs
	V8OtMJ86Du8b/k4vDlrbvRA0KXPRmHANcAw9/S/PTpMrSKpmsIbTZw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49xv3k4h42-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 11:31:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59O9To4X007623;
	Fri, 24 Oct 2025 11:31:00 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011049.outbound.protection.outlook.com [40.107.208.49])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bg184j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 11:31:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dBrq7BFVpVhP4dvTV0pSoH0lBcl9eaW5TV3gpbLwlQqehG+j8Rh1QoYtM4YkHyoOkf5chkpFLts1hcJDlBIYoSFPsrxK6hUUr6m+rgpq2F13eUqp76fN4kUxMIv1zffb09Tx7STlbwvdp006ApO/Ks7Fkj7pjs9RaqLvxu6xcStS/cdOBqABMuHt4bUmiAZ//ZPJKqIl0p1cP25nwlAjx9hbaEfSx+7raJ4ic6LfQo7TjCZKijY3JHWpQIrfo7o9N3E6nKz0mYk2VDQVJMa9XoDKvh4BVybOTa+5DKg3awGwrMuQvYoJAWaV/JXjqXrY7DQ+g7HT3ETbKviMpT/rdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RJ2y7nNzYYbitU5d3TTR2RsaOiaivwhdzr+WbyDIKIw=;
 b=IcXn5L4dpNO5SvM3DY/5Gbjxdd4ULK7t8rKg4u23KjYIhhE3HsysML677JZtiUB13E8677pgR4iNI0GLu9RoXzGhzOW/dXkhr8tuWWgrU33Xinh2JM5XDUSzLEmI0BWLxSQFn4s5W3+miM3iFNEyrPUgLUXh5VN+L5wVLqQ0W9SIZFvsCsM3ZAffD4qTsd4w8hKt531ebOTWxRE4ErGt3CjU1OxrP5xfXUY3qVa1bNsb2svtMyz4UJye8WgNV5O4V5B2FmoeVMD9pRslA/f1tlAgOoJuV1k786sB1uIqirZkAljZ2+KKRfHv+/jbFyDFucEZ9IynVHNeb8Plw4SNjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RJ2y7nNzYYbitU5d3TTR2RsaOiaivwhdzr+WbyDIKIw=;
 b=tyChKqnkJztOdmfxgNQolB5Zf1fASRmpgi2HYnVKwjs+httBzA2mf5j/zLMlt30ldsQitCk9zRZYkCD/iMmMc1uEjR6UUY86IyNITyX+vR++vvNVfuKTD+g4DBD3Q7163Ml8Z35kA347aDvcDv0qc5kNlQyRHu2VqweKH0ylx+4=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SJ5PPF972B28679.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7ba) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 11:30:58 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 11:30:58 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, Harry Yoo <harry.yoo@oracle.com>
Subject: [PATCH V2 0/2] mm: MISC follow-up patches for linux/pgalloc.h
Date: Fri, 24 Oct 2025 20:30:45 +0900
Message-ID: <20251024113047.119058-1-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SE2P216CA0153.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c1::9) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SJ5PPF972B28679:EE_
X-MS-Office365-Filtering-Correlation-Id: 42589107-5f4f-4ffa-cbd3-08de12f0cd3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xT+7tU+zmWjZZg+Xv5pBEx7TrWKOVII9XgzTngkLzTN0DL8izr8XsnVv9x0t?=
 =?us-ascii?Q?tEJLCcBBQB398xpHNNf428z33CSqNXcag0ePOWYMZtnf3OhTB6LYDZbrZm8L?=
 =?us-ascii?Q?FmNsmOeSqQclJlXKCfs5NZS+3spADwVD2rI1SjFA58R390dfMuxSMnlppX+z?=
 =?us-ascii?Q?3gHFu+7yqrH1wwIB0To1NTk0wbruolgLOSqZR44Gzr+/aFdeQyGiGe6Pnpc1?=
 =?us-ascii?Q?Y39dn9RdgcXMrJ5yk4hhwMSfWK71mzn/ownuZF42MI1o4VAAtAuTyWEKGZAZ?=
 =?us-ascii?Q?lmIrNAkx5weTQqo2ti0UxMVjBZ025zZolZ7TohQucml40DZMXySdgvHXb8hQ?=
 =?us-ascii?Q?Hk5QpAcFFeqAttNPa5OrrFmKhswr48J1tgRLcQ6m1NcgxZa5AmxWT9RMGGbz?=
 =?us-ascii?Q?aoF25B4DHPILW6Mj2Hng8ZKxfQds3KAA5dLlhDoJiaY7zZg75RpmdjX3fjtF?=
 =?us-ascii?Q?gspezrLNfIwP5+54BjLvbJwdSruW1+stNWoETWEKOhMuy/OljJJBtSKksfEQ?=
 =?us-ascii?Q?u5eT4pcWcDgFVhV5xhXdNccTNzyq22wNWL6HwwKSBHqa7ep7mx8deD0/imgu?=
 =?us-ascii?Q?NA9+G1bGU06rkC807sKzHBYnfJQ2VEGilS+BnW9fy5lGQ6hfSkvEto+GgOYU?=
 =?us-ascii?Q?yybGl7c2rgiopUASD8uFFHD6bspo6JqcLQrICYiDOztJBX8twLNOGDLkJyUO?=
 =?us-ascii?Q?6h8RER4YO/igXIvC0ZXLg3WdMM22zhKvP8j59Wxo2UjxWlYk7Tzd1mTzYJFa?=
 =?us-ascii?Q?5Uwg3NbkdN27CnKswuYfR4NbvIb4CS14ZnbEeEDPFcV254eDzOZYzRs2eC8k?=
 =?us-ascii?Q?KmJPNLLHMr7lTyS2UMWH3j5yTgD6XXXo2/dCaQ/tq2zIKwWRG1hPS+qVQQ3o?=
 =?us-ascii?Q?c7eMqIIOEZ3mOrutmhSBf+z3n3yvg3GtiLzDNUSgBlj2J2Yr8oQzLIWBBOKp?=
 =?us-ascii?Q?BIu1OItRluPqKc15Ct8E9HKTvc62BEittcXFgutrX4NM9Z+O6y2UY4E2Xi59?=
 =?us-ascii?Q?0zr7ftWx4j/GDu2o8TRghSXVVBB6jXO1GHXbOjUvYoW5wJukIJSuN/+BWg+g?=
 =?us-ascii?Q?vuP/EjtggjwawzQ5mcwP+0C25BzzrfHalRGdPQPQgyCq3wipAeV+AbQDnNPk?=
 =?us-ascii?Q?MVo3pj16HM2KxEovv6H6qQOR1fTvzIoIHNb1TrSt2ZM3XdQ8wz2kJh5siliv?=
 =?us-ascii?Q?1ZfFtb5sTOpgCZ4eub8kHdjqw8vEgs0C8XZ/A2ggW57yPy9205JPFbjVDoIa?=
 =?us-ascii?Q?gLTtzjJv6uE6udGuEhfKSZwrR1q7+rlLdP3iVolwcTACn7vSQ27SB/bfF3Hj?=
 =?us-ascii?Q?pXcMGSkeY4YUgEcAubxm0C7FqeauX/3unbHALA0l/PS7YAkzOCp38YLLcIZw?=
 =?us-ascii?Q?vRkdAl+RgjTMcide2wn6pI92lWpkBm86QC/07ONww8me0iPB18k1/OJmkR0b?=
 =?us-ascii?Q?t+Yv1keCuK7i7q7q9rh7qQkNb2DtB1z5?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jnkFV332GXQrGtYQlfZlJ7LJGG4lyOmlR37k4U8X+MPKTEulieSemA+tMRT+?=
 =?us-ascii?Q?rBBnGgiJhOYFiAk/RGE0EHbhAIvaYdlJRlGRsByz3sNF4uCHYHTijVQzz1Ob?=
 =?us-ascii?Q?y93Q9yVNeQ+abe42rAXdr7bjXErHQMPVEAMlb1bW/GvG8jL0L/r8R0cPgdT9?=
 =?us-ascii?Q?ir6EnaUoug32xopXvfORpO44sr/3ijXmCasSvkphj90xSypC72XusPwQ4/GB?=
 =?us-ascii?Q?hXMUlnuI7qQv8H4dZFR8ECY6mUtgNRg1hpLtJkMG/ob/b58qDvWYpoiJh4an?=
 =?us-ascii?Q?lEGM44CUGY1UZ0RPLpjL51EGQrKBzDxv5M8Db3mMWZ4sb6muCM73PLIQF0+0?=
 =?us-ascii?Q?TOmLM5stZoE1JkSeYnzQSvRkjUeO/9kTzFJ7NyEQYhNGAS3kLRfav9PVucaY?=
 =?us-ascii?Q?ucgyOF5lW5GoZrUcmnCTSMCj09tri1SXte4/2vaRASLks89J+WKqQUSI0X0n?=
 =?us-ascii?Q?a7byD6hCcW7doNQwdBTkM6x7Otb9ALM0XewiZhtybCQoEKNwb7RPZPdiqvPp?=
 =?us-ascii?Q?zQ54Z2lzExt4MlQrPBnbCw7YqrHhf61AcU2Cvz5vayTYFKmELHR6kQCGdxXF?=
 =?us-ascii?Q?HgPIZ1tOiYuhAg1LnmDKZXFQzxCBHir4DDxLaG+0P9kh0xMW+YD490Gls4YV?=
 =?us-ascii?Q?enXi46n7LnabDYjHhWus9H/QP0ABV4sLNU5lQXMU/FQj66++6V01OYD28Zp+?=
 =?us-ascii?Q?hASCZKdGP2jQ5Nb+jnX4l4ug2Pub6F1szAMRtzkUYxUJu2ZPi5nW2lrz0JbW?=
 =?us-ascii?Q?PTWtesh1FhfWgk1OzvoZ644DGaGj0zhv7AAFWyvNzKbtMJXO+JmhKgh81hMs?=
 =?us-ascii?Q?F6ExCHjzteUjNncvFjPze1rLVcweGyzsRylv/f5+HQoo9PQeVnRm92h8+eiS?=
 =?us-ascii?Q?7izfjaBUAWk/ZkBHER4r0dpDBkQ8SbjsCVrYHW8qw9IPwWcX5Iluv35IIoeq?=
 =?us-ascii?Q?NrLHQIZOXYVYE3Y5nWod6yTJB1YaQBbDCjzCX9gy3X6PgStHOU0SEqPHuPOJ?=
 =?us-ascii?Q?Qs5zxF322Sdkz31oOYl8DimWlmHjCoXUHeRh5HFz5OrE/Ld64H/25YzDeeld?=
 =?us-ascii?Q?tTsS+3hKTyrEjaNKiIFyEhCEUCmcgzqYlO5verlZgOlMbyR8hXtpxIdmP8Hm?=
 =?us-ascii?Q?Kqy91Nww1YqteCLToMzIr+Ilz2OR9dukRHYGLyUEpnbrKnQ/LteeMespxACf?=
 =?us-ascii?Q?GpXrdaWcavQ2h7PRJXG5KT52+GQCwLa3UHvtAiC0YnkPqX3gkjRaL+WBaSV/?=
 =?us-ascii?Q?olrRIzJjo/x/vm306lFogzoiMYRKINm9x4XmPvhu7vE/0j+BpdTft6DtwdV0?=
 =?us-ascii?Q?Oir5uMx7tRkbHust1XxhEam+I+6WUVPbzaVVzKj8711Mob5obtV71ttrdUbk?=
 =?us-ascii?Q?heY27Rng2LE8NOYY/PCWEsgYEW2BhXxIB6keC2VJVwddRS4HzMGz1pR4O05z?=
 =?us-ascii?Q?p8cKFXa5Jp1L1hsh9fbFpa5VCp8wqXrGis2+M2vYlsmQyBqR6+Vb6lQXxr4N?=
 =?us-ascii?Q?DWi4cAn3p9q53tf2IZlYwHJrowCaX19ZMX6fA684eaoWBZ52GWs5HAKG+EMP?=
 =?us-ascii?Q?+L8SLqAzZ/CtK8VVL9EhcH/8EdDFRPFOY6cef7Lh?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Wl3KSABV3wetWzAJlj2XEO7ii34LnzpEsjt1KVeIbKw7ghuIg3WrF12DBFl/RCpYPLQNj+3+TsFmrLn3T3yjU+jx9SOLPL070PnCR9HtY3Gw9tqcEMsSuVPUycuvzkAwnryBGEowZwjVKHZPGTEbYA54gzrVRWfS6fuNTtuMce1ug2gjCv0y4K1ecNV4NHfIKrxcWs+Mm6E/vPSd59cP9gfCtNMI19nx8U/nDLRQXYNsuahktCE3SWFHtBRnOkfZU3yDFWRHnP5HntcWbMZFbVuoFIRAXIEqnWG/+/cB1O51Q0IFQjFH9Sg/jiQRFJfpERvY4EGOkUM4J4vITAwL3SSPBp7t0b4e9yIz1/z7gQ1q0EKrgO0yH5dzfTxe+oqOXwjGozKINaEldCck5CItjqPkryBTH50/FNhIeJR5bGaA0+4kbcw3Jx/4/GOxe1Sg4HGwoatpc6vHH3Ue0w5BgPdv3gR7m5qx48xgjWFUF2z8NvXG2QhCZr7+nyOqfPgeymns0bSAU3YvCMvkPQQnYWWaPdoGPiMrMzq70bsdRa84RdYYTvBwu4a3Vv9WwFIRYHEVtGJ0dDn4y6vMG1X772FR7+jt6EQ4aVg78DwrWu0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42589107-5f4f-4ffa-cbd3-08de12f0cd3b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 11:30:58.1211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m4wJ2H0DH5d0MgCkTgLPephGJ0wkj1JoMS6NkuMiRU/MYyBN8+SYRexoPhzntPr6pMXQAs6P5pOWXD9PJbirRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF972B28679
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-24_01,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510240102
X-Proofpoint-GUID: zLcV5JmXHC9UAnDLp6W6mthqUD8uP6oh
X-Authority-Analysis: v=2.4 cv=bLgb4f+Z c=1 sm=1 tr=0 ts=68fb6376 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=lo2N1JL99uwnjFVDFfgA:9
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDA3MSBTYWx0ZWRfX1oDuYXgdLOQ7
 +mzAH5YxZO/AwvYgl5bT9Aj4NNcnhCqp7MEbzOZhIbpzORoODowx28Gi0IQO5RA5nC7j7opRKFm
 gUshEYecycOpHVh8MhwLsrwLxSYMwN4C1eJzMZfxV8ui7QEeDjVO1tabatbT0SGW1DFqRU6+wtR
 vu3fVoe6sBrTJBXVHIq+iwnPLbyhLTE+lgkJdTLOJkFOSaOIXGKD6Q9yITTaC9V2Bd6KkCUkxez
 d1bnYeVMbjUZ3h25oj8zoI2nBZwlgxrREKeC1MeG3pDFxLkoXXfeqeuCPwQzhtHJIppCcStCTdl
 ikX2oSofWuKUma7lZ4tnwmtEM+K/CySt2Zisf7MqMBu4fIC/MdIl4Z47/knqdoppZG6RSIMYKA7
 Gdx/AMnDA2QSrORMmclsKKssBg8+DA==
X-Proofpoint-ORIG-GUID: zLcV5JmXHC9UAnDLp6W6mthqUD8uP6oh
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C64121C0007
X-Stat-Signature: w4u8xyjayiqhscn6e1uw739a66bag1o8
X-Rspam-User: 
X-HE-Tag: 1761305467-899267
X-HE-Meta: U2FsdGVkX1+NB+ajPN0SDePtvlFOQwr2fFq6JZWFNiNk3mA9PXnLaxzic4twyYIpjPTeuFA4Hpk6rpTOU/RbUxQ6KbmZiq/uxLqQ0mntGph0zk8UbIgTBY6gMNyB1sN8KKzG21HKtz5QuvrSX3FVc6Av5TfEVlZb2yeLGw27s80+Vm6xGDeUGceHVUK14Klm7cEy+AS2uIxIq+qCWZ3C1v8scpgZj1bH2lbk/xiGyTE520kvxV14oVg6aSfc0apri6M4GyozEksfo1tGg+6NivnIzOFNwtGOtZIUTYLaKz1vBRBQUhh//Iu0H8F6MfZ0XgolW7fp8m7t3+1zoSnPLYuBdh2LSzmD8yTHszFvDcLdl8HSEWaG6JwSgr5Rz3sUFA/nUD4nEvXAuycLtXNWyVJh7CvbQfDOrIVfBNqxtshYcKHYXLcHNCgdoK9uUe/8DeH4WKgYfI3ineVjXbw16PRw12xscPpQ8sIqc9RgHTvGMQ5A2q3D9iyVhFXBEZkXQ6KLxHrhXz9sFKaKPsDsbZsQVMPOt9U99LtByZbX25h8/hy9tjIqfONnPaC1c3hYcP2sPkyJXn9Ynid9Y1Sv/lCI3t6CG6SFeQnT3IJUV3fgoaVhEV2x7hW9LP+5DoQBaMxIz5RICSzB5puvbFOQSXs2vW6n7fzrJbgRoAUUBgFLnfAXupewFh5vgT6apI4Aiu6RUpNAtXmtzwnedecmG02pztOF0bev/hWGqcsu/0lXdyIKDi8baNF73Iho7O/ub2L84NfHebUTyf8b5DZ+GWYWd5PYz9tSrLmsHFys/JWSPU8qRpsZqrmmpcUyk8FBhP7LUGcJ+2T1zAs5Ygz6PMxxyPEzgiZ2QZLT5oaVz/fEg0heLfpF4z7Su7Otih6m0bin2IkjEFfyux+IEnv779+O2fyNGm3mXxqQMV9ChmRkCL8KqI9oXtt8D1fuEOmf3T4RkMGk0EmCjLOOX/z
 TuLvbFZp
 9MuAvdD4rBKkipnt1Ej+W0UAL5onmcXEwKXqmkOvhI2Qg5aCT1Q1RP8/A+3JxfshvlMDcfhFk/Da9BGiaiIgv7Ggj+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

v1 -> v2:
 - Added Acked-by, Reviewed-by tags. Thanks!
 - patch 1: alphabetically sorted F: list (SJ, David, Lorenzo)
 - patch 2: Made the header inclusion look better (Mike), more specifically:
   - alphabetically sort headers when they are already sorted.
   - add a new line to separate <linux/*.h> and <asm*/*.h>.
     - Also applied this in a few files taht Mike didn't explicitly mention,
       for consistency.

Hi folks.

This is a follow-up patch series for the patch series named:
"[PATCH V5 mm-hotfixes 0/3] mm, x86: fix crash due to missing page table
sync and make it harder to miss".

This is a follow-up for MM. For x86/mm specific cleanup patches,
another follow-up series is planned.

Patch 1 creates a F: entry to MAINTAINERS file in MM CORE section.
Patch 2 converts common code to include <linux/pgalloc.h> instead of
<asm/pgalloc.h>

Harry Yoo (2):
  MAINTAINERS: add include/linux/pgalloc.h to MM CORE section
  treewide: include linux/pgalloc.h instead of asm/pgalloc.h

 MAINTAINERS                          | 1 +
 drivers/firmware/efi/arm-runtime.c   | 4 ++--
 drivers/firmware/efi/riscv-runtime.c | 4 ++--
 drivers/s390/char/sclp_sd.c          | 3 +--
 fs/dax.c                             | 2 +-
 kernel/fork.c                        | 4 ++--
 mm/debug_vm_pgtable.c                | 2 +-
 mm/filemap.c                         | 3 ++-
 mm/huge_memory.c                     | 2 +-
 mm/hugetlb.c                         | 2 +-
 mm/hugetlb_vmemmap.c                 | 3 ++-
 mm/khugepaged.c                      | 2 +-
 mm/memory.c                          | 4 ++--
 mm/mmu_gather.c                      | 2 +-
 mm/mremap.c                          | 2 +-
 mm/pgtable-generic.c                 | 3 ++-
 mm/pt_reclaim.c                      | 3 ++-
 17 files changed, 25 insertions(+), 21 deletions(-)

-- 
2.43.0


