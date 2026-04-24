Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 259B6FDEE5F
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 02:52:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CBB96B0092; Thu, 23 Apr 2026 22:52:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A4696B0093; Thu, 23 Apr 2026 22:52:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 792186B0095; Thu, 23 Apr 2026 22:52:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 65B0D6B0092
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 22:52:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1E70EC281C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:52:32 +0000 (UTC)
X-FDA: 84691926144.16.A5B3097
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012016.outbound.protection.outlook.com [40.93.195.16])
	by imf21.hostedemail.com (Postfix) with ESMTP id 414BE1C0010
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:52:29 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GTlTN81a;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.16 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776999149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JFntIgk9uj3iXP7kiSDYhEA9wFOSYyCiLjWj2zSH/JA=;
	b=zKGPzltq0ve+hO6o1vs/eXqlvb/8lKS2T7rhR8yM5nW3yFKh7o/mRzd1UarnrH0QfVJRA3
	vqlf3fCe0KJIsFlbV7jch9m+sd0tCAm9Y9o2tUOKN6RsVJbTJ+RidDddwa68MlTLQk1vu6
	MSTGRP8fIvJ04/JnSE+WiqZKWumKT5I=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GTlTN81a;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.16 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776999149; a=rsa-sha256;
	cv=pass;
	b=U+miw7U0pGR1D227CdlgZweitySP/hNbzXjZRuij5hU9YI/cOa16CLJ3HSUiu0adyYTNb3
	wgxE007Uppbjzl5dFJNmwubotbTHz0o75ZDdWwZsow0uSGuFEYzBqkbnu5JbbzyuzpCe+x
	URrnB/+HrdtdQbt2Z3UhGXO9uvDGn1k=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e4+bqIa/G+fXf6y/nhZKvsJIorbA/l1Hi8/0QA9p7e1EJsC3ZZ5K4yzD+iTp7/9P+z4ju5Cxqoe9M287Yv2R2dpXDrYIMlJC+jIqdyCv2XIBenZopA+yfvDtuQCzk7QMVqLwBfoftG0U0vEsN6zaTu9uoEWZzT2SGssC6bNi7GPvlxnNPro0nq1ub9/pvozIax0SJ03CB7ApFW+EL/3PykPeqjpBMOVgTcSevPoTV4NTuf+KXo6fBrY9dib9+VxnrFEh68pO6QUOems+CIytdouvf+S3yHp9AQDBSI2ktArDfL2omHUc9UW09B6LE9Tw3BUGlV4dnXHq5G9wLs0dPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JFntIgk9uj3iXP7kiSDYhEA9wFOSYyCiLjWj2zSH/JA=;
 b=s5xYDdoKEKY7WpVazswcJs6DR7myQ1hjC7A/Q2QTQGk07RH0RKSbvigxl+t/Va4L2PmPJfcA3Z408YUm7HyMbJXYXldAjw7rfrUyZwph5R7cC5NpcXUPHLmiNBnHUXM2Lj3p9ZPrrK+1WdwPwgAEd1ohUU1OPPWTNNdybXycW/aPtUPjSjzxM1Nk1uj/BMfmTqvXbzRypG6uWSJibMWeUrMIQQBTT4TLsxictND0+oMOvqq8+Gf1UOoolEt+D8cw12Y1f4XnZ2rf73ENdBGcMss6+6GBeBbGIwskPoGi7IGOMte8vOQM2YNXK2VI74LVH2adCAQTxaz/B9MEX9eSPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JFntIgk9uj3iXP7kiSDYhEA9wFOSYyCiLjWj2zSH/JA=;
 b=GTlTN81a99Bn5xxqmE4jkJVMyIayLO65hApgcO4miCsfgbvX2aa6MPFD/SPJ5CErKG1zhfn5QZWU0vvPq9FRzyqLDR1q8yTXfYOHsOzwN/++g1tr911cuH+b58e2DWjy3kUBur/gJAkLQoZko5z7S8rsWHSFLXw1gmnWnF/BIXCxs2Vj4Z7qDNjOFFQiV9Uj4swroQDJUTa7gbwm84JRccv/UqEgAbbAP0htK6sKm1fWORLpqoT3j8L8fSlV67JcIfgXwfAQ+2/Q8wCKAdX/sQxYjJhaN1SiPYf3l7Eg4kNVLkuM1ixTRVIZBM8qAV5662l2Get0WFupbnJ0J0lA/g==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS4PR12MB9588.namprd12.prod.outlook.com (2603:10b6:8:282::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.16; Fri, 24 Apr 2026 02:52:13 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9846.021; Fri, 24 Apr 2026
 02:52:13 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 7.2 v4 03/12] mm/huge_memory: remove READ_ONLY_THP_FOR_FS from file_thp_enabled()
