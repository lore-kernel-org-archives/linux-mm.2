Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B04D9CCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 06:23:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6B696B00A3; Fri, 16 Oct 2026 02:23:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1CB16B00A4; Fri, 16 Oct 2026 02:23:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0A9A6B00A5; Fri, 16 Oct 2026 02:23:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8853E6B00A3
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 02:23:53 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0D6C61202CF
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:23:53 +0000 (UTC)
X-FDA: 85327498746.18.BE5DD90
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010028.outbound.protection.outlook.com [52.101.46.28])
	by imf20.hostedemail.com (Postfix) with ESMTP id EB4A81C0004
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:23:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=GZf7LFUz;
	spf=pass (imf20.hostedemail.com: domain of KPrateek.Nayak@amd.com designates 52.101.46.28 as permitted sender) smtp.mailfrom=KPrateek.Nayak@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792131830;
	b=ZzgfLKrMp1qCILI4c3IGN7nM6PgpCRcFngM9LMJiXiXoY61mmLrIh6VfFnAh2oN3jCqCK5
	ErOeJBMwlVYWaNkP77hUWgt4rFlfBjXsdZw0JiId1LwXszwTgPh/eB39Xtzw/euGXPl/pm
	tXTu/OWhfwt2iICgWp/deoawFoxs5D0=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=GZf7LFUz;
	spf=pass (imf20.hostedemail.com: domain of KPrateek.Nayak@amd.com designates 52.101.46.28 as permitted sender) smtp.mailfrom=KPrateek.Nayak@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792131830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=czSLFUGDMzAFLI3Pr/+hBd+9bUbci1aNuPRSFzs8ryQ=;
	b=Fg5Y85NDo7a586HNF2uA+PwwJOjEiJXwUr838U7OfjK1rCUhTzRHfxeWIL19nxb4Wh3cnl
	aHvI28uWJ9lS4quzH1pyJI67hi+5szMDVo5h+STLDyGkZzirH6JjcNwTXq3mogIBOcLH2v
	Fr9Jsuu7Ro1C4gL8hirCpE4azdUNALU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vrebuuRzkQ4MJu/AlPvXTlS3ygwTAxJd8L4kdZJ7CpIbjqo8dv5+cfJAmWQxxdUTTOd3tmOIPp+TLKCToxaPT527zRTartl1rTVTDk0JUZ8if4koqeiHtf2+2wEIVUekV90qdL6G/IC1YRKKd0OzB9lArCC+P5+EW+6ozwU075V8Lq4hVruqmlyDRT7Ll7y+kQD3o25p6shrVoyh3gs5CH5Kt7rWxm4ngF6nB6rozmDLA/kVd/a+6hF6medGYUvXoLsd/6WgwSqlq9E82FAM1tQ2nYU8X92Aq5zrLQp7M4ODXyKRhQSTub/tXMc6gkVERPXuDH9VvXHxfkKs0N+lag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=czSLFUGDMzAFLI3Pr/+hBd+9bUbci1aNuPRSFzs8ryQ=;
 b=Y1uOZNmrZ3fIMggBT8fU4rTOGjaURlixroJtIZ5NUcI9iPzlwjjjsET0fGSJSfHgV9qIALNuU7TNcUupg3WfGWXhXyzJF2PT/iJqZ7ZTvQzuzbYLbNsU/xpeF7QHAl6wsC/VzaVklE8ojLAjPiyeE5ARhiZ7Iw4RqR0Ta9SbTZWlB5Tmhzi8pBpEN+3fLC1OGItEf+JWKRBYVpQSxu9m6RtZqmbuIOyLaG638dFdh+BysNYlDmEzcAncxDcIVO7evvYiyz/x1lDS+hs/758nvAql4spS3cFExhR/knqGCTLrqL5LeDcEoECAEb57bHUBOtTUDmm3oufSVrpu4vmCSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=soleen.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=czSLFUGDMzAFLI3Pr/+hBd+9bUbci1aNuPRSFzs8ryQ=;
 b=GZf7LFUzS8MvemknUjhEgE4bhTlxpTZH9a35BqyZ7p8paUjfi46/VDQoIHBiERuKKQDRDx+qPbwsZdlF2uOPVEaVV+Psj8hKz8Uf8ZpHJ+UXIjgCHUVhmJU4l4hsEt53onvzDKskf8sXLBIUrNXhvkX89iSG/DkGUjGYF8/MYh8=
