Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 045CBCA5FD4
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 15:38:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05B496B0095; Thu,  1 Oct 2026 11:38:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00C576B0096; Thu,  1 Oct 2026 11:38:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E15286B0098; Thu,  1 Oct 2026 11:38:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B4A956B0095
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:38:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 23091A0249
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 15:38:07 +0000 (UTC)
X-FDA: 85274463414.05.D74150C
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011059.outbound.protection.outlook.com [40.93.194.59])
	by imf08.hostedemail.com (Postfix) with ESMTP id 34C08160004
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 15:38:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="A/l+V99O";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.59 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790869084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=946lhAQKkOAoD2MPoFoRW1VH/wfvmI78wdReVbODwfs=;
	b=GGsWDVD3nA5Et1HNJkcStGuXuvobYiaFoEowDAE5CRNeZCbEPo6sVs/4bjByQRCAzoyIer
	QxH6Hazk6sFDXkpdumrUSgUzhFh42/OY6Le8JUQvYircMp3u6yISBfHrQHDqwQaEjPp6ET
	1YovgjqHmf9NPV25Me9MF4QKDWcp1/M=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="A/l+V99O";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.59 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790869084;
	b=u3G44m0nzZYtfNfDerpUjjA93WCYBxlNiyTLZpHhnT74aUMmpdf3CjfnQN83QaRBEHxodP
	xR4ZnzD7GFmsTwwye0OzWICzvN1JLSESCJ3uiGMoHkOBrkhKv4DGOG29uohLh3qNj6IbuN
	Fp9Tq6QRssJJ3lTSXr7t9pDTcDKuEAI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VG9SZq2CkLpzGgSp7fMmVrT5ivPpz7w++WjR2ra7lM637iQiTRG56iQoQznrtQFsNEI2SjaT/mxYkAUKGwsAUFZqa30hsivxINenuR70X/X1oTVjRcvjvYR8tX1+Ow/w8sEWftCJaUtpqMVu2eoHmZvMMQmZL0TpEwXW4/oWpFV0nyStAeB+CBTOVaoF9YMlh+CD8p+OwzvSoX83P8LfNk2Xrfg6eHE+brwkcSTisPf4GZsT51aLsiGHDs2LPZyOGiGCpMGCV60lraYfSZ3gZO9B60PJecNwnoQhFBpuOxBOvLvhXnkl9HXAda502sOWw5rQWgyRILx0P3vDPjWndA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=946lhAQKkOAoD2MPoFoRW1VH/wfvmI78wdReVbODwfs=;
 b=AjmwlQc1namoqYwip5GEh+IhAiefgE7UKhj1o+pxgS7PAsiae+RmaYB8HtL185HvIKALdF+F5eMnKKXhLyhKWY3XXGFha17NIQg5SOe+B1PfG9EAMRqA+9Fxkk+VUfrt4F8fx+XOz8i4wNc9calDSooBirB9ejANLzWggbssjQH+J/zKYO6g21kW+KiSZJCP/1nBsi+M6oqtNAj6NX+MT8X+LmgHBovZy2Qa8YeLk82SZnKjzUD0hB2sW/fEG7bkda62HHLANU06B7uvGU1W4amX5VYl/9n7E96HbU/0jsn+HJKJTnU6lzFvRVJeBOBssIfFsEXl8/tFrTJ/yVEEew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=946lhAQKkOAoD2MPoFoRW1VH/wfvmI78wdReVbODwfs=;
 b=A/l+V99OwPIQtwoiWsSg5miNjE4+JfVf7L0adEz/29NJkNuSheziLvqXAt1GmVUDL+teqAow5A/yomFAKQ6aBNMBBkkfUgIVsYY7/D6dKNIKqg7ChA2Cx9ZSCDAAO4Olh0TNc4qrgCE2n/CjJ3bp0ACYfRj2XQ5R9ir9CUw3DGiqtatGv3G4iWu3f8Cuf8qTnmz5qjMj5CGm3G0FBRFSsDPYdRMhHJJz1rZwV+jKca2GrvPYkk9Y51gC6D7iUaYir5zWLJZ1WkQCSuhO2HB7gYhmWP6LXm7ipoHc9SYoS3Vkqj+LuOvVElTau5RMJob1cCLgHNJ0lMAZUdOhcCK3Bw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA0PR12MB9012.namprd12.prod.outlook.com (2603:10b6:208:485::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Thu, 1 Oct
 2026 15:37:52 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0472.016; Thu, 1 Oct 2026
 15:37:52 +0000
From: Zi Yan <ziy@nvidia.com>
To: Qiliang Yuan <odys.yuan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/migrate: look up consecutive pages together in
 do_pages_stat_array()
Date: Thu, 01 Oct 2026 11:37:51 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <4CCA725B-9CFE-4ADF-AE8A-59D6ECA4321F@nvidia.com>
In-Reply-To:
 <20261001-bug-mm-move-pages-stat-batch-v1-1-255b7e915744@gmail.com>
References:
 <20261001-bug-mm-move-pages-stat-batch-v1-1-255b7e915744@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: BN0PR08CA0020.namprd08.prod.outlook.com
 (2603:10b6:408:142::8) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA0PR12MB9012:EE_
X-MS-Office365-Filtering-Correlation-Id: eb96d3fc-9300-4b18-aade-08df1fd1f4e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|22082099003|18002099003|11063799006|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	znOFs1hCriyvGM3OR5s2QH7Up2N7ROQrrdwRc0N6X6NB3Se0+wuWzuCUYaROVGrgjqGar8NAGcx2zYyQdUI4gXVPoDU0C4NOp5aikTqx9ayKb+K6HCSPFnxGtmfjo8PJCz4Dm3VWvppAakSP4ULQyRP+YcpMuABlwpqQZ8p59w7l8AWgkQMmRdBJRf8NQaA+WlnGYU6g6jhEOTjohVm+zSS1iSfB2nTkEVVGX7WTEgEPPJzHTGcoaMb4+iR3WZpTmKS6AjBqTtx1H7ZZJCRjrvTyd/f4a4Zx5bZU1qKHPhIrkeK3h5T6kwWkEbA4/qtaV05eZiulhxxyZcGApbeVMCAdgyyd6vpTKCjMgy8bOOTP4JLxWu1P8cIDBwvsPUyoC/6sCKVK18vshxoXKuUCyj0k90hUH/CLXQTxs/LK+o38Jco+79/aG7LrG8EauY7/NNJIKbKsZgmI6N3xSiRemtRWXnma3WSga1niv7UL0fTqQpAGXR7qZfjScnymPzAtoLeAaTBwbvTnNaqGFIIiyfoocYuajlquzqFs/JcA6QlOX5sYtJsgqR6NgoPQFU75nmghm9DKEoYuqs0FzaxVajlo8i0wvaxDQmsDChJBf3gqUMft1JXp28wstInuWXHPJ+msS3CT6HapJW7ednlIGnYdE1U/vw5rG698UDVhS/0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(22082099003)(18002099003)(11063799006)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uskLRyniGnh7ZwviOG3mxz0ODfX+PlaaJINdEXJ7inofIb2j2ycA+68keI2f?=
 =?us-ascii?Q?aT9Er7NXgEhIDXKjI5AubRCLDgykTVhvnjfcsUOOdrKa3tRGJGa6Hjo7q4pf?=
 =?us-ascii?Q?7htTvi6R/7SI1smmG/3YUoJvooxcccBU5uN/ngDcCy4PiDun8izynvkwbdVx?=
 =?us-ascii?Q?7SS0SCujX0l4Io5OoOGIXlasexzYx9cCfiUhS3/xLdcyPpxGSqx2x/hokplZ?=
 =?us-ascii?Q?dz8TRAPHA0NotauA8MBje+aOFRFLuZ7U9xP94CHtAwm0uPVbm0c8xqAjLhXN?=
 =?us-ascii?Q?I7rZA1qew9jSmhkuvCD6zDmDjqgokrHuORbCMYJ+cKgOc5Sto63EojvggSd6?=
 =?us-ascii?Q?jwMPtqfuWXLzjGatjQPBzAFK04XTGtS4rH2yLiJ2DJ4OwMlZSrRPoSvstphs?=
 =?us-ascii?Q?pokTvE442nbQIoj2zHv4zD/CyErlTvrqsNWaMhbYRkVTGqoolEA2uyVWiBEq?=
 =?us-ascii?Q?zpX2Fxpv4nlmiogzaZqbRIhWB9ZhdY4/72dPD43cj5A1SMU1PJCMpdBWbUMW?=
 =?us-ascii?Q?IARL2sZFSKyRpddQ/pwlEXRijNTSs9IAr/ADdjcl1c2xLZcvb4+gD/Gv0ife?=
 =?us-ascii?Q?rDWdyWvGVFWvl+4EZcb6J9q84qXM0TUWREh/EL+waFe+BVNpnWyhJda6iCmP?=
 =?us-ascii?Q?zcmqF8iiBCDHtD+dk8YJF0LMPsHzG3xr91XvbCC8iD70eUmMR5NyCMrDrBbl?=
 =?us-ascii?Q?aTya4Mg8yqiDLpJg/F3l+sqyND09e3kloBfHMIk8hi+A8GmlDwZUzWzFVLvD?=
 =?us-ascii?Q?/Q+W+PVhhWA0cTdJebu6x3T1zJHTqapsLg1gz0XjqPXWwz0KZWGxQbWJiKDo?=
 =?us-ascii?Q?MvvGjMzLxSmDQXNvoaic1hBIDl4czZ+ye7XHfQ7Iwi+F3797AU/OCNIY8kd5?=
 =?us-ascii?Q?vJh/T8tcJ1SRLd3q2QvBXIZLuNFuA9qTRbFVQChhEOkQbO7VwQPzpjWDYsB9?=
 =?us-ascii?Q?mc4O+nE1nSFbKey+cS7EKL4igxxCYiSBWF4cIbC4wue504vf/WbKudSHHIsk?=
 =?us-ascii?Q?PIMnh73t2g0IIYQ4GicYs1QnFjdN4TyB1IfNilbpA+OWbo1e3LrwG/3j/9i8?=
 =?us-ascii?Q?xxrIcojdz9QPyFc/VaYgoIG+FQY95rB0/8u3i/uAhUOH7TTU8jA01zh2YYIj?=
 =?us-ascii?Q?II6mUZuuP0rnDzBwBJ0AxzRUEAxHcikW3NryXQCNUD7CtSK/oYq4xmuiB65i?=
 =?us-ascii?Q?fMMsxQjdNel1ip8K2kLMPEqlcB2+eGP67WP6QUi7KgurH0mp5plZqmX1meGo?=
 =?us-ascii?Q?qviYeT9e9CcmTMu6jJEgnP9QNjaLsBvgN9e0Jnn7nuIV+BqNY+ce+al2ywTL?=
 =?us-ascii?Q?QaAruXBBk2YpWyht9LFKqq2X/3kSZHbsgJYd2SHjfLMmF4hSWOxbGfIdHf6e?=
 =?us-ascii?Q?4QYPRBhdojyMSHJYm5KYNpT4YYVB1k6v65L/hfUUDZzluDS7r3/K42uIo+CT?=
 =?us-ascii?Q?7iiEi88zzJziOyIM6rw16Ng35gBtVMAJdOboFZ64kLnKAWGp55ZHbag277O1?=
 =?us-ascii?Q?Df24OT5AOW9Bf99jAC2OSiqQ2n4fh/jB0v49BkzClDSV8LdijtMFlzvaqPEM?=
 =?us-ascii?Q?IvL1tb62ZkuPVn8U19mMRO6ace6NlidL/3pH/dC8NnwycZB6QdK3oRsO4j1A?=
 =?us-ascii?Q?J3uv9KyjkXOL6e9GQrVcpsOrE6NOutk3U2ti/zS5qZzOq2XFD+49rXXyM1st?=
 =?us-ascii?Q?kTF6u5EEtuEq9bC2PZdLW5a+ODeva8SBpGa9iZYSV8jUhr7I?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb96d3fc-9300-4b18-aade-08df1fd1f4e8
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 15:37:52.8319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W8QQNZ+tRW/6l5UfAS/uKX76zyQo190LwWqBnspwPFh3koCFkfJqSFB53CUAKq7v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB9012
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 34C08160004
X-Stat-Signature: x1ogphy6xhebtmksugwmrdq45mpxwodo
X-Rspam-User: 
X-HE-Tag: 1790869084-394279
X-HE-Meta: U2FsdGVkX18BtfJNJg3dFT/pMGTVvm1uIBKxmwvHhZF/8hIo/Wbk6hSEr1OwftYMmEdhAxzhaEodLwUdH90aT/KTjviINs1i91tGxn3LZtzTx293ccdPxdN01lP03E89Br3fPIZKcB+1ciRVDViKtJa0d9Hb2ob4srSRRUPtWoxiPd/a0JdzGhYTu/FpVsDuHnsgL/m9fPL68mH62B1okt1uvyQ5k2yjdON9+8D7SpnpS01c1ZfiduVJX6aN4yPl9kIp7Os2Xx0+Mntw9B1f2qTlXznGtRk9Yl/lJd9J0MjDEP0qCX7dqVCcnSP2e+Xhd4zgLpedZUNJfEg609IiDeXNO90uaef3rVAiUViTrvMM3BtbDEjfzLRFT6MOm4LwdKFef/JnXpXyVqQA5f6MVsMM4HKnsGKA+6Z5B6L33w+6S1IBkHnaBYS0hzZBqCAZwKqOpQrqsh4oiSYLy6LKrGQrE82EDHGTtDcDKve+dZcdKjewLj0mPbjR3gf4TqhbMqoE9TDtgZq5ALGt/zC4RJq9QJN6hiOa9MkUUC5LP3VD9av94D2fNJ7Iqkotk8nTHSrkGXkj9Roq5GVjTs8/xhs28IHbekN4CVFwcf3FPSjQ3IKTuQu/ASzAMOQphiXN5GPN+B/vVtRLzJvwVJrfWQJBA4ykhMPxk0HnVZBxgNxQ6XOlQqtFjygym9KeqgTxqhpFyjUMgqzQIyfUW/JBJ0aAT+7DWpFAxCvDD+e8Z+ZnWfwCfVjuE500Oge+gMOPjN0hEvwhOCq3hOnyjdXTb7Tx5G4xQla6B+oQ7bp6mU6M8GEf/4YWldyDWzU4CZYtWrV+L7/C5fToHeZ5EsI176qwYzIT3XJLXVPs43nZVpEZeR5uEp2/qWnMJJjQO95DCJmAxZR9orJIhpfJRl41W3lOdhf1weuYgqiVn4F6WmHZCprjp5LBlHrbavXOg12w/2wqUotPq3HGL7BE2aS
 0aCGPDMo
 qJpePtRmRfwkWfX/k+rcbF7+BSNYLbAApEB1bc96pwJAmDDroVN0P94PsLNbDS3ktGyp9tUZUqOJGq+EPd5lRBmF0uBPRzy9foArPw2z/QSEUdGxgJFPHYgdkvgoXxobBTJZnqlHaHZ1UkQ1Rv1AXzoo5SAdRETCcedw9qTbout8FjdKlYEogSMNqBAHbEBIeXGn+cIfIjqQUPg8+J/Moo7H4C71uJczZo4duTSBRtyGt9A7FK5FFWvDcqiUPO95XpSHI51Iu6oDdptRtRuZs2hDMwMWMVxojchpkskuZ3dlqZYzkpEW+8PKS9Q0e6VEu27URvQL8QsGA0a2DBfYALMYUJHdVVZ27kCVSqH0xHvK2L64X6tRL3aD+z0V/IqmbJw1+FzdV6Zx5wRftaC740/M7BKuS716BkVWW7xJwLg54+MA2Q9+7A6hcZ0avoB4AjUl+KgrMiK9RkapLXydopjPiTknndQyxaXGXgs+xaiTvpOUD03sCMiyfo85fHvOlblrL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1 Oct 2026, at 11:10, Qiliang Yuan wrote:

> move_pages() with a NULL node list reports the node of each page. RDMA
> and KV-cache transfer engines use it to find where large registered
> buffers live, querying every 4K page of buffers that span hundreds of
> gigabytes.
>
> do_pages_stat_array() looks up the VMA and walks the page tables from
> the top for every address, taking and dropping the PTE lock each time.
> That costs about 105 ns per page, so a 16 GiB buffer takes 440 ms.
>
> Callers almost always pass consecutive addresses. Reuse the VMA while
> the address stays inside it. After folio_walk_start() locks a PTE table=

> or a PMD-mapped folio, answer the following addresses under the same
> PMD from that table or folio before releasing the lock. Other
> addresses still take the existing path.

Instead of adding customized batched walk code, it might be better to use=

walk_page_range() + pmd_entry callback. See mincore_pte_range() for
reference.

BTW, DO_PAGES_STAT_CHUNK_NR is limited at 16, so the batching benefit
comes from 16 pages instead of 512 pages in one PMD? I wonder if that
limit could be raised and how much more benefit we will see.

>
> On 7.3-rc5 in a 16-vCPU VM, querying every page of a populated buffer:
>
>                        before       after
>   4K pages, per page   105 ns       22.7 ns
>   THP, per page        92 ns        13.1 ns
>   16 GiB, 4K pages     439 ms       95 ms
>
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
> ---
>  mm/migrate.c | 83 ++++++++++++++++++++++++++++++++++++++++++++--------=
--------
>  1 file changed, 61 insertions(+), 22 deletions(-)
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 15b45832bcfa7..5f470dc7dc746 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -2451,44 +2451,83 @@ static int do_pages_move(struct mm_struct *mm, =
nodemask_t task_nodes,
>  	return err;
>  }
>
> +static int folio_stat(struct folio *folio)
> +{
> +	if (is_zero_folio(folio) || is_huge_zero_folio(folio))
> +		return -EFAULT;
> +	if (folio_is_zone_device(folio))
> +		return -ENOENT;
> +	return folio_nid(folio);
> +}
> +
> +/* Look up a PTE in a locked page table the way folio_walk_start() doe=
s. */
> +static int pte_stat(struct vm_area_struct *vma, unsigned long addr,
> +		    pte_t *ptep)
> +{
> +	pte_t pte =3D ptep_get(ptep);
> +	struct page *page;
> +
> +	if (!pte_present(pte))
> +		return -ENOENT;
> +	page =3D vm_normal_page(vma, addr, pte);
> +	if (page)
> +		return folio_stat(page_folio(page));
> +	if (is_zero_pfn(pte_pfn(pte)))
> +		return -EFAULT;
> +	return -ENOENT;
> +}
> +
>  /*
>   * Determine the nodes of an array of pages and store it in an array o=
f status.
>   */
>  static void do_pages_stat_array(struct mm_struct *mm, unsigned long nr=
_pages,
>  				const void __user **pages, int *status)
>  {
> -	unsigned long i;
> +	struct vm_area_struct *vma =3D NULL;
> +	unsigned long i =3D 0;
>
>  	mmap_read_lock(mm);
>
> -	for (i =3D 0; i < nr_pages; i++) {
> -		unsigned long addr =3D (unsigned long)(*pages);
> -		struct vm_area_struct *vma;
> +	while (i < nr_pages) {
> +		unsigned long addr =3D (unsigned long)pages[i];
> +		unsigned long next, end;
>  		struct folio_walk fw;
>  		struct folio *folio;
> -		int err =3D -EFAULT;
> +		pte_t *ptep;
>
> -		vma =3D vma_lookup(mm, addr);
> -		if (!vma)
> -			goto set_status;
> +		if (!vma || addr < vma->vm_start || addr >=3D vma->vm_end)
> +			vma =3D vma_lookup(mm, addr);
> +		if (!vma) {
> +			status[i++] =3D -EFAULT;
> +			continue;
> +		}
>
>  		folio =3D folio_walk_start(&fw, vma, addr, FW_ZEROPAGE);
> -		if (folio) {
> -			if (is_zero_folio(folio) || is_huge_zero_folio(folio))
> -				err =3D -EFAULT;
> -			else if (folio_is_zone_device(folio))
> -				err =3D -ENOENT;
> -			else
> -				err =3D folio_nid(folio);
> -			folio_walk_end(&fw, vma);
> -		} else {
> -			err =3D -ENOENT;
> +		if (!folio) {
> +			status[i++] =3D -ENOENT;
> +			continue;
>  		}
> -set_status:
> -		*status =3D err;
> +		status[i++] =3D folio_stat(folio);
>
> -		pages++;
> -		status++;
> +		/*
> +		 * Callers usually pass consecutive pages. Answer those that
> +		 * fall under the entry or page table we already hold locked
> +		 * instead of walking the page tables again for each of them.
> +		 */
> +		end =3D pmd_addr_end(addr, vma->vm_end);
> +		ptep =3D fw.ptep;
> +		for (next =3D addr + PAGE_SIZE; i < nr_pages && next < end;
> +		     next +=3D PAGE_SIZE, i++) {
> +			if ((unsigned long)pages[i] !=3D next)
> +				break;
> +			if (fw.level =3D=3D FW_LEVEL_PMD)
> +				status[i] =3D status[i - 1];
> +			else if (fw.level =3D=3D FW_LEVEL_PTE)
> +				status[i] =3D pte_stat(vma, next, ++ptep);
> +			else
> +				break;
> +		}
> +		folio_walk_end(&fw, vma);
>  	}
>
>  	mmap_read_unlock(mm);
>
> ---
> base-commit: 551c722f40809618230001baccf219193e22fc5a
> change-id: 20261001-bug-mm-move-pages-stat-batch-f62a29ea5867
>
> Best regards,
> -- =

> Qiliang Yuan <odys.yuan@gmail.com>


Best Regards,
Yan, Zi

