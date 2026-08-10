Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10049C5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 04:47:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBB746B007B; Mon, 10 Aug 2026 00:46:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6C406B008A; Mon, 10 Aug 2026 00:46:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5AF86B008C; Mon, 10 Aug 2026 00:46:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7BB0F6B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 00:46:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5B29EA0669
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 04:46:57 +0000 (UTC)
X-FDA: 85084124874.10.BF55EEA
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012045.outbound.protection.outlook.com [52.101.48.45])
	by imf10.hostedemail.com (Postfix) with ESMTP id 02F4AC0002
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 04:46:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=oLvwq0zi;
	spf=pass (imf10.hostedemail.com: domain of bharata@amd.com designates 52.101.48.45 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786337214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pE3hfiH+7328qwcdNDZ1DtTmJfiHK5EJRXyq/L2n9hs=;
	b=orudr0Nq0HUXIyTBM+OUP6EsDw4TrwE39IYPkb5Bu002mnQ7p8jrtdBiVcDSom+V8EVl8s
	puibmH7+hjW2d1F8ONkywAVMuJ3nqf6tTQ0zW+s3XA4CAuAUlRxkptp9zXTOk09UnedSW6
	F/E9TVDgAqaBeMwjszmYiS4Zeykepy4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786337214;
	b=rzqMDA7jLkGcy6CQawzBls1gzDO9q0lZSWCgRqTTZ27tV+s+d1zitdhD/3iiyNh9JD5SjR
	rAqvnMEatoF2fKmY5OQ2sbi/Dq1sj8SPzPiwPBpDFTSIeiBhYVgvX4MdD2FV5L7s7dvSyQ
	4hFD8jNBqUgWcryrcey6aAUOwjSgW9s=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=oLvwq0zi;
	spf=pass (imf10.hostedemail.com: domain of bharata@amd.com designates 52.101.48.45 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ErQJ2AmmPvLN3fe9QJYqLEZ05ZBunKVLHnfNHAAH7BCDbOIHuV6z7CghXehhtycEjew7gAcvYGNMPFmmMoSPCWLb1kk6IvlC3apQVCqoxR1Tf1sZfouTdpeybYLA/VFJEVtNRUAucm06ko7Y8vxhiWp4fHoAfopGcA9i/yWGO+YhJXB5dvTIPSLSk+hs17pD2hADCuBXn3qGgxlGERLz3O6a0hjD8E6U8IKeqQPNZCMsAmuX+mEOH98sk4tS0toKha1PVqC9jQtuHYb/XyqVJLSEc5NYmak/nUmTzzlcps39TwS1Fcvg1XxLuyyugZnwFBjkRGSv19CydpJbibtkew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pE3hfiH+7328qwcdNDZ1DtTmJfiHK5EJRXyq/L2n9hs=;
 b=OsOo0AkQSBKQ/qeIc9EymzJCQ7EWSOwUjcjydToXHzsKM/jAgDSu03dmoQypsaI77imVACwMDJjuTVVEYXPsTH9oZZgPQN5JxQwVBnUA+cri5ypDKiTHLh97i9vLZnr6ahNGEleiK72qeupOWwpDnWkslLddhfZeeZ36E/m6WjY5kpGurKtPhkSmTtmCNCmHLoDYESHAdzdK0TrhKYC+28E4E17tdkpgQT5neDQm0zsh8Xw7QRhjKCtW7CdAayaCIKwqDxsjLRMoSpcRDHr0zxaewYksMByItPnytKd1cCEmsXUsetUXwYvy+hGzHLuX88gQTDRX6DAqTcB1Q+kF6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pE3hfiH+7328qwcdNDZ1DtTmJfiHK5EJRXyq/L2n9hs=;
 b=oLvwq0zixfGXXR3xdY6LMocF5ecxbfauiQlv7JZwd9ZS6KbhEbjle0Zks9t/gIShN88T/FbNzWcWPrnEZGdUizTEeKvuzRQdMNpMFGGn8ceThSvJAfjzRsPyBITAtPRRwKxBWHVKpe3IC9HNN0VYwSOcfzk9cjdqVOVlSLiAaKY=
Received: from BN1PR14CA0027.namprd14.prod.outlook.com (2603:10b6:408:e3::32)
 by PH7PR12MB8124.namprd12.prod.outlook.com (2603:10b6:510:2ba::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 04:46:46 +0000
Received: from BN2PEPF00004FBE.namprd04.prod.outlook.com
 (2603:10b6:408:e3:cafe::70) by BN1PR14CA0027.outlook.office365.com
 (2603:10b6:408:e3::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.25 via Frontend Transport; Mon,
 10 Aug 2026 04:46:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF00004FBE.mail.protection.outlook.com (10.167.243.184) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.6 via Frontend Transport; Mon, 10 Aug 2026 04:46:45 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sun, 9 Aug
 2026 23:46:45 -0500
Received: from [10.136.47.225] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.45 via Frontend
 Transport; Sun, 9 Aug 2026 23:46:38 -0500
Message-ID: <a2fd8c7d-d6d7-4c79-8b4d-3860c04a586f@amd.com>
Date: Mon, 10 Aug 2026 10:16:37 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/8] mm: Hot page tracking and promotion infrastructure
To: SJ Park <sj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <weixugc@google.com>, <willy@infradead.org>,
	<ying.huang@linux.alibaba.com>, <ziy@nvidia.com>, <dave@stgolabs.net>,
	<nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>, <yiannis@zptcorp.com>,
	<david@kernel.org>, <byungchul@sk.com>, <kinseyho@google.com>,
	<joshua.hahnjy@gmail.com>, <yuanchu@google.com>, <balbirs@nvidia.com>,
	<alok.rathore@samsung.com>, <shivankg@amd.com>, <donettom@linux.ibm.com>
References: <20260806134454.96428-1-sj@kernel.org>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <20260806134454.96428-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBE:EE_|PH7PR12MB8124:EE_
X-MS-Office365-Filtering-Correlation-Id: a6a32b13-5071-4598-dd9b-08def69a61d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|36860700016|30052699003|1800799024|376014|7416014|10067099003|11063799006|5023799004|6133799003|3023799007|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	bW5qNT3gWV1ow41Qisem0HhMRJLJ5/AFY/j97KJwIw3XA4zTtrEPzI42it8+m8HPf37xNjhrEm+1Ge65fNZ5DQ+6PCZ+u3dL6CfwysTTLiZFRYgLG0LvA6MVqE9nWYG8UUUYZgeI48hNQYdBrwi8TAxkVKbDf2YyPsPdNUEoG7c/7F4YukjvD9B9l8qHyjl7McjYM+bE52M4dbWYZAbGEiFyEn3IMfGokVqO3eNseAT7UbdhNNacKbRmGsIDVmZRkrPvkHXKp0zFRgmrhtBPONF+N21VEsPQjEB9Y413i8/5YRJDaqFfen99N2G/YKxoXs6HJeq1TtLUqZG3u31SlEt/sRYz8z/pF6LgXwnBWPuzZi1SR25U1aosPGkWLQxW+tpoNBMxfhBwV4dSA9BxAfwCTOSE60JrWXdllfIgacdxzUElIa2YRz6T/lEpw+4QVZFCiERHwL4zenfadQ12GvdbB1AwGAtZ9s0Bdbi5N1z5Sh11ENFXD9u3ptWmnLgGe1wzoqhlCWNgPF921JacQYiC43kNCJ+6Nti6K6mZPUBnZNkmPZLQxK+rjZzFkkyCRq0oMBFBJrl92jqGLGXiBNomGglOuOuox7+LvBsacaWBTlyhxWCVM5uMMY7n4AFf6Q6WfLaG+fgyCmaeotFCYJn8v/pqpT4HOvkla58QdoL7MHa17y62Hq2TOkxQcZsZkUkD2ZPAdOcqmUcY+luPmA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(36860700016)(30052699003)(1800799024)(376014)(7416014)(10067099003)(11063799006)(5023799004)(6133799003)(3023799007)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	EDmu/MuTjequuZz8QZ/1e+DgAXIc4BiAuRBqBgAq5EsM8360T/wn+UUIFO9oBW9+NNY4rH0vPSMON/B7TNLVk5MXE2OD6NIcP3FJAflsTOf4XdoEtUGWYveqx41hdopWudPuhk7ZWqFQ9OHwJE0RlHjTp0oOZYA9DhDzgke/c3r7OmJ/Bi18fOTCA+tdYassz8HPnW9DoQXsR1WSoyUGG6/alOz+/8ZRjzbSPunoYULQYjLchjBXvgMkZnaFi49/ukYJ6vqdP8Pert3CypFFfNy+UFJD4TgOmBtUwJn3yTwtya39mY4AJMj33xtPkmo6QioBMABj1GS2bXSXu1k7QizqJHgyHzOELuChKbi7UXyn1SNfyxPBGA9yy3n1PESO4U9P7Ghu+4Hx/EoS0lXNuH2lEn9oVktWlb2rF42vL9z/4tr7B6LmT0Ngr0zK3DBZ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2026 04:46:45.9678
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a6a32b13-5071-4598-dd9b-08def69a61d7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBE.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8124
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 02F4AC0002
X-Stat-Signature: hpqxa3shbmd7ptbxcofsozc9ezfxp7cw
X-HE-Tag: 1786337213-12163
X-HE-Meta: U2FsdGVkX1/OdK0qwWiRZZ1hn95Ldtuqr5LCRktMpj1ca+9cZbbpNCiAnK8TsGfqJJfl4RJX3atkLm4U9fWmHihJKvPkqO+e77n01ZPRRKr0xuk4VtOM5tRJ1HhWaj/PDpOBXogz5j2tVrLQi6w8QdqHYM2P9JXMgP2vTfO8HnoGFfkNSJFNWzO5xOr2G07Aq10J9Y6UNTxMRJxG2DqtlzxiNctj9241fr6RHRhQmgKByranTOXbDSQTO+qAyJOQ0DL07zwYdDr/WqUbXb3WpkXjsJC9UpPY7SErFDW48ylZFlJePzXRtKD28ZVqpqIPC0Vz+/c6Z/SxoCDGEon1g+n9iQ7AvOI827GRKEmqxD4l9gweBe4e6SZXwoP9RlnboABHR1bQrzwW10mm7jUYcPffpLtj5HXDIdWYqnxaQnN5/ZPhE8k6b+2HrohwWspmvqctkf13CnlkpVgNV0phssQuqW0+kJZQ8B3q2c6brCIgfFoSkqNDS2dPlzAH+yB1WQCz1SlQ6K9RGqg4WE9v/ccygaqiYG11bxVsiXA/67tTE2gPXWhRElDsma0sy1ghwcSKmEYu6f88hg+h/K4GOOwfXdIRW6OXB2mgNrwSm8fkY4hoi8JuJwOCnt0GL2yV0iZ26db5RC/cSiDynghAE+Phmw7RHj3GRlatkxXUhz5Y6kRwLx2eGchvux++7jrghX66p+pb/wzyNnnvpApPAuJcWHB2gLSAuLlKoqPPDTxf67/ZHwDeAaatwHVE55G1B5QYGDQuV4BuiKouXrIzM2+zNIUIGh8j9cvU1NOND9sOkMF9p93q7NjaWOBCjvS4lTf85GrDvXnv7JAXI8xz/Gx4mK0w6wEr5D9BiicVKGIhzKA+gSL98TWHM/PD7w5SPX6xPImvzRKmmKbmvXm/KCeZgEn+aTtEVRfSUUAZpy5oqjry/GDzUixVihZDnGWPhXMRb/t8L5UNJm7qL3q
 +HTtAPLV
 0fYksPHhRN1R2YLjr/Cedh0fy8bwvIk9oPezFIPF6/d4dcSalm4wuuIJ5/cTnxoOfjNYpOXDbJlS3PTP7xK5nZiXvU3FQax+MV6wm+PoBn6zIHZLAOhYmZu/uT1T+PfCrZ0WGFKLqIraBon+x1ikefBAZ1xL01AXK5fVsygvEhnNe0tgMa7ZTdEpsJ7Em4WhPgE2x5nOGEBdLOsOzjvAUvwTDauJh8yyBGe/llGXRMXzNMZrf+U0TfpCZlqx3+9QJvPOfEKZwNcP+5pP+vQZyGyqz8yH5UE+sX/my3HY4w0trCgHeQ3TlpRu9NskPgBd3VVKWLgwd25uPzmdcHN5DYZqJ6/3PCtFaROzi9g9YmxXTDyopuDriNIkEy2p8U9NEClxyu78jg9Kq/4NdxqkfxyCEHZpTBjC7XD+IUncjh/MW+MdYDLSCFXeZ45eSeRzTep43xAmf7g2PkjtWmxVsrtEqIPgzK/Zffo7a+FOFuPa/HoqtOGjyAkxBhs0bArJkaV5b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06-Aug-26 7:14 PM, SJ Park wrote:
> On Thu, 6 Aug 2026 11:19:22 +0530 Bharata B Rao <bharata@amd.com> wrote:
> 
>> On 28-Jul-26 11:44 PM, Andrew Morton wrote:
>>> On Tue, 28 Jul 2026 11:13:48 +0530 Bharata B Rao <bharata@amd.com> wrote:
>>>
>>>> This patchset introduces pghot, a subsystem for hot page tracking and
>>>> promotion.
>>>
>>> Can DAMON be used to do this sort of thing adequately?
>>
>> Hi SJ,
>>
>> I started comparing hot page detection and promotion aspects of DAMON
>> and pghot through benchmark runs. Here is the first set of results from
>> pointer chase workload.
>>
>> Since I wasn't very familiar with DAMON tunables and settings, I let the
>> AI to chose some default followed by other combinations. The test harness
>> is developed and run by AI. Request you to go through this and let me know
>> you feedback about the combinations and configurations tried here. Based on
>> that I can adapt the settings for the future runs.
> 
> This sounds like you asked AI to do the comparison because you don't know
> DAMON.  And you still don't know DAMON, so you cannot really explain the
> results.  So asking me to review what your AI did and guide your AI.  Sigh.
> 
> Correct me if I'm wrong.  If I'm not wrong, no, I'm not an AI slop reviewer.  I
> will not review that until this is clarified.  I call it AI slop regardless of
> the output when it is something that generated and shared without full
> understanding from the human user.
> 
> If you want me to review something, please send me what you really understand.
> To compare/discuss DAMON, please learn it first.  Spend time and ask question.
> I will be more than happy to help that.

I was seeking feedback about the combinations and configurations that
were tried so that I can adapt the setting for future runs. I spent time
looking at the rich set of configuration possibilities [1] that DAMON
provides and experimented with something very basic to start with, followed
by a few changes in each step. Now I can see more meaningful numbers
from DAMON without the need to enable migrate_cold.

Metric notes
------------
- lat  : steady access latency, ns/access, mean of last 25% of samples
         (lower is better).  Baselines: base 337 ns, pghot 348 ns
         (within 3%, so absolute latency is broadly comparable here).
- node0: end-of-run per-process placement on node 0 (numastat -p).
- CPU  : cumulative cputime of the monitor/promoter thread over the
         240 s run, and its peak instantaneous %cpu (ps).  This is the
         concentrated cost only; see caveat 2 on pghot's distributed
         cost.
- promoted: bytes actually migrated (DAMON scheme sz_applied; pghot
         pgpromote_success).


DAMON configuration method (default vs manually set)
----------------------------------------------------
The aim was to start from DAMON's own sysfs defaults and set only what
a promote scheme needs, then change one thing at a time.

Left at the DAMON default in every run below:
    sample=5ms, aggr=100ms, update=60s, apply_interval=0 (=aggr),
    intervals_goal off, watermarks none, quota goals none, filters
    none.  min_nr_regions=10 (except the page-size runs).

Set manually in every run (the minimum for migrate_hot to act):
    operations=paddr; one target region = node 2 physical range;
    action=migrate_hot; target_nid=0; access pattern nr_accesses>=1
    (sz>=1 page, any age), i.e. "promote anything accessed at least
    once in the aggregation window".

Per-run additions (the single variable that changes each row):
    D0 default    : nothing extra (pure default + migrate_hot).
    D1 page-size  : min=max nr_regions = 67,108,864 (one region per
                    4 KiB page over the 256 GiB target).
    D2 +quota     : quota bytes=128 MiB, reset=1000 ms (~128 MB/s),
                    weights sz/acc/age = 0/1000/0 (hottest first).
    D3 fine+quota : max_nr_regions=100,000 (min default 10) + D2 quota.
    D4 pagesz+q   : page-size regions (as D1) + a quota (1 GiB/1000 ms)
                    + the same weights.

Table 1.  DAMON, base kernel (each row changes one variable)
------------------------------------------------------------
id  config             regions       quota   lat   node0  over   kdamond
                        (settled/pin) (MB/s)  (ns)  (GB)          CPU
--  -----------------  -------------  ------  ----  -----  -----  ---------
B0  baseline           - (no DAMON)   none    337   0.0    -      -
D0  default (coarse)   11             none    121   64.0  +300%  25s/10%
D1  page-size          64M pin        none    129   33.0  +106%  277s/100%
D2  default + quota    14             128     105   23.3   +46%  9s/3.7%
D3  fine + quota       14-38          128      88   23.6   +47%  14s/5.6%
D4  page-size + quota  64M pin        ~1000   296    1.0   -94%  270s/100%

B0 is the no-promotion control on the base kernel (numa_balancing=0,
no DAMON), and is the reference for the lat column.

The "over" column is measured against the 16 GiB HOT SET, not against
B0: over = (node0 - 16 GiB) / 16 GiB.  B0 promotes nothing, so its
node0 is 0.0 and its over is n/a.

Regions column:
- A plain number (D0/D2/D3) is the SETTLED count DAMON adapted to,
  measured via the damon_aggregated tracepoint.  These rows leave
  min_nr_regions at the default 10; D3 only raises the max_nr_regions
  ceiling to 100,000 (a cap, not a target), so DAMON splits/merges
  freely and settles at 14-38.
- "64M pin" (D1/D4) means min_nr_regions = max_nr_regions = 67,108,864
  (one 4 KiB region per page of the 256 GiB target).  Setting min=max
  PINS the count: DAMON cannot merge/split, so it is forced, not
  settled.  The actual count was unmeasurable (NA) because the pegged
  kdamond never completed an aggregation pass to emit the tracepoint.

Table 2.  pghot, pghot kernel
-----------------------------
id  config            thr  lat  node0  over  promoted  kmigrated
                           (ns) (GB)         (GiB)     CPU
--  ----------------  ---  ---  -----  ----  --------  ---------
P0  baseline          -    348   0.0    -      -       0s
P2  hint-fault (def)  2    124  16.0    0%   16.0      6s/0.7%
P1  hint-fault        1    112  16.0    0%   15.9      13s/1.1%

Notes on Table 2:
- numa_balancing=2, and pghot tunables with the default values
 (pghot_enabled_sources=1 (hint-fault source), pghot_target_nid=0
  and pghot_promote_rate_limit_MBps)
- Both thresholds place exactly the 16 GiB hot set (0% over):
    P2 pgpromote_success 4,194,304 = 16.0 GiB exactly;
    P1 pgpromote_success 4,157,158 (15.9 GiB);
- thr=1 converges faster (first interval already 136 ns; it promotes
  during the load phase) and is slightly quicker (112 vs 124 ns) at
  marginally higher kmigrated CPU.  thr=2 starts at 395 ns and
  converges over the run.

Caveats
-------
1. Two kernels: DAMON on base, pghot on pghot.  The baselines are
   within 3% (337 vs 348 ns), so absolute latency is broadly
   comparable, but this is not a single-kernel A/B.
2. The CPU columns are the concentrated monitor/promoter thread only.
   pghot's hint-fault source also imposes distributed overhead on the
   application threads (NUMA scanning + hint-fault handling:
   numa_pte_updates 10-15M, numa_hint_faults 3-8M), which is NOT in the
   kmigrated figure.  DAMON's cost is concentrated in kdamond and is
   captured.  A fair total-cost comparison must add pghot's NUMA-
   balancing tax.
3. Latency does not track placement linearly for this workload and the
   mechanism was not isolated; placement/over-promotion is the primary
   accuracy metric.
4. DAMON and pghot increment different counters (scheme sz_applied vs
   pgpromote_success); cross-mechanism promotion counts are not
   directly comparable, so placement (numastat) is used.

[1] DAMON config directory - tree view
--------------------------------------
root@host:/sys/kernel/mm/damon/admin# tree
.
└── kdamonds
    ├── 0
    │   ├── contexts
    │   │   ├── 0
    │   │   │   ├── addr_unit
    │   │   │   ├── avail_operations
    │   │   │   ├── monitoring_attrs
    │   │   │   │   ├── intervals
    │   │   │   │   │   ├── aggr_us
    │   │   │   │   │   ├── intervals_goal
    │   │   │   │   │   │   ├── access_bp
    │   │   │   │   │   │   ├── aggrs
    │   │   │   │   │   │   ├── max_sample_us
    │   │   │   │   │   │   └── min_sample_us
    │   │   │   │   │   ├── sample_us
    │   │   │   │   │   └── update_us
    │   │   │   │   └── nr_regions
    │   │   │   │       ├── max
    │   │   │   │       └── min
    │   │   │   ├── operations
    │   │   │   ├── schemes
    │   │   │   │   ├── 0
    │   │   │   │   │   ├── access_pattern
    │   │   │   │   │   │   ├── age
    │   │   │   │   │   │   │   ├── max
    │   │   │   │   │   │   │   └── min
    │   │   │   │   │   │   ├── nr_accesses
    │   │   │   │   │   │   │   ├── max
    │   │   │   │   │   │   │   └── min
    │   │   │   │   │   │   └── sz
    │   │   │   │   │   │       ├── max
    │   │   │   │   │   │       └── min
    │   │   │   │   │   ├── action
    │   │   │   │   │   ├── apply_interval_us
    │   │   │   │   │   ├── core_filters
    │   │   │   │   │   │   └── nr_filters
    │   │   │   │   │   ├── dests
    │   │   │   │   │   │   └── nr_dests
    │   │   │   │   │   ├── filters
    │   │   │   │   │   │   └── nr_filters
    │   │   │   │   │   ├── ops_filters
    │   │   │   │   │   │   └── nr_filters
    │   │   │   │   │   ├── quotas
    │   │   │   │   │   │   ├── bytes
    │   │   │   │   │   │   ├── effective_bytes
    │   │   │   │   │   │   ├── goals
    │   │   │   │   │   │   │   └── nr_goals
    │   │   │   │   │   │   ├── goal_tuner
    │   │   │   │   │   │   ├── ms
    │   │   │   │   │   │   ├── reset_interval_ms
    │   │   │   │   │   │   └── weights
    │   │   │   │   │   │       ├── age_permil
    │   │   │   │   │   │       ├── nr_accesses_permil
    │   │   │   │   │   │       └── sz_permil
    │   │   │   │   │   ├── stats
    │   │   │   │   │   │   ├── max_nr_snapshots
    │   │   │   │   │   │   ├── nr_applied
    │   │   │   │   │   │   ├── nr_snapshots
    │   │   │   │   │   │   ├── nr_tried
    │   │   │   │   │   │   ├── qt_exceeds
    │   │   │   │   │   │   ├── sz_applied
    │   │   │   │   │   │   ├── sz_ops_filter_passed
    │   │   │   │   │   │   └── sz_tried
    │   │   │   │   │   ├── target_nid
    │   │   │   │   │   ├── tried_regions
    │   │   │   │   │   │   └── total_bytes
    │   │   │   │   │   └── watermarks
    │   │   │   │   │       ├── high
    │   │   │   │   │       ├── interval_us
    │   │   │   │   │       ├── low
    │   │   │   │   │       ├── metric
    │   │   │   │   │       └── mid
    │   │   │   │   └── nr_schemes
    │   │   │   └── targets
    │   │   │       ├── 0
    │   │   │       │   ├── obsolete_target
    │   │   │       │   ├── pid_target
    │   │   │       │   └── regions
    │   │   │       │       ├── 0
    │   │   │       │       │   ├── end
    │   │   │       │       │   └── start
    │   │   │       │       └── nr_regions
    │   │   │       └── nr_targets
    │   │   └── nr_contexts
    │   ├── pid
    │   ├── refresh_ms
    │   └── state
    └── nr_kdamonds

29 directories, 60 files

