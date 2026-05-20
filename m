Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35C4BCD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 14:58:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A90B6B009E; Wed, 20 May 2026 10:58:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95A2F6B009F; Wed, 20 May 2026 10:58:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8227F6B00A0; Wed, 20 May 2026 10:58:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F1BF6B009E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:58:08 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1FFBA140371
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:58:08 +0000 (UTC)
X-FDA: 84788103456.25.67EEFFA
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011046.outbound.protection.outlook.com [52.101.62.46])
	by imf25.hostedemail.com (Postfix) with ESMTP id EBEE6A0004
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:58:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=bX0NHmOf;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf25.hostedemail.com: domain of KPrateek.Nayak@amd.com designates 52.101.62.46 as permitted sender) smtp.mailfrom=KPrateek.Nayak@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779289085; a=rsa-sha256;
	cv=fail;
	b=SRJa0tTQDopd5vx9gFmvD7b4fDYk07qK9jnev4Ex6ZaikFwTIVSlnHm3Ky5+ZzTAPrIMdl
	nlZwGGBPvyVpb7S5Esp3gwBW2LFttRkGw8eo9wTVfOPt1z2+veldqRW2im1ovjGt+dZJAe
	N06I2zyorqsMTrLQHJqpF2rEROzKqYo=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=bX0NHmOf;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf25.hostedemail.com: domain of KPrateek.Nayak@amd.com designates 52.101.62.46 as permitted sender) smtp.mailfrom=KPrateek.Nayak@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6J7q0rWG+aczidUckHXZfqUEEIjiXiJy4J7ymvAuvj4=;
	b=dLV8ovn65mIIsDwzVaBdk4rCMU6OricjYBKSygyBOdn9H2Tyoh7NnPFKKVgUHe0uW3NDt2
	EguyG00IKScaOysHej/5LPTnywKKsSE3LLnBWGtA1k+hsB/zfe0Wc+FITo9ePHhIVOcWRQ
	HbfzBVIty2SNnj0P+6CCJ11kHvURuAM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CFPmQ/iLnxxQZX8bujT8iE7KUal1RXdmuA5NeDtcAXbgC3zrDNFFjM4LE5MfbAZVlopwO3C7QiK9eF2AldSYfM6Cz/pfhMMvzp287ajt6y+F2rjGZTenUVUTNKZDWJZ0rjMu/a5hsIQ7G/3g3qusxK4PQA5kfI9UAlQImk3ALdXUEM6OWCD/4x+e9zFgzFUq/ai9FEQaFKctoLl8U/Y5EJxt++3M2vRhwCS6we6lpPwKrO4bME2kgMNhKAIN/OjakwjPRO/YyqFGZxP9/5rVWIbUCtwHH3XCocmH8AvrozR2fDN4/RlxMOucxwGPmEnevsROkjvkmeRnVRE8ZrLBWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6J7q0rWG+aczidUckHXZfqUEEIjiXiJy4J7ymvAuvj4=;
 b=JkssN8CZoKU2vxfo3WQXQCBp967errevB1MG456+FQ3nh31zs7IisSABmzCegI9c9us9/vy1W25KXotMkn5qmxLXnRFKouJQPXZHcCulVZsdaZYfECs8LYjP24Nb+1oOxwU4arx0BEcsYicO/SkkEps2Vx1zH1wJzCTj2KYT71kqHi+DYLHe7mzdx7EN4FiiA5SBjiPQ8oaNtKtYzhqgqpx4zrhENXEf3nZ3TCj46XUq5TIkdVflUGLIxKFJXCCaliQlsg88jhIRBmP+U/3d5QvaTe8o8SbSIYN9dCD7s+LZHgai3qh3ZifkyhAe3mfskEDOFzWEQ2CkompJIdic1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=xiaomi.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6J7q0rWG+aczidUckHXZfqUEEIjiXiJy4J7ymvAuvj4=;
 b=bX0NHmOfL8nXqN1PcEHrEDSeZ41BISxiBTNwwBhzUKg29asBhPnFKGXtVhSqe89XGNMoIsDFXWI2of8/YGEbgC+I6ce1nUodaaiJ97b0KcYcpTKBaBLU3xY9rmQ1WkCH8Zfd9e7t7ns676COgPIFAgIExqlwMPH3R4AIYU63Yjo=
