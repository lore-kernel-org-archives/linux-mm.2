Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7811ACD3424
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 06:18:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8EF66B0005; Wed,  6 May 2026 02:18:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A66786B0088; Wed,  6 May 2026 02:18:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97B426B0092; Wed,  6 May 2026 02:18:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 84F176B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 02:18:12 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 21949120755
	for <linux-mm@kvack.org>; Wed,  6 May 2026 06:18:12 +0000 (UTC)
X-FDA: 84735990024.20.A6D6CC7
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010022.outbound.protection.outlook.com [52.101.46.22])
	by imf30.hostedemail.com (Postfix) with ESMTP id E540F8000B
	for <linux-mm@kvack.org>; Wed,  6 May 2026 06:18:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=AkSikhvW;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of bharata@amd.com designates 52.101.46.22 as permitted sender) smtp.mailfrom=bharata@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778048289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UY2qwOIdeO9PNjp6XWJsV74C4SHbulNVA0ZmqO6LOKk=;
	b=50RrF0PdtSO/pj7So8ORzGQ5OGQvyfvF7rWtn77EGLyR6VTPju9DDh92DLhLmlpot+jI3R
	qKBmb/E8xi7DCKqWS2DgHFYPtthHSW5b/erwL+g0YFdM6lccldXNdYUf4Lbldki5LHjSAB
	YKmRpcxXQJn2XVMQEwvuQsYJiIY5bz0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778048289; a=rsa-sha256;
	cv=pass;
	b=FIgVJa8VbMlNugw7AMjDsZpHc1n46t/5SH6AzQNmHoFdTFCB1q4wgjcwfQj1gX6uJA4HOD
	IDwXy9/IP1YxeaqVbbTMc2CEbWknmoydY0kwOQh5rCLJ4IsEyR4PpKbiBQmxya1zgAlRS/
	YyggY0Mo/R3FaaOCq21t7V4rfVn4Cko=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=AkSikhvW;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of bharata@amd.com designates 52.101.46.22 as permitted sender) smtp.mailfrom=bharata@amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ur/BfdnCAPngPPr9gpo3SgVx2ZP1oo0eCqGVrrUFME7ySQ+uUoXKQIskc2t1a/uHcCDh+IjztrtvdMV1rN5fMWnm7K5LBLq8L+/zXiPsROzaMgrdawP7PXjNAG/h1jscex06xRGBdpZrYC8S6htAD5zL4+NMO+9HZGzm5s3CLFL4IMI1obQV3TJ25DW/TxfKb0KsagOqVpJvY3rURI3onRwK77UgcEjp/iVnKYC+f2G7+kuRdCXenaVIuOo5Q4pQqK8nqMLyj3j0L5mObEKhae1cy1VEXk6rKHE73WLUR0/tHoVnFd9ku+vTLzjsE/ynnhO51wKkLyn8BdWNrKtppQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UY2qwOIdeO9PNjp6XWJsV74C4SHbulNVA0ZmqO6LOKk=;
 b=i+PiNggWcmXI6J0suZMosZUu0rOPLLFbG2qet5z5dYYBe/6rCW9/a9x8PjhifJam0YdF/HSOOj3HoyEiB/r97cuBqd6HsoTZeeGuh5E5SEYH2YeUlKGM6dXRuZFZ5cK3oLPNHMCVfW/tEosQ8T9qcDYr1C3YWwbnaS5ullcYAEq8l5Dwk4yNgR50rmgjLxlMEvmgHGcfSC83FXU7ruUEE1YhlBjWXyOMx6CiC61NFcxlszCCdB7emb7LPxoaXQpv6v1IMgt9TS8cIwLjaR4jUcRF6qos90GBniwdfqT6mnG0PdLd5IBe8WVvIQKWw8RtNdxvqkk+d/+iN+u9f1ZQuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux.ibm.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UY2qwOIdeO9PNjp6XWJsV74C4SHbulNVA0ZmqO6LOKk=;
 b=AkSikhvWhHhceJHnVKawJVyint+tTcQTJGFGMIPbzpg0X7g/3cplPz7bayJMVSU5y1xLeQhsBa0NR1hNcWkA2u0zM4Irvia9DrCt2J52g1h743NzhFL0ElH0LAQNQoVv5+CR97IuxN8uC8BdM/s1w88wQ4AprrSe0WUAsPvNNxk=
