Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAFC0CA0FF2
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 02:15:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E5E46B0029; Thu, 28 Aug 2025 22:15:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BCDE6B002B; Thu, 28 Aug 2025 22:15:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 184E06B002C; Thu, 28 Aug 2025 22:15:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 066376B0029
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 22:15:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9987284F6B
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 02:15:24 +0000 (UTC)
X-FDA: 83828178168.08.1464E0B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id 492A0C000D
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 02:15:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cP+NLvZK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ETjb3Kz8;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756433721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KFobVW/hdlT3+7q+B8LzzC+/0A8k/JX/hrDBs2y0O10=;
	b=zLmnfDg4NYrzJ0xtQ5cVl9ORzU+BYIsPvO3kb72xZTFfQxW4mN89FKaE8Q5gpcUMhxVuOS
	VNIcS3PuW5aKnKzHx5FAnn/wufvSMg51cZrpqXb9HDWFbvbLo/ffJ7PeyMrBds45uW4nN4
	sD9i+r0Gim6vMiZNuEzkVtX1rma/sxY=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cP+NLvZK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ETjb3Kz8;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756433721; a=rsa-sha256;
	cv=pass;
	b=CC6zth3586CGNod9PY7cwTW+wWv+x+8DAOe85CLUVudN1PrSw2xJu9n3E1HRxENysaKyGN
	PlC3m1LGsj83rdwhQACsVzC2Zu3ANjZ3iWMLo50m8nstC8o/t9d0ybJgGYnm+0Pb917oQj
	+SnNAOYaj1YY7rwKlzr7desszpfLUSs=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57T1hCKr029326;
	Fri, 29 Aug 2025 02:15:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=KFobVW/hdlT3+7q+B8
	LzzC+/0A8k/JX/hrDBs2y0O10=; b=cP+NLvZKVxwE4s2RjuJ27O4dDSpyrK+i6p
	iQ6KzjXV+emIsRoyZp1yx/ufzdHWIPBeCwBD7ZCWD0Ogc5Z8qpkxO6sv0nL4Xb5P
	OvJQJqPaMSChwugQ3RjfEsUPY59HuvwDN5qCEkqquRs3mQ5ggiUMFbCboCVyiUzv
	AbDGIaFuFrb/IOgvk4mjaL40U4w0+RpE2oA1IRVUa+vHD6sMPoLJbKwSNnwZebui
	+evPVX5ZLJcwgFmjNqSBZYbOQt1xN5w8UIopP57o+SmLqzoOiZ5rURFTxYi4H/mB
	tQffLGPfhC5hon2idvwPGr5GbJsbP30J+g27Qq0JAjgm4R6eXuMw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q42t9hhj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 02:15:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57T1PnaN004951;
	Fri, 29 Aug 2025 02:15:10 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011036.outbound.protection.outlook.com [40.107.208.36])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43cqq9s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 02:15:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=slRsRaibQ08ASEecPdTm4YwTNBqxMPlw1OOxFtZL2zFEus2sNJRW4jjqfHVqH2MF88lFJdXUm4HT3UCM+rW/gVlOJDI2cNbDOysYmOZkZ2SaogszULXAuYlUejIcLDzH6UIcjTuEXzHeI2kQI01lp5Y99BXQDpzrsAppMw5feJCfjbj52+E5zUUnp71zSLsTtWcUSXbkxnhrfJxGEdx3aTTamB1bqK4Fx6z1IM2V8a1BuRQZfU+ouqx3LG/GCryHsJOBvaYXUnG1lKTk2tpqa1jqiJcZK4CnLCy6cR6sH8jVpxtBs6hjlIvBGfa2cQ0qFWeCs4YPqEZkleQI4gxsAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KFobVW/hdlT3+7q+B8LzzC+/0A8k/JX/hrDBs2y0O10=;
 b=JECK5A68rEYxm+n4vLw3e93JrP4b4lL6yLKUJ1Pu7InRPdxSqNA+AYjMo2lR+l51o34Pb8MzVauPTSBocuJ3AqlArNva1yJz/0K7Uaca/UB8duGVDIruv9leo2hlhFvAJdbnhCiqjPA8gb1ds6/kmAZipGJ5VB104nrF7XWyL7WNSB/OJiMu3iR41pnBn5ot2jfQamQzxYGylhzC3CShqJ9EHkR5fDvRJShgbTz8yRdoyUTp+PaA5lasfnbeAfS9RGuHkkxmBrXZ2wuIr97eBzR3B/FNvo46+OBdRfZ1et76Z2hM18pHHPwDfLM4kEao4IjGj89c7LpcgFssCcCUKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KFobVW/hdlT3+7q+B8LzzC+/0A8k/JX/hrDBs2y0O10=;
 b=ETjb3Kz80D9OEwHKLc7BxfsgNdAsOKo2+w0HFFX6MzsphUtUNdNu7bD0WthwCWVziKRKA6upEdOQwQAvFAo6TIm0GDbHYdxH0X+Ya4CK5TGRwTXsgbgUJGxFPs/OzsZsM/hVFUUIfQ6eFGowxqmllT5YRKsXyMZPtaJww//esTU=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH0PR10MB6433.namprd10.prod.outlook.com (2603:10b6:510:21c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.16; Fri, 29 Aug
 2025 02:15:04 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9073.010; Fri, 29 Aug 2025
 02:15:04 +0000
