Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B82ECA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 20:12:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10B778E0026; Tue, 19 Aug 2025 16:12:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E3A88E000A; Tue, 19 Aug 2025 16:12:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F14358E0026; Tue, 19 Aug 2025 16:12:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF0FA8E000A
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 16:12:29 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6A7401401FC
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 20:12:29 +0000 (UTC)
X-FDA: 83794604418.28.1DBB0A8
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11021097.outbound.protection.outlook.com [52.101.62.97])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7741120008
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 20:12:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=BkhF0sjs;
	spf=pass (imf13.hostedemail.com: domain of danielf@os.amperecomputing.com designates 52.101.62.97 as permitted sender) smtp.mailfrom=danielf@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755634346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dMy9q8E0IfDEhqqoMEFRpjweTfHECoXnBUjxN2QYpN4=;
	b=flJJqHoyVVV5deswtOHHJCrs8C8ZYiT7BKQoz1E1NMxx8VXpZhI75gRCkzfanKcfxs6qjO
	wyeOZYxPsNAYWpze/2icY+7W94qpwzq5nhXYYK5rCHjwBZ5Nzba11TJlKK9JuPSpQdTRRS
	/SGN29ijlftb5Us7dKDoQZWJi253POk=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=BkhF0sjs;
	spf=pass (imf13.hostedemail.com: domain of danielf@os.amperecomputing.com designates 52.101.62.97 as permitted sender) smtp.mailfrom=danielf@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755634346; a=rsa-sha256;
	cv=pass;
	b=AB44yqw2tAzjNqgIQ0fRxKUdzORTqAdrUdpJQTWdJV8/Ds4TBN8YDF++qShOANG6eUW1Tn
	guDBeoNlLTGSPd/8WuMKTJoU2T/BdPJb/9s9tFdPPEtc5Yd+f2f2XJSz8jPYWNJwZqMDOE
	pKlASNXhMFIWDwcoyoSkJHd8+ToQAzM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cQ2GA1yoSAffzZLnMV+IfYJd7mvmDmKa1ptZR5AzdDbAcQu53iQ/IenBADLEVtHH4fdEHKikXACLn61hLFhimNbdF4huhu6SdQZ0dzLPOfUiFVqDiTcH2KWMJ0hMk/AVVey1korf8oZ3H+pzHc0S2OTPRsVZPkHueehaVXZrsK2TL/YI+aoKAyduPyNcheQgTbE/WDzOqiAO2qvwRU2TMzvnbg85dxhmSv2c9adnYNtvHdACwJzRwdT21T/T8khuLmFv6xLok/TRuZ/1Vy2OCB981t595DaAE54yQy2CU/vvxY3UBs6qm2+FLvhC/qsDEhbmEBZ+BUEUthpbVH8CHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dMy9q8E0IfDEhqqoMEFRpjweTfHECoXnBUjxN2QYpN4=;
 b=AEpRxNjOfdfyBMWvB1fT6bZfPgKEdhXcvu33SMPN4TcpNy0kVbIszazJu0Z7wVTDtGynuId8P8VhLNoqnwbag9PBhFcf4NAlPo1xY45DqIs1qkBUqhhcyB8mghaBVqic8sPpM56fMRCUaKrLUR3sbyOnYE/+raM3Z/uVhwUNsV07zmxmbgexUbYkveBRxkfhv6YQ3hrl4nHb1aaDLpU57UeE7AQlu3CwxTeQ7fs1eIRGGIUFcE3Dakit6mGQ3q3kAohwL76Ksvd5pIsMY9EpiHELLJD4HStA5PBFZ/MViwzGNY+mCwiC7j7XyXL3qmDwp7XFMDIS/k9Uqbn4cYqDRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dMy9q8E0IfDEhqqoMEFRpjweTfHECoXnBUjxN2QYpN4=;
 b=BkhF0sjs5oVa0G7He+jBnsi2yscL0mIxFvZDdp/uj/6paGvuhmUJy5JNzphmtyeI+P9cAWNcO0kCkJ9+hYIYtQ2xHy2fK83Yvx29nkyQh2VWHP+YKQvD5BH9ZHt/5UfE4UDfPbJ2PAnMueqDoUffc09t/2DxxUUS7zDCGS6bAxo=
