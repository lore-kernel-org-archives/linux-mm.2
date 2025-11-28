Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B4C3CFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 13:30:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A619B6B002A; Fri, 28 Nov 2025 08:30:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A13386B002E; Fri, 28 Nov 2025 08:30:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B3036B002F; Fri, 28 Nov 2025 08:30:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 73F296B002A
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 08:30:19 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ECAB81A0550
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 13:30:18 +0000 (UTC)
X-FDA: 84160099716.04.EA0A320
Received: from YQZPR01CU011.outbound.protection.outlook.com (mail-canadaeastazon11020098.outbound.protection.outlook.com [52.101.191.98])
	by imf28.hostedemail.com (Postfix) with ESMTP id EF0EBC0010
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 13:30:15 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=krPKXOFB;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.191.98 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764336616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OvbYMRuyh38SFx7Ll037VhqltACYvUM4ZsO3sRsrvT8=;
	b=QUTZU+u5RoZUiMi4c3kqSFEITexovSOMUmgaqxpF0gDPzDvAriWo4ieUUQcbFkC6oM8zGK
	tE4wqsgvCUSgUkwjkcAcJPwk7Eg6nJSYPn/Jn5k2AxcxW/BpMFT7+Zu9bO6jduxkJKp39o
	YtfQD5X0cKUY1aW/P8J2v074MqzkP/k=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764336616; a=rsa-sha256;
	cv=pass;
	b=TkT73GxePP54POM7jHkYPZLbsOavt0hc1qK0vpcSFZzEzu/Tr8xhoLaWaYUSnyuydTpCnC
	i4+psZREHHaJZshKHMgVbqZCsdvpMyJvEuclVDP+yNccXpdSMCQ5VbXQFbp6Z9/yiGbGVg
	aud/d7wja/ncxdEn1je75ZLu+4wiQt4=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=krPKXOFB;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.191.98 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dlrol5h3mroOtCTS88Efp0RrvTDkYGk5Jm2LmrnTmBdRUJQu9lqIMD3LSCa3EhREwX2aM8ZSPNVbnf13TaG667I+Obie3xJS19ayYXBhJFqfWWzr5Yfj248PxXbT792RuKmv5101E6qV+E7lRVwokHvKIg7feb76pDsb9eXh8tcxLR4Ycym54t7X5LWs9Om3tdbUzqRcZtE5FUz2wEW+BaB2pQSo0eWX6TbOes+NsshI2mUKqgg8Mkmegsdc6FBVepnAMWi+wIxdS73uG5AFa/L1NjyNXWrmpZFUUsm81UBgP8kCo22iXHyqi5PT9EJx0yaX2B1kmzuBXe7PNbq57g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OvbYMRuyh38SFx7Ll037VhqltACYvUM4ZsO3sRsrvT8=;
 b=AKh0segPG7QU6B7oBAPfXuIbeZbhSNeZ22+2dPXoXPtwvVipGI8VE5byhQ8muHu5t4udfwWVSJuKa3A8ABBt/hAIXdSuJSmfmrpAUqSwmLJx0BITAaryLJHmzH6xYp/orXsrLtmFi7W2r3L1u8czCkp2zJm77Pa4Z+bq7sgz6miWLLGI6xq6Tw0zHy9TvKQHcq2cIApXhWj4IHGTalLkwe4GViVQoYv70sV3ZWD2NMHYtr0SCu10rZNpVPgFj2csIH3r8MnQUZIPSBK0T4BuJKC3V20AsTKIXlqcN5C4EizFOrIsalHF/RuHmXnR2TvnONF/WWzYOh3QJC5JSZUy2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OvbYMRuyh38SFx7Ll037VhqltACYvUM4ZsO3sRsrvT8=;
 b=krPKXOFBiohNMilFqs4acImUlOndsdCmpmCW14y/AsVf67NfK0aNkHll25VuixcTyyfVl+V0+Ru+39pvF1W9QTgLbaAmiXdfP8iJ5AKt6PoJ6H3SeoUMVdrAN2UsDJbt9QqcuPaddsxHlKtUhsur8GeYbD4guhkUAOsPZdk2V/rmUdvLjVBjR7R3DonHVbq+A5cAD9H+r7KET3j1MZEIFkreDRJrY3dHjx5VaXOuHYd9AwhQ6QBe4e4B9tbaMs/IwC8LO6qAeUUgosWA13qSt0mcgYE6VG1HieHyDJpRrhvAraZKHhSjnxXypkcj/+AdATyY+kyUQjY5Qv33FqfQhg==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YQBPR0101MB9629.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:7d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Fri, 28 Nov
 2025 13:30:10 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::50f1:2e3f:a5dd:5b4]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::50f1:2e3f:a5dd:5b4%2]) with mapi id 15.20.9366.012; Fri, 28 Nov 2025
 13:30:10 +0000
