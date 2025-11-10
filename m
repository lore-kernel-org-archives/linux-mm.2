Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F116ACCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 14:20:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59E738E0008; Mon, 10 Nov 2025 09:20:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 575EE8E0002; Mon, 10 Nov 2025 09:20:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 464988E0008; Mon, 10 Nov 2025 09:20:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2EA248E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:20:33 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DE33254FD4
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:20:32 +0000 (UTC)
X-FDA: 84094907904.15.0B029C7
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013023.outbound.protection.outlook.com [40.107.201.23])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1F81D40006
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:20:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=KhhQvuRJ;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf12.hostedemail.com: domain of shivankg@amd.com designates 40.107.201.23 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762784430; a=rsa-sha256;
	cv=pass;
	b=hjqbbJFhMBGrrEsiLNbpy+RcQobCRWwvRsxuT2+nA3qvBjYKPeZKDwLwRR2yE+lTf40qaw
	onmtWxWBzZ2Z0EAeo913c5cOkKnNxIhqag3MOqEmxv/0m4G/rQ+xnMN1WBmGgwvlZD6Lkn
	ykVg0CIom0M6wpvHN/UAU9BqegS515I=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=KhhQvuRJ;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf12.hostedemail.com: domain of shivankg@amd.com designates 40.107.201.23 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762784430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2YIqYPeAsrZAN1wj/c28OtNwDGe8GDCoR+AaceDOTRM=;
	b=Mq2bFQJB0vBvHPO/Nfg9tLqQk109OAKhMNU/E2291gS2/B6aNnP8J0DgCaEx6oaMCmEj9t
	Zf4hirzKee/hlkZO5z/xZwPRtS36BwifKHljk8WF309Av3dHvZ0lNom2LKykTk7MoGu5bP
	ibrNlyjQdrrKbTUmsJDBHNSIJ5b6QL8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xFvIbeyOIa0bHoSe1slbNMTNCk4yldmQIDg4Xwtu0RsWbnuRDw8BvnLR9EyYE3mjonNWWXERWqZBgLgmbLtwv8XkZucAKsgxb+0t4CrfHHPowSEXwWqpywmdJhJMJ87xBBAQHw0oksz++SLpcGjriW30GM3jGfMbXz5C9m12Qmwni+S66E9bmA4roFmua13CfgZ6iLpwSAO2pVm4LK3geAWBftq5/Kujs6E6Z34eQG9zmPsw78DXh6lXPVlNTaCyrSwCB1NRD5vlrk2LPX85r71s6Y3BVaLa/lIub4/+NwCB8R0802ggb2xG22ic5CYqVzx6oOyh53BdoyknLkWs5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2YIqYPeAsrZAN1wj/c28OtNwDGe8GDCoR+AaceDOTRM=;
 b=I0WGSqUY+hiSxeJ8yuOZZFacnOSZP3HOoZE3F3FsoCj9UTUGleGcHQ5HF5zSfwkXjL8VQNPMBnetVel+AeKiVl+ybp5f/pmufl/VIr8m/EVuln4LkH0zKj+qxycJYtGbABI+wo/HOuYTg4vYyhSYswiObTqtEFgR8dZhhe56qYhkU7U4O1UwOrR1PEeR6/EENDvPzL3elNAx8FEUVxHp9JXh29eRYC4u26nj8RU+yIcOwWkY/OU+w+B601WcFGmtFG5JIKZjoutEc0kff2pcZ925q9TdzOUKCgvOsrQaQCoFNltRe9P1z7vsjfO/zXkvZ3IxKukpNERMNakxvmO1sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2YIqYPeAsrZAN1wj/c28OtNwDGe8GDCoR+AaceDOTRM=;
 b=KhhQvuRJbhvqxW59uFXso62VR29z/hK1T1UnHww4JAr5NFRZTzrHv2Z8juKkw9Zw69yhwS45RSaSBTSnA85TNMjRGDMRotphPV8G8YPoI9z7XXVE0QViuWoQbl4zaiNGForqw6PZxpNfEebf6E7Cno/E60t92n/otU7eyiROtHc=
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com (2603:10b6:a03:48d::13)
 by DS7PR12MB6071.namprd12.prod.outlook.com (2603:10b6:8:9d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 14:20:27 +0000
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d]) by SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d%6]) with mapi id 15.20.9298.015; Mon, 10 Nov 2025
 14:20:26 +0000
