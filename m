Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53115FD3758
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 13:33:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2F346B008C; Wed, 25 Feb 2026 08:33:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE3A86B0092; Wed, 25 Feb 2026 08:33:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99EC26B0093; Wed, 25 Feb 2026 08:33:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 89CDA6B008C
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:33:01 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 21753BA350
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:33:01 +0000 (UTC)
X-FDA: 84483069762.19.888A13F
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11022137.outbound.protection.outlook.com [52.101.66.137])
	by imf29.hostedemail.com (Postfix) with ESMTP id 24CAB120012
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:32:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=bWYWlbiS;
	spf=pass (imf29.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 52.101.66.137 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772026378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qapp5QrGWzFkBIOw/HYie8FsZogyJWll8ZQKWtVBe4o=;
	b=D8Sh0dMKobO9gsPEn+uh1VWFcQVV4TBX1KAgBSCBhymSUYefbKQOiv53vAeFSgiuk0zKPI
	9N3NsyBoUhQ3HpJM1pfHwcnQfbEI6+uJL0aOT0THCW8tPYMVAG6b7KdlSZ0btxi1exa+ch
	9Um6rZ/zKlVQeE5Jn6SwXz3VsiY6pdA=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=bWYWlbiS;
	spf=pass (imf29.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 52.101.66.137 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772026378; a=rsa-sha256;
	cv=pass;
	b=li0IeeDgujXpBSX+xfQY0bBBixjli5D2ET0rWP1uEx3Fcsd8i3tcDGXNdVabERpRYWcM9d
	Zz9thGWyRauOC949kT8DXXmgMip7HDK9lo8bGUtCdDG8DradCNp0fJbYWHoM5gvDHTDZqx
	AMJgdNPRvxmRBRGEKsyJvdBtpgheLM8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=roZFb1EaVWflcb/SraM4p6u5+8vIIHu5naigOJTK8rio1GvYiZPx7eheh0JoaBd8Yru9KLABEsQSaElcBTzorlTFc4VouO7Ia/FTIgpknMEZZ31VUCA1XxfQrMKENvbggsxKj1FcQNdsCDA4prsC47PJiV5QAhWxq1vRU/Yp6UAoA52BhNABrnJ7zexTNprNenGCo4HDae++cDjrTJ5Md3OwgQgpPglzMx39FMYmF1JUo/oHAdoREICGNHaJFgJYvzyNxJdO4ioEbJnRcR0h3LcFcinb3T84txXxAJMggFvbXwHtnFH+IKpfvdOv6subk4aAU1gatcZQw73dyubBTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qapp5QrGWzFkBIOw/HYie8FsZogyJWll8ZQKWtVBe4o=;
 b=K99rS1b9EFtfCti1+wfqz9d9c2sQARzZI4xPIkPrRJ76B61Ygmi6HVjA7D9l3CX66FDUQp0B4Qk3tzzf96SJfAxa2liHn7eQJ/nPOiRV77mXk6V3zL3+vnem/P5TnK/7CMozFp2+vRmzeDd0Vxn8ffggv0n5lU1ZKGL1hH7qLcleHX8K4rkrzGOnCo3FfKq6EryQiLxEXtwZbdU02k4UzMbsicm8tvQHSMTF+rtIvTuCt3dvZJuRuSgJEGsaCc5xjOCT2cuA4Zma7ORKzS6IJ83pkg7RJxFKC6CCQExpwUPqXNR3Sa+fd7YAcw49vxG1+K9Zqit17rbEbg57MVuJ/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qapp5QrGWzFkBIOw/HYie8FsZogyJWll8ZQKWtVBe4o=;
 b=bWYWlbiSyMH7RrfkBXYFCMDupXz/1lDlmWAgaS84gFprst6MyS54G5KXMPTTvsYngKJ8iiU5q4NbJsFDi5Lyxm620AF/Pk+X68JmvmHQvDwdBJI0VN27fDhfnOyu2NJPj24RCdUfox8uiO7tkkG7V9o63yTCwQnIt5k7+ZwKo+KY+hPXqSvvDt9ge2BGT7Fokjd9hNb6ZRP3i6fVa5CnifsHO+BsAyw01bGv6PQm2qyg16VjLJKckhZyrGaP2xkBijQ3KMgCyC1meFb8U9LE9993Rc5qIHbn8n2vOvs2gtdJB2TAp5ECHkrjGvj7SG2WVAasPlNdSqkpvJdSE7JEGw==
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com (2603:10a6:10:471::13)
 by GVXPR08MB11715.eurprd08.prod.outlook.com (2603:10a6:150:317::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.23; Wed, 25 Feb
 2026 13:32:54 +0000
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::3470:51d7:36e4:36d2]) by DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::3470:51d7:36e4:36d2%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 13:32:54 +0000
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To: Christian Brauner <brauner@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Jan Kara <jack@suse.cz>,
	Oleg Nesterov <oleg@redhat.com>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Andrei Vagin <avagin@google.com>,
	Kirill Tkhai <tkhai@ya.ru>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	Adrian Reber <areber@redhat.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v4 1/4] pid_namespace: avoid optimization of accesses to ->child_reaper
