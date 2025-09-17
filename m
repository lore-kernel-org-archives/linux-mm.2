Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A194CA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 05:37:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9416D8E0006; Wed, 17 Sep 2025 01:37:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9196A8E0001; Wed, 17 Sep 2025 01:37:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E0F08E0006; Wed, 17 Sep 2025 01:37:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 659288E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 01:37:02 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 187721DE6F8
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 05:37:02 +0000 (UTC)
X-FDA: 83897633484.17.0AE21DD
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7A174C0009
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 05:36:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fctkTSRx;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=NUk5ynaG;
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758087418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=19qc2+LFug1ai2FNQCP4p0amH3iDQP9qCMxTVjIdDMg=;
	b=vmmOq1OezWUmOIi4p0Pgxi6KPJHImmDwY0zYeqa13UevySEE2RQRLQSxK7TicP0yRZTxwr
	kyXkV9Rccq+f9PSVULX8woMbDhjAeEbx/9DTp2Wn+FxAcVT50CkSUOKDuUS4WOBPVpEhoG
	9LsEHBrlf1dbueOGGy3UUkeA+zyJELE=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fctkTSRx;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=NUk5ynaG;
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758087418; a=rsa-sha256;
	cv=pass;
	b=rXreNbfOOlM7d6TU4X2nYh8QjwyX1WqaK6VAgGM4GAvN72XTIwNBajKhkZe1RESEwAkJj8
	/qMJD4fDqxGc46RZ6R7aguXm9WJN5thiBaTidyZM/CCCrVBEi7wvaEEn0Ty/ueWuQ8z69O
	6cSvIe2GxZvCIwDDkwqJGpGX13feZYM=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58GLdh3w025371;
	Wed, 17 Sep 2025 05:36:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=19qc2+LFug1ai2FNQC
	P4p0amH3iDQP9qCMxTVjIdDMg=; b=fctkTSRxmMQqYi2MgAN9wjFG2BmnYclW3l
	nTVwY4g7jRqpYQQs6NgjfsSa/hNP+R7B7KxKhu0XaljZCICT8j2EQCezShtqtnXJ
	/Y3R9gxuYkZgDqiTNCuGmm+b70s2gVjVxKjoMlCXZeBqToapm8gcpAkf8CTH5uy3
	lqpiwSWc5Bhdus2+A1e5jCrqIgfd7vgZ5dcHF28rcJuuG3G5Kv442eBeXdH2T0dr
	BRR+682AUh73PxQBcvBnss2yzm/5IsX9Z16TkTzwI1Y940u0/Is1mMsXaqJCW4wN
	I9KrN73Jz5pTQJaA20+WnF/nlMcSoh2DZjDDbBEg2CT2fb+eNTJw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497g0k8e9c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 05:36:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58H51Q5C036849;
	Wed, 17 Sep 2025 05:36:40 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010052.outbound.protection.outlook.com [52.101.193.52])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2darhu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 05:36:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u1tBmLENpJeKV6iq9OYaB4CcL+2tEoZU5z8awStW/s57d/6DZPpWKM0iGKu3gRvKEs4p/Q4Qu6kOqN1pjVvh1oz3X/FRYVhNQZ2ilSdCBg4wTSfWtwZkEMecf6RaUmufhPhe0SctCZ24GYaiZYAIjOCa4QNCtknli+c0OoQ6gFG3WS4XzakKtjbbjfFyyjuM/7IGmT8ZaMq8v0uK+TfvFope4RpNRMs/MmCx/ocXybbjMo6sGXfqkAjoz9MzRsvITSwU+mBVDTUzaW4Xjn8dP2BllgyueK/OxSE4+HQjd9uEnFN92nLGY5M5iCrfC1Pj+MorTiTZDErloLmbToJJIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=19qc2+LFug1ai2FNQCP4p0amH3iDQP9qCMxTVjIdDMg=;
 b=oy3xPvfjjPq93W8lbksPJdGz8dTQ4nsNrTUBvQ5wbupzmnnYt2hnkmhFULSlZd3BJKFWIWpodp6gZLhpTzz2Y4yRykQZ0twgDamcbQ6MzrWbmKqoG/nSFcNm2CysUBWrQfZL6pJhhDvBJw0RwZom5Fw9oz+0O4bqjb+2ZYlbgtLC2ZW3CDIKJGfvG+7uy3wYpICtEZQlw6r/kBPrYLpiIDBtlGz7twayLBP6470wgB7qLWiEp2tdQJLIQRE3Lg+VMuMuNebJH0U0WejYpALI4UPtATckByRi8aF1r6yeWQJYJrFD2S1A6lBt0JkeX539L9w3JbDymh6/qlK/HUxsfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=19qc2+LFug1ai2FNQCP4p0amH3iDQP9qCMxTVjIdDMg=;
 b=NUk5ynaGGJF4/TZ9gEB0WBggGny8hr/JAtzZxOCT4vdWPRta13u9GjiNIM0ANwT93xi0EUUogf1pW2GuU+zTfVMsx0hdSJkMazdgW9SdoCiemUjLbdoQvem/jZ2gZXQhrvesMQLEcFv6tj8UTIC6bn2lTiczSv2pun88DzeVxGQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MW4PR10MB5776.namprd10.prod.outlook.com (2603:10b6:303:180::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Wed, 17 Sep
 2025 05:36:37 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9115.022; Wed, 17 Sep 2025
 05:36:36 +0000
Date: Wed, 17 Sep 2025 06:36:34 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kalesh Singh <kaleshsingh@google.com>, minchan@kernel.org,
        david@redhat.com, Liam.Howlett@oracle.com, rppt@kernel.org,
        pfalcato@suse.de, kernel-team@android.com, android-mm@google.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Valentin Schneider <vschneid@redhat.com>, Jann Horn <jannh@google.com>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 0/7] vma count: fixes, test and improvements
