Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72168CAC587
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 01:29:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA8948E0007; Thu, 11 Sep 2025 21:29:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A80D08E0001; Thu, 11 Sep 2025 21:29:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96F2C8E0007; Thu, 11 Sep 2025 21:29:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 850648E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 21:29:54 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1BEB813B707
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 01:29:54 +0000 (UTC)
X-FDA: 83878866708.27.7371C5A
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2088.outbound.protection.outlook.com [40.107.243.88])
	by imf14.hostedemail.com (Postfix) with ESMTP id 44149100005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 01:29:51 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=B106pWCO;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.107.243.88 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757640591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BfUotcvg4cR12OCRbrVvsZqwgln4H1H+i4jTDDVsZbM=;
	b=2BOLcpW1t3XPOEyOQm0YhLla5feK8yWJ2DqQXBUAYvCTiDQJfGn5vbproKfBgYESRH1WaA
	MUNpU3LH1ExOGtwaWxrH/auuKh/PgJOH9rwqru9a40OZF3SzvgA4sMMcSNr30jblP5xExb
	Hi0nLuQwfpDpQqX9QC8yyCk5Up3aq6M=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757640591; a=rsa-sha256;
	cv=pass;
	b=OUR8f5JW5ugI3oxOfdOYJ69XpxC3macs8XC9z+8sBlnYIY7TjMDZ4pKf7AJsR/+ZZrBw4/
	imPsGjGDNZZ6RZ8XC6cPihrnPUr6K4OsTcxCI5psKHU89nVjgTQByKvYPskOMyQ+TyJen9
	FrpZDlyqGfp3wKWScTG0jmnyLLXBL0E=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=B106pWCO;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.107.243.88 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lK6MlCI9lZFhKJ51hdsqlOZ3LdmdY8haf07c1AijsQDyylUVK3FZCM2JQ02lR2u1tKsiSRYeUL7Ulz1sQybH/+ByDyHdeBBRcFhirRIQmPkYM1M1Z8NlS0omHicSc6EWdkmMOgIsDu2Zk3kWXBQyYj7M/9Rrq37MoGAfxGhtWRCGbt+GjO2BkMUnD/0AAtqR2QHXI3Iecp/G1ElG/jgpbAVjLwdOa5btXjCcIpp/5dJOOPV4UXc2Cb9gK+C1M3St5EMJQIO6DOYqyKD/un5REDQfb0huEd+gvZcHMie98x0ahDOao1nqlQKKkxEbRB2pFUvhHFT3UDw7wXnjhHkGaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BfUotcvg4cR12OCRbrVvsZqwgln4H1H+i4jTDDVsZbM=;
 b=LYHODxYh+JwGUfFXcHMxxkg/3B0oo+hGl0Ec7s+KUEavDIwd4l8J4O68yIn96Eu8JZPM2EXM+8Snrfn0RXVmu/wWA18DptMvCubebaSlRG9O6VYQtXWveJaT1NRHfpKRsCbQCVQB2zYQJ/C3BK4UULpSXh25hOgNwW9Hh5mtAz/6RZp+ydX7VpDkRUrizWhY34GvafinTqp4OBYlFuOW+7MGKXuiz8t+RVCPgU8L7YAnG1fz3j4K5m/DXUMzay0R4xNtweq5avQfergkXEdt5b6ehJbcReW7HGNFtLHqnUPT9qOKw80umsP+TOxNDjQR9h1vFuEPV5VpLVNWNLJjuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BfUotcvg4cR12OCRbrVvsZqwgln4H1H+i4jTDDVsZbM=;
 b=B106pWCOl8ciGHlZDVutSfR8wGOFk7Eij3XbLCudR7EBMt3QQskPGRCMrFsqtusGPXuYdCH63pYazB+O4DCclLjBHeDnFSj48Wx+LFWLYd7suMw5bAb/kh74C0+oHON0OlLUX+kTnXY6WNUP/Krz3sZaC6Q70AtwHRR9HbPOpe1S0UF2KiL1UVEPHXBQfht4urA9T/XdQqMZ7s+S6bNK+iB6qxWSDiu6vw5jEICiZlkQzS73XmICZPifeAX5ViFk8GwYYwgCoZF//FT1SrZGN+Zul7dVwLo9/fpTviLLBojPsVAFeijMVvdXVZs2avGGk8QroG84SQNaMNnRF726Ww==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS4PR12MB9635.namprd12.prod.outlook.com (2603:10b6:8:281::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.22; Fri, 12 Sep 2025 01:29:48 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 01:29:42 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 wangkefeng.wang@huawei.com, linux-mm@kvack.org,
 Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH] mm/compaction: fix low_pfn advance on isolating hugetlb
