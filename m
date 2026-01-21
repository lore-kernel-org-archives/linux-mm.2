Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A3BDD46956
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:51:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEB656B00B8; Wed, 21 Jan 2026 11:51:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA9B96B00BA; Wed, 21 Jan 2026 11:51:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD7966B00BB; Wed, 21 Jan 2026 11:51:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 990ED6B00B8
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:51:27 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 51F4EBA6B2
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:51:27 +0000 (UTC)
X-FDA: 84356561814.03.2561E4A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id CE14B40015
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:51:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PXCABfHf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rDJAL6lj;
	spf=pass (imf01.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gy/gNtftho/pBCoUcELF9QaGj7k4/VSmefuiZMFqGo8=;
	b=tCmtgZLr2MFiaQpnaHEI8TOHpja8RBlB9SwkYzrb64R1O2jPnow8b9EirKH/uG0mk2ej5J
	773IvFb1EeDbjsi3WVrqHJT5svp9UxwQhbx2XtHR5hKDA5TBMT8eqTZ8mZ+2a8lcJk4l2f
	7p/ZZ6dbEbBkvmf9FM+0mKwpWhhlJtE=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PXCABfHf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rDJAL6lj;
	spf=pass (imf01.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014284; a=rsa-sha256;
	cv=pass;
	b=5fSghQJRQZbIGVFeXJubVUOWdEOrBu66lr8cFiYu0zt13lLDlbU3HGbO8Iuzd/lXYkMYVH
	dAsGaHGSTe1qE0Fx3B27atxcFHHXho6t+EkuSsS1QscvjrQi6SyeKzsg6ER1A7n4HeQ0ro
	UHkW92SvJ2RaGvTemhteeu12vNkJOEo=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LC2gkM3264873;
	Wed, 21 Jan 2026 16:51:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=gy/gNtftho/pBCoUcELF9QaGj7k4/VSmefuiZMFqGo8=; b=
	PXCABfHfTBw5gRjr+DbDbiz4VU32UJGUHbb3DqCcYsRJtBV22Kclr/B8axCOUusE
	JkIOJfYEJDf8C1bk05Rb4TK0O63E4eMOLO7dffRG5qE4kX9UJ0OJHNZCat1dO/U7
	z6zmUM3aMmCx00Py5TOKvEHff1lbprSqdNpsHx24fUyQMn832PQaLuHRs7RHv4QZ
	YxNf46JeYebPnx0DoOEsRIU+nTMDwcolQXbYj3Guj/jKQNY6w2/WZEKX8BzQoHft
	XyR3YDI/5GliFBT2zfW161/rSzdikybZtHJybCqwwCb0habAfzpqKlZAGhjZ67XR
	uB+H3Ixl8lm7A6T1QhiHwA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br1b8e8js-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:51:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LFWCav022457;
	Wed, 21 Jan 2026 16:51:06 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010033.outbound.protection.outlook.com [52.101.56.33])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vf9rm0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:51:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k+EZNjadsw6waR/2Ok5X9nCoKEbVPcLBpW2riFlQ3HEa/iWW5D/aUw7Q6ZJ5YXxJYMcezlPSh7b8kICg1kq3bstDqFVIHvFmcwxVjHSrBS4252hXwfdk+5S0YgzJP+8XLf3WsYoblZal11E/UhnXl8bmMPgv6NMkczW3T0dD/4qfUsLno6FTdrPKvWyaWNUrBXiv8E585866v5vsPJbM2YnqM96zp1WF/7/yEfhJeDxdsBHSNrVnRh2AICDRyj8iiaqdXF9g9Gl5JBIhs3F7UBzKTxEKPURqNxysjoIkQo4gbWj56JGMMfIdbdSSTQ4jAz12xubIRkP7HZH/k1fb9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gy/gNtftho/pBCoUcELF9QaGj7k4/VSmefuiZMFqGo8=;
 b=JsFgjTCN53VqFK7a1iBGVKuepWIIJPogrymnjZkyix/h44PlGFNHiWcNZhKu8Iid5pdrTSmqoHSO3jFTh81YndVg9g7MKqQB8s3gxbXK+B+DkPzqQwot6r1iVEXM5pwPSyjBKKK2J/szhow5PaA6i6MH7KkG0CX3Jtfttk7oq7Dm0pMyjN2PtIk9fpM04MdWRNtMPGD2mXhIhz8s2qkDVPkOhTmFDfY3EteNjVWAdvG+lV+QzfzGaSW7rNjtOB4OUCk3zTmapbeP7BfMN00J/5clDbKHt06tDyHlh9rUzgowXWOOe8HhPFyr2Js+1qnVM/36HVA43dlBc/q7aqwrhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gy/gNtftho/pBCoUcELF9QaGj7k4/VSmefuiZMFqGo8=;
 b=rDJAL6ljjs0T0f9GxgwlGU68Mh8hl3/9oW47dXYLZutIoFDr0Eu4jc0sfB+hUORn5P+7WhG4gjnrOGFcrNUEE7OUAdDfzgZWBH43KRc3JMGMTO32zHB9PMjw0WUsFJFbMfu1IE78pPef/0m2jyqFFvY0GZOv6D4fq2JfaCfCu6s=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SJ0PR10MB4414.namprd10.prod.outlook.com (2603:10b6:a03:2d0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Wed, 21 Jan
 2026 16:51:04 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:51:04 +0000
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
Subject: [PATCH v3 09/11] mm/vma: Use unmap_desc in exit_mmap() and vms_clear_ptes()
Date: Wed, 21 Jan 2026 11:49:44 -0500
Message-ID: <20260121164946.2093480-10-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164946.2093480-1-Liam.Howlett@oracle.com>
References: <20260121164946.2093480-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0017.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d1::28) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SJ0PR10MB4414:EE_
X-MS-Office365-Filtering-Correlation-Id: 1edfd1c6-623d-4184-bc48-08de590d43ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?13on8nCfs7up9MEX4UOx8rBZ6kQRCSe8pNNcygaLlPvw8DashoetafpgzcWj?=
 =?us-ascii?Q?vJe9iIkIHEXzxfTQvx+v9/Ykw6EKOrjTIhbCF7cYmPAk0M5CN3Rmy/3WNe6x?=
 =?us-ascii?Q?Ack7qdq2ZwUb4hhuePOq5ORJ+RcVheebvOfjFHVsaHULg6ZIdhBW0ws9648w?=
 =?us-ascii?Q?ylhJOzEm8K1OcsF+iU0fvUGrazgE8pOKDAkEhpDDXS9eXZ+u5tNaDs+b7Aqb?=
 =?us-ascii?Q?w37Ffos5LCVZ43KsvwnZs0xiFUlijfY1NRc743mmQrrPzcnG5L0JOYfNizlt?=
 =?us-ascii?Q?GyaibbaBUS9buEb1esoWbJiO/dnNaB3LhalIACS/ofPV8yRxPlRDMU9bEGQo?=
 =?us-ascii?Q?cNRieRaxqjZtLXmwRQ9WXfDUFiGzVKJU8H/BdCEkeWLesTBP8ZkubAYlmMHi?=
 =?us-ascii?Q?4TgJRhReEj4ePX81/Go3nENbEzveKxFOsc7Ex2VYQ3/YTand4hSDjce0qUop?=
 =?us-ascii?Q?nSTmjzIfh5vBMLDJfYFntruRVagwHSUQE40hNdT5qsNZDnwU2dskg96riFdX?=
 =?us-ascii?Q?UdieTPDH8Fz5ZYsbXn52dtia+NBVyk1SxyJebiLVUP5K6LTbGZiYe5EQu8Di?=
 =?us-ascii?Q?8OmFc5j1t8wKbT9rHg3h35twzGA89akSVCSqfgXoI9HFFjCAlj/YfWgA3rZz?=
 =?us-ascii?Q?+VOB8MXBK2picUrBnors5ukC5dBqG3BfZiSElal2ooN1oazxfBWfsfKRK0kQ?=
 =?us-ascii?Q?FhfNoc4ovZHTEUOuyh1QXGDIaqzWUuWFGF2wDcbXi2UPq8Clmv6W5s7R982w?=
 =?us-ascii?Q?2zeYvW1Jg+GsRmkNgyQzREEMhTI4qQt+3ATIv3clmJJmQZQx+yMo23qHoY9k?=
 =?us-ascii?Q?3r+xhVfB6wvsG58Ux2KjUSV7owwCS5EStQm31z4oyXLDtz2i2hEE1HbJ2Tgm?=
 =?us-ascii?Q?5OtINWnfcDUryBfPx1Z79XxkvZeOtNWNQerX/EVsp7BjEd/1dynsRjdril48?=
 =?us-ascii?Q?pPLlTLXSo0+U/AYIYDQijWcYz6Fdp1jvF7xoz1uaSzAFFFitblZyQR+KgQwh?=
 =?us-ascii?Q?d26Qp+EW2Q2ccVmfNxGPmFFxfhebV2XRz/aFCXBLS8PYG5GV/qjD0QVAxT7l?=
 =?us-ascii?Q?yGRpRzsRqtRuEI60+0tFm1Y7HefHzoXHH9McfhyGV+eY/vrCV5NCt0W8JE98?=
 =?us-ascii?Q?YRPGS//S7Yhy1uWOLZxcgzAIe9rd79ikhEHqFU3P6RDFQ961huJyF95rxA8H?=
 =?us-ascii?Q?puYfhEpM0SnGGy1PweskqzyFvV8emHo2QW3Uksw3bcTu+iGp1wreMMwV+Ann?=
 =?us-ascii?Q?CbZqwiO4Ib96iSWQjtE1bUbrdNwgkkUvWt8c8avD3N1KKy1K5s8pPN/GFPRT?=
 =?us-ascii?Q?px+bhPfnCkZAcSdt/bhYcCRz+57HV3m1vSEzZFUiyNiNfxDK5sD+1K+P4LgB?=
 =?us-ascii?Q?utrnLv6AEnoJ9k0TZyUH8kPLo1HpT3J9mFGnAFFlRK9MeRic6KQIVegv1xBE?=
 =?us-ascii?Q?UeVPvHJ8NSD4hTPmx1qlxl4VAd8imXKgGKJFf2amo0q0ctKqRnFXq/4qGDE6?=
 =?us-ascii?Q?ituLqYfIXlvodc55xr/edlDT+BmU2sjdT+UCZ9QK8IQkHimL8v0Kfutud5w9?=
 =?us-ascii?Q?1f0WulmX5ZtS6mnDs1E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?P/lUR/isACGIR+WD8ACE3ZPutQMIP6yQ6YH5zqjpFdAayIF4ViWS4XoQLBTm?=
 =?us-ascii?Q?zKke4nx21qQ1tbBkeF8C7YkQb4iuVVLAOV6vhm03QzZhJTw1H/oCxZMPxEJp?=
 =?us-ascii?Q?1Ns4BzO86oGtIA/BpxXVYZgp0BzGKYeCJkfw8wnUIaJC+1xJ/4piBBY5QnsN?=
 =?us-ascii?Q?xjPVkGsoz9aQUrQed9y8LR67y90IMWTwlE2OnHD11l9CpsQt+1Ag4Ai7oDnZ?=
 =?us-ascii?Q?LX0g07CvYqQGC8D3afhJH61Ggqtl2ZFHWur7Ehjlt3Qyy6HeEbvpjJs0HB4L?=
 =?us-ascii?Q?7j8DVGU59IpMrLSi2ejTSp8bzBuWurBhOU4+nut+mWCadVAgLvdQ7UE+Eii4?=
 =?us-ascii?Q?1hiGZ9ASMlLrWl+u/3WG1JPXa6TCKOZ8gUO76qkTu52GgLIpxDJOVZtva1ux?=
 =?us-ascii?Q?PwDA6PNMLsYOXf6EovFaQOfS4yQ1MsvJPeN1LhkYKm4POy/DLJhmEhxhw3lt?=
 =?us-ascii?Q?PUnpaGEkZMSmaBwlyJV7vrPTWaKOqi3DML3Hv6IfWhIuLHex/v5JTlfl6u8E?=
 =?us-ascii?Q?5lkKuiR4Cb5UqzNB0jQSJMrFurwJOmEwso2H5qUkIdnsCHNfxSMvve/FOlYc?=
 =?us-ascii?Q?WAViqzXTaWeEtNz32xTaKa1emKgKgX6QFb8tyh3Cd3W7gpdemYP8fTaX/4Dk?=
 =?us-ascii?Q?FD15R6jAzvIacaZmaZQe/g+syIHeknunKuMzv6GLak9DRVSPWbxJC/nkVEKT?=
 =?us-ascii?Q?UpxOJDebzQVdHTlgB5exgcwQ86C8UC7rQXdG3Qgv6magsQPvVOnEc6ZoqFr0?=
 =?us-ascii?Q?umSpqYjm24sVbsjV6TTqzWgr49r08vjJ2dXej5rgagkMVeHomPXSHoqbdIJb?=
 =?us-ascii?Q?Kuahp2CVssUlEyfCUBIfEQO3tDBWdd6+Ug+7j3kzieQuIfzUHFyHuVQ0hXsp?=
 =?us-ascii?Q?IMXV/T1l/RtcI7IQJZ6Doc5Pb/7id3UXllnSyFr5xm/TmrItujtSsbukuW/P?=
 =?us-ascii?Q?CdBpwouYwkN4FY8TkmCUwhlIZD/PkNgKR1wWg4oDmfj2ZBeijJdM1PxE5EGL?=
 =?us-ascii?Q?OHFyscA9Xm/2N1DeYGE23cDjySRC61wLy5IhjAOS1SC2++Th8iGJo9XxgSKr?=
 =?us-ascii?Q?fadoFAPyN08/HBcKD5dMjzvtwA+cvQ9mXhA1krNxf+Iu6Qi+qv0SrpoBM6yZ?=
 =?us-ascii?Q?6KQf86xIgTyPdAvy3M4di3plEJCYPmuu3X+s2el93dHlwLHrOrDcPLv9LEZA?=
 =?us-ascii?Q?Oxi5882TxstSZXglY04d8wA6Udtb9v97hT8Nrvq1SsIOxxK8Nc3NInAyeE91?=
 =?us-ascii?Q?V5I9R/zrZ+NvTRgwJOT4c4JkQQtUks8vxfRmrKdwdQc+L7uYFUglUZ+Dz9H6?=
 =?us-ascii?Q?5RZ/v+T69Q4Ce/jyiuVGDejEQ1n3QS/d8NXuvteD/I5RapUxsWjih4lHV/mZ?=
 =?us-ascii?Q?/uVm/sp/qg8ovGwWwCZ//+aX2Lk6a/NglBMuGIP/M1ZzNOdKn4cdjkO2jn7U?=
 =?us-ascii?Q?UhTKhJ9wef4f6K99ROBx/x8lHNCbFdZoKxuKO3Jq03NiJGhvxC0c50c1ve9q?=
 =?us-ascii?Q?7PaXBOs88nMg9OWVjvGjiUDFTH21egTaO1wceZQQ4U+UUzHswX4eYEndbX6s?=
 =?us-ascii?Q?yPFnmjKlO9PF2bW92DGDYS22AuPjjRxYmwqbfRggYx5uhjRuE8Khy/SZinv9?=
 =?us-ascii?Q?igCVRpkS2bBC38YJZiG8Nxw8aDk5iRy2byyatz4UMM4hIAd32SE4RGst43ru?=
 =?us-ascii?Q?mcmUMtlGGeMrbuj4+pYGnytHHHU7V/0gGDBOKAGN5udl0DRIirTpZCyuQSG/?=
 =?us-ascii?Q?D4FHeEScrA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MQPjNDO3SjwtEYlqN28uHFzxwLG7qsduXiNJrj5dRFK35poUi3H+7SFoA0T62gS0Hoa9zzDdyXE7fwpRHEjMf60AijuyoJYVWswQsgjUfZv4330iF7urcy5U27d9W/nFKgy2/i/EqbWMJBCcrDGHNINDwMXT1jhg0UYfI91XTQcU2klOsSXwN7Jm09TeAM+YQaMqwXVT7zj0P0aege+J3he95LfBQmu1NFj9ZO1y1IaBziBKsBFe2KOh2BPWRDAdkwFc6bJVC8MzrZ5n7vVJidzcvks0qfgR50Ydqc70qxjEM3Z9i00iSm4QltFdMrvOXS/InQC/k4uuIOBkAPmeHEW/YG7Nhp83eHSD+Gdz7Acg8XvGcq+wlFk5WqKqIuZNrxcfOCxUzDXshWTwPGGMMgbR87lRLMu2bdwt5qx3KO4KB1tW3IhgQS3C46JjGWSDr5G4MYHstvizXLjDeMc1ZZNxSZalGJbDDpXedxs9DTNMZC9pQM3zJFQgfGjeVJ5ZMUKy6/vVD5tcCkklqu5/NfGNRWDR2seyXpgWwVZVzjgIMYVROOosdgLm8oo5HutfD0ECj2tHH3MfbhfYEfv9Rd7U/U4CTAVh0tegy0X0/wI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1edfd1c6-623d-4184-bc48-08de590d43ce
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:51:04.1348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RH9q5xWJaA8xZVrhbFMW91jFCVA7oEqsX2G8oPUMiHAAjAkcIGjjOa228LxKSG0bUvelUCkDbmfsRhM1lM1FpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4414
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210142
X-Authority-Analysis: v=2.4 cv=WbcBqkhX c=1 sm=1 tr=0 ts=697103fb b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=yCtcxbmM08XVNiOCcoQA:9 cc=ntf awl=host:12103
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MiBTYWx0ZWRfX66hUZez0RHBV
 LJwhQ4rIjH7nBxnSlV3QzLA/rSldk/XXc15lQ5QUP8apbfvHCcxdBfMzGG064/4u0qPumdraHLX
 9D5hnVg3WoCEPtQhKvPeXs6jpcf1gLEX7UZZVhCiT03A3Y93L49paOOqjP+30deVSVx5qc8PYEx
 qRYu3VVCPM+JYlNyVOdFq6k22vbI/U2OrfodVk6ExgUwX7uhZ6oNV+UcNVULAt/pZ0nLp6meeYt
 LBkmlFK3slWCgrO++Yv2cno8tAX0eoeqFS0UrMmsRhgGuo/Xx5F1R0bZZ0dXXGeWy54w2RzIwbk
 QzpEOwEhK8MVq8eVTDSgj02wRRalGhO8f21x2M6YwpxrlTyku45vFk2DmscXovG93slJPneVqNX
 dYLkgCFClIa0SfsKsUnwPei60UEDeWrtPG8b2ALtYwB38PZi9pCAE2gDoQU0aTpFxzxqZwaUPQT
 UlQ7Kn6shx9K88/9awhL8gnjXkj6A+eVSH2KFAXk=
X-Proofpoint-ORIG-GUID: n8SbVb7PMkPB7b6iKYIUVXQd-WAxk6lD
X-Proofpoint-GUID: n8SbVb7PMkPB7b6iKYIUVXQd-WAxk6lD
X-Rspamd-Server: rspam11
X-Stat-Signature: 68oss1nx884dfxs4canqagonr99qxwa3
X-Rspam-User: 
X-Rspamd-Queue-Id: CE14B40015
X-HE-Tag: 1769014283-235401
X-HE-Meta: U2FsdGVkX1+aBKv9f7oHaFHmB+0vrL7DEF6wLo7j0erFFcI1yz+pNkV4VdHgH+mvNKWy7pyXjAHIo3i4Y+AyRXaZ42nTt5epIlXiYLY70h7i0snIaQuUXgLXdCKNWZKFLuDWcHkbVZTOG7EjG7ReBldYSXKwiLysUdHj7WGOr7oJ9vp4hLBhLWU8+18+VKNGzr8owMCwXF6bQL/NdGYdiI8Ubie3aTv62uEafJYfNyiPC4Tutc8yY541wgHg5vVE/umxXSZQtmKoHP/l+w+1JBwVA9g+vQwWHo6Ge1zRSS5DcBedCLBLvwkfQZELQdU/BTVbU4sjHw+Qcx8oP3u4X5NqpaJHZuzpkMx5IFZ2zm/awQqsXqG4lpeZ9u//WESvPU5pVmdz0p6QM44qz8qy+Jtscn6vdPMk2gcl0AOs899L4NbO/2+r7s6QHj01a53j9+bX0cph9+l8uGRiTHGy1mPGBYtOKqDHAB9VojTNzTl2m014AzyiDEwo/Lv3xK5bflv5RPknQjHe/iSKsV373ywmEa/1KrX0cp92cxUSZzQ9GrZF93yAOGPPZY47th0feg+C/NWIfIb2sB7Ev0EuFobqabCiimw2wpbjU9uwKkuI48TeuaHx0Dfq3I02tk+yxcWXbb1n5/CQt7ihKo+cWelL3Fbr1rVekViWYp52FgR3KkxLt4j+nkzWCjXJ2XKbbl4bJdNo2N84DcsTxcfzJLFmjzgAwS/v15QfP9IXfOnFopOKBVaSSaQCxnuUHXlfNCY5I5ztJtTIMzzTWecO5G6zeFDmxxSv+EeI/Zx2pOCIBC3HuthujpG7nxKnMjU/hsiDfXxUwfHzkjsmUwfzl86t2Q76Xop5Tum+37AvX1ppid0GtktaU9qNCr8hHYvMzZaqXGOFadZtwiUblJSVYn5P4y3aHWTKEbrsObtPGN1q6EeCMAY5XcPw/KeD5r2L8+xDyRzR9BhwmXqsUkv
 64GMSG57
 iy9BGVxFrzSzwXspIhc6Y7vhr8KUil39L75grbc/GY0NvxXMLJwm+eUxeqN+EunwHr/rN6+xGYPoGCLRxA7hcthASlb0tr3woA7nJe+hOuOdvvFAgIvbv/uj+4QX6Y+zkJeyOcsrKyji3bMed2tXWzqMI6bpKz1fAYcpFiLgdVKEAHLGSuqjJBYlGFvlYM1Hbreq8kXDvl6PsAwHiE6cbw7sgfoHFq7UkG1f1LEGZbDfMgclNJo/SpLh6q1wufADgnsjukJQJPjKIdWorBkfiox/g+haO3euh++/gqb28v6cE03AbjPng/DQbmYESRlJICEpHE+WG33eClXk+CbH6LwYVVs3/+yP8BXN0s4hsfYTZ0naRY1BNu6+9sr3qYXwfd4GSiejru2m48wkLX9M/lYohafD00xu4S0nOd9JlqxZcPKDpQaApOSpDzC4rFsuy6ncIYjlI897UBoz87TmPEU87A+hcXcrozXQE6nVE/8oitdmuM+6cBmkvBZ61FKwQZG4vlAKyEZYBBLhtxSNOLmPRetdwcR6i+osP9acOi3oTvv/Pub+hBOUKhDJMZpfq5xpelbnM9sKJtppnBXHgFUgNPctzXogtdHrqbxUoQ5/5/B0w3fRe+iBDtgewYWCRmznFNDg8Nfz/CqnXcI2DRvXLuhhsl3hGNrDlbx43u+uk2zN+zGEFSU4hGjvZMrao8NzBpuROGgMc7eD+JzW4PA6Q4EuPkebtQu6Z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert vms_clear_ptes() to use unmap_desc to call unmap_vmas() instead
of the large argument list.  The UNMAP_STATE() cannot be used because
the vma iterator in the vms does not point to the correct maple state
(mas_detach), and the tree_end will be set incorrectly.  Setting up the
arguments manually avoids setting the struct up incorrectly and doing
extra work to get the correct pagetable range.

exit_mmap() also calls unmap_vmas() with many arguments.  Using the
unmap_all_init() function to set the unmap descriptor for all vmas makes
this a bit easier to read.

Update to the vma test code is necessary to ensure testing continues to
function.

No functional changes intended.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 include/linux/mm.h               |  4 ----
 mm/internal.h                    |  3 +++
 mm/memory.c                      | 20 ++++++++------------
 mm/mmap.c                        |  4 +++-
 mm/vma.c                         | 27 ++++++++++++++++++++++-----
 mm/vma.h                         | 14 ++++++++++++++
 tools/testing/vma/vma_internal.h |  6 +++---
 7 files changed, 53 insertions(+), 25 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index cb3de0c73d030..3164b897283f1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2624,10 +2624,6 @@ static inline void zap_vma_pages(struct vm_area_struct *vma)
 	zap_page_range_single(vma, vma->vm_start,
 			      vma->vm_end - vma->vm_start, NULL);
 }
