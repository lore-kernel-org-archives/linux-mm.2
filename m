Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DADF8FCC9B2
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 03:40:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 454DF6B0089; Mon,  9 Mar 2026 23:40:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 401A26B008A; Mon,  9 Mar 2026 23:40:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D94C6B0092; Mon,  9 Mar 2026 23:40:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1AD986B0089
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 23:40:22 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9DD1D8B88E
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:40:21 +0000 (UTC)
X-FDA: 84528750642.24.685B232
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 06C63140013
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:40:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Fy5JK36F;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RX6drdqa;
	spf=pass (imf26.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773114018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ThdFh6eMzzOsm/WCy7aJE6nZD051KYTqO54sNwK5fzA=;
	b=ADdrnZQWephqn3N0lfaAyptFKg/iJL+CmpWwIqXnjUPX+5+CAzY10xMtwR+0TNzhPqJmDg
	3dUjf3GP+06ESSEMpBSZjY3BbRi4NpvxHerffxrv4jvPjeRDs7NH4F1oqZIRL/Uuuc4/76
	TCiEf6RzZhjl4XZHjiOk4fsq/VhKBpY=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Fy5JK36F;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RX6drdqa;
	spf=pass (imf26.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773114018; a=rsa-sha256;
	cv=pass;
	b=crGP7i8mu9W/A0Ezrvg0UrHbf56F/gbJs2CZqyY8I44kH/BKGTUOCsRMwYkDZa32OFUW5/
	qRsdikNbQgJuQSLnuqPXJUEVGxQl1yx5NeYM4N8qa5BS7vr2zX3RAGE5khudnRyOMF8qjs
	p1n5++89VC6XUYqdFhnCFkHRRPzeX+c=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 629IN2Mi2347242;
	Tue, 10 Mar 2026 03:40:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ThdFh6eMzzOsm/WCy7
	aJE6nZD051KYTqO54sNwK5fzA=; b=Fy5JK36Fyt6/34/HDgE6xhSt+nsTxu06iS
	cOBpZbmGFPiyD3jg4KsCzO8+UEGlBLVbfoeo/XZ97U37yuy4PNqmagLd0QzkpXvh
	sFJrYRQxzNFwvJRRF+vXADbqdDuJr4IvulrUfrXE2qPIDPLlTkcdwt35jcC7vTtI
	1S49iRKZpbu6oC0cGeX5F93nX4K5K/sNfpH70q43RqPDY5/Qrvghys5ufe6NitEm
	7eTpfmLsviQ+HqU9Nc3EZSOzBo8tpmLLCzKEJZw8AI5DOkq2njzs9IDeumICFFLn
	+X263fS0b7pLUYkPTUBaP/cdiWy/6hTl0st61Qc3lUuV0kjjXS6g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4csmmaa397-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 03:40:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62A36fsX020417;
	Tue, 10 Mar 2026 03:40:07 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012071.outbound.protection.outlook.com [40.107.209.71])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4crafdhhm1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 03:40:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VsGy8DHABQhBAfg9dMM8al7A/l0eK7eLDs17oAD3b4+J5qEUjeaDYj+RH1rA/9bY9yuFBH8hWo71XnGb4xwMgNA62EW9U9oRQauzxWy5NEzJiCmM/o/FpgcBgdGqXTc3Ovh7AhEMihPiTaDYqcMG9vyQuDLMOlPMsfXgOw357fYmXMnKrF/h6KGfpMyOxktBdmHvKmeySDxUnuzD+/ddtFcyDfDbwl9WD155at/Jis1fK0/Wpwlg60oFdt3cAQCoAfzmfxD+8EonVZSwWgdUrZAWLpT0ONEHueMH+A7Bo50bBfe0HfeC5udaVs+5AqaO+gTrn5DuYww+stp5GwhV6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ThdFh6eMzzOsm/WCy7aJE6nZD051KYTqO54sNwK5fzA=;
 b=FEKpwnw3iYrPKrBvwRxqKGKpYmu4AcUaVtHnMo/Yc43fmtkZybdfQbzHpKhyW2VqCGsf1QV8KipzN7CwUdFYi3D2VcRR+9zLlOcUrEfrn+E8DmdurccUVDJzboT7YzZvGGQ3sfhVZ7fDMfZ2/tpW4CbJcUiB8BiOktIvgFKoFIOMb90snfsJvrAQzxE0gdeghrADBH6zmzh/5vpda7qrdmsX03rWWnE8SCDRi6iOFW4ZbXBC/uzMGr/8tSib68SDNFsRRz0hVPEMD4Qj36kHTEin0bhsMll8xsAwcdPEE7d8MqZ+prkNNhp5cD+sZeE9+Q1TQUTEXvRqvOD8tH7Yjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ThdFh6eMzzOsm/WCy7aJE6nZD051KYTqO54sNwK5fzA=;
 b=RX6drdqahNDdGR1TB1JmN7bLmFfd461ND7KndjHtg8V63UelOAz+EMWSWqUgAskOW3G24mxKbkjPYDkfhiJzj7SYfLMHlFQUItpd61tuL6dU5oLwck5+IpfuqingkvbyfgmkaWN+F6aYEDRXAaq4glLjLFlkm2Wl6nfGzSF/rXY=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DM3PR10MB7910.namprd10.prod.outlook.com (2603:10b6:0:b::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.25; Tue, 10 Mar 2026 03:40:02 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9678.023; Tue, 10 Mar 2026
 03:40:02 +0000
Date: Tue, 10 Mar 2026 12:39:54 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
        Qing Wang <wangqing7171@gmail.com>,
        syzbot+cae7809e9dc1459e4e63@syzkaller.appspotmail.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org, chao@kernel.org,
        jaegeuk@kernel.org, jannh@google.com, linkinjeon@kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lorenzo.stoakes@oracle.com, pfalcato@suse.de, sj1557.seo@samsung.com,
        syzkaller-bugs@googlegroups.com, vbabka@suse.cz,
        Hao Li <hao.li@linux.dev>
Subject: Re: [syzbot] [mm?] [f2fs?] [exfat?] memory leak in __kfree_rcu_sheaf
Message-ID: <aa-SinLe2jrtO1pS@hyeyoo>
References: <698a26d3.050a0220.3b3015.007e.GAE@google.com>
 <20260302034102.3145719-1-wangqing7171@gmail.com>
 <20df8dd1-a32c-489d-8345-085d424a2f12@kernel.org>
 <aaeLT8mnMMj_kPJc@hyeyoo>
 <925a916a-6dfb-48c0-985c-0bdfb96ebd26@kernel.org>
 <aassZV5PjgFx8dSI@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aassZV5PjgFx8dSI@arm.com>
X-ClientProxiedBy: SEWP216CA0153.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2be::12) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DM3PR10MB7910:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f885e6d-881f-41ab-c212-08de7e56b603
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	/B3F1p5wy1xc6TocxIj0aTN/7PYtykCYXtVqdK1Cy+aklg0XRa9aIMzZ1DTJVETr83y1ru+T2U2j/mmiug4oC9NogqWDALz1mAZTiz16/nYHj8nJAQpBvsA0f++8FJ/bKbpI6U2QSWa4iY7h/vHWLRnmgdMGrv+stm4IV4G14bazMzpbYKb4SxQXaAZgOUIhyeUoJh0evtZP5vq1H3GNLOAYL7YpQgmuICxGhFNNvCjgPyCll+EzG2TFL6p4lrslwra7C045wmrrFiMukznAzE/9K7N+XlBZGe4wiMqWaaGXrlHNjOl1oWE2ffN1d1oWonejouU5rGeOZwKPcbdJpidQ5qS70XBX1RJgXmhXOq/AAIr676wzddTNggXTRhtl5N3KfmXhYsueGoeZ6YBbBlMaYnfmFNH/2QRg7IMgYWgO6LxUGVFVPDsegTjKexYuZp+my3N7G9kCsRY8sT8sTZnJLAOPwlOVhPhcLFx9lVY65obMePpB2e2JuMpvFDQ5vrP1A6o21i09S0WAoIWveNQAOYek6Bf5pLXlKfIvlN/9C5mZIEhflIjDHs/UOVFt3Np9vLyZPsNbT2lGEx1+NQAK2pzQOM8LisFZ1xRWhpSS1aNIromTWViaLPkIBhZeYQNKnqy6K0XmjloAM4b4Y29JI4hjXjK9GDsXfLBxhki344jFrqtEk8r8pZL+0kDJNYbfirmK4uyHHtTFlEu0ffI2nM671sRJpPY37urgXTY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pI490vobD6Pj0A296trAliB4QEARKkhjyUYB/Fg7PJkaF+ujhyUAZqGPJNmH?=
 =?us-ascii?Q?8ziAmx/46wnshbptHUEMJTdi3/zzsizpHgugmQH7Fb0sRvGgZw/Jcf/e0VVg?=
 =?us-ascii?Q?FAiRBaDQl0KhCawZhF4gz5QErPwvPVruAHcP8AQNcBUOzizoMZoSEwlxKFyK?=
 =?us-ascii?Q?0E16nYtk6dAl75e6HnbksCKz6A4MHyA3pfudzhYc+vGawJjGksmsYuttWQpj?=
 =?us-ascii?Q?5S2hRdgLzrnGi9/rE4mVCnNEimWDY/d2Ueabgxv2pvHtQxEUaTpb5w7QG7lh?=
 =?us-ascii?Q?GjoSIKiBCsgrkEf0LG9FQb+FZJJ4ZRb8ZYUcNvqEErD9aWzw2ih9xpY+7YI+?=
 =?us-ascii?Q?mL390iz4uAHk0cCusFrsFP9VM6Qj+RWStwn3OO5x2S4D+0X1v/7+iD0+7i5L?=
 =?us-ascii?Q?VuzVgASqxYC6UrksUBQ0lRPUyAobSYVfgVJkdWdKUc6ft3o0SwTSSnII2wah?=
 =?us-ascii?Q?QYEdqcn0igZe8fy/D2wb0fp8RgKV2bXUjSI+Eazd7jykQshU6Z5KWiaoWj9h?=
 =?us-ascii?Q?XMVTyFiI4+jqQUncwr3DEmi/LH4z2h+PjbcMPHWJr8yPilCt1VCKRTf3N/Fj?=
 =?us-ascii?Q?hFPh3yyixR66vFKgdcSP1310IsmXwqXH/BA8qolXdeu5cUcbrIr0fpqrUhYD?=
 =?us-ascii?Q?/T4Lb4dcE8GhqvNSfM1+jzQwCeZThR9bL9K9cPdXUJ5qQadeMl/cVQU6/pIU?=
 =?us-ascii?Q?DjkRu2BiKIzshfyZbkWAT35+qRT8B3PzRzCbkcnSXlIet7Z4SBoZj8XaIMnH?=
 =?us-ascii?Q?dagUWqLY8zXaxossAyAIZOGuPNgNT0Y/UTd38ETIrhsHehAQl6lpYWfxBl8M?=
 =?us-ascii?Q?RJlVYlBzmDXCuv+3nlFPqHRRCe5O5Z7mf243Rj6Pow00doq3edkQUCvKwcyG?=
 =?us-ascii?Q?WPbaDUk+FB0HaDe8zgELul+6v5RrY5mZx5XlN1TdlAwDb89YUOP93P5NRJb0?=
 =?us-ascii?Q?yZvxgdVRqscoI3UekODjdHi4pRlGA0l7FwscP8F+zjI+ZIXX7mzlOYqeK1HG?=
 =?us-ascii?Q?65JdgHlA0Aeo+u4XOi4Q/jqDJeo6/PH80PkCbdAb9WIynn/zHW0Ls1gZT01W?=
 =?us-ascii?Q?J/p1vTD2s1XQZGXppzIXkVdGf7AnJUQlS6jfzTcC6234/uUpoAM8l/ZQ8f5t?=
 =?us-ascii?Q?DFJrtVLXeJU+W5mWMyfW1c1bI3L0V/7w5TmY/6/H0YI2nYaHrcxMrMlW4BxI?=
 =?us-ascii?Q?9QMFfqlVfgGHTWggPe8QbddxnTKsNVzflTsb85N1xwwQM9LlRK1BxdizA7xw?=
 =?us-ascii?Q?kw5TkVjAXYYd4fIGUK/aTROdNPO/21Qb1HOvYCO7mLZhuHqlokqaHUOrDfkT?=
 =?us-ascii?Q?JVpHAWviwdaJbczdonpsrlKcFkfZ3SfKYPFVQQ+jG6VHHTlQIwrMEtx//5L/?=
 =?us-ascii?Q?RBLBQXv5omuMaR4YJGBGdequ1w6Ld6CqSRIjJDbRs0nSq8LnyVP+cj4fRqLo?=
 =?us-ascii?Q?f1bWf8bsxoA8R699RrA580dI/B2hV8h9IckQONIQZJ/h6LUmaB81suPd7CHc?=
 =?us-ascii?Q?Suf+CE7qRYDXIACHzJre7iFrXSJVQczgnAjVQQW1MIvU9oBephza9bTumjWo?=
 =?us-ascii?Q?LCqPTBzo/W+ZqtRwkwIecfZMYh5JUlRIHYr0+RJils0AhO5jYv+qNcm61fru?=
 =?us-ascii?Q?AO73W6JHpP/DFlhQ+sxX558E5d/cQUiHfcM2L1MzmfK2kQ6WeNrO+otbUg6I?=
 =?us-ascii?Q?ca5Jlg1y7/jv9q0XBW12myYmK3s1npZltQggk6ShUsnyRud+XdMG1mNKmHWV?=
 =?us-ascii?Q?Psqjkp8k8w=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	O5qTSthKA9QlTJwz6x0Gr2dt8WlYTvAomH1AeCU2fk0yE/mjydogs9I7L/2mUO86waXrN6+6zGX9CS9F5nUlq+b27xhdnyQcsri/cIxaH7tGc5x54UGJhf85kjIUAMIacmCeTJ46Dja+dUYqvgD0q79OgqnFZcOIMP9gDJD4IIgo6HFbJvR9RKX5kUJsV9bKPG9RXol05KnrYUIkWP0efaVDUb8HnRlzqZtUyRTDkQ/OeM8oU1rUPm2EB32CZ3NHB+M3arDCFu2ycoFqd8Utg7eJKe9Gsh0FND7Yo4eDt8Q2ed+vRvdTR4ocfdbiZl6IxFDAiTTip+Or+rTmHaDIQw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oEmhocsO+p3oWWWhR6QViV8/qr3JkewJaWDzCLG7d/T3rzkB7K2/9VmR9Bd8Ai16K727633kLk62TAyHZt9q17ZZvnTw0vJ3s3mCtp8T3LdnDidJo/yHepPyUKPW+Av2pA4qfJiiTw5wQjFLO8k4NoSbkE+Q4/IgKHjXuf8TWhERQC5gE1RyTDGU3wCm76R45F756HVvRCkyTOrZHvpfx28Jum7yyEeJ8ODbV++EveY5LzpO/1dwPnwakQib7iyXG8t8R0ebJXGX4xE4FwaoGnSF9VTX6JOzIqFkY0ro4pQ+rKwCyEp7WbryWmCmJLJmRSk8Dd/pQMbrUtG7qQTIOrCBkuP6xm77JHtd5JWdp2ERvf9RS9kP/v7ML7zK58zQd3zbyoOdol4VYYU9jjt91435A9spGvMWnoNGWz9LYbCGHSDFfBthZIdyUturn8SL+/rEJ+4jqFk9Ydtdqd/G/q+2uCl4pVC5u56RPQNSozCC6vMjfRExfJPLqWjs7ot+fp4uZvBBAMq+Y0/3fqojBk8ytH3+9JhxVIu3tMDVBu7X02VGSvZ/GTYXjYg5InTZ9WnOvpxc+eUBKMp09T1HNf1N2U9T2dIt/2MYzyRKGXM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f885e6d-881f-41ab-c212-08de7e56b603
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 03:40:02.2528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KLgTmOfjF49znn3Ba5qAOKvm9+ZK4HQxliVfSj9lWll7ODx0Vebfw1fo6mQLS//ksUgBGCy6QiVn/aqNB6HQOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR10MB7910
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603100026
X-Proofpoint-GUID: CKX-Ki1tI9IU9QRl_kWV5HX1fHuVMPKo
X-Proofpoint-ORIG-GUID: CKX-Ki1tI9IU9QRl_kWV5HX1fHuVMPKo
X-Authority-Analysis: v=2.4 cv=U5efzOru c=1 sm=1 tr=0 ts=69af9298 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=9ZohUdVepsfXsivdpNoA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12272
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDAyNiBTYWx0ZWRfX39ZsOQLvuLdL
 1nwOhyLQyEQq9DKQArdxu7G22LpbURZzicO+Ubfbk1xpUeSLT7o86v8BCwAkAXZIUoXc6qPKock
 FLQ9J+aD4vVHXi+1uMnfwyL2y+nlW93B3SwnaYLFvxZeSBJ9CIWitxqA7XvjcWt1MD7zMSm7GOE
 dfq9eGp/RMcWF+P/uQDk/4Cglx2zS3XhdjIbKxr5oZX5tKYkZS3WPgvW5HGtQHFCYnu+k+2r5Sp
 KHBju1JjtCnMh5sg9zXbw0wmSli0dRT87iQrfZXU2i5S6uDQuwPqmDu3V5bLdX1a61X5BgBBfYT
 BMH9VIBZmGJ/WG++/mlxItsHv7tGUwX054k9rV+XeEeJbI/BbT+QEkzUprzhlndCYSw2vOuohVX
 RsIVon5H92y2CznjqqkX9HpSQVTTGbQkw2KsXEzHaZDbM6DSZsBQE5+t24i9JUWiJm3JZMGHzmc
 fVj4fredJWuBFWvB/q9oFVJbghj40pEt6AE3G+yM=
X-Rspamd-Queue-Id: 06C63140013
X-Stat-Signature: 5jikgzz7bh8u5t1zzafwpsrrkrrjnib5
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773114017-814146
X-HE-Meta: U2FsdGVkX18MyR02lwu77JxqmzbovWNP+aUXeDFEKg/TKJSLjMcfM7pIBllXKYblZLDqpowNT0M9hLQMu6sUQzLgUO6IQ8NraNkk+49ABKLrxbLYLBkB8gIlhVmpQE4zybDKCDAR59z2q8bF2/vIzpM9b0MO3r4Swg2t4DCbZ2YL8woRscjRp7fowJt+StQzz/1q6JFG48/3S80T46qbMtld5VQ5Rq02QnhohsVoNyjtKfj6yLT6MUTW/1NLhJAJMfebJLMZ6OgeCx/Ck1y8q1dWDBN1eKnaSv5mgHKi5rdFHQ9oaNaifVbcReKObyTWvabqX6KDbG59r29qqzT7Vl8H1pU0D6QIR/SAA4g+tLhh6X1++Z+YbMLaC2DvTIIbRzNr7S7H/E2X9AahbKBpxvqTZRfWQPykZU6ybwOUqY8yvFUaZIHti68qQ2y/iu4zWjDVMOSjJB6Me3BBMWhlP1gulhs8S0EYXz64oIcfVH0DhRllGWp+CNHVNBGDxqvv2DtATuviQBPj98dpDtUVNsBjcQBG/p3VZ9Kq5gq5pMn47MhTAOFrhQz0MDsvZcH7JbVGOteZSNah7GtkjQ0zBnhyzByBJKopoCimmfC6jE+H1NNbJPub/8h7BoH6PPqEmO8iKivy2NEg5VWj90buXiB5tnt03DjzRCp2d7O1Grw7fh0K/EG4EPjxBWGKiZqzmd0B4y7DNyFgTSasl8rXPqq+i+YZvRST7oFKwXl52AABmtcb1ROyv+FFy5/j2zSUNcd8SmSL0qCL7Go7ryFcN4TtRkszt153ACfi9C/DDPYHZnMZmb/KG8oki+RuY8hP3AlmzfGT55L/NrAbJ/wfMPmPgx7s6vs+ZHl7O0k0/cZXonBDqxr005cIDvp1hYLwFI/MVb2Y3i46dEeUR/WlP3jzTrPzf6M8vqt5uFMY/fHFOrjpf6SYGRaskjDJI9iLVVjp03DMUOauZagKNXZ
 glp8+Xi5
 Gmv3PN+dFVLNhdLLQ9vDratjyEvcdHQkblVhRqcNAeaVCc5B0CiNcCdy80NWhkjdJYbix+kip3CIQFvxc4u6aPvx01y8JekQ5HsVXenJMxYBRO1QnoVCxdR2LjwWWIBcbapDdMdtTet0wUStUgtFW710Sw1Hpg5KCMuFhX7QXnGyi/DnG1J2KeqlY39I4hVxiBE8clUEqpX82xbBGuSXI3Ca4nWEZJLyiSQjvXPOXqBO+bL8k3ukczoJJJ31ZD5Cd/7SW4FIVUOlffEhQg5V1j4gn11hykMMeGCRpG3mzTnnExS6G+NLO1G0JnezAokVDb7uMxONkQH9oiBYsy5nuoPdYOLzzU1x+QofbUZZJ+63kKG91YQ+S/q+kx12lXaqiL2/WbJXEodUnU8vZ4t2I/0JJl33Kobh5E4yTn6sIAITWi0lWpTm6Spnh4OzlKd1fELefi6OunEgGvOx525nYTVDLP6XmuiK94+oerXg7DiL/k7ff8Dp/Va18bwquQzc1ZDREeO8vENgYAdmFzKZGDzNoEL9ar7ri3TYszlf9FQopbBhEtYQiEUcIoxn87KU6edIfj33798oF/tByaPxw8mqypRKG17Fs6S7llXw17W0kGNyIlEYkoXVum1ij9CMiNYd/j/lMd5GYnOcGrqdAIt0YAIYviujOFOMJawRedu083vwT5mQ11Ld6YAV7157wBOP1s9BdTTUrKSwiT3Fnab6kDw2yihHqqPZBk6vbMQKIBeBUTn/Nnt3dvi+Kq1hCA1+Pj4G6T6WoiK393OMVCKtRXOLBXtXL7qzKwpeIM5GHKr1AkwJMNMI37R79whm783LSRROc2dojBnNhH9hwVAQEQSw00rQ8ULvttzT3PSna5+OZm70BV/JUmI41p/eIAFtJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

#syz test

diff --git a/mm/slab_common.c b/mm/slab_common.c
index d5a70a831a2a..73f4668d870d 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1954,8 +1954,14 @@ void kvfree_call_rcu(struct rcu_head *head, void *ptr)
 	if (!head)
 		might_sleep();

-	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && kfree_rcu_sheaf(ptr))
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && kfree_rcu_sheaf(ptr)) {
+		/*
+		 * The object is now queued for deferred freeing via an RCU
+		 * sheaf. Tell kmemleak to ignore it.
+		 */
+		kmemleak_ignore(ptr);
 		return;
+	}

 	// Queue the object but don't yet schedule the batch.
 	if (debug_rcu_head_queue(ptr)) {
diff --git a/mm/slub.c b/mm/slub.c
index 20cb4f3b636d..36f613f48bd0 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3014,8 +3014,10 @@ static void pcs_flush_all(struct kmem_cache *s)
 		free_empty_sheaf(s, spare);
 	}

