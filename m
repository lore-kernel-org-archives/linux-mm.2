Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 465B5606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 14:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=DwI1We68
Received: by kanga.kvack.org (Postfix)
	id 48B5D6B094F; Thu, 22 Oct 2026 10:12:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 442FE6B0950; Thu, 22 Oct 2026 10:12:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3058A6B0951; Thu, 22 Oct 2026 10:12:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC17D6B094F
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:12:54 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7CEFFA5D27
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 14:12:54 +0000 (UTC)
X-FDA: 85350453468.17.402DB6B
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010040.outbound.protection.outlook.com [52.101.193.40])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9D6732000C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 14:12:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DwI1We68;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792678371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=edVx3dL+q3+hwntZmlbioZQYyzerBVklrHFuF1C2sC8=;
	b=yDcdoBrjoLINr5it7uJ7TaqIj/U+ngCH8qbxwH4ykJnxQXiDnZEilPPhPQnQh45qkEPUsZ
	pUJyQXSU07dH4uzGIe49zqWIYgkPrDV7ZR06QT5vCu698SIA9ba1RP/rvOHA7mZ26OF9b7
	j5QyozZJY9VXm/GXLcovq4PbKvRYJTI=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792678371;
	b=smahMdbGDUd8qWXIwj0z2sPCS52U6Tvh0yUsL/G2A+T5qn6IlgYD2cweMQhhfh9byh+gOy
	kIsJ/etT2mSyZRYevxPlhNCPjsdkpqCS0pafr1zFhNHlzWPn/zr5sz4Y6vV262Y9BbMWQS
	8apRysBZI1gQdmEG42h9kmTPmx6uYi0=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DwI1We68;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kBHI+f5bG89fL3dyiwZ6jThTP6dtVuHXKbz3gSANZrvhISX0SlzW7rqMjcTM3ROiwN1dyfOHJDJpfo+wOBt8gnWrTG163br5QcUEDcg8xFxOOQLth3yPDwNLwfcbbsjJCDNb8+c3vMepb52PPI+FJR1fUqDbfHETHBp8kHGXolC/0fhAbhg047Bhtf+21CfQhLOHT+9tXNCjXjAJ6pc0KWE1VhHvKHuFM2o3DTWqkNYA3CGIBVmqZehrbUr7NdzzOCzRAsVlKVrkEoJU8JQh9iEj6VrfsDxk1L5Lo5qpbR1rOFEMJcwGjPNtoR9Iop81vjaPZ5bv3RdihG+gjPMkig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=edVx3dL+q3+hwntZmlbioZQYyzerBVklrHFuF1C2sC8=;
 b=FsUynIBc9c9jgC5RJF9sVlQuoOwVb50k4jigSWND4z94h70jVSQhDUTZsJcs4WCsfQIv2rZfi7jb3xH+sb6PZN6eux5JbTKy80j3H3moYbI7rlJmvm6Vxl9wxqqYlFfFkWNBPl1HCkUdV7gBBJgXw+ETLQPLp5d7HpI9HLBGsZCKHFvOKnv+6BOxgWwv8EO4NH/v2tymfe9sBl5B33AahupKFbxqDsznfQA2ZzVEhDu4yjHTYIx/puxlekl870aedWqe8HMIPL4O0x57YWNs+AGNgxXxIMy9in4tD2A0SBv+sfFqnh6RicMiwn0/E3hK6jXuyXqdSORxjlDmeQ0V9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=edVx3dL+q3+hwntZmlbioZQYyzerBVklrHFuF1C2sC8=;
 b=DwI1We68/aPi/rx4CpGiGEhRor8iEtwOfrG29707bpIfSXeWtvYQFR2GwYoXRpjBupfZ3CmVSHkF1hyHXusCn7s02OA4ibs/aXOiDHvj6anqtr70NmAnHWqnCpZKeIB20GF5574SzwtO9xnQCw63CWD6Bqd6F886BWhFO54iQAPXy6dcNRSjKdQdw054l6ylvKa3DOzamnX0JWgaYUwNAm4WveEC4MdJqeCU2Xop5V2YbL19Anum8PS8rEjS/EqYi9avOWpf+8D//V3uaKPTkgeylGWml7VosCJmC5IU69QG/qwXXxUiaXz+qAKJOY0eBMypEYVorAGS2RDiWkVsDQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MN0PR12MB6173.namprd12.prod.outlook.com (2603:10b6:208:3c6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Thu, 22 Oct
 2026 14:12:45 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0522.017; Thu, 22 Oct 2026
 14:12:45 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 22 Oct 2026 10:12:43 -0400