Message-ID: <e85d0b14-28dd-418f-872e-57c0127ad572@lucifer.local>
References: <20250915163838.631445-1-kaleshsingh@google.com>
 <20250915153401.61cbd5120871ee7a4e5b9cae@linux-foundation.org>
 <aa95777a-8012-4d08-abcf-7175f9e2691c@lucifer.local>
 <20250916191645.15aae276992acafe7f7e723e@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250916191645.15aae276992acafe7f7e723e@linux-foundation.org>
X-ClientProxiedBy: LO4P123CA0459.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MW4PR10MB5776:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a1ffbc2-aff5-4658-c8ad-08ddf5ac2b5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SkJn9TnpBdUxKeiSPTykAfw96B81shdI4lwF/+9q5AR3dp+PQj5mGMi0t7PR?=
 =?us-ascii?Q?lmcoWfVYplfysOtPIYoy1T8cK2UkEwtMJBbbGHQTHZ7nPoIlnGKuzXSarjcb?=
 =?us-ascii?Q?T36JkLB9JqraN3akxB2CbGUA9YX2fFMH3og0FP4LYEC2sQHj7GbUGGNglt4/?=
 =?us-ascii?Q?r38fZCaPxsGSdhfBnLTZqc5XzbD34rCPVBsISdaZMHVOjsO3iRjvTJXQdC8O?=
 =?us-ascii?Q?6rbI9LIM381aTbIjGntXjDn9jVVuICuc7IkJ49nNvvGIyDpUIAMpWwWJ4b8l?=
 =?us-ascii?Q?IftqcXR3Qe5dRIyusAF1CqNPk2hqjO75rMwX01qBscLQsu8HxGTK+qAC+kMG?=
 =?us-ascii?Q?Jf71MSGYWUqnDDRZHKT5nBFJ7BAxkahKmbXVEMFbzUxrvha5xBtRvQFOnNYd?=
 =?us-ascii?Q?xk2Xk5G9RHl7bv2iTnnd9CGD3Q/xSpocTLlnmjeDMCO4G2oBe7NfiGGVwoQG?=
 =?us-ascii?Q?Gnd7H3JwxrQROiD8LBzKMGjfytkHxrNXDTvyr2okFbNbSgM9eb9Tv2Y8P4y4?=
 =?us-ascii?Q?khpobBBao7tXH9Spud/1j7bOCJcp9QmJJkts3TRBPyPWvL6PWLw9mdDJdr2i?=
 =?us-ascii?Q?2Ujfi94HHSNBTpoNwE1Q9+locuDn9jaCK4JiI4dVhR1+yH6iHzaF2fP64pRK?=
 =?us-ascii?Q?PT4nvdlbKrOFYcTTVvHVYlXNGXDl9QDi2Msi72HRxPtsZ7vf0/ypol1HJYT7?=
 =?us-ascii?Q?t9kqOwbFAUcYIs5WUCWYx5AIqRip+nDIqulJDe27buhFj7uCBnD2+Q54wyWp?=
 =?us-ascii?Q?ztAf8yEcu7AMyAR2TXzvH39Ms57KPNsUOTZL9qGkmjGZFRAyyxV6YV+y070l?=
 =?us-ascii?Q?vJBH3zKKICM6wLfQbrSIJ88xO/+cubnam/y4+I+f/4glzc+eLm57LZbXIS54?=
 =?us-ascii?Q?3G8CzamZbIEdidLkj7dhj5FiRRPywKtv++vaU0g84guOlbzrW5WITqwU3zk4?=
 =?us-ascii?Q?vHElYvfO0WA8j0/gzIO/Yop9lMqfwQQ1hpIdUbwCVPzk4cXIcTYq965Aela3?=
 =?us-ascii?Q?I4FTlc9sYr8ic7vP/KLqrYmQEUmwY+zwx/vcsJEGHiNhg3JOODzpgk7ZKIM2?=
 =?us-ascii?Q?VbjXGmX5LYMxZmWd5WeTNSwwUnwGxX3dv/MQ+xR45P2ntThRRDEicTrsEgxC?=
 =?us-ascii?Q?ZxCZzSHsu6SwqrwVTtINuAH+7mM2SYIA4mocUyX4aUl/5yT24iD03gMKBM9d?=
 =?us-ascii?Q?gdJjnniUoQoXcBCXDJPQpCmtxg4qqSg0PkZRqNZo5JOEMcNMTvw+kU7cscfV?=
 =?us-ascii?Q?Qa9444k0mvjFWL0bcf3vfGiAq2xd3DJ867xBlBMKF3zHD2qx9Gwxjbm/guqK?=
 =?us-ascii?Q?XBuFjkp1DzHowcRyPNB0oeXlr2lyD4q3qewDqf2O2zjio4jni6utYEyG8ieC?=
 =?us-ascii?Q?IcaUh2Z/eblXdKfRE3VH+5KjKAIAZbN5BAspKo3jZoATjGbEa9+hpPXfw1xC?=
 =?us-ascii?Q?mrjXHccDL/8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dH2w1CZDHXORg73e7GibTy7QecTz85URVD+SGKNAPVPjlL5p3MjgttwJlWtW?=
 =?us-ascii?Q?aG2bbxEtvl2piUvZpYLhYSZY8R7ldFzIj3k4jT6YPGdas/HOZmGMKWT5bJ0a?=
 =?us-ascii?Q?z5W9zltF6Srh64WivU6rkEJwA9TfHrJvy3yoaPRnfbc0N3jU/DAo34+8AV87?=
 =?us-ascii?Q?7yoU0YdY3B0mv8cgdTKMjEc0k3IZsbRhDScdoeoaLefFG3XmYGlBTQIcwJLj?=
 =?us-ascii?Q?W3gJ20L5CdxDcKeZZxatCDxa5smpLNHcQZtMiVhxn2E4uAIFPPuiCPo6io97?=
 =?us-ascii?Q?lvSC/vuqYF/IsFdoVNfc+EMzxFjuD53sSEJmCR0ruSRZuVhhMLybDPU544tD?=
 =?us-ascii?Q?M7UUo1cHIp8/MrG+V7fPaYPc4tte6mcXsl+TZmjEguzhcw5sM6/TsHSgzPdS?=
 =?us-ascii?Q?TektVKtwbXgGfAmencgdWS2CfW8TFmy+U0LpgV7ayVJjgH0U5rQlO0uHaBa0?=
 =?us-ascii?Q?ifc2IPOcjSMDw8akik1K76ZNZmChDKPlaAcAREO0WOYBxCfSs6fKMYx/ipci?=
 =?us-ascii?Q?S0b2rtJ14Ul/BLhkVuccgvbObTUdWVOsTOwXKuKA0QuDSMQeOQcTzIdbqVNF?=
 =?us-ascii?Q?bUJ5kOpDM9JdO++vlvQYbbZel2Eu9E/YVmsm5D+DYYTS6tttGfuysGS2Ccp7?=
 =?us-ascii?Q?BHNyZEbpOR4p/jHtbNXd1T/AN+cgCPeiVH7FR+HtpDINV2UkeQl7IlHnWp9s?=
 =?us-ascii?Q?dxi551Tp6cZvFz4vZxJw2DGuNjTRDLLrK5CMxpRn6+x+LeI24QX+SsryKHeX?=
 =?us-ascii?Q?t1o1BOqVcx03IYlCPW4dzdpLdAGAd7XMpMc464p8OCclfvXdLwSsy05hOj6B?=
 =?us-ascii?Q?NEjU1bwCqeL3VW2q88mckXxq0JvVhFE06PkK6kT/J1e/wYuYt2wPkDf9eZBw?=
 =?us-ascii?Q?8BaiorEKeelroPT64Rz5wNmiidp47XgqeTRRpR3BcuipN80MNwg6v3BAY2tf?=
 =?us-ascii?Q?ZcFXjkGkcG1MxCEWpJsZp3AgtoiqBvMQJzu7IPFMVw6CDCsWJV55LX4wFgD4?=
 =?us-ascii?Q?i5urIPKdR4iH91THBwOoA9gMC7+80ArDxwkmSLKHNxMguLAsdfQpyvFfBeZx?=
 =?us-ascii?Q?c6/QbQYUU91kjVmkjfAnNI9YhuNxNbcfdN3ZTPzuLA/eAoClAbaZebcrx2iz?=
 =?us-ascii?Q?N9/zHhIZDzlqCh1cXsfEwZ14lsswMJN/pXWpeTJStdG1QzYUwnUmwfoF5AJo?=
 =?us-ascii?Q?X4hhFrZ3X/I9ALNNvmvgP0z0y20t/h2z6jRlI1NpjpgLhHJ8KMSUUMhC5WgF?=
 =?us-ascii?Q?Exh9MzA1bNEnRq6CJUPvSbZj3aZkvz4Tuf5VvgwJieH5Tc2DZ/qK2rWjawl/?=
 =?us-ascii?Q?BXGowbWbeZ1Y1jlqvY8mYycirp4Sg1Ebr+Cu9qMlPuQIpyOiC3AlYrwGGGIf?=
 =?us-ascii?Q?f1cJSPVYFkyP/ZkbSpuO/Vf3PR+lxKC9PFdxpoSMfXuhGjBz0sYTsxhnXVBs?=
 =?us-ascii?Q?dqmqhXijfTke+0hleWxil+TE3eI5ZjcCG82E0cujY/u1xUsDPSRS5iHBIMLg?=
 =?us-ascii?Q?r7VzZjNu3Gf6mwPXkNx3yiVe2H/hjJEFEuFhevZCxXPoVx9tcP98+IvPZs3Q?=
 =?us-ascii?Q?Q/B1TGUl0GGU95Oc26Mb7tOVwj0YlwgctXyrfmP0RT+Ce7jll4npNCv3i+2p?=
 =?us-ascii?Q?pw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hK+CJA+VyB237zEYnX4NGpdDZRgOOxZmp+v4elgMXwoJt27tLplNkwfyJC/hOldUgtOmh6MM1lVaAGpuJ6N4+LJe5MAzPoYjYZPwSMFnTFtfFUTNTZVsxWYV2W7Q4SZZvX5j6C7tWmXKzFqIOTrwhbUc72jZ+2/Q0oC8ic3Ixj+R4h9JgM9WU92qHsJX6vRotmE2oLF5gbwYAEogygMbWe419KoR4I5GSOB+dRIHhld1OpO/QUeWrlZMnjQD/AYZCziIm6dWfl7m3Ibp9vbC3nRTiR0tEdajz5O/mZK7Ujya4ucXv8+VaWkcZ64MZymlcvghYeQb85DiweA94zc69U3V1VR7z4IsxRrgYbgOkHlSC/64DOq3UUcjbh54HF3cN5yMuMx2VRzHqpE7GULWFich/jirmJ14gi5QlQVXZytaPXbIIfEwUzD7ZfPwu5UqT2FIg6xgOJHxVVMvLUcS5r1WDBl/5Txm/6znjIJWgOYu4iL4ijkpx80T5OG1TFeZG5UvLxhwKDckK30UDD9E4rVljLqRVRkfQ1fE6Xn2i80fnkBtkJPP1TTEdUn51+ngS+BZdFtJ+nWVcFl0/6w6M/LeyYR4jmqNUiMu1F4kaoQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a1ffbc2-aff5-4658-c8ad-08ddf5ac2b5f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 05:36:36.8906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 06H5QAy/kz7305d/nmclstt36ISiv+lumorNsu6o30ir3+juUdVwj/ia8yNSSlALgEQ2Xcgv+NLnq5lsWiwwm6NUIphL+ahv2V6ED4Zas44=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5776
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-16_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509170052
X-Authority-Analysis: v=2.4 cv=b9Oy4sGx c=1 sm=1 tr=0 ts=68ca48ea b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=y-oGFA_aXwzF19TyuAQA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12084
X-Proofpoint-GUID: llu73pkX1hNVl1BEDZ6GtaWAzAiBVLvL
X-Proofpoint-ORIG-GUID: llu73pkX1hNVl1BEDZ6GtaWAzAiBVLvL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMyBTYWx0ZWRfX0OGPVnbwrmdl
 nSgtAewptFGmjPj+32bhw/zLnl/obzj09MyCKqCFCmJpzVfWtm41BPVbVsjM6S/KbTtjn6hmNot
 v8kvYowwNOB352NYq8JXVU7P1Q5XbButMRgjXXcbofOv8/HB1DzCXjX5UYraDpqWCEytw9lR2KD
 sTc36RpzFK3+XKWtiBQjtg+zICr6Jnenpuz5COnYScQcwTakiXbUvACg4AbFlAScBWOTegaU728
 EAoB2gzQsPBEj7Un5PMpdV+oa0fCkfW9zxcJ4TKN7yzmOL90dLJa8xGypx17CaDKJXq2Siebt5A
 9MLun11BUPLFoudhVnENjjGl5t1C7I6JTOgaQiZ3VQzLQyKXK4cCP4wW9PkWG8OBnCO/uaUxkD2
 OtS+M2JsdNQTASsqFYoC0QAtwKCUcQ==
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7A174C0009
X-Stat-Signature: smzh5e6kxuy76ebmkjnd7qcjfckyz87n
X-HE-Tag: 1758087418-97326
X-HE-Meta: U2FsdGVkX18Q42EOQvxlz4GdLYAEXF4Id+naWu/6fiCx2t2qzyDew7cvK0Ecunq2g51Sbw6nQSQcmRQ808UbmdfxlO22eGsokDit302zeUImgwOrZhdM+w9eXp1iLODqcysdQhQQk2gshkaSGF/zsv3WlN+fGYne3a0nbqiZXkHR1xBKtytGxvaNvUkIeD3HagVhW74onpqiCSRzb7Q/ulHAAIxqoQBwg0C8VLjWVPtkW+vt7VhUEXqt4fzFiBvy7ZaCmArTZUh0vNWbA6S+aibeT0b93CjEivnmjVzxru1jYxJ+25dGa6NxCX4PWd2ZV1F//SOJ7e8nN8eAYYF9AQPQTD/tQoJ7byps37Q/EZdEIDItZMAjMoUQ8Hjzgrl9uyoku1+56Np3GPkq9cnQr5cmDeg1yaoerHqfr/pJ8ixGFr7Mc1sV0ZBWJassDjiAsvCmF9ViaW2aT6OJb2uGhp5PMr+50T0i7tZt+g5DFNqnlUaYMKn8lUDfmCaPLYsqhiOi5/ECok+rgFsSTHy82QJNbXI92XKucVz6hw/SbUrjeye2awhzX/PLW5odrm3XAXFdjeo7MxRjyqlzC+OwfCO15ewF3PbcJS0c4p5AJBTRQNBMLjN5bHt5U2WXL+H2AS4BVh2rKmmSaJuytZHbFAerd3zwsw1VVtdoOYxd+V6EN/fx9uWY+nBcJ+5tUzgUM30lTYEqTTTApIdrVMUfOrQV2y22WDQkjxbzmZ4i39/DXxwqd23ot5snqEVCsPZZ5VTV5CbhpgSG/i36BHlH0KAZqVff1WCTgxqkfOcdwTR/Mw9igTGOBY2Whi1NxcScnhMzAfig8IWhImQJhrsHMCTeD0exAbTByMAZRiUcAgoNKB0eYPBvmOuB3ETiSQ+hxxW1dI1rJVwS/07oeaWpG41/Rn96bAFFDExQzaouYtYsXD4N+YnHdDlnY8Xz8CExfFyBEwPl7MIO4+6+tPa
 OU/mW+NN
 IrrymS31VdDPYlK8SxLtReuwvCoFQqxmci8maQgCccb7+2+HBQbQgBdwESLe4P5c0PHecaBsCzHlkf9GG3a/WsgCtcLIrwlznbj/wckkyNWTNkoGVA6pc44uiMMxuIKyXb5u4ckXeQTJgMHhmeyzAu/e7vwMxWmnU2mPwqqUtcqkedh2zCtMSwNK/bcH5dis5eVtiPEmAG4ZEU5ol6ZfSDRrtu13ojHNMngwCMzEToG+lvHjB+vCHbdb6As7BAfbHmwsMskNTXCplpMFRCIamANiW5FWXtMACFgiaGn9Obe9mRXOmNbPLNe5DwuZzgxhVFED9HloywX7p0IN70XretNtwFB9NoNe7Jefmc/tqj+OIJtOMH1NNvdkaQaBMlkyTDj6GjSlxnFCcG1eFI9g8HfcJlZiT5NZ23wmecpHkGGchYoKEG+tkyxet04ojULzgfLgFPs9hBfbGMbDkx2WH3Rj4a02LHHwyH6URekoel0Zm4rFtDIJ45C21vs3gq/oUQIgkXPG99NIzKE0ZicYTL9/OmVdJnZr+C3MHLOBFGaJf10szyBBplDz7FmxfH1XjyRRyQSvI9y6CgGrnherC+4t8u+yoI8L5b8eGOCDgBqDH3AZcD1rxpfuyn48lcq8qaQ6ueqW3zZTIfxDcs5QAcmFdKz4RHBz5UU2gh9d+Npnwmb2R10p0EauPuo/mY4vtUSflDD3hbmgL8hatdVtzqiqVHpe0AiuZ+kjKqCRGuBWfNuM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 07:16:45PM -0700, Andrew Morton wrote:
> On Tue, 16 Sep 2025 11:12:03 +0100 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
>
> > On Mon, Sep 15, 2025 at 03:34:01PM -0700, Andrew Morton wrote:
> > > Anyhow, this -rc cycle has been quite the firehose in MM and I'm
> > > feeling a need to slow things down for additional stabilization and so
> > > people hopefully get additional bandwidth to digest the material we've
> > > added this far.  So I think I'll just cherrypick [1/7] for now.  A
> > > great flood of positive review activity would probably make me revisit
> > > that ;)
> > >
> >
> > Kalesh - I do intend to look at this series when I have a chance. My review
> > workload has been insane so it's hard to keep up at the moment.
> >
> > Andrew - This cycle has been crazy, speaking from point of view of somebody
> > doing a lot of review, it's been very very exhausting from this side too,
> > and this kind of work can feel a little... thankless... sometimes :)
>
> I hear you.  I'm shedding most everything now, to give us a couple of
> weeks to digest.

Thanks, much appreciated! :)

>
> > I feel like we maybe need a way to ask people to slow down, sometimes at
> > least.
>
> Yup, I'm sending submitters private emails explaining the situation.

And again, much appreciated :)

>
> Maybe they should be public emails, I find it a hard call.

Yeah it can be hard to get that balance right. Maybe public is better when
we're deeper in the rc and there's a general load problem?

>
> > Perhaps being less accepting of patches during merge window is one aspect,
> > as the merge window leading up to this cycle was almost the same review
> > load as when the cycle started.
>
> I'm having trouble understanding what you said here?

Sorry, what I mean to say is that in mm we're pretty open to taking stuff in the
merge window, esp. now we have mm-new.

And last merge window my review load felt similar to during a cycle, which
was kind of crazy.

So I wonder if we should be less accommodating and simply say 'sorry it's
the merge window, no submissions accepted'?

Of course I'm being a bit selfish here as I'm on holiday in the next merge
window and hope forlornly to reduce the mail I come back to :P

>
> > Anyway, TL;DR: I think we need to be mindful of reviewer sanity as a factor
> > in all this too :)
> >
> > (I am spekaing at Kernel Recipes then going on a very-badly-needed 2.5 week
> > vacataion afterwards over the merge window so I hope to stave off burnout
> > that way. Be good if I could keep mails upon return to 3 digits, but I have
> > my doubts :P)
>
> I'd blow that in three days ;)

Haha yeah I bet :)

Cheers, Lorenzo

