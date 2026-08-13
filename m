Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDF17C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 09:25:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 048FF6B024B; Thu, 13 Aug 2026 05:25:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3C4F6B0251; Thu, 13 Aug 2026 05:25:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E03E66B0253; Thu, 13 Aug 2026 05:25:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9EA4D6B024B
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:25:22 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 264ED1C07F6
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:25:22 +0000 (UTC)
X-FDA: 85095712884.25.985A7C6
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013006.outbound.protection.outlook.com [40.107.201.6])
	by imf29.hostedemail.com (Postfix) with ESMTP id F20E5120004
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:25:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=yddYWpJE;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of nikunj.dadhania@amd.com designates 40.107.201.6 as permitted sender) smtp.mailfrom=nikunj.dadhania@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786613119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0VtfE/EzHGMMaXxfquFSlZ5GT8zZhkbySdBJ/E4OflE=;
	b=wnOzTwPW20D4icSy6iM5tUJh4PvvofhX4dcFuIkdLd5+M9cKknwkrc4AsL1/2RwIO+1gG2
	vvJjcYoynjvR2hCYB1JrszTr62IL1crAEujMqc4Y0px09w0yINsosI/RK2C78gfCwCr8jw
	P+eyhCiNSPPtVFbtcZuA0jYnyU92qXs=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=yddYWpJE;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of nikunj.dadhania@amd.com designates 40.107.201.6 as permitted sender) smtp.mailfrom=nikunj.dadhania@amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786613119;
	b=yjy7zbrESvFzpsrse3NrdfXe1VTKcTWXXxehUQ+6u/uO1iW54/RJyiehbo+9cJVxBzyAhz
	mF7V545+xsVLxIh5u1COgRaZsRE2fEgzbqq7qTreAoHkQbyX5mocwZko9y8yS4VL3tJRdq
	eHKjV9bqwEjYOz+zrqYBhtpOTMSz8mM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A3Sq2mlF2EkascNZqKoH7qLJId9qcqiWmg09XZc58+Qs45v+8lC2O5sxqRR2Exzu9h0Hdn0wcrnMEf//mGEVKMysPoKObqxReP3JTWU1jTbJ2Xbvh4vpM4vB7otWbazRP3vv77/LDrxO5pxKeOLyvAfXe5oCblnZGIxORE7la6jv81BleMbLsaNXmLWdcBlRsUHPN5PDL/u592peyp2MW68OHo0//onUtdAOmngKRjachz4iolfXEIr18sRwa6Ekm7b1crxt3ZRyn/FmXrd6B72Vc4cj/hvYAckm/JKmLKTyupNoXmpQcuIdUCOTcaUCMKy7Re7pmpla1qDW1QyIQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0VtfE/EzHGMMaXxfquFSlZ5GT8zZhkbySdBJ/E4OflE=;
 b=g1fm9Ww01XfPgiPueD7ilyoxiZBhrzhV9FYcZIOr18M2blRbciCUEXQrJJ0ZgjP3dR2pQ7zxo+1XGwh3O9OMl4/7Y30ey3t8b2OuVs0X4L3nJLn5Gxh8zTJ7Q5e8PmT1pR0ln1Awcek47juTD2vndPXGcqmH5Bde5g9KfWhHbELyHPAHkO6pT0ZEIxy2+OlVgZP02JYyqzSAhXWWIwy1OIlzhY8wDUk1PvlzQo86bJrvVsqjTp2UIqeL7WVWr4uhLVz3TxGi49mpwBjE2K5SD/Da59pIghtOSrVE41XDJ1qAq7Whmdo7SYy52/n+ZQSLAORdzc6xezHlbOHyagX4Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0VtfE/EzHGMMaXxfquFSlZ5GT8zZhkbySdBJ/E4OflE=;
 b=yddYWpJEdd0d73Q2vMBfXWo6Wf4b7gQZHBhWYv9XAeKBHy0DC2QueuZJAr6gfULj9ecuj8pIurhYp3Iihl/ZPaASfqd4wxarSR5B1BZO6kclTQMneEg+6eokWerPgcbEQRTxfJ7WgNo7iZ3nGJuDYtn037JUnDs+45jPOcPdCMQ=
