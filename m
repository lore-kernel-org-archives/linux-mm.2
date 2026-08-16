Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 185B0C5DF66
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 11:51:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 058F66B034D; Sun, 16 Aug 2026 07:51:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02F596B034F; Sun, 16 Aug 2026 07:51:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5F9A6B0350; Sun, 16 Aug 2026 07:51:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC7F66B034D
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 07:51:29 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5802C14051E
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 11:51:29 +0000 (UTC)
X-FDA: 85106967498.21.1B2FEC6
Received: from TY3P286CU002.outbound.protection.outlook.com (mail-japaneastazolkn19010017.outbound.protection.outlook.com [52.103.43.17])
	by imf24.hostedemail.com (Postfix) with ESMTP id F35E318000A
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 11:51:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=OUTLOOK.KR header.s=selector1 header.b=KG7TjLDI;
	spf=pass (imf24.hostedemail.com: domain of seohyun.kim@outlook.kr designates 52.103.43.17 as permitted sender) smtp.mailfrom=seohyun.kim@outlook.kr;
	dmarc=pass (policy=none) header.from=outlook.kr;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786881086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rccgmomi7SLRV5soGKIKjcidoapo+D5SoP3AjJQvzNE=;
	b=yQzjByzKWxqO6E/L/YWqrEyOzNRbSIMTCnns3GoJ1/n9PRUORsVO7sEPrjtiW1mxeyWbAm
	8GvFK+8E2jxLG9sELfSX3WW+UMikWGOUcD1lB7vEV/xOGXjacXL/Y5q+EzOrmluq+3FuS3
	/LQSf77HFK0caRV1DCU403bJrmhlgAg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786881086;
	b=ea0FwkRlN4r3A0W/WRUqLU5UZUgmqMBGD1UIQFapYuuYJduaOT/9s2WzI4SMsUVOmv6X/K
	oy41uq7AP9oYJUfBAygz3kw57ejRipZeNPkR7/0M1RmeQT0EeiRnBQOMj7vQjTM18mBF18
	e9l6JvdTcEO9/dBe30EkB6gDyF1jJ1w=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=OUTLOOK.KR header.s=selector1 header.b=KG7TjLDI;
	spf=pass (imf24.hostedemail.com: domain of seohyun.kim@outlook.kr designates 52.103.43.17 as permitted sender) smtp.mailfrom=seohyun.kim@outlook.kr;
	dmarc=pass (policy=none) header.from=outlook.kr;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xe8QXT9Boshb48A0TLpyTmfNIqep9FX0Pp2Mc78ekeTOL1jdxEdde4TeGa5NAhzb9DkaoBD/blSEuLplW/yXg0qo/On8+2cac0uMDmwpMsfH42G91VaFrzU5ooVxJaUwJ6wD/koyZnF4Z+36K+pcu1Qoi/TCBD2pjqDJdQs01qV6MhufkzNaPzaeEVYFznngqrfx0oxQ6e9JbOvTLTEWnYxwV3OOdz6GXcj2aXna9PwEWWkETCRmJyEVuL2Af4UtXq6bElCQP1r7mVi6Z+DJIf3+XXQERfx2VaVzhFskDJaoH4lixzQ/Y1diVOpkwijZZikSeVt5Q/m2TZQE0UZ2mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rccgmomi7SLRV5soGKIKjcidoapo+D5SoP3AjJQvzNE=;
 b=vl8YpIO8gqmNMOa6HoifNjTBo42xcCgp51FYA+AzHiDl3BKytfjeujGL6U38NipCUsErN3T9chETCEuEHAoeZHO6bStO8jnZeG5gNDnio3O/1BfgUqiJapTzy6AzeLFQSxltGZF3RHg1p+bXqu0XVeaf3jRI78g6NW8Jz6ZpSfjOua4IDNcAzNk5iqnotG7UduNXbDTWXo5Vm4li05aI8XTA2zPmS1j36g0Zm16EDYXeWhbaj7H0btzmO3JrJ/0S8dpUQRJbdNEd+xxm5U8gblZ3lIwqAvKHen35DsC6JZ0GBMH9cyu+chwNTtXJynmj8SPqEMJLk38+mwkCl5Dt1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=OUTLOOK.KR;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rccgmomi7SLRV5soGKIKjcidoapo+D5SoP3AjJQvzNE=;
 b=KG7TjLDIOZMJuo2tlXPoKT/RjwVeW0iKBmkFvh7uq6oPrzCvd6g0HccEaUMoAjfzbo7xxc2X0wty+KC6jW/pdjfaxyzBpuNSm+cRQdisismER7iMtyFCUFVylFFHQZ4spKdRICmAi3ovshqnsaEt3v/eXQpODd+GQSFdOzPZhgC2eATUis/lN31MCBeUcqMXPui3aXeR/M+tz2kM9/OzlDb5BwfTTk6/e57WUG5AxCHboTyyeLxQ0qDcCfUfgCn6B8cQoSYJuiYnh3hX7JQ0tS+E14qyIMJWsCv2RPRC+1mA/9UX/3No1qku/79uUkWZ9vv4U6n0707wri1mA5MXMg==
