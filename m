Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 258EDCA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 18:31:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8687A8E000F; Mon,  8 Sep 2025 14:31:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83FA48E0001; Mon,  8 Sep 2025 14:31:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72F128E000F; Mon,  8 Sep 2025 14:31:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 608908E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:31:47 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EF82F5797F
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 18:31:46 +0000 (UTC)
X-FDA: 83866926612.08.87AC6A7
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2132.outbound.protection.outlook.com [40.107.92.132])
	by imf01.hostedemail.com (Postfix) with ESMTP id F1C0040009
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 18:31:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=TvvE0CC6;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.92.132 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757356304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D5QKanoLrKsh2xaoqXJCcxfLzITKXthPVBxmIXcU6sI=;
	b=3u8uiUp2Vc8eq7N8u5nmRqf5NL9mJJX8gGA/xpAx37yGrbPCu+nlhAvXvbwJXdLiEamalF
	g9cKGfVoI2nvxfqtQHLCKVs0GqwO82FUulp5UOekTr62K3jzEfZbjfrPOZIO56vB6hwLVX
	+wP6/KHWOMKRYFfhQ0eFV/3oMUf0AU8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757356304; a=rsa-sha256;
	cv=pass;
	b=dYfioNghfLWQUMQON3Joyu+oTeRTZfSml3xE0dLPKGFtK9/9r9WO2aj05lB1YZxyClwM/x
	yES9PYR1rFTojhEFZXqTqZuwx3mc23pOfISEAqqPnnolHstb88AoHBnZTYRGoiMvfRIYYJ
	nXVorf6fbRoo3lzO4wyIwuJ//TqZbqo=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=TvvE0CC6;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.92.132 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I/6VuiQhcK8zGmaWiYqsiBBqqve7QY5YqFrMV14ubY8/Ai474PoGST6HVOOXcE8MniL5zeMUr3wgcDuy44YzZzhXkKwF9ufyXCjz748Hi9xZHFJ+kPXX/BHPrT31je/2L4Fx7x+ZTIpH82LmqhIebyFEKiBH1a4HLZ5f/u5Yv7sP+LHh+q/fWiGOwH1PASbOzYQluLrcMCAwdYLUoXFB3zKDLCWhkzICbd/nk5QV76jCEMmM1cpGbYTLRTiGz9AjFwoIRZeycDW8rSpMK4f9MsB/J5GyjRMHfdWl7K7wxr4HI4Dq9685qUL25/pX3xGSLBuXbySjPMI7Gfpkqz0Yqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D5QKanoLrKsh2xaoqXJCcxfLzITKXthPVBxmIXcU6sI=;
 b=fJqiJtAluZLN/TTdmJMalgtSX1UaRt2tBS5yzCK/tuv+WG5gyXBmxEN+WVX/xOdFd5lPSTsFl3Je1mSzmb1Dc4zn3e0n16Wf2ThZpTKRocf0ukHQayr7D8Gq5/bT683KNk8Pz97hfvjm/oSmDelMva1L1YgiYBCAqUNSFWBHaOz+BwcFhejhsBZLTCxp/9CqT23Zp4jQnyVHH9AO7P426YiMb+NxEVJXMRqDLkb7IDmhdzWhdZ+AtW2PLFEEe9JPBMaDoL3/y7tEi4ofRdR5FU8qf4fEokU9L7i+x0Nv6FwJVKonA7K1Z9kwOQJM/qmwrlWXifE4PEFP3Hp2tnw/9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D5QKanoLrKsh2xaoqXJCcxfLzITKXthPVBxmIXcU6sI=;
 b=TvvE0CC6Ky90V/fWg6RpU36r5SfiYxqemtO3mx1fZknRHiuSwhHSKp6zrXFUF8RtyztP+bCGV1iUAH5tcRDM+4Drq8gkgWzr7Cvdnwxm3RRwdUH7XzhyfbnESdoAc/aQgGCc/bv7aRpUTWgE1wLwnAGG9++VkmKp9+y2dE0s2iM=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 CY1PR01MB9224.prod.exchangelabs.com (2603:10b6:930:fe::5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.22; Mon, 8 Sep 2025 18:31:41 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460%2]) with mapi id 15.20.9094.018; Mon, 8 Sep 2025
 18:31:40 +0000
