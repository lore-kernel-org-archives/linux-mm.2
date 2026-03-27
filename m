Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1698F10F2848
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 15:48:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ADE56B0098; Fri, 27 Mar 2026 11:48:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75E836B0099; Fri, 27 Mar 2026 11:48:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 626706B009B; Fri, 27 Mar 2026 11:48:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4CE906B0098
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 11:48:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DB12514077E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:48:38 +0000 (UTC)
X-FDA: 84592275516.21.3B93F7D
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011010.outbound.protection.outlook.com [52.101.52.10])
	by imf28.hostedemail.com (Postfix) with ESMTP id D8CA3C0004
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:48:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=D4ImGqnJ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.10 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774626516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hE2ZYG1s9Wvz0tu5/QCpOXOodj0maV7m+IhCjCYQYh0=;
	b=2k+521fC/w1j+JEzG/eUdtmUiGVXfEJ7C5hvlWZWaK8Hr5iljjAr/7AyyrF6q0ofk7fX3F
	YX4l7LUcozbcMowyz0ZBtEjU+wh8GihTAlpw4LGmPNPOLPziGisNVsyzKDjtmZJB+/ZsAg
	yFBF5phxd6yF/4h/wmMifMYtz5ndtaQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774626516; a=rsa-sha256;
	cv=pass;
	b=lY/pdZYRYgtl8MtDTM7dzL7ray30uacK4bRAyTWGsuK8b0ne257wMpEDnlEPoTFXSg3bl7
	HRqRC/KIemhuxDskIrO+IHXMdm6YZe68IyLgg83L9LPUkxzaH2LDoPnhUCdY08vVdn4UWw
	/i3mb/XDAD1J9V8BYEsWAuJH4mUEhfE=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=D4ImGqnJ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.10 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HrOFVKgf9Uu1C9xQfqR1wlBEgJpU+wWT0FNqSyACAuliQDHdW9YevUbJEnBt6dgd2f2q2leLiLGFUrMqx1+KjCqtJE4aeMAbGbk0Q6kz1kvILsCsA6mgh1zFbLljQlqXn7xEXP/aWUlaHdNdDS4Auxic5mhhPB1U7BxtbL7H0NrdSyZHzhQ31+R1BMiu1xJ4lF4fBil0cgHPMK3+R/88JKoockU4e7n/ctJjs9EIBu2yBb4cg1RtmRe3iRF+GDF1b/P3pjxLMetY1EySd7tuELFWo53vdppcO6UUi9JW/1edMx9Mnqcn+s5aM62GAIfto3fBzndWl6V3eT2o/bgzsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hE2ZYG1s9Wvz0tu5/QCpOXOodj0maV7m+IhCjCYQYh0=;
 b=XwOoHoRzCBdsXAgyiFGW+KvYIHcla8L3IoJY1Hn02zuwYHBMIXIGUfImd8hXcTYDGHv1aNH+RxjYa87KyhRVC3tOGm9yxNMToHkK9RdNpERwQl1kUPKzDY3UWB5M5k3Ono8kmKcVNNs4fyGJhZe0rggfwqhc16e5AHZukiS54NR3ozeOspwRJrf2Q0d3ZYHWKg+ntrb2qe70ucT85KU/843xM7FDH9jdEB43VSvM30J7ok+yVn0bhLdF7jh9rBqcfw7RRarioFYqpSH9YDpp2e+ZKdjws+VUghWagN4msunQ7ResnvlQPcw+afiRTb2517HQ6KUy4Xx4xd6dvW+wxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hE2ZYG1s9Wvz0tu5/QCpOXOodj0maV7m+IhCjCYQYh0=;
 b=D4ImGqnJXL6Dv7xCL3HTJMUhu5zfEGFV9dqt6rLuocrahUZ3jhvqVOueU3/0wA05GAdV6/oKb7tg4SrjMrdhBnVCvukTajoG91dHcdaMUTsP/31gk/idDbN5ea3iPPJ3eOsXOl0NJ2gfIMDGCZG2Y0HKe2dX2z1VJqdmmqclEE8aCAQSxoi7hRpdegaHqr3LPRNuGi6OJ1Y183PW/naN1YOqChlz3Lqu35ZXKjoHpWOKSoRCVHgIL7CLzpiYmCRsMQjrbj8DFVCi39uRnt4vUAXzsCPmG0fig4fkoxR1DDSCbJ216Vv95lJgTXokuMYfgFhuVCGmohSQxv+gBbqt5A==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH0PR12MB8774.namprd12.prod.outlook.com (2603:10b6:510:28e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.10; Fri, 27 Mar
 2026 15:48:30 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Fri, 27 Mar 2026
 15:48:29 +0000
From: Zi Yan <ziy@nvidia.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, ljs@kernel.org, harry.yoo@oracle.com,
 yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>,
 "Harry Yoo (Oracle)" <harry@kernel.org>
Subject: Re: [PATCH v3 2/3] mm: memcontrol: change val type to long in
 __mod_memcg_{lruvec_}state()
Date: Fri, 27 Mar 2026 11:48:26 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <475CC3E5-2A90-42C4-B0A1-93986B0E43B2@nvidia.com>
In-Reply-To: <70a9440e49c464b4dca88bcabc6b491bd335c9f0.1774604356.git.zhengqi.arch@bytedance.com>
References: <cover.1774604356.git.zhengqi.arch@bytedance.com>
 <70a9440e49c464b4dca88bcabc6b491bd335c9f0.1774604356.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0010.namprd03.prod.outlook.com
 (2603:10b6:208:32b::15) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH0PR12MB8774:EE_
X-MS-Office365-Filtering-Correlation-Id: c4846a4d-1ebd-48cf-a43f-08de8c184aa0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	cxB/L3Ht763jVVtsp2j+GBQELt/Fc+g4zHza2yBrGAoRnD0wC3o7Lb9OQRYtUKFTNmo6IhhuVJUS2uWfBidg8CJS0S1n9KajwDpea+pC+cB8TsNOeUkemS86iwetGAYTgMJGjV8U3IGi2dIsZjRb/tSv0HJGO1ZIbBaJemOjKfZKmYu2YBJpx67Gy8GxmnHXjrGuk2QEEFJHvBLBq1YJS83Mo7Y+2L/WaarMfR4RQewEsACCW6a0soBUtirZ2BVBtb2iYdn71vhIOuUizWShQ7fEMiIMXwC4N7VVP1KvjZYctwVjos5mjzNp/K3OuQoRiVNZ2bW/+LUZSlZvLhiSe/2l5JqzjvGcDiNFOFSnUSbhVLZC2NYh7Salltay8Dfp8FOmMwNdofADq6iyZLyHietNN+83NGl5XE2IE8ARJ7QoIcBzZHQA/XXSpbk7urCAJGYnbAwknHFMKdoUbGk8VKlrjTCiT8U3gW6NCnL735063lUUHsPPaGaM+QzD8gVwOS0lA8XWQ+Jm0alyoIQnfCOCnXfjPYEL9Q7zsJyzEcCJ9bmNt+eg4Iwq9PlZ1XpNJglJUwOT86G66LwBOE6aFUZaoY7BmOh7kOK/pA3oLWN4OVGT1w87Fk0NRpd2AajUOaP28PW7OJubH1Bd7CdwMZ/gPysKUo/HoP8CaNR7gxHhYssevRtniqIId6rZdxSsT6vjs8VuyOxkTa0lbxcInRNUEeCv7j6ZAeTJGe2/o/k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?auLOeLluG1rd2ip+V7CpFFZ71Z2VWHidUnfJYZs2O9JZGp0XWxjjRh+XJjZj?=
 =?us-ascii?Q?kjGAs5QoywYnlHBwYLCywldZF3btuZI45BLLj/Fawqreeoj+855Blb2asXad?=
 =?us-ascii?Q?A4w6Fh8Qe0tGBZ6nF0sQK06JPj9UWCTCCIpbZwMSD77gkwhmUmcbeEzz+cVe?=
 =?us-ascii?Q?UkV0uxN50d7nqnAy7gaNC9IKE++odKkwEW4hhJu+CKYE4hsFbfFRZvDFPxbW?=
 =?us-ascii?Q?qGPblbCV1JdZnSPSnKxrkJUxZg8nw0UAKUyQov91S84HAMenQNHiV0+cxcV+?=
 =?us-ascii?Q?kEzoAnMLa44dZZDCjs/MXF4f28egQtJ+ZYHzRd7O51BImZDB4YFzIWfF4y+6?=
 =?us-ascii?Q?P9qbdN06Y+6DOipZvmUr/GBCn5dOtllF6N2VAzlDyv9LI8Iwh+eIUkB3xb9e?=
 =?us-ascii?Q?0fmJWWuiWQJwjty4+oeTlC2tsueREeG0rhxMYohblgOZme6UzwZRL9POFYUO?=
 =?us-ascii?Q?SWsGy54LhPBCh0wckNS4DIHXKP/c/O4OZgGzm6IH26sjcifwjGO20zHVVbSv?=
 =?us-ascii?Q?UcRkomTc/Exq+qeraMIWbH+Nmx7AZx1RPfHhE+MhwTS0zyepZqXuWlhFi56U?=
 =?us-ascii?Q?Izvn0DQalyxv1CcC/KSZFit+pIH7mUhwRkDdcqTfsHSUDXrNfarZ+S7cEOp/?=
 =?us-ascii?Q?lCAb8XzAdevEgiH3hDsOCEmlEhBZ6nq9ghYp6LgtYfcd379dqkXtIkLkoYm1?=
 =?us-ascii?Q?9rgNJaiytExDusX+/M9P41XSCMUkZk4KrFKdlACFNjq/4kQfTr9UJAg4q9lu?=
 =?us-ascii?Q?igvC+18skG4oq08OFq8b9cZuc5kXE9j9q7fHh/2DB5qeunpU2xxDi1UsRcp5?=
 =?us-ascii?Q?UAVLXI+Zg786Y7m8eDPHL+6HnxldCWq8mJU1AIFuHiZ0Gf08gAVa2F9Xd+eu?=
 =?us-ascii?Q?1qYwnVGXFCKsXwBL/ab8CxLeWH5bRahYjNfL8c1gxUHOBDrpMFozz21y+UCz?=
 =?us-ascii?Q?qP+BZ/CG/V0dk4ewXh2f66h8xZXJVal1WSpjJ+3i+bo5kT0fDMrAoqWFGd2j?=
 =?us-ascii?Q?2+K8wauCwOg5o3nD1FjQZc4iSS+O52VnnRFW2yyXnUiEamoKfYiIhclrVXsZ?=
 =?us-ascii?Q?Djvwks7xAq9BMQaqXBUHqINCqSDmfThfh3JFI0mnfxAzD3tKWXC4z+7elEkN?=
 =?us-ascii?Q?GxQaO0I8oQnp3DLjS+jV5iDw8aUvQVqqU7LahUl5BcBQDjEXqzqxUJAFqrC0?=
 =?us-ascii?Q?Y4pnlOPUagVPgw7rjxHm8aVL12V3Wd9SPYYfrqN+CtVYqSrCjqvohdanVSP7?=
 =?us-ascii?Q?evsG/YNdd0MQlk4HShlPxm3TuGYSNGfAZ4yM4GFFubjJ2rTFJ+SVPjeUnrXZ?=
 =?us-ascii?Q?RMLjfoh4tg+rXgr9Tfv4LIgzSlnq6Kgx17rF+M6R5q4Pv0AJd1lkC2J+WqOc?=
 =?us-ascii?Q?3/XOVf4hcw/Mxm+yXJlz/hHJ8Ww4rwWuApBS7BeFFDTwynDYEw2MxlcjauAj?=
 =?us-ascii?Q?nVHqpEQmt6IPtISwzYlnMp+tKf824VMmKZLexXIwfqnkVfzaLcww1vzj7PDc?=
 =?us-ascii?Q?B2r6Ps3puEFWU+ZmVyarFCTy6bqcT80f50Ttjz46qTys8B081RIZkfDJPB4h?=
 =?us-ascii?Q?1/BPJZfXOTnj//XfTOlZXyBdmFNrkCnv+Ev77I8ynpQFtirZjzZ07H5DMByV?=
 =?us-ascii?Q?jWFVfslXVj6/QQnTah33STglUH1+z02TN10WTeXmVoKYkNFWGP0N0XZDeIn6?=
 =?us-ascii?Q?E2LOJkB91QRtlfLa9ARMgydwjlh5+n0Khh6s9ckELWKfHFzTmh7AUs6Z5wDW?=
 =?us-ascii?Q?YQdPhgX1Ag=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4846a4d-1ebd-48cf-a43f-08de8c184aa0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 15:48:29.3533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l4bfl5llVAxu8IIjjIaORTgzdUxZ95A5N30bqRZHAagZu+Bzap7e3hwc4amZSG9Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8774
X-Rspamd-Queue-Id: D8CA3C0004
X-Stat-Signature: mpux7ba9tosefiaxqjobagm4p8e6aotw
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774626515-917330
X-HE-Meta: U2FsdGVkX1+njzNLUZKQ/4ELmo7csRkVc1IbnIeWMtny1oLgCkadkvtfsawYQvL31iKM+ldhTV08671SsZr/OMsik5lBhiieY7sXyKRgxtfGVdAV78iWINo1aBn1RfDt+5elpgbRuUPmMbpcOxgU2CNSfiHSAG328oIbAjLdmx73V3Rhx5JTir9lqYVI4Ww93mcZilKRZ+wPYfM8wtDg0GsE+JDEOWMlZZ8lO6DCrsyEM5pVF8SECJK0hf38cnzCmjjqefb5qwc8tJaO4wiKWvAbo4gvh2t/ipDjsY/VwvsrC0O80Gqp+rNt/Wu0XCysWZc5ViRW44KlQBjN9tP5zdphozB9BJp7O/+/gBGZwTn0rEDn1p5E1QUFHtNaXoxIWtBj1AnbpBFx0tZk9FT/9wwAMRCLLfZ7Pc3w50dMfIY3En0oYwXhqu21u5f1cDE9IsC+2yIFqBR4QnIn8wIILhuyl0xYwyPWw1viC1w021uSRi6pMcAOf07awZHcUtBzs4TBCgPL6TXmHdcfTgdNLlhSpue9hvVVP5Bjf4oWrrajZ+SOrbO2fr7JWk6bHLMUQ/Cv/E8S5OqyvfTA8TLd71kVhYndbleUYzGqlO7sJKQKTTx70ORxL3ONjWvUULW1XgxHWyMXPs6PgzzXHNRDFzDevga/a8EdUgvgawLM0dYSvkFsS8QBhIN6Dw985DiPW8MXkCr51xmuZzE0paobN8nEgsP0RM1Pj5UYHPzs3DVWT2NjAJYucdUnxg2Vug4ubrMHqs8nMy5kYLz8sDq1+90ZLplH176TjshcgXBUYXCUlOj5mmocMd4UWsHrdrHlLU32QMqZgHgk6sxflMXn9R39s2th6Ji+7MvgJ6mrbry3GG+ETDBLq3x5WNcaa3MDUchBXUUgqybJ2671Fqq3ZyP/A1CjVji/brtTZxyMxoxzNcOG4OEbyRNcnLX9UmomvphuY40A596Gyo2a34X
 9RjlBszr
 1UVw0DEUEbBAR6HIASAP5WPxOG3TuUMwZYGqCwUt0dd4ETSAlRvLyiNd+seIryExlxOWtRKuB56YQ7tVM/vi80hzi5aeb7EGT4BxZyx5q821BgUTQ4gKEKlcRR1rLJPEY3eyLbCw2m8rUyF1995as4P4WSw0faezh1peC0l4ggzIHsEN50rbXYGOEp9bWAeIFymxgJKCMdbdnSgpS5H7yvard1MqtjsWKT03oyw6MBIQwQemrmPOgw6wBLbUq1+jSDqmm9cumgbhxf0R/hXYD4X2Mhbwj9QSKlbmYdtdlPaQFaL2o8y783QYern2agQNZ+axAg+130uel3zxAkuTHzP2Yv6frycz1DIiKRe48q/uMNNb95gcyGu+REWPSmvfTTwCRpwqsE/a+WAbhac7tFT5+5MaU7adLXgqtZ9ZsZE7AbzNjnEtuQoT4Hrfw00VIcPYa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27 Mar 2026, at 6:16, Qi Zheng wrote:

> From: Qi Zheng <zhengqi.arch@bytedance.com>
>
> The __mod_memcg_state() and __mod_memcg_lruvec_state() functions are also
> used to reparent non-hierarchical stats. In this scenario, the values
> passed to them are accumulated statistics that might be extremely large
> and exceed the upper limit of a 32-bit integer.
>
> Change the val parameter type from int to long in these functions and
> their corresponding tracepoints (memcg_rstat_stats) to prevent potential
> overflow issues.
>
> After that, in memcg_state_val_in_pages(), if the passed val is negative,
> the expression val * unit / PAGE_SIZE could be implicitly converted to a
> massive positive number when compared with 1UL in the max() macro.
> This leads to returning an incorrect massive positive value.
>
> Fix this by using abs(val) to calculate the magnitude first, and then
> restoring the sign of the value before returning the result. Additionally,
> use mult_frac() to prevent potential overflow during the multiplication of
> val and unit.
>
> Reported-by: Harry Yoo (Oracle) <harry@kernel.org>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---
>  include/trace/events/memcg.h | 10 +++++-----
>  mm/memcontrol.c              | 18 ++++++++++++------
>  2 files changed, 17 insertions(+), 11 deletions(-)
>
Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