Received: from OS7PR01MB13914.jpnprd01.prod.outlook.com
 (2603:1096:604:36b::13) by TYWPR01MB10823.jpnprd01.prod.outlook.com
 (2603:1096:400:2a7::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Sun, 16 Aug
 2026 11:51:17 +0000
Received: from OS7PR01MB13914.jpnprd01.prod.outlook.com
 ([fe80::641e:83cf:743b:85bc]) by OS7PR01MB13914.jpnprd01.prod.outlook.com
 ([fe80::641e:83cf:743b:85bc%5]) with mapi id 15.21.0315.016; Sun, 16 Aug 2026
 11:51:17 +0000
Message-ID:
 <OS7PR01MB13914906DFF1C9AF471A5B46996D82@OS7PR01MB13914.jpnprd01.prod.outlook.com>
Date: Sun, 16 Aug 2026 20:51:15 +0900
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/rmap: synchronize lock and unlock target in
 anon_vma_clone
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 riel@surriel.com, liam@infradead.org, vbabka@kernel.org, harry@kernel.org,
 jannh@google.com, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <OS7PR01MB139142FE16EC63B892559D40496DA2@OS7PR01MB13914.jpnprd01.prod.outlook.com>
 <CAGsJ_4wNPeSYHe_-UZnNRF1i1yWOxdbOiqsuVXVtLU7BDOBbJg@mail.gmail.com>
Content-Language: en-US
From: Seohyun Kim <seohyun.kim@outlook.kr>
In-Reply-To: <CAGsJ_4wNPeSYHe_-UZnNRF1i1yWOxdbOiqsuVXVtLU7BDOBbJg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SE2P216CA0090.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c2::13) To OS7PR01MB13914.jpnprd01.prod.outlook.com
 (2603:1096:604:36b::13)
X-Microsoft-Original-Message-ID:
 <14964d2d-8a44-4b60-add8-21fdc227581e@outlook.kr>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS7PR01MB13914:EE_|TYWPR01MB10823:EE_