-void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
-		struct vm_area_struct *start_vma, unsigned long start,
-		unsigned long end, unsigned long tree_end);
-
 struct mmu_notifier_range;
 
 void free_pgd_range(struct mmu_gather *tlb, unsigned long addr,
diff --git a/mm/internal.h b/mm/internal.h
index 2cdc5c9396f10..25a17eea550b8 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -197,6 +197,9 @@ static inline void vma_close(struct vm_area_struct *vma)
 	}
 }
 
+/* unmap_vmas is in mm/memory.c */
+void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap);
+
 #ifdef CONFIG_MMU
 
 static inline void get_anon_vma(struct anon_vma *anon_vma)
diff --git a/mm/memory.c b/mm/memory.c
index 4331a6abe3e4c..6fd6decc139e9 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2083,11 +2083,7 @@ static void unmap_single_vma(struct mmu_gather *tlb,
 /**
  * unmap_vmas - unmap a range of memory covered by a list of vma's
  * @tlb: address of the caller's struct mmu_gather
- * @mas: the maple state
- * @vma: the starting vma
- * @start_addr: virtual address at which to start unmapping
- * @end_addr: virtual address at which to end unmapping
- * @tree_end: The maximum index to check
+ * @unmap: The unmap_desc
  *
  * Unmap all pages in the vma list.
  *
@@ -2100,10 +2096,9 @@ static void unmap_single_vma(struct mmu_gather *tlb,
  * ensure that any thus-far unmapped pages are flushed before unmap_vmas()
  * drops the lock and schedules.
  */
-void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
-		struct vm_area_struct *vma, unsigned long start_addr,
-		unsigned long end_addr, unsigned long tree_end)
+void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap)
 {
+	struct vm_area_struct *vma;
 	struct mmu_notifier_range range;
 	struct zap_details details = {
 		.zap_flags = ZAP_FLAG_DROP_MARKER | ZAP_FLAG_UNMAP,
@@ -2111,16 +2106,17 @@ void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
 		.even_cows = true,
 	};
 
+	vma = unmap->first;
 	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma->vm_mm,
-				start_addr, end_addr);
+				unmap->vma_start, unmap->vma_end);
 	mmu_notifier_invalidate_range_start(&range);
 	do {
-		unsigned long start = start_addr;
-		unsigned long end = end_addr;
+		unsigned long start = unmap->vma_start;
+		unsigned long end = unmap->vma_end;
 		hugetlb_zap_begin(vma, &start, &end);
 		unmap_single_vma(tlb, vma, start, end, &details);
 		hugetlb_zap_end(vma, &details);
-		vma = mas_find(mas, tree_end - 1);
+		vma = mas_find(unmap->mas, unmap->tree_end - 1);
 	} while (vma);
 	mmu_notifier_invalidate_range_end(&range);
 }
