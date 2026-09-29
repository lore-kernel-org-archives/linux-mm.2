Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50404C9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 15:30:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45FBE6B008C; Tue, 29 Sep 2026 11:30:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 411556B0092; Tue, 29 Sep 2026 11:30:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DA376B0096; Tue, 29 Sep 2026 11:30:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F1B606B008C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 11:30:53 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 87C1180541
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 15:30:53 +0000 (UTC)
X-FDA: 85267187586.24.A6F6AA4
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012020.outbound.protection.outlook.com [40.107.209.20])
	by imf18.hostedemail.com (Postfix) with ESMTP id 560A11C0015
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 15:30:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CyFpg5+W;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.20 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790695850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aN/iiDajVj+LLMWL5HSlHAuk28Y9qAnTxQWoMoVACd4=;
	b=c8UDzpbVrqZ02+seUuFpOWrbZdl2YYvGQsngWec3MqChL+EPBIncmgk17JcAvNh/orgz2R
	tcF2tNV/boTvwCKUKz8rzFaWr4xyH1x/b/PtgJW+5YOLskRIZIy0ShafgJB8thgkhe8pUx
	mxt8E7PJ6qlECwqEWnLJalkxE7grGVk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790695850;
	b=bx8fKUBeSU+K3CM0N2pS0G1w/H7mLDjTGEORjyi0jqwh/lhtvxuzd1xPSMOa3T3C2XpQ+L
	zjOWjlXpC4fZ/0viv7kf9ERyj7WAf9HiG0RI9QWpHQvqq0503KbAniKagGDhXORwQq+F/1
	+Nwhh8rwI1CeF3LAoVYgmlIRr19+AeE=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CyFpg5+W;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.20 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RbkFIQ7nBUm5Jfn9VYshC8QcyMqhc/0d9k/0kWXGHpFMmJMKPX7SHMcB1Z+mKKr/1V6sQeaRQir2Rj9RswcI+su5Z2/xvAg7KvoDEsJO+fzeAjF6wZrMQcep/72rcbKsTVnUqLlBkQLbSJZJjJYJ5SQs8YoBTho4WYxzf1egh/jD+XMTM7/+pKIOymBt2ZGvZIB5ac6numMJGqfcUaS4Yabw5yKR6Ouem/YGcMhNZOHB9NGpPTWHYg7l3xVpR+E35CXZzPqK11JK5ekWqDs7YERrA+Yao8G9qvQhHhfs1LxRsEfNIgIC9nta6Uszg/dqMP8yRI7cHC6+aZeBoEDQZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aN/iiDajVj+LLMWL5HSlHAuk28Y9qAnTxQWoMoVACd4=;
 b=ht/U8kuvJ75VSvrslwQZD1dpswl6JOntq5dIu8WZL9tkvIH+Om2788qwouYkBh9H3Jkvg78fQAZwzvX5shHtmL0LlKDVH3Z1E6/b6Xgf81sDSqbKtO0Et3oM7C/+0L1X1MChpGzQ7oDhKeb2DxwHiy44am0UDefG6nO32qFF+5FLZoMavzuRNvibNP/lHyImQVhEpDzG0ikv4/7JONDAwCJ5LnruSmIPH2qgF9xfK44yujpMYcxGahA6WZTuXrA3tZYSbZS0kgQn654BiIDCWbBIpWUg0YQ0jqcDOwFtH4Oo0XxP40yhhZyr92s3p9Nq2JKDCzftYX8Ue6+6Vb5+qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aN/iiDajVj+LLMWL5HSlHAuk28Y9qAnTxQWoMoVACd4=;
 b=CyFpg5+Waob/qMoy0uipM7vqJ0nk8aRGdot2ZE/2yXI99WFwSXUjJsmgeIwgUmn4o2DFL18UDUP84OguBABUC//lAvwDYlXbleFC3na+RmpWf0ysPiZgBLF0Hwiyb8W8TywPTOvKo5CpZ8UwOWYes4V+SdmbHV7jDUzMzeJj+UUR5DTCoNPo4jZC/KNwfHsJk7Naaysh9ReZlubz9t6l7JXO3kH5ZVW11UVB8ImcH1LCBBAHYDV4kAK0OFI4LZwpk3WKvPJvRTtrHHGvFz32lLQITQDkswsj62kefwcFCJYcfeVbaTN8sGsJpp08wUUdXVl/pYGiBdLKZgWKNnQoLA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MN0PR12MB6004.namprd12.prod.outlook.com (2603:10b6:208:380::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.23; Tue, 29 Sep
 2026 15:30:38 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 15:30:37 +0000