Message-ID: <f1a1b7ba-c084-4e41-9242-8255f2664b76@efficios.com>
Date: Fri, 28 Nov 2025 08:30:08 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/4] Optimize rss_stat initialization/teardown for
 single-threaded tasks
To: Gabriel Krisman Bertazi <krisman@suse.de>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, jack@suse.cz,
 Mateusz Guzik <mjguzik@gmail.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Michal Hocko <mhocko@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@linutronix.de>
References: <20251127233635.4170047-1-krisman@suse.de>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <20251127233635.4170047-1-krisman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQBPR0101CA0061.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:1::38) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YQBPR0101MB9629:EE_
X-MS-Office365-Filtering-Correlation-Id: 979606bc-256b-4a34-4d4a-08de2e8240b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MFRpN1BLWU41QkFGbFVEanVkSjVNeU4yaVE0SHhrZThPUG45SExzTCtBb1Vx?=
 =?utf-8?B?Mlhnc2Zta0xMTno1VzdIUFgxUytiakVvUG5wdy9BN21raFlrUzh2M2pGUDRv?=
 =?utf-8?B?cG96bnZKU1NybFQwa3hRTWdyczR0Wno2WmJtTjhHa1VJdUR4QWhyY2x5b2lC?=
 =?utf-8?B?Q1A1U2ZiRG5yazBVa1RjaS9lOVJWQ3ZCMHRIQWpCN0p4aFBWbGlZSnBtZnBI?=
 =?utf-8?B?c3ZQcVB0bDRMTmlhVmJZS1o3TE5aMkd2ZnBNQVFYd2NGSzFHZGF1Y2pmS2Qx?=
 =?utf-8?B?b0wzbnpzWUp0QjRmNXFoS3IyVnA4d2cvS0t1bDcvMlI3ZEI0SmtMeHUyT3dm?=
 =?utf-8?B?TkNwdmpJcnBTL2ZSazhPN2w5cVhocjdWRHBlQ3ZrdzRkREhMTEZVRDhjN21l?=
 =?utf-8?B?WWtZUVpDMHhYMStaN1h4Z3pEUndTa0xVNzVOMlA5YWZnT2xHazBKVTQvTkQz?=
 =?utf-8?B?L3FNRnBmMXVVdHJLVGpsUmZCL0RxSU43bUtyQkJxV3Q1UzJKaEQ2MEZCUnJ6?=
 =?utf-8?B?RUtSOU1Ic3R6Q3hLVGpyMWF4QmtvdHcwQ2NzQjVmMjc4cWVhR1NhT21mQXN2?=
 =?utf-8?B?ZUtLN2JTTkRPcGduSnpManlSc0h3SWQ3ZW95d2I4M05aNDVXZTd0a1dUS08z?=
 =?utf-8?B?aUVFUGQvcGVkb3BXWlNqdzVzUnlTYXQ5R0lXTXoyRFJ6aHJBU3BtTUFuMG5v?=
 =?utf-8?B?S3JUR2kyWHhqWTlnRlA4SHRvWlBmbzVldEV5WkdqQUNGSko1UU02UVJiTDZL?=
 =?utf-8?B?cUpQWXcrK0NVZmRvTTg1TC9DdnRYejRnbGpFRHVYSFRGSVRRcmgrMFNQMU0v?=
 =?utf-8?B?NUhYMlZvYkZqdjdaUy9hTXQweC94U0M1UGZsYno0NFBSWU1xL0VycEpxYnZM?=
 =?utf-8?B?RndrYmRSb1NoaDZpeENadjByNkt4OVNPd0dLVU5uOHNxWXVyRXA3NG81akRh?=
 =?utf-8?B?cURBeWZEelhiRmptam8xV3RtMXp2QS9qQ0VyRVBJeHl1M0xPaWdWY1ZRRWxh?=
 =?utf-8?B?dnRVTlZCTkFYemU4bXBDaHpqNC9LSzhRcUNCK05rWjlkWnBIcHVxRFNTalNN?=
 =?utf-8?B?eFNUa1dJRE5kYlk4aGRsYml6T0hhSGNtc0NKQnRLWGhISzlOSUVXK0psWjZ6?=
 =?utf-8?B?R3RxaTN4Q0NlRmJQZ2Q5RXpWWk5NU2FXbDF5QmE1amE3b3Exb3Y1bEI3Z3JW?=
 =?utf-8?B?ZTdiSlVvWmdOU1JwRUFDNWViZjJETnpKbFgvSnN1NHBDRitXSUVCd2Y3VHdZ?=
 =?utf-8?B?RGpuay9KWitLS203VFF6RGVEUWVFMmY4YUZLR1h5eXo3MC9kQzFyQlo2aklY?=
 =?utf-8?B?ODliM0FNOEZRLyt0N0EvV0hLUGtTL0JxUDdnbnB0VDF3Y1lYeHUydFV4UTJU?=
 =?utf-8?B?dnQxUERjYUlydVpqaW9GK0hGUzIrbzRzblY5LzZOaEh4NnVLVlFwNHZnL1da?=
 =?utf-8?B?cTUvQk50Y1ZZb0doUWdrNTJjeXhDbEpac21zMnJnVHZEY1cwMWY1WHhjWFVv?=
 =?utf-8?B?aFFETHc4N1VEcTRQZlhiV2c5WWgzTU1MY3c5blRjenpuclhMVER4ZjlWTjFN?=
 =?utf-8?B?Z3pmcjRnbThEK21EcUJlbkpqeHhCZUtoS1BnaHNqZlRRUVVPc3N5Z3U3Kytz?=
 =?utf-8?B?eklKZkU5bkFzOXRlTDZHWVAxZnVkaUt2Uld4cGppTDIrTG5kV0E4ajl5WjRu?=
 =?utf-8?B?VGZTRGt2L2Q0RldCVzZsUmwweEpjK0VIMmt0QmZ5WkVRNWpDdzFyV2ZUQXhB?=
 =?utf-8?B?NEVmT0JIWjlyQnRGWjdwdkcrSkw0RjlXdi84K0ErUmNkbm1VTzdXQlVSWjMr?=
 =?utf-8?B?cTNTdlU0Rk9CeFlCM2tMb1FEUTFFbGZQNFQ5cXlsMGVKRDlCWUJQRXlZTTJ2?=
 =?utf-8?B?SzhRSUY2RndudXFvZlZodi8rQ1IyVFBDNWxKTSs3VDVIclE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ODVCM1NTR3IvQy9jSjFwZnpHRXV3cTU0RU1haTRkNk9ZU1dVamdDQ0grdjc1?=
 =?utf-8?B?andSQmcwdHNaOXZUVFNDSXBFZXA5S1lWbU9SV1BtcnNabHNDVlhJbXBzd0ZW?=
 =?utf-8?B?a0ZtK0Z3K3BJVkVReUQya2trMGlYMjhPbUExbW1XanpNWmVsalFDWk5zYVdo?=
 =?utf-8?B?OVl5dXhSaTlaeTZJdkVjQldBM3l6M3pCNFJPZVVvekZRZ28valdOS0d0MURt?=
 =?utf-8?B?dzhGc1I4NUNuMTVxZ3RQWUQrV2lJRFViTFNRRTdHbzRDMmxiYmh0SitoUjBu?=
 =?utf-8?B?QzV5dE15c0Zhc3BUTVZkZjA0T3FvZ0NLQ2QzYUhHUU10VVlvdjNIRkZGZEpi?=
 =?utf-8?B?cXNLK0w2KzlxNXA0ZUJFTTNxd3N0Y3pzamVudy9zc1YrRGNST1RlSHIrYm9R?=
 =?utf-8?B?YlBydEtwRkoySGdhSlFpUHY4akhUZld1YkFNWnpkV24rc0lTZ1lUWTE5NE9V?=
 =?utf-8?B?bjM3di9vRzU1cUZ5ZU9udS9rbHhrb3RwMEsvMTJYRk5tL2ljUmhVYkx2SktR?=
 =?utf-8?B?RVNTQ214cXYrRm9hY0ZUSTNEQjZPYTJxOURraG5TUHNGUU1JYWtaVFcrTlRw?=
 =?utf-8?B?ZHRYcWZRc3RSZTQ3ZC9pNWtnQllhSnFFT2c5TUlVL1l5UWVkRzBJdHFYOXZS?=
 =?utf-8?B?VXpOVzRjQXhnTzRHaTBnZTg1VXFhK0NveVdmZldaakRZK2V1eWwwNlphbUYr?=
 =?utf-8?B?NWZXdjlIYVJEREduMzRVNnI2dDkza0IxNE1JSXdsTmhCdWJhMXdYZ2tiQ1J6?=
 =?utf-8?B?S1hOYkxnbXo0NUZOOFdWT3A1cnJ6Z2o2Q3N5eEUxQVdTNDhRclRpTVVpL2E2?=
 =?utf-8?B?SytsZzBpU0FSTy9lL3UraTJKaVJuSkNBWHltK0RvWFVCL1JRNkFMb2l1b1oy?=
 =?utf-8?B?RDNFbHpEYlc5WWJldmFQK09NUGxOUGsvRUU4Y0RpckphK2R0cjhOcVd0dCt0?=
 =?utf-8?B?YUdmL2ZBdjc5M0hWTnV2NVZhakk1SytSZHU2NzlUWElXRUNuQmgyUE5BdUVy?=
 =?utf-8?B?U0NJdU1JMUM3bmo3K0czRUpXbnJoMGFmU3JKaFBBRnpIdS9mSUFvdjJ0YmlQ?=
 =?utf-8?B?aXhXZElTWWtYbTBqS202dkRDN3MrZm1UYy9VSnBiNGtjV3dPYXd1aGp1WExL?=
 =?utf-8?B?YW5NL0xjSmNUN1VKOWx5THZCd21ZNURlRkUrY1pPU3FFc01SSXRBNDRyVTRy?=
 =?utf-8?B?aTZzK0N0ZjFraFhwbFZPUURRYjNnSjU0SE1acm1kOUJHWVZEVkg3T2hocUI5?=
 =?utf-8?B?d0toT213Y012UkpWRmFuRDFLU1lSNWtCem9Fcmo4eHpLZEZiTXB4SmpITStH?=
 =?utf-8?B?YzFua3RzQnZEdmc2MTNWcldOY2RsMitsSUxDSUJjalNieTRMUk82c09BNTZV?=
 =?utf-8?B?Slp1dGpQTjByMFk0L3owZFJrdTFvcUpua1ZqMDYwQnJtbXJiQWlMTjZKOExu?=
 =?utf-8?B?b0c1cDBMRWtSYlphQ01tWjdhUGtqMzIzV3I4Wjg4V2h4dVh0RFN6Z1dSUGRK?=
 =?utf-8?B?MmlJblVZdTFHZXlUYlhMWkNuLzVGK002UXRFb2dnMXMyQlpEVXUwb2doc20y?=
 =?utf-8?B?amxGQVFQV2ZUOEw1T0RObFNGZWJjdW5mZldzVEhqMjIzMTFDK0JYN3QrMSt0?=
 =?utf-8?B?SWY5Z1JWTE1rejlhek9kTXkrelBpczF2QkphMEliQ2plcEZHMjJ6UnBaazRS?=
 =?utf-8?B?WE9ud2t1cGV6ako4NEZLL29DNzhIdE8xSVNhMG5UUzFTTkxxMTRPL2FldVhk?=
 =?utf-8?B?SXU4N0N1QW10QTJrZmJFTUpGYjd5eVE1bThJbkpuUU9qb093byt6S29PWFZC?=
 =?utf-8?B?dGQ5Y1lGcGR2OFBNTHRGODEzaXRrQzAyTWNmNHRuZVZuKzBrckJTR3U1OTNL?=
 =?utf-8?B?T0xmUEZXa2o4K3dxMFpRWlhhZ1pNRXZnYjlpOWcxaENRN1BvOE1rMUF1clVQ?=
 =?utf-8?B?bUpuano3Nm5vZWhra2FtaTlMMFJtRklJSWJmNGQ1a0s2SDM4V29DUEZaUVRr?=
 =?utf-8?B?MTQ2U0xyZWd6M1QwNlBqbkllcUk4ZEhZKzF1ZTN0SjZVUTkxNkZBWFpDMUcv?=
 =?utf-8?B?WksvaEV4SFJ1WXd2dk1KbTh1elZveDIxRHplbnJvbVQ3TzRiOXpCcXIweUU3?=
 =?utf-8?B?MzJqMmgzYzhoSmFNdGZYYjJsZ2dwcEp1MlFFVlFyUWthTGYvRzNkdHlVR3NB?=
 =?utf-8?Q?BWFgzNc6XfGw8cnDItOwEU8=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 979606bc-256b-4a34-4d4a-08de2e8240b7
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2025 13:30:10.0793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UE+gieeY1qkb/Em2WJzYnFotwk4WQLnRa/H0hVcGcumRMnEjRR/vXytf5VKHJRpW9bwUGNEkUKUWspeegDxzBfFsbHhu06iG6R41QwsAKOk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQBPR0101MB9629
X-Rspamd-Queue-Id: EF0EBC0010
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: jqtt53paffayczeogwbu7ssdg9e1ma3y
X-HE-Tag: 1764336615-916802
X-HE-Meta: U2FsdGVkX1/mcaOKnmBNRh01/wlPajAUjA7Vl0KR4R8F8WvLkTK6t4kRpqXa4cBwJrVof6RyONFaryirOuHKcC9rGH8pYMgf4mAfE8U5tmFTDeXLoik0hjjVIKHokJ97YOecSMNFkZvgnRY1w3mFvLJ0e/xSkg7YEpnu3BsgBiy5ci6/M669ZNC5UMF7ySVkLouZ2WYkyzWBPHEvklJEjpY0q9mkqln2GLGpBGjUha5VXMLUl/LfkcCUe+28RKsrt1y28e9hl7aLnLeAa4kn8LBaH0jU9FzABCp9Bsv32QBZTd+XhyrfcO2l4eox8/Gai/D2Knpz3C28kLLUdRmGRe3Y/gzf/9ANbbmqiG4xdgRI/IEq7aYQOH3tC9F6MxyybUyHWkmlFmSdLTfuKeFh5+JmS8NyKiqZVBTY18W060vhA601ZZm+btBhVZ6wMcnI1Qzc8r9+hhRzIuxhaNpSJMKV2kWSNx1MjlQa2UfjZlYPwbA+NFj6bkUURJEAM2MDEYJf1dchZmYeqe898ikKYCRL4cTnhu8+BUcpHWNjxf6T2SpZzkTG+/ATDn3maqm6/BdSjVjrAaCs6lAHBEK4GBBsFWqIE15wwk/1Iq4m5+j09KXeDHkg65iWgiZN3hpUKCEgabw/zG/YQVsDn/MUhe2Ka4gLWKCOjNXEKIvOd+/sGuGgaV8aFIQjXC3W5qZbm83Ie6J1HU4mpUXh5Ra5apBkf3NXTI1J4f0cSlZ6hLcLKwdFmahAw6D9cUIbSiQKZPkI9cgPWT7rWvxhyF4Yi+tfgdsAvoVOYMsZ7Z+D10yGjRhjuwowb24hZIO2IuE0ZBvmx+5ctmms0YeMRr0Xnm2R5sPOEIHnY1IkyFHyqX44Z13U/+bGHFlzRSo13oNEKbjydNyVDDeFaEY2npb47pn9v3Dhqft36dSsERZT/F8/dV2TPp5dRReiyQNUHg8shuHmy2MvvdHNzZy2unM
 Faw2j9CP
 m90m2UC5E6VjF7whm4YvTs30Bnhy1g6VpER+TsZrbjk5NNbX0s87QcUclSuDHoVnT/syK4P2ZSuBnhqlxXLHW24UZAKcejhw8KTJw1BJfYh0pB4bH8vcjkrkTjW0yBpnO5cL/j8yQfmEFpreTdGKk52hkBsHPnUtvmFKx4vSjtUDmoJa4yvhKsLrMy5DILby/RdcOakk9jfj8mkhOujKLTeBZK0QCdZYufDHhwXX93RBmzDl6pdYIQ97oZUzW7NXacaBXySetovoYf1GD1rEvQjjnznJkX/2E9BDChKpsV/s2aeNATK+lmA2lkGclXqGDGIx2dLhDmY3mBdEP0bcGGMTXC2iLyMRm1AsZl/VybqPp2CQCyscC1sTm8wS8PvIgaPn2VtnGkJij625UQYW8aB8HusHSfyM8eWjPYOnzAqJjtTkJ0KLJIeCO65gY/5slANRj+rxowRpIJjBWz4jQaKt/M5XqCzmkDc6rjlBHrd+KqEIXTL+7ZLPaBe5rbv99B4r7kioArfP+E/tnuKvBlAfs+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-27 18:36, Gabriel Krisman Bertazi wrote:
> The cost of the pcpu memory allocation is non-negligible for systems
> with many cpus, and it is quite visible when forking a new task, as
> reported in a few occasions.
I've come to the same conclusion within the development of
the hierarchical per-cpu counters.

But while the mm_struct has a SLAB cache (initialized in
kernel/fork.c:mm_cache_init()), there is no such thing
for the per-mm per-cpu data.

In the mm_struct, we have the following per-cpu data (please
let me know if I missed any in the maze):

- struct mm_cid __percpu *pcpu_cid (or equivalent through
   struct mm_mm_cid after Thomas Gleixner gets his rewrite
   upstream),

- unsigned int __percpu *futex_ref,

- NR_MM_COUNTERS rss_stats per-cpu counters.

What would really reduce memory allocation overhead on fork
is to move all those fields into a top level
"struct mm_percpu_struct" as a first step. This would
merge 3 per-cpu allocations into one when forking a new
task.

Then the second step is to create a mm_percpu_struct
cache to bypass the per-cpu allocator.

I suspect that by doing just that we'd get most of the
performance benefits provided by the single-threaded special-case
proposed here.

I'm not against special casing single-threaded if it's still
worth it after doing the underlying data structure layout/caching
changes I'm proposing here, but I think we need to fix the
memory allocation overhead issue first before working around it
with special cases and added complexity.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

