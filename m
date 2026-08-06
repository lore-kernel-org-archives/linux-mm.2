Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F57CC56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 16:45:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F7AC6B007B; Thu,  6 Aug 2026 12:45:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A8E06B0088; Thu,  6 Aug 2026 12:45:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54B946B0092; Thu,  6 Aug 2026 12:45:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2CB476B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 12:45:25 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B23751A014C
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:45:24 +0000 (UTC)
X-FDA: 85071420168.05.6E8D810
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010041.outbound.protection.outlook.com [52.101.61.41])
	by imf14.hostedemail.com (Postfix) with ESMTP id E894D100017
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:45:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SXT9HMxU;
	spf=pass (imf14.hostedemail.com: domain of jgg@nvidia.com designates 52.101.61.41 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786034722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n0vWU7UBO+eT5npgKD7hQRs7EEQeBGFJVVjzRj9VUvo=;
	b=fLToIMAcwY9Vt10CTnsJCuPvZZfKUqr6idXRs39c/rlzhTVXiErHSfOrHSOPgUsRKkkCDK
	QgAbjZM+i74Vhl0Iwo/+cqGerV8ShcJ9ohkhq2TLDbKNa8cC4H4tobVy6OaGc6JSrJUea1
	MGZ133GZnF5DAJbZuHpJAGQzzL/x2K0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786034722;
	b=Uud36wer+EQhsK7V4t5rMELM2VbS9CiaBVTUIOCwQRh37iA0aD8+xkNiySOvScS7Kbms7f
	TQbx0ZQ4Ue2oxNPL2cw7z8AbrGRmHMG+kbt5Oiak9xM7gsVf7z7XRvmJdZkDhIyILG5SRn
	E2YhYkMyZbvVe1eQlv3NTk4/kAmvDZ4=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SXT9HMxU;
	spf=pass (imf14.hostedemail.com: domain of jgg@nvidia.com designates 52.101.61.41 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eF7BFI7ry3XSvw4eotyFupxSjAsMCpuSLYbvotTgNZh/QnXD4TfPIb0P5o0WkRhrape62StDHAjrFh0lc8fe0qkJKuevyYp7BfmN06r2mArgYZgJBLCBdAnd8cs/sMaY4fsj3BKha/TQeScgjkPgwKh52NOQ9J78nD+KLiKNvIdOLWwWvc3ofeYP855l5yhFmX5fLUx6byrx+FgRDP/a0RJK3EAR9CppNnAeoNQ6BSiii2dEIGWrefdvqNw4i6tQFMvt90ch+No1rgwatOrSgCqoWit81hwuJeTvMhxI00G3hpP3StxNbsNIte/1708Vgg/FcOtEScyGpVrhsx6wKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n0vWU7UBO+eT5npgKD7hQRs7EEQeBGFJVVjzRj9VUvo=;
 b=sD1YEsBr27h0zpu52eaA3vEZ7vNHqERxky32NpHJKj/KpLNupTpkQsCQMWkm2C7aJwZAUCiVQjBHfcZ8LmdFOhlVpTGo9kFinXDgCtS3GUUJLs5Zz+iHeRLeWVfymsp110ZzqqIZemJ9R0p7UJ4y+Sxv2sAtVz8fKoziin3vW97SnnM+FsWS6OvuEA1K3GL7I5XpU+SXOKOzfAMK0Kr0MBTxVjJCnwKsFD32k4KAwRcdiZKSBXybS7zhLyxjbe9Xg/cDcQtFcgRzTJLCfdsX+RmOrNHovwPtvhMYccxJ/BFsw5FSF3wWFdmMoooBq2YDyIOUtTfn6OcvFe3QL6iHcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n0vWU7UBO+eT5npgKD7hQRs7EEQeBGFJVVjzRj9VUvo=;
 b=SXT9HMxUztC6wruvz6XssEOWDHHj43u502oSGoxlBZMQjeZJL0rD6YCo4gThxWrLmUeDFK0vh/063wZ3dqJsltJW3q01qby6cBPlB6CVgXJM52aOGwXz9eV6l0ft9ZxFGhjoY8ib/vq15Z3JW2UfDNQcE2dkgl8QskD6WLVpBlJkPBjFlMM00AEDmtjY3XPNNkDWZrtY3X4S4offusWEeYNzweDWDjX7CTQt3JjIQSTD8vqfA8TKuGUbprimUys6PLleO8Og/JBiQtew1wESgFWvUh8r2jbb+bRn5yvD3pmYSUtu+uA6WLe/CbZZbkpoFP/jMXOxvU2TIoJqCzLJ/A==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CY1PR12MB9676.namprd12.prod.outlook.com (2603:10b6:930:104::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.21; Thu, 6 Aug
 2026 16:45:18 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0292.019; Thu, 6 Aug 2026
 16:45:18 +0000
Date: Thu, 6 Aug 2026 13:45:17 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@redhat.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Peter Xu <peterx@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, stable@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: let special huge VMAs bypass the THP
 policy check
Message-ID: <20260806164517.GA140051@nvidia.com>
References: <20260805055544.1568534-1-clg@redhat.com>
 <0e52d0b4-064d-4602-8e7b-5744b05f24ea@kernel.org>
 <anSZpAjt84Pn7O_b@lucifer>
 <5b7e84f5-2007-458c-910f-7a6e1e3d3eab@redhat.com>
 <cf533fc1-db58-4c6b-a206-a8dac3fff391@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cf533fc1-db58-4c6b-a206-a8dac3fff391@kernel.org>
X-ClientProxiedBy: BN9PR03CA0436.namprd03.prod.outlook.com
 (2603:10b6:408:113::21) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CY1PR12MB9676:EE_
X-MS-Office365-Filtering-Correlation-Id: 6cba0e09-0358-4670-1e03-08def3da18ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|22082099003|18002099003|56012099006|11063799006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	UBvSfpSbC3Y8exf80YR+rNfMFXeXOjRhMFFoQL+oECSic/RX81dA/5x3RFQTne4Y+ttvxnwGZF/bhkd/DD1+cTPQKM46I53UfxewCWV2xy4YJTA7qYwF3Zds/kzO86qv8rpO9f2JEU572l5Yx3tkg3guhwX+srXxSdyL4YsIJg5g9psfZaV9Si4U4Y46hJIbhIwtezZMfynTbe7rB6ot1xl4GwX9bc1FFtQyIhwlE/UvZvqsVjnE2zngc//J5FXo/8r6zGFvKCw6TGQnldbONO4EkrlBHnK6Z4MWCLe2ZRHBgV//d3ZowhtyxpLrtGF0XO4jJ+X5Kp6cW3YBcGlXuehTvGKTxYPKN9Ku+AdtsVeFsfZvbURJQJaE0ZV/hn7nL6abilfndMkF0n+gwc6wcIpZwY9jfLFOKzemuVPkYxx5D37v7QZsbrLJumq0ikMMKhVSmCVe7aH6OogQXRYhJ+XtwcqabNezzcIfJnq015IzxWfMTM5LofSfBNLxqKQ9gguSytRr8BIhv/RzuWUv+C8G2X/M5wGCjyVJaGBqZXTMPBNcO/gJOPb5/X0pZqoEiRXGAIHpyB8TBce04kN7MG/R7NPdAYrKOuXBwnegOynd1OeWb1gQV61lL5rXQJOMVCGx0JeB4F3SLVMJ+9QG15RDXYV5UTZc3bSuaK5T7qw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(22082099003)(18002099003)(56012099006)(11063799006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ajVyTENaUkJydGFaT0VXTUtRNlB2V1NrMWJPK3FnN2d5enlkWW1uSkJsLzhh?=
 =?utf-8?B?Y3lBUitLNmRjeENPSFcvTkVzOEd5S3pvSlUrOTBsazJyVXh6Zk9PYy9oQnVD?=
 =?utf-8?B?dklBR09hcG4rMmlBM1BTemx0MXUxaTNFaUpiMGd5RjBiN0xKbEpWcmdRRHor?=
 =?utf-8?B?cWt5cmI0L1llWFUwN0c4YWRPL3JsZDVBSzhEYzlKaFc3TUNSUlFoNlFLT0dQ?=
 =?utf-8?B?YVZYTTNDcVpPTTJHMSswemVGbnIrTlRRemlpcHMxSTV1aFNBbmMyZXdobG5x?=
 =?utf-8?B?Q0lTMm9vemN4VGRJMXNORkM2OUFXMDVjNk1HR2g4SVpDbUFaejczMkhMR3Q5?=
 =?utf-8?B?Q1B0ZXpJajRhWWpNVnArQWFvZ1prem9FejlRbjAvOU9aaHNLZ2kxTWpXVXVQ?=
 =?utf-8?B?NjlESjdscEFwck9DVW81OWYvcXhZck9wRFdLNmE5RFVQZ0RXMmN0R1Z0b1U2?=
 =?utf-8?B?aE5nSnkvY1lwV3cxU2ZKUHFFYnZGaVQwK1d3S3Y4aU5raE5uMitKSlBsbERz?=
 =?utf-8?B?NGtlWmlOVER3VDZtSnlyZjRGSmxaUktSQjZnTXlUVjVibUlhV1ZFRi8zME5k?=
 =?utf-8?B?VHREeWtJZmM1dXc1MzhvVEZkTTQ0NVhiOGl1UFNPbWRyOXVPczg2SWJVcTE4?=
 =?utf-8?B?d2NpM3J4QXFGZzJCcFNrVzZFNlkzY0tjZi9kbzBNM3l4OWVWaTBWemgyb3A2?=
 =?utf-8?B?d2JjWFNqeEFacmJiVE5hZnB4VmFabWFpSVYwcENtVXhlQms3S2tLQmhCOEVM?=
 =?utf-8?B?d3JleUJSUU5NUnp1TXQyUEk0dzIySDNBY3dENytnOHk0MzJDM3RSWXhSZ1Rv?=
 =?utf-8?B?S2FYeDRMMERQUWl5aytZdFVzR04ycGJvdHB0N0ZSWFlKaThuSTUvTXphMjRv?=
 =?utf-8?B?ZlY1ZWpEcFBmdmExaDFHRTMrZTJvd0ROUjUwcllyS2dMYzRMRHgwSGd1SmxN?=
 =?utf-8?B?NG42QmVWWXlkRFlvMno3anRJbWlXSTZOWEtIZDlpSndaaEdvWVVKUmc2cjBX?=
 =?utf-8?B?U0FzV1RjQ0xPaUQrRGs5YVlWdmdiUzhXaWdJSXBvNjNMOGtSaE93QWlMSnpQ?=
 =?utf-8?B?NGo0U096MEZQMDE1RWhYMlpMQ0JxVTc3VWt6TnRFRGNtY1hvZmFvd3VRSkh3?=
 =?utf-8?B?ZElSS1V6cDQreDVYT0pSMEFobnA4MmpLN25NaDRRRHZ0R00wMnRwSUtvR3N1?=
 =?utf-8?B?UTNmYnpveFhLcHZDZDZKTFh1ZE9QRnN5YXYzRWhGeEhjNzZsSzN2bzYzbTV2?=
 =?utf-8?B?OUFubVRkTFZlNXdzSXJLTDVFSTA3L2VJdEJHZXdoSmY3clljRFN4UEVpK3dS?=
 =?utf-8?B?d1UrcnBTdi82MFJZbWw3eE4vaHVzT051aEVUR3FGL3p0MWYxQUJ0VFFYQ1N6?=
 =?utf-8?B?SVpLN2ZFbWJNdHVmT1hMbG9PTnhWNzd2TDl2SmVEbjdTN214eTRlUlg1SVBw?=
 =?utf-8?B?Q0JLMmdWbjc1UFpYM2lGN1hQeFFjWS9XNTF4UmNFOFRtTjJpcDY2bmxpTUNs?=
 =?utf-8?B?T2l5ZFc1VHFTaTNuanV3bGtxdmZzalFjSUs4SEdaRkVMa0lLVkNieTNXMzl0?=
 =?utf-8?B?V0dZMTRYQ3RiUzVPYW9FamQyUVVINWh3QzJsbHkwV2ZTcUdpR1F3Tlk2WmlG?=
 =?utf-8?B?bGp4ak1sOTJwY20wZlZwTjNZMGF3RUlpQnFMWVB0aURhMThVd2JVcHMyeDdS?=
 =?utf-8?B?Y3AxYzA0U3BmeXZueXh5eFFlWTJoZVdXOGRRWlhlbzJ2M1cxR3BzMnhzQnBW?=
 =?utf-8?B?R2hMOEhMMXlidzh0cTVSMHN1ZTVnMmlrcmU4SGg0Uzh6QlVVSC9vN1BRdGI3?=
 =?utf-8?B?eFBEK1JmLzd5MkRJOXhzeTlTNXRJN2tjTkU0MVRXMEVTdFQ4bzd1a3ZoWGtW?=
 =?utf-8?B?TmF4OVJuL3ZjYlNYbzRKTmlYWmpkak9KNGpTWGE0SU00QldqMlZ1aFdSeTUz?=
 =?utf-8?B?OHoyVERURDdBU0FiZ3FlRUduNENsY3pzQWJhRU52bUlaR3ZWSTljZnhZeEFX?=
 =?utf-8?B?cDlYbUdNNGNuZlNpWlR6TUYrczBHRjBmR1FFMm9OWVNIT1RTcDhtY25FUTRJ?=
 =?utf-8?B?N3l2aGkrYlZxeWg1WVJnMlhNZHpyNnh6OE5ZZVVKMUZ2MmFUZWJyY2IzQUNT?=
 =?utf-8?B?VVNYLzN0Q283aDhTcEp5ZFA0eFdqQllzL2lHZjN3K3Ztc0J3cHlBbHV4T3hx?=
 =?utf-8?B?ajhWUzBZZlRiT0Q5c2lSQXo4RzlqOU5Vc1p2VThuZlQwZWVRUGVyUzlTL0dZ?=
 =?utf-8?B?SFIxekxVMmlnQUhjM1pIOFdEOHM4SDJ2eFd6VHkySERZeVQvVTZlM3YwdjdZ?=
 =?utf-8?B?U1RsSTE0Uk1ncU42Qmk5Z3lSSW9BQlFnSUFtL0xXMFp5K1pWWFNiZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cba0e09-0358-4670-1e03-08def3da18ef
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 16:45:18.1568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yl6iQSEud+8dRzkGBRg9GxRekQ6VUG2smzaLoBjCZWUkRfia63FwylqhFPfVFsSM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR12MB9676
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E894D100017
X-Rspam-User: 
X-Stat-Signature: sxfxqnskzw3sma4ea1se6f4k46uxjnzh
X-HE-Tag: 1786034721-673702
X-HE-Meta: U2FsdGVkX1+GhwyUVe1gRapeLORef0PMLFl7IhvNSOkug3a05y6qIUeFm7IMTCVE6nWofVMWXB+FkFQ9gNGwryUBhN6aXpUSoiGGVUGWjs6+D4z++AJ8F4D6Qd0B09zUCHECwB/ZQt3jmNC233r6mvdjYm1hGbrudC7CnkV47eTvIOpKxLIGFYoGxF/ZKEuY7ldDfYl8GM8ZJDoDLsVjcH6pZVzj0s4Qh1X/cluCX33QdKb6P0CpMLqP1ZmdL8zBFw1iQWyXJxU3ZZ7f8clsZ9gIJb5pMPuql6vVzXTH4o+13K8qvf9Sw5UGbEmK7h4CAZYyW5zE/3h/K7I+fNoyWvG/dIZftGA9nXK/B9CsnQXnCCeM+DObncScfeyu2KYGKTPa4c+aJyjoI4KMp/sF0ynay7Kybv3YfNFjEvyHOTywkfbd++MZ1t61DVSw5CqVAKr0rvgD1as4a//JplAopmJ3NcqVcxEItuwt89r+jU1GfLMtzGgiSWxVBAZaQad5ksIbbI5ZaS9oI9pLJ4DBbGvDV6iCDk/3OgTh1eGio7ogOk++oUjEgenMKBqM7g8TugIaKw18uugk8PP747TLVyXcYbU/3AOkL0endMy1s7/00EKWr5nMmxjw0uZJ4hAwEBuH+Epf5ikFmwyQjj4HZPkmYpai4yo5+fwQgzySjQQG998724sqhx0FF9nDDzc1v5avQc7tOTsl57bPhUiuKB3F6KU/DDObgULrwVsvqwALJg/Zm3IXufMwt73dZJWYt3JqKs550M+ICP9wZL+MdUp5wSzeSKe+ljswDGqGyXmX2LaqsD5Or3+erBk3NO7cM2yL/kmjRngcZME5dq+P/OwRNr2+DU8IKy7BIrV+pKWydUYu1WZYYQwcRWOyMK8FjUucinNW1fzG2TT1gJb78025ZGYcOuYSJvAXmYq5n6q/CkkS7lGBhmtYMfq7VOeBXvLRYFLQxHd5EbMdNI7
 rVeHWG1+
 R9Q5isjEahDBJW0yfzPiL6i5KhjLKjWgCvc5Q5b6anRaYOgOCWszS55ObRv3XHd7X+ZForgt3+AG4FKPFHLMviinafiCOllujtppTufvc94hbLjfywgOz6W4eY9nRIPzAWt7Bswu414JwyzWMuDl1xvYDq/3A1fCOAEGpi0Ze0cuPt0+0gKuxrsyylgJP/WCUiMFjU2GJmzrgmyQM8UaJEEJ3y+oliDHtqB9seCoP9E0/CBgLECvwjIUhNT+zwk8E75Vq+7s5XKMW66yD1FZx6lYhsSYMClRZMjlKWtjfEitcdgSfB4p48ZBGyyIWVtEETKMxztZKwO/EEyFzZqn1Tro1Esb0iIoqtW+/rPn6o98Tt3P+iTHC5WVannz3h+BAaPq7WBBJVKhXYows3WN2wYphZRZFWG57E0T+wkjBckesD1DRqN75q1/vFph+mr52uUZ9F5i0l5v6U4Icm9DQxtCm1Kh1YzskbFOE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 04:47:07PM +0200, David Hildenbrand (Arm) wrote:
> On 8/6/26 16:42, Cédric Le Goater wrote:
> > On 8/6/26 16:28, Lorenzo Stoakes (ARM) wrote:
> >> On Thu, Aug 06, 2026 at 04:26:20PM +0200, David Hildenbrand (Arm) wrote:
> >>>
> >>> emdash in a code comment?
> > 
> > There are quite a few of these in the code in fact.
> > 
> >>> Then I spot
> >>>
> >>>     Assisted-by: Claude:claude-opus-4
> >>>
> >>> and really have to shake my head.
> > 
> > It's a one liner. Good enough to raise the discussion no ?
> 
> Just to be clear: Unchecked AI slop in any form is making my life
> worse every day.

I think eveyone's life who contributes reguarly to the kernel.. The
only ones who seem to benifit are people doing drive by patches!

There is so much more harder work on the maintainer side, and it is
now even harder to get patches picked up on the submitter side.

Yet responsible use of AI seems genuinely helpful and quality improving :\

Jason

