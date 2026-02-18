Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26DAFE9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 04:01:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 576CE6B0088; Tue, 17 Feb 2026 23:01:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51DBB6B0089; Tue, 17 Feb 2026 23:01:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D5116B008A; Tue, 17 Feb 2026 23:01:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 27E2B6B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 23:01:33 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A31498B89D
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 04:01:32 +0000 (UTC)
X-FDA: 84456228024.04.D8FE9F4
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010020.outbound.protection.outlook.com [52.101.85.20])
	by imf13.hostedemail.com (Postfix) with ESMTP id 858772000A
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 04:01:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=XaCTThJQ;
	spf=pass (imf13.hostedemail.com: domain of KPrateek.Nayak@amd.com designates 52.101.85.20 as permitted sender) smtp.mailfrom=KPrateek.Nayak@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771387289; a=rsa-sha256;
	cv=pass;
	b=wW+8qnnEwn0TfwrPIGq1DYTWnurPas8mrUZ2SV3eyiJRtvdcE3TKvqxGXC1r3cXw/HCG0G
	GsAxMqrxIIUBP4iC1yi2tiJWvfq1Zdyx3aHUUIK1hMO8DTONQVc5/VvM/wawpsbyKLI1YG
	Q8fE0ctYlOpWGWpSZYiRVmViUJco2ZY=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=XaCTThJQ;
	spf=pass (imf13.hostedemail.com: domain of KPrateek.Nayak@amd.com designates 52.101.85.20 as permitted sender) smtp.mailfrom=KPrateek.Nayak@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771387289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3kbpHbNDdDy9wF1/lXnJdfDxg0j7CZOIf9SLIunZG/E=;
	b=M4fmZWQppU9KmziJ9qaZ4E6+KK/yAZhNh+jaUaCpHmTf2Q466qMHqQoc4LCwY61sb69gN7
	hfG49zY5Yw8J+97o1fEbIPlXFFH7PSf7YpJWYuSzjPjMuZD87Yi0fuDR52Ec8X4q16R/y/
	QMZe9S21D+WLoOA206bMDyygt3daCE8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jl1AT7DNLmJsjdiwKIMJv9Kx9BGOhmQugy7N4/LJ2hZ/6PfDHV1JxpjJBInzXbMvJV8wOhKNBIGEqd7WoMRFmYj4jYAceDanuhZU2O19gtWwF5aZWHGJ794PLkSIInYRIIhtHBdEvQSaRKg58ROMiLZ0y8wxR+OCy4p51JCAKUokxrLknJmRS04EPq+bN1sJL1LyzmizC4fkwFMhm5mghswYIUd4bmIUDj2JtDXZDZ8IC0+6y0zoKJ+0rrWLsaM6eW70vkDmXLUc2k4FdmsMbjCcK3oJrB598iIkR162aiSyC829eicA8D/iOMKQGXHpEvPtUq/gwFc9Sp47MmjT2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3kbpHbNDdDy9wF1/lXnJdfDxg0j7CZOIf9SLIunZG/E=;
 b=FYu4i6eicYij75fr4HMeks7uzgws1ZF7AEBWCEvFt6Q6PkjyeidXR1ZvL2Pda70EDryuywH0tMr0FFPZ0S8P08otm1+PamVFHGfhzYyAlRZsOvOqJ2nu0x4bikW8cdgsgYMN/4HocXkevaAS0MxV4uqs02+DSqWy6wwe2tPeYhFQ3vUn3Og0zaOIXUf3+xyByij13JLjdDKqkI3MWJeYLdTBw72LmbyJd/hMDoVS3nW5BK5rGMnu+0tg4NJrM4Nmv8JEluy6Cl9MMtrDdtHqn+8Gu3znBHcK/s/lCRrrQOMifogvxC5vr9nOH9wrRNRRjKEedLCsTUeTMsI82vuupw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=arm.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3kbpHbNDdDy9wF1/lXnJdfDxg0j7CZOIf9SLIunZG/E=;
 b=XaCTThJQHczrL9vqarurCvEaKQOzfzC+WhOlsXor7nw0HhiiGiw7N2YWK0PFI9BKX4gTeLCoN2Ne3ldEO4heT2dy3Q0B11UZbr2GKd7xdiWtsqJ2SqU/MF1SBS1E0sts3Kbbs4Bugt4hC+RWxCNRuaklpGmKZPCeD9STdMcs1hQ=
