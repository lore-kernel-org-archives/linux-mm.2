Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0B75F4BB60
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 17:17:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1837F6B0088; Tue, 24 Feb 2026 12:17:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12D3B6B0089; Tue, 24 Feb 2026 12:17:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F29D46B008A; Tue, 24 Feb 2026 12:17:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E005A6B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 12:17:35 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8E4918978F
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:17:35 +0000 (UTC)
X-FDA: 84480006870.14.B49BB8C
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013047.outbound.protection.outlook.com [40.93.196.47])
	by imf10.hostedemail.com (Postfix) with ESMTP id D0796C0009
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:17:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KnAjfZe2;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.47 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771953452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uvfjp38n/FdC5fXRhGJKHM8e25Ollxx5cKJMGTpTias=;
	b=JWOR+fmi8XzNB/QDpOW3LFPvfnfHQ7X6yE110Obl6bprHu1SYHWUCSdtgwP6IDFjmAnILj
	OqAi4iulT8YyUFFfbaBHY1isVCXucNo/Y5XX/MKpkmWzDtA+1PsSDTQD4MletVWOjGx3Id
	Vui4o+8ElImIOKRrGeuit70Jnk9QjOQ=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KnAjfZe2;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.47 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771953452; a=rsa-sha256;
	cv=pass;
	b=o4SKFuBxkgQg6PhXOWRjx9CbXniV/ctTXALa8q0j5JWhGMpofabNJRfS0yI/hoilVefSTt
	4NmM5KDebmdS8OT3fryFqtigoANg8liZ5lhVs95247F2CJq1KtUasz8HPFJ7jIDSkMYGue
	wXF9G7JlaKZapgOruYcRbiJf6QV3nWI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rsJ221TMYt/IplAC1MEqyq1XtIeiTkdT+biQBPzc4QmnER9SvpgJAZDAKc9DsDGGrI4nT5kf3RhfDQep7SPt2nKWBVd8Pqe+ANnpn9bcaRr74Ut7N0VBMTs7nYEFdYOeo/r3QMuGH+faDplgKlZcuLbCjdlP3SdUmxW7os6iUg9emLDKE3d7qECHyULX7KlqGQTa1TUEc8uBB/JFrLXUlj19KrDkXGXDSvSBAhx1pRGKKHn5um5MtZ8VvmhSs3x6i7tD7I72bgSAI3VIeFiCWyCLmfOFhl6j/H+oCfeiSvX5bd0yja08nbj3p1OpcY/2XOIAs4uXbipLcwjM0fSW+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uvfjp38n/FdC5fXRhGJKHM8e25Ollxx5cKJMGTpTias=;
 b=k9d//PnfPuASD+j1HTGGjcMkDsgBdC7gBXbtzk2sxlq7NgcKJGNnAzJpsQe9qPUz/WBUz0ymoehLkS//a/FT+BrzB97dwSKc1+HTPLoN4dYo/02NbfWLXIN/AewhoaSv+U1MLGdILB4IVzW+he74wCTOwKBPcOZe33i6GrUufSoDaQnQi77vPezY/FwsJhrIwyRyYnHRv/PNYAda1Mw3kPNPt1gZuiFCjYEq6ep54gvKigNque5XDHUH9b8lD7sna697CzSx97I4L4TW7lgmtzlmx/us73uU2aSw6dLDOmOSmlXilqZOrC2kHUwAoJ09Wy/UM3p1d9wdBvToUA2wog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uvfjp38n/FdC5fXRhGJKHM8e25Ollxx5cKJMGTpTias=;
 b=KnAjfZe23Y5l6oMN+4TkcNBCOzntO6bhMCi+5oJzPhst5N0NdVB1dTEVnxtccpDMxhcgeHHpA/ZSADAR6/zLUdwdK8Zlwvsm4n0u95NnNIJjcBuHCjumlHbEiCw5inbcgz6Q7NEt7P+EhAuRrVw1ZTLbsrgYtboKDWoD5kYEDqlC0dSNyYaznCEZ8U01ALfLX93kM/GdPNrdwMAAU6lS0lXThJt+l7IwoI/xmcT0JsOlDALc3skyRM78kUvqbxn8c9F0T4QnM+/knytZE8WRo1Bb7E9rh16qadJx+LM3hIAXDrbp/bmdeyGV43IF3mBTSSn9A5gW1NqmZx9xKqmeog==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY8PR12MB7097.namprd12.prod.outlook.com (2603:10b6:930:51::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.21; Tue, 24 Feb 2026 17:17:26 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 17:17:26 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Ron Economos <re@w6rz.net>, wangkefeng.wang@huawei.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, jackmanb@google.com, jane.chu@oracle.com,
 hannes@cmpxchg.org, willy@infradead.org, muchun.song@linux.dev,
 osalvador@suse.de, sidhartha.kumar@oracle.com, vbabka@suse.cz,
 claudiu.beznea.uj@bp.renesas.com, Mark Brown <broonie@kernel.org>,
 akpm@linux-foundation.org, pjw@kernel.org
Subject: Re: mm: Regression with v7.0-rc1 on RISC-V
Date: Tue, 24 Feb 2026 12:17:20 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <1AB3E96B-F4CA-4B00-9078-2AC20A1A60DC@nvidia.com>
In-Reply-To: <78D36EC1-2596-448A-A939-0A1AC7B3D1BC@nvidia.com>
References: <1b17c38f-30d3-4bb4-a7e1-e74b19ada885@w6rz.net>
 <13b8d60d-1209-4650-9fa5-982381c53512@kernel.org>
 <1966378802.577797.1771952827516@app.mailbox.org>
 <78D36EC1-2596-448A-A939-0A1AC7B3D1BC@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BY3PR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:a03:217::9) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY8PR12MB7097:EE_
