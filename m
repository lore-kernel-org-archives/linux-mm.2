Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40DC0606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 10:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=S0tNOpXe
Received: by kanga.kvack.org (Postfix)
	id 6A1AB6B00EF; Thu, 29 Oct 2026 06:22:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 652EF6B05B1; Thu, 29 Oct 2026 06:22:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51AB96B05B8; Thu, 29 Oct 2026 06:22:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 249D06B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:22:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B26D5160245
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:22:24 +0000 (UTC)
X-FDA: 85375274208.12.46BEDB8
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013022.outbound.protection.outlook.com [40.93.196.22])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7B741180003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:22:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=S0tNOpXe;
	spf=pass (imf24.hostedemail.com: domain of bharata@amd.com designates 40.93.196.22 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793269341;
	b=2uMFikVA18+E24XfabcGrYn0Vzywzy3UYDQQsM7OtOCZ0Xwq12/WmzAtEsfv0VOU/Xta4/
	Mt0ZefUc7mWOJIxThHytd0a3IhLjLxNmA+zmAJtpF2hQzR88uxxP43dsZi+/v/bIhAxjwm
	fc1vPnhjkcERoKGd5xdbrqPfrBqVXUo=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=S0tNOpXe;
	spf=pass (imf24.hostedemail.com: domain of bharata@amd.com designates 40.93.196.22 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793269341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mERhVTreeJWEyZF0OIJz4cYMozJmUKHAF/0M25LMpCQ=;
	b=B8U/v8Wn7VZTrQE8mRxOUAidZ24gjAsbzEFwlTyc7UPIHaLnO1wjnIuSp7pYS6eMOlyk7n
	L1NOR5cXZMiWJMFIz4xaXvXhLe8IpSpeeydpLd3YDVMUos10ttEW0DI+Y1auUa480pjvgk
	B/IHYfZkK44Dmce7PX6hl8bYctVEH8I=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MuPUsbTPTydERPec3XfYg4MfGqxZzjig+cK+NP8AONyboIAPerj5HxTugTmXcGxyP90b5/wpjaQ1cjuinQ5ZAvG9wGjbu48B+SKDyY8FEG2Djybu6xOqjb+cxNm8yZgMB5BNN9CH7SqvP+b80cZPqAe0Ltto/m7IfTcxTbeg64ZT0tpPN3TG+DOlhGw2b6YceuoO0pXEz7xckqrs/U+3tjaAxZymTqV11ktRAZMO8iVhXAQ9Y6+6MyOFAtCgaD+CLzULoPHtYYj9iSekxW6/XcdlCrWYs4RLI59+oLtzKcFNT26r2jd9IRRjS2/Pfr8YTpfcdvWIZH5przZ6iTVpXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mERhVTreeJWEyZF0OIJz4cYMozJmUKHAF/0M25LMpCQ=;
 b=fKqg/aKhe6o9XXuWUUSBUzdorye+QjFBEec/uWV2uxZBN1JsTCeromf9595DByGAjnEzqAiuM5dpoLqahX+zkUHVoIyzmUjxDK7AO3JJmV+8E6j8xtGMfoG1RoH8UWWcE2gjXbvGvj1FyjnTfHz9QlM0qKdr/8QCga9oC2t1LsiLfxbWrX/CVgsEwxLolVdCROi+U1We9HbBwsmBQQ1T/mDnZH5JNpkQ6KxKW1O1xXGXPh3/zFhpV+zv2VWAg6kNN5TCgA9SR82ENKJvBMDfQr6PGyZ3+z3EMf3TUiKz/MFjjL29yOJdOTMCoCRjQ7d15PSAAlD5C/ySc0eBDwyVeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=bytedance.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mERhVTreeJWEyZF0OIJz4cYMozJmUKHAF/0M25LMpCQ=;
 b=S0tNOpXelHRM9wl5r5rXuYSlBH3pTFVMPUiz4IEX9kNiAtZckyg1TekHPUOn8qZWwkSL3ruo1VwyLfT0Lec4aZI0g+++jImzvvrDRIdgjOAEhSQJ4JoFdZQKMbYwf20P4gvnkq1wpMLmJKDY9eolLrOrMYNpjVNqMk+f1kLq37w=
Received: from PH5P220CA0004.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:34a::16)
 by CY1PR12MB9560.namprd12.prod.outlook.com (2603:10b6:930:fd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Thu, 29 Oct
 2026 10:22:17 +0000
Received: from PH5PEPF0000002A.namprd04.prod.outlook.com
 (2603:10b6:510:34a:cafe::61) by PH5P220CA0004.outlook.office365.com
 (2603:10b6:510:34a::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.569.9 via Frontend Transport; Thu, 29
 Oct 2026 10:22:16 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 PH5PEPF0000002A.mail.protection.outlook.com (10.167.243.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.4 via Frontend Transport; Thu, 29 Oct 2026 10:22:15 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Thu, 29 Oct
 2026 05:22:15 -0500
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Thu, 29 Oct
 2026 05:22:15 -0500
Received: from [192.168.0.152] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.53 via Frontend
 Transport; Thu, 29 Oct 2026 05:22:09 -0500
Message-ID: <a6bcd771-fcf7-4fe4-8c21-5e65bd579de7@amd.com>
Date: Thu, 29 Oct 2026 15:52:08 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] sched/numa: make free-space tiering promotion
 bypass configurable
To: Li Zhe <lizhe.67@bytedance.com>, <akpm@linux-foundation.org>,
	<bsegall@google.com>, <david@kernel.org>, <dietmar.eggemann@arm.com>,
	<gourry@gourry.net>, <joshua.hahnjy@gmail.com>, <juri.lelli@redhat.com>,
	<kprateek.nayak@amd.com>, <ljs@kernel.org>, <mgorman@suse.de>,
	<mingo@redhat.com>, <peterz@infradead.org>, <rostedt@goodmis.org>,
	<vincent.guittot@linaro.org>, <vschneid@redhat.com>, <ziy@nvidia.com>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>
References: <20261028041253.74839-1-lizhe.67@bytedance.com>
 <20261028041253.74839-2-lizhe.67@bytedance.com>
 <0676993f-c04c-4e4e-9f8d-1650c8fd6d6e@amd.com>
 <010b2b6c-8f1b-4c3b-913f-cc2e8b957759@bytedance.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <010b2b6c-8f1b-4c3b-913f-cc2e8b957759@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH5PEPF0000002A:EE_|CY1PR12MB9560:EE_
X-MS-Office365-Filtering-Correlation-Id: cf079dea-56ec-462e-dc0f-08df35a68156
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700016|82310400026|1800799024|23010399003|6133799003|3023799007|18002099003|22082099003|13003099007|921020|56012099006|11063799006|4143699003|10067099003|261028144727099003|261026121527099003|261022075727099003|261021123027099003|261026140227099003|261021121427099003|261022105027099003|261009223027099003|261022113327099003;
X-Microsoft-Antispam-Message-Info:
	GFYm5AKy/3qAYubLx27G8RhcyvQv7ANhQ5GTMmwgJvrjSGBVtUCvpi3Z/JQFoxR9kY292aYrGHQS95Kseqybsxtl06z12UhBagE9iujkj6PskaQ5kZ82rkj9C8xYxEg6h4lH47Ivy1E29KTMYz09YS3bWOOBnYTVA3Hmj7hnsHflO+IuVfIjdTts7sihrLc8iLaIal1M8QZTzTwJ3ON9CZnlnS76Qn4EqM4ZMhu2lEeQ4bAt/q2V1Hz2ci5Fe8YditXXgMa6+eK3uCIah+2WHyyo/dC3K+bc7T9gmHrY9y0PEmtgcBTniwvU/jhoNh7D0pl7XoWaEQgRjqNxLhdNirq6HTF07On/CmbK0RQxT6bQLOAXdg/tVYi34Cj+xG4NExGyXqyNcXOy1Xq/BG0QSV4LceWS3LEkag8dTTfuD74QQi2BLH0OHCTmasC7cjXyizFSdwUzHE82ICuaH8LyWSg3NbN1fKUM46oP2J/dhmb4XHuqc30OzW2TWLBn8A38bL770sYW8UkF61+DqrvMUrAQwDpElZLQFIslpjxlN9zuehXqcQREmFfL6K6j0J4VXUQNgNNs8C/rMW6Fs3qoYop11s9hId8YG/0QhFE+CoPLlgR/cT/FLRjVdHh5xBjnROIG3eS3eSCydZTKJJC1UueJ6dvDP0Q//Qcr8kMGf2PsEZ5MTOhRf6HuAfhcEkKLOiGDzCtwuxuNlg18GcmaFyRGq4BRBUKvY2MQj9j5333IiOb2FmAGKS9xUC5VOScs
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700016)(82310400026)(1800799024)(23010399003)(6133799003)(3023799007)(18002099003)(22082099003)(13003099007)(921020)(56012099006)(11063799006)(4143699003)(10067099003)(261028144727099003)(261026121527099003)(261022075727099003)(261021123027099003)(261026140227099003)(261021121427099003)(261022105027099003)(261009223027099003)(261022113327099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	QyR+69TJ77J0idCatCphagCQc44W4LEGUD843RbjGVxN8nV9JjBxl16uTExFAfBL8I0rwQHxjxbgyIiZsyfPZ3/Kgi3hoTUQmfKr2iaiyYBPpWv5jdyFDdmvhB1v+/vodswYLFMYCUu/FS0GzaUg45zskbiGeysIwdqs/4ngtGko7UNoWQM/IlUh67mKSqDWwNNqkKrXXsAs84KY1DZvBcDVHO5kk2xJNk9z461JKiSj2EdNAh4lah16/6ImLYbNY5tRkn+T2HzNLcnisIiUvzHvz2t6kiTclCa/YOHrDtVOnzUge6Tqq8XztygNH32Jxt2NVyx1xbvil1nL9eJR/qfGM3/GB3IYq5syfQN9TXUXWvs/+FJay6YzZlyyIp4J3aIzjhaFIb3FB+v1WnMPF11Y7SrNDoY5h1Ev49sEmKYhEfNFisP0DGchsCmlltdu
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2026 10:22:15.9976
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cf079dea-56ec-462e-dc0f-08df35a68156
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH5PEPF0000002A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR12MB9560
X-Rspam-User: 
X-Rspamd-Queue-Id: 7B741180003
X-Stat-Signature: 4cwwsbkiyd4tjdfqkku3jbsz867e78cm
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793269341-624700
X-HE-Meta: U2FsdGVkX19G0eNWYeDwKNALFZg7pOSRCi8jj9w2OzzUQA1X4D1QLKlIze9Wi5oMYZhFyHp7a+0g/hNvC9SL39o02eQdZc4e7+K9sNZQ4d2eOGan9mP2GEEJorKfmr8mKj0GeC6hzFJp5iDpxNRZec4hCMOvTCBb93bmjbbJwYWYn3UaqLMK/RrtxXe4m8/cdca2p79qdBfJvevrSCUUm2zJ54m031ofNJR0mTjDb07/+YbjWi+2QvaOMQMeuDwxb9xrQt3sTIGRdnlvqYUofiDQEv6+8HizDhb6bz817HCcve6vIcpvSumB9LFKVTsC+ozHOR5QK0dcQDRu507qWBW08djom6HIbXDXfixcx/Geas85ObnEaa0sYh8sQn/Ut6YlQ8h1dfOoUjfYAp3j9bOV3RGKbAq+Ajdvh9xwXyF7mnmVrsUCzrqhMs5clfIG9/JLU+OCNHjt+Tmpc8rSQJ2sSt/1pqunKY1tUFg3nixc0lh2LJ9cuyeNWdKoJksItsQGPWcSsRWSmxYb+8VGItLRAWco3ncslOi6jDD9+oVUa3Z8j3HUurjCS5xqzWryEE19oUPwHJzNYLKwI0CHsDTil1QI+XHJtVRlYrNWMnX3v0xDYwsSywU3wOEfc/xJvUgzNTFwvyxyc5RzInXIAjOw5AwC1q4MK7b0Sle4o8gBP7DsSDFFhmS2y6iqeN48gGMbiZbLV57xqgcMTxqdSGMT6hW44R2CmyEaA8IjCqqxF+Jne5DyHYvrA3ozFdw+LUnSRam2ajuX4qDPz7KkBHcj0ydinjEuqAD913GYLCsww+XxG/AZaJbCCArkw95jCMTRloOBirn75jPML+dkcr98oviWUSzqXg7JK+dLY+1fQbhufi4rL7Qa+xgJ6HyjRvYktl6IBTHTYVyYmWoAo+jxg97qmzJEdyWM93J4LS7OPwMCl2LnPhP4feQyKgE8RVnWVDwjf2FJv04dvaY
 XJwoB0K1
 5QYhmnXJzKbw6OOkexQLR7KY0FZjJAfZCPDbuZ9GWp0ez7xbGJt7lPvRpMUlKxXQMoRLMPPfBX2TLoFGNmLfRFisWZiRlNoFT2H8q56SSGHej/VWSMcTcCk6OeTaNrqIxp63RSFHPlqXST4WNhedSgGo6NOUTzk3dMDB8HNkyc+Az9WoLuY2h12u2F9+qHJULmmT8FnlTgZsb79VclgBLx1O4M3zw6Xin8hTNfxEjf9NIFsCoKfQ/NHuB8DVyc4+4YL419aljQFbT9Mb728dYMyvPdpO8V/QLEQR8DZUP8J35E60p5rPcrpQ059POMB4uCFR/yCWMQe4QRiifNtT5RhPed7jVLJXGYxwrtn0wZD2rLsf4j0aVdzTCJlddb/4k5CPg1y5knhTqDykLgOA80J8EWZya56FzETMYlBIsPdATPQNfG6qQcPcRDG0351VTRgdBgeq+jQ1ZCtsjRnKdAU85fVCzgO/HpGqhZ+Oecw2RQtz0IJ1fUfX6ICtesA75aaLH1xQbBkKCuorUIY9jARiza/f/pdTo36jf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 29-Oct-26 3:16 PM, Li Zhe wrote:
> [You don't often get email from lizhe.67@bytedance.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> On 10/29/26 5:34 PM, Bharata B Rao wrote:
>> On 28-Oct-26 9:42 AM, Li Zhe wrote:
>>> Memory tiering normally promotes any recently accessed slow-tier page if
>>> the target fast-tier node has enough free space. This preserves the
>>> existing policy of filling available fast memory before relying on
>>> hotness and rate-limit control.
>>>
>>> That is not always the desired policy. Some deployments may intentionally
>>> keep part of a workload's memory on CXL-attached memory, for example to
>>> preserve a desired DRAM/CXL capacity split or bandwidth distribution. With
>>> the free-space bypass, short cold accesses and bursts of hot accesses can
>>> refill the fast tier and pull the workload away from that distribution
>>> whenever DRAM has free space.
>>>
>>> Redis testing exercises this policy issue. On a CXL system with node0 as
>>> DRAM and node3 as slow-tier memory, a Redis test was run with
>>> memory-tiering-only mode enabled. The test used a Redis dataset with 12
>>> million 4KB values. It reclaimed memory until about 85% of Redis
>>> anonymous memory was on node3, used a Redis benchmark configuration with
>>> a 10% hot-key working set, and then issued a short 256MB access burst to
>>> cold keys outside that working set. The cold-key burst mainly touches
>>> memory outside the hot working set, which is expected to remain mostly on
>>> the slow tier.
>> Can you please clarify if 85% of redis memory ended up on lower tier naturally
>> due to overflow from toptier? I ask this question because, if it is a natural
>> overflow/demotion, then it will be hard to find head room in the toptier to
>> allow promotions that bypass hotness or rate limit checks."
> 
> 
> It was not a natural overflow from a full top tier.

Thanks for confirming this.

> 
> The test intentionally reclaimed/demoted Redis memory to the lower tier
> to model a deployment that keeps only a limited fraction of the workload
> in DRAM and leaves the rest on CXL memory.  In that setup the top tier can
> still have enough free space, so the current free-space bypass can promote
> short cold accesses back to DRAM.
With pghot, I have been providing benchmark numbers from two scenarios:

1. Non-overcommitted case: The workload memory is pushed to lower tier before
the measurement phase begins, the toptier has enough memory to accept the
the incoming promotions.

2. Overcommitted case: The workload memory naturally overflows/demotes into
the lower tier and every promotion undergoes the hotness + ratelimiting check.

I gather that your measurement technique is similar to case 1 above.

The feedback I have received for pghot is this: Non-overcommitted case is not
the right methodology to use but the natural spillover is. Hence I am not sure
if optimizing the free-space bypass case would benefit any naturally run
cases.

Regards,
Bharata.

