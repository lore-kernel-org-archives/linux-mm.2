Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6E72CD98E3
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 21:39:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0587B8E0007; Thu, 13 Nov 2025 16:39:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 009448E0002; Thu, 13 Nov 2025 16:39:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEBD88E0007; Thu, 13 Nov 2025 16:39:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C21828E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:39:39 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 570DA16013C
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 21:39:39 +0000 (UTC)
X-FDA: 84106900878.15.0CE6993
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010057.outbound.protection.outlook.com [40.93.198.57])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4C2ED140007
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 21:39:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KFQ3WtPZ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.198.57 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763069976; a=rsa-sha256;
	cv=pass;
	b=R1f+KMmNfVBUeoV+mQcd3fyDDvM912FgWtNVhxWzk94giOYRyT5gkd/+t+wrzDxTSJJzgC
	3p4FKz4S6HL8eoKoR+RKRQgE2aucdq4Wpev4J/lu39D2nE3wl40L3+ENJSZ4vG1Rf4w6DL
	OP1YrhaPdMv7RiwS91iYAid+TTEue5w=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KFQ3WtPZ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.198.57 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763069976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=62aIdj9hNPBEBSobKz61QTF+qjyNx53Hc8bOlFcqQd0=;
	b=f1QVtprJit+UfHtRuzbRwbPR/E90HcNNx4D3enxgu1bwFGB1JAX+zQr2LVqC7P79bSTRPP
	8v4LYRM/6N0CknH4kYxQj7c1o17HrHbdecZMi4u/c+on0oWVxDYMHggNoOYocdIPvzqZ10
	j8PCp+ZSL9cNfxabTxWa58uaQUUXcug=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F+Bk/5FFqJXZCCO5XUHQTPB8txce/eiA1mj32mAv+2eI36ZcgZGyOLMPjMuYPK2PiWCEaWGzuco7hmY+lXA7vfJgvoU+r7+FRiF1YsCVhFCQJuz4BM3F+JPL5VuNKOrau/SyhKdrjg15GzMDiYkW73DDlLCSSyVcwC1MYhf/sPwXPNnVDuJgR6ThVL2fUIQGs9CNQM7X9DlyTY5/w6pbaAe0iEAsVSzvhuUJ+Z+/pWdA0a7V6w86ZQbtEUbb+fGhvDtf8wWHsgcRgz81lBJLXNXlrCuyVYowmc9eGB/jkGXebXFBQQpUAIjdaTffh9brjok6jxdWX5vyoX0sS9/0RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=62aIdj9hNPBEBSobKz61QTF+qjyNx53Hc8bOlFcqQd0=;
 b=ZTCUKI5aiV2ILOS3Z6RTHK83y9CB8JE0PCLgo066GyiLpNM8gR6a/q/5BbiCKMp0uC/Swl3Wu19BzRHFXX9bwczCl+K+FrafzcmaHt8NM7TEFXTIOFdfrxxm7QIX0VpFmC8OscKGaliGQfA3GP9ICaFmUZDKP/G9qjW93hYCsQpC5S1J098S16+QvmtN6uhA1SPDnG2VsNjoO1JG6zs+SPci8763No1Y5UTc4sOdfPS7gqKTvPEeNi2EyVE43HYT3OHX0D4fZ3oRtlIc+m/V1P79H7UVA5M5Hc11rl62kZ47ArUQN/xoUQ0TAsv4dy+a4vHxkLoewVttyVLgyQPzhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=62aIdj9hNPBEBSobKz61QTF+qjyNx53Hc8bOlFcqQd0=;
 b=KFQ3WtPZD1qYncfgS5gIJvtrD02sO6YVIUpahyqRNMBAWs7scDFvJwDC8IxDjDQ7Agzrk65JH9kPD/w+jtO81B/VRCaOhqZJzujm+lOJkqD4VGUMMa31wkFWKuqigyI6aUz760lEfcyd98vLWm7pPlkYkwF7fo7EocVSsi98H66Nlz1dykFd9rVokLjkkdKSmigsHy20tLqdJTsWx7r5u8gNLhlazBVFJrt6sHjjeFptIimYniq3xz/5DgVw3uPHUprSfAj8DpNkqJVBnjmml23zao8hoCP7tedXsI4m0OStJa5Ao0fUhvYVRS68z+37gNXDePYavD+i1YX2k/pASg==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by SJ0PR12MB7036.namprd12.prod.outlook.com (2603:10b6:a03:483::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 21:39:29 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 21:39:29 +0000
Message-ID: <20ad8b5c-1bb3-46bb-bc03-8e9222a7f7e1@nvidia.com>
Date: Fri, 14 Nov 2025 08:39:21 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory.c: introduce split_unmapped_folio_to_order
From: Balbir Singh <balbirs@nvidia.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
 Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20251112044634.963360-1-balbirs@nvidia.com>
 <048134fd-6a3d-4a6c-a2eb-9a9911c3b35f@kernel.org>
 <efa37c4d-8c9f-4094-a713-4fd4452ae917@nvidia.com>
 <826df5b1-b61d-4794-a96c-dcf9ac19e269@kernel.org>
 <bf8e0c95-15a1-4eac-ba2e-52d361050039@nvidia.com>
Content-Language: en-US
In-Reply-To: <bf8e0c95-15a1-4eac-ba2e-52d361050039@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0172.namprd05.prod.outlook.com
 (2603:10b6:a03:339::27) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|SJ0PR12MB7036:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ddac44a-50d7-46bb-0b5a-08de22fd1fb8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|10070799003|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?enZYR2NxQTY1SGNUa1FzRGt5NThINTB6RmNJWmhTM2N6U3UweWxwazk5ZDdk?=
 =?utf-8?B?K2pyZXlrTXpyYUlSdHIxdEg5SjMyTVFHMnlTdnBlL0NPcWgxaFRzMTF4aGxC?=
 =?utf-8?B?MGdRVlVmeGFPU0xCd05lTno2b2NVQjBSOGh0QnFiUURIZXBNODVvUThRVk9M?=
 =?utf-8?B?N2hTODVLMHkyWUpYb3crZFRiK1V6ZEUzNW1MQUlFd1ZZbTJjU2pYS2grVTlm?=
 =?utf-8?B?YlFReXpPME8zeGp6L0gwMDE0M1JCWndUYXdkajhlemgxWVRYYVE1S25Dc1hr?=
 =?utf-8?B?RlF4T05jY2pIUzB6TmZpa0Y4QU43bGZ0QkZEd3pUQ3BodEdZS2FEWm51bk9K?=
 =?utf-8?B?emdUYXMyNTVEQnJxanFWN0h6UHdOaHlVbE9VVG9jUDcyUE5BblNOQVZmNUxG?=
 =?utf-8?B?akVWWkRib1B5V3VmNkFrdkVUKzhVMTVadGJwSENJWTg5b0tRWXdzMkNSamlv?=
 =?utf-8?B?SEtkMXRlVWlOdUpTWDhaNWhnMVVUUFlyd1BFWDd6bVU4TElQMXpHVVR4dGtX?=
 =?utf-8?B?UHBXck01cWxsa3dhQ0d6UEYzVk5pV1JJMkpUcldYckNCVGx0VFF1SmZxSHpt?=
 =?utf-8?B?S0VsVzB5Z29BdGdNbTZXSzFSbWNvYlBrTFI4UUNzOEVTc0pXcE1SL1hvTUdh?=
 =?utf-8?B?TTE4UDZobkpmVnV1MTF4cWZHMkhlSmhlUElxV1RBUlNVZGVhbldzYUVjb2Jm?=
 =?utf-8?B?Z0xnUW82S2FUd013dVJyQnk1WjlFcDN2Mi9DNkw4OWY2alBjejFpcXRMeGdp?=
 =?utf-8?B?QXlydTVpV3VYd1o2VC85ZXdKU0xLUU85Z01CNjg4M0pVYzEvSVpXbHFtY0RX?=
 =?utf-8?B?MmFNOUxJYnN2SlBhdFZWdzlyeEs2bTFLN211dVhrNUpmOHdwMU16ZU9ySkFy?=
 =?utf-8?B?SkRVTExIWGcwY3ExTlZPUVhoN2dZYnNuRzU5ZWZaNGxqT0Q0ZUZkU3JTY21L?=
 =?utf-8?B?aTRYOXBEZURPSzE1L0JoR0pFMjhnemU1VVBwS3lCU0hpTXZQTEx2b3BVVG80?=
 =?utf-8?B?UTh6bXk3NWtMaHpDQW9hWjdOVTR6Qmh5UzR4a0xvbjhrWGk3V21Bc1lGM3Fo?=
 =?utf-8?B?U2kzdXRMTjZDdnR3T3RuYTdkV3lpSC9vNjhISGVsNXhWdDZTeDdKYzYvRDZR?=
 =?utf-8?B?enM2NFN4M21YUW84RnNzQTRDejhYN3pCSUFZVEtEbG1qNXZaRktudW94Wjhx?=
 =?utf-8?B?ek5LeEdCa0IxdVg3K3hkWlU5Z0FjanJnYjh2MFRnMm5MQVdTdC9LYXRMdTFu?=
 =?utf-8?B?dnpIMlRJWFdaQ01iOGZmdEhFNk5qSHlPYm5oQUZzT0F4QlBlN1A2YXZqRzhJ?=
 =?utf-8?B?SDhyb0wyWDlwQkpoUVNRcDJQZDBoazU2Z3NsdEx3VmIzSXdHUm1HcXRDaDZX?=
 =?utf-8?B?d1VmRys1U0RZaUlWbjlkQ0QvNi94ZzhFNGorQWMxZmY5SSthaHU3cDFIaUZR?=
 =?utf-8?B?Umd1Nk96cmRyZ1FzcUNHUS9YMU8vV3MxRFc1TDdwU1Nmb0l6dlJWK3dLdHRl?=
 =?utf-8?B?OVRLa003Smsrd2V4NlJrWE5rQ3dod1BGNUdFZVlSUU53aVJ5c2VOWDUwR01n?=
 =?utf-8?B?Z0g5M2oreWo0L2p2bGNxajRaZkZjRnBrU1VFUTNlRDhtalFqVjBOcnFLN3I1?=
 =?utf-8?B?bGhjWUFuR2hnL2N4cllvaTlGSXc3NmR2Q05DcFZvTUwvRGMwNENzVVlxQzBP?=
 =?utf-8?B?Mk1OU1U5Tm9pUm02WW43Q0ovREZrMkVKVGg3MUM4MWZkZTNodS9kRzZJcTFr?=
 =?utf-8?B?cmd3NDJrekY0b2E2KzcwOHpKYTNvMXM3VGZTak1qclZ6T3Yxb2RJY0ZxZ1g1?=
 =?utf-8?B?SEFGWVlwSUZ6OHRFck1QM1BPZC84eDM0TVBTZ3BoM0J3MFA5VzFQQ25RNjNO?=
 =?utf-8?B?RFY0UTl6TFZMY296NmZUK05sNDhhK0hSbVdGbHdvVEI3cDdaZ3kxdWFHUGJJ?=
 =?utf-8?Q?kTF03QdsrR9O9jkVg583Dk+J57RafvGs?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NURNRk1LQVBwWm9pV0hiaTVIWVU1OGFSSVJad2ZWbTJmdk5XcE8zWFNjTDhj?=
 =?utf-8?B?LzJCR05ob2I5VDFscjBocTJvQjIraGo3Y3ZQM3VvQlRjT0pCWHFSWWkvMEJV?=
 =?utf-8?B?VVNzUmRGc1BEZjBmdkRWWjhGb3hzUWtVY0NNKzQ4Zk5vUjJVdm13M211QWlC?=
 =?utf-8?B?RVFMemwwVWdEcmRSclhkQnB3R2NLbnZpbm0wUEt5QmVUWFRzVW9QeGxYL1lh?=
 =?utf-8?B?SFRqT2F6ZDZ2Yk1qQWR2bVhBU0JldmFPVlJsSUduZUVucjNhQXNEWXNWSkFx?=
 =?utf-8?B?NktCZjdmckZ0WnRNU2xFRDNQd0xmWHpxMTNnQUhrZTgwTGJDaWp3Wm5HVWdw?=
 =?utf-8?B?Mk5SbUE1ZW1tK2ZJQUVUa1VSOVZwWDdZa0NuUWlNbGJrTVJ0Y0tDSnNSK0tW?=
 =?utf-8?B?RTFNU3JTbFZYS2g2VXhnRzdUcnhvYjk2aXh6SHdYYmZCdXhTamVWWDBoTi9o?=
 =?utf-8?B?d1FBNHpQMlVZenVOblg0U05kTS9iQjlFZC9WVWNZWmRBYzVZVlhIcTY5UEV1?=
 =?utf-8?B?TG4yVU5kR0pleEJUby8vVk1CRDFiTW1EaCtjZUwxM3dLTHkyRi9QR2RUN3lH?=
 =?utf-8?B?ZUtHQlpSNHRxOE5JU0t4Q0hSMkRIbllUK1FsREVJQndFcHUxK2VOUWlwc3Bs?=
 =?utf-8?B?dzlCOXZYQWNvY0dDdVZFRDl0bk1zVWVWdDl4dU9OZ1ovcms2Q213Nyswd2lN?=
 =?utf-8?B?RzBaSzdrYVRaYkRtUnh0NzBOSlBXM3ZZVjZqUHRxbHNNeDJ0UnpFSEk3OE52?=
 =?utf-8?B?eUZkS3hqeXZsRG1Ba09Vb0FZYnRTQWd4dTNNQ2p4YWRLbHFzRFd2VndYOWp2?=
 =?utf-8?B?VFp2TmRHNStnbERrQzZHdmxUaXo0N095bVZHVE9ZVXd4VkJUZlR2SEVPZEhT?=
 =?utf-8?B?MUNxVDczaERza1ZPL2VLeVE5ZDBnMUN5SWxScE8yRzdzMGNicm1kb1hNWXhN?=
 =?utf-8?B?cHBxbWhmRDZLb1hJUlRCak5EMHZkeHRieSs5VWNsWXhMVzc1enN6cmhIRDQr?=
 =?utf-8?B?NWxtUEFUZ2lkQ1hWVWZmTmJIYy92NTF4T3ZjQ0UvQnE5OHNjVXQzWkpCV0RR?=
 =?utf-8?B?VW9xSE44L0NjSC9DcFVzYVAwOVFhclRaamdlek5oeTRja3JDZWo3dTlUd2Nk?=
 =?utf-8?B?TFE0My9tbThOTlZHdFBMSjlmMHA1MWFndXJQNnY0Nmh4WldSRDBkaThwQUpK?=
 =?utf-8?B?WSs3a1kwejJGdExsRndHSDVPaS94b0tzTURBNFk1eit5c2w0M1Bac1BHam5L?=
 =?utf-8?B?Mmg0eERmdyttZ3UwL1ErUzVORmpQSy9FdjB4eHFJVmh1WXFiZEIzNWg2NWxy?=
 =?utf-8?B?V08zVkZxaHRmM0hibzFjTUgxUzgvbHQ4Qzg0cG9UR0w0cllDUEZmSkNzWXJE?=
 =?utf-8?B?bWpVMUhMUXRSYng0ck1YdWFIdm4zckRRVmJUdHJyNHFVWUo3TmNCbi9sc1Uz?=
 =?utf-8?B?alRNU0dGelkvSFhEVHZ1SnZ5a29iZUJYVmVycTZwTmhJZjJydXlqQzZ5WWRS?=
 =?utf-8?B?OGpGSXc1U0hJQ2NxRVNNY0RwcVhpSlArTXBnMVhXelNzRUZnK2YyRmxDMUNQ?=
 =?utf-8?B?bjFpOS9SRjJvdXEwcHBrdzFBbW1halM4OU1yUTN2a05EekoxU2dnUmdnNEtB?=
 =?utf-8?B?VnFqbVRnNW1HRXV5NFJXVVB1a2FCMkk0aWFKZ3p6ODVZVk9XenpVbnlKSHdW?=
 =?utf-8?B?ZEpUZDNHa296M3VwUERLYnhzb3RMdlprTlp2clp1czMvS0NFUSthZ1JkN1VF?=
 =?utf-8?B?LzNRa3krL2JHTGkwMnBQMTc3ZnFUdVdHM082NCt0b3lpVkQxcU5jM2xJMWto?=
 =?utf-8?B?WEpFWFQyOUpJTFE5ZWdyZWY4L1dWNjBIZjFXSE00QjQ3RjVVTXFHL0t1WW1i?=
 =?utf-8?B?U3ZIK28vVElDM2Exb21la2ltMGNHNUlNeGRwSUZaS2t5VmpwM1ZoMXZUNUlk?=
 =?utf-8?B?ek5OVUduc1R5YWxuWGhPZFpZbUpjOWNHcXF5RTBHaW9RejNjL2IwOUtmMkFV?=
 =?utf-8?B?V3daTnJMc0FkS1FJU1FjSk9xK003SC9uN1JTaVMwQ0RGYldvRmJja1YwRGNL?=
 =?utf-8?B?THNrNUl0eUxOWlRhZkpiMndYZ3Bvdzd5R3BQdTFaMDcwZTJ4dWZZK3J1MnlM?=
 =?utf-8?B?enluVjhHczhVRkprM3hHOW1rVWJiVDk1SzRBWFo5WFZOcml2MVlWZk9na2xM?=
 =?utf-8?Q?Jqb+Agq7n163sXyEVv4Q1niAxOakjLf3DaTtZZ1Gh9Uv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ddac44a-50d7-46bb-0b5a-08de22fd1fb8
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 21:39:28.9858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uZvX6GoJunc3vx2dXXDXF9a5p9cFXOtdXbWCzCYktAVLjk3/KTgyuvbeR20Qo6Ux5yJWraxH5ViocFgW+mFf+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7036
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4C2ED140007
X-Stat-Signature: x5rq4a8o7dxn7aw1msyffpnhu1ijwzds
X-HE-Tag: 1763069976-158658
X-HE-Meta: U2FsdGVkX195OBVoWWINBRlCI3kAilxLCWfQYtAWzl8DVWfX1luZBuFrKu3qdd1yApGe8JuD1KW+G+2KBOQvfcmyAWttvpoBs7IRwIBg8e0nYscGkqlxLjME+/QF0Hm5sZOCAVBor4MMP9SMYHqAMcLa8tqOuMNBLjPKZpuEdbKIzZxGDctm3DJbUqiAnwY6Yb44ssjLQfUkVjPv7k9imiIkOL1P/r3zBg/3wRwyLP4Q2j5uS+ile/ldNommA1JtCZ5Dbm1xHpAAbQ4fSZ04CEVr8rFZPfuc64MfcOAOa8ydklev5pIDoblNvNwEZNjMxJVUlvL0WP1ctZn5gDacx8VOeIbUXzGX2qokStcRgAywyceIEyDWf6ljVrZS3BrgaXKQpq8NSPTaV0iX4tlKzzuPEm7mOwuvOYoorcGO7wg/2NhqceT+q2j2LKeWJz6tmA3v2YRRLjZHhk9WEfp2vlSR9OGN9x1K3ygF1yoeq5upg21nTQFvY89ghHMo2Srw2PjJ1cYmmAOcIVdKbENgXbyRuwHD+fTa49Q8gtsgD1qwCy/5ofTUB8silEWueYA/JuolTMQu5TzC3PL7q5v+npm8TC9DTCh9UH+Auo9JdNphe1cm0Twf7YRe6GON4SIsegLAH2ZWxUSUqWTQrQQmSZM9SH4MpN7Ctc6SUkA+m6ud3Qx1pi3DrJvpsPVCP2Y9BDGkmsZYxzVf8Ie6ckf8sLWUuI3nIEH29ngWZ4Qj/649BfYDS4WiTfV0f+s4xZ5Q3gVZSLcO2P+TY8KEGMoX0sn/C0r/v2gFYshSKsz4XEZApEpzZxlosPKZkfZ3RYpkFe28kqhI9BMgZptpdSYh8Awp8YLujAPvFSAJYVHBxtXUvTZaDJbba1UH5kYv/ePeUNBMSVGT+nHyDS4U5vZ+SJ/ZwsoCcKlqAEs23WTSv0iTHkuKjuV6P/r9nLWf7e4jN2JrzFLAmxII2+g/b6B
 T1k/AfvL
 uqgOLk5JF9iuP4H3XPbRylaxxH0VHliqowKlBssewcgak46b3MUF0ewe48gq95aNiWIgkKfOV+TTVxNy8xbFmFB00BHvj8auuaRgG+Wa9GrMMJbIQUrd5qJ2JCYjAwWvfYLu/EkEK+Q7uJmjft/wgmm9QGLNw1XbDjYePl2hoZ1F8EH0HPtdpiabsuk85vtFF0Tcvas/z6F+mUX1Q7yTQJGb5K61I2+pfpe6wMUH1b44qjC3Hu7BlgpDL9WbeIce9jWSODTs8ir/yX5tJqHM9tJA7LEGaq0JPxLsxfaN24STcofQjwwpV4g3aNZBahpT8gueeRXRdk4K1ESnVtz4Eo7/66WBoojjduBmw3GflxwZZOg8iz/ndwhMjXU2HPteKpIu4f+1U4LS1gKzYy9d/T4a4MmZujN81ItJF7kM4QE/C/2ZkhUtKb5ECZdQ3Gkqe9i9W6KCi1oukSBvbUMhw/yCwx867uPZV3CqbiI6RZDOp2+yS9zG2j0fWc965PulIh0CRqWD3HZp7ChrzApXvKEquMjau22FOjPwxwQc0bnpXgc8iQoePmXtAFZB8Uculcsv5EH7WSIRm9OxxPEtf/rkUFaF97xqG0+QkzbWrhq+sqgoRtzOYtTKNe/ZAw12FquJvWfNjgiQ9aw5XKyUGJ5LAG3Dt9Z3o+rG5BTCVwMy/7mTcEnjxAeTp9GCSTJ8l+kqpEP0jZaolJnrX7zvF61obEWo1JoaZvcbLBYQCStAsliGijzMHqQ4LSIm0AVJvyWjf5z41gdQfkrCXIcEBxmR1lWDNIO+/P/agDIZTfLsTlJUCYH9x0m7zfH4nKm2WhmNYq58JVo4ILG+DE4a00sj9fgH/BPc/hDJmqFeW4vX5oE9D5bBzkszzUpsR7eBpAv3A9wajo7O/lKWtVtPFBsS5jVVQk1ej5CXClDFlq8Z6uAGi/c/YzE9Q/oOfKS9sDvok
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/13/25 10:49, Balbir Singh wrote:
> On 11/12/25 22:34, David Hildenbrand (Red Hat) wrote:
>> On 12.11.25 11:17, Balbir Singh wrote:
>>> On 11/12/25 21:00, David Hildenbrand (Red Hat) wrote:
>>>> On 12.11.25 05:46, Balbir Singh wrote:
>>>>> Unmapped was added as a parameter to __folio_split() and related
>>>>> call sites to support splitting of folios already in the midst
>>>>> of a migration. This special case arose for device private folio
>>>>> migration since during migration there could be a disconnect between
>>>>> source and destination on the folio size.
>>>>>
>>>>> Introduce split_unmapped_folio_to_order() to handle this special case.
>>>>> This in turn removes the special casing introduced by the unmapped
>>>>> parameter in __folio_split().
>>>>
>>>> As raised recently, I would hope that we can find a way to make all these splitting functions look more similar in the long term, ideally starting with "folio_split" / "folio_try_split".
>>>>
>>>> What about
>>>>
>>>>      folio_split_unmapped()
>>>>
>>>> Do we really have to spell out the "to order" part in the function name?
>>>>
>>>> And if it's more a mostly-internal helper, maybe
>>>>
>>>>      __folio_split_unmapped()
>>>>
>>>> subject: "mm/huge_memory: introduce ..."
>>>>
>>>
>>> I can rename it, but currently it confirms to the split_folio with order in the name
>>> The order is there in the name because in the future with mTHP we will want to
>>> support splitting to various orders.
>>
>> I think we should start naming them more consistently regarding folio_split() immediately and cleanup the other ones later.
>>
>> I don't understand why "_to_order" must be in the name right now. You can add another variant and start using longer names when really required.
>>
> 
> Ack
> 
>>>
>>>
>>>>>
>>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
>>>>> Cc: Rakie Kim <rakie.kim@sk.com>
>>>>> Cc: Byungchul Park <byungchul@sk.com>
>>>>> Cc: Gregory Price <gourry@gourry.net>
>>>>> Cc: Ying Huang <ying.huang@linux.alibaba.com>
>>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>>> Cc: Oscar Salvador <osalvador@suse.de>
>>>>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>>>>> Cc: Nico Pache <npache@redhat.com>
>>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>>> Cc: Dev Jain <dev.jain@arm.com>
>>>>> Cc: Barry Song <baohua@kernel.org>
>>>>> Cc: Lyude Paul <lyude@redhat.com>
>>>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>>>> Cc: David Airlie <airlied@gmail.com>
>>>>> Cc: Simona Vetter <simona@ffwll.ch>
>>>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>>>> Cc: Mika Penttilä <mpenttil@redhat.com>
>>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>>>
>>>>> Suggested-by: Zi Yan <ziy@nvidia.com>
>>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>>> ---
>>>>>    include/linux/huge_mm.h |   5 +-
>>>>>    mm/huge_memory.c        | 135 ++++++++++++++++++++++++++++++++++------
>>>>>    mm/migrate_device.c     |   3 +-
>>>>>    3 files changed, 120 insertions(+), 23 deletions(-)
>>>>>
>>>>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>>>>> index e2e91aa1a042..9155e683c08a 100644
>>>>> --- a/include/linux/huge_mm.h
>>>>> +++ b/include/linux/huge_mm.h
>>>>> @@ -371,7 +371,8 @@ enum split_type {
>>>>>      bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
>>>>>    int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>>>>> -        unsigned int new_order, bool unmapped);
>>>>> +        unsigned int new_order);
>>>>> +int split_unmapped_folio_to_order(struct folio *folio, unsigned int new_order);
>>>>>    int min_order_for_split(struct folio *folio);
>>>>>    int split_folio_to_list(struct folio *folio, struct list_head *list);
>>>>>    bool folio_split_supported(struct folio *folio, unsigned int new_order,
>>>>> @@ -382,7 +383,7 @@ int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
>>>>>    static inline int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>>>>>            unsigned int new_order)
>>>>>    {
>>>>> -    return __split_huge_page_to_list_to_order(page, list, new_order, false);
>>>>> +    return __split_huge_page_to_list_to_order(page, list, new_order);
>>>>>    }
>>>>>    static inline int split_huge_page_to_order(struct page *page, unsigned int new_order)
>>>>>    {
>>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>>> index 0184cd915f44..942bd8410c54 100644
>>>>> --- a/mm/huge_memory.c
>>>>> +++ b/mm/huge_memory.c
>>>>> @@ -3747,7 +3747,6 @@ bool folio_split_supported(struct folio *folio, unsigned int new_order,
>>>>>     * @lock_at: a page within @folio to be left locked to caller
>>>>>     * @list: after-split folios will be put on it if non NULL
>>>>>     * @split_type: perform uniform split or not (non-uniform split)
>>>>> - * @unmapped: The pages are already unmapped, they are migration entries.
>>>>>     *
>>>>>     * It calls __split_unmapped_folio() to perform uniform and non-uniform split.
>>>>>     * It is in charge of checking whether the split is supported or not and
>>>>> @@ -3763,7 +3762,7 @@ bool folio_split_supported(struct folio *folio, unsigned int new_order,
>>>>>     */
>>>>>    static int __folio_split(struct folio *folio, unsigned int new_order,
>>>>>            struct page *split_at, struct page *lock_at,
>>>>> -        struct list_head *list, enum split_type split_type, bool unmapped)
>>>>> +        struct list_head *list, enum split_type split_type)
>>>>
>>>> Yeah, nice to see that go.
>>>>
>>>>>    {
>>>>>        struct deferred_split *ds_queue;
>>>>>        XA_STATE(xas, &folio->mapping->i_pages, folio->index);
>>>>> @@ -3809,14 +3808,12 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>>>>             * is taken to serialise against parallel split or collapse
>>>>>             * operations.
>>>>>             */
>>>>> -        if (!unmapped) {
>>>>> -            anon_vma = folio_get_anon_vma(folio);
>>>>> -            if (!anon_vma) {
>>>>> -                ret = -EBUSY;
>>>>> -                goto out;
>>>>> -            }
>>>>> -            anon_vma_lock_write(anon_vma);
>>>>> +        anon_vma = folio_get_anon_vma(folio);
>>>>> +        if (!anon_vma) {
>>>>> +            ret = -EBUSY;
>>>>> +            goto out;
>>>>>            }
>>>>> +        anon_vma_lock_write(anon_vma);
>>>>>            mapping = NULL;
>>>>>        } else {
>>>>>            unsigned int min_order;
>>>>> @@ -3882,8 +3879,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>>>>            goto out_unlock;
>>>>>        }
>>>>>    -    if (!unmapped)
>>>>> -        unmap_folio(folio);
>>>>> +    unmap_folio(folio);
>>>>>    
>>>>
>>>> Hm, I would have hoped that we could factor out the core logic and reuse it for the new helper, instead of duplicating code.
>>>>
>>>> Did you look into that?
>>>>
>>>>
>>>
>>> I did, I ended up with larger spaghetti, I was hoping to look it as a follow up
>>> after the series with the mTHP changes and support (that is to be designed and
>>> prototyped).
>>
>> Looking at it in more detail, the code duplication is not desired.
>>
>> We have to find a way to factor the existing code out and reuse it from any new function.
>>
> 
> I came up with a helper, but that ends up with another boolean do_lru.
> 
> 

Zi, David, any opinions on the approach below?

> ---
>  include/linux/huge_mm.h |   5 +-
>  mm/huge_memory.c        | 336 +++++++++++++++++++++++-----------------
>  mm/migrate_device.c     |   3 +-
>  3 files changed, 195 insertions(+), 149 deletions(-)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index e2e91aa1a042..44c09755bada 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -371,7 +371,8 @@ enum split_type {
>  
>  bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
>  int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
> -		unsigned int new_order, bool unmapped);
> +		unsigned int new_order);
> +int split_unmapped_folio(struct folio *folio, unsigned int new_order);
>  int min_order_for_split(struct folio *folio);
>  int split_folio_to_list(struct folio *folio, struct list_head *list);
>  bool folio_split_supported(struct folio *folio, unsigned int new_order,
> @@ -382,7 +383,7 @@ int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
>  static inline int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>  		unsigned int new_order)
>  {
> -	return __split_huge_page_to_list_to_order(page, list, new_order, false);
> +	return __split_huge_page_to_list_to_order(page, list, new_order);
>  }
>  static inline int split_huge_page_to_order(struct page *page, unsigned int new_order)
>  {
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 0184cd915f44..534befe1b7aa 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3739,6 +3739,152 @@ bool folio_split_supported(struct folio *folio, unsigned int new_order,
>  	return true;
>  }
>  
> +static int __folio_split_unmapped(struct folio *folio, unsigned int new_order,
> +				  struct page *split_at, struct xa_state *xas,
> +				  struct address_space *mapping, bool do_lru,
> +				  struct list_head *list, enum split_type split_type,
> +				  int extra_pins)
> +{
> +	struct folio *end_folio = folio_next(folio);
> +	struct folio *new_folio, *next;
> +	int old_order = folio_order(folio);
> +	int nr_shmem_dropped = 0;
> +	int ret = 0;
> +	pgoff_t end = 0;
> +	struct deferred_split *ds_queue;
> +
> +	/* Prevent deferred_split_scan() touching ->_refcount */
> +	ds_queue = folio_split_queue_lock(folio);
> +	if (folio_ref_freeze(folio, 1 + extra_pins)) {
> +		struct swap_cluster_info *ci = NULL;
> +		struct lruvec *lruvec;
> +		int expected_refs;
> +
> +		if (old_order > 1) {
> +			if (!list_empty(&folio->_deferred_list)) {
> +				ds_queue->split_queue_len--;
> +				/*
> +				 * Reinitialize page_deferred_list after removing the
> +				 * page from the split_queue, otherwise a subsequent
> +				 * split will see list corruption when checking the
> +				 * page_deferred_list.
> +				 */
> +				list_del_init(&folio->_deferred_list);
> +			}
> +			if (folio_test_partially_mapped(folio)) {
> +				folio_clear_partially_mapped(folio);
> +				mod_mthp_stat(old_order,
> +					MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
> +			}
> +		}
> +		split_queue_unlock(ds_queue);
> +		if (mapping) {
> +			int nr = folio_nr_pages(folio);
> +
> +			if (folio_test_pmd_mappable(folio) &&
> +			    new_order < HPAGE_PMD_ORDER) {
> +				if (folio_test_swapbacked(folio)) {
> +					__lruvec_stat_mod_folio(folio,
> +							NR_SHMEM_THPS, -nr);
> +				} else {
> +					__lruvec_stat_mod_folio(folio,
> +							NR_FILE_THPS, -nr);
> +					filemap_nr_thps_dec(mapping);
> +				}
> +			}
> +		}
> +
> +		if (folio_test_swapcache(folio)) {
> +			if (mapping) {
> +				VM_WARN_ON_ONCE_FOLIO(mapping, folio);
> +				return -EINVAL;
> +			}
> +
> +			ci = swap_cluster_get_and_lock(folio);
> +		}
> +
> +		/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
> +		if (do_lru)
> +			lruvec = folio_lruvec_lock(folio);
> +
> +		ret = __split_unmapped_folio(folio, new_order, split_at, xas,
> +					     mapping, split_type);
> +
> +		/*
> +		 * Unfreeze after-split folios and put them back to the right
> +		 * list. @folio should be kept frozon until page cache
> +		 * entries are updated with all the other after-split folios
> +		 * to prevent others seeing stale page cache entries.
> +		 * As a result, new_folio starts from the next folio of
> +		 * @folio.
> +		 */
> +		for (new_folio = folio_next(folio); new_folio != end_folio;
> +		     new_folio = next) {
> +			unsigned long nr_pages = folio_nr_pages(new_folio);
> +
> +			next = folio_next(new_folio);
> +
> +			zone_device_private_split_cb(folio, new_folio);
> +
> +			expected_refs = folio_expected_ref_count(new_folio) + 1;
> +			folio_ref_unfreeze(new_folio, expected_refs);
> +
> +			if (do_lru)
> +				lru_add_split_folio(folio, new_folio, lruvec, list);
> +
> +			/*
> +			 * Anonymous folio with swap cache.
> +			 * NOTE: shmem in swap cache is not supported yet.
> +			 */
> +			if (ci) {
> +				__swap_cache_replace_folio(ci, folio, new_folio);
> +				continue;
> +			}
> +
> +			/* Anonymous folio without swap cache */
> +			if (!mapping)
> +				continue;
> +
> +			/* Add the new folio to the page cache. */
> +			if (new_folio->index < end) {
> +				__xa_store(&mapping->i_pages, new_folio->index,
> +					   new_folio, 0);
> +				continue;
> +			}
> +
> +			/* Drop folio beyond EOF: ->index >= end */
> +			if (shmem_mapping(mapping))
> +				nr_shmem_dropped += nr_pages;
> +			else if (folio_test_clear_dirty(new_folio))
> +				folio_account_cleaned(
> +					new_folio, inode_to_wb(mapping->host));
> +			__filemap_remove_folio(new_folio, NULL);
> +			folio_put_refs(new_folio, nr_pages);
> +		}
> +
> +		zone_device_private_split_cb(folio, NULL);
> +		/*
> +		 * Unfreeze @folio only after all page cache entries, which
> +		 * used to point to it, have been updated with new folios.
> +		 * Otherwise, a parallel folio_try_get() can grab @folio
> +		 * and its caller can see stale page cache entries.
> +		 */
> +		expected_refs = folio_expected_ref_count(folio) + 1;
> +		folio_ref_unfreeze(folio, expected_refs);
> +
> +		if (do_lru)
> +			unlock_page_lruvec(lruvec);
> +
> +		if (ci)
> +			swap_cluster_unlock(ci);
> +	} else {
> +		split_queue_unlock(ds_queue);
> +		return -EAGAIN;
> +	}
> +
> +	return 0;
> +}
> +
>  /**
>   * __folio_split() - split a folio at @split_at to a @new_order folio
>   * @folio: folio to split
> @@ -3747,7 +3893,6 @@ bool folio_split_supported(struct folio *folio, unsigned int new_order,
>   * @lock_at: a page within @folio to be left locked to caller
>   * @list: after-split folios will be put on it if non NULL
>   * @split_type: perform uniform split or not (non-uniform split)
> - * @unmapped: The pages are already unmapped, they are migration entries.
>   *
>   * It calls __split_unmapped_folio() to perform uniform and non-uniform split.
>   * It is in charge of checking whether the split is supported or not and
> @@ -3763,9 +3908,8 @@ bool folio_split_supported(struct folio *folio, unsigned int new_order,
>   */
>  static int __folio_split(struct folio *folio, unsigned int new_order,
>  		struct page *split_at, struct page *lock_at,
> -		struct list_head *list, enum split_type split_type, bool unmapped)
> +		struct list_head *list, enum split_type split_type)
>  {
> -	struct deferred_split *ds_queue;
>  	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
>  	struct folio *end_folio = folio_next(folio);
>  	bool is_anon = folio_test_anon(folio);
> @@ -3809,14 +3953,12 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  		 * is taken to serialise against parallel split or collapse
>  		 * operations.
>  		 */
> -		if (!unmapped) {
> -			anon_vma = folio_get_anon_vma(folio);
> -			if (!anon_vma) {
> -				ret = -EBUSY;
> -				goto out;
> -			}
> -			anon_vma_lock_write(anon_vma);
> +		anon_vma = folio_get_anon_vma(folio);
> +		if (!anon_vma) {
> +			ret = -EBUSY;
> +			goto out;
>  		}
> +		anon_vma_lock_write(anon_vma);
>  		mapping = NULL;
>  	} else {
>  		unsigned int min_order;
> @@ -3882,8 +4024,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  		goto out_unlock;
>  	}
>  
> -	if (!unmapped)
> -		unmap_folio(folio);
> +	unmap_folio(folio);
>  
>  	/* block interrupt reentry in xa_lock and spinlock */
>  	local_irq_disable();
> @@ -3900,142 +4041,14 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  		}
>  	}
>  
> -	/* Prevent deferred_split_scan() touching ->_refcount */
> -	ds_queue = folio_split_queue_lock(folio);
> -	if (folio_ref_freeze(folio, 1 + extra_pins)) {
> -		struct swap_cluster_info *ci = NULL;
> -		struct lruvec *lruvec;
> -		int expected_refs;
> -
> -		if (old_order > 1) {
> -			if (!list_empty(&folio->_deferred_list)) {
> -				ds_queue->split_queue_len--;
> -				/*
> -				 * Reinitialize page_deferred_list after removing the
> -				 * page from the split_queue, otherwise a subsequent
> -				 * split will see list corruption when checking the
> -				 * page_deferred_list.
> -				 */
> -				list_del_init(&folio->_deferred_list);
> -			}
> -			if (folio_test_partially_mapped(folio)) {
> -				folio_clear_partially_mapped(folio);
> -				mod_mthp_stat(old_order,
> -					MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
> -			}
> -		}
> -		split_queue_unlock(ds_queue);
> -		if (mapping) {
> -			int nr = folio_nr_pages(folio);
> -
> -			if (folio_test_pmd_mappable(folio) &&
> -			    new_order < HPAGE_PMD_ORDER) {
> -				if (folio_test_swapbacked(folio)) {
> -					__lruvec_stat_mod_folio(folio,
> -							NR_SHMEM_THPS, -nr);
> -				} else {
> -					__lruvec_stat_mod_folio(folio,
> -							NR_FILE_THPS, -nr);
> -					filemap_nr_thps_dec(mapping);
> -				}
> -			}
> -		}
> -
> -		if (folio_test_swapcache(folio)) {
> -			if (mapping) {
> -				VM_WARN_ON_ONCE_FOLIO(mapping, folio);
> -				ret = -EINVAL;
> -				goto fail;
> -			}
> -
> -			ci = swap_cluster_get_and_lock(folio);
> -		}
> -
> -		/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
> -		lruvec = folio_lruvec_lock(folio);
> -
> -		ret = __split_unmapped_folio(folio, new_order, split_at, &xas,
> -					     mapping, split_type);
> -
> -		/*
> -		 * Unfreeze after-split folios and put them back to the right
> -		 * list. @folio should be kept frozon until page cache
> -		 * entries are updated with all the other after-split folios
> -		 * to prevent others seeing stale page cache entries.
> -		 * As a result, new_folio starts from the next folio of
> -		 * @folio.
> -		 */
> -		for (new_folio = folio_next(folio); new_folio != end_folio;
> -		     new_folio = next) {
> -			unsigned long nr_pages = folio_nr_pages(new_folio);
> -
> -			next = folio_next(new_folio);
> -
> -			zone_device_private_split_cb(folio, new_folio);
> -
> -			expected_refs = folio_expected_ref_count(new_folio) + 1;
> -			folio_ref_unfreeze(new_folio, expected_refs);
> -
> -			if (!unmapped)
> -				lru_add_split_folio(folio, new_folio, lruvec, list);
> -
> -			/*
> -			 * Anonymous folio with swap cache.
> -			 * NOTE: shmem in swap cache is not supported yet.
> -			 */
> -			if (ci) {
> -				__swap_cache_replace_folio(ci, folio, new_folio);
> -				continue;
> -			}
> -
> -			/* Anonymous folio without swap cache */
> -			if (!mapping)
> -				continue;
> -
> -			/* Add the new folio to the page cache. */
> -			if (new_folio->index < end) {
> -				__xa_store(&mapping->i_pages, new_folio->index,
> -					   new_folio, 0);
> -				continue;
> -			}
> -
> -			/* Drop folio beyond EOF: ->index >= end */
> -			if (shmem_mapping(mapping))
> -				nr_shmem_dropped += nr_pages;
> -			else if (folio_test_clear_dirty(new_folio))
> -				folio_account_cleaned(
> -					new_folio, inode_to_wb(mapping->host));
> -			__filemap_remove_folio(new_folio, NULL);
> -			folio_put_refs(new_folio, nr_pages);
> -		}
> -
> -		zone_device_private_split_cb(folio, NULL);
> -		/*
> -		 * Unfreeze @folio only after all page cache entries, which
> -		 * used to point to it, have been updated with new folios.
> -		 * Otherwise, a parallel folio_try_get() can grab @folio
> -		 * and its caller can see stale page cache entries.
> -		 */
> -		expected_refs = folio_expected_ref_count(folio) + 1;
> -		folio_ref_unfreeze(folio, expected_refs);
> -
> -		unlock_page_lruvec(lruvec);
> -
> -		if (ci)
> -			swap_cluster_unlock(ci);
> -	} else {
> -		split_queue_unlock(ds_queue);
> -		ret = -EAGAIN;
> -	}
> +	ret = __folio_split_unmapped(folio, new_order, split_at, &xas, mapping,
> +				     true, list, split_type, extra_pins);
>  fail:
>  	if (mapping)
>  		xas_unlock(&xas);
>  
>  	local_irq_enable();
>  
> -	if (unmapped)
> -		return ret;
> -
>  	if (nr_shmem_dropped)
>  		shmem_uncharge(mapping->host, nr_shmem_dropped);
>  
> @@ -4079,6 +4092,39 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  	return ret;
>  }
>  
> +/*
> + * This function is a helper for splitting folios that have already been unmapped.
> + * The use case is that the device or the CPU can refuse to migrate THP pages in
> + * the middle of migration, due to allocation issues on either side
> + *
> + * The high level code is copied from __folio_split, since the pages are anonymous
> + * and are already isolated from the LRU, the code has been simplified to not
> + * burden __folio_split with unmapped sprinkled into the code.
> + *
> + * None of the split folios are unlocked
> + */
> +int split_unmapped_folio(struct folio *folio, unsigned int new_order)
> +{
> +	int extra_pins, ret = 0;
> +
> +	VM_WARN_ON_FOLIO(folio_mapped(folio), folio);
> +	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> +	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
> +
> +	if (!can_split_folio(folio, 1, &extra_pins)) {
> +		ret = -EAGAIN;
> +		return ret;
> +	}
> +
> +
> +	local_irq_disable();
> +	ret = __folio_split_unmapped(folio, new_order, &folio->page, NULL,
> +				     NULL, false, NULL, SPLIT_TYPE_UNIFORM,
> +				     extra_pins);
> +	local_irq_enable();
> +	return ret;
> +}
> +
>  /*
>   * This function splits a large folio into smaller folios of order @new_order.
>   * @page can point to any page of the large folio to split. The split operation
> @@ -4127,12 +4173,12 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>   * with the folio. Splitting to order 0 is compatible with all folios.
>   */
>  int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
> -				     unsigned int new_order, bool unmapped)
> +				     unsigned int new_order)
>  {
>  	struct folio *folio = page_folio(page);
>  
>  	return __folio_split(folio, new_order, &folio->page, page, list,
> -			     SPLIT_TYPE_UNIFORM, unmapped);
> +			     SPLIT_TYPE_UNIFORM);
>  }
>  
>  /**
> @@ -4163,7 +4209,7 @@ int folio_split(struct folio *folio, unsigned int new_order,
>  		struct page *split_at, struct list_head *list)
>  {
>  	return __folio_split(folio, new_order, split_at, &folio->page, list,
> -			     SPLIT_TYPE_NON_UNIFORM, false);
> +			     SPLIT_TYPE_NON_UNIFORM);
>  }
>  
>  int min_order_for_split(struct folio *folio)
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index c50abbd32f21..23b7bd56177c 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -918,8 +918,7 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
>  
>  	folio_get(folio);
>  	split_huge_pmd_address(migrate->vma, addr, true);
> -	ret = __split_huge_page_to_list_to_order(folio_page(folio, 0), NULL,
> -							0, true);
> +	ret = split_unmapped_folio(folio, 0);
>  	if (ret)
>  		return ret;
>  	migrate->src[idx] &= ~MIGRATE_PFN_COMPOUND;


Thanks,
Balbir