Date: Thu, 11 Sep 2025 21:29:39 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <ED7450E4-51F9-4749-A74E-C3AE8927E577@nvidia.com>
In-Reply-To: <20250912010721.zd67xbfdava2u26e@master>
References: <20250910092240.3981-1-richard.weiyang@gmail.com>
 <20250911012521.4p7kmxv46kwz5fz5@master>
 <5F7DCC9D-4CA2-4BA2-9EA8-F04C3883E289@nvidia.com>
 <20250911032751.khtgvdhcqzyf3rgr@master>
 <3DE28F4B-ACB1-468F-89B9-D7750D24BE4E@nvidia.com> <aMMGbPX9uUj7TfoG@fedora>
 <20250912010721.zd67xbfdava2u26e@master>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN8PR04CA0066.namprd04.prod.outlook.com
 (2603:10b6:408:d4::40) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS4PR12MB9635:EE_
X-MS-Office365-Filtering-Correlation-Id: cfa3f2b5-5d21-4c59-70eb-08ddf19bd914
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dwj0xWK71AiBoygb1UCAhTk+bipHNWjIc6c0yA2Thzb1ATIfc5G3xZjRZ3p7?=
 =?us-ascii?Q?cJkF/fk0ORqD9mHuwYkP8qq98dNNYvicuZ7ddmTlzka9cJINQerKMw5KgjAs?=
 =?us-ascii?Q?u2485t7IQs1+3ohh9oY0SV9dIP6jYlt/b0CSFzG4Oo3gh0HdRcdyGFc/Lohk?=
 =?us-ascii?Q?tHgseDC0m0zj9sjCaZ51hOwWCGOoTivf4/OJ9+86u5v3xUkfyNDxB6xYfOt1?=
 =?us-ascii?Q?87Gpg01gHxaaJosaSL3qs9noBHB12Jx+eaI96YdUC0gcc6IoCiCwks8PZ0XK?=
 =?us-ascii?Q?ofiR/7NzV5QW8y64ahAQcc1Z5XTE3fXqHhiEX8VRsrx0I0sqgLeuNH4+bbM/?=
 =?us-ascii?Q?48NxU08hLKLIYZrT1k95awQziiwwm+k4CvG4gwySqGAtrVUAbEYpfr8ROuKh?=
 =?us-ascii?Q?lDtcWHW4o3G7A8P7YlpJ/0mshCyy8FUn3d6WmM8kTsHF90F487bIqTr584mQ?=
 =?us-ascii?Q?KKM5raCNPHJKkc3CM4KFJkwnF/hBnqLLSwnVPOExtLxsywMx+9kYTD7D4h71?=
 =?us-ascii?Q?hDKgS/8FKr/OuTH/4PiFtawa72A5yOjNImn5HhmoaKkiupEmO8mjgrpulijA?=
 =?us-ascii?Q?CDf0ba/Bx7khjLYOt6s7Ei3uQ6W8nWAEyskXFkCH/50KLlg5IwJsEC1wWsTU?=
 =?us-ascii?Q?GONjnu97Gj8XS/fHTz4zgzK/bRuLR8HlVFFX6Wt6M8wXkhYPUXaW/h8b7f+D?=
 =?us-ascii?Q?ItEZZCoJtBMpndCAVWhe9c8mQ+fxeqTd0JJrF1XC7PMJc9VrAHdSnwwY5k8M?=
 =?us-ascii?Q?Y351xWcu8Fe1mda0LT3ZvvOW04wa6WVndcky4InBqVna9vdWH1dg0D4fmN7X?=
 =?us-ascii?Q?RQRvLW/zT1skD6RG3wxDqAdFMADzGwkiK0yA7F+ol9Anozl4qVhlZHKAslsO?=
 =?us-ascii?Q?dcLFEPbt0xhaEOlzJRE1DNimx5XulTeeD1jpDx28j8OAGzrVBd98cBVZCNwH?=
 =?us-ascii?Q?qb4+Eq3yuGkDfjBzYV0foD7YkwEaOvTsw9oPZGR2B9iRzJOj/xbxIznj20AR?=
 =?us-ascii?Q?LL8iLpks9GiVlKuWboQOx0A2gsfNEsQhuwCtWTliaN2YV4sbvEA16WlksxS1?=
 =?us-ascii?Q?/aLHWeonrbkdJ9jwAto9m9U5IO5AsBma8Z7N3V7s0gde5kPyBFj+DsowkXqz?=
 =?us-ascii?Q?s4VPdG3jygwpWpbgaaBdWtBrK8gt/z7Qw/6qShpAzVrCJXZuEU6wwKKFGMdD?=
 =?us-ascii?Q?m6/S4KolFqKqxGPn4bcjMzvN+XqCcp55CxCyQqo48CjcXD7nuSFqdWV+ydbq?=
 =?us-ascii?Q?vexNHEw8n8Dab1QGkH+e4nMhdNpD7oEkTP1xdKBq8vins3E7ErpATKZDx80C?=
 =?us-ascii?Q?W4UK4WPXTMJ64whdu9MTswbvGcQBHsPGLIGwqKXdR2aVoR4gxseYpiZ76plW?=
 =?us-ascii?Q?5T/WW/lT1wdxKUg0wjDc0EQ9sM2s6R29m2IbhRq0VXPu9Cfiw6f+TuYItcRP?=
 =?us-ascii?Q?Z2qnXDegeXA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?j+tDJhU1O6EtZMSsGCdVL3so05ZfpropMo8Qeh96PSEF5ZmRYpd1vSc9tMiW?=
 =?us-ascii?Q?a4jvB1t5CauHWsm4BNLmM5UPznPcAlb0Z8J/KpF9vmofvJ8Hyo83RbwCnWN+?=
 =?us-ascii?Q?kdjdo3hIp0G+ecNtkH3h3OwOh9PaoqhhiPIo56ehN0PRwBf9nE7Bl9/2pSeI?=
 =?us-ascii?Q?13+RQoSx3eRwahAWsENMF7E6OKDxf5wWLMhXf43bRHoSQKOHVnld4TKLPemn?=
 =?us-ascii?Q?lTLLrp/8yrgWPfeZdmuc5ZQsgl2i+L3vDooVN3Tds7unD1AOBnCs54keeA9v?=
 =?us-ascii?Q?LLXhqZoJssjV+bB4u510pBHDg2c2wfCUolTCRnTAQ1OqZCgMHB2u0pRqLU0N?=
 =?us-ascii?Q?LtcJJoWglniHEIhfKALTgBQLwYUpOy8ifax0/49SLrQQO8nPuHl4Re4f2s0b?=
 =?us-ascii?Q?tMZnXyEJB5RMEL5/vwMVKM4RdY3Env7eiu4B59SGuYVRhwQABf2NoW1Ap0yx?=
 =?us-ascii?Q?e9Ah0jh7MACTSVBU1VIIBfHRr4dbAcAUaTCP1zagm2vuQLjwDZ92Y2Q4DzSj?=
 =?us-ascii?Q?4KIbALCyiUsgDk2yULCx65/4wjvJ6YeXgKMDqmZ6XJ9o/i3L3YBPuQ6xFTAu?=
 =?us-ascii?Q?PQeph2JEeBCjnlWrc8ZeKaz4KSS9tT1ebwjlEtWd4QA76CysLNudL5brQfYn?=
 =?us-ascii?Q?Y9egXtlmvv7NHB2wPHXP+R9qlMrpzL1yk74GyejGP6Fpu7JhkrZQ4l1EY3YX?=
 =?us-ascii?Q?H5ievY1vnQ5j8DIYmiV4RMLgX9t7zWD96B21k2bq84m1AtQWAQi7gTcFKJ/7?=
 =?us-ascii?Q?dGGINE5GvyRLcE2sWwhIhteTFtyod9KCj48RygcubaZm21CX4//Z+/rnMaQl?=
 =?us-ascii?Q?OxwAoP/zylZ0I/A7ibG3zu/PO9FiG72f8MqepjtJDEwveE/qDMkJbac+5L5A?=
 =?us-ascii?Q?is94tqYQc1gqiIHodl4obAHh4v1WcXqzzjoWhnlaRJ0Hmu8oJgE0ahgh6d0c?=
 =?us-ascii?Q?SZU52TdPrkrXlN84IrYvHzz53mkmrUE7iqUOATeQeevijkf/LQnYk36ko8Hn?=
 =?us-ascii?Q?PM26LIfH5EkmdS1b55PMpYQEwERzRcdKKKLM6UjgCtJJkv/iz6/w6A8aAVcx?=
 =?us-ascii?Q?ZPn9PoE/0cw7Wu5txTi9dSSQtY/TmvWuRnWpPED/9V6ga5kxVOAKHpOHci/T?=
 =?us-ascii?Q?9gAR3jtU+RAyUN21O+5qIdOaNnkBeClPMjz5OE5d4rE/a6OvH7L5NHK+t9eY?=
 =?us-ascii?Q?I8nEAecP5UjBwopfUqzM27Y3R3DePT6YKKopOv4cAyFwRsq80dDEGe9bZp9h?=
 =?us-ascii?Q?WLm74m2AckU38+3mfOYL2iOh4khZ3MhLOK6Wpwqwbpw++rTBRnDucfwu/QZC?=
 =?us-ascii?Q?fYb6cMTKcBthsI5a0i5ZfJzool2+Yircaw22mAwJ9+on/P/q7ZtYwwuOYQbj?=
 =?us-ascii?Q?tLiiPRBbecoAkFWYlL5EpSkXh/3b1Itmug+/c78w2TD3sH67D9K08OCuh590?=
 =?us-ascii?Q?moWMQQclAylBi84kFnZmdngDsBKwT0UwDwAGvkf1R3EagR7rgXEJEdhi9Axj?=
 =?us-ascii?Q?4Ee7SXRfEOB8rOySS2a40Eq5Zdy+TrNhE+j6R411EqUXchmT2/rx7CrP9tae?=
 =?us-ascii?Q?0TbmbngFQ54wrY6Em55z0O7dgNDGIoDcU25CBA3t?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfa3f2b5-5d21-4c59-70eb-08ddf19bd914
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 01:29:42.2241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dA6REhH0I+3y/z1EbrBLtcUkmEY09RI33kn5LCm8lBqzY6pP/uDdKChSFK9HsUWE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9635
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 44149100005
X-Stat-Signature: ft5wo3sbscpndwbhgrzzm5agqb3if9rq
X-Rspam-User: 
X-HE-Tag: 1757640591-609696
X-HE-Meta: U2FsdGVkX1+8HZVh0t/AiRhylESA4EujnmcycaEaD67jCM60NTlPJSq8VBJRiIGG1KzzalgwCyLj1eNI1GDtgMBIsj9o27b3ONAiTnK5Dmf/niwaYL5KcfUePriFDbBsLy//nSBJD37XnPfSi1NlhrC+bPAiRXOh3wpv0lCRVImmdv63bXfq1xrwWqUuqpNKjgph7oQzwA7RNy92LDc39osCDrnux4HdW8AAzRp+fAn7wQUUzWlvtYnIX+cA2BTSFtbzzs25mmVQTqWNcbDlMYy/+LLMm6eTKQWmDn642Fxmuh5gopx+r6l/GUcIAFERjlfmknCQaijlC2HNqt59YAZ00Ee3F+Bae3cxImwI5kydcbsi4rRNnv2ngAhpT4UdRy12AC6lYclcAK6e1xqepDuMN56LPhg073DCLwGmIp9RR8hX9aLN97l9Iw725tesLIZLxqvwW8MlytS8mIjJwyaPhf3c6X7D1vtOJqSwhRSeLAtm3RJrgS1M5PaQ5e3CmAvq6I+gXpY/5IlXqLWN76N+/+Jr65OYKGVKxDLOPwqS+kjkyfLT9me1kAKmyFu8/paAN3wKSlVNLdcmBMNoc2PL1+F9jiy9K/KLVbjsdio+coDIZSh7MKr05RSlCUNW06p+lVSQRnjDm1Hrt2eRpLhgW2+7Yuw+v/3iI0y0lfN4+ZDmC+ktqKGrpQpNOKLNfubTpc+E5IylYicNSOQx4V8mDPG/GMxaxAujp/3/qHi4LVRCzxor9HqKgUATvWHShonKwQ+AXsrdTEp0xpsGuEQpOHYrZpb4MZNWmLKejjJRct/XswWJudSfKQ685Q1yWFCUoexmQ3r/v1oAp4fdhdMQc1oRUeeu/teyxrTpMyvIAjMW1gSqjRcaIUAE3tzqimMsVgyWy2KDZ29EZrxxuciC88diMbM99YGfrkp/yj6xxOuyVyQAEkBA/+fk1v9ihw5kKJjMteDv6aqfRUc
 oGa7890U
 BomkzK7UmwjmnCxSpuv3je7az00RMIi2jh/msOpIfMvypAOuUUmocR59PDoWQ086F5S+ODsbrRCDVwcHH15y+WMPphnCqisPtzDdCd5/ZCYtuLZvo67LYm9phMrnH1tDV+WW0ZH1hZBnmlM4L5WtIKQ5Fsn49aCc1DxPx7cVUXIIjro2C0IdyDmVRc2fRb7V+EsKBSGYAHwzUpxVEC734nqMgNVZFHY26BhV4tPr9NjSEj2gZAEASKvwJwm9AxOoi1nQgg28x/vuWLGt6ttpWXruk9MyD9TasZJUCSNqGd+nAxi/pUwhHCVaKgLr9u4D93bAVqG4ch+a8qs0FEXVt1X79SKUbx+KWYhlY+W4SdrTi2NCu49faJI6uxdZLq1uAYXKYCosvJbBupOZbKbEL9LBm9HfvTfMV4Hm+u+zs4bKscSVI87b6MqNT/iqaJjVsJaDbDq2XijwiWEg3Y9bByEbA89rIhIlBzq4dbSukFCulJES4c50Fm5pmZM6GJxwCFTW+xmIP3+38NoKBEIGQZqYU8EjhHvGBjvIshF3yXIn8bWHBMj8inlYpcx8of2yWertuAZDwLiMrvBPInnEV2PYV+1T0kFo0gd5/G9vFZRLatMlUz3xChROwzpYjqvM7KxavxI5Q8ikpwag=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11 Sep 2025, at 21:07, Wei Yang wrote:

> On Thu, Sep 11, 2025 at 10:27:08AM -0700, Vishal Moola (Oracle) wrote:
>> On Thu, Sep 11, 2025 at 12:19:34PM -0400, Zi Yan wrote:
>>> On 10 Sep 2025, at 23:27, Wei Yang wrote:
>>>
>>>> On Wed, Sep 10, 2025 at 09:35:53PM -0400, Zi Yan wrote:
>>>>> On 10 Sep 2025, at 21:25, Wei Yang wrote:
>>>>>
>>>>>> On Wed, Sep 10, 2025 at 09:22:40AM +0000, Wei Yang wrote:
>>>>>>> Commit 56ae0bb349b4 ("mm: compaction: convert to use a folio in
>>>>>>> isolate_migratepages_block()") converts api from page to folio. B=
ut the
>>>>>>> low_pfn advance for hugetlb page seems wrong when low_pfn doesn't=
 point
>>>>>>> to head page.
>>>>>>>
>>>>>>> Originally, if page is a hugetlb tail page, compound_nr() return =
1,
>>>>>>> which means low_pfn only advance one in next iteration. After the=

>>>>>>> change, low_pfn would advance more than the hugetlb range, since
>>>>>>> folio_nr_pages() always return total number of the large page. Th=
is
>>>>>>> results in skipping some range to isolate and then to migrate.
>>>>>>>
>>>>>>> The worst case for alloc_contig is it does all the isolation and
>>>>>>> migration, but finally find some range is still not isolated. And=
 then
>>>>>>> undo all the work and try a new range.
>>>>>>>
>>>>>>> Advance low_pfn to the end of hugetlb.
>>>>>>>
>>>>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>>>>> Fixes: 56ae0bb349b4 ("mm: compaction: convert to use a folio in i=
solate_migratepages_block()")
>>>>>>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>>>>> Cc: Oscar Salvador <osalvador@suse.de>
>>>>>>
>>>>>> Forgot to cc stable.
>>>>>>
>>>>>> Cc: <stable@vger.kernel.org>
>>>>>
>>>>> Is there any bug report to justify the backport? Since it is more l=
ikely
>>>>> to be a performance issue instead of a correctness issue.
>>>>>
>>>>
>>>> OK, I thought cc-stable is paired with fixes tag.
>>>>
>>>> If not, please drop it.
>>>>
>>>>>>
>>>>>>> ---
>>>>>>> mm/compaction.c | 2 +-
>>>>>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>>
>>>>>>> diff --git a/mm/compaction.c b/mm/compaction.c
>>>>>>> index bf021b31c7ec..1e8f8eca318c 100644
>>>>>>> --- a/mm/compaction.c
>>>>>>> +++ b/mm/compaction.c
>>>>>>> @@ -989,7 +989,7 @@ isolate_migratepages_block(struct compact_con=
trol *cc, unsigned long low_pfn,
>>>>>>> 				 * Hugepage was successfully isolated and placed
>>>>>>> 				 * on the cc->migratepages list.
>>>>>>> 				 */
>>>>>>> -				low_pfn +=3D folio_nr_pages(folio) - 1;
>>>>>>> +				low_pfn +=3D folio_nr_pages(folio) - folio_page_idx(folio, p=
age) - 1;
>>>>>>
>>>>>> One question is why we advance compound_nr() in original version.
>>>>>>
>>>>>> Yes, there are several places advancing compound_nr(), but it seem=
s to iterate
>>>>>> on the same large page and do the same thing and advance 1 again.
>>>>>>
>>>>>> Not sure which part story I missed.
>>>>>
>>>>> isolate_migratepages_block() starts from the beginning of a pageblo=
ck.
>>>>> How likely the code hit in the middle of a hugetlb?
>>>>>
>>>>
>>>> OK, this is a kind of optimization based on the knowledge it is not =
likely to
>>>> be a tail page?
>>>
>>> No, it might be that most of the time page is the head, or people ass=
ume so.
>>
>> For compound pages, we will always have tail pfn < head pfn, so we sho=
uld
>> always find the head page first.
>>
>
> I think you want to say tail pfn > head pfn?
>
>> If you did find a case where we somehow encounter a tail page here, I'=
d
>> love to see it. And then you'd also want to make sure the other compac=
tion
>> trackers are appropriately accounted for.
>
> I may not follow you here, below is the call flow for
> isolate_migratepages_block() invoked during __alloc_contig_pages().
>
> __alloc_contig_pages(nr_pages, ..);
>     start =3D ALIGN(zone->zone_start_pfn, nr_pages);
>     alloc_contig_range_noprof(start, ..);
>         __alloc_contig_migrate_range(.., start, ..);
>             pfn =3D start;
>             isolate_migratepages_range(.., pfn, ..);
>                 isolate_migratepages_block(.., pfn, ..);
>                     page =3D pfn_to_page(pfn);
>     start +=3D nr_pages;
>
> In the loop of __alloc_contig_pages(), it iterate on each nr_pages rang=
e. And
> nr_pages seems could be any positive number, so it looks the first pfn =
checked
> by isolate_migratepages_block() could be not aligned with page order or=
 less
> than MAX_PAGE_ORDER. This mean it could be a tail page per my understan=
ding.
>
> Maybe I missed some point here?

You are right.

But nr_pages cannot be any positive number, since ALIGN only accepts
power of 2 as the alignment. So alloc_contig_pages() might need another
fix to handle the case nr_pages is not power of 2.

Oh, after I checked pfn_range_valid_contig(), I find your example does no=
t
apply, since it returns false when any page in the range is PageHuge.
This means with your example, PageHuge branch will never be executed.
But alloc_contig_range_noprof() is exported and can be used directly,
the @start input can be any pfn, which can be in the middle of PageHuge.
So your fix is still needed for this case.

--
Best Regards,
Yan, Zi