Date: Fri, 29 Aug 2025 11:14:56 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: vbabka@suse.cz, akpm@linux-foundation.org, cl@gentwo.org,
        rientjes@google.com, roman.gushchin@linux.dev, glittao@gmail.com,
        jserv@ccns.ncku.edu.tw, chuang@cs.nycu.edu.tw, cfmc.cs13@nycu.edu.tw,
        jhcheng.cs13@nycu.edu.tw, c.yuanhaur@wustl.edu, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm/slub: Replace sort_r() with sort() for debugfs
 stack trace sorting
Message-ID: <aLENIE0gY3XsGeSN@hyeyoo>
References: <20250826062315.644520-1-visitorckw@gmail.com>
 <20250826062315.644520-3-visitorckw@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250826062315.644520-3-visitorckw@gmail.com>
X-ClientProxiedBy: SL2P216CA0167.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:1b::16) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH0PR10MB6433:EE_
X-MS-Office365-Filtering-Correlation-Id: fd2fb982-1fe8-4736-858a-08dde6a1dd75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Dz4vEjzgZ0JqmrJd2s9y2Cz0kiJigk2LrH4TueJYY9rFZwraAfTSihrhHd0X?=
 =?us-ascii?Q?1ExnmWBycZak2gGz8R10WAyeRrnxJ0AnPhYQAoIyEeBWlaHTMc42YFitPrz+?=
 =?us-ascii?Q?Vq7j5bYL7K5MiaeTC+240xBPMcIyNJAmKKrmVbjVpvGScAlW7tCdqj+zMChJ?=
 =?us-ascii?Q?Y/Wb9o74/4ytHPt28ViAMZI+MFXbAfuqEw4dlRpA80Np5Q19foBguUpdJ4h8?=
 =?us-ascii?Q?CBrsH1UqbT4g/Hc5it+in8QBXH8yOBGuAfPR6EQ/CQYI0b7/dN4dMxDclfzf?=
 =?us-ascii?Q?McvLYWXXrViNa8AySjfpsHanMp3WxJeGh3X0gv/mucQpP8X96hiKRp6u9nQS?=
 =?us-ascii?Q?LAPkj7B/HNGmVkSbMGUOY5Hu8Ht5hv5KT+AeDUoWFpKZN2AP2WdgmPPY52f2?=
 =?us-ascii?Q?XRKtojEz99SGISGXopEXzlyAS8g1lPrKn72BCCPuDjFF7t6+QDPq6DWRragj?=
 =?us-ascii?Q?G5QugV81RklKYqe6EhTX5E/KDBqKlSk7kyiyCQY+PZaMLHE+vSl3dIp2IdrR?=
 =?us-ascii?Q?Wz5SgwbIuG1mAGG2jew57vZ24q1tpHgujduo8CWOrvLJWqdL9wJNW8376BRR?=
 =?us-ascii?Q?FOK5xq0oUG41MlajMRuGQ9pBEzscyL1wF5r+dbSB0GGtD02y7n791tg41Ts1?=
 =?us-ascii?Q?yTCeYGUEbKukEXXQNwFpGClRmQcHs78qaZov+Hc18UFHmLwqkJCvIudmff3A?=
 =?us-ascii?Q?G9Cn0JHcxp/MkHpzKWx8hBRMXjwHYXnGiXSGgm6xmzslY/zxi/uOzKrTN4WN?=
 =?us-ascii?Q?ezryzSuDr8YkiQWb/nzzi2VjqUfOtYZV98SaXJqavTW0Nuvyq5YXd1BMclpZ?=
 =?us-ascii?Q?E5S/N8A+nDD8QQOgR+OsZnXP0CKn190xSLc6ADDmCcD8/lVFQ2tlsHl1reYJ?=
 =?us-ascii?Q?2QeDh7kI74rzTq0YgUcnSnqPtbr1V1AtObe4RtF8NBEGRx0Yev/EWURX5TXl?=
 =?us-ascii?Q?yu97BvRtuplZbF/McMjU0pqG8G+hSIbNBpuYVwvNnwsm80QlxFVPgRY9MGS7?=
 =?us-ascii?Q?MvZunoDsOvRlrlsbSzFdjpA/qja6Oy9n3cU955wwoaSu/qLx/ELkXwhw/05U?=
 =?us-ascii?Q?PQ7vVKZTguvJyRoe60TSppEh1xg8N4AwYP9gm5ffetGZodMJ66HWaBKrjJZe?=
 =?us-ascii?Q?KkIxoJLhpnnPDnZIZYx1mFEanqVcQCcttA2s7x589cQBr9viy7yiH8N2nYeT?=
 =?us-ascii?Q?eE0KgNV5gB4h5voNOikuEjiKJhfwEKW9DF/FPtGZrkcoWvsbkUp7RSl+ixXq?=
 =?us-ascii?Q?vwoWeDV8YKo4nQzhXQFm56QNjm1kG3cnK6hZEJ78rNJ1bIwUDAAUZIg7Z4eX?=
 =?us-ascii?Q?AhZtDh1GnQ3TYyevTdfrKBDEyMSRovSph7RDH0pI/qX/Nhwfzh8p9C8F/OKn?=
 =?us-ascii?Q?6kHk/F59BVlRu3hBTkKL8B6FlABMCofX8fHly/QBfk/L+akr6hZoeGhwAAJg?=
 =?us-ascii?Q?XvgTZxcJ+C8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vVFWniF8HYahrQDML0ww5RhRi8LaS27ogOBAR3L2N+1iPGV8zzzZtsfgUS0h?=
 =?us-ascii?Q?PkTlmOeIgLpYbznPnH+P6ydsU/gVH2TeR2ek/nsPgqr7I/vQ9mBLytK6c4Lf?=
 =?us-ascii?Q?pYmhtl9XkrmAqWcPL2UNJOyUdmURED27Cd0/+mf5ZpAFbCw2jah+1F8z0fVu?=
 =?us-ascii?Q?q/vIfMQtdfoX1TeFOcCfXMxlzvJGtKiXYF+ELvXMnPUeqtSijnq23WrNBSD2?=
 =?us-ascii?Q?YPeDsIZBk17l+QmLrXW0DVdWkWhtc2KHaz8UQDDi9JB9yA6Z+n3bGt/UgESz?=
 =?us-ascii?Q?MGhVgTSRfefwmBVDf56ZuCZOz8W35RiqoCwry9yPnApvmDiao/QgYxgl+1bP?=
 =?us-ascii?Q?jSeLaIkMwzG5ZCM0PIEJqJ+uL/0iJkh0Mzsdlofsk1RUSNA1xpnsj9OaOh4W?=
 =?us-ascii?Q?7GMUy9rpuDx+dHnYDzUSelCJspd6X+1HM3NFPLR5/+uEczA53KN/cpvrQnao?=
 =?us-ascii?Q?hguheH2ac4rZM922L2K/JhqOUTJfuEf2mDqiKAECKJwF5LuOl37OOrpFOIMX?=
 =?us-ascii?Q?XU/bqtdPkrAYYEWpZZ//jWJc/6QWkwL4e9gD1r2kmDxrcCumGe7IoN0crco7?=
 =?us-ascii?Q?NSTL7PyLpo+iPa9qMZy3nNBgyjyz74gVhwUugHWRNVmEdmhEt0LYkQSSewvG?=
 =?us-ascii?Q?wcXqDbcxQ40V+n3eoWt+FyFro2/9+X0v50QIHEfsjz7cCs/IeNWcgBkF5p1X?=
 =?us-ascii?Q?e0r+Hmm5/wWumxD+dvwq57jfKjcB8DXPXCWhhZbXr3osF15tVojiqXhr65wn?=
 =?us-ascii?Q?gWgFbqaCCigxPmazc8q7hnZtveDjTCnJ1BT+JH1Wu2ATULGfX0icmEOpLXvE?=
 =?us-ascii?Q?aOvPs4vVVO584LWPC+fpMQ/3FoLzrgeydaTCUSH9ZgnXCOxohYltBEHYF1Jp?=
 =?us-ascii?Q?IxJH2ItWCojGELiNwDcVsFgIdXP+iKGZlMfoMj8lIe9hU1izMtgoMHQxu3ZZ?=
 =?us-ascii?Q?4fX0CA0+UFlf53M871Jzbpas92Se7Dct4nvNbWN5EjF7/eZv5ss85UIAXeTa?=
 =?us-ascii?Q?RqJ9ehtO7SmSdf/2AteM8oytRdfzo6yihzJf3JRwGZcfxe/2M3Mwr7KwQyM3?=
 =?us-ascii?Q?gomoNo+RUIvvJUkhJuqz6IPtb63aBE33nIb1RQg0o5eiYyDkeiucEgnOsSl/?=
 =?us-ascii?Q?HBK0HU9we7g8ls5JxgFv2Sf51Cwamvkn/LfkbnkK3S+UDIe0fqI3s8wfxaEv?=
 =?us-ascii?Q?Zi7a8GBkdYhBM5Rwt7a4BISz0q6+rEREpBdNv/O81zQqYfUd/3eGeR1rgkuL?=
 =?us-ascii?Q?yQlv1BK+wRh1lQHzPwnV/xtT/NrAbMEM+19Se8TCQDa42TubgZ5AyP/TBTyw?=
 =?us-ascii?Q?TkvmQkTnHZcWoF8ck2UCp1JjJo4xqXfhKtC0MS6+ZyJOGJXYpRGtWCSFLgCy?=
 =?us-ascii?Q?6Hg5HjBg5rjPca2kU2/p8gKcZF+iOG9XaiCeXpMCi9Po21STUySi8X8w2pmF?=
 =?us-ascii?Q?ExzSoojUhXa/xfC4MiGuMFCp9R9F4oXWa+zBTbDZYQgxxB4J0wuqDqQBWo4g?=
 =?us-ascii?Q?UB+tdPMDFfZCIGSejM0lJZUorQoGfQqKHaOs+vbOvsKoBc0WrjGjbFJr5BVQ?=
 =?us-ascii?Q?di1H8oy+F+dU6w2noozPAV8U4tFn5eVDRGnUx0pV?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	phozZAIgl4ayWe2V10J7leTERc8RNF6QT5WfYg2T2BNl6EXZ+QKcixuubjR/a97raCVllA7c/TAuIe7hA72z0xugTk3L6KfptsSuIfbcIa9Mbw93J2Vr05YLCWl+wZ2neo6XqmAWSLmEwGYWCdWmuuUflWE/ErzMVhBmL8RyVXKWUeSHcEuXawxRgrk6BXnEQaCthqQ0kyEkfsi6IgDTAoZbswxVKPTk5ZNqqhM6PaMhHXFx+VRXJplrSNHiIGmfv6rdhK1Uj8rza/HNUnoBy4lObxWV6dW0f3/93LNk/ieKWM6R5uKON2ox1v/izWzPa95t0Yh1Rm9e6Ni8djcein3HS7LxYNXXZXIDnWrOU4XiZyr+86jjnPJfsfBwPfxqJttthfZqnW/OhQ99ylcXVBmfWqaD2AMwD33evpk9WqGOpY9Laj/B9p9ZLr00Mfw3RGCTkXkYGwy6mzT+er27DgNxxTYGxn8vVOcg/D/1GimC/Ci2NpttMpdsmyJJLt1rWbfzWrd8QYYIe7SMUWbO8HyE1keK9S+Yt3JOZ8VjE753TOYWd0qckYgm1JeMJNqJJQ1XM3rypUD1n4GB+U81X881rQ3mMvn0b4wO5SltL3M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd2fb982-1fe8-4736-858a-08dde6a1dd75
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 02:15:04.0781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fxfHeIE+sWSlpllhhNj0FUB9QFtNUWuRKUMyEgU4axd344xG4MiGwcn4fbojISfd6f2IkfLequaj903Cdi5ylw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6433
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508290018
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxMyBTYWx0ZWRfX+QzNDu41y+CD
 GloLVt9arXmXXVvmyY5L8167/fjFoeQzWFJYUvCLrcsK+9f8PM8ijeTUQ1Fnu95Sl7o/jPs6COo
 sVQEBixis1AHxBymvejJjD6AbszStPs8u1BWOuNsK4TLWWqLWmadTlWCvRO/CulKqGxrqw8p7gh
 v2J0HpoWuSX13vOXgzHbqhmYGy60LoEIqp2mKpmZYNw2GxdF8Yv5/ttRtHmvc/vjUsp/qqztXtR
 JL8x7de1b2wJGRybIXX3Hfp0OxOSj8guXFeASwJnbS47uDYN0VR6K4XCnchcBjI3CzgCETBQwBR
 ZuU5ryWLJ6nW+hd2Q2LsZeINxEY0F54EP1gz96KbW6V2WmVzmLnF2UWpRLVYhxJxz1wbw5t6T1g
 +e4vWl24