Message-ID: <fe52a1d8-5211-4962-afc8-c3f9caf64119@os.amperecomputing.com>
Date: Mon, 8 Sep 2025 11:31:35 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/6] arm64: support FEAT_BBM level 2 and large block
 mapping when rodata=full
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
 <612940d2-4c8e-459c-8d7d-4ccec08fce0a@os.amperecomputing.com>
 <1471ea27-386d-4950-8eaa-8af7acf3c34a@arm.com>
 <f8cf1823-1ee9-4935-9293-86f58a9e2224@arm.com>
 <bf1aa0a4-08de-443f-a1a3-aa6c05bab38c@os.amperecomputing.com>
 <39c2f841-9043-448d-b644-ac96612d520a@os.amperecomputing.com>
 <d7cd4004-bacf-47b0-9cd8-f99125e02238@arm.com>
Content-Language: en-US
From: Yang Shi <yang@os.amperecomputing.com>
In-Reply-To: <d7cd4004-bacf-47b0-9cd8-f99125e02238@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CYXPR03CA0012.namprd03.prod.outlook.com
 (2603:10b6:930:d0::11) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|CY1PR01MB9224:EE_
X-MS-Office365-Filtering-Correlation-Id: afbd7f26-846e-498c-4aeb-08ddef05f41c
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NjA3WC9nMlNPNk5PdWc5cGM0QWN1U2NtanpQRkc2TU1Rc3Fjd0tFaFBMQUpW?=
 =?utf-8?B?SVJobDJMQ2JLNUFRREpudk1Jd2RJS1FCNERtWHBuWWttOGY1ZUVIYzZZcFJq?=
 =?utf-8?B?Y3AxUlRRamZBVWtNVUR6aE94ZGFTVzBKUS9Zc3NFaTNabU1TMEViTWo3bmJv?=
 =?utf-8?B?VEtZM1I1ZUdPMDNrS0lTdjFjVEpaU1lBRVlYeXdRaUR2K1U2M1dKaCs5eVd4?=
 =?utf-8?B?Z2F4YzhyNHpSRXBiU2tiOWxPbFFkbmlOaWs2ejJlLzN1YXZwK2tYUllTbVpj?=
 =?utf-8?B?REVHY0wrT1hiRnRlYXZvUllLcWptM1puNlFRdkdQZXVLUnVhdkNTdGpKRUJZ?=
 =?utf-8?B?enI2ejBzbU9vbGxDL3lXSFBBZDh5RzgvcEMwdXZ0UVBkeW1TZ0dTRERnTEZE?=
 =?utf-8?B?UEg1cVNEWnFrQVN2UXN5UnExalRsaGJ0RDFab0d4WCtBMTZTYU5pRGN0RTd5?=
 =?utf-8?B?MGtHTDRiMElHZjllUzFPV3R6NmljTWh1UlFHbmpXdllra000YkREUWZOR0p2?=
 =?utf-8?B?N3ovZk9xeVVGcmFIYmhvZm5LZ0hEY0tIM0dSWitQa2lSZHBYcVZwalY0cDlB?=
 =?utf-8?B?TTBQVytUWitaZWZITTZkc1ArZ0E0cmFBWmJKbXVkVVcya0JNaURyT3Y4SmRr?=
 =?utf-8?B?VlRxbVh3SjFYMDRUV0l2OG10OGZ1YWtNdVQrVWY0dDRvb0pMQzFtOEtNbFZo?=
 =?utf-8?B?Y2pFUXkzZTFpcWczc0tQVERXZkMrTHZlb0tFODJhWFhnV2ozTWg1M295WlN5?=
 =?utf-8?B?blEvckJkUERDeUphU0VYRlQxZjQ0V1pHVVkwdXFtSGVwbkJvdGdZR3pWUjRK?=
 =?utf-8?B?dmRiOW10TGl6NWpldU5yNEpNVXZXb082U0d6Z25jY2lWVHZoS0JLYmdpakYw?=
 =?utf-8?B?U3BlZnFpYkZ2T0U1Z3MvY1BvTVNvUVVndmt4N1o1NWZCem8rYnA2N0k4Ukhs?=
 =?utf-8?B?aFZmUzZlVEJEUzNuSmR6WG4zZUVPY1YxUTJjNFVOYkFPMmNFcXBaSllvcUpP?=
 =?utf-8?B?SXhMZlFpS1o1N2N3OGVnNy9WbmJBK3FNWnlrN2MrZWF1ZmJPRHBCMVp5QU5Y?=
 =?utf-8?B?ZnExTjd4aEg3ZVdyY1h3bzNUN1FJSjR3azRUQ24vcXJvUTBxY0srWDlYQWxt?=
 =?utf-8?B?dURVNTM4OWYwamxIRjVhSVlRQk9nMWROTytGdVJpaVVQZlo0cm1GLyt2Njhz?=
 =?utf-8?B?aDVDeTB2cEdvWlZlMHRxV3o1VzlubVBFWEl2YlJRVFM4ejhTVVRNbVBvNlFl?=
 =?utf-8?B?aU5jZ2ZzNlorY0VnK0c1ejJIb1BMYS8yZmgxTHFmNHBOWE00SjVEOWEvaU1k?=
 =?utf-8?B?OHVQTTdRR2cvT0pwZXltRnR6N3pDNll2NjY4MkRWU3Jxd3FrQXNPNVRrYzdo?=
 =?utf-8?B?aG5Ua3BVczAvaEkzR2dkRnlSS2U1ckhRR25sVENFOGdMeHdUdFRpUW1LVGx0?=
 =?utf-8?B?bkt3WlN5M1N3MEo0M1ArdkZKQWVCUTRHWExRekRFcm42eFVkQUlpNXRVL2hF?=
 =?utf-8?B?N1NjWDBUaldXakdWRFp6QzIweU5qcTVoTk1tQkFnOXZ0eTRPSkR5YmZ6ZmFq?=
 =?utf-8?B?T0hNa2RlNzNoZnluZW5tQjE4SlVIdUcxZ2g2clJBMC9OVUV2TENOWE5xL3lX?=
 =?utf-8?B?UkhJQlpVb1FyaTVScm9teFN0TXVjeVVyQVRQc0lJQiswY2k2U0w5WGlHajJQ?=
 =?utf-8?B?WUpGZVkyK2N0cDV6S2w1QStJUjBMUndZbjN3MGZybzcxcGRXQ0UxaGlMczFJ?=
 =?utf-8?B?K2FYZXY4dVZlNTdOL2JuMnNzL0N5OGt6T3RUNFJqVCtlTFhISGRvTjFyRVV1?=
 =?utf-8?B?dFQ1SjZ2NFVPaHFEUmNxNUx3dHBBQU4yTnAxdFlEV2dCaGNjcGlJWjBZVERK?=
 =?utf-8?B?ZFdJMG5ZbkF3clJKYnh5Q1VCdHJ6Ym9mT2V2cVNWR3RydXprUnJUcVozTzZD?=
 =?utf-8?B?MCtqRWFjOUkvVjBrV3pyVThoaHZDSDU1RW51UDV4TW5HbU9wTFZRTnJQUnpX?=
 =?utf-8?B?andzb0w2MDh3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MU9SSTc0WjRHSmRxbmFZaWtUaVdGMlhDUmxqd2JpMU5iUlcxVUQwQXhOTnU1?=
 =?utf-8?B?a0U3ZUxkTjMwVy91RHAyWmkrNElxSVRWMnM3K2JqK1Q4ZFBzTUhhTDN1d2pL?=
 =?utf-8?B?ZnpWeC9CSWM0VDgzdHdrVWRBdjFzQzZTd3FYNHdNMTMwTklzUVg3QjJhR0pM?=
 =?utf-8?B?ZzEvTlRGZm9XOVU4MEJxWm1MNkFkaGNxUk5ITkU1SkQxYmkwMGpNQWZFREM4?=
 =?utf-8?B?cmxKanFEb01aZGZIVm1jUkJ2bk9uakhNSXpGRUxacW1WWVNQTGN2VHF5M0ZK?=
 =?utf-8?B?WFpJc0NJeGpZRVZvR1lMSi96MFpzQ2VHYWlCVUJNUk5TQVdrMGMvTml0emg1?=
 =?utf-8?B?amt6VVZQV3NGTk9ZVmc4L1UzTzdDVkplT0xZbVpPY3QyZk5vaWlRR0RLRUJs?=
 =?utf-8?B?UUpmRW1sRzJvbEhsd1hYRXJydjhQZDZCZlErT056WEt5RXRvMHdJUDE3ZTJM?=
 =?utf-8?B?RE9XcXJxakp2bTBqQlNOVS9Qelh3VVc0YWN5T0ttTFBwcnNJOXJaaXhJWk12?=
 =?utf-8?B?ZTJXQzZjMDBUdm1EYXppTnZGU3huQXFiUVVaQlBWbkRTUkUydE4vczZBZXNn?=
 =?utf-8?B?d2JkdVliNGZqYkc4ZTdSUHBKMm9nejl5OStJVXZWMEh4K0xFcVBsZnJOQklZ?=
 =?utf-8?B?TXEvUEdMOEpKNEVldll6UFBoRVB2ZDdONHZwT2djWFV0LzBPRmFoQkFVcFRE?=
 =?utf-8?B?UXIvSCtnKy93eklwWWxweWc3REJHWTRRQTIxRS9HejhvbC9veXF1SXFaK1BZ?=
 =?utf-8?B?ZEhwS3lrbWlyQWUxZi9qemcvNDczaUMzdUo2OUZsaUh0NWVFZjBmRDdTYWNR?=
 =?utf-8?B?bTJnY3BQSWhwb2htejFNQkY4TjVWQzRVUlFQa3dQTFMyNThWNjhlNXh4R1A0?=
 =?utf-8?B?L245a3loYXNhQSswNHJ4YTBONm1ycTI1dkdyMnpmSFVyM0hoRXF4dlFIdW5G?=
 =?utf-8?B?YWZ2YXk2SVdJbndzZTB5ZElLMk90YlJBSEJmaFRLZHlnQVJWSnhlbWpTbjZX?=
 =?utf-8?B?R2Y1UUR0SWZIb0EvZlVXdjlkNUdQQUoxVGlXMGFHRGlGVHNrTHcvdmlQSjFD?=
 =?utf-8?B?bGhuOE0xOHFPWmM3a05qY3BzWnUxUktPdUdtRTI0VElhVUdNclcybkM4RW1I?=
 =?utf-8?B?NU5NVkRYUHBONVBKYmYwRmdnR2c2Qjhid05OWWdpOUdmTkVZeVNNWVhFZnNq?=
 =?utf-8?B?cmJYVEgzS3NwUGFLc2cvb0J0RkhmV2hVRU1TM3NoTmFVaGludUMrbTg0WG14?=
 =?utf-8?B?Q3pYRi9JVndjNExORUxUZ05Fc2ZoK1cvU1hvTHFML1RGazNVWUtVelBMWVV5?=
 =?utf-8?B?NFIveU5weDhsZEc0T0dVYnZWMDNWejhaYWJVQTlqdFA2bXBkNWdjOHo2M2Fv?=
 =?utf-8?B?ZzQyTHE2Um8rajVOMXJrcTZFWExnaTZFSWNZQ3lTbVh0NWhzeitEcC9HSHNI?=
 =?utf-8?B?OXUxRUdaRW42T0V6NFdwaVM1ZlBRV3ljSUhERlNCNFE3SS9objVCWkZvbmlS?=
 =?utf-8?B?OG9rTnFobTVrRjRLcldPMnlWQVpEZEl0U003Vm11WUdrT2E5RlE0Qm11NC96?=
 =?utf-8?B?aWRnQmZLUmlGU0tBVUd1eEhkVjZkK2NoT2NsU25taVh2UXpUc2EzRnd3QS8r?=
 =?utf-8?B?T3huSktjMmZDZjVNSC9XbTdiNkp3RnVLUnJoWnFpYjlFd3RJM0xiVG9vaDVa?=
 =?utf-8?B?MUdHZjhRNmlCQ3dDWFFVUEpTTmVxMktkMld0Q1JTZ2J2Tlp5WWJYdWtLWWdB?=
 =?utf-8?B?N3p5VVcwYzVoZkQwV1RnenBicWNZL2tDZW9ISVB2OUQ5bEp3MDVPVVVjYkU2?=
 =?utf-8?B?bTBzM3hqL2ZWc09iYW9sWllTQWwwU1ZrbHE5WXlYbS8yOWkrWEtBb2Q5S1VK?=
 =?utf-8?B?VHR1SGdlaGJuTE1BajNoZXRicWRmeVEzZVhhcGJXVEx0Wmh1a0JkRWZQUHJv?=
 =?utf-8?B?cE40WFlqcDR4eEgwZ3lKVllsYzQ3SktMSGN5Sk5EQXUvWUVlL056VlBhUExY?=
 =?utf-8?B?a2Z6Wi9mTzZEbEsvS2gvV1k1RzJZZ2hJV1FDNFhpWmpZZWlrU2xqUUNjV21k?=
 =?utf-8?B?d1RFRE9oNFY0RmhSSHovam5XcXYxQyt4bURKbmR2dVpvWHJHMm5KMGxxM0Yv?=
 =?utf-8?B?a0pENlR0d1llWmpJYjdwM1FXUS9UQ0ZnVlVzd0RpTlVjZm1lRFpiL21uWmVR?=
 =?utf-8?Q?zFqXArSf1O3eAYMu3ExsaRE=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afbd7f26-846e-498c-4aeb-08ddef05f41c
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 18:31:40.7811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1h805VZyAqz1LqAIDuM5cLKO8f2riNikI+BKyq6lKiOmTDCcDY2eJjqIh2Ay+JYvHnk1g3Qc/SF9LuxCsc3txgGp/FvCSKEonRLvAjvG0cY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR01MB9224
X-Stat-Signature: xphw8h6h43j51jc7d5akt1co6owmez49
X-Rspamd-Queue-Id: F1C0040009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757356303-736770
X-HE-Meta: U2FsdGVkX1/MnawO9RfyFoOFK46myy2c+4Wv7Dg4P0bXzWkuQ9V+j19cjWcbnRGPgNjro4/EhAC1mDMtqW/++GJaeTb728EOpyXtVrvgCuegnEisq6uAt3SL7BZHuGzlZ5DBFz5VrBwC+u0CO4JCaF5jYxiQGAB3tdfIbYMee18ef21dsOZLVhbz8NBl63miHTTiKmxC7Elp8S0RNv/WcSdVULVAWjOLVskYHr0zg17pmTai4tu9Rt/YV26mCpou9MDHKRVHM13MOjhoKD+czjIbRVcYlDGUXNZwB2uKacMzR4Oc2lg3OlYIadjurx+nWuNbgGl8XrX5U/+iQRbyIS9plNTb4VsDdAr63Pe3dqmOwRO+y8Z/9rCsRyovEM9BmnLU6JN1ibHhydr3PYwM2OFWT0gNRPxGs3yH0eY0M6GnkJ/7kF5aEkUmtcMGnKNG6HI83wSA8zPLVjKZ2t1JOOemjZViVYkZT2sNQvDlluAhDSW1q751VVyrLzEIb0volJbuZ1G5ulvy6/jSa5x123l4Ykcnl0fLAhZ5KxiGhS8+q9LoTDDneCdo7Blpc5V6PJgRHMUbdHgEkNd77EGxJdICffGkn22oGQjKPq77Wi5sLrD5x/vUOtCZs8rsE/9JRzxsl0B6HgymGBykkTs0cS2nEs41lrX39EJoHbxKuUeaxz6Q5wWd18iwMlLbMIKfmhNJWaXuJFjBO+z6D40Vp5C5cSg/sDFCJcDJByyyIoF77b7SFZDemO/UDUi7erhxm5ocBwzl0Y8c98r7CJf/Ryy85441w3P/VUi9Sce42NTNegJHBVoTxD7L8sf6k6bnvAxjx/kFmsiTztNy1lAbOYRpP28rY9Mb/6NNuNpYjBi4u0uc3T94thY2O9AiSN8xd567NiAXEk6zvSWoFWMZ18jR1PVtTNKssnTjc8BEUKfryXHq6rEcGoGp20hy5KccZmXMxGo2ISGzxVlBfn5
 xKDAcXdF
 WUoK9V77oJFDy++cg/YembUOFSPDRY8Reg3iZWty6t6TbEOh5pGMM2ztNYoTRkMa3XCMCNpQ+z7/RgqPbzwCTuBSsKvr+i1mWy0P+JKfDkWrAOT39vKpJvJa/Wsn0Tq/WMokBECnl9EtSJ6xxRCxpTe5hWYi8jZtAfEJvbbReAlJCsAx60znMBomx4a8ZdbOjtC/+4cXfEBl9/8L0lpm0Hb8xhJVyszwjS32Bo49W2zm9m+ByR9Y9FMA7CDqqZ8psZxGGqBHSZJpomvPXJxOYRbL7bjCRENQC2/v9AeST1pjidZ8XZ9C1uiSA6zLqVtmARNVj+taUdpD9BmLbnwXutBwsLEif5oPV12XUsripEWJJnLB8WsN/KNr2GL7G+H8fwaoLgE2i9Ok7wef+63OjcyqEQ1rOeRGImOhMuft0iSeAFj/PCeSA1qWhbJZtKIuXHbYirZTLCn1uHPQ8dEa3RWnJHWs/znAaRjCkJBBI6Ik+5nRNm1rly6TPNaXRz0stntdsYhNQCRkS72OLpSCP78lEjRMWqpyyqYIWud1Ob39NrTwh4AGphR3/J86qBJ4YhjMvG+om4e++m7QcNcCI+rZYzbyPsbsxuukkGNRtYRT22Zpt7Ogg3ZSQYQI6c/oFXPAWc4yT3QOILU4wJ48mCARkqeOfUzyXXO2K
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/8/25 9:34 AM, Ryan Roberts wrote:
> On 04/09/2025 22:49, Yang Shi wrote:
>>
>> On 9/4/25 10:47 AM, Yang Shi wrote:
>>>
>>> On 9/4/25 6:16 AM, Ryan Roberts wrote:
>>>> On 04/09/2025 14:14, Ryan Roberts wrote:
>>>>> On 03/09/2025 01:50, Yang Shi wrote:
>>>>>>>>> I am wondering whether we can just have a warn_on_once or something for the
>>>>>>>>> case
>>>>>>>>> when we fail to allocate a pagetable page. Or, Ryan had
>>>>>>>>> suggested in an off-the-list conversation that we can maintain a cache
>>>>>>>>> of PTE
>>>>>>>>> tables for every PMD block mapping, which will give us
>>>>>>>>> the same memory consumption as we do today, but not sure if this is
>>>>>>>>> worth it.
>>>>>>>>> x86 can already handle splitting but due to the callchains
>>>>>>>>> I have described above, it has the same problem, and the code has been
>>>>>>>>> working
>>>>>>>>> for years :)
>>>>>>>> I think it's preferable to avoid having to keep a cache of pgtable memory
>>>>>>>> if we
>>>>>>>> can...
>>>>>>> Yes, I agree. We simply don't know how many pages we need to cache, and it
>>>>>>> still can't guarantee 100% allocation success.
>>>>>> This is wrong... We can know how many pages will be needed for splitting
>>>>>> linear
>>>>>> mapping to PTEs for the worst case once linear mapping is finalized. But it
>>>>>> may
>>>>>> require a few hundred megabytes memory to guarantee allocation success. I
>>>>>> don't
>>>>>> think it is worth for such rare corner case.
>>>>> Indeed, we know exactly how much memory we need for pgtables to map the linear
>>>>> map by pte - that's exactly what we are doing today. So we _could_ keep a
>>>>> cache.
>>>>> We would still get the benefit of improved performance but we would lose the
>>>>> benefit of reduced memory.
>>>>>
>>>>> I think we need to solve the vm_reset_perms() problem somehow, before we can
>>>>> enable this.
>>>> Sorry I realise this was not very clear... I am saying I think we need to fix it
>>>> somehow. A cache would likely work. But I'd prefer to avoid it if we can find a
>>>> better solution.
>>> Took a deeper look at vm_reset_perms(). It was introduced by commit
>>> 868b104d7379 ("mm/vmalloc: Add flag for freeing of special permsissions"). The
>>> VM_FLUSH_RESET_PERMS flag is supposed to be set if the vmalloc memory is RO
>>> and/or ROX. So set_memory_ro() or set_memory_rox() is supposed to follow up
>>> vmalloc(). So the page table should be already split before reaching vfree().
>>> I think this why vm_reset_perms() doesn't not check return value.
> If vm_reset_perms() is assuming it can't/won't fail, I think it should at least
> output a warning if it does?