X-MS-Office365-Filtering-Correlation-Id: 3816b643-4ac7-40d5-43af-08de73c894d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T0U3NVNmYVFrME1QcW41S0dFRk5UNHZURDg0RXU2N3hUSWZtYkhWZkUrYnU3?=
 =?utf-8?B?bVJSNUo0UkJkVTVCRkIwVlBxT2h5YW16eVoxenFyYmlDeERhUzNudzgxUTVy?=
 =?utf-8?B?cVd2SC9lZDQzK1Q2Y1dJSXFjalFIYWF4dnFxWkxKcnFjSWU5L1phU1dGNXZU?=
 =?utf-8?B?Zk1OZGNrMms1cWk3Zmd2U3p5NlZDRHZ0U0t3ZkVFYjNDRmtPRTFDZy9IeEdp?=
 =?utf-8?B?MWZrVjhCWDBsMVpRckR4OE1BM2hkaWlHL253dnV0aXRTcUN3ZFRnNUVYZ1py?=
 =?utf-8?B?Z2J4RVI2R2EzSHJkRDBsZDZOYlc3QkJPM3Y5UFErVS9kNkY4RjV4SXVaa1BS?=
 =?utf-8?B?REtLQXN4dm9WQkJJWEhJWCtYUDFXclpKNENQNXU2Nk1malNySmZUaThLeHU3?=
 =?utf-8?B?UlRib09NNEI5ZmdYN2NkemhSNFFOSTNUNkV6cG9VRHR3a1VYZ3pRU016Rk1I?=
 =?utf-8?B?MWpQa0NEb25ianJ5RGNnVnlzWlNBZXlBV2g5VkVjSEhxVzgyWGZKb0JJUGdz?=
 =?utf-8?B?S3pZcFdyUDdKM2pVdjJvZ2VJNjVibUZPNjZlWXRDdE9UbTFCQ1o0a3luVEY1?=
 =?utf-8?B?blRBRFlJVEp2Lzdmd2V4NkRMUHh1dWQ5UEQrbkk2emFzWjBKUXFOSWZhRWl3?=
 =?utf-8?B?Y1V4NGI0UWM3TTZzdjdBRkZOMjhTRHpWVkoxWHpsNjBvRXNwblhKclZEVDVy?=
 =?utf-8?B?RmhhZXpoeVJmV3lvbDZyaFVlN2tNaDJQTHZDcDZyZHpDQUNWNk9hRkpzcG5X?=
 =?utf-8?B?T1hlWGNBa3JISGNWYlJvM09XNXQzY0xoblY1US90QzlZVnA2V3l3TjdVZk8z?=
 =?utf-8?B?ZndLNDJRMjd1dXVEZTNxcjNhT2ZhQ1c2Y0sxWVZwd2NHeVJ5cXUrS2gyaVlU?=
 =?utf-8?B?STQxOWhXWm9sYkNkU1FCZ1Fqc1IzZVJsMnhWSnJiaUhoY2k0bXlJTHhERUNl?=
 =?utf-8?B?U2VtWGlncXRJeEJnQktST1ZXWnQvV3B4bG0wMEd3WlFHbzBVYWNJUEpTamZU?=
 =?utf-8?B?NFNLeGJJeFBUQUNMV2ZSeVZ0S0NDVEV1NE0wQ2pEYTU5QzhnTnZmN0paMTR4?=
 =?utf-8?B?bmdaYWFBWDFaTHdzRmhsZHp3Rm9MUzM3SlhUcVZyY2RrRE8rU2FKZU1XSFJ5?=
 =?utf-8?B?TGNmTmZPR2NOTE9hNTRBYlR3MWhLcUlJTHltMWU5YjQ3Wm9BU2JBWXRUMy9K?=
 =?utf-8?B?NENqK05WdVhxSkRMWVN6NkcrZ0pKZ2w3UWNiR2ZITXl0SEZ2S1QzMVFpZk5O?=
 =?utf-8?B?S2lKRnZYQW02S1ptcTNEWUM4dWhReU05UDU5M2N3MEhjb043cGUrMFpacVR5?=
 =?utf-8?B?WHVvRzE5ODdFb2dxM085RGZ3R2NZS1RxL2xLd0xLTG9pTFprWWlQRWI0L2tj?=
 =?utf-8?B?TGVhWWFad1RPRUdrUEtKaWZCdTJETEkwUkk0a3NUU0tQVDlwb2NlMDcyQ3lI?=
 =?utf-8?B?S2R2YjFtYnN0OFhXOXJLT1ZUdXJvRnV2anp2WndsT1cxQUI1VmtNYlcwTTE1?=
 =?utf-8?B?aml2aGt2bmpTS2l4dVEzTkVKZ1M0WndZTmJmTHBPUlU0d3JONWJpRWJhNEdv?=
 =?utf-8?B?bm0ybTlmU044Q2x4L1FUK3VJdmgycnFaZHp3bTdNZmFDOXQzVnZFZG1rV3JK?=
 =?utf-8?B?OEJsc1JJNXVQVEJQVWIyM09hQVgveVczK1piVGxkdkVMYmNKcWZmLzVLL3pB?=
 =?utf-8?B?VkdqV3NXaVdhQUFJYzdGejI2cEN3dStLNkJCN2dUeEtSakNBZ0dTVGZ2aE1W?=
 =?utf-8?B?ZDBLQ1ZIRmFXVGprRjlmVURFektpdkV1dnEwKzB5L2JucWFSQm1ETUlUZnFz?=
 =?utf-8?B?ZjlyOEQ1N2prVlZFRzZnRTFpMnlMbzVQTXBrTWhzYnpNNTFjTERnYzVtOG1w?=
 =?utf-8?B?ZlIveXQzZU00a2NyRXVabUJkbkxJSjJMbzVNNW9XOW93emJWL2VzWXJyNURF?=
 =?utf-8?B?cm50UTlWQU5NbmRVSjZUbER4Z2dqbHlrZmdUWWd1UG0xZHA4dDhhRjllaDlL?=
 =?utf-8?B?cjJDYTB0SXJCTEo2aDVwOU5YVVZxcnJlbVdJZTNpN1VxSG1tUU9HZGJDRnl1?=
 =?utf-8?B?cDdBYlVRdFI5ZWVIU0xWb0ZxQWw4S2ZoOUNDUHFQNm9VblVXa2lycGlZN2lo?=
 =?utf-8?Q?/ymM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cTFDS2hLNWgxeUlRNGxSTnJMUktLRzVBVDluMklEa05Odk1OblNrMEg0ME5l?=
 =?utf-8?B?RnlKdlVJc2dtcFZtOGtPY3BtdUJhL1JYTm9ONG05STZIRnh5Zy93bHB5ZlBv?=
 =?utf-8?B?V05PNHBiaW9VME1tSWV4VFMrcGZYWmYvaE8welRhZnc2TFBzSStKN0FJTVNa?=
 =?utf-8?B?bTZYUGJlUXNlekZGZHo3MEx5Nm5zdUpjK1hWL0RUNVMvbXljeHRtMmxjVUxD?=
 =?utf-8?B?UGZSU00rR2tmMTl3NWNFKzJVd0FKN1RQMXRBSlJzblNwSVZhMEFpWjhvc2p4?=
 =?utf-8?B?bHVacFFMbWFIOTc4NzZaMi9pZmVSV21LOVpsWHIxSGxRUWVDbnF3Wm5oeEVU?=
 =?utf-8?B?WG5zekhydHJBeXg1T28zaC9zcUFoTEdRNlh2WDJOT1FUdzl0NzZPRjJqbVI1?=
 =?utf-8?B?ejlGU1dxYXV0MHVjblpRY3pMRXZvV2w0WXhab0h3NWdobkIwK1d3eDJkZlV5?=
 =?utf-8?B?Wk5pK0N3Vzg2VkYzNEFPWERhQmhTeVdkS0ZySTVWemRqbUNIanZkTDlSZEpa?=
 =?utf-8?B?ZXNIazgzYUIzOVZ1ekZIVnh0akhiSkE0OUR0aDIwcXBKdFVlWHZVeUlVWWhk?=
 =?utf-8?B?eG5ob0tZS0lUQWZ6TGNjTmJzZ2FvY2hueHlnb2ZrRGQ0NUVjYUwrVTVaVEdq?=
 =?utf-8?B?SWJJVkVBOEllYkVnMHFtMUdIcVdhQTRKazNISUdxM2x4UTdwRUk3Q1JSdXNl?=
 =?utf-8?B?eUNiWHJ2bjhSMHFYVHJpVW5Nc2tHMkhuc1NDeVd5YnZncWhMMzBUanZYSjU4?=
 =?utf-8?B?eGUrS3JOYXNvSHNDWlZMUTZpckhkdjF3aHh1d1IzV3djTlhLZ2J5ZTBIMjRy?=
 =?utf-8?B?WW1Ec2pQdWVmL3cwTnRsTTkySnNhOTk4aWhmajdJd0F5YmcwNlhoL1dnQ3RG?=
 =?utf-8?B?cVVES3I1M2haY2luTVlIVUF4N09nakVsY0x1NHFNZzVSVlhyUnMwWUt4b3Jn?=
 =?utf-8?B?NlZJdE8wNXEwd3hIblF6dno1dlpYRnJyZGJ6TUNJWkpXOWg0MVhvd0hyYVRi?=
 =?utf-8?B?Q0UwNnJRcmtTM3IxbFpyNG92bFFObzNDbkpuVExXMllpVHZnWmZhZFI2L1Qr?=
 =?utf-8?B?cStQbmVNNGU1cERNd2sxZkMyQWR3UEdha1FyNitNZmZCVnl3YjQ0WUg4d0Za?=
 =?utf-8?B?anZZcld0eUdRak9hUDFnc3lHckVZNHZaS25ZTGVHSlhyTG1rMW9TTXNEeS9U?=
 =?utf-8?B?RUhra1lpY0lrb3dDOWFNeVZkMVZTYjEzMmx0eCtVcTV6NUV5VTFYRHZRSGZi?=
 =?utf-8?B?am94Q0pJQm0wZlFhNnk2OEpxRGVLekppaHFNR3F0ay9wSUx6VE1CUWlObitV?=
 =?utf-8?B?aFR2eHpub05HL0o2Vm05VU9vOEQyLzlMdTl5UzdDMis1RXBheloydnliaG5W?=
 =?utf-8?B?T0FZREhIZTM4MGIxTkt1ZFhiTElSVDJnVEdsQzlHZ3ZxVDFUa0hsWTRGUU9P?=
 =?utf-8?B?SVk1cXJKd1dlYlV2K0o3Y0p2TDlFa1psVE8xNFdhSFVGMmdJRDI2cktjZjNq?=
 =?utf-8?B?bnAzTGVnNmpIRGxSVjFvelp5YTNuTUJsWndKOWZ0OUxZeXhXM3ZmRHR4ak05?=
 =?utf-8?B?clc3eVpiZXZNdzF1U1E0MG1ScDgxMnRRYWVxNy8vNG1KeUlLNEIrb3R4c2x5?=
 =?utf-8?B?UlI5Z0pMTnkyU3VVWDVEcTZFcmFXQ0pLOGRObmRKeGYyNGZMQVdCVS9kN2Vp?=
 =?utf-8?B?V2JtenpXRi9JSlVsWnpPTzc5djRMa2hHYnlIVWRWbjVlS09wYkR0UzA4LzlY?=
 =?utf-8?B?ajA5NzMxYzJPdlVKVlZMMmYxOW9JTmIvbFBVbEdGQkp0UXFqaHFsTlRka2lq?=
 =?utf-8?B?Qlk3WWhnR1hRQ3hZNU5qbis3UGxPRzB6Nm81RWxaZWFMenVKeWVoNmdQVWY2?=
 =?utf-8?B?K1paZ2xveGlZQVJ2emNVcFFQUU1kY3g5Z0R5bTBxc1gxUnRSZ1pFVmpWNFAz?=
 =?utf-8?B?LzBRcTJ6cnJraXRJRlNCbHR3dzR3M012QXE3dG5EbTNZWGJuMkVmdStmd29D?=
 =?utf-8?B?RDBaL3gya2lBZzEzeitneGlJb1FYYUN5OHdReCt0YTNZSHlHTFJNMEg2bU9s?=
 =?utf-8?B?S2gzYVQ1VE13S20zbjM5TmR6YWlENytTenc2U0ZTZUFuSEZjQVpOZ3p1SUd0?=
 =?utf-8?B?MU9taTJzU3JEbDk2aExkNXNyRktDbWE0eE5NbDhGWlIzMGI2TUZiajNXQVp4?=
 =?utf-8?B?L3JUVjRxR3dGUStvYkZQSWk0cnl3cmI5SGtLc3R6Mkh5NHhVdGtHcEFXTFJJ?=
 =?utf-8?B?Um9Wd3ZXZGFiN3VrZjBVOEFDTlhFV0xpYzNaM3M3V3hNMWZQcTZzWmNUSDlC?=
 =?utf-8?B?cnJLOWplSGoxSzhoV3Y1ZHZWQkZUY3dXWTUzUWpBZHEwd0V1NHJnUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3816b643-4ac7-40d5-43af-08de73c894d4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 17:17:26.2100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IdlH5+rqiww3I5ScflpoLW6N3FTdiboLY03MNMu5TEzM4a9NYLB4s7y5rZeQRrOj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7097
