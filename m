Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6592FCA5FD7
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 04:04:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2FE16B0089; Tue, 20 Jan 2026 23:04:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D07336B008A; Tue, 20 Jan 2026 23:04:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC85A6B008C; Tue, 20 Jan 2026 23:04:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A8EFE6B0089
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 23:04:49 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4C5251407CB
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 04:04:49 +0000 (UTC)
X-FDA: 84354629898.26.BA27936
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012066.outbound.protection.outlook.com [52.101.48.66])
	by imf16.hostedemail.com (Postfix) with ESMTP id 43C4A180004
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 04:04:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aKKJMQbc;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.48.66 as permitted sender) smtp.mailfrom=jniethe@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768968286; a=rsa-sha256;
	cv=pass;
	b=DqWt6tPFteEw7+EF3o1YawI/1D2QZU1pGgZEaecuc22YR+Ad7Xp4UizUvXStCa6baPK6dY
	BflyHp+n59RC7fIIVaaLuocWkL6KQYbVX9pm/uAbcRfJG++a6J/Eafx9PQYQdF8n3rP0wB
	aO3f+Ji7k4gbZSzKYg3vyP2SqMrEuBg=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aKKJMQbc;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.48.66 as permitted sender) smtp.mailfrom=jniethe@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768968286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PBffttv8d1xwNnTMeL0YLVQ+HTF4g9W82VdaC3AZmLQ=;
	b=Kz/lGZ26dPjJ4/qDsmJwhyvFsIVbvrcHca8stLhfEDpGyLuzAx7KhTxXCzyWvEEK3PL3pn
	y6l9aIiiLLPsTNJ7fx75PiD7s61/56StN7JFr+wqYaOW9Fgb6ecM4yfXg8Tqx73EB+6Z3H
	ziRCLE8zqviisVekJrNOume4zgNezx4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o0r7+lZgfiCBa5aUN+kSou3upbRK4T+k3L9T5Zb2UYcTjvWdkXAVR2QBVWf0gpji/Mmb6SBJecyuMR3FTRdo5pWwnbC+wfTaM8mrNShz+7a7A3Z17s5OFliu0nB8WSLuDAwHUazoVFsSaDG/Z8KoSjQQnW7iFSh0K3BuR/dMjFYQc/yq5GPoXlKA0Nfubz6YcrW511lh6Z73xLYq0/lMm8r74PP3vELvb2snV+w5Dk81Td+EB/Ub2O0AGNIx5H+gko6/VgOyikbXYjCmXmbtz/ewOFfjV30HznW8FmlitLgUZ/X7IDNBs5xPpvS8Ds/9iheCKbwRiVTOR+NRIGwUMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PBffttv8d1xwNnTMeL0YLVQ+HTF4g9W82VdaC3AZmLQ=;
 b=wn+YUKKGBrI9XX5i65AeXjzu1gIic9naBA4xmp1ijwTflsjGD3Ds/0becqYNGKCMmyZMqXQ+JNBUpgGfRsMBOTJFlfeCRWYC5mamxCWZMkLC1zznyLmiYyzwoBYI3J3nu4+GEY684sz/plVzDYSw32ghFyumLpPkUhkfvBgbkQjEeM3TPtUUFA7rw2Rff9gPw5vtEymS+ofc2tF2OodeGAwNPKfJXHIiL7S56Qr5Dhi/Ly1ywvL+n1o+tSaPyiQwiD+3qukIwPO72N112XGkOIwMGnFHRd2faAjtxjff713aYtc2pF2D4pwD1icOt8eweyCZ/eIZTuzV3Yeqa+8Nog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PBffttv8d1xwNnTMeL0YLVQ+HTF4g9W82VdaC3AZmLQ=;
 b=aKKJMQbcQXLiiDXRDT9bNBtnm9mLYUbIAOqRugci82Lz7/QeBTKTpuBjkquOei/0DQ9yMxhm9f7WXUoN2tQ0rYaUS55UMlvspRDqtaBasQtWdAxJ882N30/HaISxub/JT4roq95EU8zP7O2cmiMbr8BAesCI/rYR2zdLgotT9vyItvMz54cgPxXnl20dal35C6Zmw4cuYOFqaHgd42WwA2QYceNMPpIm+6Able13vIduHsKInzgPf0Lz6ESNd8VDOE5eY1u2manQBl7WrTy34HuQ/e5SpU3z1gbgDY4bSpp8ek8euiyEwdTirBJ0TYW5GOlTjK848nhl8aUUAEBxhQ==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 LV2PR12MB5726.namprd12.prod.outlook.com (2603:10b6:408:17e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.9; Wed, 21 Jan 2026 04:04:40 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9520.011; Wed, 21 Jan 2026
 04:04:39 +0000
Message-ID: <254bd66c-4c0f-44f4-a4a1-87dc44bc5e30@nvidia.com>
Date: Wed, 21 Jan 2026 15:04:29 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/11] mm: Remove device private pages from the
 physical address space
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, balbirs@nvidia.com, matthew.brost@intel.com,
 akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, david@redhat.com, apopple@nvidia.com,
 lorenzo.stoakes@oracle.com, lyude@redhat.com, dakr@kernel.org,
 airlied@gmail.com, simona@ffwll.ch, rcampbell@nvidia.com,
 mpenttil@redhat.com, jgg@nvidia.com, willy@infradead.org,
 linuxppc-dev@lists.ozlabs.org, intel-xe@lists.freedesktop.org, jgg@ziepe.ca,
 Felix.Kuehling@amd.com
References: <20260107091823.68974-1-jniethe@nvidia.com>
 <20260107091823.68974-12-jniethe@nvidia.com>
 <36F96303-8FBB-4350-9472-52CC50BAB956@nvidia.com>
 <c9afedc6-f763-410f-b78b-522b98122f06@nvidia.com>
 <6C5F185E-BB12-4B01-8283-F2C956E84AA3@nvidia.com>
 <fd4b6553-3e9e-4829-a12f-51d29a5d7571@nvidia.com>
 <16770FCE-A248-4184-ABFC-94C02C0B30F3@nvidia.com>
 <649cc20c-161c-4343-8263-3712a4f6dccb@nvidia.com>
 <C2A9F124-9EA8-4916-AB86-659BD280390D@nvidia.com>