It should. Anyway warning will be raised if split fails. We have somehow 
mitigation.

>
>>> I scrutinized all the callsites with VM_FLUSH_RESET_PERMS flag set.
> Just checking; I think you made a comment before about there only being a few
> sites that set VM_FLUSH_RESET_PERMS. But one of them is the helper,
> set_vm_flush_reset_perms(). So just making sure you also followed to the places
> that use that helper?

Yes, I did.

>
>>> The most
>>> of them has set_memory_ro() or set_memory_rox() followed.
> And are all callsites calling set_memory_*() for the entire cell that was
> allocated by vmalloc? If there are cases where it only calls that for a portion
> of it, then it's not gurranteed that the memory is correctly split.

Yes, all callsites call set_memory_*() for the entire range.

>
>>> But there are 3
>>> places I don't see set_memory_ro()/set_memory_rox() is called.
>>>
>>> 1. BPF trampoline allocation. The BPF trampoline calls
>>> arch_protect_bpf_trampoline(). The generic implementation does call
>>> set_memory_rox(). But the x86 and arm64 implementation just simply return 0.
>>> For x86, it is because execmem cache is used and it does call
>>> set_memory_rox(). ARM64 doesn't need to split page table before this series,
>>> so it should never fail. I think we just need to use the generic
>>> implementation (remove arm64 implementation) if this series is merged.
> I know zero about BPF. But it looks like the allocation happens in
> arch_alloc_bpf_trampoline(), which for arm64, calls bpf_prog_pack_alloc(). And
> for small sizes, it grabs some memory from a "pack". So doesn't this mean that
> you are calling set_memory_rox() for a sub-region of the cell, so that doesn't
> actually help at vm_reset_perms()-time?

