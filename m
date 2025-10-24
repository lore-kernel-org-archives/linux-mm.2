Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90A6FCCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 01:44:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6DC98E002C; Thu, 23 Oct 2025 21:44:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1F418E0002; Thu, 23 Oct 2025 21:44:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABEBD8E002C; Thu, 23 Oct 2025 21:44:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9880D8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 21:44:18 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 39404BE114
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 01:44:18 +0000 (UTC)
X-FDA: 84031312596.03.2086356
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id A1B3714000E
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 01:44:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=iZZo6hnv;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="BG/LtedV";
	spf=pass (imf26.hostedemail.com: domain of martin.petersen@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=martin.petersen@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761270254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6y9In15wdnutgYW5oZUAvseJtih1qYCpUVsy5nu2bJ0=;
	b=WYusdrDrALVrKpXaqRLN6/rp5GyXUeoPV6SHBDiX0ZPX80xU8dpog4tzTrH0iUXfUnnyFp
	ELiSqMj0TxMCt4uiz2MMs3BIheo5DhIsLFtwec49/AbpksaiHt+ZTYdID15ip+i5VcWOqO
	WrOKPh9vt3ppKG1eiz0vzfErzxg9yEk=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=iZZo6hnv;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="BG/LtedV";
	spf=pass (imf26.hostedemail.com: domain of martin.petersen@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=martin.petersen@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761270254; a=rsa-sha256;
	cv=pass;
	b=nxf4siZrrqA3z4vvMjrMxpLu/jggUC1EjWrfCuGOVzsxOQZH7xRGyBFiIFgZbNTfMgRWtc
	UnDcoHNcXMA+ck1pmf57GgJuTRAcMDY1Dkqbe3wRpo3ulwuqXTkTO0xbkHUJanWSbyAA1i
	wz0ZSjEmOj1SyttCealkD2iy/IkXJ+4=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59NLNQi5024080;
	Fri, 24 Oct 2025 01:44:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=6y9In15wdnutgYW5oZ
	UAvseJtih1qYCpUVsy5nu2bJ0=; b=iZZo6hnvlIvb6ORHIhYuMyETdEA5N/v/u6
	IQ9QkgRB7vTYWcoDv/1so/KtNuj6DFQKE5DhTdnu47ynUpstDruDROOi+aqsEQ5U
	T7apYeVs0TMkKXssoRaMZ6MxTg11k02dJ0De/I0kfAHajvK8nJK0CmVloT5J4UIt
	VeEwwn8M2vj1xaT0WwA52XehdMw3co9NRroPzDOb1xBsiJATVU4KLbkfDpVjfIts
	AOeCHMgVLlXMZGtOeee3maUlVwKxPuEte/e/3VNl1qs8RdV4TA8M6w4cN3OaqTkS
	fKx8VDXtzE0LAdX8EKnYxCBYkGHR8mC3r/zFnlp/Q1fKxnYyVTLQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49xvd0us8g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 01:44:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59O0vTqG022256;
	Fri, 24 Oct 2025 01:44:08 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010033.outbound.protection.outlook.com [40.93.198.33])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bgbb4g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 01:44:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n1LlOgD/hFpD7x+F26lwjSRiWtgKeOub4u0c/xIFg5IBUtNRCbd1svWynvgBOtGLfbuxsbyVWQGHKZNi1BeyjZscmDP8l13uL/QSjVk8DWRq3QVHshG8RbN8amEyxAC5OPNlPNx2Za1R+OnB58u5G74zZp0lNcYHqj0WsE+cuCA61aqQK/RIongAvvZcJzlS6FKboE7XYMHCiZLXCTehaSpA9z9BcdgoWVFhOt7yduNjYlxVNl/57F9rcu83ZsmCiZHnVitP86XWzJlPGWQAv+oeGiLLOEAnsf5QZM7eByD+F4sQijH3QSt2L1/FvnAkK+I7dpCP5JH9LU5vLs3Wig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6y9In15wdnutgYW5oZUAvseJtih1qYCpUVsy5nu2bJ0=;
 b=GQgEwiGElQEOq4QTWsgvH/cYHuLv0NbY3eIeQ9yTrtKx2p8u2J7eLXqvih7tjCQ3KZzZK/egiBwLS9zo5FSse+6EmReaKQMPNfXXIk1of6cBbSphfdvZJyjYVWNuMQb8eXOKt5nJLY2rZXu7yaO7QcXmNeZJpihgY10FzSnnZznwt9witThCmCNA6gGKutm+nYhKdY+NyPjSH8IT+n2+rdNedWjs5jklT6au6z4guYhHWrfXxGkYkBk2z16UNNx611E4YNs8n5Ol/1ocn+sadh2bu/exjsAWSCiwVRj6C+YLz+fFC1QhFo4T4Er5gmaRzZeYQcbHIszUEXM5z7Atjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6y9In15wdnutgYW5oZUAvseJtih1qYCpUVsy5nu2bJ0=;
 b=BG/LtedVnz+jdlsfjd12Qn4b0zbD3wTlvs0oDnynHazC7CWOlT0zMxY5ECEr4ZsKDkQyyPUT1VtnUz7IoT8VEfEXo1QX7tIFmX9jNpCyVuzJBAOM6gBmUYzla05qRtdMiVVTjAM24DSB0H08schkkevIgCjuSb3G4NtxVVBWyio=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by MN6PR10MB8069.namprd10.prod.outlook.com (2603:10b6:208:4f9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Fri, 24 Oct
 2025 01:44:06 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 01:44:05 +0000
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Vlastimil Babka <vbabka@suse.cz>,
        Andrew
 Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin
 <roman.gushchin@linux.dev>,
        Harry Yoo <harry.yoo@oracle.com>,
        "Martin K.
 Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] slab, block: generalize bvec_alloc_gfp
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251023080919.9209-2-hch@lst.de> (Christoph Hellwig's message
	of "Thu, 23 Oct 2025 10:08:54 +0200")
Organization: Oracle Corporation
Message-ID: <yq1bjlxysz0.fsf@ca-mkp.ca.oracle.com>
References: <20251023080919.9209-1-hch@lst.de>
	<20251023080919.9209-2-hch@lst.de>
Date: Thu, 23 Oct 2025 21:44:03 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0344.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6b::28) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|MN6PR10MB8069:EE_
X-MS-Office365-Filtering-Correlation-Id: 72df2d77-78cd-4054-6540-08de129ed124
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?K9axY1C4jK1liM+nd44lLtoL2VcRGI2lXPKJ5Cj4g4GPocUgLkMtuKkgsRGY?=
 =?us-ascii?Q?wAaWhGjuBtz+6CrZKj6j29dN5plxsCBNiNZgdpS2wmKFUGECLSPvjgherE8I?=
 =?us-ascii?Q?9S7YW3jyFmf4zgeoC4p2abH3dsW10sotGWov+1c+gRkCpwk6KFJNvlvQx/a5?=
 =?us-ascii?Q?WSNRULHHzAXZY6Q95rOxsqDb0l1J+NuikWRvn7egoVgFYr455hdx6Dw2zu9L?=
 =?us-ascii?Q?OT6+UeZEci1eHSqJhaOBl461nvnPsjzdX8XkEFbVHPcsZ0YLRit28R68GSa+?=
 =?us-ascii?Q?jYWsYDsJPUcVs8xZLoWq5+EcAElq7wJk8XuM3r9Du8EerGLf4+nUhCs0sZuu?=
 =?us-ascii?Q?Q8nRU+H4X90yI8HdXdBURAZi7DRfzJ5O4oZ3/2Azfd3zyafn53NBLPSy4OKT?=
 =?us-ascii?Q?LfTkhoYXRPlXEv0Y5eEhA1mLLfX0021o3j5HFJtTheBMgbqMCmPvi1kt9NO/?=
 =?us-ascii?Q?92/gPAsOpKBLhiJ1EJ0k4loh+oUvxDs0bk20DSOnq7a638mydDeOxCriCPlF?=
 =?us-ascii?Q?V3Yhbn9+PSxaoVIblLgEa3EcaGbk8wLHIexnZAIOAcAqbaCsTcyOcb68vGZq?=
 =?us-ascii?Q?nh9eIS5KbdyIDC+s6/g5TpS8yOphhXrd9cuppBYwtIU9G+tME0ouDtTMa7bH?=
 =?us-ascii?Q?OSXWO8IavK6gJwm2ZOPHywNKt+uwLgMMQzqbpsryB54AX467O8+xz1SSuHAJ?=
 =?us-ascii?Q?teEznb8/jXA5BlzJJ39w/SJUemI5jm/Ascd5l5m54zzSbapjKGdwVxRozrHu?=
 =?us-ascii?Q?yOrHD4qF92j2yKQ+5TKmNnoK/hlXdDIHE59h9SelVVVgyscofTUlMJ1HuO8E?=
 =?us-ascii?Q?9rA5wEKw6byoHqANljmxK5x3NatiMod6LLWYzWMr5gCLbcg0katTT55KZSNj?=
 =?us-ascii?Q?Lz9SVicbIA6UmbnJMVedWdg5ZcB5Df5DtIQYcFAwCUmX5toB1fzw7CgnxCBx?=
 =?us-ascii?Q?4bTHzw5yHQYdA1kQmSXP3LEvhe4Hu7xZyAlUjW0EXs+lqTBV+WGWQ1MnH5EB?=
 =?us-ascii?Q?w2LhGbBnK1cA57vweuNqkRjk8oKyHkRJXmx01jPBpZWJeGvggv1LTgmgOI0T?=
 =?us-ascii?Q?DRJX1mq4gxuI/6TVOSDGEC59+4njotMobIVlKgtPQ0mEORG4huIC2d3FtrDE?=
 =?us-ascii?Q?zthIJ7yBdoO214U0dICQEPcPbYj720pewBPwoRtBFpTipwO2m8r8JWFCxU76?=
 =?us-ascii?Q?pS7gIvEQww6jwH4j3+AGwftDhQmBEZnSgve7x43ioODZtDkcoOf8PMmRDwDw?=
 =?us-ascii?Q?8A/JaVl9xfdExXomfinQt5NHQTiYiK7BeuOGcZHdx5gtFPj2Np120y+P3iCv?=
 =?us-ascii?Q?HYV0doIr5mdmM+T+s/eHZ/GVtZMacjQ/xhmytOXfQ8+FB3vNukD76QyZ0NJn?=
 =?us-ascii?Q?c6xEeoO8zMHIkXQvcrrao17ZbwWxG4ppFG8IdLkoxx0rn7vTjbJLw/j11fx/?=
 =?us-ascii?Q?wvHhjjVKRKPNOnVTh06w6BMIewbzXtTY?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Zq1oaLQizuuwVtXpuosO1Q9r9+a5esRtqTu5hH8QDKK93WkrH0fLkLRU6Riq?=
 =?us-ascii?Q?WasKJub2IY2nRaBNp+8lP1Um9F/tlxcPr4HFHZXyv2IT5nW/JBPdauKjCchP?=
 =?us-ascii?Q?//RsUcAToPCbzQFoPWEa21kIlskuZ03o5hgjfAahnLurejUVLBgECp7wAR8o?=
 =?us-ascii?Q?6oef9ogTpw6Hbes844u1oVRMPwqA6del3Zhg0PHKecbvz/9KFEcG4Fnsp9Nr?=
 =?us-ascii?Q?LdYojSztZ1cnK5Ysw7UCLwRuoyRpmm7em7HDh1l7oGakv9/4STsc/YRbxISa?=
 =?us-ascii?Q?2Dx0oNflAUsL2jwensoNQ9W6DeJNXP4UuoWeE92QPQBwDHghJO5XB4CUj38o?=
 =?us-ascii?Q?XLnfojlYIZwdkYs4QXgP62YaI/5V4lnBNwwq5bNaM+7FQ1bJFAykCeNxsuhd?=
 =?us-ascii?Q?+60Ne2+TxezOfVbDUVF3AJUcbW0dvBrNE+TxFr/MF7DS93L7qA/mAgCz/q6B?=
 =?us-ascii?Q?IiZlqlV8k37By/VpquxiHaAm2A42cosK7AlIKfbTr9yrgDDzJivybj0Fvwrt?=
 =?us-ascii?Q?K8Tbp+kHL3PKYCHe3DB9/i8buNg2UIexs53PUUgEiFm+syFU/n7AU8oGN5xd?=
 =?us-ascii?Q?0SUwER8TWBFzuSDLyKiiwJ+wW89S3X7VWX5huy3y8VmXMCUjENyp07tySSsr?=
 =?us-ascii?Q?rpsiX3GrKPqX/7eobO7ZWmtsseJjjUgc6pqcVrFoEagbAcksKYeGpOXVvar1?=
 =?us-ascii?Q?0MyzG6ZKelvdr17LgkQqcKd0sZ9kAMgbPVSwl9D3pl+qFVaendvVOZ1T+64B?=
 =?us-ascii?Q?o8xwxbAY67PyCUMIpkSNC7tWI9sgRwLDvjVf2MfSQnT9+Oyo8T2MGO8MZ5Hz?=
 =?us-ascii?Q?6s0o/TcuhGoCyYfNfXVAM98UznrGKqSyLa/Yv5+gFWmWXhZaYkHJhSKcDGQn?=
 =?us-ascii?Q?QmwzXQ9xC1lmdDFFCRxVKHON3JgUX3rC7C1PZ5MroHReXIhMjLBR236qxfjl?=
 =?us-ascii?Q?Whcb0HlXDbB25nPUcdYF+vo5kRAcvzmgoeKd2yI6kzZL1gAIKssQm3k2Hqzb?=
 =?us-ascii?Q?EdQLfSy/TG5ihOrarLXvyoM4SwDEKcZXSmPl9/BpCW/jfASzZ+wfe52lYZ6E?=
 =?us-ascii?Q?xCzjhhYqDaoElfAnFiS3swGiPtqrkqLa/+rT/+1ZpKRgy6gKEKbcInTzc8kG?=
 =?us-ascii?Q?clCFQv7QHiO0VvaWGBn++6M2fttHFiMgzwp4n0cDlhereJXFdXs03RReANND?=
 =?us-ascii?Q?YzyccwpqHTQOwBq1Q8kX8O9nA87A2TGqjQYpprJQ4TlvXNVtAWciwjV9OfXC?=
 =?us-ascii?Q?zlDSG7pUuwBXkfOhrIvj4D/BkCzM1Z+zNGnoGWRExpn2XJK5Gtu83QL4JQ4U?=
 =?us-ascii?Q?u/4yY7IUsrI1dxGiS1lZ/b0Mqm+3A1ryNAfzvdJSXdHYVq9KNvaF/NWpDe1j?=
 =?us-ascii?Q?f5boXP9WnwI7KyHY/Udp8Il3KGsmfHtWL0gkLxM2FPzZmfrOexZvjMf4tUrK?=
 =?us-ascii?Q?lOvJId+P1TVl+rRFLe8mE4qulGFvXBcZ/q5ZxQNyc0UqX3d01NkAE+b9BEwD?=
 =?us-ascii?Q?Sba0YP3hY+Ix6/1c7V80MdV8RXER/WGGe4jLjZtoZALCT5zMdLsINBkO4IFx?=
 =?us-ascii?Q?RshTs8GSx1GTZG13sC5PDV2dDrOyn8uwdtAKMkGYnHGYUWGyu3+xvpqmRE14?=
 =?us-ascii?Q?AQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Z0avm6fjjLQ0ybc3/ipzpuoVvf1rIGCiX+Wuvt/FK7zSnwCKBTBln8S8TGM0Qq8dzGUeEDuNvK5Pi/jljuKNgh2xGnDcXZRku54Fl3pQmDHq94QpRDFPQDXBkRqAU1s7IUdGFyo1P3toYFJD4VII56F3SWXUOaeqKVa/P7woxgVUKqlqDSC+AnQGXOxNG+wYz7HNbtIFk35qhUc5bpLVTuEy07oHvHI6yB31baHy6XwJM/2oL712hBzSjZ91PcFxJuCphwIkKBLBczCebIRaWcHKPHK8KSRbiMMmblzNuiuN+gPIguMbGqR7X18Z+OMEIDy4CQZR/eOVlpq4MweerxFES6cT9E4jeC+uCiZJV49hBp6tAZVm2oHV2TLxGoj9xbM2quZKzmpmzOAsk0XEIw9ELDy9e7rvBk+T35DTDNrldHTv2P8Q0Y4krjzl48cIpXLQL0ZHMYcmPTuhIAVP07nPxswDkZH45g/L2gDYvuBIOhDR9e7f7F9n/ETw2z6ktSG4f3I19Slx9eTY3aeuZAWKQkcM2Jo7i4Qv1kBpnKDcOdQ5dy/giUOBKoNtwKRd4npFtYTpH0ynilnhWEHbtsX6xb3Gol+uK4l/4noQ8BQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72df2d77-78cd-4054-6540-08de129ed124
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 01:44:05.7462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qMYwQFOLjGwgn5oP0MBowiWYx554GyR1MuH2hgWnyrlRBGlJ+mdKu2PaJicWJ/hNw1zLr0GLR9RFC667ohCkFzKfsiRD/FxeNK+mPIG6EPE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB8069
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-23_03,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=969
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510240013
X-Proofpoint-ORIG-GUID: _OM-H5dhF51fBpElBCAS9BNSI2rpA4lh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDA3MyBTYWx0ZWRfX2YuzkxOqC/Iq
 evGtovAsw8b6/G7mdkdZhjKVsfTJqY89OBXpBXQ/QsicUKtoS1TAk765hyLBhVKhc61heCGEms1
 IJ1dhNAZig5jgaZazS25jLNXUdrvbLlzQyfFVuayDV7CDRwcxUH12xRxqzYsQf0+hMI0CDJn4Jk
 VaxUqeRcg5bAHADYIogJKUK25Hz4eZ8qR1IWGUFHrqyb/82R5QS8iLoKyCdJTxKIfz9YI+oW59m
 91hPaPBnjxJ8ttSWs+Uj3B0g7PLRaLS5deBL0r2l4Gv7IA/yBypCMrRj3EC+IboOwOFP1hyWlUx
 WcD1HEjeMAfvU53viJ8ck2mxvxZUv/QDntoGywU8XDdgkiJJEtZSz4hVJUJxxKqeoFJwF/l2O7M
 +LFIkiahTxZBSqm/9BPz40rpzeHkdLD5fZ1ztSFkYDI3EE2EudQ=