X-MS-Office365-Filtering-Correlation-Id: 005a76e0-7b63-49b4-08ea-08defb8cae4a
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|25031999004|23021999003|25010399006|5072599009|6090799003|15080799012|51005399006|24021099003|8060799015|19110799012|440099028|3412199025|40105399003|2607281247196008;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bWFmd3BjQ2JlRHhTeTJYOG0vQUt0a1k5NzFyN0tuemZhOWdPVWhWbThqeExV?=
 =?utf-8?B?eWhCNFp5RldlNGlFaHRJbVM3Mm9ia1AxUHgzdElaaFZIRlZNQTBNRFFsUGpY?=
 =?utf-8?B?MnZBYTVHb0xyVk9mVXdua055aWRHdUFkaHREWnhPNyt6UXBsQ0o0Q2RhV0l2?=
 =?utf-8?B?eksxd1BHTmd4T0JzODhDeWNvMFhWekR1TVQ2RTN3ZkRuZ1pQS1RGcVdqU2dS?=
 =?utf-8?B?SXhBdkp2dTNVc1JRbjdZL24wbGg4YUUyVXhFbmlXaVFIZmE4alhUMlptVGp2?=
 =?utf-8?B?NjgvSlc3RGZzeHNFeWhDWldoRFl0L2wrVDg5dGF0THdhMnQ5VDhqdjZZWEJF?=
 =?utf-8?B?cFgvWDhNVGpsOW1FMVh4YU5BZmdEM3docUZIOG44clRsWm9Mc2hlUGtNZEZa?=
 =?utf-8?B?QjlPcGhrSlo3Q0dZd0d5UmJwbVBLSGpVWHZSQmdVbGtkQkJoYzVZSEk3WGJs?=
 =?utf-8?B?OGZybGlid3NyeXdpTEk1WkUrMkhhY3QxMWx0RHZWQVROZzBjVmNJM0pRTmhw?=
 =?utf-8?B?czl5NW9GMVpmRTFDTVJFT2c3NEFNbS9oZ2hJeTlLQU9wS1pTQXB6THpURG9w?=
 =?utf-8?B?OEUrR0VldWc3Uml3MHFUT3laZlhZWTZFYjhFN3dqUjBIWUMzQzJXMFRxQ1l3?=
 =?utf-8?B?Yys1WEE1RWdGbDhvSDFRQ3BObGgrOU9YWTRNajJ0YXhJOTZEWU52aGowclp5?=
 =?utf-8?B?ZTd2THMvVnV3Z1ZrSEhEY1JwZlJ0djRjMGVhVW1LUnVSL1dBUVdOQ0lYK1hZ?=
 =?utf-8?B?UmFZUVpKclBPazZRaTA1cldPYlBGUXQ5NzRsbzNIMHEzelh1S2VkU2FnNUd3?=
 =?utf-8?B?QS9YSi96QXU2N3pnNWRkcFBsNnI2QnVzMi9XbGg4cVJDeXlJN3R5TDNmWFcv?=
 =?utf-8?B?ckROMGpreXQ5QVExMXFFTGVXNWVKTmxoNml2UzQ2Q3E4UXFGTjlxU3NNYU1l?=
 =?utf-8?B?UEJ2K1dMemhXUHZ1eTdtdmxLMmJVL1VpNjJZN0hqeDVGQmJFMk9NeTFNNWdw?=
 =?utf-8?B?dThsOU5aTkwvaldrLy9FbHBmWlE1eEpRenQxd1dndklOSlBmc3N6MzB3ZExn?=
 =?utf-8?B?b0NqaFJTNmVRS0FHV3JBdVhLWXNDTDc0ZWdqNWNZQTR4M3VvM1QvUEZJd3Vo?=
 =?utf-8?B?N3pxYVh5NHJKVGV3Z2FibUZYYTc2ZHFjMlAyTUk1WGV2MGE0RTJhOEcyT25h?=
 =?utf-8?B?RWxMWG9QVnliRFJHSUFIUjBPWUdJVnVzUzBBNnM4UWp2RG04aWRmWkRuTThz?=
 =?utf-8?B?V1JtYzl5dWo0cW54UWd2WjJJNzJQaVJscENWdGZUMEs1czQ3QVlBNWM4N09E?=
 =?utf-8?Q?nfUyU7FaNdY4QMGJmfO1wAcpa+dUL0B4u1?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d1JKVUcwRDRsNi9Sd0RLS04xa2RTWnEwaERNWDlsKzBadE82V0IrUkZvdk5G?=
 =?utf-8?B?TXZPeGdRcjhQRks1bzRoQmZ5UWlsaGFUSUx1UWJMV2RtaC9BUFRadStKNi91?=
 =?utf-8?B?b3BHS2JkVTltdVliM1BYSDMzRjJWUWR0RDVkenYrZW50R2dJUmZWRmEydDd1?=
 =?utf-8?B?QWFTb2tRcmlnN0M0UHVFSkhnWnlnalNPaHpJSlhtWEp0T0dkaDVvL3IvbDl0?=
 =?utf-8?B?cXRzQW5YaUNwczJESG93TEVCUTRRNE9EWlVHWDJ5QXNFRWtBdTZuRmMwWEU0?=
 =?utf-8?B?QmpuR0Q3UUZBTXBQai92WlRLdktMQTBPTjhiZ2R0MTBPWmRuV0FTYzFlemlp?=
 =?utf-8?B?ZjJXWWRoaFU4TWtQejRCcGxrNjNHUFBGdENhYTdCM2ZITldVRVloWXgydXJH?=
 =?utf-8?B?clFUQm14cDRHcUYvTGdWUDc0WnFjQXNmZWVBM29XZkxNRnI3S0FvOXB0dXQ0?=
 =?utf-8?B?RE5uWDhBN2FxU3lzVVlDaWRYcVBvKzZGeU5MNkZSemR5RGI0M0FvU1EvcmFU?=
 =?utf-8?B?eWdqN2RFUFJpeThTMllIVGplc0h2b1pmeVhTc24zZnRjaWtIWVF5K3FIeEZ2?=
 =?utf-8?B?bVRjZ2pMUzR3OTRManRjcHcvZGtmM0ovaXVoRE5WQXVWRmxVdDViWmNJM0pq?=
 =?utf-8?B?Q1lRS0xPUkc1M3E0WmJsT2E4ZE1TaUZnV2VjM2RXeGw1UUorOC9LVXJoUUYz?=
 =?utf-8?B?cTF3UUhzNjh4YzE5SmZicEZvU1VURzM0dHU5K1NKNkNrY29kYXYzNDNzQUtM?=
 =?utf-8?B?SXRleHl2Y1Nra0RrTGsxOGw5T0JmeFZFdFB5SE5oV2FTUDhObEVabklwVkN3?=
 =?utf-8?B?TnBoUy9vRTVZNStDRUlFQ3JQR3JJS2xOZkhueTlYOFlpQVladEcveWF4NCsr?=
 =?utf-8?B?blEvTkdJQWZXclI5UTFJUlZrVEZlYkx4ZFVoZFlkVW9zcVF4SGdkTUFlRGEz?=
 =?utf-8?B?RU8yRjNRQ1ZDS0N4RDhzYk5jMEpWS1ZLYW5BL1dlb2hzeEZyczNOL0lYRDdp?=
 =?utf-8?B?OFQxTmxWU3V6SXEwZTRwczh0U2MxMU5Hc0Jrd2kvQVpOSjBncmFsOVljSmlX?=
 =?utf-8?B?YitGMkFPcFEwWjJCclRIWkF2bmdWNmpUOUQzQUhzZjlaMDlhWm5lVzF5QUFE?=
 =?utf-8?B?My9SOVQxakVwQllpbFBJSktZZW9BTlVjNjY0OE1XVHhYYTk4SWFQL2VZOHor?=
 =?utf-8?B?d3JxQmtWNCt1TnRlTzQxTXRJQUY2c2hFMVR0VE5lT1o1NFlVRjRwVzlJNFBx?=
 =?utf-8?B?Lzl6K2o1d0tyS3JIZkNLeGtqUGRCK2ZOYjJydzdMYncvaEJPckRPemhDdUJJ?=
 =?utf-8?B?eHdDdGhScWladm1Zdk1hc3UydkQ4Mzh3VzhmRXpTNUlHZWYvWEJCKzhDR3FW?=
 =?utf-8?B?TTJpdDJBUUZWcTJNU3hBWld4Mi93T2tNUHE1NzBIa09ycVRYZlBUM0huSU5k?=
 =?utf-8?B?aVQyMURCcy9xNFRxc21iMTdNNVhiWVRRZCtha3A4OWMvb0tUb1pacXhaSmVX?=
 =?utf-8?B?OVZjSi9GMzBudUZ6cVhBVUdKMXJJK1B0Y2FPeE91RGY5a0R1UEhMRGZMcDVr?=
 =?utf-8?B?eDVzZXc0MmtLVDhQQnRjMlRNOEMxNjV5bTNPZVdoellVSm1wQWZtZmFTckpH?=
 =?utf-8?B?cE1HQ0htMDRjRDV6RTJ1UGtBOW9zdnl2VDZPL3ZJSktHa0pwa0ZTd2NWNG42?=
 =?utf-8?B?aFFjd3c2Z0JSVWlZYmVmdkNqcGl0MGJXVG9MV0pXZDZCMTF0VWFPbTlRYlda?=
 =?utf-8?B?NG1vTnZLOUYvSmpJN2RtVGR2SWNxenlCY1YxVHpTNkpGL3lablFlMkdnYmdy?=
 =?utf-8?B?SlQ1STg5OUZqS0VhZVZhZTFTek1UdEJZczUyV01seDdyVkVwN0RkdkRpUG01?=
 =?utf-8?Q?I++VdqlPe6bxR?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-b83fc.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 005a76e0-7b63-49b4-08ea-08defb8cae4a
