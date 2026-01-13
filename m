Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1770D2F35E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 18:51:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52B8C6B008A; Tue, 13 Jan 2026 13:51:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AB636B008C; Tue, 13 Jan 2026 13:51:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36FA46B0092; Tue, 13 Jan 2026 13:51:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 23CB56B008A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 13:51:43 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DE0A91B2B9
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 18:51:42 +0000 (UTC)
X-FDA: 84327834444.01.77895D7
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 508911C0006
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 18:51:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=pcxCTNpr;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=eE8kBxKK;
	spf=pass (imf21.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768330299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZqUIyyfE+IKhwUabpgHzmO4/7xYmOMDMPUGhjv2sQ7g=;
	b=IlQj97GiXCXsa8SO0+8PjCJto+8b7k2yNy6W0zSM2kZosgUfbni5Lbi2buFpcqfVe4QXIa
	7i5rt+KWyXATUIfwYBAbe/BbmoNgYslTfW4Hh3YjiKAqwRdIWfAa/h3YUF0y7d7S3fDYMx
	ymI+Itb4M+6Zt544L6emM5aN6X9ki7U=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=pcxCTNpr;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=eE8kBxKK;
	spf=pass (imf21.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768330299; a=rsa-sha256;
	cv=pass;
	b=ohhfjEwCt9ntwYVITPYUTG7dX0f1sQVLTqMBsEMhhA8GVopYEm6acJkjYUwBcaxD+wcpsK
	u56fqCdiL01PRiLNGaPigwI8vhB7wQm8F5hgOWZaPTeulVAH/7tiK21Yn5ZDZVs09RORMI
	xVZFkKbPmoZdBHM/LlHdcU8yusP2lVY=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60DGBt3q2419474;
	Tue, 13 Jan 2026 18:51:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ZqUIyyfE+IKhwUabpg
	HzmO4/7xYmOMDMPUGhjv2sQ7g=; b=pcxCTNpr0qYhk677LmExgZXE8oX7M2FjIe
	5X3LyWIfbLEQwV6aY096Vh4FZx85Q3UBQ0VWtFMuhoCG92RRoW9zVfYYO39ITeL5
	ukgLTnPifLMy+Mh33Ledfyn7LPaDk4h753thcnEJXwvNQaPfFV38oymQAKFA7ct0
	QdGjLMpaGbMJW6axp0bXMaZb1CguHZFuHFb+Jv68e9KhzURdiRpjaCveJpQjMdiK
	Y3rl9Sj8yVO3OLbdL+J70zmhVOmpue60SDYNhcd036hOWexFlXbnM+t4W+OPLYs0
	SRb1Bm8o4/8aOu8WkZ4tmSux41yf0097x84Wo1BFCgylrEmEIsPw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkre3v081-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jan 2026 18:51:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60DHiJ1g005686;
	Tue, 13 Jan 2026 18:51:24 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010064.outbound.protection.outlook.com [40.93.198.64])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd78ujgm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jan 2026 18:51:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sLCBA5WOwJ5RvKVvb4eNzLcUZiZwiACq2z9jpj0E2mCw6emATjpdTNAz1w0mOfxWGXyin1OPOoiZO4S6Xsq71vtPcYumCOSCvR5kKm+OX08kLYz/9tihRSYP43K+v0ulxFjW8QuWmromw4ybeRWtvi7jyYmqf1ruLxJNaNKEbK9m+7f/93gi172Imfmpvt3H/3hRbAuwhEqrPHw0rTUP4l0xPCgPXmeZlpmr/UX3dPFGN/jmpFpF29VrgcKlEGwqetfKvGnEsSh6M1G+KZK5Aw2qhXwvg+iuA3XVij0tM2TY/OI42e5KUWpDwsoUQK7ogvCThvIjvv2D/CBfpM5vzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZqUIyyfE+IKhwUabpgHzmO4/7xYmOMDMPUGhjv2sQ7g=;
 b=ANRFL5zEwagrT0gamFwKCGIhiV+jsCIh8UdBp0oPC+h5/Ccg54Q76oCZ0diJQFNgkLdFPS8lnQGXae4e8QfcOf1bp5etnJVNvILn9BvNTMOGkkXTLZ9jnCVsZpW60id8Ggjjrg8PKaiMN2S8/tk4MATk8AShYbzgXz/ykg/+Vk3Hj3fmewdJIT2zNEf6wX8LpyvDlPzhJkbTHmfcHq1OI9k6ru/wEgTI9zsz4Ee+ctBidrqOp08g98X7FZuFWH5/TAPCh65mUCNrlAxb5zNY+U8WKupuGf+tRC0CmMfhJ2sjvmvUbWKvPWlMJ0fM1xKJhm9lqmtHhpTw2VaXP84bBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZqUIyyfE+IKhwUabpgHzmO4/7xYmOMDMPUGhjv2sQ7g=;
 b=eE8kBxKKPTKZRkuxqRMMQ+GaSu5ggssKS7CNVdj/nGZJBDRjXbWsMGMmNoW3cHgBJtNVDHmvQGUm4GKjqLHiIiZ9wID5Cv/a+MJdSC5rcPICaLzT4z3bhaQf0A6jglzT+MiB8HRthfLQ2vM3bUXZHlW8HOt3x3QdUYUghRC71Xc=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA2PR10MB4810.namprd10.prod.outlook.com (2603:10b6:806:11c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Tue, 13 Jan
 2026 18:51:21 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Tue, 13 Jan 2026
 18:51:21 +0000
Date: Tue, 13 Jan 2026 13:51:17 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v1 2/9] mm/mmap: Abstract vma clean up from exit_mmap()
Message-ID: <mvyj37ijy3j55ynvtlqoji6nlbiknidyq73ufiktw4sb4wiwgz@kmsqd7qsbrap>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	David Hildenbrand <david@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Charan Teja Kalla <quic_charante@quicinc.com>, 
	shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com, 
	baohua@kernel.org, chrisl@kernel.org, Matthew Wilcox <willy@infradead.org>
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
 <20250909190945.1030905-3-Liam.Howlett@oracle.com>
 <e58b16ea-3018-434e-9eff-eb6cdeef4429@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e58b16ea-3018-434e-9eff-eb6cdeef4429@redhat.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0277.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:109::10) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA2PR10MB4810:EE_
