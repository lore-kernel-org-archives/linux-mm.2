Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AC9AD1489A
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 03:23:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D205B6B0092; Wed,  7 Jan 2026 22:23:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCDD56B0093; Wed,  7 Jan 2026 22:23:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B85666B0095; Wed,  7 Jan 2026 22:23:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A5B0E6B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 22:23:26 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 51397B97ED
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 03:23:26 +0000 (UTC)
X-FDA: 84307351212.25.5B715F5
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010045.outbound.protection.outlook.com [40.93.198.45])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8D0AB180005
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 03:23:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=V908ieta;
	spf=pass (imf16.hostedemail.com: domain of apopple@nvidia.com designates 40.93.198.45 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767842603; a=rsa-sha256;
	cv=pass;
	b=qwidNt3tJsHbFyARiRzBf9qdKg452MwQYTR8LhKhAsOCVFa2851p1Ot/MtMeA4EFF0bpwo
	MPXaS659htn9VD8McYN0qooQ20K0HzgLblrZzYJJJZxLhrE7DW4SQ61H3LUgClRYikk7Ob
	t6+gdCDvbFPnkZueOGE6nkb0EROg/aY=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=V908ieta;
	spf=pass (imf16.hostedemail.com: domain of apopple@nvidia.com designates 40.93.198.45 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767842603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k7y3spx1Bqic7FZfqMhPFLJI6X+F+BRR50c1QWqY+3A=;
	b=G1EOTi3aYNqxTGZMve749G5Q5V2oeXHEkanOildyoCqrQAJwJrfKGEoH8tLGAWJ8w/4qZS
	L06LUAC+JSly5HiDlXUOrX0VqPvxHDKKFgcRoim6sbwznR2+com3OpMQkgKGg8Ibah2p4m
	kpVnzLpoleBoimhjWORtXkJ6OjUD3pA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TXh1FgaLYd1olAwzjjaY1363oSI0AvWHBDDyyVBh13TqwDf8bvsTqPQpICYMxRKuUSmK/tP6qvYFKLJ9ikWMlyjag265pLP3eK0tjLLPlvPQzpP/QFmDwgLYkmr/BaLWk0iD/vew/7Pm7l/HER0PCGwHiTfOfMGm6leXWycW7UxWawBud+lT6bxDQd4A5yAGQWq8vA69S/0Qk5pVKvR0SOQya8FAQZDlVgkshVjkegn7J9ylamfDiU8PDj5rtddgyjWNjJpKOiasEHxbq3YS8HSnAeqJuZIXlDrgIB+Z+LTbIFTfxalSHnruK+tILqzr4GTWxsucF8yRdQb+LAnneA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k7y3spx1Bqic7FZfqMhPFLJI6X+F+BRR50c1QWqY+3A=;
 b=Re42oEpcOonEjvRYHoy/hE0rzpgeEivW7OY2OyltchIkPiZSXfc6Rnhwe7SQ5rzeULLdn4OCuEFtqCo2QvKfZKrsBs7EM09JwlVHKhsbg2Kn4INV399Jd/GV0CEe3ihbtZ2/g8wY6XA9jOKESpBWnhv2BtsTrOhZLvXpXIFJ/m/BNh32NE0uJPBKDdPt4/mrKpYBLDYI7R2Rcj9rxr+6m5WVRcPGgWPnvXGUp2azmT9Z+UqegtIrYbJl3yWrVoU8+q5kuFgka6+vhWsIMtI9rZ3asJHG4px6EVkC10ab8D9bDZ7MBGMHJHwJ8w0KLCXLiRI1tw43VVDUMcd7Yca4yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k7y3spx1Bqic7FZfqMhPFLJI6X+F+BRR50c1QWqY+3A=;
 b=V908ietae4mk51ALvW70TQRpHPO/KrXTEjvvvvY/RbhKAQiIgGrGJCU7MPliLUQy2k1aO8tAzIlocmaaLbOeJGMW2s+NGGtz1Giqz4RlWFhPxK+DN1DDBkYYwS2RvhPwlefefMtcUtw036FiFwI/YIxxpigUtWtZFoCg09Vc85/ig4hYQ/iThwEdaSaQX1QC1iORhhjzJjVSwzYR5P7LPmwRttptHFx1zYR5mBOQIymaENYg6PGdAY+gjFExSNDQmB23OPK9cNK21/XL6tBWEkIcPruxv/3sVN8USVoPqa9Y6duyubKscaTNPCWrQZHUzS/+9RlmEu7B8xqlwDnzBw==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 CH3PR12MB8909.namprd12.prod.outlook.com (2603:10b6:610:179::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 03:23:20 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::953f:2f80:90c5:67fe]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::953f:2f80:90c5:67fe%4]) with mapi id 15.20.9499.001; Thu, 8 Jan 2026
 03:23:20 +0000