Took a deeper look at bpf pack allocator. The "pack" is allocated by 
alloc_new_pack(), which does:
bpf_jit_alloc_exec()
set_vm_flush_reset_perms()
set_memory_rox()

If the size is greater than the pack size, it calls:
bpf_jit_alloc_exec()
set_vm_flush_reset_perms()
set_memory_rox()

So it looks like bpf trampoline is good, and we don't need do anything. 
It should be removed from the list. I didn't look deep enough for bpf 
pack allocator in the first place.

>
>>> 2. BPF dispatcher. It calls execmem_alloc which has VM_FLUSH_RESET_PERMS set.
>>> But it is used for rw allocation, so VM_FLUSH_RESET_PERMS should be
>>> unnecessary IIUC. So it doesn't matter even though vm_reset_perms() fails.
>>>
>>> 3. kprobe. S390's alloc_insn_page() does call set_memory_rox(), x86 also
>>> called set_memory_rox() before switching to execmem cache. The execmem cache
>>> calls set_memory_rox(). I don't know why ARM64 doesn't call it.
>>>
>>> So I think we just need to fix #1 and #3 per the above analysis. If this
>>> analysis look correct to you guys, I will prepare two patches to fix them.
> This all seems quite fragile. I find it interesting that vm_reset_perms() is
> doing break-before-make; it sets the PTEs as invalid, then flushes the TLB, then
> sets them to default. But for arm64, at least, I think break-before-make is not
> required. We are only changing the permissions so that can be done on live
> mappings; essentially change the sequence to; set default, flush TLB.

