Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E14DCA5FFC
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 16:10:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03FB16B0092; Tue,  6 Oct 2026 12:10:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F329B6B0093; Tue,  6 Oct 2026 12:10:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFA5E6B0095; Tue,  6 Oct 2026 12:10:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AE92D6B0092
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 12:10:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 147D11601F5
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 16:10:04 +0000 (UTC)
X-FDA: 85292687928.02.F52761E
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010029.outbound.protection.outlook.com [52.101.46.29])
	by imf26.hostedemail.com (Postfix) with ESMTP id EAB1A140010
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 16:10:00 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=1Rdmp2TF;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of DheerajKumar.Srivastava@amd.com designates 52.101.46.29 as permitted sender) smtp.mailfrom=DheerajKumar.Srivastava@amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791303001;
	b=z8QfyE0aSfQ5WyEyjKE4jAh1iVfjn2K67I9sf7bEBIVQ8wNbusSUFxciS9IM1o6Ih/0q7V
	3Sen2hAuaf4IpgO2HnuXwye7AtJ/Hb3XP9IvwoPy/mfrqRTxZ3tGlOWFBryVwEDEzRkTTO
	CzKVttPi4A4nsoXifawbgT4HMdiHYv8=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=1Rdmp2TF;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of DheerajKumar.Srivastava@amd.com designates 52.101.46.29 as permitted sender) smtp.mailfrom=DheerajKumar.Srivastava@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791303001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nA2NZW6KlB7vW3zwmThuYnEhQEnitc1FqIMQplJKEWg=;
	b=Q897cMitP2MeV6kwxTVLsC7mP5zS+PdTytrgeAl/6YWdqcErADeieWBZ9tayM2+m3EuIey
	+S7n5RLqJ+19BpHiYWK1n4gF/LhlBipVwchvKns6AKtvay9d8EeL+vcDxrptReeptgrtfy
	+6hV0Qx4DSp68pzO0IkhD1NbvUsijz8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R7AvLMsoAifK3Dlnl+S4KeHrwrnsKmtgiA8ATYVFJdCDVAB0x561PZzVnYGqkxJx/UCLR1H8VROoh8qEUNHt2BJ+tOYM2IHDLnbR2xGQ1hIpCRN/v0bL6Jpbg0ZCbiEn/JjdCfLqcdzYUXuVjY1yKEmWN2ul7MAgxt1XCoNbhfvsj4Xj1rBsfHPIb7IDBUGn7/4qXPMlPVi/Dg4AM1SmIapFqvD+nOyv8P72x7VbtraAS9vkKAxDIWBC7XUCY8HTKuLsu/2e/u2PpaPevblm8aRYdJ73hDK09F45EUZsiCwix6gK9cFklFy050/rIeaG6IIqdUe7ga16myAXokqSPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nA2NZW6KlB7vW3zwmThuYnEhQEnitc1FqIMQplJKEWg=;
 b=izEhO23fxoAMzNZcP+YM2XrMtIcVTzN4dq+V4DK9+AFATBuVvAUii07gxCMp0GfnyvC7pC1NbH3sn0w0F7SBcyY7nfotD9DnFOpaH7VDiaafIpnC9qy0pnmsMHnFowzcMJUsTtT6h7P+YDB02VhrOAZ9/Zfc9dHgWJYVkbz8yn6cAfVqkb6cZeGTe4zYJhbuWDPFIzApZxK6Xlx4/p590VyB3w3XWSdaoW5MCn7HzyNORZsPeOZ3ew88FVrjfj2RR5Ea9oKr2tvVKs3m3wLFtT/RPH6HflxHp5Kvx/wBT7HcDINgmB0CEi2Zb7kRIxTmXGCScJQvMKNpdgGoXhdzsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux.dev smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nA2NZW6KlB7vW3zwmThuYnEhQEnitc1FqIMQplJKEWg=;
 b=1Rdmp2TFFEJdFwGXCRBc4a7EzKs3akNtNFBLUyac+5TIWjTtdwTKf96x5m7HcgTDvMzVqFgI7tXyKIPy2SUBzuok+bIt7yHQUiqrvxhdtKNgXoEJi1k2IAYyTgHAiq0p4FVlh9oSofE1F3pmJf2X1CplS4CkBP6KrMp/DRFwiDk=
Received: from DM6PR06CA0094.namprd06.prod.outlook.com (2603:10b6:5:336::27)
 by DS6PR12MB534567.namprd12.prod.outlook.com (2603:10b6:8:498::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Tue, 6 Oct
 2026 16:09:54 +0000
Received: from BL6PEPF00022570.namprd02.prod.outlook.com
 (2603:10b6:5:336:cafe::40) by DM6PR06CA0094.outlook.office365.com
 (2603:10b6:5:336::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Tue, 6
 Oct 2026 16:09:54 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BL6PEPF00022570.mail.protection.outlook.com (10.167.249.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.14 via Frontend Transport; Tue, 6 Oct 2026 16:09:54 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 6 Oct
 2026 11:09:51 -0500
Received: from [10.252.201.245] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Tue, 6 Oct 2026 11:09:49 -0500
Message-ID: <023e73af-ebfd-4490-bf56-e91df10f7855@amd.com>
Date: Tue, 6 Oct 2026 21:39:48 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/hugetlb: use kvmalloc_objs for
 hugetlb_fault_mutex_table
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>,
	<akpm@linux-foundation.org>, <davidlohr@hp.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
CC: <Vasant.Hegde@amd.com>, <bharata@amd.com>
References: <20261006160128.31447-1-dheerajkumar.srivastava@amd.com>
Content-Language: en-US
From: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>
In-Reply-To: <20261006160128.31447-1-dheerajkumar.srivastava@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00022570:EE_|DS6PR12MB534567:EE_
X-MS-Office365-Filtering-Correlation-Id: c2577bc6-bc69-4c87-0d86-08df23c4426d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|36860700016|1800799024|376014|10067099003|56012099006|18002099003|11063799006|22082099003;
X-Microsoft-Antispam-Message-Info:
	knnqffqC+yVSbKMzx9fDDjGGjbFazaH0gRwd3Vv5/QXKwB5IjEXiqJWymrs2sjjQfEL88d6mIKLuOe6PqN3JuU2m6jrJ1bgsmJNmSysmTnRmfh8YFGrmgVpE7i2j1WD2RCBwDNYx6TDVXb2nXdAWCrQ3ocMrUpTXBDoZ+eP55nynDuoFrSI4IcPEwyKxcyvoW3Tg8BMLxmtKt9f+WM8ZThiBY4nRgZ2WgiQ33Ndwsge5LEqh6qAuSpzG3jKUiaKFpewG4QBualsfN3QufiOluHLOmbicU2e+3Jpr1Eicxq4jOsybg+o9u/2A5d5KfJMz9YnrmwKCl5gGQ0ReP2OG2+eKEmoF+S/KmDPOwjFQd8B9vpSeJ3cHD4/JWAkUC6Esxtg7HVU6Mi3KcwriTIk0cVBpUI+MpSc+4VtDTP1sKOt8cCAW19DaCuEbctmLEH5aMkJRlqwy+wWtSQhUMy3pmUr51Aa99kYNb6ZEpmeU7vxbIZhNAxLuKD3IIqWae1ZJt5M/Al4ZpXvLFt4lPhFprumCuLEIuCOo5ruFwczb9lIrgEqrP5ffXa72dPIqATW/Sfogs2JLaliOP9t1SqHeol+2g4+vv1zM4WyUAbQ7Sey4vrojJ5MBTziXXxXXHT6mrXvNaFO2JfaveEkOT7mGBusnOx4o0qrBuzG52SwV0pB0VkkiN1wBQkC6aX+FJjt0
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(36860700016)(1800799024)(376014)(10067099003)(56012099006)(18002099003)(11063799006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	pdeeT8PR2oDyVhRFS+Z05M+5+yxfqOHBmFa2t3qqa9jhePcDHN4T4Hnv6RGuj4R2ipP2fa+APTwUkcjwHL0nqRkEf8iVpfTKWJ+tNFZ/Pgf3cCG5UFO7TwkE+plKGdjFSsHfl2oMcLYJKoQ7nL80K+i4oibHIN0xABcD1q67sGP57Nnn6f0nFeExF9uUBhydtI9L1fnred9FPGoPmJmltYOEAx+zIoWgf//CJcNX0pr7ebirMzoxB5E1lmglVIwksHjDKILMKJbd6Sv/wV4cKPMQcUxkNClcT1dq1nv3yA3Vx+RTlFZv7TzlWVPhVtsXr74LOvFmZxxGAGfBlPBfOsWj0XYlR0c9jAMZnb+ZC5bHf9QDGTQupnhmHnXv5p1Glgz4RqNY21N5D0YTDp9oWRRiZ7X6mMsfHRQzFMx99c7xLQkVb0kz1YapUaYMLFdP
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2026 16:09:54.4457
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c2577bc6-bc69-4c87-0d86-08df23c4426d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022570.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS6PR12MB534567
X-Stat-Signature: 1b6akuayzgo9n16tpiod6rhh5i1uagfk
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EAB1A140010
X-HE-Tag: 1791303000-954863
X-HE-Meta: U2FsdGVkX1+dYQ7d1GYOVnfwbtK62oR56dknTakeCdVkq8FLENmX1OkOBH7YeYpFksfXsk+kVWxZEcjnqD5Atv7Wa/p8/vdz7EGvmF5Jj+pbLFoqqKkA6xZptiGXndHUZV0nAiPpnmwfrEjW4UjJKUrgrnz0sAncrCZNi7L2etnBF7g9H7/n9Hc988NqyvMvrUguDHLBgLjgFzdd22oEpb0LcoKPJ4tM60raAZURIC7sJuJS130hwgW32tAjwuBZbyC+rOvyYurfCwIwEOFAKpymFIwevbUbxAN8OFVCGFv5OZupMUxaNoC5yng9D7J3PRq8jNKus+gi/UScoTpsH4X1wmRNkl7yVwr9E2XMt0Ryf5RQUWrB0iedwiBPIl7MzvHb6F381Usgky6NYB/IFhnqkAzckCZMdWHGjayObLL3vEvx0p69EySQA4K3oCjx3eF0q0EsSFW081hhzKnfT42JIs8Hg2Bd10NN7ZgMFp4ZjRKNPmIhtk40kJ8yax5BHeRuyVdn1Vfphz3ranOupiuEds9+1udZyKCN/DbASbtd7BF2KfxOaumki95uAfc5WsrsuGqDgx7IM5eKIMtCMUuPkP0jc3mVNxiLla2n2GSROBIGih8MktXoIIiKTylYCHV6KAomMCQqzSV2mcHA32Y1Zrst8PdGoCUxsV9jJq3CNaLiBIsEpFv++5Uq3lDuuEHot9cmg3CD/VAs3RVayGKeZ8urXSRkixd+rdOJpqQ6AQC4PRlxpL1AbhKBKUMXcYyrlrA+RZKB8bd9689vadmz5J+X/0NMmdwPhBDWVi/EKUmCt9KYxZjPH5TlBTpQ/6gGgTKBswfn09MoKXdh/iu+Y0ykRRkUtQgyl2mKg4eJm81DhxUHH7miXmKXXBLQJEgnV3Nn6NS3LFgJog7PKr+nvoOtr0cjZpREhfdNX7IRrEj8LUFnquJarvjvZUc1++I34q9sAtj5YObFiLP
 kHcXztpb
 89xPLI2vxOGVhZqV9VHho6Y8U7zTSzB7VN1KVzncJtEa9qkSoCSwK3zzvobBEYjtqksCBiGVQrXK5QaSyE3uzjHCXOUshl4TV9CRHQ9+mSsuFX5vGTEirKRUbNYKuc4f1GA1EGpP7gbop3Lms0LZ20QEFvAhPjYI3woK4mQMLGkTAC+a4esrLf08CFaJsX4XQMya8h/R/evI7/kNa1tWMZMXvVXidegMgDQ81nLLfL2vM99L0a5cW+QR1P0bYEZglfh0p05PiT8JExGjqUXoV90JBreuD87YfP/gRcy19gYnzEbc6FS9mA8xMLN+n6IIe4V6CEH3WT1cJjIH/sxYd9n57olTsRiNRDplA5OkYpA0Yly/JdYK0wdVYFCK2MES54UHhV+Ffj/iqMyW5XM0f4kLUHeDOULldslccaxkGd1B1c4zlmyLgMrrmB1V/UCnH3MkYO9aa7uhETuXftwoXeQGr791yjxcvuhCKh5uY/ShSVG2UeacunzrZocwYBlITvVsLJQeJ+ZXhEws=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

On 10/6/2026 9:31 PM, Dheeraj Kumar Srivastava wrote:
> On systems/VMs with a large number of CPUs (e.g. 4096), hugetlb_init()
> computes num_fault_mutexes = roundup_pow_of_two(8 * num_possible_cpus())
> = 32768.  The subsequent kmalloc for the mutex table can exceed
> MAX_PAGE_ORDER when struct mutex is enlarged by debug options like
> CONFIG_DEBUG_MUTEXES and CONFIG_DEBUG_LOCK_ALLOC, resulting in:
> 
>    WARNING: at __alloc_frozen_pages_noprof (order > MAX_PAGE_ORDER)
>    kernel BUG at mm/hugetlb.c (BUG_ON(!hugetlb_fault_mutex_table))
>    Kernel panic - not syncing: Fatal exception
> 
> Switch to kvmalloc_objs() so the allocation falls back to vmalloc when
> the contiguous physical allocation is too large.  The table is only
> accessed by index, so virtual contiguity is sufficient.

Sorry, I forgot to include the "Changes since v1" change log.

Changes since v1:
-> Use kvmalloc_objs() instead of kvmalloc_array().

Thanks
Dheeraj

> 
> Fixes: 8382d914ebf7 ("mm, hugetlb: improve page-fault scalability")
> Signed-off-by: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>
> ---
>   mm/hugetlb.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index cea25773a6c9..6fc5c0bdb500 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -4177,7 +4177,7 @@ static int __init hugetlb_init(void)
>   	num_fault_mutexes = 1;
>   #endif
>   	hugetlb_fault_mutex_table =
> -		kmalloc_objs(struct mutex, num_fault_mutexes);
> +		kvmalloc_objs(struct mutex, num_fault_mutexes);
>   	BUG_ON(!hugetlb_fault_mutex_table);
>   
>   	for (i = 0; i < num_fault_mutexes; i++)


