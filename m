Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A86ECD37AC
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 00:00:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 386626B0005; Wed, 13 May 2026 20:00:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 336476B0088; Wed, 13 May 2026 20:00:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 225196B008A; Wed, 13 May 2026 20:00:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 121746B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 20:00:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9F4441C0238
	for <linux-mm@kvack.org>; Thu, 14 May 2026 00:00:34 +0000 (UTC)
X-FDA: 84764068788.20.0B455FD
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11021092.outbound.protection.outlook.com [40.93.194.92])
	by imf03.hostedemail.com (Postfix) with ESMTP id B186520005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 00:00:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=nHOQHXLJ;
	spf=pass (imf03.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.93.194.92 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778716831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pfUzpW1GP/hAvsD5k+96AYtutrAIiHbxcqD0wWYTN4g=;
	b=j365bjopC1DSn1Vl/Jxny7GwPOr4KjU2G14H+JHImmclbmYnhyaxRNR6neRZ+nYfWy7VI/
	gUsg9M5gNtQTw3k3FAaWlV4yND/vmJFGTVStY5tmp1VnJ7L30WqMSCSka3aP6GCR2mgXUa
	mUoPe7vImDgGippYHDmZviJNkQdip1A=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=nHOQHXLJ;
	spf=pass (imf03.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.93.194.92 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778716831; a=rsa-sha256;
	cv=pass;
	b=n5ckycd6Imh5ZIsC4mytMJ+kY2chVzJT8lxv28EUeTOyAySDd/1yvT9Kumm4tYG5o/P+hk
	YBYNRM4Jh8IDtwtrKU7Xx5jWODDAiQeFVruq96AGWWMCJGHBthkGxv1pXiBqq5Qfn/J/p4
	KsIsfk7/iSIMIUhbGt1ftM0WbqyIolA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b00lBpIZRFqY/wu4eXtVdQlLYxPhzO37LVJ4RsNtTWLmEM7MxrB9hU2MPYroFaZK57OCpEnvNSOec6E3rQ/3cVdAxcjxp9eqvSMnyk2ThZ0NmvVwEp7EcPG5ecdHV9AzJsT49CLgY3JAs94QZHVWIpIFgheqxdnMiGMnbkJlN4RO6M82Tp6k6eYrlJMSrapsQuloY86EFP6o/h4uCOalGTC5i5J4igJ30YaDGf6EXSsx5b+kE4mkjaacTLx6Ot4vqZMSQELGsaMhRevK3lVA0+JDMaQvyoUJu88USkLYD3ZwjuDUA1QR4u1jlvlpgt7f+J8NHNkG1lUT6PD290nkqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pfUzpW1GP/hAvsD5k+96AYtutrAIiHbxcqD0wWYTN4g=;
 b=JLGhV2wKW1PaLI9T45iOomymIgo8j8DWUr6XkFtmj9lhWfQFcQFkSjU8eZ714mXre1vtVL8bSEDCG3MxCJYMvVfb5cwKS5cLsepnfaio54feQxY5N/eouzgnf++BbDOTBhFyrIos46mNBF7RxGYRELDjztgZM8zjguhXOqMcsRsSPDcAv7vRSIcqnC6kCckNTuGlJ62oW8qLdDBmZEh6HNytI6NmA5lTGxZVXbrW/ocFTp2+lPGXWTQ3Jwk+bXJmXUJs52fKdYOMOvFrHwYvpc/3hIQpRUzGe900a/tvtjC7VmMt7LdCHen7p85GNZv6JMYrRLUclffGnUBiWQDlpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pfUzpW1GP/hAvsD5k+96AYtutrAIiHbxcqD0wWYTN4g=;
 b=nHOQHXLJu5dOUiUfZcTwUiTwgtT45Xj/qCKOgbK9adLKxfGdQnqb43G0K3AHhC1ASTpaEf4hII3IyJ1yfOZBBI6MBt0hNU9ZekcoXnGHCveVfPxDii22qrWdHs4gXPd7ovA6EXDuYNSXxubGWRLdUy4wbnK+yrpAKu8u0hC3qYE=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 BN0PR01MB7071.prod.exchangelabs.com (2603:10b6:408:164::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.15; Thu, 14 May 2026 00:00:24 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0%3]) with mapi id 15.21.0025.012; Thu, 14 May 2026
 00:00:23 +0000
Message-ID: <583d5984-fc21-4204-9845-8ceabacf823f@os.amperecomputing.com>
Date: Wed, 13 May 2026 17:00:19 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1 PATCH 0/11] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
To: "David Hildenbrand (Arm)" <david@kernel.org>, cl@gentwo.org,
 dennis@kernel.org, tj@kernel.org, urezki@gmail.com, catalin.marinas@arm.com,
 will@kernel.org, ryan.roberts@arm.com, akpm@linux-foundation.org,
 hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <20260429170758.3018959-1-yang@os.amperecomputing.com>
 <d16893b5-3a21-4595-b4ce-e34a7e8a199c@kernel.org>
