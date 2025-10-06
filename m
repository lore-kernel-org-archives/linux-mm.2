Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FA2DCAC5B8
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 17:51:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D94BF8E0008; Mon,  6 Oct 2025 13:51:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6C438E0002; Mon,  6 Oct 2025 13:51:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C34098E0008; Mon,  6 Oct 2025 13:51:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AD8DB8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 13:51:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4DF92140698
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 17:51:49 +0000 (UTC)
X-FDA: 83968432338.15.75CD1B2
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011049.outbound.protection.outlook.com [40.107.208.49])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4347C40013
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 17:51:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=vVotaVdw;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of Felix.Kuehling@amd.com designates 40.107.208.49 as permitted sender) smtp.mailfrom=Felix.Kuehling@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759773106; a=rsa-sha256;
	cv=pass;
	b=Ji/wcsPK2pbDlp53dDE/B55mjjbsrfTj57IbKUny/sFRgATzStyEwwUf3FaF7RfrtwhD2m
	VQaW5yHIj5/VpMJtAP8aTuvOwSUQ6yM1LOOwZLSCXdsJfTQJXZpZg/b+yNx6IDH9oXctEi
	+Kk5PoElwyw7a9dTVyM7s3QxdjDyEQE=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=vVotaVdw;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of Felix.Kuehling@amd.com designates 40.107.208.49 as permitted sender) smtp.mailfrom=Felix.Kuehling@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759773106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SPz/s+XkS+YnSAnKR7EQEw84Vh6gMlaeJmg9o/o8moE=;
	b=A7mGN+DZ/JFD7t5ogzwiBRAnLCaL1RsuQFPcyLKLL6B4ff08yZ1zNOKsOMIGpYRPlXP9Cd
	/26Dfvi9YLMMtvebKibwnSYtQEMnq/nnBGpB+7PDGvoxa1aR/GjP5EjeBFHxvU7FEtjwSY
	FBWhk6bMHDweuETE9WstaOq9kmxziLs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XFO8I+1TMh8HH2shEY72fzNiuH+uGwB8ebBNCLoaSb423d8Jh0/lRMKxSc2jP2N2e4boedgy9IuGGY3t5nThOb3fL7FFfYeUcUIpipjTf3YSXae9LpIiGtvbVR0qL+B0dIQnQ5YdrRDjDuqH4IydUnjuo82jheegHGOBu9zAUkC75xa5KditqQoAeBvEZnxOjpfQ6uco376Z8Nv2gqYVhRtcuNNKdUrah1+3VucfhknRZIm7geY98j9YBnSudlU+fWX6gGnSEBvNCf/iajA6XUj+gAMZOV2Y8MHradEOuAKQ7sAyUYMcnzdLZHnoq8PepwMwiUx2qrMPRx0QLtjK/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SPz/s+XkS+YnSAnKR7EQEw84Vh6gMlaeJmg9o/o8moE=;
 b=VN3MRVifo+VnbC2Edki5M4U7RYGREGSqvf48FY4h0oqVwIdD4MxUHcjP7G6Pj4JGLrw9v0/0mIhjRwgGvyxYHQBH+4MIOuW7Ux1+Do+n09QDuPfgDCNJsVN4eOjgVq82kbpH076zj2l1fY4xodqOCX/GZuSfjUjf9gKRTQVJ7fZMU+vAUYhaiINwBaijjEOHDntCzEvKx6ug8hE42MR1j11ebeP1YNqV++3xXs20N+zIrZzD4DO5U6qwC5fZlkBsgANIxxXBe8KDuDtBy74W1dNrTSlvhFkqtJBSZmLuttO/2KDCdwumttTOyplYccTPJGqQSc6JMSKI9ERjVh+0GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SPz/s+XkS+YnSAnKR7EQEw84Vh6gMlaeJmg9o/o8moE=;
 b=vVotaVdwwZJ2wzHm9j1eU02HGIxGhq19QAlaH218Ih3QjEukpw9HbNj3DtbJS0Z4fy9uXcb+bPT8GZ/2b7AYQ8Ko8dqB/CvR8T1910xgv33lwYbabXxnoVEc4vNlppqYmKnUAxx/PWtyQZ2+8+uWmxi/pk+RrPuHOoHY9ILIZzc=