From: Zi Yan <ziy@nvidia.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>,
 "Gregory Price (Meta)" <gourry@gourry.net>
Subject: Re: [PATCH v4 1/2] kselftest: mm: return fail when child test result
 is fail in khugepaged
Date: Tue, 29 Sep 2026 11:30:36 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <236634F8-80E1-4C8D-BA5F-87446F061494@nvidia.com>
In-Reply-To: <20260929-fix_khugepagd_fail-v4-1-2169c18f2576@arm.com>
References: <20260929-fix_khugepagd_fail-v4-0-2169c18f2576@arm.com>
 <20260929-fix_khugepagd_fail-v4-1-2169c18f2576@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-MS-Reactions: disallow
X-ClientProxiedBy: BL1P223CA0029.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::34) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MN0PR12MB6004:EE_
X-MS-Office365-Filtering-Correlation-Id: 5051faca-0e1d-41cf-0aa8-08df1e3e9cbf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|4143699003|6133799003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	2GTh5PiXPMjhF9UWRz9+NqNrmMuTmXKNz6feF2IdcdHTTELS0PIa7f6zCUq8zcWkL8DgdiGxS43+Vvpg3FBPq6ZvGuCF6ap7zicUKFjzR72+33Fg7fzb8VeKXQ5ZRGTuZgZYwDr+TlQKxPW7A/GQFIxuEgLlV4RVfKYFT99VlFzSiNW3gOaoKJGCzRTeJRKOcIdYSiBrWZdJLldmMBGRz0Aw1VAgebef4NTluL24mdBYG7XCPZkwQFgr8DGWXw4afnl6izPUsuIMx24SbuIANF2U/xOc2lTJkjX3mnXTHP2bPLoVsILAHG2gWi4BXu8TjrkuSd7NX5dcCejHu39PvGQzVxaDwhzaP4hgLgcyvbOt8/QpluEU+L5X0xQ1vhUJfLipSpvxiVhDeGYiBwLBXpL5qXKHlwiCzwqKAsEADsZ5TvyDerQ9EB13j8CClhHT+nTw7wYOyhxDv8DrLIMCmpAxWMRVPiZQkJ1jLPiXeTThZNYjbThWYLXjmi4aa/vW4QBZtWolkQqsPjMOCCh30LyFyYupHQak4Vzsb5BMALbmUIKX5i4gmGnqgnsm1KGdiDNE6EGBUzcJPFoJPFnkSvfkGuFszwpQvdmQwDPS3kpFAYrIusTTAIXZ1q3CYay1dH96qhrkyo7vlAS45gNpOpxV+7+8s29f+fE5ZtL4WNQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(4143699003)(6133799003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bXZNdlg1eXYySzlvVDVUYWVXZ0Q1NUpKcC9Wd1FQaUVLQXpncVpwMFBNUkV1?=
 =?utf-8?B?STNONU1HSDJDSTM5RTh2NWFBOW9ZdjdDb1BXcnlZaS9rT3ZyYXl3MU04YkFa?=
 =?utf-8?B?eVVQd1ZCRm5FdjJJNXNaMFBjbzVxOFZYMzJmTWFqY3pXRkVtNDZGbUluYy9m?=
 =?utf-8?B?Wm1pcCtlRzcyU3VjWnhNeDR0Ym5mYVdRb21GdWRvVGtWa0pzWTM5TlVOSGdj?=
 =?utf-8?B?SHFLNWdybThKZmVhUVJibmw1OFZycmt3NnJiSnhsOUVSR3BtR3NnV3JMT0lY?=
 =?utf-8?B?bldkb2xFektCYWtQTndnSGFINE9UWDJtZzRLdTY0bFVqWk5sYVJTMkxwVzhB?=
 =?utf-8?B?dytEK1paVWhtTXVHbGpRVHZlejd1SkdjL3RQYVFwa3RQRkt0TmxPbnpYdVIx?=
 =?utf-8?B?NHlnVUpMcDZCRjZ0YlJBRzRCTEZBa203dmUrdUxSbTFVVlFXcUJURWNJUlQ2?=
 =?utf-8?B?SS9aRzFiU3BMUXNTZk5zVE9HMytmUHh1U2RKdWozcURlSzdBSjFpZDl6N0J1?=
 =?utf-8?B?dFhWaUYrOUswLzdER1g4QVdxRVpZek5yOGxkMnAwdy9HRkQ2bmpnajZweW9H?=
 =?utf-8?B?ak1JTjM3TElFcjhBOVFXcCtzdytySlk1RVdSUVZoV1gzbXB2Ri9OS281UW00?=
 =?utf-8?B?Y25ZcHNscWNkTFkxUlgzaDRDcUljdy9UbEVzSG5Xamp6dFE3WTlNRW1LZWhj?=
 =?utf-8?B?VXBidWU4cGplZE0xODVFR090Lzh5TmFJUm5weEVCdkNGcjg4YytoYm5mUVlq?=
 =?utf-8?B?UlMwMVd0MWQvYVRRTnNRZWx0QlY5QURtcG16a3NLYklDMVExTEFOV3NwWUgr?=
 =?utf-8?B?NzlYeHJzRHJwMmtGRVc2bFBIRStJdjI0RFlrVXE0amFidjk5MkdMZUFGcXVP?=
 =?utf-8?B?YitwdklOclRmZVFmekZVdkNjUG54cTFaZVA3M1B2WjlFVVhqWEdVdHlhUlRw?=
 =?utf-8?B?a1hZVElqVnB0MDQ4QTEvWTBiWlpLK29UTzVNV1l6Y2E5Yk1TNFhuOUFJcXVs?=
 =?utf-8?B?QVB4T3BUSW9NYmNZOVdNeFFzYkRLa21JOFZJdzB6ampWS2VDNUNmMnhOZlhH?=
 =?utf-8?B?TDdlSm5aaXRLSTkzeFBSTFpYYlZzOFIxUDVMT3I2aVEvL1BGSDc5NWs2emhu?=
 =?utf-8?B?ZU9ORXJ3YjZERGJVT08zVDlPNUhhcXZpRHIzVGZQRXZKWDhJSWxoT0YvSTNS?=
 =?utf-8?B?VGpEeFhYMjZEVHBZSzc3aWZhUlNxaW9GbDVoN1FnUWFXYnNQdEVTWFpzYVVo?=
 =?utf-8?B?bHp1a0dMSFo5Y0VhNENBUzlEaXFpSmQ4T2dkN3JqNW5xSWU2NVpKRm92ODJ0?=
 =?utf-8?B?RE9FSVp3Y1Y3dVZoeXE1anpreXNXaldMVS92RWd6SmtXYnpybTRCQ0dmeXg0?=
 =?utf-8?B?MGN5bGx2YXlGdllXL2MyYmNteXRnNDc2UmkrQjFiQVlrQjFIdHg0aHZyNXVY?=
 =?utf-8?B?UitvODJ3NDJpQm9TQ28yeG5qam1tS20vLzE3UktpOUxkZUZtMjJCVUhrVy85?=
 =?utf-8?B?WERtTFpMa2g0cTB6ckg4Q0x1TGRhbjdUMDF0ZTFiYXNPZVZLT0pIV2YydCt4?=
 =?utf-8?B?cXZrV1U5NzY3ZlZ0SDdwWTNYSmY2L3BSeVQ2UW1Mb0lzTjdhK0RRazRoVW9z?=
 =?utf-8?B?YkdmV25UMENaclUvWSt5eTdNN3dRMUdWUCt3QkdDVnpUVkREeHZNNTArbjh6?=
 =?utf-8?B?K1FLc1lLUXE5UmNzRTFwNklpOUJTa0MxSytSTEhTeG4wOGJuSUJMbzc0UzZz?=
 =?utf-8?B?VmlwRll4ZHVMd1BhV0p2cEFBTTNtR0VMeS9iVlRxcGJPbkdxVmJLZ0dVeDRC?=
 =?utf-8?B?TTBLVVpnUU1xc2RxUm1LZVZFNmZNOUR3Wm5uQnNVelo0cDR1WmhmVVhtejNv?=
 =?utf-8?B?NDE0ejhLYnQvdS9UY0FxRjNsV0lyZTRGTytGeXNscVNGR3JhSzhiK1VZVXJz?=
 =?utf-8?B?OUphTWQwZm1DeFNXaFo2NVhPYWlqaStiMkhiL3V4U3RTL0xvZE84R3c2dGpC?=
 =?utf-8?B?am5vRDlUaE8rMlpyeE5VclNYbERYeVVNVENuV0JDVHBoeEdLVFhRaXAwWHZB?=
 =?utf-8?B?YzBiZ1pKS3llRXlUU3pjazBuVlhhekFHOGt6bW4wcWhob2FpNGs4RDVCWTZp?=
 =?utf-8?B?SnlJZHRad2hmWlhGZ2FmSGQrdVlmRjlFR0NGQk9IamdJNWlWOXBvWlVuTyt0?=
 =?utf-8?B?SGNTNlJQZmFzQkhSZ3oyY3FZMW0xUlAzblB3dmdtd0lPU0JoanNKa2Nkb2Zx?=
 =?utf-8?B?S1BJL0xUNzRqcVE3dEdDRzBKU1ExNTY5Q3VuVWg3NThrOFVkeG0xWG84Nm53?=
 =?utf-8?B?NENSaDFZMWYxM21zeHo2QXZJUTVhdUx1ZEQyRm85WEdndlNnSXhQQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5051faca-0e1d-41cf-0aa8-08df1e3e9cbf
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 15:30:37.8970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ls5KR5/+G+ZCQwifuCvBFw0bxaXZsrFoSlEYYt9ShoXE7l/pfyTd17FHiVf7XRii
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6004
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 560A11C0015
X-Stat-Signature: ossxyjpsgn7fqy1yyrqpib3zcw9rb567
X-HE-Tag: 1790695850-137376
X-HE-Meta: U2FsdGVkX196m9F2IFbJ05nMgbUR9XTj/FZsTw8cDmud9hpjM8yIIDHboL3uF2kU6vwX66p+u4a7cXIyZc8M3S7jv8nqPTf1o81pecI2BhTywVlaKYNAohRA5Z2gfyKXUAH7teUG5vJItNxj6LXmUTWO/EY90xFPsFlIbYUdaajqxdsP0TLVoXhNgZyBlG0qJHi7CommWIYVeIf6YnFbQzsXRY+sFg1dRp6esG2AgSPsV5n4pQs2nMBnuGnZO60123hFaJf+JxJiHQXUIu5r1ongNAld9y8eY0umn2RjAVo5OpLGSuZwELO75/N4UmoYW+ovbb186zi6Hs5iC9Gh+6/NxcZcvCV4OUQcfFQpKOANAUAtWDFH/0ixYdchNghteVYGw7xab5sOoAszbvZhf0QAqIxgNW8+beReubPveEJ6o7aHQGS36+I/gyBiBHNHQPXqmkbudntdu+05Tus2cG7+LCRLFpPxnFmFAUDTfGwKtr8bqHWBQXK53Pl0c+Aa1w+b31Okiu0/AGcBF9vHHFWLhcvGZzUAKacwU/ql6Kzxg/bu47HsZ3oEGZ6S8iDiMReSHdhVTqLCF0XCyFAV5hlna3KpDo/LQEt0ZFm0LoE6299jpn4gEYvaKqIrJCgOjxb+pYXUDPx7sUeZGKk821iCZAx771kr0/AA0POr2fuY9tN4CRlUBQJAuMUV3SEaAxwW7UpYNHT3LLnEzjviqQF7hO78QV9420pFE3wvSPBn4g2I+WsLOfaGQrmgTPw82KVk8y+GcPgenuRc2wgJFO1Zqiy+zph3ajlEMKZK0lgLOcH5PvaZO63yNvtzqLAtMMVgWHYgIKwz8CL3WQp6c0t26NdT0bFRm3mt3YDFonRezbIs77ww8SkHHRdddTWPpI+U27pxc5pCrpRzj5AKykE3ueflnE7glMc+vBGdi6egDE7AkTBWQZzQmxyD+aga7cDjA7OZB7IqOf6vWq9
 kG1iGcVJ
 pqX26oymYA7+7bq6BVYUYw+kyMa/1OZtcxa6DlSbyIt77XpYW4JBYFa/wKtmIzNQfWajYGu5R8IWGqooPz929nUCAFYsHEWMbbe29gTwTTmppbbR9rIkLUSZSBvJcKx+aNAS90LCfb8ySIFXYhLHcsSODfCj6Z5dneHNh+edhII2j1gllJWwSOUUvbvLvDGaIlJErQFFaZMEjedx7HXUCWPuKjcdNdW91Dg1X5RkG90Slcl607XSg4RzgY6KZ/jtvfFuPbRMHeZr4wD6znUYKkC3MrhrEWdiZ9f/1nOv28SGAZkqlVhg8LEEPRYOP5eGL0X1ejtxjfT14hvRJnEMK227JMBiVuhTtZAYTQV/TQ9maDXYdh+cgDLX0cL7fmwXa+6R6ImCP9R6xfjrs9C5epKIl3sS4ZaWjy5oBCwABhEucvLeWwjo5+2BFIa8lumpuOi2kZDyChFj6gzOazPdfHVxttqyLYQZCPHvyH/v3WXBYrWP00NAmWXrKElDuGm9LY2vFMm7I+ivdZDKZriWQ8NQlyX+iKOc5yBvoRkSClUsx0JldmdJwqkxO/0LoMQKrm32cEI9vvxApW3xwKR+GSIGZ2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29 Sep 2026, at 6:33, Yeoreum Yun wrote:

> Although the child process in collapse_fork*() or collapse_max_ptes_shared()
> reports `KSFT_FAIL`, the result is ignored because the test only checks
> whether the parent’s page was collapsed into a huge page.
>
> As a result, the test is considered successful whenever the parent’s page
> is a huge page, even if the child test fails, as shown below:
>
>   #
>   # Run test: collapse_max_ptes_shared (khugepaged:anon)
>   # Allocate huge page... OK
>   # Share huge page over fork()... OK
>   # Trigger CoW on page 1023 of 2048... OK
>   # Maybe collapse with max_ptes_shared exceeded.... OK
>   # Trigger CoW on page 1024 of 2048... Fail
>   Bail out! Unexpected huge page
>   # Planned tests != run tests (26 != 23)
>   # Totals: pass:23 fail:0 xfail:0 xpass:0 skip:0 error:0  // child failed.
>   # Check if parent still has huge page... OK              // parent hpage success
>   ok 24 collapse_max_ptes_shared                           // considered as success
>   ...
>   # Totals: pass:26 fail:0 xfail:0 xpass:0 skip:0 error:0
>
> To address this, propagate the child’s failure and skip the subsequent
> check in the parent.
>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  tools/testing/selftests/mm/khugepaged.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
Makes sense.

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