X-MS-Office365-Filtering-Correlation-Id: c284b2a9-67bb-44f8-e45a-08de52d4be37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XZmO5lCHY3EbUQy6U3LOgdSJSXIUwdSUAMwkDAt45y47/1wy1Tx/G8pUI14Q?=
 =?us-ascii?Q?TJV9Bzt1z8emCZoRU71FthJfbSt47cHBozxQg4DdeaI3eGPeUcL/ZotWrszq?=
 =?us-ascii?Q?HPoKxHIfjmDByMkXD/BpCRTYe3x3nimzAEORZKy75uNZOtaThPsknmtllYmj?=
 =?us-ascii?Q?wpzLQ0J7oNlKTnw/W4kcQTVCQEeAEpG9z1QoN4eE40Q9qRL4yyVbiAaJecl7?=
 =?us-ascii?Q?H3MPKQFbF8htOcWU7ul13Dx23vGFoTGLdXgYbhEcx9mLtCIagmNBe0IL1VkT?=
 =?us-ascii?Q?cfJLmXAJjyyxJcwbwJGxIvH4tOMHN417G2b0kZKEQMTrkLIRBqi86yBPWCrJ?=
 =?us-ascii?Q?RsLz2+UzP50gtvvuPfbsbu5Xja/rQMw5UY9KJb2HGQEWRAATrfeYtBgtP1DQ?=
 =?us-ascii?Q?8GQ0db+78M9D08GnAvx3OBJ3PPwuvr6vyeR8LFDUJhzceI4UuP10XnimmxE7?=
 =?us-ascii?Q?KApBafiBVvbok8Z+3keQqeHYSBFuLy1+B5W6rd2I6BbWubUQMbnJHwZ0Zyt2?=
 =?us-ascii?Q?kCBlqZVtEPV9iWt77F5MSheaxfnDs2kaSAjhcjeURpKZwcomjaL1cGXoeI37?=
 =?us-ascii?Q?XDDg1a4R05ESL0sjODWuavwTO668wQVz4s6Ti0ujD8PZgeQ/WDuHX8XTrgNL?=
 =?us-ascii?Q?XXI7RVmnaQytMF9/93WPsDDkj4TbhdJ8RmxGtVY0suUylS3jyXrt+i8KAiR5?=
 =?us-ascii?Q?fSx1B3h4reOVjjAoRBkVPQsDPGw8CBangocH68eeyzqQ0pNhMASDTiAIsAdN?=
 =?us-ascii?Q?MEFihlnRV/Cy/MrV2QVDojOIX6BIk5+37yKBfHbY5IRPhOzkl/NyVOMc6Cml?=
 =?us-ascii?Q?ORmqnWaTRFiiUc2cnbeRMKjqMBoGmvHcU6SdPsk7EKwxHpYM1htdX25s2zTa?=
 =?us-ascii?Q?Xh+IlteE6osiTeFgLl6ETz3H1Pa9pRf9ouxVKfVekH8nkvzLwlDMQRPwlj68?=
 =?us-ascii?Q?RmdDL+waX7rc/pHfcGp6faItEWpyTVj+tod4ldYLlgkp1jRTLfvYSXO5LIl+?=
 =?us-ascii?Q?8pWJArg3HkDXXouWD2lCbNWsWCG1an108y+2i6fJhRLtYVGiR9PvB+2PlBuN?=
 =?us-ascii?Q?AWVEmszJqYJZs6tnFgmemkXW/TNdFc3HYICgRVsr+7tnrv75ZgkudkO3vRH/?=
 =?us-ascii?Q?GqVptn+Acga5H61QvP8yrEy8yzpQRiToSRvjNmitPeNl1cfufNrcjSm0R6Ov?=
 =?us-ascii?Q?VFZ5bAxICEGlhIk0KDbPYE8aGE48ba86SrIGvncn4FZaIBRcGWx5PvlWp45d?=
 =?us-ascii?Q?pzWUZ7Wzo1tKMtI5+5+yIj+reXVtF7QLp1rcqh8mK8Po9cJzo9r7XuA8lyL7?=
 =?us-ascii?Q?IcZEiHY08g2dgLuY7ut7UXjycNZS1s7Hvh3wer/wEMqe3CIiMFQ6+w3pHhU5?=
 =?us-ascii?Q?yUt8LYbaFbsqX9zRMiO3qtw3wWbR3kmL0TDnf0ap74sQjEKStnkGOEBar099?=
 =?us-ascii?Q?Re6vB65T3JclcXnsjSmRTermnZ+zLOXi?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PaIFqRQUaPgow8CAJw6ithHN6vomlGEonOYfNhnMrQy1LYlxpn0ai0wfkto7?=
 =?us-ascii?Q?CP33r20Mf4SP+qrNC6ZnjZlHsTcB9y/PUnZpcOuZJIeG4i34GrO3yzYkLKWz?=
 =?us-ascii?Q?+32g6KgayQaVrqXWyH5XpUR1A3b6cq93RZJV49WEJvHWqP0fLSw+sVbINdqv?=
 =?us-ascii?Q?40JdPJobyw/7ZhVvP1AOVkkNzHq4GP/mSP9Hef8YZUAwlHLiBmEUHyfT27X1?=
 =?us-ascii?Q?dt6/fpHFAiF2s0bJJniGk7YDKarTxB6GFfFXtDz7O4hZesFuzZzWj5Y6+3Jc?=
 =?us-ascii?Q?VA30sZavfR9cV9JmlMTA9z/9V9KCr9BSr5jZrhivPXj+LmFbwwBNRR9fSQRX?=
 =?us-ascii?Q?htk9etC1d/OplyB7zjIU88FBMi3ntYEj3+lodqRJTZs+SjEWNOJFRYD1uULZ?=
 =?us-ascii?Q?SZzsObsrA+I1HB0JksxL/2fs2GePbffYmduGT0bWvo80UQP8cyGEbXvNO+8z?=
 =?us-ascii?Q?NUlS6vzxOAJ45SzEPoHy35vZnBHd/KjMp3W7Taw5Ksm61Vj4YQYZc2LVSpBk?=
 =?us-ascii?Q?Z75HijJWXChnKXDXPdOXbAa66lD4EUylAsdCF6/eezqAMr9Y1rt1/BqEITsv?=
 =?us-ascii?Q?zJ0rmTDCcqTNQpSeGMyvdw3bih1MC2cg4XXLPrTOmC89n9kRLW4lYzdtALQj?=
 =?us-ascii?Q?9WT92l4kbFoVsOhblk6vY0r2z8XN4q7gX4LSJ2wNoMMzVQRIDE4meluiNWuV?=
 =?us-ascii?Q?mXcMapjH2o6u7XcgMXtqnKhJ9T8xSH2jYU3w33Y8/dqZuqqv4gMTuxgsirAR?=
 =?us-ascii?Q?FmRqMxcYIo1xauFTi9KX35Wj65eTf8ZpBdHQoVZ8fqVwGB0N6VvPjIfsXX8c?=
 =?us-ascii?Q?j5/LNAtk/YkCG6nWBiI7HtKmSBbTTbiewUftU/0sat8stdkH4kpIsz6LuQHf?=
 =?us-ascii?Q?vTsWk3xvt3vlTSvtzXZdp5W7XcKDHJ6TsXuSGXuxspJnjS+ZztgdzjG7zPut?=
 =?us-ascii?Q?vRqpIRYgmzg/oXAZWgMR8aLckVST0VY6LZfjPSJyvyZgp+rRKli8O87XsHV5?=
 =?us-ascii?Q?n4tHsDIvJ3lXZrWjpGkGXmKEkNZjsCss51e25rytlDdXKbOUTtjBoT1Bq8lB?=
 =?us-ascii?Q?J+tUkThJ1FdryAVNu5njNdC6gj2Y73N6cBFldEAKvYpJ/yqYTMXjc6J4dqFI?=
 =?us-ascii?Q?5OkSQMdAtZg8She5XaLEt7Aeh5V+uvCW2avkHRGl28y+dF6Tl80LXW6dU6/2?=
 =?us-ascii?Q?oKrIA8KuCENYLdjbB05hBUNS6/Tu1aPmr+u8+kwnFgRqPhda6J22cQrUOd2L?=
 =?us-ascii?Q?Zh8icf10QgdfOBA5lDH759ecWKQuwM+3bvD3DMpOf0f7O/vFGgNI6R7D6Cig?=
 =?us-ascii?Q?lj9rg2sZ0XewJmXR+oMLByXxpFeU8u5dxjyNV8rOSpGTzhlErZOsINPsS0hH?=
 =?us-ascii?Q?nuQ92zJ8mW7UGMVxNcJOii2TAzkL9lvKi5djFpFG009Yt1+q+ujxHXTWiQ9Y?=
 =?us-ascii?Q?LUbKgJTsZz2G5D3LG9CyyT3WPnlYGimpqjVz+4wx9FTbSoxLrbSJ4w8QsBSl?=
 =?us-ascii?Q?ixqBAVVo9FSfHRBBGF1Vu7cXmkdjfqz4bAW30EH3stA95l0iKgVQyJ1wykf3?=
 =?us-ascii?Q?Z9txDfK8nT4uo2samQRQi5ZazJ1BKmoVbKEDe6Jc48gsiEdCOMhBQKFRdr2z?=
 =?us-ascii?Q?Q05PdKZXcPexG9PegiXxUeRykzMxz9ZDTiI6qp4FfKCr3WXMS3RPWr1rBQGO?=
 =?us-ascii?Q?mi5+EqRXdbmdoSt+Dd1XXdijXj3GTCnnhfFHTzTLQv/9ywuWlbaNV+wrKg5x?=
 =?us-ascii?Q?sikWUuJffw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sk5niNwtECHkCEu9Ebn/dt5Rg2q3BdF2zYauOqT25IOPJnuKbR8pNpzap+7IxTCCbTnCqvfpB0t5atanUTtlfQN9GYJ23niYkURtNsFRQRg72VIyN4OfHKi36NnzCXOSp+XvED8v4ZahTPu8or10JzsO/aupaneDDer03Np0rEHE9H3A0v2g7fjMbONyGHaiA5qxzo+dwbEtVSlNjfyknWCQUx33NfgQ4xsXHAX7zOipFi3okMVrclF94sNhw/0oIoQl5WDH3QvNx+gZQrszYREluPukmBB9mWQafdVuDflcWEFU9Jub8SQ2xIlLd+PWNC87C3oo69w2SLwq15XkoY+o+xfSth/4knI/Ku1lGJWCSq/2JG1m9Q5A+BDjyhxkjmlmTdeRtY4QUvC0uLraGauUWNoD+4LSESIrfRDqFeD4po6g6RbPVx1lwwhuBxJ0mMTy5tcw1t2h1IynkExY1wFdnq52rbR++vta4QE2nM3xjpDBEJ2gSSagBi5MAOJLhQfsTlet2yCoT5YvNq0GRMLr7l+rrKcbJ4GT82b/aMeApnO8F11m3lhBFwaf68hSAnxsEBxLcAzhAU0QS1xhPIu+PrzlBEW/lq5UbhItDBI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c284b2a9-67bb-44f8-e45a-08de52d4be37
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 18:51:21.2656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oi8zupqoHUgzHqoFPtSTsO7HtMkX7Lk4+dO/vKL6IwNz7rs4/9q74bsTw9aZ16dtbJlClLS9prLzpMTfa6aglQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4810
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-13_04,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601130157
X-Proofpoint-ORIG-GUID: VtSKvRYCJYPkO1ceXDD1G5l-uoD3MQtr
X-Authority-Analysis: v=2.4 cv=YKOSCBGx c=1 sm=1 tr=0 ts=6966942c cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=02kPHZdFsKPxdZZN26MA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEzMDE1NyBTYWx0ZWRfXwKMQlpIlRl4P
 PPmntVyZFu3h1ghAF5kdD2KMSOSK8LkAUy3A4BJdU6J3HrMFC1fRUAkIpJwqM9yw73CoLbCwGuU
 JPzzDTmB5YWmwdvIhB1hBs53ElOoQ6Ae4H32LWXeKOTlUUVjJeZ3bFLRCuquaTclqdvXG3DpxkT
 CumDEVx68Y3tE3XKYzQdcHDd23A56GeVilp4aA8F2Udv+PzC8XNrPiHCyHej4ssr8U8/eC2fBlL
 QKh0cLK+uJIGrio8tTHnxEHqhoMPL8Id3t1kPo1A9ubvwKlCIkcpBlBd9nIsN7p+/GKW6cuflz3
 29itJKMlx+2G6C0a4q0oynA+ftYGxvmQjK78NMcgsYokcNVo9RW6Xs1KcuFr7ycgOfYRYB8PSj8
 lb26qOd7RXQ/UWt1Biz3XtOLx9k8/dpMpGswdzn6ayJfd3Q+pler0mKviZPJEfqipnPDosxfLWc
 qcpYh17ez7ANfADALUA==