Yeah, I agree it is a little bit fragile. I think this is the "contract" 
for vmalloc users. You allocate ROX memory via vmalloc, you are required 
to call set_memory_*(). But there is nothing to guarantee the "contract" 
is followed. But I don't think this is the only case in kernel.

>
> If we do that, then if the memory was already default, then there is no need to
> do anything (so no chance of allocation failure). If the memory was not default,
> then it must have already been split to make it non-default, in which case we
> can also gurrantee that no allocations are required.
>
> What am I missing?

The comment says:
Set direct map to something invalid so that it won't be cached if there 
are any accesses after the TLB flush, then flush the TLB and reset the 
direct map permissions to the default.

IIUC, it guarantees the direct map can't be cached in TLB after TLB 
flush from _vm_unmap_aliases() by setting them invalid because TLB never 
cache invalid entries. Skipping set direct map to invalid seems break 
this. Or "changing permission on live mappings" on ARM64 can achieve the 
same goal?

Thanks,
Yang

> Thanks,
> Ryan
>
>
>> Tested the below patch with bpftrace kfunc (allocate bpf trampoline) and
>> kprobes. It seems work well.
>>
>> diff --git a/arch/arm64/kernel/probes/kprobes.c b/arch/arm64/kernel/probes/
>> kprobes.c
>> index 0c5d408afd95..c4f8c4750f1e 100644
>> --- a/arch/arm64/kernel/probes/kprobes.c
>> +++ b/arch/arm64/kernel/probes/kprobes.c
>> @@ -10,6 +10,7 @@
>>
>>   #define pr_fmt(fmt) "kprobes: " fmt
>>
>> +#include <linux/execmem.h>
>>   #include <linux/extable.h>
>>   #include <linux/kasan.h>
>>   #include <linux/kernel.h>
>> @@ -41,6 +42,17 @@ DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
>>   static void __kprobes
>>   post_kprobe_handler(struct kprobe *, struct kprobe_ctlblk *, struct pt_regs *);
>>
>> +void *alloc_insn_page(void)
>> +{
>> +       void *page;
>> +
>> +       page = execmem_alloc(EXECMEM_KPROBES, PAGE_SIZE);
>> +       if (!page)
>> +               return NULL;
>> +       set_memory_rox((unsigned long)page, 1);
>> +       return page;
>> +}
>> +
>>   static void __kprobes arch_prepare_ss_slot(struct kprobe *p)
>>   {
>>          kprobe_opcode_t *addr = p->ainsn.xol_insn;
>> diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
>> index 52ffe115a8c4..3e301bc2cd66 100644
>> --- a/arch/arm64/net/bpf_jit_comp.c
>> +++ b/arch/arm64/net/bpf_jit_comp.c
>> @@ -2717,11 +2717,6 @@ void arch_free_bpf_trampoline(void *image, unsigned int
>> size)
>>          bpf_prog_pack_free(image, size);
>>   }
>>
>> -int arch_protect_bpf_trampoline(void *image, unsigned int size)
>> -{
>> -       return 0;
>> -}
>> -
>>   int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *ro_image,
>>                                  void *ro_image_end, const struct btf_func_model *m,
>>                                  u32 flags, struct bpf_tramp_links *tlinks,
>>
>>
>>> Thanks,
>>> Yang
>>>
>>>>
>>>>> Thanks,
>>>>> Ryan
>>>>>
>>>>>> Thanks,
>>>>>> Yang
>>>>>>
>>>>>>> Thanks,
>>>>>>> Yang
>>>>>>>
>>>>>>>> Thanks,
>>>>>>>> Ryan
>>>>>>>>
>>>>>>>>


