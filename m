Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D70FEE3698
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 17:34:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A354B6B0088; Thu, 12 Feb 2026 12:34:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F6256B0089; Thu, 12 Feb 2026 12:34:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A3D46B008A; Thu, 12 Feb 2026 12:34:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7808D6B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:34:30 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3D412140242
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 17:34:30 +0000 (UTC)
X-FDA: 84436503900.06.E65064B
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011018.outbound.protection.outlook.com [40.93.194.18])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5FB302000A
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 17:34:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dmwnr3eI;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.18 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770917667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=thS4WlW6GPETfMOnsJvwhgtI7vmBjb2jMvOncu0LLGY=;
	b=nG5ubGLqC+DO8Ah3Li9XXUhtTERZ7HZ1xyLv9DbnY1skUoifdfyri+XuegvFz3pZrUj01J
	Ojd+TV53nFXkQNtvxCYKXLVbQ/0kA/n3E+PPe9aE90VCD/gjF1hjw2SS4qRnuitzuHqAZ3
	u/i9fo/jkGv1vK4q9cj5XmaFXD0c/UE=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dmwnr3eI;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.18 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770917667; a=rsa-sha256;
	cv=pass;
	b=UeLvhb5wovCMOzLHN4uwU4lAPrr4zrcs7k4X0cjMT6cjHAwVT2TEt0aJk956sXdSZu4pco
	LrEECYAlNounny1vK9rSwVhlEHrG28pvFwCNaTtPGF5VVhgu6EmYErCoSqCod1EcmknVTN
	RrAcE8QDWzUEKHCAhx4iZ8TfHRNDM74=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fsnlmzY65JyzSt8yeZTqjtNbxtDL1QGGSriiDssWdd+IT4UkVpxnba8i44rKB+ma/TifNoSUVromiDAf1H9Zda1cIUP72I670u1l+OerJWsMVfujdoPmmjOn5dICEae2BgG6ZdkJaaNs2dVnYDSqNv28H7mg9R/OqpaEFttJiKexCg9vZRXC7AFDrpREsg0aO+I2cTxEJYgpHc/8WETkZPHhZ4p5tCSfdykoiCoXEBd1F8Z7j875qOagMGlE/iH9Jx+NSX0XRGVo0uHQE26Dx7g9vXiCVR/OpyN5sDR9dUZMIOxRuodEJ7oL5y6VUdUnYTtwsJAtA1OGWyAj5R6hDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=thS4WlW6GPETfMOnsJvwhgtI7vmBjb2jMvOncu0LLGY=;
 b=hjJs/rTvmI9nNKqKRerDPsHgtkjtMRdqZHeLHL+jeHZEgJBYQPN3vhqq1NKIvLjfqOOfvJSK5aV2a3KLKXZjR5kdS3+Q/TT1fyk2D+8fXe7N+KuXvOXHEtPS8MKcWd5VHat+cbJ5KiT6+FBLVqrHXzb92LbWXHPdb/O9Ob6hn+UdA4izALerav3wOBin1lLQD4+pOc39Vl6gNERedzMRsfxSLQQv1aAS3mWG79EHpeaCd9L3TwoHqBXI6aN0zxxXLnIZzUEdl+rixUK/EUu8nXTsAzvBuQimTrWAGo7KPj5KCVffdBfDUSNyE7IrMbb1CMcH7Fkwm3WyG/CkO21W/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=thS4WlW6GPETfMOnsJvwhgtI7vmBjb2jMvOncu0LLGY=;
 b=dmwnr3eIm9WtbhxEIiDMElC0tefhpEbgXBCQa2UwAIygH2TEKemVRq2fVPXgD0/a7ChWmGnplmMOMMB/v7TG56VSHrf+lV8/5JJhN0C9yZ2Tp9WiF1jXvErohpjFX1TF0mze8VwM2WHN1rp75/xTu38/yxBEoXuEX5nyPbX35ZGtisHVDmyXKFEkdagyRmO8BYXhdKrClEWWVesuuMWsorNXeFCe0YMpuQGjCs++ChZYhH9MEe2GOakCjvlYYDSvE5NLyc1LY0hGJ2e/ymSSiN0W+nFxv4yN6YDIwV9mp94fGZtp0gjtCOfpOKKt0xmOXYMn8+y7oAtTffsdTEyUtg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS2PR12MB9613.namprd12.prod.outlook.com (2603:10b6:8:276::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9611.10; Thu, 12 Feb 2026 17:34:16 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9611.008; Thu, 12 Feb 2026
 17:34:16 +0000
From: Zi Yan <ziy@nvidia.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
 gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jackmanb@google.com,
 jack@suse.cz, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, lance.yang@linux.dev, Liam.Howlett@oracle.com,
 lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v1 5/5] mm/khugepaged: unify khugepaged and
 madv_collapse with collapse_single_pmd()
