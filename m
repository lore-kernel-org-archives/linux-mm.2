Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FC59C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:09:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5378E6B00A1; Mon,  3 Aug 2026 09:09:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50F296B00A4; Mon,  3 Aug 2026 09:09:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 426676B00A5; Mon,  3 Aug 2026 09:09:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1956F6B00A1
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:09:45 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7D5E68061C
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:23:46 +0000 (UTC)
X-FDA: 85059269652.09.EE046FA
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012001.outbound.protection.outlook.com [52.101.48.1])
	by imf29.hostedemail.com (Postfix) with ESMTP id 359F1120004
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:23:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="uG/BdIy9";
	spf=pass (imf29.hostedemail.com: domain of bharata@amd.com designates 52.101.48.1 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785745423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0qQ0QMoazQtmJ12GXLKs5HklsWGQs1G3r0tx74BSWkQ=;
	b=1Upl/KrkNmpzoUg1rrT3vSoMi6Vp+v9lf8s0T6f20w7xeix3fU2kcxalURo6Lzw8i0vXfe
	Ymk+IEXz8yMZ1SRQsWgP5kEIyCod5cwKhjSvPrwi5pIxsbvXRt4pZhVvWmuZBNOLZG4Vvy
	sLk2fjc7cuobFNiHskE46GEwKIAUMk0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785745423;
	b=AmZpG9fXtu5Zy+iwf/lKFy34NubjClE3TXDYESati7TSVIi2LWGbTgOdR3DEZzsgrgy4B3
	BpBHjE4IChPUnhBSUYMfCrW9kUXJPKjX0H6MHBH7aTuq3cLtruqZtmucw9S6ZbWmVjiCW3
	PYX1D0TnLrI6LX74j6qdVqaYGgXCrH0=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="uG/BdIy9";
	spf=pass (imf29.hostedemail.com: domain of bharata@amd.com designates 52.101.48.1 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DCNW1BXBSGUWetnuFnuwMnR4AXwd7No5NejO37Wj5d8JbbFSrfuz3hkN1cCBOoxWRdqU+6bTSro7zOXFq/4cHQwGgd0z59k3L5n6bYV4YHgtu/4tJsgWD/HSKaAh3kmaluEB72Wi9y4C9bQ+rMLM+Q1DXrxRM9Hn3SFc9A2EPh3SG52nDj+hVECbOTznRlqc09r/6PP0jTmCwTonZ4yfn93uy/bu60bmYXjUc3LDfJghFAdHyz3v0a1gVFn0Hty7wIR+6Xee2IGeqCpcMp3GNCRh4OoL/qwkGtjFq+35Cp1tuFpCZQr5sGZ+mIZHZHexVyN9GlAsF4E8zmTr2DExPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0qQ0QMoazQtmJ12GXLKs5HklsWGQs1G3r0tx74BSWkQ=;
 b=ySC6jxZYnSmCH6gyw023t9d6OyO9q95wU4nkGg+lng3Ji9i/a70EZWvTlmYWfQ6mnuzRtaL0UaeqJCNf674e7tsdCh+Hi0SI+2nn5mApsyGjy8yDkmmDstzHPGhhocT6dfL1hb8sorpECydk6GX3rUIXHsyGKOhdGEfWHbMrPx8VL1x1McPTltssTBKd3nFKif61TGyElxdIuUuzPleBd1gF2oZn2NUMjFX0RZ/2reDLVal1pZh+OM0EYeZ3bwF9HFdXIAU68iEqd3imMCGAzzggCMPfVEx8OgnUyA9dUo6bgdsfcts/W0mEYTJTZD088t99jckXLF1Eh+7BWvVgjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0qQ0QMoazQtmJ12GXLKs5HklsWGQs1G3r0tx74BSWkQ=;
 b=uG/BdIy9YmaJkAbpD/jtXyJLTHWfFIU8PKBu8po85cAVBaGMrPKIc/mgfd7wUHU9/Bl9iUN2fjsnT8zREzdg41wubxzQd8rPY4J5jA0RNhkW5gmS3YzeCAxeaeqYxfYwpTyxO6CKc8SaMsyNWWsSzHej3KFUvQxpnVKIuoBe6P8=
Received: from PH0P220CA0003.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:d3::12)
 by IA0PR12MB8350.namprd12.prod.outlook.com (2603:10b6:208:40d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.17; Mon, 3 Aug
 2026 08:23:31 +0000
Received: from SA2PEPF0000150B.namprd04.prod.outlook.com
 (2603:10b6:510:d3:cafe::17) by PH0P220CA0003.outlook.office365.com
 (2603:10b6:510:d3::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.17 via Frontend Transport; Mon, 3
 Aug 2026 08:23:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SA2PEPF0000150B.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Mon, 3 Aug 2026 08:23:30 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 3 Aug
 2026 03:23:29 -0500
Received: from [172.31.176.217] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Mon, 3 Aug 2026 03:23:22 -0500
Message-ID: <169e55f3-1b39-43fa-b844-747d128e16b1@amd.com>
Date: Mon, 3 Aug 2026 13:53:21 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 5/8] mm: sched: move NUMA balancing tiering promotion
 to pghot
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <sj@kernel.org>, <weixugc@google.com>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
	<dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
	<yiannis@zptcorp.com>, <akpm@linux-foundation.org>, <david@kernel.org>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<shivankg@amd.com>, <donettom@linux.ibm.com>
References: <20260728054356.291998-1-bharata@amd.com>
 <20260728054356.291998-6-bharata@amd.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <20260728054356.291998-6-bharata@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF0000150B:EE_|IA0PR12MB8350:EE_
X-MS-Office365-Filtering-Correlation-Id: 00201cf4-f2f8-44db-6196-08def138801b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|23010399003|36860700016|18002099003|22082099003|56012099006|11063799006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	uYCP0IEm94JvcgIOWWhtno45L51hXbm785EQAywCI4raxSDfFHplX2WMKa+kovCXYhu636njuSfWL72ddMgW+/6tgIjAAl9SVbC8S2u9VgdfWzhuRiRzLLipfOtm9ty6/Lgwirq8E0kXSYNojvRsRFsjsCPp3NpatFeTG4mI2DNa0o8+/WllwL9ZnPqQF8Q4i6ahtox8bpqxNvYztpMSs1JzOP7GBB4K8gc2fq9GljnqG5RI+0uGTC7ac1FQmd/eqtYDxhOvcNx+XRNw6aaCwU7SzzsGMliCrHj4HoLC5I6PkUIqb5JhjkYN8QKEalL+RsP2KCc3ERpAvcgBpCh2fRjX/StR8NMfPDjc+KLyv8K/rt/HJnCboTAjofML2cvrByB1cDnqAj2BUNs0OCnDFWoAV2kXF4lejBgHpBmM2LbKi8tp2+Khg+tHOTdPwh9bjKsBL2SPeAYsoS4PPMKKl37zAl9AuzbwIM6J/dLNFulVa6j/FfaPXsilfe3Zce7y1QlPV82l5+M9CGa43iMKavXDX7mgbgqqmgcXAUeKimv+DtKPvDo92PGyWdhgDuc5bVG5IpvdMSxlgkQ/WHT5EtirD5ZilIseeQSePNCa69KiNwkNpRfg07CtUvnrW+JpOt5uB7ce4IQbJ5LmiZsRWG4R1zKMtQgn0RbHSQl6ALOObKbdQjeOJih95b7oqli06zeg1dn2C6k0a2656RwzoQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(23010399003)(36860700016)(18002099003)(22082099003)(56012099006)(11063799006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+zceC5/tYOYtUEq3jPXam4OQGtxxGzIIxAozfBgMN9Kx1dWxlcJHYAslePLHMHaIVk5e9za9wBPQwaAehPRVb8Y+k+m4pUTMtnuYt8NPGYHkvcHaxpnNNQo9vnBWbuxqfD1BfxIykq3f94QzvDoqSUINlS1+yqNMd6dp0mZ788ESK/5/L+Q7gAZGnCQgCT5WKrMu5Ol71YzfSQQ5FNb5jXx+o7iGpbHcHBab+PF30MCOUT0B8u41VmcRTaPW2S52fFV8fQJoMPvh4w6J7k2gnJ51nEgmrYj+zZhgOIW0afGH4X9B6gAYuLywG7cxgF4qqlupyGJ5N9EUTQbbcT8sI+iocNEoUREdbNxRWfE2HT0vvkbPddyufeRORvjpoGsTRt9TrCW0iR/GSf+IkEwC7XrtCu4+XpxSXpJaayiafXG/rbrqwKNbwsgDFT24Wt+G
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 08:23:30.2220
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 00201cf4-f2f8-44db-6196-08def138801b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF0000150B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8350
X-Rspamd-Queue-Id: 359F1120004
X-Stat-Signature: az6b5ikddfsoxnkkgzpohtm974z38gyu
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785745423-528376
X-HE-Meta: U2FsdGVkX1+3TrKPzLkSe8C26x6RzREAM/X4v3g7qfjPT77NRthVmU0Yk98zJorUw7W9JuN8XENBHLluzVAV7GQXT5mKUyruz56C7zY+ZDbCcoLqhVSp+Z/929LA5xdcFndoGKJnJ0Wx5HHDHT1fb4J2KDEnJsow2bde2zdUDVD+qAaAgM+f0V0zFNC+P5Tc2s035SlzM8ecEzQUXT4MEfJQn8Xuh5BpJitQm4XEVircFyjLNaVpung8xIshDuQqsV2CS4kUL1Q/zRGW3Me8HI/4wJdfuR7vJVK/wVyPihIlZehqccJmI3nJX3CAMnobeNQJZDmBvkLH3Cs4X24HL1n+Ovqqj3HGCTr8fAnWxS4scevjCiyEF7jVaF+6HFu0S0kKFpmCblWcsgTnw/gcy9QH9IOvwZiYcC6R/Txla4mb3mw5gJVuAXr0Enj9zbnAcGWHUrNpiLCyL4WokU5WINbj6jubarBX3GaGLEzmqkHSjqk/D5Z4NpSCohXeldEivkhUU8tixW3+ffdRCwQa4wOtbeb2v5aGQFceU0jlGAnHtqjQU6dEE8azOOcpnG5i9kibGBqusu72MPhuXUN99g6EATxjd0fyfNPd7DCmsuFi0oRVKtMv6zj3k603OQ6cUsjwYKFEQ+2orSrk0PUEBQTCCQnt/SfquXGK/c66bl7AWzvLUeasRCykgSIWDnELAmlyIFty3nR7rnMuHTSVwac31qXtCbBc5JXM35D8dMN28ciEuTfgmAeNmMu8tMAyEI3Wj7Zu1bcjTGnRpcBAh5RoVMcq+ATsJIzPnBu8lUJ8CqfwIfFGYt6OVR66kruOyl+Gux/nMhARinSHbQq0UeABOhBEIpJMuq0dImX0fGRuj6lT9zKE/aYqdog0IMLCkE8Ff1bfsRJsXOsrdbgxg4Dr3kIojWtx9hGO95zjudb3u9zHNp1CVFQD+aXOWkO1VI51sQ1uQM67TWxZuB7
 wqhHrqpv
 aj5txh19R9mj7ujaElHx4igqzK1YdodfhNbmPG/v+UaAQZDarc4K9FsAbpfOPeu7fL42mjcIXSvkT/hQe33IdBgeLdwho8xnsqGQT8FFIj17lVc+Y7vIxpyKwkC40k0CrQfIcp3RHS1WBk2wvgvNfCCIJbIlATriXDGitKsa2AAURX1A/dkKnHoEckjHSEgOQuiPjXdwlkVYNFeySoyRF+GcaNs+LkooBWgXd7GLMmNUL557zY6UkXd9T3W6pa+MLTpxE4oqAPHgovNCgk2sYusZSSpwZA+qDygKBbk2+61ZDlMJRgktbxS/qJnQXi1vWDebRhmwSSQm6q6e1vw/bqLtciSrPxvDCoqjOaKpqq+ShaclAhtmBddvE9ZfsswcxSHNpm9TXEKPWZ+ozeZK4LZUXm9mpcFXH8N5Yt4wj2mb1LJRI5l0fskN/mL1rf6w/hId8maEWx9n3gBu+gas4pFM3tpF5Agoi45bvY7gL2qewjJw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[Reply to Shashiko review]

On 28-Jul-26 11:13 AM, Bharata B Rao wrote:
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 2bccb0a53a0a..c36092ebca42 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -41,6 +41,7 @@
>  #include <linux/pgalloc.h>
>  #include <linux/pgalloc_tag.h>
>  #include <linux/pagewalk.h>
> +#include <linux/pghot.h>
>  
>  #include <asm/tlb.h>
>  #include "internal.h"
> @@ -2205,7 +2206,7 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
>  	int nid = NUMA_NO_NODE;
>  	int target_nid, last_cpupid;
>  	pmd_t pmd, old_pmd;
> -	bool writable = false;
> +	bool writable = false, needs_promotion = false;
>  	int flags = 0;
>  
>  	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
> @@ -2232,11 +2233,29 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
>  		goto out_map;
>  
>  	nid = folio_nid(folio);
> +	needs_promotion = folio_is_promo_candidate(folio);
>  
>  	target_nid = numa_migrate_check(folio, vmf, haddr, &flags, writable,
>  					&last_cpupid);
>  	if (target_nid == NUMA_NO_NODE)
>  		goto out_map;
> +
> +	if (needs_promotion) {
> +		/*
> +		 * Hot page promotion, mode=NUMA_BALANCING_MEMORY_TIERING.
> +		 *
> +		 * Isolation and migration are handled by pghot. Since VMA
> +		 * won't be available to kmigrated which does batched migration
> +		 * from non-process context, filter shared EXEC pages here itself.
> +		 */
> +		if ((vma->vm_flags & VM_EXEC) && folio_maybe_mapped_shared(folio))
> +			nid = NUMA_NO_NODE;
> +		else
> +			nid = target_nid;
> +		goto out_map;
> +	}

> Does this drop NUMA fault statistics for shared EXEC pages?
>
> If nid is set to NUMA_NO_NODE here, the out_map path skips task_numa_fault()
> entirely, which seems like it would disrupt scan-period adjustment.

It does drop the call to task_numa_fault() for shared EXEC pages but then
base kernel also has a memory-tiering gate that resulted in shared EXEC pages
not being considered for scan period updates. So this doesn't really drop the
NUMA fault stats for shared exec pages. However I can make it structurally
similar to base so that it is the memory-tiering gate that rejects the
scan period update for shared exec pages.

> Additionally, for non-shared pages, nid is set to target_nid, which might
> prematurely account the fault to the target node before the migration actually
> happens.

Accounting the fault to target node is deliberate here because in pghot the
promotion is delegated to kmigrated. So reporting mem_node=target_nid (top tier)
is what feeds the scan period update in task_numa_fault(). Since pghot does
async migration, it feeds all promo candidates rather than only the successfully
migrated ones like in base.

> diff --git a/mm/memory.c b/mm/memory.c
> index ff338c2abe92..91daba4c2bc9 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -75,6 +75,7 @@
>  #include <linux/perf_event.h>
>  #include <linux/ptrace.h>
>  #include <linux/vmalloc.h>
> +#include <linux/pghot.h>
>  #include <linux/sched/sysctl.h>
>  #include <linux/pgalloc.h>
>  #include <linux/uaccess.h>
> @@ -6029,10 +6030,9 @@ int numa_migrate_check(struct folio *folio, struct vm_fault *vmf,
>  	if (folio_maybe_mapped_shared(folio) && (vma->vm_flags & VM_SHARED))
>  		*flags |= TNF_SHARED;
>  	/*
> -	 * For memory tiering mode, cpupid of slow memory page is used
> -	 * to record page access time.  So use default value.
> +	 * For memory tiering mode, last_cpupid is unused. So use default value.
>  	 */
> -	if (folio_use_access_time(folio))
> +	if (folio_is_promo_candidate(folio))
>  		*last_cpupid = (-1 & LAST_CPUPID_MASK);
>  	else
>  		*last_cpupid = folio_last_cpupid(folio);
> @@ -6113,6 +6113,7 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
>  	int nid = NUMA_NO_NODE;
>  	bool writable = false, ignore_writable = false;
>  	bool pte_write_upgrade = vma_wants_manual_pte_write_upgrade(vma);
> +	bool needs_promotion = false;
>  	int last_cpupid;
>  	int target_nid;
>  	pte_t pte, old_pte;
> @@ -6147,12 +6148,30 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
>  		goto out_map;
>  
>  	nid = folio_nid(folio);
> +	needs_promotion = folio_is_promo_candidate(folio);
>  	nr_pages = folio_nr_pages(folio);
>  
>  	target_nid = numa_migrate_check(folio, vmf, vmf->address, &flags,
>  					writable, &last_cpupid);
>  	if (target_nid == NUMA_NO_NODE)
>  		goto out_map;
> +
> +	if (needs_promotion) {
> +		/*
> +		 * Hot page promotion, mode=NUMA_BALANCING_MEMORY_TIERING.
> +		 *
> +		 * Isolation and migration are handled by pghot. Since VMA
> +		 * won't be available to kmigrated which does batched migration
> +		 * from non-process context, filter shared EXEC pages here itself.
> +		 */
> +		if ((vma->vm_flags & VM_EXEC) && folio_maybe_mapped_shared(folio))
> +			nid = NUMA_NO_NODE;
> +		else
> +			nid = target_nid;
> +		goto out_map;
> +	}

> Is the same accounting disruption happening here in do_numa_page() as well?
>
> Assigning NUMA_NO_NODE skips task_numa_fault() later in the function, and
> assigning target_nid credits the target node prior to the actual migration.

Reply to this same as above.

The other two comments for this patch actually belong to patch 3/8 and have
been addressed there.

Regards,
Bharata.

