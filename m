Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69D06EC01B1
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 09:58:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEB0A6B0005; Mon, 23 Mar 2026 05:58:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA0ED6B0089; Mon, 23 Mar 2026 05:58:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8A846B008A; Mon, 23 Mar 2026 05:58:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A77EB6B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 05:58:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 50065C329B
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:58:48 +0000 (UTC)
X-FDA: 84576878736.29.9C36803
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012051.outbound.protection.outlook.com [40.107.209.51])
	by imf21.hostedemail.com (Postfix) with ESMTP id 20C411C0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:58:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=BnDjZrnR;
	spf=pass (imf21.hostedemail.com: domain of bharata@amd.com designates 40.107.209.51 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774259925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Re5AXvLNTBOZS3wIcaAEiYDf48U2wIogHIOuFp2Jlzg=;
	b=hJzn/NDrFdu3XhNtAgJBxXBAv/t0GjOIdErpU5iX5IHfBHauR+MmSgYtrAkn/cZCwfDV+f
	/sS2npAfJKx87Vpv+ddWohI5T4Z9KxOb2rRrVvoNsYjl8j3bQcEqy4UWdQHzplCCp4rEbu
	el179Tzb8ec572YT5HP4FxTRyA3Sz+s=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774259925; a=rsa-sha256;
	cv=pass;
	b=SmM2XA6oQ6sb6jPuEHDQe2KSpjCLPyGLWqrTo5f8yYUudYU/dgGEpcVXWrDr5BBHuOGyK2
	JK0Z0jgyccKqk3NpSAysVYgU/RFx5AMJI7npay3v4asiyzV/tQIoy7PUFaSwcEHvk4BdAY
	nYngkZdBYoDo/PJF1n0u/dXKwfgB1HY=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=BnDjZrnR;
	spf=pass (imf21.hostedemail.com: domain of bharata@amd.com designates 40.107.209.51 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZGSRWTeT3zVEVo1WsZIKI1qCebeMPQGq1z3Ze2sIkk4tfHDCLUP8TSc0KHt//OZOuk+JcMxzCUgvjT8KoZU+O/sOyc+zj+9IcnASwKHdzuzXvgBqXyvJo1R4vL1K1KiAvNkKxfqLLp0PvLFSczY60JH/VwDe2Tl0ZcvJhLZw7Zub07BWCLn75KHsvXm0eVTa3CjxWQDwhDIfVaphajnjSmvIdPR/PKYLiTwgCA4li1SSTc9pljSPH0yslYXZjcAIe+ZelJ/yc7v1FUi+9N5Ez0dQT8/alVKman0elzYop9ZExXMjtJaRaxevg2hGnY3PCT/fMHBAdtbwqx09mBkZhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Re5AXvLNTBOZS3wIcaAEiYDf48U2wIogHIOuFp2Jlzg=;
 b=tk5LDV16t7jyhNS6m1LrxVUOvAfiWXAcU42WyezLVe1Bci+TpOFflrVKvJoi//Bjx4VUnT95zOd8+WFJmr4rQdzBg3I+lWS98GRbwWYHjK5AfedUhIdQU6HHjJU5K/P/v9RyyQPSeypYaIwIUW+PnuCsuPow207Wud1ceoNq/aEPJrJDSPGekhYuzXbMXYlcSp/8T27AtnoG2839aCB6oh8BJeLItEK2i0IC6oqtRz7JtjWJgVR4Kv1+O1//YuJVC47Uyjo5dWRf/xDVOWMcESoApkplB2PPeF/flQQsL/EwgRTQz3PWCA3XAivikMKxyWNZuq8YlhA1XsEAANi1Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Re5AXvLNTBOZS3wIcaAEiYDf48U2wIogHIOuFp2Jlzg=;
 b=BnDjZrnRW0/g9UYBiRgDXu1Cn7z75rmIUVJ/xASAS2D5JPVRR3IXOEssFTbw4fc3qWnzet6w9D4i5ubuj9nnaogL24FMguNzfp50AwnIjS20GSvSkt91ZreBbkaaaNDc4xnSjNWi6t5jfqFDK4dSAJtIER/FWtX5sCyITx1TnNI=
Received: from SA9PR13CA0018.namprd13.prod.outlook.com (2603:10b6:806:21::23)
 by DM4PR12MB7693.namprd12.prod.outlook.com (2603:10b6:8:103::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.9; Mon, 23 Mar
 2026 09:58:37 +0000
Received: from SA2PEPF00003F62.namprd04.prod.outlook.com
 (2603:10b6:806:21:cafe::49) by SA9PR13CA0018.outlook.office365.com
 (2603:10b6:806:21::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.31 via Frontend Transport; Mon,
 23 Mar 2026 09:58:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SA2PEPF00003F62.mail.protection.outlook.com (10.167.248.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19 via Frontend Transport; Mon, 23 Mar 2026 09:58:37 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 23 Mar
 2026 04:58:36 -0500
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 23 Mar
 2026 04:58:36 -0500
Received: from [10.252.223.214] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Mon, 23 Mar 2026 04:58:29 -0500
Message-ID: <957f2242-56d4-4bf0-8aeb-9d60fbea8c8c@amd.com>
Date: Mon, 23 Mar 2026 15:28:29 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v6 0/5] mm: Hot page tracking and promotion
 infrastructure
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <sj@kernel.org>, <weixugc@google.com>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
	<dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
	<yiannis@zptcorp.com>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<shivankg@amd.com>
References: <20260323095104.238982-1-bharata@amd.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <20260323095104.238982-1-bharata@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F62:EE_|DM4PR12MB7693:EE_
X-MS-Office365-Filtering-Correlation-Id: 31cf1357-44b9-4b02-fd77-08de88c2c0aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|7416014|36860700016|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	v+97q4af3mVzzlbHnghTJnbuygd2YjzWApIidwEWBiYKtyDE9uoSN0q4S0punIkOAod10mcfWOn+nqui8u8xmtGgZKr/tMOA2/TRu+GbeFttNsuu0mAA8U5W4nxMeKdiiVpb3gDYcVpNrD1ZV/wJ+ySLtPK31DNuCU7tX67rTEBu+5xfuHgARrvSR6btB6BYIzeGxzi2gcEc63pY88Jyj6XcfPVZy2T21tGJb7I5IvLexsyYzMrUZdHWYp8zTqu3COR7i8JVWtSwsZKNQ57Gke3QTZ3jMtbG2yKhcxOCE+zakbNRAcXjoUjT0ECbGcRp3qnVaKLtRRTA3J8pDxjX6mPtlXQrU4vnUZ3RXRtMQVpw/AiiuEvg+TS7jJhaWIf/LmbRJjU1aNYjZkONeAcNNghQGpf4YriMwcm3TMYkyUG8MaBmzg48Jbn0NsUYImKMpQrIOs6clVQi2iezE/hMA3U3PSAMr2KpKhe7QY/JEg/5i+LzVpRiRL1A5Tb37cXwNEx5NwDeEs+st+6CO9tkrJQwOYvcvkRLABKEWPdyAdL2wAcTLpUo7VKgkuHjY6vSJRK5v0KHqOtlGrRYhkW/zwsu67hM43E3rVesUUafCyV8lrbUBQVdymyWPLKsym0VW80huv+rs8cnTxmgcJi87rC7C5l42ljPIvmRxVZSY/nNZCBEtbLiNWWVk/Am1QSHSoqhgJ1+zwjiYzburq45jW8Aiw2Gv+wFyxpFT8JyE4XqaE13wwzjTK2V9hFOMZ2LszZ/wtn8M90yHUMyYaok1Q==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(7416014)(36860700016)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	WT7CFPkFmEyjGYwt8O25+HbTw85M1x7NDp+GIuDNb+UKE++g2G/KhhsAJM1AJvCEDSOaexegYraZcI/cb9cSFZzOyGELKyplLOgccVSs0ueg42yrS5NZNcbi/tkCf9r8raCDHkp1CytUVnccwYVLkv5GmMXjthMTWTAlV0qn/MT3Lmgs6krJSQ9Eb/r+GdkUAJsbWL1efRRaKBrPlgfAvT50uGyzwLwYexIGnn+Jk5Pg4n0+2tSrUl9yooGkE6Qe9qqdN9o8YbcwBoSRDWJTV7fe6LsiFr9c+RaIrpJHWiTFfLMchunxeh5hILN9h+spA2vBo8nqNjxIXSyutDtUaT22V97RT3QrwssWDI6jkU4w0+UntMhEwkozzz6vj4bfZ/xNrjv2yEWe2canJ3Xa2VZbH8xt6dyaVhpexFaDYHbi86cC0GFQoRjbIejNg2s6
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 09:58:37.0019
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 31cf1357-44b9-4b02-fd77-08de88c2c0aa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F62.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7693
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 20C411C0005
X-Stat-Signature: m7tmdbk6p6s7om4cd19dgiux4xr69kxn
X-Rspam-User: 
X-HE-Tag: 1774259924-277867
X-HE-Meta: U2FsdGVkX1+ITvv992AJVpuyDdZkJJuvdu7cSTTGo+ORCU2wovFLY7/hBRqy25DLs+8C4TQVkVp4UpYahwjR8l3PD7ukmGzcivhfRLLTJtxkSfx9m8tmgrPmTKMzamLG4S5cpMv7YySM2c/iz3L3+G0KZVvD22oJUtsOFhbEFNMOsgzj3zZI50iDp7m3WE1e7GdSVTV7wsufrMVTezsbKzrrG7gSPuj+knNSspglU+qVV5QGJnpCwFtFkYZpblmzImogYw2FXG/dPB4ArUOG7jYh5DcRja8wLxwb4sVaYhc2LyRHYCwy7kQXipItY+263NlWOWNM+WPpsRbtiIESAegxj7M1IcTTCd4jJcyCrH/bklVnFkUp/Wzy+uu93Dwf3JHtxFa34VmTy8wiCWYqTOfcn7eJWgsJBWP9I1YGFSLoz17eVitB1QP31WxnMUCyh0qdeyK2h3hzcDlbT52M3KWchdAcf+vFKh78b3MBfMdA3KLLeo0MWddRqx8ONdg+i6L6FAMUfsC/gSu7S7cdMehqMl5Asxz3wuAJ7ZjNU3K5PAVDNvXDgfxPdLbD7HyXBN+Z9ms0fBsrCT8vJ0/vfbYKD6KHVh8//tdATI0Lga7mNpzlf6k9bxrAhokYKpwIQGZd/F07nyOF2Ngin/4CbSlGMOepyLmjN5S3LGFnBdCladbFkgJbM3BBQfBe/cT2CzNv2kGGs7JkDGOHrRYQP+pn+iXtiSBMwtXBb+NNbVgBT93CiBl8sLg+RGxKX4CM3U3mA3uR0aNVMta0ldY1D3EGz8OXscNSvjQKittFKbBmfPRiCF439W27Cbo2jbBdzWOb8JWMNzB6FmOZOy7NR1fItRBjn9+lBb9VvgO24Q0kboJlitm4CA0yNaIqrCWZC1c/N1FfK457v0xjTmiDeIlSPtP65rYBRYH9/o+QZEzffkoFGoSmgFuvuYTFEuXYj3uttunzMTJIl25p7K+
 0Or1c+n7
 7bJ/9tQHOrTqnsKRIXtwVMqbqKFl27RXjCCW2oHHNIgYbiVHHeO/6Yq5hjrpTroI2S4sCErV952Gxd4P+VYUM4ZRMF61p43kyUvYgo+9DdekxH4xVGdtr7eTkW+fcPa+Tf5vqOAPBKVG4zvNiEKmR7OZoT1DOb8rvpjDoFD2Ix6q2uVOnu3FGuGRLZ769HQMlKsWt5x+DZIX0/tvKbQirUQ9dNnuFWWXCVkdXF0R4CGBHRoGcC0pgeDLNOftQfgJEr1OkEHm2BbubxzUs4SIdh4EHsXF04jcvtcZo2L8wERrD8WX0IzGJOGCgGNp5dgfSaS6pO7FhlY91XFOljjceclu3Z31C3n6PW+cDFBfnEram+rlK7kMsI0NAa6mCITFUgRrzHkH0lIrusVVaIN7zXXlqA2bjanbset6vZnJ7bdTiBhXB/3IvKXMYdaM130+VxP9wn88HDLaR1Q9wk7jocSe4t2t8Ne2tIRObYxfjdvMlkRc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Redis-memtier results

Test system details
-------------------
3 node AMD Zen5 system with 2 regular NUMA nodes (0, 1) and a CXL node (2)

$ numactl -H
available: 3 nodes (0-2)
node 0 cpus: 0-95,192-287
node 0 size: 128460 MB
node 1 cpus: 96-191,288-383
node 1 size: 128893 MB
node 2 cpus:
node 2 size: 257993 MB
node distances:
node   0   1   2
  0:  10  32  50
  1:  32  10  60
  2:  255  255  10

Hotness sources
---------------
NUMAB0 - Without NUMA Balancing in base case and with no source enabled
         in the patched case. No migrations occur.
NUMAB2 - Existing hot page promotion for the base case and
         use of hint faults as source in the patched case.

Pghot by default promotes after two accesses but for NUMAB2 source,
promotion is done after one access to match the base behaviour.
(/sys/kernel/debug/pghot/freq_threshold=1)

==============================================================
Scenario 1 - Enough memory in toptier and hence only promotion
==============================================================
In the setup phase, 64GB database is provisioned and explicitly moved
to Node 2 by migrating redis-server's memory to Node 2.
Memtier is run on Node 1.

Parallel distribution, 50% of the keys accessed, each 4 times.
16        Threads
100       Connections per thread
77808     Requests per client

==================================================================================================
Type         Ops/sec    Avg. Latency     p50 Latency     p99 Latency   p99.9
Latency       KB/sec
--------------------------------------------------------------------------------------------------
Base, NUMAB0
Totals     226611.42       225.92873       224.25500       423.93500
454.65500    514886.68
--------------------------------------------------------------------------------------------------
Base, NUMAB2
Totals     257211.48       204.99755       216.06300       370.68700
454.65500    584413.47
--------------------------------------------------------------------------------------------------
pghot-default, NUMAB2
Totals     255631.78       209.20335       216.06300       378.87900
450.55900    580824.22
--------------------------------------------------------------------------------------------------
pghot-precise, NUMAB2
Totals     249494.46       209.31820       212.99100       380.92700
448.51100    566879.53
==================================================================================================

pgpromote_success
==================================
Base, NUMAB0            0
Base, NUMAB2            10,435,176
pghot-default, NUMAB2   10,435,235
pghot-precise, NUMAB2   10,435,294
==================================

- There is a clear benefit of hot page promotion seen. Both
  base and pghot show similar benefits.
- The number of pages promoted in both cases are more or less
  same.

==============================================================
Scenario 2 - Toptier memory overcommited, promotion + demotion
==============================================================
In the setup phase, 192GB database is provisioned. The database occupies
Node 1 entirely(~128GB) and spills over to Node 2 (~64GB).
Memtier is run on Node 1.

Parallel distribution, 50% of the keys accessed, each 4 times.
16        Threads
100       Connections per thread
233424    Requests per client

==================================================================================================
Type         Ops/sec    Avg. Latency     p50 Latency     p99 Latency   p99.9
Latency       KB/sec
--------------------------------------------------------------------------------------------------
Base, NUMAB0
Totals     237743.40       217.72842       201.72700       395.26300
440.31900    540389.78
--------------------------------------------------------------------------------------------------
Base, NUMAB2
Totals     235935.72       219.36544       210.94300       411.64700
477.18300    536280.93
--------------------------------------------------------------------------------------------------
pghot-default, NUMAB2
Totals     248283.99       219.74875       211.96700       413.69500
509.95100    564348.49
--------------------------------------------------------------------------------------------------
pghot-precise, NUMAB2
Totals     240529.35       222.11878       215.03900       411.64700
464.89500    546722.22
==================================================================================================
                        pgpromote_success       pgdemote_kswapd
===============================================================
Base, NUMAB0            0                       672,591
Base, NUMAB2            350,632                 689,751
pghot-default, NUMAB2   17,118,987              17,421,474
pghot-precise, NUMAB2   24,030,292              24,342,569
===============================================================

- No clear benefit is seen with hot page promotion both in base and pghot case.
- Most promotion attempts in base case fail because the NUMA hint fault latency
  is found to exceed the threshold value (default threshold of 1000ms) in
  majority of the promotion attempts.
- Unlike base NUMAB2 where the hint fault latency is the difference between the
  PTE update time (during scanning) and the access time (hint fault), pghot uses
  a single latency threshold (3000ms in pghot-default and 5000ms in
  pghot-precise) for two purposes.
        1. If the time difference between successive accesses are within the
           threshold, the page is marked as hot.
        2. Later when kmigrated picks up the page for migration, it will migrate
           only if the difference between the current time and the time when the
          page was marked hot is with the threshold.
  Because of the above difference in behaviour, more number of pages get
  qualified for promotion compared to base NUMAB2.