Date: Thu, 12 Feb 2026 12:34:07 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <40C75C7A-6362-4879-B414-493CC476C6D3@nvidia.com>
In-Reply-To: <20260212022512.19076-1-npache@redhat.com>
References: <20260212021835.17755-1-npache@redhat.com>
 <20260212022512.19076-1-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR05CA0126.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::11) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS2PR12MB9613:EE_
X-MS-Office365-Filtering-Correlation-Id: 3de80740-8e4f-4a9b-2e14-08de6a5cf1df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZTA1T09YY1dRMng2T2czaERPZ25vMExNeUhvYzgxaGtBZEpUZGJ3TDBCYnA4?=
 =?utf-8?B?Qy9WNm9HTG94OVduYnlvRk5XU3liV09USnIxNmp2NXY2VDhNTHdjUjNOYWg4?=
 =?utf-8?B?Z3VPSjRCMmZJVXhtczcrdWVhT3VGOFArOFluT0FjeGpWcU9OV2JuMGErdlBD?=
 =?utf-8?B?by9EbEVoOFZoSUxMdlN5NGJPQlZiQnZKU3dPMmNqeUNwVzhpZHJmVUlNcTBX?=
 =?utf-8?B?eXVLRHk3MTNzTmtwK2lRaWZoREpEQnRYbTU2eGYvQ2tqTm54bmFmU2NwbCtF?=
 =?utf-8?B?LzlQVEVtOEdHbkNEdVQ5MEVlVWFxMXNxRjBmNnBmdWtQb05DakgxMFE2YVlR?=
 =?utf-8?B?Z2hiSFg3eVZjVG0wUzV0bCtMaWlJeW1QU0UrcXYwb2VLM3lhNCtPUzh6SmRw?=
 =?utf-8?B?Q1A3bjlOQUlDRlVEVHdXRnVxaEpQT1RSZ3BaTWNML3RsRUQvVWxaNlJiS1o0?=
 =?utf-8?B?OEYvRTNxVjBsMlN6N2tqWXkwOGpkZWZUK0YzR2J6N2hPNVBLbDRseVBrZlNW?=
 =?utf-8?B?QmwzTHo2bG9STGNSZ0gwQ3IzSUErWmFXbE94eEU2NGc3WlhOS0lHWFpqaUlm?=
 =?utf-8?B?ZmJPNVNkYWhJYTQyRlNwTllTeC9seXNWcmVrckY2VGZGWThicE94SnJJc1I5?=
 =?utf-8?B?UWp3d0RoVjdWUlBrSVphSnhvcnpQbFQ1amFnNklMWUFjbGFRVUtoNzRUYTBE?=
 =?utf-8?B?NURtZlp3d3Q4K25tTHZoeTVFemNkSTdCY3hFbTBsZTdVZ3EyUEc2S2YxajA0?=
 =?utf-8?B?Yk5TdkFUMFU1NTRkL1FMSDN0ZXppcmRBYjc4VDR3ZitIa1RXaVEvbVdmUmNS?=
 =?utf-8?B?REpIZXgzdk8vbEdRcmVBeTVPSTlUcFc0NVhua1Qwa0MrYnBBM0Y5MHhNWUNL?=
 =?utf-8?B?MVJzckUyLzdYVGhrRGE5eGcyT1pyTWNaVzZvR1VEdVlqMGYxSUZKS3NZbkZ5?=
 =?utf-8?B?M3k1VDIyb0VNcGRTMnlTYXBISDlVUC9RMC91Wjl6Z0dVcWtYK1hkRmpObWZo?=
 =?utf-8?B?eVErck1qdzNMWFlHSjhhNXJITmRqOWp3THdkaDkzb1h1TzR0R3hXclBhNzNv?=
 =?utf-8?B?Q0JDQTl3aDlESXVXOWV0MGV4VzU1djNSZ1hvOUJtSHFJc2FRYzI0WjF2cG8z?=
 =?utf-8?B?T21PSnZETnRDM25PTGlVM3BRcEhoZnduRTVLNEdYYmlZb1U4bm1ucENCa2lx?=
 =?utf-8?B?aVpDUjN2RGRCTUpUYVQ1NEFjUUtoT3VvZkhXMjM5VXpXOTA3UWFXMTdQanQ3?=
 =?utf-8?B?SXpYM2dzV2RDRGJVOGlBU2ttNGJtbzc3Njd5WXllcjdBcVEvMEtYdFkzZTJ4?=
 =?utf-8?B?ak54YXdUOG1sOXFzUnkyamtXdjZraVBhMy9ld282U0ZIRy9DU295b2t4c1Rh?=
 =?utf-8?B?V1VodGIyVThidVZRRktmWWdpdjA4YTkxamRsUVFHd1JOSlRraENrV2lFVk1R?=
 =?utf-8?B?OFdsTThmcTY1QUxuQzhFR1lzc3pTb1BicGhhSnhudEFUTk5sSzA2TC9mRkUv?=
 =?utf-8?B?aFp0Smt6Qmt3dTJCelZZdzRXcDJ6N21uYVgwaTQyNTlxZHI0eVVueTM3R0p4?=
 =?utf-8?B?YjRyUVdIb01oZ1RpQ1Y2R1B4RXNYRjRWMDV2VExDTXVwQURBWWZjV0xEZllG?=
 =?utf-8?B?S1h6WkVqNFFvS1dQbm9vTlVhbStMaG41SFNZS1d6Wk1FcWRLc0c2Q2lKdEll?=
 =?utf-8?B?aUZFWXloWXBuNlF3NzFPU3YwWGM1TDVjV2FYelFWZEE2a1dFTlZ3UGc0OXJK?=
 =?utf-8?B?YmtwTHo3ajlEUHcxcEhTWEhLcnY5bG83bDdaWkJ1TGlvYy9KNjJGdXBsMHpH?=
 =?utf-8?B?Z1psbzZaQjNDcUVDK2N6eCtnR0VZQmY2elZFb1cwNkE1bjNoM0Z6Mm5rY1pG?=
 =?utf-8?B?OTRCeXp3aGk2bHBndWtOaHRDUjRWYVdZOVFYTGI5UUc2WXUrSEM4S1gyc2V4?=
 =?utf-8?B?bm9LMnFybXJORFZSNkRnejd4aWRqU0RuU2VZOUVJME5BUTgvZEdweEp3cnVT?=
 =?utf-8?B?aVVvYXVnaXRNaG1xdmg5NEtSSmNIQkdRSHJEclQ4QTFiWWRuMkZ6OGJBYzg3?=
 =?utf-8?B?NURnTE1UUVZQZlkrZmxUUGd2Um4wVG1lcGZWN3pyRXBKWEFNeVN6Mm9aY1Bq?=
 =?utf-8?Q?hFMg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VDFKNnJQV21oZGZlelJqdktQRTBUMm9hc29zV25SSlVDTy9RTzVhaTdIRXhC?=
 =?utf-8?B?eUxOblUzUXRsZkh0UEZHMDBEWUtHczJIRzdQaE9USXhUTGs4NlJqT1AxVGl0?=
 =?utf-8?B?ZzAxOE5WcHdWanN5ckw3ZkIwZ3V4WXBBNlVpYm9uWHNISUVQaGx6cnRwcStq?=
 =?utf-8?B?T202UTBkOUJNZjNKb003TERGU0cvNnl6UWl0MG53YnlITjg4eHVSWG93NmZG?=
 =?utf-8?B?SDZ2T04wS0ZMVHU5RzA1MWYzL09zemVxMFU2MnBHVlU4UlFscWxmK3BrQnM3?=
 =?utf-8?B?bUh4RTRQMnY5MGtFTi8vYS9IYnhpU21iQlVqT1Y3MUIwQ2h3Q1p0NDZIVUY3?=
 =?utf-8?B?SThhMkNmRE1VNmkvRFptc2V4WDBjVTlwUEF0MFNweTNNYkdqeDE5SVozek5G?=
 =?utf-8?B?My80ZkM1K2FrR2RBM0g5Qld4UFVQbU1peVhUczhTWk4waU5Rc0JVRGRlczhS?=
 =?utf-8?B?MDI2QWlUUFUwQUg5UW5vL2hOY3dmSHYxU1VEbWs1R1BYS2llWGR3eUo0Tm01?=
 =?utf-8?B?RklPKzVyY0g1NkljbEw4YlFjZ1hRYzVEQ0FRVTVqNXVoR3ZCTy8wb29xZXlh?=
 =?utf-8?B?dUdrSklLWllBbThMcjFGQitxMjdzSHpXSUEycmpERitYaWF6d3hNT1N2aU5v?=
 =?utf-8?B?a2lCY3FOYng0UWdqaXMxYS9wbC8yK0ExUnJHVTEvK1Rma0E0bE1xZDcyY3ky?=
 =?utf-8?B?TDJlN2RuK0NxSk1GQlZnOElGRHMrM1dkZnNURHpyRk5XWmo5dzJmWTk1YU9R?=
 =?utf-8?B?eEM1aGlSOW1YdlordzRSeGVTM1YvdXpjc1NMMU54b0J3eklxaVc5YUhwNEp3?=
 =?utf-8?B?K1o5SEYzMkJlcHRMUk0vbkNXL0NvWUYvNjhnVUNJSkc1Y1hkbTZnY1gzOVlG?=
 =?utf-8?B?bWxSSlZpTHA1S0Y5blhYeW5kb0d2QVZlVHdydExMTWY1bE1QNGYvTWpYMUxY?=
 =?utf-8?B?Tmp1cTR1QVNiekVVZGwyYm13RVorQ24rd0NEcFlIR2R5alNkSGJ6d1R3eUs0?=
 =?utf-8?B?ZWdDQStKUjBYbXA5QS92Yyt4OEwrS1Nxc05UNWFJUURHOUFFaEx4TlVXME0r?=
 =?utf-8?B?N3JYZURUZzc0S0pJQUZZcHRSS2xzZ2JBcVJBS2lCc2ZZbXBvTnBuNG5Ub0NH?=
 =?utf-8?B?ZXpqY2JCL1g0b2RCejlDVHdIYkdCeVlIbDdnWUpKSU9vYTFuK3ErSUpjdC9u?=
 =?utf-8?B?c3M3cDRRTW0xRG9xUEEvQ0JHZXhPaVRmV1NhMzNjakZvT1ZuZ2ZwVXUydE1S?=
 =?utf-8?B?Y1IzWmRzQ2tkNVgyb3Mwd2gvSGtoMGE5TnRsbVBlcVI0blV3VkxqQTVEa2xI?=
 =?utf-8?B?M2NRWEdHa05NQ24rUGFCWVZaQVJNWjRlck9qcHJ2T0NzdXVKYnB0UmU0RXlu?=
 =?utf-8?B?UUdzSEFvdTVLZVBGMUoraGMvakVWYzlqY0hwcnBHWDEzL3lmUXlkSkdaL204?=
 =?utf-8?B?Mks4M1ZFSkhLb0gwaGhEdWNBU3BxdWV6TGVLYm9jVEo5bTg2NmJIVFRyaFdk?=
 =?utf-8?B?ZWNXTGNSNldoKzlPbUVVdDBkNy9aS3QwNTZGeEJRT0MyaHAveHZiY0thNFdL?=
 =?utf-8?B?V3kraHVZOUJscHNGeGtHQVI3ZEYxMTlHWDBCSWxOTlR6Wkg3L0wzUUR3LzFt?=
 =?utf-8?B?b1dlWDdIV2hUOGxVQ0h0dFowQzA5L0UxQ2RUS2JxZTRqVDlpck52YUV1TStq?=
 =?utf-8?B?bXZBdXdWMHJZNFVzYmVOemh6TW5YNm5NQU9Vblg4WStEdWVKR3VlTUc2RnV6?=
 =?utf-8?B?K0gzME5FdEFNOEZDMzJ5dk5oOFdYZkRwVzdKWXhGVFdybWxCbWZDU0JGTVlv?=
 =?utf-8?B?MnRkYmkwWTRtVlBFTWpJMXY2K3RBc0pIZlZ1cFNCVW1HNUNaNGVLcm1OekN0?=
 =?utf-8?B?d2NxcSt4ck9vNTd0R3pnclIzTWpkdWg4L2VTeWs3d2I1ZUFuYVNTMUFHSVYv?=
 =?utf-8?B?eEw5REtHbDFETmlud2tQZENYWlFrWEd2Uzc4cWRJOHNsempZdTFjNXdGb2Fz?=
 =?utf-8?B?VzZPb0lhMkdJTnN0NlVBT25lV1F4S1k0bXRMVzFjUGtma3NzV3M2TnZjNTZh?=
 =?utf-8?B?V3BXZlphZFByU1ZTVlBJczZYU3NXaFRicXJLM25CRnZsREFENy9pTmVObTcx?=
 =?utf-8?B?SHAzNjl2RU9nbFk0d1FoS0p3VUswUWFHcUgvR0M1RlljU2JiOWp4U0Y1bUhC?=
 =?utf-8?B?Y0lXRk00c0orWExCMXBmMjN3TS9QbDlVZTZuUklDRXNqNXhlZ3JSaHZBN1Jz?=
 =?utf-8?B?WjlQK0RZYWd0cjlYNU5GQURZaks4ZkZ4dG93NUJiWERpZloyY2pTaml6S29u?=
 =?utf-8?Q?M7ir5L/9+8Zqa8Rb8p?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3de80740-8e4f-4a9b-2e14-08de6a5cf1df
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2026 17:34:16.3260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CKHP7OR+sATt4eyVBxPrzKUOThHANzK0FjhHoypY6EJmZabHaKKCQuABkXA0KcFs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9613
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5FB302000A
X-Stat-Signature: mebjyena57mgy1bzk56rszfgxfqww13h
X-Rspam-User: 
X-HE-Tag: 1770917667-96737
X-HE-Meta: U2FsdGVkX1+7uW3QyUl4703SKvPQQjC5cT9xPSy/q/7UiFp2LYVQLy50H13RUU2rDpX8Wg0TsCLX8iaLmEEURsU65iXKgroAqsBaxqKlh5VbgGHLrPwDCrQBxeaaknvTCdfknduWOS6PSpM0yODVntT5n33sgU+pgR5LzxsjbKwn5Kg2rKRRmeWx7pd/fgBtDoV3UEhMJRv2rfB0jZMRDt7q2jP8gY5yHk4OpaSih3eN51mM0XlJALSuuw7Zb8glsV/TuDZGBkMm+r2n60WSlilMb8BOkMokLImTFuIkzUQg68/1W9ccjsYQ8UYxdH87uvVggKLuvQjHFYX1DB/OGWQIF8LSe4e8KwhLi6MdoCaKZySB87F4R6QV3cwQ4TOJvP0i5JwoYB/lNelL/qCDGn9JGN/t8dxI5tXPPOrEZkiTlSNDD4RAnXEBTTvf8VIjBvLKJSKI76qs5LCBAKSnUqdY8ovbmTeeXmN2DKutEV5Ux/p+7uVvNAoeFUAP/rVHawssFYJ1RgJ9t+HVQbeat+OVryD56gS0lEWJ0lLenhfTmMpq93BWa9CSUQ0ChzB5xC13H3DO1pXDjsLe04+nDUJB4ODNH5qeQZwLZpIjFOLLmcDCP4nDU9LAtQNkyHsI28Eirn4aPDUEFPle6yJvWDc/1YH12QdLxdercOQpuO2DOWZ8uuSY5FsGGuc59+WNX1uEu6qI4+i9zJ00+yKL3XEGgX4W+tnIpVs8WkfwtogxoY4UqXM8SUw5y3xaB6jXmlPq0YP0j9VfxWJv42PrvL7LJ6PWB3CIOI5ZEglsKugexhUdYt72oVzGV0JOdDn8ft5hQLSyY6Slj9aK9FG4pyKz8hXwVkBVvJLB6zWkTM8RFhCGQWGRnhSM0l+xMi5PzhCmcFmJMq91u0c9b/2JxTBQOi1/yfjcDQMETyIEAKy42OcH1Io63D8TO47hEyZT2/qvegVmpmgCJ3a4Z70
 5pVDScx5
 Y2IS2n0hJmcOOiQXEBSq1JNUfgsEtKsDQX+XDFoh19usEOC2iemXu9W0W4+a56tTZC20uXtx/7ykhvEH4mip2UEwuq0D3KoE55rTeN0ZlycwinywGFXyPFX76EByS5yZw4lFd7LINMKZsSkEm1rDlhb50Bet6UE716+PE9Ctd1n805ogH5sBEyE8iyoFQfn55xifw8cxPISuf57G2a358jtmQ+b8TfoEqltiZAGPnUltXBcL1qN/77Gfv4pAUu5V5G0o1T/NkxpWOAYClgBRm5KDw68Xi1jT2twq1ckytHn2vdtw4FTcczy8Kwj4W68lK8/ophRYprYLUgCaB75JPW0/E7TrqpckjUAdrxTRLbH0R5BqTAS32JsnoUo3a6KU5uLS4/MiwGZNIu1nS3nHgdi5l+NxM6F8IhYUvdMB3xWl+ryyOhYuID0CjDhktDcwA6FNW16gliWZFZYn2sS1bgQ/0syi4eONAGpP+sGpzD7IY7lUmPKldWQr/uEg2IqFA3s8T0MK7wW0WzQEo8eqjq3VpjaYNo4RyU/Lc2Ef+kmT0mW3ULpl/irKEhQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11 Feb 2026, at 21:25, Nico Pache wrote:

