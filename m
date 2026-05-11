Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB0E2CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 10:02:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FC2F6B00E0; Mon, 11 May 2026 06:02:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D3876B00E1; Mon, 11 May 2026 06:02:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E9EE6B00E2; Mon, 11 May 2026 06:02:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5FBC36B00E0
	for <linux-mm@kvack.org>; Mon, 11 May 2026 06:02:45 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0DE6F1A069B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:02:45 +0000 (UTC)
X-FDA: 84754699890.23.5AA7B14
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013064.outbound.protection.outlook.com [40.93.201.64])
	by imf02.hostedemail.com (Postfix) with ESMTP id DDA0480005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:02:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=c3hebmSs;
	spf=pass (imf02.hostedemail.com: domain of bharata@amd.com designates 40.93.201.64 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778493762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MAb97NaInBEHceeTLLlCu44GchnAU3poP4BJy+35MPk=;
	b=vX+gFvEjEWeDzOG6am2xTdU2HG3R+6WEvQjzgSOkuxmB+WYkv7DrgIwzU7+AW9K3idx6mc
	0P7+M/fqCT0P2/RpQefuhFJFPApJIqgkXSVK+iRGfUfbs70IRqMglGT7dasBxyYjzVMmjo
	kMQmMT0epe+ZjoX+kE8E97GFHTAoPcQ=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=c3hebmSs;
	spf=pass (imf02.hostedemail.com: domain of bharata@amd.com designates 40.93.201.64 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778493762; a=rsa-sha256;
	cv=pass;
	b=tUPtabiHtnYG0VOTZK9cuR2KZuViqBoxx/J/lhcceh3T5FH9Yb7yBUrG14fZIEmE/1Nzwv
	dlsNxnboBgqSPZFhd9Cqbo2haVoCgi4bLqHbJuVbwUq+fr7cEPZbVRToKPiyjSUFuix2/y
	G2u6H8N7zDT1mgyVBGyFjqFWu4TK3Gs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IKgZn+4EE8yRYBDev3c5RuraEmd7JzVq2k3P/5NZfXMMWspJgLZXNmIyZNGxbWFYKVlyCR+A+04H84sdm0/77CtFXKCX3rJ+dUPDLWU9FbNCjvaFkvzf2h5JccJJSOoPUjDwA/tT+qGO/1CGCogbtTz+6s+PVbnjdT+U+hR9GR6Vgz3TtGlzVcqJhkIi5zU4z1D78TznhTPn0cWEKqzQbpSqiAPdrg3SVXisrIRnD2S3X1Fi2tq/A/lTW3j7koWkrqKtt43o17wqrx8DxI6C9xWhil9WmKmgVPptILvQP4cW6AJlP/adJpWvAqotmDCfBOs1zMsGzg2JQXMBNWNh9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MAb97NaInBEHceeTLLlCu44GchnAU3poP4BJy+35MPk=;
 b=wFLc2aRSpAOAI7g3v7A4UL9DdU7wmZzHvQCrZFM9QjckGC/+kyuf3KC0M0FGDMxwvGdMSdrYXkj0TJN0YTvaQAI6Pu2qVkRGG5kYu3fBF9CmJSmPBgTYfi/JffPckWJKxAjwKlfK+ovql6tgeUSm12lOdotVwLtAFWhANA4I1h8yA9a9ZzAFrdFjPraZG+WAXHoCv49fbKGhF40uSjGG6UbtG0XUHgFuJXeVdZ7k8vfAFT9sKGpqFozXAsl99/B8O3Ikcm30hG7w6m+6muoCGeFKiyld6NOsrmoxxT+zTXqLkIXgvJszCY2o4xDUNf2UhzhP4LKd2DDvAECe338eDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gourry.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MAb97NaInBEHceeTLLlCu44GchnAU3poP4BJy+35MPk=;
 b=c3hebmSsr/VI+JLlTLhFw8Ma2LMRgxONj08CU5BlRve1u9QvjRPhCXaqAJsitcwLNGsLer1fCuD4qCc4V6DkYnUD/j/FWIyb4JvbClZg6Nvq7ej255BtFIBb8UhQsqeSQtFzxQ8Dx4DbCBy8aAoItOjDsTfi01YOgZfOCckL8k4=
Received: from BY3PR05CA0029.namprd05.prod.outlook.com (2603:10b6:a03:254::34)
 by SN7PR12MB7179.namprd12.prod.outlook.com (2603:10b6:806:2a7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.22; Mon, 11 May
 2026 10:02:36 +0000
Received: from CO1PEPF00012E7D.namprd03.prod.outlook.com
 (2603:10b6:a03:254:cafe::75) by BY3PR05CA0029.outlook.office365.com
 (2603:10b6:a03:254::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.25.15 via Frontend Transport; Mon, 11
 May 2026 10:02:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CO1PEPF00012E7D.mail.protection.outlook.com (10.167.249.52) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.13 via Frontend Transport; Mon, 11 May 2026 10:02:36 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 11 May
 2026 05:02:32 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 11 May
 2026 05:02:30 -0500
Received: from [10.143.204.127] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Mon, 11 May 2026 05:02:21 -0500
Message-ID: <c2b63544-d5da-4fc8-88cc-487de0a9a71e@amd.com>
Date: Mon, 11 May 2026 15:32:20 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/7] mm: Hot page tracking and promotion infrastructure
To: Gregory Price <gourry@gourry.net>, Matthew Wilcox <willy@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <peterz@infradead.org>,
	<raghavendra.kt@amd.com>, <riel@surriel.com>, <rientjes@google.com>,
	<sj@kernel.org>, <weixugc@google.com>, <ying.huang@linux.alibaba.com>,
	<ziy@nvidia.com>, <dave@stgolabs.net>, <nifan.cxl@gmail.com>,
	<xuezhengchu@huawei.com>, <yiannis@zptcorp.com>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <byungchul@sk.com>, <kinseyho@google.com>,
	<joshua.hahnjy@gmail.com>, <yuanchu@google.com>, <balbirs@nvidia.com>,
	<alok.rathore@samsung.com>, <shivankg@amd.com>, <donettom@linux.ibm.com>
References: <20260504060924.344313-1-bharata@amd.com>
 <afkDNR9yVRjire4T@casper.infradead.org>
 <aftcuvXzHSywFL8g@gourry-fedora-PF4VCD3F>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <aftcuvXzHSywFL8g@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00012E7D:EE_|SN7PR12MB7179:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e710ba1-1b34-4533-d6db-08deaf446d6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|36860700016|376014|82310400026|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	qAsIc3EzLLJ7qFAqFdfeB08LH299HDEfGTg7KxEUWujArGbryScsXR8W/UAqga00P/JDkxVkNse+c9t3lkb17WPWI/hREbTjyzqfsTETuYEqIEDqgfd+WXWoNY55THCHp2p0G6EGIiEVz3zD43u7IiZNarT6EOBYpi7mOelKnY6bjcK8G5N/B/Cy751AT8QUfYQ/JIGubLpWBtvVReLRu/kZIOeRYQBu4ySuwNNqpMYe2jQdCWPBAykOXV+/+zvnmrauVbv65ULEQQkWg2uHByHI8n2jObof9f5x8rqhGmt3YrO1wGW5jao9Heg/2/vXrscIlYT+qaPDE3nCzzMqYNqS986Bm0rHXGAIGv55MuIY7ZUJIvkaqw6pus/PYmlfQzKbW5LghXgv605VHTcQEwXKei9PBQtEM7gwPqn2clQH5x7E7tSSkh94BJihjE+nFSf5Rc5/dnIzG7OXViunpImSosJblXrOjkqaphgrAodaVi5wj/g1SCAzJ6EldxnS7AnrjqP3/hQaFxO/lRjvhZjCO10YA+2MUk+b4y/yOhRaVHiVJ/I1PTwj6qC1gegkNylBBEqFIebEgWcI5IjtsdRO8+JGfnjeuHILDRp6BIM81cfm8nRkpIyQUA+gUzST9P38VtjaNQO9qWOAwcp3+C8nOOmW7bC6IKI/OaYzZwar0Y2R7vrcy46n5r3X5VJaVLJxbwKODQxadv1QPJXCkwlm5chmaK+QLNor+mEhk50=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(36860700016)(376014)(82310400026)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	a1pR3JH/ZjDlwSGKDAbvI048nAdmdwKoVpIB5x9H/Sx5z0om1pDRiFsm2vXr2wkUuRd7k6PlNj1+00haVqeBDyInP8ZTsUl2R9wl1JHuolH0ZhZHUSQDG/xKyd2AxHb70h5ymTtWA5okK9eKFfBrUPDjPDS7udz6Bhh2rPhaoM9rj3KfB9KQH7gGoKXtG69gzThCwkSbhj9+wg20s1Zsnb68tuTLdobMPm9cCLqLi4phe/hNthonDIU3rVkPOh8+2LlGqDgGunr+IjCJJrgvrz8fiKcAD/jNe5K/rQsK3WGhkb7zXEtCLykYPQGVS9WLRTQ0yRWre2mYVo7mYWbk7vH4cwmAc0BOEVGC+238qQj4ZLgL81eFYYcTrJra+5RjgNksJ8VXI6/BYFmG5e50zrU6qmqGz3gvB86gfrkIRxbn01V4409SLNQiDdvQnT9v
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2026 10:02:36.0234
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e710ba1-1b34-4533-d6db-08deaf446d6a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00012E7D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7179
X-Stat-Signature: iordxk54dwicf59st3q485igezqqbfs3
X-Rspamd-Queue-Id: DDA0480005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778493761-239028
X-HE-Meta: U2FsdGVkX1/TVhN80SP3OJG7oT8XZ/6MEnYnq1knOEdYgJWz3SjcWvF7MA0pP5mAKDtygcPuQ+VdNdpPFpafzogrEDo7rOSoaMpVNwkdNFCVNgE6hqGNKGMa4nxx6oYOd2+0zMWNrCIS0eTswMbjliReADX59mbtlqW8fUBO64vpTzAvfQiNxtYfKQ9D7GF4Ev0Dd5t2yvn4b0E1NkTKJrNdF7Mn7/N4oonjC1omiXDXNF2x359b8JTXcIob3MAiibfD6o0LiJVt4NaIy/8xWtl77Z+pYkb4my/IZ9Gl56hS/Z7pNKsOE8kahAQA7YhJWY2/XEFHld8eN4v4kKNOi/OUfBBSiRj9gwoPzz5IRqRdr5niu3N4a10JHWgCye087L9G5m/4Zjwpw+IuLPBEXWwc+HSTIS9ckCOwKO7HKo6467eqHt/h4u48Jkqb9iqnrwVMzEYFPjpN4N5NQ6/oTy1uAay2b+MXiFOgEmoeKSxdCP+oWkCUv7IVfCFYjoB/AwVFXPoim8J4q5Or0Df0HkahBYEpMMM7FxSxxtiT6i4kZk8vxKj4geqCcRq+nW9Wg4LDzmu6xSwh5zRBPV+UYx/a/ub6nglHNlWYtdhh21mS5ioVf3QjSrn0n8oPwfdARt1hJe/CvGjgkWGQZaZB8aEnu/FMxvFeauXHmGanlC0h3Zd7U3JeTNJIqt0+2qeqWBvxwkxsLLtF3F6Zq6+7Hc5CAAlh/d7g0Wp+etLuvRFtshUsPTzmkwQUGx69fewS1NMLe98i2Fnja7+mSqgD8RIrWTUDtas8Q7nP4UuzyAhcmM3OWRytsbawxE3EHK4mb9s/plEvClFC4mGXZaH7sh8AYoYMIjT/dSMEoV3iqGNa/brMG+UPgnZ5TJGyM032BM6L7Nrb9buXIPuZMZd/aKptDjM0tk35OC6pX0CW9DXpZnVW+BlxM5aW0KU0YD6ZPboQ6xO1IiFp0wmH9eF
 AohL30Y1
 XObsi2iS0feTBcQQBSheLBJmSztPADbavIO6xrCHXGclm6J4ex99dNy5ER3MXSHpM2Kg+7RZfJ8xLsJ0DyKmam546pJEcjgNY1Im41BEp5dQkgtMZ2yawz/NFMVewpgZq5xe+SiqutkDlgcCSf6HFcImXU9HVuoJjQsw6HbejEcdeCA44ZlgdIyH2x66fAuPe6GPq71Ow15kSdWFloVbhDmbcByc0mPKm1Y43jtq/Z2Bq7/TFwyRBVY1vMOV6R96VdHdqhxU5ukX2AopVaHkK9kxr1OmS0DKywxhDTg97iW+IBphjI24WL+poJdbK9vOejLpXOAwHMJAuJG1cIz5QOHQGZkZ+1Z0zEs3RcvQUugV4hzCV7vKpCboTRG7xX28bLIOshzD7Q6a26ZjfnSKqNV5Gv7oLJvQR2HWW/7nOTYWd0AYXfO32996lNCnHExVFzxmY8tPQUGGxsdFpew23KHW/Dyk97DKzb5ASWubq65kdN/U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 06-May-26 8:52 PM, Gregory Price wrote:
> On Mon, May 04, 2026 at 09:36:05PM +0100, Matthew Wilcox wrote:
>> On Mon, May 04, 2026 at 11:39:17AM +0530, Bharata B Rao wrote:
>>> This is v7 of pghot, a hot-page tracking and promotion subsystem. The
>>
>> I continue to think we should not do this.
> 
> My only pushback on the general "we should not do this" is that we need
> something to counter-balance the demotion bit in vmscan.c, and the
> current implementation (prot_none faults) is rather :[

So you are saying pghot subsystem currently does hot page detection and
promotion only, which is fine. But the current implementation of demotion is not
very optimal and hence we should spend effort in fine-tuning demotion first?

In this series itself I have shown via benchmark numbers that for over-committed
cases (involving both demotion and promotion), the workload isn't really showing
real benefit due to demotion and promotion. Are you specifically referring to
this problem?

> 
> I think this series needs to greatly limit its complexity and provide
> some gentle correction for LRU inversions, and I think they're making a
> decent attempt at that.

Regarding complexity, I agree that the initial version of this patchset was
quite complicated in the way it maintained hot page information. But the later
versions including this one have greatly reduced the complexity with one byte of
hot page information per PFN, atomic updates to hotness data without any locks,
per-lowertier kmigrated threads for promotion and reuse of existing hot page
promotion engine.

Did you have anything else in mind wrt complexity?

Can you provide more context about the LRU inversion problem?

Regards,
Bharata.

