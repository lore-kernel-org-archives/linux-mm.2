Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9532AEC1EAC
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 12:29:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06CE06B0092; Thu,  5 Feb 2026 07:29:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 020246B0093; Thu,  5 Feb 2026 07:29:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E032A6B0098; Thu,  5 Feb 2026 07:29:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C92BF6B0092
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 07:29:00 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 922C81404DE
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:29:00 +0000 (UTC)
X-FDA: 84410332440.13.E1F7A06
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0A77140002
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:28:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hdRHNUqZ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wEIh38XF;
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770294537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GlrD7v6IskHwhoXu9U/IR6DuNcNleQIZfLKoVxgdZ84=;
	b=nuMggJMDDxzxKE0LzE13aoqwAC0PTEgq2YxdIgE7g8ACpJoR7Ln4Sm2c0238wYkkc50xU6
	ZU2ikhpf1U8Qvt08YTSf6LZbZp2Ur77w4jOH7YG83NgPeLTG6yCiIRUpTUpy9SxtSyjDh7
	j64Jyk/7ygzvD9FEjE1LVthIPKER6Ps=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hdRHNUqZ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wEIh38XF;
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770294537; a=rsa-sha256;
	cv=pass;
	b=HdtXTD2Cxlro/yYiE/jmKlIsDz3ZRAMoi/uPlvuEHfX8iYXth2weo5EBuLDBjhVDjKgVh8
	U6b1spnVRu0TT25OZigil6VOEQn4C7Tr0dLmT0EA/Zd5+fptdadic3KwnJOVH2Xe7STaRE
	024tzgQ8ggQuCd2tw+cj93sAatn4xsc=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 614N2HhQ1716428;
	Thu, 5 Feb 2026 12:28:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=GlrD7v6IskHwhoXu9U/IR6DuNcNleQIZfLKoVxgdZ84=; b=
	hdRHNUqZE+mMmhWC1TmoYPcuYnruJuNN6zmSnzL8BA6hwGe9WaSYJSprpvAFw+tW
	B9hXzxKXO8RDEU8TFQRUPpTC4Y4MCyhLdZfh1UluE8+MF0mP+rdn+WYOgQgK45bP
	dnNjOB4Ruo6XesbdsPHzDh3G87lNeiXcDhosRTjYNJGNYZdq81mhFwAYgIAI2E5J
	gnwh9vfDifelsZn0F0BCC732goFV+Qt2t1Ua+cPBXTy7rrLorHeEvx4XvTfzc/bQ
	w0GtXMNGqVNxAi4O7jmrA5cR3Hh6AUknJ6zkPXC8SOilnPD4o7lNqzpdwwEAln2F
	yFSdIruGburGxxa8LMBH+A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c3jhb3mjt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Feb 2026 12:28:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 615CCib8025853;
	Thu, 5 Feb 2026 12:28:28 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011050.outbound.protection.outlook.com [40.93.194.50])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c257bqjej-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Feb 2026 12:28:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JkYhsm1xPtI++TzPtmwSMQ4ZcbOhpiWwHdwH+fZ2kwM4ruOQnTSXanGRCZHtkveUDFvlpJxwTxIsorgn2maf+ZxJQbHiszAanvj6DizELOYj8juc3KZG8lhZVziSOS4q8nNaamM0+GKpPAM8haA9FhEEPzoXoEMwzYdXAy/8TekJVpGbTvjJh5ncywV6BkFzWKo1X13k+gXXKHlma9Qx8n5lXRG9wUc+U93tsblMAqPa1F7jmITyww2Rm0sJzjen6G4IGaYAwVCrfxLpawlStq6EEKUHMOo2IZXkG17VjPc+HUGzt5TA8mE6UchyC3NowAycVTntdMTsu4rvbvx3FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GlrD7v6IskHwhoXu9U/IR6DuNcNleQIZfLKoVxgdZ84=;
 b=L7g4c3DdNTVRn8NUc8lkGTs1OwMLEatdy5COH5ObXnLO2H6LMUoEqVF5KhfmrWjzE/iOusQYlPpLLthcHEoL+Tb1fYpqdJZEZ9e28xnt2eQDno4aRHM4Oe5a6tQmbDJcQFSKTdLS9bdG+QLMsQ53RXeRrR1649kO0fdFOgz8idkUmzrwcvQTy/johIY3vMZlZ29kP4SztJNEBOJuJC8wVlNm/vwOpaNDmoTbUYVoFMYCPm2OMg0VrJnGyMRLtdwYBEgVPbMpMjG+C03Wq/ZGg9xFdYkGzKlJFG45iz83tIKZoXXRpEHK9/mTgF+n4pUJHwoypLdD2jcjXO3IVzkvLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GlrD7v6IskHwhoXu9U/IR6DuNcNleQIZfLKoVxgdZ84=;
 b=wEIh38XFgRB0pidCBVaNOsDYWX3C818u4Rk2yjE2uH+QUiCiYclJgHwpAQ9XjnLeE1NtpOUBQcjJLkPbwrV3TiwuFe37C0x3xImYUG00DNYk6GkxK21U3itEUILl4FLA1SLC5rcO/qZOeEBrGVdQ5r+fpoQ6gUC9mgGeSTLtFlU=
