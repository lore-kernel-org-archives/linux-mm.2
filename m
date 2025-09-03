Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7985BCA1005
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 00:50:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C6EA8E0001; Tue,  2 Sep 2025 20:50:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 976C46B000E; Tue,  2 Sep 2025 20:50:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EFE18E0001; Tue,  2 Sep 2025 20:50:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 688EA6B000D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 20:50:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 03E651601FF
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 00:50:43 +0000 (UTC)
X-FDA: 83846108808.11.E27EFB6
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2123.outbound.protection.outlook.com [40.107.101.123])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1F975140006
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 00:50:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=lpv0qTGa;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	spf=pass (imf09.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.101.123 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756860641; a=rsa-sha256;
	cv=pass;
	b=pomVdQQFHkAA4duOrxd1f85BW/gU54/8ZZ2zVNXI5EolI1wnlOQbl/8zU2QiTSAQD9eFy0
	RdWFrhfWlr8aJqYjWf0DRL3LwXo51w+vm/ZLK8HJPmjeblSTz6snKrsB9OC7MieRxF/02H
	gc/WHqjuFTk999JLnalf3vmpJIGSOQE=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=lpv0qTGa;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	spf=pass (imf09.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.101.123 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756860641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=95XfnWx7t/4d8J+7Mrt629jxiJTguJAdFa2GliEpD2g=;
	b=4ajo/Sw7VS033W2QNq71A5wlnbKz+YPHfj1lcA1A5fWXHeQsPKTVadbzGsY2j243yOsJkb
	0xrBg32vP9lRNMv62Su/C3YxASXfrAGsTlpGwd1O8J/2sK1s6z2ioKOzGhqyKl5TxiWt+8
	vz80awCtu4mri5ls1/e+2+4xiwvMBVo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OOKk5BtUWphMRglEdWQdmZAVHLjB6Buq0nJn2LDB2XNuEFrD4ezwqxGuQb4sjxYdkP/4iGVOVi8Fbd00GafQ1+tzkogUJkURk1QLYpLlW0ZhrJSDL5AzPq64udezECXlISNajzBp8sbok5iHf0uBktDJxiXEiFVx32ztr7BzKUZCn2yhorC/lMj6AR52AER87Oi2RSLB3YD7VydD9xLTXm9yrfO0UR7Y8vEf2FL8E4N+FOWT2Pllanl6F/5hem6k3Ys/fK4k7113LLnd9tOZGH3FD1dDfbaMeddYsNUYvJiP0QhsYrQuvXYubrMhpO7p9jSfq1SRpxm3R0DzejYBUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=95XfnWx7t/4d8J+7Mrt629jxiJTguJAdFa2GliEpD2g=;
 b=tZyvqpCHIIbn4Gjip4+nvTORWFA03XTV/hPFj2mvHPp9yDDBKgk/KxN1wiuAbPGJRG2O/FIMGck9Jx76aQuDMNGIAPMW0fPUXSNJBf6kHNQSUtcLluQCSAHRF4pb2WVJm2i8K9AL/hX1Z73y6YLvqK2hxqDFc1l//KDweQCSTGIN/ukA+9kW9KAFVg8E8Kp8QLt5aLundAxD36eYAMnBK3SbnlpU829N8Qnc3hvvrRIfDelbZdBvOkQKtVPWoVWpcUija80HELqVqUkfzXoSKMVMqNh8HMQKD0rNG7UzTW2HNKMqhDLrSdEWDFKRExgO+ucc0AJ61gVq4QypyHYD3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=95XfnWx7t/4d8J+7Mrt629jxiJTguJAdFa2GliEpD2g=;
 b=lpv0qTGaMAIA+KjiA92S03xUF/eVYzvI6eunL/EuIjCkS+NIELDrh9GVFtYdR5c0cCf2A5bQRGsL9lvF4p4iXvKg6p2H6OoJsxOOKi99T0wGk4cP+swuGsvlCJk9YC85OmIFhb7amEKrB9itmpr8pqiNzwkNlMNHgTxts6aVJe4=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 MW4PR01MB6322.prod.exchangelabs.com (2603:10b6:303:7e::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9073.27; Wed, 3 Sep 2025 00:50:37 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460%2]) with mapi id 15.20.9073.026; Wed, 3 Sep 2025
 00:50:37 +0000
Message-ID: <612940d2-4c8e-459c-8d7d-4ccec08fce0a@os.amperecomputing.com>
Date: Tue, 2 Sep 2025 17:50:33 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/6] arm64: support FEAT_BBM level 2 and large block
 mapping when rodata=full
