Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 562BEE909A5
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 13:56:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85C596B0089; Tue, 17 Feb 2026 08:56:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F9626B008A; Tue, 17 Feb 2026 08:56:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B3FA6B008C; Tue, 17 Feb 2026 08:56:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 594F86B0089
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 08:56:32 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 164E8139436
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 13:56:32 +0000 (UTC)
X-FDA: 84454098624.18.D32D50C
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013055.outbound.protection.outlook.com [40.107.201.55])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1CD571A0002
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 13:56:28 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=LpXYWGpj;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf19.hostedemail.com: domain of Thomas.Lendacky@amd.com designates 40.107.201.55 as permitted sender) smtp.mailfrom=Thomas.Lendacky@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771336589; a=rsa-sha256;
	cv=pass;
	b=S4G0HcprMC3UQJUp4+4h4MJjVAOlIjmQiqAtffpuHbaOcd1ARkuzv5hNPwKgh0G6i7VId7
	uQfGzBd2JCJStc1rn/QDX5pVd8XMV6qWTjmZc1VMfrG3aIQLtLo91sy82rtmuVi+mi6bnl
	kLj+aWcWDszue7WY8ss2ZNXH39NweV8=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=LpXYWGpj;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf19.hostedemail.com: domain of Thomas.Lendacky@amd.com designates 40.107.201.55 as permitted sender) smtp.mailfrom=Thomas.Lendacky@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771336589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=imn0SAM5Yc9kYf64kbvrZB8UuSQadRH0OmoS3KyPatw=;
	b=qDYEB3MqjPTfN4D5gdiSeb0XHqyaiNpsPb/FNRNTMXGgluqaRfEXs+xcNx7CsRTDkMaG90
	cuvNmHZQ85RZkLTuxj+PRXsbLp0h2sAagvDDkPyGMF23xCCe+iVN4z0s7ELMvESS0jqppT
	/H+uG2wvWw4nWfYNrSP38P23XU5Gtvo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aJHqfMShU2324wTRwvEwj8x4sSzSNaKx7R/mZ1PCFNTOwokeUAxwTt2DsYo+rsrarGyAmzGhoFnV8jFjY/NdJZLDq+UJFZC4XWXD2OlBR4XLx4O+WYz7TkEIUxEzSTxEZ4v71Lnkwuij1SLERsM77+HEB7n9X4sD/VB69trbj2AIIQmN/xpDrrZKbnwIx9sJEeu1JxVZgt1PNFYSsTIS4pYXQr0QP/PTC8Cbwo0hTnlXrm7WoIaqM6YXKGoATHgI8HcLiIDXAJBrAjO5HGFP+1FBtpvbpvsyG3sp3LDHdgkC60leG6GOzceWwjAWS0G6+M2lAWPWJ+3aieishOPcGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=imn0SAM5Yc9kYf64kbvrZB8UuSQadRH0OmoS3KyPatw=;
 b=JSiJYHs6xEtyMqIG5n/8S8vqKCdkGSwAzcg1BDCckHH/h9ifvHZiIiEW3tpZI08Pz3WysEMiDFz68IdDOo/dAW4qQa0/DxyJMQ9fRihRu57ZLclqEptl7tQy3tUa2tSnSYu+YLGX135s3mqhaum+hGgjndEJc5tpvP6f6X7MS169834PSOdR5F7rsGYpXZtgC/6lreGbEdoZP6xcU55iAuhb5hjn6kThqxLmq3SW/OU/YDG4KjpdZ2zgDXDHIzoLKsbR63juOTGZySsHtbJ5kqJbT1qGNHdsB6koiVuljlMDxQATbW1Q9Uy908MylChiWtV2XJOZIhyW0ySiM3cq4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=imn0SAM5Yc9kYf64kbvrZB8UuSQadRH0OmoS3KyPatw=;
 b=LpXYWGpjn5fAxKbZTYQlP40G9DAs/+ABHuprynAe2Cs5WjmzhCk1gwi2xUPRf+Vmeru11LoAqndYcGw5uIjE2wP6CU4WqaveEXswsD3MM00yCN9eEc+akIIKnv3ci1IZSQbobTXc7Pqi7YX1PMt9iWCafJKVCOcjKk/ThGB0CZ0=
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DM4PR12MB7767.namprd12.prod.outlook.com (2603:10b6:8:100::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Tue, 17 Feb
 2026 13:56:23 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9632.010; Tue, 17 Feb 2026
 13:56:23 +0000
Message-ID: <a45b19ed-149d-434a-ac80-4ea74a2e0f10@amd.com>
Date: Tue, 17 Feb 2026 07:56:04 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2 0/2] efi: Fix alignenment issues in unaccepted memory
 code
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org, linux-efi@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Moritz Sanft <ms@edgeless.systems>,
 Mike Rapoport <rppt@kernel.org>