Received: from DS0PR10MB8223.namprd10.prod.outlook.com (2603:10b6:8:1ce::20)
 by BY5PR10MB4209.namprd10.prod.outlook.com (2603:10b6:a03:207::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Thu, 5 Feb
 2026 12:28:23 +0000
Received: from DS0PR10MB8223.namprd10.prod.outlook.com
 ([fe80::b4a4:94e3:f0bc:f4c9]) by DS0PR10MB8223.namprd10.prod.outlook.com
 ([fe80::b4a4:94e3:f0bc:f4c9%5]) with mapi id 15.20.9520.006; Thu, 5 Feb 2026
 12:28:23 +0000
Date: Thu, 5 Feb 2026 12:28:23 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: "David Hildenbrand (arm)" <david@kernel.org>,
        Alice Ryhl <aliceryhl@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Carlos Llamas <cmllamas@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <muchun.song@linux.dev>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
        Gary Guo <gary@garyguo.net>,
        =?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>,
        Benno Lossin <lossin@kernel.org>,
        Andreas Hindborg <a.hindborg@kernel.org>,
        Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
        kernel-team@android.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-mm@kvack.org, rust-for-linux@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] mm: export zap_page_range_single and list_lru_add/del
Message-ID: <39931d87-7e50-4e67-9f9a-3980f39de16c@lucifer.local>
References: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
 <20260205-binder-tristate-v1-3-dfc947c35d35@google.com>
 <02801464-f4cb-4e38-8269-f8b9cf0a5965@lucifer.local>
 <21d90844-1cb1-46ab-a2bb-62f2478b7dfb@kernel.org>
 <ab63390c-9e75-4a45-9bf4-4ceb112ef07f@lucifer.local>
 <CANiq72=ybFtqsh18zkC3e1iyR-RoffcL_ZDr-fU7SjzJiFERHw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72=ybFtqsh18zkC3e1iyR-RoffcL_ZDr-fU7SjzJiFERHw@mail.gmail.com>
