Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA39E1098788
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 14:22:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E5416B0137; Fri, 20 Mar 2026 10:22:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 096E16B0138; Fri, 20 Mar 2026 10:22:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC69D6B0139; Fri, 20 Mar 2026 10:22:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D8B006B0137
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:22:48 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 73811140259
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:22:48 +0000 (UTC)
X-FDA: 84566657616.17.345889D
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011050.outbound.protection.outlook.com [40.107.208.50])
	by imf25.hostedemail.com (Postfix) with ESMTP id 91941A000B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:22:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XIZP5XXb;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.50 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774016565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ot1SC4nCcdRBPrf3RfVrkCngBzY7K4AsfRwSqO0YxW0=;
	b=L3ex6gHEw50qBhq/WPTSpb/4icnwb+Ogqou+uVjVAM2FSLDrdGaUuM8GFJNQxLgdPlVpFX
	gkNXFRknSXM4l/NaLcuzfHxUWJ9HtIbfo+ojvplMLd18DQWxBZbN6pAHB3dPwE71QdB0f1
	Eb9qfUekidl1lbSkzC/sr4W2rZSDRDw=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XIZP5XXb;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.50 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774016565; a=rsa-sha256;
	cv=pass;
	b=NUqloEUpg19T7ibwOPZeIUXGsuYIhradILSM2rhkalMVRFECz/Vp3aNyfR64B7NUJtN7BM
	X0Zj+6hPVNsAV16DzKsYrwDhVBJ1ifzQPM8WNl8t6zuB6CDUyYfm5KtMuIRmeDh3q1bZKF
	4mblSWlOvzjX65TFZ8SgUtangHC1aCQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s91GjCKwdW9K3/XhtDB33d/zW0gGXkzrNAda1ytHIj0HqoOiOS0t3KUu6GTcLk58Wk16jtOxkM+bnO2WVu9ilabVqtp5T+exRLdx7m3CNWovQ8ljqVDyxfqG9GSv1Dj3Bv+CCsCPcjZgzmAoTF9N8OEYqP1/AMmop6LUPV/oGfEeVdeY3vc5eGwnCG7YR7xaBxPVbEvOJbdzWDwH6Bv7n0XK6u5FU6Xoj8XIjyEOUGXVdvzY1V3yU7gQjMh15h1oFMj8HINJePt/J/fuzRmk1s5oylH/KPhS13QOs010rv8WXMQZThQcokR9cPojFij5ozBCoZXeovsVRMBdXYkcWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ot1SC4nCcdRBPrf3RfVrkCngBzY7K4AsfRwSqO0YxW0=;
 b=BMX2HeJHPzuOnCkkpw4p4kKlUr3EhePDO/aNQKo9eiNdFrWagk8bL86ko+TtE67jRJwwo3dysxEXw893CT0wN2sTmIJn4d7Mvv+wyR0QYXXYHpHDjhvxVkDXZEspY/yFfZ/QklM90sAOqCelioW/2rbp82aobBfIFjWAfpXQzCm+wagrS41+kzWZws9NiKY1V1pKwLRpEtDJHzyZcEO0G7D5sjF/bgvSxnlA8yzdzOV/hiqN5Gm1P4mMHiFtV5t0RWi4fH8H4YPbBqecOkW2qZ2cxdggDtU2dSkp8hFRhNxXNrii65lhoJcZhzPOkHfYzkOVLI9osVn8MQIV8z1sAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ot1SC4nCcdRBPrf3RfVrkCngBzY7K4AsfRwSqO0YxW0=;
 b=XIZP5XXb50W2F0/2z2WANK8EwD755I4lgaCakAbx17c94nn6j27BDVzNl1fF+iQj0wXwEbPDfHZ7INXlbjIRxT1xfawAplkNTgCZu6QpRNCReKZQsIvR7l6BtZ2chRhhW6Og/l1j5Mt0GD27DFClMVNz2RcQ8+gaz6wXZcKMn5Vq81MZiCnwQKHXmfDXu9uMqp/hZJ+Tu8ssSL6e0Yjp85RYBB8dWt4ABufHLe++3Fs3hTRMmw3UitvNXwyYeT6vx2VjCvm0fr2h5KW2y6SSHkhMtLQpk/bnb7pCmN7Kp9tJzlElayw0nB2LVRhH6zlIuDT/iWAT7RvuDbXDmDlZIQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM4PR12MB6376.namprd12.prod.outlook.com (2603:10b6:8:a0::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.9; Fri, 20 Mar 2026 14:22:31 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9723.016; Fri, 20 Mar 2026
 14:22:31 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Matthew Wilcox <willy@infradead.org>,
	Bas van Dijk <bas@dfinity.org>,
	Eero Kelly <eero.kelly@dfinity.org>,
	Andrew Battat <andrew.battat@dfinity.org>,
	Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v4] selftests/mm: add folio_split() and filemap_get_entry() race test