X-Proofpoint-ORIG-GUID: BTl7nLCyK-njTU4IToQ9RwfEcYLke3QV
X-Authority-Analysis: v=2.4 cv=RqfFLDmK c=1 sm=1 tr=0 ts=68b10d2f b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8
 a=j1AEct2COPbnnh-7V7sA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: BTl7nLCyK-njTU4IToQ9RwfEcYLke3QV
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 492A0C000D
X-Stat-Signature: nmig65bqeusddgsj51dmjtssx5qpxejc
X-Rspam-User: 
X-HE-Tag: 1756433721-869702
X-HE-Meta: U2FsdGVkX19HG197oVWSvV/4eISAumg9du1a/LEVIv6EBIc+gkleSfPcXd7SFnEQZfyJPBSQt+ge7sn6s9hDHwxOPhMHRkUeAOLqwhqOWaAS30l9yZs2KuulaCf3ge8SdX8xzJfVJKN/mP2tudV664bSMppSM0OTzKlbBKRE/8l1mFtCIFslI4EDI2KlP1IEQDe+bBKzZFm4NiKen49+dPpEAsJUZOUD9Q3ZFIfBsEiRX9VtYJRsh831Nl6YAXtyvNCXXekE3nWPD9Zgg5UYf2vHyztQMNYkVurvo2H5o/uYjfFtyHMlqDBg6Enal9Nyi7QahvlYxCzWuRjl4nHKvPsQt4W7jiM3MO0CMo+iQhg5JET6x2uvf7jw0GrKR9/TnknpAQdx2zwj+s+jlv940EJlRcKpjvlLUstT7VGe5F4j4/UfqVuyYiDNYxOZH/VH4c16J0BAC3N9+1R9GSmzJ9/PVexIFL3XrJP30lYeQde5BUoDUChpPopqFHavwYFZ2SIK0SCpMIaCBWA2T6HavZollrf/2kk6J6GZyN/y/5mibVDWknqBR+KArD4utGijw5vZx/IJvFGk6Jkd12hNOLL0+2PJSVXoeSDes9MIT3ZKlb8KFDjhcvFg8TRPEYb0yUjzeszEvBnzBUvn2j2C+0lg9FiX3l+757nK634h7KUulrTh6r+ns4wQHgIDASSBkdCGaQkLiTfXwDJ+3vUVKvOqIU/zJmN+xBPCh6fxxBgO2+Jf+7c3sd6K7Qe18K1+1X0BDEu0hc5PO7C5rFmvVJlPfhBxoWMsZvteYvpgYSgKyEuIPu4iikGNfz3NkM28W7+rv2imyRbAzYrqUDj8SFRo3dY7cJdNiE+JJoLjfhyTT853gTDB4H7DP8YX+wloacYZmHvxJAfEb9ba4JyEsnQ14PU3lwZtNGhU7jVLjDOl0nwbHqebID4a0ljlVeNnf+FWXTZOD6wqPRCJK2T
 WYDkZK6D
 357qI2zE0WrsG6Fe91UeI+Y3+oo4gvPEkmOwnB5sx4LUoPUHT4skd/exgHQ1qott5lbML1c2QF3igZoWy6GCHamx+uESOij1W9cBeNIjSuYfPBQVrk4RGnjIfW3zTmd8hdBxmUiufFWPNyjxGhmmYKyJOCZS+5M/EGIONGpZnXOx6xfsG+ce+7HVBBiaJ2TLUD6PhpUw+ouXtN2Wf3JEcS9qPpThiZfCZqjFwcrWIyRvl4d9kDUpvaj7KmyINnIxdqfZttFttmmQ9DhnTbNkhgViWkvCHhhNfbZ1w574C8EMwczYGwRHUbrJsbpRX97kZ73MlrUKiqCn7jBHxrSLJUvXLbcq4bYtUQWg5H7atk19uX2erEU41SjIzWpGygUalyPh7Vskb2EqMpJMOev1X8KdH/g5bqiQZ7o5lhkEP2xD3RKwFG67fpgbf9NAHYvUrSlZlTh7r/gDVtSUWQtP5Jk0IJA90elguyBGzUWEUmj6kN7CiV5+zurJkmM9wEoLECSYguXDck3qBEPk0Cn0wSZeCFoyZTawNI9b2FkreP40ukEbfcmChivocMuoi3BOxhP/C7J8gU2AaF+Upe8KX2hrAaFUw0Gs3tWuw/IGyzyBS79ag1x93GC7DganCjpUtFVeecnottQ5J9rR/W+oE2alRw73SkWuTjJZZJbgLtUBfMbhrjs88lxnbEHaGKkRJcqddUQrifjcKH6o/BlCx0nowWitqxHImYxJPrSG1Zcn54xmJ+XkTmAxK1cugTliPZcxTrtJvHq6v0XelswhfJp6Mb48dBIRT0SrVRnA87rfpuRHs+9hkH8s48vBxcIbTXZFUJpLsmRYPNpSFoaZuYb6mAA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 02:23:15PM +0800, Kuan-Wei Chiu wrote:
> The comparison function used to sort stack trace locations in debugfs
> never relied on the third argument. Therefore, sort_r() is unnecessary.
> Switch to sort() with a two-argument comparison function to keep the
> code simple and aligned with the intended usage.
> 
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> ---

Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

>  mm/slub.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 081816ff89ab..39a238384892 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -7711,7 +7711,7 @@ static void *slab_debugfs_next(struct seq_file *seq, void *v, loff_t *ppos)
>  	return NULL;
>  }
>  
> -static int cmp_loc_by_count(const void *a, const void *b, const void *data)
> +static int cmp_loc_by_count(const void *a, const void *b)
>  {
>  	struct location *loc1 = (struct location *)a;
>  	struct location *loc2 = (struct location *)b;
> @@ -7778,8 +7778,8 @@ static int slab_debug_trace_open(struct inode *inode, struct file *filep)
>  	}
>  
>  	/* Sort locations by count */
> -	sort_r(t->loc, t->count, sizeof(struct location),
> -		cmp_loc_by_count, NULL, NULL);
> +	sort(t->loc, t->count, sizeof(struct location),
> +	     cmp_loc_by_count, NULL);
>  
>  	bitmap_free(obj_map);
>  	return 0;
> -- 
> 2.34.1
> 

-- 
Cheers,
Harry / Hyeonggon