X-Proofpoint-GUID: VtSKvRYCJYPkO1ceXDD1G5l-uoD3MQtr
X-Rspamd-Queue-Id: 508911C0006
X-Stat-Signature: qndt4trew85ugziye1bgazup8gtte674
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768330299-959795
X-HE-Meta: U2FsdGVkX19o9DTw8cRatwvn4/OgPzjTR2bpRVb84I5+MWWI+hZ0sf5OxqeobVpfVJ2TeqiIP4WFIdXBTCDee2tX5tl1GpZ7q93i7kPuzCsjNB0f6iKZqBFE48oPC9AvkB072zxEnYk4akBJEZFh8raOg7VAy7Ob3H4d6aP0Y8+RuhXQXZ8mSe3JvbHZIO6zObbNKPu+tsrPp6Rd1fGxpKZ9q1F9wHuHvhhLsRu9+kJxV3l7QQELh+lfNc7/Vn7fculswxQLrzTIr21HOTp5Vu/eHzeinIJDKZQgJ6g1X/xsOcSFOoQL0BzshHP+77hMpxHiFOHq5ovZmz779Ii2kmj3AU2xy228ZtOewFZUTCrboFAIhLj1IaKi4C5Y6FtsOLWC1d+rwykNfE21IkprTwJBjwcK9HoV5PZopm01a8Hik+LxgdSrxCgmCnRbX4rTidWKadGHi9r5RgIHl1EthhdQz3GQtL0mIqa5/lesNfxi96MoAhldHkGsuJ2uNLiOPcujaZC7q2CnpEUUqfrmUMkk9svpgH9hgNhz0/1UCgqbo2w3b0/KZq4MhuBOePW5LWOaxTz3WJu/wLpSf6Nk2jDFB1I0zU5GQDw+1jiedQoXR5pROQBH9r3Zf+CXeu2EIgY7CCyXQ2swnTSOSVymP8BXoVxes3i5EVXSpMItQJIif7jOBssx1sPH/TSBJP1VTJemeHj5slkppN3BpwBkI5MIIpjRhQUgtm5V8Qzb01kBUx7v+uuVy3GybbY7l/l4d31MNXG9E2u+cy13PPUZmkv516GycgbplDiQNnWXKlPclKfhhu/je087tsuolKfR94BZdxhxdCxK3OPkpJbB/t3J7t0kUA/L6hGx8cBq2TDfUHYfeA0/ufmEDPFlIm98XFH8o6gcze6td/NV0HVYtimctAJJzXF+ou84keAsNbs2mYVMDOEKaTqiTOA/p/di//Ng2CbEozWcpovLVj+
 QiNCU0Uv
 imNOAXxYIwNa8uGYFCsVizxq3+oz0b+csS/7L74HWtpkGeD4oj+iXPLrbCNdET4PN5kcuhBN2rE1dGZk2nOHMj4l571Yx4zjPghZjVWPa1Gm2kb7Q2HBW2YFrA+8XtWHALAEbQENfXCLObpFeA2BkqkQEHxZb6IT7T2L790JEYigFPu+5dQ7STTumCIbcBOi1nzF9GV7TWHaZHWgHvXEEqwWVzovs0GDP2kig2ZbAr8yioEjnVMvpL2fPpRmVn9KXStV5FdovRdkv4Br2/vvFjC5nnOh6CY/Nd6zd8RNEBxfgMFEs62dCcVUYmTkP+EBCT+cMvMciTNk9ax2gApNpdUt+KcIPLceIylH92aaO9hQeHDoxfwUKRw5Nv0x2wIkg1wf3aX11Hvd2fw4+kisRoLQInGAjB2HggOCXOHlA27KlQ9DPsN6Fa1HKewJRohrYLj9hzwh3GH6I0rlTRN1dPHPdusq9khYwY1+NPS4DWPoqE2irOHunzdWGuIlxjRvV/hsZoBmK0qEgVbV2ScfpLRKS8yS93q9u1pSW+cyX33GwfJNO5W3iAPGqZQ2BzHdcRedUl5shsrD7w2diDXCf5DKB9vkOJNNFiitIKs3D0QZmqicTYXdN7CJDr0Yw0j7/8P/lgxD2/8G3zSIlMXdtZnUUtcsa3EbsluvAU0ByUbzZqvQbtAmRlezS/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* David Hildenbrand <david@redhat.com> [250911 05:21]:
> On 09.09.25 21:09, Liam R. Howlett wrote:
> > Create the new function tear_down_vmas() to remove a range of vmas.
> > exit_mmap() will be removing all the vmas.
> > 
> > This is necessary for future patches.
> > 
> > No functional changes intended.
> > 
> > Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> > ---
> >   mm/mmap.c | 37 ++++++++++++++++++++++++-------------
> >   1 file changed, 24 insertions(+), 13 deletions(-)
> > 
> > diff --git a/mm/mmap.c b/mm/mmap.c
> > index b07b3ec5e28f5..a290448a53bb2 100644
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -1250,6 +1250,29 @@ int vm_brk_flags(unsigned long addr, unsigned long request, vm_flags_t vm_flags)
> >   }
> >   EXPORT_SYMBOL(vm_brk_flags);
> > +static inline
> > +unsigned long tear_down_vmas(struct mm_struct *mm, struct vma_iterator *vmi,
> > +		struct vm_area_struct *vma, unsigned long max)
> > +{
> > +	unsigned long nr_accounted = 0;
> > +	int count = 0;
> > +
> > +	mmap_assert_write_locked(mm);
> > +	vma_iter_set(vmi, vma->vm_end);
> > +	do {
> > +		if (vma->vm_flags & VM_ACCOUNT)
> > +			nr_accounted += vma_pages(vma);
> > +		vma_mark_detached(vma);
> > +		remove_vma(vma);
> > +		count++;
> > +		cond_resched();
> > +		vma = vma_next(vmi);
> > +	} while (vma && vma->vm_end <= max);
> > +
> > +	WARN_ON_ONCE(count != mm->map_count);
> 
> I would just do a VM_WARN_ON_ONCE() here.

Sounds good.

> 
> Reviewed-by: David Hildenbrand <david@redhat.com>