Date: Thu, 8 Jan 2026 14:23:16 +1100
From: Alistair Popple <apopple@nvidia.com>
To: Hou Tao <houtao@huaweicloud.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, 
	linux-mm@kvack.org, linux-nvme@lists.infradead.org, 
	Bjorn Helgaas <bhelgaas@google.com>, Logan Gunthorpe <logang@deltatee.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, 
	Sagi Grimberg <sagi@grimberg.me>, houtao1@huawei.com
Subject: Re: [PATCH 01/13] PCI/P2PDMA: Release the per-cpu ref of pgmap when
 vm_insert_page() fails
Message-ID: <46lz5szq44vz3chzj6unh2sff4cfnpyvih7zty6fcnitzyrulu@6a2xdopoafxt>
References: <20251220040446.274991-1-houtao@huaweicloud.com>
 <20251220040446.274991-2-houtao@huaweicloud.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251220040446.274991-2-houtao@huaweicloud.com>
X-ClientProxiedBy: SY5P282CA0167.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:24a::23) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|CH3PR12MB8909:EE_
X-MS-Office365-Filtering-Correlation-Id: 2742a540-83ae-4cf6-5d59-08de4e6545f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TewcMrgEDt9NIjI5LLIDwGY3XN4ccvphZdIz5qvEDdL+qFeb3uBVfE0Ue1GW?=
 =?us-ascii?Q?1BcDOdsbC4KR/8ha4fzt/kAq5gfg15YXYntCWm9h96jBJsNcMhys1RW5++Uj?=
 =?us-ascii?Q?R4MN3Z3CrSo2hiNlSJnnEiq5EaLaSF0WyP3RqPWZHeK2LiloresDHexnQCxm?=
 =?us-ascii?Q?LGogx/ZlD0zjcYe7zScl0Mi6WC2kMQ9jtsd2tJwVk/Utu8NJ0+vD3sSj2Qeg?=
 =?us-ascii?Q?sVLhOlvKRqOPJMFss40eiTvEtwIVh978pVKoMV1dyhLw53XmMzRY1K4LMoVl?=
 =?us-ascii?Q?xDUcelCrHH9PrgkJLoXGlt8OVaaHHaAjb6sk6dLQWZ1ku5OxonIyoPaD8XC3?=
 =?us-ascii?Q?q55+c5I2rHMWrhrHQBSGJifSfGsLVWptzDHHcO/uCVtqMWGg5AY1A2OIHeRM?=
 =?us-ascii?Q?MXJVwYig34ItEGhpFsab48Kueahq98nP63FQ0DxSu8S3Nm5NLhL1C4/ETiv/?=
 =?us-ascii?Q?RIbYdOoXrLI0sXuwbaji2VnaJlAGFBmXxFibLLlQx2B3oWZMUkpM8Aql+KaP?=
 =?us-ascii?Q?3T1lEUWSZR2Gt7B+9ZpsR9N/kV3NiQh1lJ7LSJcHZBqQPqWsFLQsWToNK6YY?=
 =?us-ascii?Q?x4r/1vStjIGAwUSwOP5gMPKpeDyxh3pXz1jU2cRT+rOKD+c/udgT4OWZdWom?=
 =?us-ascii?Q?r67s1QaY4Vu3hs6j8DCi4O24JWROJAzulOEW9KQmpT/PEUj/hHjWS7QiVI3S?=
 =?us-ascii?Q?An+Yj3hDy13l42Ew1YTWWxYR3pJ9jIDxrm7MFIIX0zw1AxFNq7QKoC4NvPYs?=
 =?us-ascii?Q?NPoM4U97XSI80tbm85bMdPW5lf/Ax2ZYoVX6wD++tv9jP2WcE5M+y3EJkq/7?=
 =?us-ascii?Q?YVDA7ZznZ70Zs95E2facoctVzzVWIguKz5rXGHpUNMwfZvtqxqflKhLOXysy?=
 =?us-ascii?Q?c5BKfWG9uKJQ/fATpCG4yh/TEoyTh2+Aqeh91HvcOUKda49Te86dHD4ppPpF?=
 =?us-ascii?Q?n4l8DrlEXJrvwsRdPesy6vp3OYZeeCHqQmG85WLm0DSS8poaQviaMszzTzDq?=
 =?us-ascii?Q?ZhL6WrEEx0MoP7G79/OZoiAc3eaH6t9RjG77IJUnTR8bx7JDPg8UbZnvMkWY?=
 =?us-ascii?Q?Kg3Pr8ZZ7T30JjI6Wel5etDeycPKP9nATEWDjPZK2wPGPKfs6BB/bor88kr+?=
 =?us-ascii?Q?uV3mrWfS93CKj01ww1hcEwHVPVK8oDwjyit75BHX/bcRDHvhRkZ+Enb3AtqH?=
 =?us-ascii?Q?RBGoSGLltJr1fryG/01okJ1YU9CxbhwqPZvn0yuulntuVXdWfVydkj0q5TNL?=
 =?us-ascii?Q?zwnFoh4BDdjVLwXSr8V+95PJ6TbX7XcjhVd0+oHAU92KfLQaiDMOYBS1JFYj?=
 =?us-ascii?Q?Qs6W9ing2kjZVN9DuWxJ99pX9D+pk8Txb2bKEjZP4qr9Nm3Y4HiG5XQuc3a0?=
 =?us-ascii?Q?ari66JjGEtknIO6QlavLnRJTdNcHB3sanxHrwEq2gkpL7KLqdmfT2dPkcQOy?=
 =?us-ascii?Q?UfNdFVTPbJrJ3lbyhvgUWCdcTAvGuXRm?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bNJBNuetYyLHrendeP9ct6xHAK6HZJLD2KtVpLEzCG6a64zJhhIGlEtjLZaA?=
 =?us-ascii?Q?e4qAzJ2FYntKJU0SrKOSSDGT6e4k6TTxSeY4Iujfk0bBlHocVco9pnWlt4Pe?=
 =?us-ascii?Q?8LJz7cG5krgtHXiNKS+VOIeYitrjyt3Ejuyhe4FQmRlLbWifcD4vRCOSVoD0?=
 =?us-ascii?Q?h1sXLx3BU3r5pD85nUt1d+Dxsi6+AtdJEG7GW+vCrFy38xej3Y56t5D8pbQz?=
 =?us-ascii?Q?LdNt0ECgmzWzRetSS5NVG1y9mdt+yodFHRxIz0jJB9pK/1gBJFqWEhRQTgVe?=
 =?us-ascii?Q?V+49W7GxZASJNdLrQZwWi6X3mBqwgM3/QFZVDJWoEZ8q2Lo7qdt1DJ4dkNsa?=
 =?us-ascii?Q?2KwS84X1q3JQV8OMyKhak5haycuUx+KTwk8Uj3VBC5Z5JmRpbpOyKTeAX8Uw?=
 =?us-ascii?Q?s0jHKE7z5ie8i+T1vuOYP/L10qA/bwhmdMXktmsf/wFeovUHFSUQlAASAvMF?=
 =?us-ascii?Q?MlED7xHWt4+pbGmP/dYc2/jgpyijwDq4lk+bc22Ccmda/JhdwZkZHe248hXo?=
 =?us-ascii?Q?z+/SKC1abiLXSZg7MGOUQoprGt28l4QCBkGj9NWdizMP6dyz+T1NFrFwLMeT?=
 =?us-ascii?Q?Jgj6O6wPgOiPtLNudKy8TnARYqEfvO5YkmBoSq1a5nNeimIRh1Nm8ib+N5fF?=
 =?us-ascii?Q?VY4ajGpC3SUr0V9NFxf08RGIWIzvJqSkfTZ+yVwoo7+OU2PhoubY47xTt1Ec?=
 =?us-ascii?Q?6HkB0DtWXGRlDE5QMzh4pzDY3TxSdfQqDz5LnmmP6QZN2RsQmplPyCsD/YHE?=
 =?us-ascii?Q?I+Y6tBU6MXBnvAqlb8tpuStwEziRX1y0XOeYoDtmrMGvWoenD0a8XmNsIyp0?=
 =?us-ascii?Q?WAKTlcGj/wrs+W7moUcriReOrOLF3XmeqH3UVFv4SfzrGHo/1G/KpZM+9hVG?=
 =?us-ascii?Q?qaFJtTQeFFeGENLzsVv4F5veUIh1p7e2C7dYS/Cxljsgtk4oQB2CXAkY5WYh?=
 =?us-ascii?Q?b1a4Xshzfzl4JQ7DXUIpBgzl/fvVojqI0vCN7/w+W/XNWfQpi5d7wE3AqvhD?=
 =?us-ascii?Q?ShTvKNoYXDtl+Oh20Pvy5+M7sYj92rVvbejxb4fgrNhZ5mwAiwRAXhKXf5YE?=
 =?us-ascii?Q?jAEXsNnYepJgtJaPXJ//6UdCryCHp1bV6jBfMWLfvbcM3pJ610n7IZNkUyWa?=
 =?us-ascii?Q?ciOhlAOJIsmpiQInxurGIJL6cpWIgvDaXb789SJU53QxO40HVMfZ0uEXQrjt?=
 =?us-ascii?Q?GZpHcXd+QxbxJK5yaRt8D6OOd74OWGiDJSVj1A0ytnFKHnUBVNiG8KmbpbBF?=
 =?us-ascii?Q?yLKQ2jqmalvAla2rjVfg8xytzKtNRKcH1ZlMpz95vpTVkGbdbuVeREnB3qg7?=
 =?us-ascii?Q?EVf9/TwHwgx2U1zNLp736eMn1u4UmRK44EXDMCYV4oOwpFf34aVY4+4ihs2V?=
 =?us-ascii?Q?DxFYA4s23pArGZoCD/rtDaTOkUrkrR7J8dPH/iXqHJ/v8lHAusPeZoxWO+yP?=
 =?us-ascii?Q?tJRzuJUyZ5NjD7rWpVDLeMHS3mOqQwpEDr1hkdBXH1i9JAg1QCh3lVnstaK3?=
 =?us-ascii?Q?2mG6F92xB2zI6nn1G7o9CHRw7typoUxlL61mO5gSZFMaC72WAApRV0E/MD02?=
 =?us-ascii?Q?u+pCR8azH3NXPF+uR7e3W0c7nqStunLN712o0tW7lacmhm6+omBoTVoz5MXk?=
 =?us-ascii?Q?rrWknZmdcz6+9TAWfEjfMPmoY0ulaz0ToGHh/yaPqo6N5LQ3Jj95SUyk/ilQ?=
 =?us-ascii?Q?4/HR/sUmOcmD/U4Ks9B1hZV4KlMssdXkho4V3Jce7/bl0TGubvuCEFjZiL9J?=
 =?us-ascii?Q?PoGzY0Pktw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2742a540-83ae-4cf6-5d59-08de4e6545f6
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 03:23:20.7124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F+ZwdkJNQDhigZYPG4XGggbydvitNsrQueBVYEkgLkn3HyOqRL5nzK8h1hKcl2loVH0GiGjIQA3SR1gR0LIDBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8909
X-Rspam-User: 
X-Rspamd-Queue-Id: 8D0AB180005
X-Rspamd-Server: rspam04
X-Stat-Signature: dkuic9tnk7jj6xzgyxzu4to8mte48g66
X-HE-Tag: 1767842603-871434
X-HE-Meta: U2FsdGVkX1/MH7OpzPQ9P1H4xB6Cxz+vviaDnkah8Ppx89JZKNFjrD3PeF0bBal7rvxhsrILB4ZgPFVWsQXfQkJNjMFNnfAmN7Rxq5dqcbhVD9KKdCO3t7pefV8wDIxMWn3IAsUnpo7v3N5YHAEF3dGKSILAsFcVXUq6sGNy0544YI5dF7GatmhighLtNtZHuPHWWI91SeLh5WmP5rKuf2b3+Wp9doqldwPNKde3OtTsNosl5qgO4PobkWj1JL4JQ9w/ZJvGHqE0yHIf5g3RL4Co8Fac2UFNwIT1mc5X10DUS05h8b/HIYR6YPhegSlqExuYUf9kBKlAOVu5OdzJGpaJfEmnWWA1FH71376VGxlKNURulFsbC524hQ1CxCI4A8FabL/OkhbJlBxqRioycrffmYzK5oWeJEnj7lK/SMcgKqphOFoA8YZzR1TxTfBxw6foD9MOWAgnJnF3qm2aV3b/Qdz6pcyFWgB1/Mzxfo9r+BcTWzHMHE2stUOu4yRBQbImoWAs4VB/HgMigtABSEdS4ytPbMAW71quXnEXZPNIdIIgn3YmWGYFoSoOstjCVqQAgA7XXA8wNWbCVz97vsBZb0+ccsYRSXbPEP2M0ik03Pcqk54SAPe3VbDG0vL64IRkTApGh6bNM5qd4dlvtkj8on0+SLXo92kAx5v1vy/kWfkaCx0zTL1FGIjJz4NQd/WEWefEHCWXpol0zV0d08f6z6vcYCqIo11bbcB5juebIhHLrU/thRze5JG9BKWij3gvoCG7wSFk83YhaE0x3UNcvQJ4CFbYNlSTIIe8A/yDi5R19VzZFmMfOVTr0iTKX04X04yaER0JuPlyWeIG9JNFxw0i6PSbetRMCgqUbu6P9UN8QpKleQUQduD1r/bvXo/3keZ1RDrfVfPXVe/Z9ENZTeiPR5EwOts/jtYRxqgsKUFP15mW6Y4frJ4g4i0o9c01X4Fz/vlMAe3fm1f
 FO2imEW4
 yRmvIqUJGoAtgS1Ow4uwn58PO0RNKsjSulSqGCYfQisyMrWt7yF2nUvISitVLk2T2zn5wQoY1X4GC3QKZQyEFWILIYQ/hGwyBLy8HoVDHVU7NlKy01kyWHAOHdsR++T+r8dvrEYkT1AXGxqYjlfGvOzfYfwJ+KDb4LPIsu95fSbtk1H0poTVhtFeiozRWc5J+xPcVaXS2a2bDvBqUVkFvSMWSO397S7wVSakOuG/lviLr3xV6CTcdOsP6OpeV1cSMuc9wve12meI5m1WiGtuAzzvvYz3MpwngzlEZf+6pvdSsgcbwPJtawe+ZQCVRLWF0f8mbTESNS/iYJ0o88N/M+DeBVsB9zilb6OLHyJZFhgP8lgDyvnQuAeITQ+9EGraQjDHVNQ4ARRQak9PhL+HtmNhqu+5won6+nHnh/7SljH/d38RT75+whJ1762+aEW5qrF+88A/Y9OqVKNwfWrtmPL0qjUsSQ8n+awqWRT5uaIKmPDDZTBWkExj4oyJ86JLFGlA+8U9q1U8XDjU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-20 at 15:04 +1100, Hou Tao <houtao@huaweicloud.com> wrote...