Received: from BY3PR04CA0017.namprd04.prod.outlook.com (2603:10b6:a03:217::22)
 by SA9PR12MB407125.namprd12.prod.outlook.com (2603:10b6:806:a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.20; Fri, 16 Oct
 2026 06:23:45 +0000
Received: from EA8PEPF00000006.namprd05.prod.outlook.com
 (2603:10b6:a03:217:cafe::3f) by BY3PR04CA0017.outlook.office365.com
 (2603:10b6:a03:217::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Fri, 16
 Oct 2026 06:23:45 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 EA8PEPF00000006.mail.protection.outlook.com (10.167.249.229) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 06:23:45 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Fri, 16 Oct
 2026 01:23:38 -0500
Received: from [10.136.45.168] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.53 via Frontend
 Transport; Fri, 16 Oct 2026 01:23:28 -0500
Message-ID: <b618f528-ba35-4fb3-881b-e0ca12bc9558@amd.com>
Date: Fri, 16 Oct 2026 11:53:21 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 5/8] sched/topology: Avoid redundant O(N^3) group
 capacity walks and unused allocations in build_sched_domains()
To: Pasha Tatashin <pasha.tatashin@soleen.com>, <kees@kernel.org>,
	<rppt@kernel.org>, <juri.lelli@redhat.com>, <nik.borisov@suse.com>,
	<tglx@kernel.org>, <vschneid@redhat.com>, <vincent.guittot@linaro.org>,
	<bp@alien8.de>, <thorsten.blum@linux.dev>, <cgroups@vger.kernel.org>,
	<tony.luck@intel.com>, <david@kernel.org>, <mingo@redhat.com>,
	<akpm@linux-foundation.org>, <linux-mm@kvack.org>, <seanjc@google.com>,
	<ljs@kernel.org>, <zhangguopeng@kylinos.cn>, <dietmar.eggemann@arm.com>,
	<mhocko@suse.com>, <vinicius.gomes@intel.com>, <tj@kernel.org>,
	<vbabka@kernel.org>, <linux-kernel@vger.kernel.org>, <peterz@infradead.org>,
	<surenb@google.com>, <hpa@zytor.com>, <x86@kernel.org>,
	<dmatlack@google.com>, <tim.c.chen@linux.intel.com>,
	<kexec@lists.infradead.org>, <pratyush@kernel.org>,
	<dave.hansen@linux.intel.com>, <rostedt@goodmis.org>, <gmonaco@redhat.com>,
	<jgross@suse.com>, <mgorman@suse.de>, <graf@amazon.com>,
	<linux-edac@vger.kernel.org>, <liam@infradead.org>, <ridong.chen@linux.dev>,
	<longman@redhat.com>, <bsegall@google.com>
References: <20261015153331.1872641-1-pasha.tatashin@soleen.com>
 <20261015153331.1872641-6-pasha.tatashin@soleen.com>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <20261015153331.1872641-6-pasha.tatashin@soleen.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: EA8PEPF00000006:EE_|SA9PR12MB407125:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b6d24ad-fbb3-4d95-ce32-08df2b4e081a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|36860700016|82310400026|921020|11063799006|56012099006|4143699003|261009223027099003|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	cwyugd9Ar6kwce5wuyRcoWNsxU77MTwwjmePIXiPadVq2WbGRID6tG6CRm9pKlIzwlT5OO5aQoVIMkrXOY7NTPPTkFubpgsnE6PbXXmfG7EpGW4A8Bbh7Eqyirt60CzVeqYiqnUAdfgTY1s7NgJaJVirJ8MJQaQal7CXqeQZ19v/LiAWYBA1GVIrt2bCukyZVKCrvKMj50F+JyDfZ3d7h59LZ4+GYVeEnQoj/P40/hAk2MPNxQ1RB4hSv56PvFFXs3/4n3vnFecoRv4cog1SfFP/ep7qhGeRmRcevQcttZTbIu24uUSZRj2Y+aJZP/vI77Qkt/n3PB7ImHu1ZKFUEzZu7SwLMQ2gTui/lCIm2tKBa+V+iuh058K8NM7JMYCSmaCW34XyysIJu3+wCtbl5Ri8OC3/YkOn4F82TIWW81vdiqJEhdnrEnWnZKBAwx1/mO80pFNNkwxwxpbpiaMSTmLvTFw8DEC90srHmtHP9tW3WftLO+YWUdi6PTtw19cqyGmMPTlSG/ktJV0bcIievwy1snXrSR5E+jKYAOOxt+R66uiKQ4l9l9ON0OLFXxe5mNUGDyaDmxV9RPMFpqj3nrxeB1Dg1IJn5mY9o4DYK7WdqFibz607Ltz60UfPK5wr5C7ngi3ez7LBMgNq7mdvg0zJ2e2n7aQiDTgndrJibLwbiWac0kpHsapMrlnxjpzwBYLktMz2iQ1J47ulZc7pKs2qL4uBuMgTQRj8MCKq5OijHbwuYjeow6jlgyBLPumO
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(36860700016)(82310400026)(921020)(11063799006)(56012099006)(4143699003)(261009223027099003)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/HaWa5VmaHTpxA2nn6kKUeGS9PCYyqO2z1eyacGJFLrydEv7+ujDqh5I94fqZ5Qo8mGXvd/Zlgj/sBR6sJKBxNtrQf0F1/oOpesFdtTd13QEYoOtOo692RMgxQ3IEJ4MxBAp91GoW2jprO0r7zydDh3ZauhZlHRCWTIUt4/Ho0b9/C6etvZbmPFx4MN8DydPxxxxMmx71idIp+dtUAP4s/AvfmujzMTjd08e+Bh2cRuWoUoqxTM58B22aT5QqhcMz+Mgg95fYKpJW5B8dMaRWDBN0g74kMHeHEhf4hkpjfPyRxaCBAnPQZbtihdDIQTy5BC6U8IJ+o2CX+WbzwZ6qCHQOQSFfIClq1H19ztV/+bA7Aq+8DOnm7XozfOWz7nfBTOjW8h1/Y0MJ4+ICCFp9K3SET7NB2pqqK1DFaTdMceGopHhJW0FsdDFuKjtMSEE
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 06:23:45.1969
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b6d24ad-fbb3-4d95-ce32-08df2b4e081a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	EA8PEPF00000006.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA9PR12MB407125
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EB4A81C0004
X-Rspam-User: 
X-Stat-Signature: 9hhowso5xqcg9oouyfwucm5ydnnged4k
X-HE-Tag: 1792131829-301698
X-HE-Meta: U2FsdGVkX1/T5Kd23tOVATuKH6/a9MTodulT+jvf2zToryAGe4yEzEFsRDCUO4XMgkBBnGkFqypXlD5qLY78I/PhdCOs1PiZrBimwtprnZYFNofSqUoKexGZgVsjAjaeubKlpA2uwkND/Wi1GdT5Yqo8kld0KaqDZ914hXPm/Csu2Q4MSBuQFALfGM9Vn7zAsSkP6dRb7v0muL+8v+1pxmvrlf5DTWWjYzkM6YmMQ2l0aeabVyd71iHMoTUOFhPZ1nH1mJ/+LjTSj9519kTG+l6P9u9pPdbmyOFIc3HFgIft6x739muOQRtQUm/v/NutplWVGohKUK9JDMdZWJ/t4oSuwCc3lo1pZSF40zkbjlJg+9GoM77TpvevCPsJZ4DVeKSQ3DiVr3LYfAwFPauWFwiyDYrrnrgcHbrF3G0+0Z5BQPcaF75L7vjCZGp6qprsIGFw6letBlNtj1L5lyKBd/JGfIm02UV/2tUWF8ks7PbGDwOozDwqkHJZzprXZ9n2GFH6W+R+IofMerX9QROGoEDspZlUd05U2fbN8l95+RhkNtNrimVZ3rFXoRHLgQQ/raiF2uy1TjmbHHRJ3EYXX5U4OQjO5zC0PKhcL15qRZ9j2q/7rNm81e/R0tEM7MLPnN3opeVTrxs5hd2w1szcr1QEq4IhyMCetNoLcTQ7H/0avWsnFUl5MR7PyI/zQYUtOho2PSffFOJl+MSFdYPTj1DcAOSbECjir1fwrUGnkNSxdoUgsq6eebWQt2jZXjV9xbVUPbynoBN17H9Z4IylQ3cYiGk26OdN4k98XnNXR/rENL2fFyuEmQOR58Ji9cp+N7La10IXH49TWOJ5rUjJGVfI184XWpA9SB/rhyqbAi/zLaQw/TBWUqVxgKxcITcIWXIsfMTVY0fpQ7km1bOkXxFwMa2XZV6553nYRj4DQLwzvTSVzuystGORYxph/ZyO0D9I7/ctuwfhOLRC3F5
 gw/jtYsB
 gkZlNKnqNVVA4RCh3x8cNHvX5ZricfM/j26CQ22ptM0vN0/n3pIUn50H4dQ7XSife/XL35yngv9gvuvPJT9l9r2IDZGfCZMQZlti4GNkeFDGUTx+5wa5Hx4R0hGt/p2n22suyR+NTl7oDQerqkEI/DQcbk0Yo9TNWxAIQxBNOFHTCqIvtQfKjcsyVng6DYVbu9HviMwJfdSBsDvEHBpLt4zaMTaubeO4/+REXUMAkd+k3oHyGZQmOVgzrhbUzVZ2t8uq6VGX9CG3o6HaXOCJK6a+1OB3h+l6rqaZS9xXuv5HfKhGVvo/tZGUer/i/dOI4yHSwvtVGUF3/5/+a+YZ7gWDK8o2ROeOm5RElr9hj+FX4Oj2IODff0XlXj6j8Odehqoy7jOLMVq54i0d4W66sI+hbUxS5hOUDedqOjk2wnfW+CQby23b83DsLWA6KRrd0K1A5vtNwzq8bThYHCelE6xnOkwgP9/Rexyu+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Pasha,

On 10/15/2026 9:03 PM, Pasha Tatashin wrote:
> diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
> index 0248227d983a7..02c38089a80c9 100644
> --- a/kernel/sched/topology.c
> +++ b/kernel/sched/topology.c
> @@ -1259,32 +1259,49 @@ build_group_from_child_sched_domain(struct sched_domain *sd, int cpu)
>         return sg;
>  }
> 
> -static void init_overlap_sched_group(struct sched_domain *sd,
> -                                    struct sched_group *sg)
> +static int init_overlap_sched_group(struct sched_domain *sd,
> +                                   struct sched_group *sg)
>  {
>         struct cpumask *mask = sched_domains_tmpmask2;
>         struct sd_data *sdd = sd->private;
> -       struct cpumask *sg_span;
> -       int cpu;
> +       struct cpumask *sg_span = sched_group_span(sg);
> +       struct sched_group_capacity *sgc;
> +       int cpu = cpumask_first(sg_span);
> +       struct sched_domain *first_sd = *per_cpu_ptr(sdd->sd, cpu);
> +
> +       sgc = *per_cpu_ptr(sdd->sgc, cpu);
> +       if (sgc && atomic_read(&sgc->ref) > 0 &&
> +           first_sd && first_sd->child &&
> +           cpumask_equal(sg_span, sched_domain_span(first_sd->child))) {
> +               atomic_inc(&sgc->ref);
> +               sg->sgc = sgc;
> +               return 0;
> +       }


This insanely specific check perhaps can be something like:

diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 06cc9f6397bd..a7d7a3b51c71 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -1203,6 +1203,33 @@ int group_balance_cpu(struct sched_group *sg)
  */
 
 
+/* Find the group_balance_cpu() */
+static int find_group_balance_cpu(struct sched_domain *sd, struct sched_group *sg)
+{
+	const struct cpumask *sg_span = sched_group_span(sg);
+	struct sd_data *sdd = sd->private;
+	struct sched_domain *sibling;
+	int i;
+
+	for_each_cpu(i, sg_span) {
+		sibling = *per_cpu_ptr(sdd->sd, i);
+
+		/*
+		 * Can happen in the asymmetric case, where these siblings are
+		 * unused. The mask will not be empty because those CPUs that
+		 * do have the top domain _should_ span the domain.
+		 */
+		if (!sibling->child)
+			continue;
+
+		/* If we would not end up here, we can't continue from here */
+		if (cpumask_equal(sg_span, sched_domain_span(sibling->child)))
+			return i;
+	}
+
+	return nr_cpu_ids;
+}
+
 /*
  * Build the balance mask; it contains only those CPUs that can arrive at this
  * group and should be considered to continue balancing.
@@ -1212,17 +1239,19 @@ int group_balance_cpu(struct sched_group *sg)
  * can fully construct this using the sched_domain bits (which are already
  * complete).
  */
-static void
-build_balance_mask(struct sched_domain *sd, struct sched_group *sg, struct cpumask *mask)
+static void build_balance_mask(int group_balance_cpu,
+			       struct sched_domain *sd,
+			       struct sched_group *sg,
+			       struct cpumask *mask)
 {
 	const struct cpumask *sg_span = sched_group_span(sg);
 	struct sd_data *sdd = sd->private;
 	struct sched_domain *sibling;
-	int i;
+	int i = group_balance_cpu;
 
 	cpumask_clear(mask);
 
-	for_each_cpu(i, sg_span) {
+	for_each_cpu_from(i, sg_span) {
 		sibling = *per_cpu_ptr(sdd->sd, i);
 
 		/*
@@ -1281,7 +1310,17 @@ static int init_overlap_sched_group(struct sched_domain *sd,
 	struct cpumask *sg_span;
 	int cpu;
 
-	build_balance_mask(sd, sg, mask);
+	cpu = find_group_balance_cpu(sd, sg);
+	if (WARN_ON_ONCE(cpu >= nr_cpu_ids))
+		return -ENOENT;
+
+	sg->sgc = *per_cpu_ptr(sdd->sgc, cpu);
+	if (sg->sgc && atomic_read(&sg->sgc->ref)) {
+		atomic_inc(&sg->sgc->ref);
+		return 0;
+	}
+
+	build_balance_mask(cpu, sd, sg, mask);
 	cpu = cpumask_first(mask);
 
 	sg->sgc = *per_cpu_ptr(sdd->sgc, cpu);
---

We just find the first CPU and reuse the scg. Otherwise, build the
balance mask.

With those changes ...

> 
>         build_balance_mask(sd, sg, mask);
>         cpu = cpumask_first(mask);
> 
> -       sg->sgc = *per_cpu_ptr(sdd->sgc, cpu);
> -       if (atomic_inc_return(&sg->sgc->ref) == 1)
> +       sgc = *per_cpu_ptr(sdd->sgc, cpu);
> +       if (!sgc) {
> +               sgc = kzalloc_node(sizeof(*sgc) + cpumask_size(),
> +                                  GFP_KERNEL, cpu_to_node(cpu));
> +               if (!sgc)
> +                       return -ENOMEM;
> +               sgc->id = cpu;
> +               *per_cpu_ptr(sdd->sgc, cpu) = sgc;
> +       }
> +
> +       sg->sgc = sgc;
> +       if (atomic_inc_return(&sg->sgc->ref) == 1) {

... we can be sure this is a new sgc and just do an
atomic_set(&sg->sgc->ref, 1) here and initialize the rest of the
fields.

Thoughts?

>                 cpumask_copy(group_balance_mask(sg), mask);
> -       else
> +               sg->sgc->capacity = SCHED_CAPACITY_SCALE * cpumask_weight(sg_span);
> +               sg->sgc->min_capacity = SCHED_CAPACITY_SCALE;
> +               sg->sgc->max_capacity = SCHED_CAPACITY_SCALE;
> +       } else {
>                 WARN_ON_ONCE(!cpumask_equal(group_balance_mask(sg), mask));

Do note this check will be lost with the optimization for the
fast-path case but that should be okay(?)

> +       }
> 
> -       /*
> -        * Initialize sgc->capacity such that even if we mess up the
> -        * domains and no possible iteration will get us here, we won't
> -        * die on a /0 trap.
> -        */
> -       sg_span = sched_group_span(sg);
> -       sg->sgc->capacity = SCHED_CAPACITY_SCALE * cpumask_weight(sg_span);
> -       sg->sgc->min_capacity = SCHED_CAPACITY_SCALE;
> -       sg->sgc->max_capacity = SCHED_CAPACITY_SCALE;
> +       return 0;
>  }
-- 
Thanks and Regards,
Prateek