Received: from CH0P221CA0017.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:11c::26)
 by CH8PR12MB9789.namprd12.prod.outlook.com (2603:10b6:610:260::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.15; Thu, 13 Aug
 2026 09:25:12 +0000
Received: from CH1PEPF0000A349.namprd04.prod.outlook.com
 (2603:10b6:610:11c:cafe::4) by CH0P221CA0017.outlook.office365.com
 (2603:10b6:610:11c::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.15 via Frontend Transport; Thu,
 13 Aug 2026 09:25:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CH1PEPF0000A349.mail.protection.outlook.com (10.167.244.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.3 via Frontend Transport; Thu, 13 Aug 2026 09:25:12 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 13 Aug
 2026 04:25:09 -0500
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 13 Aug
 2026 04:25:09 -0500
Received: from [10.252.195.98] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.45 via Frontend
 Transport; Thu, 13 Aug 2026 04:25:00 -0500
Message-ID: <b78d6e7c-b754-4872-9dce-793796a03296@amd.com>
Date: Thu, 13 Aug 2026 14:54:58 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] x86/mm/pat: CPA fixes
To: Mike Rapoport <rppt@kernel.org>
CC: <ljs@kernel.org>, <akpm@linux-foundation.org>, <baolu.lu@linux.intel.com>,
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>,
	<den@openvz.org>, <devnexen@gmail.com>, <hpa@zytor.com>,
	<iommu@lists.linux.dev>, <jgg@ziepe.ca>, <jgross@suse.com>,
	<jirislaby@kernel.org>, <kas@kernel.org>, <kevin.tian@intel.com>,
	<liam@infradead.org>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<lists@steffen.cc>, <luto@kernel.org>, <mingo@redhat.com>,
	<peterz@infradead.org>, <pfalcato@suse.de>, <shakeel.butt@linux.dev>,
	<stable@vger.kernel.org>, <surenb@google.com>,
	<syzbot@syzkaller.appspotmail.com>, <tglx@kernel.org>, <toshi.kani@hpe.com>,
	<vbabka@kernel.org>, <vishal.moola@gmail.com>, <will@kernel.org>,
	<x86@kernel.org>, <bharata@amd.com>, <Ananth.Narayan@amd.com>
References: <anXvODEvV4f_Taj7@lucifer> <20260813055544.25567-1-nikunj@amd.com>
 <an2FdPPOWT50lLD4@kernel.org>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <an2FdPPOWT50lLD4@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A349:EE_|CH8PR12MB9789:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e33a5fe-d820-474d-ba81-08def91cc6d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|23010399003|376014|36860700016|1800799024|6133799003|18002099003|22082099003|4143699003|11063799006|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	jWq4uxQfVB5n1mgdRXgs2f5bN5bu+iW7LV1UZ8pB/6LF29a276bW4QT+OWzkbpRL1hENVJmlsdD/NFeuaIK+fvpc8bi7y+zo0XjXLAy3CWo/P+KhRDxTMce/X4B0RSNcdgTYEf+AiJeDzNesc/uATSTXtmHftNdW2FElMjteDFZuo1m76EVCX2rmTf4HCLUx9WhWMzJ+vtbHrM8xajEutJ48O4yIW2M7GEIgfwSKHbbD/beQ7ZjsA4ARpBGpU9zWzMRZktePfIdHG8mLgQm+mpKzyUSo8zF5yK8pa65qj7w/hDYnhIgFnbPhWW/Zt3HoMNMEv62M08tEc3MpbaB3N97EAvdhkLh6Ove+DqTbaAVF5kQjeoTjjGBNER/rtfW9wCF5hOL9hnxje87IFL3EmftTPm14wV68TUYRFOzsyo/yevNXrPsSiHCLw3oGIIs/Zj8W3CH3OuaTBvW4mHC2GDUWjUONhFzTcdAChoyJc2q2jKpPgKkJJRfPkhXpU/NJEwUl1BvvN7f3SDpkhU28o16E72RkHA4sGfBgPqjKTFYxwGsy3OOxREhH+0QsGVM5QN7X0f1b8aw5GIKUdw62AXe1ujEgfvAS9cCKYAGVZpgwnsrLwzetUPIps4nY/KANl37hHViK7tGPLcY1CN7xiypt8fQtvjCi0mSbzV1K+MCm7T3TMQ6MWP6tqlA8sNmt0zuK+9TL/u4e6veG2dM6TQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(23010399003)(376014)(36860700016)(1800799024)(6133799003)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	8WbSG0nf6DCeGDWZ45JvMdB+2JsNGMyIpVhA/oshoGTw1OCF0NdCum29uQB3obw6Oi9aLcuabykt4Y+s5UCBoBo+cU1Y7/5S0muN8aJstVfEig945R6AoXDiVBDqgE9tJDfo4FNerEh92J2OsiIo9y2JKgg8XQ+qA0AavP2Kbz0uJ7MFBzC6vDGokDubxBkkEBSJpBUfw9MmST+a9Lm/+V4SZrlCvV7uQXhEd2YgJrh0hYlbX4upFi7aty6xo95tc3hRhHTXJ+txPZavV/vNU5V4ZkUNSkXvs3nFANNE6kHnTT2aeHM4DdmwjIzOuEUFVz/5smrFEWfofMXpPhFrRKKKNghHAFnfIhn3hx41tP+sB4xSmqfygVb37goTYYJQFpIv3IorHBd7s/ecsk9LgU9eTdQZfC2Y1zGe+/DjCV8z6EPsL+NMGQ0vJTPYuqRz
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2026 09:25:12.2837
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e33a5fe-d820-474d-ba81-08def91cc6d4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A349.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR12MB9789
X-Rspamd-Queue-Id: F20E5120004
X-Stat-Signature: 9ycge7xrkked6nyr3oquu43abspc66un
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786613118-914506
X-HE-Meta: U2FsdGVkX1/XNAii40N6VsbiTEoBcNpeGyZDG36uymFGc5/7MNsF88E5Gnv9AXypbxRkAaQoIhBc36wnQhzm/XPj7iiCODYMqG6vAcpjnIWGNSdhUv87abe3t9mHECa5Vc0MgeAkdNlNZoO+cUxtw+WZfuixBKbeUO3hB+1/qgtt52JzkueLxf7n7PeipD5pU6co0UlKEk2LXkWH3XqUlfpEYyugMOo755wBE18DfyN7RjqX7QJMt0/hBuUAzERVeXO/CUHh854hQEQnFx6N6BHnOmEE7Y91NTkUc7Te3EdX8Jgm7rfreCMWaeMV+v/ITm3TR+PeWZJ0Q9GqyI+gb2SXcYXG6/VSwygbR7OecY8hyi29g9qzd5AP6Kc7XhEFSuL543mRZVFa7o6HtCeW1rVQ32T66KkmchKWaECCmJxTuHgO25Cq8gruTIbzIH5UvQc9wB16cNNJb2uSXb9ZvKhr0mu8ojhWY1Vqmxw81B/Bz9GnDqw8kVoM8WstR1J607dseW4TaxgQFsZKSgTNCAJKOz9UtD1UYtZ5yPJGLMv6zmRsiu0lGQnHXQPnEBs0UZSPSZpe7FmbVvLkd9n3//pZ0GmAaQvjMTsuHeOqiKt0DIit74EOuwZb4o1eAd4abtQosUkmX6ar6YwRcFgkBgb6+SuXvJ4Vyycq1tjKfNdLsqKxZWobDeQr7G9U6HLSAvr159vgx8sp8dK1UdOkpNFf21aR0MCCA7E5h+bZuJCLGF2BnjfhHBoXpiIG9CYwrKtEC4NjUHidVzCcFWIGEOipEpOTGhNq+JXq7Hl6efBrxwZy+7jY4hlAu8b7dHPOHg3KjDEX3Lj6SL1oo4QxR287sM5fcBPbt6DQUYL7T2uz1cB3aCZntvUYhffohQ3lKnS5n0H556XH0s/09JUOtzG38bI6/xEC/O2yvdtVkI85Vlz9NVYBVxyYPzTR1vPJXD0w/SAM4lDrwkj6ZAx
 JKL2rhC0
 eYeH8vPkKmrOnbtnxSoZbChZlhVPipcMT+J8r32kUXIbfu2U+tzksS9s0qic2QSIHBM+F/P7uTML4T1k/sYeIMmdCLTCPrPWujReA7j5Syhr8ilAG7/VcmLnUxu15eS0775IQB7G2dqnVYGNy6kFIJen0m/9tbshWHbJ1he0qb55rtoNKnz4JKlxr51UsE4i0kpruhjH4Y12bJgVI8zx6NIDZQBW5/Q8FJXYUdQqzcnxp86gqKJ44INcm0UgaOkbLhaaUxmvnGylT89OBYpz/W2posCjkIj5LEJY7ESBl7G8zZOtRtf8UGrQNWT8Q68TsI7evTaBk2idX9GRasV6ocT9qKl4tY4CWXSsr+pJmv34vw86+tKMPpgsdKf6JFQNzgTM0q4o79NUCwXHlSf/HbVGKbXU12C3C2ywmBDHCULxkr4GL2+aGvlt3WFItkgQ1tQKDkHQGRa2gshU640PLdpuGldUiu8yijuSevEtnf380sr5ah0raxowTFHTrg2vAeXVv4S2UigAU00q/NwFJjNUZsas/puBng00POZws2sRTTTZ4Kif9qGofK3NLTaJ8mOMC21DU727u7mByfdc3oOPKJ4nFZO/pq8X9jsinxAJvVYJqJ1jPckkH7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/13/2026 2:21 PM, Mike Rapoport wrote:
> On Thu, Aug 13, 2026 at 05:55:44AM +0000, Nikunj A Dadhania wrote:
>> On Fri, Aug 07, 2026 at 04:36:08PM +0100, Lorenzo Stoakes (ARM) wrote:
>>> +static void poke_vmalloc_pages_safe(struct page **pages, void *addr,
>>> +				    bool cross_page_boundary)
>>> +{
>>> +	guard(mmap_read_lock)(&init_mm);
>>> +	poke_vmalloc_pages(pages, addr, cross_page_boundary);
>>> +}
>>
>> Tested just the proposed patch from this email (without the rest of the
>> CPA fixes series) on the 512-guest concurrent boot harness (details in
> 
> For this fix to actually fix anything, the patches that add locking of
> mmap_lock to CPA are needed still.

Noted. 

Noticed that you have posted a v2, will test the full series and
respond back with results.

Regards,
Nikunj

