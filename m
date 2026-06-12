Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D4B2CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 15:53:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 251456B0005; Fri, 12 Jun 2026 11:53:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 202EB6B0088; Fri, 12 Jun 2026 11:53:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C99F6B008C; Fri, 12 Jun 2026 11:53:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ED1C16B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:53:21 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9D893A0188
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:53:21 +0000 (UTC)
X-FDA: 84871705002.22.B28FBE2
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012041.outbound.protection.outlook.com [40.107.209.41])
	by imf17.hostedemail.com (Postfix) with ESMTP id 81B1340007
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:53:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=f6of9Q9M;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of Pankaj.Gupta@amd.com designates 40.107.209.41 as permitted sender) smtp.mailfrom=Pankaj.Gupta@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781279598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OlmAbBFj1CK/TIvylqkJexWuff63+sD/C5tyK3c/PTs=;
	b=GijS1jtTx3mwFuIT+FL0YdbfbuPCGKRV1nSFZUwt2xCPiHj2CMpmXhIaEftetOQccMi/oP
	lEzEuYjALU9cSSLbxfQE4IXKw5khJkLn2EByTvS8fvbdhLzV1xoBf6uS0uMISSn0+UfWri
	cWyyw06JeCwmls7eI/e/rBg0mbYq9qo=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=f6of9Q9M;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of Pankaj.Gupta@amd.com designates 40.107.209.41 as permitted sender) smtp.mailfrom=Pankaj.Gupta@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781279598;
	b=pwixxOqdoDJQbjDe8EyyibyujSIJbNHpKFAUbxsC2PWcdD0GHcQl3R+5LgDJf0AY6MQMVk
	n3DDrd7UuiISQLp9cjx3Z44/5pj9kYoiWSzktsGE2CNBtdEkSzdr+pTUley3FKM5pZ82yJ
	nNgHfIcUnQkcwdBYEC6/Lycj7+a/2sg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YJzCyXx7OvwT1MukrtvCE+XsbuhQYHMg18M6HE87g55h4rZo6HOgBSpaVcDZBGsBT8jeaTtyfB+huMzfMb/x6Vl14aVgRzURihPOIPlKr973ZJdj50rPR3bSAEji3rLHQoVo6QFfLkQbUSyWhroESArRhNdAOeRopNcHCV9KP8gY6Mc/sWfmkPjENmDjVtp5DDRCWifbYTb9TZChPUME/RSuqIFGmsJrtu0pL6Lqhv8JHkiH9+AZocidJkS6p+sKSgT8dqhFhwmzHOeT9ZKZQNyBN19NHKzAdwJNvsl27HjV5Scod1VdV/A+mcpCXxhpDpqIt/UdpobsT/G5KCw/Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OlmAbBFj1CK/TIvylqkJexWuff63+sD/C5tyK3c/PTs=;
 b=tqlZdEXf6zv8fYgE/lAY6qCVllW4PcIPUyKBvF5DhO9PGBODFo1+Il+zKCoBx9d+t49jk9/FaH2CN47SYdBsRsIkZ9XnJKPopigGu2GwXrH7ZgdQ45IBc4LbM1fO4vZ0CNb3lsngxke4/7cxTML8ROKs1Ix5u6W9QxxDhN6ViSZiGIlizDlSzUsbEp6CNSb3mLMGoyi9n5bDsae7uFAC4bqvCxGBQoY5nhJpGGRvFWKdm8nyBokeONHtwh0sLniXQutSjFwwb1cQBNKko4M0MXHdBS2hos6Zdlb3VENDtdp0H8A+gBfBcESRdRq/vTpCAG16ioN/WWJp/R1/u7ix5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OlmAbBFj1CK/TIvylqkJexWuff63+sD/C5tyK3c/PTs=;
 b=f6of9Q9MjkAJTJJLjekTFWlnGLEtsMosLPcUTeiJbVxHsQgiS9UkzFzgiP8crWL+z4x+FJJ0nnTD6/5x0Fe7zhT/vi/rQU1G1+Z59nOO3iEhyo2ccuvNr2+OEb8T32oH1tutx9aPO/xKhzf+EiRRUNK8VkSrXBSEIdBXhgsOWmw=
Received: from CY8PR12MB7433.namprd12.prod.outlook.com (2603:10b6:930:53::22)
 by SA5PPF530AE3851.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8c9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.15; Fri, 12 Jun
 2026 15:53:14 +0000
Received: from CY8PR12MB7433.namprd12.prod.outlook.com
 ([fe80::faae:d638:bdc9:4bf6]) by CY8PR12MB7433.namprd12.prod.outlook.com
 ([fe80::faae:d638:bdc9:4bf6%3]) with mapi id 15.21.0113.013; Fri, 12 Jun 2026
 15:53:14 +0000