X-Proofpoint-GUID: _OM-H5dhF51fBpElBCAS9BNSI2rpA4lh
X-Authority-Analysis: v=2.4 cv=D9RK6/Rj c=1 sm=1 tr=0 ts=68fad9ea b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=JoNdTUIbcdQZd-uEawMA:9 cc=ntf awl=host:13624
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A1B3714000E
X-Stat-Signature: pxfk3cxtfwt1jcq4q74k4en38d3e3iw6
X-Rspam-User: 
X-HE-Tag: 1761270254-604258
X-HE-Meta: U2FsdGVkX19Vos5ONGxNG068l661JnsWr8fz14bbe9mECAsXrMdYpwTHwzctqJT0yZGCfT5pQ37YJcYcsXJTb0GeLPGPxwEFT01kWGklOZGBJKhmqwMLbFmakqxZjJeggQ2VpZrmzXJazyqmG5K6VCORZv9btJOkEgWAwwWgXcn9s92m4VEFKxaSmUtVy7uJ60VN2OwqDtsQGzFySeRW0+h5kcnuSSN8tHTzMRUlX7Q3WaJ9W0QsKWzRbt5T6rTD/jj5XB7adI91cHZqZxf7jE3zf3lvRLGJJqGnnnaWzdY20wuwoImvvqUuV71MOwyBhEttXR9VH6m8IuaitFGcUb8mBa25Qv81FRKiM3BVeYS4gnjkXnmMAibpMuJMD9I/oP1XeJneTLTl0ZgHZHE95sLT44O5cMxd5+Z9izdpa/Vwt25GWSvORTF7b8XddnaDWeT/+lp1XPAM4V1OrCGegUQrU/jMrDmAbFvmckHIBwJWIaJjQPX1stQx2oksIz2IqV1gbfP9Wl+Fnit4E8C8vw5AzIWkf2lkhXvwAgR8Qu67v6UfYLWiOxxLQ44IkaK4uJOnp0skTwlk01ZQpXVwJMfbQcD/k/2eXj2baEdHKjKYyVh11YEc4CBU/frxFBp5zP4Hd1z6WFt8wOw+tt4LoOzBtttZJuRCdGBgNpYfJBUacjexh2svplh+bX2Yx2boh7tZSPvKGfnmij8aJOiwV72EIYxREU3hJSWF6u5yPjLapvVz6mmWzyj8GtvJluXItLxi3IMwV33xFn2kA/ZjE0AmUBmMiszFoxrvX52iVuRIF/bA9N3aMgty8u829ggwlwwQVfOVY/ifdsedp5ucxAdTJvp2yxT1kXeQxlIhmxonKHdCdeSikag7/QltWhI0rKnMYdRCPm28LKpsYK5/mhzF6hB2csekSLWIJbedtSCCQWqOFaeQfpswo1v+m7yeYa8x1gJv0wueNOg1cMS
 FC4j8n9b
 1YaUbjwt+X83DGJLFP+Iode8vyNMh4xTK8hx4RiovlT4IFs5YUeWE+i/TfhmdRxR5alh30MX+uqsuz0jydD1lbEZBAWHUrMz1AR5mOnEwYhBbmDGVdam3Q2iRUTtuhKjMXE4fGBxylALOPZDjNVwpVQFcGUJzxzhq8CT6spilessT45Gsj9qwFKk1fjHm//CXBeXxjobAmP0XtOQGbR36IxLyY9JWVkb+4NMuB2UtbThte1zQ2+NCtxSrYmoFKEdDRLSkb63508F5+sLMSo6Lyrgg2BdaBBP4o25mo5LoIxHSb5SCazmB2J6DD3GDOEX0pKigBRiSeHQ986+5/UH1xqWfMg5zhhw+DBYmyMPrvvarpJH0sGjDHlnumv3RzDCdiwY+UGqYvVjNXAin0LiJ3jb1Qr/3PTIf4r7RZpoz4ECHTXTiRZ7SFWlfpJ0DwyIdCfKLow6DKtfKWCIcsHM83LXu7H+4hjz8w0vPzeJf3okjXQ7xQUyFxjpOcSEaBD5EvSYgZ1ahchlq9BWtGsOM17ObnONSdI7TGlaCPLgMNdI9fZilM0w2VUXtEglhqPxZ0RDLsqB0u7T3L9EgiWoaFFp6lISBXslE18elWAOi3B/j+BL3YMI9BPQM/6/M7F15zLSh9CYTaJhys0V4pgFhBBilLZOC6fvpnkY/LHndQmK3mIpV7/VHomuze7VNJvp02V17DCLvOIsFMJllZG7KO1BHniJc5N4hvfcN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Christoph,

> bvec_alloc_gfp is useful for any place that tries to kmalloc first and
> then fall back to a mempool. Rename it and move it to blk.h to prepare
> for using it to allocate the default integrity buffer.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen

