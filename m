Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9453E9B36D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 11:56:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9EC66B0092; Mon,  2 Mar 2026 06:56:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4CD06B0093; Mon,  2 Mar 2026 06:56:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C215C6B0095; Mon,  2 Mar 2026 06:56:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AE3A86B0092
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 06:56:41 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 36A2A140B68
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:56:41 +0000 (UTC)
X-FDA: 84500971002.23.FA5242A
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012033.outbound.protection.outlook.com [52.101.53.33])
	by imf24.hostedemail.com (Postfix) with ESMTP id 07C94180005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:56:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=mMMGwqHd;
	spf=pass (imf24.hostedemail.com: domain of Suneeth.D@amd.com designates 52.101.53.33 as permitted sender) smtp.mailfrom=Suneeth.D@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772452598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BtuXeW9FYK5X+hnA8QuatR0D9jjMzl+31IqdgwHghMg=;
	b=oEQUZ13KlbFb1OTXqHqm6vZkG4cs+G9RZCo5RRQl2VC3cqpPIfFrY8qHTmjKqu+9xTRJSF
	QxiL9J7oiD2i37HVPC0Ww5+YuaOXr0h+LopUUlTS3gxmTF8r37HKOtfL/LWwX1tOgrXPhS
	u9vdfQ+VYzDaRz1FiXoZ7LiaIKUsNQc=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=mMMGwqHd;
	spf=pass (imf24.hostedemail.com: domain of Suneeth.D@amd.com designates 52.101.53.33 as permitted sender) smtp.mailfrom=Suneeth.D@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772452598; a=rsa-sha256;
	cv=pass;
	b=e582FO/dlcTXfgtofKjgIM4/AK4keP8bopFZEGIWBi4pkLlT66VmX5SmdUpnws+7AciYdq
	jbijdZojLDP8xXrX/9doaaok5X3f8XBnE8EFOYrewddzWqnhAqvVKX7hNOVxhVHxqZWWEq
	dS3Vj7GChlbL/KfM+eqPgG6WRfIh1aA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TGHKtZ8DTGrVFkaQQt6LpVxSuLh1CfPse/P1y00kGvRb3e9Z9Yrb2uzehxnZe4+OKA1kU9AbdYHldgUWMESyEhJyJQoIlCXkTqf4eaxVebZW8eb4TWAL++7OkTusmK0K5Vfb5Rb2IWNRXgcj9qf9uktDXFYKOfv44njbkPK63sUyw5grsnJ2GS9WKyVBRRwiVe0AHTnXaB22q9b/rxEUIkLoVw4fYdBm6CdTm8igEqQflzG3KTGlV/+qE501+WP+Z8/05DKhwnju/nI6s5LJQjVH26H6kx76eqpGWMFbismZuMeGtK0tLwgIJnrYIDCPUC147L+B4m2+ybfZf/5QOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BtuXeW9FYK5X+hnA8QuatR0D9jjMzl+31IqdgwHghMg=;
 b=nsQbmrF4d+iqWJHr83PWhDb3ym5B09o9GJ4IjRyBytOx0WF68W++yaSzXtMWZQoulEACTllWSwFnfdJGGcqM9MIiq33JDiv+P2BnkYAuzjDjxQ9rNxknFmZHiiTxw8LCATdDf5s4ubqgCrcQLa+fMxabb3QQ9bDIFZKVXhED1pk5YDd7riV0TS/I+ilRF0q1eZ3s6LLwOpX+cGHYZhlgmHU8O+Ipvct+DuCnjAfPByFr1y3xTS4+MDcZThw3pRy0ofu3YiLHXogbx1GAk805twovNexpeyoFOS/kFWgyf1g16+sFn4+n8qVzcsdKqg/iC8nIOU3t/lUILPyIbOyimA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=suse.cz smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BtuXeW9FYK5X+hnA8QuatR0D9jjMzl+31IqdgwHghMg=;
 b=mMMGwqHdjsDCYhFXZN5KZLBbGGrbRHjDI44tMCyG6m2plEhI/0OHdSESHZAQRohnUP1DUFmS75nDHjT7jvLBwf+jm9E2GTVAH18LsztRsx/1qW+d//piCh2zfzaaxK3CvurNGjbAXUHmfDvs3ssphKKHbzkQrqnt875QO2uWkEo=
Received: from DS7PR03CA0261.namprd03.prod.outlook.com (2603:10b6:5:3b3::26)
 by SN7PR12MB7810.namprd12.prod.outlook.com (2603:10b6:806:34c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.20; Mon, 2 Mar
 2026 11:56:30 +0000
Received: from CY4PEPF0000EE3D.namprd03.prod.outlook.com
 (2603:10b6:5:3b3:cafe::f3) by DS7PR03CA0261.outlook.office365.com
 (2603:10b6:5:3b3::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.20 via Frontend Transport; Mon,
 2 Mar 2026 11:56:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000EE3D.mail.protection.outlook.com (10.167.242.15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.16 via Frontend Transport; Mon, 2 Mar 2026 11:56:29 +0000
Received: from [10.252.200.216] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 2 Mar
 2026 05:56:15 -0600
Message-ID: <df5a0dfd-01b7-48a9-8936-4d5e271e68e6@amd.com>
Date: Mon, 2 Mar 2026 17:26:06 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/22] slab: make percpu sheaves compatible with
 kmalloc_nolock()/kfree_nolock()
To: Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, Petr
 Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>, David
 Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>
CC: Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, Sebastian
 Andrzej Siewior <bigeasy@linutronix.de>, Alexei Starovoitov <ast@kernel.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-rt-devel@lists.linux.dev>, <bpf@vger.kernel.org>,
	<kasan-dev@googlegroups.com>
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <20260123-sheaves-for-all-v4-8-041323d506f7@suse.cz>
Content-Language: en-US
From: "D, Suneeth" <Suneeth.D@amd.com>
In-Reply-To: <20260123-sheaves-for-all-v4-8-041323d506f7@suse.cz>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3D:EE_|SN7PR12MB7810:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ec2235f-55b0-4e66-d47e-08de7852bdd2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	g0WLE3KVUQr2V3iJaIRw0Yvo6ynGEqKX64H3CxQ694BGGBXdZcqlqkIU4DmE//tNsnRI8osvZFffyvS9Gk+sy6axsYyvGFll3JtQvwOewN4o0gbtIfwDWVKDW+P75nPrUcML9PXnJ3xekBhxUBQyO3yQLbuJptcI0WJ1yQEUHlySB163zo+ln04xIS6IxYi3zSSWXAHP//9yYa6eHB3nnqxfMmagc5cRk2LCL3oFfi/Vc9Ccbb+T5KW0kxV4pd57+slsdZJidtlk3H87QS9youYApRsAoU7piLgywQfIbK2j9ggf0JUE3f9X3QXyc/ONdf1AEHrfmsWqk8Sp4QCvUJOxTHNND23jxUpP2S0FMTHzgfAN+MGcbdIBd2jkUXkHP6luzZBqO3LWp/69MtgH7rjQC+Pxp/KSk0q5YsiK2YFoR6eAbPKgAX98jHv7s2soXh4ezDH0ZyselEYCJmbDUpQ6ZtdT3CxG4WnBUgKcRZeQBAGRKI1onnAqzpbSIbLcSN8S5xX6jqVrbQ41yMqd+KdrYcGe77ysQo6+Vn0lyMDkhpRi7m8nx5v7sOQPe/hejA5YmD5Vf6CUzbhjywKnoYu0OiaEqr25Bpon1Z+V/sChhqR8YVmyvzHnnpczSHsxVfy9wWs5BPYaAW0VYyi6a3qaZIIx8ZqsAxNW2nn7RqpyKEQ/txGq3S2d9EYUQpKHT7Sx/8E0UOVXT1H63mS45jXunqeblgR+5P0Tr+zxgCD1eTjbWI7hLx8Mx9j+FHv05019ZozwmED4ItFG/JSzn3Cdk2wjqpYZJsZER7dUBtU9YFylqvDfHkfqfCvV8DR/KppzHT/ALoVyD1SLrCXzew==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	LSuwd0lRbgCHY54iSRpOlq2qAroJiLptlxQwgIhpMmWONghmnizijH+3kgDzfE4kewXi3caRTTlidQWqZHZKpjVRRejGXx64X9g9X5EjeRg4K+f9GEbEP8ZQmo+uvusPGKjuzJ0g/mSgpD+31yuxGEMRLjBCGPWORFu5cilq2FsdIEg5RTZG5Y49BheYj2y6q9gHPEzse5fLcZAQW11vlVi8lDjvgOjXWVE0tbrtBmHthcmaiKy8r7nPlyFPFnMEnU+ksPc4OKwL/BVZenx+ApLbmzZGSIlCheinqkewJJ/MxMLG8C1R3/zbt2ChnrBnEuAjRqIcX4CMgvpcqbGM/djm7jYly2XziS4p6DEbOmQ9Q3bV52+ooftVQ/9xI/wI+6+KHQUpHyf3BJHJjRqTTp8rJSDebev5vw90eQRPE0dLr4W8fKsiIqFI3vZUbVIP
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 11:56:29.9654
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ec2235f-55b0-4e66-d47e-08de7852bdd2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7810
X-Rspamd-Queue-Id: 07C94180005
X-Rspamd-Server: rspam07
X-Stat-Signature: fnefshrxr8psryn4t6iypnjwm3ai4yms
X-Rspam-User: 
X-HE-Tag: 1772452597-208418
X-HE-Meta: U2FsdGVkX1/Irx2EsAIKGdEUqUUt9/WhW/dTWtwGTwxE1StzNctWlApRD6iAjVQ8O+NShdyILsXfEut31zjK37mOCIL/ALgfK/S53GPHGEaBPYTmLqQp9HkcLMf0H8Za1YSSoZG0lUCvVyCqLF5pS1UO9RrdxOzR49/gPHYopJy9aw+E3YhU71jEr5WHHut/ItIYDoa2XGaNHK5OxEygF3/MwNSIMpASJ7zFjCbgwWmbe3KDuVUDSmOaU0VaxU8c3mKovYLfFDJDfmw1HGt8aWfg3hMsoeizl+2oD4B+AAj4W90wNaPFbXQbRwZjkOneJkXjdTbmaS/jn6KvH7OGmq/xeNuowD7SwF5zdx8N3EmE+wGLbccu7gJnilgHNXTelhr+9cFzySZsuvxVfu8iabDCQfTnoW/iuaeugqk/6z9+H2OW3dtGmrPnGvkELxayF5Yz41Lla/lIsmvyUTQaRrNtZFQ8dHB/MHjBIqYHZ1Pd7wSvuwjpj+h/43HC6JzytMIh9hLuHax3In6axKylmWkdHspNmxoHQBgPH7tAENZ4eJmRTUfKq2u115sXXyHSzq/gokOxH/7v37jD6QlgVrJGq1tvRXZsoi2gm0JSr4facQ0nC92Ym3baO/pyCQk3kpUgnjjpJ4LESWk8cM6zSxHofapGo3qwG045/QHi1M5M1yJjv6Mws/QRVq2pqMJyKIwjYuEqJr+LLWO7cGBjJxH+nAUVBT2kHV6PxRDp9X2QaImKhk3YU70JpCLRLdIPNsCvVtwgu9hrSb2FYde1cUn6QbPJA/6oUYV+PoD5tkZJ7a+q+qaNTSD0ZsIOQ6SxYGJwnBAw7zuYIrZkOBzEAetyKoKB383X8zVFNPEYmSxtuBdUIa14nZ26jn7VkUjhDtnQHn62GkCZpws0MXvtUzDuA1C85g2K5F7IDWcUM+ITxfhCplc8xaD8jeVYUSXFxhH71NVJHCqyDsfpWA9
 W8PYwkcj
 EmyHo4xDCV7I5slMgTzf23v8A1X/C5L6k1tun1wOkzlS2SEP92h9QX1ajmhH9HjqyRnsjTqn0+P/RmtPXr7SKtdxfGECtHovLncDCrsSdAOWxCnnyHHgcbyjezrqJnkZXERKZ5uBCsPtAni8VBVea/zKlXdLfj0uzX/NCEdaUF7Us4fL8h2WM434P9sIRYjDXU8WKyTUmDJ6Af28CAjuyWNVVRTXVLD/L0oc9Z9N12+cIFJxDg4Ja5BqPojuFTMjo8I1swuw7okIgSR+tiJ9zix/UVNZ1wTFwg3F6gYOfawD257gq3iaWwfBt+PS52RJ6rf3KRFDu7QrQXMsX3aq2nDf4D5mhUKl4WwxCmsnXlJUex7n4HFkllyKGsgvM2aJdtHq47pj9pAoGjPFV6phCFn8Yswip28UjJIreacqC/k9Gpst8GLQUhhJGqRbcjWoV9obJp+xNFEBGGphCWFWLJ3lTVWk6eruQ3RYsrTw7JXwmxkU3uAdnXfgR/Y/uGlfQNffuTU+zFpGXRh1G0t6nCfyKPHQU8hdqkr9uEBo+uLC0GdFS9VeK1Qx4/J3bpNjsRcdDtM3V4D/EBPdPiTvquuj3NS1XkOJVb0qzZZHIVg5CjTrLAmO+t1HRDT5pVrHRza/o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vlastimil Babka,

On 1/23/2026 12:22 PM, Vlastimil Babka wrote:
> Before we enable percpu sheaves for kmalloc caches, we need to make sure
> kmalloc_nolock() and kfree_nolock() will continue working properly and
> not spin when not allowed to.
> 
> Percpu sheaves themselves use local_trylock() so they are already
> compatible. We just need to be careful with the barn->lock spin_lock.
> Pass a new allow_spin parameter where necessary to use
> spin_trylock_irqsave().
> 
> In kmalloc_nolock_noprof() we can now attempt alloc_from_pcs() safely,
> for now it will always fail until we enable sheaves for kmalloc caches
> next. Similarly in kfree_nolock() we can attempt free_to_pcs().
> 

We run will-it-scale micro-benchmark as part of our weekly CI for Kernel 
Performance Regression testing between a stable vs rc kernel. We 
observed will-it-scale-thread-page_fault3 variant was regressing with 
9-11% on AMD platforms (Turin and Bergamo)between the kernels v6.19 and 
v7.0-rc1. Bisecting further landed me onto this commit
f1427a1d64156bb88d84f364855c364af6f67a3b (slab: make percpu sheaves 
compatible with kmalloc_nolock()/kfree_nolock()) as the first bad 
commit. The following were the machines' configuration and test 
parameters used:-

Model name:           AMD EPYC 128-Core Processor [Bergamo]
Thread(s) per core:   2
Core(s) per socket:   64
Socket(s):            1
Total online memory:  256G

Model name:           AMD EPYC 64-Core Processor [Turin]
Thread(s) per core:   2
Core(s) per socket:   64
Socket(s):            2
Total online memory:  258G

Test params:
------------
      nr_task: [1 8 64 128 192 256]
      mode: thread
      test: page_fault3
      kpi: per_thread_ops
      cpufreq_governor: performance

The following are the stats after bisection:-
(the KPI used here is per_thread_ops)

kernel_versions      					 per_thread_ops
---------------      					 ---------------
v6.19.0 (baseline)                                     - 2410188
v7.0-rc1 	                                       - 2151474
v6.19-rc5-f1427a1d6415                                 - 2263974
v6.19-rc5-f3421f8d154c (one commit before culprit)     - 2323263

Recreation steps:
-----------------
1) git clone https://github.com/antonblanchard/will-it-scale.git
2) git clone https://github.com/intel/lkp-tests.git
3) cd will-it-scale && git apply
lkp-tests/programs/will-it-scale/pkg/will-it-scale.patch
4) make
5) python3 runtest.py page_fault3 25 thread 0 0 1 8 64 128 192 256

NOTE: [5] is specific to machine's architecture. starting from 1 is the
array of no.of tasks that you'd wish to run the testcase which here is
no.cores per CCX, per NUMA node/ per Socket, nr_threads.

I also ran the micro-benchmark with ./tools/testing/perf record and
following is the diff collected:-

# ./perf diff perf.data.old perf.data
Warning:
4 out of order events recorded.
# Event 'cpu/cycles/P'
#
# Baseline  Delta Abs  Shared Object          Symbol
# ........  .........  ..................... 
...................................................
#
               +11.95%  [kernel.kallsyms]      [k] folio_pte_batch
               +10.30%  [kernel.kallsyms]      [k] 
native_queued_spin_lock_slowpath
                +9.91%  [kernel.kallsyms]      [k] __block_write_begin_int
      0.00%     +8.56%  [kernel.kallsyms]      [k] clear_page_erms
      7.71%     -7.71%  [kernel.kallsyms]      [k] delay_halt
                +6.84%  [kernel.kallsyms]      [k] block_dirty_folio
      1.58%     +4.90%  [kernel.kallsyms]      [k] unmap_page_range
      0.00%     +4.78%  [kernel.kallsyms]      [k] folio_remove_rmap_ptes
      3.17%     -3.17%  [kernel.kallsyms]      [k] __vmf_anon_prepare
      0.00%     +3.09%  [kernel.kallsyms]      [k] ext4_page_mkwrite
                +2.32%  [kernel.kallsyms]      [k] ext4_dirty_folio
      0.00%     +2.01%  [kernel.kallsyms]      [k] vm_normal_page
      0.00%     +1.93%  [kernel.kallsyms]      [k] set_pte_range
                +1.84%  [kernel.kallsyms]      [k] block_commit_write
                +1.82%  [kernel.kallsyms]      [k] mod_node_page_state
                +1.68%  [kernel.kallsyms]      [k] lruvec_stat_mod_folio
                +1.56%  [kernel.kallsyms]      [k] mod_memcg_lruvec_state
      1.40%     -1.39%  [kernel.kallsyms]      [k] mod_memcg_state
                +1.38%  [kernel.kallsyms]      [k] folio_add_file_rmap_ptes
      5.01%     -0.87%  page_fault3_threads    [.] testcase
                +0.84%  [kernel.kallsyms]      [k] tlb_flush_rmap_batch
                +0.83%  [kernel.kallsyms]      [k] mark_buffer_dirty
      1.66%     -0.75%  [kernel.kallsyms]      [k] flush_tlb_mm_range
                +0.72%  [kernel.kallsyms]      [k] css_rstat_updated
      0.60%     -0.60%  [kernel.kallsyms]      [k] osq_unlock
                +0.57%  [kernel.kallsyms]      [k] _raw_spin_unlock
                +0.55%  [kernel.kallsyms]      [k] perf_iterate_ctx
                +0.54%  [kernel.kallsyms]      [k] __rcu_read_lock
      0.11%     +0.53%  [kernel.kallsyms]      [k] osq_lock
                +0.46%  [kernel.kallsyms]      [k] finish_fault
      0.46%     -0.46%  [kernel.kallsyms]      [k] do_wp_page
                +0.45%  [kernel.kallsyms]      [k] pte_val
      1.10%     -0.41%  [kernel.kallsyms]      [k] filemap_fault
                +0.39%  [kernel.kallsyms]      [k] native_set_pte
                +0.36%  [kernel.kallsyms]      [k] rwsem_spin_on_owner
      0.28%     -0.28%  [kernel.kallsyms]      [k] mas_topiary_replace
                +0.28%  [kernel.kallsyms]      [k] _raw_spin_lock_irqsave
                +0.27%  [kernel.kallsyms]      [k] percpu_counter_add_batch
                +0.27%  [kernel.kallsyms]      [k] memset
      0.00%     +0.24%  [kernel.kallsyms]      [k] mas_walk
      0.23%     -0.23%  [kernel.kallsyms]      [k] __pmd_alloc
      0.23%     -0.22%  [kernel.kallsyms]      [k] rcu_core
                +0.21%  [kernel.kallsyms]      [k] __rcu_read_unlock
      0.04%     +0.19%  [kernel.kallsyms]      [k] ext4_da_get_block_prep
                +0.19%  [kernel.kallsyms]      [k] lock_vma_under_rcu
      0.01%     +0.19%  [kernel.kallsyms]      [k] prep_compound_page
                +0.18%  [kernel.kallsyms]      [k] filemap_get_entry
                +0.17%  [kernel.kallsyms]      [k] folio_mark_dirty

Would be happy to help with further testing and providing additional 
data if required.

Thanks,
Suneeth D

> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Reviewed-by: Hao Li <hao.li@linux.dev>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>   mm/slub.c | 82 ++++++++++++++++++++++++++++++++++++++++++++++-----------------
>   1 file changed, 60 insertions(+), 22 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 41e1bf35707c..4ca6bd944854 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2889,7 +2889,8 @@ static void pcs_destroy(struct kmem_cache *s)
>   	s->cpu_sheaves = NULL;
>   }
>   
> -static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn)
> +static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn,
> +					       bool allow_spin)
>   {
>   	struct slab_sheaf *empty = NULL;
>   	unsigned long flags;
> @@ -2897,7 +2898,10 @@ static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn)
>   	if (!data_race(barn->nr_empty))
>   		return NULL;
>   
> -	spin_lock_irqsave(&barn->lock, flags);
> +	if (likely(allow_spin))
> +		spin_lock_irqsave(&barn->lock, flags);
> +	else if (!spin_trylock_irqsave(&barn->lock, flags))
> +		return NULL;
>   
>   	if (likely(barn->nr_empty)) {
>   		empty = list_first_entry(&barn->sheaves_empty,
> @@ -2974,7 +2978,8 @@ static struct slab_sheaf *barn_get_full_or_empty_sheaf(struct node_barn *barn)
>    * change.
>    */
>   static struct slab_sheaf *
> -barn_replace_empty_sheaf(struct node_barn *barn, struct slab_sheaf *empty)
> +barn_replace_empty_sheaf(struct node_barn *barn, struct slab_sheaf *empty,
> +			 bool allow_spin)
>   {
>   	struct slab_sheaf *full = NULL;
>   	unsigned long flags;
> @@ -2982,7 +2987,10 @@ barn_replace_empty_sheaf(struct node_barn *barn, struct slab_sheaf *empty)
>   	if (!data_race(barn->nr_full))
>   		return NULL;
>   
> -	spin_lock_irqsave(&barn->lock, flags);
> +	if (likely(allow_spin))
> +		spin_lock_irqsave(&barn->lock, flags);
> +	else if (!spin_trylock_irqsave(&barn->lock, flags))
> +		return NULL;
>   
>   	if (likely(barn->nr_full)) {
>   		full = list_first_entry(&barn->sheaves_full, struct slab_sheaf,
> @@ -3003,7 +3011,8 @@ barn_replace_empty_sheaf(struct node_barn *barn, struct slab_sheaf *empty)
>    * barn. But if there are too many full sheaves, reject this with -E2BIG.
>    */
>   static struct slab_sheaf *
> -barn_replace_full_sheaf(struct node_barn *barn, struct slab_sheaf *full)
> +barn_replace_full_sheaf(struct node_barn *barn, struct slab_sheaf *full,
> +			bool allow_spin)
>   {
>   	struct slab_sheaf *empty;
>   	unsigned long flags;
> @@ -3014,7 +3023,10 @@ barn_replace_full_sheaf(struct node_barn *barn, struct slab_sheaf *full)
>   	if (!data_race(barn->nr_empty))
>   		return ERR_PTR(-ENOMEM);
>   
> -	spin_lock_irqsave(&barn->lock, flags);
> +	if (likely(allow_spin))
> +		spin_lock_irqsave(&barn->lock, flags);
> +	else if (!spin_trylock_irqsave(&barn->lock, flags))
> +		return ERR_PTR(-EBUSY);
>   
>   	if (likely(barn->nr_empty)) {
>   		empty = list_first_entry(&barn->sheaves_empty, struct slab_sheaf,
> @@ -5008,7 +5020,8 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
>   		return NULL;
>   	}
>   
> -	full = barn_replace_empty_sheaf(barn, pcs->main);
> +	full = barn_replace_empty_sheaf(barn, pcs->main,
> +					gfpflags_allow_spinning(gfp));
>   
>   	if (full) {
>   		stat(s, BARN_GET);
> @@ -5025,7 +5038,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
>   			empty = pcs->spare;
>   			pcs->spare = NULL;
>   		} else {
> -			empty = barn_get_empty_sheaf(barn);
> +			empty = barn_get_empty_sheaf(barn, true);
>   		}
>   	}
>   
> @@ -5165,7 +5178,8 @@ void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, int node)
>   }
>   
>   static __fastpath_inline
> -unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
> +unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, gfp_t gfp, size_t size,
> +				 void **p)
>   {
>   	struct slub_percpu_sheaves *pcs;
>   	struct slab_sheaf *main;
> @@ -5199,7 +5213,8 @@ unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>   			return allocated;
>   		}
>   
> -		full = barn_replace_empty_sheaf(barn, pcs->main);
> +		full = barn_replace_empty_sheaf(barn, pcs->main,
> +						gfpflags_allow_spinning(gfp));
>   
>   		if (full) {
>   			stat(s, BARN_GET);
> @@ -5700,7 +5715,7 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
>   	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_NOMEMALLOC | gfp_flags;
>   	struct kmem_cache *s;
>   	bool can_retry = true;
> -	void *ret = ERR_PTR(-EBUSY);
> +	void *ret;
>   
>   	VM_WARN_ON_ONCE(gfp_flags & ~(__GFP_ACCOUNT | __GFP_ZERO |
>   				      __GFP_NO_OBJ_EXT));
> @@ -5731,6 +5746,12 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
>   		 */
>   		return NULL;
>   
> +	ret = alloc_from_pcs(s, alloc_gfp, node);
> +	if (ret)
> +		goto success;
> +
> +	ret = ERR_PTR(-EBUSY);
> +
>   	/*
>   	 * Do not call slab_alloc_node(), since trylock mode isn't
>   	 * compatible with slab_pre_alloc_hook/should_failslab and
> @@ -5767,6 +5788,7 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
>   		ret = NULL;
>   	}
>   
> +success:
>   	maybe_wipe_obj_freeptr(s, ret);
>   	slab_post_alloc_hook(s, NULL, alloc_gfp, 1, &ret,
>   			     slab_want_init_on_alloc(alloc_gfp, s), size);
> @@ -6087,7 +6109,8 @@ static void __pcs_install_empty_sheaf(struct kmem_cache *s,
>    * unlocked.
>    */
>   static struct slub_percpu_sheaves *
> -__pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
> +__pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
> +			bool allow_spin)
>   {
>   	struct slab_sheaf *empty;
>   	struct node_barn *barn;
> @@ -6111,7 +6134,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
>   	put_fail = false;
>   
>   	if (!pcs->spare) {
> -		empty = barn_get_empty_sheaf(barn);
> +		empty = barn_get_empty_sheaf(barn, allow_spin);
>   		if (empty) {
>   			pcs->spare = pcs->main;
>   			pcs->main = empty;
> @@ -6125,7 +6148,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
>   		return pcs;
>   	}
>   
> -	empty = barn_replace_full_sheaf(barn, pcs->main);
> +	empty = barn_replace_full_sheaf(barn, pcs->main, allow_spin);
>   
>   	if (!IS_ERR(empty)) {
>   		stat(s, BARN_PUT);
> @@ -6133,7 +6156,8 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
>   		return pcs;
>   	}
>   
> -	if (PTR_ERR(empty) == -E2BIG) {
> +	/* sheaf_flush_unused() doesn't support !allow_spin */
> +	if (PTR_ERR(empty) == -E2BIG && allow_spin) {
>   		/* Since we got here, spare exists and is full */
>   		struct slab_sheaf *to_flush = pcs->spare;
>   
> @@ -6158,6 +6182,14 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
>   alloc_empty:
>   	local_unlock(&s->cpu_sheaves->lock);
>   
> +	/*
> +	 * alloc_empty_sheaf() doesn't support !allow_spin and it's
> +	 * easier to fall back to freeing directly without sheaves
> +	 * than add the support (and to sheaf_flush_unused() above)
> +	 */
> +	if (!allow_spin)
> +		return NULL;
> +
>   	empty = alloc_empty_sheaf(s, GFP_NOWAIT);
>   	if (empty)
>   		goto got_empty;
> @@ -6200,7 +6232,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
>    * The object is expected to have passed slab_free_hook() already.
>    */
>   static __fastpath_inline
> -bool free_to_pcs(struct kmem_cache *s, void *object)
> +bool free_to_pcs(struct kmem_cache *s, void *object, bool allow_spin)
>   {
>   	struct slub_percpu_sheaves *pcs;
>   
> @@ -6211,7 +6243,7 @@ bool free_to_pcs(struct kmem_cache *s, void *object)
>   
>   	if (unlikely(pcs->main->size == s->sheaf_capacity)) {
>   
> -		pcs = __pcs_replace_full_main(s, pcs);
> +		pcs = __pcs_replace_full_main(s, pcs, allow_spin);
>   		if (unlikely(!pcs))
>   			return false;
>   	}
> @@ -6333,7 +6365,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
>   			goto fail;
>   		}
>   
> -		empty = barn_get_empty_sheaf(barn);
> +		empty = barn_get_empty_sheaf(barn, true);
>   
>   		if (empty) {
>   			pcs->rcu_free = empty;
> @@ -6453,7 +6485,7 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>   		goto no_empty;
>   
>   	if (!pcs->spare) {
> -		empty = barn_get_empty_sheaf(barn);
> +		empty = barn_get_empty_sheaf(barn, true);
>   		if (!empty)
>   			goto no_empty;
>   
> @@ -6467,7 +6499,7 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>   		goto do_free;
>   	}
>   
> -	empty = barn_replace_full_sheaf(barn, pcs->main);
> +	empty = barn_replace_full_sheaf(barn, pcs->main, true);
>   	if (IS_ERR(empty)) {
>   		stat(s, BARN_PUT_FAIL);
>   		goto no_empty;
> @@ -6719,7 +6751,7 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
>   
>   	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id())
>   	    && likely(!slab_test_pfmemalloc(slab))) {
> -		if (likely(free_to_pcs(s, object)))
> +		if (likely(free_to_pcs(s, object, true)))
>   			return;
>   	}
>   
> @@ -6980,6 +7012,12 @@ void kfree_nolock(const void *object)
>   	 * since kasan quarantine takes locks and not supported from NMI.
>   	 */
>   	kasan_slab_free(s, x, false, false, /* skip quarantine */true);
> +
> +	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id())) {
> +		if (likely(free_to_pcs(s, x, false)))
> +			return;
> +	}
> +
>   	do_slab_free(s, slab, x, x, 0, _RET_IP_);
>   }
>   EXPORT_SYMBOL_GPL(kfree_nolock);
> @@ -7532,7 +7570,7 @@ int kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags, size_t size,
>   		size--;
>   	}
>   
> -	i = alloc_from_pcs_bulk(s, size, p);
> +	i = alloc_from_pcs_bulk(s, flags, size, p);
>   
>   	if (i < size) {
>   		/*
>

