Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC74CCD98E1
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 01:56:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8723A6B0005; Tue, 16 Jun 2026 21:56:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84AB16B00A4; Tue, 16 Jun 2026 21:56:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 712116B00A5; Tue, 16 Jun 2026 21:56:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 34C7A6B0005
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:56:15 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 826C61C190A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 01:56:14 +0000 (UTC)
X-FDA: 84887739468.19.04D9729
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012033.outbound.protection.outlook.com [40.107.209.33])
	by imf10.hostedemail.com (Postfix) with ESMTP id 87F6EC0004
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 01:56:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fAznZbxF;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.33 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781661371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c6ICKBGZESEwnywdKclCCdL4mIYMT0UGB3zbnBK5f1M=;
	b=ZnLEcSksRTAG7/Zl/plHcT/Lwm1YA3fxm/9tzG/7bzMTISf4nGG5v7K1rkc1aFz46Im/GG
	Knpxsd+FPybhwNAVFE7zPwBr0XDlXERWk5ylKalqowfUiiyOM+8k8X4HAjL5wswoqBqpoJ
	EhepRkWhvHvu2Lok+GSCOph0kw9QFho=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fAznZbxF;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.33 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781661371;
	b=4pQyV//9zEe/vM8Cn9Ljpbv0ssZJmJDBpTbLtWc2I3up3bssysg+KTO0lCyWd1oGCz/arY
	KDjFJL/0IS2CosFzWEbklJkrVHsLFl6jj7Zl2QSrmMydLrSBbk1f0BoeoPSK1ul7x0Yx1w
	/PuEW9JTAHuQ1k74ERRGVvQXHJJjo1w=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bvC5CMirfLqtkerrgUuSPNNHJg2zykkH5fzl8CuO/zQ0gFnrwBAJO6nGJUoUqRyXQxnbD5KLYyVmADty8uLFVfKIA939TL95p5HToARvzZOR3U0s7FukgdYEmI+4jcO44DTAfUXs82jGISp1XT8dIOdopfV/zdU/MPn+2s5SwFkMK/eKj06TBJVedTzyjl4RhV0cOWtPzIFVV9/vhRWbLnbXP7QWEtf2khkqxaX5JgQCRwDpnxfithclpg8EjifPE0eQnE1+W+PP7brjS50kuZ+yFxjGWYMWIqxso4ynq95QbnxJNlt7ydFAjkUD3Wt4nTxuMa5OvQLowZkrQW/wGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c6ICKBGZESEwnywdKclCCdL4mIYMT0UGB3zbnBK5f1M=;
 b=LX59Hzc5a/FNzUjsAa3fitsKCkID6Y5JJHAKWfeb42cL6SYNb5f30GWx3JEQpjW80+3nhowHxiZhtiuZWQ92PtwXKnjMl3mx/iOnQXU6Pqbd2e5QhNZibvCwMm2uftI+SC9gXx7glkDW6Kwdh0ARHfYN8wwmr4LNQ8wj/KErr5gFTtgLY2vd8LUTCITRgDENNq1zqRZrNRK1M5Q+ABKRwp3ZrNE8KiMQq5teb6HTbmxLOn5dePZcBUZh3BE69/RBc+K3SfrOea9f1Jyt0VeEBgn+0p7q+Qt/IUN1lQLFDsjD5NeysYfMCMsWLi5STupxupmhBStQVDGBzYZGZjOAWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c6ICKBGZESEwnywdKclCCdL4mIYMT0UGB3zbnBK5f1M=;
 b=fAznZbxFe3R5gw/1q8yl1RjcOhV/X6MY8fnRq5QrLOQYxSifKtOWGw6vzNQeeprtMZq9PZNv8Zqm8sxwML2hWOmzlApnhVt5cpqLpj1FAEmdQ1SyRPJn7RYHB+9DIZq0xeLTQwDOJREmgIZh21lTZ8h7StibidcUjhr4CCGFT0JXfpX6DdDcFfP/NoH956yeC/oKTjU12SgCaGUaRnxo+uRZNe+rgxDL2Z19ibkTgUWSParcpzs5HkG4VJ51kBGgffkhXVsVlGrPOtpEjXvo+fiSe0+ppNin5rqGqj6KAwpwZ7t8iP0plQJsxvS+qUCBBNDNTqxO7Y2AVAXi4cCNEg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH0PR12MB8052.namprd12.prod.outlook.com (2603:10b6:510:28b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Wed, 17 Jun
 2026 01:56:06 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0113.015; Wed, 17 Jun 2026
 01:56:06 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 16 Jun 2026 21:56:04 -0400
Message-Id: <DJAY8RKHUO52.28U7OSO06U91J@nvidia.com>
Cc: <osalvador@suse.de>, <lorenzo.stoakes@oracle.com>,
 <jackmanb@google.com>, <hannes@cmpxchg.org>, <nao.horiguchi@gmail.com>,
 <david@kernel.org>, <william.roche@oracle.com>, <tony.luck@intel.com>,
 <wangkefeng.wang@huawei.com>, <jane.chu@oracle.com>,
 <akpm@linux-foundation.org>, <muchun.song@linux.dev>, <liam@infradead.org>,
 <rientjes@google.com>, <duenwen@google.com>, <jthoughton@google.com>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <vbabka@suse.cz>,
 <rppt@kernel.org>, <shuah@kernel.org>, <surenb@google.com>,
 <mhocko@suse.com>, <boudewijn@delta-utec.com>, <ljs@kernel.org>,
 <osalvador@kernel.org>, <willy@infradead.org>
To: "Jiaqi Yan" <jiaqiyan@google.com>, "Zi Yan" <ziy@nvidia.com>, "Miaohe
 Lin" <linmiaohe@huawei.com>, <harry.yoo@oracle.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v5 1/4] mm/page_alloc: only free healthy pages in
 high-order has_hwpoisoned folio
X-Mailer: aerc 0.21.0
References: <20260531055829.3636554-1-jiaqiyan@google.com>
 <20260531055829.3636554-2-jiaqiyan@google.com>
 <84a0b176-8534-e03a-9e6e-400c74ddab0b@huawei.com>
 <45290F97-B8BD-4A9B-934E-0A122A5F3A80@nvidia.com>
 <CACw3F51hi1SAs264i0FKMbieOQhCpRQQ9s7gS_cHDYgHsqu0WQ@mail.gmail.com>
In-Reply-To: <CACw3F51hi1SAs264i0FKMbieOQhCpRQQ9s7gS_cHDYgHsqu0WQ@mail.gmail.com>
X-ClientProxiedBy: MN0PR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:208:52c::29) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH0PR12MB8052:EE_
X-MS-Office365-Filtering-Correlation-Id: ada652bb-9774-46b0-5f7b-08decc139846
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|23010399003|376014|1800799024|56012099006|5023799004|4143699003|11063799006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	7gGqe8SzgQCtZzifxDf45IG0UZkcKWi24MLDvF7izrTnB2OZ9iiRHAJaWQdwcfOjLGqRdbHPuWJTvQDnkWLDdoNUzTm/8gPtdR3NyJLTyR3KYWgAg0NBJRUO1SzFELZosaChaLy8AICW5ZlgF/VhwSfTvP7usC/16mTz2GtM/A7pm3F3hCmCSebVWHrLppH0edoM00UuDQ+PfXWZDNthycXqx4Wp+sir8PGWmjpnBOgzNrMAOEejk8aZJYz04jPPetfuTxKI7kbawaR5iB2yP6/MmCON0Jl3cMWklEOvXudfT41cOHg/AFh0ARI7r549/6/klakNbMS/8rlxbB/UFkLHRCA/2P9bohIYWAnqpxgkxVtZSfi/T0s342V5a5AeoJ+tcLO4pxgNtdDM9j5P9BDaj8/+LqI/kTttvFSpmltzu1S4b4fXqpcNPqt0CY9jGURurp/k1zrx9cmBuhoy3XIsXmuY1WKhCsHFeHE1DF2IroQK1LdLocM6dDrNVJysh3l/vXG5x3pk5lDZD7qwRvsf6+5b78cQV6x3hwBv3cSg++ogssbrDQYV0Z0n6dvwZBFQw4DtrrfoU88sCFQRAxqCD0t6CZwskjgsh5LqdZpqzS7OSHvhsl5IJgv232m98GaYqz/j1QRyHpGonpS453yClpEyC0PcxL+MVDsuW/tzrJ0O1PiEMzPwg/0RyivI
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(23010399003)(376014)(1800799024)(56012099006)(5023799004)(4143699003)(11063799006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bmRrRzh0RnkrUlFpVXZzZlFVWHBvNjNCck5KTVpHQm8wc3pGdHpsV1FhWms0?=
 =?utf-8?B?Ym8rdEVjR0NUancwa1JmblZqU0RFMFhvd1BsOVIySzB2VE1rOEowS3dFZEw4?=
 =?utf-8?B?ZGN0Mk10eUtmRGVnam00YWVjMmh6WFRRNUhLZmorOEtRZG0xdjI1d2EwV0d5?=
 =?utf-8?B?dHpndmg2eHpkbGtoUEJwbUNQaG5neHhUb2k1M0JkdGIvejV4WVljVHZPaHA4?=
 =?utf-8?B?Q2k0WndDZFdQalZqQU4vWFk4UEhBb2pod1M1S2d2ZmJCamxJYmkzcDdNdDVq?=
 =?utf-8?B?QXlvQlZrSzR0VzAyLzhmWWF6dG5tWElVNC9tTmo4aTVDL0gramxiVGZZWE1Z?=
 =?utf-8?B?ZnpNTDQybTJSeW9Ta3FERGxCWUJ6bUUrVU93U0tVZUQ0VEZLVUZ0SHkzS3M5?=
 =?utf-8?B?bWU0Sy9LTC9qTmJERWVjb0ZGZGFST0pTL21QRURiQzJIZ2pVM2s0KzZOV25P?=
 =?utf-8?B?Qkd3MzliUVpqRXdlWkYrd0hkVlcvVXo0WERrT2ZpRE9iNFRzNnZPY1pPcEVm?=
 =?utf-8?B?SFg0eXI5VUh6WHpWYXhmZitaRkdqdnF1aktaclIxd1ExajZnZ001WUNQRndY?=
 =?utf-8?B?RVNXVWFBZHowWWlwcGc0dlFSc0thcW1nblZPUDgrWjVxQVcxb2VoWXFVQ2Jq?=
 =?utf-8?B?NnUzOGQ3VmpnRmlmLzE0dU4vK21TbEVOTHJqckx0T0pBSlVLMmRvNEsvcHR1?=
 =?utf-8?B?WC9Ucjc4dlE4TlN6UEhRdXlDK3JOZjlNaGhpRFpDZndrK1hXTUZUeVZiNTRk?=
 =?utf-8?B?WjQ4bi9BczQzV0JiTnY1cEhNM3I2RGVXVlZSb1RKSk5UYzd5Yy9WZHFSTVZo?=
 =?utf-8?B?c1ZZYjZHTWlLTVoxYXlXQWRFZ2JaUGRuaGh5N21JenIzL3gyWFhiWkw0Sitq?=
 =?utf-8?B?V0tKRGd5b3JUTFIxa0tFYUlZQ3B0MmJpRkZENStFdGZKV0lMdllzMXBHQXJR?=
 =?utf-8?B?ZEVOUGhWN3JyZzRpOElzWlRXK0RNeUVrcmR5dzJXYytXcmUvbUxRNXdHdGpn?=
 =?utf-8?B?ZDBVVDE3akUrek5xc05DR3RBWDROZUhCY2RWVEs1a1NNVmFuSDdWWVpMWDY4?=
 =?utf-8?B?Zk5sMXdmUjhtcG9PZlRnV0lkWWlPaFVRbzNIelBxVXBiT3lIVW1jZ0N6SVpt?=
 =?utf-8?B?aWF6NEVLYnV2ZHQzVStzUktieHhBV1dSSVNoMXJkRkNTaUNjeVFzQ2FKREk5?=
 =?utf-8?B?WVcrM0w4aFhpcmpvSi9jOUpiMDJkQkFWdW5UU3VMUTNYK0M4WHJ1RlYvR0Fx?=
 =?utf-8?B?YjZXUTlMRUx6UGZaallrTG11UnNCaFJtdUNoSWJxODBVRWdFaXhYdFoyaG9s?=
 =?utf-8?B?RDVjTGNmMzJrMjVWWjhwUlBlWlB1SWU5ejF3V2ZkcHVNZExURFBERHQyeHhK?=
 =?utf-8?B?OFJlTmtPNGxZKzdjeEhsNkNxMHZXMVlOQTdqcjJjRlRLK0VHK1MrdCtzWWpp?=
 =?utf-8?B?dXkwWTdVQmNhRVhpejdZRkZVTGJ5UXlIbkJjcG1vY0pCbG1RbGtUK202OWo3?=
 =?utf-8?B?eFpZbkkvQmNQL0NSb096S0xwK0dyUjNvRU1JVi9ub2cvMUh1RlQwbUI1ckl5?=
 =?utf-8?B?UU1lRDA5a1BLdU56YjNRUlZQc0xmMHdnMW1IRXpreWh2Q3hUaTljbnVMYVNP?=
 =?utf-8?B?OWdRVkdGTFptbkNVZGpSMFZiN2xibkFRYUJJMlYrLzRIQTdLODMwVG5paHNu?=
 =?utf-8?B?LzRIdHZPZFJyUVNoNGhNcDhWbGJOcG1oWTd5R08xSjArZmNLSEpZWTFJcTR4?=
 =?utf-8?B?eUJuakJ1dmJXcDZIWGdldGJrclk3elN3WmlDaDNSSHhReTN3UkhVYkcwdjVI?=
 =?utf-8?B?d2Y3Nld1Qml0MGdIdHZkY1hUMVFWVnR0d3BmODk3ZmttTFNjdGtETUVJM0hy?=
 =?utf-8?B?MExRNWNlYlZ3bFFmbCs4VDhhYjdkQ0FSWmtINVlrOXpUYXBXRlREZUZyMzdJ?=
 =?utf-8?B?WW55VG9SVGZIU1JqdHJlMkI0SXlMaFY4ZjZnWlZYZ29ERCtUa011RTRVbFpz?=
 =?utf-8?B?WmtQV1VidU85L293MlBkMk5mNnNXZGtTd2ErNEc4TzRiUUZSRnJCK2JnazlP?=
 =?utf-8?B?d3B0TmtQay8yTml1cUxBTkNPQWh4K3h1Nll0YUdXOWQxR0xmNVc1RHNSRWgv?=
 =?utf-8?B?Y1VsZnhXeDh0aysrcURtRFVUQWdjWUdJT3pLaVlpK3lMM3JjTU51V3grVzBv?=
 =?utf-8?B?T254Qk1ZSUgybnRKZ0xQRng1eWx6ZldFWVB3aXVoVzRGakNBUnd1Q0FOc1Jn?=
 =?utf-8?B?K0l3WUx6cGxMS2E5WGdYOGlwNi96cldMbFZiN2RNU2hxUS9aWnJlZDdLSjNC?=
 =?utf-8?Q?3usLh2MaiRasOAkbHT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ada652bb-9774-46b0-5f7b-08decc139846
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2026 01:56:06.5521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mCI9JOLLtgJZMrKOxBvzmRj2POh/kOdeVFtcEGb0D0tE8dwquJtFuGNQ1lhd2e8m
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8052
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 87F6EC0004
X-Stat-Signature: 4duoy1njiujp44dhhy9iw98nj11ya3z5
X-HE-Tag: 1781661371-918819
X-HE-Meta: U2FsdGVkX1+p/LEmid7FUqBumZ5HvRm/plNvdnZ6kMCNxZ1bXVJz2r/YPaQWt2QCvXlyDcP6XJyi2GHqKkhTBGVRyN+bTfTEWZ+bKIaaqEVsNSnJk5hpBab139ASJRU+gbxS2IJjqiMt4GYMrpLemjQpO3l/tVETrae++gddDODmChWYrFGFT6H4oUVlT5J+RCKieZDEqhLrG6AlgNfJvl1yNq15hJPU0OsIV52kfdqe97mDAxJUPPTgG7xvdFETQtrb/e9DLwxpGv8ljISIb0vBjzouigam4LQmX9oYZ/sTVR91zF7yln+CXxz0xR7Hx8g+NhPycy34QhDniVgy43rUw2/Gi1Dtw9DVQ/vLQiOKKYzL1AFJNgx+CYYSO8zwo1ZULqodsqU1L7E/NjYuNSYbSbAux1iiSg+qqrrYljfxu+DlxdJp7ALywezdjygid+AKnoRRbteCiKqDZWumD8tyfcXCS5EUvriKGm9nU2BUqGJ1GNIPSrHyJj/XbvY3cI5sxu2NehlCHdmPNUq4u3fJ3snRDmRTEAqEbERijb1JhTD+fNtNL6r4AzPtDkcsar62/SQ3iiCgBqI7vXNmTE30eL6/poIi2w5xQJu1DtuTeE8NzNRxWF9athD/+qcJcTmu3mmXSvqB3OqqEN5k6GfX+vtU+zHzirZtvYuYhGbqbKZwYj4UHbCXv2xjoUISRfaUO8UIwrCTHBL+81gJyjXj9wBblr+DOjgG7pf6xLhMGcnO3aXEBIsLyGB3NXOsBEYd505C+Pg55xTKE4Q0GH5rFYbdoNRoqrQ7+17MoWShJH1rK+xvrczlqrnu9zT4bStqRJl1CEAkeS5rRiKnV3OvMwCC6I/N/yq5b3xhd0c0wAvl3MMvlT3ZompqeE0Imhx9NUGdLomJDfOGfy1U/A/BtNrMed+96kNRO2ROAHPJ1i/dH4wkOfzjw6Xt+nzq4eFZDWlIUzSEZV7qG8r
 yNhMzVqo
 Cnzy+pwH7Bp7mJSBjhtbDG/9P9tdsRLTsTYTEhi1F7WcaEp10IpGMx7Gc/eBazJiLMoAbSacGIgtEe+jigp1R1mpPkj2uza1SIvBhIzrLxDnWx7DoqAQPPWj8pli+2YU9fIM7uFkBOX0h305xgBYi7SG07u7N5srkl6mmPl17RHpprRC8yyDyIrv4Os/T8Kbsao+sw3wVDuYVDgUe3uR0TNAHfPly4Obij0/JhFZo/ddXluCqVzpgRXZGAYUG0MIiRhkeioQ1XxDKN0cyvn6OZ7U7cxBJas27uS6mQ+QGTBvNzuEHhp9DS5MzQgsQx3PmP/kGI6V0w1F4gMt0GhorUU1p+K2tpNO8u+HNhbI81T/Vc3DKmwGm+ETzx0/L0l6L9ceFNc2H0d6HnCMsoZrORdMPKr5LLMIr5xyzJ7bZUQNczqwSUtZA84NvuKwbGePlih1kHI2lBDAX7+M6PCo0BoIYfJud9pJ3paK9hK/QB3XVBS+d4Gz7SESMYfZS4Q6nOnzIuYOpwsX71WL9wEl51EzTrpFhqGpfl2M+ovAG+qWE7GvmWfJgBFP5ZnRytBXFM0E2Ud+sN8knNl4XMyEhZBkYfCCwYK6/r4mLUMreep/FUtNE82rPcWilcPl50kxHETTGapi3ODNjj33r0mtkfw8m6NZtVMjQwboJiNP/iD+X99UQeudHvciRVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Jun 15, 2026 at 11:23 PM EDT, Jiaqi Yan wrote:
> On Fri, Jun 12, 2026 at 11:34=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>>
>> On 8 Jun 2026, at 23:44, Miaohe Lin wrote:
>>
>> > On 2026/5/31 13:58, Jiaqi Yan wrote:
>> >> At the end of dissolve_free_hugetlb_folio(), a free HugeTLB folio
>> >> becomes non-HugeTLB, and it is released to buddy allocator
>> >> as a high-order folio, e.g. a folio that contains 262144 pages
>> >> if the folio was a 1G HugeTLB hugepage.
>> >>
>> >> This is problematic if the HugeTLB hugepage contained HWPoison
>> >> subpages. In that case, since buddy allocator does not check
>> >> HWPoison for non-zero-order folio, the raw HWPoison page can
>> >> be given out with its buddy page and be re-used by either
>> >> kernel or userspace.
>> >>
>> >> Memory failure recovery (MFR) in kernel does attempt to take
>> >> raw HWPoison page off buddy allocator after
>> >> dissolve_free_hugetlb_folio(). However, there is always a time
>> >> window between dissolve_free_hugetlb_folio() frees a HWPoison
>> >> high-order folio to buddy allocator and MFR takes HWPoison
>> >> raw page off buddy allocator.
>> >>
>> >> Another similar situation is when a transparent huge page (THP)
>> >> runs into memory failure but splitting failed. Such THP will
>> >> eventually be released to buddy allocator when owning userspace
>> >> processes are gone, but with certain subpages having HWPoison.
>> >>
>> >> One obvious way to avoid both problems is to add page sanity
>> >> checks in page allocate or free path. However, it is against
>> >> the past efforts to reduce sanity check overhead [1,2,3].
>> >>
>> >> Introduce free_has_hwpoisoned() to only free the healthy pages
>> >> and to exclude the HWPoison ones in the high-order folio.
>> >> The idea is to iterate through the sub-pages of the folio to
>> >> identify contiguous ranges of healthy pages.
>> >>
>> >> free_has_hwpoisoned() is added in free_pages_prepare() as
>> >> a shortcut and is only invoked if PG_has_hwpoisoned indicates
>> >> HWPoison page exists and after checks and preparations in
>> >> free_pages_prepare() all succeeded. free_has_hwpoisoned() then
>> >> can re-use free_prepared_contig_range() [4] to decompose healthy
>> >> ranges into the largest possible chunks of different orders.
>> >> Every chunk meets the requirements to be freed via free_one_page().
>> >>
>> >> free_has_hwpoisoned() has linear time complexity wrt the number
>> >> of pages in the folio. While the power-of-two decomposition
>> >> ensures that the number of calls to the buddy allocator is
>> >> logarithmic for each contiguous healthy range, the mandatory
>> >> linear scan of pages to identify PageHWPoison() defines the
>> >> overall time complexity. For a 1G hugepage having 8 HWPoison
>> >> pages, free_has_hwpoisoned() takes around 1ms on average on
>> >> a system having 56 Intel Skylake physical cores. This is
>> >> 15x to the case of freeing no HWPoison page. The cost is far
>> >> from triggering soft lockup, and fair for handling exceptional
>> >> hardware memory errors.
>> >>
>> >> [1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-emai=
l-mgorman@techsingularity.net
>> >> [2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-emai=
l-mgorman@techsingularity.net
>> >> [3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
>> >> [4] https://lore.kernel.org/all/20260401101634.2868165-2-usama.anjum@=
arm.com
>> >>
>> >> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
>> >
>> > Thanks for your update. This patch looks good to me while some comment=
s below.
>> >
>> >> ---
>> >>  mm/page_alloc.c | 85 +++++++++++++++++++++++++++++++++++++++++++++++=
++
>> >>  1 file changed, 85 insertions(+)
>> >>
>> >> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> >> index e47679e7a9db..03df929abca6 100644
>> >> --- a/mm/page_alloc.c
>> >> +++ b/mm/page_alloc.c
>> >> @@ -208,6 +208,7 @@ gfp_t gfp_allowed_mask __read_mostly =3D GFP_BOOT=
_MASK;
>> >>  unsigned int pageblock_order __read_mostly;
>> >>  #endif
>> >>
>> >> +static void free_has_hwpoisoned(struct page *page, unsigned int orde=
r);
>> >>  static void __free_pages_ok(struct page *page, unsigned int order,
>> >>                          fpi_t fpi_flags);
>> >>  static void reserve_highatomic_pageblock(struct page *page, int orde=
r,
>> >> @@ -1309,6 +1310,14 @@ static inline void pgalloc_tag_sub_pages(struc=
t alloc_tag *tag, unsigned int nr)
>> >>
>> >>  #endif /* CONFIG_MEM_ALLOC_PROFILING */
>> >>
>> >> +/*
>> >> + * Returns
>> >> + * - true: checks and preparations all good, caller can proceed free=
ing.
>> >> + * - false: do not proceed freeing for one of the following reasons:
>> >> + *   1. Some check failed so it is not safe to proceed freeing.
>> >> + *   2. A compound page has some HWPoison pages. The healthy pages
>> >> + *      are already safely freed, and the HWPoison ones isolated.
>> >> + */
>> >>  static __always_inline bool __free_pages_prepare(struct page *page,
>> >>              unsigned int order, fpi_t fpi_flags)
>> >>  {
>> >> @@ -1317,6 +1326,15 @@ static __always_inline bool __free_pages_prepa=
re(struct page *page,
>> >>      bool init =3D want_init_on_free();
>> >>      bool compound =3D PageCompound(page);
>> >>      struct folio *folio =3D page_folio(page);
>> >> +    /*
>> >> +     * When dealing with compound page, PG_has_hwpoisoned is cleared
>> >> +     * with PAGE_FLAGS_SECOND. So the check must be done first.
>> >> +     *
>> >> +     * Note we can't exclude PG_has_hwpoisoned from PAGE_FLAGS_SECON=
D.
>> >> +     * Because PG_has_hwpoisoned =3D=3D PG_active, free_page_is_bad(=
) will
>> >> +     * confuse and complaint that the first tail page is still activ=
e.
>> >> +     */
>> >> +    bool should_fhh =3D compound && folio_test_has_hwpoisoned(folio)=
;
>> >>
>> >>      if (fpi_flags & FPI_PREPARED)
>> >>              return true;
>> >> @@ -1443,6 +1461,16 @@ static __always_inline bool __free_pages_prepa=
re(struct page *page,
>> >>
>> >>      debug_pagealloc_unmap_pages(page, 1 << order);
>> >>
>> >> +    /*
>> >> +     * After breaking down compound page and dealing with page metad=
ata
>> >> +     * (e.g. page owner and page alloc tags), take a shortcut if thi=
s
>> >> +     * was a compound page containing certain HWPoison subpages.
>> >> +     */
>> >> +    if (should_fhh) {
>> >> +            free_has_hwpoisoned(page, order);
>> >> +            return false;
>> >> +    }
>> >
>> > When the code reaches here, the hwpoisoned pages have passed through k=
ernel_poison_pages,
>> > kasan_poison_pages, kernel_init_pages, arch_free_page... These functio=
ns might write to
>> > the hwpoisoned pages. Is it safe to do so?
>>
>> At least, kernel_poison_pages() writes to the page. It probably should b=
e
>> moved up, somewhere like above kernel_poison_pages().
>
> Writing to HWPoison pages (location having memory error) is usually
> safe, as in it doesn't cause a machine check exception. Memory
> controller usually just fails the write op and waits for the next read
> to raise the MCE / exception for prevent silent data corruption.
>
>>
>> I do not like the shortcut method, since the pages are freed in
>> __free_pages_prepare(). This causes confusion. One alternative I can thi=
nk
>
> What exactly is the confusion? or why does freeing has to be done by
> __free_pages_prepare()'s caller?
>
> Harry suggested the shortcut method [1]. Although freeing inline might
> surprise the caller, it simplifies things for all callers.
>
> [1] https://lore.kernel.org/linux-mm/aVy7L-3pc4JUYBEn@hyeyoo

The function name is __free_pages_prepare(), but the code ends up with
freeing the pages if the folio has HWPoison.

>
>> of is to make __free_pages_prepare() returns a enum
>> { FREE_PAGE_PREPARE_SUCCESS, FREE_PAGE_PREPARE_FAIL, FREE_PAGE_PREPARE_H=
AS_HWPOISON}
>> and handle the return value in the caller.
>
> Are you worried that a caller of __free_pages_prepare() may see false
> returned in the has_hwpoison case, but mistakenly propagate some kind
> of error, or doing something under the assumption that folio not
> freed? In this case the three enums can be useful. But I checked
> current callers of __free_pages_prepare() and they don't have the
> above problem.

Right. Looking at compaction_free() code, if dst gets has_hwpoison (not
possible now, but if in the future migration code decides to mark folios
when copy fails with EHWPOISON), the next list_add() is going to cause
trouble. Or you can rename the function to
__free_pages_prepare_and_free_has_hwpoison()? At least, caller knows the
potential side effect.

--=20
Best Regards,
Yan, Zi


