Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7A8BFF885C
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 12:00:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D5976B0005; Sat, 25 Apr 2026 08:00:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ADD16B008A; Sat, 25 Apr 2026 08:00:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09CA06B008C; Sat, 25 Apr 2026 08:00:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ECE666B0005
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 08:00:55 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ED99BC18FE
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 12:00:53 +0000 (UTC)
X-FDA: 84696936786.10.817F413
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011029.outbound.protection.outlook.com [52.101.52.29])
	by imf16.hostedemail.com (Postfix) with ESMTP id 767D5180006
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 12:00:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cG04i6H6;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777118450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fHtdjaGcbUjrQWaR2bse8uIiTCMPzar0l7abrB5l0EM=;
	b=y0Cg9O48UBban2uEtXSRYzy+Be1cVMnHruMvR13dp0HXMepcAFnb9i7uXaEf/xCbcxXQAU
	4oMXsdhDk8ag5lGXUZhcjdXj8r8cE3yWP1edrXtRPixs/AhNotn1SdXXVoyXOFUovlU54c
	RQqdHnwH9gEizHdNTkkc98F4wzri6U0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777118450; a=rsa-sha256;
	cv=pass;
	b=X38SIXziACZKjf0INK6RsGktu4rEBzlwuKfiBwxWumdntdwvfulKkkXUcwR9ydGD5HppNi
	58h6MMqnFcVWWGKzStGg/yrOT5GbIhUsurlWwSrXTZKnuHSgnK7D1lkegrdBJguO3XxUdI
	nf9aaFGudOB1qqIkr8W/2N0HdW1Rz/I=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cG04i6H6;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ihNgSU4d5RkozeIubLGYAeijB1N5ZAR0ZfVCJVaNiOLBO2luuGNvFj4s0pJ9MGCX0QJ4qKAch4vybnM+JxzHTjRd9oPwXCH+Rmt2pqew7iTHmJnc/6NUJ6kJqMvsQyUc/LUOy5WGqBobHeJSndlWkO2Foclu13YvmdDN6D8Z2Tc8JBrBXCTGnnVWlnBP6UIz8aMsYGETUa+lyX1AX7V0XbgHAhe8i7ph2JGs8i+QkxEwpfLufx1S45Y504eaCXMPeDVr29HP6jU0LaLtaqt0ecpkkaqLqFQ91NcEdfMb0m75EB4SfYOUDgZ1IpwJ8hxmMwVYRxWxquyFr2w3+rxm+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fHtdjaGcbUjrQWaR2bse8uIiTCMPzar0l7abrB5l0EM=;
 b=RmnO5OOn38oGjDbtUwBNuZnEv7lJntWYEa1I67aWnXL0tr26BE5XLvzp3uBEw+mp8Sto90xaTpgqxRFbFuKF7YXpsFUxBsVcVCk9I8gDuRmIhfrq3tWqrKEbco7bopSynQi1Dyde5yJTVyzBqDIscJwMXOq8kfCu1uwTQX+pQA0vRqdnXxwYbVR+IF1vmN5wk39N1+ecHjtxPI/Lxacr4UmC1hoXtY5I4PZUuLDV/HQI9H3NRM3v4mf4otVnQtwY0KDHiGX9pe0kgXL7Qx+aLiflS9yuQ4ueXPDk1nhrsDbxgIZ0Tlq3NV5TMhZZYwsJmxikQacQx8muOIiMnp2VhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fHtdjaGcbUjrQWaR2bse8uIiTCMPzar0l7abrB5l0EM=;
 b=cG04i6H6p+KQZaWgSORm/HrJloWz2Xy5OpwuPoNvyxBUSV0T4cywCnaN/fCChjzIBBFY/GtG4dZsEoNPKSTSca2zZXS+cwXcb2/kuvCK68zak53cqApI/H/IGZNnQLQ8nApZPk6TXs9ak8IMnfhyft38YROMuehaGjJVJs+bcrn6dO+OzijLi6L9seNyBTTvp/CRQnLd/4bqNB/dg9xOFkKyUcByOoUepa9JBBqDRRE6FKH/uNI6DfQ4KG9YwdAvbcGufZ007tyvYRT5kMOiX7TYuNkVrS7lR9hvSKEemhwa8eU2xDS4QsQYMRXc5vERPgxLmsRsirhvvq3l1JC+dQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA0PR12MB8376.namprd12.prod.outlook.com (2603:10b6:208:40b::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9870.12; Sat, 25 Apr 2026 12:00:45 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9846.021; Sat, 25 Apr 2026
 12:00:44 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v3 03/12] mm/huge_memory: remove READ_ONLY_THP_FOR_FS
 from file_thp_enabled()
