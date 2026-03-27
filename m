Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C9F910F2847
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 15:54:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71A6A6B0096; Fri, 27 Mar 2026 11:54:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F19E6B0099; Fri, 27 Mar 2026 11:54:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E0D26B009B; Fri, 27 Mar 2026 11:54:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B2206B0096
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 11:54:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 242B3593F4
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:54:19 +0000 (UTC)
X-FDA: 84592289838.19.8A19405
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013034.outbound.protection.outlook.com [40.93.196.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id 447881C0016
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:54:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CZGZLUS9;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.34 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774626856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SjQezoNq05V6xD5KR47J+WANOZbySW7llmHSCSR0mtc=;
	b=SahUug65y6tf1EAJ6Q/54pG47UrunBSMEaMyEueAgmo7ENSCOIfxEceMq/Lazv60zbgWnb
	jlg/VVcnuNK+NU9L/ruQhB3gtJqLx6FLpBq5LlJfu/P8O0Su4Toq42NwFYLYS0/z8JcSjA
	vmItI/8aoLaFz6buGhq5t6bwFdG/WcY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774626856; a=rsa-sha256;
	cv=pass;
	b=E3N3sj2naAvUqUcfcb+MBkoL0RUQFKqN2AoxsggtLCf+hGDK+UbmyyJgrtC1puGRHg/voI
	BGbUaJtCIe9+8KHo/wPywEORKa1kQFdhVc3FTYjj+fR+QiBN6wneuPTxbevNjoi4Z54ZW/
	uKnHYrGEoRf9BsnYH9Ugc0DpjHEZRQY=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CZGZLUS9;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.34 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j9oY4pmfNMvMInTknF+6wgQEbD0UQmsEoEkC+CLlEYdB//fEsatGs/V2Btl6vj/U4PbjfpdQkvYOtYpkKWNU0Ziz3iiNfU7235o1ORy/0CfyzeV8p+wjV4kTJNdFArx2I3+SerPdCWsYgGHQJQcMT1kGyMp6j55S32gFios5HyAjsBeHCs3QpdqLFyeLX3CQcTVmIDeuLgnr9SX/1cDqygOmOx2snJzxl4UFZHc7zmob1QAEoZCQIuIURqkoMEAQbEqSIjhZU20is5fcIXzdMC8F61WYUxcr+WIP2EQEBJ+1HFbOilR05U6gnX7ycVewUgJ7nAknGPcWXJQ+5yafoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SjQezoNq05V6xD5KR47J+WANOZbySW7llmHSCSR0mtc=;
 b=doxNQRuL6dHEc5BgRGp21QCyWv4bPAsmpthHpR8Z4ngipXmLCjlGUZa5JuaG172SgdStnkEMoeDIK4STBV9kPedjI0jFzBMOOruenE23C4/368evTqQwAMQ+YaQJAritNa1H1j4GhgsxdfK2k0nIsUIcQhHA2A93/O3xeKQAQd8NHIY+gMrxZDgrFn7lyNH41I3NoPadhZaOgsMtymVh3U+WCJQhMRCrHNOfKHrhd66OE2cZ18+3k6j7Qg/OtH4uj3cEKUNH9Ehwm+Mxx4wHpKFfBPHUmFczc8RgNdva9Ega1PGNWIByuG7DYOgEBSni2HDgErfMKmVF5op91ptu9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SjQezoNq05V6xD5KR47J+WANOZbySW7llmHSCSR0mtc=;
 b=CZGZLUS9A7jbDV4un17NjC22yZJ1td6tEYqnxosqH6peWIcqoNe4B9BeVzwLXfP/eriVfzJ+8djsuaEwRnH/0e2WaCXJkgze7zecvJ6E8LGZQbo9YWL/mtNa/XSr03XHCSl88OW87eONGDUyzUjAyGFWHEW+l38bAwAz2e2IDd6mLaZsY3CNH872zEwGO4BQwTwR60qaMMcLJElkae9WVgF0hkQCvfFIRVPGhLGnO71FXVL6dbsxvl8lLX+axchbsdMiBajbDIGj7/D2E4u4Z51V8MgyMNthgqRa5AUAXLBYW6c5sYn0bvrOYRz5qXQaewJPFu59eMGRbYTp+6+d+w==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ2PR12MB8848.namprd12.prod.outlook.com (2603:10b6:a03:537::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.20; Fri, 27 Mar 2026 15:54:06 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Fri, 27 Mar 2026
 15:54:06 +0000
From: Zi Yan <ziy@nvidia.com>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Uladzislau Rezki <urezki@gmail.com>, Nick Terrell <terrelln@fb.com>,
 David Sterba <dsterba@suse.com>, Vishal Moola <vishal.moola@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 Ryan.Roberts@arm.com, david.hildenbrand@arm.com
Subject: Re: [PATCH v4 1/3] mm/page_alloc: Optimize free_contig_range()
Date: Fri, 27 Mar 2026 11:54:02 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <9A3A4520-76F9-41CF-926E-AE2882814C84@nvidia.com>
In-Reply-To: <20260327125720.2270651-2-usama.anjum@arm.com>
References: <20260327125720.2270651-1-usama.anjum@arm.com>
 <20260327125720.2270651-2-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BN9PR03CA0847.namprd03.prod.outlook.com
 (2603:10b6:408:13d::12) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ2PR12MB8848:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f191d26-68f4-4b92-e15b-08de8c191385
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	IVK5JkeyQcd0ddoSz8Dys32Gj6r1FdHDfo31Rkt56ajVPTaoIXzV6QSnfkylUYna7C/NB+rPUd6XIGddpw4wVbsH3iuDmbP60kVj7kIit7jpKKr/7ZupLQpO9u4ZjPvynzdBnuQHC2pPCB/SA+CpcbO33uqKBFwvsitdnDK8t+zUKLFKBHs8hmAx5c2u3bZuqske1G7UpO+4pCgdj8YpMFd3go5QTDoPGp+UoGysyEtHq+eruUyvszOdCgJUNcNlNC+83qJbaCWMfkIGwZh2rjeqSbXWnphMnGqVeOASTbo3sSHbKUKYK5eF+rCLHa7OBovqF2jAl31/xN7CXi25lId4PGK/pjq5ud6vGFYsmIh/DLmsO7QaE1YhtsM4kabqL8hHAmYI8zzy3WXR+J7LP34RpjFMYXp+2g7a/rrZa3cwHvsIfUivX4v4S3RnUe44JrpOzb0cG3tUbHbLY9clZvnICzjTJL9YQVLREu4dkZy3FmuKhhr+ESF9yAsaum9mf44cbBMDgb/w1Kbh+uNRekPVZbO1mwgKbZJjpOSecvtW3O6LV8avyWsfF2LKuJDLZAam7BRJpxGWNKDcBnHE7n6spmqkka8CuY1GtsPPISmygP4hkF4B3hcIZZPoHlfqrlGcOJnDdj+s9qKZUVH6BhUhdfhrt+COL+KCS3ls0RfyhLdErjOHziVYIuxsjCskkX9Pyytcr4jw1orTCwAlnJmgW8fYZt3VPz+NGkh6kg4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d3kzSTZabDJEZDlRZjltTFZZVVg3TGtZaUc4QnUwVHZyYVRrYkNYQ25MU2lr?=
 =?utf-8?B?bnlCeGxrSkgxVG82OFF2cEpjOTRMYkQ0QmdpNGxFeHBBV002WFZmYTlFQkp4?=
 =?utf-8?B?RU5nRHhQcnhlK20wa1FTK1hMNlZPOGRaRXdoMjJGbVd0a1NZUStvcEkrSnlL?=
 =?utf-8?B?c0pDL3Bwa2hDU0FjR3V3cEtRR1NsbXg0QlBXWkRkSk5HeGZka09Qc0pZUGhX?=
 =?utf-8?B?ak5NaDdNQ1NsRUtyMW5kTXp3VmpNMEdwZklqZUhUMkxsSi8rdHFWTUtRY2Z4?=
 =?utf-8?B?dDAxSGNpZXVGY0k1eW9VcGdtdy9ycVBXZkgyWU9tNzkvQkxoU3pWMmx6S1Yy?=
 =?utf-8?B?QlVDR04xZlVWOHkxU0NDSjNqU3MzdHZ3S1pYQS9VR3hWM0hubXpwQVBpdnJw?=
 =?utf-8?B?bi9xaWRMb1VKTHFLclB5dkowcERma3lTL2NlcFNsdVNGbUNINVdaREhnTFMz?=
 =?utf-8?B?K25Ud1dkOUNJK0lBT0RsRlcxL3FXSkp4dEl0dzUxbndiYTVZdWVuWjdIRDMy?=
 =?utf-8?B?NitQYnQrczlRdFJnQWlZV0t6cUNIOTJVdWZQQWl4WmpkRGhCeXlIU3NVVmdr?=
 =?utf-8?B?eUJBOW5BeTZiWlFacmNzRytWbGhucU9iTDFCQmxDbTZ0dFVneVVRWnM5UUJV?=
 =?utf-8?B?WHBzYlgvTnBvRHpIN2dOdHBMQ2hvUnF4WnBjTTlKY0hFTGZBaVFxNHNvY3pP?=
 =?utf-8?B?S201ajduMnZZZURNczc5bE1adUFTTTd4eGcwSGxzY2pTRWd1ZkNxRHpGVUpx?=
 =?utf-8?B?YjZWQUxMdHZuMkM4SGxsUjZHT2wrV1IvSEJjK2c4elBtN09RTU0xcEdnZnll?=
 =?utf-8?B?NUIvTmphY29kdVY0K1lueFhWcEdsR2x2ZlV3TXpTazFqaVNlZ09rcTB0bUln?=
 =?utf-8?B?MGRvYXFLdFdmRlgvOGQvb2VCdnY0R0daNmpmZ1lURGYyZkZrd05sSG1OMHFj?=
 =?utf-8?B?SFE4aS9aZGJXY1VrdTBGYS83UEhKTmErRS9iOUVsUmsvaTZMcUtLUWJUL3Zh?=
 =?utf-8?B?MmdqK2ZidnBaM3pWTUZDWkVZSjFXRXdiT0ltODJtWmpENzlUV1RTYWxKbVNE?=
 =?utf-8?B?Wm11SmJNYTYvOFJDZUN2bTU5VVprK2ZPcXliTTRrRVhCWFNXcDZ4ZDZQeDFo?=
 =?utf-8?B?SlFWekFyRElRZHFaeXhOeE8xNG5wbEpRWFRaTEh4eEJvWTZKUUZBbUpkcjhi?=
 =?utf-8?B?alhVbjEyWDhTSlhUN0NlRlNnSERaNjFLNVNKRWVCUnphSTlZUzNGcEtubDdl?=
 =?utf-8?B?MFlPMkZ4a3dPS055M2FmaWlPNlRyTlhzeFFnQ1liZGY3aGx6encydStPWlgv?=
 =?utf-8?B?VStiaXFod2JnYXlwbXE5TndReUFyWnhna1JycnZVVTNrQTVHYndDWldNZXAy?=
 =?utf-8?B?YVlRbS9odnJXaC9kVi9pSTNMUUpzOUE5ZDNSRDFJV1FnNWs2VWg3RlpESGZF?=
 =?utf-8?B?NGtMaVRXdUhJSGw1dXhHTzB2Yk51ZHp2TkVTM1M1azFEaVN6T2FDWnlxaGo5?=
 =?utf-8?B?WmNPSlA1Q3VsdjdkUmJlRG9EVUJScUNmUVNsZUNjTEx3QjMwb0VuZUJXQjYr?=
 =?utf-8?B?bkRjbzBrNTRkZE1FWWI3UlUvclY1VkVreGxkb0hIM0s3cjRBS1ZWT25TanR5?=
 =?utf-8?B?MHFpdVVZekVLcFh5dUhOdk1uVkZZUlIwZ0JaK2RrdzExelRmMnBKckNHWE5i?=
 =?utf-8?B?TlcyVGNxcmFtUUdiVzgvMllQOG4wQkdaQmJWV2xqQlRGbE9xVDNZWklCRUZk?=
 =?utf-8?B?Mzg4ZXhmRGRuME1KbjBCTCtad3JQTFhncDIwMEV4Y014Z0FGa2UrVm5RRC9N?=
 =?utf-8?B?Ny84eFFIQzhNanBnRStXVXVoZ0JYMXVTQkl4c0FUd0UwWTJuRzBaWkdSWlVi?=
 =?utf-8?B?RWEwdkhXOUV1Q01wWjRYeFVzWnJ4ckhDcG1MaVRJVStFYzhzWElzOWdxOHF6?=
 =?utf-8?B?TlI1Q0hvblZoUnhvdnY3STg2dHNKSk5vbnJtekhVcTR4N1A3NlNNRzFySEdj?=
 =?utf-8?B?OHdDOUJGaDNLdVBwcGxmUTZmWUttb2VKMWxOUmppc3N6Y3p1QTRETXlEMStw?=
 =?utf-8?B?SmFUYW5KUGgzM1UwdDJnWnFxMTFMbmsvRWIxWCtTOFpueHhzRXNDYnNKMVN5?=
 =?utf-8?B?Vi9PS1JEZUxwTGEzK1hTWE9yb0F3a1JLKzl3OStaTmhILzdJaFhiN1oyQmpQ?=
 =?utf-8?B?UW5RYStBci9VUkU4NC9LVWJCQTAvUUdwb1NXaDBSN0lja2lYWlhkMW1RK3RI?=
 =?utf-8?B?ckFIcDdXNjlkd1dDMlg3KzBLOWpGTnZFbDlTbzQwT0JTdFMvUXdXVU9tOTQ4?=
 =?utf-8?B?Szg3anRaTXFwWjd0NEhMa0RPR25zOXZZUlBqaG1RQ0I1aktCQm9HZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f191d26-68f4-4b92-e15b-08de8c191385
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 15:54:06.4352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5TXkqaOZrg3NSK/tFaHAj2c5ahIfWYKF605Vc/AipGwTb84SsiL8S24AaKhqLwLF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8848
X-Rspamd-Queue-Id: 447881C0016
X-Stat-Signature: 8d6kmtwx3yuw7dk1hoxxtwqjyrd6u665
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774626853-278224
X-HE-Meta: U2FsdGVkX1+AqHYgS0PZR/DDerudEif+ruFzH0dom26HqEVRalmINP9vKihnkUuEDyneh5HYgvemLgW/Jli/+4LzoTOGGiToH59h7id7a8FZ0+ZiCYxvyFMLucJRDuYI2jeFw8zmVVfDeNsqdFjKuwtmyJMc9GLEtU5mnFmVIihX467O5C4WDdzMg1OeILRh/gNdk40p8Tv7ODoo1hbWhRgGl8NjckKBoGvGxMo7XEO0GNVVHXXdIj58chk6nSJL+KFPIe+aQbmdL1aa868wiKdAY/gLbOezZIiE1R9BNSs4qriv8X9zjqWPMh1AcoN0YlgP7DAhGPR7FnDDj6xiICIShm7fBmgoE9bhgDXfAXI7c68vYYNTJdjYfLOlVh8ewdMzBQ7s1sXBDBApY8QaIW9nancXwFRd2w0c82PHNmGS96+efh+b6W61eIoF/JlMi2C18AHIcZKZa9JwV7irlF/4GWT9hnQ5RwzeJKW9y7SK7cThEgijQM2qIxmQzmqSU80t35LifIpfz4xMLaQ1S71sdVJtO5cXW5VVGHM4RGtzPK+jXtlxhhR5DINL1UlSxRZ9rvgbkQU6uUR32mPuAkC1xnBKWtEN9sjCWqkoaIvXXu0uEssLZPi0Vi47EKnRJFdh4vObeKuwb7SbVczUsgxnd59amjcYb/RUjMMCBYt4vKVPVv0F9HW8RSBKsBeWrv+HqEmSLJ7RVd0mzbtb9q6/unSWg5NAX6z1OJdUc4+leixvzYSy5ZSEhfRpo2xQHFx4RhvRw0szxPw0R4/fX4gfglM23ScdQD6HCwnbGGroXQD0x+t3FL5xUxe2KAz3CzsECclrfTyfLDZlZjLLPp9LS79EWRckFDLq38DlE2OXcxpLatJ+5R6doi+zNR+eFeRkJfC5QxYXG4DCjiIiF4qlXXLRapxtbs2uOHGXD97BegOw31n2dkISALxuzzLm7ixtrorPqGxEOPqePvM
 R46dnDBq
 cyYrWZ8F60F1KNXnOqxnMwRBDYZhDcYpsQwZ+D1K3H+zlN3ZY58BcRhdkaBFCIkWf2iXWU1WtAVlmSu2tPYb6xU9nvcNqhALI2USbN407g7vxh3YZ3wq8wUCTOYxkqGZQsyqhSlRFrf8bbIqLK68KazKDt5uc6gRKwZ9prGjp/UREK9qX9QzfB8IL23rI6k2W6y6K3GANTPzxs8KAY0lF2NGeW60/4jDBl0T0B8cKAD9irSbjYrCovzO5+1GrLKblNZShVL9zTFZsYlLMI1+X62qUvJR5gwsUf/Q1K0nyUvb6P5PAGdGBA6j0IaGQEIckvjW26eOt/+P2O8wcSqcxiQndm2PJ7UApS/fq/C9eSIywmxY0dw1kTbHR3L/gnHSgUaf+kXthWevNkxvvD7MatOaqQvRhWhVkcKw1i6r47Y+lEeKPu7If5QTk+XHygQ1Z3NhtoZfKSwE9vYhh/8lVhy3jq1p91+lsYkyyb3FzOeWkow/UvPAWd9EszrxpnWQcUBK5xtyyu53iKBYU9qmoq7IPJMQbiodjTu69bPOkgXEWPjO11RcKu2gd+qKNGWmyzFyTEa2Q2Wk60VXgKbqG/PAUgK2148yacTUQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27 Mar 2026, at 8:57, Muhammad Usama Anjum wrote:

> From: Ryan Roberts <ryan.roberts@arm.com>
>
> Decompose the range of order-0 pages to be freed into the set of largest
> possible power-of-2 size and aligned chunks and free them to the pcp or
> buddy. This improves on the previous approach which freed each order-0
> page individually in a loop. Testing shows performance to be improved by
> more than 10x in some cases.
>
> Since each page is order-0, we must decrement each page's reference
> count individually and only consider the page for freeing as part of a
> high order chunk if the reference count goes to zero. Additionally
> free_pages_prepare() must be called for each individual order-0 page
> too, so that the struct page state and global accounting state can be
> appropriately managed. But once this is done, the resulting high order
> chunks can be freed as a unit to the pcp or buddy.
>
> This significantly speeds up the free operation but also has the side
> benefit that high order blocks are added to the pcp instead of each page
> ending up on the pcp order-0 list; memory remains more readily available
> in high orders.
>
> vmalloc will shortly become a user of this new optimized
> free_contig_range() since it aggressively allocates high order
> non-compound pages, but then calls split_page() to end up with
> contiguous order-0 pages. These can now be freed much more efficiently.
>
> The execution time of the following function was measured in a server
> class arm64 machine:
>
> static int page_alloc_high_order_test(void)
> {
> 	unsigned int order = HPAGE_PMD_ORDER;
> 	struct page *page;
> 	int i;
>
> 	for (i = 0; i < 100000; i++) {
> 		page = alloc_pages(GFP_KERNEL, order);
> 		if (!page)
> 			return -1;
> 		split_page(page, order);
> 		free_contig_range(page_to_pfn(page), 1UL << order);
> 	}
>
> 	return 0;
> }
>
> Execution time before: 4097358 usec
> Execution time after:   729831 usec
>
> Perf trace before:
>
>     99.63%     0.00%  kthreadd         [kernel.kallsyms]      [.] kthread
>             |
>             ---kthread
>                0xffffb33c12a26af8
>                |
>                |--98.13%--0xffffb33c12a26060
>                |          |
>                |          |--97.37%--free_contig_range
>                |          |          |
>                |          |          |--94.93%--___free_pages
>                |          |          |          |
>                |          |          |          |--55.42%--__free_frozen_pages
>                |          |          |          |          |
>                |          |          |          |           --43.20%--free_frozen_page_commit
>                |          |          |          |                     |
>                |          |          |          |                      --35.37%--_raw_spin_unlock_irqrestore
>                |          |          |          |
>                |          |          |          |--11.53%--_raw_spin_trylock
>                |          |          |          |
>                |          |          |          |--8.19%--__preempt_count_dec_and_test
>                |          |          |          |
>                |          |          |          |--5.64%--_raw_spin_unlock
>                |          |          |          |
>                |          |          |          |--2.37%--__get_pfnblock_flags_mask.isra.0
>                |          |          |          |
>                |          |          |           --1.07%--free_frozen_page_commit
>                |          |          |
>                |          |           --1.54%--__free_frozen_pages
>                |          |
>                |           --0.77%--___free_pages
>                |
>                 --0.98%--0xffffb33c12a26078
>                           alloc_pages_noprof
>
> Perf trace after:
>
>      8.42%     2.90%  kthreadd         [kernel.kallsyms]         [k] __free_contig_range
>             |
>             |--5.52%--__free_contig_range
>             |          |
>             |          |--5.00%--free_prepared_contig_range
>             |          |          |
>             |          |          |--1.43%--__free_frozen_pages
>             |          |          |          |
>             |          |          |           --0.51%--free_frozen_page_commit
>             |          |          |
>             |          |          |--1.08%--_raw_spin_trylock
>             |          |          |
>             |          |           --0.89%--_raw_spin_unlock
>             |          |
>             |           --0.52%--free_pages_prepare
>             |
>              --2.90%--ret_from_fork
>                        kthread
>                        0xffffae1c12abeaf8
>                        0xffffae1c12abe7a0
>                        |
>                         --2.69%--vfree
>                                   __free_contig_range
>
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> Co-developed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
> Changes since v3:
> - Move __free_contig_range() to more generic __free_contig_range_common()
>   which will used to free frozen pages as well
> - Simplify the loop in __free_contig_range_common()
> - Rewrite the comment
>
> Changes since v2:
> - Handle different possible section boundries in __free_contig_range()
> - Drop the TODO
> - Remove return value from __free_contig_range()
> - Remove non-functional change from __free_pages_ok()
>
> Changes since v1:
> - Rebase on mm-new
> - Move FPI_PREPARED check inside __free_pages_prepare() now that
>   fpi_flags are already being passed.
> - Add todo (Zi Yan)
> - Rerun benchmarks
> - Convert VM_BUG_ON_PAGE() to VM_WARN_ON_ONCE()
> - Rework order calculation in free_prepared_contig_range() and use
>   MAX_PAGE_ORDER as high limit instead of pageblock_order as it must
>   be up to internal __free_frozen_pages() how it frees them
> ---
>  include/linux/gfp.h |   2 +
>  mm/page_alloc.c     | 103 +++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 103 insertions(+), 2 deletions(-)

LGTM, except some nits below.

Reviewed-by: Zi Yan <ziy@nvidia.com>


> +/**
> + * __free_contig_range - Free contiguous range of order-0 pages.
> + * @pfn: Page frame number of the first page in the range.
> + * @nr_pages: Number of pages to free.
> + *
> + * For each order-0 struct page in the physically contiguous range, put a
> + * reference. Free any page who's reference count falls to zero. The

s/who’s/whose

> + * implementation is functionally equivalent to, but significantly faster than
> + * calling __free_page() for each struct page in a loop.
> + *
> + * Memory allocated with alloc_pages(order>=1) then subsequently split to
> + * order-0 with split_page() is an example of appropriate contiguous pages that
> + * can be freed with this API.
> + *
> + * Context: May be called in interrupt context or while holding a normal
> + * spinlock, but not in NMI context or while holding a raw spinlock.
> + */
> +void __free_contig_range(unsigned long pfn, unsigned long nr_pages)
> +{
> +	__free_contig_range_common(pfn, nr_pages, false);

__free_contig_range_common(pfn, nr_pages, /* is_frozen= */ false);

is what we usually do for bool input for a better readability.

> +}
> +EXPORT_SYMBOL(__free_contig_range);
> +
>  #ifdef CONFIG_CONTIG_ALLOC
>  /* Usage: See admin-guide/dynamic-debug-howto.rst */
>  static void alloc_contig_dump_pages(struct list_head *page_list)
> @@ -7330,8 +7430,7 @@ void free_contig_range(unsigned long pfn, unsigned long nr_pages)
>  	if (WARN_ON_ONCE(PageHead(pfn_to_page(pfn))))
>  		return;
>
> -	for (; nr_pages--; pfn++)
> -		__free_page(pfn_to_page(pfn));
> +	__free_contig_range(pfn, nr_pages);
>  }
>  EXPORT_SYMBOL(free_contig_range);
>  #endif /* CONFIG_CONTIG_ALLOC */
> -- 
> 2.47.3


Best Regards,
Yan, Zi

