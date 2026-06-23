Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A81FCD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 08:48:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 436396B009B; Tue, 23 Jun 2026 04:48:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E6396B009D; Tue, 23 Jun 2026 04:48:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AFE06B009E; Tue, 23 Jun 2026 04:48:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 02F6B6B009B
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 04:48:12 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 791218DAB0
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:48:12 +0000 (UTC)
X-FDA: 84910550424.30.05AC432
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013035.outbound.protection.outlook.com [40.93.201.35])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4846E100007
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:48:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=a39RkI8u;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.35 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782204489;
	b=qJJ3/o62rY+GZq0dMdBUARIvCkZiDjUV1xWB9HDzyqMtFuwxbosIXi69lugFN9GSo/VKrN
	urAO4rPp9+rBLIkS8huLvvY1FHwx6TtvcNLWG9dKTFudaFQR7z97tAG2AAQc+4++cNC7eV
	+d8WNCwI0+Qv+q7q71U+Ev9A8YA4PGU=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782204489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zCLQCUkYurYdm4XyZWWZy6RReCyfyNeb02okR4nsRL8=;
	b=YyBAJ54HSYl28EUOv6ucmzbqkdGB1F7m923VgWbyVZLB8LHYV/mX8HtfI57uI4P973D5jl
	yiG8xKVkoFWdppVkGWBuoU5PpGps0hfrX6AYBzWcTSjZRu86bgugS0F/iRkbXGZUzPheWa
	KMqOWcauSsGa46vyKEMwT2p6roeyjMo=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=a39RkI8u;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.35 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IQeODtH6DUe+3bN1MYV1WbsTj+jswxRBnHRYJkxdP/JFCQOKPqcJRW8ymQhGsoFY/ZC50kCqF46JI4xAhchLC1NVx3mhD7v1JOSZ9TcaP90SjepCFahbgX/nrCAmhQOor5qHVASKFIOG9QakxbYEUKi7myPOn6IC/xiNYE3QkWiGzik3SBWCmquWhlav/DUB6gzuekUgEfBnXMoZ/h2XEEobU7E0DZHm2552td5CMI2dGo8spOXIAOjwk4yuaEe+4FaZB3PiAXTHWWLOKBytihCeRIJuKPrTefIiu4NIXXMfg1vm0RnCK5NuqDPaP7gxdhEWqnYdaGpSTwL/A4L8RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zCLQCUkYurYdm4XyZWWZy6RReCyfyNeb02okR4nsRL8=;
 b=wHSDwd+cdd/mtBjFgUEKNtzIQPVBLTonglXlbP6ehG7oGvZ2d4Lwu0jhkpwXoMPDrbOsOMbi9p/QrpEV8aoUKgPmBY50gscnQolrIdZ+TAotvszTn+4gmLoBv0YoK84cv1a0zbtva7cd1Nrics7FwzaKMp9b/jp0IUF4cMKwyYM2royOQBM2t1VM2SSe+orb3XU5Uv7YOlVTQeC76hC50pD0QJH+nDge5o1yp8Ro0UbwUy+021ZTPy/Wp9CnpNXDvBqU+/0OZmAupvUzkEGE+dhm/ajIHrTUmhYvxqs0MhruewGy3ULmzLgBZq6SFo9d4rS6pDSqtZyWGuRwLqZF1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zCLQCUkYurYdm4XyZWWZy6RReCyfyNeb02okR4nsRL8=;
 b=a39RkI8u+9IQfyF4zEkBTpTMxW3A5aqDHCWT2nkLSZWiAsQjWRLfgtFM18SnCWAiXNy8fqxJ8KUqomjT4Wnickk+/kr3dlprbK7OtO0QEDSe5SAINtYJl8OiU4fKUReVTIWDpSlCEucnwYCGneToxCZAe26AFrG6KKDKzJ2+XLU=
