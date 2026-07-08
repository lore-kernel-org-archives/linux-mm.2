Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4169C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 01:34:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB38C6B00A4; Tue,  7 Jul 2026 21:34:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8AE96B00A5; Tue,  7 Jul 2026 21:34:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A1FA6B00A6; Tue,  7 Jul 2026 21:34:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B2336B00A4
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:34:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E59161690D1
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:34:40 +0000 (UTC)
X-FDA: 84963889920.03.792E8DB
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012047.outbound.protection.outlook.com [52.101.53.47])
	by imf16.hostedemail.com (Postfix) with ESMTP id 23164180003
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:34:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="gLDO/ANN";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.53.47 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783474478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wjLU/OkaLnGWVBswFlt/V3uJgZrEXHhhZPQbZfmMbu0=;
	b=Isr6JXRqvVXkr6m91iKBkmbCHtY7u7d8kthNbtZqDVpoaJbwAVZLW20HXM3r7H8k2lksiI
	7MUFRpv7fOqjiqy0MxFPt3iiXnlifMlQYa75CiBHHpp8mVnFW3HvQepTNdKOSyxgYv/qtS
	Kgmpn8Q22a8xXw72Iwf2rOAOk65VgNM=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="gLDO/ANN";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.53.47 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783474478;
	b=mbEKWgB2nO+5LGKrC9fV6aJej9Iln5dE0MX02YjSUABLwnkOGCg8dHiN/tbtWcXjFpkaNZ
	8L9aeug4641YJ6SHr4nal8zgofguvmJrE/aIdR7EkvSl3wXy+m7WsPA+lyKcFL6zWp4KsP
	1vDbK/XEBCO8RVqDRbYKjIXTB/jxjos=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I19rD2TNEg0H+izrl1F74OPx6wfTp798024DVYmXpH4QCi4tgvspqqVVNKYw5m7ZyKNla+XumLRHaTDYYtv9zGt8EurWTKvlzAbtXrD26Pg7Jcb6zquijDlHlxTSr0XVBh7L66QbeAT4K2t4oQ4YqjitxephRteGHT8un6aWrN251eXzQ06oDu7HkTRF2jScAaKSxh3Dgzg4fYf5W6F6RrplkG8X0aTzHrPOk97j+WHIlnReWytnIis0iuoUsXp5l/Ng7wD9FZwMNkfcNvToBYX8Z2yFpFwpZa7wtoYGyA5jkMXKhb1FSRp1T5vFEtZfY6L7CWjqabEz5JG3cRoE2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wjLU/OkaLnGWVBswFlt/V3uJgZrEXHhhZPQbZfmMbu0=;
 b=dSQi6XaGmPGF8hC5QoYf9L1sqrC5712rU942NtZYkwpSO9zFRQ7CmyBV/qyTMkCX03+uYyfTOLOtMohwLO4tS0YKbDg2SqERsyCsIl32qr0TByWxNfAg/b05k3B8jxJtjSWhzlxjCNeE3nllUnsiYsE7GeomQtWzsTQhi2J+4HhmhnZO1sDFvGZ3v49hZSNej3FyMl/noIiNDj33lMVcRyj425xz6xhG7n6dS71dbgSgrvKs2JD6oI1RWEGDwI+W+u2M9vVE6+OpinZRYPWnNgGsCtJgTPD1zq5HNUzPj5BqKf3fa7h3z7CWtfZA9C6nVgiM3OB4nH9pWsSJ3jN6PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wjLU/OkaLnGWVBswFlt/V3uJgZrEXHhhZPQbZfmMbu0=;
 b=gLDO/ANNxXWPO+Vv+CUu8+tu5gPXNW0Hjw87k01OeIrhubNDbfKC9/LXa47Qo8boISQ7X1K9rjp1IVsGx/MPgEdeDWFt8ks8hP9+fyzkOorOjC/+LWBzlhCfbnrGcnNXIxfQTxU8Hy6L+V+JLuW0VIPdAs4YZXwhgP5zGM+/NLwGTS+2Hm7piDVW/uYLqa7EKWW/DsjB7wd45b8mLlnV2QZdxScv244kvFJoaaJt/RJuhTltTQ3wklPkUWXozY3bd3SYPG9ys8nCE9dDEgE9cb2uS/XsDoBdV+j7yt3oOK5oAIw2/+mswqOn9gDzAxkILmroMHR5q/UADV0B7YKWMA==
Received: from CH2PR12MB5001.namprd12.prod.outlook.com (2603:10b6:610:61::18)
 by MW5PR12MB5624.namprd12.prod.outlook.com (2603:10b6:303:19d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.9; Wed, 8 Jul 2026
 01:34:29 +0000
Received: from CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe]) by CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe%3]) with mapi id 15.21.0181.012; Wed, 8 Jul 2026
 01:34:29 +0000