Received: from BN9P221CA0002.NAMP221.PROD.OUTLOOK.COM (2603:10b6:408:10a::9)
 by CY8PR12MB7538.namprd12.prod.outlook.com (2603:10b6:930:95::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Wed, 20 May
 2026 14:57:57 +0000
Received: from BN2PEPF000044A4.namprd02.prod.outlook.com
 (2603:10b6:408:10a:cafe::26) by BN9P221CA0002.outlook.office365.com
 (2603:10b6:408:10a::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.16 via Frontend Transport; Wed, 20
 May 2026 14:57:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BN2PEPF000044A4.mail.protection.outlook.com (10.167.243.155) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.48.11 via Frontend Transport; Wed, 20 May 2026 14:57:57 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Wed, 20 May
 2026 09:57:56 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Wed, 20 May
 2026 07:57:56 -0700
Received: from [172.31.184.125] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Wed, 20 May 2026 09:57:50 -0500
Message-ID: <5bf30954-7c88-4cbc-a529-9d5465e22ee4@amd.com>
Date: Wed, 20 May 2026 20:27:49 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] sched/fork: Fix timer_slack_ns inheritance for RT tasks
To: <xiaofeng5@xiaomi.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra
	<peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot
	<vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, "Mel
 Gorman" <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kees Cook
	<kees@kernel.org>, Felix Moessbauer <felix.moessbauer@siemens.com>, "Thomas
 Gleixner" <tglx@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
References: <20260520-sched-fork-fix-timer-slack-v1-1-d4fc937245b2@xiaomi.com>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <20260520-sched-fork-fix-timer-slack-v1-1-d4fc937245b2@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A4:EE_|CY8PR12MB7538:EE_
X-MS-Office365-Filtering-Correlation-Id: 04bc6ea6-66a5-4f54-b075-08deb6802db0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|7416014|82310400026|1800799024|11063799006|3023799007|56012099003|22082099003|18002099003|6133799003|13003099007|921020;
X-Microsoft-Antispam-Message-Info:
	gBwCYHnY3Se3GWN+ZorEkGqBO6PVGf8RhVJw8Eje9uaBy6ogQ59AGhmtEi4BniSifHOdh04vMi4DdtTUcytB/TRQ6FCnsU3TUWML/0JI+xUMadTLu9BA/gqWWRH36FlYCazqVEa7cEJ4u0e8vjIsz5P/+mq5MSu7VdJslKRzDyGFMkSFOSYq/JbR8img5T4VFnX9kxbIXAD3Larxt3+FC5Bsw8rNbL9bB2zeYqsBUtO7zMqS+yXEjpE+PTObPy9/UxxGL3xIW1Hm0nEPV8bi8jm0MK0dAKQ4pYgBe5OvaqfIxoiemUwryAe+QoTZaqh39/roTPjCf9MqBSnV4uOs0b32B20eClGZVaV2f1FhTvbbTlJRHgy4zvpjkxXlwpi6724K3BxeihVFxSb2kGzDK4SMpjVI+C+Z7NCxFtifYSlO1KNCXxFPQU7S3Js/OV8HM3IYRLoUgu8I4Ts42OUq0vqSc4fzj+4y1hNgyKPC5jLZDY6zoZvBfHdAsRaD3Cwl5CNkAqGgg+tB/tGsuD0+GJLTlemPhuIL4vDuAhWx1USGQEcJEuN0IMZ8UJLK8RpdjQ1bpUSQrdkuYTXzelwu9l8SyzbgKyUIJ/BJ4uUWKP8eEDXCP+mB1rE7xboUoKLjcbz9sOMX/6XzIWZylCbGY1XBOCNDZRhVFAKhtvAGBe3hxWbzpnNG9QdMrlZJYcDi2fhKUfG3WhD52XSls81ohd6k2Bkse0QqTt/P6MqQdt0=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700016)(7416014)(82310400026)(1800799024)(11063799006)(3023799007)(56012099003)(22082099003)(18002099003)(6133799003)(13003099007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	aNMU/cQmJnqMcpox/EWr233vN+HL0i4v5R+7GjRZ43nlOj/Vdtj0vMI45pIB2j3jDOaro88bqPpua1fK/lvnhM0Sx5NMwHW7qAShzbPV2YIkOsMTAy+UqNbF2rAaXSdDVFo+vXRuEsyGmbLIsZ/98sI2+0WDcUg1MW5Zdu8kXOWsIutmUCQ+kXCghLK+QgFTPM7teMoM248V+YlxA26mBQBi3t4paj29EnMgPjzhCyYCoDDTLtk0Mi3aRz+oRF7QjgASEG49uhffXVPh1fNnxHU5arykKiiY/ZmUKUEQK9bQINZizBiVxGHFwQAiIkNc7i4OiPK8ZtRxFL/CJY/i1thCWI5z0H5lKcLKIBtswXMHKKCScostmJd/naEzpIxKz1csmdxBpA2UjaNuXp7GsSySWJmyu5CBtq5Ppg/v5/Dp2kqePQEWJ7cjPlm9cmnk
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2026 14:57:57.1370
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04bc6ea6-66a5-4f54-b075-08deb6802db0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7538
X-Stat-Signature: t9zozt33x7yj77ndpt8j6qhdujcxir9a
X-Rspam-User: 
X-Rspamd-Queue-Id: EBEE6A0004
X-Rspamd-Server: rspam07
X-HE-Tag: 1779289084-282862
X-HE-Meta: U2FsdGVkX1/QdltvulWBJT+tW1tz/dqjptaSKa2a7EXWWE2i6db3Okfi9QJ0cpNPvQ+bXLGh23PLrKeeGUfYm58PNaU3RnuemkYp4WaNUnBObA6hkO0+gKvaIdoLd31YYhRDltVZuecjxGi5YlqQ+nxh8+m/9VLPeUqHw2JrGdCkUJhqsv4RNcBEQjyasAOeId2OvG5V5c9GUo2We3J72n40pkJFnsUgpWucaCaUGblpZI5iVKaMq3dIRB9cC2HxmCwmPXRLCOkVR8NxatrheKlTamPCzGKAfPNYJOhCG+RabpSOpCifQBF8Hf83Zp8tCBBhZzzY1xDwwZNr0nB4GsJY3jlZEbQ25yfmxhCR5MnPIsV7m8zFl/jSumoGhZVzWNn50tuQb5ClhgfuppP3kLrCnYvgrxFPNEW11Nb4jwk5qiM/Sl+6PHu5PSRWwYpFEpZBQ5NJCIvnv13CGCOdP85gqMOhXcUju38Z+JC0IL6P8UtVQNOUUVtiTi5YbDziB9l/sOFPZdZ00TV3wnAJUr8XeJ0bZPHrVrmClk+g6BTzpzzQoP0wUOlmrgFDaBOmDzT+n09t+1KZEUGoNcjuz6oUpElzuDisKT6Y9ywIt/vxQSOm5ysCcz2Ca/NZGWoWOpoXe3s/Xus/rQTIvrKhbE6adXZg8BOlEroH7k98I9rYaSdmY8R7boicktor92d7wgQfRWGlNiwH9y4QPNmmQpQUvxexZBT4YW//bD4gt0y+dHP+Gi2mp/w5NcjChY3jCyjPgGL1p4Ej5pcSVOFwvULhpMXjRJlpZORZcDdQbb8Y6yJKDhL7HZfV+tibGBCKb3IcExyPMEvZw864Xdx/eWMA0jj4MQ7DabeLqkrebkA0/8mkb2mQY+y71CC3eE6+lRA6ZrKgCrtwr1VIium/BKmE61E8jtadyQDJNPkmKzo7/l3xDk4via48BNABls5i2dmGhOuuy33vkMa/anD
 jmmrZqlP
 nmKS7PtPe2ky8uHfl0aH9hu7Cplq/k/w3QRt7NzD3tJfaRN4cEPyCXdhtcd92p/KKf+0+j0kWjJkWe0j/2HcPt9SXgCM0aKw/qQGUJ3Xb7iQdK1jDNmhepELeWKDpKe4cHFzF2GMSTICzxcv09FXBdw9xFnMefW21UyAuknslBRVysZXnh3E0+wuKhDQIbNoMv7BHiR6Al+rus6ncQ+eZTNjOBA2tc44jeLwbgTFdPt270PPveVWMgsbs+JYCSGd97VK+wpx+jU2AT2lZT0pxyqQaAi7moNFVZEnfqdX0KHCS8CKnfsjcxYZ989nklvomCDWvBpdgqZsWErJq6c+6rBnjqwnscS4WpxrTECj0U9z8RZIPlaitwA7cPDaFWqXmODk17vHRMUqrjqlCaoDI6k7XiE8V0Z+2n/a5P3hQJe3SpyMzOYUx+CXyPQfKHOVsGyZD+DR7Fpw9NDHSQtD/ZH4JiDcL3trA62bVyJ/hCKx1y4N5HzdNq/Ba9buNNbpTSiTg3MDloMTIQ3vdI4GuXb2blLoMW83fYbFGjGmvp2CO0D4gJxmaMY/vt7ad0YBtYSzDDjEpgtn9mbrpA93a75Zh+wnkTHtOzn/WgwzC8RPoprfzhssjBWKn1n4ipyaK8Av/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Xiao,

On 5/20/2026 6:37 PM, Xiao Feng via B4 Relay wrote:
> Both problems prevent timer coalescing for these CFS tasks, causing
> unnecessary wakeups and increased power consumption. Writing 0 to
> /proc/pid/timerslack_ns also cannot restore a proper default.
> 
> Fix both issues:
> 
> 1. In copy_process(), inherit default_timer_slack_ns from the parent's
>    default_timer_slack_ns (which is preserved across RT transitions)
>    instead of timer_slack_ns (which is 0 for RT tasks).

man page for fork() [1] reads:

    The default timer slack value is set to the parent's current
    timer slack value.  See the description of PR_SET_TIMERSLACK in
    prctl(2).

And that description in man page for PR_SET_TIMERSLACK [2] reads:

    When a new thread is created, the two timer slack values are made
    the same as the "current" value of the creating thread.


The two timer slack value that the man page refers to above is the
"default" and the "current" value as is describes in the opening
statement.

From a documentation standpoint, it is doing the right thing. A
RT thread returns 0 for PR_GET_TIMERSLACK and the same is set as
"default" and "current" for its children.

[1] https://man7.org/linux/man-pages/man2/fork.2.html
[2] https://man7.org/linux/man-pages/man2/pr_set_timerslack.2const.html

> 
> 2. In sched_fork(), when sched_reset_on_fork demotes RT/DL to CFS,
>    explicitly restore timer_slack_ns from the parent's
>    default_timer_slack_ns, falling back to 50us if it is also 0.

As for SCHED_FLAG_RESET_ON_FORK, man page for sched() [3] reads:

    More precisely, if the reset-on-fork flag is set, the following
    rules apply for subsequently created children:

    -  If the calling thread has a scheduling policy of SCHED_FIFO or
        SCHED_RR, the policy is reset to SCHED_OTHER in child
        processes.

    -  If the calling process has a negative nice value, the nice
        value is reset to zero in child processes.

    After the reset-on-fork flag has been enabled, it can be reset
    only if the thread has the CAP_SYS_NICE capability.  This flag is
    disabled in child processes created by fork(2).


Nowhere it says anything other than the scheduling policy is affected by
this flag. How is timer_slack any special?

[3] https://man7.org/linux/man-pages/man7/sched.7.html

> 
> Fixes: ed4fb6d7ef68 ("hrtimer: Use and report correct timerslack values for realtime tasks")

Based on my reading, this is not fixing anything but instead introducing
a behavior change contrary to what has been currently documented.

If it is acceptable, at the very least, the man pages need to be updated
stating this new behavior and the kernel version that introduces it.

I'll let others comment since they know these bits better than me.

-- 
Thanks and Regards,
Prateek


