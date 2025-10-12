Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A351CCCD184
	for <linux-mm@archiver.kernel.org>; Sun, 12 Oct 2025 22:54:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A8AD8E0003; Sun, 12 Oct 2025 18:54:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9808F8E0002; Sun, 12 Oct 2025 18:54:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8212C8E0003; Sun, 12 Oct 2025 18:54:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 676378E0002
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 18:54:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D5B91573C3
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 22:54:33 +0000 (UTC)
X-FDA: 83990968026.24.1BB3E32
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012019.outbound.protection.outlook.com [52.101.48.19])
	by imf15.hostedemail.com (Postfix) with ESMTP id D0872A0002
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 22:54:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VZI3D4rz;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf15.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.48.19 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760309671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qAo/ItiXOywBVnsCYAFqoGFRVPBhMtmPDp+QnCb44Vg=;
	b=ENZf+kQqZzrJnsxKdBDQbclNIQv5EQmkksf80q9EGKyVKqG34O/Y+It1q71jSHb1z/4xwo
	E6Q5gNxfUihFbIK2veg90XFrMxP7DdFKAgWh8hHCHQ/BzbtQvn0zUTjSO/8g/LOgPy4Jrd
	n1F9NvdCm/uD/OvY7bJqRLTI6JGu1ZQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760309671; a=rsa-sha256;
	cv=pass;
	b=t41SEaCOkow+2RxNmJyFwmM5HvmzMLsK2hs5DfvnTVfEbOW/CtBZ1ugDpy/HBnC5IwSKuo
	LgVDNU7Ip4RHE0Fu2Ix/LrcCe/GLkg+GIuJHWaIycfZKzpYjGCbz5N1leMAJbtAlx+9wJi
	sOiGhyCAdwsRssNJX4anOvTw7bLIqZk=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VZI3D4rz;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf15.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.48.19 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MabYaRZYj9RTgigjuy29Dx7JD2wO9UwMt3RAk2XmCEx5tFfq8qK0q7UMn0rfKWfS4EvFOF3zr8zWffgtZr7yao63V8QtOqL1EvJgbUJpqJKrp6eHWEq2KUqM2t4xO8VGRJ3tK9FlT5Ui+K4d7hjOzdQV2mGAiBOdMovAqeKH5UzFAzykgZE0pb6/fA6hC5+w/yFeWlsMhLuoVVPUw6BQt7hIS/OB/XLRnQb/6WjOjvaG9GpCsL4y6JF0NloE389X46jvNmMwV1T+zvIezOwaBvw/WTtWqqd4sl2plrVOtfZ3H1qUJF/DKxUnFF7pO2cKMNlY+ctZvP339fwRkfI5fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qAo/ItiXOywBVnsCYAFqoGFRVPBhMtmPDp+QnCb44Vg=;
 b=SCLFr7Vc9TU4b7e7SoXg/vYAWH7id+g4N0RS3/oXNDOyufpcTAyddTF+qa+UouNBRQvP8n05vJD88EnxFt1FLCW4I+nQDFJ0IU382b6JsK0/wwyeplf1FAsFqahCCx0l/mGx/XhsW4r7eAFyW5Ef1VIONxvqW9Anc8JZrFggLONNJCjQ4fJZ4+b1k+42+noYYr7dahIo08UsnxeFd4jZ71IJsadZK70WgaOSDChel6u4fEahPsdIuubKISVounlG7oyExoXKkYYe4CJ+n/jb5mR2xh7m05LrupeLWD9vbAs1h0G0A2Eg7ETRkGnrDtMLnmLKRQcvvxYLZHrDUdHVog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qAo/ItiXOywBVnsCYAFqoGFRVPBhMtmPDp+QnCb44Vg=;
 b=VZI3D4rzDk3hmYB6FZpTONCc8FydviLgZMI4buA7vZonvnOiq2/1fYLjrFOV6QieYKBoDJrt2xzeSnM96fnBB0Tun4DytV4/o+VFbjNJIiJEVyvX5ZmD2Bh4PtJJ8IQbxQVju/nJGGiU69FU/wc+xU+hPC7geyU1JJAB0v06WwL/QhHIsY4fjjFUl5xE0C6qUX4o4DADiX5PTO+3CAj7XGQ43CK46VE/OfTtrEcERInJLR2X3eAQtJlVVAWqZnomGDowKzu15AzfNOx4XLHNO6QHl+YFIlWBWLI4fBFaKVfKUT7ercE9KwYBivLD804BCshCQl0D9kZtOT9LpyipUw==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by SN7PR12MB7177.namprd12.prod.outlook.com (2603:10b6:806:2a5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.11; Sun, 12 Oct
 2025 22:54:26 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9203.009; Sun, 12 Oct 2025
 22:54:26 +0000
Message-ID: <7f451c61-f45f-442f-b6fe-fac9ba0ea6d1@nvidia.com>
Date: Mon, 13 Oct 2025 09:54:09 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [v7 01/16] mm/zone_device: support large zone device private
 folios
To: Lance Yang <lance.yang@linux.dev>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-mm@kvack.org, akpm@linux-foundation.org,
 David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Felix Kuehling <Felix.Kuehling@amd.com>,
 Alex Deucher <alexander.deucher@amd.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
References: <20251001065707.920170-1-balbirs@nvidia.com>
 <20251001065707.920170-2-balbirs@nvidia.com>
 <CABzRoyYJXVdgTdoz9uYxeYHeejU1bbe6_rQnvbKns7fjvz_kqQ@mail.gmail.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <CABzRoyYJXVdgTdoz9uYxeYHeejU1bbe6_rQnvbKns7fjvz_kqQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR07CA0079.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::20) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|SN7PR12MB7177:EE_
