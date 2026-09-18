Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C688C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 04:15:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 625E96B0092; Fri, 18 Sep 2026 00:15:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D83E6B0095; Fri, 18 Sep 2026 00:15:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ED456B0096; Fri, 18 Sep 2026 00:15:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 269A06B0092
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 00:15:35 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8D5CE405A3
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 04:15:34 +0000 (UTC)
X-FDA: 85225568988.22.F723F78
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011038.outbound.protection.outlook.com [40.93.194.38])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5C8B940004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 04:15:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=0rUOpuIF;
	spf=pass (imf11.hostedemail.com: domain of bharata@amd.com designates 40.93.194.38 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789704931;
	b=l9hzqKJMtFy4y2kEIS21tmyFVvhFWmp/k1nLuIJ4g9YtD+2AHhTGDDHxUqnnqnKWM77Tkm
	Ej1YEA/eE1TO2hP3npo83zeTN/4ehettig+qp3dYFiuVexsVChWw1cF1OxANkvRkkvVoFJ
	wuBFpw4LcC9XbCPA2IQZkg0df21QFOc=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=0rUOpuIF;
	spf=pass (imf11.hostedemail.com: domain of bharata@amd.com designates 40.93.194.38 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789704931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cGzSJvfzwe5+nkB/WrNnRuX57PjsDokXUYQ8Vj9joxY=;
	b=lV7Zs2ojc9HlLdtT6KviojdcKunhhBHeL8TjEvFMcunJXaM7TUJUfq57kQGjPsXyJoMo9x
	Ve51pOooLe0DzTNIsPGNKEu77jZNwF3PrQiUWuB3f4wTrOwUeCLYIiMzUoQJf4PWrOrqdY
	gQ7sIMY7C3EXpKKdAFiBYpQ2P/+2EXA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DKGFKtgX/oNb0PNFAKuNX7CB9C0IkDv4xCBTLfdi5kfRM6Y0TvZ7Uv4sxdgsK2dDvkWH9eov/nTZp0YAYCbTZZzOuqhg7L6BoqCaAHZHy6FwreMrkyTPXSMIGi0Ct/gsR5kWfWiP5mk7UlG9a9vvYVgEkhPLux8YZKQqWC8Gp7nYwD+SmlbGdUKhN3DG0TaDI9l7Nm3kgloTBzjgOdmNPkdv/pSNHC2l7tKxzLzXzg7w071ofKV1uZNICkOvKUVqfrSDx94oFnEYmXpWc6VGAP/3NHrn71iKOm/ySll4fS0lj3uIk8pw9Am93zsNttU6qT8qwi3Dp5P31489c6/YsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cGzSJvfzwe5+nkB/WrNnRuX57PjsDokXUYQ8Vj9joxY=;
 b=JfQ3QAi8qaUJGQrzH19zSEi0I2yqtuiXyrUZ5UsyMa+zBTqLy5mjdwY0dCtrMQKP1IW+glLWPa/AkH93w7L0B3yttgo/GIIvqX+3dI/Wf5sSzd3kGggNXo7AvLN+Y06QCkrRZ+2hqb3/+VGaLFLEBqCU2Udag90WM90k3sq2x6DA2A5gkE04SM0Q+UuIT6G1MaZI1V5s3t5ErKPwOcRcGKBRX4AdsUdgBHkYKut55k0Oc++M6Ov4xiPd8UpWElCnVxQWzklj1enF52wyyjzYpDL5FMBV/TpTm+bPEJCdp5bJggCwTT6fn5tbZOpsJUCzMw1ufhpPudWxaIKu2VcVRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=infradead.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cGzSJvfzwe5+nkB/WrNnRuX57PjsDokXUYQ8Vj9joxY=;
 b=0rUOpuIFLNtvXswgYSW1J0jbHf6/YTffe5UwrDcUlzslpthLNhcGvW/WBxaX3XS50jObxr1qpb+efvTZ3iYcniTeSkGtxV60J1taJFvwjX6DWPgyTAhbWnMsdgkWpUci+07BN7nUWJNZrwMkmadkaODypgHe4xnP3Mfn+LsiFUU=
Received: from BL1PR13CA0177.namprd13.prod.outlook.com (2603:10b6:208:2bd::32)
 by PH7PR12MB5925.namprd12.prod.outlook.com (2603:10b6:510:1d8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Fri, 18 Sep
 2026 04:15:20 +0000
Received: from BN2PEPF000044A6.namprd04.prod.outlook.com
 (2603:10b6:208:2bd:cafe::6e) by BL1PR13CA0177.outlook.office365.com
 (2603:10b6:208:2bd::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.11 via Frontend Transport; Fri,
 18 Sep 2026 04:15:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF000044A6.mail.protection.outlook.com (10.167.243.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Fri, 18 Sep 2026 04:15:19 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 17 Sep
 2026 23:15:09 -0500
From: Bharata B Rao <bharata@amd.com>
To: <peterz@infradead.org>
CC: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <baohua@kernel.org>,
	<baolin.wang@linux.alibaba.com>, <bsegall@google.com>, <byungchul@sk.com>,
	<david@kernel.org>, <dev.jain@arm.com>, <dietmar.eggemann@arm.com>,
	<gourry@gourry.net>, <hannes@cmpxchg.org>, <jannh@google.com>,
	<joshua.hahnjy@gmail.com>, <juri.lelli@redhat.com>, <kas@kernel.org>,
	<kernel-team@meta.com>, <kprateek.nayak@amd.com>, <lance.yang@linux.dev>,
	<liam@infradead.org>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<ljs@kernel.org>, <matthew.brost@intel.com>, <mgorman@suse.de>,
	<mhocko@suse.com>, <mingo@redhat.com>, <nico.pache@linux.dev>,
	<osalvador@suse.de>, <pfalcato@suse.de>, <raghavendra.kt@amd.com>,
	<rakie.kim@sk.com>, <rostedt@goodmis.org>, <rppt@kernel.org>,
	<ryan.roberts@arm.com>, <stable@vger.kernel.org>, <surenb@google.com>,
	<usama.arif@linux.dev>, <vbabka@kernel.org>, <vincent.guittot@linaro.org>,
	<vschneid@redhat.com>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>
Subject: Re: [PATCH v2 2/4] mm: allow shared folios to be promoted to a fast tier
Date: Fri, 18 Sep 2026 09:44:52 +0530
Message-ID: <20260918041452.270875-1-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260917162324.GP4121339@noisy.programming.kicks-ass.net>
References: <20260917162324.GP4121339@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A6:EE_|PH7PR12MB5925:EE_
X-MS-Office365-Filtering-Correlation-Id: 9eb6e5d5-db54-4b8b-dda8-08df153b7391
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|23010399003|36860700016|22082099003|18002099003|13003099007|56012099006|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	HeZbWRI0GI31+ZcLR+ekhEifAhVPHw5Qjfpr+nk/adra3Y+Nbha7tczFDkBxQJXVd6L1eFf24RvYwHonTGT/NQnEHX27/opEHZlFpMwxvfLlgzOC0IWaSrA5vzycDqXOuKVVuB2tP22h6BP+YTxZJ9GZ02IT3mGx7/BPfUc908OGUw/FOheSsha/0EcWZWk3W8IVgBEsEHMNXyyapcCdMjt3FxWeaB0DXmpRJLFbZPnaQ12+0rPy1/SnRfgaWZM8xy8WUjYed9MNEMuQOjrk3h0QGikEQ5eCGU6PmfxyR4dOx5N2ven/5l2jmKAQcPPDPmnPV2MYtVoswaLbw7W5RJAtjX8jGHftE7egu2baFt34wXFy0YbJ/mqhUZz+A5lxkYEYWZqSEP5YQldsKLWUmISpG6ZmJIqaicF22Hw4sDKwwiRwNX3aYfSseWA1AxRl8dlKImelYEBXTylsa6wdIwmuLFwml+belwL/A7fbkI21AouH5mPLKTe/0HqdK4tdzRXGnTEAxhuKqvHTN4bKP6bQTEAnVRfQgEDfW31g1SCD6tjel4nriJWrhfKREp6d4AKd20wloTxfQE7AkhziFWPoTCaNH8QWdadPGght9MnUNFNZs7Ww7pbGPNYDwWnt+44gi9glo2wHklnqKb82FtVRODXWJvvQ7SB904Tzcu+G54FQYYGS7DKLJCsFB8EO7Wxcd1y19rGUEEDIiSdPqg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(23010399003)(36860700016)(22082099003)(18002099003)(13003099007)(56012099006)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	spi5ID4qRKeyi6Jd+ztRUBL3zSXwvifp+mZH5gf7ipwBUP22AQln5gQpzc+cjtsgjjls6yyY4LctMEhb4iRV2nxeTr3SvP3sqcaHXh24ZPtQTz+g3y5kWeOYliooMXvmzA2QD5PDfOdPaXlj81BvDo7/Or/W4vxu6u6VYSOfeYhTDogEXwYCAhuVVPRKpZRT7XSsLt+9wkL7O455MScSM4Fxy/efNZD6CpIHV+vhcb6tz6tuCYqefgJDTyVlbxH4BdXVbHQoqVA4v2ZAQ+BKhi09HfbZPYZLoLse6qwtLVPAtelAANsdZszXYlxspmBdd8gGuzPycrurXjd34bpMK7ozXDIhENhSh/gCInO2qhIoRG2jMfxU5KgsM3+R4IQ+ntYOKyRbqsv9tqezosOqrGHI0yzWgz5UCUfpbEwPWzG4wSl1iRG9gRnchkTvOWrr
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 04:15:19.5636
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eb6e5d5-db54-4b8b-dda8-08df153b7391
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A6.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5925
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5C8B940004
X-Stat-Signature: apjnhqp5zifx71w37dsturo6jobg1xfb
X-HE-Tag: 1789704931-738054
X-HE-Meta: U2FsdGVkX1+nSpDjTgeSOoVDC9peg026nBPXQP4Hmp8dpUxu4CloJL8+u5+yBqKzuJ1NGOGZSQOpdBxH7+gcClTsgICOtpX/LkhtZiezii7fHM9lhhYwmJIqCWa8zothDlmtJ9eMNa5U5uzfWR+8HP3JpJQe6Onvst5FPEtm27reisXdnNyH4VJndD+iYXo2rUDRk2KNDQq5SSznLhkAXN9H0109f3zAJp8lfjHmm3aQx8eWM7E9ViHy6iGL/JVo1N9xPQJnzVYQCoIaw7JZGdbW2JUgn2AJY5ecUJ/A4dOHu/6/65IYS/0VRXfD0RZGmkVEWTnzc31W4QJc0UbO1z5U4p6cgHJurweU5EUrEwnHzgmgue858CTQhQRtZuE1Ekv4j39tNpdQO6lz8KsYdAF8oT0sx2m026x2ck1MslM6IrNJlmpt4vshiqnINNawivSCCUgt+Fe2A3zY65mu/3qUEjLt9eZ/vsDTCzoN1InAaJQw2pML0jBtg/86UEoInwjJZyJkXZkO8QQP9BPK7O94SpKGy7mdC15fgbVSBkGHKMnhVnSU+xg9iqBR6h/1qRdmLiIo/YgBvlJdE/ABCT0q14JwvpjRiV+N+fa9btO2pABzd1+gOQXZxj2+GY3AEqRxA10tCElEPknv6MOqr9Q0hLK2vhQ3ozmuvW/B1zfjqFCVDarp6f2zfF0ChBRfl+5LpQ302+/8HBxPh/u3k8rGEEhS3cbnyIR5ybji43tF1VNfHH8ukabsRnLqnZQLb3oORssXkrDsKb6B+pH0id46EzBe7/h+YUb4/SJNZHLaitGXzJs59P2x3ndfbIdhpAlh/y/qlwKAezrJ00a4uFhbRhh7tOYQVhyXknq4ccv/eFstyujFnrL8+o1cQ3LDgIrit6+x0LzH9fHTxDXFhu3lR9AS2JI0+e8DVLLftfm3QiLeDyDKfz35Oz5adH9eZ/DnKAlEOzq1iFiPRCr
 XdOLiwsD
 sIMEUeQmLWpGZah7FFiHEIsIj4q50Me8f6pGUvcAcKxiiK6Ef1byU+ble1+p1t3PdbdrkoMJQ35ZGo9ouaGDf17w9mm7vmrrrBAnymlyiC27oCylsBqu3/KIBV5rspXMveywhKnlwV4U5cW89dR4x7PH0gcAkH4C3VVgBcqs6ogyBfQbGViUpeBapSjEThnG5DcHtb2STEvKOkzGjS0S451SNbRixtP9Xj9XQ+8ge8yVSZBLJoaCAigoWhOeS5U0PO6IDiZ9APrf8lXoIm0h+rQhPldzOzu30Vx5clYXCiDXmwYuGLHE/Uh2IQqUS0Vei1jXSLek9hydxCpMygEq/GDSu7+R1/8argpjKQ648WZQ862ZjsG7H4Usj2fFeN8lVFhKVQ7hqoQ5QHxfjPEDMUOO992d2yS30ROLN1lN+9KyKrEJGbPC4NQlFpRqSNfGmCizckhJNzS4fk6402/BzQLPqtHnHHm27lXWYEnUkFWwaCNLUlieaGON/tpCZXkRy+VbjblW63Bc1UCurY8lOCAGhqpJ3e5dFwoe6Pud/m8IATIw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Thu, Sep 17, 2026 at 12:18:24PM -0400, Gregory Price wrote:
> > On Thu, Sep 17, 2026 at 06:08:27PM +0200, Peter Zijlstra wrote:
> > 
> > Honestly I'm starting to think hint faults are a big hammer making up
> > for the lack of hardware support for getting this data.
> > 
> > Would be nice to just have the hardware report what's hot (and how hot)
> > rather than depending on a software-heuristic like deriving hotness
> > from a page fault.
> 
> Yeah, there is/was this patch-set from AMD that uses their IBS counters
> for this, but 'ab'-using the performance counters for this also has ick.
> PMU data isn't ideal either. Mostly they generate a ton of data that
> needs to be analyzed as well. Its not clear cut and easy.

Here are my experiments with using IBS for memory access profiling:

1. My very early attempt was to replace NUMA hint faults with IBS
provided memory access information to drive NUMA Balancing. This
worked for all the modes of NUMA Balancing (kernel.numa_balancing=1
or 2) [1]

2. The next attempt was to use IBS data to drive only hot page promotion.
In this approach, IBS was used as one of the sources of page hotness
information to pghot (existing NUMA hintfaults being the other) [2]

Both the above approaches used the primary IBS instance that was being
used by perf sub-system also and I had made the use mutually exclusive.

> 
> I'm not sure there's been proposals for better hardware support.

Then AMD Zen6 processors introduced a 2nd light-weight IBS instance
called IBS Memory Profiler which is separate, works independently
of the primary IBS instance (which continues to be used by perf)
and which is primarily targeted for memory access profiling.

I have used this as source of page hotness with pghot (pghot-hwhints)
and the benchmark results are encouraging. [3]

Also it is worth reiterating here that neither primary IBS nor this
new IBS Memory Profiler have got anything to do with PMU sub-system.

In this context, I would also like to point out that pghot patchset [4]
is trying to move hot page promotion from scheduler to its own dedicated
sub-system. I have done the following till now:

- Extracted out hot page promotion engine and moved it to pghot
  so that the same gets used for other sources of page hotness.
- Moved fault-time migration to async and batched kernel-thread driven
  migration (kmigrated)
- Used NUMA hint faults as page hotness source to pghot (pghot-hintfaults)

I have often wondered if it makes sense to move out complete hint faulting
mechanism out of scheduler but then I see that task-follows-memory part,
the scanning logic, fault stats heuristics are tightly tied to the scheduler.

Also apt is to remember the PTE-A bit scanning approach [5] that was started
as a potential replacement to NUMA hint faults based scanning. We are
planning to revive that effort and make it as another source for pghot
if we get good results with different benchmarks.

Regards,
Bharata.

[1] Primary IBS instance driving NUMA Balancing
    https://lore.kernel.org/lkml/20230208073533.715-1-bharata@amd.com/
[2] The last pghot version (v5)  which used primary IBS instance as page hotness source
    https://lore.kernel.org/linux-mm/20260129144043.231636-1-bharata@amd.com/
[3] IBS Memory Profiler as page hotness source for pghot
    https://lore.kernel.org/linux-mm/92c26cce-0608-4c0d-bb13-fe87afc225ba@amd.com/T/#m6d17d0d58a5026c16d63c34e1abfd67a57a66256
[4] The last posted pghot (v8) patchset
    https://lore.kernel.org/linux-mm/20260728054356.291998-1-bharata@amd.com/
[5] Kscand - PTE A bit based scanning
    https://lore.kernel.org/linux-mm/20250814153307.1553061-1-raghavendra.kt@amd.com/

