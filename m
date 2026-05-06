Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AD7ACD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 06:20:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE0546B0005; Wed,  6 May 2026 02:20:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A91246B0088; Wed,  6 May 2026 02:20:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97FE96B008A; Wed,  6 May 2026 02:20:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 87A576B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 02:20:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 105D9120747
	for <linux-mm@kvack.org>; Wed,  6 May 2026 06:20:55 +0000 (UTC)
X-FDA: 84735996870.06.1988B75
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012025.outbound.protection.outlook.com [40.107.209.25])
	by imf21.hostedemail.com (Postfix) with ESMTP id 074511C0004
	for <linux-mm@kvack.org>; Wed,  6 May 2026 06:20:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=z7V4iGWg;
	spf=pass (imf21.hostedemail.com: domain of bharata@amd.com designates 40.107.209.25 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778048452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jl9KfI5sgDVJ/W9h6j4mUJLfvc/o6X0nFZsW2/LSVI8=;
	b=o33l//1V7BEF0OxfXa/17G2Di6Ue5Ssddg0eKgRXa/5GClZCO+xbX7n3K7vN4tdja+jSf5
	zg+u/hgidf8FnrorBwu0MZpVp3FOGzIziNbXx7/mXZSwZKIzFEchZzwu3oASu6Zeahv4WW
	Bk7AeahuW+TaF6fTX21REp9XOotf40w=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=z7V4iGWg;
	spf=pass (imf21.hostedemail.com: domain of bharata@amd.com designates 40.107.209.25 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778048452; a=rsa-sha256;
	cv=pass;
	b=Nfbx17PE6brzXzmvqviVWpj66UDF0jsdl2yaSj+GqGZmg5yMTj9zGesnKvftRVjgnIJb9m
	IWDoV1Mb8UEGDmnREuNW03ZaZ1lVvWruh+EVlqAqrDJAkDvqI8q2BbWOW7LCVCNjzruMyU
	CR0KlYcXbO+yJ1LJhGJef9oYyeExsRU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qg4EqGXJOVrW9eOa1Ol7z3QequoiHCh9kaj+E08mlEw7ht+ONF4pzDpygbQ7LpgngXwFB158ZSaDFm1tubB8//7fK4tLceXO8nDbfSb5/zJvW3Y5vy2PuTDRj+vN/1Su2C9jFZskEZFB1IfTtFFjCc2UGC2+NWFqz1/3+iN9iJEU+HcwJyubS12HQ9zL7rZzx1NI6VSUBwpjDtc+vwpUgD42r3g3n3sQOtl8/1fXJHous+sGHAuzF/acHtfqXUn5WVypqjL1ZhOdoq2jw9eHgbGgc9nzfrdlmnl73AFQ+wmyQqc+QhxEINIuf/ADZHaZEHYSt2BdkV3MO82eWckcZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jl9KfI5sgDVJ/W9h6j4mUJLfvc/o6X0nFZsW2/LSVI8=;
 b=dwdKIvWb/oIpRWWpT/G7v9OQ1n/VvjDrvtdVGnDxEYcqWvMJy+e8/Rgs+zCzF/KpGPwRhYssEET8aJ3PLAEhswDQPPeDcgJzlvv5oK2bzgD9d5SDeiWkL5Ks+qUTs8rs5Rdc3uSLBB9wg4JvOVkmCbLfsB2NPgU8vd7BK4PpOmkT/iQiMmJ/ul7Nx01Tf1nPM6pB937orcNVW56L2KM1ug/SZWnw59WLlT3u2EFn9Fe+tvdI9zzjp5TyBfcnU4Vz8aIvOZu7fxlyhk+UqO+QjMOrvogLAuLZOTxiNuY3K7O9p0JjYm21ADmgkYJwauyNlO1DCwxEB/8XTaLBSSaZDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux.ibm.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jl9KfI5sgDVJ/W9h6j4mUJLfvc/o6X0nFZsW2/LSVI8=;
 b=z7V4iGWgD1QXIdIY556SJkxIX78VXOHaIQL9DfE20n1zIWcOpqXq/6ZBhTqhcuqJlxDc5VKRyd9husPIH0lSWSBBRcdnPg263REO7pLGT1bds9hdacfYuPP7POKZ9Lhdow5Co6rn91YXHjdoklaSqS+WJh6rzok6JjXyWgq5mEc=
Received: from MW4PR03CA0238.namprd03.prod.outlook.com (2603:10b6:303:b9::33)
 by BN7PPFD6BF22047.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6e4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Wed, 6 May
 2026 06:20:40 +0000
Received: from MW1PEPF0001615E.namprd21.prod.outlook.com
 (2603:10b6:303:b9:cafe::21) by MW4PR03CA0238.outlook.office365.com
 (2603:10b6:303:b9::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.15 via Frontend Transport; Wed,
 6 May 2026 06:20:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MW1PEPF0001615E.mail.protection.outlook.com (10.167.249.89) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.1 via Frontend Transport; Wed, 6 May 2026 06:20:39 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 6 May
 2026 01:20:39 -0500
Received: from [10.252.223.214] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 6 May 2026 01:20:32 -0500
Message-ID: <02c55808-9d55-4024-af7f-472245606686@amd.com>
Date: Wed, 6 May 2026 11:50:31 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 5/7] mm: sched: move NUMA balancing tiering promotion
 to pghot
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
 <20260504060924.344313-6-bharata@amd.com>
 <4b532a01-674a-4d81-8ccf-312688368c50@linux.ibm.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <4b532a01-674a-4d81-8ccf-312688368c50@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW1PEPF0001615E:EE_|BN7PPFD6BF22047:EE_
X-MS-Office365-Filtering-Correlation-Id: cbd59924-d169-4ef9-541c-08deab379846
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|1800799024|36860700016|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	wuRs+eDxNOcsxvc+H4TnCP7q/boN6oq7O3TAAUsaa6Xf4zEW6H5hYvC9jzUBwzoHDaDTJIkOg0hBTMroXgQgmCXGsvfp/wq3/AIxy7VfqHirNnwreAkl9O5FdmuZbpt2r/cAfkmgXTUNJ/5YJc29dBH38kSnXp99Mx9/54dGquzFHEr/54UH/3Mo/hrvbOcOdy/F2pmDVtWSnYhi/G7WF28lvOOHSI003Jx0edESpaXAn4L6JqhzGM+ofgRiODZ1BV7+VEGknm5BjBxjpio4l7skhHXJrXkcoEaQKGvGTPPbZOH/Y9F+WldRojQHMt/ddWMLtiAZlwH2g6chskWiGVChSutONN/jCldmyj87Ybwemud5wJUIkd3A09Uru1gu5k6k005dJipAKtHSJgzVaY2iPVuaGLYbH9XCzagN9biU5KcRhBcR5SJyfcY2k0EZ4+MuEAwrIv2UELYEwx7rwVgR/LKZx2iSnI3/YlWI0SVGIxys9f9EKov0OGv/euFuLsgvhJBhpDvOXpSB1PkdujpN7SQIQNIU7kgZ5kVPy3CKwgbMNrNGl8efpH9L6ImTWRSW9INoFAaoqzXSXFNy2lnLq/Rw0J8LmWJ9ct88gvQapfsZzn+DBfd1WdRN7zlIkN9qwSgiGGLWW7uluRz0TagcFyE7oVhlim4o+0lPb6DAu2Eb8nmGTkCGLFrb+8JwJ1jEFptZ0f1bsU1IIaryq4WZA+RHF77dqSTPaKWCmS0=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(1800799024)(36860700016)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Dt/IzW6QeHGeRR9hxOkwKUmQPZXQ85xkLbSV2iySXyGg5arMOx3IV8sm9C5TsGRHaveIaLRhTbM131kz/dBKT/pu30Sotw/UvZOmlgBeBQZJvIrOUf3Bd71KprgSDt0OthReWzU4US6JngZY2qxJhYwANiws4zezSNQ4Hf+T8bvsXMtZ/Hc8R4zP5vHuf98xcsJSTJMig7ZFiPOMhy2CS0+Uhl8JsI8tKdxGuiZNElPbH7Ofn99z+K4Nb4sF2nP8jz90AcdpUp+aFso0C9/h7Vl0/2ceRZGyfrgphqZ30ThMYEUrZqR2GTVyzkln1epmkOgj7xYvbTkZQsBayxc+lNfFY1afkGUXr5/K1APSw9//jre74RRUXCdaRbSHqB/OLkghTLH4yH7VmcMW3+5FKtVt7SVGHtOfIO0pNKkxt3dORI81MUaqBr5VxIzxRiDP
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2026 06:20:39.8145
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cbd59924-d169-4ef9-541c-08deab379846
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MW1PEPF0001615E.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPFD6BF22047
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 074511C0004
X-Stat-Signature: 3mxi8ba7qu944n5rditbwi859rcry3xo
X-HE-Tag: 1778048451-91970
X-HE-Meta: U2FsdGVkX1/sMUJf8T6traX9DLK8BgcHb6EVYZZPenoVY/NKZBc7CPcpzCvhb6tyJBcb0KM74s+rSKt6A1Yb4iyz3AYx3lf7cQESh97zCr+e8E1bc0Ke078HKAxjbJ11K5BiiFOqInmSWNUJNw2vI4RAJcvvRs1dJ9jVp82H/I+WRFyYzo8Cc2unr8fZrKFgf92Ej9NhXsVG0AZ6pm1WoLRbkn3/p+aNP0RlYGg8o+8eLk46xdWhMm5yeli6f+xZcCg22/tauYS/NUpEz6JuBHagTFqsMDZ+uQ14tLqADOX+JzRYpSR376Er0sV4PnrDpJEuhzyzlkLkMV8i3TFTNkawmOvHm656JvHScFyHugBp7QqX4ojmZectlBxi0PL3XLsxq1S0ml4Z8kxpx1n3t5jKqrPgqq8tmA/MtB5s7AROK1DSdPTQNZ6EAvsBdUYe4yLJFzvvogdXbBU2DK61ELG9UJHknQjXhR7B98HXOEopjzM2SNlGZj+pey9mktJFmo21YsNqRo8/YirzBGe11Cv8J748CAe0sa+DEIh12DsnnUNWeXYysja42Cmit/9cTtY1V89/KWCa7S4NN2U3P8LSx6vR4UHg2h4xuGCnuUaEuefrOsV1dLWVd6z5bfviJjZpBglXamMX1lsnuHHgH/D2EJg90vwp1BXwYL7SSyey7wVQznUR8NF1hJ67qolHtexI6XeHwsT/NOTdwjJyM4wK4gGSbEjt+D3R+1k91rttLUhmAL+6OERm8Sh35pKCEGjZ/kUgFO+0sCmOFVG1dz60xjsyIhzLNpgNdyXeHxXiB6w0GbgzvCkiPBYNXZA1wyd3JV+CMAzdsSdXr1PpaV/u/rG9T+wMdOhAaOcTS9x5xB3qgv2CVaVXAqpN0dQf+XSdxZvD0HQsopOIbmN0NgrOqlYKodd4jTPhc5DZW+DMzDlSzqa43g114ycFJGBXYZgGpnVN+doETO5Jp48
 yEO0TprP
 5ZUUys9wsHVCkps9cXy/XodC+zHo2Q22rRNEBrpgdQ8rbWwfX+LA2uiV0v32iHGwO+4fkQo7b4bHXvf0mA55hgxwdcY88bbdcSZtWhD4S1WwL2ILv4yq0xrxV0kLae/RLP4p9IeUh/6HwMbsk/8Udlo+lPmCMZo06xlhihjERliZuM/6owkRwJpG2cue3/ZrWS4X+aN2i93sL2ungvROeUzWijEp+Zu5g1NEPS5r4olfSKTO+ZFXbsJQ3qqbWE+p3SVJGt7zI9d+9BAC4jX6xysmg27Pl777lei4Hxy0wszppxZmGE64vP1zYJlCYtlBk/An0QK0Dddbr6MZ0PzrzdZmY50UQB8Bsnkb9IZClkkiuvbCFFZQHjDoR0BA2q9hHI99qq4TKd0TaQ022FhnaG1/5YiOUQdsBfcVj1/3FSH7bJqXc/xAamq0BTEo2khPRLcxnidyANmdHRfyX8qize4dY/pvwfSFqL+zDwF5D/93DYopjSV3jH0iT80pSO++2do21
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05-May-26 10:14 AM, Donet Tom wrote:
> Hi Bharata
> 
> On 5/4/26 11:39 AM, Bharata B Rao wrote:
>>   +/*
>> + * For memory tiering mode, if there are enough free pages (more than
>> + * enough watermark defined here) in fast memory node, to take full
>> + * advantage of fast memory capacity, all recently accessed slow
>> + * memory pages will be migrated to fast memory node without
>> + * considering hot threshold.
>> + */
>> +static bool pgdat_free_space_enough(struct pglist_data *pgdat)
>> +{
>> +    int z;
>> +    unsigned long enough_wmark;
>> +
>> +    enough_wmark = max(1UL * 1024 * 1024 * 1024 >> PAGE_SHIFT,
> 
> Just a thought—would it be better to use #define for these hardcoded values?

We could. It was a code movement, hence left it untouched.

Regards,
Bharata.

