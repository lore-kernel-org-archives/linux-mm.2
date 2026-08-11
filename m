Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3DDDC5CFC1
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 20:55:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 080AB6B00B1; Tue, 11 Aug 2026 16:55:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 057BB6B00B3; Tue, 11 Aug 2026 16:55:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E891A6B00B4; Tue, 11 Aug 2026 16:55:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C2D226B00B1
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:55:06 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5D8C980228
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:55:06 +0000 (UTC)
X-FDA: 85090193412.07.6174402
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010006.outbound.protection.outlook.com [40.93.198.6])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8EC4F14000A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:55:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XZaOl+KV;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.6 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786481703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hkCrzGYffhrS+lBm87Y/JP0Ez7nSN+F28AcRSbBlazk=;
	b=prdN54XlMixx73rJGo4bG6Xa9Z8SuE7x6+9e1U/PJD8lTz4BdMsrbJJG3Q0mloisZf+ZXa
	LiddGdK3t66ywJY9oIk4KH3sQ/3kMZN0Y5H2q/Sc2/y3l9Zp+DKd49BfJ+sgLlsBSj+Oko
	wN5dUgwh+fwOUuyV2FWHuV+8ZRK46V0=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XZaOl+KV;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.6 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786481703;
	b=I0l0N6ie9wJrpqfsI/ie353XgAP8DmnAyZjTA2X8sB7PcInU6wplXZ4JipItVjdzZk758H
	BAwYrkhQCMf/5vRJRf9D0RdDUung8tog3zN8K1xA966cIF05BN6NI4wXBvrGXdiuywXAgJ
	7Oh4pCYQJO+HuoHb0yfp9eggVsQXdfU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=egKSgXFuh6VbdgwpH7On67qEXXySuyjSYE/05L1aucBDrwc5r5Rua0BQ7fVk1YAp3DevMG5ZYKqjBogC9LCrL3guo+oHeIOvOA1MFSiP7apaAljcE3FfDCadXB+QLDlE/NeSIyszIqy21UHlyZjwLK3xbCAPOZ75+HnzK7n2ufEgCZe3TMTCZRfRkxiDRZUxO2br84ng4zONzJgOoLFGemA6h1reWMAR4IU4XlXUrPuA16Ai01guTideTsJHdOI+kQEHZZwRcu597YvFCOlpikrm3eyFcqy6Vu0wpUrpBbOPRA5E3/3sXcbHSLg5HTHlIYv/YAMOjqkElU3y7mTS2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hkCrzGYffhrS+lBm87Y/JP0Ez7nSN+F28AcRSbBlazk=;
 b=UDMPMfS19vnaAuxuO/TnJT4KnubdLXjE0K5tEEg6jZn0aYswggpLMYXsn2Pc+mDmDb54CJwXr10KgRphcztOey7gVTVeV2NkKjuiWMt2Ayn8wup5aFtT8tEQcB+PJGJ2d04lV2elCF7uengGAsaFWNypcf6sbBMLHJdC4NM2omstNJoI+0f9VTbDR4c7rHWg+kLhrPW16rvAoLLz/3pfvdLUI9IhLhuNYKeT91QBDbwSNYRM88iKco/m1aVOo03ix2UFQvrZ3JpkM4WCbaBC6XYwTijGrOaPXstjMQjHjqnhmI8hoVaFW/EdZ/6pZnv05/XdWMTtqOTz13IUTKqjvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hkCrzGYffhrS+lBm87Y/JP0Ez7nSN+F28AcRSbBlazk=;
 b=XZaOl+KVbHJB0xtxJTrVjBH/fV6JSOcsUbH8FtR5ZdL4DJjo0ZOjl3UXU57RVOweGztdeAiyi1lwUhPAdxU6CxrY+Y82hdFNu6bOWmnnU6cXGuRwB7AdhFMxHbMDSfCIg2e+Qz7GdO3uCWZ7303ShcPt/nb2etbhXuqiHLx//OLFl79NzICGvlTo9/CZxrBbhoGM+IHJ/hnzmyOsYRM4RzudgwQhyP0n75wtMbeNNzzrb2MNLgfQQdsvkT/yZxq7etozwZz0lsYkZBczXiq/9qryjOAlJhPWynKWhvXwBxL7f+9R45HFAlS2x35sXEcJ+54NxTtX2Rty2BImSwR9PA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS4PR12MB9585.namprd12.prod.outlook.com (2603:10b6:8:27e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.12; Tue, 11 Aug
 2026 20:54:56 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0315.011; Tue, 11 Aug 2026
 20:54:56 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 11 Aug 2026 16:54:55 -0400