> The khugepaged daemon and madvise_collapse have two different
> implementations that do almost the same thing.
>
> Create collapse_single_pmd to increase code reuse and create an entry
> point to these two users.
>
> Refactor madvise_collapse and collapse_scan_mm_slot to use the new
> collapse_single_pmd function. This introduces a minor behavioral change
> that is most likely an undiscovered bug. The current implementation of
> khugepaged tests collapse_test_exit_or_disable before calling
> collapse_pte_mapped_thp, but we weren't doing it in the madvise_collapse
> case. By unifying these two callers madvise_collapse now also performs
> this check. We also modify the return value to be SCAN_ANY_PROCESS which
> properly indicates that this process is no longer valid to operate on.
>
> We also guard the khugepaged_pages_collapsed variable to ensure its only
> incremented for khugepaged.
>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 121 ++++++++++++++++++++++++++----------------------
>  1 file changed, 66 insertions(+), 55 deletions(-)
>

<snip>

> @@ -2799,6 +2830,7 @@ int madvise_collapse(struct vm_area_struct *vma, un=
signed long start,
>  			cond_resched();
>  			mmap_read_lock(mm);
>  			mmap_locked =3D true;
> +			*lock_dropped =3D true;

Is this needed?

1. There is a one above handle_result;
2. mmap_locked is true when entering madvise_collapse(), so *lock_dropped w=
ould
   change only after one iteration and the one below should take care of it=
;
3. goto retry is moved below =E2=80=9C*lock_dropped =3D true=E2=80=9D.

Let me know if I miss anything.

>  			result =3D hugepage_vma_revalidate(mm, addr, false, &vma,
>  							 cc);
>  			if (result  !=3D SCAN_SUCCEED) {
> @@ -2809,46 +2841,25 @@ int madvise_collapse(struct vm_area_struct *vma, =
unsigned long start,
>  			hend =3D min(hend, vma->vm_end & HPAGE_PMD_MASK);
>  		}
>  		mmap_assert_locked(mm);
> -		if (!vma_is_anonymous(vma)) {
> -			struct file *file =3D get_file(vma->vm_file);
> -			pgoff_t pgoff =3D linear_page_index(vma, addr);
>
> -			mmap_read_unlock(mm);
> -			mmap_locked =3D false;
> -			*lock_dropped =3D true;
> -			result =3D collapse_scan_file(mm, addr, file, pgoff, cc);
> -
> -			if (result =3D=3D SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
> -			    mapping_can_writeback(file->f_mapping)) {
> -				loff_t lstart =3D (loff_t)pgoff << PAGE_SHIFT;
> -				loff_t lend =3D lstart + HPAGE_PMD_SIZE - 1;
> +		result =3D collapse_single_pmd(addr, vma, &mmap_locked, cc);
>
> -				filemap_write_and_wait_range(file->f_mapping, lstart, lend);
> -				triggered_wb =3D true;
> -				fput(file);
> -				goto retry;
> -			}
> -			fput(file);
> -		} else {
> -			result =3D collapse_scan_pmd(mm, vma, addr, &mmap_locked, cc);
> -		}
>  		if (!mmap_locked)
>  			*lock_dropped =3D true;
>
> -handle_result:
> +		if (result =3D=3D SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb) {
> +			triggered_wb =3D true;
> +			goto retry;
> +		}
> +
>  		switch (result) {
>  		case SCAN_SUCCEED:
>  		case SCAN_PMD_MAPPED:
>  			++thps;
>  			break;
> -		case SCAN_PTE_MAPPED_HUGEPAGE:
> -			BUG_ON(mmap_locked);
> -			mmap_read_lock(mm);
> -			result =3D try_collapse_pte_mapped_thp(mm, addr, true);
> -			mmap_read_unlock(mm);
> -			goto handle_result;
>  		/* Whitelisted set of results where continuing OK */
>  		case SCAN_NO_PTE_TABLE:
> +		case SCAN_PTE_MAPPED_HUGEPAGE:
>  		case SCAN_PTE_NON_PRESENT:
>  		case SCAN_PTE_UFFD_WP:
>  		case SCAN_LACK_REFERENCED_PAGE:
> --=20
> 2.53.0

Otherwise, LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

