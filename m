Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01A68C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 02:57:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 802146B0088; Sun, 28 Jun 2026 22:57:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DA8F6B008A; Sun, 28 Jun 2026 22:57:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A1EA6B0092; Sun, 28 Jun 2026 22:57:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 308C76B0088
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:57:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8E1D9140537
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 02:56:59 +0000 (UTC)
X-FDA: 84931438158.11.7E74F3E
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012051.outbound.protection.outlook.com [52.101.43.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id C80E140003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 02:56:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qegzTP9J;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782701816;
	b=j7Ny0yry2oEo0d4EHIyVuweJ2QYnf1b6p99US4hejstAJgPZqoJXwpAKc4maQLk2KjayDS
	aBMA0xhfUzXHi4jTQgzuwF1M/hi8sU2+z5YfPD0KwmkxS1xXFa6aYDXZJwSebZUXubc9wn
	sk1J8yAYw4iEACoyI6M+aDAcOoSiITc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782701816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=EAs2EHcOYL8zbDW9XhBF9Tm8XJF1rTtykz2nVeXre4A=;
	b=hpkKkV2Xo5HOUug4JcoXTQPBsEUfrXTET4GR0nDTq6oo8Lv15RuEpb0CXtOzICHloit3y5
	BTcGbu1CtNfy2br2FNy5e77R35r/hSqJEiuwv0XQWUWYHG4rkeaI6bbpnfM+DUZNkzS2N3
	c4G+FFtdbeiOA0HCRs31AMdXf/yCRH0=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qegzTP9J;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ebq6LTDU77umCtMVlvHY+qFyryDEgiSVyO58goLtoW7K3OywvtI/brWW/ksvFNUMfRCoWV1lHwepB1iF+mz4/V1Rlg0R6Es3HFz+6RwbexERSBXzuA18ChXn++pJq8wwqqPdwdeOsXsYgWhfqtKSITx4jhRP4auFLJULOFioPgCoShBkEVefhC/lIGmCkimjwxs2y3iIhZsO27NF7dqly4nCHaCxVxSeo16xaMp44OSeD9OS8KMR6TxxsBL6YPNFbn9q3Aq6ESbqQK8FElg0SWepdgQhy7wbVZkYGuRaXW4opc4EqsO3wwGyLV+03mDtCwCa6KSupoXJjddiCqhdGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EAs2EHcOYL8zbDW9XhBF9Tm8XJF1rTtykz2nVeXre4A=;
 b=XQ9rvXj0kw1J0uB7iROVu2tpyedi8h1eGN+hk4PIiwRab95WKboNEHwSEwf5z1aJDlazptg8YdoSdkMjFsg0JhlVHj3nrXkUG7wguab7v8RFuD8K2BEtv+tfIyFMSOvCzBnSc484uZTm5nHsx2ea6mCyQeGOXxS+yM0A77JKUK+1GZxpRWTr5OYcc9eWVLHyt+b3h251Lhty4vlngkU67QKZgmRgsZ9yQzgVivHGU3BX/gI6YVMwUjCJA4i1CRpGBZdoph8TfOy03SCN3a6LmrR54FAwTK66a7iUnd4sGjpA+K3NIIeV7+JPOwc4hnwPPgPgC9pbyif+5TpmdGbSlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EAs2EHcOYL8zbDW9XhBF9Tm8XJF1rTtykz2nVeXre4A=;
 b=qegzTP9JJObwe87JkfYrIv/mhO/VkOt33h5KrzxgZoG/EFyJSUSrOyrn98wirFKlx5hWUbd/VaB8Y+iJPnyBOUteD7dmDpshaQZ2/IROMDqbcaRfEHsw3wL3psR0JtVskSQt5Z45N4dDDDB071fTUQ1XZWrWM3TTuzMM4GZkdWeMoNb8GX/sg/IkhatEknwOB2lGTxs8JTlIyKIfxsTm25MOda7uZBgjc5GY1F0dXLgQgAXYhVWg+EKG6wIscZfbs9yr+t7nxKSkJ1Bk6JcIKfi96D4TsJ+lLa8meWxc5E4rLffKiWb5RAqCzEnbpUfEsGN4wXYWpe/3lXBXLscbmw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by BL4PR12MB9507.namprd12.prod.outlook.com (2603:10b6:208:58d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Mon, 29 Jun
 2026 02:56:47 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0159.018; Mon, 29 Jun 2026
 02:56:46 +0000
From: Zi Yan <ziy@nvidia.com>
Subject: [PATCH 0/4] Keep subpage private zero at free and folio split time
Date: Sun, 28 Jun 2026 22:56:18 -0400
Message-Id: <20260628-keep-subpage-private-zero-at-free-v1-0-f4ce3930d10f@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANPeQWoC/x2NwQqDMBAFf0X23IUkVg/9ldLDqk9dCho2VsTgv
 xt6HAZmMiWYItGrymTYNem6FPCPivpZlgmsQ2EKLrSudTV/gcjp10UpLprusoFP2Mqy8WgAi4d
 /1o0LzdBT6UTDqMf/8f5c1w12BST6cwAAAA==
X-Change-ID: 20260603-keep-subpage-private-zero-at-free-a1e1435025dc
To: Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>
X-Mailer: b4 0.14.3
X-ClientProxiedBy: CH0PR04CA0002.namprd04.prod.outlook.com
 (2603:10b6:610:76::7) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|BL4PR12MB9507:EE_
X-MS-Office365-Filtering-Correlation-Id: e052d284-abde-4646-3136-08ded58a0f05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7416014|23010399003|921020|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	E5QXMKN/gV+sR9dgHz870kAnlzQBphCF0kNb9o4Xo9n25pY1hZVDN87STcYVNtLtiaIJQQohXRtSy1LFa5WZxJu87M4H3NbJg8yN3t2CSD9cyL7TOZvJ6BwkdcKDKmxSIRoCI1q7PcFgw89PY8b7aHqcdRVVZffWHrKYgvIZ0kbKbpjtCgnX2SLGlusBAPVB9pohf62mmU/wCJ5f3JICgGwI3TZS1XNmdZ1/ICN2yHGtxTjTlHrRaMBAoimJ4001Waou2J9yiv2mCqKC8J1UkF9LPsxtpZNVPnGQIbSHKicrq5pTH4hQvQ9cGPr13Zsw4h7s/PGy3Sm9V6EFPEDMf7L09EdBnRpuoiyDAQZFjGhVMiyAgoLJgXqbCLxrq3irLrOrHgWviD3FBMr+M2rx/4qmjeNdD30nXnX+zseElx5FfEwPoN+RhzSz0N0gyS9b6oZ/OHuMX1bWrAbXuNAsgYdjZzjqou3PgqDAWR1T9suGbmtIf3y9BuyBwTiSiqtnmI45YG3JBdmfm6W7dZJv4FhoZL8ZDwSEg4H37F01tv5SpYW9+N2z5j+VIXNjLpDx7sV/VFrlEDPHzJG6u6YCdcnL/H6KPANlCKGku/BuYh28VR22/uxa4nLuu1FqPA1mrDd7JFOjRu3rJo0fBCW+g/6PdxXuoOspKaY8Ko/pGmS8U0mjudtx4aEs9v2uGxOy5uv2ktaKaRoPMfePergVkg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(23010399003)(921020)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S1BSREFTV2V1dEhTViswekxocEw1TzVicnNZaWpaUUp6RTBrTmNveWdxL0RW?=
 =?utf-8?B?cmpkWjdTMkpnWGJPaFZwbDYzTGtTNGRGOXlTdDdqQUJzQWs4NDluSWNKUFhT?=
 =?utf-8?B?SHY3Z0F4ZUdPbm1pd01DNllKaExkTFBRNHNJMnJpN1NjdU9HQkNQc2xqdytO?=
 =?utf-8?B?bldxK0x5RkxLYmJIYTg4QnNlRXZKejF3TUZUMnhYQ050blpUU1RNeWF4cUJi?=
 =?utf-8?B?NDcyNC83NDhjY0EyWUVQb3E5c0VFTEN2a2ZKQ3Y4M3RjakR2MWdlVjk2a1ph?=
 =?utf-8?B?dUdjZTRFY251bzZkTk5KRG9idHE3VjNPa1kyd0NodzZGclhWMWQwclU0S3Y1?=
 =?utf-8?B?QUw5Rzd2SUdhOTZDZDlyek95Nkd4M1pqWm5BS3p1dWlDczI0Wm5xdytwV0Q2?=
 =?utf-8?B?RHZjcmw0NndlYnpha3M5N0NDY2NBejNmNGtvd05sTUlsUU9XMWRTMjB5OVZO?=
 =?utf-8?B?WVB5YUlqV0ZwRGY0L0g5OTV4aThQZlpIc1F6QlpsVjFiY1Z2QU9SRTJmNWtO?=
 =?utf-8?B?a09RdnpPS0dod3B4a2Q5T0w1Zy94azZ2dGYwNWJSRDlycUF4OTlaV3N6b0pB?=
 =?utf-8?B?NFNFRXVRQ2lrT2tEMHBPVk90elorUm9tV2dkVC9hN2dUb202dnBxQkdvbUlE?=
 =?utf-8?B?QlRTcHRaUzlvVER1emdiYlR5RjZpdTVnR2lxRXNVQUFvdXNuUEg5UXp1VkhY?=
 =?utf-8?B?ekZzK3N5bTk1Ymw1WDlGUnpwbkVHSG9UajRINUlkdkxVNVNXK0pqby9ITzVE?=
 =?utf-8?B?SmtoOUhwU3oxUUcvanliNkNVSEh6a3ZhdFlRYlBwUTUzTFRIYVlhM0ZzOHFT?=
 =?utf-8?B?MlkvWVlpZk5lMGhFN0JTdkJOVVBVUEVjZzl3V2JLQjZlSTZLNTErMzA0RWZy?=
 =?utf-8?B?N1R3QWJKM1BIbmFVZGJ6T0Q5NENFVERCazR0ajlyNVN6cFRic2pGNmJkNllW?=
 =?utf-8?B?UEJoRkxTbWNGWlZNdDE2U3dWYWVpS1BPbVVyUlMwOUlCV2tCZGgyc2RlSjgw?=
 =?utf-8?B?YjVTRGpETDIwRTVBdE5zSTVlaGhtM1dMdWxRWTRxWGVoak5EdWNoNTBnaThD?=
 =?utf-8?B?cHJjbUJlN0dXdU1aU3RqSWtxNXVMNG55OTlEOWdIQTRKZE9tWWJ4MjJrRks5?=
 =?utf-8?B?WVdLemU0NFRrYkwzaUpnWFNCOEJsL3JEb0VCdTBmOHgybUtWWDZDUi9wVGZj?=
 =?utf-8?B?R29pdVk5WkN0QmFocC9xUlpaRVZXMTNoR1J2M2MxV2h5dUFrMmlUUkdnNStM?=
 =?utf-8?B?MjVvWmhyM1RLY1NWdnE0VkRORlhEbDM5bkdvMXlCbm9zMUNmaUJRKzE5NzVK?=
 =?utf-8?B?VERWTkdsU1FkaWZQZllLKzkzQkRZVDl1WUlycDNrWHNKR0h4TEhYVjFveHk5?=
 =?utf-8?B?c0VKNlRyZDJESWRJemxCaHhYREtnT002L3Q3SXhMRXBQTWR0THdIaWltcFBD?=
 =?utf-8?B?dWFvZE1aVXJHN09ZVnhkYlFxQ3NjTWtFVTZVYmliaWRmWmMyZ204cXVEbU5z?=
 =?utf-8?B?bk13RzlOeWY2LzcwV2JFSW1FOWxrSWJoUFVoQTNEVjQ3QmhlbkFwYzEvajl4?=
 =?utf-8?B?UTJkOVZSSTRTQ3lNOHl6Y0k5ZEdHSnhZbUVYY3UxQUVqODRwR2pkMldENjlh?=
 =?utf-8?B?NU1mZzhIL0F1bUM2RSs3ZVQ5ZG9jQWNYaW1sMmFrQVZQUmVPQ3hRUXRrT0I1?=
 =?utf-8?B?Q1pIelFkS1RrV0NsYmZYOXhVcjNOREx2RFBGWjZZdUZwVjB6cVI2akZpZUZr?=
 =?utf-8?B?NzJHRHRsaDluNVh6YWVHaUkrekdQL09weFR2QmFqWEhRblVhV3ZnOUJtei84?=
 =?utf-8?B?emE4alhhbG5ScUZING15Mk0rUFNJdU55VmJud3lGampYcWM2ek5XZ2ZCREJI?=
 =?utf-8?B?aGhITzVLbEdCTUNsa3lnOFdlMENJM2VlRE5Tc1pOSDVWSitmUVp4aVpOMWtl?=
 =?utf-8?B?NG12NjhBczlHbW9Ia1dVUWUyOHlHZWtYNU1xV0U0T3FZNElxY1RPYUg2Z1Er?=
 =?utf-8?B?Uk9uWGx5a0h5ayt1REcrcTA5cHFMZjRQOGtRRXNNSlJkQm56Q1F1N0UwMjZW?=
 =?utf-8?B?cUowaXBCdlgrQ0ZtWnBxSTQ2UVEyK1Jad3lxSW5xRWhmMWJHRDlBMnR0VzEw?=
 =?utf-8?B?bFlEKzhHdVBTbElyeEVveE9Fa2FhekFOSHVDNFpaVXdNOVZ6cTVYcmRpdTlT?=
 =?utf-8?B?Q3FpdEcwd1YxQTMyZVNLSktpUHRUem9Nd0dER3pCMUpPRmxaN0hnVG1FUUJi?=
 =?utf-8?B?L2llaTZHSE5iZWd0NFA1bjQ1Qkh0YUJNTGZXeDVJTSt4WDd0SjFxYThXN0tj?=
 =?utf-8?Q?ST+kA7PMpvgT057zi6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e052d284-abde-4646-3136-08ded58a0f05
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2026 02:56:46.8479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gltLaIRWgFfm1dqTGL/ihdkdvb6g0jHxnIIfqV6BVVf9ZRcVJdIoJK6Jc1nuxSEG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9507
X-Stat-Signature: d84jahf6q5nppdtcbcecw4jffws6bory
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C80E140003
X-HE-Tag: 1782701816-422986
X-HE-Meta: U2FsdGVkX1+KVEsbM5BoPzuw2wavZ+ONSBk7Yq/BfZlGB21wE32xYfgR9NsV4zyJdo0s48map4LRsmRXHSImKfz3fvMQpH8sYduO9TfoH0gb003zkZXV9UFfpIeD6v8/CzJGGClW/wyA6n5FymSI44RaUj/SBSFq4VSDIPjmDoXwXsNCe2RwiEABHW7KCST2vnuLGNEaQ+mHqN44faPGi4uUqJCdXpIQnvimqf1Ra+ECw3AY6S/SNDOxcBnGYUW70tUOIpQ8kI6ayaqEhCeVMHeXvNiu0OxSswi44zQKGe0VTwDerxjOMdG31irToYQyb8uI9fSqlDdDBf9LWKY7koJqJUpB0b3xK1hGr/hojxiHfV3bxvpeBaPo8pEFlv7immiZReYeKo655UVUm5QNvz5qfPP2wCvF8Egm1Uj3BiMdfuR/ZI8XrF6AgXGY0DVIhypJVYR4TbB4Ho9aSW9u8JVERHkcEJFVvq2uipaVQbftzPsiPFpSJjVSycSHrn0gti/rNpaJ2pd0/2Y4Wx5VnSdPQLqflkdjTqpbCgGPipqNtKFtiuLnGQ+Fpmbe4MQb4HRXeYYOTgb9o4e1ae0kM6pfLuGHbwBTG+T1DfUm9UW17qlVcJoELLKN/7pWW8iQzLImVwvTkIG5m9DUb3FuljfSK0OXFi8nUG3r9llkdCMIjl8PtJOtZhrzfSEZlPSPdhLCGNVgrNmvuo9voakC50L/vMhGNCJOOyPk8t3KQFvJM+H7zo0iOBqx5aXwdiWAkhqWuLevP9J/sleS8qNMN+kuEGu5jQICq9qJkoScKZuCpct41txqVEM+I0L4Ra2U7vbEe0kkWlE+PS9V9yyUqgh1lS+/jcNbbCOCbjxldNcpyxNQcD2XDyQVDjM1qXyNcwzeuzyAJy2i6z8mqXa6o0JpSk2oauFR/idwTrw8AXWgDMNi1VyASxge0siMEdxkiPwAmxP5aAyLF72xLdA
 dk0Vz4oY
 3hB447LQqKJQ3/LFfeTcQeGHtwoedvz5rWM9PrFh6QUCT/Irtf/PzDD4HJ1GOYVvxfF2WB3vsvDtPrdt9cqDIyIKr5Mm6ntuH3NM0rRg/4xMsWVbIBHccr9ZJCZmzfqcmH3J5lsnsbQWs1oeD4SgLCNMeunFo15wkZ/hyrs/E/pZEBIrgArWpnVX94RUr7hJz8UPez4YL6Sk3qQf2XBHvPgFhehc8x54st64M/tYXEWaDe0tTpCdx4csw87ERZJNVeYVBw9QXDsuZahewfli4GCklMX+zi70LtLLhnL3/o+H2OM1UEssrKEohkwHUM6vEA/yYTUbxbaFTctu1JETY2sgX0Jg3BxH1q7YJVXjLV8q3tbSX0yaZw9MRMiu4uLxsER73lKbahEDut6L5+TAB3gVnWdU2EETZ7thiqBmhZUgNDORxN81GxnyomTS/TLmZWzma
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This patchset makes sure subpage->private is zero before compound or
high-order pages are returned to the allocator. It also checks subpages
that become new folio heads during large folio split, before their private
fields are used by new folios.

It is based on v7.2-rc1.

Motivation ===

page->private is zeroed at page free time since commit ac1ea219590c0
("mm/page_alloc: clear page->private in free_pages_prepare()"), since we
concluded that it might be too much to ask every page user to free a page
with ->private zeroed. The holder of the last page reference might not know
whether ->private needs to be cleared.

For compound and high-order pages, subpage->private can also leak to later
users if it is left uncleared. The page allocation path does not zero every
subpage->private field, so they can be seen by new users and cause
unexpected issues[1].

Check subpage->private at page free time, and check tail pages that become
new folio heads during large folio split. With those checks in place,
prep_compound_tail() no longer needs to clear subpage->private when
preparing compound page metadata.

Overview ===
1. Patch 1 removes setting page->private in compaction code when a free
   page is taken out of the buddy allocator. cc->freepages is indexed by
   page order, so storing the free page order in page->private is
   redundant.
2. Patch 2 adds back the page->private check for tail pages promoted to new
   folio heads in __split_folio_to_order().
3. Patch 3 adds a subpage->private check in the page free path.
4. Patch 4 removes subpage->private zeroing from prep_compound_tail().

Link: https://lore.kernel.org/all/20260206174017.128673-1-mikhail.v.gavrilov@gmail.com/ [1]

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
Zi Yan (4):
      mm/compaction: stop recording free page order in page->private
      mm/huge_memory: add page->private check back in __split_folio_to_order()
      mm/page_alloc: make sure subpage->private is zero at page free time
      mm/page_alloc: remove set_page_private() in prep_compound_tail()

 mm/compaction.c  |  3 ---
 mm/huge_memory.c | 10 ++++++++++
 mm/internal.h    |  1 -
 mm/page_alloc.c  | 12 +++++++++---
 4 files changed, 19 insertions(+), 7 deletions(-)
---
base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
change-id: 20260603-keep-subpage-private-zero-at-free-a1e1435025dc

Best regards,
-- 
Yan, Zi


