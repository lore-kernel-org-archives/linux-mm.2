Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DECF1CA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 22:08:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE5DE6B0011; Fri, 29 Aug 2025 18:08:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBDD96B0028; Fri, 29 Aug 2025 18:08:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A85A76B0029; Fri, 29 Aug 2025 18:08:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9358E6B0011
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:08:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3EF5B13ABFF
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 22:08:40 +0000 (UTC)
X-FDA: 83831185200.22.175AD90
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2127.outbound.protection.outlook.com [40.107.243.127])
	by imf03.hostedemail.com (Postfix) with ESMTP id 46F6820005
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 22:08:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=uCr7+fv8;
	spf=pass (imf03.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.243.127 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756505317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WwxTzfe7/vzr4O6TN8SWaVuNzBU/xY03E4daSqx4M+E=;
	b=PcQEls3Dlh7Ug51ded+tYrPfql5UJemtNpripMTfwqaZgXUKsypILPDecCPIDfIuMHScxw
	jR+wv09HL9OlBoQFWOizHt+xbRKaJaipDYrpeXJjz09k5yc7zf9BFjpudj45JoOG7jBH1q
	S2xQBHybsH7r4jPdecUD3yljJ/qByiM=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=uCr7+fv8;
	spf=pass (imf03.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.243.127 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756505317; a=rsa-sha256;
	cv=pass;
	b=T6/93j0mLLuztVEC3Spvty0T0l4vkjiUH4kDFie7X5wHKoVkpRzmw4O/ihqMuamyd/JZep
	gMiMfOiAayrr2F1E0r+UDf2z9Ulwhi3rsPO5MGgijnIYxGPgZ0edC63GOLZQv9QKOwMvFv
	oU6gqF5kTssRzHK0L5p/qO8QpgE54SA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SJHSTtcobt804q9GUb4/vSrCN6tyhXer60i86Obz7jf7PikcqhqJZhEud48gBrDtrRQ8/cgxgnx8aiIJvhqDt0dF7FKoyp7T2G1Uwjk7Rjp5R1ySqOvi7mveE1/ngqoglMh06kVqe+r+/b/nfvW/7rz7cmmLuNbYGa2haHCiwwyDADc94fifa6U1jZBJtcRSEa8HT/8GsVMD3OxGnP4UmaLNznDCcqDej73KD8+i8u/euJSH7wUm8z+DCmI8PQaez0WMe8iFdlzxbirsjJWLyQV6ZpFL0nFBfd0dp1DK4jxB2kMJOSplzrTJNXnRe9Qk0IKvw0KjOXQIxYIUFz2BHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WwxTzfe7/vzr4O6TN8SWaVuNzBU/xY03E4daSqx4M+E=;
 b=N3gsbfJTjAiEHyMk6yFRDLyVSuIqCxblGgdB7ImkcPpi695qFX5CS7BC1e4l9B9gfqddqdXYP74v2sPh2TOZIQzGoutwyQWiKXW1fHDmM5/opmvZ8hO1nAKZZdLv9uWcAkaAkr4b1UiQR/XApKZV5fTCNZfvtxsAp3UjGx2E8R5RJSvayP/mK+i7jM0sW0v6Kicy7Zx/vf80GpTYTzz3uR4WosOZTFIj2EBfGFF1zR6fCG3ogjyDVKPtthhwufRCCh6uGiJilNFOkngxjoHvBaPGq1HlHLJ5V/K5+XqsGbmNAdlnA4mROF+cVM8kbDaAjsXaz0GLkwiZIZINmU+16w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WwxTzfe7/vzr4O6TN8SWaVuNzBU/xY03E4daSqx4M+E=;
 b=uCr7+fv8FkMrxZiMboYp05v6o0nyiLg8vb9BoCdFuPJ37kHBDNZ5eio+0KNiIcd34e+kRyeLS0mgief0Gl0RwMO2arQS/TavV8iV9vrYWlbJ/MIKGArVtF7pH3WzO+6t5K8VQ2px0qUiz0odmpu4/wDV3GQnfV2+XaGr2WDCMQI=
Received: from BN0PR01MB6877.prod.exchangelabs.com (2603:10b6:408:161::22) by
 LV2PR01MB7693.prod.exchangelabs.com (2603:10b6:408:176::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9073.21; Fri, 29 Aug 2025 22:08:30 +0000
Received: from BN0PR01MB6877.prod.exchangelabs.com
 ([fe80::91fc:9877:8a2a:d4e0]) by BN0PR01MB6877.prod.exchangelabs.com
 ([fe80::91fc:9877:8a2a:d4e0%7]) with mapi id 15.20.9052.023; Fri, 29 Aug 2025
 22:08:29 +0000
Message-ID: <b3f4e006-6101-496f-a4a5-13474470109d@os.amperecomputing.com>
Date: Fri, 29 Aug 2025 15:08:23 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/6] arm64: cpufeature: add AmpereOne to BBML2 allow
 list
To: Ryan Roberts <ryan.roberts@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Ard Biesheuvel <ardb@kernel.org>, Dev Jain <dev.jain@arm.com>,
 scott@os.amperecomputing.com, cl@gentwo.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20250829115250.2395585-1-ryan.roberts@arm.com>
 <20250829115250.2395585-3-ryan.roberts@arm.com>
Content-Language: en-US
From: Yang Shi <yang@os.amperecomputing.com>
In-Reply-To: <20250829115250.2395585-3-ryan.roberts@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0062.namprd17.prod.outlook.com
 (2603:10b6:a03:167::39) To BN0PR01MB6877.prod.exchangelabs.com
 (2603:10b6:408:161::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR01MB6877:EE_|LV2PR01MB7693:EE_
X-MS-Office365-Filtering-Correlation-Id: 47bce957-5add-4dce-ae24-08dde74893d2
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YklwU1U4RnhRdnlzUVdCL3dVU0xUZkx4Umk4L25KcnlBVmQrdklNZkp3eWRn?=
 =?utf-8?B?RlpKUGlTNXJvblZSdXRQZUZJcVRIZ2VqL01UeGlpcG8zYjRGYjRmMXpkU2Jp?=
 =?utf-8?B?Y0E5UFVqaC8vM0tzVm5ndjJ0U1czNGQrVk9ybCtJWHk3U2pXOVBVNDduSjBU?=
 =?utf-8?B?N3N0TjVBTEpBeEdMYlB4elBDWGk2eHBvdVhCc3B5ZTVPa3gvbHJuYk1BSEUx?=
 =?utf-8?B?N0t6NG05MnBxekFiclh2cmxXYWxueFo0UUIyVC9GRXlvTE9NcU56eGtwd1NI?=
 =?utf-8?B?NHZmdkh6bFZ6ckQ1bkI2THRVbFdDZUp6c0xuVlNRT25hamZoL2RmUkhJYllP?=
 =?utf-8?B?eFlZYk85VXRicVZwYTlNdjNXZHBRMGpGNzNkcTZFeXhhcUR0VU51RFJUUVF5?=
 =?utf-8?B?Z3drUEZnMmM5dWhrSHFGU1E2emJsQUo3cC9ybFM2TW5NcERVODE0eWZ5VzI2?=
 =?utf-8?B?U1AyMWxFcHRhRTFyc0ZsZ1pEeUxtUFU4eFdTTjNDeFFxUGVIamhmVFZncm92?=
 =?utf-8?B?ZDFIU05IKzBFb0R4ZGRNVi9xRHNFV0hId1FPay82czJ6ZzR1UllObU9IK3VS?=
 =?utf-8?B?T0lWNldYYXoySDg2dmx4dHd4SWVINHJrSUdFYWtHU2ViTlVMQllmenp1R3Ra?=
 =?utf-8?B?ZklFV1pQZ0ZJN3hXcUlOVVRQMUhGRDBNS2tPTE1RcXp6NDlOWFZzL2t5Q0ps?=
 =?utf-8?B?ajRHazUwWm5tbEtGTVkwVHBwZDdlZUd1UGc1N09LTEYrUXBMYjh3WUhOTVhY?=
 =?utf-8?B?aWZ5REdWYlNXRWFHR0pBNnMxRDRMODJabXB5WitibStweXBFY1JuOFhwNlVM?=
 =?utf-8?B?MDU0RFJ6a2FFbk0vWkdhWnN4MVNsSWExaFd3NGRCRHlYYjI1WUFnek5rSWVZ?=
 =?utf-8?B?K0VDL3RFdElDZ3NCWGVQOFdZY0FDVFFNVjdTQUpMMkg0OHhwem5DUE1iSWZD?=
 =?utf-8?B?NnFIZHRSdWcwOGpkM0pMSFN0a0pBNDF4cU9lbEZWUkM4TjFvWFJJaEdDVkVE?=
 =?utf-8?B?MHdNZk9CR1BFQ04vR21Uck9ham44K1lOT3BLSmcwa1VzWXlnR3A3WEc3d09G?=
 =?utf-8?B?a1cvWEpIbHdPYTRqMVA0RTcxQ0lYMHUrQktwOExSZlMzQ0ZiNVQ0SHZleTNh?=
 =?utf-8?B?Q29zWUVtNWdhZ1VCTTFqUWpxVXRtM21ZRXdWUVh0VnpVQy9ZTUpSZ1QzOW5K?=
 =?utf-8?B?K0pKYWhqZVFXU0VqamRsWlZkaUFGM1daNGYvWWU4ak9xbTRLRnpCKytnSnpP?=
 =?utf-8?B?V1hWZ1JRT1hlVENwU3g5YlIzQTgxb3NKQlpQQUsrMGRLQ2ljUzRuV0xPZTg5?=
 =?utf-8?B?RktheVNhZkRReU1WTU8wZG96Qi90Q2dtakR2L2Z3bnE5NXlkRkVPbVZQWTNX?=
 =?utf-8?B?ZWVOYS9Ia0MwbWJ0SmRXdGtaa0NtWUVCQjFZb2FWMXZ4SldORUtsVndVbTJr?=
 =?utf-8?B?U2N1cGRzdzY1dG5GRWNIN0Y3QlVsMXdmbHV0bVZnNWZSVWkyeUYxdXFOcEs3?=
 =?utf-8?B?Mk8zVmlIekRrc3FWREdVMWJFUk1vY2F1R21YVXFXeVQyRzQvWUR1T2loM3BL?=
 =?utf-8?B?by85V1hLWW1SNmFvaEZVSGp3WWRVUElkWGcvTjM2RXQwSkp3S2Zha1RrNGk5?=
 =?utf-8?B?V2RzYTZRcHpZaHorR0NGUllGUHFxM1RrNEY0M05wUGxEOWFtRlhZeUg1L0JB?=
 =?utf-8?B?a0ZxNElNLysxRnZCWWF3L1JoaG55WGdHcE5XejVHeE8raSszaWhIem9Xb2VW?=
 =?utf-8?B?enZkRThSWHNnSC9YNnZzaTdLK1BLbkhaenJ3ak92Rm1ybzlNNHJycTloM3RS?=
 =?utf-8?B?K29WcGx4ak5KUFB4VkZoZFlJZ2NTdWFCcng2RlloZmxJSk9HcVR1QSt0U01h?=
 =?utf-8?B?ZlNoWWM3QUh4czVBVU9qZUUwcDJzWW5LYTlBQ2hrbkQwK0lseWJhVmRGMmpN?=
 =?utf-8?B?djZRSnVDekdQRTE5akhCTkY0SWIzQVdGeUJaWHowTEpxNGRoa2NpdTllb3Rx?=
 =?utf-8?B?TXowMHlndXBnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR01MB6877.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TE0wT2o0aG1UaU83dWswQXpIbEtXeHF6cTA4RnFEYWdrSEo5d09YZ3JpOUwx?=
 =?utf-8?B?MmxnMmk4UGY1OHVsNzJEbmwvTWZBa3Nqem5MTDJqZ1c5QnNNYzl4cUJoTmY1?=
 =?utf-8?B?b2RKaHd2NzQxVWNUMnZwV0xkdlhoSFNzZGhPb2l4Zk5iOE1IOVI3c2tSZXFr?=
 =?utf-8?B?ejU4OTNRZjRreVBJL0duMG9QbHFUYkZISXlwWEZBLzRpRW1hbTNsQlNqQUZ0?=
 =?utf-8?B?TlNMYVFQcjZ2VkNFUnhvUTlWODNGcDBzb2tZWWFHUnVydkVLclorREtzU05w?=
 =?utf-8?B?THdIbndxNHMxOU5pUk02TUtPK2pISUR1MUlxbkFaT0xhN2JhL3l6N1JISTQw?=
 =?utf-8?B?bEpJZmI1b0I0NkxvY1hyQncrYW9HOExLTTNsZ3pEdTdsQzlnN3NlRzVkeUxh?=
 =?utf-8?B?aU8ySmQ3VjNFL3cxMzhROG1XL00zZmlGNmxoR0t5T01neEozWHlFY2xzbGw5?=
 =?utf-8?B?dkZHNDhkRHpQalM4c2QvREkrMHNZYVhRQ0wyYytzV1R3dWRvSlYxbS9WZ3pG?=
 =?utf-8?B?TEErdTJiSlZrckdZalplMERLdkMyQlBlQm5EUVB5cE9MQXhEcDg0Q2J0a2ZW?=
 =?utf-8?B?VCtyQWpoSlJNcmUxS3J6cW0yYS9xTkJ1UVZwTHBucmU2Z0ZrRnQ3eWxzbm9v?=
 =?utf-8?B?dysrYnhyQis1VERwY0lTQlVKdFhLM2RBSWdTR1ZmQTFnMnEwQnV6cklLTjNW?=
 =?utf-8?B?TWdXNG9GZCt1c010cnJjbmxQbytCaGF1Y3JtRFpWQmhhYk03MnVqQTlzamli?=
 =?utf-8?B?Unl6VWJVd3lUcGN3TU5ZYmpMNW4xenQydFNZWi9keU0xYkwwNHJja3VUZXZo?=
 =?utf-8?B?NGlVbHV3Z3BoUlgvNFZlTWg3K3ZkQUR5UkFoNmE4NVQ3SFNjWXh2QytKdTFt?=
 =?utf-8?B?N2hhYURCdWxuV2w0aC9SNndzajBrSnJlL3NtVmlnWi9rUUFFdFdmWGNjN0ha?=
 =?utf-8?B?QWpzMlpEYTluREtpUGQ5Z2tjYkw0SEk1RDR4OU9SbnFOanRydGd3cHF5MUh2?=
 =?utf-8?B?N3UyQkp0aHVJK1gzNktTRjB4cjJwdjN0RG9DMzZHUGI0bElvT0d4dGFYVk0r?=
 =?utf-8?B?ZGNRSkZIRHUxVlRLOXNFYUtodGIrN1BWMnptd01JWmdkcGZrNXo5TUJpWmM2?=
 =?utf-8?B?aTgrajlQTUx5N0NON3lPeWJDL20yWWRZZjlVNW9QSitQeXIyaFduTG11ZXlp?=
 =?utf-8?B?VHRtU3pWdTgyaTM0MmNiNExNZzNoZUFLVmdEalpWOUg0czNUakZTTjRWcWVv?=
 =?utf-8?B?MllVUi9mTnN1UUhUVGV5QVJFdlQ5bjVWOWx1K3BNbHdzditoYWE0NWcwQ3p1?=
 =?utf-8?B?eHhWazIxa2ltQXRyd3U3a1BQRVBYSTBQWElGQzFKcysvNUVQOWFBN3pkRHhC?=
 =?utf-8?B?aC9RZTNzZ3Y1aWRXS1dvbDh4Wk5NWVVUNWtTNjFrQnYyS2pYUUZRK2Z6S0wx?=
 =?utf-8?B?OFl5NWZLV21CdWN0SXk1UWNRUXNVOHhsQlBiR0pKeUhPNmc4M0hPRHdKRmFV?=
 =?utf-8?B?M3BxYm1GU2VaeHBPL3B6b1NYVk9qNGZvbnYxL3EyWE5TSGlRZHVBdWJmVlRF?=
 =?utf-8?B?NWNKdFdkWjQ5cWwyNTZ5NGQ0TnE3bTltemFNdTltTVIvbHJJSGpNRlBGVzlI?=
 =?utf-8?B?d281RHRwMTNrcGFjQ0FxczloQUdLNlZwM0pSVE9kdUsxUXlYS1ZUSjBMQnNM?=
 =?utf-8?B?SjFzN3J5ZCtzb3VrL0UwOVp6aUJBclluS0ZLeEhGNStWZFNuYTFyL1k5M0xx?=
 =?utf-8?B?RXZTR3BVaS9kQ3JLWVZudkF0MTZocjN4LzhSK1NVTlQzQUVXY2VUWjhnaVNT?=
 =?utf-8?B?OWJXY0N1Vzd5ZXNDeUZSMlQyS21FNkpwbVorcEtueWNXaEh2K0tNaks3cFFV?=
 =?utf-8?B?RGlzUG42cmdRUWxDTXNXZXlGLzBtTnpWbWd3QkkvZFc5Vm45MmNSZVEwQldZ?=
 =?utf-8?B?bWpNWU1jNGtsZ2NvQjZqSUt6ejR2Qlo2V25raEEwR3Z1T0RZbjluSmY4cUQ3?=
 =?utf-8?B?QTJPbC9MWW9kcHdzRWs4eFFGVmpIVC9tSDZHcU1HcjF3Rk12L1RJNFpEQTJ2?=
 =?utf-8?B?U3Q3dGhSdGtaN3JtRWtVVGtYWkdJRW9xMXA0UlJYZVVZU3pzeSsxODNLZkJx?=
 =?utf-8?B?cXFKNDFVRHdpZmJ4WGxjbnRkTU5ReWU3S0RZdVFCM1JCbDdEbGZJQm9kTTVZ?=
 =?utf-8?B?ZWc9PQ==?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47bce957-5add-4dce-ae24-08dde74893d2
X-MS-Exchange-CrossTenant-AuthSource: BN0PR01MB6877.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 22:08:29.9126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ui30tcsFYOkJ7QW9pV3SG8rY8Crm1kh3ngHzUgn6QHhSVe2tzBBD40Dvh7yHkGW6yZP0zxwJ0jWmEhm01NXMRbLFluM3vugMi3yIfBwjoz4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR01MB7693
X-Stat-Signature: 3xxc3zjef6qub5dt5skpxso89nxm8jpi
X-Rspam-User: 
X-Rspamd-Queue-Id: 46F6820005
X-Rspamd-Server: rspam01
X-HE-Tag: 1756505317-456091
X-HE-Meta: U2FsdGVkX1/EZhyNLKVu4vV1Odcb/pL07OQJEtkhPQVuxEffdX0Q/zQ7ODtRf+O5KlTfS83cKsjKzvjsrn3vbwuuOgHE1xPSH5CziQ3p9NhoKjlMcN6zX0SPMB5SLDhBXXe89k2V5rkwg2sQby2hVaXrtCqgbfqjn2IURXsPONuZ0lB2pzSbE5iVbgjCEHbvTUP/WZX5OrdUGsmVkP+nzP1O63YHlYH9fJ4GvCR+oYmv9dkysyYEDHzlzsAQRhV7/y8AeosjaepzaCF6+A+nsRYscnfzwdHQJAb2c9MfFJyC0znNKqvEtAwRS+pJ38ZtZgqR9NrFITMhu9mIVd1WwzwAidaFx/2v/mIRgr2ljPiG1kJYz3R/edL4LRwGi+x4gaSRfH1raBMDuyRTiqH/obPyfvfRuMEcl7WuwBUc3R+5do4F6Pfay3wkBJhtfL9uiVOayjxwUbUt0h4PjCwwSHn5nUpsWuy80yww+VSZxfC9G5TYFfBbfa/edlcJVCZwDi+Ur3pHHnfDhISUxPTs2r4ZDBU3BMBaGCWgY9nCDi8B6xpjo2CLR9vQDcUQPToB8m/b7n1+DksIMJ/AytP5oluQdZcwpM+2LI86RpBqMcH4Lcye6EtsQ6dsNhe/L9MWehR3jH4g3g0vzTlmKAjNGDQzTYHtedLWjjcRld7joqVOCsWujGi2Taxouc7US++8OMpTbsXzJ0tim+R6BXdelLw/KShN9HZ1+7y0TTSoVvyTJDYwwl2h2VYDNVmzypKaGLvpVNjoFrEJZoNSKuj3DshdXC3Wk/rUf68IFglIVSmZZHSSyBPKV0ncBPvShN2A+vexkgdLCjReO1Gi1sXntbIKhOZXX5EWaHOF0tOyip/inxBkRWmoY9c1QVCsgAWPBU/mRhQsl8V/l7HCVYbLWlxXlIHkcmxwBaLU6GdcTvcLHRrAJDlhkrtgOHxO0ny3Ktpu4C6ctyZRSIpDUEc
 Q3OtFtHr
 40rKDZxS5zSoOzP0xJ38CxjGRSobqMBY+fkWb0ZS9qcksMfqGnBpDjAT9xM3ZNRQhfVUhcvowV/wrFKU9WcqvB2URRy31dn8u2Ag+46KZ9yY5EB2gI8yc3jx5eln7jmTlz6/KTO80pkTov4LGengfo8sBEG/1xbQWjpHYz3CkUaextFXFJMTex5liIIyWm7vyXYJbOM3Q+QwA03uItuTapt/VguEr7JjecWNTGTWfGcwT7z/WnEixbgvdIniHmgLSj0awgBHZsw5oqWu63+Z+YJJIfCav6rbYC/qwq2tCh/yYBlVt5l34oM1ABk5cJdFxUalPSuUnVxjmF8Sn7/jUd07BmoUCEfn3yp4+PpCFtvfIze6zD2fpW7G4/TdWb9waXWDzbXGreLNsBMP89a7Kz6CzStzBmDpclqmf0qIUVQbhQtgKRnJqzzldbnes0DJ7aTvdMr1P70vsZ0NiLjpT0FthZxJXp7zUTiQbR4yzJnB5ZkdQFdw39eM0kpjHlnGK/CHlrGLjBn7c3OpwdyNo1coIL08AenP0f6UyTjGKKvqlcSHoj55QmVAlewF/DHncpp5DPypXnWOv8yXmnShRd5FXPYo+VWKGbM5BX1XYChvPcS/VjbIL2SCCY0DmD7EtHkVLbbcS2baW6Nmu7xGyUKhEwqXG7Jy0VhFddVwO7e1mnSuLypWwuuFuxw4KRRAHXzJwBAVYZtN1Xuo5RkSKsLErC/zgZ7nxDTD+En0sHLMZHAXKBcsqsaRYW4bjJ2W3+jgUTK4hhzYXlrc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/29/25 4:52 AM, Ryan Roberts wrote:
> From: Yang Shi <yang@os.amperecomputing.com>
>
> AmpereOne supports BBML2 without conflict abort, add to the allow list.
>
> Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
> Reviewed-by: Christoph Lameter (Ampere) <cl@gentwo.org>
> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

I saw Catalin gave Reviewed-by to v6 of this patch, I think we can keep it.

Yang

> ---
>   arch/arm64/kernel/cpufeature.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 9ad065f15f1d..b93f4ee57176 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2234,6 +2234,8 @@ static bool has_bbml2_noabort(const struct arm64_cpu_capabilities *caps, int sco
>   	static const struct midr_range supports_bbml2_noabort_list[] = {
>   		MIDR_REV_RANGE(MIDR_CORTEX_X4, 0, 3, 0xf),
>   		MIDR_REV_RANGE(MIDR_NEOVERSE_V3, 0, 2, 0xf),
> +		MIDR_ALL_VERSIONS(MIDR_AMPERE1),
> +		MIDR_ALL_VERSIONS(MIDR_AMPERE1A),
>   		{}
>   	};
>   