-	if (rcu_free)
+	if (rcu_free) {
+		kmemleak_ignore(rcu_free);
 		call_rcu(&rcu_free->rcu_head, rcu_free_sheaf_nobarn);
+	}

 	sheaf_flush_main(s);
 }
@@ -3035,6 +3037,7 @@ static void __pcs_flush_all_cpu(struct kmem_cache *s, unsigned int cpu)
 	}

 	if (pcs->rcu_free) {
+		kmemleak_ignore(pcs->rcu_free);
 		call_rcu(&pcs->rcu_free->rcu_head, rcu_free_sheaf_nobarn);
 		pcs->rcu_free = NULL;
 	}
@@ -4031,8 +4034,10 @@ static void flush_rcu_sheaf(struct work_struct *w)

 	local_unlock(&s->cpu_sheaves->lock);

-	if (rcu_free)
+	if (rcu_free) {
+		kmemleak_ignore(rcu_free);
 		call_rcu(&rcu_free->rcu_head, rcu_free_sheaf_nobarn);
+	}
 }


@@ -5948,8 +5953,15 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 	 * we flush before local_unlock to make sure a racing
 	 * flush_all_rcu_sheaves() doesn't miss this sheaf
 	 */
-	if (rcu_sheaf)
+	if (rcu_sheaf) {
+		/*
+		 * TODO: Ideally this should be undone in rcu_free_sheaf,
+		 * when the sheaf is returned to a barn to avoid generating
+		 * false negatives.
+		 */
+		kmemleak_ignore(rcu_sheaf);
 		call_rcu(&rcu_sheaf->rcu_head, rcu_free_sheaf);
+	}

 	local_unlock(&s->cpu_sheaves->lock);

@@ -7538,6 +7550,7 @@ static void early_kmem_cache_node_alloc(int node)
 	slab->freelist = get_freepointer(kmem_cache_node, n);
 	slab->inuse = 1;
 	kmem_cache_node->node[node] = n;
+	kmemleak_alloc(n, sizeof(*n), 1, GFP_NOWAIT);
 	init_kmem_cache_node(n, NULL);
 	inc_slabs_node(kmem_cache_node, node, slab->objects);


base-commit: c23719abc3308df7ed3ad35650ad211fb2d2003d
--
2.43.0