Received: from SA3PR01MB8473.prod.exchangelabs.com (2603:10b6:806:397::12) by
 CH1PR01MB9358.prod.exchangelabs.com (2603:10b6:610:2b2::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.25; Tue, 19 Aug 2025 20:12:23 +0000
Received: from SA3PR01MB8473.prod.exchangelabs.com
 ([fe80::46d7:1d3a:dc9c:69c3]) by SA3PR01MB8473.prod.exchangelabs.com
 ([fe80::46d7:1d3a:dc9c:69c3%6]) with mapi id 15.20.9031.023; Tue, 19 Aug 2025
 20:12:22 +0000
Message-ID: <7dcff61b-55c1-4242-9ae5-ca965fd4c8c1@os.amperecomputing.com>
Date: Tue, 19 Aug 2025 13:12:17 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 0/3] ACPI: Add support for ACPI RAS2 feature table
To: shiju.jose@huawei.com, rafael@kernel.org, bp@alien8.de,
 akpm@linux-foundation.org, rppt@kernel.org, dferguson@amperecomputing.com,
 linux-edac@vger.kernel.org, linux-acpi@vger.kernel.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, tony.luck@intel.com, lenb@kernel.org,
 leo.duran@amd.com, Yazen.Ghannam@amd.com, mchehab@kernel.org
Cc: jonathan.cameron@huawei.com, linuxarm@huawei.com, rientjes@google.com,
 jiaqiyan@google.com, Jon.Grimm@amd.com, dave.hansen@linux.intel.com,
 naoya.horiguchi@nec.com, james.morse@arm.com, jthoughton@google.com,
 somasundaram.a@hpe.com, erdemaktas@google.com, pgonda@google.com,
 duenwen@google.com, gthelen@google.com, wschwartz@amperecomputing.com,
 wbs@os.amperecomputing.com, nifan.cxl@gmail.com, tanxiaofei@huawei.com,
 prime.zeng@hisilicon.com, roberto.sassu@huawei.com,
 kangkang.shen@futurewei.com, wanghuiqiang@huawei.com
