Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA7A3C53209
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 01:44:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BD0A6B0088; Mon, 27 Jul 2026 21:44:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96DA26B008A; Mon, 27 Jul 2026 21:44:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 835B56B008C; Mon, 27 Jul 2026 21:44:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E2F96B0088
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 21:44:51 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A287580279
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:44:50 +0000 (UTC)
X-FDA: 85036491540.18.D72E1D7
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013009.outbound.protection.outlook.com [40.93.196.9])
	by imf17.hostedemail.com (Postfix) with ESMTP id BD0AC40005
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:44:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="ZJr/5jvP";
	spf=pass (imf17.hostedemail.com: domain of jhubbard@nvidia.com designates 40.93.196.9 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785203087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E/E+Nvts1GXsiZWFLcXPZEzx2guAEsaAZmheNQRzvPI=;
	b=LCtWA8tJMiEsqJzbutD2ylDJqqrSCom7FpsmBnogX9+0SA7e2JoGGIdtQDMGT5he6BPG4h
	WBLnn0bcKKvDn+Ct54HTifN1SXlUdfZ0cOUtoFEYUACA4yUF+xC+zQHVqiVU88gZ4bS14I
	iMadyRaEimqyhsQP1KlQya6jYKQ8m1k=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785203087;
	b=8iIbdD3YXscU3iO/f0ctQQ1l23ZwyHIcWS/Jy6siVgLeO9icOroBsht3u3xL6QDu2FiGsb
	wyZnfMNTCUdrE5b8nD9Yc4H3P3OK3EoMWBZ749GgkLSyepszMYyKCfBSNjLOc7iortBn66
	k87F7NNkeumsMjPpbdTM/axAaqa0wC4=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="ZJr/5jvP";
	spf=pass (imf17.hostedemail.com: domain of jhubbard@nvidia.com designates 40.93.196.9 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Srfxo0eFwX1Vs6n0VXk8DeAjubHPWd6AtNC1yZbTNmA3ZzZOm/zJm0XX4e9ABzXKQ1/fraXj6u5ZXoeL7lkEjVttf4+NqJ/H7YAKSVqr4vGAl9/JDbnd0o6mkAWIkA5Esr1/B/avIqaRlKI7bwctthKq1mnUh8yyDmQ6gHHCkeVoyrJvlwwhJ9c6d9mu5cymjJLGjS+WGKVNilCyGhYh4LbDYzRLvchIptOnh4toRdDs+EcmWWeqEgjUbAhps67cHq1wRF9/FbxlV2OcRQxCJUaEjzdVJsWEChhMJ06k8KvpzKlLPpAb67xiKwCFf+wlYtSY3POCWEGzwSwZA0raPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E/E+Nvts1GXsiZWFLcXPZEzx2guAEsaAZmheNQRzvPI=;
 b=UqSPtBP1b5PviCcIifrKfhGU9Zwhm4wvCdsiBnkQHIIYIElJzXonK42Swu6sCgwqTIxO0cOVEa5tmeopZgegJo6DUay8x938NAWbV8vi2sQNSu/BDbsD4ulZv77j/eJTfSSZDW+y4+WdIBlPXhvvY15XzPCBM1/jF+RuLUiCeYqRZoRycuVxKLlguc/iFaYR+T8N7N8NRDBz57fPBOja2G8sRWLbGB02b1LiGv+V4zLhaof/Js9dcgD4kZETlgy5OuU1ve3NIaRyZaKsU0OpnJ/BXCcpaB7tD4APqH49VoF74kcM7vRgGQkamYT64o2mhs/vfdGpDD3Y5dMt93lglw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E/E+Nvts1GXsiZWFLcXPZEzx2guAEsaAZmheNQRzvPI=;
 b=ZJr/5jvPi6MjQfY8S7bJLIkbO2o+OJTFJ5F7hUCIJtU+GhgnnrKVeINF0uor6qnn8YK3upygGVELIqfXDiGC7oVpnN94T1Q3wZYeUS0LOywVx3C9Vuf/ciSyiDTUaN6xj4PtuEqCqwm9G/VsuLNPbxJp7uYkcHzGP0vgq7mqysq6q1oGmV7LXK6LI8D8MGaVdvIoZn5Cob2XWrZ5tIHaGe2Zc5n6JOlCNVdMDK91A4lQTgrD/QFEtOGQRCuOGvXMmKvtIW1nZ5IQ/3L/pVdcmJdSY4YmRJrtUMOAM1BA62RP3XFBoJ0FbWnpAvuVHkwBxsc99sODhEtoiQO/JPJbJA==
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 SA5PPFA403A61D8.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8da) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Tue, 28 Jul
 2026 01:44:43 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8%4]) with mapi id 15.21.0245.012; Tue, 28 Jul 2026
 01:44:37 +0000
