Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A8E2D37490
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 19:56:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBFF06B00A6; Fri,  5 Dec 2025 14:56:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6FA86B00A8; Fri,  5 Dec 2025 14:56:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5F156B00A9; Fri,  5 Dec 2025 14:56:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C61C56B00A6
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 14:56:44 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5F942890AF
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:56:44 +0000 (UTC)
X-FDA: 84186475128.16.0AC480B
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012053.outbound.protection.outlook.com [52.101.43.53])
	by imf21.hostedemail.com (Postfix) with ESMTP id 41D491C000E
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:56:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ce5wYiGx;
	spf=pass (imf21.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.43.53 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764964601; a=rsa-sha256;
	cv=pass;
	b=iFkjtf8KZd9gcw9ik6ZxssnLCyjQWxmt54uNlWyynVwz7MejTKpcVfVNhF5Khqsx9qJdQr
	4nlZaGXWOQ/Y3Te9KVBuLS2UTTAmysZibtOmTsP1EVjFgadkLIHIPWtcMrs3eIKHaAo3XI
	poMRnAtz1I3HN8zCi8+e1Tzg+3qCBTg=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ce5wYiGx;
	spf=pass (imf21.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.43.53 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764964601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q8nFT5yXJ9B9gSQy0ulyeufSbWgYkedxLOHnR5GWnwc=;
	b=13UzG8U9cBoEpsFBSaJfTQl2FDCtB23Qlm+lOZMG0uLhBUPZkWPcVtQ/Xggez20SNhFxaV
	7t0y22f0OgkclsdpnlZIJtbfdvevWOexhADs7Dw/fgIIamF49YZawiHV7KiEouQvYJ72KP
	zyGjoJQheDIOZvoF0J2OB7BAbG9a4lU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OwKrn+qG4WeFyx6ULPVXDkrKW7Q+D48twD/+TPbX+59LYgzV0mmzFvcCBn9uGh0XIIiRkeze3Oln7VC8hxWOkyiaJU2YN/180f4ZV/jOX4tU9ZY+/f/eZPbhRJavDdVpBd8HQ82iBaYAB2OvxMW6VJiezjMivPt+OgFRM4hCUSnsmrJYGCmi75u8WtnmsN5vexiEw54MV/YY0bUbBG6Gy8msVNp/cnpgm0MmrX7IURUIkDd/LUTKKWa7eIMhcYD+bL3XW45tOxFtBUarsqGKnJKVmosK5qCh3AUqZSXsGbEglaF9IIN9FQwZnscxmIkSVP6goKVGhYpLfL/hpadcGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q8nFT5yXJ9B9gSQy0ulyeufSbWgYkedxLOHnR5GWnwc=;
 b=Aja/0ZUZmdW9ypvTyJIoqEdHSG/I3I4s4hi5b3VcjUjCjVEj56lpyrZoIPx+vDfE7cO5wxOYue4w6lpQ9ra7Uq5SgbIJa4iyGpT9BxI4IUylqtypaoRKH6iWon8gaGy8OK324egUBUyef/Gfiqd/pQHPRKHitwV76nmDEz1CqscBT0wJAqVCMZe5FQc5z96fKxzSo3Hj8iDAGUb5jSCbiWcl5mlVXQWBLA+ji5JDb/Blq5OuvyN3PDxaoWi9dUO6na/Bx3GNIboGxJQXqxx3AXoSQyaBzeljWHbky2b+ugQs4oF2/Z20bo1/aUcJLA70AKuQyoREeq6cTf1Rjq3XIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q8nFT5yXJ9B9gSQy0ulyeufSbWgYkedxLOHnR5GWnwc=;
 b=ce5wYiGxRyRfJQ+E2dIyklQ4QkYLPZuTWgWDGzX/3SXDH2+of3Icc2uZ67SX1Ni9KxobTRPp/qcDP8Ext2O4mjzB313Q9zyR51BIonF3IIINTWAoAFjCi4pAQSuB4CnhxxFOOjXBjDh3JydtF6Q9PR6fe8mCpmqYAIFp6kXopwGr3To6rzMPL/WPfSturuHioaGvDgGqac4MUtnpnyYUI4Qqb2TQDKckb2xxCAcIgbGNqU3CpQgSpnZyqOZY/w0WRMV1yzG3sdjnk/vNqYwUTovW7KFwQDZRU2V9FRT6jAHzcW51op5fnI0bpmNdXvMZ/stHsQK30qPSa/4MXEc42A==
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 SN7PR12MB6768.namprd12.prod.outlook.com (2603:10b6:806:268::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.12; Fri, 5 Dec 2025 19:56:37 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8%7]) with mapi id 15.20.9388.011; Fri, 5 Dec 2025
 19:56:37 +0000
Message-ID: <b2b2ce39-200c-4dd0-a46a-8d3f184b7d51@nvidia.com>
Date: Fri, 5 Dec 2025 11:56:32 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: avoid use of BIT() macro for initialising VMA flags
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 oliver.sang@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251205175037.1287366-1-lorenzo.stoakes@oracle.com>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20251205175037.1287366-1-lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0059.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::34) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|SN7PR12MB6768:EE_
X-MS-Office365-Filtering-Correlation-Id: ac4d070a-18cd-44f1-892e-08de34386615
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Zk1VVWNEREZVeXlhQTRXTjNIU0o3cGFjaGUybm02T0ZwNEROY2hSMEhNZ0xE?=
 =?utf-8?B?dUxVdkhRUWJnYW00dmlFTVB6cGxlMVpSWkNMVC8zdHUzUituc2dvZ3hKRC9V?=
 =?utf-8?B?WXpFRGFLOWN4NTU0TVBMQjF5NnU2Nlk1d3FnSWo0clF6djJLSGNXVUdzU3dH?=
 =?utf-8?B?YVBFZHNReUphNnV3VTdMaVBMNkM0MW4rdTZicy9iZ2owNGNjMkZpYTBtaDFq?=
 =?utf-8?B?QjlZeUpJSUd5dmcrOXlCbHZVSm5wWUlmVC9oR2xmeWZPVGgzazVidXI3UUpF?=
 =?utf-8?B?QzMwNkdRT1dieDQ5ZnVMeC9IWnh3QmhKOUpJMVhZdjgycGR3SmwwSURzMjht?=
 =?utf-8?B?NVJyTVljRUlnNHZOZHNHMkw2dHNwUjdOYi82QlNnMUpnT2FVeGZVQnpBZ0RC?=
 =?utf-8?B?QWFHTEVBY0dzWDhJUExDSlR2VzhBNzYzakpyVkl6bFMzWlNIT1E0U1QwWG1p?=
 =?utf-8?B?TEJ3RGJLYkhVSDYrQmMvZzNYV0hTcXJkT2R1UHZhVWpnUU5uMm91VXc0cVY5?=
 =?utf-8?B?cXFzVWoxb242V1VNWVJMMkVpUWpzOXozaFV1QVVMdXJJRnhyNG5saklmQmZu?=
 =?utf-8?B?MnIxQXUrMzFHUWpyUHNMSWlUZzFpdEIrajdzb21qQmNyTHdlRTZYU2JCTzBh?=
 =?utf-8?B?OW1wWHk4SXVDSEhMbnV1dFppdnFnQzVQenBQd0xuRUtJWnVFMHhDakE1ZStu?=
 =?utf-8?B?bmFaNyt6eEJPLzVuZWVUTVM5djZmWFRzT0xsMzRIMVRsZlRWL3N5TjhUQmU5?=
 =?utf-8?B?ZjgxQk83amdnako5R0I0YWNDL1RWZjZmSkFFK25CaHBtZ1BXSFl4QXZqZjIv?=
 =?utf-8?B?TG1sL25qSmNUZ1JMQ1lkTE9tamIvSEh1cnl2NTF6eEp1KzlISmxTeWxxNmxp?=
 =?utf-8?B?S1RKanVrNHp6aTR6VUQ4cnNWcWF0Z3N5TTUzcXNmMXBOUTdFZTBkb01FVlN2?=
 =?utf-8?B?eUxsckhBUFc5RG1YTW9oeUpMSm1RaTkzQU90OGJLYTVJY1d2VGNwbkJwZXFr?=
 =?utf-8?B?Tkx5OWVqekZvYjNTK2RnUXowMzBUUCt0d0cwWjI2WjlteVVmNThxVjVHUWZs?=
 =?utf-8?B?Y0FrZUY3ZHlZYzU2UmJnUnpmU3RmdzRILyt3L0I4eWtreWl1eHpJempVM3Ew?=
 =?utf-8?B?WGNJbHJCWjVBRkpmMWtUeXBKcitPeUtzanQwZ29BdzVlVjBSamM0WDdTdTVH?=
 =?utf-8?B?bFVDV0pNUktVZ2Zremp4NmFWQTF3MEpSUzZoTEpleXpLOUF3NnhXc21HdW9W?=
 =?utf-8?B?M0o4aGp3NjA3N3ljYnZ3QzQza2VNdmtvNDlmWHY5WUlDaUNFL2FOSUlIakZV?=
 =?utf-8?B?Ynk3di8wazkzOEtnYnEzWFkvU2hRd0lpMVoyU0hqci8zNU1GM3ZFZUUvZE8x?=
 =?utf-8?B?M3Z6TDJJSWVJZnUya0NuN3p3YTJlNmtST0xwUFZwMEg0eTRWQThxZ0FDQjJa?=
 =?utf-8?B?WnFZeFNkV3Y2VERFOUk2bGF2MVlHMlpiUXh1UzliSk53QnpkT2lyU01GUm5I?=
 =?utf-8?B?RXREbXpIMUVwaHNtdEFMdUZERGh3N2JkMVFpdXNzT0t6cXVYVFE1N3JjVHo1?=
 =?utf-8?B?cUFZL2dpUTdRTmRSTE1FdWpJeTlVa0I5SjQ4djBEQnd3elZCdUhKNFBiUVRI?=
 =?utf-8?B?QnJabEt0dVhSenZrYWhKQUJSWW4yV2xLeXNPNUhTMEZra21ydUNTK0kxRUVS?=
 =?utf-8?B?bys4UGlDbmVCMStYSlk2UWZTakhVK29sNkZWTFFYbllLN2dMaG5jdUpFUUJs?=
 =?utf-8?B?cFEzcG9nb05zc0JnRitXTm00RmM3T2QrYVdDOUdKY2NBb2M4VVU1bUE2cVhn?=
 =?utf-8?B?dmNmdHlTbWd6MG1makkvbE8wL3YySlhERWM3UTNIcitXS2YxWWhFd1hnZkxO?=
 =?utf-8?B?T0pyRFVVRHptdmQ5S2tkanIrUmtKMDNJcDMyTzBoMVZ2YlJVT3lDbWFaQlFR?=
 =?utf-8?B?ZWREYWNqQ1VvbDVQempUODI3QkNLU1ZyclRITUp5Qkxtd2NmUStFWUNQSGtw?=
 =?utf-8?B?OGtJdmU4Y0FnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QjhPN3M4aVlJVGRQVllSR09WTHY3Y2dKTFJBbUJvbzZVU2xuVTdHeS9SR3Rt?=
 =?utf-8?B?cGRjUUlJc2F0bUtkc2tHZS9LQjNxME9vZnlBN3MzNEZ1dENtVW5uTGtOcUF5?=
 =?utf-8?B?VURNRE5MdjZpSjVUQ2JhSnNaRTNGSFJZbG1YU05aeVl2YWY5R0lvV205bHdY?=
 =?utf-8?B?RnYvQjczQzMzL3l2cFpLbmplOGVzMEUzYXRyMnJ5YWxUOWRwRzlrZlFUdnZy?=
 =?utf-8?B?S0UxenMrREJRUVZXZGNzZjhnVWJOVnBzOXRPNkd4SW8xMDkzVDRlNU1EMjVL?=
 =?utf-8?B?VXZzZ0lRWTE4Ky81S2tORCtRbk5yWVlqcVg5REd4R1pQRzd6NWhwTXUrR01E?=
 =?utf-8?B?UFZCQ2ZDYUxGakhFQ2cza0tuTm1nZGZTUVZKMllrRnNEN09oc2ZXd2Z1K3hM?=
 =?utf-8?B?b1JrR2pudjgrRkRBeGJucVJpcGZ2TTN6c3htOXlTeHBiSEJZblBsWFY3RGt3?=
 =?utf-8?B?QmZ1eXdMWVBWWkZnV3BFTjBMcW9wdlQyYkptejdOV3dOZlNSUTlLWW9LRkxH?=
 =?utf-8?B?ZndmYnQwTExTWlk1QW1IUGdrNlgveGZlaXVwMnhxVm1mT0NVNFNmUStPVVBK?=
 =?utf-8?B?U285OWNkamVNOU5ud0Zrc1ZOcFowVTR2M01qOHZMb01lb2xmbHNlci9XRjlv?=
 =?utf-8?B?UjZQa0lGZThWdjFEWlA5UTRpeTZvczk5Z25xUUt0L3hwNjFDU1RFTjVQWkV0?=
 =?utf-8?B?SDNobXo4eXRDZ1lES3gzVjF0eGIyanM5alNiVW82WEVlNG54ZlNVNWlKL3M0?=
 =?utf-8?B?NVltOGF2cTVzazM2RlliV0FpVVdQYzBPakFWaXIwZU9hOHJpakdYL2FzRmRS?=
 =?utf-8?B?UHBUK0gxWlFaS3lCM0dMUnZ3TFRET284N2haTzE1eUVLWGhiNm1kVEo2TkJE?=
 =?utf-8?B?NmZxcUpUZXIzOVAvSzl2cXkzVmZydTY5Yk9kNlhzOWg5Y09qYWpyVDhTVnB6?=
 =?utf-8?B?OFhIMUE0MjVlcHNSc0Z4cjFISnN4Z1VpWEJnR3JlS1hEU2NQMlhPdTIyMmpM?=
 =?utf-8?B?ZFFRRzZWcUZna0kzRjVwOXdwZll2YS9NcFZSQ2p4Z2xScGp2UG4zZXRTNkJE?=
 =?utf-8?B?SXYreU1BL1BOVEhzc1NqWGplbDB4UW83VHYxRkg2TVNjaGt0Qmd1aEwvbjM0?=
 =?utf-8?B?dkZXVU9FMk1TTk5Kc0ZqZko3QzlIREVXcG1SdUlYS1A4OS9oUDVoeTErZkRJ?=
 =?utf-8?B?VUpFa0hkeFI2QUtwSXc4K3pMcUw0QUtaWTRkWUxWd2lNM1llRkNENDZCd1Z4?=
 =?utf-8?B?ZGF5ZnQ4cTdJclB4Ym1rV0s2QnJZZ0xQbnpwbU9PZ1dEUFJEcGlhT1A5Vmo0?=
 =?utf-8?B?TzlvWWQrL2M1am1aUkdTZGtUcVZPQlFaU3dOMDhuZHBIdzVML2FvRmJEYjF2?=
 =?utf-8?B?WHVoTXRTYXBLdkR6WHZmcUNwQldTVllwV0pSV09teTFzMjM2cXo1VC9qVVpr?=
 =?utf-8?B?RkppRUNzcmhnT051M1NoYkhxcFlzc08xVDJNZFcvck13bWM2QmlOTXRYQkZK?=
 =?utf-8?B?L1VKTDNYL1hoMDJJTDZZOHVqY3dZa2toTmN0ckg0N2FISTA3SDh3NHFZN0w0?=
 =?utf-8?B?U1BUY21FZm1QWUI4NWRpblNtM0ZRVzdRdnEwYlBPcU5EMnA1ckFHOU8rQlJX?=
 =?utf-8?B?NTgwbVFNSHp1NXV5MU03bUplN0pUQVVYeFBwb3QxanlpRGM1NXRGM09xaktF?=
 =?utf-8?B?em9sOTIvUTRCRHhiMWYrR1AvZGNTZEs0V0g4RXFmZVJkNzg4ZFlOVjJFd2FR?=
 =?utf-8?B?TmxodXlRSFVWaThyZGpVMzRtS2krcGZ2L09RSDU1RGQ3RGhmSC9QeFZaODhG?=
 =?utf-8?B?WUxZUURjeGZUWGZLZmF0Qk5PMXZ4SEQyd21nZGRZM0l6UEhESnBQMDJqKzVn?=
 =?utf-8?B?Y3dGbFVsOTFHQ0c4bGJ0NVNBQmZ1Q3JsNWVFNUxDcm5xK2JHVG40MmpQSGFn?=
 =?utf-8?B?WGZYWTJHVU5PRk5QN040Tno2TXczbERKYy9xRWE3MTFCQzU2SWFuVHNCU1FR?=
 =?utf-8?B?NHNDbjJHdGs1YXdmdVc0cjlvdnRuaGE4Y3BaWWg1M0FkMG9JK1oyNFN5MUFi?=
 =?utf-8?B?MTQ4S0tPbTVic3AwZXpsZHlRZDE1VzFoemJKNkV5MXdnUC9salhlUGEzMTJr?=
 =?utf-8?B?YzJZQm4zVHJ5YUlFaGpoU1k3ME8rVXZZM08vUm8xZVhYdGZldzRxL2xYSVp4?=
 =?utf-8?B?bGc9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac4d070a-18cd-44f1-892e-08de34386615
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2025 19:56:37.0481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L3wF5hEXNBu9KUnK2yPVHQTeN6IyhipWUrXdfyPnIQxGU2PIy0vLi/9BfP8Ea1rLzwIOENcId9w7BOLct+1Rwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6768
X-Rspamd-Queue-Id: 41D491C000E
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 7x3kt8w4gzeorm3xjywej4emny5exgsk
X-HE-Tag: 1764964600-765159
X-HE-Meta: U2FsdGVkX18ObIYVwYJEHZafO7X1FWcRvHSlU8Pd7sRM7ndkyxKZ0osJ3grNvJQoLU3hCu0LvVvkMX4DbNXiP0v5cT/WNacobjoOpEBzvM+rtpGvGfHm2gSiu/8HJ9FMEvK1BG/AB1r6CtWm6tKFG5AU7Ac3W/iy7tMoSjgZFLLkb8PmnlN7CGyHO1HE4zZ9t7bMJT1qT7MrHhfyGPOfq+pnp9zRB568VlLBw4gZGHlzMbAIZbzAjbtEH7fJmBwZib+8yTbRinOD74+qAcDzq8dF8825AnTZabpyyK2jwlo9Stg7MrdTXe1PypTPlNlasuxHSEM3/+DPGJGx8meZop3Kgi/Cm6vXEXSGEOaRXSumSas9daTNjSrNUXcEAL6aZxlQk5fqw91+ZWlaL2hQLFZQyDFNtoHqzONlAeBugxd1zgjI59rW9B28m1LUdkGgmEX9esBMS4YTrCDi3a9EPdL3pzGd4e87c+UzxwQr2PayPqF5upsRDfp7cpOUPfVGLZtIie6FQiDJndGrWUsERuVm8KPSLEdzc1lDACsZl+P1QViypEzPhu2pGOYNpcyDpL3DSPUrNvE6m76XDiJSYEBHILAb8k7befKF0nuT2T/GHnp75KAtz3YAqS3BTnqrCc7AqZjjtkv70MH4Whg0Gn07z7y3RMpNQWUZuWkvWkKhvFXKravfLa6shEAnWbc3MdTAYCIUWquvqmLuSOL/v0ncCAP3Q2r0Ny5eRg7gsxSg4q3dinbaYr7CARY6m3K6BfWh3Dn9XSwhRIx7FWBEIwMayHLDvdG0TUBhwjIRNfcW6L2eEkTMQBzoPnMwUrxQbmVzJA3+e7uJasIo0dpUFOsAdWSPcNFJQYj6RESfcOfAEnauEBlv6jJ+8U4ieQgXxbDc+c75SjZhPZVI+CHFtZrVFviKsr1SFQpy/Ck49G3ite4yc0OHKMAfyrDQ7Dn9Mn/uO9FqEbOt2lI7hQx
 qUdQ0bvw
 dcDvviKD8rP1q32pJuf77NQW7eyhKEOUnSQauHnuXT8GhPNMzSZX/A5VSfNMtWk74j66ODdBLa8uBWrC+xBCNH+nsTU4sC9nsIDAJV2BlSJCk25ML6JLfNPzhc/0ITfeGZPDhc2gjOWUbearubdzHrrtqxpm9+M0H8J5qKFzj/ZcnmhE1GWPxzaCqC0E7fE9HH71r8ZzACGfLVTvM42lsGRvqmLuEicFUUgd41vkbXVaS30L7GNr2Iph1T2qmSLvJsZ/rHpqhF/KePPvsx9igRN1/gWHJX1omzUMFo8Jh9SQSsrqcIkwRdSzwX2Gz7KjXFrBbJdMWUgJDTs6X+2i7xM3LtXdSGbuxs/ffUCjb8Eh2loeOcy5YZx8xbvs3fKmBpYg7/ohMi8QYslKe8sU2Wcijps0m57rNhitDzdaY2v9b6eXd8K3nfw9P14zDweLfsQ6qMaOdlAQceoFBo9nq0H/d9P8npeLnSkaV28tIql/Ut2aswTuauBzbEskZxLp42sRJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/5/25 9:50 AM, Lorenzo Stoakes wrote:
> Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") significantly changed
> how VMA flags are declared, utilising an enum of VMA bit values and
> ifdef-fery VM_xxx flag declarations via macro.
> 
> As part of this change, it uses INIT_VM_FLAG() to define VM_xxx flags from
> the newly introduced VMA bit numbers.
> 
> However, use of this macro results in apparently unfortunate macro
> expansion and resulted in a performance degradation.This appears to be due
> to the (__force int), which is required for the sparse typechecking to
> work.
> 
> Avoid macro expansion issues by simply using 1UL << bitnum.
> 
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202512041634.150c7e4f-lkp@intel.com
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
> 
> Andrew - note I've referenced the linux-next commit number above, could you
> replace with the upstream commit hash once your PR is taken? Thanks!
> 
>   include/linux/mm.h | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index a2f38fb68840..c4438b30c140 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -395,7 +395,8 @@ enum {
>   #undef DECLARE_VMA_BIT
>   #undef DECLARE_VMA_BIT_ALIAS
> 
> -#define INIT_VM_FLAG(name) BIT((__force int) VMA_ ## name ## _BIT)
> +#define INIT_VM_FLAG(name) (1UL << (__force int)(VMA_ ## name ## _BIT))

OK, so now maybe we don't need all of the rust/bindings/bindings_helper.h
changes? Those were because Rust's bindgen doesn't properly handle
nested macros, as I recall.

> +
>   #define VM_READ		INIT_VM_FLAG(READ)
>   #define VM_WRITE	INIT_VM_FLAG(WRITE)
>   #define VM_EXEC		INIT_VM_FLAG(EXEC)
> --
> 2.52.0
> 

thanks,
-- 
John Hubbard


