Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99E0BCD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 08:42:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7D7C6B0121; Fri,  8 May 2026 04:42:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDFEC6B0122; Fri,  8 May 2026 04:42:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B80656B0123; Fri,  8 May 2026 04:42:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E2886B0121
	for <linux-mm@kvack.org>; Fri,  8 May 2026 04:42:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2B91A40763
	for <linux-mm@kvack.org>; Fri,  8 May 2026 08:42:41 +0000 (UTC)
X-FDA: 84743611722.05.49F620A
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010005.outbound.protection.outlook.com [52.101.56.5])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0A40CC0002
	for <linux-mm@kvack.org>; Fri,  8 May 2026 08:42:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=SjhryJEC;
	spf=pass (imf28.hostedemail.com: domain of Suneeth.D@amd.com designates 52.101.56.5 as permitted sender) smtp.mailfrom=Suneeth.D@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778229758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VUz90yIDAF9lsLZsnjft/7iI84A/CJ6QlD1fezFrjkI=;
	b=p16cjpKI5r6raEEWs4UmmtPv7WCeI8kxDBPeDBSwpBOUFUkHBYwA9l6nqFa4+6+8TXx01k
	eJSluG0HjpEJhy+soGtFDRDKGPnt7sXGBfIrfIitBqZKfz2sJhO/8PAo7dJq3WokeghVqC
	8QdaqekncjVVl066Lp7Cv5KZIP+OlTc=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=SjhryJEC;
	spf=pass (imf28.hostedemail.com: domain of Suneeth.D@amd.com designates 52.101.56.5 as permitted sender) smtp.mailfrom=Suneeth.D@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778229758; a=rsa-sha256;
	cv=pass;
	b=Mkwxnt0DsIZk5D12eN0eSz0hsu7W7+CKreDqC1lPwL6lZqt+efrUz9agSJ3iWhQ7adyAHH
	uWwG6gv7FSp3sG5xBIghLBUwsAylfBt1oL6KHJhE6fZCvcEnAO8sM0udC5bZz3VYxvyJ2g
	mF6/WMLGJiW/Qiw6MNfDyK1dwmmgDGY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LefNNj0NkmyZGR4DSu8B2Hv4ydRo9cf+HxDDvAvrGVEggFLcuYjG3RkOlryp7h/6/5uEDO65lr1vpBDVrUhiLufwy+YM7y1cJbR+wV5OnofRSRO5URU1eYpfzqFaP6AUn9hGj8Z3D7mgZgIQW8D9RwY/pQziaDZvMgaHNxPIgwE0X5eKwHZifOvBR0QuKNDvZazdUGIAlNZKNtojne/ndOiOo6QmDHeFKMSQGbF0PK8B+yli3BGjCBJoTs4KrFjsh8FZENhgS/nnpgniNXyRN3LdJU3wFeEZaZATHbYi9eIvggTxUDn0FgZPmtmSLjpSGz5zaVMk5JdlXEGZ9LQdoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VUz90yIDAF9lsLZsnjft/7iI84A/CJ6QlD1fezFrjkI=;
 b=wCIgdt8pIAFnt8Q6YsxMfDrqviVmiAffxDmn/MINCMlPUz4WCE6ccpxI3Hpv97ur5ogzYfEZemKZWW8BTupp6NwjpeBmGe+tSYPGEu3vNgWhZpBPjlNgfBQ6l/rvaVle9XBd1ekBKtOQNqVCOJ37Flp/+2msIVDn3/46Kpd9jwF0A5dfykAUrN12SCO6Wz9PIzDZNCLC0NupojyfUDVe/wIHslk73P8Pw9Gn9G8rjyy0Nywmfc2SHTyaz3sFkWlSfWah20eNria2uj8DLHtFzWi8/WbfwIwkQdAUbwapKoymkMDjtIrJDa1HIavumdCVkOTUunF3c830sKGv+PHS/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=oracle.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VUz90yIDAF9lsLZsnjft/7iI84A/CJ6QlD1fezFrjkI=;
 b=SjhryJECCAae1trtFizjXTLnfUidiZWR6/MB6IAVJsiAOHJuMeLx+skL0+iYaC1RBahw2DRpiO8Rx4CNJ/zNOCIrxFb0+eya424KFcab6ENqIrJV/D84taLacB7taIzuUC4x7uaYnuZSxkDOSb5EIhg7cHbxRfhO5oelULsAnwo=
Received: from PH8PR21CA0008.namprd21.prod.outlook.com (2603:10b6:510:2ce::29)
 by IA0PR12MB7674.namprd12.prod.outlook.com (2603:10b6:208:434::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.20; Fri, 8 May
 2026 08:42:33 +0000
Received: from SN1PEPF00036F3D.namprd05.prod.outlook.com
 (2603:10b6:510:2ce:cafe::82) by PH8PR21CA0008.outlook.office365.com
 (2603:10b6:510:2ce::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.25.10 via Frontend Transport; Fri, 8
 May 2026 08:42:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF00036F3D.mail.protection.outlook.com (10.167.248.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9891.9 via Frontend Transport; Fri, 8 May 2026 08:42:32 +0000
Received: from [10.136.39.237] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 8 May
 2026 03:42:28 -0500
Message-ID: <c4605bf2-9ac6-4d04-9f49-79643ee99178@amd.com>
Date: Fri, 8 May 2026 14:12:07 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 26/30] maple_tree: Use maple copy node for
 mas_wr_split()
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Andrew Morton
	<akpm@linux-foundation.org>
CC: <maple-tree@lists.infradead.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Matthew Wilcox <willy@infradead.org>, Sidhartha Kumar
	<sidhartha.kumar@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl
	<aliceryhl@google.com>, Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>, Arnd Bergmann <arnd@arndb.de>,
	Christian Kujau <lists@nerdbynature.de>, SeongJae Park <sj@kernel.org>
References: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
 <20260130205935.2559335-27-Liam.Howlett@oracle.com>
Content-Language: en-US
From: "D, Suneeth" <Suneeth.D@amd.com>
In-Reply-To: <20260130205935.2559335-27-Liam.Howlett@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3D:EE_|IA0PR12MB7674:EE_
X-MS-Office365-Filtering-Correlation-Id: c0022048-2621-4c16-3f79-08deacddbf3a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|376014|7416014|13003099007|3023799003|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	w8er2f7Q99W7XeQC5FzfkDGTkXeXMBei9rQ/n45oxDaUIsBUhV9PM9WLs8irUx3wHIwtzr5Zc97AFrkqhSc1Os02trE4gh/jX407gWKcEw3T/OPdcBzh6yQzYSdSutWUchqU5HLqXL8zjXfYUi88ggFU4QNkM/KDn6AAKGkAOTpyvsdPxxbeGSAXiWUbolJFefW/f5hVkHNV0AYmvTO3jq0DRyo4NIaKCcjq24xhOsVBqcU/nH1U5OV6Rgu4u33zUn9tR/TFmmEdsRKrmpojelXDTZXJJJWkk3nsLyUsGR44PY6t8otmzJaZ2pELbJGXVPxDWaBKYtDJ81Jb+VR0VK+2L3eX9KEGD60zfWAzZ/KHk2+TeIqaQ8qedrBpq52Qh8J3b6ynq+u3wn5S9o1Rm6DtuuofeO6F2GuFE/2SnAWy589JgWhaIbb/77kkoEatnVTsL5OKLrfVkUntgBrZ7BuX8WvxcUzymZfUIhlmMc3zNtEQvV83Y+lj41P9xCPX+D0Sb5x2fZCdnrlQS3K34HkUWvm4hakFr3CFmjPgt5ZikbCghB3M3Y+JCiROpSXoR4iJ4KQl5PbyhIn4g7t4eCgIp1+uBOtFc5TAED5U0F00yDaVuMiFGBSiCsgGvtp3SYfNpeJCgLXf6swrdGeN5ihvucCZFploiknxKEyb7GI6ctoel+K6T2cwt6pN78zYcc7l48H6IjZwCYxtKVQKb99Uh2Vckkq5AlM8MHxqRaY=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(376014)(7416014)(13003099007)(3023799003)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DGuJN5oe0OkR2ZudWnvnXSjACQViryvh64e801J3TJ1tSDkmX36Dh+LIUE5v409kLM+pb3uujNUeJy1kymckOdddtH9uDe1d1qfHMtrg7TStb92UmFYrnVzhYAAA/bz0/hRQxND2qB3WZ13QCEIlDDiNswg04PtpB1HqQ+/0E+r34mAeIzY1U/aiLBykZI3rITtdMlpD5kzUZuY3EKr5E4t2iG+TLzeRKcXVHwub9C4xXjbdCCCdpbzu9OiEn9beVWZaOr5htDSmT3mzQ5M9k5WAISbT35ubtYbIZCODWY+L2XqRo+HOwQx1yW1YZIeRfDY7Ncr+lCMz/tI5FZAmsCTtrQb/gq0Ban9u0UTECZ5nqUpf5S5Zg7rzMHqX3BYuBxH2OeerlQ2NJif6vIgp7mO0cCqPJr/RS1bOSAzgjAuCtEzwi+kJfEDbVcnnuGY9
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2026 08:42:32.8595
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c0022048-2621-4c16-3f79-08deacddbf3a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7674
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0A40CC0002
X-Stat-Signature: c1hiybyr34pqtazqg8385ko376i7wriw
X-HE-Tag: 1778229757-664549
X-HE-Meta: U2FsdGVkX19ZH3JlzX2WpyphUODHQExdUqU1mKldz8EEy2jmA2pMWZ8RCkRgdBptBU44CNe+f7M5ytTBeUXOyr2wd9m4nhVi9jijIs/MloRPh1B7BC1ofBvc2+Hxok4M7Us2fxt0SrmxPsp5AMN5drFuRjzZYxqcgXpjrNaillYb8ylnbVI7QkYSTEz5rraedqNonCcaune1J6QhF/ZoZxbfXCp74zfiPNAUb720uobxLoAt2Kgo2lx3VYPaGkbC/9x3Nfzwy4h+BXyWR0gBHR7YO2SnLvowxRe+LEsJIh5yeEossv2kQinArGqMgYxT6VlOqCnvuPfWU6qmwi8bIVILSq+1kZzihx17o+KSPjTZaX8AOmQGbAQei/g09JbLe5h3PcJLKKY39Vwx9UolDcrsg49caT21VCh5ecsxxutOEcNfJKBM5VywhDigrEeFnxZ0JRW5HTkh3v+gm4MOErU4vnv3MNhv/Kq2/GKXqmzcIdQMhPijrZ5A6EIDkvDXhaBfYjvTADus+2ovFaI5qFWOSCYnh2T4w5TrC09rSLbjJgN+UGpYTj6RTSRsksiFvKtiYrTlqG4tfKZ347C+/2AJGlJeyOMLqEICGRCxV1mFFpR73xJQondLk4puz4JVt1OX97hyviZNcGOWSfAVXOCsJIUqLLNT/RLl+H8OABqCr95JSc1LIbz2lKjrvyd6rF4iKEiVDHHfITU1o7JPm6LJJyBkmMq/dU0a0Pr9IgAHagFO5R1Wa4amIXmUMvX4WhNTUlPtQIgp8NU9n42/tbE7Va2nWJDaD7kG8Ay+3Q/bgm4a/gjKCFklZahLiUAyZ21xl8Q9/qwFTCeZpKwyGCbKcwMdpedEUPfH9WYpmVeHpjjhZG0rzKH4IKM86jj5PXA/aswiNAJJcPV3qccU1FgkIfv301Q345RG+pOlPWoABsogrDwDPmENxcYdzMiMa/hdnFMRRuQmpXfz5QX
 c68f4IYl
 6E38vLELrky7du3fWsFqE3gXkCO2JdmBth7jx/pZTHzHs4jy/+LQEdvq/8PKra2S9PDOQQOHo+cPp5ORCNsdTtGvF+yXpXrWZ7cvQIyUJFt/b8xvniVXknFqGu6GEsMuOaIDTFgmfFJ/B9jiSytUR/8WVBRvVabS8ecVnPWhzmURsWMjmuEsUYwPa8hdNdMiNZSGRvxSaMiQJu6QLSU7NOKKMPLDM2oYhcSJ6T/wclS52q9dZtOM6WZKjF7pD8Cj0ZnhYRdCyTA6vXYn8IYfP2N1Ozekn9+2w+1Nb6pkkJ5nL+aURcxCVbCydoHbTm1fcCWvaGDp3huMooJArAb2WlYhDkM48ieNF29+PzabPuj1LRw4nu8Jsw8nyTebKrz62WR7DC/gxc/2n6dQh6girYKla1PutB5a+n2O26VcyHjSpnQQmi4tvPZWXT6+wQzoc0luTZ4PDlcJ/e/bnSH0iUZCeK1QTu9r5x/S08fxNEzQHOBr2OQ+VOITR2MxDUZxFfT9zTkN81E3HpKQJYffXqDN5wijmq1+fJxFPsgEcvZSWNpaT1QAdsw8IFPqdvwj5Q56VlUMmkz1qr0TZSl3W5YIRl7Pw32l2Gmqj3WfA13xPKNg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Liam Howlett,

On 1/31/2026 2:29 AM, Liam R. Howlett wrote:
> Instead of using the maple big node, use the maple copy node for reduced
> stack usage and aligning with mas_wr_rebalance() and
> mas_wr_spanning_store().
> 
> Splitting a node is similar to rebalancing, but a new evaluation of when
> to ascend is needed.  The only other difference is that the data is
> pushed and never rebalanced at each level.
> 
> The testing must also align with the changes to this commit to ensure
> the test suite continues to pass.
> 

We run will-it-scale micro-benchmark as part of our weekly CI for Kernel
Performance Regression testing between a stable vs rc kernel. We
observed will-it-scale-thread-brk1 variant was regressing with
~9% on an AMD's Turin machine between the kernels v7.0 and
v7.1-rc1. Bisecting further landed me onto this commit
280b792cac62ddadca2935766ca870b438c86323 (maple_tree: Use maple copy 
node for mas_wr_split()) as the first bad
commit. The following were the machine's configuration and test
parameters used:-

Model name:           AMD EPYC 64-Core Processor [Turin]
Thread(s) per core:   2
Core(s) per socket:   64
Socket(s):            2
Total online memory:  258G

Test params:
------------

nr_task: [1 8 64 128 192 256]
       mode: thread
       test: brk1
       kpi: per_thread_ops
       cpufreq_governor: performance

The following are the stats after bisection:-
(the KPI used here is per_thread_ops)

v7.0 (baseline)  %diff   per_process_ops   kernel_rc_ver
---------------  -----   ---------------   -------------
353091            -9     321987            v7.1-rc1
353091            -7     328897          v7.0-rc5-280b792cac62(culprit)
353091            -1     347884        v7.0-rc5-11e7f22f5e85(culpritm1)

jFYI a very high level call trace from running will-it-scale-thread-brk1 
which ends up in mas_wr_split goes like this,

do_brk_flags() {
   may_expand_vm();
   vma_merge_new_range() {
     vma_expand() {
       commit_merge() {
         vma_iter_store_overwrite(){
           mas_store_prealloc(){
             mas_wr_store_entry(){
               mas_wr_split();  <--- Function of interest from this patch
             } /* mas_wr_store_entry */
           } /* mas_store_prealloc */
         } /* vma_iter_store_overwrite */
       } /* commit_merge */
     } /* vma_expand */
} /* do_brk_flags */

Recreation steps:
-----------------

1) git clone https://github.com/antonblanchard/will-it-scale.git
2) git clone https://github.com/intel/lkp-tests.git
3) cd will-it-scale && git apply
lkp-tests/programs/will-it-scale/pkg/will-it-scale.patch
4) make
5) python3 ./runtest.py brk1 25 thread 0 0 1 8 64 128 192 256