Date: Wed, 25 Feb 2026 14:32:23 +0100
Message-ID: <20260225133229.550302-2-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225133229.550302-1-ptikhomirov@virtuozzo.com>
References: <20260225133229.550302-1-ptikhomirov@virtuozzo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0277.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:84::18) To DU0PR08MB9003.eurprd08.prod.outlook.com
 (2603:10a6:10:471::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR08MB9003:EE_|GVXPR08MB11715:EE_
X-MS-Office365-Filtering-Correlation-Id: b70247c7-de1b-42e4-7b72-08de74726159
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|7416014|376014|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	X+pn+TPGakuFt7Kr3RMUxdJUX8N95F+PtkihU3pugj5npJIdmbRMMIgKFSeW8TOCVsYuJXXm6gJPrGa3V+9ncwWpQiylvLdX8UZXNpGrwBN+kunje20NndJPYphaUexuq2nOS3gycqvkMTkqoDHYzXfYx8eKVI4HoguzZ2ygtiFZ44wveACX3XpGHfUue80MQnG2xEawJHz/sXmNA4Nc3KUUtyyY7V+Qg2B4n6X2A1Yzu0BMgUWv/n0sieogjxLvpFl5k2BXFwDeEADwUaDA7bs4b78NKXLpPWMYWTdswvDRszyfWv5wFLa0zQpBMVpEpfGfj0na5hz5eu93vY/SZpJUzA5OGUIDXhs+LPewmFVUShMOrbDjkJOhE3qoO9mqBIE2HhYUGYtmlNBEuuFMyPfLNlVgKuzQYGO33xBqoyHWSrWD+077yFj+GW9F1At1ca/ideJlqQ8Uj9kmyTI8ZOmJ0Plc1E+z1sMJ0XzuHb/s3LH/BUS+fV6xMYrxKGtFj9bBjfRmcH+0jnaQoZgr6GB7p+KOVwyy1NNc8p0mOC8gJeltqmC2ZtAe5xRWbTlPuFjAoqNl0SuBO/vJbpobOL8Wf8IaF7H4RgecppbpIKg7bBlN70VlrEXk9p92MeKG8gvVvdaoms7cvt9ngAu0NnjYY3iEWoUnZ5Vl/Xs9elEWaei1KlkPKPhmxt7Km7UcSdi8wO/X11jiLaINZZDHLdGH5V93q5K51+g0CR9G0F0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9003.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(7416014)(376014)(10070799003)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3A1nkGfLY3jk9utHCcWt0nO9mczjdBy6y/psGaujxKjTV+em0Jl10KgTqz+P?=
 =?us-ascii?Q?9KDsRuF+vxY48Ijen0lhKrefa2AUW/Y6+sIqqJxHxBEW/3Mwa96DYxkDJ2My?=
 =?us-ascii?Q?ycFWPsSYNlMwuZBwwPh1BDqjWIpBak3e4HO8rIBFgFTXs2UFJGd1TT40koEb?=
 =?us-ascii?Q?JSr/EX0TjFy3KnrX5E6rxmefkA89g7buR1DIFsG0iCvzmy6SDlR5VJrBi6zX?=
 =?us-ascii?Q?2+w49uu4G6+0tLpjsZKfgWAi+r02drekgdKBZ+OPVFJuO4nzKPD+0eKY+9EI?=
 =?us-ascii?Q?IYMJY00vnoDu1VUatj3xrtAIAr7761iwS4lh4mXkbEon/8+0T2ML4oRujmM/?=
 =?us-ascii?Q?Zm+mrevVk5k+Qwtak3n4JK2+qVfFFI6u1iSOU5dweLZqrcfa9LI4Lwld1DFy?=
 =?us-ascii?Q?HQEmks3xrp0Wc9P39YRp161rCXtiMYoytMcEfmBzBDa9j3pMRidCNErMKEkw?=
 =?us-ascii?Q?NgVjOzFfewygQDYlQFf2SmT1b+sVR9kret64O0jjNInex0ERq//vXwYDFXWc?=
 =?us-ascii?Q?kEanENL2SaVJsSBiS9gBQXsUomyb0zgLE0TCanZEdJWKQgF6V7VE/pQUjVvu?=
 =?us-ascii?Q?rwjsXO+8DTkMDxvBanlIOKxgQGtMjI8yfPDVZsfBKDIwr5AAZ409AT3qCJ1P?=
 =?us-ascii?Q?STVdugzN3r4PZQ8/CUgAhA/J1raPF8rnteUB91f9qaWSitNkGmaKk67KGl9i?=
 =?us-ascii?Q?vcNDvdWBMs5dwI2sMgEil1lqW5+3NIh/DwqIEdg3LZoQ+ikatolqbhAc1w5V?=
 =?us-ascii?Q?JEvFdcK3ah7yN1G7/tI3BxSmYjS41MGN5hOVqTrwFcf1QFQvlG6wmtUnSfb6?=
 =?us-ascii?Q?BJ/ubpF231teOzdG0726DaB22159FvvKC3+afY3vGT1Qq/X0/luef0wbV5RW?=
 =?us-ascii?Q?LBc88NJOGmtFdUlp5CF5L1GQYT4tsagQ6NfjJxhw4eUlxPUt5tXeh5XnMp+e?=
 =?us-ascii?Q?Dx70pHPfLI9DPifREYTFXvenGwP2z7Nl2nZ8NdhbBbxw4LwMl85C+DtI6IBs?=
 =?us-ascii?Q?M/Xw2SY6pOTdiIbilcPi1f6y3iyZd8IQYv2BO9J9/AlWgzndV1xRc1Hki6KF?=
 =?us-ascii?Q?C/QDVrNQwxSvix4GL3VHP2lUkehptpM5G5GimdsOti+Y/nl1dHqF5wXyqNPU?=
 =?us-ascii?Q?pWb4M373XZCylfmxt+hmdQmLtm0gAsBiEFeRjFl9BqW0qWDLnsfnRkFub7Pw?=
 =?us-ascii?Q?nmK2WraOk83/9DQfBhSaPfIGGN/OVOUCYluRpk6ypcb0tRuwO49O2Xi0pD2K?=
 =?us-ascii?Q?M284G7xtpn5bpG6/Jo6Kn2MRhEl0ZGWlI9DznxqQt0MPYv4zkAEMsvCd22dd?=
 =?us-ascii?Q?Kga9VhR+4FTpjBCzyCf3JPjRPF4v83xOtSlg8kWH076RtEt3edaqjismv+CK?=
 =?us-ascii?Q?GiWRkpZeQx50ARWdFKaB3WQmQre6w7rpxzgQWxUtLlSBl8vcB8sv08itiPgL?=
 =?us-ascii?Q?kcq/gry+4yXrmUl4518sGEyuU0SMbANc4r8lA8HEm4LPyr7Le243EsbPLGsP?=
 =?us-ascii?Q?6L+ScvwiJJHw5t1zAr5K71YDqpRHycoxIwA57OHiwWRqMJZaKpgbdbCxTnZp?=
 =?us-ascii?Q?2JAxP3h3hmpBa6ypQFc4nAop27lm/O+Z7d50fWnLjvWptWtdoJKrwd5aoTg4?=
 =?us-ascii?Q?/ibPCYI9Irnskf/ix70+8IOxQmqRmk4iXNnwIcN4mXz81XRHq73gV7h1aXun?=
 =?us-ascii?Q?+UwAO3wQPp3j+HP++ptnKLbNclW/CzMkQCgN4gHhTOOiM2emV+s82yZQ8xvi?=
 =?us-ascii?Q?RfL2sxnukqwJTXsQ4PSChfexnzTQOTR4tKm8MkqdmyrzIWty0Nnks+8M+yv/?=
X-MS-Exchange-AntiSpam-MessageData-1: rPnERm+73XGU4QFZO+Y8OLJeFHjw+iG+voc=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b70247c7-de1b-42e4-7b72-08de74726159
X-MS-Exchange-CrossTenant-AuthSource: DU0PR08MB9003.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 13:32:54.2705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KagdIvOeN4i49o4uCe/6VTVCgKSr35GYdFYMxpq4EbwZ+aSLwxrkdFglwY+zZtn4ZS7jH+iMyPUYLuSvgxxqGNkCphSlT/qIGpF8HmddDwA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB11715
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 24CAB120012
X-Stat-Signature: me157us7n5pjffrcfh37r38fbjb3zjup
X-Rspam-User: 
X-HE-Tag: 1772026377-524347
X-HE-Meta: U2FsdGVkX182D0nBb9ZlbJdX6RPFWOcS7FdRCCoaLnXNoGkp2UAbt91lFHzYTw9vY9FcxuVdWYg9DbJHyM/+jJa7VQewGoQcq7Z/Z5er2my1gsGwf81ALOzTgDK3Rw2LjI1lko/Mc9nR3DRUZC6aR2LqWOPhqqL7DB3mU+fIeXQ+hFhgaKAtE+IDKHRQ62MU+ocSgb+8yPVXu1ejnCZKAR2BgCH1NU0M38bwZCmdizMZu0BXEGf52DfRg6zRmMIzZ0Avco28nN/stsKShUIkgCP+hQVKXzubo/1Iy3YBzYr0/Cio+VVvBPY60c9l2Fj1d2HLmw4zbr4N1dKbYgloQX+6wcfHSWuTosf62LBe8COXMgb5bkMgA4FgsOf5+9HFznzoujCkZUEg/Rawh5j1SVVlQ1cXt+2w4nFFkSxB8QgRcfZkkLxaXb7+MN8N9vpVjUlBYElWEhgD5qBqvfwO5s7in6bhdE5q3prxof+PySWXJzn7p38nf0nntTiToLGOYJPjA6S2iv7O3tmuMnR/HCOvgXrYCm9U8LNOtFQz/DqsaqXWSJxGZYulRwpe5MBT8gwdP6zcjl/mkRx7IoCb66fG7hy4uhTyLIGFoQNXkyLCwSG1YEmfRVreBrBT40ZoHjubHghwV/QM057aSUYTs4EJprBmz0ewkNiRK68SQCyKtTzUyHmvD4hNhehDtm25Yacwez1LplWQHeKqK2b9nncIwp/i4QE8aXsSMyw7ZWhl8jjLlKUqNylC25wCulJ3ALpnCN3604h9ZtRIMLfactvrOLRa0/9hBOD+l+UNZbCgOyW0zndPaQQs/cbl6NzGu9aV/WnYicRgv4/+n2Z8YgG7fkGM+F67bFdq99z0F2278gafRx+DYZkKdB8heVuJgdTYP4i7VZSvTxJ7B8Bu24ReQ9oBm328H83ZBT2uZJJyGTSttd4mmC2iVCaLm4SzRiEY7w+peS3r2wb1ujd
 LCP9ihCo
 dWMO7a0SeENuREYci4OWd1i+o4+FBkgrZz4f17OZostuZcvkB6prg/cj3K15QnZ6/Bojy/Cx3A+GI65aZiNwM+pdaM6fELRmJ+OMTG+Ik1tzzpgPkYMqNnpuMR7WUb4j6Qg12xWOeNNqZ6Tp/opmH9k8GC6FQb4+pUEMU+C3Gpyir7NQ3FvQ13JSQCVizbgHeaUrJaqHWRvG/yqESQlfAaKW5iZKRO86x4H9wEqOaicLw5RgRb79caMDcrIegygUb8YQ6aexofzeiXsBmxH7xggmwIa6iIBpGq1ZRAoVB0iUz6zABL0H5LZxO6AjHOM2bRy50RiUhWs8mS0uDhXzZhrKVR5pZfC3j44PenanJ+RV0JLa0v7L5S/bsuhiToFLwBWN1gSI6Gg+4m7DK9kULD9RrcO/QX8LwkizcQrmMMg4ufmg5nip09fNEa1QZBF6RZllQB6ieTRwlEbaYM82jI7P7YHQD8WardftCcOW0geMJ9Z73hWxspb42mlPlpOaD61R9Q9juKdJz3Qf2Fx4FGiw/j3aAimcRd0kA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To avoid potential problems related to cpu/compiler optimizations around
->child_reaper, let's use WRITE_ONCE (additional to task_list lock)
everywhere we write it and use READ_ONCE where we read it without
explicit lock. Note: It also pairs with existing READ_ONCE with no lock
in nsfs_fh_to_dentry().

Also let's add ASSERT_EXCLUSIVE_WRITER before write to identify to KCSAN
that we don't expect any concurrent ->child_reaper modifications, and
those must be detected.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
--
v3: Split from main commit. Add ASSERT_EXCLUSIVE_WRITER.
---
 kernel/exit.c | 3 ++-
 kernel/fork.c | 5 ++++-
 kernel/pid.c  | 2 +-
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 8a87021211ae..8e5e523dcc79 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -608,7 +608,8 @@ static struct task_struct *find_child_reaper(struct task_struct *father,
 
 	reaper = find_alive_thread(father);
 	if (reaper) {
-		pid_ns->child_reaper = reaper;
+		ASSERT_EXCLUSIVE_WRITER(pid_ns->child_reaper);
+		WRITE_ONCE(pid_ns->child_reaper, reaper);
 		return reaper;
 	}
 
diff --git a/kernel/fork.c b/kernel/fork.c
index e832da9d15a4..9ce2d12ec701 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2423,7 +2423,10 @@ __latent_entropy struct task_struct *copy_process(
 			init_task_pid(p, PIDTYPE_SID, task_session(current));
 
 			if (is_child_reaper(pid)) {
-				ns_of_pid(pid)->child_reaper = p;
+				struct pid_namespace *ns = ns_of_pid(pid);
+
+				ASSERT_EXCLUSIVE_WRITER(ns->child_reaper);
+				WRITE_ONCE(ns->child_reaper, p);
 				p->signal->flags |= SIGNAL_UNKILLABLE;
 			}
 			p->signal->shared_pending.signal = delayed.signal;
diff --git a/kernel/pid.c b/kernel/pid.c
index 3b96571d0fe6..76c2744493e2 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -219,7 +219,7 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
 			 * Also fail if a PID != 1 is requested and
 			 * no PID 1 exists.
 			 */
-			if (tid != 1 && !tmp->child_reaper)
+			if (tid != 1 && !READ_ONCE(tmp->child_reaper))
 				goto out_abort;
 			retval = -EPERM;
 			if (!checkpoint_restore_ns_capable(tmp->user_ns))
-- 
2.53.0