Content-Language: en-US
From: Yang Shi <yang@os.amperecomputing.com>
In-Reply-To: <d16893b5-3a21-4595-b4ce-e34a7e8a199c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0141.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::26) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|BN0PR01MB7071:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d22237d-d12f-4ed0-273e-08deb14bcb95
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|55112099003|4143699003|921020|18002099003|56012099003|22082099003|11063799003|3023799003;
X-Microsoft-Antispam-Message-Info:
	ql/Pg59d/hPASq49yzW2sHKeDqqfq/A4E8cCXwtTpbo/UOUCYcZ93ebzgrfp3XWS0CHC1QOtump5tgKBwhgegfv9E+5VXdNcXYjVFiPoizL/8mVlxt3Z5DXZ8P98vDCFFZBYVv7RYVCIVxbZ87xLsBRyrPyneYFKqfHhqSSYvfaYUxeul8WRtRukZS8ec5HIB1dcHqecE+VbAjqlpaT+zAEHYdCJJTwHFyMJ56Rojg/nGfnSaVj5pM4XTezpMQRJlqcJFagOpVLXTom7KlmKXNNIp/vFaKRyd9k0VYXSsPdhnNv8sm3pRDX3/GFmgupPrV54BG5VSv/uYhpD3V+RJZlLmGbgUHExLmCMczaphACc9FnYvChEHj5PkhdyJe18SQRxdBZC0Fifm4r2IctKy15jmUI8Auiv9lQqxi8QTCr3s0WlyysIQnp8ukqaaMKrmSLhjltZWb6iq3K0EQf4qifB+Xar7S9ctll4TFDH5O9wfyA4cXf1qM+qthEvsFj/TtI4+jcEUuNTWyN2B3e9+ceEsJKPW+CLpIew9e7o8sssohgM2XC9Rh0hZconm7EaqOaWhjZMGXHIy8qMBQtiK0KDPePOEKvz33IjlQVBxpDTxFSMd6Mi5ZdDju7s4DI7zlE6LijFRGfsFlkq7mIDdTtyFgfT97BmqBK3BCE2FyrH61FQ7mwBLdGIs+QVg9nnhsaW743590Sg+dF8TMRKoU6gg1fH1ww1E1GKs3zFZSA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(55112099003)(4143699003)(921020)(18002099003)(56012099003)(22082099003)(11063799003)(3023799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TEgvUVBrWkY0UXZDUkFVY0Y5NkdYSlB4dUQvSVJrUDZWUUZkRWsvSjJJSzhL?=
 =?utf-8?B?am9sNzRkUnAvejRPZ0dURjROUGlXeDVwTHR2ZnY0NEJKN2s0bmI0cm9DdWpy?=
 =?utf-8?B?cmRVb1E0YnVnM2ZzaHR4YlRRMmt3a3ovMExjWnlIVDJJb3pBV1kvb0trNGdh?=
 =?utf-8?B?c2hwaHJoNDkva2hwSzdQc0pCdzFiblFKVS81VE9vNnFCcmYxcU1rVmhFWDlv?=
 =?utf-8?B?TTFHQVpoTnNpSDNxTTBQTTAvT3NtcWdXU29maXJsZ2xiMDlNUnJncTNBWjVY?=
 =?utf-8?B?L3prWEhpNHJxWlFtcGd4VzNvQ0ZFOE1JS3IvMjYrL2FJZ0pFRmVManJBWW1R?=
 =?utf-8?B?U1NsNmdlNXFIekdFZDZER3dXUFc1WXM0Wm43a0NGOXVxM3dLdTJ3SFZRdlhr?=
 =?utf-8?B?N3lVb2RTQVUxR0ZybWsxam1PZ3RJMzI0TkVUU2xHV0pDRHY5Rm9QeXIvdjRj?=
 =?utf-8?B?QkdVeEZlQVRQbHQxd1p2Zm8rU2N6MS9kODJQRWVldWlRam1qOTZ2Vkg5aHBq?=
 =?utf-8?B?UWQrOTdybFlVL08xdUVuSk5Rd3h2aUQxY2hzR3V6ZEduNnY0WENhcWRxTEVJ?=
 =?utf-8?B?eCtzRTdyT2NoTU83V3FDYUZkOGVqMnp6VFZPYytMei9ZWHJNNzY4VnN6L3ZW?=
 =?utf-8?B?RjdWT2VZOGFPdyt4eEF1VzcyL0RvRXpSSEhCcWFaeUhlOXVVa05icDc1Z01V?=
 =?utf-8?B?ZkkvV2RMNnJwNm92TTZPUzhLdUpQcHRQbmVhK202ejcvYm5Ic08xc1BMa0l5?=
 =?utf-8?B?ZExPaTY5SnJ5YXY0T0w0dHVEaWI0ajFVRitXd2x1dFR1aURPcHZiWFpNbG9N?=
 =?utf-8?B?S0VQT3d5QmM2dmNuR2w1d2JielBOYmFiTHEvZk5tdVNLL1hDMFQxR3NvWEVh?=
 =?utf-8?B?TllrTTdWL2R1NDI5UStyQ0VLLzBtcW5MQ1VrdmtSSXZZNTZnc3h1YlNMMnI0?=
 =?utf-8?B?d1FJYlplN1YwWU94U21OTEhJM1p6OVhUR0lZNXJBOEt2VG04N2k3aDcwYmpt?=
 =?utf-8?B?MUdxT210STJCTG5yaEZjOWhHZ1BsRHQvR0ZPUEpIdW9POWZVTEIzNEdRRW0z?=
 =?utf-8?B?dG1JZW9xU2dzazBWYjBPeGJsZm9uRTlEWEE4QjY5dEZIM01iSTNXLzNFOGRB?=
 =?utf-8?B?bERUWFZEV1YvUTRPUVd6MktrVS9Pak8weDZHcENPVVNpUXQ5bW1SYTVET1Rq?=
 =?utf-8?B?UnZsSHBDTnNXOWwzMGsvYXR0RXhEMnFHbHdlL043bkpEeU5ZT1FhZHZpNnlG?=
 =?utf-8?B?TW82Q29TK2syWFBIallHNGt4UW8zY0trejFqMGk0a01YRDZiUUtjcjNya3ZS?=
 =?utf-8?B?SFJoeXhBMWpLZzBRSUEyTVdyaFZDdmlFTXQ1K1U3ZDZFNEp0RHZxbTVzWEEv?=
 =?utf-8?B?dnUzVUhBTS9Pd0grcENMQUg0cmdYYWhPU0lGS2V6R1Z2TVBqNEVHSXdzaU9z?=
 =?utf-8?B?ZlR6czFrb1JBU0tJaDlQNjVCb3VJU2JUdWVLdytEc3ZvUTZ5KzJTdUxqQTRp?=
 =?utf-8?B?QUVlcFhoK2RDcEtNLzMwWWdsTmErS1N6bXFKNm9kb1FZcXlycWE0YzA2V016?=
 =?utf-8?B?WU1CVnNMZmxxR0hoaDVEdmVrSGJnTlYxSFBqc0ltcDExRWpuM2RZcW9uaDNC?=
 =?utf-8?B?czkxUEN0VnJ5M1FJZnBVYTdHcnNvMU9YdVdWVGpMVExodGNOT2dWa0xxbVZq?=
 =?utf-8?B?RFVqVGlTY1oxL3VhUkE0ZUdZZHhQVzhFVXJRWXhsR0dzN2ZWK1ZvN3B1MW90?=
 =?utf-8?B?NU5lK3h4eDc5TmQzRGZHU01TajliZzUxZzZyY0FSMkNwblU2aEo0RjdTNk5k?=
 =?utf-8?B?OGdDUGNhYzF3K0N0cE5Gd0lVa05zdlM0cncvdSswMmhWemlDVHZILzVTK251?=
 =?utf-8?B?WkxmZXptMHc2L25vdFhXb2I0V2h6T2tkbTNqWHRLUjFGQjh6RWc4VS9EZVo3?=
 =?utf-8?B?TGhsVzUxc3hJSUtSUVVqZnNXTmxyOHIwOVJ0QnA5eXlRNHZ2MTNsVUUyZ1M4?=
 =?utf-8?B?dFhHRW9ia0NpYXVKVWhlcXYrUTNrNFowcXBYZlVPRVJ0aUM1WGdHcmNWT2I4?=
 =?utf-8?B?eEVEdFdFRkkycFRtcm9DTFVWUXp0N2dZcm5uc0dlUjVBb3Nqci9VR0ZqRkd5?=
 =?utf-8?B?UVJ3aWhUYjZ6eUNCTmwzdG5CQzZtazM2QXdjR29EMW4vM0R3dnkza1owUWg0?=
 =?utf-8?B?NnJaS1JhM3czSVhsZWtJdWc4M1VRN0p6UXRxaHFmT2tsNktnNm5WU0hreVMy?=
 =?utf-8?B?OWZEWGhSdTFZQ042R1dyb1RLYUs0bzRRb0syaDA2c091Y3p4Vnk3SFFhR09k?=
 =?utf-8?B?YzIrZytodVcrK09uYUtpSlNPU3BXSUlIRjIzSXVFQ2Y3ZGxRNFlFYUhpMGxk?=
 =?utf-8?Q?NPw74EU+ODOUY5TA=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d22237d-d12f-4ed0-273e-08deb14bcb95
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2026 00:00:23.6924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zp86EOfacb3qIsqNu7g63FvbEUJeOl3Ec4pNPgYFKJBQX3qKXJ12c08LiUI1sAcmHW2IcNWcESv4oYtIi5z8fMp921OhLLzPEHbZZOTjOJo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR01MB7071
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B186520005
X-Stat-Signature: 7ruzbgfaidno5xer1f389j5t8ypsxdir
X-HE-Tag: 1778716831-378707
X-HE-Meta: U2FsdGVkX19xKed2huw0vak0UuY9235escdcHehoXX8tegfxJxRjI3pBe7F2/5OS/0kvwiTcNFYxwcXiib3XqWFc+qWd9sYUpHOdZScnol7ER2L0oBT0bbWBUPJmbDe4GaCk43vj2vyA+4bE2kPHGJ+W12xVmOzYXVAICVKaGMTXSQKmS8MxlG9VVhOPvhtoAO1v/86aQ3GbTzmTphbft0ISYO+jTe1UA7ye0GB0rEeW1J26qR1rLUsLTdnm0cBda16aD2zo2BWCxR2xIxXWkEyGY5GK8Zi5Q19dpb5v2y1eLXKH+Av3025X7IBuN+u64Yc1ICl6QCWjTve9F7htaGqq9iNe2TzZurx9DFCMHGd+B6SyL4NDrt6t4okyocw0bPciY9SBG6y+TpVvKWw4WJzav5Byw+UZgczE41G1fMLvwbeLPXniTSRV9Gebxeb/KIq7dcnwGazBcbTUbrf65YsOYgscpGCmCpfVWUPAiqzrvXd6iTg/zjLZaUgGY1V1wyaD8lDd2iXbeJ4Alc0PNrIaJ4ENmDV66BIwD25W1eF7LmYt4dxOy9JBqTs/Y1YLExvWVhNpGTY9qK8MUYa3GrdyZ6niUIJfx9CJ4E5AR2zwCqng1FuTzLah9stuCe2t2ce5/DJgdWYxBfJQvOShykvawLNmVZsZh7iaHs3nnU1Nw1MjxQ9tD4AmrHFCu4rVb/llHL5wwFHsoE1xdgZqKP0cJ8BcAb74FFPOqb4djwBlxTXeRQ347lHUwVxDq6AI9HchOVN4L8Xd2mZisjEAKC+3XXOxMrnwTc6SM3cmNbWl4/A7ojoTPd1zdF+hfTp8d0PAfMoRMqByd+fimzwI48lNZCq9eItKBSn3EzWYgzudBSxuLeOYbYCkjwvMf17xxPWBL9tle8rk3KcgoMFIRjqyukPhcrEyUaF0stqO+JCSJ7yv1jbK3/Cn8oFU9wCRHPzYRoLHT/nxfYfeXlC
 7PY+Wre5
 8RKfRQ8D/C5wtlN4AsqaeDtN2Z6R9oXpBZmEDoEpCmYl9dNevu3sWm6iinwJVTn5M/3UgDh7mqQpqYQ8EAz8iJ2S27NNzJLMYF7tJ5LzhC5uLPD4gmXza7B2/wIONBpLWJpxWEj5yMjs7Gw+voaDRa1C3KPMWhP+yWoky6XJOEZvyNAVDEQ8Uv0IccfAeeZLwuH3l2dLyKlG0g86swlSFcQ96heC7TZBzSK5t/9iZKLjbAerMTKq2EAiCSE1+ZTse8sckMoHWlFsw7/f5FFAE4zak3e+H+eoCXh551ur2JEpCoXrT5qN9ynpeUB9mtfegfT6eK78+qyJ6jBc0aSWZRKsaQKX1nHinkla+VYaWM83rzmdQnpWtdYlcTpbR9ux9pIEQcKpKY+VngznQIqoRHnlQZV2iEe7zHsxN3gQbQWY66QpB/6o7TWsOfYBWEtofKFLr2O+MWFrNufFR1UqlquB2TlwPPflNRozYKHne7rmxd+9yTQW3BbAC9CEmaRluafx1PqpLn5/KxTWRO+FvBMH5U636QyYsWHBj+1Ij1m50Mq4n7LbAhKKQ9G3+GDYJEcH8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/12/26 2:02 AM, David Hildenbrand (Arm) wrote:
>> =========
>> The benchmarks are done on 160 core AmpereOne machine. The baseline is
>> v7.1-rc1 kernel.
>>
>> 1. Kernel Build
>> ---------------
>> Run kernel build (make -j160) with the default Fedora kernel config in a
>> memcg.
>> 13% - 18% sys time improvment
>> 3% - 7% wall time improvement
> This is pretty impressive!

Thank you.

>
> There was quite some feedback during the LSF/MM session, what's the current plan?

We didn't talk about the plan in the LSFMM session due to time ran out. 
I had some hallway conversation with Ryan. He said he will try to 
replicate the performance benchmarks on some other ARM64 machines.

He raised the concern about CNP (Common not Private), but neither I nor 
he can find machines with shared TLB. We do need some help to run the 
patchset on those machines because disabling CNP may have some 
performance implication.

I plan to polish up the patchset. There are still a lot work to do to 
make it in a better shape. Sounds likes a plan?

I'm not sure whether S390 folks will implement this on S390 or not, 
anyway they are cc'ed.

>
> Also, it was raised that Linus so far didn't enjoy per-process page tables. Is
> there a way forward?

Yeah, it was discussed. My point is it makes some sense for x86 to not 
have per cpu page table because userspace and kernel share the same page 
table on x86, so the number of kernel page tables is actually unbounded. 
But ARM64 is different. The hardware supports separate userspace and 
kernel page tables, so the number of kernel page tables is actually 
bounded by the number of CPUs. And my regression tests didn't show 
noticeable regression for setting up percpu local mapping for 160 cores 
(means 160 kernel page tables).

So we should maximize the hardware benefit IMHO. And it should be up to 
the architecture maintainers.

>
>
> Finally, in the LSF/MM session, there was the question why the preemption
> handling is even required. Can you describe what the problem is?

Someone questioned why not just remove preempt_disable/enable because we 
just care about the sum of the counters. It may be ok for some cases, 
for example, some simple statistics, but it may cause problems for a lot 
usecases, for example:
     - __this_cpu_*() ops don't use atomic instructions. If they happen 
to access the same counter with this_cpu_*() concurrently, the counter 
may be corrupted.
     - this_cpu_write() may write a value or pointer, it may corrupt the 
remote CPU's copy.
     - The percpu counter may call into slow path to flush the per cpu 
counters to a global counter if some threshold is reached, the imprecise 
per cpu counter may result in suboptimal behavior, for example, calling 
in slow path more than necessary.
     - Cause the statistics out of sync or larger deviation than 
expected because the counter flush is not done due to comparing the 
threshold with wrong value.
     - AFAIK, scheduler may use percpu counter for some percpu lock, the 
imprecise counter may cause lockup and misbehavior.
     - And some subsystems maintain percpu state, then make decision 
based on the percpu state. The corrupted percpu state may cause various 
problems.
     - this_cpu_cmpxchg() may compare the remote CPU's value and result 
in indefinite loop.

There are a lot other cases that I may be not aware of because percpu is 
widely used by various subsystems. Anyway the spec is this_cpu_*() ops 
just can access local CPU copy. Accessing remote CPU's data is 
definitely not expected and may cause various problems.

Thanks,
Yang

>