Received: from DS7PR05CA0040.namprd05.prod.outlook.com (2603:10b6:8:2f::33) by
 MN2PR12MB4111.namprd12.prod.outlook.com (2603:10b6:208:1de::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Wed, 18 Feb
 2026 04:01:24 +0000
Received: from DS1PEPF00017095.namprd03.prod.outlook.com
 (2603:10b6:8:2f:cafe::2e) by DS7PR05CA0040.outlook.office365.com
 (2603:10b6:8:2f::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.13 via Frontend Transport; Wed,
 18 Feb 2026 04:00:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS1PEPF00017095.mail.protection.outlook.com (10.167.17.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Wed, 18 Feb 2026 04:01:24 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 17 Feb
 2026 22:01:23 -0600
Received: from [10.136.47.100] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 17 Feb 2026 22:01:20 -0600
Message-ID: <a537c546-2fbf-4509-b668-33851e0d44d5@amd.com>
Date: Wed, 18 Feb 2026 09:31:19 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64: remove HAVE_CMPXCHG_LOCAL
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
CC: Dev Jain <dev.jain@arm.com>, Jisheng Zhang <jszhang@kernel.org>, Dennis
 Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter
	<cl@gentwo.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <maz@kernel.org>
References: <20260215033944.16374-1-jszhang@kernel.org>
 <aZL46z1UZkQlF3Dd@willie-the-truck>
 <89606308-3c03-4dcf-a89d-479258b710e4@arm.com> <aZRyzy0SJ8uF3K2J@arm.com>
 <aZSChrCVnoWSe7h0@willie-the-truck> <aZSb8VbCC471Cw1X@arm.com>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <aZSb8VbCC471Cw1X@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF00017095:EE_|MN2PR12MB4111:EE_
X-MS-Office365-Filtering-Correlation-Id: 99cd9220-d20b-47e2-9c53-08de6ea26202
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MUhVaVhTanplVjFhMzIvMncvRllRdHFyMG5iU3dZR2daUHErVDVsVklOOTRZ?=
 =?utf-8?B?ekNBdEpOL1I3aFl3SGlMQ3d0RDI2WFZVenVsNzRRTmxqYm1Nckc4TzBTRTgw?=
 =?utf-8?B?RWloY2JoRnNyUnlJYnZscHR4cURDRkNNNVFNZ0orVjFEM2RKTFJPc0JidkRs?=
 =?utf-8?B?TjgzZitWN1ZxNW53RjhsdDBleGNXTmJYZVlRSmFWRXJqTFlGR1ZndHA3V240?=
 =?utf-8?B?NDVYTEtBYXhsTzdzSWx3NVhpVHVadStWQUR6NStCNEhYTERDaTdoYjRydlhv?=
 =?utf-8?B?bC9LbWxVWExoeXNUeUo2ZXNsS3dKdm9STzdVWEh4QkRoY2V0V1h2NE91QUkx?=
 =?utf-8?B?SEl0Y0xoZUpGY2ZjRlFKMWpJaE9uZCsycVFBdHBkQWJ1M3BHaElyQUc1SW9C?=
 =?utf-8?B?RFVqalFmRkdxT2NHMzF3NG9qcDJ5QjhOSTNRQ0g3UlRLWWorQ0FMaGoxVFVC?=
 =?utf-8?B?WTVzbHlsU0RHOVpiMWV1a3I2UXlSRDV2eUJ4VmtsdUN1bXRlL3p3dTNld0ZP?=
 =?utf-8?B?ZVhJbzdLQWtYOUV3QS9XS1pvdXcxMEVndVBqeGFDYTc0dnJXdDhOK0s1Tm1S?=
 =?utf-8?B?c2hRNlJQcy90ejhaaVFkdEo5TVRzeTRQQmNMWWI5UzZNTzVTU0IxOUl4VVBO?=
 =?utf-8?B?RlpWRFZZZkxOMkFGcHVybXNRNEFtS095UUxHWE15RTNsZ0hqZzhmVUVSQ25T?=
 =?utf-8?B?ejFqUmU1ZmZPbXJ5TWxrQit3YlV3WXlXdGNhejY0UlFscGNVNWh2ZUREdkR2?=
 =?utf-8?B?ZW96NkdSRzhocmJlbTRJcFMrdUlSTHEvRjUwQktRM2VDTmZtZ2NveG5uVkFr?=
 =?utf-8?B?enRoaGtKZDB4d1luOEpRZm1rSnZSMDJOWEYrc2tKTTdxdFZUaDl5ZFV6cXE0?=
 =?utf-8?B?VitMSSt4ZUcxU3JhTUR0Q3dRUTdIbEhyaUsyQXZlT1FFUjc4U1IxMTJnNlh3?=
 =?utf-8?B?S0h5Z24xYnNsYytGdGJDR3NicUtPTlV4TXl4bXFSQXBPKy9kTWQ3KzlzTE45?=
 =?utf-8?B?QWJVN2dwQW1sREJJV1pQbWhuR2VCVjJZZUNjM3YrNFordXA3QW83bWoyNlhl?=
 =?utf-8?B?WVpaSlk1VFZGZDFUa1JLYmt5ZWlSM0d6RmlIZm9odi84b0dBNnM4bkxTaE1n?=
 =?utf-8?B?RlBMV3J2UGlQaW5velBCRk9FdFRpZG4rWWQzSkdWeFFkb1dTdE1kaG5VZG1z?=
 =?utf-8?B?bGI1cjlPMkdZYXBzTzRzbEhQc2hWQ2FlV0lCQmRBeGZQT2Y0bjFzazR1UU1N?=
 =?utf-8?B?bXQ1a3FuSlFLQjFHeUpIalByQWJUbnp1Wm13eDZQV3g4bzFxWkRvanpDYUZR?=
 =?utf-8?B?eUIzWVFBRWRHTE9qSVhjazQvZjVUZGFlMVQ5bHBRcTB3emdLSWprdk1wUmZT?=
 =?utf-8?B?VkVlTWticHNtOXZybUlOaXo1c2xnVmM4dXRuN005NFVERmdLRmE0ZUduSVhE?=
 =?utf-8?B?WnJ5enlxZkNuOFJoaUFIR3RqdG9RSEowYWpZSHU3RDZ5cUttU2RZMUdLa0hr?=
 =?utf-8?B?TmJMb3g2ckN1dFg0b3VUVHNaU3Q5Nno0SFRGWCtoRGdSQWV5MjdWMXlrdXox?=
 =?utf-8?B?Z2svTnIzY0RRemIwbFpONmZJaDRVV0xDSVNYWkpOZ1k2YmdyNjNqeENGR3NQ?=
 =?utf-8?B?ZUJIZWNURkVlYjBvQWxCakVnS2lleFRyM00xMzRmUEFNWVRHcFNlQ2JoUk1q?=
 =?utf-8?B?R1lNejhHSjJFalA2REZGQnFKTXRtYkVEZGh6dXVUZlN5MklhYzJhbEhoYVQ5?=
 =?utf-8?B?c2ZJYllhM3dESngrdGJuQU9NTDRFWFNSc3dWcEEwbTU3ZjZWV1FacWx1aDBm?=
 =?utf-8?B?ajdRMFlzRGtIUkxTSnAvVHpqN1BPeWh0RWNoaUVIL1pPK0dnWnNNRnlpcGor?=
 =?utf-8?B?NHRQaldkMlB5OTRLNWoxYWNNazU3ZG5ZRlNRWDcyRVVHVDFXa0tNSTFXdGZK?=
 =?utf-8?B?U1BQMlpDNU5CWE8wU3VkWEFubC9qMEltazlJMlp0dEI2SXRwb2ZnVFJGeGVi?=
 =?utf-8?B?bnZFdnVIQlVDMmRYMCtReGZQSC9PVHFrc1RIZHYzelpOb21yLzBiMnVaNXhu?=
 =?utf-8?B?VjVyZUg1SkRTTTBSUzNUREliWU9OZzN4MGl4eTFvL2dtMWN6RERrRjF2dUFO?=
 =?utf-8?B?K3lmK01Jd0gyTVNSUzBhUnEyQ2dyaEhuaUxoSHN4TGJ4YTdRRXdnb2o1K3Bx?=
 =?utf-8?B?RDB0ZkNjN2FudjI1ZVNnd2pwdXIxMXE4U1BGVVNtQnB6MTZKSUNVQ3F5d3B0?=
 =?utf-8?B?NlpmL1BWSFhjY1ljNTk5cVZlMk53PT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1AmHXmLN/BvEVVhxH18xzwhXBoychBXVuAXwYdIbZyTpGoOZ/pq2iNPTKXzwyJeCO3MQoUZED7ZHWrHle5rxtIZ0ujya3KI+xdbQZhAPs1owyFLhw60b+2Ug7BhOpObhDxK0S7Jl7tGW1GyOdPKHiRXvr1TmwKNRA6RFNJ1mCBc9KEUfcXEo3fDaenlyglNH642iLdmp/SfFEHE0RIciyuI9rWqpfyvUrdq/qYx8IfjwFARkAQl0py1jX3GNyvxhOexayKDhqNsj5O/NB+qgf/qUPuGK+PVUVd6fxG5xma5fgElJH7wBOzL+ce3UXcwAdppQRSqGq0g77HaCVuGpD5hqv1dbEUwITgJ4yO/Fgyf7OcUb2Q5cvqtfwcQW5+rPRgCyGvY/xUrBMbx1AdyBbIWRbGQVWDaq4UKBTluuWeIjtJrDtzJSwbIWNnUXEz7i
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2026 04:01:24.0855
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 99cd9220-d20b-47e2-9c53-08de6ea26202
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017095.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4111
X-Rspamd-Queue-Id: 858772000A
X-Stat-Signature: tzjfka6464uuxuiuau3e7r5ncwesstrn
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771387289-224248
X-HE-Meta: U2FsdGVkX1/HtHpGYuWJEDNTl73GJBi+pplCAoZcE6E1uf2Kku769dxlYHUli14OMc2+ZjX+C+oxZHVhVFjThVVlQdnUmjn/nQwhqRPwRMuBehc5KljlkLZDOWlVE9AJABaVGclx69OU2wsgC6q03wvaM8uxcss0gGw8lCJ8wqq8bQ1P+4YrMZIffdyB/U+CgDAB19A9byBRmhWglFuvxtHN6KqQdYPy3XJUYHy+Je9jbe+oq2jZWqQiB0XLIBiuKBZSBOU/8SZzDY6WNSgTv7f3OnHAPjm1xvr0WAkquJTqw0ePb8pGPmzrO7yNxUAmANq+cNjnJ0FnVNmHdiRRzb0GgLdx92wdzKSRYNau5OrFXPFg0Y5HMx5iRcpEnlR/AnrvQc3ybmku2Jdd2mNlx7aM6LoDTOrKMqcsueA6Vn0rs5S0w012DGW8AIdbP6PigvTOpfwvNevWHmlt7AdQ00F+ovLg8QazBc2N55uaRvV//jRRtQWbaYLbtsVIKLuPH84+4VawF8YXFmauO4Ig1d3cAD0Mt+muiHANk09pg6eYFpIvT4DSPsx2ImF2HuBikrGc5qg0vdf3R6h1EYgeiPI6M7CibN306fSPMzewYLMd1f/BxTs3Vir7BNon+kFtYaWnpJkMfgBdC+jXNBMJv8NV3ARS8Y3gzlOSAHzHqMiE53gD648M/i1byAOIiXBiyFQpg5oIxxLdfWbOVfzwx2Zv2Q6++Ds6x4SDdxwLHb12I+wY7KVRTabACGs582cx2JW4/vzYT9wMu5lmT2/+1O+Ia2YQ7rIc/7cdB+OpMkajqKIfhbppZsqiJ4W6qghtrhK8eXo7LhbgfHhcnk5jLRNgc4loak5ybXgVWWUseQPwtqarlkP1cs/sAsbBf1JF9iYfTJKoyPq2Av8nwUurOF3c4hzkMWZhY8CN80n6/JyK0L38KO9H1q5ehJ36KXHrS2aARHhVU0IprxVBQFs
 siDhR7S8
 JdtddvrwIkuBc2rrC7q0qiZpIqYAlACw4ECUFMaKmsWkIcwtv2aAGzG350AMFGYkh2rmmDqQtsstxmHZZqee8bjYsLu9mlSCPQJBfBug7F5zmBB9DOU8FDKcpNQt2FiaVfgOD1nG8hdHnsd7XrGi2B+mzs75PL/Hdf8D7cgsguYjZtKiQ9Sq3PreLRJBMmpPc3LDMXFlRSXSsLQ7r8fgmh+TgKYzSEv/Ww9ME/wyaY/l52cGQEPOy9Dr/SUUDsRH0g8qIQeO6DapsPAV51xvwlZ8abmPLq+l4GLEr3NjbOlFzK0W2urvf2kLfyf7vJkniFlNxC50HNy7+KpzQ5m9dOx4w5oGtpzDU/yDecLakAWNKm+qJkrAKOqcJoHV7rAZ7pBU1M8Q8KSfK5TxcK3OCYgyYeAOSdiaSqeN9o1TculS5E8a/Iy4kTAfyGkjhNnyJI/s165ZNrWUYiOA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Catalin,

On 2/17/2026 10:18 PM, Catalin Marinas wrote:
> Yes, that would be good. It's the preempt_enable_notrace() path that
> ends up calling preempt_schedule_notrace() -> __schedule() pretty much
> unconditionally.

What do you mean by unconditionally? We always check
__preempt_count_dec_and_test() before calling into __schedule().

On x86, We use MSB of preempt_count to indicate a resched and
set_preempt_need_resched() would just clear this MSB.

If the preempt_count() turns 0, we immediately go into schedule
or  or the next preempt_enable() -> __preempt_count_dec_and_test()
would see the entire preempt_count being clear and will call into
schedule.

The arm64 implementation seems to be doing something similar too
with a separate "ti->preempt.need_resched" bit which is part of
the "ti->preempt_count"'s union so it isn't really unconditional.

> Not sure what would go wrong but some simple change
> like this (can be done at a higher in the preempt macros to even avoid
> getting here):
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 854984967fe2..d9a5d6438303 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -7119,7 +7119,7 @@ asmlinkage __visible void __sched notrace preempt_schedule_notrace(void)
>  	if (likely(!preemptible()))
>  		return;
>  
> -	do {
> +	while (need_resched()) {

Essentially you are simply checking it twice now on entry since
need_resched() state would have already been communicated by
__preempt_count_dec_and_test().

>  		/*
>  		 * Because the function tracer can trace preempt_count_sub()
>  		 * and it also uses preempt_enable/disable_notrace(), if
> @@ -7146,7 +7146,7 @@ asmlinkage __visible void __sched notrace preempt_schedule_notrace(void)
>  
>  		preempt_latency_stop(1);
>  		preempt_enable_no_resched_notrace();
> -	} while (need_resched());
> +	}
>  }
>  EXPORT_SYMBOL_GPL(preempt_schedule_notrace);
-- 
Thanks and Regards,
Prateek