Date: Thu, 23 Apr 2026 22:49:06 -0400
Message-ID: <20260424024915.28758-4-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260424024915.28758-1-ziy@nvidia.com>
References: <20260424024915.28758-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: IA1P220CA0022.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:464::11) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS4PR12MB9588:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d0ea972-8211-49e4-47fb-08dea1ac7cb7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Sm6GOF1wNHGh7ef+6rtIywDrqJ4ly/+X3Sw+hJgG00D3e2YNFhLdhMD6i4c9AuExGwMtHVgsntgHe8s5PN5dcSdbijbmvw4a9wG2xQq19fqC7N4zRKbhOrvJmdN/FQJ4qNeWt8BUttUOfj9VTV3YT07me9w5GsLuIjyx+iXPpz/9cjOdkVTwjplKuNh3T5SR2eECgaKaHrYCoob0Y/sjuijbpVo4V6A2+9W5XRxBoULmb3EF7VbtOWhW9BTZVr+WH2msBeYg34q0P8mjck2NqS0uqU3vWvcpj5HqxltOpdtBBg19NTGB2MwXUTWlKHVjlZCBYQ6T7SuOKSbLnp9CD3FWW3ZiqgH5T6vc5XaTaK7XoICVgTTVL1BdBDLJuK0wcIJxv78rNOLLRW0CPqBRwvg6OdS/lslRuTla23H7LI4SN/uE/YfioPw1DrqOxGAD2MNJFTNFacaPyRgh7o5h6ha/cfwm0jKIE+WOCfRp50m/GqqvcXS4HZAavVCc8CiKEsVw9Hz3n/om3R/LoJpd9v9oGhwPlAnO29lcYxDQDbe0k4hCZ0msMvpozYviL6adPYIgvaUsNTdqskJM4xA/t6/PfMXmykxt6vvGLxarZ/V35lnmyL2NB5O9208jt1Q6bYRkay1Z5ztxx2HwVwGUnTo8HGRa6KwI74TxFyoyNJhLuGb7ODhRGR5p0AuFDFBuOj8hqCX3LYo2+m2BuUSQC4gXPY11rkk83gM1fwTSd/0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?a/FnK/EQtyn185dJjsW4yAbwZ/CXrjuQSXJx0M+qWRFuuRwdTuZ1Vdb7lkwJ?=
 =?us-ascii?Q?CmHF8DAbnxIRviK/xZNx23lwRlxobxfUr4bzrEJxs2QVO1+YrguCA8c2KZB7?=
 =?us-ascii?Q?OFrD+paHnaTWg21N2bSBLWAhPHOtv7FRZFoUJp17GkjOAa4XL0mAIb5Tw9m8?=
 =?us-ascii?Q?PC2JMARFVEaAnWDcpkD6bReG6UA7ScSB71rZk2O5apyKCy5gwtOvfJIueePy?=
 =?us-ascii?Q?LaepQ9aYecOrVxEx3+hzWO34TYllQcTz5tbcbPGRGLjjg9Jf51W08o05IYso?=
 =?us-ascii?Q?Tfn0pNicfpFvZt6qyj64jCS2UodtVkmy8SZAy1S7l+3GShbxrHTT7On+/2/s?=
 =?us-ascii?Q?77BeY0pUB9IkwrS0XZ3AHlTXCvumIPJOpkwfQ2HF31DXWfDTdDa+8AKgQ4hK?=
 =?us-ascii?Q?rr4q6uyZc66kh/oTjkoGr/R09/W49FdvHIVAjFRYiMaVw0q3O1B0Dz0NQZ5F?=
 =?us-ascii?Q?AEyimTJ++sopteXtnFlrCYtliQ2Hm365taRoAxOQIiyomaM7wdSvczMgkSbM?=
 =?us-ascii?Q?V4711l8YU0WdOkN8W3tK9+UunE7Ip3BJCYJbtf6EPx0PEifykWetlggFVYv/?=
 =?us-ascii?Q?ErhZIY6yGfMOMQ+C5q8OvjhowjOpvvN+uVPeDOvK4+OMyjVRoDxAzfXLPGTW?=
 =?us-ascii?Q?gov11O1sSR+PvdzOsn9SkevQlCmPzxdGo1XOzMU546nxjc7iVtmSfpQWR0ot?=
 =?us-ascii?Q?fq6sOzbS/6JIkRDJ9zVrEusyLR24m6Mi5oey1ckLAy5YVYzUA4aVF+sJidqB?=
 =?us-ascii?Q?YAdQt8ovPdEB0hDxy16okX+i/13YKgA+gzz9Ax4/Epf+g5if6eubNB7UPd9p?=
 =?us-ascii?Q?9qHIRIks1Fp6QAqDWbRnxgHbQK+o5lj7DzfEmS2p9gOQ5Qq61ynBAjvTfcCU?=
 =?us-ascii?Q?h9WK81W0ueMiDY34VXlgkvh5hwcrwZYgELqx6PMD7gOTjgTOB2Lc2aYpy+HW?=
 =?us-ascii?Q?Fv6RZpNcxS3pbVazPdaMWw+u5gFp+QI2m7UIsktMhQOdh/hqwdeZjEQ+TAU7?=
 =?us-ascii?Q?knRKdVAtktDQz0/JgOLA2iIW95bpBYnuvRxvOUZa0W5M5GT4Rjo94A+wIIWp?=
 =?us-ascii?Q?vHf5LqQadZwfKzxjdpATd94pR+/Iz1d7mCAJS0aQ353kwoJQw8HzrMtca4i8?=
 =?us-ascii?Q?fVMJk4WlkaTa9wYsv8Es63BA7CGCOX6tJurYWNpejkksGAuolV56ac7Sl7U6?=
 =?us-ascii?Q?b/OrB6ZbjV11Q4RfGNfOckfdgGz/7DNthOG+cmpoYR8b6SRezykVEfj0xUXv?=
 =?us-ascii?Q?fGXLUucCalNzr+ac7KVLGUNYUs9WxjzCKUZeAooSTbBrfiBPjWcg7J4VrZ+c?=
 =?us-ascii?Q?wTlycEqaC6sVRP8e7TqPHxN9ToLKpYSOe3EeL8LRHjHICpCKPcTQd4gk8rIj?=
 =?us-ascii?Q?ssGB8IhCumULgt17YaR8WjXiyb0MssaF9GEN1WvSEitm/teLap++7MtRfzb3?=
 =?us-ascii?Q?g3Tagirj0x+V4/7DE0/OLyw4nry+YCNwiJ3rjbmKtYywwajV8/8QqiuJM2Cl?=
 =?us-ascii?Q?0dUGlQqFUACriFFNw+S4Osx9HnB1C2DvqfoxYl7NGxpT5TZmMl+yeAFL7Q9Y?=
 =?us-ascii?Q?tWaUPCffEeifNMQzqC268fO+kBqJAIa/BjUtI2zPq4G+AwdVxpwOdOmlxLkO?=
 =?us-ascii?Q?3J8UWU/f8cpvzkUoN0BYFwSQWdRUDMcQUZvLDXcQB+WzNp8mStRl4uOWwn4S?=
 =?us-ascii?Q?vmPnxDmxEtEqY8I61nQ8FDX+pVhUn0t75gdbcAFSSWRlPhAu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d0ea972-8211-49e4-47fb-08dea1ac7cb7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2026 02:52:13.2806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mCZgH5JhZWO4Wd6lySJD1dsnT+HFipnblSWG9Ovcp3pJ/HhJ9sxDaoY+bMLhioZq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9588
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 414BE1C0010
X-Stat-Signature: qwbqgpht4yn8cx4xwmt43ewncr99fci3
X-Rspam-User: 
X-HE-Tag: 1776999149-784554
X-HE-Meta: U2FsdGVkX1/YFYtmgLSmAPrYjPdQJUm3fhXkayMWbCCYqJyLaP2YA5GwZXYZjXtpYQx5Gb93TdlrsXHifjV17+St9DVKjOY9qXD4PnEGAXqnJqz8NUTXl7iXVPlytZEyTavS+p7/DcK9iHTyips8A8UWAT3IUK+inqFhRijgzzzYUjw5+8tgOaxOKtJFvOoUWkl4iPYlY/vxtJQgMFkkmfJTFqBag1QEZb2mzXhJTbSsr09R1NjtCsrGkEj6y19GajcaW6zwJ1NRX6ifYHRN+bub1nUBZvUW9rntbBnSQ+5UQz/n562xf+4oX4JdhglaUMI5Ucc/Ex68I0wemgA6+seQfAfgoOnrCBkKblEp3NL0+lxd4Druo1oLsxvycDyjQBqkbjT16UoMay4i0pwoUrkTd6MZ1R/Gx9udAjHBRk9HgH6ThV2MrvK10TJCFi9/fNyMJ8IDeljQrNEMWemEHEP832sMs32QuCD/b2IRON3PdA4yUGpVYq3IAQKyz4/XCY/liuKVUGDTH0Ive+UzgkBj+SNHjGGG7Yg4yX3ySjpF2relros1NjxFJpgCA7h9x85L9fudHQ95ot+Oy1NTTqRDDUIWQEnXtA4Nzkk7qLAy+g//AtV8MTWujTRl3GoqMxJu4yhf6dR4oUZWO6S1belAw5GC9c02fzZxGm85R9t3QFYUNqFgXMLGVuZj3layWcLWsqOm0iu6vUrGpZphzECoYmgHRBqpMmXZrjzZDGsAVBuhQ4tuuvKpCpEMui9jXm1aUtkomQP2o1xxi2IdXp+0ND17xC5oR4U4R7FvucLYfkGRPUy3gg4Hi2zO3e6EC1CGCzkAzvZQm5xoEQhwPKaMARPE8KHkuApbbrJNc/30sk+driR7sFYPQYQJfB36mgAtzvlAnfzYi2IsTEndPhHKvxG84mnIH3wxKeb0/eLyz7Hq10gdMmu2dufqMCBBkSDABS1YUCfod8j5Aqa
 5MNLkh/F
 umtIZhrEdHiDlehwgIqUTEjAGnhCYhErKrONiDwofa4meh0PoT53Dn0B6HuqeKUO9v5lhxtxujzxATsBffkP2yRIlJNHMydW+Gn1AR6SngoTV+IvieTr7VOj0uXMbIJ11fMuNIu5g5f2g7VcEH99ZZBR3CasKUrAkB/fEFB7bh6i/R4ZiTje9AbmPjSnNHiizi4YnvAADo1agGjKw+T62UV260aIXEUycXbDNivyokt6lNsjBx9CFuNYl3hV+z1cNSZU1o/lbp4sNmfnCFNYbgorT0/fsmZ0yr/ocUG2rMp6t8U0UpwYotFgf4/PJV1hyH/XksIPq5iTPs57FVvktMHLoyTzUX2BaneExfi1AqCrQgmLCqteMXNnjOEfw415eXk2OIo08SRE1d+20kkrci9HFruuMdebVyyUBvNcXl4IXt35MDu5Hcd88L/UPUIt+FHa+aSATItd5jisHVd+ywoFXbGmejXWLWk1vLNLV/bowX94=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace it with a check on the max folio order of the file's address space
mapping, making sure PMD THP is supported. Also remove the read-only fd
check, since collapse_file() now makes sure all to-be-collapsed folios are
clean and the created PMD file THP can be handled by FSes properly.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/huge_memory.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1f0d0b780943..f0db1390a18f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -86,9 +86,6 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
 {
 	struct inode *inode;
 
-	if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
-		return false;
-
 	if (!vma->vm_file)
 		return false;
 
@@ -97,7 +94,10 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
 	if (IS_ANON_FILE(inode))
 		return false;
 
-	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
+	if (!mapping_pmd_thp_support(inode->i_mapping))
+		return false;
+
+	return S_ISREG(inode->i_mode);
 }
 
 /* If returns true, we are unable to access the VMA's folios. */
-- 
2.43.0