X-MS-Office365-Filtering-Correlation-Id: 12b60e59-97d8-4b53-19a9-08de09e24b5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|10070799003|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dGdOQzYrQmFBS3g4TlM0U2R0QUgwQlFza2pqYi9MVmkxOTE5bGhReGdUUGo5?=
 =?utf-8?B?VWVIWUtneXVyL2RIWk0zbnFYUkdndUg2cWNCTlh1ZmF4Q1NwRFoyRU53Ymty?=
 =?utf-8?B?TzhwWkRyR1pESVNycWJpUmRzU3J6N1FXN01oaWw2dXVYdWtMK2kycytNdWN0?=
 =?utf-8?B?cDFzOGFYQk9NYlBaTGtQZVEwVkM0cXJkSFBkVkpVYVBFQm80QkdIcEhjSWdX?=
 =?utf-8?B?RjlNeGRzMjlhODBFTncwR0tYSHp5MWs0Y2hPYzlCeVdzT0ptSGwydnFZWUo2?=
 =?utf-8?B?dmpVY3RBSjY3VGN5M2NTd0pXNTNsS210T01OUGhIWWhseTJVamZwVTR6bEpp?=
 =?utf-8?B?SDdreERNNFF3allnU2tZeC9Db0E1aTdPTThvRVpSMzJGaFJweEk2MmpSRlhm?=
 =?utf-8?B?SXlyQ3RNd2M1RXVUK2U3NkhGUURoSjVjUjUyRGpzWmlsWTd0eGRndDRhNkk1?=
 =?utf-8?B?UHN2aCswVXBxQkJzR0FBNGk3ak5xMW9Oc2VaeHo5SkZUd2JCL01USDF2ekEy?=
 =?utf-8?B?V2x0L1UzcDAyZ3EzV1RzWE9xUnBIdk9oMjJNVzQ4aUYwVUo1aDZmY09wWk41?=
 =?utf-8?B?KzNBdy9wWnhJckFCLzJKakZ2YXdqdVJGMUwzazVMaHJUbDBmaU5JeUFuWjc2?=
 =?utf-8?B?eVVjWWJBZXpOMStHUmJSa2V4WlVBM0tnUkIrL3ptSUdpNSswT1hxN1lWR29a?=
 =?utf-8?B?dDJRSXdMU3hUYWdYTTIyMGFqeURpajJreVVMYytXNlZzUDM1ZzFra3ZKSWxn?=
 =?utf-8?B?SjZxOEUwRVlrYTIxa3ZNeXErWlZheHlHdEVZVk13ZVJkVzVtRW9PbloreDgr?=
 =?utf-8?B?NkhPZ3ZFTkg3dTZad1VVMzZ2NVA2RVFxUmFMVnJxM0JWbHFxTlc1RFdEYmxW?=
 =?utf-8?B?QmkvNGNYSzd6VExHOVRqNGd3MlBJTW1QYmQrNVJpUU9TTW9sdTM5QjNGNXhZ?=
 =?utf-8?B?cFdXL2xzUkNDR2RoU2dEdG9hV3lyeGJST3ExRlJ1THNmN0VyTkVEVDV2cDk2?=
 =?utf-8?B?SWxxYmFkVUxPN0VnY1ZUTUdISWxFaXZvRzZpZ0pVV3lvd1hMSEVDWld2TWlh?=
 =?utf-8?B?WXBFaFZxZTY3Qzh1Q0ZBZkt3bkxZRlVjQTlPaFhyUksydjloZld5eUwzenY3?=
 =?utf-8?B?enZDZDZnWXRFWG5UbUVzZVhFOFhQRzFaVnprL05NOTRBSUFKbU53Qk5oN1FO?=
 =?utf-8?B?ZWxpazBYbkRGWEYrcS8wTDBYRlQyWTNmMG1qYkJFK3FoUVNLWHJidmhVQzdQ?=
 =?utf-8?B?Wm9SVzA4bkdOeUdzTHJWTDJqUWpBS2FGSXBzR2E3UlNTb0Z3ajk5eUc4T1ky?=
 =?utf-8?B?ejRJMFcxOWErNnVoNm9aRm5iRjdtc3MyOTVPVitnWEs4Y3o2SlJ3Z3FKYTVp?=
 =?utf-8?B?dVBXVzUwSllZOGZlZmRJSUlueWNLcUdBcUdZMHZzaDh2TVpjVDArL1dXOC9a?=
 =?utf-8?B?SGxVVitNRW5DWUxYcitJdXd6a0ZFaGxLWXIwRHlRN1lnQmUzekgxam82dVNs?=
 =?utf-8?B?b0ZqaFNJLzVuTTN0UmtFRG54NmhwT2pHK05rQ1B4V1FXcXNyZ3VYbGsva0x3?=
 =?utf-8?B?K0Qxb0NzZFJ0dndxeUtWSG1RbWY2UFRVci92QzFVYUtEMTAzQlZTYVcvMllx?=
 =?utf-8?B?ZFR0UStPYmdhSnBxL2dWakFTRUNNM0svQWpCbnZvNDJHL1M1L1oxTlhBa1No?=
 =?utf-8?B?UmZNQjFDSi9XWnNyVHJ3OTB2aWRWK01jUWplMjdlNDlBRHRVbDFjTzNVN2Vl?=
 =?utf-8?B?eDRaUlAzY3JpbHRIVGtJRmlkbk5BcWhSOXllay9lY1djdWhSeFR3eXhadTBW?=
 =?utf-8?B?Y2llSjhlckc2T2JaemhyYkx1TzdJKytrQ3puOW5CeFlXS3lxUXFNZzlCckRm?=
 =?utf-8?B?cUxlOUpxc0p2YnVSaEtKeEdvZEFwNlpDc052aGhrR0pmaG15VlFtTGQ4dktH?=
 =?utf-8?Q?frcM6tugE3gzUZ1gB+NUifK1Fbb70Le9?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(10070799003)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RHpMaUtHQ2NRTGJoSytFSnlwVVg0bFpoTUVMRjk4NFQ4eExrMHN2NGp6VHA5?=
 =?utf-8?B?bzdoUDY4ZENUNmhwc1MyUStBdzhsYWNYM0pyZUhlZVVLM3pMSVJwSnpWWGdi?=
 =?utf-8?B?TTRFSDg5dVlwQVVIRnl3K3dZeENaaVp1R2lJcUIrYVpCTkRDT2FTQUFPZ0VC?=
 =?utf-8?B?L3F5ekowWkNscTZUTTdjVGRzSGlVenhpTERnbGFkbzBmUFJsOHlYNEV5Z2ND?=
 =?utf-8?B?MHNLVFRzMmFGb1dzMlNqU0ZWaitsNXRZMlNQN2ZzT3Q5aGJFN3M1Z280dHFX?=
 =?utf-8?B?UlRzYXFPUEdmbWpsNmQ2ZHRKTVVDU0U5K3UwN1Q0UUx0aXFyN0h4ZFRvb3Rr?=
 =?utf-8?B?VkVPcWxzNEhCd3pVMGp5Sy9IeTF4WHl0TnBuVmxBWHhlRlk5aGdWNldkV3pD?=
 =?utf-8?B?eE94Y2o3eng5Uy9qZjN6VWFTUFA1cFBnTEczZDdzWjdORGlVeWtxZlFCeXJH?=
 =?utf-8?B?emRHbkMrdVArbUl0Um9PVVpyU0szT3Y5YjVlZEhXSFgwb2VGZU9Vc0FlVEtO?=
 =?utf-8?B?VHBZYXZvMUhCdTlzaFRXaGlsS0NmRlNTTGRjeTNDZEFJd2U1U0tQc25BeXhT?=
 =?utf-8?B?RXNFRjhnd2hEMkpab0RXSXBscDdNQkdOV1JxMmQyd0NkRU95Y1lpeGxNUVVJ?=
 =?utf-8?B?WHRLdkJzNjh2SVBxYTlFQ21sSkFKUCtwZnhETlZXU1VtSjJNU1FDN3BIQ1FX?=
 =?utf-8?B?UjZySmVvU2R4Si9LelJiOUZjUlBmR3hYeldiVFRRVjRhUkNMSmVJc0V4d1pp?=
 =?utf-8?B?dEpoUGlYQzk4cGNjSzBlU0dFczJBSk1sb1NFWllJS1FQSWxlTGMxM0JSWlZh?=
 =?utf-8?B?SmRrdjNJVGlKMEw3WkJBZ3RjMzVMSHZFaFVsQ2FzMlk5MmFaMC84dy8wblEx?=
 =?utf-8?B?OTErS1pQdi9CRWVyWitDeVF5QmhFRk9wOFFWRXNYV29hbGFXVWdpWUUxU3Ev?=
 =?utf-8?B?dFd1MU4yMVB3bHNqN0xmcS9ZUXNQYVB2cUtKb01nT08rOFVZcWdkelprdkJR?=
 =?utf-8?B?YkZHR2FGdFF3VHNWekI2cU5IM3IxY1prbGNDcFg1aVhRNHlFZmdjTnQxVk16?=
 =?utf-8?B?bDJ1UnpBMFlhK210Z0FkdDN2YjlBY2w1QlJ1c0ozOWdYNzBjWTZ2V3RiZ0ZB?=
 =?utf-8?B?QWhrd1FXQnMxaWMwYndMWkpIazcxWjFubzZFa1E5Z2dtaG9EbFB6dFJ1K08x?=
 =?utf-8?B?c3hwS0l4WCtTYXB3TVJRaHdXZ0pHWXhBOVNMandxLytOTFZZdWdPdWJMMEM3?=
 =?utf-8?B?NG1uallhem8rM2c3cmlYR2ZSNzRTVWFmbEEyaGZWTGNLRTJsK2QyZ2VBdXYz?=
 =?utf-8?B?Z3FJRWlOMmc4ZEpCUFIySDJOL0ZMVlcwUmtuL3hDVnZDUm5LeEtxSEQ2R3FH?=
 =?utf-8?B?VHVrdCtYNUFPczVndUVHb2FJMXVXTXUrUnJkWG5sTlZ2MlVhWE1GQnZzbENW?=
 =?utf-8?B?bDVBMlFEakdyTzBtSURpRUEwOUQ5QXNmRXM1MlQvQ00zb0NhQktpM29nWmdO?=
 =?utf-8?B?NWovWU5LUTNWQWZ5Q3VTaUdJT014c1N3R2RkdTljTGprRWtjU2ZYKzBqUFhL?=
 =?utf-8?B?UVFZTU91U0ZQejA1eFdYZ2l3K1lLdmhCUXlmdDJ5QkwwRkVldkh1YTMrQ3ZY?=
 =?utf-8?B?QlNBWWx2dHZDMGZvSkYyNzI5dUozZlV4MEtQbUpWc0xldTJtOG5Jd2doVzVt?=
 =?utf-8?B?dVVDRDB6OG1ieDJIbWU1SnMwaFBmMWFIWXJHOUdjN1JJSno5T3p5a25ldk1a?=
 =?utf-8?B?SU5oN3hLeFhJMEdPeEFoRHNldjFZaFV3VENhdjMreHB4Zlh5VlJSODNlcTli?=
 =?utf-8?B?bTg2ZTdKbFhsL2NZcW5qeHNFbllsQTYwcFl5UCs2OFRnR1p5VUxFVGZCUGxT?=
 =?utf-8?B?R2lPNStJeEFlL3hSMmJ6dVNWU0U4VjNPZkFSU3VOWldQK0pNZFEzL3crNzhQ?=
 =?utf-8?B?YmFPOXltWEU1OWxObitWNDZXSHBCMk5sajlUcmp6c1FSeHNDSVd1UmFpTHdm?=
 =?utf-8?B?MlBNQ0EybFo1ZjZYaGwrUm9GYmxNVUx4ZXdsZUlGWnIzM0pwRmdvWGxIRlB4?=
 =?utf-8?B?NllPRWdsOHJkRXBFRWg0a0REa1BWV21TSTJtOHQvME03ZTRXL2IrUGxZdWxV?=
 =?utf-8?B?OFBZbXBZM01qN0J6bUlFWlNuYVpPTS94YmxMK1cwR2o3MC84Z3RlbURLSUhE?=
 =?utf-8?Q?GNDDzIrQf2mfYN8c7pBTPNZ7zoegl+3/yTsbJStAI3PM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12b60e59-97d8-4b53-19a9-08de09e24b5e
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2025 22:54:26.6577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7HgNGqGQZT322qdgYUQrMa+iiQ3faOjxaEbo1q4B4/WF9CyfXpWtFE1WeAp+hF3HeEBdC8DMuA+qIozf0d+x+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7177
X-Rspamd-Server: rspam01
X-Stat-Signature: mbwahji8tj1nouycebgfmf6jo391to15
X-Rspam-User: 
X-Rspamd-Queue-Id: D0872A0002
X-HE-Tag: 1760309670-302233
X-HE-Meta: U2FsdGVkX1+8IJmcVQNBSYspp2lCRxJkB7RlC2ub/o6AdxMlxo1lfJb+qZHmbonlKs8ncZcbOC/yP24pDPvpiq4IICuk4qxr6NsZwrAEGG7RsT2sVZ0a62L9vJiVyKm/WFpj545es6ZVJkc4VAgt58jSgFWdF+Xy1O7+yW7/GjslgO/QbVkTMDij+DOau70y/xW9qVmOhvvRFaTo9xmXFXw3+NFIg3fC5enCpQnOenTCZfKy8TVV0ma/w+OtLjhfXmAQ/bqekwODldmJ9cGeNMMZ2tO6rPa6ccIh247nAerHthWFEc09Np4SeYlcO7+0s9yaikzeHB+Q/EqUCs91veuE+c8pbs6L0Tkvus9ISd+SeRqx/j8/X8Q+flg67GEybsdKUBFiKq7MOUbSXGO0XNGfO6fIxeh01XW/JGy6UlmUkblv0V5zdRq2tio6CulcvvQgeA7Xqeygdl85CPrO0mpWO4pm2bqDAZHUENHGfHiOza8VAITKPkpj6YoGLHinKSn8bIsi+7FwuY64h1iy98+wPtRMnZw32yAO9EycpY1ihREOoxC9qNbBG//TwwZDIgbNrGb5eaSGrrbexUdTbjeKSQVnUvYvUutoXpmv/l89o/m+/xY4E0DJgFy04RiZZuYOlCsCeOWmKflbMmkiOPzkbE+S/dy9SwS6umdBeeOvx0h6dy6Sf55WJymBieAWH7SFr/2VmA/YfbN2/Teq4Lg0mZ6gleoWDi7cMuCnV5D4H+QNNAPOZCZWocGqf5nUHTh/JEc+bJXMHnNOJaTjYSK4rcBd5FY6RulT8EQhflyyB3ciYWFLPSYsMDxZM0vZFmPdJ9WQQ3w9mjBSQara+ClLjJLrT1lymTNWse/hgkMj420II48kxLJI4kRCc2P/0qabxMMDk/vF67nnfb3WbXwy754pOSQXKi/tPHWM2WYEwv+mGd15Qugd2iSp/3muXWKGSsFWafGeZYQ0OSd
 8+3fDLT+
 PyxKDQJ3rctZ3UZWb94CZXPxvCOXq02x+2IwrZXFXdSA+/FnHBpgHsOD5VuH4eo0wJ+ytE6qRs+j7PR/6iPbZwbrDHdaaN0Sr8Tjjbp7jdns1MMjtcc08C+/YO37bTcFDe9LhCLNTomFCfq//B5dogbOUDhYzRu+kxIe1Cno8t89yrqZ3bGyj+Fw7Rw22VAuOJs4hVckeR0eFUL8AQE/pvsE4Wq0KtBmcy4X/hi/VjNvdT5pJt5ynotLQl2sOJYBX7IqfQnSGprORR2cbIFmSV5NfQ4FWlNo41/a9ocuH/RNh158f11P6p2J3j3cy67kbRVwGrUbYfZheTTxmdQ8UoSRlbZ79CNKLk3VjOhXAIYWFl0vc7dpO/1vp3opSEigCw1an3sKXwOpvF9O8SMcUhXrqRn1EFB6E1gq+GVOizEvgC1oPQ1GbUC4yzJFSoMwJBlslIbvNqMPdeekGJIA/f3wOSPznIiCmDMrq/8uSIhbCCHFVn+hT0jspDNO72D8t3dW1fa6EMG4SENh/yyUeNY4rnRbmN2bUUETzu0t5LLbX8adbdehlCL5b0oV1CLJ4x4qUMRhL6Er44RMGoK9K+w5lhFvY2Lz1SYQ6uiIKyqR4Ev1iCVGYtnpwpFfVI5s5EbN76h1lhXjir5SgoCRDBTBb5OUaVWVxMNtQdUotlnNI++Tsc2MfRfMeQiPUdakAnrDnRmXVzBv/FOaX25r53bLeQMt3LKfxczqFOechdjdCyRyvBllv2OY7T4kmmDBHVywGOrCYk97FR19D2ufqRih0E8c0XPvKQBT3tOlSzcnst1jPJF6nA1R79V9140QfSzL4mpQStvHgja3RCEN71qW5rDvdxpnMyZjuAgabavutvqjVxqGXAyzRBiPgl28YmwYjBVHnakhHb81Zv4BcvGwv8CjsRi9aouXGGzGUAiuqon5o3RuoafaJGJSA90+rIUrOeQuQ1DljVSGg8q5I4d6V29le
 Kk4H5sEC
 9k/kkCFne8IsPF8WwvGHTFa5JpgLHOIprxn7/lv1/CsnNAwpQetpLxjOrnNjpeaX6V9o/3wNy+YYm1hqXdaHOQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/12/25 17:10, Lance Yang wrote:
> Hi Balbir,
> 
> Just one nit below :)
> 
> On Wed, Oct 1, 2025 at 3:43 PM Balbir Singh <balbirs@nvidia.com> wrote:
>>
>> Add routines to support allocation of large order zone device folios
>> and helper functions for zone device folios, to check if a folio is
>> device private and helpers for setting zone device data.
>>
>> When large folios are used, the existing page_free() callback in
>> pgmap is called when the folio is freed, this is true for both
>> PAGE_SIZE and higher order pages.
>>
>> Zone device private large folios do not support deferred split and
>> scan like normal THP folios.
>>
>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
>> Cc: Rakie Kim <rakie.kim@sk.com>
>> Cc: Byungchul Park <byungchul@sk.com>
>> Cc: Gregory Price <gourry@gourry.net>
>> Cc: Ying Huang <ying.huang@linux.alibaba.com>
>> Cc: Alistair Popple <apopple@nvidia.com>
>> Cc: Oscar Salvador <osalvador@suse.de>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>> Cc: Nico Pache <npache@redhat.com>
>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>> Cc: Dev Jain <dev.jain@arm.com>
>> Cc: Barry Song <baohua@kernel.org>
>> Cc: Lyude Paul <lyude@redhat.com>
>> Cc: Danilo Krummrich <dakr@kernel.org>
>> Cc: David Airlie <airlied@gmail.com>
>> Cc: Simona Vetter <simona@ffwll.ch>
>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>> Cc: Mika Penttilä <mpenttil@redhat.com>
>> Cc: Matthew Brost <matthew.brost@intel.com>
>> Cc: Francois Dugast <francois.dugast@intel.com>
>> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
>> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
>> Cc: Felix Kuehling <Felix.Kuehling@amd.com>
>> Cc: Alex Deucher <alexander.deucher@amd.com>
>> Cc: "Christian König" <christian.koenig@amd.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> ---
>>  arch/powerpc/kvm/book3s_hv_uvmem.c       |  2 +-
>>  drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |  2 +-
>>  drivers/gpu/drm/drm_pagemap.c            |  2 +-
>>  drivers/gpu/drm/nouveau/nouveau_dmem.c   |  2 +-
>>  include/linux/memremap.h                 | 10 ++++++++-
>>  lib/test_hmm.c                           |  2 +-
>>  mm/memremap.c                            | 26 ++++++++++++++----------
>>  mm/rmap.c                                |  6 +++++-
>>  8 files changed, 34 insertions(+), 18 deletions(-)
>>
>> diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
>> index 03f8c34fa0a2..91f763410673 100644
>> --- a/arch/powerpc/kvm/book3s_hv_uvmem.c
>> +++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
>> @@ -723,7 +723,7 @@ static struct page *kvmppc_uvmem_get_page(unsigned long gpa, struct kvm *kvm)
>>
>>         dpage = pfn_to_page(uvmem_pfn);
>>         dpage->zone_device_data = pvt;
>> -       zone_device_page_init(dpage);
>> +       zone_device_page_init(dpage, 0);
>>         return dpage;
>>  out_clear:
>>         spin_lock(&kvmppc_uvmem_bitmap_lock);
>> diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
>> index 79251f22b702..d0e2cae33035 100644
>> --- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
>> +++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
>> @@ -217,7 +217,7 @@ svm_migrate_get_vram_page(struct svm_range *prange, unsigned long pfn)
>>         page = pfn_to_page(pfn);
>>         svm_range_bo_ref(prange->svm_bo);
>>         page->zone_device_data = prange->svm_bo;
>> -       zone_device_page_init(page);
>> +       zone_device_page_init(page, 0);
>>  }
>>
>>  static void
>> diff --git a/drivers/gpu/drm/drm_pagemap.c b/drivers/gpu/drm/drm_pagemap.c
>> index 1da55322af12..31c53f724e25 100644
>> --- a/drivers/gpu/drm/drm_pagemap.c
>> +++ b/drivers/gpu/drm/drm_pagemap.c
>> @@ -196,7 +196,7 @@ static void drm_pagemap_get_devmem_page(struct page *page,
>>                                         struct drm_pagemap_zdd *zdd)
>>  {
>>         page->zone_device_data = drm_pagemap_zdd_get(zdd);
>> -       zone_device_page_init(page);
>> +       zone_device_page_init(page, 0);
>>  }
>>
>>  /**
>> diff --git a/drivers/gpu/drm/nouveau/nouveau_dmem.c b/drivers/gpu/drm/nouveau/nouveau_dmem.c
>> index ca4932a150e3..53cc1926b9da 100644
>> --- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
>> +++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
>> @@ -318,7 +318,7 @@ nouveau_dmem_page_alloc_locked(struct nouveau_drm *drm)
>>                         return NULL;
>>         }
>>
>> -       zone_device_page_init(page);
>> +       zone_device_page_init(page, 0);
>>         return page;
>>  }
>>
>> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
>> index e5951ba12a28..d2487a19cba2 100644
>> --- a/include/linux/memremap.h
>> +++ b/include/linux/memremap.h
>> @@ -206,7 +206,7 @@ static inline bool is_fsdax_page(const struct page *page)
>>  }
>>
>>  #ifdef CONFIG_ZONE_DEVICE
>> -void zone_device_page_init(struct page *page);
>> +void zone_device_page_init(struct page *page, unsigned int order);
>>  void *memremap_pages(struct dev_pagemap *pgmap, int nid);
>>  void memunmap_pages(struct dev_pagemap *pgmap);
>>  void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
>> @@ -215,6 +215,14 @@ struct dev_pagemap *get_dev_pagemap(unsigned long pfn);
>>  bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn);
>>
>>  unsigned long memremap_compat_align(void);
>> +
>> +static inline void zone_device_folio_init(struct folio *folio, unsigned int order)
>> +{
>> +       zone_device_page_init(&folio->page, order);
>> +       if (order)
>> +               folio_set_large_rmappable(folio);
>> +}
>> +
>>  #else
>>  static inline void *devm_memremap_pages(struct device *dev,
>>                 struct dev_pagemap *pgmap)
>> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
>> index 83e3d8208a54..24d82121cde8 100644
>> --- a/lib/test_hmm.c
>> +++ b/lib/test_hmm.c
>> @@ -627,7 +627,7 @@ static struct page *dmirror_devmem_alloc_page(struct dmirror_device *mdevice)
>>                         goto error;
>>         }
>>
>> -       zone_device_page_init(dpage);
>> +       zone_device_page_init(dpage, 0);
>>         dpage->zone_device_data = rpage;
>>         return dpage;
>>
>> diff --git a/mm/memremap.c b/mm/memremap.c
>> index 46cb1b0b6f72..e45dfb568710 100644
>> --- a/mm/memremap.c
>> +++ b/mm/memremap.c
>> @@ -416,20 +416,19 @@ EXPORT_SYMBOL_GPL(get_dev_pagemap);
>>  void free_zone_device_folio(struct folio *folio)
>>  {
>>         struct dev_pagemap *pgmap = folio->pgmap;
>> +       unsigned long nr = folio_nr_pages(folio);
>> +       int i;
>>
>>         if (WARN_ON_ONCE(!pgmap))
>>                 return;
>>
>>         mem_cgroup_uncharge(folio);
>>
>> -       /*
>> -        * Note: we don't expect anonymous compound pages yet. Once supported
>> -        * and we could PTE-map them similar to THP, we'd have to clear
>> -        * PG_anon_exclusive on all tail pages.
>> -        */
>>         if (folio_test_anon(folio)) {
>> -               VM_BUG_ON_FOLIO(folio_test_large(folio), folio);
>> -               __ClearPageAnonExclusive(folio_page(folio, 0));
>> +               for (i = 0; i < nr; i++)
>> +                       __ClearPageAnonExclusive(folio_page(folio, i));
>> +       } else {
>> +               VM_WARN_ON_ONCE(folio_test_large(folio));
>>         }
>>
>>         /*
>> @@ -456,8 +455,8 @@ void free_zone_device_folio(struct folio *folio)
>>         case MEMORY_DEVICE_COHERENT:
>>                 if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->page_free))
>>                         break;
>> -               pgmap->ops->page_free(folio_page(folio, 0));
>> -               put_dev_pagemap(pgmap);
>> +               pgmap->ops->page_free(&folio->page);
>> +               percpu_ref_put_many(&folio->pgmap->ref, nr);
> 
> Nit: &pgmap->ref here for consistency?

Can be done, thanks!

Balbir