Message-ID: <2374350e-3468-41b7-8239-f351e1db3932@amd.com>
Date: Fri, 12 Jun 2026 17:53:05 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/22] mm/page_alloc: don't overload migratetype in
 find_suitable_fallback()
To: Brendan Jackman <brendan.jackman@linux.dev>,
 Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>,
 derkling@google.com, reijiw@google.com, Will Deacon <will@kernel.org>,
 rientjes@google.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
 Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-9-28bf1bd54f41@google.com>
 <646fd09b-0dfe-4646-997f-22e464bca024@amd.com>
 <DJ75GER4WC9G.3PEDYJQ5T0EWL@linux.dev>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <DJ75GER4WC9G.3PEDYJQ5T0EWL@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0437.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c6::7) To CY8PR12MB7433.namprd12.prod.outlook.com
 (2603:10b6:930:53::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB7433:EE_|SA5PPF530AE3851:EE_
X-MS-Office365-Filtering-Correlation-Id: e78c0c97-86a3-448a-9f56-08dec89ab611
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|23010399003|376014|366016|4143699003|56012099006|11063799006|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	FQDa/KfagB34egnqTt9WdggLJYJ1sX4F+rsodPwF7ednK1XkdiwOfQxs9nFUcWFj+LfFPgU28JFDaoAjgf1OlXRnhhC7HHLlDX34PVwVvYaaR/+59rlStKnU0dLYkFjJ5xuy3ZsHEKg/CjVwnPsmjrr5bUT9NV24JEx4gD8OE5g9ueGqI7t7xXCCIcxt8WPcWQOIr51zO2DPAYxAsyD63niaDZS/jZxeKHWMyEwNgxY1HXG1ZHW2LZxmrT54S0ZakyEIWOu7F475/XSKzNsauF7D1hhPWjMi+fS1pCVm1r+iFEaaA+1CueSrEKsXJGAJQA93sTsP2zsom/IPJuefcQ1VU2QNwyEShCihexyFcG+tQ9z/a0sfNYFmL0eR8KjuYJ6pB8ATjYBBdS+jDQ1jzz043Gm6YzYnVuXeVtJZpD4mvAJyUwrF6Ta4Dr6Wy1LSq+41Uxr9VbrvIazRUFZH50yTdSfxiq5nJqJtTTTLuT9uOAEUQDUGbuBU9T0he7CyYlm8cBpIcM5QLjhuqohMz2vUeJP9Bthaahe7ZHEKyyZ799qfe1TWBW3Oi9XPNvwv4ahNi/ebn8oOC0nR6SHQJa9V2Nh2NwSwO59189fsXbaseoBfdY5TZMsGJ6+Dtazb2y9fRVptfpiiH1pyp7jBCpxwx93+8TGPIy9HX2XYgdJJWedHDddA1/ckZoY2LVYwRlBqULohBxoDbxQQNdftuvX0I/+WdTzAckvSK0tmXqE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB7433.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(23010399003)(376014)(366016)(4143699003)(56012099006)(11063799006)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZW1YWVJzQTh5eEU3VnQyRFdncTVZd0FyOXZ0LytUY2ZGbUZCalkvbnpjc0lQ?=
 =?utf-8?B?dENoaUY1K1l1dHBCcXhjVUJVbnE3RWlGWjY0cml5Ky9MY0lyMGc0eGVqbEJS?=
 =?utf-8?B?NmlYcFhwM0N4RklRYWFpZGZWcEg3RGhSaSsyMjhpblg5ZDBJOVJ4dzlQVFd5?=
 =?utf-8?B?NVUwVzNNTHE1bmRyNXRTL3ZxMzY5VU1oSUVuSU9DdXNlaXdFRUhpdGpNTHJB?=
 =?utf-8?B?WFhrcnlJNzl3NVNmNy94YU84S0JxT1FWMkw3aHBRd21FYWkxdm0rZDhUSGZy?=
 =?utf-8?B?bjNucVNvNllhdEEyK2R3RFZWK2lFTVZNTXk5Z2ZiaWVFcjljcnlQRXRsQm5C?=
 =?utf-8?B?TlpCc1lNVlI3UCtJY0JESTM1Y1hHaGNZMWREODB6Q1puWWRBQUY5cU02SmZE?=
 =?utf-8?B?N1FMK2QrSFhkYWVoeHloMmFNN0owRFJickNwdU8wTEx1OGhLdDZYZzVMOGVL?=
 =?utf-8?B?Skkvb0l0akdVenB1cDFwTWZjWGs0QzAwbVVnbVQrVDk4S2J5YXVreGlLdGpr?=
 =?utf-8?B?cWMyc1AycjF2alRtNkVFMjk0cisxcTRTK1V6UzBWN1l2b05sYTcvNW9WU0wz?=
 =?utf-8?B?TEI4S1JNcDdqQXMzZ080OUh4Qk5uUitIQU1kVVV0RDZlcDViZWcweXEzenJO?=
 =?utf-8?B?aVVTd1NHUEwwT0I2MjliYlh2THo2NlFLRTU5dnNxamFkYUtTeExidHVwVk5P?=
 =?utf-8?B?ejRuMkU0MmRUUFRmZTFlY2J1akx1RVY4aW5rcW1GM3ZVTzBUYW5NT1doVDhv?=
 =?utf-8?B?TXBpNDVrUHU3S01TTG5rbkVZaWd2dlBuWG01TFdjblg4QWVEZ1BKRkZRam1t?=
 =?utf-8?B?NWQySkphVkdnWWNvNVdnTWdremh2TnppRmpnZ0JBVTl4a2FyNXladnpuRlo3?=
 =?utf-8?B?TVNFZmlENnRUeEQwWUZaUG5HSVR4R2ozQUhWL1lsMXpQZi9vbEdOVllWRStH?=
 =?utf-8?B?bmxrV0hadXhuOFNGWnFhTGJYNjN1WWFUVnNlUVBMSDVYWUM5YWZLTnBPT0VY?=
 =?utf-8?B?Zzc2eG9jaHQySTF6QnJWYVV5eGtFeFRjOUIxSlFTbUVpbkFadjFzMFNZT3Jl?=
 =?utf-8?B?dXdlQXZkejRzbC80Z1IvNjZIbXZrQnVwQXppSGZaUm9KbHdUeVVTWWFnZ2d4?=
 =?utf-8?B?Y1VNNS84NkM1RUlYS0pzRlBiZ1lMaFFYaFhyOHVyS25ScmdiYjNtVE1UeU9t?=
 =?utf-8?B?b2hXTjdaRVdlQ0hoZXJJTDRVUmVrT2VzMkRqVDlEY2hrMTkwbDJRRVQ5dzJo?=
 =?utf-8?B?ZXhoVkF5dEZsZENQN2xyTStQbGtucEZvV01IN3dGZEJnTkZHTzRtVEJVVFNv?=
 =?utf-8?B?eE5PSys0VFdUMnFyKzRxUlRmekllbFc5eGpxTHNSSnlXb3dsYmg4QzM3dGlj?=
 =?utf-8?B?SnRFRlk5YUJUYzZnNnBURWd6WUYvS2FKTm5GdTFXTDF3NmlTekdYY3RkQXNx?=
 =?utf-8?B?TmdrN2JKVVpIam9FS1haRW8zRWU1bklkcVlJUXVGM1AyMTcwSFJmTlBXS1ho?=
 =?utf-8?B?eFI4NjYvR1MyZWtUbU5zdmZCWXdISmgvM0FySk5DcHdRMExHTFlVd2pkNVZv?=
 =?utf-8?B?dEpXYW1nTGtoNXRpWWprWS9RK01pWlVoQ3dFUWtiSUNGbzU0Ri96Smx4Q3VR?=
 =?utf-8?B?R2wydmJUcTdIOENSbkduczFWSDlLUWpHUFNxZlFaM1dPZGJ4VkJySVpGUjhB?=
 =?utf-8?B?Y052ME5GbXJSeForS3NBSUlHbFpIbTZJMHhYaTdEVDNLNmlHZXNub01oN0Nw?=
 =?utf-8?B?M0Qvb0tXK2wyT2FaOFYyUzB6UUNZcGRwcHZqUVhCdENnNXpBZFExZkNwWFY3?=
 =?utf-8?B?bG9UZDZ5MW5UZlhtVlg3c1RYekVsNzB1VkJjUEl6Z0hmd01oSlV2VElRcGIw?=
 =?utf-8?B?eTB1M1BuZGVESzFBOEVxU3lKMS9lY21RckwwT0VJemhPY1diWUcrTmZUdXFp?=
 =?utf-8?B?aE02d0FsSTZPRmhLZVRFTno3M1V6Q21ZWTY5QStFcHo5TFlYbms2eWF4NWho?=
 =?utf-8?B?LzBFTERYTGJra2lMSzZ4WkhNY0tyZitFNjRuaDlZbytGV21zNGVZSzJRTExG?=
 =?utf-8?B?U2U5Tm5HWWNrR0VLQzg5TWxlYWQxU29BSFFJOXBqVE5LOGpaRmZ5YkhhbXpl?=
 =?utf-8?B?MDJaakxqaWwwVEFDdFczd0NWOENvT1lZd2lzMk55MWVQWi9aTFcvSlE0a3Q2?=
 =?utf-8?B?OTZaYXcrSitmNW5YWitMcGhEcXNiMk5mTTdNNzBzQ3lJQUxXZ2dvNUMzL2FQ?=
 =?utf-8?B?OGhXTCtreVg1cnBLRWh4SllkaFh6ZU54aHdVaytPWEFLVHFJOXluTHl5V3dm?=
 =?utf-8?Q?j4tSUxgQkBwEpvqvtu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e78c0c97-86a3-448a-9f56-08dec89ab611
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB7433.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2026 15:53:14.1202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hqjto44YXHr+sHRGJacHrRYx0YPHy511R6OhfMAFN6FyzP2qTH6DMDCc4en9BT7/EYYf3uPeuNjDQBhzSncNrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF530AE3851
X-Rspamd-Queue-Id: 81B1340007
X-Stat-Signature: ytadzcoim47buqrs5w6cothfb48dsfz8
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781279598-206107
X-HE-Meta: U2FsdGVkX182XDHryDojGKI3J0dL2u5/DNq4HuqlD5dVdjtyluVITaosv4NY29bMhxB1655tixysYodUmNJOZJ/EdzovFER00D1+QSRhfcMHegtRyOGoXIBh/AY6m2G32NFYaj9tCowWzVPMfQM7yDc5eTha3038sxlRIhcZVgPnH9L0TF5XcHJKD7AUJL3ksOH0Nrfk6quq2hF6cjsDttaA7DXipSqjpEpNOkU9ZgqiwnAh+TmPge4btSU6kxLz6hwJhrDJRfegIyTclT8zGYbjRT+rJzk/dV1pGWALypaA+EycVq1qs6lLnukfIpK+gi/VnFrzy7WXArcXzH7R7iA6jglVlb902pBGWtUuFXR+Rtx+pWmy6aY//RsBBYwgf0EACOplNL3Xkmjoj1nsRUiWeoVcXK+UqW31DvGaxWh/EKmHJBPg3XLynzkIePmKKsGgJIn3y6jXd+aeauWilUo6pUp/gz4CR7ZmMPNicOsO29oLbBCqh7JLZXdBc+WDe5Pwmn0uWMbyjRh06z+vlWEJJNY2kmUJ8ia2CMBl+z+AJX1JS27uZaCRTWQI0gpUQ/TiDK+OAoAjLQ1rmNkQUS/AnDqDqjhZFpV0zgbXwRs3K6z2kjDTN4e6KJ2s/qHh1dil9S2jLXVH4Ij7UnlcX64FvnIrp/e3E2yclM7DGjGVZaom31M1PMaUOwi/mUNUnBTjX5tPVrv+YHO9kK9G/Ht7c7M+wOWJ9P+0WqwL4W/LlL+XiMYreBDYFH2S4h7de+2wm51Gfr9Te3VrP4fbZNLP6UAiSsjFh76gbUvdXlin5IeRHlT32+RM4g95O2WEuo1Yv9F/nGcIBchm/GeyQMhJniSE97UYbeLS+T9JVzeEkrdScswHXZ7Ebfo7geKRYnJLleDAsNrJcvayR3ODxwgSl4nM6H1+BS8QrswJMw8eRo/OH8vhcDXFEm6hCBylIVRhEQ69DbYsj6zfmO8
 3u9peT9I
 HEHGx8aBbR/EMLiYDb8qreUFKDoVAe5Mg5AFB9C3+WCRgKuo/hhC8JFAFRleMXa9liGl1dQzCgMTw7PloMAnyfx/dSGRTH1WPxVXx64Nm+Lf6eho8MlyoGgyqwPen+sRHZhUEym7Hx/2PuIq02nG7EGUYq/6q+s9PHrTBHoXuPeaBjRoQdCNFcfHkyvjrq5GD/6hH2WINrThjVpcfOG7NdEVzXUtsIOwcuJPk+Qw4Ay3bqUhhATSqYtS9b3XDD2DnbQWXV8vE9LoinLhAWk2/JLxuKN1XyvY0fqur7tOAXcuWPyCyes7LY/OgotIR6FxXGuR4daqKjx8LA2AJve2zFa4E/WxCEUQmwPXBAddTLhqbYvKDsNzkkBbk1JoLY7Hpv84j098CzLSXo/SnZXpeIpy8nXsAKXTNGIub07o3HxoMN1mdAXoZIdMSOfe3tolRrZUIX9wtT3eDycOC3SdJgahZUNKYSlSm83MEYuqPnsjvMQLkwVG56raTBSmxEkp6leqIOrZJSO7D1MspoMrYgax21g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> Thanks Pankaj - also BTW this and some other patches were already split
>> out into a separate series and they are now in mm-unstable:
>>
>> https://lore.kernel.org/all/20260503-x86-init-cleanup-v2-0-bb690bd2477c@google.com/

Thanks for sharing this. I’m reviewing the main GFP_UNMAPPED series and 
will also go through the separate series you posted.

I am also interested in reviewing and testing the current state of 
guest_memfd support on top of GFP_UNMAPPED.

Thanks,

Pankaj


