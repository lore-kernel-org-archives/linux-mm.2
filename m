Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF7EEC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 12:08:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 953516B00DF; Wed,  2 Sep 2026 08:08:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92AC86B00E0; Wed,  2 Sep 2026 08:08:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8412C6B00E2; Wed,  2 Sep 2026 08:08:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 568FF6B00DF
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:08:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E73EC1C03FA
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:08:29 +0000 (UTC)
X-FDA: 85168699938.23.AA6C6B9
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012024.outbound.protection.outlook.com [52.101.48.24])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8A652180004
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:08:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=AwMYXeXw;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of nirmoyd@nvidia.com designates 52.101.48.24 as permitted sender) smtp.mailfrom=nirmoyd@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788350906;
	b=meUjvd9cJ6fjCp8TY8Wegibg1OUbcxDd3ZXXsLNCk0WDttLfX3R4+9NdyjIX6IyLNHaQKF
	A2zwGqKTTj9Ph+M/wYVls+PsmkP8D7ENwDzNbTov4YeYuRQ/c8l/v9YkJWieYw53o4it2K
	PcRN1DykmGQ1wzQBS59eGET8DlWnwWw=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=AwMYXeXw;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of nirmoyd@nvidia.com designates 52.101.48.24 as permitted sender) smtp.mailfrom=nirmoyd@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788350906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P62tv12/esgIhlkdePPtZgKrY9u5RVrNvnQsqTDM7UM=;
	b=W436wPH148yGSM1OwWHoPoTDskHU9fc48yEsNAHK+MHAR8iIVduQwPBUVTWLB940mF5N4K
	ad9CdxE8ccSdWpXyh6F7ObzjGeZgFwIU4tyJCfweI2IdwgfZi2bAdApfH6DSwfC7ZZo9je
	LRlPqa1zgms1tHhz8uxmOIbqzC8u/Qg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tiQ5b2YgdWiCQWWVsYK8goQ1zUWJ77hUbjXPRtH8MkC+fS5gtWbiWgS4EFZz/fMIOy2KM6jNcBtfFxrGUZHp+Ls2Vwa37KuyDBIyZcV6yiCasNrNeGnfXxP/RMzIwCD/lk1oi80tPSldZUERCrfddzbmHY+HgLF31IiWCa3YGy9bd3mII+c5oArNMnQbnoxaqz4SR8VSZp/n+smcDJpUb5Tzaekb3UJRz4KL7tVc6eLdOhtkeXguXCZYjVlypJryhn6tyGSr6TM1ki/dk2/2aV2cin26oFi4MWh7E39AGwkzMu9SeZzQg0TlNwcRAsoiS/MZdDd/yzHWoMmhZY+kyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P62tv12/esgIhlkdePPtZgKrY9u5RVrNvnQsqTDM7UM=;
 b=Kyft7WlPW5Q15pirDufCXw+gvTa7TraCyq1GiDh3CRrc7hhGJZmYFNLL37a5WA2hhlCUHhyEQ5BpPn0eHLeSF1b4RTtbpPEhOm9YNcOR3CgcZKlplySw6HgW4de1sfZRY5N23pN8ecNoCvBjTX0XHkAma/vlAsFeVwjnp3ItBojmQ3cm3I3D0J0bQ2kYkTGP+RkdMeVZBhrPebLpda0C7mJVBuql1MbeiBRW6XxuY5nMT6i+TRn//oZ6aCJFaT8pwjXkYnxzVLrzOEwhmrd+1VFyiKfio6PQatsZPjBiNd06fYbveVc910id4DgFGupImOV6QvLq7Qsa5Ie0CpCsew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P62tv12/esgIhlkdePPtZgKrY9u5RVrNvnQsqTDM7UM=;
 b=AwMYXeXwXJZb9DGsQyhB1fDXvz0rpwmT6Ajr6wMpG6KQcTyhFgz0SqgWLnVBgBPc8AjF7ke7SLx/7KwRGZ8jxPsMcV2veoWeKKVQC9T4H1Ze2XXiL+OwUQ7oGznJwGAFu997Ql/znSHNYlL4Xq78p/c8DMToP0jSRnQQnTVH6Y3owCH+f6mTArsgan2Q/EO4Kcs47oWpL92EPvVWgBrSAIRhzvJM5FQsnBqKRhJrIluXFJAboSniDsT3xQO7vm5u5owmUaQ9+viZ9De0lhVGVWTuj2M9HSM9TiGKzlkUE5b+SyGRF3/ONRSv2McpanVYiNT+5wkns7EAmPX3AT/ZNw==
