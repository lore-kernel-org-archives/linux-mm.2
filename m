Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF575D232C6
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 23:41:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 464476B0089; Thu,  8 Jan 2026 18:41:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 412486B008A; Thu,  8 Jan 2026 18:41:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E98D6B0092; Thu,  8 Jan 2026 18:41:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F59B6B0089
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 18:41:27 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C1F0C8B46C
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 23:41:26 +0000 (UTC)
X-FDA: 84310420572.15.250CA23
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013053.outbound.protection.outlook.com [40.93.201.53])
	by imf03.hostedemail.com (Postfix) with ESMTP id E585620011
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 23:41:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=TMXOe7zs;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of jniethe@nvidia.com designates 40.93.201.53 as permitted sender) smtp.mailfrom=jniethe@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767915684; a=rsa-sha256;
	cv=pass;
	b=OjZAFMqPhLRsV/0P+mWVo1op94mMmuxhVpqNXUgAlmc2hEwa/yBfybKvjEmofiovCFLqmD
	hfBLCZE/Nvesze1UlGlIELBTgesYMpIlRLGqdsaVDMIvS47GGIuuZdLFjs+zpO/oltEIKb
	GjumvLy7OptixPEexKF2BydaTcBaInc=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=TMXOe7zs;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of jniethe@nvidia.com designates 40.93.201.53 as permitted sender) smtp.mailfrom=jniethe@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767915684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lEjHDZZC97K3WCYH8fG6Iwu5wzGnnCM7C2bIlMjJ8nA=;
	b=UmNFe0D/qWp3zV5hQK+HJWHfETWVttLLHditBPijBKWye4nIs2dIoekEKafvvrNKzvmZIe
	mzu58x6TTL7MwjUaX9C9JCOOnNWigRFijS/GYWsZN/jMg0ntuqB2eiJqtohHXKzHndatmB
	LJdtSqTaLQleD6t5mlEjnPkM/Z68svo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tekkW5XICDFWsv1X0V8AmhCAmXx4WrnVs1J1sXStPS2By1WObDTKzrkLPpmmo7VcO4RFXzJmh/CYNw1ht7LtOZ/NAA8abzKlKhaGe4B3JdC9ftcUVB9/u9MewxXiEVH1rmzgUB6bXz4DKJh4EeDEJsudeyZldca8wt6aEuO4fRiuGNG7FyM2BxsxP1KQd7VhicMUxdZrG43u0f6Zy3QWMp7Qha14TrQ8twqaccht3f0KL7Vs1qtxtckFhelseIvu1uw/NDdo5477qyIu+EzG1+hNr60bDf8AwmapoVphKOYdVHMyYgJJShaqKC4tlo2KZUDfDTENMXGYjcaRtDRiXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lEjHDZZC97K3WCYH8fG6Iwu5wzGnnCM7C2bIlMjJ8nA=;
 b=g6z/Oc5J2Sf0yq8pcfiHGjHwiFTYFlhOA8mRfdrpdTtEpvdJnZYQC7qmFbO1VWo2/DLuqt6VWx9fW7PI46Vjy7/tPWarVL72rfM1C7z60oCqkTRemw1PykJSFdY8t0xsi2FjJoszO750GvSkXcDjIAM1GqVIEPZB3t+uT7Oz7yczr17rOP733wxKzqrG6MTXc5NIowmTG97qX76pIPd9KC2xWTf32c7VtY1Xiofaf1PZXOxOsMcyx1UgLsV9DD7T9JOG715ebWqrWEQiozfHIbC+vnrrDOrkOykY1mAIpyLdiA2XRWVcLOecOHllB59+u4gXsTwcJkYGrPFA6Lo6MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lEjHDZZC97K3WCYH8fG6Iwu5wzGnnCM7C2bIlMjJ8nA=;
 b=TMXOe7zsV0yhVdWyV+Po+X+FiFQZx2U4rFZY462vr5TcoDWbY6ZH84BxER8wWgnL0hlMu/vHkSHykAB5uk7qKJ9Q3fGci6loIWjYdrNA4IKEiZa9m13UpgUEkdGENLcD8mnIIylGqhhx0bhItz8WqBECwUWr/pb/DcHTo2bmL9OAWfsFUHz8OAoCKRdtMIR8jbnhAQYBOMwl9H7yR7SSvJic4WtOD7O09/UGspmigBV/NrSehIe5QHw3pgQTZOr7XHXFYX9HOBvopICyH1tPVDEZKXSHDuVcotEGYoP92St/TH7/5aiEUhfvnEmpGiBFLeD6yP20vzK4p6oQeRW+VA==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 DS4PR12MB9684.namprd12.prod.outlook.com (2603:10b6:8:281::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9478.4; Thu, 8 Jan 2026 23:41:20 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 23:41:19 +0000
Message-ID: <106a76cf-c2e6-4371-85e0-b6308255c075@nvidia.com>
Date: Fri, 9 Jan 2026 10:41:11 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/11] mm/migrate_device: Add migrate PFN flag to track
 device private pages
