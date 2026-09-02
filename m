Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7691AC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 21:04:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DABEA6B0088; Wed,  2 Sep 2026 17:04:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5D866B0092; Wed,  2 Sep 2026 17:04:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C242B6B0095; Wed,  2 Sep 2026 17:04:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8F7CB6B0088
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:04:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1236B16037B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:04:35 +0000 (UTC)
X-FDA: 85170050910.12.679C7E6
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11022073.outbound.protection.outlook.com [52.101.48.73])
	by imf10.hostedemail.com (Postfix) with ESMTP id DD69EC0004
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:04:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=SKJfPK9T;
	spf=pass (imf10.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.48.73 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788383072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qJ2suCguM5lzL3bZ9tFqiTyZTRiCMFpmZv1RaIrLjgQ=;
	b=YA1nJmWbFAItqv+XRByNM3dTEnztppBxtRJL0hXHwjOjJNbRCSLrAwQNolHG2OKQ0xsrON
	QJ7M7Tu2TtmxCi8mMml4HCIujGhWfkJSnxeF85QGZz8WwndPzNz5xZSlgwIjSt6jcVkYZm
	yMcAAo3xJn3PoZtj9ToBpOj1EYYtf3w=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788383072;
	b=GwE4c7n9rfZLY8/muE79+9FpHDDElaZAA0z0Zrgh2+T7guGyhg6Bbb/ISd13HDFPQRgW7V
	xKgoE94aJuwguARgEPvKIZw/Sgt6YEDwv/WhZH8o1rizesUFfYWk0cmjgGKo2F0ADOs9rC
	TX7ADrgKcxrTjbDYQLEzW13LPdwkH+o=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=SKJfPK9T;
	spf=pass (imf10.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.48.73 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A8DMJpy9/l2cY8NrnUFL1i3kTZVpYqaGnHFfLtdkO1FV2bgU1bG9vrgS8JQBLZlyx3UeqFsIDtzWyzuYI2xUMYzvu53sn+rfNsg8+Dn702Pc9ewcwiEy9DVsERDERXwKd/UngFtq7SjIA2j5kNUL8vv9v9Qt+dJf3i2MqBWs9BBmO3mc04mj9rkNzfe3vuGBgWGP6UKYigZw2yjjrCnO/huv9jme4exx4FDQfkmnUJazZ01GiCW5foBJaO3cr9izCODt8xOHt1xVpiGxm2SVLOy9WRU4LKBeCagSs0Nu5iEvH18wqGgOFS6YUsG0ACMF8dDl5U38H0znXVW5HpoAag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qJ2suCguM5lzL3bZ9tFqiTyZTRiCMFpmZv1RaIrLjgQ=;
 b=ID+OuAsWSwhTJdK+v/NGOSahiatn/vQiy7rBW7hdZlx8VOwi5o+x4WISC5b9TBTxd1pKzgEDaoLkGs70LEQc1nBhXCknFhoufIfDMB7o7o8qhzeVTttp4lUeiYAGRf5Fa+GywQr4sb9O0YiNf7rakND7DEwc/7ygrk3PMmvEbJga3Qzma+2rZg05UfuRxzv6iUcrA7EkcxX9VHneVZbEErs+i513JID8WxKjDUBPk/LobJLNtw6FMU2HdbRSTsGDiUwLlulvgxeSNR+w92N/EO1zvp10GFWT4B6zi6KmaYfb86c4o6fAkrOisS4/yzmJkJe1oS4FI9vk8u7J8HRZpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qJ2suCguM5lzL3bZ9tFqiTyZTRiCMFpmZv1RaIrLjgQ=;
 b=SKJfPK9TRwuBbHWr3NfOuJHMWmuY2N636VeZa35F9/ElCClMDKMylb/bgApH7+bjFnwbFdooGrWIrMEYi7+ozsi01nmc3aqBbJqBbvd6DxUVd0aofMEdWbcHQ+gkM2WDMo0KdSRUX/NRuh0akd1XJz62IJZ4ACn2j5Ys31hop48=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 PH8PR01MB994612.prod.exchangelabs.com (2603:10b6:510:3b3::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.7; Wed, 2 Sep 2026 21:04:26 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0%7]) with mapi id 15.21.0360.008; Wed, 2 Sep 2026
 21:04:25 +0000
Message-ID: <ea42bc79-5c60-4437-a8ed-8803f4cf4e6d@os.amperecomputing.com>
Date: Wed, 2 Sep 2026 14:04:22 -0700
User-Agent: Mozilla Thunderbird
From: Yang Shi <yang@os.amperecomputing.com>
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
To: Usama Anjum <usama.anjum@arm.com>, cl@gentwo.org, dennis@kernel.org,
 tj@kernel.org, urezki@gmail.com, catalin.marinas@arm.com, will@kernel.org,
 ryan.roberts@arm.com, david@kernel.org, akpm@linux-foundation.org,
 hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
 <afe6eac4-c8db-4ec7-98be-1c7cb0d3c1de@arm.com>
Content-Language: en-US
In-Reply-To: <afe6eac4-c8db-4ec7-98be-1c7cb0d3c1de@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0189.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::14) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|PH8PR01MB994612:EE_
X-MS-Office365-Filtering-Correlation-Id: b8bc5907-42f0-4d8b-9da6-08df0935c533
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|921020|10067099003|11063799006|4143699003|56012099006|18002099003|55112099003|6133799003|3023799007|22082099003;
X-Microsoft-Antispam-Message-Info:
	m3V4N+ypQr8qpKyjCoJmxQ9hBrfPqprKWrKHg1fxsKKNMlWqL9vfyBs+/jim/5ECfWgN2ygojH5vyg3w7lYjdiTMer+53mf+xbylzV/jRofJQ750y0nd+uWshn2agDVDvW8EqV6xqgdrpgvCb9uz4ICxJT8qrmuwIoVMy1MAj9Xkhp8m2lf3IU2xlr92DV6CKu1eY2yEe1MQBedRxkgIrE+NOQmyh3yF8TzUS6z3fZtKwMa5kVU5l41wxQdtAsFomNdxd+uzp/zXxfCAC5+SNZMt6lUqUHIXn2NIQVqe1W3cgRPYXdvMzRoz34ObSmfR4WNpky2jPJ1+Eylq3VewXkaECrUIZElJvNW+NP1b3n/Q4wjaNewXXSnKNY30hf6JgjM2PB6BSTJyjuRxuoyeoONytTvXm1/IScR8M6sEdwrMNMNumioHBML8tm606KxDFbe/tE2naet3LjITE0El8CklhsUK75/PapbAwwpUsD4u23dNPd2qk5k8ntj77jWjr4QFoEsruw0vypOUMvni2zSE1mpTFTx5tFNtvGzJocm+D9uq9xWIGkYZHllJPAGZ0WE66IsWoOoVdFZbchw9RbrBMn+pZKAodx9ldR9hePPW6z61UFwZPzYkpdlgmaFtQVmaRkLjyix10Yw8gEYxgKX1nSZrpdoE+XVHkTdlqzbikCuAsa0S4g905ncaWeZu1ueiverl+H0exopxPhB31A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(921020)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(55112099003)(6133799003)(3023799007)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QmQ4MStFR0RkcDRycUhmK2FjZ3MwUWFidDU3TnFYUlgyVGdFRTNxYTlpRmUx?=
 =?utf-8?B?SGdQdUQ0YlRsclcwMmZrVDFpNlBTNU5sdXFmcmZuc3UvNDh1UytjaVhPRXJs?=
 =?utf-8?B?WVpGWUVuM0dpbDdWTjJocTBhNHNTOGFGaUptSXdPcWE2TnVXS1QvUDAwNUp3?=
 =?utf-8?B?bEFHL1drMFZWOERHeWgybDdFSG9WdHI3bGpYTWZBL0ZlVy9DL2VLVi95OEFz?=
 =?utf-8?B?RHRjMnJzTE1ocTBHUFNHZytPTHRrSGREL0RtL2dLbGpPeUYxU1ZNMnlpdEx3?=
 =?utf-8?B?bUFKNjJKVnNlZnV3cXZUVGoxWS9xQmhJSFRCVCtLaGgyYStONEhqUXQ1YkZJ?=
 =?utf-8?B?ckt6TllLR1NDL3BSbFhKeEZGWm5ibjhVU1pIcjBLZGxkTS9MZ2xZQ29XQ1hs?=
 =?utf-8?B?bXJhNmM3dlB2NFJBQlRRUTc5VkxRMFFleUs3cExXdk8vdmdicFFESmdYYkZM?=
 =?utf-8?B?K0pDQ3VjZlFXWmg5bDdoNkZOWmxOOThIZncxbmpvTW45elRqaWphTWk3L0lt?=
 =?utf-8?B?N3JNQzJCdWVUNzJDNEZEdnVqYk8rcHJ3LzNVMm1kbk1ZOUJJcVB6c2RHMlA4?=
 =?utf-8?B?amJTbU5aTk9uQ0JVa3N5bm0yeFQvNFFUdXdGc3o1WkNMc0tqbG5DWVNMc1kx?=
 =?utf-8?B?ZGhSZWZ2NnhLWDFUM29FYUlETnB5bkNrd3VteTBVMzdRZDJPYnVtQkxNdHA2?=
 =?utf-8?B?UENwL01sUkVidEJqTmFRaFZzR1N1QTRIWGk2cDlCcGRTNHplelhxbVFwTFNE?=
 =?utf-8?B?cENjZjloYmdlbkdmU2dyMjgyZXoyVUhqWGJQKzNBSFhtRUU1eW1yL3lBeEZ4?=
 =?utf-8?B?Q0FESGZpQVdndm5GNkxPZW9ld0g0MGFkTUpMcDBIaGZmZmRkOFNIMldwaGZs?=
 =?utf-8?B?N3E2VmZnVGxkb0dPbnBoWGxTdXhyMUwxS3ZnSHIwY2t4aDlSbDBFSHJMU25F?=
 =?utf-8?B?a2Mxd25Fa2dHSE12bTFBNy83OFNMSDZEeGRERFVNUG9CWU5uSFB1ZmM2dTd2?=
 =?utf-8?B?OTFsanlVbndXN3VPTm11S3ZOQWJnSnhTdzh6MlAxOVdVajlpa0J4VWRXa2Q3?=
 =?utf-8?B?ckhiZEpUU0ptOUliZHlMbUE1Mk91K3hBdVpCUzNOS05iektGdmVEZnh4am9a?=
 =?utf-8?B?YWV0Ukw0dnNxTmk2K0hTN29hcWJScXVxeGhPRE1ZZ200WHMwZ2cxeTBDLzV4?=
 =?utf-8?B?d3hXci9FS1JyZE5IRHhOY25jNkcrRmdteW04ZWVIdjFkdHdNdWovaWtOMkxz?=
 =?utf-8?B?SGlab2YwQkl0SENVNW43emkvWms3bzFRL2czYm43Mjh1MEtWdnRaOFFKWTVY?=
 =?utf-8?B?ay9VbjZlRUkzRlh2SGxneElFUGc0Qjl0eXZCR1hMbnFEZWRRbzZkeE9mOXRL?=
 =?utf-8?B?MFgvaVQ4YlptYkhPN3lhUFhObk96aVVHc3JwNFM3Vi95T1p0L1hmMHkwY2Rp?=
 =?utf-8?B?RGlDRHptSjRkd0dycE40TVlLWnlrdE1pb2NuRzh4Z3dwaXVsbnZUUkt2ZkRD?=
 =?utf-8?B?ZkExME1tSHhqZVhBNUYwemF0M081K1E5ZGFTdGFLMkFJWVJ6ZkdlczNMaWpZ?=
 =?utf-8?B?UWlOTFZsZnhaRm80WWxhUmtTVUgwMGlSM2JFSVBITmM1amNLamd6NmpSTVd6?=
 =?utf-8?B?ZnIxaE1sQVM3a2gweDhqS3Vjd3E3RXZrbU9oZnUwUm8weGxsenNlak04VVMx?=
 =?utf-8?B?eTBSZjVKcXU4eUJzNEZvOWtUT2dxczMyZU9lSGl1TFRlZlBhN2syNlhnQUJ1?=
 =?utf-8?B?aFJ4SXpScGduaW1JTk03b0RQUVZ5aVdVR2Vwc3grNVBrYlVuR0pmUjBEdVhv?=
 =?utf-8?B?OEJNSGhTa25yTE1YaDFlbnRGOVNkVTlDeVRNaElWaWxTMS91S1NZeEFBQ0pI?=
 =?utf-8?B?TCtOdGdYTGVkNU1kNlVtYVBQdHliUDBBbllOUVNCdzh0d0FSZXdFS1hZMFpZ?=
 =?utf-8?B?Mzk2b0hCWERjM0JhSnVFb3h1WU5SSmd6TDZWVTliczNuSGo5RmNrWFJ3cm5M?=
 =?utf-8?B?VUlmK01yVVJXdnVJYXc4YS9yNkVTR25USWxmR1EvenVUak4wSkhFN2dVaDlS?=
 =?utf-8?B?dVFCSGZIMkZreCs5R0pGT0dHY2RQMTU0RkZjR0lxSk5kWXpKazF3NU11cDhz?=
 =?utf-8?B?ek02YzUvTHd5MklJNFlKcUxLNzlVcEltb3NFOXBCc1BMUnpDeVBiaGVTNDhy?=
 =?utf-8?B?encyajNhQUI2L0hCOXR6N0xXOGN4MXUwcTY3ZHVpMTgxTHJxZWJCZmJCUHZJ?=
 =?utf-8?B?U0Ewb3lMeGpmVTErWTFsVFk2MjAwYlZjd205VXNvWUhVazB0Z0dYYzllYmhR?=
 =?utf-8?B?SERwWGppNjhDUXhzSGVGL2VFMGgrWHl0aW1MSVZmaFgyOS85V3JUVU9QUm5H?=
 =?utf-8?Q?YNUUuCvpmNcod4Cs=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8bc5907-42f0-4d8b-9da6-08df0935c533
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 21:04:25.8393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VRbsiEmiG51bRbdvpsAE88gLHuW72CxURX0hfUzYUTA9wRzNtnG7DMIFZf6C9VN//YpsnYxV+YtyqQGDkcogP4VP0xwhS0vL7a9NC+M9bug=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR01MB994612
X-Stat-Signature: 18336uyj7xum7y3g8963d3wg7suzm49u
X-Rspamd-Queue-Id: DD69EC0004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788383071-887549
X-HE-Meta: U2FsdGVkX18knJQLqK/otXS7eBFSTZJ1GDU8s9nl5wZ6D97poQyRu4x5Cagf+JNQNLySVXbn2F+aPsMpi6gdeN8COL77f3TScrNXQ3cc9zgaHHiyjr98QNnhV3lMTg5cL/buiDOoZpdd/2YmqImA0QeXnWatgW5pWGQzwiyGC+kuWlIgNu74tyDckPJfBAjZS8svpldyK9niZXx6+9jvRvzLcJPEqLhuoO0HXnUdFATbHn2EAFQwJepUTRkmkbkb/XppPFFpQqsyb98Nb1bV8XgApdfXnHm5qbO/DZ1uxsCNQOu1rBkcqPQbjKo6q5DyrhtFmQ2BDAMEqL1PtMdTLF/J5x3XdJH7JrsjEjfTjUJGZltV+UeFdUf9Jr6GneIKPJKyZoKkgVA3onlDWOGgKBDn+804605PTRFBAYPpEgMsudhsqaeSTUvDivBtwbAH7aDBwYmrhnx037kFRdzKnybBnjGhckKLSGMWtvqscvu0O8Vai1alNoIHcNV6AnirbKL15ozqnQBhp1qiUoe5Z34t68N7afOX9DG3thwYn6qWeGm1QM9yQljFeUN32F+EOH6i3iLUc77V7+8DTemcSQ5nB5vKwwJkRgPHlKGC2mKT5jygP91w/l5yvfcCC/8Wa3r/P10jItrstGPEV2Xo+JUM+apuZSnequZotycPslWSAwhL3XzcI+eCxjQDWCrazNRF8MCj4m9XiyVFjuvml75puY7EazcvzEbllt7rVhAyzaL51Og4snB8qTra08nsJbxyPNKoEw+wFse6oUkuLKtcry02hNlYGbNDpgrgVLWAz+jUs75vlp3fXtbxWnek5YtXEVv/ed9vZKU1wrL+hDy2gtYJqhg40PPsPCnuD0NwRzKVukz66FYIl15E86WlCZfD4Z0iVMA3LYL8YlXFR3ZABmZtUrdxaQJReFdK2KIl6MwZmxI0Ogon8rF9ZK7Qxp/+RqYaK6mFO51W+Pl
 1OA5rc5x
 4VmAWzbJz6oyFLoaoX2pbndQsSYt+UBg79AAp2xesh8HT6+TEniUvUmfaujEs6NPY4bThcqzKsuaWhNJcIYu07r0C9W3d9eLnLp40FvAGLFobvWAX8XU6MNu9A7Cj/13CLEF7G4HWHCEw6NBEFQg8UT9WHL8Lma/iepNVjY/qjyY/IfcjPJsDcKnpiUk5ynP82aUEOCIrWrvHCAP5y3U7POKAtUIBFtKqbEgmH46HumORZJDQiyOhbS6UShwuTGxYp3ZTWOqMYxyIx2b7MifHX1EKdbmS/dAmpwW+D16cnGXUzv5v3rfXYhduWWjw2pB1sH036F/A7OXI5j57cpsUlrTfUKSJ/5Na5ncbHvlmGMNiVIil22HErKwxeUbVxiM84tSrKyNCorB/NQAWXF4kxyltULMa+tL0KWqSL6CHORExiK9z9hsrmfLtviyaAhlwOrZbYpOprewB28d4a2J6U0kr45eXKJ/zNmQ49LsNOOasrOkiY7B8F7SZEDce8/uwKpHiuRSMlpOftP+2lY65fSYeJ97pLZcCiK89RmTnyBwJFSntF0FtWrRvute0+OKNxodTHQIuvyASpx3xOjUd4NF26+UQ9dIxUSwkPm1bRS2tY84NjeiFjrfsbhmSSr2PIf7SeZCgj5Q6wz6cZuY8WWIT6aVm3p+ZajQ9DT4aCQXbCitxzgIZDoqjcg5hrk2Rq88+hd74ZJkKZHl1FSnD3K7x9lr21xcEZVkt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/2/26 4:51 AM, Usama Anjum wrote:
> On 15/07/2026 7:04 pm, Yang Shi wrote:
>> Hi,
>>
>> This is v2 RFC. In v2 a lot problems found out by Sashiko were fixed and more
>> feature gaps were closed (please see the below changelog for the details).
>> Although there are still some open issues, for example, it just can support
>> 48 bits VA (for 4K and 64K) and 47 bits VA (for 16K), KPTI support has not
>> been solved yet, etc, but I think the delta should be big enough and worth
>> a new RFC to gather comments in order to make sure I'm on the right track.
>>
>> Some more benchmarks were done, for example, some latency related benchmarks
>> that I mentioned at LSFMM because I thought responsiveness should be improved
>> due to the removal of preempt_disable. Collected more PMU counters as well.
>> Please refer to the benchmark section for more details.
>>
>> Look forward to comments.
>>
>>
>> Changelog
>> v2: * Added 3-level and 2-level page table support.
>>      * Tested with 16K and 64K page size. But we just support 48 bits VA (4K
>>        and 64K) and 47 bits VA with 16K for now.  Please refer to the below
>>        "known issue" section for the detail reason.
>>      * Added support for memory hotplug.
>>      * Added support for KASAN (generic).
>>      * Treated percpu and local percpu area address as vmalloc address.
>>      * Fixed build failure for x86.
>>      * Fixed build failure for !CONFIG_NUMA.
>>      * Added KASAN support for local percpu area.
>>      * Some other misc bug fixes found out by Sashiko.
>>      * More code refactor and cleanup.
>>      * Regorganized the patches.
>>      * More benchmarks, refer to benchmark section for more details.
>>      * Rebased to v7.2-rc1.
>>
>>
>> Introduction
>> ============
>> This patch series implemented the LSFMM 2026 proposal for optimizing
>> this_cpu_*() ops on ARM64. For the details of the proposal, Please refer to:
>> https://lore.kernel.org/linux-mm/CAHbLzkpcN-T8MH6=W3jCxcFj1gVZp8fRqe231yzZT-rV_E_org@mail.gmail.com/
>> I didn't repeat it in the cover letter because there is no change to the
>> proposal.
>>
>> The series is based on 7.1-rc1. It is basically minimum viable patches.
>> There are still a few hacks in this series and it may break something,
>> for example, KPTI, SMT machines which shared TLB, etc. But it shoule be
>> good enough for now to demonstrate the core idea. The main purpose of the
>> RFC is to gather feedback, figure out missing parts and risks, and make sure
>> we are on the right track, as well as hopefully it can help the discussion
>> for the upcoming LSFMM.
>>
>> I broke the patches down to arch-dependent and arch-independent parts so that
>> hopefully the interested persons can do experiments on other architectures,
>> for example, S390, easier.
>>
>> A new kernel config is introduced, HAVE_LOCAL_PER_CPU_MAP. The architectures
>> which can support this feature will select it. Allocating and freeing percpu
>> local mapping is protected by this config so that others won't pay the cost.
>>
>>   
>> Known Issues
>> ============
>> 1. KPTI
>> -------
>> We need determine what CPU we are on, then switch to the right page table.
>> Currently arm64 kernel fetches tramp_pg_dir via swapper_pg_dir - fixed_offset,
>> and fetches swapper_pg_dir from ttbr1. But ttbr1 may not hold swapper_pg_dir
>> anymore except CPU #0. So we need to figure out the other way to handle it.
>> Switching to tramp_pg_dir should be easy, but the reverse seems harder because
>> tramp_pg_dir just maps the trampoline vectors.
>> Maybe we can do two steps switch. Switch to swapper_pg_dir at the first step,
>> then switch to per cpu page table (for entry) or tramp page table (for exit).
>> Nobody should call this_cpu_*() at either userspace -> kernel entry stage or
>> kernel -> userspace exit stage.
>>
>> 2. SW PAN
>> ---------
>> Has the similar issue as KPTI. It installs reserved_pg_dir to TTBR0 when running
>> in kernel space, but fetching reserved_pg_dir via swapper_pg_dir - fixed_offset.
>> Maybe we can save the physical address of swapper_pg_dir in a variable, then load
>> it from that variable instead of ttbr1.
>>
>> 3. Shared TLB machines
>> ----------------------
>> Some machines may share TLB between CPUs, for example, SMT machines may share
>> TLB between the two hardware threads in one core.
>> The per cpu page table just can't work with it. Maybe we need a new
>> cpufeature to indicate whether per cpu page table is allowed or not. Then
>> just enable it for not-shared-TLB machines.
>>
>> 4. Don't support all VA bits
>> ----------------------------
>> We just support 48 bits VA (4K and 64K) and 47 bits VA (16K) for now. For 4K
>> and 64K, supporting other VA bits is not hard, we just need to determine the
>> size for percpu and local percpu area.
>> But it is harder for supporting 48 bits VA + 16K page size. We just have two
>> top level kernel page table entries with this configuration, but we assume we
>> just need to sync up kernel page table at the top level for now. We need to
>> sync up kernel page table at the second level in order to support it. I'm not
>> sure whether it is worth it or not.
>>
>>
>> Benchmark
>> =========
>> The benchmarks are done on 160 core AmpereOne machine. The baseline is
>> v7.2-rc1 kernel.
>>
>> 1. Reduction of kernel text size
>> --------------------------------
>> The patchset can reduce at least 11 instructions for this_cpu_*() ops. Both
>> preempt_disable() and preempt_enable() need 4 instructions to manipulate
>> the preempt count, and preempt_enable() needs more instructions (compare +
>> READ + compare) to determine whether reschedule is needed or not.
>> Because this_cpu_*() ops are inlined and called in a lot of places so we
>> can save a lot of instructions.
>>
>> The size of kernel text is reduced by ~184KB with default Fedora kernel
>> config. This also helps reduce kernel icache miss rate and stalled frontend
>> cycles as kernel build benchmark result showed.
>>
>> 2. Kernel Build
>> ---------------
>> Run kernel build (make -j160) with the default Fedora kernel config in a
>> memcg.
>> 13% - 18% sys time improvment
>> 3% - 7% wall time improvement
>>
>> 5% fewer kernel icache miss, 5% fewer executed kernel instructions and
>> 15% fewer stalled frontend cycles for kernel.
>>
>> 3. stress-ng vm ops
>> -------------------
>> stress-ng --vm 160 --vm-bytes 128M --vm-ops 100000000
>> 8.5% improvement
>>
>> 4. stress-ng vm ops + fork
>> --------------------------
>> stress-ng --mmapfork 160 --mmapfork-bytes 128M --mmapfork-ops 500
>> 15% improvement
>>
>> 5. Specjbb
>> ----------
>> The specjbb test latency curves showed the patched kernel has consistently
>> lower p99 latency (the lower the better) than the baseline.
>>
>> 2.5% improvement on max-jOPS and 4% - 5% improvement on critical-jOPS.
>> The specjbb benchmark is quite sensitive to latency and responsiveness,
>> particularly critical-jOPS result. The patches are supposed to improve the
>> responsiveness due to the reduction of preempt-disabled critical sections.
>>
>> 6. MySQL
>> --------
>> 1% - 2% gains on read-only test, 2% - 4% gains on write-only test. Also see
>> 15% decrease on frontend cache stall.
> tl;dr
> Comparing GPR approach [1] with this series gives 8 improvements and 3 regressions.
>
> Fastpath is a Linux kernel performance benchmarking service. The table
> compares the both patched kernels: positive values are faster, negative
> values are slower, and (I)/(R) indicate statistically significant
> improvements/regressions. Unmarked differences are not significant after
> accounting for confidence and noise thresholds.
>
> +---------------------------------+--------------------+-----------------+-----------------------+
> | Benchmark                       | percpu-pgtable [2] |   gpr-fixup [3] |         gpr-fixup [3] |
> |                                 |    vs baseline [1] | vs baseline [1] | vs percpu-pgtable [2] |
> +=================================+====================+=================+=======================+
> | lmbench/lat-mem-rd              |             -0.26% |       (I) 1.24% |             (I) 1.50% |
> | micromm/fork                    |          (I) 1.10% |       (I) 2.46% |             (I) 1.35% |
> | micromm/munmap                  |         (I) 18.10% |      (I) 19.78% |             (I) 1.43% |
> | micromm/vmalloc                 |         (I) 11.92% |      (I) 14.68% |             (I) 2.47% |
> | mmtests/hackbench               |              0.27% |       (I) 1.09% |                 0.81% |
> | mmtests/kernbench               |          (I) 1.19% |       (I) 1.18% |                -0.01% |
> | mmtests/sysbench-cpu            |              0.01% |           0.06% |                 0.05% |
> | mmtests/sysbench-mutex          |             -0.85% |          -0.14% |                 0.72% |
> | mmtests/sysbench-thread         |         (R) -4.49% |       (I) 3.02% |             (I) 7.86% |
> | perf/futex                      |              0.55% |      (R) -2.80% |            (R) -3.34% |
> | perf/sched                      |          (I) 1.61% |          -0.39% |            (R) -1.97% |
> | perf/syscall                    |          (I) 1.54% |           0.98% |                -0.55% |
> | pts/memtier-benchmark           |          (I) 2.37% |       (I) 2.51% |                 0.14% |
> | pts/nginx                       |              0.42% |           0.96% |                 0.54% |
> | pts/perl-benchmark              |          (I) 1.83% |       (I) 1.63% |                -0.20% |
> | pts/pgbench                     |             -0.09% |           0.55% |                 0.65% |
> | pts/pybench                     |             -0.05% |          -0.07% |                -0.02% |
> | pts/redis                       |             -0.00% |          -0.04% |                -0.04% |
> | pts/sqlite-speedtest            |              0.15% |           0.44% |                 0.28% |
> | repro-collection/mysql-workload |              0.73% |           0.25% |                -0.48% |
> | schbench/thread-contention      |              0.42% |       (I) 1.04% |                 0.61% |
> | sockperf/echo-lat-tcp           |          (I) 2.88% |       (I) 1.69% |            (R) -1.16% |
> | sockperf/echo-lat-udp           |          (I) 3.93% |       (I) 5.11% |             (I) 1.14% |
> | sockperf/packet-tp-tcp          |             -0.41% |       (I) 1.37% |             (I) 1.79% |
> | sockperf/packet-tp-udp          |          (I) 1.45% |       (I) 1.49% |                 0.04% |
> | specjbb/composite               |          (I) 1.39% |       (I) 1.65% |                 0.26% |
> | speedometer/v2.0                |         (R) -1.04% |      (R) -1.04% |                 0.00% |
> | speedometer/v2.1                |             -0.10% |           0.10% |                 0.20% |
> | syscall/getpid                  |             -0.98% |           0.52% |             (I) 1.51% |
> | syscall/getppid                 |             -0.43% |           0.14% |                 0.57% |
> | syscall/invalid                 |          (I) 3.06% |       (I) 3.56% |                 0.48% |
> +---------------------------------+--------------------+-----------------+-----------------------+
>
> [1] v7.2
> [2] v7.2-percpu-pgtable (this series)
> [3] v7.2-percpu-gpr [1] (Based on email review, we fixed SDEI to restore x26
>      instead of corrupting x22, and adjusted this_cpu_write() helpers to
>      avoid GCC overflow warnings.)
>
> The constraints/workarounds for the per-CPU page-table series were supplied as
> this Kconfig fragment for all the different runs.
>
> CONFIG_EXPERT=y
> CONFIG_ARM64_4K_PAGES=y
> CONFIG_ARM64_VA_BITS_48=y
> CONFIG_ARM64_VA_BITS_39=n
> CONFIG_ARM64_VA_BITS_52=n
> CONFIG_ARM64_PA_BITS_48=y
> CONFIG_ARM64_PA_BITS_52=n
> CONFIG_UNMAP_KERNEL_AT_EL0=n
> CONFIG_ARM64_SW_TTBR0_PAN=n
> CONFIG_KASAN=n
>
> [1]https://lore.kernel.org/all/20260804170503.3513916-19-mark.rutland@arm.com/