X-MS-Exchange-CrossTenant-AuthSource: OS7PR01MB13914.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2026 11:51:17.3505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB10823
X-Rspam-User: 
X-Stat-Signature: 8jt3wsxepj3uh94ds97mag9tts8d5sy4
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F35E318000A
X-HE-Tag: 1786881085-604761
X-HE-Meta: U2FsdGVkX18cah3atAx9ydosNUpaVSnDliKtc/CsGnOGIRTXK/spFlGCvRYS5BiBvhfld4mEAIO3whDaNYHE/g4HlmZ20mL018O0b+ERpYj1JY9uU4nsQjAAbXKGS/2VxsWBKAqmYntwB/mArduwEtWyr+5h77eonHPqR3bw7eXWcI/QWjF71dw3nV/KZU3iYELqzBJSqEEX+S/loSNCjgj7SV/MT9dJue+3aB6B5Yz1XEcDX1N/+Eg1klqXhQcW5znlvsHZI4hZgpjN/mKopYn/o7JF/9XG9Zk+gmeL6WmWbfTd8kSFczTmzAHmazwftD2NpY4d4AlGTuiJH0f3omM5sUL5uvvnH5onE6dcZwFBC3ygjl0j45/77qdXedEEktTAoSSUCUUWf52lslN8lYyrA/lLnkV9vH6/Ctt64SoObz0RGkzaBAAtOOl3fAKkQ3qtCU+sO4yN3KE4OTD0ZJrwPJySuV3CyusnlbVr/0VIelIw4/9sd1/tH7hs401e/wwYfNK1LZJrSrkJ2ldoW4D8cFX+NXUuG+tpuL2cFkQ0vqMXzu45qMM5dvnBU+Ebr2AbIuIf3wvEXb3gX2WW0wQeYjc2tB6/V3PIEQ7wPSjV1sj2/AeoyfI8UxIooPS/GqEOPEhgA13M+md/9QGCKrbmOcx/os6Yhu5CYYzXSEOp3McG4bGmQr2bdWhYNewjbR2AnzWgCLrQEbUh+TwjSwxhSe/6UW4q0VBBMDRV21fv0Na155t+vcFAk5Ad20tJkBh3QVLUxwlaiGXu9v6la4kvFliFmQbCQJGVLf8ji4DfmKNbbcp5DSfVHMBamITnStqTwsIG76kVwVQt8+xSwH41mnyw0tp/UuPbFZYigmdkBUtTJBIGhZEo+NaFGqKdWCj+Lo9ZPrVLSh5BY23jdCLiwQi3OpPk+N24oRJcoKImvhSDW5g/EEE+XX64jpWYgzdTle3AJ4bqnu5mrUz
 GOPwgi32
 MAfgusy3vBCsr1cjDwfZlAPs9I3OKtUsNa1jlbsjnp41yMdu1JIahKthZ/m2Cu5lhZ/dipEmIBb40yWfSwKl8LXg2NkwVQc1RsMmigJCE5DdBN+5OQ7orpl2nuyiqFnhC0+lyjm3HTwwvLby/hBsCMHxfT628fTvcrQCMHuCVlWd7RUYpbV9KijVb97YlAyMrxVOan+2FpDm/vdmOYNEvVWoaugJFRB6dZQbSA2o+LSni0PnpoXHu/QCGh8tZ7jQRcjlv2etnScSnHM8Xa6dtyTyIOLryARBP+2Y5f1GGltEqmy9/AnrWC+noak9zffEvHLn7FeK7m3ldrpm+19CPss+7T4K9fPjamslPhXT0cVUw2FqkAmsI9UGFLDYRTISLCDB937VRnojVznFHrMta2IKkE3AfgEab6O0bBamBokbYTXPg4oWhPIcWP46sUaHrm72i6qGbAxVqSF5RNL3wnBxb4iQiyRrJTybkp9FJw0ZTbzAEWfWXGNJl5g+gVuLA7nEtoWNfqN1l1eIYZ5LBxSjnIuIh/4OzBOu28IUSdlnMWTyQM4oY5Kcq9EeQsHd+X8C/eCB4wT4doPp9rGGuDMvn+mtlEBjPCGEU6f9rQL648FXj+gfU0tISob7/Wp2sLsR9oiUH5I1itdn+vckMhk14rdgfMHujg+Vq7CL+5tSz4fk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/15/26 14:21, Barry Song wrote:

> On Fri, Aug 14, 2026 at 2:33 PM Eric Kim <seohyun.kim@outlook.kr> wrote:
>> Currently, in anon_vma_clone(), src vma's anon_vma is assigned to
>> active_anon_vma and is used when unlocking anon_vma after linking new
>> AVCs. However, the anon_vma is locked using src->anon_vma, instead of
>> active_anon_vma, making the lock and unlock target inconsistent.
> I'm not a native speaker, but I feel the lock and unlock are actually
> consistent and operate on the same anon_vma. The code just looks
> unpaired: one uses src->anon_vma, while the other uses
> active_anon_vma. But aren't they actually the same thing?
You're right. My original commit message does come as confusing
because it sounds like there's an actual lock/unlock target mismatch.
(I'm not a native speaker too) My intent was to match the variable
name for locking and unlocking, and since active_anon_vma is the
implemented alias for src->anon_vma, anon_vma_clone() should
consistently use active_anon_vma. Should I send a v2 to clarify the commit
message?
> Not an objection to the patch; I just find the changelog a bit
> confusing.
>
>> Use active_anon_vma for both locking and unlocking.
>>
>> Signed-off-by: Eric Kim <seohyun.kim@outlook.kr>
> Best Regards
> Barry

Thanks for the feedback.

Eric Kim


