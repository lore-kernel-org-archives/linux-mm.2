Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46DF0CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 12:24:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3B2F8E001B; Tue, 16 Sep 2025 08:24:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C50A8E0001; Tue, 16 Sep 2025 08:24:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 864DE8E001B; Tue, 16 Sep 2025 08:24:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 708008E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 08:24:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 26EF11A0153
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:24:07 +0000 (UTC)
X-FDA: 83895030534.01.39648AE
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013026.outbound.protection.outlook.com [40.93.201.26])
	by imf28.hostedemail.com (Postfix) with ESMTP id 462E3C000F
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:24:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=F8IkJfm8;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.201.26 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758025444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=weLzfpnElnyzpxv8CmJGmECpkheneUSTeKQEr1RuzJc=;
	b=t/2gvjjpEzD9UqL0L9mziKwqD5LyZh9WgIwjQ6kw2wCDi67aizp/zt4JmJv9M2LNIPwnvK
	I5Cv7zgZPOCJBHCg3qQd32DhJh+RukCKnCG2niuA9G4ORZf1Wck3d9ikdUgPcq9aqq2UK3
	sjWZVFR8XvIVAIisNNfOZ2B52pvIjX0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758025444; a=rsa-sha256;
	cv=pass;
	b=hsgDin9dsa4U+YdN6JhYFkfuwyIB39o0rsJz7vMrzafpcXZ5I8tM39kvZxXZNa9xBhVfAf
	TkwfbVvZvC4Wr437/shpy82Mg5laYrO6yKqGNjGNiKblKa0aeioYc1D7pTjjmHmbVsYsjV
	S87wp0wWvIlZFwdzlFtgQT16e+3XF4M=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=F8IkJfm8;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.201.26 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C/WrZJsRK+gdowTxEay9P8kVk/vgtaICScliXf96QBsmQUhLzNZNAYtr00bX/xERicNUJfNjla2ucTqyUpp7hg8MWWDJFaN3/0TwGCQKggbiGoR8u4nr+AnH3Fim3bLZHPMjOsZPscGVjfqze7IPSzbzggnmDj3Ibt+RNWFuTPYSIL01X2KIfTO8bq4LXGO7YYMrC0fz+IqCaYljzaYB1S+NJ7VmngFePlVx5aBuFu88J7QGJMpmZIyrQ27yNR70dyVnxhLfzVCA8oj5za400VszjPKMGU/iOrxHFJbw+8aJeZH0X1qC83eTrpAsbpUTTUmvjsjZGG6L4KwvI+V6CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=weLzfpnElnyzpxv8CmJGmECpkheneUSTeKQEr1RuzJc=;
 b=hlprrjGtbQw2xPcrsMlGfM2YOmW6IxzX9fLtS8qs+neultlxcyrUV7Kkegvk8APsMQF0N1ZpGMZQdrOV525sHGSfVCL5yqhzJc5OqYtPhreYtj0TxHw7ErrnYKDzAxEYAP/dqeFajG/x2rvkTHf9dv2im+Z92a2ACFfgqW7owMfd96tCP+pwGgrZgOIW99WQTP0OjNcldeVroDQbnbYH3S0jVl5ruQLIoCiPNslpSUK52OknLA/+aMA2sfO6I/zq76SbTfQfRdEBi6QpOJd2tmk8RwvC2HLB8VCcISNsYTmTFBdqgMLv+xohLtXZFwDtYJ9g714GXC+LUz32OBwPjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=weLzfpnElnyzpxv8CmJGmECpkheneUSTeKQEr1RuzJc=;
 b=F8IkJfm81HqcJ1NG0lN5zw/s7A2FP3wj/5kDIUKuhtPCRAMQeIxCQNQb4NMPB8UnQI3vF0Nqopn9spsL4qtEYEkHvmvFFNx05MHmIPwQaC7QgJY3w51edK/O4wBMcwZm+FcWZGssfkTfs154sdIFZKS/Sun5JOV5SgZH/FvorsVQynXzdYTauKsHzOUCE4Eh0GThZIkt3gVUIGXxgZJZFphLzQkPyiG/uWa0AYSf9M1qUIS9OpcMC40n6EQUBBkusKJIH++0mi7WlV/4yeUyKXegRWU3zsEdFk/lk/3CKR/XjkQS+939C5MehXHUMEWXRNtTHeoKTpw80uf4TEBkIg==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by DS4PR12MB9684.namprd12.prod.outlook.com (2603:10b6:8:281::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 16 Sep
 2025 12:22:20 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9115.018; Tue, 16 Sep 2025
 12:22:19 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: damon@lists.linux.dev,
	dri-devel@lists.freedesktop.org,
	Balbir Singh <balbirs@nvidia.com>,
	David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Ralph Campbell <rcampbell@nvidia.com>,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: [v6 12/15] selftests/mm/hmm-tests: new tests for zone device THP migration
Date: Tue, 16 Sep 2025 22:21:25 +1000
Message-ID: <20250916122128.2098535-13-balbirs@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250916122128.2098535-1-balbirs@nvidia.com>
References: <20250916122128.2098535-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR01CA0051.prod.exchangelabs.com (2603:10b6:a03:94::28)
 To PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|DS4PR12MB9684:EE_
X-MS-Office365-Filtering-Correlation-Id: b6feed8b-1cad-4815-4321-08ddf51bae56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|10070799003|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VUFETndabU5BL1BVUEdxcjdKR3hUMWZHWWZvZUlZQ3BGQTM5bE1JcVlsOGNR?=
 =?utf-8?B?akNKMGZXeW1rZjlVcHJUYjZCeTZEUWRpNDRORWRHNVNoNkE4OHdpa3pZd3hC?=
 =?utf-8?B?M3pzVDdJTFEzMjRMTkxRemFBeGxGS1RRS3NacUdOb2lmNkRmNnpnb3lDQlkv?=
 =?utf-8?B?OTZISXllNkFROW5zNVRGYWJxNzB4dEYxSUpOSE51em56WWIvOHNqbmZUUnhw?=
 =?utf-8?B?dlpUNU52TGwxNTIvTkdZSkZFdmU3alQ3cVgrR2FqTEFxOWR6QmhRVW5vLzg4?=
 =?utf-8?B?eUN6U0JDOHVKYkZkdFArM1U5SzlMdjJnNVl1dDlacU5vc1VLZnk1bDFzbDZm?=
 =?utf-8?B?THM4WjFUTXRydjNoRW9NbVFQUGZpa3ZCT3pkM2dpS0V3RktTellQVWlGTTZY?=
 =?utf-8?B?TlVXQjFoem1lSW1VYjJydXVCU01KK1VVVUlDVm5aQlVKZEdqOUVsWXZXMFdE?=
 =?utf-8?B?NmNxVFlWK2prR2VLWVhzb2hjdW05SHFJZ3IxYnZYS1ZkRSs2Uk1Edi9iM1pv?=
 =?utf-8?B?QldJOFU0anpJTnpWa09GOHR2d2NXMWZtSTVDNytZMXhqZURYV0hhZlRRNFMw?=
 =?utf-8?B?aHJiY1JNVlY1d1JtQ3RFbnFQQkNCam9KcGNMS3p3UGllZlVlakx2SFF2a0xZ?=
 =?utf-8?B?R2Q2WFdnKzUxMEdDbjRRa05GVGZ3NzFJRmVpZldzZ3haaFVRMHVuNnZadENK?=
 =?utf-8?B?ZkppMzZCVUovdHltdGRKeXdRRWp4TGZLNHA1S1Vhb2hmaDJ5THRyMzZoWVJp?=
 =?utf-8?B?S2RHMktFL1FWb3VlSFMwS1BheXVzYzNzcGwzMEp1Rm50U1orV2pMaHhGamtO?=
 =?utf-8?B?MnZGbm0wWCtnQ0lsUEFheW5jaGNNUVk5WGhybDNvbXpZemFQN0h5bmlueWtr?=
 =?utf-8?B?M3BSOXhTSXFlZitqNFNVcldTY3BpaWIxVDYwMkNITUpWaENpNkVvaHpSdFRB?=
 =?utf-8?B?bk4zZHE4eFdKSXUyekp4Nk9xcHhJZFlDeTJ0ZUdlSjFyNW1GS21oL1pNQm9Z?=
 =?utf-8?B?VkRuMXlselZoTUtGSUtERUZyMmgrNXlsTUFpTGVpaFRoZExQRXNmVUprT2tU?=
 =?utf-8?B?bHRtUTNRTEpSYnVvVnFvV1F3S0V2a0lPV3pDOEx4ajZ6Wlp2d2xVV3RVZ1Ru?=
 =?utf-8?B?Y3JVaWd4NUJHcjFKSG8zSDNyeUNPQi9KVGh4Nk9QY250UENNMUNQSW1iY3RD?=
 =?utf-8?B?WXZWbnNtQjJmcm9sTnAwYlhWaXM2TVNIUnl2UlhZbzNNMmJTUHpVN0o0elp2?=
 =?utf-8?B?QS9xSjhlVE80ck8wZFpzdUJXekYyUndTdko5cWRvTHNMYWUvNEg1bFZVZmRL?=
 =?utf-8?B?MklqRUpqVHRpeVIwc3krSnhJTWZHVmJXb0U3d3U1UFRvQ0ZuaU50cGQ0ZEl5?=
 =?utf-8?B?eUlrYnV3dXJZRS81U0FnNEZ6RUNuRlN5aWFGd3psdXB0VzhESDN3b21waU0w?=
 =?utf-8?B?aFk5QzFsSnlsd296L0x1dm9SNHFCcDZrSzZNTGhXbStqUk92czNVcnlhemNm?=
 =?utf-8?B?UlRFRlBlQkJ1WHNtZHUwRWxtZFQ3WkJGbkMySlp6WlJYRjZmM0dDZm9pbVhN?=
 =?utf-8?B?T05oRjY5STdTR092NDkrSmIvUHYwWGpRK25yeGFxQzlFSFJhUzI5OVdZeGVm?=
 =?utf-8?B?Tzh0QW9RaTVwTitxd2ZlcVNMNWlvWDJZQkpQemFkeG14cmNqZEZ2azQ2VTRD?=
 =?utf-8?B?K1F6N0lITzdlVzN5VkJDYTNqSGd5V3F6NERnUnYxTG1LSUpOYm9JMG1xY3ly?=
 =?utf-8?B?UTZrc0pFTWJxSitZNWRva3h4NWYrMGI2Y2tzV1JRSXh6czd1Y3V1S1c3SjZC?=
 =?utf-8?B?MHpWNTJyTG1MMmljbVJwQ1pIcVhMMTBpYjRRc2VzS3JnZFBLNURQV1JRYUtK?=
 =?utf-8?B?YkNWaFNwWHFaeHVtSUFFdEZLM3BIeXgrMnM3enNzcjVhN3c9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(10070799003)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UVhsSlNzeS9weURaa3I5SjkyU1RaTlJNR2UyWW50eGRjK0FMNDI3aWRtM0Ja?=
 =?utf-8?B?a3JYU2E2OHhmd3ZJWGxpTHN2elBpQm5PdzZNVmo2VnBMbFZPR3FqVnIvallN?=
 =?utf-8?B?azRRVDR2OVVKNTQ3SmwrN3pNSDljY1IxZ3BDOXZiQ2k1RXA2NDdVcVdvd2wy?=
 =?utf-8?B?bjl6Q2ZqeEZWVFU3YkV4aDFDZlJZL2VFUUF6M0RIMXlJQnRmVGFjaWk1V3cr?=
 =?utf-8?B?NklwVjVqWFpZcmxjZld3NWdubEJVK1dkZkdETE9tSmQzT1VrTUxJQjdyZkxo?=
 =?utf-8?B?TkRmam5mcGd5TmRCY3F3WmY0RWRHbmJuMklYajVjVGhEVG92b1YvNjVNMUEw?=
 =?utf-8?B?a25WZVhMUnpYbDhiL25vUlFUMzFaZmFtZE1VQkw0RjAxaGdocGsvMk1xM1pC?=
 =?utf-8?B?VTNlYmQ4NE9DMkNtcFlEM1Z5SWc2UDlaNlllMGdzMjAyVnE2eS9ZSGFHMFYr?=
 =?utf-8?B?RzRFUk8ydk9OZ3I4cCtaMmpIVmsvRnRrdkZ2dkM2WVpkUWIvTzZQa3BtY1B6?=
 =?utf-8?B?bDlwZytpLzY4Wm5lWnYyRzRNZ1diWko0bU42dWJjZXU1VFBrYi9zUUw4Wjln?=
 =?utf-8?B?RDVtQ2RtSVNQd0l0cDc3NjRiQ2lmOFRTOW5MU3lESWxTZjFXZk9FZTdaUXVF?=
 =?utf-8?B?eGRrVzlBWTFQd3NzL29vOWJ0ckwrRnAxSU9JaUd5cTBrRDhvOEk0VzY3VUE2?=
 =?utf-8?B?dXdDUFJ1YVlMMG9yVTFkV0VEeEJqWDdiY3JkZ05FSjJPMndYZ2N1aFlLUTcr?=
 =?utf-8?B?c2YvY05UUzVMYWRBZGVtc3RWN1BYSkhuTEdXOEZxNCtUVHlqUmFOanlLSmRu?=
 =?utf-8?B?MmlFQ2dES0VENSt2bnZRSjJIMURySTNGN3prMXpnRm5xMWhOL0hLeFVFMW5y?=
 =?utf-8?B?NVArNVRQTEpjeWd3WlA4VlIrRC9wY3FPR0ZzUXVBcmc4ZGc2TFUrNHlYNW1j?=
 =?utf-8?B?UmYzSm82ZHJmemNHVlpEdHFHTzdmZm42WlA1OVhId1dqT3R5ejZGUU9TZUx0?=
 =?utf-8?B?WFRIejh2Z21nM3VyQ1ZKUTRYdlNhRUxuZEZya3NyeHg0bDdHVFpia09jSDVi?=
 =?utf-8?B?eGpSN2FxSUI4YWtaNURFcXFmdHQvSkhTb1Y5QTRmTjlUclQ4S1Bkakg4eXpv?=
 =?utf-8?B?VzhLYjhycDJackhKcGtEaHk2YVFzTXh0ZDgxQmpQY0tOK3F3YkN5UDM3dXN3?=
 =?utf-8?B?bFpxN2g2NkpEKzhydnJCTVFxbFBxSk1vRW9DWGE1N0h2ZHFNNzBnYXFCcExv?=
 =?utf-8?B?OEdRTnNzL1k1T0MySVhhYWxxNmVhcDcxQ2F2SFQzbzYwM0ZoaklOdDBUaGpL?=
 =?utf-8?B?dDFwbEcydFlPV2RGUXMxRkxyS29zNTY3Yi85MGlmSW5RZytPRTlJS25MVXRY?=
 =?utf-8?B?dWt3YzBwb0VWMG5TRzBqZ09CdXo5bE0vcnNlVTdpQm4wSWsyWTVvbWFUZUVR?=
 =?utf-8?B?MER1NEtaQjQ0cDAxdHBCNHUxTUt6OCtzbnozY01OMHRkeWNOZW5FUGQ2Y2JY?=
 =?utf-8?B?ckZXSlVsVEpJTnNQYnQ2OE1ZYUgvR1dFUHZkRDdPV1hBemFyM1ZrSHF0WjdJ?=
 =?utf-8?B?STN5SEFxS2E0ZERDRXJsMFFHa0UxbWdnaU9EUko5cFVEeEhmYVNzbGtMY2cv?=
 =?utf-8?B?bzdYTXVtRmdzYVV3NmN5em4rdVNpWUtBbEk4R0pDZDJZYnJmVzlqTllZSFZa?=
 =?utf-8?B?bS9rQ2VBYWJHTFVwV3hvTWwvbVZXdm5DZExsYnVlYm1GeGI3WldoSmoyNmh5?=
 =?utf-8?B?VzlGcHEzNGlhUWpwTVpEN2pFTFZmUzMyL012VlJrK1cvZUxBcXlnSWpXM2Ix?=
 =?utf-8?B?VEI3SDl0QnFkWkhIMHAvR0ltc3NwL3I2QlMzNk8rOFdmVVZORTF1eHJFK1M3?=
 =?utf-8?B?c1Y0Tm1tS0oyWjZxUmRhWDFBOHpEMmx5Qk9BRERZODgxcjhUZitISjVDK0hF?=
 =?utf-8?B?VitHYzlDS3RhZzlPVnVEYVZwVGRHMU1zOTR0ZlN2SmxwL2VyUDMxck9zenYz?=
 =?utf-8?B?VVN2dnFSeWltVnVjNkV4b2lBK0ZmQ0NCT05PeXE5OVVjOGxxL01Ma0dRY3Zz?=
 =?utf-8?B?TXV3Qzh0M3JTMnFzMzRkZDhRa1B1MmlnOXBkWStwSTRoc2R6UDdnK0pLU3F1?=
 =?utf-8?B?WXVJT2d1bE9pL1VoeHFrZTdZMkNXeGF6cnh5KzBTZFZJMEpoSEJvUFFoUDd3?=
 =?utf-8?B?WHc9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6feed8b-1cad-4815-4321-08ddf51bae56
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 12:22:19.7270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hui7vsCMnV5y/iX/w1fxtC98TVmE6GzkE9glSAIQENYXCkIL8kJxg9Pv+K+kxqRIBR7Ijaqkm12zyOROL3SAmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9684
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 462E3C000F
X-Stat-Signature: a4nfk61x6sya7yj41cmxxwpr7h4qyqe1
X-Rspam-User: 
X-HE-Tag: 1758025444-903013
X-HE-Meta: U2FsdGVkX197aLZ/KsR9DK2u5n0HOV/YmnrAyS5zDXiM8lihdd0i2Ba9vRGlYluc1Ul3Ke575x3BBrz/qM2fVNnKLkgBMUvnw0MAueeXYh6iqMsTgpy6RkEEDuk5MXLbG6mei8DrPPOWCZfbYvQwgArpt0+l0JH/s7Z4c+NoHWQcd/xRndfncBhqnCDBFkgYnkClqki04ChTAGE1P/vSQMC1tAnUG4FMqSOmWgd0lnT8gyWF4XX9aG0HqgxJjuAQr1otbHMIwePjuWeJNb0HmG+/tVW4HoE3YkOTkmuPDpF+hcr2uscRLh/GqBeqYnAPMB9cUAfI9Z5MlsejaK9twNtQSY3P3cxAa9rhpJLjElgmGsQG1/QabZhfQYrHvDps5pAf916YsGE1Hfn3uKjMXgo2Cm3v2SWaWPTD37yA5FDUdgKnhKDnmc8M0rMrdHI8XExzeSsawKor4AW3pdZGdCeiQeZifdUwqzAanDbxgY5ZbmY8s2Ol6vypvHvCyQKjzljndvxIMpZ1PMxz8LCrX6UdIfaWP4z+uU7poUbFl+bXzlIgYH4F7JrKjFiQLBZjSnf8gdR7HBI5kZ159Ajdlgo4LEHyWnQQf+buewh29cXrKpFuD3iDXRoUMiz0J6uJnHC5doAp6jXEceEwpYyRJJzNf3UfW00fLTTDSKdP6/rNMv6Olpj+MKtEadHrB+HYMTLPWKsoC6Y+7BA1Fvit7Z4+jTycVNAHQ9rgSJ6N+suMWNEGiYI0BqF6HlPqMPbhUAYMqkDo5DEBrMeWywZwmzPu+6j4kfAA+7RNjh1xsw1IXzybwzvd5xPTilKh/WqTJy6bclBPpmzwlXosInKFFkWZM/5QNDl/tV+2Da1uj1tBz+MoRqlWytzGof+Vpi5nuFQREbOEOny1IN1xN0adxhWWYTcrKVm4YXuJHkkL1bXtZ0Af8AOzLHW+EbMfa+H1gyyNUwC9JpA0/80DAld
 CeqZkVOc
 7RhxyaozKXfHmu+nAvLVP5jqmjxPq8G9707ZhlyM5O86EdAyH/lo3Omb2BY8SQZSXCc8nv59Ucvsu+s3lys+hLrXYyllCMR4tGzUmj6bJOpSKYS740eCc7mytXOZ7bCyar27WAsc+BX9svuBVR8UzqooBRi9Ua+KcePJn6ZAGezIhpAlCztIWU1TP1zTrEhpRNPOk/zjtdK/K7n+y0o6iUOZUeZU9bpej51Pqg3Ew5sTUb9BA+StDqCmFFGFuxzY+C0+dRQcmCazC8UXHDxCHxH/J1xzF2Jvbwy9HL2UClX1SuOCeE6BW8gGW2XaEkagP6N3PiXxlIGOD6H0MTHqMUxRKG6Xy2Zl3r3w6caTVeRigyKaKLMZekDdL79H0tBGh/vAvJG+qyAeYt6xnDGbPZ4cEFJKxz5X9E9oZqCYZ0YlgwubYLRaw/t53RDGvUyiL8ULKSlSQ/c0wXhh7f6v8nyDgiFBQeUkpaLbgym0QuO64i4Z/YW2h8mgK8bGL2NvhH6FAxw+IViMebvTEfQRcbdgo5vKPFmQPs+lzrt/5OJiOgtLya/lOFA5Z3UzqtEnkpt2RyAeCY9uNXGoD71fqrgUYVNqyAVWRNteRcYKU0IhF7arbNHoFEafVB4PlJPzke2YwRugGgNqYFmvNQm5erIU4dr1ZWMB311eH7XHHnAF5THgPPp56QgQPw8wMZWnd+4LAMLHByCSZLLGTLTtchABZBMU9CGsVBZKMqujh6uGOHmntRCeIn/rX4Mt9NyFSvZYUqSJlvyWV/W3Bc7Hdq1ZjvrEswRX8poy0iQ5TueohjceNiE6QmC03jpbZ+Wmza6hp37TfKAtLEPWIMpKmSWI14MfcEejOioD79T+qINeKANtsPCHJ1kiL8+Fh2gr8DDPp9V4RA5KMZtgteUS5DE83bG+561WQn2G3P5OiAby+iicw9lkRa4rnpXm0/3OUtlGuGiZGlnBHoAxt50oPko2a02ly
 HDEqymYj
 jaUQRFb04e27blVhKddKd3GRlOl/z6rSBvSbg9hsks0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add new tests for migrating anon THP pages, including anon_huge,
anon_huge_zero and error cases involving forced splitting of pages during
migration.

Signed-off-by: Balbir Singh <balbirs@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Francois Dugast <francois.dugast@intel.com>
---
 tools/testing/selftests/mm/hmm-tests.c | 410 +++++++++++++++++++++++++
 1 file changed, 410 insertions(+)

diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index 15aadaf24a66..339a90183930 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -2055,4 +2055,414 @@ TEST_F(hmm, hmm_cow_in_device)
 
 	hmm_buffer_free(buffer);
 }
