Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EE2DCCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 15:35:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B3D88E000A; Fri, 10 Oct 2025 11:35:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68B618E0003; Fri, 10 Oct 2025 11:35:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57A998E000A; Fri, 10 Oct 2025 11:35:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4527C8E0003
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:35:56 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E329086FC6
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:35:55 +0000 (UTC)
X-FDA: 83982605070.06.6BCBE00
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011016.outbound.protection.outlook.com [52.101.52.16])
	by imf10.hostedemail.com (Postfix) with ESMTP id 07489C0002
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:35:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="G/3FOaVl";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.16 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760110553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WP0LyLmlBU8t1Ez0SwLHvwkri1pVipLh/u1vjklNszo=;
	b=pJHM/aXUgOfFG7AT4+E4+pW97LPKPRW063X2Qy1puLINaaateT099WzVRa/TAocY6Zy2JK
	MtvIPhfgD3pBNPV0qJs6DQqJfRfs0KMcafnblAlB1xPFOQ2KzsN4+Pc1Svn9Pyx2bZXWaT
	x+/LMwgknJx3qzzf7JlHFHNu+G19Elg=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="G/3FOaVl";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.16 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760110553; a=rsa-sha256;
	cv=pass;
	b=xc2FYRbRjVPtz5gghMnjZBVdWkScs/XiGjssq6o9MTqUIFsS8VyNVMivPB0szlcLJzkwTs
	qUAZBq6SDfgd6hlSxkdTL81/fwptW8c7GU9Bvd8/gmoJPt9Guc+6GLELHjiaHz10v6qANl
	UWpqEHiNN9UkFXnBX3CQdmeBxJXaYHo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bx2GZoeJVNpwcVQarsvun8zNgEM/uSfjVQlWZ8qiroNBH+EdbbcoNaAjhPeYPJ3M8a6g3TD2+j8kXpuRaAdtp3mua3frRxlkTzjD748MR3V+lfp57JyQomSwAIEU6De/8uXs15GUb4wzLhnVEuKNd72/DEHm2Rh5mVZIspHG5CTs3/W0j/Vw8HFaE10EJxKD58M6hzIChFOIbkgt8ft49pbgkOYovopVbMcxHCxUmvW8r7JTFEOgD4bH52OGzCBnaLX8ood+KG6zdUD/rShqvTK7JiokJyID8xdRpODQkEMPNbXH4EVl1QZRDkoLTxss5OhpRPar2CCro2f90ItR4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WP0LyLmlBU8t1Ez0SwLHvwkri1pVipLh/u1vjklNszo=;
 b=LN1Chf67n5FpatnLGxvBrm6nLZVK4JAcOmzuqdkwDFT1NM9dVfXtZqSKFchKGd3xmFkxN73+Z2qAau6N8v4gd0zkk7c259LHRBDSHj3ODfEBdM4yuIgQPNEBDN5Pj8a7ukv784Cjqby/zScNuMTNwurlN/OgBrdFGqtcjeEeoNwa8Gf7XyJAhl1qtLLYRovHZR+wTEaGw2Yy5uudiQAyEH/UJVV8h/krjy/vlZdAy1vlEhwJ91jcZVEO2H5Ye7tIStP5WKq1JWmcT9LIXG/xGukO94cNAwyuayfMVX0+YJ9L6wP3/Mj9EhbygeZ/tAD7FDtGUawdvs7ySk61NsVBeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WP0LyLmlBU8t1Ez0SwLHvwkri1pVipLh/u1vjklNszo=;
 b=G/3FOaVlwoMyIFQ3fv3NDinP0RmzFDaBmhopupSW7xS4PhBMIltw5GWabH3pZAPpG2emaLgTdAObTLX3FQUhtQ6fBSBCLz+UnxQYlt3X+7DgZ8AGXu5sNJwFkFjkASkiXbGz+3A8HMV+kEe+aD3IAq5k/dANdH83GUI3qGKH8Ic1HKDIrNV9klMo/DjA46O1nYNCqrAO41GLqPlZWOw0R0Trl0xMubLs4T52w/usv6760M0l2aDJzXDDhxhOYCm8T0slZiQO+mguKbWTK7WWqkJHWzgVst7CDG30twhG2x133S9v68VITdA2pRLnWmJWkgmXoSmAuWQ4MzVcShiyyQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA4PR12MB9834.namprd12.prod.outlook.com (2603:10b6:208:5d3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Fri, 10 Oct
 2025 15:35:49 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9203.009; Fri, 10 Oct 2025
 15:35:49 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 dev.jain@arm.com, hughd@google.com, ioworker0@gmail.com,
 kirill@shutemov.name, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mpenttil@redhat.com, npache@redhat.com, ryan.roberts@arm.com,
 richard.weiyang@gmail.com
Subject: Re: [PATCH mm-new v3 1/1] mm/khugepaged: abort collapse scan on
 non-swap entries
Date: Fri, 10 Oct 2025 11:35:47 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <924750C0-8E59-4331-87E4-874872CB8E44@nvidia.com>
In-Reply-To: <73bbc22f-2739-4f0e-b8d7-b8e344a3fead@linux.dev>
References: <20251008032657.72406-1-lance.yang@linux.dev>
 <3ABDAD81-A650-4C9A-BB4B-5515180F0743@nvidia.com>
 <73bbc22f-2739-4f0e-b8d7-b8e344a3fead@linux.dev>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN1PR10CA0014.namprd10.prod.outlook.com
 (2603:10b6:408:e0::19) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA4PR12MB9834:EE_
X-MS-Office365-Filtering-Correlation-Id: 02056305-4d23-4fcf-4d50-08de0812b06d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UbQDmioQ3xyTX+Q48Lxp/MEp5VkeEJiobDBtj2sSNUJ47Rr+PhYwoCvAeMP5?=
 =?us-ascii?Q?AJbLDnIzIqVveB8t2H8+5Nh/u9VqnMPyAl11ddHf3tvGfu1loyKBGMPoDt4l?=
 =?us-ascii?Q?ZCEWEugunYyQveKD/V996JNa4OoU6Ybt8VdUNHS8E4o/LBlKc2BCD4nfYxE4?=
 =?us-ascii?Q?1KE3v/Uk82lo0why9KbFRizz7fweFDEvRKW/HOyfKjr7fOwqV5kJr3S3HC3a?=
 =?us-ascii?Q?2CwYTp2uMjd5JgUK0yNKgZLdB2xuprzAFWhrYbO1g2ZMOcZh+QxapEbkQdWf?=
 =?us-ascii?Q?BilIOnsEBv9oOVmZobmh6aLJJ23FvXPP5GI/CAcdrK2Sfu7Z2hrwdD/x3OJN?=
 =?us-ascii?Q?hjnZcpYzEmRP1qJvZ/iYhFSy/VVHRJO4l0q70FjMOvnE6YAJAUJDbhy8tRb0?=
 =?us-ascii?Q?4HsuqqgYhtKIdaxiRC3XQOtMwJFzGwmn8RkujN5Hoz26pggWRK6qSmGblJqh?=
 =?us-ascii?Q?msf3+7l7jhnjgydHljYqiLN7G2CTqVF/n7ZYdUU899ppaHaMFq6cKcViB5Vi?=
 =?us-ascii?Q?0abK5sp69u7j7K1uAoAFmAv/cqvSzZ9rSWOwMQhbda2Ca0ghYQ49DchJafDo?=
 =?us-ascii?Q?XGRe94v/pZwSUviEg+mkeyeMzMlPOXu/dMncXkDON0gUPY625BApKCrlVb6c?=
 =?us-ascii?Q?NNKYakHAMXQNf0nqgMkClhpvzfNf9vm8ZdB2T5ucyEQGZzTNtczLbK/GbdHi?=
 =?us-ascii?Q?+h59mcwJpgbONPe1FA54oOdnZr17s0uOb/8h537Ii9zos2E9p6PzKxv8K0ob?=
 =?us-ascii?Q?Qs9F9uF4F/7KQx7M+nkkvFCtqeLasLQbyJqu4hboBl76KSVy2cQU/zAFgPHY?=
 =?us-ascii?Q?ofqAS1oQPoym9G4UNxhzO9fMc5fi3Po7YZT30Xkvuf5Lem2l881NmxJBxRn9?=
 =?us-ascii?Q?0E8exr7Zzw4Qx35qnRv+U9BiAikK4zmBflVLlS0Byje0WxpSs54RrtsI7hIj?=
 =?us-ascii?Q?st3UVF7Srb7Wdcdr2RPspWsxzjl/1etY74C5rVYVrEzIl3Xm3AmRrYz+ViA3?=
 =?us-ascii?Q?mibvu9OzxCFR9i90S4fGAbmwyukxX7hpSlSKrucQGzFlm/Jo306MC+PLTNUV?=
 =?us-ascii?Q?B9dsTDl6UGi4tV6QvG8Q0d3PeZAAz1DR9hFS/MZO9Ws18Psq5HpO/L8P1hig?=
 =?us-ascii?Q?ZXPW5oIDyyLckrqK9cZoyW//omtY8Oh/N+UGS2TY2gHcPVQOQSCn0bGhRFu+?=
 =?us-ascii?Q?s8cqlwWvjv0hzB3c+SIEw67t21hmzqtN6jamDhJfrp1H/X5LjbWdMK7pECct?=
 =?us-ascii?Q?L5GhTABUr2qVXG2f84Rij48fQ/JMoQFSxJS6eHtPOH46sfitT+hWwqeK+6Q2?=
 =?us-ascii?Q?uVBOKFVAoCq0hcjQTrhbSeifuXjkHoyU/ukWwhvcO0QF8UZriY0BTZacSp3Q?=
 =?us-ascii?Q?6U+yMjA5CdWdlbPcWsGFeQClSXzVA7qFuHW+xjKK8mMEliDtr3GcGpTNVd+J?=
 =?us-ascii?Q?9Hwjs/0y/A+6kKNkec6Ez8Nzdcd5BbEzsyguxfIIUgXXrCjhWTftWA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZMnbOtdbw2Qk80arEEZnVzTRA0YBqEFs2iWQUzz0OZKTPLFlRaLa2faqGkin?=
 =?us-ascii?Q?m4KzIBUWpEuCvVL4BJsIo7JrhF4WAwtf0fSjvSKKtpK8jjV5MxvzVf2OSDvT?=
 =?us-ascii?Q?c9nSHL24/2Jn7gdAA/LjqXve3EPpi4/yLmGu6OioLhLlaylUWR0KpgqFOUoS?=
 =?us-ascii?Q?H/nSBObqMIrG9+g/AKcqOtYYlVakThA4PX6YAFfhcb6/yMcawPFnq4Ww6f7e?=
 =?us-ascii?Q?KWX7jUN4gAXTzMgOMijLB9nvaxaRYrS2463vNqStOnv/d7rtbauISo58T++T?=
 =?us-ascii?Q?0ZCxxKPgyhcl691f8ptFgOSI45rzFBONY3SGSzcmzioVP21mRdwoQc3IaW89?=
 =?us-ascii?Q?fkX8jyf2iYLHJSkCD8YMyBlGlN6oFRYeo2RrHA7fMMK5KzPFi+MRf03a6B/4?=
 =?us-ascii?Q?Mdg4ECzuLNPX7jfkb72zMtovP0De3PIg2DAa1q0VAXDx6DMLyqQ61Jw0ZEMe?=
 =?us-ascii?Q?w6FczYnyOWRWQPQQ2vwVNNCRXQVXYqeorRCrgid3Z6b6iNtoqPM2rzjNsNTg?=
 =?us-ascii?Q?+cRmA+VuvaiG/QGjgatOh1ps+Sx8rhfa62JQAYkpN4jkoQnl5L+irmAqQ1G0?=
 =?us-ascii?Q?wLtL1qWJlgXWlz2A2HhjUQY7+yqGaXdj4G7Q/M7bZM6XSNm5/HjAH3z4VfoU?=
 =?us-ascii?Q?DvV9KoBhkZs7vHT60PlDHzzhgrkN0z+5D+OQFzsUyERWzWBVINJQXK5TIn6n?=
 =?us-ascii?Q?p+N/5WggVufMylhbLrDmHUjsYltcGApGGD4wEjfXrL5CJD3SOhqTDVSbU66u?=
 =?us-ascii?Q?9j40gMZnpY/CF+CxBzPV9UXYG7d9jaXEzEIcNZPTTOCeY8tZ5DE9HchwH3i+?=
 =?us-ascii?Q?YU/xoe6WkI0NF0PkDVVS1TU7+qT8f0xxhnPwxnDm2S/p+Fr2oZqnXT1lANPZ?=
 =?us-ascii?Q?GQDjYqxHVGzMqlWrZ4rVrDbUUcbO00Qi4hvy8HIVmqojlksMYkPwegsKgD1t?=
 =?us-ascii?Q?i3liuAF8jnYivUUER65AwJO4Tc7Aoxut6BUsDQL0hZHPP241/1sc/6Wtn+kK?=
 =?us-ascii?Q?vcNwcxANcAwfnIjgnAyiZ5/yEUaEpdRPXvg3BODmv/c7x3m7Hzcsaz1RZpt/?=
 =?us-ascii?Q?T5pJ6JUYy/guSLRqYWKFD14gITlnehdOmNvZCpAp9Aqb8x37OlWiFVYtAKEp?=
 =?us-ascii?Q?JjQsaaz9SQhrBLi5qUediR263k6KXUaEib8NnSuj9pNipH+LmJbmI7mWO5uK?=
 =?us-ascii?Q?GF5Xk7wFl4RBasCXSuIK1nJ19/qOg5ykfE2F8yeHQux4sECHwWUtPQnWWFPj?=
 =?us-ascii?Q?2aaybpnsJHeVnUG6JrtgGOYt8jq2+AX/loEWwuAc4Q6pmOeQEpxFj5ZqAt17?=
 =?us-ascii?Q?5x2jQ64vj7GStMQEuwJR7M5sAmBdIgKrjbEArrUQSRDGevKW0sAO++KomMGC?=
 =?us-ascii?Q?/E4c1ZgiDvtPq0YJH+6akbax1E5hjYJS38OWszA6Qj3yZu27L8j33HOrYAkI?=
 =?us-ascii?Q?AE+9CTVVquhZNKKThqhLMQAZzVHnr7MfeOhSVgphFwG78LvLgc40k8+2Ab+F?=
 =?us-ascii?Q?SEnPRhytjd7SRYRyqczxhSATQGs16Eslrd1BRL+F7l1Cg3rnax0YPFsRglcx?=
 =?us-ascii?Q?Dnb8wTmurJp1lDPOfg3e8LSs8yqIADr8DPHQ2JFq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02056305-4d23-4fcf-4d50-08de0812b06d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2025 15:35:49.6928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KlRU9c/QWyllGWVKlnIcs4NZdY8cnhpV/DHL9Wndi5DtgfB93BCE62FztzlP6piU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB9834
X-Rspam-User: 
X-Rspamd-Queue-Id: 07489C0002
X-Rspamd-Server: rspam03
X-Stat-Signature: nfg7uipr7tmm9ah6sjntxa1ipn5djh1x
X-HE-Tag: 1760110552-846659
X-HE-Meta: U2FsdGVkX1+13Faky2j2U6WQRQswixQMS5ZSYDKJ3T6bbrACF45mJ7q9dfKU/8CSXrYpczRH3EB4JoKf9xT4wdndQorGHzENRCJlCDlTeNEvCavCWv7woejI1AKGLoG5AAEkO2lwBjuMc9/YrMVSt+Vl0lre971kPv+tcC7WqA9caGzz4q/w6HX0BN8V3aXFl5CnbnBGRULgPFlzAO3lDWBeMmCoxa9eeqO7aiKsxlmfbS8g2KKw0JPsNTH8CgctVIxWMfcR9k43tmbmSJJsIt3r6Sy7U2luO0zVu3tx3J4gkSwu7TLrLo3gpdLrWCDfz/6Pbm4RilM0C8915UD0k/qQw9vMNLNkDejm1wz9/Y+lEDr+3QUt/s0T/+2rWOP8aVoC/W86UhJ2gpy7ltFnKGk+4CvD2LgoYSgpe7GTjLYfUSWbvpbzX7FP8c+v+tk64E3r21AgnX6zlxkN3CYIz8fGqBDkP991ZFUAvn/ohWwTiIXd1aCHFgO+TfY0tSx8WiYNZXQa8hDoUonYNVsFlj1/9T7Q7vDldYEnwbYmEsVAJMmVc7G2v9yD6A4TqRQj08u+DWjU83r7V8Y+ItvYZgismgm6c6ETKeipTaypFCBgp6Xdv39mp3JcJdFCh8hpprZdQyQ5K+/BkPD+YJaTBOr20SpXNQG7hMZAEkQexMJAPqUL62va65ypTw+bzKD5aOPyHXWQEauLqHVkrQN+nbbVchZr5AuhCq1D8kBPS5AXf7Z2bloO/IJc4YNWqVAi41uQGzcTQeb6ovKGZ1c+d/PwNRfZDFCRCLDMQPhEQqhCfJ3wPuL6TkojE1O5FIY5DZ1rMu9h7ba9fTz1Y9raFBMwywnLFC5hoa9WHtYsvmnDF7pW5PXwsX8R9wVvuUD7x65ZqFM1nZSeh0kDZVg2JHeNqItkVuwM4Zz+1oakZZNyLo4+P6oOvWwYCxXFqHYDS0Ptjuevj7ReeTZNDbk
 12Gwcrfn
 iP0eT+BFeDRjEN8tD6fItQ/ER+jVitI+qWLLa20vGLDZu5xSF7uxeTjdkNrkqbdaHHWw/FmorN6OKoOfiGXFtX1j3IbVF5lqhd9wSPrUCsNk+HWQa1kTOxXmmrQRmmDNL7R1nv1sOxjlbIU4kmYRNR9LIyzlhqlfWc3CtfeZpOFnWsj+Zj95qnsLpP3J9mq6J/Gs2cDICToRkje/b4uspXwV8cZzM+ZWrtXQI8yGgwAt6AM2CPk3Kxu7atYEwx3hR0w12iZBTi6ydESxHd5pYrTEFgpP2zklN1l2waPAgcMqu5K6sQY22d2eWAZl5x+p2uw0TTJvCteY1Bcw/bB3Mh1F+sVnbMYtDUr5R6uvn4PcRBZoHU7KCpklwACB6sXPnd8J43QPJRck2DAVvkdV+FFq1Lg2jwwyiWw24GMiRpAGNnG6mlfbVfD/9rVizM3pMOy0HnUszbTZn2Uhg8hABQlCxxPDevm16doPBgh+0866p57Z6wEnnzETyvlRmoSk3FEvVfZxkkhzVlW1AW3dYQWfIhtIRFaPUTfZ9CeQtHHWdHoPAKI5s7SR0+6joHGTOzAka+IhpYjMP6iJSxNUaU8rUbuoQfQld1HJBlAWXnLh7YL8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10 Oct 2025, at 11:34, Lance Yang wrote:

> On 2025/10/10 23:21, Zi Yan wrote:
>> On 7 Oct 2025, at 23:26, Lance Yang wrote:
>>
>>> From: Lance Yang <lance.yang@linux.dev>
>>>
>>> Currently, special non-swap entries (like PTE markers) are not caught=

>>> early in hpage_collapse_scan_pmd(), leading to failures deep in the
>>> swap-in logic.
>>>
>>> A function that is called __collapse_huge_page_swapin() and documente=
d
>>> to "Bring missing pages in from swap" will handle other types as well=
=2E
>>>
>>> As analyzed by David[1], we could have ended up with the following
>>> entry types right before do_swap_page():
>>>
>>>    (1) Migration entries. We would have waited.
>>>        -> Maybe worth it to wait, maybe not. We suspect we don't stum=
ble
>>>           into that frequently such that we don't care. We could alwa=
ys
>>>           unlock this separately later.
>>>
>>>    (2) Device-exclusive entries. We would have converted to non-exclu=
sive.
>>>        -> See make_device_exclusive(), we cannot tolerate PMD entries=
 and
>>>           have to split them through FOLL_SPLIT_PMD. As popped up dur=
ing
>>>           a recent discussion, collapsing here is actually
>>>           counter-productive, because the next conversion will PTE-ma=
p
>>>           it again.
>>>        -> Ok to not collapse.
>>>
>>>    (3) Device-private entries. We would have migrated to RAM.
>>>        -> Device-private still does not support THPs, so collapsing r=
ight
>>>           now just means that the next device access would split the
>>>           folio again.
>>>        -> Ok to not collapse.
>>>
>>>    (4) HWPoison entries
>>>        -> Cannot collapse
>>>
>>>    (5) Markers
>>>        -> Cannot collapse
>>>
>>> First, this patch adds an early check for these non-swap entries. If
>>> any one is found, the scan is aborted immediately with the
>>> SCAN_PTE_NON_PRESENT result, as Lorenzo suggested[2], avoiding wasted=

>>> work. While at it, convert pte_swp_uffd_wp_any() to pte_swp_uffd_wp()=

>>> since we are in the swap pte branch.
>>>
>>> Second, as Wei pointed out[3], we may have a chance to get a non-swap=

>>> entry, since we will drop and re-acquire the mmap lock before
>>> __collapse_huge_page_swapin(). To handle this, we also add a
>>> non_swap_entry() check there.
>>>
>>> Note that we can unlock later what we really need, and not account it=

>>> towards max_swap_ptes.
>>>
>>> [1] https://lore.kernel.org/linux-mm/09eaca7b-9988-41c7-8d6e-4802055b=
3f1e@redhat.com
>>> [2] https://lore.kernel.org/linux-mm/7df49fe7-c6b7-426a-8680-dcd55219=
c8bd@lucifer.local
>>> [3] https://lore.kernel.org/linux-mm/20251005010511.ysek2nqojebqngf3@=
master
>>>
>>> Acked-by: David Hildenbrand <david@redhat.com>
>>> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
>>> Reviewed-by: Dev Jain <dev.jain@arm.com>
>>> Suggested-by: David Hildenbrand <david@redhat.com>
>>> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>> ---
>>> v2 -> v3:
>>>   - Collect Acked-by from David - thanks!
>>>   - Collect Reviewed-by from Wei and Dev - thanks!
>>>   - Add a non_swap_entry() check in __collapse_huge_page_swapin() (pe=
r Wei
>>>     and David) - thanks!
>>>   - Rework the changelog to incorporate David's detailed analysis of
>>>     non-swap entry types - thanks!!!
>>>   - https://lore.kernel.org/linux-mm/20251001032251.85888-1-lance.yan=
g@linux.dev/
>>>
>>> v1 -> v2:
>>>   - Skip all non-present entries except swap entries (per David) than=
ks!
>>>   - https://lore.kernel.org/linux-mm/20250924100207.28332-1-lance.yan=
g@linux.dev/
>>>
>>>   mm/khugepaged.c | 37 +++++++++++++++++++++++--------------
>>>   1 file changed, 23 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index abe54f0043c7..bec3e268dc76 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -1020,6 +1020,11 @@ static int __collapse_huge_page_swapin(struct =
mm_struct *mm,
>>>   		if (!is_swap_pte(vmf.orig_pte))
>>>   			continue;
>>>
>>> +		if (non_swap_entry(pte_to_swp_entry(vmf.orig_pte))) {
>>> +			result =3D SCAN_PTE_NON_PRESENT;
>>> +			goto out;
>>> +		}
>>> +
>>>   		vmf.pte =3D pte;
>>>   		vmf.ptl =3D ptl;
>>>   		ret =3D do_swap_page(&vmf);
>>> @@ -1281,7 +1286,23 @@ static int hpage_collapse_scan_pmd(struct mm_s=
truct *mm,
>>>   	for (addr =3D start_addr, _pte =3D pte; _pte < pte + HPAGE_PMD_NR;=

>>>   	     _pte++, addr +=3D PAGE_SIZE) {
>>>   		pte_t pteval =3D ptep_get(_pte);
>>> -		if (is_swap_pte(pteval)) {
>>> +		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>>> +			++none_or_zero;
>>> +			if (!userfaultfd_armed(vma) &&
>>> +			    (!cc->is_khugepaged ||
>>> +			     none_or_zero <=3D khugepaged_max_ptes_none)) {
>>> +				continue;
>>> +			} else {
>>> +				result =3D SCAN_EXCEED_NONE_PTE;
>>> +				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>>> +				goto out_unmap;
>>> +			}
>>> +		} else if (!pte_present(pteval)) {
>>> +			if (non_swap_entry(pte_to_swp_entry(pteval))) { +				result =3D S=
CAN_PTE_NON_PRESENT;
>>> +				goto out_unmap;
>>> +			}
>>> +
>>>   			++unmapped;
>>>   			if (!cc->is_khugepaged ||
>>>   			    unmapped <=3D khugepaged_max_ptes_swap) {
>>> @@ -1290,7 +1311,7 @@ static int hpage_collapse_scan_pmd(struct mm_st=
ruct *mm,
>>>   				 * enabled swap entries.  Please see
>>>   				 * comment below for pte_uffd_wp().
>>>   				 */
>>> -				if (pte_swp_uffd_wp_any(pteval)) {
>>> +				if (pte_swp_uffd_wp(pteval)) {
>>
>> pte_swp_uffd_wp_any() returns true for both pte_swp_uffd_wp() and
>> pte_marker_uffd_wp(). Why is it OK to just check pte_swp_uffd_wp() her=
e?
>
> +		} else if (!pte_present(pteval)) {
> +			if (non_swap_entry(pte_to_swp_entry(pteval))) { <--
> +				result =3D SCAN_PTE_NON_PRESENT;
> +				goto out_unmap;
> +			}
>
> IIUC, we have just handled all non-swap entries above (which would
> include pte_marker_uffd_wp()), right?

Got it. Thanks for the explanation.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--
Best Regards,
Yan, Zi