Message-ID: <39c8a4ed-53b5-48e3-baea-f67cc1e8be4f@amd.com>
Date: Mon, 10 Nov 2025 19:50:17 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/khugepaged: do synchronous writeback for
 MADV_COLLAPSE
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 Branden Moore <Branden.Moore@amd.com>
References: <20251110113254.77822-1-shivankg@amd.com>
 <aRHs3pA2kOr_uD3k@casper.infradead.org>
 <b7313a45-c36e-4390-a0b8-46f412474f86@lucifer.local>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <b7313a45-c36e-4390-a0b8-46f412474f86@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0205.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1b0::14) To SJ0PR12MB7458.namprd12.prod.outlook.com
 (2603:10b6:a03:48d::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR12MB7458:EE_|DS7PR12MB6071:EE_
X-MS-Office365-Filtering-Correlation-Id: a18b9f89-c3cd-4c6a-1077-08de20644b18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZG5EdGpJbm9zUnh0VStZaUU0OTlBZktXZUJZR0Z0NnBuckMydFdIOTBSVkZu?=
 =?utf-8?B?dlRRR1ZHY2VSYklaVU16NVNvWWJQU0REVVpOdjFISkMzTzRuNHFTcy9GQkx3?=
 =?utf-8?B?TXVFVHNzVzl6eTlMLy9EQmdCcEU1T3U5VGFUQ093S1NEQ2V6MVdtL0xvZmY5?=
 =?utf-8?B?S2ZtejFjaEdVYndmc0N6VGY5WjU0U29BSFlHcVQyVlFVWnpYWUNVeU1zVmFr?=
 =?utf-8?B?Z21uckNaczJPUTVaRUtlQWVVSllNaUFCNVBJN1RWSjRnUTVmL0UyZHpKNmJ4?=
 =?utf-8?B?M3NXMy9NYWxhTzYza0xmNnJOZGI5VlJHWkRkakFpOFREaXROUHM3aVcxa3I2?=
 =?utf-8?B?Vks3VkxOa0dJUE15N25sVmcxdHJsMWdOeUVUc1Nwczl0UkRTUjZhZzdTancx?=
 =?utf-8?B?dStaUmNZQkZ0OUNXb2tRZVczbVVFdUY2eDJnYnVUU1NsRkVaMnVsM3c1Kzlt?=
 =?utf-8?B?NHpTV0hTUjhhTEFKSmJlTHFTbEVsYzZiVmxNMDcvREhYZUdTczJyL2FZaGdi?=
 =?utf-8?B?bmxyRFVkVkowMWdINEhqQTB2UGpLc1crOE5GUFpiYllEOU41TEx5QnpFVnRK?=
 =?utf-8?B?c1I5ckVXUlljUHZ5enl0bWR3RTJFQjBjZzFpc3Vqb0xRNzI4WTZ4Sk5HTG8w?=
 =?utf-8?B?R3RlNnJCVmIvMm9aU0hXVUhaSSt1UFBYbUtIY0VJQmwwNC9vUkg2dDIyM2NR?=
 =?utf-8?B?V3pNTFZwVzU0YTEzYmlhaXVDa2pCM2FIUlJCekkybVk1ajQ4ZDgzVnJFVDlK?=
 =?utf-8?B?NGNtL0szRUJwcDRHbzBRampwRnMwL2o5aGZpSUVzSnlIZ3RoZFFOd1poM25Q?=
 =?utf-8?B?U0tPS21SNG1teTVKMHdPbGdpS0FKUlV4TlhoOVpnV3ZpNmppWm1CaWV6cmNo?=
 =?utf-8?B?ekNUdXJhNnd4b0NUOGZZZS9pbmlpQVUrQlR0dHkvVFBRNlZlWHNJVHNiSnN6?=
 =?utf-8?B?ZEo5WDloeFovQXBQQkpFUENobmZUMGNEdU5xT0Zod0RoLzhlbzBucll5STNS?=
 =?utf-8?B?cnhqMEFCOHJkMFpMM2VqUUxDemsrOEF2Nm1DbFpMQjh5Tk5sdHdjQ2Y5NDlM?=
 =?utf-8?B?bm1iSnVoK2RuN0g5azh0WnNScWt3dEtGWmM0dEswa004d1RYVXNnN1dEWjEv?=
 =?utf-8?B?UDlsNno3T3pSek5WaGdKWmRrd0ZoYTlMS0hKTGdFL0JRS01FSUx3NkJEYjVu?=
 =?utf-8?B?MkNST2hXSEFjMml3d1F6WkZSbHFyL1JiT0ZjMk5Pa0ZuSVVrTThEcnRmZEpk?=
 =?utf-8?B?T3M5dFpiM3REdmJEdTNvYVpsSklsOFVCWXd6cUg0MFhxT01Qb3h1dmFhRFln?=
 =?utf-8?B?d2hZNWZhQ1lpWnl5WlJiaW5LU3lETDRKd05RTU9saXVqN09MdVlUNGxncXdi?=
 =?utf-8?B?dEhXbzNNVWExSS9ETnVXNUYvV2htM3RuM2pYK2pPQXVHenpucTRMcFlRb3BF?=
 =?utf-8?B?TjVZSGd1UktzZFZpUXFTa2lmemVjSVJjL0ZzeU9GNnRKRlZIamQ2bXRsdlAv?=
 =?utf-8?B?bm5ja0g2bGxOZ2hQVitYQXRzeVUyYmsxaVU2SWpNRHI5SkZxTjFSSlpvbDRE?=
 =?utf-8?B?N3FwQy9zOFl5Zkk4ZVRKT1pQS0drUm8rSU1JRkNaWTRTdEJVMW1VNTRZVUhS?=
 =?utf-8?B?YnVIOU9iMThuU05DUkk5dG80bHNRc3NEdkZGTzMyQ2dJU2xjYk42c2l4MXFH?=
 =?utf-8?B?dlNwWm5mQy9kaVcxeFZMQ0F5eHllTzlzSlVid0Zyam44YnNJWFRGTENnNjNn?=
 =?utf-8?B?d2d5dGJDcHJISWlXV3RsRjNwaXF3QXJHUUM4WFNyeTc3ZzkzcVc0TC85QzR1?=
 =?utf-8?B?R25QU0pXZVREV0VaUXB4T1VIdVJXbXRKN3pqN0U3MTVqSjRTMmk5WHQwOTFy?=
 =?utf-8?B?VFdTNHNzZmlNZWZaejBVcktwVWp2RzFOenBEeTlvMlh3aVJGZktRa2JmRE5F?=
 =?utf-8?B?ZHlJS0dPbHlpbm1mZStEblg4QkdVSDVJMHJOZEg2VDIrQkJXZkd3emJOUFor?=
 =?utf-8?B?bFl2dGdpajlBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB7458.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K3c3eWFBN2tTSWl4TU5LN0pLQW4vN3Jya0JQQnpjMEhDeCtyUkRGS0QwQ3NH?=
 =?utf-8?B?KzRpUm9xZVY5SXlHN25OY1krcnZ5WVVXWE5BeGg4dmxkSnVhc29hMzFtV0V1?=
 =?utf-8?B?SUpYdWc4RzdZWUxVQmlpQzNDak5UR0hXNDkwNkJkOFI2dEFaR2lSckZ6S2d5?=
 =?utf-8?B?eDBKMjZ3bXhuK2FYWVloOG9sQnA0QWp2T3Z0Mmc4aDRSOUFiS21taFN5Ulhr?=
 =?utf-8?B?RlE5OGtyWkxtOTROeFNHK1VrS1VNOFFPNGp5UEVkRjhIb2YvUmY0aWVSZUd5?=
 =?utf-8?B?R3FLWnNlVS9LL3UxUUg2TjdLR1Yyd0tqWFhXYmpLWDBTWFJwY2xoaGtiOHI3?=
 =?utf-8?B?dWF5c3JUc20vS1JMTHdOUS9lb3FnaGRHSGE1cWMySjFLUVY5OE96Tm1UaFpy?=
 =?utf-8?B?UCtGNUNvNzk0T0Z0QVl4MHV0UG1JYlNQUGg4YXl4U2Rpem9rVzQ4aTZMUHg3?=
 =?utf-8?B?VUJjeitUVHY1bW4yNi9IZ242YjJaSE1sbG8vM1BSY3NoejczblJBemhzV1k3?=
 =?utf-8?B?ZXJsMWNiWkpnZlRwVDVsOWxEcmZGelNTVmo3VkRHNFIxRnFCVkV3L3Yvd2wv?=
 =?utf-8?B?OGVHcFVHZURUaHVUUDhTSndFTFVjdGVJbXYxc05ISm1ZYkZyMmVMRTlTajh5?=
 =?utf-8?B?dy8xUDlZaExqcXFKZ0o3eUxNMXlBUWpaenhNVXNNNlNHRTdVUDJzdW1rSWhi?=
 =?utf-8?B?bGdQV1ZzWE9NaE5SS2pEdWZGZnNWcUw0Q1VoL0FvMTROSnErSHcweG54eEpG?=
 =?utf-8?B?QXkrSUdSUmYwREtuUkM3VU9JZnpJQSttZWtJSjNTUGtKYURXSmlPUTZZRG5v?=
 =?utf-8?B?dkRsZlM3cHU2SHY0M1QxZnFHNU5qRUFUVmlYMktPTlY1eXVJcHpMcldZUkQz?=
 =?utf-8?B?c1JZUXNMSHNGYTB4NzFOOHdoZGhaREtCRnIwbVIwc0lQbStHSEZudVRrZ3pm?=
 =?utf-8?B?d1pHV3ZtSGdYYXpaditkSFE3d1FjV2cyN0YyYW5MdVVicnpEZUF4dk1tbyt1?=
 =?utf-8?B?ZlVsMXJ6bGVOWWZPVzQxRnIyb3B5RGdGVTFUMTl2QUhYNUhTUG9MUHoza3Bn?=
 =?utf-8?B?cHBSNnFWV0puUlJidExqNWtFNTluSmlOM296ZXFDRHYwMjVIT1NrUm1jbFpk?=
 =?utf-8?B?U3VoZEFQWnFrSnZwcm43OUZZaEhhalFHcTdzYXhWZUZiRXBHYnpoMkgycWRu?=
 =?utf-8?B?blB0Z2ZiTGRZZHJuWm1FWGptU0lWVFVCRDE2QkRtMlRnV0VuWnBGL3BVSms2?=
 =?utf-8?B?R3JoajdpaUMxSlRwWmpTMFJPUUthRWRXMGNqcjZMRnpTbzR2ZDB1U1VKMHNY?=
 =?utf-8?B?dmplemRiNjNvRHJHUFNTcGhWN1hud2thaHpMcXFoVFZ0WEdxSDBlYmowQ1ZC?=
 =?utf-8?B?UVNJektsUVlUeWJZN2pvRnArZ1VWZndIU3dueDRBOHE2Sm05UEZzY1BaZFMw?=
 =?utf-8?B?MGgwdGl3SXM3d1h5K3hmUDlmb3RubnFiMTBHaXpkM1ZYYnVScm52SnVuOVNR?=
 =?utf-8?B?VzZwMHp1Uk1ORm40bFBUcE0yZkt1MGVRTWM0RUpQMW1FUkQvSXQ1QUIzb090?=
 =?utf-8?B?WCtvVHhBSUlNTFNzbGg5a0FaWWttVmp3N0l0UHM1QVBjQnJOdTY2OWhUUTRV?=
 =?utf-8?B?OTVOMEtzM1VDQ0RRa0NsMXd4VzhXVXZtK3dMOTJJcExoNHZDUTd4TmdQWWYv?=
 =?utf-8?B?cmVac25kZklUemM5MklSUUZ1N3ZSQWozMTVqYW1MTDZwY2VHZ2lmUXVBUXVX?=
 =?utf-8?B?UlBZS1M4WndjcS9nME5QZnFsbVBFaVVYN0ZIWmFMbUY5SkMyWnVhODFZUGxO?=
 =?utf-8?B?U1NrMjczazJSNXV4MzEwNTFyUHRjZkREUTF6eVRTMTdtKzJ5SG1uNVVpaWFm?=
 =?utf-8?B?NHRXdVFzQjY2eUdGQkVMczJJeGNXTit6K3BhSmhid2lhNStSUXUwMUpNM2lk?=
 =?utf-8?B?ZlMxZnRRa1l1aVgyRTVXTVQzWC9ZVmh2NVZRVVF5bVUvSm1uelNZN09SSUVx?=
 =?utf-8?B?WDRRalYzSFV6SXVCOCtuK3h5bzFxcWRtaTk2dzlUK1BHcU9CU0hpeHJkMHpq?=
 =?utf-8?B?RDBvK2VWc0JOVHF6S0UyWit1dTFESzFNMHdWRWlnYTNucHNwbkh1QkIxdUd3?=
 =?utf-8?Q?pjjRNVJAAJ+lFM0Z6tPzzh9iz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a18b9f89-c3cd-4c6a-1077-08de20644b18
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB7458.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 14:20:26.4913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SvVAjawtruYpUDM4X8QEU9/RL1ArMZaNO2f1QpqpYKGhnsn+R0VnMwJoGgC5FMxyjQ9vi6/ph8eh3rrxzldxKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6071
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1F81D40006
X-Stat-Signature: kcrex7t6bzris7eq5raj3t6rmsf5rsfy
X-Rspam-User: 
X-HE-Tag: 1762784429-356952
X-HE-Meta: U2FsdGVkX1/BhYdKgz3Q+TCu1pNgr7syfF+vxhuDce9cRFBKIoXO1dPkVjYNBgI0NGH7i0If/83Pc7l2I50R+afbbEbz4vFtJHbpSJbY4n979w503sGCnl/YH7fnlx3guBrjY4dxmKVpkGQEQItOqA1gRxnxoIMFY5rkFYjAuIAhdadaRCPgCJzzLvi7MP9O5d0+3Zf3DHrkRqmlSwnOLrs7yElNGtnEPNrG4swzCE//StG3g3N/JtkaaBX152/CfYtKyjMoIm8FNDL398RGsAnAmT+k0FdVAW7qaT5InXPOLhiXuuXZAcVQ3SEnFwsjWIohbf77Plp6awp3LE8Tj5p++JNtnrgYe00nRt6KoCG3HKqu7oKyTGs43jr5UoF4QNrFCDb5vNkSEiK7lxx2zITfq1LIzn4ILqPcNtwjOaiJ+Nin0ifIGU/6NcIY8z8HTzhY5cPcOzycxDoYffIVHaRIVoIl8Jp4YVK7sIHu1oJ3qwlj/07D+/zLnJh8RG+i3XpZxuPmE4WGjG8jR8sRZvMSTrqpOvFbLqpQ14zmFvW3eaxoTnkOVvXAu1PtHsNhPfaODplvsTAE8i9onXY111Bbl3+au7RMMpsXenexg7us9pWUEcALCbPvWsCVu48oxNLhy0j6mhBefQWjTSbAi1FdEvvI8Icq0EBTQke3+V4XCkhiUigbSJfzs1IsRqqtkuYhQiUlPI1wOhhDTFNi871Q7RpQs39H5QvwQ6YDvpzx5MduqHFuukjLWnaJSIs7bhwsTQI0zXJXVmpdQNLQIn+vuzZt7QB0r6SwRleukVLBPQprFyrzOEl6FOfsWQB8V89JuVRlQ6vTC8BpRR/Ob6d6Vz1cEXbACicb0QJy58h29tV7GgQVw49g5unsxcz/GDmBgPmqwpzrJTnRKEqU1rGTNYFxhRDK/2gJQnrK0P6PSNnuAzls6SYosLLLRdiuhXPrOnC+aeQxBwqTuTH
 dk2vW16t
 UMaYLe/Q1OalTqx8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/10/2025 7:22 PM, Lorenzo Stoakes wrote:
> On Mon, Nov 10, 2025 at 01:47:10PM +0000, Matthew Wilcox wrote:
>> On Mon, Nov 10, 2025 at 11:32:53AM +0000, Shivank Garg wrote:
>>> When MADV_COLLAPSE is called on file-backed mappings (e.g., executable
>>> text sections), the pages may still be dirty from recent writes. The
>>
>> That explanation derails my brain entirely.  Text isn't writable!  How
>> can the pages be dirty and file-backed text?
> 
> Because they just compiled it and it's not been written back to disk yet :)

Hi, 

It's not about compilation. My binaries are already compiled.

The issue is copying those binary to a freshly mounted filesystem.
The page cache folios remain dirty until background writeback completes.

Reproduces 100% for me: fresh XFS/EXT4 mount -> copy binary -> execute -> MADV_COLLAPSE fails.

Detail logs: https://lore.kernel.org/all/0b84865c-5b23-4be6-9902-af9d5e63c182@amd.com

Thanks,
Shivank

