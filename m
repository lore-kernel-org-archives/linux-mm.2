Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7DC0F31E22
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 15:21:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24B906B0093; Thu,  9 Apr 2026 11:21:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 222696B0096; Thu,  9 Apr 2026 11:21:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 138716B0098; Thu,  9 Apr 2026 11:21:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 02F7C6B0093
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:21:26 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A9CD41B8A3C
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:21:25 +0000 (UTC)
X-FDA: 84639381330.17.492B924
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013014.outbound.protection.outlook.com [40.107.201.14])
	by imf15.hostedemail.com (Postfix) with ESMTP id CEC08A0006
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:21:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZjgAXUpl;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.14 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775748082; a=rsa-sha256;
	cv=pass;
	b=yTBOvL1y/mgeGNQvD+zQF8aATnUimgl3hOnjBOOqVWLRz9xTjaDZe1OkRD0VEZivozWcxM
	A2d6FOFTYhVRJxMU+ueicTtF/iL+PG0HfuAJ8ozuFqMEqXl0FecP5s5sz2iTxcQ/21QYxX
	YQJFCc8XIDpPR3pdq3bumRA4MxUswls=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775748082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TZmgdf/FEwcOiyoLY1Q1XGpoqHPXfYfBbTDIh3J4K+Q=;
	b=ngJqQSUy55Vht9B9qKB9onvNtrXWiXPnmRL15XhZ1Zk2V3lV0WgEagrlqO7tMRHrSk/UrJ
	yi8uvihBtfEM66qa4zJK2RQ7VdLtCjiQgo6pT6zCYCty+BWZBuJSL5sOLNKQLZ7lqvVRZc
	0oCqDogbId6p6b6pA871gCjzmmwipFE=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZjgAXUpl;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.14 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RcQwxSbp3ufFaF5gfLihdQ5AmVYZRJcSBr1aTU9pP9Ndb9aD0ezvuY0QFnEHdS1RveiHd/yQUF88DulVLTWg22vR9DQNKINQ1CJn2P+IsVSEOwEHZsDX/mdX36+2JTRKewam8bQo9nO72FgDrGJLKv5uyGZ08OTRtGzm18IOhoRpLdqhQx+xmxyHjWf9lh4sQeBj57ix5CK2abMrFvNUFwql0AfWM1DqqWo8hAg9+xiuFWiiCGrD7Wz2Azog1QXTj5W5r3Wfcwg0NbGok3twnxK1YGBxxvYBl10hixVCoHboQ1fHEji2bHVVlPVVFZWjDz0JdjM9quwrtUaUW+sAuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TZmgdf/FEwcOiyoLY1Q1XGpoqHPXfYfBbTDIh3J4K+Q=;
 b=V5Jrvhsy292OMVi7bzZ7KtvCqIocyce0hdP58r4BycW3oQMXfifzGsUlCcGbmtNr1opcLHrzKqFpm5tpJwhmKyn22FMIF9YOFL0YQD8ZiCuoS6jmH17mt5IpO/wIV+30o4jsnxb0dKig0Xm5KrjBgwUmSuXcpsOj26520gE4OgRdZaiAVz9Q8WCT/5myOtuMf9oCX0Q8pt6olSeL+oGuKYzHCAtsgoChQRVCRPTaBb3JPPGG6Tzg16JQ2rFZVVAH+q1m6gRxp3qCR6IW1pJKwFDBOlOwKGzSMp/8qCCxBnrLwnLNRG01O9TW9F+H/9sGO1SPc+tnaCQc1CfuNUkqfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TZmgdf/FEwcOiyoLY1Q1XGpoqHPXfYfBbTDIh3J4K+Q=;
 b=ZjgAXUpl8Gxt1bUmagu9P7Z4uMaoYuqjsZ3vGemZOLDZo4tHWUCFyx+19NAXvLEjDcO+R/AlxraARfxZHIJVW/6CEw772zX0EuzYK9XBj77oUwliR7P6xQU93Gxokui/1DtZ7R1eSqqhkjQoh9ivSLo2ciyB1XQF/6dXU8LY4tXVPUtusOB30TRYnzx8H3r5NcacPHxPCZ+AQOYKxrRnLy3Pf8JtOt4MMR5m/7GduY9QkI5F82UAV3jluvxxixkIAxoW23JGS/VqhbEzt/Syh4MtcmJY887HUUibel7QTDlIRnYy2e7mBqx48Yfx0fG/oWW4V99uzQoDGwqf+BIzhQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB7661.namprd12.prod.outlook.com (2603:10b6:208:426::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Thu, 9 Apr
 2026 15:21:19 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.014; Thu, 9 Apr 2026
 15:21:19 +0000
From: Zi Yan <ziy@nvidia.com>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ryan.roberts@arm.com,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com
Subject: Re: [PATCH v3 04/10] drivers: nvdimm: use pgtable_has_pmd_leaves()
Date: Thu, 09 Apr 2026 11:21:17 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <81879907-E65F-4F46-8A85-4D8780EA8AA2@nvidia.com>
In-Reply-To: <0309be4a7133ba8d043380f0c3614af764f6e3c9.1775679721.git.luizcap@redhat.com>
References: <cover.1775679721.git.luizcap@redhat.com>
 <0309be4a7133ba8d043380f0c3614af764f6e3c9.1775679721.git.luizcap@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BLAPR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:208:32b::28) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB7661:EE_