Date: Fri, 20 Mar 2026 10:22:19 -0400
Message-ID: <20260320142219.375118-1-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0154.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8c::13) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM4PR12MB6376:EE_
X-MS-Office365-Filtering-Correlation-Id: 6eff8e2a-1d31-4839-a982-08de868c1f71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	uWqxp+xKhf5V7crO/E4QtyvG8RTsoYAhJSJOcs6X0+dOinK4Fwb4TCeqygCzYyABMcYSNQTonWFTepJyMAsRsaOxViOyRVCWBpHeM2/NRj9SSIt3trR9vnxxsfdAzh1XYa8SDCsnnn0L7iljJaq7NIDeuB3jmzNO0b+GBfEYJqrrzZ82BZhq0xgRVxZE2wt80Lv01tbkA8Gy3I9ZFyXb9eWV8b+fE1xZ1SbmiQQnrq64wpj/StHum7PTOCNWnDvcOaPvedEq+5owKZ++RMfJLm7sa0ChtwKhoc06dZY3oW1Yjr0u1a7iM72D4BdrieL5PhKEAsWyA3VGI2zaBeAcFA0PWXc73TuGK+nW2jfYl5UUcpMB1duTSWD4tLVCcV4RWbu3cdHQdNjKP8FMkLtGxJ7hpjvo5HZ2EiH2mMEjMOBLDPUspYrE7YwKOxUn/lkK0jnafDdCa6QEhgmfF9GDTDHMG1jh3rRV3ZV8pUwjMHMLU2Wq7lnwgV2PFITx3Zgm9SvNT6cx270RdKSb6bTmC/JKyzM0HQtbzhDPRgL97jbD3x6qJO7HYDN5hdpThLoe3kzYUUNqXI7DXMWFu//hCj+vzRCyExdDEmpXm7IBmNHZZytIrn+x2pLgTjvKWAbHtHqocgo7nouAbfMMPTEjtQUsaJdUf03tjgf2/yhVMDzl7fB2QFb9RXG/BxW4jflfGkC4ivXkms+v2QXeDQd7NYiq1QGi8qEZ7euSfC+3oyG79yPepEwqtfh2PQAj41km
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JZyB/hIp0OrbG3pQFFhzyuUPFJ7DiE3k/M+3P43BQxaMyG4XrNbjBujEk+Kv?=
 =?us-ascii?Q?UaV8mu80J+pUU7ms2JZpu1ldSwFtfNM6LXFfD881HKKWdNn/FquGpVBksiQu?=
 =?us-ascii?Q?ijALLDqbKcBA+xpiL0EPBylyH7GofEyjIQSrE2sHIU9vK+LLGjWx8npOwC7L?=
 =?us-ascii?Q?ntasDVHFuWp1rpk71mAsJOzlqUth9tflnm7tg8YI2Kg1XrIkcggyKpvxnSdT?=
 =?us-ascii?Q?lMx1o5IULWxRwj002ek52W+BQf7DTr0zmcKPDsW+ZmO78utI1eThDAtU+1Xd?=
 =?us-ascii?Q?F33oWuiHKn8L1ku8L3fJItqcvE2PcdNPk2Z1e36g1cBVOKZMhWEv4K87zCLY?=
 =?us-ascii?Q?u3zn15ahydEBHyIRwwLjFZeGx4nW2pfQjNphyYaOYz85bfEw7cohZukNI7we?=
 =?us-ascii?Q?SDQADcagQZH8Fhnlcw+oA53MnQ4I8JLeUojsX39IsZDcq88ByaNFTDwYv8hG?=
 =?us-ascii?Q?zbNsSrF+zHfPL6ikdD4wnk0AxJ0iGFBJ8MWX9BmuyCpdhtsX0vlQDnbM1Dtr?=
 =?us-ascii?Q?KNRZs63ApVI/50FcTOxvD/Eczqou6g/xeOHGPZVWbU+TpwMbyh7xgu5xdtdo?=
 =?us-ascii?Q?0iAICDwJsjn/ujWZmEIdfmoM76VKOmUDFeAtRqTrJYCE64hXy0TYzZirzDxh?=
 =?us-ascii?Q?2o4HhPO1LaOXb/FnV/iRHs3jbKuKUVrslfxieyWEs2JWfEaLigXrZh6fAf6t?=
 =?us-ascii?Q?V4Ztem6e5GmgelNg0uMBU5f+o+fRMIbqREYmeIQrx//uW2jPYEOi4DkrVNP6?=
 =?us-ascii?Q?cRxZCcT6kxJVh4gkKF70YgE3eLwQbFhbR+L3bjiDc1x/GaZzNViGcsSNV9bG?=
 =?us-ascii?Q?dthyvMu+WggZq0Wk0wP8FVny+Mi/RHMpTq62EHpW2S4VGSLlUzqAwde1sNJ/?=
 =?us-ascii?Q?yGL1KaPME1StnKszDyf7xSI7XMY+y4+Nc6rmI02RJW/58eieALo7ngtuy+HF?=
 =?us-ascii?Q?YsgGaiUeswjP0TgzcTHZF08j4jrMRGN6Oqov2JOF1UW3uiyY37LDy2T0iKyU?=
 =?us-ascii?Q?k/f8T5Z/C50b/FJNJ8w+cqJtnJ9Bg/LPlwKZOvJiwqsXjfm5YAKQyH2I9Ksi?=
 =?us-ascii?Q?UZkWZPwdhwsv8e88Gj8kaO305Ob4WCerj4p7Pr6d5B+LtLt/LMXSx7hwjzjU?=
 =?us-ascii?Q?9Uj2Vn1ZMwKfXaFuXcigL8TWDCqDnchr667oPfanLTN+0WMjL1tAcukgTf7Z?=
 =?us-ascii?Q?68mwidlbvOxPBBUF2VSyZMlxHGWfubWTAwp8fHdkjTV9yoP7MCKaZAv7k0+Q?=
 =?us-ascii?Q?n1yB2q4IeD74azoJXc4bRR2+JalYBK2PG/1wqdE45flAcfIEIAFU+rtZOELd?=
 =?us-ascii?Q?cFjr8F6GYIlGoGqT30A/JX2YyNmsOeU182ECPj3x6xHyYoWQuJrS6JcyzINp?=
 =?us-ascii?Q?x3wV/O4xOx5JBh/fBzX6jzByw3bQkjxD8j154lVzx0jIiuuOG4KVo8oBLlQx?=
 =?us-ascii?Q?fr8IY98e/lySysM12vhCtV0tjDtPreDpF5ORJC/nWo9FzMT0Z2cmvBoVxUDn?=
 =?us-ascii?Q?qplndEvGDnDTm51AXTnY/yxhxwTNYfSfvzYfvNy2duvIiEPCHU7Ycw+RDqu0?=
 =?us-ascii?Q?aqihgDtZbnVtnpC8ohLlclMV4p5MATf5CU4TwUO7ANlgNAuHaE9qToQDQ/4G?=
 =?us-ascii?Q?PuTicaR+Cl5quscnAC5eoNonB9Zv9oe+ucoYDJj22RTlsWi0QzO3ybhefkhd?=
 =?us-ascii?Q?Rxjs6Pgj+Arbo/A3lm133Xz0biwwOJYoien/22u9YJN6FSWPuTqrPz4xTHI0?=
 =?us-ascii?Q?RiV8qW6ZDw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6eff8e2a-1d31-4839-a982-08de868c1f71
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 14:22:31.6492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5igPMcN7IvDbJ/zaRLnu3pE4xrrSJ3JrEwVP77JDA+2zYifX5nT4FcXoxureyzK9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6376
X-Rspamd-Queue-Id: 91941A000B
X-Rspamd-Server: rspam07
X-Stat-Signature: nhuh5p4ji9f7buyk4eybrm49zoijwqpz
X-Rspam-User: 
X-HE-Tag: 1774016565-734775
X-HE-Meta: U2FsdGVkX1/o25qf/QKyKi+pUK/sqknnSyc24ve5IMy6q8XuvtOb5X3GOZV53QfDoYJUcIRrJY2CELmoMAjmJ5QQlSIue7UOV0AI5NKsELkXk8AhIFb+cCx5XvoRFoEjFvTEBg4eK2Yr0hsTFTxAyWRf0YDObqGLzttEicEJSFEaH9+zLo+Mh37nfLFkkc5gQbLvVPpFEcvSSH4CmuEDwjNsjHoTgMAqrKigLebJfLUMUjJK45/QXKsM6AJOkWGQRR2waOXr0uwj0DT95kQ3QvIpvz6A+W9IiMz2jHeyvZ8Vrw08aTOWBSb/JrmNblCByc+o7H03EXoXHNJXaFnCjCKRsSNenet12ncbA1fUvY5Vv/hm946YjsJPHxPRMyvg8mvQg/x85xRG0uKxgfBktsadEXmdSPyq3A0KQdvOV4wEUlZ7RVzOy2jZamKk5DbsLGWrJ6M1wyd/VGZsRXbR5PxY7UAAiFYInuo3N6QQBZnPN1MJFeHkIZuBGzWDF9/V5UU6gOiuDRsOF+jGFbxR2krIze0DAqj7gOiedzVGB+Ow5cU7DJXf1m+qm7Z8qzk83FsfGbKXeM4RmJn3P2GgXYJUuT3BakDdj+kCx9LLOSXXcgZX/bf7l8ltaFT945qzXFtkcoutZ4vawhcU32707qO6FtE9I2vGNV5t9yJ9vYtj4JwxUbtWMPTBm8CCKqLa4U4NMUGAL4v7KtPbyvcZ8DO+e5J4P8BSMGsq+pDa4NfhYeUSkL+sM0ISg0H2pCzkmc5sR14E/8mtbF1XZXov/+btOvZd7VLw1tJNoQJVbswHZ2GXlkHpKwkDuKPdNqe5x0aX/o574GYbeJOtBMgUBsB+AeZzjtLo9IIW/Sp+LyyHOs4OgwkX9UTnvXurjYIQldj5gx+6C47/019/l62lv7gHyjH1797Fg6MDtRkt56ondjQDzcEZ8ZLuA1kANxIKqz69fTI1vln0cYUe8D5
 xkyeAXPx
 7P2ZFLN+aaf85ikmlgFhpaGAP5JyaY+BoPAwmEQk7h8zNJCobpo3w4ZYekZnoX3UaCQxgeU8jUOtxLjCdmdBQ8ZA+jlrE6Ied9j4v01Jhx7X4ABeHJH96YbO58pzhXntgOY2ilgJWdYy20gAokb7rrx6V7uaZ5Rrff2+/3oVRjXO9cc2YbPru+b4ratoQ5hTjAIs1AlNxaXUAVbaLuYpWdl+Vo4cTrF5dsnVhbJyyetXDlf3Nr/EfXrA4WGsumvZS9ZEB95lwSQrbQfsLL6HPZ9ZmzjmqKHuOstqzY4mnY4+oA2CyQCeNxv/pulZ3icgz5Fm9IkVnnszoaqM/381pKpZR0CdT79QPlD4knKjIez052hNaK1viIvLUaVoqSotJlxb+UAbmFX0T0sQSrc7z30rJ31TDzopsbYSkx1SkH/p0sfYhe53ds5vCwXfwMHq6iBWL7FKbOFfowIASWsgpGJSvtVVdhLKO93vlmpFKIpHGfFepJ+KFE68imMrAV5tooSt9wzeh9SQUURBTUXy/MrZqwoGjQTfqtYbo+xqHPVR/14+2MAnyYcuNQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The added folio_split_race_test is a modified C port of the race condition