X-Rspam-User: 
X-Rspamd-Queue-Id: D0796C0009
X-Rspamd-Server: rspam02
X-Stat-Signature: 1my8d9d4x7wbtoq1tr185run1dwnu88u
X-HE-Tag: 1771953452-912626
X-HE-Meta: U2FsdGVkX1+SsgeXRzxY3c40ErNi3htZChwFSUmLICjtWTF1CX5/oGoLqHfBE8PKUP13L4jDw5TcCO4BC6mPDklBH29VwNFgby3aY+YXuGW4ZSoJ5rfE5PkuAQc8YJN18oQXlg/AYbeNvNeoCzIkfYa7lIiPQTcxzLJLCJNxJnbsBlsMfIOs5ZAuQfeZfG53OGmb3UScinL+eWZV8RcToECT7RqEuvpew36UvZD7abUx/NHkHt8zzDzg3rz9KaDUNeqGK+MixppuJjGsPHLpFgpdxFobz2lJWbbFPRV6PPKQk2iZF9Sz2FTU33x/1bvBwm8IcYDs186YlfixGwGkmSO4QNsp2z8Pd/vIZp551oV00T4avq2jQYbgA5LDQ2FB1gFq667IxsSa4O6oOS/AtVjk1/ckISgf8f3oNRl2fPBbFQKlZkut6vNwf1kNKA4xl7LcJizDXsUyX46ps9ZU2FQ5DF4LKSRrrd/spvYbETcgJQxgblLgXPv14LBDtAmcn97DoTuyD4olEo3ULuBahtTfOnDVacEE28+3ZGc7RloBeFEopg7xC6rb6ewIua4eP9i1P3XZxEU4bNKWKeyjbAC5sQEnh8xt7StvSHiQZfoUIhrY3a8Ts/aNLguUgu7hyEwlLUXQ8qGNcPq4Yz+cLiAdOV3ewZpsBVX1n5eG/9VDO9l4dRhN6g2j9sgDQ5BVWwwLY+HxfdO0YsUy3LtN9PN9xJEX9uREq+xWU/mhBGhi8BxjkvqEHiQijGhk7+2IkQlD62+PxGqWQ8GB9OQ8KMqlTCXQWGmoQ9R9gaTrxj+tPE816fl+M332pilKdSKAexkCCX0fsWeOt81uvy4BaH2lIJMI89bkjUz6ReMe6hRU7ZV9IjrotxX2NeWdbd7E4klKdlzKDdTxnynnYQuFlw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24 Feb 2026, at 12:14, Zi Yan wrote:

> On 24 Feb 2026, at 12:07, David Hildenbrand wrote:
>
>>> David Hildenbrand (Arm) <david@kernel.org> hat am 24.02.2026 12:00 CET =
geschrieben:
>>>
>>>
>>>
>>>
>>>
>>> On 2/24/26 09:37, Ron Economos wrote:
>>>
>>>> I'm getting a BUG dump during shutdown with Linux v7.0-rc1 on RISC-V.
>>>>
>>>>
>>>>
>>>> [  OK  ] Reached target shutdown.target - System Shutdown.
>>>>
>>>> [  OK  ] Reached target final.target - Late Shutdown Services.
>>>>
>>>> [  OK  ] Finished systemd-reboot.service - System Reboot.
>>>>
>>>> [  OK  ] Reached target reboot.target - System Reboot.
>>>>
>>>> [  173.985249] BUG: Bad page state in process shutdown  pfn:f8850
>>>>
>>>> [  173.985311] page: refcount:1 mapcount:0 mapping:0000000000000000
>>>>
>>>> index:0x0 pfn:0xf8850
>>>>
>>>> [  173.985336] flags: 0xffff80000000000(node=3D0|zone=3D0|
>>>>
>>>> lastcpupid=3D0x1ffff) CMA
>>>>
>>>> [  173.985365] raw: 0ffff80000000000 ffffffc501e21448 ffffffc600f2ae88
>>>>
>>>> 0000000000000000
>>>>
>>>> [  173.985386] raw: 0000000000000000 0000000000000000 00000001ffffffff
>>>>
>>>> 0000000000000000
>>>>
>>>> [  173.985403] page dumped because: nonzero _refcount
>>>
>>> So, we're freeing something from CMA in cma_release().
>>>
>>>
>>>
>>> In cma_release() we iterate all pages to decrement their refcount
>>>
>>>
>>>
>>> VM_WARN_ON(!put_page_testzero(pfn_to_page(pfn)));
>>>
>>>
>>>
>>> I would expect that this would fire already if there is still a page
>>>
>>> referenced.
>>>
>>>
>>>
>>> Are you running with CONFIG_DEBUG_VM=3Dy ?
>>>
>>>
>>>
>>>
>>>
>>> --
>>>
>>> Cheers,
>>>
>>>
>>>
>>> David
>>
>> Thinking again without my computer at hand =E2=80=A6 isn=E2=80=98t the c=
all completely optimized out without CONFIG_DEBUG_VM?
>>
>>
>>
>> At least that=E2=80=99s what I remember.
>
> Right. Without CONFIG_DEBUG_VM=3Dy, VM_WARN_ON(!put_page_testzero(pfn_to_=
page(pfn)))
> and is_check_pages_enabled(), which leads to free_page_is_bad()=E2=80=99s
> =E2=80=9Cpage dumped because: nonzero _refcount=E2=80=9D, are disabled.
>
> It seems to me that someone else bump the page refcount between
> VM_WARN_ON(!put_page_testzero(pfn_to_page(pfn))) and free_page_is_bad().
>

Merging Ron=E2=80=99s reply from another thread[1]:

=E2=80=9CSomething strange is going on. I enabled CONFIG_DEBUG_VM by itself=
 and
the issue went away. Let me try CONFIG_DEBUG_PAGE_REF.=E2=80=9D

Looks like something is racy, since it is reproducible reliably.

[1] https://lore.kernel.org/all/30dd1efc-9bd9-4664-999e-610d181600f9@w6rz.n=
et/

Best Regards,
Yan, Zi

