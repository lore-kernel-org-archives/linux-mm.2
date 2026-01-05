Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 314A3C79FA5
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 16:36:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88BEF6B0193; Mon,  5 Jan 2026 11:36:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 838F86B0194; Mon,  5 Jan 2026 11:36:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 711706B0195; Mon,  5 Jan 2026 11:36:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5D3DE6B0193
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 11:36:31 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0C604B5DFD
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:36:31 +0000 (UTC)
X-FDA: 84298463382.18.DDA9906
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012032.outbound.protection.outlook.com [40.93.195.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 332B618000C
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:36:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Al5KZlIB;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767630988; a=rsa-sha256;
	cv=pass;
	b=swU1YiaMImr6fjwK6TnaMEKDtHVgvd/+04KEVI4cEj6TjFs+pHK+jWtukPNiph6v7KsrFc
	CBwWDOMupW7yKHSLZGA6jv2k+QNb2kiipo0VoFBJPw32Z6CH9GRr5RqlejlpH2d6hm1F03
	WGM8B4OvcbcVVi825h1kwv1ZzeD3rig=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Al5KZlIB;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767630988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MWlCxFECo/Wg3cjrhwMk/8mn7trQYQAyWhDT59rKrEs=;
	b=WOSr7/abkWEytZr3+zhRWtdQhTr0/CMU7JhB/GZjsU+DNL1CLT7X+IoKjhHQIze8XudYxN
	33FXMpwadhh03y/f414KCPAZXtHhGklbxhYVkn6Gb4z+XPjmxCCHdTPeU8ifv9tWT9rSP0
	tO0elVRfSO6ZXxTsY6CryXoAG+sFzZM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QgSlUgI4KxQ/JFySInCC/DolqtUKYmlDdmLM83LwG9ec/c+AvVfFSjtxm7J/YDzSXrlXLuIVx2xqRm9OMIz/HKlAk3wkD1+CnURVFxj+HlkVYy/C8LkzJi/BUiFZqSR5WNUzRFIl+N4iX/YV+mGxzhZoOmwjsyWodDqzygog/UxJjLfTn/0Ft63pdXluVm+LjNO1tyK80g4HOxvKuUsHCa7/7tv5wSIQPfpZxx0NZRKHwnDpR8GsCT9unZZ699dsu1EQuTIFXpuracAFKl4PBTkEiaHAINtGhkntT7IoMvhvgnXpw3xvKtjsKSY5eeEyFUO5iutZRAyeGCKm+WThaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MWlCxFECo/Wg3cjrhwMk/8mn7trQYQAyWhDT59rKrEs=;
 b=Ll8JbbBUx01Wewqs3DSElbg5jOpxEx2RQSck8xVkc101mCSuQ6aT4+8Tkw+1pVfJ5n+fu/OSUfYm0p3hgd2GQuOsPYynnhJvIx4XFKhWjeq6+UMdkA+0aM/ttehK7GGutuORRIPhcQlPQh7Ze7+A+ciwbK7FPGbRFVzZ4xSPYPgV2TGKYbh11emqT20yx+yCHhGkASyj0SDJZNKXMuREqeNnEa48xPXnKtUaTsi0G4U4Qh82Gli2DGRLuW62SW1Vcm92vo3cdwYMD5a+7/JFjt/IO9Dg52LlZ817PPnAlIUv75kAboz2ig9iE1UxPuPscib0tS0hqlQFVIxHVY8Kjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MWlCxFECo/Wg3cjrhwMk/8mn7trQYQAyWhDT59rKrEs=;
 b=Al5KZlIBlvdFrIlQxUQjxtc3Y/ySn5OxtPW9Pcc6NqqMIZPDS2d899p2MRLOGTDPCM/tA2psTyRK9vglTqucFxNVKCX2tEwqzW/yZkHO2ar385JpRSIaotvvMPereQySiMoIqdOhKsYOEdniBbMav965P8ptOR40Q4YKhacMLIjIYr1VlLS0TrKHx7RUmmYKJ1YT69C0r8qtHFRKNgjXabejQ5oCSQt2gXVm37NrVOMMDev0A4bt+WQsa+iJkBk5tPt3AbDbC73ZOVhlbfTqKgUUb+bBia4tDNXGFAcPn3zRIIbmNwisKhEz4QAFdGTH/XEBxC6UbpiAqkxAg7GhrA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH2PR12MB4136.namprd12.prod.outlook.com (2603:10b6:610:a4::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9478.4; Mon, 5 Jan 2026 16:36:24 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 16:36:24 +0000
From: Zi Yan <ziy@nvidia.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: Re: [PATCH v1 0/2] Free contiguous order-0 pages efficiently
Date: Mon, 05 Jan 2026 11:36:20 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <D9734C47-0EDA-4154-8889-1B789B49322F@nvidia.com>
In-Reply-To: <20260105161741.3952456-1-ryan.roberts@arm.com>
References: <20260105161741.3952456-1-ryan.roberts@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR08CA0012.namprd08.prod.outlook.com
 (2603:10b6:208:239::17) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH2PR12MB4136:EE_
X-MS-Office365-Filtering-Correlation-Id: c1fdd5f6-aead-41fb-4f9f-08de4c789093
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NERtNDMxRmErcEVFL0t1eGQzaHhPZ3dqa2QyQVJGM1phMEFnaTZidHRtdXgz?=
 =?utf-8?B?akJRMS9Udll6VUhFdktaaGJCdU9VRGFxekdxUlZuL0pkZ1cwT00vMmE1UkFP?=
 =?utf-8?B?M1lFcExaQnpHVFhCMUNXZ2tTeHdBWm1FLzBCb05vdjIwZmE4ZWdHWUROa1I4?=
 =?utf-8?B?VmFQY1lEd2pmV2R4RW5uZDNsR2ZaRC9BTk1KaUFud1loRjZsMzdTWXF5clND?=
 =?utf-8?B?a3VFMlg4VUJtWi9yTE5IdWM3Rm5ZdHIwMTJKdVErbE95YkdKbGJqcnZYdW9F?=
 =?utf-8?B?V0dTVFR2ZlArWGh1WGkzM2M1d05aelBGcTM4dGlGM2I4dDJDaU5oMTNFdklU?=
 =?utf-8?B?bEVHZkJZK2lPdHlXUFFueG1saHAvK0RaVytqS2dpZFQySVVtUEVEVDVESy80?=
 =?utf-8?B?V2tteXR3Z04wdFFVbHp6a1FRdmt4ZjNjQ24xdmQrVzIrcmVmRjBHYUw3R29k?=
 =?utf-8?B?QXNlQWZKMWIxdUo3bG5ENHR2WkZCa3dtNlRzaFBveXR6MmtrUlZ1RDVBNEVJ?=
 =?utf-8?B?U3FZWEZWUExrNzR3ejZTL2F5TDBhcUFRVFRZa2VyejBEMWVsa0xoVDF0Q2h0?=
 =?utf-8?B?R20xVG92b0lmUnYvUFVBQ01oSHVndEg2cFVJV0pHbjl5TFljTUx0OUUwT3NV?=
 =?utf-8?B?d0Q5d1JnUzBwSkpoNWRqc0ludlBYanlaWU9OTUVua1lRVFdac3NjTGJSQ25q?=
 =?utf-8?B?elJ5bkFiczBEQ3N6cHNiMFk5Ni9VRGtxa0JpVUljbld4d0xoemdrZ0M4Tldk?=
 =?utf-8?B?WkhreENYeEdNWVJMSS9NYjBrZVUxckRtb1JVVWZZcVl5OGFCNXgvSW1qYlBj?=
 =?utf-8?B?NTFLRFFjMG43c2Z6dlFOMFhZYzYxK1lZVCtSQnhjaFhyTDNncGJTYVFkcGo1?=
 =?utf-8?B?T1JaYTRXMDFEU3J4azJ1QUVPYjNVVDBOSkNHUHNZL09QanlERUowaVdFRllO?=
 =?utf-8?B?N0VORDRuNkEvSlZUVEVLalNCckZzN2pTYmZ3RHhKUXd5SDBpUU9nbTE4cytI?=
 =?utf-8?B?amlBY1RldnlXSE5BRklvSlRiZTFLY1NGRVJkbHVUZFlzcTFldUVWdTB4L20x?=
 =?utf-8?B?L01yTG1abmt6OGwzTkx6Tk8zSzBHT3dyRjJ2OG5QNlk0bVNrdDZkeFdvdGpx?=
 =?utf-8?B?d0VtL3kwS3EwNmRId25raEFBVlhreVdneitTVFRPa0JFdk1pUnNWYXA4c0Vm?=
 =?utf-8?B?blBzaU0zOVVuZWtpTkdxYXYrcFpxSUdxR1p4NU5KTUMrWDNwZmd6Mkw3eVRP?=
 =?utf-8?B?MllOeFdhUzg4ZDJYbVlUUFV6QS9HY3VwU01ySGRWcFhtb1Q3TkxKZjVFaUIw?=
 =?utf-8?B?MnRmYU9xaTdxSzYrbDMzbUQycU04YzlKNll0ZTdqWVpLNDJMSEJaTjhXNWoy?=
 =?utf-8?B?T0tTZTZTWTVjZ0VQVGh5MGtuNUE5eThzYmN3Q0pIMEpkbWtpRnJUcnE5aytR?=
 =?utf-8?B?MW40WTJoVWtIWUhXYjR4Z2c0T0RzbHY3YmdwbTdZY2tyVXRjS0g2U2tZamw1?=
 =?utf-8?B?cS9FSE81Y29hMFRwUGZmS0ZaR1JHc2J5cklIMUFKWEU0b3NKcENuVlFDa0RE?=
 =?utf-8?B?ZHllUGh4b2xSWGpFN0RxSDdpekdVSStXWCsrRGJaVDduTWJTbFgrdjlNeGtM?=
 =?utf-8?B?d1R2TERiVEZhZHQyYU5PR05BYUp4ZlhkTmdqQjhtNHZYR0VxY1BnTWZrdkxU?=
 =?utf-8?B?NzNScG5qR3hOd3dreWFPQ2F0TkZjM085Ri90cDczdWJrY0hNUWpKd0lPNGhN?=
 =?utf-8?B?TnRlUE42N3NzY3NaaThXL3kxWmYrT0MwbjBUNnBhQ1BaUHR3dENUYURjeExP?=
 =?utf-8?B?VGI2VGZjMGRSazhYM0NHT3VNWmRlNVBONEI1cm1mZ1hUK254eUt5eHhQdXN0?=
 =?utf-8?B?VDRGVW5iK0l6VldqeFJaenFtNXJjbHVTQ3pPbmRON3ZYK2RGVUIrbXB5M0Mw?=
 =?utf-8?B?MWdlRG1oRkJCMEhsVklLT21OYmgrRUxmWkxsRnJBeWU5bU1ESmkvbjkvRDQ2?=
 =?utf-8?B?eGFmME55N253PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cENtV2FSUXUrQmRyamhkejdBWndtcDlNU05uUXZpV0R5ZXBEZ0ZYNTQrWVMr?=
 =?utf-8?B?WjB5aUorc3Jyd3RSYWlva1NDN0ZJbk1OMi8xeFN6QnIvR1VSTkhJelAxRkNi?=
 =?utf-8?B?SVh5ZjZaSlU5OFhuWklUM1dicFZVeVh6VXhBcEZKbnpmNFpiS0YxZjR6QXRL?=
 =?utf-8?B?VVhUemJZZG9jUiszc2RjclJybG5QWmlMRGJBZWhxMXp5MEdKSjdyek9VSGpJ?=
 =?utf-8?B?aDNrRmVBU1UrUEJ6OVk1VU4rOFNZVVBIb0JvRkxvN0lwMHNVU2Vhbk93Sngv?=
 =?utf-8?B?Q1BDSUljV25SK3cxQjFWUnc0ZFYzMUNoRmx0cUowd1hGS0RQYlpXenFUUzd3?=
 =?utf-8?B?TFdYTXQzQzlKdFo3ZVlLeTVSWWlUdU1wYkpiNjBXRWZmTUc4SnBFMEJaYXJi?=
 =?utf-8?B?Ry9wZTlTT3hibVhhbVhBV0F1cjJPTlRtbHpoV0FvQkgzZXlvcW9odVRxcGV1?=
 =?utf-8?B?aDY5RGdUdHZwVDdBellYdk4rbVd5MWZ1SjRvNVB3Y05kM2k2Vm5FRHF6N0Zs?=
 =?utf-8?B?Q0k1SzRxaWZCaldXQ3NYM1U4K0RPQkR1blZIMy9RaTVrbWVoRXJ0YlQ5SkV3?=
 =?utf-8?B?VTd6aDgxNjJQR09JYlowWnlkNm9RSElFc3FUZTNIMDNCVlNyeEh0cHM1djQ4?=
 =?utf-8?B?Q3Q0VWJBRFIvSmRiRmZSajBtbkZaWms3ODRLa1NjdXVQYmVqaVR2b3BDNE00?=
 =?utf-8?B?aDBkaC95RDh0Z1AvSW9YZ1JLVjdEajRYeUxDY2I5VG16VkliMk9PeEkvWENM?=
 =?utf-8?B?QjdtQ2hMNTlSdFpJL3ltUWo2V092VG9YUFBlSTIxVHVYbW9mczV6bnBNTmlY?=
 =?utf-8?B?OEYwdjErN0UvcVFzbURCU1pFSTZUeFZqcGNFZWJlUU1EbWc4T1U3RXlGRkRs?=
 =?utf-8?B?aHFZcDBoZTFwbC85YThjVjA5Y1VobFkxVCtURDUySWdmTXdibjNYZTY3d2FP?=
 =?utf-8?B?L3VaT2R0QkRUZC93Y25kaXg0UFNBMStZT242Z3c3V2JWUkIvODJYaUdYQWRk?=
 =?utf-8?B?emRmZ09iRWdrSkYzUHV1T2FZZm1mM0NHTHRxMk9RL0tPbTNRdVZ0eFVRVjhV?=
 =?utf-8?B?TnNYNit5ZzdzUWR6VVdmWGpKQVdFNGxrUGtNTlBaRjdKaHVPa05MNC8zWklF?=
 =?utf-8?B?Z1ZoOVpRT1N4c2ErWndLOUpLM1ZMaHhJVnEydXRvc2dkUUNWRUdUeVBZY25w?=
 =?utf-8?B?QTlyQUQ3QjBJK0VRNTBGaytUdEdBZ0U0a3FvaGlld2N0ZW4yNHlQblRGdTI2?=
 =?utf-8?B?aExYQXpPTkJ0T2M1bDduQWJCM2d0YjR2RDZQQVphbjFnUUNQVGVxOXUyRmYx?=
 =?utf-8?B?dDRoUDhsRVg3ZW0yUHN5dk5Lb1Q2VjZjL050WDFMMzU3bXVnTHR1dlYzbkNL?=
 =?utf-8?B?MENFQ1h0UGIrbXlzc3NTMitiNzU1bkc2ZDVkTzF0S0NsU3VvOUtHUE1HZlBW?=
 =?utf-8?B?TjFySFlNVEFRc01qcFUwbTBnUHNZbzZuamQ5cUcyNzZlRTRGZTVWYlpCVnBG?=
 =?utf-8?B?dUUxUUZHQVUrY2wyaUQ2R05Oa3EzNDVaR3hETnpIVWMvMkxyTlphejJueVhp?=
 =?utf-8?B?L3BEbnYwRElkZkdxeFkxbjNUVzRiKzBsbUpRaXZBZXlUdHVSMGs1NkRIeitX?=
 =?utf-8?B?QUlSbkw4a3lka1QvRmc3cHI1VThZYWU4ekVCR3I1dFFPSzJORnB4RWRreW8v?=
 =?utf-8?B?dC9iK2pXZnNYRjBGQzNCRHZJRlRKdWJvYVFZWTc3c01uaTF0VS9Xd0xtT3Va?=
 =?utf-8?B?SXJHMHlzQzdRV05aTU5sZTdpSXVyTzhyN3dQenVmTy9sMyt5R0JoOWgyd2Y5?=
 =?utf-8?B?eWpCc3hvdjZGMEUrSU1JaUQ1RElPME83VDZKWkNSZlRtRloxSXFUc1A1YTNZ?=
 =?utf-8?B?TzA4SXBrR3FsSUcrQUVHNDMxM2tSbmFCNjlPM0tjanhBckZ0ZDhTallOQnhu?=
 =?utf-8?B?a3huQTliZXFYMWgxMEJtRXBuek5UV0cwVzhzTWxyZ2xnSHJ2R3VsL1JUejBH?=
 =?utf-8?B?UkR0MkxPYzk2YktUVWM1US9Fa2hKTXEvYjF1Smk4eDFyeXJVWm1ObTdSbGt5?=
 =?utf-8?B?K1ZISlpHT2xMS0NwaU1lTWszS3piWjZEblV3OUZ2NXBxM3l6V3hHamxiT3BY?=
 =?utf-8?B?bTVoa2tXMklQYWF6YkNrck9welRRNFcvWUZUWjdFL3RaU2tlVWJ2SjBoSXR1?=
 =?utf-8?B?RXZoZ3E5VUVhSzFqL21aY0NtWVIzUkkwZFN4azRUQ0hQU0R1UlNwM09sS3p6?=
 =?utf-8?B?WVd4RTNabTl4akdEOUNrc1Yyd1VpdytsUHFzUDRmdmRuSjJCaFlWK1J4WGpr?=
 =?utf-8?Q?VmNgMkzbBvlAzzT/Pk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1fdd5f6-aead-41fb-4f9f-08de4c789093
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 16:36:24.0198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GsJlallTV1i0pgrEKQTffX8MQocN7D4a+CzrYEzJMacZA9VtPxmIx68rwzrHaHhv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4136
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 332B618000C
X-Stat-Signature: kpodbja37hprxde1jgqcpdnd5j5yaxne
X-HE-Tag: 1767630988-853614
X-HE-Meta: U2FsdGVkX18EHKGlnao02y5AsQG3tMxTRbayRUoPG1ImZfz7jcdJqlQT+KUK8F1NGE/XhYsN9CaDJaCvvw/pHcmejh3axiI9SCS/JvRyiUGF1BUV9tSECVccNKjK4w20LlAJlhTcHcpSm8BycHThhJOXC7sjGwVZXvh8NzEmRuAsbqRZCeM7mCxtZ7IYC+fF0AGxNfDFjIy2ywN7v8eJVZJrM2N++EYqH3zPbbpkUFdixv3KyjE0ShjavR3ZJsOtFHjU+7BX6/Z2wmuysn1700gYe/rRuCeq+Nl/8rdh49IbL1xS3+E7CWkl/Z2z5t8tiyWpi+TG1ZtcoH4iTnMIOYxKPbXgNJi433Po3WK3kYbf8w+ePgppL6ETqPLYNpoTis1JVlX+M9yPuRYOR4G/n9B0h6W1qgZ+njJogFCuBMdWt9S6SDVLL2eKAimhB6vCVXUGF7eUWgu4ruI2Zn++Dla+/ifLJ7CkJA9ZK3jECeOeVnvQllylGscrVLwW0c2oFV3fml7pohBtIprs3spyQJA0StgIulcD/06EzEVAwu00+Xd4qjbwmXbYMcX7ffWZcXT5UT8uKvEAP/wR6/zvKjIVGv8BW99jEcMNf9lNJKMgGnrNs3VZpIVxhIR2E7g8Xll3vMQ7yz/SJnq8x6/kAs+yr/27e14BLuTFAMWhKPZglYX7IPz1zTBlvGZMkV0y1jIy8648RJ4X4em4QKdIEciqb4qRMf0C2eQTuyRGyR5wXlVyGMK99fFUDltxmJa/vi/YfkcKL0aRd91MIRZ3ViazqcFCPccgdpzTz6OwFnbfCW+H2w54BXRokecbMsC9xPx+UdRPUSjAq6MJw9SDgysvbjVQmMiDho023fR7nFErmTP1FYe5kXfBMZ0svl5PNILH1RTlMRZ4w4YcNO4OMcFwNIYIcp13zcTLYQalEz1qstKzZ5DONM5Ix8hEuejrZgd7Nh9yCf2TTd29ryD
 GWM5lldn
 owA3icam1Bc4uDFDiiaHQHduNlhM578D3YwHMAqDmZIClTN5rd+XqfJy331OhWm15kvX/qxZj97tJ+XPMq7AU+ViSn+viuU0pHTJktAUzx6z+SUno9eQn2tStzjsY5E6gKcxz+eECk/eVOJzWoEVZeq+BnvdX/QWm75lFpW+I9G4mQ3zz1yl4+NJIMwip9928bzUyEOcPFsz7GU7koPX9jEWo2qMtOCAGqJxgdXkYPgV/wCNjFJqjeKmTWxe2jnXFvkSOy7RrN2bljxJI46uBKYBP4x69hmb4QmjUlvK2WoAvZFxtbwNFcWqu18wwAz7cKskmcSmXvZwm2oDkpqlBN/HMq9fuOiRYnBti1J6PZAZ1DsKQXUrTBIqAV/pYqZ6Rz7cAQ0+dVWw2CLzaHNIyaR7yva9qMiwgiVKCW84P0oo1FmL8EuzuhDHJ2+bHZyJcQfftNPitbf+7tbSZD1N6/p8jsGxdSooX2B5deDq4UufFpos=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5 Jan 2026, at 11:17, Ryan Roberts wrote:

> Hi All,
>
> A recent change to vmalloc caused some performance benchmark regressions =
(see
> [1]). I'm attempting to fix that (and at the same time signficantly impro=
ve
> beyond the baseline) by freeing a contiguous set of order-0 pages as a ba=
tch.
>
> At the same time I observed that free_contig_range() was essentially doin=
g the
> same thing as vfree() so I've fixed it there too.
>
> I think I've convinced myself that free_pages_prepare() per order-0 page
> followed by a single free_frozen_page_commit() or free_one_page() for the=
 high
> order block is safe/correct, but would be good if a page_alloc expert can
> confirm!
>
> Applies against today's mm-unstable (344d3580dacd). All mm selftests run =
and
> pass.

Kefeng has a series on using frozen pages for alloc_contig*() in mm-new
and touches free_contig_range() as well. You might want to rebase on top
of that.

I like your approach of freeing multiple order-0 pages as a batch, since
they are essentially a non-compound high order page. I also pointed out
a similar optimization when reviewing Kefeng=E2=80=99s patchset[1] (see my =
comment
on __free_contig_frozen_range()).

In terms of rebase, there should be minor for free_contig_range(). In addit=
ion,
maybe your free_prepared_contig_range() can replace __free_contig_frozen_ra=
nge()
in Kefeng=E2=80=99s version to improve performance for both code paths.

I will take a look at the patches. Thanks.

[1] https://lore.kernel.org/linux-mm/D90F7769-F3A8-4234-A9CE-F97BC48CCACE@n=
vidia.com/

>
> Thanks,
> Ryan
>
> Ryan Roberts (2):
>   mm/page_alloc: Optimize free_contig_range()
>   vmalloc: Optimize vfree
>
>  include/linux/gfp.h |   1 +
>  mm/page_alloc.c     | 116 +++++++++++++++++++++++++++++++++++++++-----
>  mm/vmalloc.c        |  29 +++++++----
>  3 files changed, 125 insertions(+), 21 deletions(-)
>
> --
> 2.43.0


Best Regards,
Yan, Zi