To: Felix Kuehling <felix.kuehling@amd.com>, linux-mm@kvack.org
Cc: balbirs@nvidia.com, matthew.brost@intel.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 david@redhat.com, ziy@nvidia.com, apopple@nvidia.com,
 lorenzo.stoakes@oracle.com, lyude@redhat.com, dakr@kernel.org,
 airlied@gmail.com, simona@ffwll.ch, rcampbell@nvidia.com,
 mpenttil@redhat.com, jgg@nvidia.com, willy@infradead.org,
 linuxppc-dev@lists.ozlabs.org, intel-xe@lists.freedesktop.org, jgg@ziepe.ca
References: <20260107091823.68974-1-jniethe@nvidia.com>
 <20260107091823.68974-5-jniethe@nvidia.com>
 <93449f35-9512-47d2-ad32-0f0efabfb8f5@amd.com>
Content-Language: en-US
From: Jordan Niethe <jniethe@nvidia.com>
In-Reply-To: <93449f35-9512-47d2-ad32-0f0efabfb8f5@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SY4P282CA0001.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:a0::11) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|DS4PR12MB9684:EE_
X-MS-Office365-Filtering-Correlation-Id: 0713fcab-8975-4adb-a7d6-08de4f0f6c7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UjZqSVpzbDNzMGg1SmxjNHk1bFh2WERPUXdqQVZuM1pyVkVBanZIckl4cWNP?=
 =?utf-8?B?U24xV1hOZldzamN1M3FzbElnWXp3K3U3c2hxTFh2eXIyS2VEcnowNEhNQ0lU?=
 =?utf-8?B?Yy9vVXdsMWRabFNWNWV4YzhJcmdkdGhubDV2emNzbzZvaVkyNWZ1RkJFdURy?=
 =?utf-8?B?OTNnb0tMaVArSzRJSXFPVHhaUkRmR3hkL21BY09tSGNBQnBPQTRsZjk4MmpM?=
 =?utf-8?B?RzF1UmNGNTNiTjVRQU5EQmM4TzQ0Z1IrTG9iaWRqN3d2R2wybjM0MkxkY3dP?=
 =?utf-8?B?NzBQT210azB6em9qdDg2R0ZncEpyYTN3Y1JUSkR0cUlubDBjWjI1QzJhejZT?=
 =?utf-8?B?SnE4YytPdTQ4ZmU2dTREWHdCaHJCKy9ZK3pyZXZPUHB6cHJBMU9pLzE0aHFw?=
 =?utf-8?B?U3h0TGNSd3BiLzdaay9kNGJZUEY1NFJmRUg0SlAxaDd4UmJGQVlKT2pVVXZZ?=
 =?utf-8?B?cnp6a0xZRDk4d2tsK0V0S1dXb2JjdWNIOGozT3RhQVFHdDEwd0J6T0JEQUp4?=
 =?utf-8?B?RS80d1R4NkVzTGs5bGw2MDRlNVFULzE3OXVQM3BiZVZZMENibkZpRTlNcVpu?=
 =?utf-8?B?NGxhYzRnc2hTZmNhSkNuTWpvem9JY1BVaFQ5Q3dxK2pNWFFueTBUMjNxUW84?=
 =?utf-8?B?UXlzdnZPYmdDUjdJTTVFYlMva3FSSHphckEzY2g4T1BVMHIyUGJFUFVkNDFP?=
 =?utf-8?B?d29DMi9JbjV5bEFoZHBHejNqeXhlM2pnUXB6dmRmWHFiMzUyU21wK2dJMnNr?=
 =?utf-8?B?cVdJY20xcmdRaTJVcDIwMUtEbHJiWk8yS3RwMXVkREpJRHcxbE4ydnVwdC9h?=
 =?utf-8?B?bjBnSmpKcUJRZWw2SFNvK2NvZFZQcWNqYjJLVi9NY0IveC96dlFEQ3QzUTBX?=
 =?utf-8?B?Q0tHajlmR0hndFEyekNNM005ZWtBZUJzQ2JkL1U0b0RqVTNtMkxudVI1bEkw?=
 =?utf-8?B?QnNZZERncDFrc1JhdEhRZUtoQTdZVWFxamh4bW9aRUc0RjNPNHBpek5DY3Ey?=
 =?utf-8?B?UExYWVJidjFlSTkrdHkvMy9BWk5SVjc2VnI3elE2ZVJiZG12MmcyU1FESkJO?=
 =?utf-8?B?c0Q5ZU80QXhOejRsYkNBbzhPTldMVWdHQUplenZXMC9Cd24zbHRQVkxNR0RE?=
 =?utf-8?B?cG9vMmVUWE9PUEpzQXJnNG8xN0FTbFpxMVEyWkZaN3VHQWJiVU85QlBzS3NK?=
 =?utf-8?B?UHlZMmZGYzhiMkUzc09EblNxMDdibmdFQk9JTU5XU3J3YjA5S2l1UXI1aGR6?=
 =?utf-8?B?V1UwTHgzNG1CaDdFYytnQy9HZVNkZHh6aFZjcU1BVDd4MkNIMXVEaHJjN21p?=
 =?utf-8?B?b1Y2anJMSFBraWxnekx2VklEWmk3SDhmc1Q2WUNMMHFHWUZBRkVHM1RmZ0NJ?=
 =?utf-8?B?U21rcklSVCtmS3RnYzNrOEJlQlBIYWtNYmZMd0VVVmcwQmQ1ZGRqU3hDekRL?=
 =?utf-8?B?YmsyR3BkQlRZNldCVlVMbkgwWGYzT1cyTWIxOEJ3OU9sczJzT2M3WWZrdXhQ?=
 =?utf-8?B?Q2h6SzlRWDQ2a0JhVWFscVUwcDZ0Q0dCUmJFU0x1VUJxKzNRbzBNUUJGSmVF?=
 =?utf-8?B?eElmSjNDeUZ0SlhabjRhYVBsZkxHcDJDSVdxY1BCUmNBL1RiMGJCcnBuRlZu?=
 =?utf-8?B?VEtUVU90WlJsc1phMHRQeU5hZkRWcTVCdWl0L1FXVC9LdkFrS2tUcXljeXNv?=
 =?utf-8?B?cjE1eDA0b0N2MHA3R0NzNFlPek9GUHZOYys1VVVkcGdlTE50R2FmUkFnSm9H?=
 =?utf-8?B?NGFKRElHRFIyY1FkMTkrSFlBU21XakErRjVaWXBoSUo5ZFp6N2huMmFrbldW?=
 =?utf-8?B?WWlUb0xLcDdiNVYxOVRVdzYvZ0Z2RmI5Q2x0Vmtza0tYRUpZTU15UFZjbXdV?=
 =?utf-8?B?NUV3TE9DZE9PR2dFVjVCdFVWalJWaFpmYnMvNmFBTFVJeGx4MHZsR1pwQXZV?=
 =?utf-8?Q?cc2R1EJOk+hzUU/JiE9asSFH1w0e2Wgv?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UTdwZVovOXpJbkp2VU1Od1FNL3dlVndaQ0c2MElxcDhsSnJQSDNZcFdMZ3lD?=
 =?utf-8?B?dU1Lbk5JUFVkdklXbmNGcWZFM21ob0hwMEo5bkZDMk92OGRyaC9OSXI5UnEw?=
 =?utf-8?B?bnRjTU5iM0dMS0EvRVVXYXV1d3JVblhlNHpXeXQ4RmdNVVkvd2xtV0Y3NUpU?=
 =?utf-8?B?MkVrTXdEQWxBVDlPQ01OeHVsSU53ZHJPN29YNE1vSExoOXZuaWtkeG1pVXM3?=
 =?utf-8?B?ZlJTT3JQdFBDRmRBelN3Sk1hV2dOdEVFS0kzMjlubVZoU1dDMm5wejdkNVlk?=
 =?utf-8?B?VC9uRWVRMDdZRVMva042K0V0bXhKcEdLUXVFSDVReC9OY1FRSEpiZ0dCTWpC?=
 =?utf-8?B?RUFBaERWYnZ1Vm9sT3dpVTFxZ09YTU96eVJRK1RDdkdncTEwQ0VkREhRd01y?=
 =?utf-8?B?R3BMQkxQMTEvV3RDcDVHYVkxcUh0OGg3OEVoVWgwcElVR2NGQWFiRDRkRWtF?=
 =?utf-8?B?MVJZbm9tUTVqc3JPTXNGU2V0ZFJINzAwU01ZcUVMdTBVTXZ6aE1pakI5UUd3?=
 =?utf-8?B?VXl2YjhnSFVscER0MUYvSWZjNGtpRVNaWmgvUUhPR1d6ODhLNnVvYnlhSmx1?=
 =?utf-8?B?ME9WSVhkeU93R0ZJNGVIVDNqQWtRSVppQXZDV0VoUUFQVlJRdTZPNkQrOFdJ?=
 =?utf-8?B?UEpTd1VrYmZzQUFYZldJcm10dTA5aFVuSFhaRUN5cWxXMGhpZEVWa2tKd2Mr?=
 =?utf-8?B?YUhxcDZmT3RsdjhLUXh5N2N0cXhMSlpXb01rbFZ4OGpOSTRJRWNwOHdoRkYv?=
 =?utf-8?B?MENGTTNONjNxRU9LUkhXU0NWSjUwVUhRL2M2TnpvTTZydDhyb3hsNFJSemFE?=
 =?utf-8?B?ZG41bUpxbXBYNUw5aGtZdWNsMjJXTEZzQTFnWWlvT0M5a2JGQlBlelNEL05m?=
 =?utf-8?B?T1hZODBsTDBnNFZ1WVBQbGFZN21CalNvQ2ZnN3NyN1pYU1B0YklOdzhFQnl4?=
 =?utf-8?B?TUVrOSs5RDN3RVg0WVhIekI3YXlEdUcvTWdnTysreXEzUnhVekZhODBVelZn?=
 =?utf-8?B?bzFyL1VyWXdkMk1jSGY5ZkgxUEphT3lFVVRpd0syMzBYcDUyTk9lbFVPRDFJ?=
 =?utf-8?B?b2wyQ1dCWk5JM2NrRXlUNWh1QTVLMW9qYTJQL2VEdlVDbjExSDZFbzc2Wkl2?=
 =?utf-8?B?Yk90RWlSZ3pIZGFhYi9Qckh1ZmRzUEhQblFEZkQyeno3YVp6K0ZtMWQxUDNx?=
 =?utf-8?B?eVAvMmFkSko3U2JxQndNVFh3bXN0b2VXcXFqWVlJMnFMREtjZVl2eHNjRjdI?=
 =?utf-8?B?cDZxZDFuU1V6U01JT3NZWnJVTE9PRndGN1RqclBDS2Vhb05wdG8xU2lMUG82?=
 =?utf-8?B?K1V1ODJ0Y3FlMzFtQVM0cUk5dkdua3NMbGh3SkpLMjZOanFGeFZQc0hnM3FY?=
 =?utf-8?B?VU9NWE9xVVNLUUphMDhYRy8vMTB1K1RXZmVnK29TOEFiY0xBQVhRdnJ5ZUhm?=
 =?utf-8?B?LzlsTEsvWm84Uy90N0phTlFxRVdVMWtOU3FGeHAwamYzM0Z4QlJQdU1mZzMy?=
 =?utf-8?B?UTdQMWRUcWNCVlNGTUhWRjNqYnhUMTNicUl3alNlMzNVc091UGdWcU9jc2Y5?=
 =?utf-8?B?RHMrUEdiM0QxcmNXYkVPTk0yQVpmbmxxczhialRPQS9pTEt2ZXhyTVlnQlZB?=
 =?utf-8?B?NEJyMUlVcUxXd2RhTm1qMlR4bmVBWEtEcmJ6Mk96TmZRSHljWTdybDh0TFJD?=
 =?utf-8?B?TUJhRU9IVGZTdlgzS3V4d3R6Z2F3cHNhRkZxMGlEV1l3V3VxMUpieWUwbjEw?=
 =?utf-8?B?SjRzc0o2Y0RTeEJJQ1NvQTNMeERHQkFvdzRvTkwxSXpyd0x4L0FNNHNBVm5Z?=
 =?utf-8?B?KzkrbGZjMkxnS2ZiMngwN29ZZDRzNTQ1RnFYRkc2QmtNaDJkWGtQWkVSNncr?=
 =?utf-8?B?Z016UW1sc25NMlFJU0dPc3dPLzRtOWlMeFRma2pOSWt3TFBLMVJlL1BrQW9J?=
 =?utf-8?B?Q04xanlFQkUzcFJOSkx4QkU1NGxMMlB6cFBlUXJOWjVDTkliVXVBQnJISkxQ?=
 =?utf-8?B?SUsxVk93T2ZkKzNCZFB1S3EvdTVlQXF2MFJnV0hwTlRyRWV6MHdSWUhQdzYr?=
 =?utf-8?B?TDV6eE01ZkFVbHJnUUNydG1CQVQ1cnUyWmRmWUNVNDY0aktZOENWZDVsQUVk?=
 =?utf-8?B?T0hUWUpmclRMMjlJcUIzQWFyejk3NEQyUnhzT2lSYkRIUiszQXFhTExtcFMv?=
 =?utf-8?B?SGNzTTdLVGhUUGxBaWdZS0NFbnE3R3QrUnRRQUJaUjE4VmRyZVVBeW9pSWV3?=
 =?utf-8?B?Z2U1azBqUmhXMkJSWnlDS2RuUm5EdGlVNDlYNUozZkltMERUOURhdjRhYzNp?=
 =?utf-8?B?a1hJWG5QTnAwOU00c2JiVXYvc0VmWUtYR1UzcDAwVjNpOU53RjRzZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0713fcab-8975-4adb-a7d6-08de4f0f6c7b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 23:41:19.9101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xq5Hmar/r9E2Olhu77s+iGKxlw3WUFxkSPeV0vAcLDbAQ45InL7tIbvhRB5p5EvTyFfUR2AVXxnFMebeG48RYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9684
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E585620011
X-Stat-Signature: w6g4nkn9fci74f36gauwsaf4tqy9zaap
X-Rspam-User: 
X-HE-Tag: 1767915683-35802
X-HE-Meta: U2FsdGVkX1/wmysrodUbXkZrnpyAQj+d6CmQT+5cHOjseoRBxRmeo3n6k89ALo5cOxFfR4BXepRobr/Q3+Rgb0+kXSthjxYNs2eeKngS6RlmU0h+57sC1MI+yAoKAip/UHnaIcLQos/SlefJgL1jf0Gh4Y9KoRpnu4pu+B0AUTihGT79DzNWyM1b4T5Qt1hiQglpRKkKGF8vMlV0niiOBz3FAYJGZ0YzcwpWj+q9aLtx7F/nay+YIl2Q0mWd9IUXSdG/4TRwm+nbki5nPfqWqY1E88zQ37eKfD9r5+vT1PhEa8KViDThnDIXsBWMST8QZlcJHOLOjxSnif7XcinL/PdZALzKFcE/OQiBtdT8pDJQagxGHT9A0jh0Ru8LLKpl5x4+5E4JohYF32a4jEMkt1wD2GtQqKyMlf7kP9mrZ7k2mm29SizjRIarXmKAyL/8EfR2GPo0lIhp7N7bAdztplzxJF8F19Y40mx7eNRzLB7l+Re0OV1HpalnLWI36gkGDlrAXpkc5lNIM+3lcW8dTc6EGaCaQoiQhFbCKptidX9gtHilU5qNWPVuzjlPzhoh5hslRTmatR2CXbHgsmNnry+QaHOR3oaulw1qZAffW5unZh7lp8rZ6ajuXKYwfRrhcDTYTCcEcZBnNlMiA4b+41HYyINKwo2617dfZByddYir+RV+R7CLxdcuhtQ9xuJMocp4YClpECSS8oz0jnFPl+BEyvx/o76gjwG800ebHomfNNt9H2qVDvFt9v1cSntCTVQHJLNgPjcN1GWwwd9vuHILRfGZyCM1z2uWtXV5RjkUFqrHjBkBPu57l6BN/U/jPkQxmpUkXlVZK6goirfOJD9S0sYinxo920MnisgDKNe6l1FLouSFVN7My+lCkGGFxZN464SEYfTGAiFkeglUfnlnRkcjFA6Cho8JApdd8mqRzfSrpA9yIB0YQJDj4wPjbdDQUPX0m7SGusz/eMi
 Grcln7eS
 q2aMGipUVqAvV2VderSWazb4ztMMe7vLQex/hHxCr5ZCeteV/TuFAPOgFr5IpVPviOtBZ/GgV24ov47nY67jlTbS4DA+qDyUxkCExN8MCzMJG5SumBjb5kLp/5hIklqqEgtTko/VIqW2W6d78KQERqWmZsMZKvcYT5hn2BcH6WOvvnVEi6BZhvYe4j3yQqOJR+xypBkrQAwDgOuDFcZlax4qA+rVa/ZPWkaK0pH1d9dmerfFPSNlKa5mIwj+OkyOeXZUNS3AEFN83ViqkHGFCLJDGTOoUDo3sxRFkYLfdfapprAGwBsIiPQ9Og9LuP+/KTrGBH/W73QyrJj0SVtgVXlzHAwtmWE+6KOOnY2bjyyCajDq0ydtoEPrNhlgP4KxCDTL67MB4WEMCzbOkv42xJTh/IbzENaz3Lz+y/6Mc514Kl0wgP/sfChAX7C875R2PpNZtl2qLlkGGwHe97T9bbfnACrRHbp89c5hmXApxFs10Hew=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 9/1/26 07:01, Felix Kuehling wrote:
> 
>> diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/ 
>> drm/amd/amdkfd/kfd_migrate.c
>> index c493b19268cc..1a07a8b92e8f 100644
>> --- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
>> +++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
>> @@ -206,7 +206,12 @@ svm_migrate_copy_done(struct amdgpu_device *adev, 
>> struct dma_fence *mfence)
>>   unsigned long
>>   svm_migrate_addr_to_mpfn(struct amdgpu_device *adev, unsigned long 
>> addr)
>>   {
>> -    return migrate_pfn((addr + adev->kfd.pgmap.range.start) >> 
>> PAGE_SHIFT);
>> +    unsigned long flags = 0;
>> +
>> +    if (!adev->gmc.xgmi.connected_to_cpu)
> 
> We could probably use adev->kfd.pgmap.type == MEMORY_DEVICE_PRIVATE 
> here. This avoids making any assumptions about how KFD decides device 
> page type it wants to use, which may change on future HW generations.
> 
> Other than that, this looks good to me.

That's a good point - I'll update.

Thanks for review,
Jordan.

> 
> Thanks,
>    Felix
> 
> 



