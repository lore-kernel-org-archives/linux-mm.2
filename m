Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B78F4CCF9E3
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 01:55:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 215C08E0113; Thu, 30 Oct 2025 21:55:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C6C68E006B; Thu, 30 Oct 2025 21:55:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08EEE8E0113; Thu, 30 Oct 2025 21:55:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E95038E006B
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 21:55:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 814D313AA83
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 01:55:26 +0000 (UTC)
X-FDA: 84056742252.06.D9A6692
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012014.outbound.protection.outlook.com [40.93.195.14])
	by imf21.hostedemail.com (Postfix) with ESMTP id B73AA1C0004
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 01:55:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QRdZzUBP;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.14 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761875723; a=rsa-sha256;
	cv=pass;
	b=7oXO93kI4BV7jDupCIcV09ex2mWvRXvCiQiOqJL2aFkXHbjqJKGtkiBy90ikNWsOJq28Li
	xw0dS/0L52KANyR8Z7WFhe/8C1B7xcoBSVHGoiD3zMC8D7RhJ0CpZ6JBv4YejouIJzmjSA
	EJeAuw7lnCuvAu/lfHx1Scd6ks6ih0M=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QRdZzUBP;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.14 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761875723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QSjvat/N87VbOTh1UAux1klbQ8PVOZDkrD2dBa1m6dU=;
	b=e9NyOQXqHsOjHoQvMT1EuEVwJD+YtjrUlIdoAjZVY6w9/Ehxtm/ItPQdmd16bQicTTiFwR
	uRAD0gpA+2czBuzdBqBU25nW8ExIhkV3n4lDzT5BbOLrptdrABWp7NAqkCnFXSrpCtFuZE
	vlcwVNssVJbt8RN1aVvcldtwAJZc4iE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L/AYJ1j7HYGU6FdhIQ8tW8wWj0GYgQrxQgJuept0LBKkQPCY6mNL9lgprBDnNPdQ9FUwSKsZMlfWHG/5bRnuumsY0wEwTKDB9K/S3DOlDkUEOJqTD1+uDxJtBLlHv36tlCNo3QiWNhc1rzKdqJyznPt1ZjnTLNB5vHwg6MzciqO5OSMQTk19rxa0gl2hwR6tm/E8yPeipTrg/9AZy+LbEnWNSwaFKV0mbihmKnlZqN5jc43K41u9rlyPrOSQtZXA+wk314fdJ5B5/huMlf/TI/zdzxdOTA0Gr3pikrNI6W8/iFYvScB/zpl2I0inBg8h9aTFfT4IlspYYVvhmK5hmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QSjvat/N87VbOTh1UAux1klbQ8PVOZDkrD2dBa1m6dU=;
 b=Lj4HvX4TcWcQOhvPzIDhybzhbQ+aqRmOCcGwXyjwZPzwtYJp6nYQ7oXruw01t3TH4ZeRBb3WEJKKR2NpPmn0mT9gCOraHEXpFvX3yAV4w6lpwslCsJZJftH3bhVBrFl9iFFROOH63zhsbGaFrlAol7Iz5UjrBvAVx1gZSqBVJSwmejI6y5Z4uW+YPeW93y2dGS65jefppD4bdYK0fFeVLRfqrgcgowI+Mudn709+mtjUBVji4bXR6XJl8YUfnMrExAEELYTnyngQhJv7M24HWl2ytr0glPaG6KAxSF4118iI2Me4M0lS9T3ay3g73RLnmBoUUN2UCgsJ2ngh/RDj2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QSjvat/N87VbOTh1UAux1klbQ8PVOZDkrD2dBa1m6dU=;
 b=QRdZzUBPD/Z+P1RE2aInpTPbTzCWO06iq+QFvovRAR0YKXDjNIr/LlYmkvuqDbfsulq7Z6o62XICliwlBH0FAkFh0aTRz5qT5KPFVyVxNXLdTNW9hrJj556heYBF/1A0vE+KxuEW4varRjRGy+AhYG/6h/sLOBMWQsNRr4Xux7SfB/dyyepn6r/ZApw3RZxi9gEiHk6eLhsbN46g/2dNx68fNACOTRKop+Ie2yx0Hdhmt/1/v1BBeSo/F3fWzblFy9B8BJNR6X1T+9rquKkfovuFocH7VsQtvKQV4GLoxvZ7wacSSSeVwHaYotR89Af+duVFovBkvc+7i8E7uyuCLw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA1PR12MB7224.namprd12.prod.outlook.com (2603:10b6:806:2bb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Fri, 31 Oct
 2025 01:55:20 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9275.013; Fri, 31 Oct 2025
 01:55:19 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, akpm@linux-foundation.org,
 david@redhat.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, wang lian <lianux.mm@gmail.com>
Subject: Re: [Patch v3 4/4] mm/huge_memory: optimize old_order derivation
 during folio splitting
Date: Thu, 30 Oct 2025 21:55:18 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <D0AB1A74-5CE3-4052-A16E-4ED314AF2D93@nvidia.com>
In-Reply-To: <20251031015053.n44qkbtnmwbtpfmv@master>
References: <20251021212142.25766-1-richard.weiyang@gmail.com>
 <20251021212142.25766-5-richard.weiyang@gmail.com>
 <f1830e4e-1630-4242-be0d-1cf65f20b54b@lucifer.local>
 <9A89CDDB-7C17-4804-8240-E068EA68F7D2@nvidia.com>
 <20251031015053.n44qkbtnmwbtpfmv@master>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR06CA0024.namprd06.prod.outlook.com
 (2603:10b6:208:23d::29) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA1PR12MB7224:EE_
X-MS-Office365-Filtering-Correlation-Id: d0dfe46e-bed1-4c3b-0dd1-08de18208bd8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?T/MlGPZCYEMcwuGqPb0SS85dZ+ZUmRZ83LFA8fdjntZf/aRsyFBoKmekG3Hn?=
 =?us-ascii?Q?FHsrYr/LqkTHMl4NyQVNPQKR/OWW4KSm5v9pEzjZyc9J1EmMLH/by4l/XUCG?=
 =?us-ascii?Q?HR58MiPTuOd+sZ0GnrKpTCpGsm6x18ZloIcjC5+3Kkr4bKXP3nNnkzYajSm+?=
 =?us-ascii?Q?Nsvie0rzZ+OLsbMlx0WJMNYpPZOXDONoZ0F34P6N4jgjJ7CDLvnoa3ZRNT3f?=
 =?us-ascii?Q?cACVpOpYX6fQA0yBndT1xge2hb3xilqHBV9zBd1gI7YTJv3wgTQHI1B9kwgD?=
 =?us-ascii?Q?eENYLEFTHNTQFO1OrYkey7+P1C56vGKkyK1zXKr13CogIhYHpP981/8olBiH?=
 =?us-ascii?Q?tH8i9/qB9yVvsE6PLKfLubmhOnEJxRFkQeuxqafI7MpIzIq8VlIsPgpI9KzA?=
 =?us-ascii?Q?XRdfrQrn8azrmAdG2rPIj54b3jNB7KzMMJSjc4z/KQmZiPaLuTFDgQ7B939o?=
 =?us-ascii?Q?u2ThExdzQ300pG/daQsVcBHhfhAqv1k7KRyPhzLnD06WzVXizXjBZuPAZCvh?=
 =?us-ascii?Q?c5YBebxfQUo1ISdYgwnQYLn71Lr1s2ZeiHLNyLDOdJeBaAhibZ/b9KuSO7Bp?=
 =?us-ascii?Q?NFeBQo68DjjV0I/f7TORIlV/crb1Ycva8cN3y6mdMWlZbROkD0lh4+7+VMnP?=
 =?us-ascii?Q?kmySPdhARGRDWG3rq9Ca22yVscMzM85YZX3O9kZ0QskfT9iu2bkKWIpEfnlJ?=
 =?us-ascii?Q?S0lgkVN6U+DDCP/w6c4UeocHPvDWlaWfdyDMeOMNcKVAUCW+DcYEc0RnO/OU?=
 =?us-ascii?Q?Zb8vWUY98LDbQKQTirfd8EyWeA4/7m/JX0A6hUI9Gc1BD+/Cfj5GTENFxAVo?=
 =?us-ascii?Q?34S9YyPwWn4iAw4rpAwb89pQEh2fGNdLRR9+BQ7mJka/+6JZhNzSK/XBVQ2D?=
 =?us-ascii?Q?Sg4GnHuewwZYP4G0Y6jTCKY0+7JBDOmn3Q73s8H0imZrPTwlRZUz+3iC7wPB?=
 =?us-ascii?Q?H/jOUWDcpxb9WklfFeqcBgfoF143xiS+F5nXoUTLJrFacvrsT0pmlH/7r0RJ?=
 =?us-ascii?Q?TRNm5jaRLsj2qwWZfqVuhz85k65yaulcNTmXI+66QzVi+66Ki6En2PE4L+wB?=
 =?us-ascii?Q?TF/DEQHssgnm+hu7Cs7OaQnXM7doyG9YrPe0lI+3sYReX2QqsivqPrzbd2/5?=
 =?us-ascii?Q?GFwrxB5lR0g6d6l6DMJ1cZiwZxjXnBTUnL6MmMyuh5RKBevONSRwlGsCEGiA?=
 =?us-ascii?Q?I27jqfrQKDn0xKeXxRfeMXyppXEaFwYDJnHPqs7d1QJGQbS+NtqL/TIZqsiJ?=
 =?us-ascii?Q?mJ45fx7Z8Ny5gAC7WH5mA+knGyA3+LtIbDfWQzbPzbl2gC0o+w0TIFiwU/H+?=
 =?us-ascii?Q?ZTv67ma+m5HM1/m5dCW6I3F08LS+h8l7ALVmFtWYJqx8Vwwe2Ybbrsp0vFJP?=
 =?us-ascii?Q?JAN2rZCv+2/giH9HqKYuxP9yvV4d4L4lhDK84Cd5ZwcaM4iPv91lMKW398bN?=
 =?us-ascii?Q?lJzHPG64jRD8w9PUJDlHaJfnC1qF1qe/?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?P5YFVNkhFeZZko7xzrAzTNiKh2zAYFeA/HWzj3NObZYSdfttV8v3chI+ZMVd?=
 =?us-ascii?Q?NoSzA2KFBs8RYpEOuI1PjjN4wAFNsuRxYXm6anl/mQTcPjihD5Tr0lv1BhJb?=
 =?us-ascii?Q?edq1+bQc8jmqNuVM8XjSNuRjKOVbJUsx3Blo09m8QTVLLH2onhRJhRavonZU?=
 =?us-ascii?Q?YhvB4CqnuqD3Sl3eFwXMsqn2YZTqmvpoVvaImZWE+/KPASaZa4WUAS7sXYbN?=
 =?us-ascii?Q?W0yh84nOF4TVd51RsM1NJQ061Zap7d8xhaz3oT0QNxp42kFDcLY0h5CbhEDs?=
 =?us-ascii?Q?Txd8TqeIDMPI/3J/yvJEjA/RrypjVKGt3OCwtw4x9EvSEY5yFWgtZTB3/QvM?=
 =?us-ascii?Q?7h6h6fPbp0KGp/HneRr4e0KGLnjf9DlN0WIJvU0GoKoEpBBjHFG5vAf00+Qn?=
 =?us-ascii?Q?8jKu/6KEb8CTiS4t5VdaKy2+cSTjWEAYRgDhvzhdZwhYIL2MngRSAJ/Km7IW?=
 =?us-ascii?Q?kiYbQ2AR5LH0/2SsQLAWsGzqcJL9XFkwvDZaJz2cUsY5evDY2OrV7GciJYNF?=
 =?us-ascii?Q?Q0NnRbABrcAMgfhpM8ZYmhWziKGo3OToxy7+AuHJUaEhQm/vD63j6Oykk3WG?=
 =?us-ascii?Q?mpaIqR+KyzlIbC0HlYE7Vj/Eb+lLIqMwlIClxxvSDoia2iy2z1arOrVZL7bl?=
 =?us-ascii?Q?8NELn/dQpkvzZLataVcdhlNiQJTglxruoIIyaE87fmsgE0+tjyj4mAo1xLH+?=
 =?us-ascii?Q?1OrT3FJNOgekPBM4CTh+P3lHVM/xOrsuiNLUHFQgrccz2oFXG6d6/fXm5AlV?=
 =?us-ascii?Q?22Uf9duh9pGVab3L2aL0uItG92z42K4XlmPTKob+dyB9/npWgSv23jEngDBd?=
 =?us-ascii?Q?hUQkl4kKsl7Zh5QohK9mJQ0R2Tr4j8HP/9IsrvZBWLhrIuUnB0EuHYpsq4s+?=
 =?us-ascii?Q?/OqKaW/Uzknz6Who4y+M5jP2i+X/M/nq89sZ/NLm1ATDIsRxH1fjC2OytuWs?=
 =?us-ascii?Q?1L/bA4khYNFgTmrZXlnU4Q9xKDyv3hQwM0FO/LPkNu1DbEC94ENeQBVSQz5F?=
 =?us-ascii?Q?ai7DIsRITPPTcwBdsX9e0zvq91e5EjthACJRGYteEDei54Z5UMVQKlDIK71R?=
 =?us-ascii?Q?veMTMHsd9MMcajtzcU1Q9v5vTmEGIO1chiyUjhgn6t0l+Divu1/0TiyKdG9j?=
 =?us-ascii?Q?1ValUHMBcQVxknljduKVciiAt6v13NuDzlkvQkoACnMfXihLZ/8BONPLbnzD?=
 =?us-ascii?Q?0yLCCK3J1wxSxaOxqpD34ZxgHnz9riMyVDgEkk9yKLD8yIqRiFAh0i29zXDX?=
 =?us-ascii?Q?DlSEYAbWkeY6iry4xfgT3j085NkDlNnmd4ROHVwYHonhZaFT0DK1S4rOdbLj?=
 =?us-ascii?Q?koAsu/SljD14EsDNLhXVmamMKWnoEmRsDyQejLKBeLJZ+lnuFq6VIksB2xcE?=
 =?us-ascii?Q?e3WuUIavSj3+xTTOzl0x+nOQhvdbN2HDDn24jev9YwbBPKocmC4at6r3dAON?=
 =?us-ascii?Q?52guxjv0P8BrGjP7VMWSkFZ+WGd5E/KuUfIxFeXgoq1Oa93/Ym7vqVbRLJG2?=
 =?us-ascii?Q?SyqRAKIeuIQEkAATq/spKgj2W+F5szYazQ/NbPWcTCYt8P3yeqFk5/NkKsnE?=
 =?us-ascii?Q?oGANuR9FA86kG8pH7mgJ+cjrMq2kgMyk6edgE0t6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0dfe46e-bed1-4c3b-0dd1-08de18208bd8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2025 01:55:19.8711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EslwjiBiqLB68frByeIxyN21aISkHHmD/QUQf5BSv1Y4TTucvfrLu2lKzEy98L8Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7224
X-Rspam-User: 
X-Stat-Signature: hhqsaqez9czyoai99m4rop46xxz5t3iq
X-Rspamd-Queue-Id: B73AA1C0004
X-Rspamd-Server: rspam09
X-HE-Tag: 1761875723-514326
X-HE-Meta: U2FsdGVkX1/LW4ajqKWf7mrSErI8KOq3hAw09bNlbHQp6wnqt+3cJyDLyndjSfyqrzWmwy8VKcX5rFGDzrWLFdOtqd31svV/2s4tsV925efs4KtCGf16FOI2CjNB5eWz7/RQhJCFxQRpIQsHPsKCDdl4go56OujAtJtttQJSvqAIVrKMhL/zPtnfgfXwnYCi7sYp1i81jRKMU6GKFer9eJx6/V0kjcs5Xv8ncRD08x3DXUnlCENElMn+RUPeyU6RntcCjL8aar3ia6pewl8LVNzCK6uAyAmLf91Bp2ltn4bb0qpajJDzdmMYwD2SzF9dUUNK73UHLQqIyXho6symQjCaP/QV0lnnhS1Bk677fpxMgqjT3utJCMNEBo6Nu3/MC8VqdUsh9U1zTAYgG1l1b7q6wsheyckXObtv9/nJjWfxLJsKXXpmrPF9gj1xEARX1+E7WXKbwUoNKf3kNdSBbaOOkzulH3gOmjPSo+uqr1ZSEoMoo1YGocxRqKDcJ2OlapbT3wdNJQCN1AF3QpOmA/FP+ODlwGqdIHnwsUFGub8U0JRpl7D1d2CKDhfZbXcQtk89C6rmlh3vUmOcRIuSOM4YmfgIrTkkm/UOFcblxRMU4J85ktUIIFwFODbeY2nd+EzLkAZx5AHQu6LmqcP7FwO5VxHRHhLeQX13xEIYo7HraYJ5DLZhAyHWw6rr5jbFtk5r5sUO9RS9ydM1Z/LjXHMoejfu4Urtw3MteHvSUOt7Xl7637rrgaD8ZQXk5DZjiJ0pXYMGjcOQYJ2yTmu83DYSvplG8bPQLRakYXpbYXSiSK5q0SZzSun0+ewdwoPNiM2rjlBj28EICB0mB3d5c6ZJ5lpb70If4LbehGDy7cqNt0orzUrHEhKphWkvDAgP+IIheX3NuOnDYKEiBIxEpS1E8WzhMvitvOEwYKzSbGc5lvWvhim8UoHtYfZx8Mm3P467MmIlozoJxSz5UzT
 atURtTyO
 ZcP0Q8HEC6VHA8WWbGqh6jIvIt4KD1ZBAxrIJ3QKXMU48o4+NA0d2hszSGaLbVI8DudVK+lDhweZtW1vkglOm88ckbzR/vQEkleBHsRYh7rlvDC/3X2J2Xx8mN6aBZj33p7iC41VbHUwWBq7/qoemK/NeOxgYBe+kGXfEGIbjvJa9m17JDwTMuv+DrAv0kuYHrC0q7BcEZoy1y3Iaz061pJgZGapa2r/ZRDcvLR8jwQpJ1bOt5VGad9w3xj/Rm6RMRXHBKsVi8YFN95Wo0N02YUTokYvfPxOgDqgpAEWgPj0eVYyoVxxEsJG5gN9nZ2axgPlyn/Tfct7HFSIpKcU7EsBKOM1F+QtD2vqRS05SaGaHJkAoq+f2KxKQ87ABWDEtYyxudtEa4YeeKCuXSkL+KYBRrWAZnhwzkoTiXcaBuGIQT7Oz6uved9AkQrwkfKISas+8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30 Oct 2025, at 21:50, Wei Yang wrote:

> On Fri, Oct 24, 2025 at 11:29:00AM -0400, Zi Yan wrote:
>> On 24 Oct 2025, at 10:46, Lorenzo Stoakes wrote:
> [...]
>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>> index 093b3ffb180f..a4fa8b0e5b5a 100644
>>>> --- a/mm/huge_memory.c
>>>> +++ b/mm/huge_memory.c
>>>> @@ -3596,8 +3596,8 @@ static int __split_unmapped_folio(struct folio=
 *folio, int new_order,
>>>>  		struct address_space *mapping, bool uniform_split)
>>>>  {
>>>>  	const bool is_anon =3D folio_test_anon(folio);
>>>> -	int order =3D folio_order(folio);
>>>> -	int start_order =3D uniform_split ? new_order : order - 1;
>>>> +	int old_order =3D folio_order(folio);
>>>> +	int start_order =3D uniform_split ? new_order : old_order - 1;
>>>>  	int split_order;
>>>>
>>>>  	folio_clear_has_hwpoisoned(folio);
>>>> @@ -3609,14 +3609,11 @@ static int __split_unmapped_folio(struct fol=
io *folio, int new_order,
>>>>  	for (split_order =3D start_order;
>>>>  	     split_order >=3D new_order;
>>>
>>> A thought for the future - now things are simplified, it might be nic=
e to just
>>> separate out the core of this loop and have the uniform split just ca=
ll the
>>> split out function directly, and the non-uniform one do the loop.
>>>
>>> As it's a bit gross in the uniform case we just let split_order go to=
 new_order
>>> - 1 to exit the loop.
>>
>> Yeah, something like:
>>
>> if (uniform_split) {
>> 	if (mapping)
>> 		xas_split(xas, folio, old_order);
>> 	split_folio_to_order(...);
>> 	return 0;
>> }
>>
>> for () {
>> ...
>> split_folio_to_order(...);
>> ...
>> }
>>
>> where split_folio_to_order(...) just
>> split memcg, split page owner, pgalloc_tag_split, __split_folio_to_ord=
er,
>> and stats update
>>
>
> This looks reasonable, while I found we already have split_folio_to_ord=
er().

Then, we just need a new name, like __split_folio_and_update_stats().
I am bad at naming. Feel free to come up with a better one. :)

>
>>>
>>> BUT - let's please save that for another patch :)
>>
>> I agree.
>>>
>>> This all looks fine.
>>>
>>>>  	     split_order--) {
>>>> -		int old_order =3D folio_order(folio);
>>>>  		int nr_new_folios =3D 1UL << (old_order - split_order);
>>>>
>>>>  		/* order-1 anonymous folio is not supported */
>>>>  		if (is_anon && split_order =3D=3D 1)
>>>>  			continue;
>>>> -		if (uniform_split && split_order !=3D new_order)
>>>> -			continue;
>>>>
>>>>  		if (mapping) {
>>>>  			/*
>>>> @@ -3643,7 +3640,13 @@ static int __split_unmapped_folio(struct foli=
o *folio, int new_order,
>>>>  			mod_mthp_stat(old_order, MTHP_STAT_NR_ANON, -1);
>>>>  			mod_mthp_stat(split_order, MTHP_STAT_NR_ANON, nr_new_folios);
>>>>  		}
>>>> +		/*
>>>> +		 * If uniform split, the process is complete.
>>>> +		 * If non-uniform, continue splitting the folio at @split_at
>>>> +		 * as long as the next @split_order is >=3D @new_order.
>>>> +		 */
>>>>  		folio =3D page_folio(split_at);
>>>> +		old_order =3D split_order;
>>>>  	}
>>>>
>>>>  	return 0;
>>>> --
>>>> 2.34.1
>>>>
>>>>
>>
>>
>> --
>> Best Regards,
>> Yan, Zi
>
> -- =

> Wei Yang
> Help you, Help me


--
Best Regards,
Yan, Zi