Hi Usama,

Thank you for running the benchmarks. I'm done some benchmarks and 
wrapped up the results too. I did run some same benchmarks as yours, 
like perf bench and kernel build. I also did some profiling for some 
benchmarks and did some investigation about where the performance 
difference came from. This is why the work took longer than I expected 
in the first place.


Test Environment
===========
Hardware
--------
1P AmpereOne machine with 192 cores, 512GB memory.

Kernel
------
v7.2 based.
I applied the first 6 patches from Mark's v2 series, which are some 
common micro optimization IIRC, on top of my percpu page table series. 
I'm not sure whether they can make measurable difference or not, but I 
think I'd better do it because we were benchmarking some subtle 
difference (4 instructions difference in some hot path) so we can have 
some apple to apple comparison.

4K page size + 48 VA bits.

Result Analysis
-------------
I use ministat (https://github.com/leahneukirchen/ministat), which is a 
small tool to do the statistics legwork on benchmarks, to process the 
benchmark results. It should help us rule out the misleading noises.

The ministat output looks like:
     N           Min           Max        Median           Avg Stddev
x   10         46998         48366         48192     47986.333  499.14714
+   10         48438         49333         49030     48952.333  304.42711
Difference at 95.0% confidence
     966 +/- 531.791
     2.01307% +/- 1.10821%
     (Student's t, pooled s = 413.415)

I use the percpu page table series as baseline, which is shown as "x" 
row in ministat output. The "+" row is Mark's series. The column "N" 
means the number of samples (basically equals to the number of run 
iterations). Other columns are quite self-explained. But I will just 
show the percentage reported by ministat in this email.


Benchmarks
========
I have done some different benchmarks which cover from macro to micro 
benchmarks and different type of applications (kernel build, Java, 
database, networking, etc). They are:
   - Kernel text size (just compare the kernel text size for the two 
kernels)
   - Kernel build
   - Specjbb
   - MySQL (sysbench)
   - Memcached (via Mellanox NIC)
   - iperf (localhost)
   - perf bench
   - will-it-scale (page fault and mmap)

Because we are benchmarking some subtle code difference, so all the 
benchmarks were run multiple times (the number of iterations depend on 
benchmarks duration and variance) and a couple of reboots in order to 
rule out reboot by reboot spread (I did see some significant reboot by 
reboot spread for some test cases). I also bind the tests to some 
specific CPUs if they don't use all CPUs in order to minimize the 
core-to-core latency variance and scheduler interference.

Basically I didn't see measurable difference for the most benchmarks 
listed above (ministat showed no difference), I think this aligned with 
your results too. But some benchmarks showed regressions for Mark's 
series. Please see the below for the details (just the regressed 
benchmarks).

Kernel text size
-------------
With the same kernel configuration (the default Fedora config), the 
kernel text size for the percpu page table series is 92K smaller than 
Mark's series. This is kind of expected because all this_cpu ops are 
basically inlined and are called quite frequently, so even small 
difference could make big impact.


Kernel build
----------
Ran kernel build with "make -j192" in a memcg with cold page cache. 
"Drop cache" is called for each run before building kernel.

I did 5 runs. The percpu page table series has roughly 2% better sys 
time (the smaller the better).
Difference at 95.0% confidence
     966 +/- 531.791
     2.01307% +/- 1.10821%
     (Student's t, pooled s = 413.415)

And slightly better wall time.
Difference at 95.0% confidence
     2.2 +/- 1.92934
     0.553877% +/- 0.485735%
     (Student's t, pooled s = 1.32288)


perf sched pipe
-------------
Bind two threads to CPU 78 and 79 (randomly picked) in order to avoid 
core-2-core latency variance and some scheduler overhead. I did 200 
runs. The percpu page table series is better. I didn't see measurable 
difference with process mode.

Throughput (The bigger the better)
Difference at 95.0% confidence
     -24549.2 +/- 4900.32
     -9.73769% +/- 1.78314%
     (Student's t, pooled s = 25001.6)

Latency (The smaller the better)
Difference at 95.0% confidence
     0.377888 +/- 0.0753446
     9.37686% +/- 2.01494%
     (Student's t, pooled s = 0.384411)


perf futex wake-parallel (wake up one thread from 192 waiters)
------------------------------------------------------
The result shows the wake up latency. I did 1000 runs. It is the smaller 
the better.
Difference at 95.0% confidence
     0.0009767 +/- 0.000134466
     17.0749% +/- 2.53593%
     (Student's t, pooled s = 0.00153406)

The histograms showed obvious long tail latency from Mark's series for 
both perf bench pipe and perf futex wake-parallel.

I also did some profiling for the above two benchmarks. The profiling 
showed the percpu page table series has lower overhead in schedule(). I 
got the profiling with pseudo NMI which has extra overhead, it may 
distort the profiling a little bit. The profiling showed 
finish_task_switch() as the hot spot. But it actually doesn't do too 
many things other than enabling IRQ. This is a typical misleading 
profiling due to not supported NMI on ARM64. But anyway both profiling 
results (w/ pseudo NMI and w/o it) show the overhead is in schedule().


perf bench fork
-------------
The result is the smaller the better. I did 20 runs. And the profiling 
showed the percpu page table series spent less time in 
__percpu_add_case_64().
Difference at 95.0% confidence
     48.5027 +/- 4.16055
     1.93944% +/- 0.167849%
     (Student's t, pooled s = 6.50039)


will-it-scale/page fault
--------------------
All the page fault micro benchmarks from will-it-scale were run with one 
single thread and bound to the same CPU in order to minimize the 
overhead from page allocator and all the VM locks (for example, lru 
lock, zone lock, etc). I did 100 runs for each test case. The result is 
the bigger the better.

page_fault1 (Anon page fault)
-------------------------
The percpu page table series is slightly better.
Difference at 95.0% confidence
     -13391.9 +/- 944.563
     -1.67893% +/- 0.117849%
     (Student's t, pooled s = 3407.69)

page fault2 (CoW page fault)
------------------------
The percpu page table series is slightly better.
Difference at 95.0% confidence
     -4736.52 +/- 438.185
     -1.16333% +/- 0.10686%
     (Student's t, pooled s = 1580.83)

page fault3 (tmpfs page fault)
-------------------------
The percpu page table series is slightly better.
Difference at 95.0% confidence
     -21667.9 +/- 1352.51
     -1.91305% +/- 0.1186%
     (Student's t, pooled s = 4879.44)

The profiling for all the page fault benchmarks showed the percpu page 
table series spent less time in __percpu_add_case_64().


will-it-scale/mmap
----------------
Like page fault tests, the mmap benchmarks were run with one single 
thread and bound to the same CPU in order to minimize the overhead from 
VM locks. I did 50 runs for each. The results are the bigger the better.

mmap1
------
The percpu page table series is better.
Difference at 95.0% confidence
     -15916.4 +/- 6094.58
     -3.53615% +/- 1.32214%
     (Student's t, pooled s = 15509.2)

mmap2
------
The percpu page table series is better.
Difference at 95.0% confidence
     -14662.4 +/- 9359.95
     -3.91005% +/- 2.44462%
     (Student's t, pooled s = 23588.6)


Thanks,
Yang

>> Regression test
>> ===============
>> 1. memcg creation
>> -----------------
>> Create 10K memcgs. Each memcg creation needs to allocate multiple percpu
>> variables, for example, percpu refcnt, rstat and objcg percpu refcnt.
>>
>> Consumed 2112K more virtual memory for percpu “local mapping” and a few
>> more mega bytes consumed by per cpu page tables.
>> No noticeable regression was found for elapsed time.
>>
>> 2. fork test
>> ------------
>> stress-ng --fork 160 --fork-ops 10000000
>> fork() needs to allocate multiple percpu variables, for example, rss
>> counters and mm_cid_cpu.
>>
>> Roughly 1% regression was found. However stress-ng fork test has quites
>> small address space, the real life workloads typically have much larger
>> address space and do more complicated works. The stress-ng mmapfork
>> benchmark saw 15% improvement.
>>
>>
>> The organization of patches
>> ===========================
>> The refactor and prepatory patches (patch 1 - patch 4)
>> Percpu page table support patches (patch 5 - patch 8)
>> Local percpu area support patches (patch 7 - patch 15)
>> Use local percpu area for this_cpu ops (patch 16)
>>
>>
>> Yang Shi (16):
>>        drivers: arch_numa: move percpu set up code to arch
>>        arm64: kconfig: make percpu related configs not depend on NUMA
>>        mm: pgalloc: introduce {pud|pmd}_populate_sync()
>>        vmalloc: pass in pgd pointer for vmap{__vunmap}_range_noflush()
>>        arm64: mm: enable percpu kernel page table
>>        arm64: mm: defined {pud|pmd}_populate_sync()
>>        arm64: mm: sync percpu page table for memory hotplug/unplug
>>        arm64: kasan: sync up kasan shadow area page table
>>        arm64: mm: define percpu virtual space area
>>        mm: percpu: prepare to use dedicated percpu area
>>        arm64: mm: map local percpu first chunk
>>        mm: percpu: set up first chunk and reserve chunk
>>        arm64: mm: introduce __per_cpu_local_off
>>        mm: percpu: allocate and free local percpu vm area
>>        arm64: kconfig: select HAVE_LOCAL_PER_CPU_MAP
>>        arm64: percpu: use local percpu for this_cpu_*() APIs
>>
>>   arch/arm64/Kconfig                   |  12 +++++++---
>>   arch/arm64/include/asm/mmu.h         |   5 ++++
>>   arch/arm64/include/asm/mmu_context.h |   9 +++++++-
>>   arch/arm64/include/asm/percpu.h      |  37 ++++++++++++++++++++++++++++-
>>   arch/arm64/include/asm/pgalloc.h     |  24 +++++++++++++++++++
>>   arch/arm64/include/asm/pgtable.h     |  37 ++++++++++++++++++++++++++---
>>   arch/arm64/kernel/setup.c            |   3 +++
>>   arch/arm64/kernel/smp.c              |  44 +++++++++++++++++++++++++++++++++++
>>   arch/arm64/mm/kasan_init.c           |  47 +++++++++++++++++++++++--------------
>>   arch/arm64/mm/mmu.c                  | 165 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------
>>   arch/arm64/mm/ptdump.c               |   4 ++++
>>   arch/riscv/kernel/smp.c              |  51 ++++++++++++++++++++++++++++++++++++++++
>>   drivers/base/arch_numa.c             |  51 +---------------------------------------
>>   include/linux/mm.h                   |  11 +++++++++
>>   include/linux/percpu.h               |   4 +++-
>>   include/linux/pgalloc.h              |  13 +++++++++++
>>   include/linux/vmalloc.h              |   3 +++
>>   mm/Kconfig                           |   9 ++++++++
>>   mm/internal.h                        |   5 +++-
>>   mm/kmsan/hooks.c                     |  14 +++++------
>>   mm/percpu-internal.h                 |  14 +++++++++++
>>   mm/percpu-vm.c                       |  94 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   mm/percpu.c                          |  58 +++++++++++++++++++++++++++++++++++++---------
>>   mm/sparse-vmemmap.c                  |   4 ++--
>>   mm/vmalloc.c                         | 138 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------
>>   25 files changed, 712 insertions(+), 144 deletions(-)
>>
>>
>> Thanks,
>> Yang
>>
>>


