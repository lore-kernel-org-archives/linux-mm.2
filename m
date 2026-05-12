Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA6D5CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 06:36:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 107CE6B0088; Tue, 12 May 2026 02:36:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B8316B008A; Tue, 12 May 2026 02:36:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC2506B008C; Tue, 12 May 2026 02:35:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC8476B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 02:35:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 86B721A0325
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:35:59 +0000 (UTC)
X-FDA: 84757807638.28.CE3B49D
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010003.outbound.protection.outlook.com [52.101.201.3])
	by imf15.hostedemail.com (Postfix) with ESMTP id 58745A0007
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:35:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=son3rH2V;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf15.hostedemail.com: domain of Suneeth.D@amd.com designates 52.101.201.3 as permitted sender) smtp.mailfrom=Suneeth.D@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778567756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BoZZ2RtsVeczyHGtkhDzcEd4FZ+aVsVlt7ETnta1pXA=;
	b=wJpjXI+eTFzqMewIP4lEhLKtOd3MScOk1uY7E5Wood8lHw33w3MSJ70VjnzC2YrWpg63j4
	GsH/ZLtFRHIejJN0w0dhFE+j+2DXpYBix7enElwhQaupPvLVHMTzY6p8AjzhzEch2+bvUd
	qw2lGI+MtpVB6IX5PJXfpUCoCnphiss=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778567756; a=rsa-sha256;
	cv=pass;
	b=rVI4yEF0WZuiryt1WMGvSU3Q3+vl3nB7P+JeYgHj1FUwHSWPTvahmzzQ2wL0xCiH6NK6pR
	nj5zE7ySXqf0lNXFF0uiKhFDpiYJvd/Jue05FuuOv3+9ww068YsO12+9T/lR6/m+irevZ9
	vqPfUpa9G7mecWVfRkBnMOgJA80YLFU=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=son3rH2V;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf15.hostedemail.com: domain of Suneeth.D@amd.com designates 52.101.201.3 as permitted sender) smtp.mailfrom=Suneeth.D@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wE00qmlcZX0DM8v7NoBfBRQv/b/C7Ll0fScQ0WJ5oIt06BLVIIQYdijERwJuJCj2N09KWWy2lHccarYUbMScWS3OwqCPGd1k74e6ihsWOzIbIanMXVnLzjso2O1FstWpEfhq1EqE1iqgLm7mEkayct4GvQ8L0T0yHK1TpqWqTgOZW+qgbNhjAtm2lbG/qXR1oIJxLjqmbdeRcs1WaNzepu5VNoYcy9uij0BQjc8fHzTGUzHajRSM3RAd/coWRIpT22m6C3vbxOwD4xKhNgWEUQiqxJfriHmAOl4U1BvAjkxCw6FfFd7BsSCSUdLCg2IClKoxE1A9U7Fy0XCQzll6ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BoZZ2RtsVeczyHGtkhDzcEd4FZ+aVsVlt7ETnta1pXA=;
 b=YBs+tLwYvAwJbYrs656/xhz99rrfPtS5E0yrzBdz1oCsGXa9f3EF8qLZnLlX295UKu+JVf30/7DMWVtt59NfLScVR0NZZ6cQR6X08GpF/csCkaMhhK0AVAGQB2p4uk/dPt6IFDfKSyGB0YIv5M0IUqZH9adjqbrzhb3m1dWLLu0a/sLXV2EwdkQIVL6eSQLukJ17V+IEv1tmOf+TXUQlFxs9D1YeDypsxwoWsN0yVYUwOGdWOyv22/LZgI5+lW0GBWIk8JFAsBeRRkDa6Ft6MyCbD169T+A1XjBOWjCR/YqxIpoM8wTEKo4i8kZNlhzVyJqIvqFLRYNdK8f4zDv2Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=infradead.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BoZZ2RtsVeczyHGtkhDzcEd4FZ+aVsVlt7ETnta1pXA=;
 b=son3rH2VbAfxbuSBq3EuvQN+grUr7813LW/wBsO7nFis3Xf6IaL3ScuWRCx8oK0vMnnxTcw/zutSXPwsInhfGN0eeDbzA53WulpumbEw7GPFJ7aOVfPX5M/AxQWyXHDd/XLdPm0dxINcyczFK1b7PQu3lGuuYstDxH9VnPLAf5Q=
