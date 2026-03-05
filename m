Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FFF2F513E9
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 23:26:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BFCC6B0005; Thu,  5 Mar 2026 18:26:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46D266B0089; Thu,  5 Mar 2026 18:26:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31B0C6B008A; Thu,  5 Mar 2026 18:26:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1D43D6B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 18:26:46 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A5B118857A
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 23:26:45 +0000 (UTC)
X-FDA: 84513596370.09.ECDB54C
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012047.outbound.protection.outlook.com [52.101.53.47])
	by imf29.hostedemail.com (Postfix) with ESMTP id E25F012000C
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 23:26:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=TKo+UVyU;
	spf=pass (imf29.hostedemail.com: domain of pjaroszynski@nvidia.com designates 52.101.53.47 as permitted sender) smtp.mailfrom=pjaroszynski@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772753203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JZv0fHm5PpgNRNqWwSvR0NqgitiAKXDh8wvn9432nlY=;
	b=utgEedOdUL028w7r7YHvy2+nfyaHBSkXwOkB77hCJsYtaHTH6wWak/FN30LDQzP2tp64Gj
	OW/jdmyD3KECcrELBMHJdffyCwMF40aqjDk582ok+z9xJREd6VhYjZ7eJbTVmIlFqgsiJ4
	rAgWExpq+0VUF6MPcckdRMGwT+1Rx8Y=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772753203; a=rsa-sha256;
	cv=pass;
	b=syqo1/IqycW1ZRPs2MrvmqTK51ueyxwg7SgyE0LBi5S9HAPczvAbTW/X8nS3YeItB++net
	A0CLqiCxSrWeW1YzbuAkZg7Tl2kCfn42n2Eyiwf1g4YLyqClzTHFKIHyD079ysiUXRZ9/H
	dYlzJEMGTyoB9tfypDuada8sgMN1528=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=TKo+UVyU;
	spf=pass (imf29.hostedemail.com: domain of pjaroszynski@nvidia.com designates 52.101.53.47 as permitted sender) smtp.mailfrom=pjaroszynski@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oNJGmcvVQGdMrCsW4PfRQZBx2UiNlbEJ0UGFgEmKbg4q9BFPeoAg5gj4RuhVEeM2URV7FwRDDzQ/RsWGfYjd4CFxzT97Xs6vFtx5M7f/SNU+qS/ZhHEGNTxPJtveyuVdwVsCPj717Gx84Ej4o6lHsE3Ye6FwXz34ek1s/pRlxTDMXeuRnGBp3oDG6zuFkqsUe17kaW1XY7xNdIbu22bjLO7XqqFkZi5U4e1M20pICTNcpyGJcFDR6Yb9ZzRMlPeAggbTd8U1k+0Gt/uUNY1UNhsM62NHDyBm2GgdP7vomZm30BhwsVIZnbjvfodCTbxa06ikF58UiuKrVcx4G0ZKqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JZv0fHm5PpgNRNqWwSvR0NqgitiAKXDh8wvn9432nlY=;
 b=ddZPKnlsOZbcw18ix/SedJtpgB6LPLeJN0PhJRWZGD3J4DDTwu2wK77VjswhR/hPyuQUzLVaDrOD6p0q8tYvbaYgoIg2QnDjjwsbaIFQ8zQ3CxMq0BiQ0IqUBxbRy5U2II8/jTMCA+R0BAyefVjn3/Xxao7BOH6zbRLGtKoeerGcvLTP0VuAVmQuCc2EEO5n4xLkkBX54mjQvdYFkc1rCVp3ElMJvBUV5lHyBBqLc+uxfP4dEYOJhryxo8xUcCaTxRo2csC6p1fmwsggX8HlK2jDnIgRGpDsB3WiVcIS4SyyfryTPGVoSfFmHSiBX49yJAJ6JxNXwQ2KwS4L6ANoAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JZv0fHm5PpgNRNqWwSvR0NqgitiAKXDh8wvn9432nlY=;
 b=TKo+UVyU+ZHm0mAMhRKeZSpr48M4i0FTn3ezviqUDFNjg/rQ2d9wCH3nDUmVZNleDqR7lj+34IxiFIe4j+iJ5JZd4ocf6/qO+pP9ucqX5Px0hMtqyL7a3kfQmoAUNG19FTxL/GtzE69b9I1oxHDPjUn3cHXY7vd7n2QXuMlSOVVFHLkgGWWn9IbG5AGl/Z2KppJAKH2qCYJ6GiPaCzcPrxK3MiMol7p8xg3FEVyVAjheRPNZsAjUtOaAzKHptuuQHQBx/j49L54RQvaTWRdjzActKLFANOSm6KJuZBDX6hwT/fEXoD/EDkrU6joiuZNn09Kxw8uOOMflI4vyDgJAZg==