Date: Sat, 25 Apr 2026 08:00:41 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <74D4C50B-CB20-45B3-8E7E-E9A499701F61@nvidia.com>
In-Reply-To: <20260418024429.4055056-4-ziy@nvidia.com>
References: <20260418024429.4055056-1-ziy@nvidia.com>
 <20260418024429.4055056-4-ziy@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: YQBP288CA0037.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9d::14) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA0PR12MB8376:EE_
X-MS-Office365-Filtering-Correlation-Id: 479d07ff-e8ed-4640-1400-08dea2c247e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ze090QUzkOXdc7WgHm4XPX8N9pz7/I8f+Z/4SXZkAUee7vuiYeo8janGCH/z1a2N0IGBb5CC0u9CSG+Wrvl8kzRepCvH7W1x0AIRAtIiaeg4rcAW00lhwHNIyBLMaIj34XE7rXDfd5qpT5ds+iBDegRfYAnfjxiXlZeWhYaysZTNCUU82rvnHNii4K98kTRBB18M0bQgp3Ws4kSR6ZcehE4SiOjPHPL91hovFRb+Q/w55BGaqNFQwc+rwIoBZ6/xvJzgstiAWnxn8UQOBTkvALOi99Dv7DyWoG1StJScew1KoCdra0G40s7gojVjDw3exLwJrFf8xmwVbHA/w68LzAm6GAzz57SfQ2ds8oCN/8mz73KX/vPP6bVf/xxu0WvZ/UmkvwyLzNnPXSsGaQEoMvwKSqWJHfiQ2Z6jHe6BqsSfKMoy27VUTOvjww9ogY0k1BYLAHMz7rGE++L0NAAbDXpFNXmv/qdf2WFKCSa3FjmyGn3vXWpED9yuFutvzZjDv2qfUomG/cQ24DerVAr/XA2oEO0lxM7thWE8mihZIS0bJW4jEX482Sdmt59FDqmNF4lFQ8KJ/8E18Pg2XfYY1bdIqTCcTN593YP14jtrGXPC7yaY3HaGyxgM8gZqD8HuYHVndnT64fqVEIxY/yuw466mWHcjuSqunXYgoUoB+SVUtc9kW7YZcM/x0cRzdll2yoCpgWNIDaYvyJVmzYQiPXxEONZphzx3AIrvPFg5WF0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eQE7NXC5M/d6SkFus6k7pOzf+zitPSSaYT97ssa0WmzOynMtPKVjATLXcbFT?=
 =?us-ascii?Q?Uu2FEvIOIULiibxvxJy2GIqp0o8XwYC6ppT7UAS01DnBD7RN2iFkwvYB2gXU?=
 =?us-ascii?Q?n05siePvPeHurAJ3f4nXwiPF8+X47B09/PSh8ubhSru3ydH4ETaBXoY2kr5Y?=
 =?us-ascii?Q?wbX58DRdtH8D6u5MW4cYemJ688bxjIYFQR9PDnJD9TGqR0JfOInFcB6Wep5j?=
 =?us-ascii?Q?P5NMDCN7Q+u1z6F2MtOMIVokRWoHpKEIPY6wvXb1GP9vw81pVahsIU5zp6fx?=
 =?us-ascii?Q?V4FgHU3h1l2eqJN8yEMnXfoCPUNLT5ep+buzPNLQuU/nR3M4KRWl+bPwUX+p?=
 =?us-ascii?Q?6K3iXTQlaZEGfgGwEeGrI/IPPoKFW/hK7YtpA+zTutDQnh45wBcqRKYngPI2?=
 =?us-ascii?Q?j+6KMHa7o4QxKGiwMWArizxUcJTg1qrAYKR+sWiV8/qgX9XhnRS6ObrIl/Gk?=
 =?us-ascii?Q?vfnFtXEYVhXxrR0KQxgvvkGFYB9LLx3XE7ndswTvnAtEsGgZP2oru/BPaXG/?=
 =?us-ascii?Q?AaEugGzvK9wtATl+00LbOs7Oh0D/yNICuKbOsKuoauHmq6TyA48kVlCuKJgW?=
 =?us-ascii?Q?vCmJ8lFa8iCU52duZUUF8J0/spWzlrEAYB74ZmKDMF6A2TOLM9QzZ6PlJyTa?=
 =?us-ascii?Q?r30kVHYRBTlyiPKEFndzaXZrWidKsrFqGntlIMA7TnIx715wDRJh2iKYsoCO?=
 =?us-ascii?Q?/esGHOQLdSTpSBmmQw6cYMnWjCzaoCDEQi8dcUGf21p9lQzLz+c87D8UvaH8?=
 =?us-ascii?Q?SqqXmxbVWRdKcU9GQZWIwWDhAZSkCf+y1ssvzXRoUSBC8m6Sq75gQb1WWjsm?=
 =?us-ascii?Q?QZCqnOgTXsQw2FE9sIcdKEMct1uEZMWukarNpSPm/u8VzghXlad/s4n89Qkl?=
 =?us-ascii?Q?RC1cqF3rsJBBdAbmQ56iKzgrW1P39bhJw0GnmPh7y83EFEHNhYZ6h+A91Byj?=
 =?us-ascii?Q?gdr7T5entrO6rJDPz+g+P7TThh7FtbrOh9qG7Kr8JzbtxCzOFBZ4tUebs0Oe?=
 =?us-ascii?Q?xv+2iM5JzzXI1sCn6HpJHzPf0mGV1+SVKWIGOoQghA/ezTcsEFWfezdAEo/v?=
 =?us-ascii?Q?sd6UKWdR5N8FjqjNKUJ512Pq78LERIt39qj05HWydij7iyisq4lTXxNYDrya?=
 =?us-ascii?Q?Xc3ySJJTx04evijrAkvuN8cW9y+OzQS+mr4iYd7HFUfwDOxnjHv3Up+UMCu4?=
 =?us-ascii?Q?5jNhs2nof6Aoy3uMw7TvtMqefYKv6WXAAkeKfusmZ9IO/phIGgU7QgF6Iz8k?=
 =?us-ascii?Q?nP6QXt7sgshqoCwvuvQpQd5kzZI5OIwR6lD/ceJ4ipjJcq0EsC5ac9Q8p/Aq?=
 =?us-ascii?Q?UaPSCQdL8k9LdljbDCTSQd49/yPuXYDGxW+sYg+XNKkX37COdyk7FVivLSEb?=
 =?us-ascii?Q?besdKumxumIIVN6JKz6g3/521YgrYDEQ4uezwiXOx43QFIVu4y/40RycDRhS?=
 =?us-ascii?Q?0ofg9ujxWoFH9KDAumBztQJ17yP/2Dz1o61hNHEn9vGRURIfk48g9lYF7dYN?=
 =?us-ascii?Q?b5otJNSwiy60q62l83s0D66s+lBLHVKwr0aZRKWi2C0I9AW9WZHRAbTLDElJ?=
 =?us-ascii?Q?DLPxLzUDgJEpFRjoU902II5PmLpp9qkuUCDUIECcWG+iJTKyHw3Kna3KJy7d?=
 =?us-ascii?Q?bl1tem8km8o8Gf+Znpr7yFXXTzpFZt3XOEP9YGbtrmkEiazam5ufB5E0TPJW?=
 =?us-ascii?Q?shp1Vl/xvnvFrC5bDGADs7CILMtyZxO2fScG43BFIElnuPzN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 479d07ff-e8ed-4640-1400-08dea2c247e2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2026 12:00:44.8332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DxjH/k6dtRZPNhiQyHCblIHpahliPXtj7an7Kyf8ozBvDOk8t+wMjeYj8rQRIK3Z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8376
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 767D5180006
X-Stat-Signature: 653o8sd74aqmywcw5nwku4q6a1n6d5sk
X-Rspam-User: 
X-HE-Tag: 1777118450-177246
X-HE-Meta: U2FsdGVkX1/1G+E7FKZRZb321CaxEpvzk2qaoJw/ADxlDe4JZ10baQ1bxZnv8ELxQhQRK6uueoi+Qd0MB8Hv0YUszNd0m6/kf8R0rktj1YZm2TmvzBzdPpPB4piF9IzudBKUgvDqlhsMVoQPVzMoCCPTid5CPs0bl02ypM517jBmTpQGPBMV+8QrdBjQCNalw2/z6xJfGQMp2L2R57YT2JkHhdRa6MDpUgvNBCmfkDu5RBfiZ1TjckFASMoLdl+IaOdr56xG4u6dpcHe3LF1Sc49/zAdrrAgs7mTlFA5W/kbVrY+bzyX7pt/kzmFXcfFt5hKuS0qKKKyPmaj3g3xRzuPhXEQfD8ie8Z3ipWarj/rTY1f5NVr3fsCFalUuD0aekK1Y/XvjQ+KAut9tpsgl6LKbCQLO7eOAIj8BGis1G7p4Ig1Kl8T8BQ9fP0KKaXMpPrI6anyLcoLhB49jmcTV4obRzjMFpcXB9cvrXmWub4EYOb6OKGIZlrrWWbMhDEEq/OMZliuC2+JxXQkMpRFLgXjUYx3nQ2hK2Pcv1WCYIB1Bpp7EWt64ibnvzsvMDWqleSb1jTccApWmE8ipwxLWPl9fL3PSArY3SQ8kONmjX04U7r6Bx8NMQO/3ZxYDYUG+zye4+CxZo+aGjRLW7emDSJNez+MmNLvEAe1wQAvTe6Z2O3JcvzVn8OOz6f/Mz3u+QS8Xz34meBBlB/qdV+Fx3JsmI2EWwan1bu6Tl8nuyj0dqy7t/veq0P6Pk3gBLd+h2t0olEzRUrvSwpwUfmv1l7biObqsa4PIRYucEAYQZLmvRv04y7LE4L8FcQuQAHUIOZZO4X/iFAIJ4v/S42Cj+Uyebie7KdSh5FJRfDASIGSZweg51ugnc6JMCNG16iq2QpjgMNmVC6d3yjtoYMWKjy3LR6Glc6KjX2oM4g2for6GYsuSX6PkW6MM4q6qxooqOHND+fkwW3vyNfba2W
 DL7YKppH
 ipPCR7YEnsq92IagF5/5SX4rcKw0cLe6ag1e2IAjnbPT4lRPwairI2z8tUurmMBoA7xL9NDc6ZsRyze5DD2aE8JgnbUkkEhy0DFYEp959XdAI8Ah6J7a/pVaylYhzgCKRcS1C48Z1Nk5HFF7aGe/gDhUzyYDRjc14CXWAz3z6DvKB690DHPjpwZscJY7BF1Km+1YgE3WIbAiSpPk2Jo8Yo7yBpWmMu1P6tFkFLd3q9tLBvSOO3+eL/Ht7CIEOxSC9yZbv8by2LGeQ9cj+x1qoxqpj+4XDPCmqYoqqrWcLN319gXAY64CGDU8ecKyqEPOcdEhn5iCz61j+Ew5tNpV1tiweF+Ez7ZlXudcYMxmoJHyNFek=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17 Apr 2026, at 22:44, Zi Yan wrote:

> Replace it with a check on the max folio order of the file's address space
> mapping, making sure PMD THP is supported. Also remove the read-only fd
> check, since collapse_file() now makes sure all to-be-collapsed folios are
> clean and the created PMD file THP can be handled by FSes properly.
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  mm/huge_memory.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 970e077019b7..7e9cf8c0985f 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -86,9 +86,6 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>  {
>  	struct inode *inode;
>
> -	if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
> -		return false;
> -
>  	if (!vma->vm_file)
>  		return false;
>
> @@ -97,7 +94,10 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>  	if (IS_ANON_FILE(inode))
>  		return false;
>
> -	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);

Hi Matthew, David, and Lorenzo,

After some discussions on irc, I feel that we probably should not allow
read-write fd for PMD THP collapse at the moment. Combining with the
filemap_flush() under folio_dirty() check from collapse_file(), khugepaged
would become a kwritebackd that scans pagecache folios and writes them back.
If we limit it to read-only fds, at least khugepaged would only write
back once for the pagecache folios from these fds.

I am planning to restore inode_is_open_for_write() check in the next version.
Let me know your thoughts.

> +	if (!mapping_pmd_thp_support(inode->i_mapping))
> +		return false;
> +
> +	return S_ISREG(inode->i_mode);
>  }
>
>  /* If returns true, we are unable to access the VMA's folios. */
> -- 
> 2.43.0


--
Best Regards,
Yan, Zi