From: Yang Shi <yang@os.amperecomputing.com>
To: Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Ard Biesheuvel <ardb@kernel.org>, scott@os.amperecomputing.com, cl@gentwo.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20250829115250.2395585-1-ryan.roberts@arm.com>
 <e722e49a-d982-4b58-98f7-6fef3d0a4468@arm.com>
 <dd242f5b-8bbe-48e8-8d5f-be6a835a8841@arm.com>
 <aeb76956-f980-417f-b4e7-fe0503bb5a2b@os.amperecomputing.com>
Content-Language: en-US
In-Reply-To: <aeb76956-f980-417f-b4e7-fe0503bb5a2b@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CYZPR17CA0021.namprd17.prod.outlook.com
 (2603:10b6:930:8c::26) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|MW4PR01MB6322:EE_
X-MS-Office365-Filtering-Correlation-Id: c0c65bf0-aa70-457f-03b0-08ddea83e5d5
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZEZUWHpoRnRLWVhWaUhpdlE5VmUrcnU5c3RIRFNjSXk0U0dvb2I5TWxBTG9D?=
 =?utf-8?B?MVFieW5SSHpUNVUzZFZsUEpVTEhmR1RXcWI2TG5lUGpMMlR4d1VaSHZORi91?=
 =?utf-8?B?WCt2NjFVZVlpTEd4ZVpqNVczUGRTTktKWkJ0ckE2OEw1NGJWTGE4NU0vcFdw?=
 =?utf-8?B?aU4wYURaclROWG45TmQ2Tlozd2ZHUFZmSWMrS3MyeTg5V0xDRzRMRXE5ZXB2?=
 =?utf-8?B?NXcyVlZPNW45c0tHY3Y1cXZtVXdpb2QzWS81bFg1dC9jOFRwWEFIUUVYREFl?=
 =?utf-8?B?ZjB5VktQWnBkbEZyOEpCaXliNkdZZGFIKzZyTmIzMkt2dnUyQjFlcFl0OHk1?=
 =?utf-8?B?RCtvY2xxNWQrd3JUb0UvRWJjdzVmcXB5ckl4UjF0NmM2eXFoMFFzd0JrR0N5?=
 =?utf-8?B?TXlXa0czR2xpMERMSld4TSt0cFlKNmRoZFFTd0lPczI2MGFjalhzYkJCOFBG?=
 =?utf-8?B?T2xOWEtidmlIQVAxa1hJaVZuN0p0SG9PVXJnckNhekRvSjZOVHAxdE50Wm1E?=
 =?utf-8?B?eDVmRkNac3NNNjA4Wm10dU96clcxTHZNUk5qZHFvbVBZTUMvczR1Nk5RZmZy?=
 =?utf-8?B?aGVneHF6d1VzOUEzdi9ISndESVFNT2l1OE4zZlRZdTMxL09JZ3hDL3dvNHE1?=
 =?utf-8?B?S3pLUXpTYjNJMHBUbU1DMUZHODNQZmJ4ZXFXRXZSb0lUTzhhWFp3bzQ0K2dr?=
 =?utf-8?B?V0I4aWhOOG0vWnVnMlExSStUcjdEY3pURE1wbmxINzREWFlteE4xMXFMZFpS?=
 =?utf-8?B?WjFSYTlMMWpkSFI2ZHhCZm9wRDRuZ0Q4UXl3eTU1THBOSWtYaFJUYWlvdUpa?=
 =?utf-8?B?TlFLUkdBNXF5RFRZdTFVVDVkUXZndGZSNnM3R3RXSkFJWEg0OUdrR1RoN0Ey?=
 =?utf-8?B?b3VFbmJvZitJZnJzMGFyNU9Bdk0vakF2eDBIZ2xQaE1UQlF6d2tYZG5nNmd5?=
 =?utf-8?B?cDgra0R0emtVVVdpdnBmb3FLS1lmb2Zqcmp1RUZRd3Qyd3lHcFMwZXpzcytB?=
 =?utf-8?B?MWkzYXFPa3lGcXZiRUJpQmpUOG0xOHBVSU9sdmFEanZ2YW9MWW5CWUlyeVdm?=
 =?utf-8?B?cUdKWDdrTUJsZUx2YWJoVU5DQVg0T3BDV3AzK0IxYTZQM0drOWtUSkFDZnM1?=
 =?utf-8?B?VkpIeGZWSHhVN3cxYktMWXRZaDFjc0ZRSmpFZlJpcGl4ZDRYWlUyK1Bhdktn?=
 =?utf-8?B?Z1FlVDVkWXBFaUlsOUdDRlRYR3NoODh6bnRPaVYwNmZ2NFVyT2hOMEwwMjBV?=
 =?utf-8?B?a2xvZlo1aFdubVNYUFhsZEVIWnQyQ1Z3M2pnL2pNQzROK2htRWhFcW9qbnRa?=
 =?utf-8?B?SGx3UVVrVjVCZm1VcXgyQkl6NVlra3hoV1hHMXRBNVdoL0o5SzRmQ2FQVzdt?=
 =?utf-8?B?TUtycVp4aEVFMjF0Q3ZuTWNCUG41VWJQdEJyczkxT0pqc3EzRCs3aDNhdWRs?=
 =?utf-8?B?MDR3RjNGcUZDQ2w3QTIyM0JvZjBNanMrODZqYUJZWXpRWlVvOGpmdzJBR2Uy?=
 =?utf-8?B?KzlzMnlZMnhLU0RSK0VxVVJTU3ludnpGeTlQdy9Ha0xVcXpTdHQwK0tsRDF1?=
 =?utf-8?B?ZjlPZXBVTmtzeHBUUDdtNTFJQjJkVVAvSHNLUVViTW9TNUVGWmhEYXFYNjBN?=
 =?utf-8?B?dENCWGhjN0JlTG1ldndhYXYwalVPMnkyUXJkZFJHdEZvUExuTWtlSGpKZFdw?=
 =?utf-8?B?T2p0eWZybVNxRWNaQmhrN0tqcU1vVGpZMXRrSCt4Y05mU3dIVTZTdDFXUnQr?=
 =?utf-8?B?Zmx1RWp0N0V1Nlc5b3h2cTNRQkpJZU1STFRYM29rdGxOZ1F3cEsrWEZDQVpj?=
 =?utf-8?B?WUE2aTVZbHlSeHhhUklMd0Vsa29xUGt6dkdNNDR2YitYUndVUkowbXVzOU1S?=
 =?utf-8?B?cUgxSXcxOGRNTGlHTGV5TjRWTzFpWUo2cWthM0hnNXVCV0pZWW1FdEpjZHdR?=
 =?utf-8?B?UWk3YU9WQ2RJanVtVXlFK3pPUTZhYzJzN3ZqaDlZcTNZeUNpT3JWc2toVVNJ?=
 =?utf-8?B?UXptNDhRLzdBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VzNWc1lyYXFGTEs5QVVXLzYybzBERUZKVFZ3aXhPTW0rSi9pUlkrMXlGcS9E?=
 =?utf-8?B?QzNtdm9jaUVnN0hrbDc4ZzI1ekpFVlFXMHZOWXVoOHZic3pQNktmalpXT2VE?=
 =?utf-8?B?bnNwTVBZL2hldXZvTkJqMk1VRXRWYjE0SmFyUDhrVUtxK3E4QWRzNDM4eVVo?=
 =?utf-8?B?R1RwcmpPVUhCT2xlMWxVNGRjZnMzUjBDZDhkZDZQY05BeFhzLzJUZWZRbEpW?=
 =?utf-8?B?Qkl4N1kwajcvVXo2R01yWmtWcWlEenJVVUVFZkk1UHU3eUFsdGNhMUEyTzFC?=
 =?utf-8?B?aGtCb2I5eVFZdUpVNUhucFhVdXlkRGFvOUY1emtLeEthLzE4R3ExRGs5blZ0?=
 =?utf-8?B?T3Q3SUVvdHdCRW9ZT0lYV3crS2s0ejZCWTdtc0NsRnpMZS9IaTZPNjU1M2lj?=
 =?utf-8?B?U2NOWWIvVUFtNExNblk0dXI2ODJPNUtmeWVVbytPcXJFR00rdWZUSmEwUlZ5?=
 =?utf-8?B?WEp0Zjl0VnpZVUtIVEdVRlkrcndKaWhWTkgvQkRKN0xhU0FaVDBQRGtHMnhi?=
 =?utf-8?B?STRQVStLd2J0Y3FLMXBMcGsyOVgzcjBISE9KdmJjUStSM3hubVZydlBJU1p4?=
 =?utf-8?B?ZDVXdmxQYXBaOWRtTTllN1BUU3hJcVRJZUg3cUNhMTFEOGd1VXdlZ2srUFdI?=
 =?utf-8?B?bXV1WDZ2NTlWNXRBc2pKYkYvT1JscHFtTVVBRWJ2TElyMldKckd2WVZKVDNI?=
 =?utf-8?B?dEwyaU9HRTBzWERxWnFiUWVWZkxkNXVoeUJldmpFNFFLMk9jcW1GWEViS25a?=
 =?utf-8?B?bnZ2Q1NWdkhTUjFXTk1DNUVCR0MrUE9KdTZvRVVZOVhwWTlNOHlLOWYwQTZn?=
 =?utf-8?B?S3ZESERLNGQxM0dHcW5qSjdHL3lZejdrZldiNkUyMThHVlpVZ2pWWENXMnNh?=
 =?utf-8?B?dms3ZVRtMmdUS1QrQ3RmYzRQNThzbEhSY3gwYzJxdFFiMjVDUkZ0UXlXa2tF?=
 =?utf-8?B?ZkF5bVQ0WDBSQ0c0WWZQRkpWV2Q3dm5pQy9EYjNheTJldzYxbElsdnhMMm5I?=
 =?utf-8?B?TjBxSlZyYWJtSi9HTlBwc0JPWFZHRGhXbTJ2WWV2bEZnYkJ2VWVTZ0kyTjVE?=
 =?utf-8?B?SC9YR05WNlRYZ3JOSUxpbmx4eitwbVQ5cVlHR3JPQkpBVkhIMzJhWEt5T3M1?=
 =?utf-8?B?VXd3bzBhcStOYVF1c1ZweWxsdE5pZWFQeWErci8rbGRMemdLbCsvT21CYjY3?=
 =?utf-8?B?ZDkwTmE5ZkxOeTBBOWhqMnNQWXRCQkM3djd0ckxweDFUbkQ0dkZrWHJTSHJL?=
 =?utf-8?B?LzEwVDdLbDNncmphcmpwNjY0UXJpbzRkUng5RzVZd3pwU3JDbG0xWkVJZWpP?=
 =?utf-8?B?clZ3c1BWMFU4MHhUTWRTNmw2ZVZHcHU0VTZ2QnQzcGNybXp3WUh2VTYrMXIv?=
 =?utf-8?B?YU5hV3VKK0NWM29wditzc2ppNk5KVGlqZWY4VkRLanpSMVQ1aGVMNFlmRzRD?=
 =?utf-8?B?VHBJeG8xNlF6cXZGaStRQS9jdWJMbGh6RXZWUXljc2pVRnFvR2R1bUtocnNG?=
 =?utf-8?B?VUxuamV6OHZKd1FIaUY1MjZUcVNwYzBDNnorQ0NTWXdnTlljMzVIblhkUHFv?=
 =?utf-8?B?MmI1RHZ3ckR5bU1FemI1RloyN21mZlhoY0ZBYWFtdHNJUy9lRGJQblljbkZo?=
 =?utf-8?B?eG03MnAwbmtBMnEzb3ljVHhQT0t3M0pVeURkc21GeEhURmNJWXFwejk2TkJX?=
 =?utf-8?B?YnlqY1lrWTRjdEgvRnVFU3o0SndPUVFnS2lKS24xa3JlVzBVcnN2ZGx1bG8z?=
 =?utf-8?B?UHFiMkpCakZRUVNQcy9wNnMwUE1xcVBYVnNQUC9wblZMMXk0SUNOc3BzY21W?=
 =?utf-8?B?ampZYWlMWGUyYThkRloySGxnS2IrVG8rS2Y4bzNrN1lUSkFjdkc5cDBCbk0w?=
 =?utf-8?B?MlcvY1dzWm9NY084KzFUekYwY05wdkRicklkU3ZwTGhTaVdqNDdKZG1SSDh6?=
 =?utf-8?B?YllETmRXUmloRzJOcXRybkRBK2o2dEFmMTRKWWg2OW9uNlNDbGlZeDBsMWlj?=
 =?utf-8?B?TzVObGRxR1JKQ2lEcXFralc4UUg5VlR2RXR4TE9WUktpYzNIcWp5UzhjRFI4?=
 =?utf-8?B?ZkdFQU9IUDNNb0VWUHdoRkY3L0RyL0xUcWs4cHBrSDE4dW0zeVBsVEVRdUR6?=
 =?utf-8?B?cy9WVU41TzFyd1RnNVJPSXVlUUQ0WTZvVEJ3c3ZwVlR3eUJUQmxHdzBuSnpu?=
 =?utf-8?Q?etrRJZ+tzCiaq1+EKaWOW+M=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0c65bf0-aa70-457f-03b0-08ddea83e5d5
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 00:50:37.5859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kgeLJ4zailIMo7J2bfKJkG4p9+8hRqpS9Pluc06Q9r0LFh76WZhbab16GxbaQEN4Fz3HU5nAQ7fItG3vjV0sistXteDtFUEuCuo8CN287Q0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR01MB6322
X-Rspamd-Queue-Id: 1F975140006
X-Stat-Signature: qqkhektxhj8jim1f8s4d9geh673h3c77
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756860640-945804
X-HE-Meta: U2FsdGVkX19qd7RsfPn5C2SPzEhzVyjFrRf2S4qzmMEbOu6ABdge5ylCj8pRiCpb/cg8oEdsSRc3Hv8U4qEm8Bc08jp3pHeQLpuq3ON5c/TIFK9RM1qK998JFy8QclJd6j7FiswDG/4zTmXsoexI8pS1DloCD3EBWj1zgpmV6A6inPmtmYrrcxtTldbINmbUnNj+8xI6wZSIvtmVmhQNWfh6iqSomEpU2bRr+kJleqBHZQun8aYGce1FhkAxlV8XYBVTIofljj9B5tWjgTdKf39rGfux0uQSJgnor1gCM+pDMH4rXz+6IRUDElJBzmRkmEuhPcFo6nGtDb9nxji4hV8EzIDOWDak7EoDbeReUaZt6a/sWNjVKpcWr2auagLl9Y0rjJJvSWYdr3VaP3uW/IkNuQfN2voR338qMkFyF4mTt89cRMA6rRGn2eA55Zhczoo+rZ3xyE1Ea6YLVgLyOVn0WQODmc9QEYM5L3SWrzy1HB2CtqUXZ9ROhjPAtPIQDPgUZcyyS5VS/cz8Su14wjPvO5Nve/Q7NcpPGMVp0sKX5vn+m76pxUslDnt+e7OkbroYtHz+KzL3vHLOzx0tQVSdtLEsqoA8uhVjnzLjJ5p10kIyJOyQJFW6k28QL5k1x4cDeeX2ea7OKVPYwcpYtxEd7OnljHhB2GznKxumlIJ4iC71mr/W7rkrRXbtiEQxDl7eslDcTOJ4e8JW3nFjfna1uGRvvELXuAv4yoKxAA/zMxD93044T7/qhyW5ybCq45ZgzcKP7JX8P65b0ws9CJBH7ZRhuILbOMi7fV0q1e+TIZ+UeeqiqBW2wwr+FB+JLlJ1SikHWVMa1mq5NxNZ5pEhGgud6N0A8c/Ym8pqE3EweiINeJliyDIV3BaTLCbEu8KaWUXnpfv9B/UwIUXJ5l32jHVVAq3QycMFYLpNPl8Tm8XRWfFfI9cy41etciAfd+FL85PmXVWcz4k5FEg
 p8caAfil
 Uj/F1vhU+qt1ZRGgIBT3b/DWZLSC1awHwjb+TNr0KiEUrNUEgGjUb3Z5ccBhKvpXmNR2Cha3gPXv+0egip7MaypFgQBxf4h53M9Ighm/5UTB+STePhZSQ1bqb0OPmPc81WffoQpOYR2usjBkPg9UhRw5Grn22t7TC8pDANnef/nJvoOCe+txfLM99vzODFJmk57fDK8y4t+n865uHY3N1RRW92neY58vrg9tE0Z+6ZivlGwzBsADfwheV5Lv1kOJfOPWLj7rCOTGpW5yYP34rXAT7tZlGZrA5sQYdtQFgZYgFjhzWGc9fiqBDNmh4BqxBni3+QqZWFqZnzrouWeKv6WwTI7VXT2oH/DASVjLLfU0DIqvo+JkDgFKKWcreWi2Mhq6eeuK6ke4hMM9I6MvZN/807G9Bx6YENPV2wxA2UFp4Qoo/T9Zdd6rwDyQROWrVo5Dc7zVOQERsAdWDJXbOhDAxdyM7rkG350NDelTJM+Fb8MWyCWZqDWGSK8LP37bnan87EHP8dH6W1XugOJXWq13Z8vuf3wZ63Qq2+ZPGePoakY2mNiXURMZssMXO7SRQhxGLbWMNh3MkrSvAwtiLZAL7iVxr06rmYZiViLUvZw66zYWzY6VXMQbPfufYsYf7HMOz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>>
>>>
>>> I am wondering whether we can just have a warn_on_once or something 
>>> for the case
>>> when we fail to allocate a pagetable page. Or, Ryan had
>>> suggested in an off-the-list conversation that we can maintain a 
>>> cache of PTE
>>> tables for every PMD block mapping, which will give us
>>> the same memory consumption as we do today, but not sure if this is 
>>> worth it.
>>> x86 can already handle splitting but due to the callchains
>>> I have described above, it has the same problem, and the code has 
>>> been working
>>> for years :)
>> I think it's preferable to avoid having to keep a cache of pgtable 
>> memory if we
>> can...
>
> Yes, I agree. We simply don't know how many pages we need to cache, 
> and it still can't guarantee 100% allocation success.

This is wrong... We can know how many pages will be needed for splitting 
linear mapping to PTEs for the worst case once linear mapping is 
finalized. But it may require a few hundred megabytes memory to 
guarantee allocation success. I don't think it is worth for such rare 
corner case.

Thanks,
Yang

>
> Thanks,
> Yang
>
>>
>> Thanks,
>> Ryan
>>
>>
>