Received: from DS0PR12MB6559.namprd12.prod.outlook.com (2603:10b6:8:d1::6) by
 PH7PR12MB8427.namprd12.prod.outlook.com (2603:10b6:510:242::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.18; Thu, 5 Mar 2026 23:26:39 +0000
Received: from DS0PR12MB6559.namprd12.prod.outlook.com
 ([fe80::3f99:f532:cf6b:ea46]) by DS0PR12MB6559.namprd12.prod.outlook.com
 ([fe80::3f99:f532:cf6b:ea46%4]) with mapi id 15.20.9654.022; Thu, 5 Mar 2026
 23:26:39 +0000
From: Piotr Jaroszynski <pjaroszynski@nvidia.com>
Date: Thu, 05 Mar 2026 15:26:29 -0800
Subject: [PATCH v2] arm64: contpte: fix set_access_flags() no-op check for
 SMMU/ATS faults
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260305-contpte-fault-loop-v2-1-0216f0026d7f@nvidia.com>
X-B4-Tracking: v=1; b=H4sIACQRqmkC/03MTQ7CIBBA4as0rJ2Gn5RGV97DuEA6taOVIYCN2
 vTuElcuv8V7q8iYCLM4NKtIuFAmDhV61wg/uXBFoKFaaKmtNLIDz6HEgjC651xgZo7QWxz2Sl2
 k8lLUMCYc6fWbns7VY+IHlCmh+18ZaU3fqVZ3RvXKgoJ4c4nz5x3ynY5hoYFc6/khtu0L1AXtd
 acAAAA=
X-Change-ID: 20260305-contpte-fault-loop-76ed911b01c0
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, 
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, John Hubbard <jhubbard@nvidia.com>, 
 Zi Yan <ziy@nvidia.com>, Breno Leitao <leitao@debian.org>, 
 stable@vger.kernel.org, Alistair Popple <apopple@nvidia.com>, 
 James Houghton <jthoughton@google.com>, 
 Piotr Jaroszynski <pjaroszynski@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>
X-Mailer: b4 0.14.3
X-ClientProxiedBy: BY3PR03CA0030.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::35) To DS0PR12MB6559.namprd12.prod.outlook.com
 (2603:10b6:8:d1::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6559:EE_|PH7PR12MB8427:EE_
X-MS-Office365-Filtering-Correlation-Id: af62badd-6660-48e6-6149-08de7b0ea6c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	8HV2ilYbmTtF/IEJetrIqaxvquK6hDQOuLQWUbqIKUxqR8JtZTBwbmIbgeL7Itv+VF1AEJDg/jCsIxDT0j+8laX/qtngScdv5IDNNtAUnLkdATjOjpPwjK2HcqZu4NAbYFooUMUKHHgZ5arEOnWtWnvcyaYZw5w+WRanSTEbTf+mdl/wd/cp1RcshT2BZuKc+PeMv4WEi3Dl3gT8AIDZ99P4r+x4O4MtjIs3CcVNlKX1kDzcCH4rRPuVdoBbEdHpt21ChzIu4SlqKO4OG67wpkWrKlx9zTGfqpl39X5eO13eMUfZhw8D4r43S+/kx10VnKtoAS9mGb4snQw3CAZMHawTZEkpmbqbvUVV3zC7Iccq1WeWms/FNzjRdv7e3exJIrBValtu4tMsbVhHTdFXfLh+JlC9+/Iy229VDzRXOc+vvVFlaLn7OOUuBVa4DxUS+zcO3PTuRBIVOQd8zRZOIB4fd/rM4OPnqrnOp7C6cQJopXz5FVIwFbZGoVzetc/R0wf1QtaYBR0+lUYgBQ2p/W1kknV8ziaXAcEFZVNDQWmdR0dDUR9nT3X8j8QKY4JS/Hc8YNusUU/PyWgBZanIizOh0jbuu+kV+KnD9ncNh34HL2V2JLTCJJM/2mh4f7/vJ1wGT/mCbH+PvTacdnRGe9+EmDSs/I4xehV9NjZgi9AzJlP2lrnDS42EuysqbNoEJIpAdo2pZqQS4dioclpfKtKvH1kC9G1yjvsbtAeAH9o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6559.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Nm9uMzZ0MDAva1AvNDZmYisxcG92bW9aTWllMUxtQ0dqaVpuTFdlaStRZUVz?=
 =?utf-8?B?OGJqOWhma0kwZms1QzBINlRYTjhjWXBBcTN4MndqSERHL1RCS2FVYmhrd0RD?=
 =?utf-8?B?SzBOWDVYSjA2ZXJuVE5sMVhHYW01ZmE3SHY1bjRWb2p5OTVmeTNxd2dGK0Zz?=
 =?utf-8?B?TVprdmp4VGlSbm9UTFpabmRodWVPWFhoVkVZQitWR0RiZU13OHE5V2JjbFZS?=
 =?utf-8?B?OVkxdVh2L1pJSGMrcmpVSmVWYnYvckRCWkx0ZFpuSXkrSk56eklkcytVSkJz?=
 =?utf-8?B?MGpweFlOZ3kvMThrLzZPaGpKZDZkV3daRmNsQlM1QTlHVjIzK2UvTG1QVGNL?=
 =?utf-8?B?WmZieDFxaVovRkcyR0NJd251dVMraUpkb2FhLzlmL3VGc0kxMHNMSDNmeCtn?=
 =?utf-8?B?MHEyL0NRZlJnY2h4U3hKOC9MS2RiTmlnbVg0Vm5wMGJGYmNDa0JWUlBrT1dE?=
 =?utf-8?B?TE9RTGtjcEs1aHAzcG0xMWNyanJmR3BldWxlZUtkMlZ5UG1YTHl5WjFMN2tz?=
 =?utf-8?B?VXlvVmdnU3dIKytVTlg1emxqVkZXU1RoNmVGZjNlMXdWWHZEbjhyODE4b21q?=
 =?utf-8?B?RGpOT0M0WWF5V2p6YnpkZXplUk1vb1lwdGdOSTd2bHVWTCtNSFFpMXNhTjlT?=
 =?utf-8?B?SzZ1d2NhQ2sxa04vWHR3a3UzQm5YZG1FZTJIQmF3cTZsUi83MmM1Z2FVZkhX?=
 =?utf-8?B?ekJpbElGUWh3aCtIVHVMZWl6bDhCeERwdnQ1NzlaMTJmdHBnbUlMclZWWFZw?=
 =?utf-8?B?M2cvWkh6VnBPRGE2dkJwRTFGVXpMZmJpNm03Y25uRElvWWdCdVE0djlIWWIx?=
 =?utf-8?B?UDRTUWhXTTdEb3pnVXd4OE9hcUlTL241Qndod3dlT05yb0JrcTQzYk0xc0NU?=
 =?utf-8?B?c3JhaFFDd2REbzVHWXZxVDBkRWcyejdOR3lUMVEySG1FditPMnhPNkdJQW1p?=
 =?utf-8?B?S2ZFZGtRd3hNbSs1MXBNeTY2Q3dlOHlkUnkvUWVkMFk3aUdwbjNoOENEL2E2?=
 =?utf-8?B?VkQrOXBEQVJtZmV0NDRpN3h0OXNSV01IdTNvZHdldTJ6RkIrSDVJc2NCSmV6?=
 =?utf-8?B?OWt0eUNLcUlyUDZ3WVRkalpwZXh2d0l2R1BpbmVxcFNqL0p2QnFheE5CU3Zt?=
 =?utf-8?B?cGY0QVNnM25sMjFiZ2xVUXgyM2lDdXFQSkJRcUo3NnMzVGFXTCtHSUYrcjdR?=
 =?utf-8?B?NVlMYWpoSTVGdXhRNHFvcWpoclVoUlc4bytCeUJVbjVPZEpYeW16YXZwR1dF?=
 =?utf-8?B?WlYrUVdhK2lqM2tZemFXbXRUSjIvMTBxazhMY0U3ckNqdVRldE50WVN5T1Vv?=
 =?utf-8?B?b3JPU29IRmlYM3VOZGJ3eDJLOEgwQ3FoS2t0bmNpU1poOC8xRFBZMEY2RUNM?=
 =?utf-8?B?WDd1VzNpYWhzVEFEYlVSWml3N1BmUHZudjBXWUJQK0YvMWZISFlyM0QrYkJV?=
 =?utf-8?B?Y05jZnhVUGxKRTRMeGNxckErVW9BdjdTc1FDb2tneW9sM2Z6UVMva1NKMmdm?=
 =?utf-8?B?MWdHYkIrQzBjVmhBK0dhSERtbkZkMjlLZWZEQjkyLzFWU2h2Qm1jb2R6R2NG?=
 =?utf-8?B?bFo0cFp6WjBBSCt5WWZnTk1icDlkTklhTHcvcUkrbFpDUTJEQm15QThJSG8w?=
 =?utf-8?B?NWlOYU5rR3JYaTM4bVp0MzFEN2NidkRQQjJ1Mkx3ODJvUmZyTWg2bW1oVGJ0?=
 =?utf-8?B?dDQ1Smw4K2xZaTdMVy9WM3dWaERhOXczL01wektRazR1UVlPYUVOZ3NpWDFh?=
 =?utf-8?B?c2NNejkweTZEMi9xYm92cWNha2F4NTFpMkJEM0NTVUp2dDBtM1F2azZVcDEz?=
 =?utf-8?B?cjM3SzBNU3hMZFNGbnVRWlZCK05rMGtUK0hMQW9rZC9LKy9yQUtMRFFaaWQ0?=
 =?utf-8?B?MmRSVHRCRFhnQS9ybGJSOEJFNUh1dXF6SmhOdXN1MmZtbUNPZ25QYkk0Ty9o?=
 =?utf-8?B?bENzalJDSFZKcFluQ0ErT1cxMzFVNzlQWXU5SXllQXpLU1pJYWk4cmo0Tksx?=
 =?utf-8?B?V2hndVd3RkZFVnVFc0FWdzBYODFVaHE1Q0lZVjRFRlljMEpRejBLd0lIN1hF?=
 =?utf-8?B?MXk3R3NWYUhyTDNPRytjODdUNU5UU1VINmVocGI3OG91RTAxa3ZaYVNrOHdS?=
 =?utf-8?B?cmdXYzU4cjE3cG5vWnN5Z2VYMWNrMzJobmhDcEh4citreEZpRGtyRlJvcHFW?=
 =?utf-8?B?UkZCRUxRTjQ0MmgrVHErL0IwZ3pqMDIxQ29yTldLVWUrRHd6aVluMTY0RDJ1?=
 =?utf-8?B?NlQwVWh3eFl5RVZDUUJkRlNTOXVhMlgwTDFXRlVBK1FTY1IrUGdiRUU4WU95?=
 =?utf-8?B?VWZQT2FwK1M1eEMzQkRUYlBLeWJ4dGtLQWtlNFhYOEJzZVFwUmQ5dXVHZXlD?=
 =?utf-8?Q?POkYsNy5D/KvVdtQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af62badd-6660-48e6-6149-08de7b0ea6c0
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6559.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2026 23:26:39.2029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +NvRd8gJOJtGjOZVU1+MAYrTyxLSoVjj2Vi+UpL+nPfVjBbjfzjraKHWJPiFhXHaiCGmnQvcAn7e7zI34lwIwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8427
X-Stat-Signature: 5tp7qkmrco1rwmh9cd3die6xca5k5o7t
X-Rspam-User: 
X-Rspamd-Queue-Id: E25F012000C
X-Rspamd-Server: rspam12
X-HE-Tag: 1772753202-717147
X-HE-Meta: U2FsdGVkX1/b4a/0SXyKP2YIa3Epz1Wg9fBVNqvQU0O2zTheFt3gWGQ3vglWwVYrwwAQeyiEQykCAui2G1ZvQ0Xi9l+hIDnmEKydmKKE/qPhKLHFi4+SBI4oNg138z+1CMGyESEuQI+Zu/uv9VUJOrJF0QgRS9583DwDKIAXU3d9kAWLE+MhNGSvHgIrBVSKVbfGy6YuqcdX3zbUKv3QzkKSwza6k4u+8jqOKYYLX8Qk7KSvYl+/Fvgyit1t3uXouiLtte+jrfFtpNmRFgOnzo7F6smC+yhBtzD7V6P+HRFmFCmA+gNlq1oQDGmaYLs1NhoLdO0XA9jPfVQm/Me4hFfrKHeZIo8HQ/pLcTY68vMVDARHWjToBeFcPeg8ezRAr/Q2zHIDTOFYy6RPpwD/CBG2e8WRfQ2LdE4kEN/9DBbzS9J7+HdWDPSKndXSP6dx4B4kEId8I8m3Bc4Ip0km0fzUCdZ9qsUMpSTtM9fIL6i5GqDENu17qFWLNDpbgrrsYc32ASpA2qH5ZtDPdvzX4jaD3kHjCEzNM4ftkuLb/iZpeOe2mGDeKSJ21o18i+2HeyA7MFp1KTsSDOz3rbQJSg1yEMl4yP1pYufQLRcsnGuZgaJUPXk5+34n/ttuqDqe//W5LdliC/a8alayc6s8WW8p+w9TYKZ08sDX9pXO8wM+teE2GRr1Y15+RZPdmiiSM9i+pwhuLgaeQaiyImFSnSfSgAQt5+Fjho57wQcrGWxddgiJWasG/GXK2yf8FzzA+bWu2nPViWYGfyBjWWq/3qOgrR3pTdNTrBywJ/BhTdSV9grH7pVEQW82RANomPEEa6oGLGVgjAwkVa0przmg+rVLlrDzUaL2x3DHUHsj6XPZctUSs+ZOkgMExABwjEs18rTs+Zqyv/kcxN81uOv8gDcJMkdUE2bGuh0cpKDtI8dZnh0W4TO9Eh+yMp6BeYe9ynuaKvLuBHyWE1FXdPw
 NLpHRXQy
 ULnaPQFiDakmN4MBWldCd3hDfzzdZFEKOsFWn/9iU3Ou4T9ynK7hJCq/OqZADhX5bnTQrNvaVj3kJPCUb8pZoLCLXg/yfurcFME8S+zEmDVSccWAyonat+SKSbik24DSey2UPzrwoSztN05A/CVn9yfPI6Sr2D+8YdT976WBjm07tEkBc5fNfwqZkoWIT9FlcJpKoWZyXB1mF00s5MlxtEQDH2bWBIm88HDq/HWkvbnEvxhvMudhrqyI/xFdX2wefgzMV34UdzZBKodPZNi6w+OCBO5Ap62ceGutwzj2o3EjcY9Vx6YuiJgwx/4e3TFz4G9zIs0apXD9UwkHoix6EPqIbJz1g4nJzWwK2Wqm7z2oSt79CoDX0GV1Ew+El6tZawmGKHwbgHFV9irNlZNGSx/tP1qAYgbui/37TlkzVdiUzJWE/6KUXsKi1nd+xL0qGm2nyVpkBfVMLEjWC4Xi192gNr28pr+/2Rk2uBtaPoUuO/l1Vi+Q+sOd+CNYwe+Lscg5Q0kNNmPFw7suuo2muxkJOWnj6rkdJN80QF1nCaegrtoV1NPqxgCO49Exs7U+052BP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

contpte_ptep_set_access_flags() compared the gathered ptep_get() value
against the requested entry to detect no-ops. ptep_get() ORs AF/dirty
from all sub-PTEs in the CONT block, so a dirty sibling can make the
target appear already-dirty. When the gathered value matches entry, the
function returns 0 even though the target sub-PTE still has PTE_RDONLY
set in hardware.

For a CPU with FEAT_HAFDBS this gathered view is fine, since hardware may
set AF/dirty on any sub-PTE and CPU TLB behavior is effectively gathered
across the CONT range. But page-table walkers that evaluate each
descriptor individually (e.g. a CPU without DBM support, or an SMMU
without HTTU, or with HA/HD disabled in CD.TCR) can keep faulting on the
unchanged target sub-PTE, causing an infinite fault loop.

Gathering can therefore cause false no-ops when only a sibling has been
updated:
 - write faults: target still has PTE_RDONLY (needs PTE_RDONLY cleared)
 - read faults:  target still lacks PTE_AF

Fix by checking each sub-PTE against the requested AF/dirty/write state
(the same bits consumed by __ptep_set_access_flags()), using raw
per-PTE values rather than the gathered ptep_get() view, before
returning no-op. Keep using the raw target PTE for the write-bit unfold
decision.

Per Arm ARM (DDI 0487) D8.7.1 ("The Contiguous bit"), any sub-PTE in a CONT
range may become the effective cached translation and software must
maintain consistent attributes across the range.

Fixes: 4602e5757bcc ("arm64/mm: wire up PTE_CONT for user mappings")
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: stable@vger.kernel.org
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: James Houghton <jthoughton@google.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Piotr Jaroszynski <pjaroszynski@nvidia.com>
---
Changes in v2:
- Clarify commit message/comments: issue affects per-descriptor walkers
  (CPU without DBM support, or SMMU without HTTU / with HA/HD disabled).
- Clarify sub-PTE comparison semantics: use raw per-PTE values and match
  bits consumed by __ptep_set_access_flags() (AF, DIRTY, write permission).
- Add Reviewed-by/Tested-by trailers from the v1 thread.
---
 arch/arm64/mm/contpte.c | 53 +++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 49 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
index b929a455103f..1519d090d5ea 100644
--- a/arch/arm64/mm/contpte.c
+++ b/arch/arm64/mm/contpte.c
@@ -599,6 +599,27 @@ void contpte_clear_young_dirty_ptes(struct vm_area_struct *vma,
 }
 EXPORT_SYMBOL_GPL(contpte_clear_young_dirty_ptes);
 
+static bool contpte_all_subptes_match_access_flags(pte_t *ptep, pte_t entry)
+{
+	pte_t *cont_ptep = contpte_align_down(ptep);
+	/*
+	 * PFNs differ per sub-PTE. Match only bits consumed by
+	 * __ptep_set_access_flags(): AF, DIRTY and write permission.
+	 */
+	const pteval_t cmp_mask = PTE_RDONLY | PTE_AF | PTE_WRITE | PTE_DIRTY;
+	pteval_t entry_cmp = pte_val(entry) & cmp_mask;
+	int i;
+
+	for (i = 0; i < CONT_PTES; i++) {
+		pteval_t pte_cmp = pte_val(__ptep_get(cont_ptep + i)) & cmp_mask;
+
+		if (pte_cmp != entry_cmp)
+			return false;
+	}
+
+	return true;
+}
+
 int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
 					unsigned long addr, pte_t *ptep,
 					pte_t entry, int dirty)