X-MS-Office365-Filtering-Correlation-Id: b50cf208-de9a-4cb9-9473-08de964ba64f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	wHWlru7dzGzeEBgjURwMETF8TmNFV1SfdzZyiENJ/+4ighEQ8u4B2UIoSUCWbfzd5K16TsfV7SsI+SDiR3uDYzxQv9rC+ssZbfHs5vI89YJeyKO+hssadrzTau7WQrK5TT6QQeBe0Eevt9j7+BtZEh+pdeIFOV2TucxY4ltyxbIKqL8APxbcZQwbnbccFRhtrSLZuWT63w7JPpTQ7wMff7hJcgYiZ5fjdKc8tRMJxWIYEyhmV17mA9+4P2atbLfQ8VUcWKHMVP1kuOG94WXqCy7lGddu/o6Vs7CYdZEYudGv9L1M/uMusf5uAkaC9Yj5IJJnBHSMhiHQlnYu0YEsHgOn7uVqePxTg/AgsbkpItFrIm2Mcs632aiKQOf52+sOlJASdNuJr2nyqqu4OQ4qeHhcdEKBZCu1mvY49ccKitRrF4LphLEsPJQTBAjZt0R/WjUJVhKXfQfZcGZa6zX36Os14TlHOblivEi39cUjf/nRGyP0k7ee8xN17cOPJzfqVAfHJRK8adHXlCaSyxy7nsJSuK4VTcF4eEaOpNle96Wf7BRF8bwgACHPTSREfD2WlYk5uEzC7ZTKXQaWlR2/GIjVe0T40rSOZWXzOPFdVptZUuYWl31hlW3fOLnUV30BB86bbevImc4FODyXtKXY1l0DryLSb5Mi8RMmkaRkSdw1a8abdC4iAwTGrQzytN6QIc/M22hYWeUbK3P9sYI7UvEOOyJbAsmmsrZ0eWid7ok=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cWCePYk6iKi5qF7VsNADI37aGl7i/NgWJFGrM2oYLhtGX+1LhyG+TE99J8Bq?=
 =?us-ascii?Q?S2eQ+/vp8ZdHPbsutI6Xc2x4vH2QmPVEWmCX+aIgsABKW0F6ueiJSGwm8DYG?=
 =?us-ascii?Q?eVAQK56RXMjqnuRbAVQu9bYQu9vuI+jvPTg9tI4Mx+nAbtO3ncEVaDz7XumE?=
 =?us-ascii?Q?w3KjNeGQ8+58GTwRdKvsNVlaSN3PS33yMbXjnv2WL678gLO9xbFYPmNpzhqJ?=
 =?us-ascii?Q?/sTEZg8KN+mNkfxY4whXSdAyOIxsEYNlPid8omsn16XP/ezM99zMOJR8Ecni?=
 =?us-ascii?Q?KFjemz66VuhZGGReI1xe+q3y1xH297DV74SW1/jEzX9r7Vy3kyGYtSWm4VAu?=
 =?us-ascii?Q?kSoRd3anxs9F6FQS8wSp3SAZm5oRGyy4zGUVeEza4klu2UN7KPs9uhYOMwaX?=
 =?us-ascii?Q?AE3Kh+WnWaN+UUG+uLKZTSGJRGmMu3ddo5xoZ2gDWvOUdaFSUekWOaeD+9O4?=
 =?us-ascii?Q?NBP820Fteg6+pqBcL4649O0oagTUgOVsQUsPlG7XHSO76g/97rNUDqN1I6Ww?=
 =?us-ascii?Q?krMBNhKQJMThWZ6S/TdA3CXB5C1zJera09VIlPs4dq+XHzfM0tHrD3rzNGXX?=
 =?us-ascii?Q?uJoFCXq+730xYDBOA6ODKknYkvM9uoToF8kkw6jsFNyE3friTF5OzyCg/IBi?=
 =?us-ascii?Q?b/WkcrmW9H+XFKmkwCSUSXdTgtTfuLfKB8o6HwmvTw74r63se3SXBSJqZ2rf?=
 =?us-ascii?Q?qmO4Yye8YqW0hr+yZVFHaJvm4RKODVGqjo8wMXFZbcK8GrtJaYP6FPBOJKm2?=
 =?us-ascii?Q?b2kPqZ+UiqLl1OuP+GY/NhWg4xTy7jT/onMbtIj9obJu8QnyLTd5nVx2gm5z?=
 =?us-ascii?Q?6tP3Bw+/drNZygHUHF9dM7Z4p3VrKtA9pb+gExRyDbVIXjKU+sHZuZF/BBSy?=
 =?us-ascii?Q?JobVjcm0MMPFA9iHwn9wykyMzGmdvBGyH85BYbPd9suzVuEKcm4y4OTSda2P?=
 =?us-ascii?Q?g6QeY3WspMfSWPTkVfPsnhfFYlcHjZ7M0df/wOY2cOCFmnzQi9jdUoMhM7iU?=
 =?us-ascii?Q?+wfgS8wt+nWc0zADt8e5BZtSnYvGtmX35dXQk459KlMNvkO31RFimKIfLtLi?=
 =?us-ascii?Q?jO4RN75/zaooFKOxU4nIIZfQg0a2RbbKHWR17jRaAy3y7d9nSPrk7SDBKKIV?=
 =?us-ascii?Q?0IO9/xfT/eLhi27a59wK7pHhTYYD5DMU2eMOo955U2ucbOs8DQXNg7Vq3+pu?=
 =?us-ascii?Q?KBbYdj+FE4qvN990K7ER6XF9KSekrvcCfJlhERmnNZd0RjGEOa4UItePgDJv?=
 =?us-ascii?Q?00pMVHdc1DC4LXMhRr3LQVWH7b6XcQ7jHj0KhjVcR9SfzIx6kV8Xd7/FYA0F?=
 =?us-ascii?Q?LGXrGvI16X8lgoI/Qjpe6Ar5GpHPciMbODS9HpeA+cN9yTPPV0KNT6Dnw4fq?=
 =?us-ascii?Q?NPURcnzCuWrJ5NphYTMdin/IX1pBAcxgih35jTN/QXxLpdku9Gp6qDc73hRU?=
 =?us-ascii?Q?zm3dOBAc9dSQIZXGqgRYWEtgxPVKRqtzpGluZ+T6YMpfN+gBgZ0CxanEokLe?=
 =?us-ascii?Q?hnp7EICbzWc8ns3ilvzK55chSRUet8lFIv2gbNtLb/dcoz4oU60Em9iN12+X?=
 =?us-ascii?Q?IAYXXwRVy/VYe428PBlVRueu73QKKbj9Sxd9NEL4VTz2A1BnjidvGXrNo/WU?=
 =?us-ascii?Q?uaWeEnsWqA/cNlLuCTpsBS247mgdW1otwZPybH88Gfwu834nM+rZkmzIU3cd?=
 =?us-ascii?Q?OJQ7f73XvBqbN2dHacKmL8mh8blKqxZjW2OrPGKkhWfV3mlZ3dfo5sd2uXqa?=
 =?us-ascii?Q?yv1/FZHwiA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b50cf208-de9a-4cb9-9473-08de964ba64f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2026 15:21:19.1282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IjkYCiUHSCOzmGwjgMzvX1Ncg5AO+WTaUAOEeMQyWrn5B3yafMJjkbBjIANIKobQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7661
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CEC08A0006
X-Stat-Signature: 6ydtdw799nurxjqemu13n3nawsy4wwn1
X-HE-Tag: 1775748082-887364
X-HE-Meta: U2FsdGVkX185L4M9cot4WbBw1QAynus5YNkoDOETaQJlRWdVMrnMqwtzlZwP+nOlVMOj/31erVZlpkJtihu3nwcIH4D1b/IyrEa6MViy3qoZKomBfw7kLQddCUmE8gTdQAM5vPejfDayDqdsepnvuWm+BecMO3QEYxdq9X4NQIuYpPuTpQ/EqvCBV8x/nXHaJYPf7+i+AAkVtM/MLRi+rxsXeqQ1gEdioFqb1uk4P8E83gEavP4U4xrCgP1idQC8+SVB8SU9vsiD5qmJMnCowPQ48Zxir/T9GAojJOkWRm1mUE4Q/rjnefs6FBR81Y7BOoKRBfTMa4Ws61D5FVhrCYshOtmQA4Gd8Iy8SwRSOeGnAkvoy2FyFb6RoDbCwiCL2pwZudYPLcSiUKfouwFc+w9OqZGH0ZWwyiSzDXdz9VoRVl9tJnhbLWDKCkRnHyHSGrlLAMIBxqL4eR5EOaiWYcVxRyI5/YMGpzjp6ARFfCijeZ+TX6dMm38kBg0gLiJ3KQiz+vWE93wWBhkab4Te1YHFlP9hL7TZANu22JErYMDDeveOI6VpmKAW82Q7DNFs9aAmLSCmxtMqaylONmG5kbgT22Wv4PSv1V1/jYq20Pu62vH8TEpbNWNBYMfsggXKXFtJyFKAMY7aWzWgPIf2Sr8XosYABJX44ukKb72uCKqw3IcUe3uMjjtf1TXF1jrnudBT4/RMfMALscWLvTKCtoqeiegl3QReJYCePJ/P9xTAecLFjVnszcjPMEU9FitkNWP9BS/GXXZDvoLBI14PlQepIQGSVE3h0obMDzDkGrN4JN4ILANRCkbzO8aq/3VLQFqUuu6PJ/iKAl8kJNVJFEMvlRlaMap3SjNCeioqLHbJgb23m/vUhDKqzu7UjPliyq0285MQaH0XByHYt+ZaTNnPr1KtT7AuvvCc8k1fFWdUA0h1K2Gqh1kNoBoApDlPEaxSvcnmP7iw3CODwlG
 WEw88gbj
 KlfjDG/WrwxEPGLHzKrHKKCFT/5qKnIr/nCGPM3WEk2bdIULFE1JOYX0nQp3sTuXuLZLWLkWV2kcFJDKfwqGXM2s6NWWoqcpyK4A1+lSz1HoJhjsv6cHZHW4OobQyWXGPq4nWAMtL++gxXYko5aopgRe7ukvFHHRgRn/Tcm6QtJ+riFflHXcFCTH93YRW0zFfpyiemknTX8EmcxwKeo/5QtPyy0n7p/YADeh7I64ej099ZhRMUfcK5vabWJTiFRvLgclC5xYnLUXy16bKt27o1HLaaFCFuVZSTskn4UEBRau0/6UfNCpp2Qt6fhUWLTmOWUNDi3Jh5duxZXYeUv6czAMat1we0pt3yJbK6jwKwFcNmNiayauhJ6lmWfflfTxJepta3MNIJHxvxZ64d6Swnp6pWQ0CK8fWNxFgShaIjSIX3feiwv0JU0RhAHMSUjqhNji/iYAdB0Daf58=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8 Apr 2026, at 16:22, Luiz Capitulino wrote:

> nd_pfn_supported_alignments() and nd_pfn_default_alignment() use
> has_transparent_hugepage() to check if THP is supported with PMD-sized
> pages. Use pgtable_has_pmd_leaves() instead. Also, check for
> IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) to preserve the current
> implementation semantics.
>
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>  drivers/nvdimm/pfn_devs.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
> index 8fa9c16aba7e..457eb54e7ab6 100644
> --- a/drivers/nvdimm/pfn_devs.c
> +++ b/drivers/nvdimm/pfn_devs.c
> @@ -94,7 +94,8 @@ static unsigned long *nd_pfn_supported_alignments(uns=
igned long *alignments)
>
>  	alignments[0] =3D PAGE_SIZE;
>
> -	if (has_transparent_hugepage()) {
> +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
> +	    pgtable_has_pmd_leaves()) {
>  		alignments[1] =3D HPAGE_PMD_SIZE;
>  		if (has_transparent_pud_hugepage())

Hmm, there is also has_transparent_pud_hugepage(). Should it be converted=

to pgtable_has_pud_leavs() like has_transparent_hugepage()?

Feel free to defer it to a future patchset.

Acked-by: Zi Yan <ziy@nvidia.com>

>  			alignments[2] =3D HPAGE_PUD_SIZE;
> @@ -109,7 +110,8 @@ static unsigned long *nd_pfn_supported_alignments(u=
nsigned long *alignments)
>  static unsigned long nd_pfn_default_alignment(void)
>  {
>
> -	if (has_transparent_hugepage())
> +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
> +	    pgtable_has_pmd_leaves())
>  		return HPAGE_PMD_SIZE;
>  	return PAGE_SIZE;
>  }
> -- =

> 2.53.0


Best Regards,
Yan, Zi