Received: from BN9PR03CA0441.namprd03.prod.outlook.com (2603:10b6:408:113::26)
 by DS7PR12MB6287.namprd12.prod.outlook.com (2603:10b6:8:94::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Wed, 2 Sep
 2026 12:08:17 +0000
Received: from BN3PEPF0000B077.namprd04.prod.outlook.com
 (2603:10b6:408:113:cafe::75) by BN9PR03CA0441.outlook.office365.com
 (2603:10b6:408:113::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.11 via Frontend Transport; Wed, 2
 Sep 2026 12:08:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN3PEPF0000B077.mail.protection.outlook.com (10.167.243.122) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Wed, 2 Sep 2026 12:08:17 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 05:07:52 -0700
Received: from [10.221.136.89] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 05:07:47 -0700
Message-ID: <1aea4ef8-8cd3-4887-b0c6-ff748c548c77@nvidia.com>
Date: Wed, 2 Sep 2026 14:07:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: remove min_free_kbytes adjustment for THP
To: Nimrod Oren <noren@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
	<usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Vlastimil Babka
	<vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
	<surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
	<brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, "Hugh
 Dickins" <hughd@google.com>, Dragos Tatulea <dtatulea@nvidia.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
References: <20260901190123.3511535-1-noren@nvidia.com>
Content-Language: en-US
From: Nirmoy Das <nirmoyd@nvidia.com>
In-Reply-To: <20260901190123.3511535-1-noren@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B077:EE_|DS7PR12MB6287:EE_
X-MS-Office365-Filtering-Correlation-Id: 97c9a0c5-4147-42de-7c99-08df08eadf86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|82310400026|36860700016|1800799024|11063799006|10067099003|22082099003|18002099003|56012099006|13003099007;
X-Microsoft-Antispam-Message-Info:
	fISVyAnZGwpJr0me1xOokn11dORaWzNT2Lo8B3EXN0JdIduwLbnP4DXOJSpBMl1AkC69cDtVQf9JWJQxppWD9CkUy58+AP3xWtgyfwj6OBC7PPTAkTg801FA5S+vxtyK7RSukNT4mxvTFZpuvXhaU7aMCV6pBb2ho79Jr+GwA3N/uILUSyPuoAtb7/WcC7tgXGl+DoyOWv1E3LTHHsmYKbEjISs1+KONk9XlLz/AO9xK6COU6QGg4QSeY33E4kGUVKdEX3xERnQn6wGXlYKmXPxMFuV6WjoGExDXJuHALeTAOUrv/JixMr0Xwo45CVpRH2YdtnorgEZL73zFknLDmeVU8nbRbwWjPfJ37ZFDGTpAyAVBRAMeviZSESx0/3OY3igWydWK6MnkQm7h1cRcv2prxPlawHXVGXsHcJozynjIYdBVM7U3EDCEfQ+5zcbvTmWXttiTJsbkVg/0H2NfuVbrTETEZSywLcVCqDWDRaTp9GbPAQ24NsS75f1a0Xw4yqYrPJ/fEc0tjxmNRzkPpuv5LR7romEYfwhfiKAKlNdSxG0kmFnEECiYCfkU2PXNFe9m3rwB7ELkxJ2/5ZmLJZY5qx+x15/sDKK0tPXYtJowigOtaNaP7xswSwNwCfv2gk6vYRnKljDk8jseFdYB/MCmI307WhuNtSBtEl7On4jaCqiPZtrjKp73N/7T1knMKCz/YunflgQ4kMTeYx20Ow==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(82310400026)(36860700016)(1800799024)(11063799006)(10067099003)(22082099003)(18002099003)(56012099006)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	PC9j33FhZJACyUkg7fkKWI4rRR9Zbjo6ozdNj5rJZ//yiycovOGCYlKWt4aG+8mE2lWiZcUtnWphVkfUPut8bp+zop6zQzhUIO+Z4KY2PvV5mucTOC489fIw/Wwzm5aqVtoExdr6fIQr1JZfeVkTI6H1fdQzjAlEarzJYxSJVRYVhpxMvZR/1Ecze4rQMZxIEfwe9/ufsjiShWcHkq+BLXdNvtXCXKh67ChjPtacQ30xmA+SfltrGCg3HiokIN7njO8q6s7o1NJLGUwxdi03tgRLk6IYvK5Q+nSx3ZuKXaeqNZi8lLr+RD5d8EV1+AsyqYFfOeoOJxxQ1c4VG3hsw/eBdKRKHy9qKtt3kQh36BtzjK459qYkERYo5K2l5g5FolDShsIFbdGIoeBEn7VVHQmjpl1XPObNDNhh0cAhIVadcg5f8sp6+0WaJNnsv30u
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 12:08:17.3488
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 97c9a0c5-4147-42de-7c99-08df08eadf86
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B077.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6287
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8A652180004
X-Stat-Signature: 9e51g1g51sw7rqoje6d9s5z1n5dx76uq
X-Rspam-User: 
X-HE-Tag: 1788350906-302532
X-HE-Meta: U2FsdGVkX1+lrXosT2SDOc/twz3jLCCqXDicKXVLA2n2s/DQOyefLKWbis3cU8AYQ/klX0Bf1pH4OTwd1uQDnF7RJFgPdDUcG2JmVeFgHlcZz2Xm8BNKbwpvKmhfd271mFOvxRflooZ3L+BfhicdmLUJ5rKsZt0rYs3GndFcsm6xMu7gRiMvOHrsjdK446hUVnMPSK2qUneBShLlBQPardFsM2JAbe1Er0Zo6M9vCxQlDn7d7c6798RBOFCrUGvEcooo0hTN9JXifJ8xQHNjPki/c8+FFGHUc20X2QTbrmGQDmHXBK3/4PjuHt4REUebTnlD7NrKSl2gurDSy041qbJb0SxXzZ67ylZ7QwsIlrAssTHugKoP2a0LwCljJBago8L8spxoqnsgUX2qm6QUWQBis89OOqmf8rpG/afJS/4pcjQycGE05mP1X9o8HzLRvMGDOf/WuvG6vYcKlESLNb4//ir576BS0zaGYwPAxoSxr4ot4BUEA8ShZyovYRG7Yccvb9/+GnOV5gS6eRFFDL9lNvnX81pVRYTNAz5nf75wnUFxTAkHybVIq4oF2gJXZnitXieHrah1j/2AFH1v+YFhZLx5dGn+WJUnKB1ovvosJA21vpjGJ9eDpJ3IhZDcWNG3ZmHrSb76yMCiemdyQVK6OwpHtzGj3Gvzk7JbNm1BECE7A6jV//rfILrdvzK0cYDqh8QVBOBayWCHcPBSR1dMQeaRgGijqItWvxdg80TOaJWvzrjpvgBDNIo0nuqnM+pxSe1I0Aij99rY0LyPL8G5S2xrOVfhu6byX3zQ3iClfPFXzN9jXwUYBR2ozbMjTAEjQHBw71sQbLOr7wg2dWhq7RtARmdsPk6YXYkvbtzKdVE5CknahzC0++qft1fKjcTQTikcLktdWcqG/KoiOw3f6RtT6YBL1XkVXXSLNlu6PNERZ59s/mbyseiekObkX74lEOzI/M04BzncXPz
 7gvTzrnP
 laXdxDVwYKCwR6DxPauGKCSOHqk3UzOjF8CHCPept2T8B7rZvg+voN7SFWPhGASHHCawovt1kfv2NXLyxjYbzotT1igOMBwoo8DJla0Kzb99vMOBjazNzcjuxzgm4/s9qvuPnA00yEW4LDVc9iS4AEMCdNRXMxV1uwiv9TS1I9PpD/jjIC4yiJ1Ur7YMw7z9giUMXm5xRy0COBgt6FgkBG3ROqzzc3KKZrnYF6YbInsj8qZGoIWbVAeSmvBD78Rh60i7F5TRRLQyNU+8afx0+5dxPBP5sYdeNe1eImsUStItpThO07q5x51W4sjEyggJbKhqTKsXHsHaDz8ZGvYLoiHTiIMQA52p0hfOvSrMldqAt3h48Mn+mCeog+Le7lRJDh06MfXZoUEM/Q+ZsFmffXynY8MpvRIFyzr1iuD8XC4za+3/v0bJ302sgykTR91YDnBSKa3SB1uSOKshCU4vD2WjII7dCbHFVmwspXP4i7ZuHUetYIIpeWiQu8yRV/5BNUvtNp+KneXwdwpuvKt5ci6Ke+sQWxfoVCgtO+W8tlNvsI/h2GAQudfNp9SXIr7/o72NpB8hJeotoOCUD+57KXjFphM0vtg+4d9c/YGTYAtzYERM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 01.09.26 21:01, Nimrod Oren wrote:
> When THP is enabled, set_recommended_min_free_kbytes() may raise
> min_free_kbytes using a heuristic that scales with pageblock_nr_pages.
> Commit f000565adb77 ("thp: set recommended min free kbytes") added this
> heuristic to help keep pageblocks free and reduce fragmentation for THP
> allocations.
>
> The recommendation scales poorly with larger base page sizes. With the
> default arm64 pageblock sizes, the contribution per eligible zone
> before applying the existing cap of 5% of low memory is:
>
>    4 KiB pages:   2 MiB pageblock,   22 MiB per zone
>   16 KiB pages:  32 MiB pageblock,  352 MiB per zone
>   64 KiB pages: 512 MiB pageblock,  5.5 GiB per zone
>
> Even with that cap, min_free_kbytes can reach excessive levels.
>
> The automatic min_free_kbytes increase predates proactive compaction
> and many subsequent changes to compaction. Given those changes,
> increasing min_free_kbytes for THP by default is no longer clearly
> justified.
>
> Remove set_recommended_min_free_kbytes() and all associated
> recalculation paths. With this policy gone, min_free_kbytes is
> controlled only by the page allocator's default calculation and the
> vm.min_free_kbytes sysctl. Users who want additional headroom may set a
> higher value via that sysctl.
>
> Link: https://lore.kernel.org/r/20260831075635.2244437-1-noren@nvidia.com/
> Suggested-by: Michal Hocko <mhocko@suse.com>
> Signed-off-by: Nimrod Oren <noren@nvidia.com>

Tested this on Grace.

Tested-by: Nirmoy Das <nirmoyd@nvidia.com>

> ---
> v3:
> * Replace the 1 GiB cap with removal of the THP-driven min_free_kbytes
>    increase as suggested by Michal.
> * Remove all associated recalculation paths.
> * Make min_free_kbytes, user_min_free_kbytes,
>    calculate_min_free_kbytes(), and setup_per_zone_wmarks() static.
> * Drop the now-unused declarations and khugepaged's page_alloc.h include.
> * Drop the obsolete v2 documentation addition.
>
> v2:
> * Use a named constant for the cap.
> * Drop explicit linux/sizes.h include.
> * Update min_free_kbytes documentation.
> https://lore.kernel.org/r/20260831075635.2244437-1-noren@nvidia.com/
>
> v1:
> * Cap the final recommendation at 1 GiB as suggested by Lorenzo.
> https://lore.kernel.org/r/20260728202014.2517142-1-noren@nvidia.com/
>
> RFC v1:
> https://lore.kernel.org/r/20260716173504.760369-1-noren@nvidia.com/
> ---
>   include/linux/khugepaged.h |  5 ----
>   mm/huge_memory.c           | 14 ---------
>   mm/internal.h              |  8 -----
>   mm/khugepaged.c            | 60 --------------------------------------
>   mm/page_alloc.c            | 11 +++----
>   mm/page_alloc.h            |  2 --
>   mm/shmem.c                 |  7 -----
>   7 files changed, 4 insertions(+), 103 deletions(-)
>
> diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
> index d7a9053ff4fe..e2a2ccb6cd05 100644
> --- a/include/linux/khugepaged.h
> +++ b/include/linux/khugepaged.h
> @@ -15,7 +15,6 @@ extern void __khugepaged_enter(struct mm_struct *mm);
>   extern void __khugepaged_exit(struct mm_struct *mm);
>   extern void khugepaged_enter_vma(struct vm_area_struct *vma,
>   				 vm_flags_t vm_flags);
> -extern void khugepaged_min_free_kbytes_update(void);
>   extern bool current_is_khugepaged(void);
>   void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
>   		bool install_pmd);
> @@ -47,10 +46,6 @@ static inline void collapse_pte_mapped_thp(struct mm_struct *mm,
>   {
>   }
>   
> -static inline void khugepaged_min_free_kbytes_update(void)
> -{
> -}
> -
>   static inline bool current_is_khugepaged(void)
>   {
>   	return false;
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index c5d11147b69a..b1f87e005e03 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -499,13 +499,6 @@ static ssize_t enabled_store(struct kobject *kobj,
>   
>   		if (err)
>   			return err;
> -	} else {
> -		/*
> -		 * Recalculate watermarks even when the mode didn't
> -		 * change, as the previous code always called
> -		 * start_stop_khugepaged() which does this internally.
> -		 */
> -		set_recommended_min_free_kbytes();
>   	}
>   	return count;
>   }
> @@ -735,13 +728,6 @@ static ssize_t anon_enabled_store(struct kobject *kobj,
>   
>   		if (err)
>   			return err;
> -	} else {
> -		/*
> -		 * Recalculate watermarks even when the mode didn't
> -		 * change, as the previous code always called
> -		 * start_stop_khugepaged() which does this internally.
> -		 */
> -		set_recommended_min_free_kbytes();
>   	}
>   
>   	return count;
> diff --git a/mm/internal.h b/mm/internal.h
> index e16f1250b25c..6890d7836c68 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -689,11 +689,6 @@ int user_proactive_reclaim(char *buf,
>    */
>   pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address);
>   
> -/*
> - * in mm/khugepaged.c
> - */
> -void set_recommended_min_free_kbytes(void);
> -
>   /*
>    * in mm/page_alloc.c
>    */
> @@ -701,11 +696,8 @@ void set_recommended_min_free_kbytes(void);
>   
>   extern char * const zone_names[MAX_NR_ZONES];
>   
> -extern int min_free_kbytes;
>   extern int defrag_mode;
>   
> -void setup_per_zone_wmarks(void);
> -void calculate_min_free_kbytes(void);
>   int __meminit init_per_zone_wmark_min(void);
>   
>   extern int __isolate_free_page(struct page *page, unsigned int order);
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index f49a6710933b..c36b7d0b91d7 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -27,7 +27,6 @@
>   
>   #include <asm/tlb.h>
>   #include "internal.h"
> -#include "page_alloc.h"
>   #include "mm_slot.h"
>   
>   enum scan_result {
> @@ -3086,57 +3085,6 @@ static int khugepaged(void *none)
>   	return 0;
>   }
>   
> -void set_recommended_min_free_kbytes(void)
> -{
> -	struct zone *zone;
> -	int nr_zones = 0;
> -	unsigned long recommended_min;
> -
> -	if (!hugepage_enabled()) {
> -		calculate_min_free_kbytes();
> -		goto update_wmarks;
> -	}
> -
> -	for_each_populated_zone(zone) {
> -		/*
> -		 * We don't need to worry about fragmentation of
> -		 * ZONE_MOVABLE since it only has movable pages.
> -		 */
> -		if (zone_idx(zone) > gfp_zone(GFP_USER))
> -			continue;
> -
> -		nr_zones++;
> -	}
> -
> -	/* Ensure 2 pageblocks are free to assist fragmentation avoidance */
> -	recommended_min = pageblock_nr_pages * nr_zones * 2;
> -
> -	/*
> -	 * Make sure that on average at least two pageblocks are almost free
> -	 * of another type, one for a migratetype to fall back to and a
> -	 * second to avoid subsequent fallbacks of other types There are 3
> -	 * MIGRATE_TYPES we care about.
> -	 */
> -	recommended_min += pageblock_nr_pages * nr_zones *
> -			   MIGRATE_PCPTYPES * MIGRATE_PCPTYPES;
> -
> -	/* don't ever allow to reserve more than 5% of the lowmem */
> -	recommended_min = min(recommended_min,
> -			      (unsigned long) nr_free_buffer_pages() / 20);
> -	recommended_min <<= (PAGE_SHIFT-10);
> -
> -	if (recommended_min > min_free_kbytes) {
> -		if (user_min_free_kbytes >= 0)
> -			pr_info_ratelimited("raising min_free_kbytes from %d to %lu to help transparent hugepage allocations\n",
> -					    min_free_kbytes, recommended_min);
> -
> -		min_free_kbytes = recommended_min;
> -	}
> -
> -update_wmarks:
> -	setup_per_zone_wmarks();
> -}
> -
>   int start_stop_khugepaged(void)
>   {
>   	guard(mutex)(&khugepaged_mutex);
> @@ -3160,17 +3108,9 @@ int start_stop_khugepaged(void)
>   		kthread_stop(khugepaged_thread);
>   		khugepaged_thread = NULL;
>   	}
> -	set_recommended_min_free_kbytes();
>   	return 0;
>   }
>   
> -void khugepaged_min_free_kbytes_update(void)
> -{
> -	guard(mutex)(&khugepaged_mutex);
> -	if (hugepage_enabled() && khugepaged_thread)
> -		set_recommended_min_free_kbytes();
> -}
> -
>   bool current_is_khugepaged(void)
>   {
>   	return kthread_func(current) == khugepaged;
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index c4dc61ec663e..5280784c91a8 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -50,7 +50,6 @@
>   #include <linux/ftrace.h>
>   #include <linux/lockdep.h>
>   #include <linux/psi.h>
> -#include <linux/khugepaged.h>
>   #include <linux/delayacct.h>
>   #include <linux/cacheinfo.h>
>   #include <linux/pgalloc_tag.h>
> @@ -272,8 +271,8 @@ const char * const migratetype_names[MIGRATE_TYPES] = {
>   #endif
>   };
>   
> -int min_free_kbytes = 1024;
> -int user_min_free_kbytes = -1;
> +static int min_free_kbytes = 1024;
> +static int user_min_free_kbytes = -1;
>   static int watermark_boost_factor __read_mostly = 15000;
>   static int watermark_scale_factor = 10;
>   int defrag_mode;
> @@ -6663,7 +6662,7 @@ static void __setup_per_zone_wmarks(void)
>    * Ensures that the watermark[min,low,high] values for each zone are set
>    * correctly with respect to min_free_kbytes.
>    */
> -void setup_per_zone_wmarks(void)
> +static void setup_per_zone_wmarks(void)
>   {
>   	struct zone *zone;
>   	static DEFINE_SPINLOCK(lock);
> @@ -6704,7 +6703,7 @@ void setup_per_zone_wmarks(void)
>    * 8192MB:	11584k
>    * 16384MB:	16384k
>    */
> -void calculate_min_free_kbytes(void)
> +static void calculate_min_free_kbytes(void)
>   {
>   	unsigned long lowmem_kbytes;
>   	int new_min_free_kbytes;
> @@ -6732,8 +6731,6 @@ int __meminit init_per_zone_wmark_min(void)
>   	setup_min_slab_ratio();
>   #endif
>   
> -	khugepaged_min_free_kbytes_update();
> -
>   	return 0;
>   }
>   postcore_initcall(init_per_zone_wmark_min)
> diff --git a/mm/page_alloc.h b/mm/page_alloc.h
> index b9259deddb59..86162e6cfa8c 100644
> --- a/mm/page_alloc.h
> +++ b/mm/page_alloc.h
> @@ -227,8 +227,6 @@ void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags,
>   		     unsigned int alloc_flags);
>   extern bool free_pages_prepare(struct page *page, unsigned int order);
>   
> -extern int user_min_free_kbytes;
> -
>   struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order, int nid,
>   		nodemask_t *nodemask, unsigned int alloc_flags);
>   #define __alloc_frozen_pages(...) \
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 255d69ebceba..92dc770b10e6 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -5782,13 +5782,6 @@ static ssize_t thpsize_shmem_enabled_store(struct kobject *kobj,
>   		int err = start_stop_khugepaged();
>   		if (err)
>   			return err;
> -	} else {
> -		/*
> -		 * Recalculate watermarks even when the mode hasn't changed
> -		 * to preserve the legacy behavior, as this is always called
> -		 * inside start_stop_khugepaged().
> -		 */
> -		set_recommended_min_free_kbytes();
>   	}
>   
>   	return count;

