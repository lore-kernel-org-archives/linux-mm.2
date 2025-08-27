Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70B5ACA0FF0
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 02:21:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA89F8E0118; Tue, 26 Aug 2025 22:21:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A51908E0105; Tue, 26 Aug 2025 22:21:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 967478E0118; Tue, 26 Aug 2025 22:21:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8113E8E0105
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 22:21:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 330A184726
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:21:28 +0000 (UTC)
X-FDA: 83820935856.15.8A87EB8
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2059.outbound.protection.outlook.com [40.107.212.59])
	by imf15.hostedemail.com (Postfix) with ESMTP id 46FBFA0004
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:21:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NOr6Gyhk;
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.107.212.59 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756261285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iMhuObwFVkeMDEP9C8ipptc3WiPxUlurwEdXt4Pb1iU=;
	b=VKwfER7VtL2D9kWaTelAJULcj6qC4eoFg5dLWH96U1SyeLdadFkfq5x1GW+MUcIepQkisv
	uMEEuh0Ou3KxkkpxtWZS5pUl9t2c2ir61YOyRe4WwmcL8Wmd1xnDBSDazPyJmbI23kaEt9
	57h6k38PuihcDl5JhqfzeUPxnnwdCdw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756261285; a=rsa-sha256;
	cv=pass;
	b=THV8vAPk/B/owCgosnrM12ntFEchouEMTkB5/HmVUm2+zQbGGAhEW9CBUUIrGygTpDb6L7
	+aLOsqplHW8TeJT77/2pAeG0rIlYIgBbrO0PrVoFDkoAIPRAAkrXZ/suHej9vUlZG/8VH6
	qtQ+ywPZD35xwfsEs8z3MMO04K0T4eI=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NOr6Gyhk;
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.107.212.59 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bhcRFPXiclfJnrRIOAa9bU6v2y2OlZ24DjcEQRLQlkNkCiSNQEvpDoZkUdRd6yBB8xZtPBjTVmVm1BAUmETb5gU9S/8wudMHl1q9sgL985Hnz11C9/hYd4egQVT1KRoVnRZ1hPrKk0yE4eGRNNANZ/9bOyjqfSnpoRs4Gx6N+RskKfCv+GcBlpiLVF7ybFBAL8XmN5QwBDL/ynYq35OZ+5LFzf+SprcWjGhEABn/imgdwp49GdAqa4ZC1fi5I7W6WizMkLxrjWfsh08Vm8QGaBibgNvPq5OBGuNj/otM8Q59j6tXSbULPIT1YDbJVkbABhFhoDalv7o0h/vMGgCQuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iMhuObwFVkeMDEP9C8ipptc3WiPxUlurwEdXt4Pb1iU=;
 b=V3u8s8aE47QEo4AMYO5nA5Xc7ZUiXx+3DjpQyPaIQpXwp0BMJ2Bfk8PHUCkDJIkhN+zi6/ttb+Lw0nlP2pRhzBq/ww+zBo0Or5tcJ1DYIa4rcTm4Cupn2hgUl+/rJOmYra1EzboGB3U4HYXUL+7Ct99UKXcWOA8tNmfWKgyK/+RdBcv76Pepo+sxVp+Zw6IBJHYohyo7LzLp8N+UiYTlyjcAgzgaiJ+HRoKwOFwSv0ZLu1pM130zj0p+PutPAlPDNJ3ptIq4/RlXZtI+i2ZxkhWPODpT5eENbV7IT3NmTxzvz0Ii7+E9gaZPZGOyvjGzlJPBkBC9EcRRH6NbyBGv4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iMhuObwFVkeMDEP9C8ipptc3WiPxUlurwEdXt4Pb1iU=;
 b=NOr6Gyhk3aQMIfecAH1zX7gIYD4/Qf0xyvlZ/srixfsPuzjlzyMi8lvgs6658yXxbLTiKZ0qnx+TmZOY8VMR6NaKQi+XVigYSDF6/3kg7cN4xFVNVVQx/6hdx4an36W3MWkX31aSBHXccY0HlTAmCcn4vZye8GaFIIPXnHLV2IR2To2GmGUe4KFbdybFSVk+oMJUNYED/faW3CTF8DBNupe6LgF9MmqH/z+yDYCvP8JzrVDqQ7GtWqA53jw9DSM1FcPP+6apeh6YD7i2WIwwhMYJ7Pxqckc7sLRKtMQOfyINXnBDineSV8qSI315NCxUwuItDOu0hyAH6kv2vO4VQg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB7284.namprd12.prod.outlook.com (2603:10b6:510:20b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.19; Wed, 27 Aug
 2025 02:21:22 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9052.019; Wed, 27 Aug 2025
 02:21:22 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 vbabka@suse.cz, linux-mm@kvack.org
Subject: Re: [Patch v2 2/2] mm/pageblock-flags: remove
 PB_migratetype_bits/PB_migrate_end
Date: Tue, 26 Aug 2025 22:21:20 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <9D5D10F9-0D76-4C31-B03C-27A3A2B526AD@nvidia.com>
In-Reply-To: <20250827021121.13645-3-richard.weiyang@gmail.com>
References: <20250827021121.13645-1-richard.weiyang@gmail.com>
 <20250827021121.13645-3-richard.weiyang@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR05CA0044.namprd05.prod.outlook.com
 (2603:10b6:208:236::13) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB7284:EE_
X-MS-Office365-Filtering-Correlation-Id: 33221704-e064-4df0-242c-08dde5106a19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FdzV8Hwh2um9UzuJxsH134vNRDf6joPGKAc9THMZNntqx3oXna8X7e2BznBn?=
 =?us-ascii?Q?6wDxl7CgAbCHcLmQcJlx/RZIdCEAmc/YZ5xULZr0fpKvmiU2H7eeXYas54rA?=
 =?us-ascii?Q?GJ01toFCfUPil9hkeAYy3xDe5TjxdjNKagXee76dk24fLKV5wU0awhp6Qz/g?=
 =?us-ascii?Q?wzG3KXcIWXGM9SLtBvUJXzDUwmF/llc4mBhxtKBa5D0nOwVyAyTGr3PyIGSk?=
 =?us-ascii?Q?CY7kCs6s2d88BdP8WomCJVS4YxnhT436RdGqfqb+biTY37UORFYXovtrmPPG?=
 =?us-ascii?Q?5Sp5q9EZt/HaHKytH+Q03AeB8oVdsbZxjY+Frs9WLr1tx71ZitaobYBSOnHB?=
 =?us-ascii?Q?eiMq+r1VY/b7glH3uokid2wm7IJXmyGGa3C6t9Ae+vFZnZUx/3tr+Q0Tvi3B?=
 =?us-ascii?Q?t9YQVLkCfimSeeuGN578jWX5rHO3h1aRT+rNv1bvhbBCnQKny3KA3xpmL1wN?=
 =?us-ascii?Q?AkSq0N338FcrMGvl7UubDmIUmm1bnhnjGKBWP/KXxHvWQNpbd/68yo5Ci1h2?=
 =?us-ascii?Q?8pMDaK1/xoV3YE8SQqKDu0/weXxR6Uri8HLW6r6GvVKHkR5TajA+RVUkl+m6?=
 =?us-ascii?Q?A/HfBJ5/4lamadeUZjZK6SDABdymmi+8IwoL74Rj22FmE5I8ioW3Xv/FeQPc?=
 =?us-ascii?Q?oHfXU67Tqnd7x5+L7DGq72ZI9vSTTtNmlH3EvhLfog3zilukEZlNoVd3TTW3?=
 =?us-ascii?Q?2adD184M+kvXiF59MtW4AiSSOHrDN+QiDuuCViBks657ys0mgAfSdIvlZ4MB?=
 =?us-ascii?Q?NMsq9mhK6YzwGEHXUB5G0X0wAJabXcNtI4hdlrx9E+P3C6V29kH8gRoAq5pT?=
 =?us-ascii?Q?v1YhsCe4ACHxFXdvk4gYxRjoc70hk+wf7U+5IqBTtyppgiLQV99vMpN9G/nc?=
 =?us-ascii?Q?DR/bhtxEeS+QvthT5A76XuggA9B6aHTz8637IxaUyFccDt+k6kZWQWmnBhSx?=
 =?us-ascii?Q?vG7pPFSCkgDjzImX0j+OjsArYDokIvSkcC/aiau18AAFSDGe6/c7rJkYRKTO?=
 =?us-ascii?Q?ldEIpB1alX9eDXFtXgKrQU5CZKT6OB5/VqTG5+W+GxwuZM89A/+WimrKvzl+?=
 =?us-ascii?Q?7JZXIZX0dRLhdMHS4X98tIesrGffk6t6iwnw1kAQLOjN0HD4gOKCN6/5TR+o?=
 =?us-ascii?Q?T6KJ2FSkPjBIMkoBnlZVOM4iWhDNIFUe8dsssu+44K7YaEt54EKKO5hcPJsP?=
 =?us-ascii?Q?0C6Q2gYQv/y631Sw5Lk8dF4lX5vTqOucnNA5uiy184/MumOGnn2xRkvTvXtu?=
 =?us-ascii?Q?8CeUjHjrNRtTPjJECtSE4lq1TASnrtKhwLKFB1pEFsA7gK89pCU1XSRMSEyn?=
 =?us-ascii?Q?JHvX3mw1ozG/R3b1mvE3UzzGmuI4VPWnptEbmqw/b5GJxiiEC5D9iCddnJcY?=
 =?us-ascii?Q?tvYYbz3OFzY26QQ3ECWPO2/07CF6bfHnWbFxgTxzNplNblpbw8iv39SobSYy?=
 =?us-ascii?Q?rFdsWBHB4ow=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8q66kxCGegh1o5vTSZx8KNaASL2Dt7oP9qsBO/PzvtqUljrEK/kR5eMKB7Zq?=
 =?us-ascii?Q?4pHPEW/wJUgihyYw7GK/flAbK3LzPjM19wS4Ze41o6r0ECM/NMb1UpJ+IkoJ?=
 =?us-ascii?Q?BuAyCngKdGKYYzWs8O0yPYR2JWnEmDmgp8nUyKGeZuUCPINjkD7O4HvTGEQV?=
 =?us-ascii?Q?wh/Wq8cYf1lg5l/VhzKgz8QUVSgKIZ5yGGsro+8dw3i1NgTXgSQpEnrERp12?=
 =?us-ascii?Q?kxpb35I2QOJCNj+Y4UWWG2UxfOpy9ye6MHXY9Au+JWDU5EOHnTyOcG+O1EkN?=
 =?us-ascii?Q?X9Q/urYA5zyFLEPKQtPPUts+ymwUEjMGShJb7ZuLw4Q/OcMog3FZn4ccKrgA?=
 =?us-ascii?Q?8UlE/kEqPKEqGn5A207brHHkpFyHusrrHaYXh9A/Lf5UK2y45AGD0zagdo+D?=
 =?us-ascii?Q?B04MtDGkq6llSgfNhyHmjxPZGlYrALr+mNKG0UBHzcfMuVO9sYvchaAYlD07?=
 =?us-ascii?Q?dq/8Y8R3owtYjkOfgbfq0ACT8tovId5/wt8r5KfvRyHS+dsBiK86cXBEjRHt?=
 =?us-ascii?Q?DG0zWGW9v5u4OwL5dvySV/C7QOGY0HVTZj3ruJRuK9HDAwxBqrl74K+WXBjY?=
 =?us-ascii?Q?wxSSXzbGIZ8lXS9cQx2e5Ip8WKGBrHjBmjgpdnwAYlJ3sZ3kTq2U2L/Wsl8p?=
 =?us-ascii?Q?wODbFN5cYjtYVR55TCZR2pSS9BxyoUPqm2VVmZ8OP5deZ/mf7GsWc3KcIgsr?=
 =?us-ascii?Q?VakQwiMwakB0XU7WrcJ3mDs6xp9Hc10awJEc4sdsppzSOQ24cUMORM6yjwdH?=
 =?us-ascii?Q?DNikfoH9xFFcQqWavuhT9WLu1bE078LxjR7ncKQ46PBP9Nb5SBW9sX12vpBu?=
 =?us-ascii?Q?jF7ebnBeKCf6HiDoZXgiW34sZXDHK5sI6tnTv6n+ZMaBAtmSAk8MdAON17wA?=
 =?us-ascii?Q?j7KSTo/D5usakK8zAT0qv4Ddba61Ol01HvCSBen7z2pKY1iW/bkPddi8pzun?=
 =?us-ascii?Q?jTYI5pfmls2sXgpfZmxbmtHrvnB13igxUbpQYNSZhYcRvFb00zrzQ/X4Icta?=
 =?us-ascii?Q?xd+UYOwBnH6Cm5UmjnbWcTfHB+6iG66m+om04pbJSwWjFPG0zsvhO7lKA4/a?=
 =?us-ascii?Q?WOX1+3WKpSWDXKvSfs4LYCpTncPqvk7xviYZeFHD8FtPQoKhpJLes2xOMKrH?=
 =?us-ascii?Q?oj1PLQIj33UJAQErQVd6fcfeqvWdp6EHeaT3/EwX07FWLCIB5JHv/tPmkut4?=
 =?us-ascii?Q?O+iIWc9brVtfwlogwGauOTCRKDpWVYxNJRZn3boGgtJTE4E3Tt1cPb+I9Wu/?=
 =?us-ascii?Q?0swMxmWo0+bz4ivsqcWjKAYa76nVm+65eA+NBz+6T1+SpsJJunTu+N/ph9A7?=
 =?us-ascii?Q?mSO5VjWpLWLYw9ntcfC3DLBwavWs7Y8uJ0hfchT3QFm8NneaUIBaP5IShbRz?=
 =?us-ascii?Q?PnoV5eTpjOUMAFQCShjbcKHMiC/chIT8Ux6oXY6nOcCxQ4AF3xDsWPJ3sE3O?=
 =?us-ascii?Q?ZYhzTh1n0HGd/grgL3XRkK3fK3XbcwH/w+p/nwmzjAGQLo5OJCLMnd4R5p/Y?=
 =?us-ascii?Q?H/2dJfIxTDskW+bRqdwWO27bwsOJp6aFMTvKhw5g+z+ObIUob0myBOsoDNR2?=
 =?us-ascii?Q?Y6OyWiQOTWmHRmw08DIs8Vsm9io2JuPtpkNFdbO0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33221704-e064-4df0-242c-08dde5106a19
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 02:21:22.0393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P27fiwTswQMBVTFWgKsSq/nNLA0ShHa6p4yeAleBVG9qrR4ceNgBw3lEUJmNaP2O
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7284
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 46FBFA0004
X-Stat-Signature: k57h5obfb9oafrm3t3onaa4idhrswxi1
X-HE-Tag: 1756261285-940325
X-HE-Meta: U2FsdGVkX18i5mxFgB2hH8kI8P+RdVydWaLkvJ/ZH/Tne8UC1YAvlgEWkDir0UJ7lEpzRVroMkFUS1oMsTihSNyHYuihrqo0pk6fF8q2qTlmXX0vLdLaF76f+ad9S5VTfv3toXXU/KNCpZZd9MFqSpZ6CRpL7T06Yse+lqDjENKG7ZWWDk+nwIR2sZ2nAYInqpFvj/NxmxfeM4MtGWBv3ep6h1r4vJOxXvOOvE/i85M26IyEStJgbtQH0unEJoMnaGEr9xCDX36+y3jhYenTfIS1FWRv7KJm1RGXXkGTYECG2c3kDXj13mFWpZG6FKdxbyKKofXdE/ozmK+zt4/7TZez6/AEdNHlLaqNdIBwX44MJE3iPZginRxR13qnaT+6IUnDTd1JKYN4NU7+6TYqjT0oz5YokzImlsLYGqWd1CZhIp2QsZ+L4rej5YPIobCA+d3617t5HladA2MRtjLCPwQxwEcn5DLt3x6C5pRMjxLy8s5NkutP+NtpRzR2SsCilzVh2Y1AOB6rS9jwfikbPEo3RSY1AP6FsEOkDNJwq7BjmVFbQldX3Call2TmRGKZl4O7Tms5rpKluzX5/g4rhE+TQBm7x7DtBXX/QQtkEJLINU7b++Gf5i+dUxu+sZlOwq9aifsd8XLzK5uurhnxGSKLzG3aFi8I7RIktwe5PkR8/xUBdDpftfEJaMp+shsFN0YDryEHbCK5bZblkshXcjGfOq33NfWmIsyk6LuWK3nrmOBipWErrsP1rMxGQ6o1+SjfihNqiGZJzxmqgaDjPEZqXqTP4nM2aKAGChUY7qFKU0xy4KqpdlkDd1FQMyMNgPaM32ygaedrelLQMX4AKirNAx7Zn43w41a+SCKll8FrdeRc343+QVCOwrz7wwWZhR3hjGJB2Xjos/QIsdG6eqZcWDcW7YkQ+p2StIwuNr4quMlajM2G3vVStU/bXXm1DLX5tW/ekyIb8MtyuOk
 HKH/jkqH
 C4Px2G4udfs+s1SHiQhIuQLHr2U2xMQkno8caZz7hwCYY9s2vrLNpSU7u8ZpFE7gbBOZU/n660qMbelQlIYhQuDoprOgKB0oRVYgDbDt2zbBS56YfXDeT9zvvwLSHznFBkbw86KQRxNgU0/UNv/UbvsT/Se6aIDvraA0kwuGjhxZwDBCVXZSRGGJPkThYHf7CoBlcCrrxkGdTLOR9rhkCMuJX52g4RB6UDF5r/nbLq8Hf9uLHtKwSLhMKUMj3N7G17M5YLyUegfdpN04GUu+hNrjApM5bkDtsuOfTaAwX4Ob/30irIfNDzE5LaYhVOEaQctcjQl7VKYJyDtqI1nHyuT1JYX9F+/GhPCLTF34Ms7b9Rsj9gOGkaNUh036GxLNGsY6O6Lmve8PD1mierjubHl5bOAe4WlodZsDEFQ6z/4WFzp4K2HWS9S1FunGJKcxwdcUr7WzX2/DZHg6oZXI40FOcK5sOXEMZZlMHFyh36hv3S6iJLomBRCNfC6u/2fWMSpUpl1ZueX46+06yhvwUMhlGZwHHTA2AS/mqJHCcytx4PgvUh8Tnv2651lW18FeaF34JU5vIkh7wjPGzCpOw7NGP7oSo8bZVil08ZGQMQU8XobRvLz9Md0vfzr+AOTU/qZ5aZNn1TBQTGoiXqd8dWknZNamKGJQ5+LXNBUYYJoEBS6g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26 Aug 2025, at 22:11, Wei Yang wrote:

> enum pageblock_bits defines the meaning of pageblock bits. Currently
> PB_migratetype_bits says the lowest 3 bits represents migratetype and
> PB_migrate_end/MIGRATETYPE_MASK's definition rely on it with magical
> computation.
>
> Remove the definition of PB_migratetype_bits/PB_migrate_end. Use
> PB_migrate_[0|1|2] to represent lowest bits for migratetype. Then we ca=
n
> simplify related definition.
>
> Also, MIGRATETYPE_AND_ISO_MASK is MIGRATETYPE_MASK add isolation bit.
> Use MIGRATETYPE_MASK in the definition of MIGRATETYPE_AND_ISO_MASK look=
s
> cleaner.
>
> No functional change intended.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: David Hildenbrand <david@redhat.com>
> Suggested-by: David Hildenbrand <david@redhat.com>
>
> ---
> v2: remove PB_migratetype_bits and PB_migrate_end
> ---
>  include/linux/pageblock-flags.h | 12 +++++-------
>  mm/page_alloc.c                 |  4 ++--
>  2 files changed, 7 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/pageblock-flags.h b/include/linux/pageblock-=
flags.h
> index 6a44be0f39f4..6e4c2da15706 100644
> --- a/include/linux/pageblock-flags.h
> +++ b/include/linux/pageblock-flags.h
> @@ -13,12 +13,11 @@
>
>  #include <linux/types.h>
>
> -#define PB_migratetype_bits 3
>  /* Bit indices that affect a whole block of pages */
>  enum pageblock_bits {
> -	PB_migrate,
> -	PB_migrate_end =3D PB_migrate + PB_migratetype_bits - 1,
> -			/* 3 bits required for migrate types */
> +	PB_migrate_0,
> +	PB_migrate_1,
> +	PB_migrate_2,
>  	PB_compact_skip,/* If set the block is skipped by compaction */
>
>  #ifdef CONFIG_MEMORY_ISOLATION
> @@ -37,11 +36,10 @@ enum pageblock_bits {
>
>  #define NR_PAGEBLOCK_BITS (roundup_pow_of_two(__NR_PAGEBLOCK_BITS))
>
> -#define MIGRATETYPE_MASK ((1UL << (PB_migrate_end + 1)) - 1)
> +#define MIGRATETYPE_MASK (PB_migrate_0|PB_migrate_1|PB_migrate_2)

I think David meant

#define MIGRATETYPE_MASK (BIT(PB_migrate_0)|BIT(PB_migrate_1)|BIT(PB_migr=
ate_2))

Otherwise, LGTM. Feel free to add Reviewed-by: Zi Yan <ziy@nvidia.com>,
once you fix the above.

>
>  #ifdef CONFIG_MEMORY_ISOLATION
> -#define MIGRATETYPE_AND_ISO_MASK \
> -	(((1UL << (PB_migrate_end + 1)) - 1) | BIT(PB_migrate_isolate))
> +#define MIGRATETYPE_AND_ISO_MASK (MIGRATETYPE_MASK | BIT(PB_migrate_is=
olate))
>  #else
>  #define MIGRATETYPE_AND_ISO_MASK MIGRATETYPE_MASK
>  #endif
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index e534f31a6b39..c1a18aaf8b41 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -355,7 +355,7 @@ static inline int pfn_to_bitidx(const struct page *=
page, unsigned long pfn)
>
>  static __always_inline bool is_standalone_pb_bit(enum pageblock_bits p=
b_bit)
>  {
> -	return pb_bit > PB_migrate_end && pb_bit < __NR_PAGEBLOCK_BITS;
> +	return pb_bit >=3D PB_compact_skip && pb_bit < __NR_PAGEBLOCK_BITS;
>  }
>
>  static __always_inline void
> @@ -370,7 +370,7 @@ get_pfnblock_bitmap_bitidx(const struct page *page,=
 unsigned long pfn,
>  #else
>  	BUILD_BUG_ON(NR_PAGEBLOCK_BITS !=3D 4);
>  #endif
> -	BUILD_BUG_ON(__MIGRATE_TYPE_END >=3D (1 << PB_migratetype_bits));
> +	BUILD_BUG_ON(__MIGRATE_TYPE_END > MIGRATETYPE_MASK);
>  	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
>
>  	bitmap =3D get_pageblock_bitmap(page, pfn);
> -- =

> 2.34.1


--
Best Regards,
Yan, Zi

