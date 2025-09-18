Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1C5ECA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 13:52:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8782280035; Thu, 18 Sep 2025 09:52:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5EC08E0112; Thu, 18 Sep 2025 09:52:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D26E6280035; Thu, 18 Sep 2025 09:52:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BF90F8E0112
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:52:18 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7599F1A01BF
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:52:18 +0000 (UTC)
X-FDA: 83902510356.24.6B48237
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id 144621C0007
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:52:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hbX4Bw9H;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ovmHqpDX;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758203535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zofWEddAvxF7WXEXhAli9In+F6mYzOHcfMFyqrfRqAM=;
	b=eIGv9cvuejAdVZzKnDG3vvLNuNH81ojf61zKxWbRIphCD22tW17VCOFWMWnOFvLjU+pOjn
	U6Q5pP81je0X4XjlVgnyZp3elTV5DQthMYP+Om4MU9RWLgVkP3U56II03bbn0mVy5w8xiI
	AI0peQrkBqz8hf7wFfx0COZ8dqCihP8=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hbX4Bw9H;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ovmHqpDX;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758203535; a=rsa-sha256;
	cv=pass;
	b=jEX4YyGLJUrLTtUrceN7ln9utuXNTpLUx/SuawGWDpbgJlPFKrtHEIpWK3t+SC5Jn2jKVl
	DDR3WLTwEN3mFdxq/PeuCAPjSZ71DpEzRNb9hh+a8LbDnUr/iJvDjtUj0QoPy57xkTqeb4
	OFc1D+N6utgaqzDxByVfAMtWyG4HJPU=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58I7guMX019452;
	Thu, 18 Sep 2025 13:52:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=zofWEddAvxF7WXEXhA
	li9In+F6mYzOHcfMFyqrfRqAM=; b=hbX4Bw9H/RlnVCeV5svxA8KGwKp9ez3sEm
	deU6SptqqfkKfRAs8pmuyU/Vd7fy7kj7qy9Mgpv2Y2UOKZc0dQOEYkkA5YmZz5yf
	oyfRlEqMBgkUvCdhp0SmAdaLWtNJGZSAdyMe1QnkwYW+LKHHVF0LE6Er2SiPkweF
	4JOZvZNnCim15F9DId+fFGoOq/Xovm3pLVxNzno/UfrhLeyN875sm8W9wAMH8RJq
	YXuxuXRqRk9nlmPb6+sNjTfRqtOIrGs74axjKpA91CCMigsmo57Pqh+SQEeQ/StB
	z6zJCwXyTHL75PyMCTm34UstYy+hV5NeFbVgrQZ0/h/O0y/yYNVQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fx6khh6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 13:52:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58IDJ43s036751;
	Thu, 18 Sep 2025 13:52:00 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012014.outbound.protection.outlook.com [52.101.53.14])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2f6k2y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 13:52:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZPX+1pNSu+UZh/SpVNJ1vgO6VnZWox46bHWAalad0RcGTAwwW6gDhfe7NCUwPnuSGPMeAxlWjiu8h+JgJ66WocSc+/Esfsjd+OAWxJ702dOxX6rhgg1aQ59gxyOQ2hB0bNAP+9rtgG8p7NIokMOZ6U0mWuqG0XhijsXtSTbEZBchy6OoWMnUxubzT6YYLmazUyZj9S1pL7WXT4MJFV/L6FY23B7bFkcZgzy1PeURoaePA+M3SUIe4DWVVx/OnDml17DxtpxHAGlSFEucT8BHGzRPlKW3oF9TBuQjRwlpNO1tH+zUuhOEKitjVgoAc21AE9Cj8/hU5QrJUOsIApMqcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zofWEddAvxF7WXEXhAli9In+F6mYzOHcfMFyqrfRqAM=;
 b=xiHDRa9++D7agckv3Zm84YdfT+1yocnl+EJMJ/KfwzyQiIgt1VPaFors79RAesXTsnmc9tWyZSm+ovdMFYFMt4Hkk8skldAwnnS/3mtXL3ZtMPhpQ83eM95jL9W8WXoFmGh2beegMYELIL+j2ra8G6j5oIIrN7af22J9ElRcvOH+Hmo68jaoTNszY6C8SaJIdzZns/OZsry6292PfNX0ZGyfpQCoOFQqSfDEJIwC6miif5alNizwcL/7gPULGBvfP7Gzol4hSz4rVTG3QvqVW2yIOLHpOxbCrbZOGERbbnPBcgcDvr2BbGWAjttWIKKIVWq01tlQ4xQxCAXFFWZIUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zofWEddAvxF7WXEXhAli9In+F6mYzOHcfMFyqrfRqAM=;
 b=ovmHqpDXABbkxRe5wG4SaG0MRoGQxxzYaC8y/wxrG6qjQ2NVhdfX2xjJc10G1/mC4skmcS21ZnMYbqq2rpdTo90GWQ+hni6G0jx/Aur6RNuaHSXaV6xy/2tlRIvbs2wwAh9b8C3Wvz1LaTaq4WiE41FOoQD5Tps8kFpPknYed2Q=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH7PR10MB6130.namprd10.prod.outlook.com (2603:10b6:510:1f6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Thu, 18 Sep
 2025 13:51:56 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 13:51:56 +0000
Date: Thu, 18 Sep 2025 14:51:53 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Kalesh Singh <kaleshsingh@google.com>
Cc: akpm@linux-foundation.org, minchan@kernel.org, david@redhat.com,
        Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de,
        kernel-team@android.com, android-mm@google.com,
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
Subject: Re: [PATCH v2 7/7] mm/tracing: introduce max_vma_count_exceeded
 trace event
Message-ID: <53ade9bf-5cdb-49b6-b8c9-1f653c861bde@lucifer.local>
References: <20250915163838.631445-1-kaleshsingh@google.com>
 <20250915163838.631445-8-kaleshsingh@google.com>
 <385df771-961c-4fc1-971c-81314c231f5d@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <385df771-961c-4fc1-971c-81314c231f5d@lucifer.local>
X-ClientProxiedBy: LO4P123CA0645.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:296::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH7PR10MB6130:EE_
X-MS-Office365-Filtering-Correlation-Id: bcfaab1e-8d0f-47ef-643c-08ddf6ba87d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Y3YIbPoPuBp4ys38tBTDSt26khDughL7RPwI+l+cuer7laLJmKn1auKryvED?=
 =?us-ascii?Q?YLKqy+FuXi5ObzilqMWbFXc0Py5lvZssVqKVYY0n0Et6VkE06JSh9t4gn+3E?=
 =?us-ascii?Q?+rtX2hiIcJ4M1AONtGrjtkGU377B4QBV6vZP4KMJewP00X9WeMIO4ImFqfJS?=
 =?us-ascii?Q?x9L4bS2V+GjmuhL5xTSWHY9j+oEOYgUEjKIN+2j0gFdomPE+KYEG36xaPKkX?=
 =?us-ascii?Q?Vomb27zb49Jo1J5QsgqVCD/Q82v4ImeDmwbnleewZemwodXld11i3aav+iT1?=
 =?us-ascii?Q?9BVuK2GPIFciLAnWYiWVs/OLWYvKT+bRWlCuF2jky4mIDhPXnyPe5JUSS0UA?=
 =?us-ascii?Q?eSA08Hjpd1UHZOmgj9z+eBQGeC7LkO2/FmIA1RJGWUbliZFCwa4YtIVgm3aM?=
 =?us-ascii?Q?UP3h18//NDXLKDSFRUEqyQjSNSxkYFFmjmhqx99RAFac4cy1NbN6HYuE5kVZ?=
 =?us-ascii?Q?Tll2QFhXSwndK7Mx/SBxSNyR9huCIpl4m062UYLGYW09RK4bWqmmo2k4p/lb?=
 =?us-ascii?Q?SHWpGt8DjDYx/X/a5tQ6bMYmUFfX48ixk3pxkFsyfINng21vMDIrb/ZF2lEk?=
 =?us-ascii?Q?2raDnriBz7i27Vwo2slxiA0rePukf0KaUMLanoUtHM1O6GsSuQAWCCfq0lRa?=
 =?us-ascii?Q?v01R6OxusO5DVVEg/KpH2YFp8McU/Tvn3/gZqoXApXTaWMWM7hI/Ql6bLNEo?=
 =?us-ascii?Q?TbXCbpdBUBes2jdbISMCsZw+gGk7Twx7VO/LAYr5hVTtRHWmCIk5lhOQX8Fp?=
 =?us-ascii?Q?KNyfbLme8TxdXVGAhAcWcluHvtlCMwPk4ZhhYdY9wBtMTlzDvLL0RtI2tTkx?=
 =?us-ascii?Q?OvY5Gc1xM3muOlx4PdugvKZaxnjB9TR4P7+CfPy5NWutxm4Yg8j+viP3/i31?=
 =?us-ascii?Q?74PDKT87rwwBtV6FpxnA//pGGJyi+78TCmpdirt8pu1YStLtDsnujVuC7p8c?=
 =?us-ascii?Q?PCA7wniEmvJlqjlNAZEeBc4oPJBDV+XPFBYxkVX4+PLCeXKEAobXQRN5Eo74?=
 =?us-ascii?Q?sdead39xUpCbnqSUmGehIDYLbKe4tinNKXlcV0KSn8fDY3bU8IHMeoBRMw9I?=
 =?us-ascii?Q?xl6wH00rDVC2jyzFzj/Jplzehgjf6kWAQjluqg7iHiYm8IcQIPc7PxBXIFUS?=
 =?us-ascii?Q?G5lEX3jUvMnFGYxkK7N0OQc+BGI9g2+4Oj8DWXERn+LKk3UIcHyvHMXBkENa?=
 =?us-ascii?Q?aGccuDtlWvyf663RAENUbX8tI026cDSqNoPDqFjYVbLuQekM/C6Hc5v21HKv?=
 =?us-ascii?Q?RqlYndiBh+DNT8aV3xyNd6mahgeESqxkQvWu9u4jnMENHWQUHEQJjHVzifBm?=
 =?us-ascii?Q?XKWVsarvU86K9JWOG7+lgg6pGE03gIRn2bncyG+nOekQkNJZixzkJvfEhW4r?=
 =?us-ascii?Q?6WaF3sHM87KzRVhSlthOtWr+Okcon9gh7fm1fTiUG5KFzTAca/5EaFYvFqYf?=
 =?us-ascii?Q?/V97g17g5Zg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eQAN7PC8x6eB3ZMLX5Equ6qwXSXW48mLszBtmAhWXbFjlaIdi7Mo35Y6yCSh?=
 =?us-ascii?Q?AoMcQXazm7AcWDdelLvURZBKVep9a8vQpQAgClir+bW7KervFIKM9soQoyEl?=
 =?us-ascii?Q?PB8zZJxJlNiC+aNglxcqQtOp2WxTd12rLCDBQJ6FYLa6lK3DUzgyO3KYsK+W?=
 =?us-ascii?Q?te/5oQXhRNN2U+jxLyHPZ7SVIiljp31vIGP5Nciz+5S0UeksK3en7KAambLv?=
 =?us-ascii?Q?2RUbQnfOJ/cSn3JDvA5KxalFZ7/o5NrhFuDF49lWu9sN1CeXYjr8GUw0BS/M?=
 =?us-ascii?Q?nRisqlAi7FAohiYLGvx/Xf4Vy9mbsNRy4va0huzSW8IavFrMTdgyVPBjQkq5?=
 =?us-ascii?Q?g0Marb9U+5rrI49uk1I69RbopbxKMtEKRncphnlgF1TDE0Cv5VkhfzMl8uBP?=
 =?us-ascii?Q?r48Rn7UsZ6i26AGQvNKSPaRc7vIn3qJze46kCEuviHx/1u7K66I1aL98Nb8V?=
 =?us-ascii?Q?UhpbrbjoMeS9PMOOvNrFn8Ddblu6Bg4FGuxAUBxElWp5A9y6zc2AE4baGSLV?=
 =?us-ascii?Q?pt1Ti+GPL0FwxDGZ5/gEqL7yVxsR4KuWEZZWSEiFwuENo0vWIZx7RBXFStT2?=
 =?us-ascii?Q?BYNbFld65c8xWzkU3d7EPt38TjRiId18nvWT1hEVOX+r5nqW+hyI2ErMV3Jr?=
 =?us-ascii?Q?+cxMfyWWCUKNPPDABr9ggQRLpXyV4D+ZMntNHsf4UtpmiRZUhvWUxL8QOrY9?=
 =?us-ascii?Q?sWz+9R2GxpH4K8qSVD04f66sJWOQofUxm/HdT2vKCo+jNIt0/OgemTlABK+n?=
 =?us-ascii?Q?ib4lbWbkCWZbncTZQQNQYYWv8ljY7yGdb1Z4WyD8Q3ia43xS9u8olHr9Xuyi?=
 =?us-ascii?Q?uLx+9q9aP52Q7TpZwKwhMXMhiis+M2nylZwZM3vXLHjn53DRChZQ5OOy7yvf?=
 =?us-ascii?Q?yxwoeirVOGp/8KTW+3nPU+mU5BmEUAHseCP67gnDAdT+vq4yVOTYZJofxWeZ?=
 =?us-ascii?Q?3Tsm1Q6CqaxBg6IJV2iouRIU3ZHkePsEOkWwqRzwJVu5x10snXtrPzdeey9C?=
 =?us-ascii?Q?GwAxCN4KBEFJ/VGjL4OkTjVaOfR2jf03/gHartVSqK3skqZ+jB1JKiD/C9TG?=
 =?us-ascii?Q?DnBiIe19CD3iYh51aM0brE+OfHkP2WayCsQOR/hLaNNAnn2HbZDozXACusH5?=
 =?us-ascii?Q?pmNVuDdpwAeTDKweaibztPDLEL6TRM77pmK1TI4FPFddXqlCQb6NHyNOIaVL?=
 =?us-ascii?Q?TcJ6Z8up8XsTiI7WXHW6A7rYlFjJfZEvTct0FAlrVZWXP+CAe7DOKXMxUt4q?=
 =?us-ascii?Q?tQYw1EpBhTjZmriauvvIfYefWOj2D2mQfByIvBdAPpag8PGsGx8TPBQbEmVd?=
 =?us-ascii?Q?6YN5eBMCJ40NYmQGOTDBuDTl0vhxKfzIOGVeqw+g6PiyZRIMcce/0+bTO52t?=
 =?us-ascii?Q?NcLMSLVu458GI9ZPvdzrBiWatONwlDtPX6kYngQ8x8t4FYiTHwxXp7BAp4Qz?=
 =?us-ascii?Q?ElFwgSCRBXVw7wXX8eDncYiGACUNUDxdpDJzQfC/wcdHdmXDqciCKEsfVNz7?=
 =?us-ascii?Q?5kh9tUj/ST/vgxYsLo/06zgm2v/P8I/3hqDEa4bwYXoTX05wcCYniNo+x6O2?=
 =?us-ascii?Q?e5tSA5eTVFaLxkzliDuyARUsGkWNitMjVdaPyyV3+huVCBhet/XhpkkmPOM0?=
 =?us-ascii?Q?Kw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eN7TaYqHdlOwl0aLbfmQHz3W4sLuDDC4Dyu7LTx8WB4p+7HoBlLlb91ytengJWrw+T5fA7Fy5M29C8MY16aIiLTxIBQMVJF1cvvZajKDBSifFn2f5AUEbrqhtngZEzZU6XrYTx4wKz5RtgzJWipw5SI5Bwyk5EDPcJtlwlLSnuDh+85QeI/txCiaePPnwXojxgtHJLhruQXgU9KWlCC52DFPvddrRSgCvDlI3miB+Tjso2M1qlxS3RRUGV5YXxdsImVLBQcAIUUG+YsI8i3stLz7On4mcGMGPO5fOFKwY5V7PCRnCk6eOwyUVlrRptgHG4BrXdg2GZMRbMB9IMv222asKCla82B+fk446XowCtVtxvmRowffUyx896V37Mcz3GYzSe9b8AqByl5sEv2X1Kxs9l8dW8jMzU04dqHPPIF/PUPfZiOpisZbCJbvGy+XuguglLPXfoZAnBP5wb7NWY3JBniDQFaXe+gY2RCslAUr1BEP7xVyiFDwyELiSuTE45jw+l9QQmvDaqLglI6wLAgwifebl0XDlbPQs+d6Rhf5dNVyMlEMIcmfHpPTBOCShmKVcUsrvRlewdn2xQ9RuHMhtic+qyZFaOtHiKUkIX4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcfaab1e-8d0f-47ef-643c-08ddf6ba87d1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 13:51:56.0192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cEaMCuP33kyfJzXKHoKCFHCTmTxxc77Qwa0hcoRd2ebmVFMUmaPGQOzYz/GMue0mBedoWF5GdriLJTiQjAd3gza66N81Jc4NcoT8wsCfm90=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6130
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-18_01,2025-09-18_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509180128
X-Authority-Analysis: v=2.4 cv=TqbmhCXh c=1 sm=1 tr=0 ts=68cc0e81 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8
 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=g0w2wbYh90yminrYU6IA:9
 a=CjuIK1q_8ugA:10 a=HkZW87K1Qel5hWWM3VKY:22 cc=ntf awl=host:12084
X-Proofpoint-GUID: NdTs1fotajzggVUbuXZGEkQ1hYDKfDVk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfXwfEm+zuqwPa2
 3NK1wVPJm92duL29IxM+n76aBL73i9lJYSTYlX43Ng/CP7fTLSGsJUL2YktXXbTz1QE4M+vnmZX
 auUzcyltUeVGSjdn39C50POGrCa1jzGeHaqI/IyTk8T8UuDVY5Pjwcoc1GqS2XEVm0doCaq7D63
 VuLlANJ+wRjO1YXHOC87oJuC3GE/Rbbd+z853HxMmFUNwezSBgw6U45YfN/jCwq9lho6cVda0Q9
 NJb6cwnKGezDCgpSk9swqQk9ayfKdA3JWklZumKna2g5Nw1Qo5Xbn9LRkT89D4fx9RD7ku8u5JN
 m36C/+cLLJ136w4TDGAhXCIn6w7DGLTDQ7phRZ7b8EnL7hNI03EFDOEfAUx25+OZYFrlYexMuGz
 rIecBcoYA1OuE9SSCnMXfcW/AgWtZA==
X-Proofpoint-ORIG-GUID: NdTs1fotajzggVUbuXZGEkQ1hYDKfDVk
X-Rspamd-Queue-Id: 144621C0007
X-Rspamd-Server: rspam05
X-Stat-Signature: ochrko4h84pacyqgh89ubrg9zjkk8q8k
X-Rspam-User: 
X-HE-Tag: 1758203534-60793
X-HE-Meta: U2FsdGVkX18OcVYUd7S1I2fX6K5nTJdE78FSQhiGhnCgXnfY9476EB/shxnPoimmJApSmxcdRcVaTiKornpfO7XysgBPcDiP2Ctcag+MppsOAWsg8U+VOsCRN0BkBbfscO0nzFgpzZo3NH8WjujLi6ic+S1utMm12YUZmcMiNwsGLMgNayHcEQwSrGm3fsSHvURGUNv5oOZ72+7SwCCq8sU9JdyDVsqmUV746ieyW+J+7JKp8G+rs5ubhcZQb7fHtoTFq8+Wft7uUgdzeE5TIbk5A0+wNEYuHE4taibPaZSFKySBeh57nDCwjZXUQnCsPs6NegJIwXIZJL+0OK0efMszv7m4NTl/BlDfMaIYilSnWTMop0eXkzhBjSVAoKZ5Vzkrbyx3d5a7qE87dCQT3Pea4Jj2cy8hLUj/vzX1jsayVKoGO8kA1ZO9Hp0wfzxTjoF1eDzxJZ+0xFLMPh3ywrNWgjA8Z09WpTyYHyjynO8/sNrYxDGg6PYhH72hGAXVFKmJwVqD+f6inJASzJJnFWiyWhVYsYiAyp9Cys1JYKPjaq9Ums1I6POBuA4qJRda3nhPJAIEqMBrzCbj8wk10C68oCAB0iYCcyUhT592w9QX4uBLPlTGnlSa0Q8q+qRv0LYd0AfjFkFo2jO8slzUKPtFMQgmgn21V0qJtYdfHedZdEMmILHydKDNF2pBOFqHuXUKiw6VVU0f4EWvzLRd6xMY1LBQCBtjA07YWKHc934U1nDQ6wxKx60oxnAn/iqF+3hBkuBNFsh50JhBA0wCeFcMAu/B03r+pNbLjmV2Asy9doT2rbl1BCBv+OBvhujToIIp7SuJBk3IQzM/XFUM+nMmraULSl5EwOeN3HGCRXooj2Jc4WWsrkVgLsdsULZRHSRB2npybOjLHh5c+bxITRKuudmulbUI24Avm2ZRNcATiwsgpsNbsmVBvVRU2hGTOg5vUB5FOtfuFLbXWWM
 Qu7ubxkP
 uEaDwjjg0GEN40GcMItI95AEgO20DxPri7uCfHtPjFrG46BA0vNaobbxKoWEgAF+PQs5m60ZfeS5aYVkI22FHwvSr14En3elKlKsREmlGqI/kqv0SKILYvwYNrVr4ZyaoeVNpQIIy1dqC9pTrwM9sP1p8YfD2o6LA84evkW3Lay1K1xV1/GksJlA77bFsentmveQmR0azSs+tmcsJh10lNDFr/nSwVwBkB4G9T9CaqVzeYhAr8ZaXQWS7SlSfZuJHKFapljV1s2m6DUftFGDp++qR2/XyciQKHXrJHFdUMMTX5I9Zt/9ZVmpkVLh2LjwLDAclOmM7kIYiz2G14M5vWp/Un+gva9ReDhQgUJ6uRCBvULjHot5am4KU50mWCff2asN/f57XaRck5Q/h7My0lCxmSSS/WCQ/eS9rZVm+cXQkCaLrWpv3wvkZflepDlcISpc5R1eExGwY8Scs3NQcDeMReSP5P9euIFPxBYYGni2Xt7cgJIpB8sStoxkpfq4FckZrB8eqoiA1DdQMNu1QdqcewJffBJqos43d6tgPgq/0qvq69Bv82AB+aVldY/1bp1vGlPl+1jzXzqE4N4os0wOPe8ZiWgzFEucdGtFP8JArz+xzS+HoZoP8YbzCkCkwZKdgWUDob9lloRIstnnvjbHs/evbjJqOzVTRq0yyc/JK/R9v6B/YNzXweOq7mVCHCeldNsiZSQaga4YI8B4YDQl9exXIxc7RJYaCwoKLBfWi0A5VVNW+0pY8Dduwzgy84eIFFMfobSKkt63DHHgsXhslAJqzE/2lUxfqco89udbxnMEX207JdV7MgdbdmGlS+etovP38M0yeQeTf8/J27Zq6ZsglwqZqdRqRaLhwh2vU8RVuL713P6UDTnb6XA7X4uZoq/BfAsC68FSC/rQoVe2Qs1JD9va+My4otnL8dTbexWRbG3PLsJXdFgWo2XvdxEiA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Sep 18, 2025 at 02:42:16PM +0100, Lorenzo Stoakes wrote:
> On Mon, Sep 15, 2025 at 09:36:38AM -0700, Kalesh Singh wrote:
> > Needed observability on in field devices can be collected with minimal
> > overhead and can be toggled on and off. Event driven telemetry can be
> > done with tracepoint BPF programs.
> >
> > The process comm is provided for aggregation across devices and tgid is
> > to enable per-process aggregation per device.
> >
> > This allows for observing the distribution of such problems in the
> > field, to deduce if there are legitimate bugs or if a bump to the limit is
> > warranted.
>
> It's not really a bug though is it? It's somebody running out of resources.
>
> I'm not sure how useful this is really. But I'm open to being convinced!
>
> I also wonder if this is better as a statistic? You'd figure out it was a
> problem that way too right?
>
> >
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Cc: Mike Rapoport <rppt@kernel.org>
> > Cc: Minchan Kim <minchan@kernel.org>
> > Cc: Pedro Falcato <pfalcato@suse.de>
> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
>
> This breaks the VMA tests, please make sure to always check them:
>
> cc -I../shared -I. -I../../include -I../../arch/x86/include -I../../../lib -g -Og -Wall -D_LGPL_SOURCE -fsanitize=address -fsanitize=undefined    -c -o vma.o vma.c
> In file included from vma.c:33:
> ../../../mm/vma.c:10:10: fatal error: trace/events/vma.h: No such file or directory
>    10 | #include <trace/events/vma.h>
>       |          ^~~~~~~~~~~~~~~~~~~~
> compilation terminated.
> make: *** [<builtin>: vma.o] Error 1

Trivial build fix:

----8<----
From fe4c30abbd302ccc628ec92381ac10cea31c6d85 Mon Sep 17 00:00:00 2001
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Date: Thu, 18 Sep 2025 14:47:10 +0100
Subject: [PATCH] fix

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 mm/vma.c                         | 2 --
 mm/vma_internal.h                | 2 ++
 tools/testing/vma/vma_internal.h | 4 ++++
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index 26046b28cdda..a11d29a2ddc0 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -7,8 +7,6 @@
 #include "vma_internal.h"
 #include "vma.h"

-#include <trace/events/vma.h>
-
 struct mmap_state {
 	struct mm_struct *mm;
 	struct vma_iterator *vmi;
diff --git a/mm/vma_internal.h b/mm/vma_internal.h
index 2f05735ff190..2f5ba679f43d 100644
--- a/mm/vma_internal.h
+++ b/mm/vma_internal.h
@@ -47,6 +47,8 @@
 #include <linux/uprobes.h>
 #include <linux/userfaultfd_k.h>

+#include <trace/events/vma.h>
+
 #include <asm/current.h>
 #include <asm/tlb.h>

diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index 07f4108c5e4c..c08c91861b9a 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -1661,4 +1661,8 @@ static inline void vma_count_dec(struct mm_struct *mm)
 	vma_count_sub(mm, 1);
 }

+static void trace_max_vma_count_exceeded(struct task_struct *task)
+{
+}
+
 #endif	/* __MM_VMA_INTERNAL_H */
--
2.51.0