Received: from MN2PR03CA0027.namprd03.prod.outlook.com (2603:10b6:208:23a::32)
 by SA1PR12MB7271.namprd12.prod.outlook.com (2603:10b6:806:2b8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Wed, 6 May
 2026 06:18:00 +0000
Received: from BN1PEPF00006002.namprd05.prod.outlook.com
 (2603:10b6:208:23a:cafe::54) by MN2PR03CA0027.outlook.office365.com
 (2603:10b6:208:23a::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.16 via Frontend Transport; Wed,
 6 May 2026 06:18:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BN1PEPF00006002.mail.protection.outlook.com (10.167.243.234) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9891.9 via Frontend Transport; Wed, 6 May 2026 06:17:59 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Wed, 6 May
 2026 01:17:59 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 6 May
 2026 01:17:59 -0500
Received: from [10.252.223.214] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 6 May 2026 01:17:52 -0500
Message-ID: <17e45cdc-f0c7-47eb-b901-b33a5001ae73@amd.com>
Date: Wed, 6 May 2026 11:47:51 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 4/7] mm: pghot: Precision mode for pghot
To: Donet Tom <donettom@linux.ibm.com>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <sj@kernel.org>, <weixugc@google.com>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
	<dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
	<yiannis@zptcorp.com>, <akpm@linux-foundation.org>, <david@kernel.org>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<shivankg@amd.com>
References: <20260504060924.344313-1-bharata@amd.com>
 <20260504060924.344313-5-bharata@amd.com>
 <5a01bf62-772c-461d-a7ae-ce4758a3fc5b@linux.ibm.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <5a01bf62-772c-461d-a7ae-ce4758a3fc5b@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB04.amd.com: bharata@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00006002:EE_|SA1PR12MB7271:EE_
X-MS-Office365-Filtering-Correlation-Id: 31048aca-b2bd-44fd-283b-08deab3738e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700016|7416014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	l+q3RcTt7mQdsqLKUS18+UnvHcwN6PaoDcGJ3D4Io0AksBZAPytT0z7Oljt026TujWAX51B3tX9dWfTAM7lD1OzUz2gFixGlm4VYhO9VPsWlsp4tYkxdvCAIHR7Qxa4Ghm6JA2LXl+dCJmxbYUan/6YTDBmbUlFp6XTZnXZAADaymjDCNAHgCfU5I0lsaconQ5yuYxsxbfFBzyuTKCOamdGV28atMtbJZisjG5uVkThoiiCHsmBQ8GJRC9hlQAoClbYsQawBtmVl/fSmcSO+nrIKzvfkJPkrDbb82AfcmeAgpG0AGlATdLzNM51ORbhTZXjC8AUFPnEFxtOL3PD6vKqYGqEYHJj2Y3mOG3qVDaUF3e/I92/F+f+P7E9pR6Thmdr1XdrBfAyPGxAk5Kmf+/9gG3IYp84TZXppv2jvQsBBC3/CHPeM2n0f8vVcbDyi91W29ouq238fmoLLlWtxz7kJApGu5+wxoABHPNxnBIQgivE4xEVE+TuXWKz7+djqCd8YFe4GcJCT19KvmugXRMngwwKqdG9S1psxJeOvOEaDkJ3xOCvWKTs2TQlB8J2hXs2+ztG2KmxZTJgkvxBe76DpWbvTvcSI/GlQyxm7igM9Awz0tb6/yrozT58ZG5DLk4yops/6JETQ19iOuCs1XF756NGIhrg270GJE0W7CrVFGjA1h9ZzAR3bAH0F18qOlkupmNH0JD69DtcbPIGoTtSY1UaOAB0EChIzeJurhFo=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700016)(7416014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	VaTKEHZ1zBWnsTh9gtY8PmHcN/dB6jbfs8z4poniXpu85rU8dXMrPWEJ0E3X2gpMhTMWcJ74/srZjNZAS+ojFIDfB4JtzkTwodS17C0aO2t0GRAzPMBUW4YanJIqVTzKmhTR0PwNf+jeFP4oJiMTCJ8RKHHyh0clOI7c5vESnwz0XbZERjcufShQI8t0wB/Lz9/d1AI5QTv+3t4fRV9pD90s9k5C5UfYwWgGouwaNcIuIQle5dfIHLXTxbk4YdygOb2Zv80cxljs8wnyhqzj+JGn307qQoQH8k1BQ44Rd7N7f6ZpllVni3g9yspc/1jVAwRu313eJep72kxKVTtUBUxOWeCQFOG2p59njMLEJuutTOOyFE/X2x3yhRvQR1/NbnLRSmjx5sr2F3FZC9ylToWbeyH8QSSEhGEIFC/NlQMtcvv2WwT3Je+uK45BgLJZ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2026 06:17:59.8795
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 31048aca-b2bd-44fd-283b-08deab3738e4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00006002.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7271
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E540F8000B
X-Stat-Signature: uouazhwc9cam67kjmckndxysa9du9dym
X-Rspam-User: 
X-HE-Tag: 1778048288-689833
X-HE-Meta: U2FsdGVkX1+9C+D852ZVVYx1FNpgJ+hB17K/yBlTGNInxtPXasR7g8iQmId+C1olQFpZolGQPNtGtu3Pv5Uu6Dq+O0V5/KcwEqJvz9ix0ZbigUMNnlW/JRZORBCwQl0qEQj+o8EZBzpJQRfuiOe9fD2WNZTtAbZk8biWFfqxQN2twGXStaYn28sRCw0xaXJWgmXDMg6BSuIhHLpMvwnSJvGKLc+7YCHcRUddD6k9uDyME8T9T3I3jLIxkbyz1S5FQb4x5PRv84KbuR9e/MPtrsRXrbRUSiTlOULAW14lBKwkH1uy2cDU2uTizaCkKpC8vETbUPcpVuAApYR5jvSpNHJ1XxQ98Npag1HwexCKIjiWZGYqaaOqTF0jsn2yryfXFyULMfR3Nodk3RhOVabXxKsvC0z19jSFY2v/UKWfb6Po5LubmBSXp5K9vir1yVGp85ethQ1chtSCBAdc3oCE81P1nraKZ+m7QNx38Zdar/n+PQfY1s/ppewnb/kHZo8twZpennNm49iw4tmkL2vEzEntjcjlURhR40odTYojGShmoXTJrsPM3wjlsI64ZxCjCvxA3iFGFOEnyJthhwFaYeAqtZ9FvssTI4nTa/lMNQHum7GO4dtJ5a4GBFSUC5W8thQeDU6iv7jrMU3p0CQM+kAuqXJtKfc6k2+sZlNVrB/siyb18FBm5Gsc4ZBSGb7Gyg/nUe+AcqFj8MbjrDdppNXSj3hW0uqLZUIPk3pHao1ifxdN8BNrvFkZYNQOIpI2m8VSMF79lL4+iBiXEjbL0rhRKljcG4Aqm1wmRL3NDAtWYfzEm0jSW5Is9Z6BP0nsMbqm9LGk1UM/u0w/BGlAREdXgSwOwgEPfK3wxSM+3qiKUw2aD81OmTLzT4bEQp98ZwCwixDzM1Ay3joEmhUbIj6HIgh0yx1ykIiKHrjZ5kka7m/z+NNfu+nwFnJ2VJlc92ujJ3OCTOQnfDeY0kp
 08oGdFUI
 gJAaJO80210eTthHbBteB0bmKobVbo5y09GqxZAxmz2y8mSL06FVA7uBMibFtZgwodcRfmfTOA3aoGJOwbdkkDwaq/7TunFZtr2deSEEXXsJGFUVu2aARtcbmix+vkJTH/weYHVlN37yE6dU6uiw1irqxvMI2o+bMFygNxBsIpmRMk66rCcTVdDVfI6bsib+u3N6wkHjbdixgtS66FnjKADHqbh4USDvG3NAQJRpPaK8leTExR+ZcgvwZFfffbutZjF6R2BrnqZuw4EPlWC27oYCMTEwBINgOb/JYPEjTY4nI7RZJ5t6tUdWP6W74xKp9e3WgzYy641+kOTgaL4eI9xxjQR14KQVZGR/sj94EdErwfy/pbzZYxKW8OOjDqarUvttIbdWS3//PT1iuoG7eObOqCNIqfNUopHPaBSjkQykxcHEhkmnjzhwo0NAXrYHvkePFzQh96T7Jid92JZKMpAIvywa36KZPKUHhaodcruLl1Us=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05-May-26 12:11 AM, Donet Tom wrote:
> Hi Bharata
> 
> On 5/4/26 11:39 AM, Bharata B Rao wrote:
>> +#include <linux/pghot.h>
>> +#include <linux/jiffies.h>
>> +#include <linux/memory-tiers.h>
>> +
>> +bool pghot_nid_valid(int nid)
> 
> I might be missing something, but since pghot_nid_valid() exists in both pghot-
> default.c and pghot-precise.c, would it make sense to move it to a header file
> as a static inline function?

It exists in both modes of pghot but the implementations differ. Hence it can't
reside as static inline function in pghot.h.

Regards,
Bharata.