References: <20250812142616.2330-1-shiju.jose@huawei.com>
Content-Language: en-US
From: Daniel Ferguson <danielf@os.amperecomputing.com>
In-Reply-To: <20250812142616.2330-1-shiju.jose@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0167.namprd04.prod.outlook.com
 (2603:10b6:303:85::22) To SA3PR01MB8473.prod.exchangelabs.com
 (2603:10b6:806:397::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR01MB8473:EE_|CH1PR01MB9358:EE_
X-MS-Office365-Filtering-Correlation-Id: d789ecaf-3786-43ad-4b75-08dddf5cb4ff
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|52116014|7416014|1800799024|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dFZ2SHRIeHcyY0xKRW0xS3N3M0dkeUNHbGlRL3dIQUwyUWo5bTVlVU9TUkpp?=
 =?utf-8?B?eEsweFR2Mm16SlpoeTZCRThFR0thYVB3TDVCeXZLQzhpcENvN3hxOUxuMzdq?=
 =?utf-8?B?anRKR01mMWV5L0F3MDNVdHFEdkVTTHh0UGlLL2tzK1k1VXVLVGx3RkhoNU56?=
 =?utf-8?B?dnVKdXhJb0hhVVcyRUEvNG5pZTk5bE9YT3c5LzNZam1XZktmK3hFbHZHUjFH?=
 =?utf-8?B?ZDBwbmRmQ3puRFZjdWY5VFJHcXdER0FjTVhMcHFHekxGOTlwWFFQa3hDR2VC?=
 =?utf-8?B?YjVteFdod1k4Z2pwKzIzSEVkbStSY0VhalNkdEdjUW9oSFVvWWUrZTBBRDZS?=
 =?utf-8?B?V3pwaGlDY0ZHcXJySEVsNk1QcE8rZGdRS05KSndVNEFYc1d2RUNFTkFWd2hi?=
 =?utf-8?B?N3dUOGZTejJRKzlBVUxYTnhTMFNxdjduWXI3ckx6aE9IcGdwQjcwSmN5RGpi?=
 =?utf-8?B?QnEyY3NnRmh3dVloRXIybUM4aXNKT0IvRVBLemJ6cnV6NG1aMEpLSk54ejZG?=
 =?utf-8?B?K2t2ajVZM0E3dyt0YjNpWU9iaGxTaHY2aG5NdndJRGVablJ6T3BmQVFydWlj?=
 =?utf-8?B?N3JyYXR3ZHRMNHBWbzEyLzZSVC8vVlI0U2N5MEVMaHA5V3lOUDJjaXlCM05I?=
 =?utf-8?B?OFlWczNxOHFoL3NCNWV1SlhXcUZlYnFudGFZcHVySTk0ZnliVDR2RmtBUUs0?=
 =?utf-8?B?bFovNFQ0Q21GTkRWekRHK3d4SXozWnZMMlI3Q0htOFZPbndmM1pvbS84T1lJ?=
 =?utf-8?B?VnF4NGFRc1prSS9vaUdlSVhaejE0SGhJZjhmcFpCUVFsQjh0c2NiMmF0NHBq?=
 =?utf-8?B?Sk5EVlFkRTNmRG9UcHVGSDZFaFA0cHNSYjN2S0dZU05OZmN1cGI4S0Ixdmww?=
 =?utf-8?B?dlQxN0FjRDU4YUNicnEwWUtvVWF6ZXFkT1c3emtIRmlRa1F2UllDQXppcHFT?=
 =?utf-8?B?WEJabXg4T1NOUTZ2QWdCdnorNEo4K3pKcHo1VlR1L2UrOThRMkJzSkRCbjAz?=
 =?utf-8?B?NFplM3V0NHZmZ0JXVWtYd05yRmVRUHZWcEUzd2xDaS84b3lZQkw5V0kreUZO?=
 =?utf-8?B?bFhsbllWMXJaLzBnaWNHUDR1RGtJQkhrUVQrQktvVGFiOHE2REFzWXRIMzFL?=
 =?utf-8?B?ZkpBQjhKdWZ2REFFUUNVdjBycVpLNmtzRE9IbVlhWlJjM3hBR2toYnBMQ0dr?=
 =?utf-8?B?WnZjeEpxZ3BYU2V6MnFZV1J0dGFJemJYM2VON2FTZU05TkN2Y2g4ZGh4QTBZ?=
 =?utf-8?B?NDZSOFpxWUNrcXVvci9tS2pHZVdnc2lxbzNQZkhFWTFDTWgwOGQ4QXZ5ajBv?=
 =?utf-8?B?c1I5Z2ZVNGlzenZ3eWhHVFJaN2k5TVZvcHJabHJubXNiVng2MEN3TW56TFFq?=
 =?utf-8?B?d3pHdm1qblc5eHpIbEdZai9oMW1meUxFQmg5WHF1Z3BmbVFoK1RaOGxDNEhX?=
 =?utf-8?B?UzFpbXAraHpJT200NGdxVDlmSEJKaE51TTRSbXU4a0Z4M1VPRlUvQ0lTK0Nn?=
 =?utf-8?B?NXdxVFN4dTNGT3Z2Mk1FcW5mNzRCYVpjU3FhTmF4OUF0NmNMdDh4dDhpVkxr?=
 =?utf-8?B?VkEyWitpZzd2MVNDWmMrRHdLMC9ibHhlcUtNcUUxZWk4eWJCVGxiVks1cHhn?=
 =?utf-8?B?dEJZYVJMLy9JRVFwaFRiOGJ1cHVEa1FhZHZ4M0tGZUpKNXVpaG1IZ0ZVRyto?=
 =?utf-8?B?VmlhMSs5azRtRGY4dTRsdDlHOWh4TSt4SWdKa0Z0OW5lcm5XR3BuTWRqN3F4?=
 =?utf-8?B?emRueHpaR0tQd2t0dWFOa3NscEt5MmlYWXVBSjNmZ1pGekFJMklzN2M3ZlYy?=
 =?utf-8?B?b3lVTDBBcjBBcmFaYVJXMjE2Slh4Sjd4M2l4c1grTDk3Nkh5UXM4YUhRMkEw?=
 =?utf-8?B?S3p2S3Rtck1tZGNGcndOejhUOW9TTXNKNVdyRFhJUXJKS2x6ZU9OTkZrV1Fz?=
 =?utf-8?Q?QLWnn5KZvFd4DF6KRVrvCCyLj0uAKbQR?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR01MB8473.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(52116014)(7416014)(1800799024)(38350700014)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UklrWklrenhxSGxGUTJMRnFRZlJydVg1YnNXOEt2M3hJWVZjRWE1cURQcE5Z?=
 =?utf-8?B?TjZ0NCtCbjBNOFgxQVdIZFJ2ZUtWZE5OTXo5SlFEUHF5eW94anJsVE1HSUc1?=
 =?utf-8?B?WS9RKzhkUmtQYXY3eVdyQW9ldkhMV0ZTTnd2bmx5d24rTUxHMFR2UUI3clRM?=
 =?utf-8?B?OUNmZHBLVVVlYk52N1Q1b2lDVUtRd0pSTGd0T0JvcDlYOVYxdk9EK1VlRmRu?=
 =?utf-8?B?ZXR0RXdjaklFM3hmRVB2K3Q0RWZjUThNTGIwbmFMa2ZmRzdLTWJOeDZHUEFF?=
 =?utf-8?B?MlM2YmhFcjNLVnE0WVlTM1ZxMDdVTFhsWWJER1ArWGVXL2RGbzRhaE5lUysz?=
 =?utf-8?B?RnJReVIzR3YwRyszVXJHR2RPMWI3Sm9KQXZjMGpnOGhia29ZcUE3ZlpXSkg3?=
 =?utf-8?B?K0w4cXRZNVhuSWhMKzFSa1NnQUd4WisyRG52MGNTTzFJK3E0V0NxZ0dRU1d4?=
 =?utf-8?B?TzgydmZBQnk0SnJITWVCT1VqaEJOYlJrRWdMU0dSa1lSa2tJWUQ5NEtKTnZJ?=
 =?utf-8?B?b01vMURScnkxcVMwZDlkTWx3SU4ySTAvYVFZV0xIWXpHVU9mV3VJTTV6MUhG?=
 =?utf-8?B?VjQyZWNWNnFpMzlzOE5CY2lSZXVwN3N4d2hiWGFyUEhJL2pSYkhCVXhiSy9R?=
 =?utf-8?B?bVh4M3BVOWZoemcvTTZUdFJOUzB1LzloelhDajdtamJ2ZHB2cWtSR1MzeGJK?=
 =?utf-8?B?TGFHQVRsajl4cW9IbC9yd0wrRFYza3ZoUGZQRkN4TXB4NHVFR3VZNU5tVG0y?=
 =?utf-8?B?OCtUTXQ0T2VwU2dJSFppSXViNEVBMlhvRDc1b21lWC9FcVh5MVk3Uys4V1JC?=
 =?utf-8?B?ME1rYTBkZ2RCKytVbHFKTFVkY0U0ejZpSkRXeGVVSzhKUk93cHZuYnFRNXZ0?=
 =?utf-8?B?T0puQTdSbEFGVS8vQzlRRU01WVJUQU92N3JOaFBNUVNRa3NhaXhNdWdhSTJa?=
 =?utf-8?B?akkzTXBsNlgrVW0vaFRCSmRrME5wVzI5R1R6R0ZNeUxDaC9OMXhwNnJ3NVZo?=
 =?utf-8?B?NFAvNEZxZVJVbk11Yi9RVG4vTjF5U3J1SVNUczUvVTVtSEF0Z2V6VVh1cHIv?=
 =?utf-8?B?bzFtcENwRnZXV0lzbExqeUs5elczRk1JRmtQQ0dXOTdUV2xYY1BtbjBYOE1O?=
 =?utf-8?B?MFVmNW1sb2xnbDdLSEZMWGlRZDNDNWN6RGl5QkJ3Ym5xdVJKTGx2Mjd2NElX?=
 =?utf-8?B?RjJ2Uk9uTXVreWp4VGp5VUpJaWVlSkltSUhvRUZEN0FiZ3UwdThHSnlqaDNs?=
 =?utf-8?B?d3JiblY3TG8yNkFsV0h4ZExhV0FYVmhwOXFiaGU3YUN1MHM2Z3NaYmJkbUhr?=
 =?utf-8?B?dzcvWE93blpOTG1BamFyMGRBcmhrczNyQkw0NFJUeGhDL29sZERZRzcrWVRj?=
 =?utf-8?B?dWFOMUZ5QXlSaHNUckdDMitWMHZaUGdXN2xMWEF5T3ErZHkydlRCNnRqSnBI?=
 =?utf-8?B?bk1MUU9yeWkzSi90b09pYXFXMlBlTVVVNVVTTldUSDBpVFVzaVdFWVhVUUJU?=
 =?utf-8?B?MGhLR29LOEtWajlFVUhpZE00N1lrY3JiaGRkcUtid293WnVyaVE4ekppYlMx?=
 =?utf-8?B?cVpLVTRoYUc2eVduclhIa016NENqN2lPV3NQMjBXVzJEaVhvTnpBaElKemJY?=
 =?utf-8?B?TUxycXBuMysxTlN0YUtzbTRyZjVFK0NuTElJblhMQWIyV2JzMTNhVW02TTJr?=
 =?utf-8?B?Q01NVXBuSlhvTmEzR0E3cExwWStxTkNXZWtlY0U1L1ZkUGd5UEVnTHQrYWYr?=
 =?utf-8?B?T0lqZDBiTXB5Nkg5Y2tpTnJuVTBIVUxuMTFZNVAzTmRGMi9Za0RLOFM2L3J1?=
 =?utf-8?B?aG5MUmtERzRFMnM4ZnlDaTd0WXRFaGNnWTZzQTNLd0ErLzJvRWQvUHRjMEhq?=
 =?utf-8?B?cThabDFIVU5SMjhVVENxVTkwK0U2QUVWc21NMmVJcmdvZit5Q0xRUkM0ZXp2?=
 =?utf-8?B?Z3Q1NFIwRTJHazkxdXdTUHR6YS9LZTVZbGpMbThxeGJlWW1EOE5XS0xMRXpP?=
 =?utf-8?B?bjYwM1JxSkpMRkxINlYrY0FKRFhlUkYwa1BHT1hJZ1dCSUk3R2pGeENKYmxi?=
 =?utf-8?B?OVVaQ2syWlhUcEtrVnh2dFoxSllidEJmOE53cGNkK1Q2TWJPOWJMUHVBcFRZ?=
 =?utf-8?B?bUxMbGdDcDBPb1ozWFVIYVN6bm5BWXRLSkJ6N1kvSjRnTTk3YjAzNHVKL0dz?=
 =?utf-8?Q?uu2pYDzPikM38GqC+a15LAI=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d789ecaf-3786-43ad-4b75-08dddf5cb4ff
X-MS-Exchange-CrossTenant-AuthSource: SA3PR01MB8473.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 20:12:22.7276
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t0VzpG/6nxSdboEvn7SRD8TTZ7cYFoH/stBv2hUWz0yPbBZo0A/Gmd7Wo/NUJfaWzE3j0syRfhAfwxYjyyA9OILo1brP+CgIZN+OmVYeSDx7y+qUOIRn+63/I/+Paxp1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR01MB9358
X-Rspamd-Queue-Id: 7741120008
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: jm1jcq3mj8wpruehncw88y3eizo8414q
X-HE-Tag: 1755634346-226996
X-HE-Meta: U2FsdGVkX1/hPMw4EKPTlMNLQOjYPuTaJJEhHRXL0IMSh0GXmiMWoP3mLjjxw5PHAP723iBwUojApM7mQKulPoU+lADGDX2KLP9UZVISxJji0eCteq9kJJLrPAHgyWv1crr667zXJBCq7wBbhqjw2nSpkSsqET+nutGzkCYthUNcoPq50hz36xMAf1SY3lgganFVIL55eg3VDRU78w3hncZ0A5tIJ66P6qgJ9oroFWBRSRxBAF1wrY7HrrAcJF1bxirHpASFQXLCOFiWyUiYJw9dP0MUBrzO1Tc1So/HUq0UYUEiecFJM0YOaA/ORIdi9ulfNh8EBsIkjupCyedxigmnDklqxApik4DieYmd67LNqAB/VABKHzVJDXjB8wYoIQgJmjsXyihO6Zzp8kRDWglq+b1Lt+FXW9LCOARNiU5n82h/YwIwVOk+TvzLjzVSDvbMXabWwP57BY5Afcpjz1y74Wkx6jqDhv7Dgm+imoSaNcpdipTnt5tjJPgnDes+j2TlJCBrVArVmqVm0vyUP4NpNPmXM0XATvZXEjaXeradJW2ES8HOYtZr1AhjOw87YD5ctpW4+TFOjFc7mHeB9YZFJ/Pyb3V2FY/GNyEGF5srECjNM3gChURLO9b2nYDa+wALwQoqRUch2k9YKM2C21L385TiNZr3h4Bub2paGlOCVtxKzDX5PCToXa7b7rSTtsHXqOn7v/wxgYomzP+WnAdkUU5FKvzt4UjvDNaWAQBWOzlULdi2HSHcdJRBkh+ndTUszmuvivb6fkZdGlUCQKM98JQVupAtpe4HQChOp6Kv1T6xzlouSNtjVhk1FTIUuLSiEAMDVfBlPPn9XSLuEhWsnq8nIYZMteg+O5UgSrAndEdASKcaAk+je4ZaPaeCjwJ5AcTjRokOpsGxSvAnoVpsqo68JjeSeIu3oYjZ8qkRrDJ+bmv9ZfA2qy6Gnejnm7rI0Zg6JoQaqEQFPu1
 mQREL3Gl
 bAqkud19ZcMsz8j0wV85KLirBSmsVVdVbh24iuT0vfRNGGBnzKQ5/ew8ioPT/CBLiCdikW1ZgmmhcbpQDVyDi/ATQvCWIoGKx/lG90cpgNmTRXuOkCjDSy7ZNUjMFTFGgJL3DEPIBgTEBkFTJV4DXdRP5DUcJlMrwjDd0QIy7b6jkQ6W/wR04AxKwagQVvtdpyz8sJ+f4fvRPvhqte1aeQus1f1CrFDdBu+E6wi+Qlx7cJ57o2L7xFa988gGDotnBcH4Q9KETAZXbZxuN8u5teMs4UvuvnT9mim/z4Q5aaKNgXf8Z5J0iEIVSvY/2VHTc+lwEMBKNtZfbTUGDCgloKsHRRTS3ZXOitiKcbbtKZKaOU9mT7g+iA8Kc8969AMRa8OyVicVT7W9BGGLm8lEZVCCnrAdaYlcgo9dmUTDr4ZnO5qU0s7ntFIET2vV31PFnvSYwmiq+p9/5gB8C/fTx7I7JkLrXdoX47HXXThCYhlSG/qFhxxu2Hazmg0Ih4mXcSsOKy7mQJVNaky3cvEMZs1+qmBG3Vuts+eA1wCvZOsxxbB3JTC3ygRXvPqE9k3qgzJXlJKIJfpy6+MmmOU8nW3vn9hSGCwH25cfV02rmfiaNVF7UbYXzuZdiR/hdwfFHGjYIUxTGo+RqAuwnRRSts/Y0SiCflfvKYHejdHBrV0mw7WoXG39nd5+ysvhqsS52i1pGhXkF2JOBFvcx1vdOlI3DJ662qxVmRVIv7gVSkZ9HfqTvW7EhY82tlw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Changes
> =======
> v10 -> v11:
> 1. Simplified code by removing workarounds previously added to support
>    non-compliant case of single PCC channel shared across all proximity
>    domains (which is no longer required). 
>    https://lore.kernel.org/all/f5b28977-0b80-4c39-929b-cf02ab1efb97@os.amperecomputing.com/

I've tested everything again, and it works.

Thanks,
Daniel