test from [1]. The test creates shmem huge pages, where the main thread
punches holes in the shmem to cause folio_split() in the kernel and
a set of 16 threads reads the shmem to cause filemap_get_entry() in the
kernel. filemap_get_entry() reads the folio and xarray split by
folio_split() locklessly. The original test[2] is written in rust and uses
memfd (shmem backed). This C port uses shmem directly and use a single
process.

Note: the initial rust to C conversion is done by Cursor.

Link: https://lore.kernel.org/all/CAKNNEtw5_kZomhkugedKMPOG-sxs5Q5OLumWJdiWXv+C9Yct0w@mail.gmail.com/ [1]
Link: https://github.com/dfinity/thp-madv-remove-test [2]
Signed-off-by: Bas van Dijk <bas@dfinity.org>
Signed-off-by: Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
From V3:
1. fixed for loop stepping issue
2. used PRIu64 instead of %zu for uint64_t.

From V2:
1. simplied the program by removing fork.

From V1:
1. added prctl(PR_SET_PDEATHSIG, SIGTERM) to avoid child looping
   forever.
2. removed page_idx % PUNCH_INTERVAL >= 0, since it is a nop. Added a
   comment.
3. added a child process status check to prevent parent looping forever
   and record that as a failure.
4. used ksft_exit_skip() instead of ksft_finished() when the program is
   not running as root.