diff --git a/mm/mmap.c b/mm/mmap.c
index 4500e61a0d5e4..042b6b4b6ab86 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1277,6 +1277,7 @@ void exit_mmap(struct mm_struct *mm)
 	struct vm_area_struct *vma;
 	unsigned long nr_accounted = 0;
 	VMA_ITERATOR(vmi, mm, 0);
+	struct unmap_desc unmap;
 
 	/* mm's last user has gone, and its about to be pulled down */
 	mmu_notifier_release(mm);
@@ -1292,11 +1293,12 @@ void exit_mmap(struct mm_struct *mm)
 		goto destroy;
 	}
 
+	unmap_all_init(&unmap, &vmi, vma);
 	flush_cache_mm(mm);
 	tlb_gather_mmu_fullmm(&tlb, mm);
 	/* update_hiwater_rss(mm) here? but nobody should be looking */
 	/* Use ULONG_MAX here to ensure all VMAs in the mm are unmapped */
-	unmap_vmas(&tlb, &vmi.mas, vma, 0, ULONG_MAX, ULONG_MAX);
+	unmap_vmas(&tlb, &unmap);
 	mmap_read_unlock(mm);
 
 	/*
diff --git a/mm/vma.c b/mm/vma.c
index 75c68c74c062e..b46c869d4bb07 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -480,8 +480,7 @@ void unmap_region(struct unmap_desc *unmap)
 
 	tlb_gather_mmu(&tlb, mm);
 	update_hiwater_rss(mm);
-	unmap_vmas(&tlb, mas, unmap->first, unmap->vma_start, unmap->vma_end,
-		   unmap->vma_end);
+	unmap_vmas(&tlb, unmap);
 	mas_set(mas, unmap->tree_reset);
 	free_pgtables(&tlb, mas, unmap->first, unmap->pg_start, unmap->pg_end,
 		      unmap->tree_end, unmap->mm_wr_locked);
@@ -1257,6 +1256,26 @@ static inline void vms_clear_ptes(struct vma_munmap_struct *vms,
 		    struct ma_state *mas_detach, bool mm_wr_locked)
 {
 	struct mmu_gather tlb;
+	struct unmap_desc unmap = {
+		.mas = mas_detach,
+		.first = vms->vma,
+		/* start and end may be different if there is no prev or next vma. */
+		.pg_start = vms->unmap_start,
+		.pg_end = vms->unmap_end,
+		.vma_start = vms->start,
+		.vma_end = vms->end,
+		/*
+		 * The tree limits and reset differ from the normal case since it's a
+		 * side-tree
+		 */
+		.tree_reset = 1,
+		.tree_end = vms->vma_count,
+		/*
+		 * We can free page tables without write-locking mmap_lock because VMAs
+		 * were isolated before we downgraded mmap_lock.
+		 */
+		.mm_wr_locked = mm_wr_locked,
+	};
 
 	if (!vms->clear_ptes) /* Nothing to do */
 		return;