Received: from SJ0PR05CA0080.namprd05.prod.outlook.com (2603:10b6:a03:332::25)
 by CY8PR12MB8410.namprd12.prod.outlook.com (2603:10b6:930:6d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.20; Tue, 23 Jun
 2026 08:48:05 +0000
Received: from SJ1PEPF000026C3.namprd04.prod.outlook.com
 (2603:10b6:a03:332:cafe::18) by SJ0PR05CA0080.outlook.office365.com
 (2603:10b6:a03:332::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.159.11 via Frontend Transport; Tue,
 23 Jun 2026 08:48:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF000026C3.mail.protection.outlook.com (10.167.244.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.159.10 via Frontend Transport; Tue, 23 Jun 2026 08:48:04 +0000
Received: from [10.128.114.94] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 23 Jun
 2026 03:47:57 -0500
Message-ID: <37010218-ecad-4f75-961d-686d51b6677d@amd.com>
Date: Tue, 23 Jun 2026 14:17:55 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Linux Memory Hotness and Promotion] Notes from June 18, 2026
To: David Rientjes <rientjes@google.com>, Davidlohr Bueso <dave@stgolabs.net>,
	Fan Ni <nifan.cxl@gmail.com>, Frank van der Linden <fvdl@google.com>,
	"Gregory Price" <gourry@gourry.net>, Jonathan Cameron <jic23@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Raghavendra K T <rkodsara@amd.com>,
	"Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, Wei
 Xu <weixugc@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, "Yiannis
 Nikolakopoulos" <yiannis@zptcorp.com>, Zi Yan <ziy@nvidia.com>
CC: <linux-mm@kvack.org>
References: <cae6ab98-3441-38bd-1e07-4586a85cdc74@google.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <cae6ab98-3441-38bd-1e07-4586a85cdc74@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000026C3:EE_|CY8PR12MB8410:EE_
X-MS-Office365-Filtering-Correlation-Id: a1efc36b-7ba4-4750-5d7b-08ded1042414
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|7416014|376014|82310400026|23010399003|13003099007|921020|22082099003|18002099003|56012099006|3023799007|5023799004|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	WUhaVp87CMqvgIIcJ1UOmMmEhwgABRpm4AseYhwF1RQuG8mjeFnV+BDX5T5lm+FYIx95dcrmwXkaqOUArj+6uQaUDyBWBk0gIiT2uMlMvId8ojR/NbqC129Wq+zwyc3RdtFrzx5wptjc3pGXUzaxshwiDTNuok5OlDUtloVnP1zyLyDTEMvqOZAL5L2IgOIMbKYw0QdYdBhaIUziC92xVF2+bzltkimSKYvIYr15CL417EFeKAIr5CsYnBjWnZKtAWUsdt8/8dn0V8so1FHchmiccyCCwalhrRzrAJXcnMY9Cdw2DZY1t98nbVld0ctB+mN1zKMy+YJSTnrSBU97bzhApy414cZ2o/NWOvE5a1Q8U2rRctn2TH1AnAYijUCMESWY/2HC4+UeZBRSxv+jT/KyhdP6SJli87GmE5U0KIt5tBL58JQ5e+ovFk5ldeudj2dgx0l9HfBLkXLA+YjaPw4OVPCaFlrMYb+GWLrrGMc8Nl1v7qTeugBKJ80IaRpF/bXJVm7dtyWiWypjHSLssDRx1lQvlITpcE1WQmSkAskMUiE+oAKqjX8jqwJzRbFE68J4U2gKY8aCwjeBg9uaKjxTozZQ7vrCvMRkVfGyuC5ruM+aA/2UGw8zePga/1BFYPn9M+ACTQGuCpE6YvuqaHtPkQvNlqY56y4LVMvkimwV0IJiE6aflIZCZMiEkevF3X2z7JBMZ3d70Db9E6+JSVbk7ujMW1Cam3JvpjPqxwo2oj1q/HllMbOWF9X2cy9L
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(7416014)(376014)(82310400026)(23010399003)(13003099007)(921020)(22082099003)(18002099003)(56012099006)(3023799007)(5023799004)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	2YI/MV6MzVUIikc8uCrLTgTsnD4VkZ0XZt4nuHuLiXfBmhMT5NuyW4Bdfisr3nKOknAj+r8DSxc4XtgiMGMblJR2nDD/PnzjHwKyi5A3pN7iTD8UKUQsE+vglrHQqxNfLChL1gJ2gj5oxmvldorviySPjnL07tdi1N3f9lt/DtjI9tCjJvWWmjMht+nUiyGuqItyK/ZU1RtRiNxd+x7o5wkJZqHfJHFb9/m2x2IgOUdhzHMBk6a1JtX9cQeuuyjJ/Cp9cCr0YRle/a+y5V2J92nMsEdeZmaXIn24cIj7X8atHRkDg3rFf+kl0rvHzDI6T/oooJdOJJ/JZBYMHeGL+32r012bNAop5Pbba/ugv6YbhXYOqL2lArU+OenvZ2TPMQT5tosc8sVbwPrez8TLx6fzGD5smwiBjh+phnMx3CvdY/azXW0rvw1UXniZqYFm
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2026 08:48:04.7325
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1efc36b-7ba4-4750-5d7b-08ded1042414
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000026C3.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8410
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4846E100007
X-Stat-Signature: zuq8886koz443m9frsrbnm8qfpeedodm
X-HE-Tag: 1782204489-892156
X-HE-Meta: U2FsdGVkX18Xp/40fQR97bJFdV+BL8hh+xFA3UZO9y3N5G7sZuEQgPxu+kf+cLjZHw2bAvfkVowN24GUJGKyqP/jRYKPmlC665ILdIbI36fZ6C1F1d1GXgQbCGnmHPorCvjo0nVWu2UOTaIDOUhTRshVzXmO85OKUs6edTQ61pDAR1ghBG1paA3+9EXCuZRs4GcCPgmoBKbZ628TNc19abIgbVsfld5v+yMeYPIjdBdNOO+zqlDVr3Sq/tjQgKuQ5cSFJh0JaIDL4PBWdPL2RDb5VihpRTM5Nfguy+Pp+XHpM4inoVC8C4dCwPV67tlrRWXUCOQpy+mXFVwa5eiZwbzrZQ4BROc4gG2Leqi0vBXyb/R200OyvLnHH1oWRAWw8JCOKDaz9bsLWnUzoLEtqghbOwwMoOiJj9/raFAIU/yXj+jH6hjBj1Kft3azV2F+z68t6ojtxiHQzvIXcuNnawKnTxkmFsecG5Lzr7NJq4GOB2Ks0cgtGO7Fhl428v/4GdMlno8I4uBZy1yGyQS5aE4cRzpFZo57Ozdfi/vaabgoI+xzpoyE6UNTgW6/ACTiKjC9u6T+9x3CJ5xc61dB6ykl5YYj5U3qIsBwivkbyY9fFxQojgMor23Y9IVTirNUA6msMz/ejw975DpfxFQaTZrrcQYLldsCUjhxNF/6UDDah5tvaH1z8FSghSj7Ll4qo7v9VggLSj7SJfOlsXR+oPU/DiguB4wytMBU6Ohyf9Ru8NPCKGa5k3q09H7dAWPMdTIR9PdtUyWJ/SN4RH3sQFiG+sh5veB3wCSTNdSYnMioTWtH0Dm6Md7Q0tBchYAVM9VjtMZ/ijlGgEa2ksBIWifiMC3c6ZL2lk+1IKKy5xnPsG+xwjinJePLMClCcICHHG+VEr9LEG6rviguLCJTBS3WRb1js6Ahq88PZu82Jv7TjSnqa14KcpVTh1VL5XwmzKn29s3S8O8q8ydDvJx
 I/yrnDiC
 dFUCl0kgLdgqtUH2DOnWqeAzfPxgMmo7uRsied6/8eTf7MApVzZCRSQQMfkpRmWJXglB0h5uJKrh7nrQyecIDi+QTErG/cY0FyD2ezjvNCjwvd353yMmah2iLwpFyri5kFt1n5JKe8G6hOkOyAI8SDkt2ObkT2xxMhj7DUnDc5fMaQ9duFy0PoulRrKUPsEGncf3bsw5cJRFeMe7SwYJtyjVXnhk7a0VdO+Gixmvav7+4gjYllOqD+wwQQOYsCP2BOR1Hv7oO8eHnbXKcWxI6QRuh3q2IlfMGB8RO9J7mdTRd8b4Aij4ToP52b7RsyhyqZIFc2iKo9ZCgc8aC3Gtt0QP1FytvyT3MEQuxZeyGAJwOppr0R079NeinEVbsKohT4YFPErzovKhWV09Iww1ZSFkTHGF2E7puaPVNICmrBO0HhdQeYqEIEnhGP26KRWiRZynPXYADCNOKeeuOnFJaDI/fzbZEUGuBCmWlGPPbxJzBV4MKH/X3pca3Shd+SGRakNyv9aaB5gsBv1rESVqTF9Papg3cFlTfas247+Mm1VtGGH8hqDAXtTdnh+3C0a2rTPUQc1LMBmYWVKG6qDuPi+foOcaIvqf36JsiIgOTjO5Dxg8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/20/2026 8:24 AM, David Rientjes wrote:
> Hi everybody,
> 
> Here are the notes from the last Linux Memory Hotness and Promotion call
> that happened on Thursday, June 18.  Thanks to everybody who was involved!
> 
> These notes are intended to bring people up to speed who could not attend 
> the call as well as keep the conversation going in between meetings.
> 
> ----->o-----
> Bharata updated that he is getting more benchmark numbers for IBS Memory 
> Profiler source with pghot and he submitted an abstract to LPC for a talk 
> on IBS Memory Profiler.  The next version of the pghot patch series should 
> be posted in a couple weeks with new benchmark numbers.
> 
> ----->o-----
> Teja Vojjala updated that he will start working with Shivank's patch 
> series for migrate_pages() and collecting some benchmark numbers.  He 
> noted improvement on Zen5 especially for benchmarks that are flushing the 
> cache.  He was not so sure about the instruction that the patch is using, 
> whether or not this will pollute the cache when doing demotion from top 
> tier memory to lower tier memory.
> 
> We're working on non-temporal writes to avoid unintentionally promoting 
> cold pages that appear as hot otherwise.  He also noted that comparison 
> with other approaches showing a degradation when using AMD's patch series.  
> I asked him to follow up on Shivank's patch series upstream to have the 
> discussion.
> 
> ----->o-----
> We skipped ahead to discussing non-temporal stores given its overlap with 
> work being done in migrate_pages().  Yiannis had posted his patch series 
> as follow-up to the previous call in the series.  He noted that he took 
> one of the existing functions for the pmem era and that it may be possible 
> to do something better in terms of implementation.  We see reduced cache 
> pollution with these patches measured by the CXL device.  We see a 
> complete elimination of read traffic on the device itself as a result.
> 
> Gregory Price provided feedback upstream about the use of the Kconfig in 
> the patch series.  That was his only question for the series itself, he 
> thought we should be able to identify if we can do this offload through 
> cpuid; if so, then we could always just use it.  Yiannis noted that with 
> this implementation you could see a much higher number of instructions 
> retired which may or may not matter.  The bigger benefit here was that it 
> reduces bandwidth.  Gregory didn't think of a scenario where we would ever 
> want to turn this off.  Jonathan Cameron suggested removing the Kconfig 
> option.
> 
> I pressed on the new migrate_mode addition given the long-term precedent 
> of the existing migrate modes.  Why do we need a new migrate_mode that 
> specifies whether we want NT stores or not?  Wei noted that Google does 
> the same thing because there are otherwise ABI issues which is a bigger 
> problem because the migration callback does not include the reason passed 
> to migrate_pages().  I was surprised that the only way to change migration 
> behavior today was to introduce a new migrate_mode that would be passed 
> into migrate_pages() and that this didn't seem very extensible.
> 

struct migrate_ctx {
	enum migrate_mode		mode;
	/* copy method: regular, non-temporal, offload ...? */
	/* reason, other info ... can be extended as per requirement */
};

int (*migrate_folio)(struct address_space *mapping, struct folio *dst,
		struct folio *src, struct migrate_ctx *ctx);

Should we extend the migrate_folio() to pass a context struct instead of
just migrate_mode?

Changing this callback is actually not that complex (only 59 instances .migrate_folio =),
and this will fix the migrate_folio() once and for all.

I'm working on simplifying the migration code as it's become increasingly
complex to add new optimization.

Thanks,
Shivank


> Yiannis will refresh the patch series to not include the Kconfig and sent 
> out an RFC v2.
> 
> Wei noted that some Google work was supporting memory errors while using 
> NT stores and that we could discuss that in a future call.  This would be 
> a natural extnesion to what Yiannis is working on.
> 
> ----->o-----
> Joshua updated on local testing for tier-aware memcg limits.  He ran some 
> benchmarks where DRAM performance was the exact same as CXL performance to 
> identify the impact of the overall approach itself.  The overhead was 
> minimized so far to 1-2%.  He also did testing on real hardware and got 
> similar results.  He will be going through this testing before posting the 
> next update.
> 
> ----->o-----
> The next meeting will be CANCELED due to the Independence Day Holiday in
> the United States.
> 
> Next meeting will be on Thursday, July 16 at 8:30am PDT (UTC-7),
> everybody is welcome: https://meet.google.com/jak-ytdx-hnm
> 
> Topics for the next meeting:
> 
>  - LPC planning for October 5-7 in Prague
>  - update on Yiannis's RFC for non-temporal stores enlightenment in
>    migrate_pages()
>  - extensions to ensure that non-temporal stores can properly handle
>    memory errors
>  - v7 of Bharata's patch series, including new IBS hotness information
>    and NUMBA2 hint faults
>  - v5 of Shivank's series for enlightening migrate_pages() for hardware
>    assists and how this work will be charged to userspace, including for
>    memory compaction, and separating the first patches out into a non-RFC
>    series
>  - v2 of tier-aware memcg limits, including ABI changes to support more
>    than two tiers
>  - first class support for virtualization based memory tier support, how
>    to leverge memory tiers in the guest
>  - discuss generalized subsystem for providing bandwidth information
>    independent of the underlying platform, ideally through resctrl,
>    otherwise utilizing bandwidth information will be challenging
>    + preferably this bandwidth monitoring is not per NUMA node but rather
>      slow and fast
>  - later: testing of tier aware memcg limits with Bharata's changes once
>    tier aware memcg limits is stable and further along
> 
> Please let me know if you'd like to propose additional topics for
> discussion, thank you!
> 