X-ClientProxiedBy: LO2P265CA0346.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:d::22) To DS0PR10MB8223.namprd10.prod.outlook.com
 (2603:10b6:8:1ce::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB8223:EE_|BY5PR10MB4209:EE_
X-MS-Office365-Filtering-Correlation-Id: bdc2e852-8121-4e14-7fda-08de64b20de9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aGFobFB0UHJjcUtIZEMrdWhwNU9kMHY1QmxuU2xZbjRaR3pkMnlpK1h3Smdh?=
 =?utf-8?B?ZTd6N01maDBlYzIxbFZsMllwOVRKTzNMcW1tdExxWHk1aDYzU1FRMm9wM0FQ?=
 =?utf-8?B?Yjc2NDB6QWNtRVNNQWw2YS8zM0xqUC9TRjZHZ1JTQXNTOUZHZnByT2cxbkpo?=
 =?utf-8?B?dHhTTFQ1N095a1JNSFVlbkJrWEhGYW5yR2hjRlRBWjhQUzJMT0JmZjBjRG9i?=
 =?utf-8?B?dTk2U24wWXNib1puN1RISHZ6UHM3cktLWHBZemd6RUtSWU9DUkpYMngxNGFX?=
 =?utf-8?B?Ny9vajR0cFJNVHVFTVlJL2x1MnFrdThqRS9QNDhXZS9jNWdWTVh6S2pHaEg5?=
 =?utf-8?B?V3VCQzhPMkx6TUcvR3VyU29sYk1kWnFhUzdDdTZQdmVVZ1dCd0JpTytDV0Iz?=
 =?utf-8?B?TXBKYUxsKzgzUG9lSDFTY0JWbXFrSjN5VUxPQzBCcVRyMVlHcHJCNGxHVy95?=
 =?utf-8?B?RmF1eWZHTnBuWGFoR0xSREtSR2ozaVhvb3FYWitMaVhMbDU1UnNQUjVsRmdE?=
 =?utf-8?B?WVZGQXpxRzVURkRZbkdUbWJXN3JXWnlUVk9NZUViZDI2Z3dzcFJodkZPRmxL?=
 =?utf-8?B?eVlvM3FNZXB5QWc2aXI2Z2JYOFBUa3VIb1hwWm9lclNIbzBDeWIxWnFQMC9E?=
 =?utf-8?B?VGRjWjBESXVTWWYxWEw3bGRWMktZSTNLRVpyR1pBbHhBaENuMVdrTUluM2Nh?=
 =?utf-8?B?YWNMeG9xMUl3ZWhDaXM2dmtKb056KzN5UkRnVjYvS1lKZjh3eFZ6QVZBSFg4?=
 =?utf-8?B?clNpS2NSUDFiRTZUQldnc3EvODc5ekNiRnZRNnZ1NG9WVnhveUpDVFhTQVYx?=
 =?utf-8?B?Qk9uQ1EyMC9BQnQyYUxrNkRKOHF5cXhQZE82UmYzTVlFSU8zait3OVlKajlJ?=
 =?utf-8?B?UEZ6TFlLbjFlbGQrRkwvK0txZUhXSU1oMGR4cXFhR0lkRk1Wb1EvSW96L1VY?=
 =?utf-8?B?YkVsZGxrbHRPaEhMYWJTcjlKR2RtUWNBclhvWXhYQm5WdTQ0WXpxYVdXbjdF?=
 =?utf-8?B?MjRxYW5XMGVTWUl5LzBkZWZ2bm5CL3NyMGJibE5HOU9zT1kwYVF0WStITlE5?=
 =?utf-8?B?ZElyaTdyRWpRRFhqS2VsNDJGb1FzL2wvZUpFQlNOd3BwWEVKWUN1bFE5bWRm?=
 =?utf-8?B?YjlmVzBoQ0dKQXg4OGVhTGRnaytEMURkT0lVbkVlRGczQUZtVlc1OXV3QTk2?=
 =?utf-8?B?YW12dXA1YzZEUGJMUVM0UGthUEgwbHRDRlkwVG02RG5reFdvVTJvaGpPNGxp?=
 =?utf-8?B?YkVnMEdXVURCTmxlaTNSZ0NHTjRHUk4xQ0prTnZsd1Z4QThZK3g0ejd0TUhK?=
 =?utf-8?B?eTNpQUk3RTFnb0RtUHpFTExZVHduUXJsVlluQVh1Z0dWdmRTc1h0d0tHUVRs?=
 =?utf-8?B?NGRaaWNGR2Fuc0s3ZkFzdzdjY1BSeWFzTEVFeFl5U0x0V0xnVUJWbjArbGtC?=
 =?utf-8?B?d1R6VmlGUWZobjVWOUxoejZ5SXg0YWFsYkZ4SzRGUWNrVzhJdzZUVjJmRFhK?=
 =?utf-8?B?UUJzUjRZNnFYdUJveXBjUWxpd3pnZGNPOXV4M20zU2dGU0w4UTZJWm9PcExh?=
 =?utf-8?B?bEt4TE9rREppWjRVRGxOYUg2WGt3YkpQZVVtTm8rSVV4dzVrUjB0cGZnT0Zz?=
 =?utf-8?B?TVVwTHZKNk5naDJ6eENoMUZiTU5uWno0SmgvZ2xnZ05EOExhdk55Z3g0R0Zy?=
 =?utf-8?B?VVRabEFnUEZFa2RmdnBtZVZ0ZEQ0VG9NZUtBU3lkNFhDaitTZUs5Wk9OcS90?=
 =?utf-8?B?bktiaWJ0RVlyWGNVbTliS2kwVUdUVUFPUnh1bnpnMjFTK0xHbDZ1T1lrSGYy?=
 =?utf-8?B?MHpQd3pkdUFaTklTRlZRSEFralNtZUZsNHpTek5VMVVBdUo4VmhiS01Jc0RZ?=
 =?utf-8?B?UElneTVEaGh3dGRpR2dkZVAxa2doOE1qanQwTy9ZVTk1aGVDTWNJOXdDVGpF?=
 =?utf-8?B?ekk3dko4MGN4T2ZOT3k0OFlYb3FpWG1ZdEdVbW9UdVppTy9EbkNVRzBiakNV?=
 =?utf-8?B?MTRjWUxtaUZteGRPbHdldVVkM0M5L1M5UXRQeVZBa3J4eVZ0UFl3MTFqUXFQ?=
 =?utf-8?B?V3JIMk43R0dFTGIxcnBheTkvQjFXV2tnWnRNRnJSeXVsekUwME4zU2w3WUVM?=
 =?utf-8?Q?9ll8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB8223.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cFkwcVpBUjdqT2NRZE1ObThBSm9pWlU5blFoYmNwYS9kczZvdTJmZkl4ZUVN?=
 =?utf-8?B?MWovTzBrcDhWVmdHZFcyb25sK2lYNXQ1MGZjTmVRdHN3L05wSEl2MmxycUJX?=
 =?utf-8?B?ZFJsbDZ5enB1cjVkNU9XdW5kcW5vbjZLTkVkVEhZWXEwS1RFdVhFTFRJUjl4?=
 =?utf-8?B?dEtPNUl0Y0hOaktVYkd4Z0c0WFNrbGdydXgwaDBnZlppcmw2MjgwSzZLQncy?=
 =?utf-8?B?cHBRZVZIU0Vuamx3OVgyNU90Q25CdEdiZ0tpL1VyOW1zS2szalJISWFHbmlM?=
 =?utf-8?B?OGk1YXNtVHFPNlFDalJ6VVRva0x3cUxCTzhkcC9ZTkRJWk12djVZRTFpa2d2?=
 =?utf-8?B?SkNmMG1yTENJZjZIaURramxIK0ZzRUhWV3RvTEF1enJ4QngraStwalV6OTBR?=
 =?utf-8?B?c0VIbGZ1ZnIrSlFrNFhOcXEzb01QZ1doamJNSStkWFY2b2w4M3UvcWFrYnhK?=
 =?utf-8?B?NnIrYzRYUFk4UXdjL25haGMyQ3BKYXdIRGwvbmVuMXVWcUdWQ1dMc0JCREJP?=
 =?utf-8?B?WTVHYmNzUkg5Z2ZwK092MmtyUjJtOEloaE85bktqT0t0TnU4ZHFXYmh0NE1E?=
 =?utf-8?B?alJMREhvUDNpLzhpeXh1WGFBbjlteWpMSmRLeVZWZ0FZOWZITjd6MWQrdXgx?=
 =?utf-8?B?OERTa1UrWDRneFhuT3pOUlRkei9pUWlmdEI0M2ZhSzZ2dGMzamsvSWhLK1pL?=
 =?utf-8?B?UlJ4ODFvS3ZpUDFkRzNmb29ja3hSRlEvRFIyVEFqSlR2c2hsRWx1QklkcHZh?=
 =?utf-8?B?Y2tpcWtoMEtyTHVUalZCTXNvUlRVTVNpZmFpRC9jT1puWWllRUZuNmhmeHFx?=
 =?utf-8?B?Yzk2NktmVHI1dXhyTnJpQmo1eTRVRXAwVHFucWhVVk5kNS9hM0FobG5ZcllD?=
 =?utf-8?B?OThTdjhqeFFPWTloSG5pTnpQcUZkZTZVNXI4MzNVZjdpVWlOczlaY001OTht?=
 =?utf-8?B?RWUyYitoTkRsOWRhRDNMdlZ3TzRDdlNWWGlHMFc3T2hYQmJDS003QWVHR0lJ?=
 =?utf-8?B?dFpnOFpsd0dMa2UrZ0lDdjhLUVROeU1ZQjBULy9wQUpTM1FKUzVZR2tqTGUr?=
 =?utf-8?B?UjJEV1dVNzk2VCtxNUJyYndZczBOS2hIcngxUVk1alErSXJGSzhoQTRxdXBt?=
 =?utf-8?B?MFJhQVJ1VmhQYjZORmJrWVlVYnNGTXlJd2wzeWpQblZKRmd2dDkwV29wcWR5?=
 =?utf-8?B?SGJLODlKdy9OWXVtTUNjUVlUdlNFSXBKNTREenVxTjJEdklnZ09CSGl5SHAx?=
 =?utf-8?B?cmVHNTlpMHhhYlRFRk5idEpLV1JONThEMjkwOGY1SHdqdzNZdm43QWpQOFZi?=
 =?utf-8?B?RDd4cXc0bzFEVURjV2IwZ0FqMng3cytNeUhIRWpvVmpxSi9Jb2lxYWRxWnQy?=
 =?utf-8?B?Nk00S2Q0TzJCTW92YVZaYmJLdGhrVlVGK0w2UlFNT1JIOTRpRTFuU3JHSkcw?=
 =?utf-8?B?dnZpbTFUeFU4SjVuM24yZ3M2akFaa0l3WnduOFNmU2pQdHdsbEhzY1FnMTBa?=
 =?utf-8?B?L3oyVktuU01iMkFFUXNXQzJSRi9qSTBlUWtsc0tESXhvcWpBNm03cHNqeDlz?=
 =?utf-8?B?MHlqRkcyVkcyZ1FGdjZCdjRGTGdydXZDQ3VaaGM1bGlkbVE3NjFOd1JzMXB3?=
 =?utf-8?B?eVE0by9WMjFrZGNIeFpSaXR3aTJqVnRtMzlnbUJLa2c0MmZ3enNrcUFxRzQz?=
 =?utf-8?B?Ym8yOGtTTi8yeVRBYjJsaWwrTTU1RW5IbHlvb0tqTi9jKzBXUm9oSXZkb2wy?=
 =?utf-8?B?MTJBblp3Z0FvQ3h5cUNGYk1weE1ObVh0NG1NY1o2a1k5anppN2FYWGR0SFdM?=
 =?utf-8?B?Q0ZwZndCam9aN3FVK0xzYi9oSEtUWlJJc213cDVQTS83bXJLakRUcXNwTkFD?=
 =?utf-8?B?Tm5aWmppRDhZL3crZThKK3dzV3JGUUhFaldJOVVHV0Q2em1OTHJzVzA3SkpB?=
 =?utf-8?B?cXByaEh3RVpWUy9NbkFTK0Y3Ly91aUNJVnozVnN0N2p0bUVrVjR5clh0eW4v?=
 =?utf-8?B?VEhiWmZZMm9KdmlvdmJrSkN1K1c1elI1Skxmemx2b1E2OFhKdWZ6T3FqZDJK?=
 =?utf-8?B?N2ZvZ3I4K3FYQ3QyVG9PUFM2UGNjRWV0R2pjeUJ2RkRCTTZwOEtTK0FIYlBO?=
 =?utf-8?B?TDBPdGVyWWZIQW5kVWFNdC9QdGdyUXp0OUFjRzYxUkwyUXU2TEpDZnNQYlor?=
 =?utf-8?B?THZRZTIyUnlZYTJla0JiVWF0amtheWVPZlBlMEpudzM5VlZLUHZZc2JNVkQ2?=
 =?utf-8?B?aUNRWlVTMXZwSVVTYTc0WXBBUzljQjNYaE1GdG9TK3lVQ0F3a1owMm9JU0Fx?=
 =?utf-8?B?VnJtUDRYN0dTQ0lQaXFTL0N5VGhvcllZZUpHRExvM1UvZk1QUHNjZk9BYXJG?=
 =?utf-8?Q?NoLaRlR7NfRVUfu4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RX5vTdqkp7V32byfFYoNYGcbgDNIfTd2NHJ4N7C6EJ1pa7+XPPFikZBp/k2I8SXSrOj/AJIAJxQozRRFCTOA+x3EClO9y9JgAdorT8dD3UlDVthQHdMbXdr8rSzpogyI/3nMJ8UAu9sTFOTwju75au+IXkouV1L1otgUd9qJz1NBnfLpbGWXYbTPgMBhL9yLhq+WtitWlxvciPWaHzE6W33HXIHU5v4iI5HwY+OOmwf/tm/WrxT5Haiq6yGhWDTRTtETb01GxPYG2UG4YXtARL1vNmHY9WYWeQklf1/4y1xPSOMyO69evFSJScmaRtTnYaKIqZr/3CVjmCWpuqtu1JFScyP6tbV66qaSL6A+Dg3t7TRmNnOda+wtQ1J8aQ9LdbYqVjwWetYifT99Rsf/55gZiOIIGXtqRgqCH4b1PSsGB30Zm69ArP5tpcPIfpd7I9+4AfLxJxcbjJ6qvDJ1R4DyrBYDtZrSQ3wq0OL7HZBFLec+aHujUKzbG5I6LwjCXNWqmhagxPzLg9ZsuwQElicuKQejgx+d63RKpBA4JfZC/zhoUlR/FgkY5L0QtMTmiOtS8V4epzJRfqE+G7JYxv7nEoIdd2Tu+80Xayt9wio=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdc2e852-8121-4e14-7fda-08de64b20de9
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB8223.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 12:28:23.4727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1lEMwbgLWuYPWoA7q2rMg12pgzHuHKUyq6ZNunZYCgjgOUrMDZWt1+jCh/cN1h9FQuu5bXKPPLUosuk/OdmummRpB3Mf3K3G73OhitvlMsQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4209
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-05_02,2026-02-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602050092
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA1MDA5MiBTYWx0ZWRfX+9psNArDzjya
 Zz9DDw3nqVE2HhxxVNwmHkzdIcwjvdp3pj9E+B6YGQ8i/oz6k43egR3SDRZvzDDoGSLb+wwLBx5
 PrzAoofnDdVq249ZDwd9lNCpFyqKSw6+hkzPDFq3iUpP2C/gnSGgtITk2jQWGYaRSMqMgp+fwka
 78t/UyQ3buvgHQIpX3Vc9Oyd1dG2kYJWRpd9jYPzyt7Nobhu5x9KwKf7G44KjoAirJCDBRN2RXi
 p+FcDgasLKQEYbll1m5XhWniIPixBvFXch6TndwX03qCaRo/u8FABMxb/zgApFco8cJIPDisgIt
 A6P5PtIclPO2CiubQGvxhOzNA+vFwTq9EEpxLRl1wmKUJ/SwcsqRYZ4HnHEoqUWtGcgQ8MyPVWR
 4t1j9LsLphESPeWtJoswU60Uhfd658lM90Riw7KuhX3J5q+taMctD8lQzAAN9eYR3S4UQjHeSVq
 Ld6DBjm5czrxysA+L9snmZ3C8mywdeG2UgSoDhq4=
X-Proofpoint-ORIG-GUID: mkhH4vQLa2ffzePnIkgxyiNT6I0ymCD_
X-Proofpoint-GUID: mkhH4vQLa2ffzePnIkgxyiNT6I0ymCD_
X-Authority-Analysis: v=2.4 cv=CaYFJbrl c=1 sm=1 tr=0 ts=69848ced b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=8tqjr2jvbcf2GXSrNs8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:13644
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0A77140002
X-Stat-Signature: 3ie7ps6ecxxmg4689kfis9i43qtnsmh7
X-Rspam-User: 
X-HE-Tag: 1770294536-575864
X-HE-Meta: U2FsdGVkX18Z3eVropvBJGzEAYukChx6eXnPktQEY4Jjq63ZvPum6Y9SOJr0oB62Tu5f/oKQhJp6teqBTUJGScMxqXBJkliG8gQHKZc+MydcXPwIKUYSKO/qmzxyYY0XyCwJWUQvE0LXCZ2mTPKxqWD40t/MxGyZOcRuQr9ubo9TCZTOnLoR+9PPngQBpwHb+5/I+rSiC4z35zJRNj7sDLU8foP1DlJLWUB1CeCJ5QNh78EYpB9VgBFd5229pbWnW8mVgqP795FXRBAJhhVAQ6eDsB75YqCbB+zjvJGm3qJhFpxUJ6biREs81rPF82L6zTemJY2QBSARGaGPwZrhvztCK5XjQz0GqBJfTRskly+v89rx5MqEPh9jTUAHNKLQSwy+CX5QKtiGt+Xyj1HYwoHC3nMwvAUJ7T90j9vbAjST8UaPAlbtVdOoYderiwkv2tPFWwoEXUsVsqxHgunWjYqeTeila/Lu6XfsbPuQunnGp+Ju1ZsSxPRfWP8E+FL/lT00Ix+VfkNapqQVDRXuaDdYOH0zLsmP4/H07ncm/m9xgrjfO36WrYjKT7uVda5impTfJ+ZjZHduoXNB3ji/ZzUYZDk1HJsPDUnO6UY/ejkn9j6lK1H947CAQYIrWD7IPN1SU8xFezq9qlE/3W90enGGlEwvmO+Q760erDGI7fL2vaFsByTlWGKpg1T81BYnW2tI9jBaEJxuQLjGP9xHpd3hMRUYmNzwuAeQhD85Ax+Gcj5XsOQ6RpYP0BX1Cf4jiK/E0PPD/kzCe1NtVyWWWZ8r6lR22Ft3CNGbFqZhTn4RwVvAn90d2ZEBXbheVpvGRqKzY6k87XJSyq4cUADH7sV+628Z+wYnAUnes9erYmTXrROfuvtiIk9BjiG9rwG/pvJsmALhua9OErLi/37PIWLrxO2AWaagB9ZKBKc0PuzOfu/K2pB1BEqjtE/eWWBm2SnrAmAG79GegjEc53M
 KQ4tytJM
 SYvp5vqSAFTsprBhrOYcQ/8Y7Lk+9FW563hmmkwbMtI7iYUfaXb4X2kc/9if/w6ghnaAAFPSUAlfubdrxMACHvM8u5DxbaIgfG07TYKwquqFrXCzjIJnbabDZTvaqS4wPylYA2U7mo6SnpWEZoHXmjgV7EmqCp5iBM1I586wFr/EJysdztoBEJCMfAt0r1Qk2UKeGu0oDFgqVrzdNaBboVAUkqyJ3CjkfZbKAvA30Bzg08G7gVcbPt+7Bjk8WXbKNgHVc4Por1vKozcLWcoFZ6V+Ye9IVC2l3NxiVUMxFJp/HiYkgkOkTUxGAW/5I+5p8iTVCSiVG0/AilJS+NJx86uSek/xCXoIKCDOjdFUWN++YGn0dV6GRDN7JX+em1Pvo9MWE7HEaZinEGPdFaniPjdr7JL9NuqfTFydt3zu80BgkgDYdB8aUgg1eo8KJKrdMnWLImXXPBAYPU5tQ85DMtaor3Z6hCv0XHDMeCmIbrYaRsvB05U6KQhJaoPxyFKn/uCyvZh+MKP0lis19LGn1fbe4AOlen1Zzf6b2NX4jSqcaed8Nc5iUvFRCL2oCr7Oq1NH9wR6hT2zMAEB9CT0ZbUTt0wlw/LK72h7oG95e1RNWvsV6JxAnl8odxjKIq7+6NE29p7U72WkmiVysOWp0U2mnfRKNlWxAkNffgrEuxuTUWb5uUHeFkj4AJ2saI+XdHk26uR+OXImOVUWO2N/rc40jxQFC8Sk59F1t6drdDuhrXnEtI+lwwESwacKZcLX16O6UAzCuPp0YKYTnmSOYaF7F8AvZnMRdvVPe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 01:24:09PM +0100, Miguel Ojeda wrote:
> On Thu, Feb 5, 2026 at 12:58 PM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > What??
> >
> > Alice - can you confirm rust isn't exporting stuff that isn't explicitly marked
> > EXPORT_SYMBOL*() for use by other rust modules?
> >
> > It's important we keep this in sync, otherwise rust is overriding kernel policy.
>
> Currently, Rust GPL-exports every mangled symbol from the `kernel`
> crate. To call something you would need to be a Rust caller (not C --
> that is not supported at all, even if technically you could hack
> something up) and the Rust API would then need to give you access to
> it (i.e. you need to be able to pass the Rust language rules, e.g.
> being public etc.).
>
> In this case if we are talking about the `VmaRef` type, someone that
> can get a reference to a value of that type could then call the
> `zap_page_range_single` method. That in turns would try to call the C
> one, but that one is not exported, right? So it should be fine.
>

OK cool. Thanks for the explanation.

> In the future, for Rust, we may specify whether a particular crate
> exports or not (and perhaps even allow to export non-GPL, but
> originally it was decided to only export GPL stuff to be on the safe
> side; and perhaps in certain namespaces etc.).

We'd definitely need to keep this in sync with C exports, maybe we can find
a nice way of doing/checking this.

Generally we're _very_ conservative about exports, and actually it'd be
nice if maybe rust only provided GPL ones. The GPL is a good thing :) But I
guess we can figure that out later.

>
> Cheers,
> Miguel

Cheers, Lorenzo

