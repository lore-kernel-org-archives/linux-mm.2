Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBEABCAC5B8
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 17:52:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 202118E0007; Fri, 26 Sep 2025 13:52:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B1C28E0001; Fri, 26 Sep 2025 13:52:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0520F8E0007; Fri, 26 Sep 2025 13:52:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E437A8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 13:52:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8F2C95AE58
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 17:52:02 +0000 (UTC)
X-FDA: 83932144884.16.6C54DE0
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11020084.outbound.protection.outlook.com [40.93.198.84])
	by imf20.hostedemail.com (Postfix) with ESMTP id 672911C0016
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 17:51:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b="h0BKv4K/";
	spf=pass (imf20.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.93.198.84 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758909119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6cuxjqxQ8CNRPSSYECwUBuMMXV4X+BLivQ95oh8Ujf8=;
	b=JrssSp6veMlGe1oafyzD2Cmj/onN14t4eRKSGy+gRu9GoJmLjuV/fA7RJ1qKPIGauCD5Pr
	3/mOGzIqMcoa6hAQhQyWBmMPLRBDOexXCIzt38UIyIBqlpMcAVCOnd7p8wykc4xWa7oyo2
	AtHNdM1zJHzHXK9N1D2v7nlvmMr6Hdk=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b="h0BKv4K/";
	spf=pass (imf20.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.93.198.84 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758909119; a=rsa-sha256;
	cv=pass;
	b=FrhXH582MhxdZlXgsfc/9w4ods5Vg5XI2ufrlTZaDG+rfYDntp63f9VdODyTAW3pUX+mli
	+vpVptmORkOjrM4GjeDGQWc059j7F2Nymz9VGRiOsDKR9HYRXLITgnjWANpCl2kWBHlYCV
	XmL/CRaTfM66tOerUGsQVeAcsYO9krw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dWxYr2ED7HFKGRxKaLnXocFwl4OrDy7emk2mzH+0aysaV46ytWxGyIbS6P17X4ndND7AP21xm+QhdVaKKJFkM3gURiaJqAoQ5AJN7zv4+AqPs8EOWQK/6lCNndDjRYZlsevx5WWolSqJT7a/NM8UC1Ar3O+HL/5AmnZ8UpOKrpafFWuyrk9HSrl+YNeyfD/3o3rRb3PlRdcPzhdNbcCSFYquZyi4W6nUmEQkgOoSwkuPu46cXalnt5cm4rmhrNrbjbn9+tmr8jK8hTzU/U8+Zm4W8dNF2eB/pIRmesG/JWFjJhoOrzZt4xdzG5bmVYhLS2IU0ItxSVtTslnUtBm5vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6cuxjqxQ8CNRPSSYECwUBuMMXV4X+BLivQ95oh8Ujf8=;
 b=rVy0+HH8fp+yM/Ea8nX3Qt+TCS9OLTPPgSo4VnKwf/me8A0Ev9e9lYYk/2vPAjg8lDcnBjnckWVtyfJfilPJB/Ki5q2bOht91TWRHOdqSUmpXsXKpnPLPo4j3p2p4CCeiG0jpPSQtxMhHA715+obVnijQIPP1QbmMJ/8q42kWeUlbWpC6MthFB4Rm2y+mZRBbjUI2DtkSUFkb21qw4L0wLv2z1i5AQJ5GQrm2zcUJgTomTX6x7uUC8RqJ8EDyE7Ahai82BYI4ZPeo6eA+q2xOL+XgZ/CXmkDZ4CFU/Ln1MRbFSgN7KX+J+iTuX4SKSnQV9CkzX099x4oJPvVLon5Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6cuxjqxQ8CNRPSSYECwUBuMMXV4X+BLivQ95oh8Ujf8=;
 b=h0BKv4K/UbFVGEBHAXDWqqLmLd7XGchxS5dAphpCfQuFi/Itw8Kyql/VEPYnIQ4t03W8d0kVtEJEiQ6mudDpR8WMQTZYxJCu2Req/r5RHeBbP+WyvU2wQZveyJLMUtV933kmew0pgCcni5TZ8BFWtl8Z/kdLJccVE2aQBlgB3VY=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 SJ0PR01MB6400.prod.exchangelabs.com (2603:10b6:a03:2a2::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.9; Fri, 26 Sep 2025 17:51:56 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460%3]) with mapi id 15.20.9160.011; Fri, 26 Sep 2025
 17:51:55 +0000
Message-ID: <bda280c2-8eb2-4e09-8f46-6ec7951a09cd@os.amperecomputing.com>
Date: Fri, 26 Sep 2025 10:51:52 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: hugetlb: avoid soft lockup when mprotect with
 PROT_MTE
To: Catalin Marinas <catalin.marinas@arm.com>,
 "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@redhat.com,
 akpm@linux-foundation.org, will@kernel.org, carl@os.amperecomputing.com,
 linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <20250926162034.1785899-1-yang@os.amperecomputing.com>
 <1038c7c7-81d6-f273-6fa1-93eb7206d5ed@gentwo.org> <aNbFtaVr8f2klqdD@arm.com>
Content-Language: en-US
From: Yang Shi <yang@os.amperecomputing.com>
In-Reply-To: <aNbFtaVr8f2klqdD@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CYXPR03CA0088.namprd03.prod.outlook.com
 (2603:10b6:930:d3::9) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|SJ0PR01MB6400:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bbde6ce-a750-4219-5bcb-08ddfd2561dd
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dklnQnRYVTRNbkNrNHJoMVU3SWJZdTFFOUMzazg0UUZEcVIrcmFBMUVnUjJQ?=
 =?utf-8?B?MlRENXdOcUFHVWxvR1pCM2pOTnRkSWsrQTI3bU9OZDFZclMxdldUQW91cndJ?=
 =?utf-8?B?ZHpma3QrTVE4OWFjWDVITC9DQlprUTFPVlBBNzVkT0hqVm5wRkY1U01tR1U5?=
 =?utf-8?B?ZXU2eVFERlJiSFlURER1cW1zRUFjckRPUmwyY0hiU3poYjJWVk5YejR4K2ln?=
 =?utf-8?B?bFZ1Vk1VQTdOckNSenpGZFdrVmpmMDJXQk40VHE4WDdlMW1TYndRZE9YVVhH?=
 =?utf-8?B?b2VUMmVTM09IK1NienBzanhLVzZ1bE9CNVZXNnl3RGxQS0FOV25aWjRtU0FG?=
 =?utf-8?B?M24rN2gvWGVBZnM1L2EycE00bTllYk9ZNFl6aGJzNU5iSnF0UDk2UEV6d3Nu?=
 =?utf-8?B?V0ZSNGFWU1dISFB3YzJwOFcwbDRPQ0kzZkFkZUkvQ3lkc20rc2hFbjlFSUdZ?=
 =?utf-8?B?TDRhNTJVZCtLL2Uwb2xOVlp4Y1IxdVA3N3hqdXQrUGFWajlwZnE5RTlqdmZU?=
 =?utf-8?B?bURuTTFrODIxY0VubVJlaE5lTkw2ZWZncnEzNjU2RkRUU1d1K0VsU0I3ZXFy?=
 =?utf-8?B?aTBiY2dhQnpaaEVTOVB4d3lzQXc1R252OW1jZ2VoUDh2VzN3aUd5Z2RpTFRZ?=
 =?utf-8?B?MjlMYU5uRjVJZVE2YVEyc243TEVsSWN2ZWFhRlp0NGRYQ2hpL0tzK1NQck9I?=
 =?utf-8?B?VHpONFBZYjBTaVhZaURDMXNDa2hXSjFvaVlOZzJMb0JndTNIc01NcTZVeTEz?=
 =?utf-8?B?R3F2a2hSd3BNU0wrUzYxS2ZmR3FoWTQwRzZ0aWxVRFpHaS9vQlU2VVM0Y1pi?=
 =?utf-8?B?WURObUphSVNoaVgwMzU5bExIQTVUMDQ4ZUVaR1V6c2dYdjVjYkJqMDZVMCsy?=
 =?utf-8?B?NWg4RWgzSmdCUTdFL2p3ak1scElXdmJDaDBielVxeGdBdGZFS25wR3dvb1Nx?=
 =?utf-8?B?Z2RWdzVxeUViRVhDL0J5U3pYU01rM09RdTRoN3dkVk9kZEdleXZCK01MbWFZ?=
 =?utf-8?B?V0t5c1lIbmQ3MFlTWVlDTERSaHFzVHBqVFNOanRPeEx4R1NuZHdIYW9wenVr?=
 =?utf-8?B?Z2tSL1YvY0ozcUtSaUU3OTN2KzgwdWxWVXMxN3NUOHlobWV6ZHowcnRDaGV2?=
 =?utf-8?B?RENwMjZjR2tYWVpKWFRnQngxdXhMR2YrNHhVK2FFWjFXSDN1cHoxcm9MK0VQ?=
 =?utf-8?B?MDVGQkpCZWQxbWZoSHk2alhzUXFFalpNZkw0Y1NtSmg5Uy9KSWJtczlWK1dx?=
 =?utf-8?B?aktOWGhqMUE4ODBvRTZLdjIvODc0dUxrSzgzLzdPME41UnBQRVQzb1oyTGZS?=
 =?utf-8?B?ZkZXVGc0VG5RZzZMUktNR0xhNnRnYnk2NnU4TDBHZ0t1b3Qvcm5hTkkzazdW?=
 =?utf-8?B?bmM3VW9sVHJmNnZuSVlVNkc3anUwQVFTWSs2YXFCWmFQSHdtZk1DWFh6RFBY?=
 =?utf-8?B?ZkxpVUQvZDlienppdUZWVmMva3lyVWhONml0LytKTVdUZElRaG5PVE9qK1g4?=
 =?utf-8?B?S0JLbzhnSU1CR3NWYzV4TXdFaDcvMk9oUnhoZ1AwTlhIU0EzY3diSk1DelVq?=
 =?utf-8?B?SWUzNERhNGZvYVRkQ0tSdlQ5SEhKR296em5SaVBValNBMlJ0T0IyaC9URGdD?=
 =?utf-8?B?UlVBQTJ5RjdqNjV2KytZYjlXdDVEWVlFb2dnUE01R2RZNkcvTUdBR25nZUs4?=
 =?utf-8?B?ZEU2cEF0VXE4MnpaM0RORmVDdHhDUUN0VHNpSkJYWXJSS0F6OXBMZmg5VjRT?=
 =?utf-8?B?RlRSbWdMaXBiQmFzcjhEelRtV2F0WC9WMTdMcHJ5TVFmWU5VdHZGNFc1ZWVs?=
 =?utf-8?B?MlFIbGM2RVVtcnFYcXNIK3NPcG1ibXVkbWFzbTg4WTBRd3VjUU1IVVh5Vk1O?=
 =?utf-8?B?Q0JPRUxxZ1BlSnFCQlI0bEovY2tOZnhBTHBoTlpVYkhnV0NXbDNPU0NsQ2V5?=
 =?utf-8?Q?39/LZrcU1BbL/cFUZ+OR5jrrqmLNbbn4?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aXRNaTdzREd4TmQveHlEY1N4VDcrV0RGZ1FHWDRSREpSOGNPeWdsL3A1eGxU?=
 =?utf-8?B?V25yZzUweTVpRFVidmwxcFVaNG8wR29kUndMZkxqRS93UWsrRkdTMEgzZm5m?=
 =?utf-8?B?UU1oRjVZWnpHMHQ3ZlpaaGx2K2RnU0h0T2RBdGdUY0FKVnB5TzFaYnVrWU1n?=
 =?utf-8?B?V21wWVk2R1lIbjNndGNvakhCOXVpSXhXZHVReExEQllmQjZaT0pjL0ljd1lX?=
 =?utf-8?B?bnF6VFZyMHk0T1R2a0FYd2x0cTJBK1l3ckxaTHlSVnF1V2dUTndoL2dTeDZO?=
 =?utf-8?B?RVNtbDBEdTdYZlNVL014bDQ0b0NuQ1hZeG5XYnlZYnJON3ZLNEFkTDVlQ1dk?=
 =?utf-8?B?U05vYThZTG9HZU1rbXN0ZFdhYmlQUCt6ZzFWUCtoTGlTMGlyeWtMcGQ4aCtS?=
 =?utf-8?B?NkJwcVhMckVKUVNyM1JkSjRaTDZPN0czSTVWWUdFQmNkUnRkRmQ4bUR0QzdQ?=
 =?utf-8?B?d2ljcnQ4QkpWdUpTa1VKNyt6cFhyRXBWa1FvSUZ5ZzZrQkhzWTJNZHNNOVZI?=
 =?utf-8?B?T3BWZ0dGb0hneU5oM2lCcFdSMGVwUS9pMzhYL25vSTBEK0d3OFVPdnBDWmdj?=
 =?utf-8?B?LzRPVS9VekdJQmRFaFFNZ1RuTUdITXRQaG1aLzhFbXNjNEE4dFMvYk03OUwx?=
 =?utf-8?B?dXJHUGx4OS9zWDVLR2pRcnFUS3MxRlZYWmNOc1VsaXpRRWNzeDdnWWdEdXNt?=
 =?utf-8?B?b3p5NTZnTmNZWkRXRWYxbE56eSsrbnp4bXRka3EyemJXSlNwTHJuM2NiOERJ?=
 =?utf-8?B?Sk9sNlBqZkVUK1A4WVlLb0NnT2JYR1R3OEhrZTZrUmVnUFdJNUJRL1FDTTlM?=
 =?utf-8?B?T01GUVBVR21ra3ExYm02ZU5VdTZQdEFyaHlVZnBWRHY1cTZ2UDlUbERWcm5B?=
 =?utf-8?B?MHZvV29tSk9HbXNxbnphckxnNXBtR21yWTFyeCtzek1adG1VMXpxYWxiekFj?=
 =?utf-8?B?VnpxSFZSZk5NSkJoUzI4c2FWVUV3c1RRVmxISWw1NHU1a0FKbTdkZU1GR2hw?=
 =?utf-8?B?VlhYTlppRTFlK0VMWEFnZkJtNEpHOXhXVGp1MFVIMUZPTGJTdkJmOHRTM1hH?=
 =?utf-8?B?b0ZwS0RhbjBidW02Z2dYZ1J0QnFyRVY2eEp6MVl6M1NaMEdFREFFQnFCZlh3?=
 =?utf-8?B?VlpySG9IblN4Q2d2OVFkSDRWRExGQ0dqOVU2bTVrazBJRkExZUVsOCtDL0c0?=
 =?utf-8?B?a0hpTEdpdUd1R1p1MWtIeTNSK2JvTVdXeFE1U1ZWWGp6dVc0VHlXeTZqQjQ3?=
 =?utf-8?B?cEl5YzAvalE4K0ZJTGhRMzJsRDVZTWlubU1VOWRsQWRaKzBjR2gxL0Q0TlhU?=
 =?utf-8?B?Q1M3cENEZmRGOFhFTnF3MDEya3N6RUhDaTNHVitlTkpjL0NNOFYzY1huZzUr?=
 =?utf-8?B?ZkdvMksraUFTQ0pseVRKbVhEMjFvQ3lDZFpmUXRnRlBNWEhndDJaNXV6cmdl?=
 =?utf-8?B?ak4vQVBKOWRiMGs0b3JlNEJYMzhVWE9FV2dUSTRnZkFjYlJlUC9pTjAvbnJI?=
 =?utf-8?B?WlVoRXJtRnUvZ3hSem5KNk53TEhmVVh3aENna3ltSkd3SlUxWWkxcmFlaVQ3?=
 =?utf-8?B?RVdwellHRFJaMURyWEhhQjRPOFNiWVlXQjlwL00xNHVUbW0xdEhPakUwM0Fs?=
 =?utf-8?B?S1hsR3kvQnd1OWN2SlVLeVZrblhVT3VFWDBCOG4xU0ZQSHovWDJFS3h5N1dn?=
 =?utf-8?B?WkJjcEVTQWlzTlRXNmtDVEdtaGlWVHpyUnJUK2J5WXB6RUxEaHptWnNxZlhm?=
 =?utf-8?B?MGhPV2Nma0dKcGxhb0ZwR1N4UHhBc01qVWhkNTZZYmgwRjJRTlU0Z2RPZ3hy?=
 =?utf-8?B?VzJxN3lwYVk5cjh2eDdrdHFlZExQRWVOMCtxTzM5SXR1c3p0T0MrSlZ2WUpa?=
 =?utf-8?B?cjU4NG4wMW13eU9KK0MzbnE2U29wUVFGQTFNem1qd0loWitkM1pOOXNXaW1L?=
 =?utf-8?B?WTVraFl6Y1VvSE15UTJ3QmVlMGc2RGZ5Q1gzSDJCcExodVF3MFB4RUNMTW5F?=
 =?utf-8?B?R1JCTWtEQ0owczN4dnV1c0VHWHBHa2M1S0V2N1ZHZlArR0hzamtXSW9CTE1o?=
 =?utf-8?B?bFJtY2FjU3Q2YWlFRmFpOGVPYkFweFNSS1NZaWdRNGhwRXhCcTRIVEVnMW8y?=
 =?utf-8?B?N0QvMG5Ba2dmRWdJWU1kMU1wcFNFSzJLNWcrV29zWmlUemNqYnVCNmNnRzBn?=
 =?utf-8?Q?tWXrkU38JIzQP1Y89epQ1V4=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bbde6ce-a750-4219-5bcb-08ddfd2561dd
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2025 17:51:55.6875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 46XTR03F5oyXWGQdb/0OuSYkMrwD62O8DIDJGtgs8oIynMAe52PxjQpyoGQyobK81dcrsAeFUqDHejqSiTcxGI7PVAhXf9oSMqJPjBe+AkY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR01MB6400
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 672911C0016
X-Stat-Signature: p9it37xfiz1n7eeq89bszw5mf6x8hcnt
X-HE-Tag: 1758909119-88894
X-HE-Meta: U2FsdGVkX19eqXroWcPnd/I3/TzJWQnJKf1lMuYw6cR5O3RmzPprIL6K9OgGkdltC3g3nKakfv/7vMlzwkUeAvZQ4qkWY0RxZDVW+g58m6u0ALpQ/qfjZ2wonYqXrX56TqdpnsuAt9UR+zvfZ0RLDEDFCBw7esxIQm45hzXk7zO421lZHhB/faIvGy/AR37/Mvt98sKx6YU0ExSclxGjICSiMQlHWZk/pKJ30Mx+U0AafDZVWROSn3AbBvUP33hzIsn901bIZcd15PuQjfQbu+PfBUQrU3svAP7aRkEWQ2pavFb7k1yNtWXK7/XdBomZwYq0+Sy6UDZNcQzniFBJZepmw2Riq1971/yGESAFHpr9bAxOpiizhoG95c105cJQkBJB6m4ES+TffgQ3QuWCXBCGpbC2zzchPItJsM5sobeEmEjgWaGbSw8Cml7yhMLGEDFX35/AK5WlwCygwPnOpxa7DPNC/Pfx+g7kkaeqkmy26/rKgzUyYotPw+MAhkiBsr/zqPDG7BcsigAAVwD4Zj7xIHZcB+uw0Qg6xK2nhpHjzmr1vCf65WRCCMKZF6/eoxkt9U0De7gf7bkehfJ7iRW/ZJKV60ARUQammcb1aOoXiY430Q3FRkE43ILxpV4lFAbAQpGOPBlmxhBgH4X95+J4Xx+Kp1PgcUESYDA4cea1XgRawDrE3QNKn5JR5hDphAPgTAm8iWswh7wG77/5nt0Lr8RfZaKL1yqY5h2hAWbIFAIHMAPrfZDAIqaTdnaubJONMLjU7tTv4AD99VXOkWSNkTc7I1NX304vMFopR2/iltw9Pza/22e15WSij6/tJsHUXp9NRjldjr/LxYWY09vZ3IU7d0LR+qfqDMXUVdIRGD5+3lGTaMUEyg206WrV1X12AhFK4ueIPZp1vETkNpzKoJRl2nJYozJ3VYUZslBl2bZ2ElW93W4o0gQPOWeZAEeZ5Y9jULrNuoRJ7n5
 jNa9fIJc
 evEBiTJ9GSNXmOrB72OUuIwQzY3aZK73pQIerOGWSLISgiyaC6OAxIvRoqW5rXUmniB6SKtWjva4yYX/6wp4B/5PvjBYJvoO0D9caKYl9CtYxUdBYJBisZthonmXcFid2iJ9TBgQfILN4uTzM8f7NW3+8yjTGW+iYXxCEfwEZntWmhM4mWSVlmHm+5l3rWn8D0qnWT4pIgE2mZtUdlpZaRsew5INIhFYqX1MCdOR6vUSyBK98+ABL3J6kndAYJOdd+zHxREOSLogfuFE3GgoiRuGhjFTNUVn84eXNfgPfm6eArZ7oEb3JSSfh2aEOOdTXLfHNZU/zPBM1u0QOzKJxNn0JzkQ9wpMJVMdrm73QuyWyknJUHGyYsSlsxxgvKm2hyLPY+8v0tiIEParln15D544yZ8hfQ49HXZWOUTB6r2+xjmnKWV+sRbHSJHAZqqVpPBN9oxAlsC11IgNPULyTVTbY2UdVFUhSdXIrOPqbyB5lIzlNohialjK8aGbdYdolQw9K9Fj6mnjStpo/5BrPCaR5IX6PgzId/mjjssE0FU6MPgdBWlWDrY2ohZrz25x0pGs3VcLGH2YviAFSUu/7C94Jdhs1AUYTOpO/om73MAhFJywckBgHFfa4ogCkjiK09YbPsbh6Y/I6nNwPlcvOAba0dw9vORCKo3myo+Q+wiKTeb0HEk51sRoD7//d2wPeuVyD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/26/25 9:56 AM, Catalin Marinas wrote:
> On Fri, Sep 26, 2025 at 09:29:54AM -0700, Christoph Lameter (Ampere) wrote:
>> On Fri, 26 Sep 2025, Yang Shi wrote:
>>> When calling mprotect() with PROT_MTE, kernel will initialize MTE tags
>>> for every single page in the affected area. Soft lockup was observed
>>> when doing this for large HugeTLB memory area in our customer's workload
>>> (~300GB memory):
>> AFAICT this is a bug fix. The hugetlb path should be doing a
>> cond_resched() like the base page code does.
>>
>> It is not MTE specific. If other processing takes a long time in the loop
>> (setting up terabyte size mappings for hugetlb for example) then the
>> softlockup could also be triggered on non MTE workloads.
> Yeah, with MTE set_huge_pte_at() isn't just setting a pte but also
> clearing the tags. So it can take considerable time.
>
> The fix is indeed not related to MTE, so I don't think the Fixes tag
> should mention MTE (but I'm fine with a cc stable). Let's say we change
> a hugetlb from RW to RX and have to do cache maintenance, we'd trigger a
> similar soft lockup, depending on how fast the system is.
>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

Thank you. Yes, I agree this should be not MTE specific although it was 
triggered by MTE in certain workload. I will remove the fix tag and make 
the commit message more generic.

Yang