NOTE: [5] is specific to machine's architecture. starting from 1 is the
array of no.of tasks that you'd wish to run the testcase which here is
no.cores per CCX, per NUMA node/ per Socket, nr_threads.

Would be happy to help with further testing and providing additional
data if required.

Thanks & Regards,
Suneeth D

> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> ---
>   lib/maple_tree.c                 | 99 ++++++++++++++++++++++++++++++--
>   lib/test_maple_tree.c            | 55 ++++++++++++++----
>   tools/testing/radix-tree/maple.c | 11 ++++
>   3 files changed, 149 insertions(+), 16 deletions(-)
> 
> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index f04989f8a115e..5813ad17ea6fe 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -4542,19 +4542,106 @@ static inline void mas_wr_append(struct ma_wr_state *wr_mas,
>   	trace_ma_write(TP_FCT, mas, new_end, wr_mas->entry);
>   }
>   
> +/*
> + * split_ascend() - See if a split operation has to keep walking up the tree
> + * @cp: The maple_copy node
> + * @wr_mas: The maple write state
> + * @sib: the maple state of the sibling
> + *
> + * Return: true if another split operation on the next level is needed, false
> + * otherwise
> + */
> +static inline bool split_ascend(struct maple_copy *cp,
> +		struct ma_wr_state *wr_mas, struct ma_state *sib,
> +		struct ma_state *parent)
> +{
> +	struct ma_state *mas;
> +	unsigned long min, max;
> +
> +	mas = wr_mas->mas;
> +	min = mas->min; /* push right, or normal split */
> +	max = mas->max;
> +	wr_mas->offset_end = parent->offset;
> +	if (sib->end) {
> +		if (sib->max < mas->min) {
> +			min = sib->min; /* push left */
> +			parent->offset--;
> +		} else {
> +			max = sib->max; /* push right */
> +			wr_mas->offset_end++;
> +		}
> +	}
> +
> +	cp_dst_to_slots(cp, min, max, mas);
> +	if (cp_is_new_root(cp, mas))
> +		return false;
> +
> +	if (cp_converged(cp, mas, sib))
> +		return false;
> +
> +	cp->height++;
> +	copy_tree_location(parent, mas);
> +	wr_mas_setup(wr_mas, mas);
> +	return true;
> +}
> +
> +/*
> + * split_data() - Calculate the @cp data, populate @sib if the data can be
> + * pushed into a sibling.
> + * @cp: The maple copy node
> + * @wr_mas: The left write maple state
> + * @sib: The maple state of the sibling.
> + *
> + * Note: @cp->data is a size and not indexed by 0. @sib->end may be set to 0 to
> + * indicate it will not be used.
> + *
> + */
> +static inline void split_data(struct maple_copy *cp,
> +		struct ma_wr_state *wr_mas, struct ma_state *sib,
> +		struct ma_state *parent)
> +{
> +	cp_data_calc(cp, wr_mas, wr_mas);
> +	if (cp->data <= mt_slots[wr_mas->type]) {
> +		sib->end = 0;
> +		return;
> +	}
> +
> +	push_data_sib(cp, wr_mas->mas, sib, parent);
> +	if (sib->end)
> +		cp->data += sib->end + 1;
> +}
> +
>   /*
>    * mas_wr_split() - Expand one node into two
>    * @wr_mas: The write maple state
>    */
> -static noinline_for_kasan void mas_wr_split(struct ma_wr_state *wr_mas)
> +static void mas_wr_split(struct ma_wr_state *wr_mas)
>   {
> -	struct maple_big_node b_node;
> +	struct maple_enode *old_enode;
> +	struct ma_state parent;
> +	struct ma_state *mas;
> +	struct maple_copy cp;
> +	struct ma_state sib;
>   
> +	mas = wr_mas->mas;
>   	trace_ma_write(TP_FCT, wr_mas->mas, 0, wr_mas->entry);
> -	memset(&b_node, 0, sizeof(struct maple_big_node));
> -	mas_store_b_node(wr_mas, &b_node, wr_mas->offset_end);
> -	WARN_ON_ONCE(wr_mas->mas->store_type != wr_split_store);
> -	return mas_split(wr_mas->mas, &b_node);
> +	parent = *mas;
> +	cp_leaf_init(&cp, mas, wr_mas, wr_mas);
> +	do {
> +		if (!mte_is_root(parent.node)) {
> +			mas_ascend(&parent);
> +			parent.end = mas_data_end(&parent);
> +		}
> +		split_data(&cp, wr_mas, &sib, &parent);
> +		multi_src_setup(&cp, wr_mas, wr_mas, &sib);
> +		dst_setup(&cp, mas, wr_mas->type);
> +		cp_data_write(&cp, mas);
> +	} while (split_ascend(&cp, wr_mas, &sib, &parent));
> +
> +	old_enode = mas->node;
> +	mas->node = mt_slot_locked(mas->tree, cp.slot, 0);
> +	mas_wmb_replace(mas, old_enode, cp.height);
> +	mtree_range_walk(mas);
>   }
>   
>   /*
> diff --git a/lib/test_maple_tree.c b/lib/test_maple_tree.c
> index a182e48b5f5e6..434d8a2fdd99c 100644
> --- a/lib/test_maple_tree.c
> +++ b/lib/test_maple_tree.c
> @@ -1024,6 +1024,7 @@ static noinline void __init check_ranges(struct maple_tree *mt)
>   	mt_set_non_kernel(10);
>   	check_store_range(mt, r[10], r[11], xa_mk_value(r[10]), 0);
>   	MT_BUG_ON(mt, !mt_height(mt));
> +	mt_validate(mt);
>   	mtree_destroy(mt);
>   
>   	/* Create tree of 1-200 */
> @@ -1031,11 +1032,13 @@ static noinline void __init check_ranges(struct maple_tree *mt)
>   	/* Store 45-168 */
>   	check_store_range(mt, r[10], r[11], xa_mk_value(r[10]), 0);
>   	MT_BUG_ON(mt, !mt_height(mt));
> +	mt_validate(mt);
>   	mtree_destroy(mt);
>   
>   	check_seq(mt, 30, false);
>   	check_store_range(mt, 6, 18, xa_mk_value(6), 0);
>   	MT_BUG_ON(mt, !mt_height(mt));
> +	mt_validate(mt);
>   	mtree_destroy(mt);
>   
>   	/* Overwrite across multiple levels. */
> @@ -1061,6 +1064,7 @@ static noinline void __init check_ranges(struct maple_tree *mt)
>   	check_load(mt, r[13] + 1, xa_mk_value(r[13] + 1));
>   	check_load(mt, 135, NULL);
>   	check_load(mt, 140, NULL);
> +	mt_validate(mt);
>   	mt_set_non_kernel(0);
>   	MT_BUG_ON(mt, !mt_height(mt));
>   	mtree_destroy(mt);
> @@ -1285,14 +1289,20 @@ static noinline void __init check_ranges(struct maple_tree *mt)
>   		MT_BUG_ON(mt, mt_height(mt) >= 4);
>   	}
>   	/*  Cause a 3 child split all the way up the tree. */
> -	for (i = 5; i < 215; i += 10)
> +	for (i = 5; i < 215; i += 10) {
>   		check_store_range(mt, 11450 + i, 11450 + i + 1, NULL, 0);
> -	for (i = 5; i < 65; i += 10)
> +		mt_validate(mt);
> +	}
> +	for (i = 5; i < 65; i += 10) {
>   		check_store_range(mt, 11770 + i, 11770 + i + 1, NULL, 0);
> +		mt_validate(mt);
> +	}
>   
>   	MT_BUG_ON(mt, mt_height(mt) >= 4);
> -	for (i = 5; i < 45; i += 10)
> +	for (i = 5; i < 45; i += 10) {
>   		check_store_range(mt, 11700 + i, 11700 + i + 1, NULL, 0);
> +		mt_validate(mt);
> +	}
>   	if (!MAPLE_32BIT)
>   		MT_BUG_ON(mt, mt_height(mt) < 4);
>   	mtree_destroy(mt);
> @@ -1304,17 +1314,42 @@ static noinline void __init check_ranges(struct maple_tree *mt)
>   		val2 = (i+1)*10;
>   		check_store_range(mt, val, val2, xa_mk_value(val), 0);
>   		MT_BUG_ON(mt, mt_height(mt) >= 4);
> +		mt_validate(mt);
> +	}
> +	/* Fill parents and leaves before split. */
> +	val = 7660;
> +	for (i = 5; i < 490; i += 5) {
> +		val += 5;
> +		check_store_range(mt, val, val + 1, NULL, 0);
> +		mt_validate(mt);
> +		MT_BUG_ON(mt, mt_height(mt) >= 4);
>   	}
> +
> +	val = 9460;
>   	/* Fill parents and leaves before split. */
> -	for (i = 5; i < 455; i += 10)
> -		check_store_range(mt, 7800 + i, 7800 + i + 1, NULL, 0);
> +	for (i = 1; i < 10; i++) {
> +		val++;
> +		check_store_range(mt, val, val + 1, xa_mk_value(val), 0);
> +		mt_validate(mt);
> +	}
>   
> -	for (i = 1; i < 16; i++)
> -		check_store_range(mt, 8185 + i, 8185 + i + 1,
> -				  xa_mk_value(8185+i), 0);
> -	MT_BUG_ON(mt, mt_height(mt) >= 4);
> +	val = 8000;
> +	for (i = 1; i < 14; i++) {
> +		val++;
> +		check_store_range(mt, val, val + 1, xa_mk_value(val), 0);
> +		mt_validate(mt);
> +	}
> +
> +
> +	check_store_range(mt, 8051, 8051, xa_mk_value(8081), 0);
> +	check_store_range(mt, 8052, 8052, xa_mk_value(8082), 0);
> +	check_store_range(mt, 8083, 8083, xa_mk_value(8083), 0);
> +	check_store_range(mt, 8084, 8084, xa_mk_value(8084), 0);
> +	check_store_range(mt, 8085, 8085, xa_mk_value(8085), 0);
>   	/* triple split across multiple levels. */
> -	check_store_range(mt, 8184, 8184, xa_mk_value(8184), 0);
> +	check_store_range(mt, 8099, 8100, xa_mk_value(1), 0);
> +
> +	mt_validate(mt);
>   	if (!MAPLE_32BIT)
>   		MT_BUG_ON(mt, mt_height(mt) != 4);
>   }
> diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/maple.c
> index 5ea45d67556a8..feedd5ab7058f 100644
> --- a/tools/testing/radix-tree/maple.c
> +++ b/tools/testing/radix-tree/maple.c
> @@ -35406,7 +35406,18 @@ static noinline void __init check_spanning_write(struct maple_tree *mt)
>   	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
>   	for (i = 0; i <= max; i++)
>   		mtree_test_store_range(mt, i * 10, i * 10 + 5, &i);
> +
>   	mtree_lock(mt);
> +	if (MAPLE_32BIT) {
> +		i = 47811;
> +		do {
> +			mas_set(&mas, i);
> +			mas_store_gfp(&mas, check_spanning_write, GFP_KERNEL);
> +			i++;
> +			mas_ascend(&mas);
> +		} while (mas_data_end(&mas) < mt_slot_count(mas.node) - 1);
> +	}
> +
>   	mas_set(&mas, 47606);
>   	mas_store_gfp(&mas, check_spanning_write, GFP_KERNEL);
>   	mas_set(&mas, 47607);