Message-ID: <be8c93d5-9882-49f1-995a-0d7c99450027@nvidia.com>
Date: Mon, 27 Jul 2026 18:44:35 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 02/12] riscv/mm: add
 untagged_addr_remote_unlocked()
To: Rik van Riel <riel@surriel.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-team@meta.com,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>, Suren Baghdasaryan
 <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Peter Xu <peterx@redhat.com>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, linux-riscv@lists.infradead.org
References: <20260724222934.1463812-1-riel@surriel.com>
 <20260724222934.1463812-3-riel@surriel.com>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20260724222934.1463812-3-riel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ2P220CA0011.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:5da::15) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|SA5PPFA403A61D8:EE_
X-MS-Office365-Filtering-Correlation-Id: 3397df4c-456d-4618-6bc4-08deec49c89c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|23010399003|7416014|1800799024|4143699003|56012099006|22082099003|18002099003|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	wNNFZ9b+ZzKVM0vPjrai+VWrk2797BZOcTP3OR+okquSXaW1Qii+jHl+9DzUpYVA/nak6iE+vLtJtxgGOWLwYDstZna/DRiIa1g554vtohyBvzp6LUKwWXiqMXPOh0pUUhP0em96hUOAMfH1J+oFdcgHjcD5y10IXNlSKcT2a1fe1YPbj5Ul/FeR/U9subkiJn8bg+B4sNsg0lFeXKgvHDG4G+RNlG1hlWyW4pmuQ8RFfQCq80VSgUvpo4ot73Y+86LDWNJUOzqz+/j+Ek4A0Le0s/N2Ymntyod7ziuxHYtUPWlKPp8zwviy0hdwcd39d7bODC4frO407FECec1ithhxKDpnY3pf7/7LJO5uBGOLWPn4KHKqH9hVTux4eUzbkBROpioVW8GlLBIXpFvHQQ0xmcGzf7xZSzabf7F4NiIsSC98ECt30Tp9amqTJi/RXcQk94BU+Z9Bfdr2OVfASmvtw/fhzGFcfbsJ67RFGQ45+2xcCv+b8gpxVlNR7IygofJqICUwXvI1PO9ULEttV99UGQOhMCqkDUKRyE/UHlul3ImROlirDMSq9CKNK4uN8sFuW1thqJHvArh+ee7r/pGeMu/4WXl6vtG9rKZPn87KefJyjcwQm4E/vLuMGB5XEcrns1dzkkmGFUSrkdUwWQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(7416014)(1800799024)(4143699003)(56012099006)(22082099003)(18002099003)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZythUjlob0VTR0thcjUzQnBMYVYwSGZ3cXFySzJGaWl6UWt1aDh5NW9nbUJN?=
 =?utf-8?B?MjAxQzZGY201SFU1VFpVc2ZqVnJHMGx2VkF2RVplZ2RlREhrSmcwTVR6UHFB?=
 =?utf-8?B?WVVERUNBQThyL3ZmVTg0d3FYeW41QlVqZ2FDOGRnY2tRNWNpMm1iNi9VbG9D?=
 =?utf-8?B?QkF0bVlreWhkakZrczQyOGhtMDIvd21HaXZsL1VVUE5RZitGdC9QNU1ES1Nn?=
 =?utf-8?B?TUtqeW5IazJiNklTaWhVYmJ6NmFSbll4MGVGSDlHRUgzeVZYRlZheGJOY3hW?=
 =?utf-8?B?ZmNMQ3lvanZJNWp3Rzl2ai9wR3RBd1FzNXJLT0puZHNyNUNaK2ZnQXdFRFc5?=
 =?utf-8?B?OG5WaHdUanQzS3dTWWZhNDQ0a251ZFJiNWphbTBUM3Q1MXFKOGJRUTJuQ0tN?=
 =?utf-8?B?dEFLMGg5MmovMWpUeU1CYi93NythbmRYUWg5aGJEaTdVM0JiRGExVldhK3N4?=
 =?utf-8?B?aERucHJDUTh4TVBwZUV6YmIwdW9acURmZWkzNnYxamxqdlVFSThMT1FvcFZx?=
 =?utf-8?B?Vk9sY25qL2JrYVVnTHBQbGpZWG9HVHdhM1lsdEJJTjlBTGZCRFRLTHROQWVD?=
 =?utf-8?B?WmRRRU9KViticG9zT3JKMENYUWNLMU1jZ3BnSHhDQWdUc0VFRG1HWnNWSnJ5?=
 =?utf-8?B?SUhVbHVuU05UYTRsaEhJZlVBSEtXaWJJSjBwNzl4QTZHVWZlQXpTVmJrZXh1?=
 =?utf-8?B?V0l6aTdlMFlmZUdvamlqUkpCQ2RTRzJyVFpuU3RPMHdwQmlxT0dsYTdsa3Er?=
 =?utf-8?B?ZzZPRmRUbjRxa2gxTllDRDBGZFhYWUEydU9uS2s5d1RDL2IxbnBVN3cvM013?=
 =?utf-8?B?N1MzTEZqcTRuU2EzQklodGlKOEYwSmphZFVMNGI0blFYNHFZdTNvUE1QK0N1?=
 =?utf-8?B?U3dQK2U3MGx6aEMveFFQUkplcGY0OWduL1h1YUNHUllCd01kQ0NjUC9iQlh6?=
 =?utf-8?B?SExDaVk4YWJaZnYxQmtVTkNCT25tVE8rSllGWVBSRWVYNzV1Z1NkcjJId1Vm?=
 =?utf-8?B?aHVHZWNobnR6S1BGSGRjNlM3YVVHZDZQQzB0TW5uU1BUdVJsWDFpMGRqdEpP?=
 =?utf-8?B?SjhKbmwvWXJIVll2VkpBVGQ4RDRhL1QybEVRdUFBSGRaeFNCRDBXQjM3Vy9W?=
 =?utf-8?B?UUxhSEduZ3o4N3BFME01TVF2c1BVeWJueUt6NGp5L0RmdjVWVjFHdklEWkhB?=
 =?utf-8?B?UnZDNnlhNmlRVUkwMEdkcThmZlF3MVdUVUJhdnh5ZGZnNENOdjA2b05QUFJk?=
 =?utf-8?B?MXVoT01FQnovbnBubUE4MzRjOWJCTTBBVlRONkg2ckJLV3E1eHF2RmVvcjQ4?=
 =?utf-8?B?NHRqTGM5eWpjdUNqWVlBVzNTLy84NGEwQXI0a0l6dDNGV0s0eDdKOFR2Y1g5?=
 =?utf-8?B?R2wrcXJEMWhxdCtvalloalRRTW5Va1h4YmNIaittZStBTEJUeE1XNEZtNVFi?=
 =?utf-8?B?YzdOazBlQ3VhK1FtS0lLN3lNd1FPWE5FajhqOVdrdTFVSUF0RG03Nk5EaDky?=
 =?utf-8?B?djVwMzdrT1B4alJIOHBCWDhwS0E1cEtING5SUEduVlJnbjZSZzJwSkJNSUdX?=
 =?utf-8?B?ZzhFMThLd3FpOEZOYzgwdDZ0U0pmOWNFbTIwd3J3T1loNjdYVy9FTVpWK0hK?=
 =?utf-8?B?NkZnZTVoMlV6cVBDVEEzeHgrSG91NkU4d2dyeHVGVHVBOWZjZkZkK3p4OHdm?=
 =?utf-8?B?ZStnS2d4dXlwZ3JoZ1R3K3hrTkpnTmpDWEhrM1dZekVMTURmUW9IT0pYdmlx?=
 =?utf-8?B?OFNmV2NXU25mclppZFJ0R2FOZ0wwNm9zVFZVcnlmTHVQZTNNdGp3TlkvS2FS?=
 =?utf-8?B?bFVobmlIekJGSGhvRHp4cjJxazJWREJrWDhrZ3Y1QkNPK21SbW1OaW82dFBR?=
 =?utf-8?B?cHcrMnZnUm9yTllwVU1wY0tiNjlGUTlENVNSSGsxU0hHcUNQNHJjRUxmMVB5?=
 =?utf-8?B?bENQRUl5RjB3ZHdrY1B1b0FmMzV5dnZKd1loRDFteHVyZ2tFek5rMXYyUUVs?=
 =?utf-8?B?NngzYkxwam00ajQ5TlZCTkhGVEtROE82TFdGZklrWnIyYU5aYXVRdWVRK2ti?=
 =?utf-8?B?QWw4UWhlSlBPQWhhbHlHSzUvL2E0V0JjaS8yRENrUU1QR0h0RzFZY3VXRnpz?=
 =?utf-8?B?NzlwbEltclo2bk1nL0lhTjJTUzliVTArTDNNWU1LcDJVQ3lwZnFJbDcwOE5T?=
 =?utf-8?B?OWxnZ1dKTnNjaGVHMWY2SUNwY1J5b0YybjllRWI0VVpndGsrYnJkWUdKVnZm?=
 =?utf-8?B?RjBZSlpGZHVySDJJVkQxZGtFejIxbGt5cmFjeE5ScHJuQ0Y4SmUzaFFxYmpk?=
 =?utf-8?B?bVVTaTM5TVFKaWZQZXdzWmlFdGVycGMrSlEvT0ZnYlpnNy8wUGRtdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3397df4c-456d-4618-6bc4-08deec49c89c
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 01:44:37.7765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4+i9Sq9kusY6cXKvgOz6WMRtMhoEn9c5rfsAB1YqLjgvgcJdt0d7PNCfVVMJmBw+ZcyjHYca1QYt3xbHuDE3BA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPFA403A61D8
X-Rspamd-Queue-Id: BD0AC40005
X-Stat-Signature: h6auqe6ieoi5gfsk9si5sgwfqm8ut78c
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785203087-496490
X-HE-Meta: U2FsdGVkX1+ODWCbXh72Uw5E98RjtL63r+PF3cgSNKgVR6kFgYryxPwgriTx/O6sA5mK6RDqeoch2jui29NY0if0UxbJsVD5qJ67T9GlzmILHK01VjQLbQCpg6wt/jZtPmee4W/YcYhtPZ26gU6rQJBAAaWJ2KRPvEU1mu2wfRiU2/fFGhW1nEDhD7LFbbwZ2Bti5oNQqGLcrh0CyTMw5mghyEN+563ffyVpXnV31Nl5IGFvX9m8rKqeetfTQt/2hWgqZ7Yg6XGxLxEmvBh7S9cZryGrficohZDPS5PyL+jLPGlUArfWUBeAyB3cMsm1egogP965bD8KuSfFsxwLXlKlyX3SeiebGs57nr+ItoBPn2/ouJ5Gos4GWn+0gKKQgSblpuypwrRO3XCZZCfiUhZLNmaBT50gHgMtj8AcQ8hTnJVShJNKueF3KzB8jV9V1mh9TFz6JGZg3iPUy1LhBtlnVF9bbWsWvv01DgX+TnSTvxmFYTqjMc4TNEaQ4eZTbmE+0db6CRsbuXTl4fa970VHbYscNhB6p9eO2xgXb3ArAmMOBRAkYqsRC+xbh+FL+cSVQ/sAgIrIBFYY2uZ3qqkeFKFuj9N9jGCw1CrEGcmFgSLak2PIe9Mx+O4iRnW7hk8w2hd800Ua2+dGvS/R3TfMdkfhrboV+Rs7MPqzAZtdrMrzdhIpysftipW7RLvzZbBLlPaNIU0ZnAN6TakA2w2K9krDNe98wERO/LF8g7/lbq1nTpkf1OeF3hePVjrf0xJIxWq4FsLax1m+IvLStSO07LLc9iQ/o3Jnur4hSuocc6nxtvQQ+bbGPnRDLi3uN1waMl5WV2i7fHgoaY0GdgjXbjSOfW3ThpLr9lD/ehlISr/x7qVfRN6D4vs06bWXAiHdbQNGgP3JYDd4spgVdH0LgZjC3m1+CggTGWylUn/cI71mDHx70F9VghuD9xj1mTgHSj0uQs60p0IIGbp
 E2EJz1Mv
 fr2TrFawJ1laGO/HRXetyZxkEJwZJmN3XjJcu+AilFBn+AuJvG0LYRJRL7HGma55RjHX2OdtnTbgxVElfkLp7+GWdUL/tHWmNpqALm2QvLVP3xVhGOZ2ycAUgJ4Aop2qcC6woUkIu2QEq0TVXAPDvzDjzmsF+0D0Dgs4NRekbxxprxQMpDddKwYWFmHovqtjiCg64BqJ9INpGzAx92mNa5Wio4OuYDm7BZM8fLhbDzJBf7e2aFo2IPjPteEyIngNzSPggu4tnkc79H/MWYrLD9qGwaqiwvTBpx1Zb5G6RkLqaY9bpfPqk/7BTQ5A075Xnraqdi3iw2Ts6CQi8FNIMwL1w8fruRQ7ZyM5oBjYbX8bdBNdEOA/CKU1U0CHVsPFx1VmTYwFqahp8V2xqP43mcQSgJ0khxWmiBxsiudmNKqI+zDC6UlcjGRjqg+Ijw1mStZ/B+RElP/ukyzI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/24/26 3:29 PM, Rik van Riel wrote:
...
> index b2df7f72241a..6ae7552fed09 100644
> --- a/arch/riscv/kernel/process.c
> +++ b/arch/riscv/kernel/process.c
> @@ -357,13 +357,15 @@ long set_tagged_addr_ctrl(struct task_struct *task, unsigned long arg)
>  	if (mmap_write_lock_killable(mm))
>  		return -EINTR;
>  
> -	if (test_bit(MM_CONTEXT_LOCK_PMLEN, &mm->context.flags) && mm->context.pmlen != pmlen) {
> -		mmap_write_unlock(mm);
> -		return -EBUSY;
> +	if (test_bit(MM_CONTEXT_LOCK_PMLEN, &mm->context.flags)) {
> +		if (READ_ONCE(mm->context.pmlen) != pmlen) {

I think you should remove this misleading READ_ONCE, because it
implies a race that is not there. The code is happening under
mmap_write_lock_*(), and so does the only writer to pmlen (below),
so they cannot race with each other.

> +			mmap_write_unlock(mm);
> +			return -EBUSY;
> +		}
>  	}
>  
>  	envcfg_update_bits(task, ENVCFG_PMM, pmm);
> -	mm->context.pmlen = pmlen;
> +	WRITE_ONCE(mm->context.pmlen, pmlen);
>  
>  	mmap_write_unlock(mm);
>  
> @@ -394,7 +396,7 @@ long get_tagged_addr_ctrl(struct task_struct *task)
>  		break;
>  	}
>  
> -	if (task->mm->context.pmlen)
> +	if (READ_ONCE(task->mm->context.pmlen))
>  		ret |= PR_TAGGED_ADDR_ENABLE;
>  
>  	return ret;

thanks,
-- 
John Hubbard