@@ -608,13 +629,37 @@ int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
 	int i;
 
 	/*
-	 * Gather the access/dirty bits for the contiguous range. If nothing has
-	 * changed, its a noop.
+	 * Check whether all sub-PTEs in the CONT block already match the
+	 * requested access flags/write permission, using raw per-PTE values
+	 * rather than the gathered ptep_get() view.
+	 *
+	 * __ptep_set_access_flags() can update AF, dirty and write
+	 * permission, but only to make the mapping more permissive.
+	 *
+	 * ptep_get() gathers AF/dirty state across the whole CONT block,
+	 * which is correct for a CPU with FEAT_HAFDBS. But page-table
+	 * walkers that evaluate each descriptor individually (e.g. a CPU
+	 * without DBM support, or an SMMU without HTTU, or with HA/HD
+	 * disabled in CD.TCR) can keep faulting on the target sub-PTE if
+	 * only a sibling has been updated. Gathering can therefore cause
+	 * false no-ops when only a sibling has been updated:
+	 *  - write faults: target still has PTE_RDONLY (needs PTE_RDONLY cleared)
+	 *  - read faults:  target still lacks PTE_AF
+	 *
+	 * Per Arm ARM (DDI 0487) D8.7.1, any sub-PTE in a CONT range may
+	 * become the effective cached translation, so all entries must have
+	 * consistent attributes. Check the full CONT block before returning
+	 * no-op, and when any sub-PTE mismatches, proceed to update the whole
+	 * range.
 	 */
-	orig_pte = pte_mknoncont(ptep_get(ptep));
-	if (pte_val(orig_pte) == pte_val(entry))
+	if (contpte_all_subptes_match_access_flags(ptep, entry))
 		return 0;
 
+	/*
+	 * Use raw target pte (not gathered) for write-bit unfold decision.
+	 */
+	orig_pte = pte_mknoncont(__ptep_get(ptep));
+
 	/*
 	 * We can fix up access/dirty bits without having to unfold the contig
 	 * range. But if the write bit is changing, we must unfold.

---
base-commit: c107785c7e8dbabd1c18301a1c362544b5786282
change-id: 20260305-contpte-fault-loop-76ed911b01c0

Best regards,
-- 
Piotr Jaroszynski <pjaroszynski@nvidia.com>