Received: from SJ2PR07CA0003.namprd07.prod.outlook.com (2603:10b6:a03:505::26)
 by SJ2PR12MB8649.namprd12.prod.outlook.com (2603:10b6:a03:53c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.18; Tue, 12 May
 2026 06:35:51 +0000
Received: from SJ5PEPF000001F1.namprd05.prod.outlook.com
 (2603:10b6:a03:505:cafe::a1) by SJ2PR07CA0003.outlook.office365.com
 (2603:10b6:a03:505::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.23 via Frontend Transport; Tue,
 12 May 2026 06:35:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001F1.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.13 via Frontend Transport; Tue, 12 May 2026 06:35:51 +0000
Received: from [10.136.39.237] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 12 May
 2026 01:35:46 -0500
Message-ID: <949b5985-c47e-4b22-ab63-eac3d290e70c@amd.com>
Date: Tue, 12 May 2026 12:05:44 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 26/30] maple_tree: Use maple copy node for
 mas_wr_split()
To: "Liam R. Howlett" <liam@infradead.org>
CC: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Andrew Morton
	<akpm@linux-foundation.org>, <maple-tree@lists.infradead.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Suren Baghdasaryan
	<surenb@google.com>, Matthew Wilcox <willy@infradead.org>, Sidhartha Kumar
	<sidhartha.kumar@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl
	<aliceryhl@google.com>, Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>, Arnd Bergmann <arnd@arndb.de>,
	Christian Kujau <lists@nerdbynature.de>, SeongJae Park <sj@kernel.org>
References: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
 <20260130205935.2559335-27-Liam.Howlett@oracle.com>
 <c4605bf2-9ac6-4d04-9f49-79643ee99178@amd.com>
 <wnvu7fwch7vbmmngd5s4pcypaoiuzq6atsdh47nhtfo4rccsxi@kbg53gd5en4o>
Content-Language: en-US
From: "D, Suneeth" <Suneeth.D@amd.com>
In-Reply-To: <wnvu7fwch7vbmmngd5s4pcypaoiuzq6atsdh47nhtfo4rccsxi@kbg53gd5en4o>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F1:EE_|SJ2PR12MB8649:EE_
X-MS-Office365-Filtering-Correlation-Id: e4b3491b-816f-4ebc-1338-08deaff0b60f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700016|82310400026|18002099003|56012099003|22082099003|11063799003|13003099007|3023799003;
X-Microsoft-Antispam-Message-Info:
	15cEr02AhlaJ5J8ZGhYbvdWQKcDwTiBZOr+t9fOJh1BjZ8G5tyozk5w+t73MBceZiI9krjZLTVuxD7MmMHTjv9tD+xHMq4hIEAy7g590IvrLbX8Wh7Du9k+g9kxshF6DK0GLJILAili9KW4zEv3P4N3cHzpqs2Pz2okczBfFQVM3uMqMV4cxDoeXcuZajABmgZo/SfBblPrQBzBYcyDorbWbgoxQgHtDypebnDOHJabqwPgTkpp9BEwhhSYOrTFtKkQet0CmDbnwgBrPh9tpkrpkZLuwKYzWhvqTn94vibbvxN9UBwMmFPs+8+SNQIoQl2G/Z+USH3qrTZtMhf1QsH79wOEd36AFxTK1XMkrxEIAZrzvL+93+rrUI3DgRaoUSlB2pphmzevbbW0yeZHFRvn2eeBTPJMQw5R7dnCdeaZ1/fFYPNHB6nZy2RhQeBMF1S1anKFTz10ZI2lD4iNeVZAvEx9feQXgSAIq8BAU55RBNHFnOoX4L+hVqjY8ikBYDlFEoNgtko4Ca13zRi++aYgT31z2D8Vef+rRqt1V5VoSHGUGQ/XDhrbwBPnW+Nw4dGmiJvcQEbW+FLz00AOK7xqJkhJBGCZuWMsTepkRMuXZzoCo+tL354xnVa8jhPy5vkG6C1Rbg80qgxED+sGUKNYFGYjwLRJgpaeG5jm6Yi3YruVzUcu/oNFC+Nge3xZRiJXru0OVkY6h9YZFRmT/Zh/pH8rReWYHXpQZAjSDL9g=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700016)(82310400026)(18002099003)(56012099003)(22082099003)(11063799003)(13003099007)(3023799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	m2kKZeTIk2dxdOLuuQ1HLwNOf9coqNry7A1iwvAEOSHV05TL1H121ieIa6bE3CJH5yewlPqygWrmDM3LNaLwWS5FEPbrm1KG5i3aHhl4AmPyme8nXkNaMbklj+h3YCQ9IijKZXdHONfufy4BXsyp5DN3EVzpx9D0zm4xxQI6+NpSm3EHeWz3dOjdUhioxsXlwDIFBcmvZExoXF7+oRiphnLo+8cbI48SE6CMKlvhqySA/jzTAStn4T01CCoHmZ2wlwkAool/Ozi+KoumMg+G5SYFTVhSHrWEIrPVDFSNWb8cCu+lsWW5ZoO1irPBRNr7J8ID79sPT56y40VFwKgsyCeaTMjre8Q2VJUqMZhcJUP8uoWtPO0OyzqfVXn6MKRHYDUDLKQ8d4tLmPasxrg++Y77fab4JQfwnsEJkon0nmOeZXhC7YauvTPAxogQykEp
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2026 06:35:51.3840
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e4b3491b-816f-4ebc-1338-08deaff0b60f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8649
X-Rspam-User: 
X-Rspamd-Queue-Id: 58745A0007
X-Rspamd-Server: rspam04
X-Stat-Signature: gx8exedc9howh77ywygebbker7sqpnyp
X-HE-Tag: 1778567756-18767
X-HE-Meta: U2FsdGVkX19sPiNH5Qv+Mr/J0Op3UcAcyBs6B0iF/56STXy+dnfUcWrkMX0gaXmTlgAevMEXEu+K+BnO4NOvGsnjVixSXTd3rc4oWPSFdDYveF63yRxa6vCVCS8b+Lyh9u4JVMMM4ipXkwNoenPwsru3EWEe+tOgRSteZRbVONVGvA+sPFetS225WOrAJOrBULJtS6RVZ5SMkJtXBQskFl23RaQTN3nz/jQJ1GvK7/sD6uu2Yr5iuIu80Rc4Kvkv9jwCMqFIeLNMNLI/JbyGKsdwCkKfC/cPQz2z1n1uq82USE8OZmVz0uU9pqH9kA5Qi0DhTPS3qyNaC8+S/aJ7/A++DZVFDAOzcxorlOyH7YtFZPE4N76TU5Fbyej7WE64ZqJzDWCteNUYiy/P9FfAEtxG1xkMpEfnSccTVJDSELzmwnFdG7n/EQEErqPzf4XDdgtuv6V1A/535wvlyMreOzRe31spNpqKULl545LzXSYiSVpHCczns+WepcU7k/9Ev++y3WBpTTAqp9jrpvLslxnEK6SYWZ5XREUbyT9f2rdwrlyeAs6dVQQLp6zkOsD0ceOhhF7U9OvXyza6yNMyDFKBCn2bJ3god9t3IR2nTJkLpxjCuIh4b67CJx36Hxe5wRQEu2dKAv9Zh6re1gHPKS1IwanmDKsQAFhnN55XgGoqQAd1J8pMXD6uwCJAd+CGrVqbFFSjJbfmWNvXz0D+CKq6TE3GygpqCj9UyI40SeYpF96lkglhYLlsx33eVu9lAaP45lrlqm+00dTSUrHD9Hn5EtG2XxhulWVeiGsPdFi23OBn9AJizJ+wO1/VaDqIuSzJUl7QaBk5XYK0zK/AB+YeC4XYyj9h2P5K443eAkJ8ZnDPQXoZjiqSQj6HnvE10w2aTgvZHUThyQ6u4UWdCwsNxSvB04i9t7BgEguo6P56OveWn+/8BoCe3OMhj9GvoALsF7XJOUM13uVA7//
 utTBYvOV
 0iQRPcehPgug/j8DCi1tCHjUuJVIe2hkdNxW7g8ZbdelwVpdS/afDIZALv7/6TXwHLOAMCU2XDBgK2r3xjm6cBt3O19WofeTSTE8EKcQyYvKN/cnFvzYoxYDAd9CSr736uuW8b9oc7mXYuadsJzdcqa9LNZkNYlu7wb/p7AXkY/uzwlgjBtA3u+QzQmopGTfnCve1/JTqWjsBq1VE2OXYMMf3ec57FWIGakjoRnpDrNNEPrRDI+in6IpSw+5Y9MY+USPyhxCc787wHMPsp5vbDLWC8K4HA4/u5g/jIYpqWLKxa8XoPGCa9H0RirRtovSHIfGVut4pyGmc03aXyMTq/mOD8peSp9XjQBC4Kz40aMxtBlLqqZfDNOFq6WJg2S+m5SDjJMAFyIf26xSBe11kAgUWAvbJY8koJn2kidWqeMqBt8VzBRxrvBvE+tgqlySisfDW7n847n+wJkrk32qdQFTiZXMijcilq/bJ7unTcDLsfwo8hIdaMtnkT3wdFT6EtziOvO2FPIN902DpgK0iy/XpSbkp7nBlrFB4BC2M9Pd2l3yAZ7FIaviSO43EhummozkvAWIqHpoAEK9dtzZIWiPYXnYPuheY5vcYx1qQ+bpxSKQCgF6rbzD/DnTbAMDMLr2AuAwu/8WM1Onlb9lstopns4Yn8dootBUP2VDyS8h4znjTuooS7GfcqWjvcTtiKmt4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/9/2026 2:48 AM, Liam R. Howlett wrote:
> [You don't often get email from liam@infradead.org. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> On 26/05/08 02:12PM, D, Suneeth wrote:
>> Hi Liam Howlett,
>>
>> On 1/31/2026 2:29 AM, Liam R. Howlett wrote:
>>> Instead of using the maple big node, use the maple copy node for reduced
>>> stack usage and aligning with mas_wr_rebalance() and
>>> mas_wr_spanning_store().
>>>
>>> Splitting a node is similar to rebalancing, but a new evaluation of when
>>> to ascend is needed.  The only other difference is that the data is
>>> pushed and never rebalanced at each level.
>>>
>>> The testing must also align with the changes to this commit to ensure
>>> the test suite continues to pass.
>>>
>>
>> We run will-it-scale micro-benchmark as part of our weekly CI for Kernel
>> Performance Regression testing between a stable vs rc kernel. We
>> observed will-it-scale-thread-brk1 variant was regressing with
>> ~9% on an AMD's Turin machine between the kernels v7.0 and
>> v7.1-rc1. Bisecting further landed me onto this commit
>> 280b792cac62ddadca2935766ca870b438c86323 (maple_tree: Use maple copy node
>> for mas_wr_split()) as the first bad
>> commit. The following were the machine's configuration and test
>> parameters used:-
>>
>> Model name:           AMD EPYC 64-Core Processor [Turin]
>> Thread(s) per core:   2
>> Core(s) per socket:   64
>> Socket(s):            2
>> Total online memory:  258G
>>
>> Test params:
>> ------------
>>
>> nr_task: [1 8 64 128 192 256]
>>        mode: thread
>>        test: brk1
>>        kpi: per_thread_ops
>>        cpufreq_governor: performance
>>
>> The following are the stats after bisection:-
>> (the KPI used here is per_thread_ops)
>>
>> v7.0 (baseline)  %diff   per_process_ops   kernel_rc_ver
>> ---------------  -----   ---------------   -------------
>> 353091            -9     321987            v7.1-rc1
>> 353091            -7     328897          v7.0-rc5-280b792cac62(culprit)
>> 353091            -1     347884        v7.0-rc5-11e7f22f5e85(culpritm1)
>>
>> jFYI a very high level call trace from running will-it-scale-thread-brk1
>> which ends up in mas_wr_split goes like this,
>>
>> do_brk_flags() {
>>    may_expand_vm();
>>    vma_merge_new_range() {
>>      vma_expand() {
>>        commit_merge() {
>>          vma_iter_store_overwrite(){
>>            mas_store_prealloc(){
>>              mas_wr_store_entry(){
>>                mas_wr_split();  <--- Function of interest from this patch
>>              } /* mas_wr_store_entry */
>>            } /* mas_store_prealloc */
>>          } /* vma_iter_store_overwrite */
>>        } /* commit_merge */
>>      } /* vma_expand */
>> } /* do_brk_flags */
>>
>> Recreation steps:
>> -----------------
>>
>> 1) git clone https://github.com/antonblanchard/will-it-scale.git
>> 2) git clone https://github.com/intel/lkp-tests.git
>> 3) cd will-it-scale && git apply
>> lkp-tests/programs/will-it-scale/pkg/will-it-scale.patch
>> 4) make
>> 5) python3 ./runtest.py brk1 25 thread 0 0 1 8 64 128 192 256
>>
>> NOTE: [5] is specific to machine's architecture. starting from 1 is the
>> array of no.of tasks that you'd wish to run the testcase which here is
>> no.cores per CCX, per NUMA node/ per Socket, nr_threads.
>>
>> Would be happy to help with further testing and providing additional
>> data if required.
> 
> Thank you for this report.
> 
> Considering this is brk1() in thread mode, I'm going to tell you that
> this test is seriously flawed and will not produce anything that looks
> reasonable.  The way it is written will race all over the place and thus
> is unreliable.

Thank you Liam and Matthew for your candid feedback. You're right that I 
should have reasoned about what brk1 in thread mode is actually 
measuring before treating the bisected delta as a real regression.

> 
> Does the same test in processes show a regression?
> 

No, the same test in process does not show a significant regression.

v7.0 (baseline)  %diff   per_process_ops   kernel_rc_ver
---------------  -----   ---------------   -------------
1050189            -2     1027859            v7.1-rc1

Apologies for the noise, and thanks again for your time.

> Thanks,
> Liam
> 

Thanks & Regards,
Suneeth D

