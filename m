Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E5C0CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 16:19:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4E518E0003; Thu, 11 Sep 2025 12:19:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D257F8E0001; Thu, 11 Sep 2025 12:19:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3B7E8E0003; Thu, 11 Sep 2025 12:19:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B1E148E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 12:19:44 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 648C6B9D49
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 16:19:44 +0000 (UTC)
X-FDA: 83877480288.01.EFEFC49
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2080.outbound.protection.outlook.com [40.107.236.80])
	by imf05.hostedemail.com (Postfix) with ESMTP id 93823100005
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 16:19:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YJwxqhH5;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.107.236.80 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757607581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PIuRZWAhU0yF/IKY7IM/Y7UnxAEHxWNdIsToDpQUrQM=;
	b=R0YJQCw5sWKHzL62pdVz75IclLGbs2Li+fiY2Zc7Pg67H6U7iOADSfjQgheWUXTM+WBMr7
	+oQlH004nEAnwqekfxLaw0zzKf0GtcGRQNWBvq7SiYjlE/t1kUnYv31ZClzH03+jV0sV75
	k9+0QMxJQl+2dC/PAQ7DT5Kl1D/zS38=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757607581; a=rsa-sha256;
	cv=pass;
	b=j2K/F+xLiCn+UTioIMap7NwL9gqDMcbFIrgMTC8FdiMc8h5VTJl18OjMYo777YyCsUMJsV
	QyRPASRQiJgzP6sPz8BimbXQ5KqoKj1W3gsF8JM+2ixI/9kCrDUGFIs7q8t3InSXAhrLgm
	DbCzHTDe6fdVvp6ot6XUCzXCtRbX0e8=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YJwxqhH5;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.107.236.80 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bJ+RAQ0SMTY/tFh9t14Q2S7m1I2tg5ZiuEz0gI4QrftxXigNevL8d0CEnufsPIviKlES1Q1wY7bgrXTHf200l5qgtoCa8IeweTF4yfgseatkmIdsbK0jKBZZhUB3bLoTsaS/ZWHcATd7RyyLZly9CxHXhYj3nNpb+mFqgNIll+mpkEXBIvhX1XjvZgcOMgav+hzB1ZEO4iv+s0sxDo9qxlPTmSPV5D9XLgBA8Jfu2ZNjZoxoDANof/AEfjzXWjLc9SyxDj26NqF2PJ+y+Qhkf9zJ9tAzox9H6hoHyFb/ysr+naNhzEwUTi096qcKM8OyW4Slouj0OveNqrM6R7Z/4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PIuRZWAhU0yF/IKY7IM/Y7UnxAEHxWNdIsToDpQUrQM=;
 b=nLs+bRCwmqRPIZd4pWkZtcfppwr7kFqnTAZ+cgd3qnSE/HJ+yqcnbAfT5aTvVslP69+kH+Xqe5HgEr+0LYY3HU4clP3VhkkGEDgewhg7FL5QJ+kwZlpBiUHCQYQFdtCco2s59NAM8jL3gG3I92xz6DFxFaeTbpd+w7Gps45Yo0kug97LYInE5qMZwhVBPuUW57nOi0R0Aimh1em0Q1qpNtowNtjAMT+uJMusoJ3Rqo4yccGugtA3CikamWNu43V0UjrLLlxKAawbUiSOY6x1Bkk7sfvaPm17w9EVX6TgaisqcjdG9I+iaS0I7JXgjzaaUW7GmnllFljALUqnR77L0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PIuRZWAhU0yF/IKY7IM/Y7UnxAEHxWNdIsToDpQUrQM=;
 b=YJwxqhH5AZc5bNItgvZhZ6LGlF961nHNQvYT2345uXjnrIuJoa0w4d8SMeWv4RiVI0SmaZPQU0LvytUtHA1jKZlXKA7dELPLPl18CiIkG09jeht3g5/ZZhjdjQFXDWUTAqRWhCa3YUG7ndeMAJQEsmW5ECuHOMs/lZp318ZC2qIhFVvTQnVCAR1wLU1T3Kx8v6ZOaeqQ+clcUqGN6jhu2knutGP6hLc2NgXY+Kw6WgULXfge/mmcNeAMlNFxYG93cUJG9PXxqLfN+oPG+K1GjT/Fee+YXtB/uCKjCUQRW0laUplm+XJlvfP758WWaLsgLFSslZtvez8kdqPAzuw7qQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB6487.namprd12.prod.outlook.com (2603:10b6:8:c4::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.22; Thu, 11 Sep 2025 16:19:36 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 16:19:36 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 wangkefeng.wang@huawei.com, linux-mm@kvack.org,
 Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH] mm/compaction: fix low_pfn advance on isolating hugetlb