Content-Language: en-US
From: Jordan Niethe <jniethe@nvidia.com>
In-Reply-To: <C2A9F124-9EA8-4916-AB86-659BD280390D@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0206.namprd05.prod.outlook.com
 (2603:10b6:a03:330::31) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|LV2PR12MB5726:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ad84f64-8b45-48d8-bd49-08de58a23278
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bEJnaXlROXVSRzJuVXFPRU1hMmYvL1RPRnY0TXR6cDNhTmwybkZaa2xKMDNG?=
 =?utf-8?B?T1FLc3dVUWdLRzNVa08wQ2UwOUdBYjVnS0NHNGZOcnpDeUVidmZTRUhxd3VI?=
 =?utf-8?B?NGgvSHhoTWUzWWNZYmRyTjlrQUhJelU0NVB2dUFsdFlUelpRdXFzRzMyMWZK?=
 =?utf-8?B?dnFvUHgyVDQyQngyRjkwRXpaMHQrRGI3NUl2NTQ1cGJ6MjA4ZWYwS0lyWGUy?=
 =?utf-8?B?OWptcmpjQjNoOFFockJYaXhaSGtKTGI5aWFUUDlaRGMxS0Vic0Flak0rZ3cr?=
 =?utf-8?B?MEhXbE0rVnV0eWNJMWh6NDV6MEFySU53RVFrRDJ3MzFoaGVKdExvTjFYSU1I?=
 =?utf-8?B?d1lXbmN0cTl2WjVEWU02NGNEdnVyU2UzdmlOak5vem1RMW9ad0xrMkJDK2Rw?=
 =?utf-8?B?QnprOGRwS2xvUHNTOHVpVFp1K0F1N0J6cEVzNjJxcFFtUUFkWVVPYjhoRnE5?=
 =?utf-8?B?RFlhWFlOSEF2dU1EaWhCYlhwMzlsRTY0Q1FOT1VFZStxejh6d0x4U0ZLY2JQ?=
 =?utf-8?B?bnZ6cHA5QTNDdGdTUEtoRVUyRlNZcWtVcHhvaEhBOHMveDVQSXE0STJIbFFC?=
 =?utf-8?B?aGRJclcvYUU0WFdqa2pGZ1VVajRsdGs4cmVmTExjcWJqei9iL1JJM2Zoalpl?=
 =?utf-8?B?cFZlQURuZmVUSHhVbEJIOXdBWHYrSzFucE80ZllJN09rOC9TR1NVU1dRWWZZ?=
 =?utf-8?B?cFZWR2VnQWJoL2toRFZiN0hJd1ZxTUJlazNub0Y2YzJCY0UyV0FYTVFPWlhx?=
 =?utf-8?B?c0N1Yit1QUxjdk02VzFkMlpCTkxOYlMxd1hoQUVqbktIbk9wZGQwTTBFSzdP?=
 =?utf-8?B?Sk9sQXBXYWcySnNuQUN4Mm43RGY0UGx1RW5ORHNBMGxXaWRUU24xNUJ5eldM?=
 =?utf-8?B?MWVEVkx4dVJrY1ZwdWJseTZiRTZXY1hhTWhTNUpkWWtJQTBUbUl3bGVmTUJG?=
 =?utf-8?B?bkozQXl2MUdldFVTdCs2K3JwbHhzNmZvM3ZIclZ4ZGhQdnU1dGxZQ0ZFdnk3?=
 =?utf-8?B?dndYUWdpOHU3dTVMMk9sSzRRdGpDU3NpK0ViYjJMbDd2aTBOZE9SdHRTOGYx?=
 =?utf-8?B?T0h3RDVMQkZhSXUwV2lRZnE3S1Y5Uk5mSXJXRTlWZ2R2SGhIMW16UEhqeUZj?=
 =?utf-8?B?amVXWHBaWjVYV0p1cXhHcjBuUkp0VkxSV1NZd1M3NFEvckJORWxxa05NeVdr?=
 =?utf-8?B?OVR5RklCZlJMUHBPdDdkK0c5cTZtb2NUV2tUbjA3anhCNEZOWjFPa2t4S3Rz?=
 =?utf-8?B?LytBTVFpL29iQ1VsSlNXQU9KZG8wbnRnK1pKRTkwV3NETXlmLzArMFpsTG85?=
 =?utf-8?B?Vk8rMHVXOUNnN1lFUHRCRmRuaGpsS2kxZWFrN1FJQmI0ZHJYVGxoL3FRWG5S?=
 =?utf-8?B?Tm5jV1MvSFBBY0F3ZlRmM0duVHhjZjBCR2JrUWYydmM4RURVS3FEL1Zubnd1?=
 =?utf-8?B?cDk2aWFEKzZhbWpBcVd4S2o3TDY0YUIxNFlKN24yM0pTZGNBTVczRVhKVlVw?=
 =?utf-8?B?R2dhaXBqSFFUazVoSE1DdERibEZvYWNvL1Q3dnpXY1RnMVBycVE0blRRbFdN?=
 =?utf-8?B?czhaTGs0OHNFSjg0YksyYmFzM0xPMThhZ1ZIQ2UzODMzWWVLSWVJRUI0d0NO?=
 =?utf-8?B?Z2taQlFwSFhxcHYyY0xEU3FXRmpxemJGNVdtN1dLSGt5Rk1pN3Qzb3FTa0sr?=
 =?utf-8?B?b29VNWJtZEVvVWJ0OXA0RUZNdDNKN1pWTmtzTnE3MW9jY3pRQVlPN0dCNlo4?=
 =?utf-8?B?a0I4T3VoTk5NcGdPQUhNeVc3cVNlM0h3ZGxzWHBrdVp4TkdBVnFpVDQ2dHNC?=
 =?utf-8?B?ZG82NGlqTjJqZG5qd1pLcGpiY3Aza1RNQzdabHBSV1dyNUozZXlPN0pXek5y?=
 =?utf-8?B?WUhOcnpTM1dCeDg4cyt5c01VeWdIdlRRelBhQnZtSUFUaXVNVTlYbEZSa2d0?=
 =?utf-8?B?RHBmekhoRmdMK25VbFJSUkZOa2ZSdEZWL0djRGRSaEZORlJyUUhRdzMwalZR?=
 =?utf-8?B?Y2tYZnFIc1BYS04wNGY4SlN5Wk1qVE9nb29ybitwZWdmeEtlV0VvOWxqdXdz?=
 =?utf-8?B?clREUVF4MFJ0MUhrOE94dXN2NnFQbmZ5TnY2cGJ3ZTJTcitUaVgvaFBoZ1VI?=
 =?utf-8?Q?yJJc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dXVnMWJkMlpHaG8wa0RjTmpPNEdHOHg1aW9XVDBhMzliZWhsdnFMNFdya21E?=
 =?utf-8?B?THdzRGN0K3lsdFFSazl6YTlBWWJ4MXF2cG5zZkhUT2FNUmJhQlZhWHpKZmN3?=
 =?utf-8?B?ZUhtajJSeDN3NVU1V0Foa2Q1OFIwYk1jSzNLT2tCR09pSFVNWTNXc09VVGdC?=
 =?utf-8?B?SUhCenVMcHprakRaV1d3aVJpamQ4djNXb3ZHZ01ha0toaVQvZU13WFkzeng0?=
 =?utf-8?B?SE1MRUFKVW50aS9UT1VNTWFVN1BUYlhCUXhFSGtOZmRQTFBUcmZEMUtaZUU4?=
 =?utf-8?B?QlYxdDkzakxPTjB4SXROVkpiMzZhU01xUDlXNmF1NFRHZTFEcmtoSVg1MVBN?=
 =?utf-8?B?S3IxUlg5cGN4N0dyVEl2eHZBRXJjRG9XYjJKZGNjUHZyZjloaVRpUzB1L0k2?=
 =?utf-8?B?T2E3djE5dXYrV1IvdWNsVkdjTVI5ZlhWTXNOa1hNNzY0SjlLcXBGUVZ6Uk9Z?=
 =?utf-8?B?aTc1a1YzY3ZielE4ZGY3Q1JMZmlkdENVd2xWLzJlTS9KNXFVNWdWblIzNGlO?=
 =?utf-8?B?eFNHbTVtajFQS3pyYW96NWlZOXFEcmF4YXRaWlpQRHVzVjhLNTJaenM3RVIr?=
 =?utf-8?B?NFZ4Z042cUVvMjFsV0xBeStNM3B3dC9ydDRBd000Mm5BSEltMWM0eVNkcTQz?=
 =?utf-8?B?d1M0dTVFVTVmWkJmd3ViUVRQZmozcWdkYkhibDQraWJsODhFYWcwOUxvdWVQ?=
 =?utf-8?B?OWRHM2xseHphNzZrVDg2R0h4bWZGR3FidThoMnFqWkpjWThIeWNmZFB1dzND?=
 =?utf-8?B?YmIvRTVSM3ZsWW93bmtZQXlieUNNcUl5ZjlyWlQ1MzlQaEszSEtrekxPOE5y?=
 =?utf-8?B?T2xhM2JYYis3RkZtRklDTVVRY3FtQXJVcXRjVUpCbXlRM09sa3ZPTmNwSzBP?=
 =?utf-8?B?bXdhLzUyVGRYenB0Z3lCQmxQWnVEYzVFQkV3ZmFia2JGODZ5dFBhM3B0QzBT?=
 =?utf-8?B?WWp6V2xaMmVkdFAvSkcrRU80VnNPN20rRlRTSVBIRFVQTlQraWRpL2dHUVpV?=
 =?utf-8?B?cDZaWjZ4eW5OVnUyWk1oeWZaZmFVUTNTUTVpNVpLakFWOXNiK0JNTTZseFhX?=
 =?utf-8?B?WndISmlZSEcyU3FJaVBtQWNOWE96VG9mWkFyVW95cDVpenMrTjVZRGc4dUdZ?=
 =?utf-8?B?T0tBSXBwQ0g3QXJoVVcxcDJSWXVocm5QUEVjN0dYakQ0R3FnYkNsRlNPNnlm?=
 =?utf-8?B?SVlqdUhCbVhTTGR4MUFxVDZmMGMwcWljOVlLNGsvSnRwaEY0VGhtc0JMRnIw?=
 =?utf-8?B?MVBLcXl4RnU4RUlwZXFWNEN6Sit4VElLcWxlWHpBd1lwdTVCUmNiUkpNM09p?=
 =?utf-8?B?NVVKVnorU3I4cW5ZOG1kcXB4Q3hsclp6T2VMaFgzV2Jxc1VzcjBtdDloR3p5?=
 =?utf-8?B?RlBPWHRkT1JrczdJYjJVL3VKcSswL0FZMldBT0ZjRWtEaVZTaDZaazlMMkow?=
 =?utf-8?B?eWVRZ0thV29QRjU1dTlLL3RaS0lYeTJxckV6TnBmOVlYa08ydmlCZTE4clRj?=
 =?utf-8?B?R3pGWkh4RlZyNlZOY1EvZWVCbDdZcGRJdnNDM24yZzhXV1M5OEpHajkrMHdt?=
 =?utf-8?B?R3JER0F4Z1V0UWR2VTBreTdyeGw0VVhtYlJUTytKTFlxb0poaEFyTDY1cmFM?=
 =?utf-8?B?UmFGcCtTRGtRekM5bmlSemxpanZNcGZnSHlWSmE3K2xrM1ZEdHE3STdRdFQ2?=
 =?utf-8?B?NFV3bDRUNjd1eWxDYU1GMzMwcTB5d05vOUc2RjNCbW5ZeFdHRGM1N2grdm5Y?=
 =?utf-8?B?SDhuVHQ1ejg1TlE4S2ZYZ1dBWldBZ3VQcmlXNlJ5bThhWkhpRFhyYS9uWk1Q?=
 =?utf-8?B?aGIwOU1EVnV4VE1sVjJabjJHRm1BTXB2aHpRZE80U3o5cWQ3aExHYkdHeHYw?=
 =?utf-8?B?UDZFNXBGMDNVWlc5anplTXIyWDlFaGZOanA0NGk5N3NWeDBoTU9FVFZ1c3lD?=
 =?utf-8?B?ZkhOKzJpTTVsYnpqL3ZjS0dTMEVJU3A3ODJ2dU9lbEtxWUtPazVQOUdUZ2dw?=
 =?utf-8?B?OVlHRDlXUTdndGwvSjU2NTVvUysyaVVmWkk4VUtzdkhjNHAwcFdQTlRZZ01n?=
 =?utf-8?B?TGhWL2V2N2x4Y0lrdzhQaEU4V2IyQ01lVkF6cEtGd0lua0R5OTZaV2FDMTFX?=
 =?utf-8?B?aGxheXNDZGVFMGxTSEpPUmhNSmcrNHAwTDcySjRVdWhxNkVlS2FwVGRWd1h5?=
 =?utf-8?B?d01XMUVZZkNHWktUc3lEcDQrek53TENFZkt0MElIMTFXWVdic2IyczJ6OTRF?=
 =?utf-8?B?bFJEOE5YSk5hcUV4ajlYVnUyeUd3RkxLWlVSMm9ORUZ6QzhjaU9uR0kranRk?=
 =?utf-8?B?WGVzZXVRcWwydkxMNDBDSTRmdUhHZ0dVMThrdDlsOUh4R2xDYmVMZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ad84f64-8b45-48d8-bd49-08de58a23278
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 04:04:39.6121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o6v14zjODi/WB+OX2MmQfd6DTbvgvl6zvfqU4Ov2WLcyevmnCsjNEjmzRx80YbBNoZYqz6zZkllpViTaAgFPFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5726
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 43C4A180004
X-Stat-Signature: g6q675k64z4x4s864ufx9tnucrqojysn
X-HE-Tag: 1768968286-27105
X-HE-Meta: U2FsdGVkX1+kjDeu0uUehpvQaZY/u5B7wRJco5ahTSs3QqsuCl7JmgFueycNQwHk/Yr692YufqKo4YytZYgZPH95YLiUZzZyh3s/7EeTkvM5gBPwUgo1HcHLvxEbDKIuP8sx7IBBxSuxsCIO99CzBTwAF8dU9d0bUntNXoiL5gKy/DqCvw/knOGGC8dZ/gGl0Jmgn0ZlZjk5BY7HeczrxWpVWQ7roLVRNjVfTDcinskqcwLDSX/tY2mfYKWNotTYrzZf35k0ZiDUWS6TgY/Fsoh/dD9GzZAuQeZpA8BHeLZw/YfUBIFZUphk/S22dAuX7Y37i8DRW+Uq9Mc/Davo3TcaUrvXbhnr2jZoXW9DcyBws5xPWUabtHgEfdHkNbA8ojgyNqKR6sKpJ5hHS+LLfgD/vkw7MspBjwpwU4BLh6Xzu9+cRtnk5SNJ1GrdyiIngMW+8WCU3GldbPjkxy0m9p/VLWKYPeyC2sPmMbdd/9jsufGOIunBWcl11B1Z+W6hTVobwKJ1eqFNjB0/aVKQblBZ2ucdWkaDSHa9mX/0apMTP6qA8ZqEhLUNBXkxOsAtBhd/pynY1ZuqjCqjQ9MVSYF1EjCj4dwMXk2ZeoT2iJhwJiGtoDMEsHvlUH+9v/yo/3qIIt3tRAQdz5P+rw2zAysZODHs+ksYJNPqDszaUyxsBNp4OFFdlzoJ7xPycVxUP3nwGJdm4EV0+shnQjesM+ZOLhJjuPxboHzc3wHnrAlsuuqAKgUk4gUYzT6g/YMPtA0Gcd8+1Y0PKRJeSSIlcr+yTUF0DLbOl3rkQj5Mn6c5NS10S9jJf5cGK8veYzySeJCghRkTDKF9av85zykJQ5CQnQMGGg0lSc5hQ/VkWg38TXvb0ssJa9nGA9STX8m/FsLEIE+hvTvs47sw8iqeusnZzAdsvvbqbZImq1099EQrqWjgfETuak9oycJCHyQSA8RB9ESsFKEFzbg0C4t
 MyyJorci
 ukSg8y3x3MDU8N4xCJn2qDhkpjAuC0PBcXqdheMMdEw+UHWiF9ucG2thvgTcnTXaqadhIF42ATxJvQ+kS0v7yMYSB1OglTLPbEwMQTjOOzJH2MYev0VTW7OCmH2JJRRbqu/BTmffHX83geFLkgV+eZ8JxXBBY2cbjq4byPMqn7OLj1NZY+HwpUCkxnPOTYMKj2Yqmgr+Cj35BZUqyA878vNr8TiT6OKprx4WMEl3U4ss+1dz9HSJev7+oWO9gIJu48mgNNfH2NTCirrJjvnhfMOKtWrtJ6kCowikoWoSGbQx1mrAeW3t7IfXnWEQ+bQycxVmh2sh20GcYvBdRvyz482z4kcgFqe7/yZnEAd2tyQSQsyZvVFA1O+hDdb+HJ45E4U6MtC7VVJcWf2XqJdNsSHavxVDgE+t641NuKN3cOxW3nAhfaqEamBRrrjcZCcTVVahuMK3uQbKcIKNS6m30sXno2Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21/1/26 13:41, Zi Yan wrote:
> On 20 Jan 2026, at 18:34, Jordan Niethe wrote:
> 
>> Hi,
>>
>> On 21/1/26 10:06, Zi Yan wrote:
>>> On 20 Jan 2026, at 18:02, Jordan Niethe wrote:
>>>
>>>> Hi,
>>>>
>>>> On 21/1/26 09:53, Zi Yan wrote:
>>>>> On 20 Jan 2026, at 17:33, Jordan Niethe wrote:
>>>>>
>>>>>> On 14/1/26 07:04, Zi Yan wrote:
>>>>>>> On 7 Jan 2026, at 4:18, Jordan Niethe wrote:
>>>>>>>
>>>>>>>> Currently when creating these device private struct pages, the first
>>>>>>>> step is to use request_free_mem_region() to get a range of physical
>>>>>>>> address space large enough to represent the devices memory. This
>>>>>>>> allocated physical address range is then remapped as device private
>>>>>>>> memory using memremap_pages().
>>>>>>>>
>>>>>>>> Needing allocation of physical address space has some problems:
>>>>>>>>
>>>>>>>>       1) There may be insufficient physical address space to represent the
>>>>>>>>          device memory. KASLR reducing the physical address space and VM
>>>>>>>>          configurations with limited physical address space increase the
>>>>>>>>          likelihood of hitting this especially as device memory increases. This
>>>>>>>>          has been observed to prevent device private from being initialized.
>>>>>>>>
>>>>>>>>       2) Attempting to add the device private pages to the linear map at
>>>>>>>>          addresses beyond the actual physical memory causes issues on
>>>>>>>>          architectures like aarch64 meaning the feature does not work there.
>>>>>>>>
>>>>>>>> Instead of using the physical address space, introduce a device private
>>>>>>>> address space and allocate devices regions from there to represent the
>>>>>>>> device private pages.
>>>>>>>>
>>>>>>>> Introduce a new interface memremap_device_private_pagemap() that
>>>>>>>> allocates a requested amount of device private address space and creates
>>>>>>>> the necessary device private pages.
>>>>>>>>
>>>>>>>> To support this new interface, struct dev_pagemap needs some changes:
>>>>>>>>
>>>>>>>>       - Add a new dev_pagemap::nr_pages field as an input parameter.
>>>>>>>>       - Add a new dev_pagemap::pages array to store the device
>>>>>>>>         private pages.
>>>>>>>>
>>>>>>>> When using memremap_device_private_pagemap(), rather then passing in
>>>>>>>> dev_pagemap::ranges[dev_pagemap::nr_ranges] of physical address space to
>>>>>>>> be remapped, dev_pagemap::nr_ranges will always be 1, and the device
>>>>>>>> private range that is reserved is returned in dev_pagemap::range.
>>>>>>>>
>>>>>>>> Forbid calling memremap_pages() with dev_pagemap::ranges::type =
>>>>>>>> MEMORY_DEVICE_PRIVATE.
>>>>>>>>
>>>>>>>> Represent this device private address space using a new
>>>>>>>> device_private_pgmap_tree maple tree. This tree maps a given device
>>>>>>>> private address to a struct dev_pagemap, where a specific device private
>>>>>>>> page may then be looked up in that dev_pagemap::pages array.
>>>>>>>>
>>>>>>>> Device private address space can be reclaimed and the assoicated device
>>>>>>>> private pages freed using the corresponding new
>>>>>>>> memunmap_device_private_pagemap() interface.
>>>>>>>>
>>>>>>>> Because the device private pages now live outside the physical address
>>>>>>>> space, they no longer have a normal PFN. This means that page_to_pfn(),
>>>>>>>> et al. are no longer meaningful.
>>>>>>>>
>>>>>>>> Introduce helpers:
>>>>>>>>
>>>>>>>>       - device_private_page_to_offset()
>>>>>>>>       - device_private_folio_to_offset()
>>>>>>>>
>>>>>>>> to take a given device private page / folio and return its offset within
>>>>>>>> the device private address space.
>>>>>>>>
>>>>>>>> Update the places where we previously converted a device private page to
>>>>>>>> a PFN to use these new helpers. When we encounter a device private
>>>>>>>> offset, instead of looking up its page within the pagemap use
>>>>>>>> device_private_offset_to_page() instead.
>>>>>>>>
>>>>>>>> Update the existing users:
>>>>>>>>
>>>>>>>>      - lib/test_hmm.c
>>>>>>>>      - ppc ultravisor
>>>>>>>>      - drm/amd/amdkfd
>>>>>>>>      - gpu/drm/xe
>>>>>>>>      - gpu/drm/nouveau
>>>>>>>>
>>>>>>>> to use the new memremap_device_private_pagemap() interface.
>>>>>>>>
>>>>>>>> Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
>>>>>>>> Signed-off-by: Alistair Popple <apopple@nvidia.com>
>>>>>>>>
>>>>>>>> ---
>>>>>>>>
>>>>>>>> NOTE: The updates to the existing drivers have only been compile tested.
>>>>>>>> I'll need some help in testing these drivers.
>>>>>>>>
>>>>>>>> v1:
>>>>>>>> - Include NUMA node paramater for memremap_device_private_pagemap()
>>>>>>>> - Add devm_memremap_device_private_pagemap() and friends
>>>>>>>> - Update existing users of memremap_pages():
>>>>>>>>         - ppc ultravisor
>>>>>>>>         - drm/amd/amdkfd
>>>>>>>>         - gpu/drm/xe
>>>>>>>>         - gpu/drm/nouveau
>>>>>>>> - Update for HMM huge page support
>>>>>>>> - Guard device_private_offset_to_page and friends with CONFIG_ZONE_DEVICE
>>>>>>>>
>>>>>>>> v2:
>>>>>>>> - Make sure last member of struct dev_pagemap remains DECLARE_FLEX_ARRAY(struct range, ranges);
>>>>>>>> ---
>>>>>>>>      Documentation/mm/hmm.rst                 |  11 +-
>>>>>>>>      arch/powerpc/kvm/book3s_hv_uvmem.c       |  41 ++---
>>>>>>>>      drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |  23 +--
>>>>>>>>      drivers/gpu/drm/nouveau/nouveau_dmem.c   |  35 ++--
>>>>>>>>      drivers/gpu/drm/xe/xe_svm.c              |  28 +---
>>>>>>>>      include/linux/hmm.h                      |   3 +
>>>>>>>>      include/linux/leafops.h                  |  16 +-
>>>>>>>>      include/linux/memremap.h                 |  64 +++++++-
>>>>>>>>      include/linux/migrate.h                  |   6 +-
>>>>>>>>      include/linux/mm.h                       |   2 +
>>>>>>>>      include/linux/rmap.h                     |   5 +-
>>>>>>>>      include/linux/swapops.h                  |  10 +-
>>>>>>>>      lib/test_hmm.c                           |  69 ++++----
>>>>>>>>      mm/debug.c                               |   9 +-
>>>>>>>>      mm/memremap.c                            | 193 ++++++++++++++++++-----
>>>>>>>>      mm/mm_init.c                             |   8 +-
>>>>>>>>      mm/page_vma_mapped.c                     |  19 ++-
>>>>>>>>      mm/rmap.c                                |  43 +++--
>>>>>>>>      mm/util.c                                |   5 +-
>>>>>>>>      19 files changed, 391 insertions(+), 199 deletions(-)
>>>>>>>>
>>>>>>> <snip>
>>>>>>>
>>>>>>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>>>>>>> index e65329e1969f..b36599ab41ba 100644
>>>>>>>> --- a/include/linux/mm.h
>>>>>>>> +++ b/include/linux/mm.h
>>>>>>>> @@ -2038,6 +2038,8 @@ static inline unsigned long memdesc_section(memdesc_flags_t mdf)
>>>>>>>>       */
>>>>>>>>      static inline unsigned long folio_pfn(const struct folio *folio)
>>>>>>>>      {
>>>>>>>> +	VM_BUG_ON(folio_is_device_private(folio));
>>>>>>>
>>>>>>> Please use VM_WARN_ON instead.
>>>>>>
>>>>>> ack.
>>>>>>
>>>>>>>
>>>>>>>> +
>>>>>>>>      	return page_to_pfn(&folio->page);
>>>>>>>>      }
>>>>>>>>
>>>>>>>> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
>>>>>>>> index 57c63b6a8f65..c1561a92864f 100644
>>>>>>>> --- a/include/linux/rmap.h
>>>>>>>> +++ b/include/linux/rmap.h
>>>>>>>> @@ -951,7 +951,7 @@ static inline unsigned long page_vma_walk_pfn(unsigned long pfn)
>>>>>>>>      static inline unsigned long folio_page_vma_walk_pfn(const struct folio *folio)
>>>>>>>>      {
>>>>>>>>      	if (folio_is_device_private(folio))
>>>>>>>> -		return page_vma_walk_pfn(folio_pfn(folio)) |
>>>>>>>> +		return page_vma_walk_pfn(device_private_folio_to_offset(folio)) |
>>>>>>>>      		       PVMW_PFN_DEVICE_PRIVATE;
>>>>>>>>
>>>>>>>>      	return page_vma_walk_pfn(folio_pfn(folio));
>>>>>>>> @@ -959,6 +959,9 @@ static inline unsigned long folio_page_vma_walk_pfn(const struct folio *folio)
>>>>>>>>
>>>>>>>>      static inline struct page *page_vma_walk_pfn_to_page(unsigned long pvmw_pfn)
>>>>>>>>      {
>>>>>>>> +	if (pvmw_pfn & PVMW_PFN_DEVICE_PRIVATE)
>>>>>>>> +		return device_private_offset_to_page(pvmw_pfn >> PVMW_PFN_SHIFT);
>>>>>>>> +
>>>>>>>>      	return pfn_to_page(pvmw_pfn >> PVMW_PFN_SHIFT);
>>>>>>>>      }
>>>>>>>
>>>>>>> <snip>
>>>>>>>
>>>>>>>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>>>>>>> index 96c525785d78..141fe5abd33f 100644
>>>>>>>> --- a/mm/page_vma_mapped.c
>>>>>>>> +++ b/mm/page_vma_mapped.c
>>>>>>>> @@ -107,6 +107,7 @@ static bool map_pte(struct page_vma_mapped_walk *pvmw, pmd_t *pmdvalp,
>>>>>>>>      static bool check_pte(struct page_vma_mapped_walk *pvmw, unsigned long pte_nr)
>>>>>>>>      {
>>>>>>>>      	unsigned long pfn;
>>>>>>>> +	bool device_private = false;
>>>>>>>>      	pte_t ptent = ptep_get(pvmw->pte);
>>>>>>>>
>>>>>>>>      	if (pvmw->flags & PVMW_MIGRATION) {
>>>>>>>> @@ -115,6 +116,9 @@ static bool check_pte(struct page_vma_mapped_walk *pvmw, unsigned long pte_nr)
>>>>>>>>      		if (!softleaf_is_migration(entry))
>>>>>>>>      			return false;
>>>>>>>>
>>>>>>>> +		if (softleaf_is_migration_device_private(entry))
>>>>>>>> +			device_private = true;
>>>>>>>> +
>>>>>>>>      		pfn = softleaf_to_pfn(entry);
>>>>>>>>      	} else if (pte_present(ptent)) {
>>>>>>>>      		pfn = pte_pfn(ptent);
>>>>>>>> @@ -127,8 +131,14 @@ static bool check_pte(struct page_vma_mapped_walk *pvmw, unsigned long pte_nr)
>>>>>>>>      			return false;
>>>>>>>>
>>>>>>>>      		pfn = softleaf_to_pfn(entry);
>>>>>>>> +
>>>>>>>> +		if (softleaf_is_device_private(entry))
>>>>>>>> +			device_private = true;
>>>>>>>>      	}
>>>>>>>>
>>>>>>>> +	if ((device_private) ^ !!(pvmw->pfn & PVMW_PFN_DEVICE_PRIVATE))
>>>>>>>> +		return false;
>>>>>>>> +
>>>>>>>>      	if ((pfn + pte_nr - 1) < (pvmw->pfn >> PVMW_PFN_SHIFT))
>>>>>>>>      		return false;
>>>>>>>>      	if (pfn > ((pvmw->pfn >> PVMW_PFN_SHIFT) + pvmw->nr_pages - 1))
>>>>>>>> @@ -137,8 +147,11 @@ static bool check_pte(struct page_vma_mapped_walk *pvmw, unsigned long pte_nr)
>>>>>>>>      }
>>>>>>>>
>>>>>>>>      /* Returns true if the two ranges overlap.  Careful to not overflow. */
>>>>>>>> -static bool check_pmd(unsigned long pfn, struct page_vma_mapped_walk *pvmw)
>>>>>>>> +static bool check_pmd(unsigned long pfn, bool device_private, struct page_vma_mapped_walk *pvmw)
>>>>>>>>      {
>>>>>>>> +	if ((device_private) ^ !!(pvmw->pfn & PVMW_PFN_DEVICE_PRIVATE))
>>>>>>>> +		return false;
>>>>>>>> +
>>>>>>>>      	if ((pfn + HPAGE_PMD_NR - 1) < (pvmw->pfn >> PVMW_PFN_SHIFT))
>>>>>>>>      		return false;
>>>>>>>>      	if (pfn > (pvmw->pfn >> PVMW_PFN_SHIFT) + pvmw->nr_pages - 1)
>>>>>>>> @@ -255,6 +268,8 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>>>>>>>
>>>>>>>>      				if (!softleaf_is_migration(entry) ||
>>>>>>>>      				    !check_pmd(softleaf_to_pfn(entry),
>>>>>>>> +					       softleaf_is_device_private(entry) ||
>>>>>>>> +					       softleaf_is_migration_device_private(entry),
>>>>>>>>      					       pvmw))
>>>>>>>>      					return not_found(pvmw);
>>>>>>>>      				return true;
>>>>>>>> @@ -262,7 +277,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>>>>>>>      			if (likely(pmd_trans_huge(pmde))) {
>>>>>>>>      				if (pvmw->flags & PVMW_MIGRATION)
>>>>>>>>      					return not_found(pvmw);
>>>>>>>> -				if (!check_pmd(pmd_pfn(pmde), pvmw))
>>>>>>>> +				if (!check_pmd(pmd_pfn(pmde), false, pvmw))
>>>>>>>>      					return not_found(pvmw);
>>>>>>>>      				return true;
>>>>>>>>      			}
>>>>>>>
>>>>>>> It seems to me that you can add a new flag like “bool is_device_private” to
>>>>>>> indicate whether pfn is a device private index instead of pfn without
>>>>>>> manipulating pvmw->pfn itself.
>>>>>>
>>>>>> We could do it like that, however my concern with using a new param was that
>>>>>> storing this info seperately might make it easier to misuse a device private
>>>>>> index as a regular pfn.
>>>>>>
>>>>>> It seemed like it could be easy to overlook both when creating the pvmw and
>>>>>> then when accessing the pfn.
>>>>>
>>>>> That is why I asked for a helper function like page_vma_walk_pfn(pvmw) to
>>>>> return the converted pfn instead of pvmw->pfn directly. You can add a comment
>>>>> to ask people to use helper function and even mark pvmw->pfn /* do not use
>>>>> directly */.
>>>>
>>>> Yeah I agree that is a good idea.
>>>>
>>>>>
>>>>> In addition, your patch manipulates pfn by left shifting it by 1. Are you sure
>>>>> there is no weird arch having pfns with bit 63 being 1? Your change could
>>>>> break it, right?
>>>>
>>>> Currently for migrate pfns we left shift by pfns by MIGRATE_PFN_SHIFT (6), so I
>>>> thought doing something similiar here should be safe.
>>>
>>> Yeah, but that limits to archs supporting HMM. page_vma_mapped_walk is used
>>> by almost every arch, so it has a broader impact.
>>
>> That is a good point.
>>
>> I see a few options:
>>
>> - On every arch we can assume SWP_PFN_BITS? I could add a sanity check that we
>>    have an extra bit on top of SWP_PFN_BITS within an unsigned long.
> 
> Yes, but if there is no extra bit, are you going to disable device private
> pages?

In this case, migrate PFNs would also be broken (due to MIGRATE_PFN_SHIFT) so we'd have to.

> 
>> - We could define PVMW_PFN_SHIFT as 0 if !CONFIG_MIGRATION as the flag is not
>>    required.
> 
> Sure, or !CONFIG_DEVICE_MIGRATION
> 
>> - Instead of modifying pvmw->pfn we could use pvmw->flags but that has the
>>    issues of separating the offset type and offset.
> 
> It seems that I was not clear on my proposal. Here is the patch on top of
> your patchset and it compiles.

Oh I'd interpreted “bool is_device_private” as adding a new field to pvmw.

> 
> Basically, pvmw->pfn stores either PFN or device private offset without
> additional shift. Caller interprets pvmw->pfn based on
> pvmw->flags & PVMW_DEVICE_PRIVATE. And you can ignore my helper function
> of pvmw->pfn suggestion, since my patch below can use pvmw->pfn directly.

Thanks, looks reasonable. I'll try it.

Thanks,
Jordan.

> 
> Let me know if my patch works. Thanks.
> 
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index c1561a92864f..4423f0e886aa 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -921,6 +921,7 @@ struct page *make_device_exclusive(struct mm_struct *mm, unsigned long addr,
>   #define PVMW_SYNC		(1 << 0)
>   /* Look for migration entries rather than present PTEs */
>   #define PVMW_MIGRATION		(1 << 1)
> +#define PVMW_DEVICE_PRIVATE	(1 << 2)
> 
>   /* Result flags */
> 
> @@ -943,6 +944,13 @@ struct page_vma_mapped_walk {
>   #define PVMW_PFN_DEVICE_PRIVATE	(1UL << 0)
>   #define PVMW_PFN_SHIFT		1
> 
> +static inline unsigned long page_vma_walk_flags(struct folio *folio, unsigned long flags)
> +{
> +	if (folio_is_device_private(folio))
> +		return flags | PVMW_DEVICE_PRIVATE;
> +	return flags;
> +}
> +
>   static inline unsigned long page_vma_walk_pfn(unsigned long pfn)
>   {
>   	return (pfn << PVMW_PFN_SHIFT);
> @@ -951,23 +959,16 @@ static inline unsigned long page_vma_walk_pfn(unsigned long pfn)
>   static inline unsigned long folio_page_vma_walk_pfn(const struct folio *folio)
>   {
>   	if (folio_is_device_private(folio))
> -		return page_vma_walk_pfn(device_private_folio_to_offset(folio)) |
> -		       PVMW_PFN_DEVICE_PRIVATE;
> -
> -	return page_vma_walk_pfn(folio_pfn(folio));
> -}
> -
> -static inline struct page *page_vma_walk_pfn_to_page(unsigned long pvmw_pfn)
> -{
> -	if (pvmw_pfn & PVMW_PFN_DEVICE_PRIVATE)
> -		return device_private_offset_to_page(pvmw_pfn >> PVMW_PFN_SHIFT);
> +		return device_private_folio_to_offset(folio);
> 
> -	return pfn_to_page(pvmw_pfn >> PVMW_PFN_SHIFT);
> +	return (folio_pfn(folio));
>   }
> 
> -static inline struct folio *page_vma_walk_pfn_to_folio(unsigned long pvmw_pfn)
> +static inline struct folio *page_vma_walk_pfn_to_folio(struct page_vma_mapped_walk *pvmw)
>   {
> -	return page_folio(page_vma_walk_pfn_to_page(pvmw_pfn));
> +	if (pvmw->flags & PVMW_DEVICE_PRIVATE)
> +		return page_folio(device_private_offset_to_page(pvmw->pfn));
> +	return pfn_folio(pvmw->pfn);
>   }
> 
>   #define DEFINE_FOLIO_VMA_WALK(name, _folio, _vma, _address, _flags)	\
> @@ -977,7 +978,7 @@ static inline struct folio *page_vma_walk_pfn_to_folio(unsigned long pvmw_pfn)
>   		.pgoff = folio_pgoff(_folio),				\
>   		.vma = _vma,						\
>   		.address = _address,					\
> -		.flags = _flags,					\
> +		.flags = page_vma_walk_flags(_folio, _flags),		\
>   	}
> 
>   static inline void page_vma_mapped_walk_done(struct page_vma_mapped_walk *pvmw)
> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> index 141fe5abd33f..e61a0e49a7c9 100644
> --- a/mm/page_vma_mapped.c
> +++ b/mm/page_vma_mapped.c
> @@ -136,12 +136,12 @@ static bool check_pte(struct page_vma_mapped_walk *pvmw, unsigned long pte_nr)
>   			device_private = true;
>   	}
> 
> -	if ((device_private) ^ !!(pvmw->pfn & PVMW_PFN_DEVICE_PRIVATE))
> +	if ((device_private) ^ !!(pvmw->flags & PVMW_DEVICE_PRIVATE))
>   		return false;
> 
> -	if ((pfn + pte_nr - 1) < (pvmw->pfn >> PVMW_PFN_SHIFT))
> +	if ((pfn + pte_nr - 1) < pvmw->pfn)
>   		return false;
> -	if (pfn > ((pvmw->pfn >> PVMW_PFN_SHIFT) + pvmw->nr_pages - 1))
> +	if (pfn > (pvmw->pfn + pvmw->nr_pages - 1))
>   		return false;
>   	return true;
>   }
> @@ -149,12 +149,12 @@ static bool check_pte(struct page_vma_mapped_walk *pvmw, unsigned long pte_nr)
>   /* Returns true if the two ranges overlap.  Careful to not overflow. */
>   static bool check_pmd(unsigned long pfn, bool device_private, struct page_vma_mapped_walk *pvmw)
>   {
> -	if ((device_private) ^ !!(pvmw->pfn & PVMW_PFN_DEVICE_PRIVATE))
> +	if ((device_private) ^ !!(pvmw->flags & PVMW_DEVICE_PRIVATE))
>   		return false;
> 
> -	if ((pfn + HPAGE_PMD_NR - 1) < (pvmw->pfn >> PVMW_PFN_SHIFT))
> +	if ((pfn + HPAGE_PMD_NR - 1) < pvmw->pfn)
>   		return false;
> -	if (pfn > (pvmw->pfn >> PVMW_PFN_SHIFT) + pvmw->nr_pages - 1)
> +	if (pfn > pvmw->pfn + pvmw->nr_pages - 1)
>   		return false;
>   	return true;
>   }
> @@ -369,7 +369,7 @@ unsigned long page_mapped_in_vma(const struct page *page,
>   		.pfn = folio_page_vma_walk_pfn(folio),
>   		.nr_pages = 1,
>   		.vma = vma,
> -		.flags = PVMW_SYNC,
> +		.flags = page_vma_walk_flags(folio, PVMW_SYNC),
>   	};
> 
>   	pvmw.address = vma_address(vma, page_pgoff(folio, page), 1);
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index be5682d345b5..5d81939bf12a 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4203,7 +4203,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
>   	pte_t *pte = pvmw->pte;
>   	unsigned long addr = pvmw->address;
>   	struct vm_area_struct *vma = pvmw->vma;
> -	struct folio *folio = page_vma_walk_pfn_to_folio(pvmw->pfn);
> +	struct folio *folio = page_vma_walk_pfn_to_folio(pvmw);
>   	struct mem_cgroup *memcg = folio_memcg(folio);
>   	struct pglist_data *pgdat = folio_pgdat(folio);
>   	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
> 
> 
> 
> 
> 
> Best Regards,
> Yan, Zi