> From: Hou Tao <houtao1@huawei.com>
> 
> When vm_insert_page() fails in p2pmem_alloc_mmap(), p2pmem_alloc_mmap()
> doesn't invoke percpu_ref_put() to free the per-cpu ref of pgmap
> acquired after gen_pool_alloc_owner(), and memunmap_pages() will hang
> forever when trying to remove the PCIe device.
> 
> Fix it by adding the missed percpu_ref_put().

This pairs with the percpu_ref_tryget_live_rcu() above right? Might be worth
mentioning that as a comment, but overall looks good to me so feel free to add:

Reviewed-by: Alistair Popple <apopple@nvidia.com>

> 
> Fixes: 7e9c7ef83d78 ("PCI/P2PDMA: Allow userspace VMA allocations through sysfs")
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
>  drivers/pci/p2pdma.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index 4a2fc7ab42c3..218c1f5252b6 100644
> --- a/drivers/pci/p2pdma.c
> +++ b/drivers/pci/p2pdma.c
> @@ -152,6 +152,7 @@ static int p2pmem_alloc_mmap(struct file *filp, struct kobject *kobj,
>  		ret = vm_insert_page(vma, vaddr, page);
>  		if (ret) {
>  			gen_pool_free(p2pdma->pool, (uintptr_t)kaddr, len);
> +			percpu_ref_put(ref);
>  			return ret;
>  		}
>  		percpu_ref_get(ref);
> -- 
> 2.29.2
> 