Date: Thu, 11 Sep 2025 12:19:34 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <3DE28F4B-ACB1-468F-89B9-D7750D24BE4E@nvidia.com>
In-Reply-To: <20250911032751.khtgvdhcqzyf3rgr@master>
References: <20250910092240.3981-1-richard.weiyang@gmail.com>
 <20250911012521.4p7kmxv46kwz5fz5@master>
 <5F7DCC9D-4CA2-4BA2-9EA8-F04C3883E289@nvidia.com>
 <20250911032751.khtgvdhcqzyf3rgr@master>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:208:23a::18) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB6487:EE_
X-MS-Office365-Filtering-Correlation-Id: 51b03750-fe0f-4a20-cd5d-08ddf14f0028
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/rkYi/m6w9yafB9bVL5qdFNLvQVcspqbP50MZEKN4A3Siu3e/DGVAcNwN0uQ?=
 =?us-ascii?Q?2bHL/mntyFBi43Dtkxl1c52JDuJhy6w3KR5EJW4rdEjfZdg8SLvHl9L9qb2W?=
 =?us-ascii?Q?65fjSBVPaWJ12WTZUIXJ3cxJtwr3OfktHGkrtSj2HJthG+P6NvZuEGAYYJSY?=
 =?us-ascii?Q?23rvaITFH/UW/ZUeWR42nwbLSfNU1E5WQc8gnRF2eSoJ/DkdRXypTHhVbbnE?=
 =?us-ascii?Q?/YxTDofFovMXO/xoPE5VZINHDlO0r/dG5+fYGqG+0v4O89P9hrllBIPr1N49?=
 =?us-ascii?Q?OvZUBkMo6N9v0qAfxP/bNxSIxJs2qSqx5BP1iIED/ef0YRpdDeS89Z2BqSFS?=
 =?us-ascii?Q?59/fn7IGK2gteyPvDlLM9qWhpVHz0jv9JZZVeOCG1UblOinwyNK7ppqZZdrE?=
 =?us-ascii?Q?vpF9NlWLSKloYg7z9v4DkWRcodHCbb+fgnRipedeuhQ1u+X6+CwAHYv6Edkh?=
 =?us-ascii?Q?crkJw9TDdcy6X+iXvzG2lcs8Lvpgmga4DAWB/MwrGD8UTiSGFCT4P90OpZrx?=
 =?us-ascii?Q?Tcy0LDc+7OKvqAsIIFrc4edIkcrNTreY7v38AY+GO1HKsQsGNMGke5bJLhEU?=
 =?us-ascii?Q?EJGLgosSkSuv2LABLOUfZ7IkaT8RhfBWFu4Tjlga/Z5KaSlZvL1VtPZv4rNj?=
 =?us-ascii?Q?jKnwteWth5ueEMI5Y3XmRkGrZbb7B9jIT4tHYUft4oB26lMPFx5LUMK6ODi3?=
 =?us-ascii?Q?AjOrhmd63ekX5ACbtSZ8s3iITXkrXiq8kAuetrf9CsyuDZDXC7HBYcj61P+O?=
 =?us-ascii?Q?Cb5DKn7hJqMvawIpgqKa82241eKbya5BYroyM9Yv0yT/9p/hE7fuKP1yAI2M?=
 =?us-ascii?Q?tjQRsilsD5aQLZwBuyMyrtR3lZOdFU4DdCEunlgrDj9RVOEOIt3n78u2Bemn?=
 =?us-ascii?Q?C6TVvaUa34oLPxjgPuh6Av/n0dKD0F+k11cBH1PHZxML/n9VpsRUwP0Md6C9?=
 =?us-ascii?Q?VLbNqMOj4aw6ncyex7aAXK/88PhrliEMBLdOLbHugEyP21brw6Sr4ehiaBaT?=
 =?us-ascii?Q?AFhva9wT3syv3rRHdTYDh4rOz3D0qeV5U5vIU7/c47zKXtRhY84ucsLCI3Je?=
 =?us-ascii?Q?jDlbvf1z2+1bChfw48B4+FeyQKNlbhgZVoQyZO2Rn3mN8zH6Q5GoMuGj8KcR?=
 =?us-ascii?Q?1hVHhD8oTlzCCjXX0P9bTmQOvqkDCz8Kf1mRG58+Tjo91X/aS89ocqF/RYVu?=
 =?us-ascii?Q?x9L4WYCJLmORfhdtxN/tnfzlYnNPAYF71KAOVWMjg+filSB04uEuieeNtHC1?=
 =?us-ascii?Q?eLOU0I81wIm4W7gZ1sVacqVlIDZrISQpwajmftVMqgHYVx48z+t7fmhyQT9U?=
 =?us-ascii?Q?t/f+fA8yVJbrwYRLsg+xToUC8QRjFGRd7XRL7a0xxZc2iBvhbBHlZ2HoKFeP?=
 =?us-ascii?Q?bCMU0Wj3MYeAD0sWY6GX/YEna0wxHuUTDawlq9wlu+b+Xoib2zqxmIL3+Kud?=
 =?us-ascii?Q?AO6NNKDfGjE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ue5m8LXBLuXo/VYyaLbxFQVYJGPGZ/8a+gn9H4uexJXaKiJTNNPLM0g/8Icw?=
 =?us-ascii?Q?NEY1T1b0RhZ7TlTbH13cGpbpt7hUXh/zOE10qplwPUpkOOYlgbZdanpEPhyg?=
 =?us-ascii?Q?nZywYj+EtC9BqicrKT2ncAu3WFo7AjS+gwxEwLRuDfycYVSzZToXwvQLB7Qa?=
 =?us-ascii?Q?CyYa+O2oBXV/wdUAAaGs+If3YA7WGVXN7KnoxeHrSX27LwnTFlyZEw5k0Lok?=
 =?us-ascii?Q?T/OlgqiR4LCm8PqW6GYFYK+DMY7/WbECkSpyt2R/V71sCjgptpLCQ3zZKibR?=
 =?us-ascii?Q?X4GnsffSIXnNZvS1qWsTmsIW4+3jvZasPRJ4PUVZN+RKvErWZRjYagbvUST4?=
 =?us-ascii?Q?1RDv/ylXZx3fVTZNl/CIyKST1p+4SJ0WjlIrYx6r/3FG96ohqR5AcMLtxopR?=
 =?us-ascii?Q?Cppa4U7bh+4TJGJFYMNbcGncRrYI4mMdNXL72jSz5gK2AWSV+HHbY947qojC?=
 =?us-ascii?Q?41gVtgM42KAiBkwSNoTpj09L14d63z1t3A2sBt+gbzlsAVfZfRJynIio255U?=
 =?us-ascii?Q?jaBNnfFZE7W2+hHNd5iS4tdT+mEKgpnu1CcU+TCfCWCcndgX4+ng1V+/B9Y5?=
 =?us-ascii?Q?unDpLjzZmzzLojhuQPs/MtpdTUfb0LwsRBTaDRd3L+VUfATr1BswmO6Jllz7?=
 =?us-ascii?Q?RzWiBpHKSgQedsN6MG8MNym9vDEX9mGJQAgKt16NFanMDv1vtZ2mFcy9iE13?=
 =?us-ascii?Q?gnCJQVNiyk/VEX6DohauYxEFMwVKqXZI8KVQldd0xYdXM6s9ZKh5egehrTrG?=
 =?us-ascii?Q?XKFeHo9eSknmsi0JW+e+0RinzUlnQcDG4evbdVySvOeLZY7Gky6DrDw/v+8+?=
 =?us-ascii?Q?QrodSvi1ulqh332/yQyYM4pEmKT+DsUsqgehXAJe3Z3xx3TssKSnv6yuBm+C?=
 =?us-ascii?Q?IvHt4TdOt8XQdeMrkW46SqciVwVgW1HFRRsUJ7HI+z03RT3iQBTtA5FzwLiL?=
 =?us-ascii?Q?FZpuCgBbm3L1PJKCAHMiW/LJwJGKRNWE3hWM6iErlzrzRWYO++Eu4Ay0jk1Y?=
 =?us-ascii?Q?NjtQTSNpz1mnLQPG4qI2rEdvdA/PJy8wrBtQS/4c6//UZXTyh0E+WnLa7ffb?=
 =?us-ascii?Q?239TuGZZOhxmoaWLdi+VkoxHkM4sUQkg5NXvGW+MTX3CVW0XI0Ap1ViqpJ+1?=
 =?us-ascii?Q?p1GWIcLCupHZlNOuv5aMNt4B1GqeDqSWWkxRyGHjzCpukXnoa4aQ5LPwFFGt?=
 =?us-ascii?Q?A5HSGGnvYJRv3I50v21DJMePF36bt+axWzhNlIiOklI/wsA+3/3gnukDGtx9?=
 =?us-ascii?Q?dx0/Q7Fop/8bNj+Vgb8w2qZGP56DbQMM9R86wGZk/EX9+rOIf4BB+SjZI/5B?=
 =?us-ascii?Q?jvlNO+JODUz8jh6X/zLfnl84/7tNAimF983zotFDGpX5B0WY+78rQa3O38Ih?=
 =?us-ascii?Q?Ov6Vi9h65SQv8jtR5uT671VtlVlJSz6yBDbhHDlFBFpXi2+ZLI6+5Y0Ob52J?=
 =?us-ascii?Q?vBkgYV0vX0atGPQqKTD7Hv3CQ66/oa4vHG4ZN7dh80RG9MDgx76eT0q3QPMr?=
 =?us-ascii?Q?fLTwgzRjTL2ckDEJ+BFhyXyT4GC1bN72DAU3AJEWNwpm7VJDIs78Jyqp8GGP?=
 =?us-ascii?Q?93t6w84saDW+A0nxtRPW563o2n+M257n21l9mNvO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51b03750-fe0f-4a20-cd5d-08ddf14f0028
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 16:19:36.5369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Obz61IvzoB1hp3RopO5J+Y9zL8Cv4owlQsB9cyQTzTCHqGuUTz67b+ev2F/hVDKn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6487
X-Rspamd-Queue-Id: 93823100005
X-Stat-Signature: c99bbswi86tuao7r5w1t6teu9y4d8xfy
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757607581-791664
X-HE-Meta: U2FsdGVkX1+Nt3iCafPMX0q+a4adXAmxezbapsrv9U0xb2GZ1isb0uqrt5hrYoYE5/edSn/5XaqaE5RMkEhVLHGLPsyC0KeRp164hw6A6Z1M3oPwVpRgF4XuAK4He5fKvNDrFnQ3hUxhs3btbSNEXfR8tpDHxuXgnIBhKosM7iPqLkjz6hADvjSoSM/t1v3OYFJlAkWGKdZOmp/8ANYPci48O52yGfBML648SQ32ME3uKjvhlc4pxGph427+C6Y8UV3oqOEkPIKtpmuEtRQnry+jhmh36b5qEusFZohnTAg8hgA0KVn++fdlBG929hWrV1ZuJnpG73byRPHVkKvJSm/3oiYcdeXCpt4Wbf0tHT+PvLwAFjiuMJInofrNEonFhBSTCVK4an5uhml3lcnX928Drs3vbnXMDjtmSheVZCoQHC+8LVGwaziej04VjyEQmOdkG5th9sguugnnLe495LTcQMhtxmu5FPkt1Y+MrI9YDr8utSrXJFZyMQM2boSMDCMQvx7kkxenUlQl6w+XFafcxIEumKhlNlURVb/z5mmnA6KUlZz/ZdAw847Fp0VR+yw86tcxq72Dy2QQfH7OwRWnD/05zfLND6WH5hdwAagcPuZEw1N34/DjeegkNnNGJZhxzW25talFqEj3GeE1Eomt6cGgzrc1Wi++/CESWvPtISndc3Vp2XliUNOEANf+J0sl4ESRi3/p/RJnz7/kU2n5kPYxRQ+Rbh48EQONdLauqbCdtvSHq0M9AOy7z/UaE9HiyTSNFpeYUIbBlgWGKW5n2b8H5jYIJ40lmhcyU9wMO2oGsd84dRPYzPQXU+wECQ1b7hsx8bsv6ylJEquJCeaDOVHZSVPA0ECBG0TjU+Dlib9jKL04r81J8kH4/JmFjlaRxBlzOpdKp6/eSoLYv17HRNp53f/NV/R6U7i/Bh3reUodWI177qVwgQBHQRfUyJizgKsEaMKMufdahmA
 xXjY1zGY
 zmon/Dj5jzQQN7SDfW3mTOpPONk66vYPqmGpmkBUVnuf9Zj/+EBHLq1FHYRUB+ikIQ3OHS5CioAHXg5w/dmfiU2377k7SS/bRsWepQOvIa886rdaxUFhJlBtKl8epW3aqRMtKv5F2S/xnrZnm2jWEZdATLyYSEucQq4cV7PKjdA0paSLpMWGe/S5qOjsU4ls9Z+jHTYuswefaN1TtldBixQcHGTAfTyXw7H5mklpGgdF6de2U/12xhK0I1ZdP2CM5FZeKxif/k6rAku3oJUniSLUYLkpWayovS704WQWf7PQS2x1Q/Is8OGieiRV84JWUPbaOl9AHZnrn+/rVrQ+lbWkKU9FjSAlTSBc39h6S2/4SBVLXmGJV1+gnqWppCxjqlpzi0Vv1L3mK2pldJMrZky22nBO1LttjukEYsIAaqvdT2HPjnuSi7EicU7g/VmoXjTCyBf+OQ9S2bqUWFxbgZD+QR2IRi/f0X6+23zZR/Af/0kGmupQ6NSqSue94FcqAkHPeiX2pjm2v0JwqxRt3AmmCfFrIY1twepVbJtdrRBjjwRFHq5ohpM6QR2Tg4VwjFR4KyK+T6F+f8sXomSHOQdQZ0kGrlOsL2mlp0wDLRQrPTzLh3wUNTvIHTXGutm/3/LhGhf/gZ4+2EcI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10 Sep 2025, at 23:27, Wei Yang wrote:

> On Wed, Sep 10, 2025 at 09:35:53PM -0400, Zi Yan wrote:
>> On 10 Sep 2025, at 21:25, Wei Yang wrote:
>>
>>> On Wed, Sep 10, 2025 at 09:22:40AM +0000, Wei Yang wrote:
>>>> Commit 56ae0bb349b4 ("mm: compaction: convert to use a folio in
>>>> isolate_migratepages_block()") converts api from page to folio. But =
the
>>>> low_pfn advance for hugetlb page seems wrong when low_pfn doesn't po=
int
>>>> to head page.
>>>>
>>>> Originally, if page is a hugetlb tail page, compound_nr() return 1,
>>>> which means low_pfn only advance one in next iteration. After the
>>>> change, low_pfn would advance more than the hugetlb range, since
>>>> folio_nr_pages() always return total number of the large page. This
>>>> results in skipping some range to isolate and then to migrate.
>>>>
>>>> The worst case for alloc_contig is it does all the isolation and
>>>> migration, but finally find some range is still not isolated. And th=
en
>>>> undo all the work and try a new range.
>>>>
>>>> Advance low_pfn to the end of hugetlb.
>>>>
>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>> Fixes: 56ae0bb349b4 ("mm: compaction: convert to use a folio in isol=
ate_migratepages_block()")
>>>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>> Cc: Oscar Salvador <osalvador@suse.de>
>>>
>>> Forgot to cc stable.
>>>
>>> Cc: <stable@vger.kernel.org>
>>
>> Is there any bug report to justify the backport? Since it is more like=
ly
>> to be a performance issue instead of a correctness issue.
>>
>
> OK, I thought cc-stable is paired with fixes tag.
>
> If not, please drop it.
>
>>>
>>>> ---
>>>> mm/compaction.c | 2 +-
>>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/mm/compaction.c b/mm/compaction.c
>>>> index bf021b31c7ec..1e8f8eca318c 100644
>>>> --- a/mm/compaction.c
>>>> +++ b/mm/compaction.c
>>>> @@ -989,7 +989,7 @@ isolate_migratepages_block(struct compact_contro=
l *cc, unsigned long low_pfn,
>>>> 				 * Hugepage was successfully isolated and placed
>>>> 				 * on the cc->migratepages list.
>>>> 				 */
>>>> -				low_pfn +=3D folio_nr_pages(folio) - 1;
>>>> +				low_pfn +=3D folio_nr_pages(folio) - folio_page_idx(folio, page=
) - 1;
>>>
>>> One question is why we advance compound_nr() in original version.
>>>
>>> Yes, there are several places advancing compound_nr(), but it seems t=
o iterate
>>> on the same large page and do the same thing and advance 1 again.
>>>
>>> Not sure which part story I missed.
>>
>> isolate_migratepages_block() starts from the beginning of a pageblock.=

>> How likely the code hit in the middle of a hugetlb?
>>
>
> OK, this is a kind of optimization based on the knowledge it is not lik=
ely to
> be a tail page?

No, it might be that most of the time page is the head, or people assume =
so.

--
Best Regards,
Yan, Zi