Received: from BN9PR12MB5115.namprd12.prod.outlook.com (2603:10b6:408:118::14)
 by LV8PR12MB9229.namprd12.prod.outlook.com (2603:10b6:408:191::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Mon, 6 Oct
 2025 17:51:39 +0000
Received: from BN9PR12MB5115.namprd12.prod.outlook.com
 ([fe80::9269:317f:e85:cf81]) by BN9PR12MB5115.namprd12.prod.outlook.com
 ([fe80::9269:317f:e85:cf81%6]) with mapi id 15.20.9182.017; Mon, 6 Oct 2025
 17:51:38 +0000
Content-Type: multipart/alternative;
 boundary="------------42a97FegnAT35ZsyT00d1S4j"
Message-ID: <b81d7333-192d-4b67-b270-ab9736a48589@amd.com>
Date: Mon, 6 Oct 2025 13:51:37 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drm/amdkfd: Fix svm_bo and vram page refcount
To: Jason Gunthorpe <jgg@nvidia.com>, Alistair Popple <apopple@nvidia.com>
Cc: Philip Yang <yangp@amd.com>, Philip Yang <Philip.Yang@amd.com>,
 amd-gfx@lists.freedesktop.org, Linux MM <linux-mm@kvack.org>,
 Leon Romanovsky <leonro@nvidia.com>
References: <20250926210331.17401-1-Philip.Yang@amd.com>
 <87ae1017-5990-4d6e-b42c-7a15f5663281@amd.com>
 <f3349a43-446f-f712-ac61-fa867cd74242@amd.com>
 <674f455e-434d-43d2-8f4f-18f577479ac9@amd.com>
 <aa910171-bc96-d8b1-1bee-65f3ef5d1f46@amd.com>
 <17ee1a4d-69cd-4be9-bd6a-2924e8731db8@amd.com>
 <20251006132144.GM3360665@nvidia.com>
Content-Language: en-US
From: Felix Kuehling <felix.kuehling@amd.com>
Organization: AMD Inc.
In-Reply-To: <20251006132144.GM3360665@nvidia.com>
X-ClientProxiedBy: YT1PR01CA0110.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2c::19) To BN9PR12MB5115.namprd12.prod.outlook.com
 (2603:10b6:408:118::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5115:EE_|LV8PR12MB9229:EE_
X-MS-Office365-Filtering-Correlation-Id: d24bbab0-8e27-41e6-23df-08de0500fff9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|8096899003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RXNvUzhrdS83Q1plVytuQXA4dkdwS2l4SURMcHJIaVUxdGVJRHp3ZlNERUUr?=
 =?utf-8?B?M2xOTmxkYlBiMVl4K2ZwR0YvaGZUcDFiMHVEUUJEZnNndkdSYjR0N2dOZEVW?=
 =?utf-8?B?Tis1V0pUdjN6L0ZpYWthTWo3NHI2Mm5CTHpWMnJzb3d5bDl4Q2taQTR6R2wy?=
 =?utf-8?B?ME1XSVZ0M2dZbkhBb0Y2VGJYM0RUd1l1Q3ZhSEsxeUNBZEkwalRUTnU4cGVE?=
 =?utf-8?B?YW9uUXFSYUJ5b3dPeUJqSFozck5ncU0zdlFVYXYyWndkVmJrdE9ER2lwRzIr?=
 =?utf-8?B?dHNnSUVHVFdhSi9QY3cyNEZwRmIwUGVncWoxTGY0dDZKZVplR1pGdlVsNzFC?=
 =?utf-8?B?YXZSSzFEVjl2TDBYR0JWa0g4ZjVoN2x6b3lGYmY0aUR1TlFuM1hva1ZYZnFF?=
 =?utf-8?B?aUMxdmRwWGFBbVlnaWtFQVFTWXJVdjIzSzJFQ2ZaNjhvWTUxVW1DaFh4QjQ0?=
 =?utf-8?B?SUYwQ3BKTkcwL0NuejkwcXBNZmhnRWZKdHRaTkhudnZEVVdLdlU1M2NhaVVi?=
 =?utf-8?B?QlltYjBsaWtsUlNhWjhsL2dVZkdnU0EwMTBkSWxyZHJsd1kyRUVNWWlXdVow?=
 =?utf-8?B?ZTlscmhRdXlsdkQ5Y2tYaEhUWHFmdVlKT04wa2RLVmVFcGJUakZ2b1RCWUlI?=
 =?utf-8?B?ZTR2NFl5YkJjVVN6dlFaVnRkcTVQdFE2NkxVQkVTWnBVN1lXeG1wVS84emJz?=
 =?utf-8?B?ajF0OUlhWEl1UitMVTUvM0d1cVhTRUZrclZueVNBR2NTYXRUUzBUa2psU09k?=
 =?utf-8?B?SE00d0ZKZm81WXZ4cGdGL2VyenhHQzJDcmQxNGJxYU1hT2hOY0hEdXMrVTMz?=
 =?utf-8?B?eFlvcjVDZjBhbzQ5WEpqWlE0bXpzaDRPYjhPZGpMRGdGWlNIQnp1YTR1Y2Ew?=
 =?utf-8?B?clVjeUlLMklmQ3RoTk1qUTJCYlJhTTVITnYwRytLRGR1RnNRQk1rVUZ5MHZq?=
 =?utf-8?B?MGFFUzNNQzhmZnNjeFhON2hXcU00eHhkK3g1UWx0dDdSMW10Q3VjSjZvT1Nu?=
 =?utf-8?B?NitvYkJwazJIMzRyMGtNOHlla2VEbGlzZmxreXEyZEY1eVA0amlzdFZVRisz?=
 =?utf-8?B?ZysxUHU1bzZGZVJ3cFF6TEtmNVNMVTFmdDZLL3RiZ1RnUE5OMGpvVFRCSHlG?=
 =?utf-8?B?QVl0MFNWQS9rd1NUUEJqR1VqeHpqTWo0Wk5DYVZBTFlHaXVkSkUrV0FrZGRo?=
 =?utf-8?B?b1lBeVRkYXk0RkJZcnZ6eUdsdFFiSGZCZnlzZFNLMllESWlvTklSWDdXVWh4?=
 =?utf-8?B?Y3lhZk5GUndXTWpCeHdoWHVreVgweGRpaXhaMWpOZFJUMkhDV2dxSE9SdGpY?=
 =?utf-8?B?azlJUUlOTHJ0QXZPK3Axa2VtU3J3N0EwNklHUzdCRHlwODlXN3FxZW8zdWNx?=
 =?utf-8?B?UDUwK3U0clRubmJibWplMVhjYThWeVYzV0tIaUV5RFpwVVRmSEdSYml6TXJS?=
 =?utf-8?B?L0xXTlZVUkl6TC9MMGNuaVJpdkRMVnJCNThrMEJqaG5Hc3YzcEJRMldoSzNa?=
 =?utf-8?B?QnRGZWZZYjFXbFpaZk1PeEtXVDM5MngrK1hPRTUweTVXaGpZa0VPa1FyN0pU?=
 =?utf-8?B?YWtYVk5VSzNrWWx1cTVLUjJYMWVIWWE0N05LdFJtWGVCTEZMN0NSc25KREkx?=
 =?utf-8?B?d1V2d3pCZFJrSGYyRVBETis2ZlppT1g1ZjZmYXVEQWMzUjdSMEZzRnR2ZXd6?=
 =?utf-8?B?QkZtb1FzNHBvRXI2d1JnMkwxQS9DZDhtSlVQK3pLQmZnaDRnNUNUdTVxVEFK?=
 =?utf-8?B?TkZobllRcWk1RnA5dE9LMEFMRDc2T25teDNoU1R5d3Fla2VGU2lNVWlTMFZU?=
 =?utf-8?B?YXRiVE5sS0pPaGt1M3Y5K1J0cTBuNytjRHBXZ251SEJqbDZkRjZBYmFxYTE0?=
 =?utf-8?B?ODFMUG84NnNGR3F3NkdlNE5UYU9IU0U2MFRBcmZaa3gyeVRaaWRQOVZZRXRM?=
 =?utf-8?Q?qhSE218w6kq60WU3hON3JtQLT3Uls03m?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5115.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(8096899003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SEpSbHlHOVVtREJabThyUUNabFMwVTFLZkU5Yk1rZnZOS0xDam9EbHBQR05U?=
 =?utf-8?B?VSt5RFpXNUZmV3R1cWU4TXNQZzd2WjJmMEFWeW9OL2NmK1B4cEVVN3U0MDF1?=
 =?utf-8?B?ZDV6VVo3Q1VlWmhTZ1dBcXVHUGZ0U01JUzJ5NEErMXZPeHhHalNtdEtUUXNZ?=
 =?utf-8?B?V1hvN1RLQm81VTQ1UlJXV1dWWFREQVZ2V00xWldXdlNLKzBUdGZhcHdLbFdo?=
 =?utf-8?B?K1U2amUzTzA3SUxjeTZhSVFhbjl0NEJRWWVtUitOTG4yQk9uV3M0eVU5eHNz?=
 =?utf-8?B?eVFxWGxrVmg2WHRKNmZLdGZuOW9zbTNMaTl5QkNPdjIxZ2YyUWczSXdWdXlX?=
 =?utf-8?B?VXEzSW9BdUJBdEp4QndJWFBrL3FvVXl2NktYVVd6Q2RCeGdpZFdNei9TR1Zj?=
 =?utf-8?B?V1U0U2VXaUo5TGc4THRLc0JBZzNnRXBpYjZCdXZ3VmFqQzZMRUNjYzdrQXZL?=
 =?utf-8?B?QTJCU0M5WTFsSVpXWlFtL3B0Y2UzWlRqUm1hbHF2UkRYb1ltdGhWRHJWQ1hY?=
 =?utf-8?B?bjhZMFliTlR4ZGo1dnB4SkZOUmtRcHhGcTR3VnlVdVR5SzJrY0FWWSsxbU9B?=
 =?utf-8?B?ZjJrM2IwT1VCWmNCYUlNTHROV25IWDZuUjFidG5XUTd2MlRlY0kydXBLaXlK?=
 =?utf-8?B?T0lZTWNnbXBNMEVJSG5LSWtOcW4yUVJ5OTZMbVRhOW5zQUdib2hUd2pOaVJQ?=
 =?utf-8?B?eCtobmpuKzAxTEc5S21GRm5KZjc5T2oyTmEwNVdoTWh5UEExY0wvenRIT09s?=
 =?utf-8?B?Nmg2bWxzcExsb0RKS25FV015eVZjY0VHU2pTZFFDSmpsL285eWdEdEhWVHpw?=
 =?utf-8?B?MmRsU3lnZVU3Wk1qNEd4Wi9HeEJ5L3duM3BTYkVISCt2Wk93Mnp3VS96SktV?=
 =?utf-8?B?ckhIUEZGcUoxQStWN2hETE5lRmRpOWVsQVBpTk5HWCtEa005NXV1a2srTE1a?=
 =?utf-8?B?R2pXNXRrenFxQ01ZczdUaDllbnhacmdFY2I0R2JYRVBMUGxtN1pubHowOGdH?=
 =?utf-8?B?SGFMUmdOMTVBUlprRGdyWWo2R1VDWEZwZkR0OUxOQ202eUNWOE83cnVsSEI5?=
 =?utf-8?B?eHg2NFhlb0loTC9xOUpBb1ZYN1NWUmNucWJFWk9DWHBvU3Z1SlRaSjBnQ251?=
 =?utf-8?B?Qll3RlpxS3pWaEZOT0ZtODVYR2JDSWVRaDJyN3BkYWhOMGYwVUpjdmdqTG5o?=
 =?utf-8?B?MFVlb3lFZEVNZDBFVjBhd0RqZkJZNWx5TDVINkVKUjRycEtDUDM2eEFWZ0R4?=
 =?utf-8?B?NWxqVUJncW1mVHMrZUE0UFJYMGpJZ3NWUXlkbC9wQjd5S1ZPZmhNeWxSdWFX?=
 =?utf-8?B?WVpodjN5MUQ5YkxMSUl5aWYvd1d5Y3dEMVlacE1Cak5TUGd4MGtHN3I2b3hN?=
 =?utf-8?B?akFodXJZMUJaWXNCWHlIdmZMMFJ6WnVINlA1U2o4SEswV2NjbHlmQkNIdFJm?=
 =?utf-8?B?MTlEMG9QRHUwS0RjSDU0bVdUL3lUeWk4d0w1dk1vQUx4K3ZQVU5wRG41aVFk?=
 =?utf-8?B?ZHJXVTVpWVdiMmVUMmxzT0ptU0IvWjFkR2hRY3hXamlEalc3Q25yNHQ1MFly?=
 =?utf-8?B?bzkxamlTRXhIbDBUazRiSFg3b0t1elQ2dUN4WjhQR24xQXpscjRlbERnRFgx?=
 =?utf-8?B?WTVZN08zR255OVo1eERIMWY1S1lEdGhzQU9zNXVkVVZ0SlZyQWZIaDVaYzhI?=
 =?utf-8?B?TXhMVDdzd3BEU2lnWWtkeWQwcGFRVHE2bjJHaTh4eXRidnNyL3lodnFRaHBo?=
 =?utf-8?B?K0g3WjJjMDBjQTQxNEVwWVQyZkNReDNhNW9FMEJrdjhIZ2ZRRDRmYmE1NHZy?=
 =?utf-8?B?V2lmcEt3Qk9Gd1pzNGF5cVBOWEpxL2pLS2pFa0NhbHZIcEdkL1BzaVA2c0ls?=
 =?utf-8?B?d0o5S2IvdklBY1BuRU9kdHp2alVITDcwS3ZCR3laRU9KNktBcDArblFnL1Fi?=
 =?utf-8?B?ZkozUUp6aGQ5Qy9VWnFDOCtiMUxLRGdZTHBTUitnaDJyYlJCTG5DTS9md3p1?=
 =?utf-8?B?MnRXdmN5Z1lSTWcwQ2ZsNXgrdFNYQXhBZGh0dVhrME8yU3BjZUt2cTVsb0dj?=
 =?utf-8?B?YVlRcjQ2Zlp0M3RTVDFkNlNhYzQ0WFMyLzlkaTVyVEhKRzM1ckZXUUtXT3Nj?=
 =?utf-8?Q?OOt8rW5yUEtNzPMW1LYj+XQP1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d24bbab0-8e27-41e6-23df-08de0500fff9
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5115.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2025 17:51:38.8169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IObIlFbJgMJWO20bG3d5nyNGbSoWRVjdHk++WJ73w9NyTEBNekAn2QxQmtvmssRhgzAosN7f9LUi+QB8QOww3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9229
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4347C40013
X-Stat-Signature: qshmje4deru71rhk4ig6y69spoqxnoac
X-HE-Tag: 1759773106-530642
X-HE-Meta: U2FsdGVkX198n3D+8zoK1WNYlg2/jRdYkSDb4S1GCH2HZ7/hU/WAtzQXWIQpyP0/JwcRMZgBeNITPovoDWcdNhW5d7S1V5flrtUtTtSHQ51OirPZwTrbZ4I9LvwGaX/rFBYWoLNR8a9rcjPdBykQAqhx9B8EiVx6zGGRVzvREPfBFIx7IE7ECo5U931LhPFmjEzf8vnzZ28bCIr3vOTHgyMq5IERTjTOl0jOvRuPeOxuZSbv4A51RhMqG3fUr0RQG0xBfn1MePRHGEucjk3FdLp8MYkd/vbgmIrwvSB0sCaXnMN4+NsiOz0Brv/Nn9s1TAN3zeHk78+Dn9iyxnIeOCVAXrv1UePh5Hnm/p28MKkS7cg0WPaog7chM5Hh2i8S5/7xMf4tHhWfU27jI9jEEGYHkVSn6Tv3AnvRX2LRBM+4S8kGS4z7rfrZ7K/z7UHbUZCc/AOf09PymSYe3dR+SBqLeHBxXNBZqx8nz/vNzQphoTTK00O1v+hNU3CDnyc/CFFGdtkcZZAhGOOuE3HmQ65QUqTdaZzTO74ibao3F+c5xiowcceZYb8Q5z8yqtodOYKH5zlR/wtMt3hfs05GmdVjXve8XTQysFZLl2k3lpeYYO3ii/r0Ec8OQVhMQkGOTLAjFFwV70rwspugRnycGqEgJ6Q7rsZZzK/B4xMbrBAgwQg1dLWYC6NsykPsKbVYSftok7k9m7RfH5N3uN1oA09vHkoaWdLeW8h2VSRS8OwPX6H/I9hrQea+lO+6CaIViEA2CTM5Z0je1IT05JpInKsvNlVvHFSMTl+lVEkw1Y16en8UPNx+3uqjdia4zDprmIKjbbylb055E3ccCiQGfT/wHeWLHFiCk0nlRGptBAp1m4o+OLPmmgsdyZQaAHCbd0IitNiOIklLQilgCrF8GRM6SYonIletIOeKy2Hv5eCUuNet9fj/5mwkBwu4kY+qXqHU4OwmvhjfhGpvv66
 +F/sMyVb
 nnII/MmRDRDpwQKDVZAe8JJcWFs0t8xdsNNO7gfj7BhjBXY18q+sl7h9Y6YQzaiwe+wWRTXCvxn265KHWazyj5kPeb+vAyzufS7nmFQnm8sPLmFcNj81rM22bQefX710uVhUdhRLdcv8SeLKA/LczvzTn9icjiGnFwe/+rPEUBUU7wAq00labkpLr3Z5SKQWqxgC1/beUvZQucHOsZ4nEKyPbM7ao1GekFnOeMzro7N5nUoh9plEkaCuhAUo1d9H/csbUR4vWjUGd1SYjt4wrmRgyzeGEnddjovM8JJKNXcqYUcLwy+UYDNKeddgKYLg+zMUEXlTdN+G3yp6PVOM81ZgdWeh9C50aB+JPByoM4fixh7OA+hVlpVjFDe87F7gQdpaQGWpirhiBSiBOEfZmhRyDAePCkWOtzdKzZaVyNGiofhuIBW/Cj7SUJQlDhnd3J6oLe8CFb8bYy918OnazWzqy0wJyfxwmxQTlqc2QseNkb9lSZIBFqZlU71Xx+xkFrYVYsikSW4Gfsj5bos+MRE6KB8MzcWnZnxW+LbGnj9nSFp1CEGME6TmzqTxhbrXi2cZ+eFhlfAUmf0LNJtB8Cd+Nry/ee/JF/zZSjgHa9ivgJ72DBYjREYyQvZaCPRiCclB4mCJp/2PeEXY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--------------42a97FegnAT35ZsyT00d1S4j
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2025-10-06 09:21, Jason Gunthorpe wrote:
> On Fri, Oct 03, 2025 at 06:16:14PM -0400, Felix Kuehling wrote:
>
>> It sounds like zone_device_page_init is just unsafe to use in
>> general.
> It can only be used if you know the page is freed.
>
>> It assumes that pages have a 0 refcount.
> Yes
>
>> But I don't see a good way for drivers to guarantee that, because
>> they are not in control of when the page refcounts for their
>> zone-device pages get decremented.
> ?? Drivers are supposed to hoook pgmap->ops->page_free() and keep
> track.

Right, we have that callback, it's currently only used to track 
references to our buffer objects used to back device pages.


>
> There is no way to write a driver without calling
> zone_device_page_init() as there is no other defined way to re-use a
> page that has been returned through page_free().
>
> It is completely wrong to call get_page() on a 0 refcount folio, we
> don't have a debugging crash for this, but we really should. If you
> think the refcount could be 0 you have to use a try_get().
>
> So this patch looks wrong to me, I see a page_free() implementation
> and this is the only call to zone_device_page_init(). If you remove it
> the driver is absolutely broken.
>
> I would expect migration should be writing to freed memory and
> zone_device_page_init() is the correct and only way to make freed
> memory usable again.

OK. We made an incorrect assumption that we can reuse a page if the 
driver isn't tracking it as allocated to any of our SVM ranges (i.e., 
after dev_pagemap_ops.migrate_to_ram() migrated all data out of the 
page). However, we neglected that other parts of the kernel can still 
hold references to a page even after that.

Would something like this work:

static void
svm_migrate_get_vram_page(struct svm_range *prange, unsigned long pfn)
{
	...
	if (!try_get_page(page)) {
		page->zone_device_data = prange->svm_bo;
		zone_device_page_init(page);
	}
}


>
> Therefore, I expect the refcount to be 0 when
> svm_migrate_ram_to_vram() picks a dst.
>
> If it is not true, and you are tring to migrate to already allocated
> VRAM, then WTF?

As I understand it, it's a race condition. The driver is done with the 
page and its migrate_to_ram() call has completed. But do_swap_page 
hasn't called put_page yet. At the same time, another thread is trying 
to reuse the page, migrating data back to VRAM.

Regards,
   Felix


>
> And if you really want to do that then yes you need to use get_page
> but you need a different path to handle already allocated vs
> page_free() called. get_page() MUST NOT be used to unfree page_free'd
> memory.
>
> The explanation in the commit doesn't really have enough detail:
>
>> 1. CPU page fault handler get vram page, migrate the vram page to
>>     system page
>> 2. GPU page fault migrate to the vram page, set page refcount to 1
> So why is the same vram page being used for both? For #1 the VRAM page
> is installed in a swap entry so it is has an elevated refcount.
>
> The implication is that #2 is targeting already allocated VRAM memory
> that is NOT FREE.
>
> Jason
>
--------------42a97FegnAT35ZsyT00d1S4j
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html><html><head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  </head>
  <body>
    <div class="moz-cite-prefix">On 2025-10-06 09:21, Jason Gunthorpe
      wrote:<br>
    </div>
    <blockquote type="cite" cite="mid:20251006132144.GM3360665@nvidia.com">
      <pre wrap="" class="moz-quote-pre">On Fri, Oct 03, 2025 at 06:16:14PM -0400, Felix Kuehling wrote:

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">It sounds like zone_device_page_init is just unsafe to use in
general. 
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">It can only be used if you know the page is freed.

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">It assumes that pages have a 0 refcount. 
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">Yes

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">But I don't see a good way for drivers to guarantee that, because
they are not in control of when the page refcounts for their
zone-device pages get decremented.
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">?? Drivers are supposed to hoook pgmap-&gt;ops-&gt;page_free() and keep
track.</pre>
    </blockquote>
    <p>Right, we have that callback, it's currently only used to track
      references to our buffer objects used to back device pages.<br>
    </p>
    <p><br>
    </p>
    <blockquote type="cite" cite="mid:20251006132144.GM3360665@nvidia.com">
      <pre wrap="" class="moz-quote-pre">

There is no way to write a driver without calling
zone_device_page_init() as there is no other defined way to re-use a
page that has been returned through page_free().

It is completely wrong to call get_page() on a 0 refcount folio, we
don't have a debugging crash for this, but we really should. If you
think the refcount could be 0 you have to use a try_get().

So this patch looks wrong to me, I see a page_free() implementation
and this is the only call to zone_device_page_init(). If you remove it
the driver is absolutely broken.

I would expect migration should be writing to freed memory and
zone_device_page_init() is the correct and only way to make freed
memory usable again.</pre>
    </blockquote>
    <p>OK. We made an incorrect assumption that we can reuse a page if
      the driver isn't tracking it as allocated to any of our SVM ranges
      (i.e., after dev_pagemap_ops.migrate_to_ram() migrated all data
      out of the page). However, we neglected that other parts of the
      kernel can still hold references to a page even after that.<br>
    </p>
    <p>Would something like this work:</p>
    <pre>static void
svm_migrate_get_vram_page(struct svm_range *prange, unsigned long pfn)
{
	...
	if (!try_get_page(page)) {
		page-&gt;zone_device_data = prange-&gt;svm_bo;
		zone_device_page_init(page);
	}
}</pre>
    <br>
    <blockquote type="cite" cite="mid:20251006132144.GM3360665@nvidia.com">
      <pre wrap="" class="moz-quote-pre">

Therefore, I expect the refcount to be 0 when
svm_migrate_ram_to_vram() picks a dst.

If it is not true, and you are tring to migrate to already allocated
VRAM, then WTF?</pre>
    </blockquote>
    <p>As I understand it, it's a race condition. The driver is done
      with the page and its migrate_to_ram() call has completed. But
      do_swap_page hasn't called put_page yet. At the same time, another
      thread is trying to reuse the page, migrating data back to VRAM.<br>
    </p>
    <p>Regards,<br>
      &nbsp; Felix</p>
    <p><br>
    </p>
    <blockquote type="cite" cite="mid:20251006132144.GM3360665@nvidia.com">
      <pre wrap="" class="moz-quote-pre">

And if you really want to do that then yes you need to use get_page
but you need a different path to handle already allocated vs
page_free() called. get_page() MUST NOT be used to unfree page_free'd
memory.

The explanation in the commit doesn't really have enough detail:

</pre>
    </blockquote>
    <blockquote type="cite" cite="mid:20251006132144.GM3360665@nvidia.com">
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">1. CPU page fault handler get vram page, migrate the vram page to
   system page
2. GPU page fault migrate to the vram page, set page refcount to 1
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">So why is the same vram page being used for both? For #1 the VRAM page
is installed in a swap entry so it is has an elevated refcount.

The implication is that #2 is targeting already allocated VRAM memory
that is NOT FREE.

Jason

</pre>
    </blockquote>
  </body>
</html>

--------------42a97FegnAT35ZsyT00d1S4j--