Message-Id: <DMBFFYYB7137.1E4V40K7E0TT7@nvidia.com>
Cc: <akpm@linux-foundation.org>, <vbabka@kernel.org>, <surenb@google.com>,
 <mhocko@suse.com>, <brendan.jackman@linux.dev>, <hannes@cmpxchg.org>
To: "Zenghui Yu" <zenghui.yu@linux.dev>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH] mm/page_alloc: remove unneeded forward declaration of
 __free_pages_ok()
X-Mailer: aerc 0.22.0
References: <20261022124504.75642-1-zenghui.yu@linux.dev>
In-Reply-To: <20261022124504.75642-1-zenghui.yu@linux.dev>
X-ClientProxiedBy: CH0PR04CA0054.namprd04.prod.outlook.com
 (2603:10b6:610:77::29) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MN0PR12MB6173:EE_
X-MS-Office365-Filtering-Correlation-Id: 57931897-c77e-417b-f04b-08df30468b27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|56012099006|11063799006|261021123027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	HS4X+q7OuyROXdJQ/gq8mwaIxuIGuYoBALdMQMJoMIKt3lt3wan8xXIvuwMxFqotxvryeKWbwyGp4oJf/1gF3i6FEnjwrbptYw0ByUIL0Wg5iWd92qpdxUHNU6BtKZbto3fvVKTq2OOQXw2AxS0zU2FK0KmzhSGUBKBepdwYKR2cU5G095dzsyUDPsM4ehC8EWohm2d+HLHViwFqXoYXVazXq6ioIszl0wpu2+VT7SQgz5hGxmzPKKwEXMv6txb4ZpVwOhPPg/5dy5bNpIw33s8BJ0vOodHjjJthfgw1ew7VAuAvUjc4AZkknycbg5wl6TjJmbUeUQ9lDbwBiYCdUtpC7VzPLc4BQRf76yPkV9dUkZTQ36Y6tZxY9nmRe9x0nCHLO3zn9+AN8UVtFr4vo9Fs0qfydg3+bLGl+T44rO+B6GWs0abxOM3UCEBPTUPhWNihf7LczGef/0SdZ2uwW5A21BEXawtRqEj5jL/pdenOgfkZYE/C2FH/PVsdIeaceoh5pi9qFADNllFYRCEzqouDRrO9twVs0g77XlT7GFs+sssEki6m7eBAnW0SBA9z1K5eSe+RAH3yolbLgAS9d+yg9WaVzI3Dw0zATEc1fhfs/ZY7ZulfhCgTUfnMc+XpieeG4UYtSLWEoDWbJOolGKHJ/b0/ngABM+HPYi0vlnY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(56012099006)(11063799006)(261021123027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TkF2NFY4cFZWZmplMWNSRU5RcHk4bTJOeCszQkY1Um5VK3BmRFk0M0V3Yk84?=
 =?utf-8?B?Y3hkWE0wck00RUFPc0Vqay9PdFp1Y0MzNHMrOHNrU0E5YVlSSWpZSEpyK2hx?=
 =?utf-8?B?b3NYU1duOE5SMXRZTzFwQ1Q1VXJONVMvVDRVblNjQ3F5MkxhMCtNQVJ4TkhK?=
 =?utf-8?B?QnNiNURGbkpRdUEyZW56Vmg4Z0ErbWJpbDNZNllDYWxBNldDUVhLbEJMYm1W?=
 =?utf-8?B?TXJ3b1oxZGFTUUVjSjg0Rml5VHk2bC9UVDVOMXlVNjN1T0d6ZG5xRndGUVZZ?=
 =?utf-8?B?YTJUa0pWZXV4V1oxYmdIWFdqTTJDcVVneWJMaDJJVVFhaFZHM0F5WGVMOElh?=
 =?utf-8?B?b0dCYWk0UWphZ1FXSnUyN3NEdEpmTmFhd0k2ZllpdURjTmxsTEdTdHFFTVc5?=
 =?utf-8?B?WFkzN3NnT0NxaEsvWXBCSjdzdTZTSHpLNGVVSWJTZVNkWHNJTGJidzlkdWM3?=
 =?utf-8?B?YndNYS9XSGZ5bjNUaDFqNTQ3RldHcXM0cHozdnk0VXMweC9tRFhwTGFIRVhs?=
 =?utf-8?B?QUJKaDlZVnBuUVdPWkdUSUZndFdxVm5EbitPZEtMc3FnT2RqakdNRUQrSzRj?=
 =?utf-8?B?Yldwb0RtSXpNcGpqWm9pbC85WDVwTVQ4Vm5nNmt6TmlrdE1Vbm9NVEJZT3hR?=
 =?utf-8?B?SGpkWWhhNkVvQTF2ZjhuOGl0M0RrYUNCMjVMWkVFU0NnZ2I0Y3hhd1RJc0Yv?=
 =?utf-8?B?WmU5dkZLbnRWMENGV3ZVdW9ETnFMaE90QUV0K1hESENMVVplOWd0YVFNUVhI?=
 =?utf-8?B?cFY2RExmT0hzWEIrUXNWRk1LUm5IcGJHVHpZSnl4Qk15NWpDMzE1cnlPRXNp?=
 =?utf-8?B?djlHTDkvRXphVVYxK1VSZkhPTUkySlVkcjI2VjdLOTZmR0craEVhNzN1YzF6?=
 =?utf-8?B?d0xpeW1Ta0liUEtmRDcxMHo4bmlPUVRSYXg2YUZzRnM4YW44MUZZNStOZUcw?=
 =?utf-8?B?bkZ3bHBZeWwxQWVmWUt1d2dQOEhhRENBcnpWUUh6TWxBdTFUM3I0UXVFNVhi?=
 =?utf-8?B?ZnBOclU0U0FvTVBrMDYrV0hacytxMFl3RENVYlNPWGZxMSt2Qk1VZXdlZW1x?=
 =?utf-8?B?Z1ovaFJqRU1VRFNFMzNUR2pwbHVSKzk3LzFmZkNGNzZVem5CT0Q2eFg1ZVpX?=
 =?utf-8?B?TTBjdHpmZE5ZNFMzd0Y1b1AyL2xUYTljdUtsZTFselovZm44bjdhaERoVkJM?=
 =?utf-8?B?RFVOUWNCU3pMRFBlQXEycVN6VnBBeWZMeWtqNHViWVpGMVRvKzRrbDAxbU5N?=
 =?utf-8?B?dTN2SFlGNFR6YVYwRk1jc0ZQQnd3K2FYZTZzUXBUVWFvbWNGbEhLVzJLWWZw?=
 =?utf-8?B?U1BUOTI3eG1WMG92czdqeUgxWHA0TGs1Z3REZTRCNTE0M1dzMnpPcVB6U0RW?=
 =?utf-8?B?cFNxL3M1cjNIOEhmejRONVRDdGw1Q1pwcHhMSTVmU2tVSmwwcnpxcTRHY29Q?=
 =?utf-8?B?WjNXanB0WUZ2TXdpOW45R04reDZJaDJMS2JGMG9talFEeWJQYXhUNDU3K2Fk?=
 =?utf-8?B?cWFKM3hPUVIwazJJNHZxN0d3VThRSDE3Unc2eWYrUnBrVHY3clhLVTUyRUZs?=
 =?utf-8?B?ZnFSVGJUSWJ6NUQzbGNlTnNnMCt5eHNNOElnenVUdWZrUUtmaXFJUHRRU1dV?=
 =?utf-8?B?SEVkeno1S2w1dnZ1YVplTlNEeDRhcVo2TnMyTnVLTG8vVHhXVUhMOVJ3ZWNq?=
 =?utf-8?B?Z0tBdktBUUFpSHgyOHhvWFZEMUpCQStWRzRGbGFjb1MwMTdhYm9RNE9YaUYz?=
 =?utf-8?B?djlMeEhVb2Y4cUczdUtUcC92NW5Bc1hsWjM4SEhRYTlDTXVhRVJPQ2JDOHBB?=
 =?utf-8?B?QVlhSHZsdHRXemx1b1hpTmZSK0NjZ29zcVhnS044ZzBRTlRhbTM4VkJjRWFv?=
 =?utf-8?B?RzNrRTJvSDlNRU9raFVWOFhQL1IzZnZpTVh0bWF4R21rZFgvZDlEQ3RrRjl3?=
 =?utf-8?B?eXhjMk9YUmRPMThCemova2lxeXpqaWdmbHlxallNQzVIeHd4REgrWXFTMTBt?=
 =?utf-8?B?d0hyUkxHdnlFVG56eGJRamNGZjN6TkdUTGZKZTg2S2hsaU9QK3ZiN0dKWDlV?=
 =?utf-8?B?bWhtNnlsckpTVGJwSEhzRDhrekx2WGgyRU1nbU9ybm9XWjhLVjl4b3c4eG9j?=
 =?utf-8?B?aDVXTlZES1J6RGtjZmNVcGw1Z3l0bzY3TXhDNFo5aWFCVERwem9nQ0hDa1Uz?=
 =?utf-8?B?RVZSdFB1dGQ2UXBES01va1FvVUpmaFREQjlXdURJd0RGcWNlZ2xpNCtaNWls?=
 =?utf-8?B?eW5Yb2FTK3FJTkpOc0UxMmJVc253MGZJd0dVZWs4NDYrcDgrcDdmV01OUTBZ?=
 =?utf-8?Q?g3XXFqUXk/18f80dao?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57931897-c77e-417b-f04b-08df30468b27
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 14:12:45.1467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x+RA/0fC/LtBNpqOO8Ij1l4oYHOjJ5M2LZvc5+6/pRupgqal41ssXgaEzhgB5/cD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6173
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9D6732000C
X-Stat-Signature: pchx9zmkiyfgpc3cswibkafhurpb6zhn
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792678371-604674
X-HE-Meta: U2FsdGVkX1/RwJnASqIXwIWBHcEVFjHUmI0RIXpnPJ5aN5WSmJHjD08lH1YcldPnx0uOqaf80qtuhx/vBOoNTTAGEDy5M9vxhbk1MldGrV2ndF5M0CLawYBb1uv9/qz14jSQ5GqiOg/tleGvZ0WvXLBCtksW6i5v6Zod8umaD8uw4LEPh3cMQ4L8TtYUEoS2AVvOEd+oSxtdV1lRlaB3zw8SlF+Z52nO0c/c3j/MMSSldHOAcsVBiD251YXqQ3xOytIc795xEdnLc4J8NUMnn5+3lS5U2b9TXvUVIQHu3GRAAw/tkABPlyfNuCA5aDvEZSUgYAG+QRCMl4UPUWz+rNuNrZDWfHQ/mWpkorW8T8argLH13EYhPlWKKklqQI6oaMVk86KLDi+suZVr9TRH9igWCfnyt6VyO7U8Jdon41UeIdolXKlX2GE/SRbNj+U8h5HYjIWLjS5x9WnLl4JZ0tBtzksTI1YhmGtRfJjGFNsUADvYturBmorzgF+gXvhU8bs1oXuGj+L5GIGMyXtfhy9oqe6jDPAwgQ/JPy/0R+vSCKbL9l2UXfXTFX4N9p2zsBrBnNp/CMMugMyIlF3Io3gE364Ty8Zo9SZyVtVOaVpLTqD2c8Jl3IdJ/9CBfYzTtxEdGoT5PHLv3CbNyaTqDmMZilaIYTSp2UzyFj4t6SD6JpwyLqR92nVS+5/ynGhHfU//pTjFPM5nhs+rrLLMHFKViPXr3i+wQ+wUtCyydpytf7nTQM3JRHHTOQOSWAqB8Yer785BWJR2Q2godo/r/eu4H9bqGdWP25ow6GcLOT4Li8CJ6Yy/wxQshUEtRLEMMDNPEgJv0AeEB/rxOr6QTKl3QaPoLLmfKTmoBpvKFa66WLy6RVmYN9DMuQLkvMRthjxtq/omuXFLqZyqIjTIsmBP6H4PBIcj6R5pvdtpDbjcfOF4HrjF21DrUksGiqT9MAG63UqJNompBo6fgzH
 5NT08BOn
 tepObrKAj1gWBpvji2fw93OtYgaPw9lTd0vs3rGy9zop0qZhuVB/6jfJsXemyb6eOMoWEUZvgXYl8AjFebzURWLhJKmvacDtUGJAeClCTL002B+EZaMRhzsRkamYl0bZMjv/jemq+xuJEWPMDJS0SJ3WeUEijgXY/eHS1uzYOJjnDZQoR1+qGpxyWCo1jOfffiUm6aK2yd1DbEeZmrnm5mXQUfl9C+O9ezgcf/5B4OuvZTqWJaFQwGOEzdvUBEhzaMK/w4yLivF0LSQh4ci58FBxafHhq5hJ39y5RyKwfF0BeESA3Z1IH8o5V4HDeFn+lO2UzsaU/lgNviVfce3IgzpR7eUp8f3VAqBy01fFGP89DOjaGXzQ2Wh3OqrxSJ1CbTahzrhtjo/Ec50GBl+bCNfh0JUM5Dwtg96dm1E0dHfazD+zd55qq/1DLX/UJTyI7gARm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu Oct 22, 2026 at 8:45 AM EDT, Zenghui Yu wrote:
> From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
>
> All remaining callers of __free_pages_ok() appear after its definition, s=
o
> the forward declaration near the top of mm/page_alloc.c is no longer
> needed.  Remove it.
>
> Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
> ---
>  mm/page_alloc.c | 2 --
>  1 file changed, 2 deletions(-)
>

LGTM. Thanks.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