5. restored THP settings properly when the program exits abnormally.
 tools/testing/selftests/mm/Makefile           |   1 +
 .../selftests/mm/folio_split_race_test.c      | 293 ++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh     |   2 +
 3 files changed, 296 insertions(+)
 create mode 100644 tools/testing/selftests/mm/folio_split_race_test.c

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 7a5de4e9bf520..cd24596cdd27e 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -105,6 +105,7 @@ TEST_GEN_FILES += droppable
 TEST_GEN_FILES += guard-regions
 TEST_GEN_FILES += merge
 TEST_GEN_FILES += rmap
+TEST_GEN_FILES += folio_split_race_test
 
 ifneq ($(ARCH),arm64)
 TEST_GEN_FILES += soft-dirty
diff --git a/tools/testing/selftests/mm/folio_split_race_test.c b/tools/testing/selftests/mm/folio_split_race_test.c
new file mode 100644
index 0000000000000..c264cc625a7cb
--- /dev/null
+++ b/tools/testing/selftests/mm/folio_split_race_test.c
@@ -0,0 +1,293 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * The test creates shmem PMD huge pages, fills all pages with known patterns,
+ * then continuously verifies non-punched pages with 16 threads. Meanwhile, the
+ * main thread punches holes via MADV_REMOVE on the shmem.
+ *
+ * It tests the race condition between folio_split() and filemap_get_entry(),
+ * where the hole punches on shmem lead to folio_split() and reading the shmem
+ * lead to filemap_get_entry().
+ */
+
+#define _GNU_SOURCE
+#include <errno.h>
+#include <inttypes.h>
+#include <linux/mman.h>
+#include <pthread.h>
+#include <stdatomic.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <signal.h>
+#include <unistd.h>
+#include "vm_util.h"
+#include "kselftest.h"
+#include "thp_settings.h"
+
+uint64_t page_size;
+uint64_t pmd_pagesize;
+#define NR_PMD_PAGE 5
+#define FILE_SIZE (pmd_pagesize * NR_PMD_PAGE)
+#define TOTAL_PAGES (FILE_SIZE / page_size)
+
+/* Every N-th to N+M-th pages are punched; not aligned with huge page boundaries. */
+#define PUNCH_INTERVAL 50 /* N */
+#define PUNCH_SIZE_FACTOR 3 /* M */
+
+#define NUM_READER_THREADS 16
+#define FILL_BYTE 0xAF
+#define NUM_ITERATIONS 100
+
+/* Shared control block: control reading threads and record stats */
+struct shared_ctl {
+	atomic_uint_fast32_t stop;
+	atomic_size_t reader_failures;
+	atomic_size_t reader_verified;
+};
+
+static void fill_page(unsigned char *base, size_t page_idx)
+{
+	unsigned char *page_ptr = base + page_idx * page_size;
+	uint64_t idx = (uint64_t)page_idx;
+
+	memset(page_ptr, FILL_BYTE, page_size);
+	memcpy(page_ptr, &idx, sizeof(idx));
+}
+
+/* Returns true if valid, false if corrupted. */
+static bool check_page(unsigned char *base, size_t page_idx)
+{
+	unsigned char *page_ptr = base + page_idx * page_size;
+	uint64_t expected_idx = (uint64_t)page_idx;
+	uint64_t got_idx;
+
+	memcpy(&got_idx, page_ptr, 8);
+
+	if (got_idx != expected_idx) {
+		size_t off;
+		int all_zero = 1;
+
+		for (off = 0; off < page_size; off++) {
+			if (page_ptr[off] != 0) {
+				all_zero = 0;
+				break;
+			}
+		}
+		if (all_zero) {
+			ksft_print_msg(
+				"CORRUPTED: page %zu (huge page %zu) is ALL ZEROS\n",
+				page_idx,
+				(page_idx * page_size) / pmd_pagesize);
+		} else {
+			ksft_print_msg(
+				"CORRUPTED: page %zu (huge page %zu): expected idx %zu, got %lu\n",
+				page_idx, (page_idx * page_size) / pmd_pagesize,
+				page_idx, (unsigned long)got_idx);
+		}
+		return false;
+	}
+	return true;
+}
+
+struct reader_arg {
+	unsigned char *base;
+	struct shared_ctl *ctl;
+	int tid;
+	atomic_size_t *failures;
+	atomic_size_t *verified;
+};
+
+static void *reader_thread(void *arg)
+{
+	struct reader_arg *ra = (struct reader_arg *)arg;
+	unsigned char *base = ra->base;
+	struct shared_ctl *ctl = ra->ctl;
+	int tid = ra->tid;
+	atomic_size_t *failures = ra->failures;
+	atomic_size_t *verified = ra->verified;
+	size_t page_idx;
+
+	while (atomic_load_explicit(&ctl->stop, memory_order_acquire) == 0) {
+		for (page_idx = (size_t)tid; page_idx < TOTAL_PAGES;
+		     page_idx += NUM_READER_THREADS) {
+			/*
+			 * page_idx % PUNCH_INTERVAL is in [0, PUNCH_INTERVAL),
+			 * skip [0, PUNCH_SIZE_FACTOR)
+			 */
+			if (page_idx % PUNCH_INTERVAL < PUNCH_SIZE_FACTOR)
+				continue;
+			if (check_page(base, page_idx))
+				atomic_fetch_add_explicit(verified, 1,
+							  memory_order_relaxed);
+			else
+				atomic_fetch_add_explicit(failures, 1,
+							  memory_order_relaxed);
+		}
+		if (atomic_load_explicit(failures, memory_order_relaxed) > 0)
+			break;
+	}
+
+	return NULL;
+}
+
+static void create_readers(pthread_t *threads, struct reader_arg *args,
+			   unsigned char *base, struct shared_ctl *ctl)
+{
+	int i;
+
+	for (i = 0; i < NUM_READER_THREADS; i++) {
+		args[i].base = base;
+		args[i].ctl = ctl;
+		args[i].tid = i;
+		args[i].failures = &ctl->reader_failures;
+		args[i].verified = &ctl->reader_verified;
+		if (pthread_create(&threads[i], NULL, reader_thread,
+				   &args[i]) != 0)
+			ksft_exit_fail_msg("pthread_create failed\n");
+	}
+}
+
+/* Run a single iteration. Returns total number of corrupted pages. */
+static size_t run_iteration(void)
+{
+	size_t reader_failures, reader_verified;
+	struct reader_arg args[NUM_READER_THREADS];
+	pthread_t threads[NUM_READER_THREADS];
+	unsigned char *mmap_base;
+	struct shared_ctl ctl;
+	size_t i;
+
+	memset(&ctl, 0, sizeof(struct shared_ctl));
+
+	mmap_base = mmap(NULL, FILE_SIZE, PROT_READ | PROT_WRITE,
+			 MAP_SHARED | MAP_ANONYMOUS, -1, 0);
+
+	if (mmap_base == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed: %d\n", errno);
+
+	if (madvise(mmap_base, FILE_SIZE, MADV_HUGEPAGE) != 0)
+		ksft_exit_fail_msg("madvise(MADV_HUGEPAGE) failed: %d\n",
+				   errno);
+
+	for (i = 0; i < TOTAL_PAGES; i++)
+		fill_page(mmap_base, i);
+
+	if (!check_huge_shmem(mmap_base, NR_PMD_PAGE, pmd_pagesize))
+		ksft_exit_fail_msg("No shmem THP is allocated\n");
+
+	create_readers(threads, args, mmap_base, &ctl);
+
+	for (i = 0; i < TOTAL_PAGES; i++) {
+		if (i % PUNCH_INTERVAL != 0)
+			continue;
+		if (madvise(mmap_base + i * page_size,
+			    PUNCH_SIZE_FACTOR * page_size, MADV_REMOVE) != 0) {
+			ksft_exit_fail_msg(
+				"madvise(MADV_REMOVE) failed on page %zu: %d\n",
+				i, errno);
+		}
+
+		i += PUNCH_SIZE_FACTOR - 1;
+	}
+
+	atomic_store_explicit(&ctl.stop, 1, memory_order_release);
+
+	for (i = 0; i < NUM_READER_THREADS; i++)
+		pthread_join(threads[i], NULL);
+
+	reader_failures = atomic_load_explicit(&ctl.reader_failures,
+					       memory_order_acquire);
+	reader_verified = atomic_load_explicit(&ctl.reader_verified,
+					       memory_order_acquire);
+	if (reader_failures)
+		ksft_print_msg("Child: %zu pages verified, %zu failures\n",
+			       reader_verified, reader_failures);
+
+	munmap(mmap_base, FILE_SIZE);
+
+	return reader_failures;
+}
+
+static void thp_cleanup_handler(int signum)
+{
+	thp_restore_settings();
+	/*
+	 * Restore default handler and re-raise the signal to exit.
+	 * This is to ensure the test process exits with the correct
+	 * status code corresponding to the signal.
+	 */
+	signal(signum, SIG_DFL);
+	raise(signum);
+}
+
+static void thp_settings_cleanup(void)
+{
+	thp_restore_settings();
+}
+
+int main(void)
+{
+	struct thp_settings current_settings;
+	bool failed = false;
+	size_t failures;
+	size_t iter;
+
+	ksft_print_header();
+
+	if (!thp_is_enabled())
+		ksft_exit_skip("Transparent Hugepages not available\n");
+
+	if (geteuid() != 0)
+		ksft_exit_skip("Please run the test as root\n");
+
+	thp_save_settings();
+	/* make sure thp settings are restored */
+	if (atexit(thp_settings_cleanup) != 0)
+		ksft_exit_fail_msg("atexit failed\n");
+
+	signal(SIGINT, thp_cleanup_handler);
+	signal(SIGTERM, thp_cleanup_handler);
+
+	thp_read_settings(&current_settings);
+	current_settings.shmem_enabled = SHMEM_ADVISE;
+	thp_write_settings(&current_settings);
+
+	ksft_set_plan(1);
+
+	page_size = getpagesize();
+	pmd_pagesize = read_pmd_pagesize();
+
+	ksft_print_msg("folio split race test\n");
+	ksft_print_msg("===================================================\n");
+	ksft_print_msg("Shmem size:       %" PRIu64 " MiB\n", FILE_SIZE / 1024 / 1024);
+	ksft_print_msg("Total pages:     %" PRIu64 "\n", TOTAL_PAGES);
+	ksft_print_msg("Child readers:   %d\n", NUM_READER_THREADS);
+	ksft_print_msg("Punching every %dth to %dth page\n", PUNCH_INTERVAL,
+		       PUNCH_INTERVAL + PUNCH_SIZE_FACTOR);
+	ksft_print_msg("Iterations:      %d\n", NUM_ITERATIONS);
+
+	for (iter = 1; iter <= NUM_ITERATIONS; iter++) {
+		failures = run_iteration();
+		if (failures > 0) {
+			failed = true;
+			ksft_print_msg(
+				"FAILED on iteration %zu: %zu pages corrupted by MADV_REMOVE!\n",
+				iter, failures);
+			break;
+		}
+	}
+
+	if (failed) {
+		ksft_test_result_fail("Test failed\n");
+		ksft_exit_fail();
+	} else {
+		ksft_test_result_pass("All %d iterations passed\n",
+				      NUM_ITERATIONS);
+		ksft_exit_pass();
+	}
+
+	return 0;
+}
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 606558cc3b098..530980fdf3227 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -553,6 +553,8 @@ if [ -n "${MOUNTED_XFS}" ]; then
     rm -f ${XFS_IMG}
 fi
 
+CATEGORY="thp" run_test ./folio_split_race_test
+
 CATEGORY="migration" run_test ./migration
 
 CATEGORY="mkdirty" run_test ./mkdirty
-- 
2.51.0