+
+/*
+ * Migrate private anonymous huge empty page.
+ */
+TEST_F(hmm, migrate_anon_huge_empty)
+{
+	struct hmm_buffer *buffer;
+	unsigned long npages;
+	unsigned long size;
+	unsigned long i;
+	void *old_ptr;
+	void *map;
+	int *ptr;
+	int ret;
+
+	size = TWOMEG;
+
+	buffer = malloc(sizeof(*buffer));
+	ASSERT_NE(buffer, NULL);
+
+	buffer->fd = -1;
+	buffer->size = 2 * size;
+	buffer->mirror = malloc(size);
+	ASSERT_NE(buffer->mirror, NULL);
+	memset(buffer->mirror, 0xFF, size);
+
+	buffer->ptr = mmap(NULL, 2 * size,
+			   PROT_READ,
+			   MAP_PRIVATE | MAP_ANONYMOUS,
+			   buffer->fd, 0);
+	ASSERT_NE(buffer->ptr, MAP_FAILED);
+
+	npages = size >> self->page_shift;
+	map = (void *)ALIGN((uintptr_t)buffer->ptr, size);
+	ret = madvise(map, size, MADV_HUGEPAGE);
+	ASSERT_EQ(ret, 0);
+	old_ptr = buffer->ptr;
+	buffer->ptr = map;
+
+	/* Migrate memory to device. */
+	ret = hmm_migrate_sys_to_dev(self->fd, buffer, npages);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(buffer->cpages, npages);
+
+	/* Check what the device read. */
+	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
+		ASSERT_EQ(ptr[i], 0);
+
+	buffer->ptr = old_ptr;
+	hmm_buffer_free(buffer);
+}
+
+/*
+ * Migrate private anonymous huge zero page.
+ */
+TEST_F(hmm, migrate_anon_huge_zero)
+{
+	struct hmm_buffer *buffer;
+	unsigned long npages;
+	unsigned long size;
+	unsigned long i;
+	void *old_ptr;
+	void *map;
+	int *ptr;
+	int ret;
+	int val;
+
+	size = TWOMEG;
+
+	buffer = malloc(sizeof(*buffer));
+	ASSERT_NE(buffer, NULL);
+
+	buffer->fd = -1;
+	buffer->size = 2 * size;
+	buffer->mirror = malloc(size);
+	ASSERT_NE(buffer->mirror, NULL);
+	memset(buffer->mirror, 0xFF, size);
+
+	buffer->ptr = mmap(NULL, 2 * size,
+			   PROT_READ,
+			   MAP_PRIVATE | MAP_ANONYMOUS,
+			   buffer->fd, 0);
+	ASSERT_NE(buffer->ptr, MAP_FAILED);
+
+	npages = size >> self->page_shift;
+	map = (void *)ALIGN((uintptr_t)buffer->ptr, size);
+	ret = madvise(map, size, MADV_HUGEPAGE);
+	ASSERT_EQ(ret, 0);
+	old_ptr = buffer->ptr;
+	buffer->ptr = map;
+
+	/* Initialize a read-only zero huge page. */
+	val = *(int *)buffer->ptr;
+	ASSERT_EQ(val, 0);
+
+	/* Migrate memory to device. */
+	ret = hmm_migrate_sys_to_dev(self->fd, buffer, npages);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(buffer->cpages, npages);
+
+	/* Check what the device read. */
+	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
+		ASSERT_EQ(ptr[i], 0);
+
+	/* Fault pages back to system memory and check them. */
+	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i) {
+		ASSERT_EQ(ptr[i], 0);
+		/* If it asserts once, it probably will 500,000 times */
+		if (ptr[i] != 0)
+			break;
+	}
+
+	buffer->ptr = old_ptr;
+	hmm_buffer_free(buffer);
+}
+
+/*
+ * Migrate private anonymous huge page and free.
+ */
+TEST_F(hmm, migrate_anon_huge_free)
+{
+	struct hmm_buffer *buffer;
+	unsigned long npages;
+	unsigned long size;
+	unsigned long i;
+	void *old_ptr;
+	void *map;
+	int *ptr;
+	int ret;
+
+	size = TWOMEG;
+
+	buffer = malloc(sizeof(*buffer));
+	ASSERT_NE(buffer, NULL);
+
+	buffer->fd = -1;
+	buffer->size = 2 * size;
+	buffer->mirror = malloc(size);
+	ASSERT_NE(buffer->mirror, NULL);
+	memset(buffer->mirror, 0xFF, size);
+
+	buffer->ptr = mmap(NULL, 2 * size,
+			   PROT_READ | PROT_WRITE,
+			   MAP_PRIVATE | MAP_ANONYMOUS,
+			   buffer->fd, 0);
+	ASSERT_NE(buffer->ptr, MAP_FAILED);
+
+	npages = size >> self->page_shift;
+	map = (void *)ALIGN((uintptr_t)buffer->ptr, size);
+	ret = madvise(map, size, MADV_HUGEPAGE);
+	ASSERT_EQ(ret, 0);
+	old_ptr = buffer->ptr;
+	buffer->ptr = map;
+
+	/* Initialize buffer in system memory. */
+	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ptr[i] = i;
+
+	/* Migrate memory to device. */
+	ret = hmm_migrate_sys_to_dev(self->fd, buffer, npages);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(buffer->cpages, npages);
+
+	/* Check what the device read. */
+	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
+		ASSERT_EQ(ptr[i], i);
+
+	/* Try freeing it. */
+	ret = madvise(map, size, MADV_FREE);
+	ASSERT_EQ(ret, 0);
+
+	buffer->ptr = old_ptr;
+	hmm_buffer_free(buffer);
+}
+
+/*
+ * Migrate private anonymous huge page and fault back to sysmem.
+ */
+TEST_F(hmm, migrate_anon_huge_fault)
+{
+	struct hmm_buffer *buffer;
+	unsigned long npages;
+	unsigned long size;
+	unsigned long i;
+	void *old_ptr;
+	void *map;
+	int *ptr;
+	int ret;
+
+	size = TWOMEG;
+
+	buffer = malloc(sizeof(*buffer));
+	ASSERT_NE(buffer, NULL);
+
+	buffer->fd = -1;
+	buffer->size = 2 * size;
+	buffer->mirror = malloc(size);
+	ASSERT_NE(buffer->mirror, NULL);
+	memset(buffer->mirror, 0xFF, size);
+
+	buffer->ptr = mmap(NULL, 2 * size,
+			   PROT_READ | PROT_WRITE,
+			   MAP_PRIVATE | MAP_ANONYMOUS,
+			   buffer->fd, 0);
+	ASSERT_NE(buffer->ptr, MAP_FAILED);
+
+	npages = size >> self->page_shift;
+	map = (void *)ALIGN((uintptr_t)buffer->ptr, size);
+	ret = madvise(map, size, MADV_HUGEPAGE);
+	ASSERT_EQ(ret, 0);
+	old_ptr = buffer->ptr;
+	buffer->ptr = map;
+
+	/* Initialize buffer in system memory. */
+	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ptr[i] = i;
+
+	/* Migrate memory to device. */
+	ret = hmm_migrate_sys_to_dev(self->fd, buffer, npages);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(buffer->cpages, npages);
+
+	/* Check what the device read. */
+	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
+		ASSERT_EQ(ptr[i], i);
+
+	/* Fault pages back to system memory and check them. */
+	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ASSERT_EQ(ptr[i], i);
+
+	buffer->ptr = old_ptr;
+	hmm_buffer_free(buffer);
+}
+
+/*
+ * Migrate private anonymous huge page with allocation errors.
+ */
+TEST_F(hmm, migrate_anon_huge_err)
+{
+	struct hmm_buffer *buffer;
+	unsigned long npages;
+	unsigned long size;
+	unsigned long i;
+	void *old_ptr;
+	void *map;
+	int *ptr;
+	int ret;
+
+	size = TWOMEG;
+
+	buffer = malloc(sizeof(*buffer));
+	ASSERT_NE(buffer, NULL);
+
+	buffer->fd = -1;
+	buffer->size = 2 * size;
+	buffer->mirror = malloc(2 * size);
+	ASSERT_NE(buffer->mirror, NULL);
+	memset(buffer->mirror, 0xFF, 2 * size);
+
+	old_ptr = mmap(NULL, 2 * size, PROT_READ | PROT_WRITE,
+			MAP_PRIVATE | MAP_ANONYMOUS, buffer->fd, 0);
+	ASSERT_NE(old_ptr, MAP_FAILED);
+
+	npages = size >> self->page_shift;
+	map = (void *)ALIGN((uintptr_t)old_ptr, size);
+	ret = madvise(map, size, MADV_HUGEPAGE);
+	ASSERT_EQ(ret, 0);
+	buffer->ptr = map;
+
+	/* Initialize buffer in system memory. */
+	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ptr[i] = i;
+
+	/* Migrate memory to device but force a THP allocation error. */
+	ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_FLAGS, buffer,
+			      HMM_DMIRROR_FLAG_FAIL_ALLOC);
+	ASSERT_EQ(ret, 0);
+	ret = hmm_migrate_sys_to_dev(self->fd, buffer, npages);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(buffer->cpages, npages);
+
+	/* Check what the device read. */
+	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i) {
+		ASSERT_EQ(ptr[i], i);
+		if (ptr[i] != i)
+			break;
+	}
+
+	/* Try faulting back a single (PAGE_SIZE) page. */
+	ptr = buffer->ptr;
+	ASSERT_EQ(ptr[2048], 2048);
+
+	/* unmap and remap the region to reset things. */
+	ret = munmap(old_ptr, 2 * size);
+	ASSERT_EQ(ret, 0);
+	old_ptr = mmap(NULL, 2 * size, PROT_READ | PROT_WRITE,
+			MAP_PRIVATE | MAP_ANONYMOUS, buffer->fd, 0);
+	ASSERT_NE(old_ptr, MAP_FAILED);
+	map = (void *)ALIGN((uintptr_t)old_ptr, size);
+	ret = madvise(map, size, MADV_HUGEPAGE);
+	ASSERT_EQ(ret, 0);
+	buffer->ptr = map;
+
+	/* Initialize buffer in system memory. */
+	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ptr[i] = i;
+
+	/* Migrate THP to device. */
+	ret = hmm_migrate_sys_to_dev(self->fd, buffer, npages);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(buffer->cpages, npages);
+
+	/*
+	 * Force an allocation error when faulting back a THP resident in the
+	 * device.
+	 */
+	ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_FLAGS, buffer,
+			      HMM_DMIRROR_FLAG_FAIL_ALLOC);
+	ASSERT_EQ(ret, 0);
+
+	ret = hmm_migrate_dev_to_sys(self->fd, buffer, npages);
+	ASSERT_EQ(ret, 0);
+	ptr = buffer->ptr;
+	ASSERT_EQ(ptr[2048], 2048);
+
+	buffer->ptr = old_ptr;
+	hmm_buffer_free(buffer);
+}
+
+/*
+ * Migrate private anonymous huge zero page with allocation errors.
+ */
+TEST_F(hmm, migrate_anon_huge_zero_err)
+{
+	struct hmm_buffer *buffer;
+	unsigned long npages;
+	unsigned long size;
+	unsigned long i;
+	void *old_ptr;
+	void *map;
+	int *ptr;
+	int ret;
+
+	size = TWOMEG;
+
+	buffer = malloc(sizeof(*buffer));
+	ASSERT_NE(buffer, NULL);
+
+	buffer->fd = -1;
+	buffer->size = 2 * size;
+	buffer->mirror = malloc(2 * size);
+	ASSERT_NE(buffer->mirror, NULL);
+	memset(buffer->mirror, 0xFF, 2 * size);
+
+	old_ptr = mmap(NULL, 2 * size, PROT_READ,
+			MAP_PRIVATE | MAP_ANONYMOUS, buffer->fd, 0);
+	ASSERT_NE(old_ptr, MAP_FAILED);
+
+	npages = size >> self->page_shift;
+	map = (void *)ALIGN((uintptr_t)old_ptr, size);
+	ret = madvise(map, size, MADV_HUGEPAGE);
+	ASSERT_EQ(ret, 0);
+	buffer->ptr = map;
+
+	/* Migrate memory to device but force a THP allocation error. */
+	ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_FLAGS, buffer,
+			      HMM_DMIRROR_FLAG_FAIL_ALLOC);
+	ASSERT_EQ(ret, 0);
+	ret = hmm_migrate_sys_to_dev(self->fd, buffer, npages);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(buffer->cpages, npages);
+
+	/* Check what the device read. */
+	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
+		ASSERT_EQ(ptr[i], 0);
+
+	/* Try faulting back a single (PAGE_SIZE) page. */
+	ptr = buffer->ptr;
+	ASSERT_EQ(ptr[2048], 0);
+
+	/* unmap and remap the region to reset things. */
+	ret = munmap(old_ptr, 2 * size);
+	ASSERT_EQ(ret, 0);
+	old_ptr = mmap(NULL, 2 * size, PROT_READ,
+			MAP_PRIVATE | MAP_ANONYMOUS, buffer->fd, 0);
+	ASSERT_NE(old_ptr, MAP_FAILED);
+	map = (void *)ALIGN((uintptr_t)old_ptr, size);
+	ret = madvise(map, size, MADV_HUGEPAGE);
+	ASSERT_EQ(ret, 0);
+	buffer->ptr = map;
+
+	/* Initialize buffer in system memory (zero THP page). */
+	ret = ptr[0];
+	ASSERT_EQ(ret, 0);
+
+	/* Migrate memory to device but force a THP allocation error. */
+	ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_FLAGS, buffer,
+			      HMM_DMIRROR_FLAG_FAIL_ALLOC);
+	ASSERT_EQ(ret, 0);
+	ret = hmm_migrate_sys_to_dev(self->fd, buffer, npages);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(buffer->cpages, npages);
+
+	/* Fault the device memory back and check it. */
+	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ASSERT_EQ(ptr[i], 0);
+
+	buffer->ptr = old_ptr;
+	hmm_buffer_free(buffer);
+}
 TEST_HARNESS_MAIN
-- 
2.50.1


