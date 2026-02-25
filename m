Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D296DF55452
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 04:36:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B888A6B0005; Tue, 24 Feb 2026 23:36:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B369F6B0088; Tue, 24 Feb 2026 23:36:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D67C6B008A; Tue, 24 Feb 2026 23:36:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 886D36B0005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 23:36:24 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0FDAF1A0439
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 04:36:24 +0000 (UTC)
X-FDA: 84481717488.20.A52E9A1
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010018.outbound.protection.outlook.com [52.101.201.18])
	by imf29.hostedemail.com (Postfix) with ESMTP id D9BA612000B
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 04:36:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="4EoqT/SP";
	spf=pass (imf29.hostedemail.com: domain of bharata@amd.com designates 52.101.201.18 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771994181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4+5SgyJcFfFQFrsK/DEIKmUiPdAYAfL9p5xLbLSw5qQ=;
	b=RsM8pw7wO8+pOV1aahIdEgPbeBG5ToLPhChyglPPtJJaKWg+XikSvU+exfHDPpXi4iButX
	P6I719EFxhFstk35IxPXsbW2HnS2ZtYi4FMo/upedXHFRkfFePQX3gzA9zBX5+bsRvy1O3
	eLNz4i5aM6pmjrVEe1rMG/uORPs9210=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771994181; a=rsa-sha256;
	cv=pass;
	b=URd4qePCyc2TAsvriyA4Z4rwaYKQ6QMM7SkoZut3qB3oUIB7vaGwKfV7n8Q+nrRsWeB53B
	oaxuENzeBAX9ysjzb8Zn68ISg50rPph2hGkZm/4GBpFvibsGtMkk7hryE+yUHkXIQlrz+B
	r5rRFKmizGvCpIePPs6M5/EtxABqFOk=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="4EoqT/SP";
	spf=pass (imf29.hostedemail.com: domain of bharata@amd.com designates 52.101.201.18 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U393Et7h0zA06yOhb5N4dhHynLd8AvQ3XGzvgH4ONxiAC30h8jugXNX1WYRFAzfUHT/1UjyTf0CrzFEbQrqd6bBTLo6ip1NntPm+u4VHI3VRyH9D5vigGtcURz2tWKn+PkU1ez15Zda+59RRwIcRGYn0a9Ie28mZ+cgWP2rIfa25QS+c6N7/OwgBUSa/BRFcRvnFTkfkTAyCGlJqWvNVkHPwJI5xj1bTG6ztYj6pEYk/1BWQ9k5h5Hjfoh3BDpRoHLDSvOce0lo+LygG5khrjQt5j8kfQULAC9SyPwoDv5mUKByN6Kpxlx+fM+Q9kP9fcx2MtXK85pGqqlgZsxG35g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4+5SgyJcFfFQFrsK/DEIKmUiPdAYAfL9p5xLbLSw5qQ=;
 b=foZq3hreHRuN3xuWKukDs0NBIJefro+Kt20nVat5a8ghcxr1NmnGRr3f8cQbmCpDkaM3k7W/QPcEVl6wh+ZFZGxe8cGR39w9tInQLqEhiJLkKcbHBT/ciY3fCdRuXR93Wuv9IQNGAeDNCLNRNzxSWlnG8VHnpExSKG2kogH3QHNcBsZNDKcxYGzv//jNM3JcKqGjED/8F0TEHRTojmUwgv6ey+x+Z9WElw0nAtTOl0Lk5BlFSmZJ48Flk0Yxu5apTmEAbgmoSJ4+3roAuK8UiOzJ3kN1zmHsVstKM2BRLthDKvhdGPtVu9Wa1i8z/sxqI4/GU21HVuHXJZ5cMKPF+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gourry.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4+5SgyJcFfFQFrsK/DEIKmUiPdAYAfL9p5xLbLSw5qQ=;
 b=4EoqT/SPU0LWwCMYaGPEPKSl86Aou7s3CO8rFSyFyQnBGCBYhKDDvAM4cBye/ugnikG7D88Cq4ZcoF5ZINbz8aVtJqXqKhoQdt7Zi5XPr8es1Sk7J2zS4laiA1UZ05tMe4MnRQDIdYFvx+nHnYYgi6GVHjao1uR4ijbRFPVNmD4=
Received: from BY3PR05CA0059.namprd05.prod.outlook.com (2603:10b6:a03:39b::34)
 by LV2PR12MB5822.namprd12.prod.outlook.com (2603:10b6:408:179::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 04:36:13 +0000
Received: from SJ1PEPF00001CE3.namprd05.prod.outlook.com
 (2603:10b6:a03:39b:cafe::d0) by BY3PR05CA0059.outlook.office365.com
 (2603:10b6:a03:39b::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.23 via Frontend Transport; Wed,
 25 Feb 2026 04:36:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SJ1PEPF00001CE3.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Wed, 25 Feb 2026 04:36:13 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 24 Feb
 2026 22:36:12 -0600
Received: from [10.252.192.21] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 24 Feb 2026 22:36:04 -0600
Message-ID: <38bc1006-d721-45a6-9316-f63941b4b96d@amd.com>
Date: Wed, 25 Feb 2026 10:05:58 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 00/10] mm: Hot page tracking and promotion
 infrastructure
To: Gregory Price <gourry@gourry.net>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <peterz@infradead.org>,
	<raghavendra.kt@amd.com>, <riel@surriel.com>, <rientjes@google.com>,
	<sj@kernel.org>, <weixugc@google.com>, <willy@infradead.org>,
	<ying.huang@linux.alibaba.com>, <ziy@nvidia.com>, <dave@stgolabs.net>,
	<nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>, <yiannis@zptcorp.com>,
	<akpm@linux-foundation.org>, <david@redhat.com>, <byungchul@sk.com>,
	<kinseyho@google.com>, <joshua.hahnjy@gmail.com>, <yuanchu@google.com>,
	<balbirs@nvidia.com>, <alok.rathore@samsung.com>, <shivankg@amd.com>
References: <20260129144043.231636-1-bharata@amd.com>
 <a8d1efd6-2ca4-4f1d-9c0a-c8aa17732ee9@amd.com>
 <aZxsBifRchLn2m42@gourry-fedora-PF4VCD3F>
 <7a574665-0a65-46fb-b87d-d2ae28308759@amd.com>
 <aZ3D_8GJit3FYhQc@gourry-fedora-PF4VCD3F>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <aZ3D_8GJit3FYhQc@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE3:EE_|LV2PR12MB5822:EE_
X-MS-Office365-Filtering-Correlation-Id: a613a089-b1e9-4707-63e6-08de7427682b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|1800799024|30052699003|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Sk1zQUlBdWF5cDdXQ0t3d2ltSy83SDIrZW1LczY1cHdOckVDaElnVC95dGlo?=
 =?utf-8?B?eU1WUFRZWHcrNThrNm5sYmpkYmZzaHdGWEFIUXJRKzRFcDBkVGY2UFZsaE85?=
 =?utf-8?B?clVvekoxUDE0dUo3ajBFR2V6cHRmTHU3QU81RHY2MDRjelF4aUpBTmppbVZp?=
 =?utf-8?B?cW5zNXpRSFhsMjhNZkJ1QVlRdm0yaFRjdGNvZ3EwdjltelFBZko5VkpabXNz?=
 =?utf-8?B?TEVxNkFxT0ZuNDRFb3RaeE9XZFh0NUZEazF3NlVBY2RuR2pVaENPT0VBMFlX?=
 =?utf-8?B?eDlRRkhoU1FZZ05EaWFBWHcvc01WeXNxSkpMODg1VUF3QXlMbGx1ZzljcEYy?=
 =?utf-8?B?Wi85Y29Ha2hsZzkzUzhSS3dvUE5LT0Q5dDJjVlFwSldFUm16b1dWZmRtVnEy?=
 =?utf-8?B?OTF2T3I0aFlsOTBkV3RCREJtZEtyVFd3c1V1S3Jmb3FaenhXS3h5UUlVcll1?=
 =?utf-8?B?NHZrVTR1dzZ2S1FvcUZ3Z3g3UU9adE5NVVlFOWFrM0dNY0pVcmN5bmFrSW4z?=
 =?utf-8?B?Ty9MUThPZzQzYlBEUVcyUWljSXIxbHNJL3RFaGdrZWc5S1c4ZUdqeEJWSW5V?=
 =?utf-8?B?NjhWc1JNcGJMdHZOaEJnSkhRRDlFRnh0TUh6by9yMW9mZFk2U3d0bGlKdU8y?=
 =?utf-8?B?QkVwSkQvcDlrZi9kNzlLK3ZkcFRhbll3TGkzaEgrUVkxdis5Z0V6SlMvcHJs?=
 =?utf-8?B?dzVRbzVCcUZpc0xMZUUrMmYzRERkbkwydFBYWHBTT2o2Tld4NHNlRTJGSXlh?=
 =?utf-8?B?dHVoS2ppSkRjWXFtdXEyK25wSCt4SGZSSW5GQ2paOVFEUDJzbVVQaEtjeERQ?=
 =?utf-8?B?M0ozRmdVbkJkdkpMdGgvWDFESHFwQmFwR3FVUDAyTG5jckluaStueUpOSC9I?=
 =?utf-8?B?Q0Z1bFRaMCt4czk5bGUwc05vMU03QXFzWm1yN1RwSnNGVjdCeFNkemoycThZ?=
 =?utf-8?B?UTdMMCtpR29uK2JPeGx3SkNaZjFFbFNPV3NzdVFUamtqUEhqVXFET2ljcGVN?=
 =?utf-8?B?bGR0T1J6VlZQSGRybHZSUWxIZzU1MUZOTGtkWmhJSWo4czh6cTJEaFQyVjZ6?=
 =?utf-8?B?VGpJNmlnN0hYblhOR2NZTjVnOU5BWHdEelJ2ejlzTWNBQ3ZQeUVZb1EweEdv?=
 =?utf-8?B?VlhxQUlQYlhDZ05HdXgwekYwZHlpN2tKYmNQOElGNWlOa2RzN250ZzQvbUFm?=
 =?utf-8?B?TVlBbHEwd0swcjJoOFJLSnZDSUc4cWFzcVM3SFNwNUVVZVBJaWtmeHNvRVJ6?=
 =?utf-8?B?WXh1WEE0dkpUd0diOHVmVEhOQ20zZ04rV1ZxZVZpbG9ZZlVnOTkrZFZKa1ps?=
 =?utf-8?B?KzdNVFAvTy9Hbkk1djJ1anZKWU1sR2VydzJ1N1FuelRLMUpmNEd5NmNUdDdE?=
 =?utf-8?B?MkdET1BpUnZybXZ1ZS9QZmRCb0tRb242LzczeCttdS9BRktaZ2k0MGhQR0lu?=
 =?utf-8?B?cnZXWG9ONHhoMlFzRS9xbExtUjYrTzg5UzN5RkcvYWJXTlN1R2M1dWZQSkxJ?=
 =?utf-8?B?SVZINzJEWHRyR01OTm9rcWxqMXNpdFJEbU43eFJnUktRY1RzOHJrTlJxQndV?=
 =?utf-8?B?dHJvNTF1dlJvakZ0a01YQldJWFpJUDQ4RHpacUQvdFQrVG1DV2tuS0FtdEpi?=
 =?utf-8?B?SWI5WUxVYkl2TFRHZ0dQSU9EYlB0STlHRFd6YnY1U0hTYzlBS2IxbzVYRk05?=
 =?utf-8?B?WjJSeWVPQkNYUTNJd3pFa3huNC9BWXhSOGVKZkRNQW5IYWJhQXN4MjVhclh4?=
 =?utf-8?B?eTZ6RUVMTTM5WDdrN1NhcTdxQ0Q0cmxGTFgwT0VwQzExdFVzUGtKYUdON0Ex?=
 =?utf-8?B?UEVmRE1JQ0N1UG1CRS92SDdpYjhUUU9jRStaemZGMU5yaUpiNHFhRUJFbkVK?=
 =?utf-8?B?QjlCdHljK3dZcmxmZkRuUzU3cWdrdmpBdWwyeEI5bUNTZUkrRmRsbVU2Y1BO?=
 =?utf-8?B?L2tUWFdhWkxwVm5vNTk3NWFaYThCQkVWK3dXdUxDWitRYlM2bjViODRWQTUz?=
 =?utf-8?B?d2lydXlaVW1lc1FUUGpjc0JEZ0oySWk1TFZ6WmNLS25QL3pGM0tLenIxZGY3?=
 =?utf-8?B?N0xUUHI4Q1dkUDRQNVhHZUs0VnhsRzQ2SnltOERUSzdFK3FSdGMySmk4OTZs?=
 =?utf-8?B?SU4vTExabEFYTU9lcCtGd1dIaDMxcUI2d0xhd0hqOW5SUVNlMWxCVnpsbWpT?=
 =?utf-8?B?Tzd1YTQ0eGxIaUNYOUlQSUtBVjlYM3BZV0hyRHR3bm8xR1FXb2tPZHk5dkpD?=
 =?utf-8?B?dnZIUGpGNG45M01hUS9pRVJpNk93PT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(1800799024)(30052699003)(82310400026);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	iXWY/fU0mPvODHmoTG3e6oKgDEw4K+ZzDxcYCSZZb/YLa1528+7yPIaAnckuP5p8vDcC8QCJDuZgGYjqWXw5INYknhrBbT8n7MnIRxX1USIBKwRxiXzye7FJwlFnguG0IvobXBqC7o64MguTZEazC8M5XRbejmsprRn9+866PMRAtE6DRIWJ/KSfpCRyQzRvJSgZbip0KycHfWVESaOex5oT2QTJRqXFEzKqCJ6kNmO6ErWscmQXwplUdjrUu5uXsIdIAVKXNM8UgI9OqP/uav3ilPQmP3OwUAaxsLEykQhzjUXgWSrdymsXhZiRdJm00AfQKJ4vckocD4L/pI87WWlVn++dj+KmuymMHXvd2686ucU36WklI6jxr9N3isJjmyWjwxv514cL9gFsOE9Ze6Yd19RPAK3HtGhJwbTE49GKA3DZBvPPsf2Y0s4AYXIY
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 04:36:13.1995
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a613a089-b1e9-4707-63e6-08de7427682b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5822
X-Rspamd-Queue-Id: D9BA612000B
X-Stat-Signature: fqxbrukw8f7oaregpurjde76dmfyrjc8
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771994180-805464
X-HE-Meta: U2FsdGVkX1/0MSdAu7bIFeEYFgKt4TP5UNfqKuq9Z1o2eXotjqm5v4Jnaa4wdOILooDs+vmugknmR1EEUcnLIpbrEP//MrnigxAQxPJw9hQ+gY8EBbin+XQ9fxlVi6JXmDY9yZ+e1UmznNI1WSUni4m/rl22RBVtW701mbTAdYaAxLQZafLrFIB3cVadJAECVtqs7xTqA+C3LjbSjojUeG1ct5xbYxVdcqMfk2IR4OmnS4S2HZvr9mMCes0oEF5ZoOyw5Wd1VtJldXkvqD81rZtrhFdET9U5jkyfgy92slpbC4yuQitciZiLbRvcFDb+mjaH9oVcw0gyonO/SJ27I5hRdoa34qzVRFlNcMDybmwNTVzHk6ARyGP9wpxq8tBusPsL9c+LqegoE4yE719gRf5lJY6CWqrUKjXob5gdt2bsuB7QzyZ7zxpEAGfexKH1aaRwpJkQjZe/pkJ/pvVIY4Rz0xJpylF4e6+SdbR7gCwPc7BjzEuXKFF24zh1BxIRFL90G4BCBSfOoNRFXsvSGCIU2RE7/2DVBKrQVF+E1f+FwalVTYMfJkV5OnLz2/zYqEleTONOQepaZRXqetKXTGx4Y9pt7UsLX9H6/hSWGEBbjCspxXJyIViPlKw1bNqyjAPvbL3uKjrz/Gh5tjyKqTBapaNbQY9Y40VzjiFNo90AcR1J1mll6MVw8key1BhZ+gV7B9wOmPd/+dV8VT2gpAX4is5CFnErxdH1R1YVag9cwDF6sIH8he49iDJr36Pf9X9pyzoxXFkNOb4m0d08vW2ECaqCaiXZTTb8UKi8Z+jdivPSFLKnEiW+S1EJmwoXm8+SVpXmJoKN1xM/46aKqPhyrDoxAZnfMILAL7BldFfkyjroOoyZ9r9huEFNf1c35jwMigf4UIwU9nnNaKh39I315V2JeU+ENorgjg9jCgWX4gIVbmLsO+Ye2TBmqdQLoLUssnPzguHCynqSuL0
 Md0kSwJE
 BktPe3mxBn15BJ6TKvjn8+ZIymoy/LWdoE6DfqjIzrXnlRlm9fcuAFT3JAC/MwNmI/VY3I36Zb2j15BC84Xg5SJmBv+cXaV0XgduqZnY6wuHykc56x22md+iAjCZg2TbTlSHC6ztUnXuClo2o47fvSd3eYDQwKvEuYksMflRz/vA+HOVx7YFf0wvAEbA8qMH7/sbO2IxYBfhlECa40POTGCQvDODqPea/T5h57IKaT5usb9499HSGR+ai2XLmzYnn07Qpxm6nCwnp9hoSeu1vJnfXRR5M679NPjGGaG58E28ZMpACQtcaGS5JgAmnnyze0FDWLMPu+2vOI/x0uNjUnrXqzfPXWaz5oveszl0jS6ORa+qG8ErAgPKs1LsnQ6AQW+BlW9Tbzf5+d/JuGQOEh8SnKN1cBHQGnAPS8OB+AatGq1eQpyYhn3SY3sY9WKXkVLvHJ1sBYSVHU1tsIaFg+d15lDkGPXDHmiPX5DZkUJfHsEk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24-Feb-26 9:00 PM, Gregory Price wrote:
>>
>> For pghot-default, with target_nid alternating between the available
>> toptier nodes 0 and 1, the numbers catch up with pghot-precise and base
>> NUMAB2 case as seen below:
>> ================================
>> Time in seconds         4337.98
>> Mop/s total             90217.86
>>
>> pgpromote_success       42170085
>> pgpromote_candidate     0
>> pgpromote_candidate_nrl 42171963
>> pgdemote_kswapd         0
>> numa_pte_updates        42338538
>> numa_hint_faults        42185662
>> ================================
>>
> 
> Fascinating! Thank you for the quick follow up.
> 
> I wonder if this was a lucky run, it almost seems *too* perfect.

It consistently performs that way. Here are the numbers from another
run:

================================
Time in seconds         4329.22
Mop/s total             90400.27

pgpromote_success       41967282
pgpromote_candidate     0
pgpromote_candidate_nrl 41968339
pgdemote_kswapd         0
numa_pte_updates        42253854
numa_hint_faults        42019449
================================

grep -E "pgpromote|pgdemote" /sys/devices/system/node/node0/vmstat
pgpromote_success 20996597
pgpromote_candidate 0
pgpromote_candidate_nrl 41968339 (*)
pgdemote_kswapd 0
pgdemote_direct 0
pgdemote_khugepaged 0
pgdemote_proactive 0

grep -E "pgpromote|pgdemote" /sys/devices/system/node/node1/vmstat
pgpromote_success 20970685
pgpromote_candidate 0
pgpromote_candidate_nrl 0
pgdemote_kswapd 0
pgdemote_direct 0
pgdemote_khugepaged 0
pgdemote_proactive 0


(*) The round-robin b/n nodes 0 and 1 happens after this metric is
attributed to the original default target_nid. Hence nrl metric
gets populated for node 0 only.