Message-Id: <DKMEWP5COTNW.J65YIGB11RA6@nvidia.com>
Subject: Re: [PATCH v4 7/7] mm: Documentation: clarify where the mTHP stats
 live
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Ryan Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>,
 "Barry Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>,
 "Usama Arif" <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>,
 "Mike Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Jonathan Corbet"
 <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
 <20260811-khugepaged_pte_refactor-v4-7-ddac39d61c4a@linux.dev>
In-Reply-To: <20260811-khugepaged_pte_refactor-v4-7-ddac39d61c4a@linux.dev>
X-ClientProxiedBy: BL1PR13CA0367.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::12) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS4PR12MB9585:EE_
X-MS-Office365-Filtering-Correlation-Id: 7192dc08-9c9c-4aa7-795a-08def7eacccf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|23010399003|376014|18002099003|22082099003|11063799006|4143699003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	5+m9Vwjt0zThjGs3K8t1mwaKKjkqWogn6r2HjINozJ1wBzDDs44kDbLYjph/MqahOz4mUQY30ukxLymM5+1ZSmMGH96M9wAUq7lgrM3X/7PYzB6jD038cIPEt6anBoJYmLwUuH/Zr+NOcpv3E1XuyFzd5foM8fjWiEF5wspJqKM2K7msaKQOTzG7DMB4gygae/D8GVLqDyWYgMkqW0mscGxQw8zPI9AvbjnAjLoyh8V521GxBr5Cdf7ObQTgF5i86AlKTdo0IoPiKnVdTdmyRNLhstwrTALd6lW13SbgwS/lyk6gV5lDsH00Awb+zIa/VSHACMVbD5iezCjWRuxh/rsB03XStOjA8vrqnHmUN20IaZ0CywMJy0OyfCQzGJMTY8Ng56eS490bp2zwYCWIpywlyjxdWpcY6em06eHiYbKFQJdhihYbEQj2JLIfBgdsgTLfz3dUanuCzwhFyW/wHmC8tg9V/lCOCNJ4J0q3c6g1E3QlZLatwrQ8+r5RtcPg8fIXV+57L8UTEbqcdC3f2IhN7rjCsZbV9qSyaMpYMWTjoWGdqrOPeElo35Tjrg0tqOxZknt1DQVk3d2AXtbj8nwvHxnksFVkfhfacsqe5YgZfy94EaXowVC37TAUFSofql3pIah164ov/IXuFaDuenFUMpgneCsMFT5FQ+Rckfk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(23010399003)(376014)(18002099003)(22082099003)(11063799006)(4143699003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?REVVbEZDeHZtY3krTXFYK0pQTGlhMEJ1QWZSRWR1cXhzUkNRT25DUm40OVpQ?=
 =?utf-8?B?L2NzUEVVcGFTRkU3S29acjNjS2R6Y1BPN2Q3WnU2WTh5Y0FTQjVoTlYwcGpm?=
 =?utf-8?B?TnVPNVZBWjdKdW5RRUd5a1BkRk9sZGtGd2dOa0FwcGVpMDdmNFBjUGxHYmIz?=
 =?utf-8?B?K3JVbmRFTldoU2kvTFFMaG5EU1dqb2RjcnZ5RFpaM3Bucm5wT3NINXBCWHpY?=
 =?utf-8?B?R0UwVkF4Ukh2eUpvSDhOdEh2c21SZVJKWmdyTHpySDlRWTY4dXc0SkRSU1px?=
 =?utf-8?B?aTc4dVhFNmw4eG52U2VJc0FBYkNGY0F1YzJCcDJXTlVzMzNKem92T2ExODFv?=
 =?utf-8?B?ekRUV2hPWW9uaWlEeXlMeVVQWmxYSjQvRmMyaDZkTkZiU1ozc3VLdnd4Y04y?=
 =?utf-8?B?dXc3MXdUMXMyNnc5a0gwcVZ2eUc5bTZkQjRBejlKeXV0dkRRSFpBbDZYd1Rv?=
 =?utf-8?B?WFgwWjluSmhWWVg1OHhRcW0vQlU4WTA4akdhbCtWa0Q2U2NKUi9UeURjRmdp?=
 =?utf-8?B?K3FnOTJ1aXVhK3l1Q3pNNEFJczE4MlpHN3pYR0dHRkY3NFVqWGRJVFdYU01n?=
 =?utf-8?B?cWMxTmJaOVZvWjJMZUZKMU82elh5ZU03NGVwUWRjUkIySEdtSFlraXhtS3E1?=
 =?utf-8?B?YmpmQWpBTi9abWFwOWg4d1lrZlo4Z1V2cHdkQ0owbW5PWkdWYjZOWXZqcVhN?=
 =?utf-8?B?ZllGSENNcGE2ZzVBK2x5RkNzK1l6UExZdG5RMzczMjlvOWRpL2ZNd0pwcnNl?=
 =?utf-8?B?ZDhyQVVIQ3VLRFc4VkRNRzNUREJGWlBjL2pBQkY1UFIzL0UwNUt0YXFWczcy?=
 =?utf-8?B?MkE3OTcvQlJlRGJmMXE0aE9wQ1F1V2ZvdHFaMDFJeERiOUQxVjZQWWx1aGhK?=
 =?utf-8?B?aU9lTE5aTFZubERMN3NVRVlkeWFWMUxEWkFiMlpZMEtPVnFQa3Btb0w5R2Ns?=
 =?utf-8?B?VzNmaGhjTjkrQW03OGk1bTB4WGd1UEpRUURvaWtxQk9jSlNqUzZPSDI1Uk1j?=
 =?utf-8?B?S1VCUHd0V2UzK01EbUZuT1U4ZGFwOTBTcVFsa1lkVGRhTXJOT1hFOXgvdXYz?=
 =?utf-8?B?UDlBcUNDVXg2ZjhRVHQzV3hiakdNUHkyVXU0d0VSVldpMWVwdTJlNkI4aDda?=
 =?utf-8?B?cDBzU01iMGJocy9LRlhnWlZFOEN5eUxiT0xsUStZV1dHTGViMkFPNG9lYytF?=
 =?utf-8?B?NXN0N1U0NHJHUVR0U0VyMUhPWTVGZVd1cGVCZTJwZnVsMUNkcEJ4dEdVbVBP?=
 =?utf-8?B?N1BMQlJnQStrcHdiMzVqamt0SGZJb2xURFRaV0RXRythTVdBU3k1dVQ0N3h2?=
 =?utf-8?B?NVRwZi9HdGxEZjArZm9VQkhRbS81b2MzNVdxeHdIbHUzNG1PYWsxTFVMODlF?=
 =?utf-8?B?S0lWMk5DSVZXdW05bFhWUVp1cDFjU3NWYy8rU0FTdGZvNktzSGxjcEh5WXRm?=
 =?utf-8?B?L3dlV1hISnM4T1MxQkl5ZHJMYlpnZUNTUFcwbjZIbERxNnN3WVEwbFFqam9Q?=
 =?utf-8?B?T2VGK2hGTkxpdHF1L0REVHdMUVBYQWxxVUM1cSsrOENSTXlUWGNHZFNtdEFt?=
 =?utf-8?B?Ni94b3JlbmUyNGdxWmpESWNJbkxkMkpSeFo0Z2NDaE1YM2lIN0JFQ0Q0azl2?=
 =?utf-8?B?S3NkekV1c2kxTVN5OHFCNDIxZ2tYZGNVb3UrZDRyYi9kWktqUHdPN3kvYTdL?=
 =?utf-8?B?Q2pFdUNzL2tXL0RjMmM2amZzRy9GS2d0R1lKRVBHYjJOUGJKRDBpaGJsQTR0?=
 =?utf-8?B?QU56czFkWnpYR2FrcXlsbThGRGtEYlFHUzJhTWNjRU1lS3Q2NlV6SUc5UjZM?=
 =?utf-8?B?L0k2UWRSMzIzMjRaODdTZ28vRlY5anhma3BvNERpYnRMTjQxOU5NZzNKTWtY?=
 =?utf-8?B?NUNuSHEzUDUybUNWNys4VlZKOXR4MTkvRlRnODFTU3BWNjFPM3dhbG1seWxJ?=
 =?utf-8?B?UllMcnZacERlVm52d3BUeGdwSisxaWxDUG9yM090bGV6cXlpZWtwWVpsWUFN?=
 =?utf-8?B?MUQxR08xZjMrbmtyMjVuV0hCMG4vOWxwdmZpSmM4TWx0azhOQU9nV1dBVVB1?=
 =?utf-8?B?SUhaWnVWRDZDdUdMN1FCR0dEWHN6MlNRZnVRR3lBeVNSN0FnNG9LY3QyNEs4?=
 =?utf-8?B?TzJhM0JKRVR2Y3ZrR3lMRW13S3FNWkZCajNJcnVERXV5RDA0K1hoQ1NxeTJh?=
 =?utf-8?B?enJRWlNDTlBkeDFTOWxvYm5JU1F0NU03MStmQ01QRWZBZzlyL0JqSnJML2J1?=
 =?utf-8?B?R0lvUVR1RGYwTjlrbkptSEE4RnpIeEhrV0ZnOENzYjdCZUFhRVBuTXJxRU1C?=
 =?utf-8?Q?qRH4aftK2WxHjYXp6k?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7192dc08-9c9c-4aa7-795a-08def7eacccf
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 20:54:56.4913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qbLpCxss12V3xY85HB6Mq8uuYYGH0G+geNisSuNZCo8np+OsRr6P+McjxAm0Gpiz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9585
X-Stat-Signature: rmx6chgo4mwds8fn8cazt739cmp6zf9u
X-Rspamd-Queue-Id: 8EC4F14000A
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786481703-515848
X-HE-Meta: U2FsdGVkX18D1fR7R3/tXUHS6045qT5oNHZurgvas1+JHuytFnFzL/o3zEGXXNVPpxQMh8Xn4fplL5XMgvtlXMQZRMaZ19knRIBNjeFyr28merbXp3SVdtRiIYbL4vwTvPcjLV3ikwMdOJejgVn/kFvZMQvMHZsVYlmuAyM9ewUhW1269IyQf03iUgSZBPnuWI+BWTb0wb3mh8ULFpOw4b6rmM+VUMfhmyPliidc5uX7yhEdOV5UaixN41ckrzaSxyvEhqCrHR4qF2vws/Dj/HfgYT8FeslkghuSehDUew5atJEG+6NZeYG/EJABbvghimLctgyyoKUEJVxB89oRsgiJcXVE4GFZrjIIJZYyPuYSyEY6TDvtpBP7bDIpWa8iLEwG+uhpy3m15XUlprwo1jhlVraRjrI3nhy1GZNplt0p2AqmEkVoYr49ebeQIl/64m6/7JPzZnM7Nse3hfsCHorWASoKszEpLaufQNlrTeBkjrcF3ABXdSLvfECS0NPncJZKEEdu+6BpwMQ30OdlH1lx2RfaEa5PBrZaGmSaM+R30rlknWgPta5VE97Xe4y+lG8F+DnseprDBKk5BH5qVLEe9dKzr1qR8cKRwZHQhc1bBY+x6zMa/zqJKPI8oLNpUd2556gtIen9NDlvN8qk/h1cepMB8xn/3DVjoQIJ87OPzMm/ibLTrX4QYcYm/yEQhHm6BbP4jycm4ivQrJVKeDJOfdcKg56jZGWZEB+CylE3l2YHTampjWWSIjXrBH1azhUp0DlrkqaLWWzLFcjyMW74HG6VZyRSp9uB9eA1IjCOciW68u4zgG81qgvq97doabnteYR1XGErVyDrkC5P2JkV72I902pulHIG36+2SPHhYaF69VYOynvWKvBhmd0cdGAoGno4qTpdbl+tYpStVR+5W6kdaVqfLa5k4aAXyPlSboUrHs+XqenAOf60ydQX5XnKyRTX34i2+Jh7HZD
 wsEHVYW0
 cJX4m369cztNr6k0nfQi1Br1De0f8Xd558XQMBFPLy0DwyjAnChvkzdqcy2/TDwb9tPNb28h9NDQi6JMR6ISOwkbgjZMmHFLTHE0yS7U1Mq7Q4uv/VJCHBB98IWR4v1Ya9YQFGNZF4tMqQVw7pG0Xc7+vKeJ5oCGBeC/fppH2ksQ80xj5uObkg/wT+DYhjp8S+MAQHkLOm3DFWHtdmBOIQcimeNBVdb86wjqGjOWK8Nc1g8iE7xzGx0tM4+4zKr8eA85e7yfIhfrCMnv0thIs9oZ0/QqzV8FhsXU9toIQHBeHDG+/2qWAheOE9Xpn4lQ7KVgjc3fwps8hCmBubDthwam6OavaO6gns0rLCahXhFDDeGy0YXaDIrsCi+WsjIo9SVjgwQhzkunudyR0RN+e1RkUefRNVlhiYOZk198XUGFmHGPiAHK2uZnV9vfPEJ24yUkN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Aug 11, 2026 at 8:48 AM EDT, Nico Pache (Red Hat) wrote:
> The note about khugepaged counters references /proc/vmstat for the PMD
> case, but never mentions where the mTHPs stats can be found
> (i.e.: /sys/kernel/mm/transparent_hugepage/hugepages-<size>kB/stats/)
> Add a small addition to this section for clarity.
>
> Also fix a missing period while we are at it.
>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
> ---
>  Documentation/admin-guide/mm/transhuge.rst | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
Thanks.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


