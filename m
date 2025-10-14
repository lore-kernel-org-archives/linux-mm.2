Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3344CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 20:12:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8E4D8E00F1; Tue, 14 Oct 2025 16:11:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B65C98E0090; Tue, 14 Oct 2025 16:11:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A54558E00F1; Tue, 14 Oct 2025 16:11:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 905F48E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 16:11:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D5664479DE
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 20:11:58 +0000 (UTC)
X-FDA: 83997815916.14.AC19557
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011032.outbound.protection.outlook.com [52.101.65.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id F02F8140002
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 20:11:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=nxp.com header.s=selector1 header.b=S2g2DlRN;
	dmarc=pass (policy=none) header.from=nxp.com;
	spf=pass (imf23.hostedemail.com: domain of vladimir.oltean@nxp.com designates 52.101.65.32 as permitted sender) smtp.mailfrom=vladimir.oltean@nxp.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760472716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=29GOwAS22pO8+YLmH1/Rl+lqWrz6KUR27dDlT5VE8ss=;
	b=BixCFF6dtxssb1XxPIR1aQ9USmp0zvjSNkS3oTq17+4dnEuaZPuEufNlJ2k+tTiG72Du3E
	4ekb+bP/ReP7Wp4D04DoX78ePw/rH6RBrXYmJlsb6x1MEWiVegJ6uvB7KvxndEUxUHsUCN
	doQtAAjPosoqtYCpwXX5h4U/i3wvx6k=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760472716; a=rsa-sha256;
	cv=pass;
	b=zcK84vOqGZGtvw6l2MUazP1DDCT9uDa6Fy4mjj1NEj/vsCFGnCU1N4E35cRvY5Xd/g/hGU
	fPqqaZ8GgqXJrlw6CF382SGABVNoCfQ5KoLlZQjY1Hqg2jkm/M1uLPToe3Ye+FGBoovza1
	2qCH6LmXf7SVXFVqkcw262KYkKuc2Gg=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=nxp.com header.s=selector1 header.b=S2g2DlRN;
	dmarc=pass (policy=none) header.from=nxp.com;
	spf=pass (imf23.hostedemail.com: domain of vladimir.oltean@nxp.com designates 52.101.65.32 as permitted sender) smtp.mailfrom=vladimir.oltean@nxp.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DpTzCx5Xc9WQGmox4a7LbgGA/GhRabAQJ/vIGsucmB0u4NUNWysQdV6mHfygrAgKhNo3JgMHYkhMdEiLOmlknapcpyPL60ywKufCT5BeF/785erZFwTJKgSGcgn513KSXZcWgumTdQgOJ6xJ5Vmno6eFi/j0dud5yxCev3pU+iWb4lUej/SBQnH4m0G1R51FsdAdvsbveK7c5YWOhow5ProCNhDyxGMRTycTRTjMBz8GGWsPq32XAsg6c5XhbatWVJVwESkWYzkyA9A17iDi7bqaI4CnvgM8SAeuQElK4DK9aZtdys9+2bQIQwTW4fe2cQnNJ54HqtymfJ7evZfVbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=29GOwAS22pO8+YLmH1/Rl+lqWrz6KUR27dDlT5VE8ss=;
 b=fGSAMMyJlzfAIHHBZ1lJutc6qzndgoNNt26r3Y/DT4CFAdYZo6jhFqVy/8ov8fBBkiKISABvpTynQWRDuLa5+MMIa6os/N8t85xU1K2AjCYrS/FDHP8JlJht7haohnoevY5dOjluSi/kzeyOdNelcEUzPQLsAhMijQReJvR+UVUM543fo2zSwZNuU9PWb3tSwuWP8/VkjeNdM0BsAt+aJJMnsxOYbhTW6qHzAqDwYGIDecIGe4tiLydbeZu/NhQRi6vmwmbD0+nZXmNMNNg7Me8IYU7Cp4rOr4u7Cn+TmnSLpSWyjdCCMz4SHfSjcEYehdjt8CC9AMH67iRQQrp5AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=29GOwAS22pO8+YLmH1/Rl+lqWrz6KUR27dDlT5VE8ss=;
 b=S2g2DlRNyDjBLorgkv3vSEp3+o0GPaxq1iXpnRhPlbIVpsp0pzSwuRdnlu+v/sAG42A+Tdk6eg6lzzrEBlMhfDmP2CqYG5bzdY2LpeHBuwhy4+9TmGJ/XPB8N4a2CWsSMMN4XmrUPhB/Rm1Vj9xT1PfnE4N/Js/XsVSFH8QFALrzP+D4EOQI8uboky0XUq9YsAVPqfm+TTdb2w2HPq2wTF0Wgxo6lGRyqPBQbF/CR8o4k/HOOPUBZMizffm+rqbLHeLlORjRsS57OnJ2DtQGMNvST03HOl7wOfL5KIo/ugzWKjJtfm0WP3HeUrcdGoWFpAKXNxdtV/4kzkiX2rpvrw==
Received: from AM8PR04MB7779.eurprd04.prod.outlook.com (2603:10a6:20b:24b::14)
 by DB8PR04MB7051.eurprd04.prod.outlook.com (2603:10a6:10:fd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.11; Tue, 14 Oct
 2025 20:11:52 +0000
Received: from AM8PR04MB7779.eurprd04.prod.outlook.com
 ([fe80::b067:7ceb:e3d7:6f93]) by AM8PR04MB7779.eurprd04.prod.outlook.com
 ([fe80::b067:7ceb:e3d7:6f93%5]) with mapi id 15.20.9203.009; Tue, 14 Oct 2025
 20:11:52 +0000
Date: Tue, 14 Oct 2025 23:11:49 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Eric Dumazet <edumazet@google.com>,
	syzbot <syzbot+51cd74c5dfeafd65e488@syzkaller.appspotmail.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	davem@davemloft.net, dsahern@kernel.org, hdanton@sina.com,
	horms@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, netdev@vger.kernel.org, pabeni@redhat.com,
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Subject: Re: [syzbot] [net?] [mm?] INFO: rcu detected stall in
 inet_rtm_newaddr (2)
Message-ID: <20251014201149.ckkw7okat3cv55qk@skbuf>
References: <681a1770.050a0220.a19a9.000d.GAE@google.com>
 <68ea0a24.050a0220.91a22.01ca.GAE@google.com>
 <CANn89iLjjtXV3ZMxfQDb1bbsVJ6a_Chexu4FwqeejxGTwsR_kg@mail.gmail.com>
 <CAM0EoMnGLqKU7AnsgS00SEgU0eq71f-kiqNniCNyfiyAfNm8og@mail.gmail.com>
 <CAM0EoMmK7TJ4w_heeMuD+YmUdMyEz7VWKY+a+qMO2UN4GYZ5jQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0EoMmK7TJ4w_heeMuD+YmUdMyEz7VWKY+a+qMO2UN4GYZ5jQ@mail.gmail.com>
X-ClientProxiedBy: VI1PR09CA0138.eurprd09.prod.outlook.com
 (2603:10a6:803:12c::22) To AM8PR04MB7779.eurprd04.prod.outlook.com
 (2603:10a6:20b:24b::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM8PR04MB7779:EE_|DB8PR04MB7051:EE_
X-MS-Office365-Filtering-Correlation-Id: c172e8c5-4695-4a80-4e45-08de0b5dea7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|19092799006|7416014|376014|1800799024|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8QPD2lZRZnILbi+a0rHsP1KCx/LTIURdIgu4h5MIRO3T0P6cw+Vv3RLIFiou?=
 =?us-ascii?Q?kmm7mabTG41LeQFMaK922HTtDN0WrosG4QsDCsw+vgjulY6IYXlBL0ETWAfz?=
 =?us-ascii?Q?kX8gjbMvqPUXR6DzAg2bqZ1ZD3HI35k6WKulZ0IlA/8aC1YU22WlJUl9lRSr?=
 =?us-ascii?Q?dvQcUi6qKB3eBlwwK2gCRl0T1ir/nNGTrOeTy8wSXE/Y6Aup0peeizQUBQwy?=
 =?us-ascii?Q?ZQIwHvs3x6385ckcHsD04pY8F0klx3NA4gwkK0BhvssPcnAxgbMgoALkd2Aw?=
 =?us-ascii?Q?5atIDy+8JH98d/Pm3/5dr5aCYN99+tO+wPETMb8+cHk95W68vb+c+dUBK+1C?=
 =?us-ascii?Q?7ZrAEPOwjBeGV9kUooNFqopCVPI9e0b3nEJFY0bUp6H7PhgBDuOOvrgNsPB5?=
 =?us-ascii?Q?toH6wOoiJdDQrZWsTCyBt4qyuv5s2JpZoDsUj2zaLO92pCiuWWUPycp5olFN?=
 =?us-ascii?Q?PwoyxQvgmHIK+6tLnzPf/elI+78aQe/wagJdl7ek4riZo9z5fdftRGqgrqbD?=
 =?us-ascii?Q?j4GXMDOTAS7qKHbsskFxDWoRGFy2J+yuURNkxH+GcSc1vGmGKeADR7in9n/I?=
 =?us-ascii?Q?TnXNUCBEM1+iQJq1u5Jz9t/bCIdfBNFzMtH8xoWSOaGCsSgyL/YwMylcE/52?=
 =?us-ascii?Q?BQVHJfbAhagEIFD8vjhQpLqcQaRAhpckaffEc6kUktrchZpQX/8sm+5K9V0g?=
 =?us-ascii?Q?iuwd6v2NvzGop7IIsEia/uGZKwxfwZ9kDg3w+vsho7+Eg2DLtWR0yfIwffgM?=
 =?us-ascii?Q?pMkV8fbIJwN6rvtU5Zzpno8Uo44m6DE7UoFCmpW+5wKaCqFKypZjLBlfrcwx?=
 =?us-ascii?Q?lD23iIFFklccqA70FQPfsB7aKGE+yLcPGrh0Fj/e6vUlun9xq6HmePY22w9E?=
 =?us-ascii?Q?NxBuTyh2CXT2utjaODmgn0JNRQNrPQ46csTsxxXGthgqvIvuFpnm/qHPePwv?=
 =?us-ascii?Q?Jqz+vAedCsbFGhpfr/oA/Go0tltxX7iq9m7q6h93XJXF/t/fBJBMywC2/S3A?=
 =?us-ascii?Q?FW0OcDjqrq8hJ6Vkq3lv2HFoaFMFfPMn01ajzGvpo1uIS5ObiY0QEc5L+Qvs?=
 =?us-ascii?Q?8fpPfulGKBBnPJ44sto+ujYoHtHsSX2uKuz2wYkEjxTup5MOtI5YmCZ7wftw?=
 =?us-ascii?Q?mG5z0A922ovlnqmQ9z0voSA0pJr34vZaVYjqcVJUgxIEzkmDJPL7Gj4O95Do?=
 =?us-ascii?Q?nRg98CoEzlb37zQx4HejikbrQAcaVxoYc5EzH1FOm+qxITZLfhVWhCzaAzGs?=
 =?us-ascii?Q?yuOv8GuJWp0Gy3MBaWbq5Wig0gOHV7/WR8lsJEBwrOGpGeW8myOP75ifbhAn?=
 =?us-ascii?Q?99x+HXC0qXPwN9Mvl+C4bCu12eefkGvNslzapz+UGaiOYI8WZUDFk/EZXlJE?=
 =?us-ascii?Q?7nqjPZj1WSRMavMqsk68UUInTZZkTCImvSFa9Y6vdPY9Ymq9yZoCSAyD4fiq?=
 =?us-ascii?Q?dZNsZaX8kNDCC8PsSOTy6LxF/5vIihjX?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7779.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(7416014)(376014)(1800799024)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LakG0R/GixpnnLtpBCq+V7Sch1DPS9fi6Sqkf2hS+ytcRehvP1Kw3WplvPTN?=
 =?us-ascii?Q?0SDi37X8aqkVot2r5KAmfVNcnGbGqxTBvE23SC3fJAbBA9xa8721uaMKIH4/?=
 =?us-ascii?Q?XO9USCXfhAglGAjpvSl4Wnx6wg2TKlc/950SR0sHvjcG4bjvcARKvJ+hGXVv?=
 =?us-ascii?Q?Uw4X1jeBrCvZFeSMjp4iuXyQC+GSOwyobN633TInSFnGHfy5xfmMU9aBEvNt?=
 =?us-ascii?Q?3atiia4GKye8LTcYqxwE3FtJLuG8rDa2gDuAf6EI4BOfx7kcFRiuRjPEeGRk?=
 =?us-ascii?Q?uYBE/e25OczgtvgzoEh7jGgLwIVpLrOoL2KKeUCON/VtYNKEIGMns0IFqe0j?=
 =?us-ascii?Q?ngNZsXemT0Ck2u9YAv23l+0cIKMCXWouaUHvyAQy9nQuCLJHyQYnmHLMPIJS?=
 =?us-ascii?Q?V+LLCBNwBNmZcUNLMC0EJk/441qTJlNJVzhwIhEf4xnpf2P+ilIA1/eWVbaX?=
 =?us-ascii?Q?oS2RTmX1wFhpAopKJhOzWFQHVvtBOIfhWRh/0NqPBLWJiNthPPFRMN5Zo0a0?=
 =?us-ascii?Q?e1zz8o1kZali2hRyCws3YnHmmx9zeLeC3G0LqZmR+CBxkoPAOvA9AWRE1brh?=
 =?us-ascii?Q?FhI/7lsLow1T7N654IRZ1ksYJDF0eGbS2HjZLOIxvfFtpJ5kkPNjkqwgFHoH?=
 =?us-ascii?Q?Tw23ZqzY2/Aw+6x4VxD5O0CZnvatHNOnxrkQRiLgbxXFVdvlcUn8eavC9OBF?=
 =?us-ascii?Q?mk6rLQcXAOXIlYhtifR0WFqOYGCynTCP8a8xmHpB9fesvD6WRQvCoanyZ7ki?=
 =?us-ascii?Q?nN0yYBpRPs1WHMIuXeRfNzK42eqdDoIjxOdfkqwmRC7VPRhH07tGx/Hwt4Pl?=
 =?us-ascii?Q?VfOhJva6DOVyBIRCggV8EqVsgwta1lHR38+aR09/6/TVI4/nD1aNnb/9RLqc?=
 =?us-ascii?Q?6FsOANkyH2MDZzzLhkcLs4RckkQHHlLjcFU8VbAQzUp8brE76OtaE8Da3zyM?=
 =?us-ascii?Q?SRirRtjwDLOhtq03XeDMCE2Ka5i88+idogFN2is48DCWBQLGtieOkxKBfBSE?=
 =?us-ascii?Q?3BXyjiaA/qhmhkg3MpjXDc2V/K1g9BcdrJrnkPbaQS4sKeSQOWDg+qstJcaj?=
 =?us-ascii?Q?/Jjo/K5IPvcXIvrthhWbeLv5ALa9ynjb4J6Bzv16PDQ1U8JanLQ66Uo1gDMm?=
 =?us-ascii?Q?bIIXKnrAv1GLQR42GSVTDpMn3hOsShxIbYJaUFNLQ2xE1xqgUVP3ayS3SyR6?=
 =?us-ascii?Q?gwAVEVVNjQh0t39rLzEY8CBg5wTVwXzteET3GU0ULjXrulHelFnjyFEe+wUd?=
 =?us-ascii?Q?CENtHybdXBUR1QyIoFlY6tD15rsXd1NzMlaFeMj3lslU9iInGzrzThXEh5WA?=
 =?us-ascii?Q?KkSMZoevjb/YNSmwice0lAx4zgCIw7ZR3bwpM44i+8LZWJFeC2dKfmLjKUOz?=
 =?us-ascii?Q?4e94h/JFTHChJq36LdQW5rXK9QlLyObwXWshAdH4dxvhmo28YVh3NE3y7ClN?=
 =?us-ascii?Q?tlaGGHLJXHSnU/1haiG3BvhdsGgIwyh+ef0eMR2uMGwW9SqgmLsC7ZP2lgio?=
 =?us-ascii?Q?BzYwlGt/Cu33+/BduI04pLq66GNi3RxU1HUcKMNJ4lnXKwb8QePXGwEKXxr7?=
 =?us-ascii?Q?RugXMGe24CjQWALd9nY+AE+xSR9/xo+FKa587ojcpPhJkHY4J/Dwoxwwlbvf?=
 =?us-ascii?Q?z9v2IgW+XOiEmW3uzBVAQGi7/K2P1BNrwgtUv1r/vrsXlgKx991T3iLyWxMY?=
 =?us-ascii?Q?Bwq1OA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c172e8c5-4695-4a80-4e45-08de0b5dea7b
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7779.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 20:11:52.8615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HXsmRTQ0iIMSH/YvLS6frqLt8Hm1b/a5WANvyd2eNn6eDamR49lm6ml1edfmU5JCHC99t7j3kZSiEko692C79Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7051
X-Rspam-User: 
X-Rspamd-Queue-Id: F02F8140002
X-Rspamd-Server: rspam02
X-Stat-Signature: qg8i45zc7tqx3d5z8arzbfz5mgfdce1q
X-HE-Tag: 1760472715-31175
X-HE-Meta: U2FsdGVkX196SGfes8zcWWlku/kMJW/4dxIV90/98PpcRRAb/aWOMcuKVQkB4gip1992qQ9RZC5JzfNaHovmD0vknm2M6alxW/3NpTNLUxtERQ/KuOC3D6hrYQ8cNczK7S6oR86al/ungq64FAeAjHDHSEvShWDDdCHJNGtqJ5ZgleS0vAFpafTYD/o8nPr1PJJaDMoDIuuhugljQKdYgUwDvV1DyFONz3ixAVuRvgHSuD7zWuAPNtx8KLF1X8W/A2i+3U6KbukFolT+4lD+JPL3uvyw+SE8Q9boiSk4r7jrMByV2EpXbh58SogIudfms6JeKNSi1PTMDmg1JWDBaa9t97SkybQnAsBPDJ9hacp8hFbncl0fDGCuTkjUFKEWFADD+t55ub8Gk8MWd6mdatCf/ERoWAmNL81GgEbe1WAR1S6DncQjiCyUEjj6jqEawALKlZmuoI+BZS9abvyEOL3nhmueKn9QTU9IBTeusbzjx19wARNs/iuyxjWjfZgj5W5bbAxOfL04V5awh5zLJF+Hkj5FLwmnmB+Z3u17w4fFWXkS+F9CPe1NLszQcZ6a8JbaUFlLio/Ih96nq/693oimTuwZ76ts6KuzIBSq5yVKcIGVwBTVw4cDveK5XUCxkuZ7eOu30JMJDqyS7I+mkK06DiAbFCmdkIXoUbyVoPKX9rKaACTZ6pNG6dVSGzW8UFKozVnPxCQaQ+MzdtzNHCjZx0HsIzfKufRtnSP9FZWb7XhTu+0bsmAqHFBt3kkL3cg5FA9s/rVAvWJ4xOAMrGoJlzmLbIZzzZCAHkiTSHqc/S+gJ6AbYSy0H00yCL8W6yM3llUMjx6cIpqhfqY66yk+Qr6QaYS32KBiNP8dvHZB35MyJxFAZ10zsYIUb1EoQg9u7Zbdsqze0aRC5Tny3ElZT3jy/JbhbR5018wiQm2E0CcOA3MhsJCpJ8TsHS/guSYVM5AYvKDJzQHH0sF
 iCq/GMfA
 XAt+VOhq7CU20NBGqGmXlUnHBk8hF9sukKaQtjIWhUglgIOUQ0w1Dd11PCrLwknzy+4dcCsmAqHW1c4zoFVFfK9nfQSVW407x14rBX77nY64eQNM8XdjExRDk3GBaD8LR+vtkL4rQMm/5bhtRZz5NXf5o9KUf43twNpWmXqb+BcoaJ6dyy6XwYTpXfjdBqjnmeGTFyO3kulDtlrrRh+xP71RK5aAdhVo+vQbAkqLYM0mYKv3gvREp+8xnnuUjBMkBi26mOKDNuZtG7TQ+q74LPZKF+kMWAE3nmMpmeUXEYESbjUMVifK5JTDL9iQRhbFKhtlZs3LpZh3cT6OlIcEhNPu/i8h186K9dI3iUFjYNmgisPbL0jSfKglePdCzeyyJB9hXSxDnBJXC/6W9HtxrOLn9vh6KWEmjyXi237I/n0mUE+Jn1xmS7plP5EE+B9hsMqRuxOmRfcqxM8r2VyCsdorW0ssaipUmKu3vJZIJLcSAcHeXLxopzhqyBI4GGfQ6ufXzJ8OUTVVQie9JMbQgXSOaaeF/KBcJmT5EASvp7L1SDOBHveOsMQNLe5PINorhNn4uqdD5BaXE9+fNSTl7kj0gIyx9moShugphJLyS2fRojqU2LZw64ywuiVkVm+WQuVFx1gTyAlNPR2nmrC02gnqh2LSqNY9WloLODNgTFwot3ps5KLMLsN9V5xjTni44hbHp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jamal,

On Sun, Oct 12, 2025 at 11:52:54AM -0400, Jamal Hadi Salim wrote:
> > > Yet another taprio report.
> > >
> > > If taprio can not be fixed, perhaps we should remove it from the
> > > kernel, or clearly marked as broken.
> > > (Then ask syzbot to no longer include it)
> >
> > Agreed on the challenge with taprio.
> > We need the stakeholders input: Vinicius - are you still working in
> > this space? Vladimir you also seem to have interest (or maybe nxp
> > does) in this?
> 
> + Vladmir..
> 
> > At a minimum, we should mark it as broken unless the stakeholders want
> > to actively fix these issues.
> > Would syzbot still look at it if it was marked broken?

I still have interest in taprio, but at the moment I can't look at this
any sooner than the second half of next week (unless someone else beats
me to it). I've added a note not to lose track.

What is the situation with syzbot reports? I don't actively monitor them,
only if somebody happens to email me.