References: <20260217104957.249340-1-kas@kernel.org>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260217104957.249340-1-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR05CA0012.namprd05.prod.outlook.com
 (2603:10b6:806:2d2::16) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DM4PR12MB7767:EE_
X-MS-Office365-Filtering-Correlation-Id: 4307619a-fb8a-44fa-9722-08de6e2c55ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bmpJN1pwMk0xUTh3TDZ4TjBDcjFHN2tUTXNwN0xZaTI4eUpqSUxTaG1aQUxj?=
 =?utf-8?B?Snp1Ny9PNndTYmUzdFlxUXUzUlk4RzRGWWd5Y0RzWk5udnNRbG05KzYrR09z?=
 =?utf-8?B?eVZyZGhZQ2dCNDhmRDJrKzZ1QTkwQ1kxTGpCUGZtajNCMjBvMmhSai9YeGtC?=
 =?utf-8?B?a3pWTzg0WXBpeG9LZnduaHBGcGIrdkZ4aGdzTUpmL2ZhQVQrUllscHVZVlcw?=
 =?utf-8?B?L1NYSjdsTGNad01zUks4MG1id0lEV21NUHYwTSthcFJRSE9FVTVFRzJMZGlx?=
 =?utf-8?B?M2loalBYQVlVODhkdmdZZGRZd1hDZG8vOWgwbWRwWkhyVTNqL3ZJOFJoaXUx?=
 =?utf-8?B?Uk5rNHR4clJBMEkrZVc0czJZZXZvT3U4cnFmbDlZYnJHOXN4dzB5S2FRRHNa?=
 =?utf-8?B?WCtORFl1UXZOV3NzVWlCOFhsUE1WdFQ3em42YzRVQVNxOS9BQU1NKzZhRWd6?=
 =?utf-8?B?ZTRMbVdBSzJVNi8wTlNCdmswR2d6ckVnZUFZRnFuQ1FIeTM5YzNKNUVlcnZJ?=
 =?utf-8?B?cnMycTdoUlI4T0l1Si81aGRTNk1vWnNxeXBFb3pvMnVORE1zcWM4Mk4rZ1Zm?=
 =?utf-8?B?azNRcWlvbEJtcjhHbHY2Uzg4eHRXWTZ0WEFkRmpFcVIzNUJNL2w2UEduR2Vj?=
 =?utf-8?B?NGZSUG00b0hFSmZQeHlTZVRtNkI5WXJJZ0ZqaC9UVFdVUFNrQno3SE9GRzFq?=
 =?utf-8?B?RXYyKzNWK0VTMGRiKzREbDZEZzFWUXhVdytPQTRsM25vS2p6U3REQmw3OWFY?=
 =?utf-8?B?WWpqaHYxaGdzMTlaNW5reUd5WGhVTDB1U2xHSW41c0VtTzAzZi8zZk1wVGxq?=
 =?utf-8?B?WUlaSlZaWStHODFmZlNkeGRPRXh4ZllldTJZWk5WTkFXbHhSOVJNdkJoOUdQ?=
 =?utf-8?B?MDRkYmNURzEyWTlhTlRRb1pGeFRsTXJpY25qLzFTeXRoSExyNWxaKzRMQ0Vl?=
 =?utf-8?B?SkFkbHI5c1c3UG5ZK1RGeStHWE5xSW43VXBEdzV6Z05ZTFlvMVJVNi9mT0Yv?=
 =?utf-8?B?VTFFcjNUeXVDNHV0elZMTXo0dG45N0V0R01Rb0F3WVFKWVF1b0FlU0VPUEVF?=
 =?utf-8?B?NjZFYVlBRVF2NG9YZEpYVEtUMkZBNzQwZU1kUERKbTRJQVIvSWU2SUZET2Q2?=
 =?utf-8?B?WXFub1FCSDg4blkvcTRVL2laVnFNOEVJMWd4N0EvaFZzZktobGdRMWt6UDZ3?=
 =?utf-8?B?N3hCU2R5VmJBMnZsZGo0VWhTSGNTeG5JL29tQnYwOUNTaXZTQ3ZVMmtCa0JE?=
 =?utf-8?B?VjZ1bHlGVGFiUFJhN20wQkg0WGhrN3JURDhjazFERldOSjRJcFRXVlhYb2JH?=
 =?utf-8?B?Uncrd0o1VWhmUWp6MU9JVjY2VElyTk0xWXcxQmVDZnVMVUVUbDZCbHRvVkVU?=
 =?utf-8?B?a2luZDQ1blRwSGQzTGl1VEVzaGhTTWY4cnJiZEIvZXBucjV4YkkxM3EyY0cr?=
 =?utf-8?B?aVI0UkplV0pFQ1ljVGV1eXRqWC95bW9aV05BbFlsMVJ0SXBwcUdnYjZkbzRK?=
 =?utf-8?B?SGRqRzdCNm14VFlCdUs0bVp5dU5jcFN1UExxOXg0Z3ArWHZ3Z0diaEJubG9Y?=
 =?utf-8?B?dW54eTBkbHNrNm50b0wxRDQ4VDM1REErQkdTZEF2NzRKS1J3c3p4c2ptajF5?=
 =?utf-8?B?NnoxZnFvRFB3UllVMnpzNVloQlZ1dThkVGtDWkJwVUJnazBhc3RaYWg2dEgz?=
 =?utf-8?B?Szc5RlgvUGpPS0tnTFhyaHBEU21DV0VsTlBSQzNWU3AvNXFhNlhyOEVWWTlQ?=
 =?utf-8?B?UjVWQkZ5Qmp4V1Jsdy9HcG9rTExlNkU0L242RDViQ05wcDBJTnV0d3hxK3lk?=
 =?utf-8?B?dCs3c0g2NUErbHVrejFqQzJtS0JibEQ5SGNNeHlvVEhYVWhoM25YZ1VGQ3M3?=
 =?utf-8?B?ZVYvRzRCOVlHUTZkcUxCWnFFeGJLM3BNblVmSDVHVndHZEQwRDR5TWcwWlkr?=
 =?utf-8?B?bnZlRmF0QWVJbHUzbFlLUVFsa25xMWRBbG9VSVlHUHh6b0NQeXkyK3hyQTEz?=
 =?utf-8?B?UTNOaW5OZjRCTVJTU1ovSkZyaEJvaE9XbFZCQTg5TGlrNmdKVVJGUC8wZ3Ja?=
 =?utf-8?B?cFhEOUk2WUNGU0VVK3lCVEF6SGl2aWVVRE5sd3Z0U0QwSlRXOUw4SVZvbUFT?=
 =?utf-8?Q?rKRs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VUVTZlFaaSt5dHBDMEVBRHdoRHF4VTRnbW5TZEpjdWJTVkNhRUhleWJHSE9T?=
 =?utf-8?B?OWxoQVY3bTZRTW1VcnVCTW5zL2ttVDA0K0UxUks0aWlGcGJJNlQ3WStXVjdh?=
 =?utf-8?B?cXlQSVlhYVZySHZzWlZHVzB3UnJTTXE1QlRKcHdUSHVFbUhha2xKUFVJUlFN?=
 =?utf-8?B?TGdNbmwyakdia1daOXRDc2ppdGYwWkltaU4vVm83c3VYeUNmUXNGMlh4elVY?=
 =?utf-8?B?OEM3NnNpaG1kRWFxdXlZQUsrdmRzYmFMOU9qeWxxMEl5ZEdRZFVtNGFralBD?=
 =?utf-8?B?UjB3ajB2VURRQW9UK2RaaXRRbEhaa0F4bWlJYkoyUXpyWWsrMlpnTkNHOThY?=
 =?utf-8?B?bnc4d3Y4aGRJV3prc3ZrUWk5MTR1VUwyeFZPbzlzY09EZUozbGFhUVZpV2VO?=
 =?utf-8?B?dStxRDYrNHJuWXZsQVhlYjFxb3A2bzhPSTZOUEpwZTdpNk9CemV6Q3cxWmo1?=
 =?utf-8?B?aml6b2w3RU5OblNnV1RUeFVnRllrUUhEKzIxbDdPVCs5OVBmKzU0Mnd5dG0x?=
 =?utf-8?B?TjFhQ05jeEpFUVY1THJOZGUxWXlGb2xqMEJEczNZbXBIRnE3TGhrVGxNcGpk?=
 =?utf-8?B?NXBkSkxxR0UzeU5JMWZLNTlmOFBEbmpaa2FFWjJtNURnbFdJRUlBODVUK1gr?=
 =?utf-8?B?WDJxTXo0UWFJT2EvSDE5N1FqdjNuNitCOVFiR3oxSVZJTTdJUkRQa1Z4TWIv?=
 =?utf-8?B?WU5UTUZVdGFudmk1aW9WN0J2eGMxYStWekE2Y3dEa1FxY1RDWEYxbk9kQ2ZJ?=
 =?utf-8?B?RFlsR2RrU0hmeDNUQXVBNUl0OTBETlhxWno2T1FhZ3dQdSsxdXFKS284bnV3?=
 =?utf-8?B?SWE1UDAzWjBJSE9pRXVBOHFRNTk1aDdrb2gyN20wUjY3cXNqY3ozR0w1MFps?=
 =?utf-8?B?Wk5xQ0JFbVAvQTNLTXp6ckppbXdLTWRFcHlIeU81aFM0S2lxV0poTW1CQUhM?=
 =?utf-8?B?Zll6VmhMVkNkdUNMT09oUXkxR1lkclJqZE5yOXVXRVVJNUYvVlR6eDZBRWlO?=
 =?utf-8?B?UkdsMWRGMmJZYlVycTZ6MFhEN1RHOVlMbURnVEpZL3ArOXdyRjl0QkVkbVNa?=
 =?utf-8?B?cEFGbWR1OUFiTTdPYmovb0NWWjhZN2JxUUV1Z0pia2tkZlJzL0RpSjVBWDVE?=
 =?utf-8?B?L0JVc2RJaytkdld5dFo2SnVZaVkrMGNoMWZhU1M1SzNZa2xOQmo2dDRmY2lY?=
 =?utf-8?B?SGlJQWZiSVBTUndlUTlpWGxMS0ZrK0N1c3g1WTBNMTJDMXdvWFhYZTJDejB5?=
 =?utf-8?B?YU5CdjNBa2xlM0pHMG1qZEFWQzF1Zm1lOXJLKytFQXMrSnV4dXZKZm5pU2Fy?=
 =?utf-8?B?YXR6VVZQSzlCb2ZSR0lFMHRjUmtSNHRyanFtVUFKOUxON1BnNG5CbEVQeC95?=
 =?utf-8?B?TFJlZ1BRNHF5VFk3REZ4OForZW9kSVQwZTZmRHRlZEo3RnJDVm93RkNyWHdq?=
 =?utf-8?B?M2FEZmR3QmNNZFFic2trdXZaU3VGZFJZMTMvZnczcGJJdXEwaitLREZqcEsy?=
 =?utf-8?B?bkJ3d0lrWGFtU1BoNWk5MDFZaTNUVktSNWdacS9sUVE3d2g5Z2N0OUhkdVU2?=
 =?utf-8?B?YVhBdXpyTi9KYlRiRzQxL1pIQmtheUE4UjAvaVFlMnZwSm9tT3lrSUNXdWRy?=
 =?utf-8?B?UmEzTlI1ZXB1bEZ4SEJPYk9FekJHR3NPV1hxc1gvQkppZDN4d3BkR1d3OWxt?=
 =?utf-8?B?dTdKZUpVTlFkOUFRdTFwanR2amRMYkVLcVpuR0xaMDRhSEhXK0tFVzZqU2ww?=
 =?utf-8?B?QVd0bFZqRlZ0RXFLMzh2WmwyWWtBajRSVmpaTUQ0dWVrcGN5ajlmMC9OOFhH?=
 =?utf-8?B?QVA2ZFVKSVl5VEF0OWszMFVuL1ZEa2R3WVgyN2Y0WElPWW1FUjhucHZobExh?=
 =?utf-8?B?OGNGTVRhRjNrdVZtNzdXVi9HNFJxalBnVjhHRGdRczVJTUxQcnljLzgyYU9E?=
 =?utf-8?B?R1BRbjhvcXdlcXYxRlJrc2xROU1HeEduaFNFT0tHdCtQVmNmM0JUcUl5SXJh?=
 =?utf-8?B?SkJYSHk5cUd0dGNweEkxRzgwSSsvTzB4TGl3TGRCRzcybmljbXRMeUd0TzhF?=
 =?utf-8?B?STJacFgrTVdnalp6MzBLMFZCSzZBM0tTdE5BUE8vNktIQmo5anJobW0rem9N?=
 =?utf-8?B?VFk2djVMUEYxcWpKSkpwS25GcFR5UTVBNGViczJINUxOUXIyM2w5THM3NEV6?=
 =?utf-8?B?cE51NG9ZN0xlTWJjUkI1T2c4SEFxMzRaMTYyVjhTNFlMVWtpQitOS2VYb1Iw?=
 =?utf-8?B?SThsR2NSL0VTUFRNdzlCUmpyS0tieDVpcWx5b2FpRnpjMklSSE1pc1RvTTds?=
 =?utf-8?Q?Ll2O3JoOYcfxVhrljz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4307619a-fb8a-44fa-9722-08de6e2c55ff
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2026 13:56:23.5799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O/2cwdRnNJmZQjyXBuihGVF0TxEb5oNxiCTCaNoXlnz8h61xS/i1kVwXP1+ghXAJRNffKHAbPQyJwLDnjetqwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7767
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1CD571A0002
X-Stat-Signature: 5mkrnihc9q5y7fwithfh6iywr6ab7ztx
X-HE-Tag: 1771336588-466718
X-HE-Meta: U2FsdGVkX19VZuK0F+QPoXVqID7X85mhqVI/UzoB2vD2mXSPHZ+7lfQ6i/WI3Q/0R/H62H4MnqQh+IsUWLGvWD6qwAID7AmbGebdKuyCDVVWchcrTHjarUuk+XQFM+s1MlS2O4qnkRQ5Y/ts3NMWrTrFbLQ1sEcbEljRcbN4uf3w+CmvGWTkIYrbzj8wZt6f9S3LnXjXA7YeVrnk8ehdpAGFCnMrddhLI41jVwoLkheRoi25I+ePrPvXz4Slb/EzYm2ovw/svjc0MVsA2U8w2pu18+1+WMF6lV7oOWlMS4vfZC8d+CBYz/l/nacxGBXqrw0UCVO1cANwQ4sGX/xBmu7+2l6x7BMmcpwg5A63Ewt8pm5iV3J8czR0QsNxGRzPmTplvSs/FUXRzlI2YN1FYH1Zi7BYFlFRxd54XTG+xayUuTJSYYzJ0Kt+NfRUkO7xPA2PRHKkvUkzZWSxFUU7nLI10uPC9BUdhdwHXWtfx+LP3gY8mCtJ7JS7b44kJgQP4tCJsVVBy6We7X+njUSarywex504petMet5rE51N9XJfyTMr3/F03xpF0V7jFfaOl7MsnHRV0NY+VNNPdNZ/5kwetwm0taoryXRDuMCSm8fHtZ4GU+OJM2HO/m1d0+yynAqoLuHTMXPJ7Xng3C0AvrOkNaoPYZfa++xboN9oAxW83bcV6gr+T9W738Ew5354M24+K3aIQDG7yRGisXiaNvPeALnhSqIW+UQfKKCEoLVdzsaKvcobmlMvLmVyrR+MLjv0HBqrbAS5mEUg4dmZObMPIo97X39IC07AZwkwCvamEZv+n4jpI4xVnLR3okrsVNSoG04EM4uOTUKA/clBnL+roC5pJgq45vwhERxCQWpYQKa0Ljq86/qXGlSSH2yC3ZYEMLpaSawtHsNyW1/ktFw8Im4IMKSO5JE/PUQ1lcXRBbp0Wq47NNgzCkIK9XugyJKOhyppVZ+sXZZO7hA
 OU5wcX/t
 p/MfujM/V33Hme7HlQzDLg/vF9CPFm0acNccP9lbDaKLk5Fb5+DlRuKPV/eFAzOFp8q+ahwGJ4qia60VtkS3xggYV004zUEAnqEIO9ylvr7jgx3gyv1NxC3QigGqs/roEyAtS5SUvdEoq1xxsmmOrp74cUh7sEebGaffVgzVJttKIY2i0KuQ78AhSx+N+mEEr0W7T9X/RszJNbGYE03Y6dwc23DXxD8qaqwFHkjOKzN7stW5GcR4ukrI2sORvSHB2lmPtwz6OhMKaIRdV6LrXySx94wToVoiThjkXz9MLDNGX8rJO2pdZIXR5F6+4LeUwXaWRrNCDSBu/mR/ZaHHMUDmg0bp3giAhOCWMh0fcuGNURmO+wLNRUl1TYnKlUyMnLrIQe/dnZe0KgtyVs/ZN+t8o4FEv/uOzk8AmG1uD1aUriIml7i/pAgiHDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/17/26 04:49, Kiryl Shutsemau (Meta) wrote:
> This series addresses two issues related to unaligned physical addresses
> and sizes when handling EFI unaccepted memory. These issues were
> identified as potential sources of kernel panics in Intel TDX
> environments due to incomplete memory reservation or missing "guard page"
> extensions.
> 
> The first patch fixes the reservation of the unaccepted memory table
> itself in efi_config_parse_tables(). It ensures the entire page range
> covering the table is reserved even if the table doesn't start on a
> page boundary.
> 
> The second patch ensures that memory acceptance requests in
> accept_memory() and range_contains_unaccepted_memory() are page-aligned
> before performing the unit_size alignment check. This prevents skipping
> the necessary "guard page" extension for unaligned ranges, which is
> required to avoid crashes with load_unaligned_zeropad().
> 
> v2:
>  - Fix 'end' calculation in the second patch (Tom)
> 
> Kiryl Shutsemau (Meta) (2):
>   efi: Fix reservation of unaccepted memory table
>   efi: Align unaccepted memory range to page boundary
> 
>  drivers/firmware/efi/efi.c               |  8 ++++----
>  drivers/firmware/efi/unaccepted_memory.c | 10 ++++++++--
>  2 files changed, 12 insertions(+), 6 deletions(-)

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> 