Date: Wed, 8 Jul 2026 11:34:24 +1000
From: Balbir Singh <balbirs@nvidia.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm: migrate_device: fix pte_pfn/pte_dirty called on
 non-present PTE
Message-ID: <ak2ldVFP7R4u95lU@parvat>
References: <20260708003955.4024340-1-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708003955.4024340-1-wangkefeng.wang@huawei.com>
X-ClientProxiedBy: MEWPR01CA0307.ausprd01.prod.outlook.com
 (2603:10c6:220:1d8::17) To BL0PR12MB4995.namprd12.prod.outlook.com
 (2603:10b6:208:1c7::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB5001:EE_|MW5PR12MB5624:EE_
X-MS-Office365-Filtering-Correlation-Id: 671a6547-74ed-4d5f-41e4-08dedc910da5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|376014|1800799024|366016|18002099003|56012099006|11063799006|5023799004|6133799003|22082099003;
X-Microsoft-Antispam-Message-Info:
	w6FsHVMhxF3z1kAaf0xx+YpPBoX6iTbqaIeCYXcnBlP3hzbyNuUnsB8/U1EtU/2UIvahWSx8u7wh9kjxMR3RiswNoHclujpiwz5FkmMtv3A3N9BOFYNt27+f1hAP8ZtUNQcOqktCChBWUzdJJANTnxgLMEtzeDh1fF1KsoJMZV8PxYPNj9aJC2jGuXCtUG3qOGeH96a0jT06nRIv9OFtjp6cyRRRwcScDItYDwdyaXtKNvAu/+Vyh2ESSSYLhXgq7+CtyIS5CjXUWmaDJbGthpS2vzVcBfSvHAvOhM3vKEDaZhRMlnI9fn9i51YX+WSGZO35IXksDIVAVOoSjguJFBIHqfHgoPvYB4+7hk9xuEMNV0j9dKW3Nyu9XBfMF6Q/7GaMCtB945rnJwNXd0goiukcjU1ZNPOS21zrfD7QQ9XqD/IJR8SpMJaFxCx/Ne9LbDAnkE63I4SNlRPMy/gdJ8ONCE+QIrpoS5F/ZIetzwp4GUeM0gh1ptf1qu1tjQmmPEHR7XTM0PP+sQdBTLI61fepSsyVFPpKhFFETfuOkBHnAXAFFKtV3+m12i2pdaklRdJAFRrj/7lhHnF0t/5mZ1qVY1i6fYTH7ba2AHxd11uQA8lvtMKw6I6R1Z7r75lqOZcbLs+kGaY+InRxA6zWcYACvYlBo/X5aH1isaqZqYw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB5001.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(376014)(1800799024)(366016)(18002099003)(56012099006)(11063799006)(5023799004)(6133799003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ALqd7dmhMdXrsaMZ2nHGwlb1a/+QGyZejam1uIPaCJHNRwURNsB+UXhATCxu?=
 =?us-ascii?Q?UrxGmwMILQ28HekK1NDVC4xZkBgsnU/fWiVyKhE1H5Idy8uZ6o+5s4mMI4Sc?=
 =?us-ascii?Q?9V4vHC2QeDuL1eVBYZLHX3CZ11G1FtS2iztyId+1tDfiNNtWA4JgCjwbF7Em?=
 =?us-ascii?Q?I0SVMF1mFuO/CLV3a7d9IqPZ3nG4ja6RWiEG+xoGHTEZzClTvt5joD17m6hz?=
 =?us-ascii?Q?cW5i3smRuEUvGnbWHEqzdM7cgeNieDgcNd9Wzvi1SvjQHkc3WSCjGCYawU88?=
 =?us-ascii?Q?AY8hIP9uDxXhBVNRvPBIGQLbcAWjtW7BuODW+fSSytHATtK/IsWQ9WQSFq9e?=
 =?us-ascii?Q?irPJZxUvBZZAqXCCc7HObNzm5EktV1afxk/s9pRBj6vkmPjmAmC7kf1xQyJ4?=
 =?us-ascii?Q?aQkmY9pN0psnXxl6nPNPBDWRkt4bRnlsk7FAthTbMDxBOOanj7gV3PkCsPDW?=
 =?us-ascii?Q?7vfKVOzufAAlSi/xL0UIq89/Mm/nAWuQB/gWZDggBwhnXrLVaNLYzZErsKfJ?=
 =?us-ascii?Q?aekXCz/CtBGaZog8PanoF9LvQ8fwQ9/oncyLQKnESTNwSQmwqy1arQPcTv+d?=
 =?us-ascii?Q?+VeXTBbHVv7tIeuU8mhB2sOoBjN0oVMkwRsxIqgbDwp7HYVzXFvvltR+Mkd4?=
 =?us-ascii?Q?NdCWTLrwWuzmf575q03jouKrFaaweyTG2XolWYQ6GBHRZk437WJcTDaHqrtP?=
 =?us-ascii?Q?1aGnrjITKKH7skO8mzgKVrjU7wYKfQNj5Hp/BCXtkYHDt/ETerieTFa+LuDS?=
 =?us-ascii?Q?amsqmK+gp/Nk2OXZF1YDQGsUQBONnKm5IBCrgGa26KHSSMjZh6NBFaFRYotR?=
 =?us-ascii?Q?PtX4GS/nKWl+UAj2tOknl0DyINNDf8uM/cB4OcA5WEhqi3T/NkCbpAjh1omm?=
 =?us-ascii?Q?wtqX2nGbqzqKjxasnxzXl6yK3bj86Qz5/Ddicc+q3OivT4r395cJ4mQG/Idp?=
 =?us-ascii?Q?VenOrjaewbxTUE+oVxoMyy8t0YClBepHELWEsk9cKsGTAdaE4W0EvfIXeDE+?=
 =?us-ascii?Q?Fta3tbNdF7pYpH4gzzd/oeesiAxkMJlXAfDTh0UjIBiqtIH+25tt3cheQscI?=
 =?us-ascii?Q?O3rEKqE4JPlW04QIsVivx77Rm1m13Jeq2+SErTyVw4rUXlFGFgQ05RQEm4QN?=
 =?us-ascii?Q?Fb5fJ+1SBUKDaTSB8U6h4J2eaHQ38zc8RXimIIkh0Y4wLy3BuYUelS8MK2Cu?=
 =?us-ascii?Q?k9yNeNX01gBcMMJJl/U3gAK2R/xhrQGQcsWPajMhafNWqsRjdApUuFZgTHmR?=
 =?us-ascii?Q?EbpmJQ4NItoE1E/6iVw642EKA/4goOeeHRnwiGY0s52nwP6blYyyv1qSRLew?=
 =?us-ascii?Q?JD4If/wQfRMWp5rDDshdnzx8M8ODMVkOFtkcjIBIMj88+ssbYtaTy1Oxe3AE?=
 =?us-ascii?Q?/YV/z+SPiG8u8LtE3NdZKpv1anDN60t9Fwhy1P9RwxpYQ3ZyzeugyD2yADhE?=
 =?us-ascii?Q?PVa3B0Ef2vTagVExXzbJsZ7T6kaLfFONxDjVlfoMG0Whd3LjR9JqjQzVvf//?=
 =?us-ascii?Q?iEoYAB/TX8uB2/X6h3MdNzjqU5EgM6kDb0CBnNA+AYcEAu0SD4ivQ/8utK+c?=
 =?us-ascii?Q?h85eD/FXlIECG6hrZyxCeEpeUYSTtgwoDzQ6r/1P2hZ2nShMnlHiD+s33EVp?=
 =?us-ascii?Q?rdKAxUs9rDOE6uQe5gmgejqq3t3C4UPS7Nj+YRpvFgtPqIhCaoTCxEdbu7DN?=
 =?us-ascii?Q?OsOWRstDqr1acK8YzxUvC8+VBH1uSWeUu+kWDU+tKHDDtUBuRA15da5VKEBG?=
 =?us-ascii?Q?SJVjPixMKw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 671a6547-74ed-4d5f-41e4-08dedc910da5
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB4995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 01:34:29.5559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iU9l12hKKturdvT/OvBOCeQT5d8SyTkMYg+jVck+EN4GMppp1H9YlEjjoJ43+1W7M/fyDEvTGKdVdo6qibl84A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5624
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 23164180003
X-Stat-Signature: z6u5upchpsdob41i4orfj7wy1715647g
X-Rspam-User: 
X-HE-Tag: 1783474477-489523
X-HE-Meta: U2FsdGVkX18gzckx3lTrIA6BlwMQBXesrZtf51itQtOjKyj6oM68yFTCEFUS4aSU/1G2C57YF1ywTYnyh5KaGUOpVHVcHMwsOhvWlwNvnnHUVd4UwBrjW0Jb4dwt8DCgDVP6mTMZkrfq9svFsGKAG0ixgNPhcH/DItKMK+ds1lhRfYqV2ZkFUxr5tYshZdA5S8DfmZ2UcadNVO5bGOuQzWF5qJRMfX1pNBAGRubPGc6NSTZWLJpcWOILtfCAeloiovzLF+30yQmDVaJurEs44beV02zlhQ6lkB8Y4M4BtdvnUVXAmFgCFoxbsEh8qWEAwxMAc2V56l8UtSi1MHF0Uf+7GWt7LIgfbTycm4Lp7EdSeBywIfQIVIDhRq851WF3Ffie4uwmO/jrOB8bCzRKOixo9Yw1eGOhSGc3vq1VvfzkTDbmZmpvfmJWoJoODdwq8SUvrCxGEQgNTDCi6IfxkGfHpxHZpcW2mzy8OpiZyYQf2ABslbzQ4YhzlvHqULz2XJdWIN6qmyVmy6XxEZ2Wof7x0S51jw0RMf1o5BsdlbNrIL59+h2yWxMjTkOewifjGdHC6OdvXuMlvY3mLKPFlOugXveJTc8DJWq73FaY/ffgw6w6QiFFTlFIxDVlPfM/94bujvYK6tAZEaiqZKEHdwkii/rvvKpMLUyDHZSxDfApZjx9cU/7heJ+sEsa51f8bVp+Zkcd9u9Og0XhcS/tmPcvDsRUAYHY4ycdRus1S7RoDpzIhbR3NX1u3C2j8ZeNlSX7fZAe9EFrVlZamzJ1rLmyIpa5LJzlgrYGqkvC5PnZQUIqqCPnE0y3Wc3IONLyy83TY0NQpS2J6cp4Ed2Tk5rDitkWzrd0UTNL63c9PhFeAQ7q0V+vmDLd0225qshMCo8dj0MKDREoywhvMBMNlWIea+TY0zovmC3b4SmrKP/rLOqZbumQQrGu0Ay1TdLbrMXGp7u8j2ovi5oY04f
 8C1624RG
 E7d4RQp0WIjv0Rtn+QehXohtbtLwMPzJdBJoZgH0cwnqD3rR4+c50frEdJGknfnwDR83P52XMrzBzrCtwOA9t0k3FP09JUJbeW808+PhUCjNKqgY0Pd2kZTnaluFvRU3S/H0WFc9mNmqgO0jN3M6eDWozYTMCDMrJS6akhgAgUMl/Z1jlUrnOawK9YNfhPScuF9XOsZRDiTYBukB2c98fQBZWiR7SsoehA9UpZqdJ3iuO7MdbfetF8Y8dxCapUalFCnfhs6kpXd0ZBwqbVMATwv0p1HhxsNDtLJpMr5lQr3bM9lr3LHiVDHuNuXQzamOS+vHMWWlJWBtdalCC2BdO+lsZN8oDjIG6GX28onYukuk+ouhDwjVsAGT6uEmiEy/mfiQfpJINfJfDRMw8tTCvlJXOywx/C/UFiOlNP25nzveSfMi0kIG6yvcamR5RSCgm+PuqXkJBbK42ndgfYa3wKIc+SAu5aLm84smdB7/PsM4YDxhpWUFgc//LEvgWgbIGuMj6WbnH5Ui8ZuXWYf9p+giBtAvhDyc3f1CYhN9xwZZooboFTpZwCufLIwNzmtHfGgzJkG0qi2fmOcaLxejfLX2wdELcYC0ZjRcL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 08:39:55AM +0800, Kefeng Wang wrote:
> pte_pfn() and pte_dirty() have undefined behaviour when called on a
> non-present PTE. In migrate_vma_collect_pmd(), these functions may be
> invoked on non-present entries (e.g., device-private entries), leading
> to potential crashes from pte_pfn() or incorrect dirty folio accounting
> from pte_dirty(). Fix both by guarding with pte_present() checks.
> 
> Fixes: fd35ca3d12cc ("mm/migrate_device.c: copy pte dirty bit to page")
> Fixes: 6c287605fd56 ("mm: remember exclusively mapped anonymous pages with PG_anon_exclusive")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
> v2:
> - correct changelog and Fixes tags, suggested by David.
> - cc stable, suggested by Andrew.
> 
>  mm/migrate_device.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 052167f9ad54..6e711381f092 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -411,7 +411,8 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  			bool anon_exclusive;
>  			pte_t swp_pte;
>  
> -			flush_cache_page(vma, addr, pte_pfn(pte));
> +			if (pte_present(pte))
> +				flush_cache_page(vma, addr, pte_pfn(pte));
>  			anon_exclusive = folio_test_anon(folio) &&
>  					  PageAnonExclusive(page);
>  			if (anon_exclusive) {
> @@ -432,7 +433,7 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  			migrate->cpages++;
>  
>  			/* Set the dirty flag on the folio now the pte is gone. */
> -			if (pte_dirty(pte))
> +			if (pte_present(pte) && pte_dirty(pte))
>  				folio_mark_dirty(folio);
>  
>  			/* Setup special migration page table entry */
> -- 

Makes sense, thanks!

Reviewed-by: Balbir Singh <balbirs@nvidia.com>