@@ -1268,9 +1287,7 @@ static inline void vms_clear_ptes(struct vma_munmap_struct *vms,
 	mas_set(mas_detach, 1);
 	tlb_gather_mmu(&tlb, vms->vma->vm_mm);
 	update_hiwater_rss(vms->vma->vm_mm);
-	unmap_vmas(&tlb, mas_detach, vms->vma, vms->start, vms->end,
-		   vms->vma_count);
-
+	unmap_vmas(&tlb, &unmap);
 	mas_set(mas_detach, 1);
 	/* start and end may be different if there is no prev or next vma. */
 	free_pgtables(&tlb, mas_detach, vms->vma, vms->unmap_start,
diff --git a/mm/vma.h b/mm/vma.h
index cca7553c7d641..bb7fa5d2bde25 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -167,6 +167,20 @@ struct unmap_desc {
 	bool mm_wr_locked;            /* If the mmap write lock is held */
 };
 
+static inline void unmap_all_init(struct unmap_desc *unmap,
+		struct vma_iterator *vmi, struct vm_area_struct *vma)
+{
+	unmap->mas = &vmi->mas;
+	unmap->first = vma;
+	unmap->pg_start = FIRST_USER_ADDRESS;
+	unmap->pg_end = USER_PGTABLES_CEILING;
+	unmap->vma_start = 0;
+	unmap->vma_end = ULONG_MAX;
+	unmap->tree_end = ULONG_MAX;
+	unmap->tree_reset = vma->vm_end;
+	unmap->mm_wr_locked = false;
+}
+
 #define UNMAP_STATE(name, _vmi, _vma, _vma_start, _vma_end, _prev, _next)      \
 	struct unmap_desc name = {                                             \
 		.mas = &(_vmi)->mas,                                           \
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index f50b8ddee6120..0b4918aac8d6d 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -1131,9 +1131,9 @@ static inline void update_hiwater_vm(struct mm_struct *mm)
 {
 }
 
-static inline void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
-		      struct vm_area_struct *vma, unsigned long start_addr,
-		      unsigned long end_addr, unsigned long tree_end)
+struct unmap_desc;
+
+static inline void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap)
 {
 }
 
-- 
2.47.3


