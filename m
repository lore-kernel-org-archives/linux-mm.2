Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD4CBEC1EAB
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 12:18:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31D696B0089; Thu,  5 Feb 2026 07:18:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F49D6B0098; Thu,  5 Feb 2026 07:18:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 182476B009D; Thu,  5 Feb 2026 07:18:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 059BC6B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 07:18:31 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B4D5213B16D
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:18:30 +0000 (UTC)
X-FDA: 84410305980.03.F3EACFA
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6097740011
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:18:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=HTcgCeib;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zKV6QfVU;
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770293907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cVePTIoc4hrQ7oOCZyJpR3alsVMa2hmP6sBWMddPcEk=;
	b=KltnaieXJTfeFpFkci8NiMDY30roQv0BV/lAHLTCZ2DwDrYGz65E3DqTE7oZYr8kA91nW6
	Cer/e+qaM/292ekKP4di9Z6Ql8GfCHwpWVdxAXffef+e4iS7Jgt02bgskE8VSaSO5+KdD0
	L3p5nUeiJvUIs9wJAvv0DVSkFp8PT9Q=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=HTcgCeib;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zKV6QfVU;
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770293907; a=rsa-sha256;
	cv=pass;
	b=OEYpD60fanQ66R96IVR5bwq5VjKLpxM7Potd/eBfMF/4q65iLLZo1cCJKsUYEfnbCJE79k
	0uDjjhtf2maTwljo5SaL8FZz0FSSKDfp6PeP57vJiFgo9Tr7Ab6XVuxeDwJVCGpVMtZIBM
	amg92etkxvVZ9vtRH86mpBHYVJtBD3E=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 614NALDt3258521;
	Thu, 5 Feb 2026 12:18:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=cVePTIoc4hrQ7oOCZy
	JpR3alsVMa2hmP6sBWMddPcEk=; b=HTcgCeibcRAz0iBonZFSeNO3nycORwSg7l
	mXuap2IdzaRWQOyIyQYtqvF4OGubpDvb0Z+EanvocA1xTUMJkLB8SFxtnFlgQcgi
	/sagivmrV0SoZiXO4+hwTmJfUGceQjOOTCHynttP0uqYMBIX2TZCxqZJ158Z1RDT
	vKgBJ4kRf6tjol8tVWHDWbLTX8D3SggYZHJNpeeivoX9lvbhdMfZQ8DVe2uWs721
	Iqjytv4YVlAIGUU4vgfBLjqY/ULMyej/UMfT1A3m6Q6tM91NJ0S+NhvfFwZoo5SN
	2Cvebmzkbgms21KnEhbWsSJwZ/eokOew0Sh5hZWHMdN0iI7Rku8g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c3jsqkj2x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Feb 2026 12:18:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 615A0dua023921;
	Thu, 5 Feb 2026 12:18:06 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012060.outbound.protection.outlook.com [52.101.43.60])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c186d3hjs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Feb 2026 12:18:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n65SYfdmI/c3SR149m2+B3x12wOVq+Oyzz7PmjNyjRSjBYau19TcSNr8WT9UXZZQDJyLQvO0pl8dREKdVAc7wzeiAfyErXWNk7pi8lOXmuHBghR4TbgUc/BQavREKOb78ikcRKoUpEP0oQw5F4kCycHW6szZF9bXa4yo8n3Y0dIxUdf2IuIQDgelFjOizI0eNKFAGLZpmi9stI0emy0RXkrKoIOXf9aXzKrcQoWwGLi7QTKpqedCPRVzjyespjRQKkNZ5L3+JQKXeyRecF4dKQ0LusdfZUvQgPBo3gYQLCj1NYss3qQKWwW/vxFU/dDLNKIuk1lg/iR6TqtKRErvoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cVePTIoc4hrQ7oOCZyJpR3alsVMa2hmP6sBWMddPcEk=;
 b=JD4E3EWwcOLJuFZH8J4/L1mFPEC+igRoUcGJuyY6VKDPMWCvHSvjVBDXYKS6X8Kr5CkO0hyKDCMdiWKti8yqSw86UCT6YauHAUmn0E0GbL6q9quoK6RqRlcmV1g5OtJ06Q6V0z0byX3+1Ewcky01lNSyzhhlD/HLXQlDwT3X55WIoFw1GZtFGEx0v85NkVLdpKx7CUkuu0oiEhDVma+2g06dnubTJFHhoPFnjftvL9Yqqk6Alfc7fFCLDCzClEDW4TUbsZBwRLIXKGK530bSNssDjEQiCfpR4RcWo70W+eL4AccZFV0NpiFAfSC4vRcTefY+YH/th1wQ7NQt+9E9tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cVePTIoc4hrQ7oOCZyJpR3alsVMa2hmP6sBWMddPcEk=;
 b=zKV6QfVUQHTyyBeuK+AkVAVYl/APAESGN+oHFPGqDFJzWbey128db3lg4TUi6djM45UAUCadTh1yf8E48rybGQ35qdZE+y8r8R9bZ4nJqCbP3jMAvYA7u8WZM/BZXvdNBWRmIP5iit5sE9z1ZQSnHDwGKKNBkvpXrx6TniW2sWs=
Received: from DS0PR10MB8223.namprd10.prod.outlook.com (2603:10b6:8:1ce::20)
 by IA3PR10MB8489.namprd10.prod.outlook.com (2603:10b6:208:583::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Thu, 5 Feb
 2026 12:18:03 +0000
Received: from DS0PR10MB8223.namprd10.prod.outlook.com
 ([fe80::b4a4:94e3:f0bc:f4c9]) by DS0PR10MB8223.namprd10.prod.outlook.com
 ([fe80::b4a4:94e3:f0bc:f4c9%5]) with mapi id 15.20.9520.006; Thu, 5 Feb 2026
 12:18:03 +0000
Date: Thu, 5 Feb 2026 12:18:02 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
        David Hildenbrand <david@kernel.org>,
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
        linux-mm@kvack.org, rust-for-linux@vger.kernel.org
Subject: Re: [PATCH 3/5] mm: export zap_page_range_single and list_lru_add/del
Message-ID: <718079e8-dd1e-400c-9b81-4c833722c83a@lucifer.local>
References: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
 <20260205-binder-tristate-v1-3-dfc947c35d35@google.com>
 <02801464-f4cb-4e38-8269-f8b9cf0a5965@lucifer.local>
 <aYSH5KG36fVQFePL@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYSH5KG36fVQFePL@google.com>
X-ClientProxiedBy: LO4P123CA0487.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1ab::6) To DS0PR10MB8223.namprd10.prod.outlook.com
 (2603:10b6:8:1ce::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB8223:EE_|IA3PR10MB8489:EE_
X-MS-Office365-Filtering-Correlation-Id: ecf2d542-880f-4476-aa5c-08de64b09c22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sQSefAuH2u0NWCY8LlPz3PxDLCD9i4eC3mNgXTCFuta+8EZi1qbrp+u/xiDU?=
 =?us-ascii?Q?rI1lSBNcM7+p3nrLka+Xj/leR8bD4CLZi7hA2vWTs6zQcXzbh7JZ1DYJOmDV?=
 =?us-ascii?Q?b/YmNGYgawFc8/NlQmLm2TGQTHiTmLSMMIUm8lPh59FcNAq4phIOdqOSffPk?=
 =?us-ascii?Q?jwYJn+Gn5S5IIqFYsdQRfVXifDtoDFdt6R8+U3BRsR5SCvvFXF/q6MYTtOyT?=
 =?us-ascii?Q?51MxBRhzytmherWwO6ruftvBz2/3YPB8CcFWI5L40DiNvG9eE7IP874bffjd?=
 =?us-ascii?Q?gF/UD5LPfCy5nkb8rQqEN/TjOSr93+u4PuRjsQPsstwDDewlfxb3suxw2Hqx?=
 =?us-ascii?Q?dGIod6chiVW4a8/mHrfK76f23qJ6bCnSyzZYz0QuIW0CKbAOcmxfZYHnZWTA?=
 =?us-ascii?Q?aNtjtZx4uzfiGqzVOXPw5MyGnz7gTTcfzlm0QnneMl9imX63BZZRVIVospI/?=
 =?us-ascii?Q?JR/pbcK3KSbXyXFVVPH4PMxbJklT6wKjIZB2BMt6BaQ0IbjkHzOEincGQkca?=
 =?us-ascii?Q?mnCNA5srN+8IcA5zwx9gRaAbEMfVZPASJntgQRp0/yU5qoFQKcgy0fSrip/f?=
 =?us-ascii?Q?4VhEyB9JX+B0Tq2eeUEbhDUMu6gqXswjAcXzGipvlXHws8H3NhAAEttzwdNC?=
 =?us-ascii?Q?4hYxHu2Ay6mxNyXNKnTE2n+E9hVkh2ekAR3887MtzqpYjcnRWd5vDEHDNRJh?=
 =?us-ascii?Q?Q/8lk+WpGkppnmP4snq+vh7DC6haNBFXJcUncGIN9vljQPYa0Br2L7+2w8So?=
 =?us-ascii?Q?9VDv8qqHKXyIJT1/KFNJM2d0xmZlbaFbkKNgGnZD+PWadOPO0d/sa01J7eEs?=
 =?us-ascii?Q?8WDpsOM8xHGF7lX63BdfGKaqyhJC34k/gTHLPtWRK0yn4RRQ+uS2lTr7kDtZ?=
 =?us-ascii?Q?8GWAs8c2EP8tbuAN1QBbPVD5ESAJHtD35Kcf+aWNCuP4HkfumjntlCirKahX?=
 =?us-ascii?Q?8wOQva1h0qz0M7V7rcNHFR8akr0vneK9iNJQzvDAegSOuxYI8aM+m6Rsb2sm?=
 =?us-ascii?Q?HgNRHmElibpcgIhNJObUCCeTuXpsxvWugYI7tmkQzFavLhuEbzkq20cr+7f4?=
 =?us-ascii?Q?VMb0bPpOpK3Az4cP7W+53xcoY0eEBTQYZ1oXhBxAUvh7LBbLAOmILX3E1xST?=
 =?us-ascii?Q?nuRKWONJtSUH6sZZEMurAI4cGHOV8Y/brslos9HDk2p2Z7yhtC+zZEWiNm/i?=
 =?us-ascii?Q?GZ2mU/xzUKX49igsZ3SDnuVYJiZRO2G5lAy0S/4PYbIj/tH0M1vW7Bf6YdT5?=
 =?us-ascii?Q?BxAuyX+tN4i2EWsNZncTbi+y4B27AfTTVKBd8Z0b7zfIfbYXTk33DgLDDG7C?=
 =?us-ascii?Q?3w8iGK0XvNYJKGtO6BSdLXLYAUPYODARIEkDvMENLxrb7uhxcuMdugSSOzJX?=
 =?us-ascii?Q?m9e9zLj7zYB4M8hiNUBBFFLA+iQQk9MiwrLiSb2/QKOTC3WMfoB3qMjjyPPI?=
 =?us-ascii?Q?2BrXjnZ78jv1YTYXfvB5OGFAKESlV5CwoYIpm+AScQdhKJ3ysZfDyDy6zBEv?=
 =?us-ascii?Q?Di9hkRQ0BD8TB6OGJsFBMyZvrTwt8y1nDYkP6qH409/zIGlFVyNTFn4tBCeQ?=
 =?us-ascii?Q?5qGZqfCV0Xlmlm3Ti8A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB8223.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GVXh96CSrRMYQ4AeLqe6ytg66gRTDnZz9k358L/eK0Rqbi3OYqqagSSFEhjJ?=
 =?us-ascii?Q?JxW2nEP0sJyCbnS1Bx4kVj8hHUq27KNcZMT3M3xZf9gR1KHY/DOzOksmi9DT?=
 =?us-ascii?Q?Ns0Y8KZc+TmIgSfsN9owFIY6EEA9BQSTguaZzgSazg9vSABDXUcPUGnVkw2t?=
 =?us-ascii?Q?961y/QANUalfDCj8o4rRF2YTDjqji04BefqYrWjNm4QdwiT/GcV9AEIoigBb?=
 =?us-ascii?Q?aR+P+2/HGzEB+RnA3avBxyCtc30alUz/QNjgx4qXHqY2Ot6L86MVSDsIrO5w?=
 =?us-ascii?Q?U2F8Bjz3ZSxa/B2kkaBzpy1nFY8qadVr7pUUwVyGHL6Q9N3cITZO6XvStoUQ?=
 =?us-ascii?Q?AyGV4vqXNrvIAM6herx2X5xBuqC9G3SLotTZKQf3gAcv6jFDTeGbUUFYicYw?=
 =?us-ascii?Q?LCC0InaXq3aNDDHTGmi8HJmfdVgiR0DBpc1ZM1IpISULrUIS2k+Soy2VH90d?=
 =?us-ascii?Q?qZ6QzRDRcV4b8fAo0JtxcKibdWP1zOvPp9qEvOMPbbOjR5RLeqx+NbA4WWC/?=
 =?us-ascii?Q?ARQnRTMTjJzQ0RcJcbT4f2vLoFwA1gCHL/FIqUs1d/WREewvna8Bj2nwIYb7?=
 =?us-ascii?Q?baTNLLk8oG7ObR3Vc1x3H27NNdWWYmZD9A/d0H6mRvSqOjjtcJotB8AzG2K9?=
 =?us-ascii?Q?+u1bIdjQAb+WbYik/TctKWPAyCmlmhATXxD1OjEWr1/Le6nf/F5vWbqub9B9?=
 =?us-ascii?Q?c0HZkuCp2hZju2rpvMX7n63W0+xUs8JGJYWBChX9QWXJzPsflQQ0e/YNz4ID?=
 =?us-ascii?Q?tdTI4x3T6JP0y8/xmUkpMFHKklxclkAFFvPrADp9I1isQmxAx2IX+JTvo9LW?=
 =?us-ascii?Q?zBnDRrln0YjRrvlAM2lwEUTEnu6MP30IsOYOZoC06645taM/UbG8gqauvvLr?=
 =?us-ascii?Q?SbJKVkMGxTvz/+mEOQNwFMsI5nABlyYX0Ezj/+dSCdSYibiq4NeSo017oZ3E?=
 =?us-ascii?Q?ts0XLz7EZKwpqE4kB/gdkSarDV6TvdMDoYCd9vu6EQnRNcdAxca345TU0hDL?=
 =?us-ascii?Q?++vta1lhCgow89oklGLokOd4k5MXiOxqxTceHDPUShWtgRPnVjjk+OW7qQaC?=
 =?us-ascii?Q?7cOyMmnKOB1Ts2XJW3rDyN7m20KAuaV9NEO/g2DsEVsPQQguKih7bhweAj6I?=
 =?us-ascii?Q?Lm6Poh50WVEgzThnybS0iDUzhZHeGhJJKLCPa/rZzDju3B81c9gsSB1tboPU?=
 =?us-ascii?Q?HB812raVb8/RJUwIXcwZjZeiAoH143KSAV1rDh8U0LBK+1fQY7rLBFuWnO0J?=
 =?us-ascii?Q?oL8P6Q5tqoaKjHIfd3PVPj2PTC08jPmvsssKmMDpZ12NIhtVkObhdyT84SYA?=
 =?us-ascii?Q?CZ0z42QNMYf5z9yAwoyzE4DGoCOABewIvwTgZYvOjnK67NQU42wRz8pzqS8J?=
 =?us-ascii?Q?K5c9vnhiZy6Jd+FppxbX9CfwsNXzwqE2maZvgS+6t1Sj7bNdd8G1iX1zqg8N?=
 =?us-ascii?Q?nm6AMq4eDbyaLyBD+Rmx5WuqCS7ybnGJYpH8XniYxBVPJmJhzeVgsKSikGlN?=
 =?us-ascii?Q?UVPRUttam+1XI8v0kOxj99Yhxqq+wdcFe3mGG48Iu0xVbhbu9tsnjzF7j6Ld?=
 =?us-ascii?Q?K+7qs7FlFaCdCY/XqSCZavqCFVmgSlpU+J+s5aP0ieFX6nrIy71jV/ElZPwG?=
 =?us-ascii?Q?oVIBNDAMQ3nOqFmbcyX8zRRPhVidmnJhn920lZ6Db8zC1GrbXiCUKA1QInxN?=
 =?us-ascii?Q?m4qA4yzflVEZHLFE8yokcmrrDAGcqANmDXee7Yc2cBOm3kiOqk7RLHmAEX7U?=
 =?us-ascii?Q?1IMJ/Lwrz7HWsW3ZtOJXE3MVLJ6pGx4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QB7m/7FVGW3hMbt3v3HKti4Q7JsDNux+v3d7/Fs1WR36nWM9m57QR9oI+gfGaAI7aNE0jd2HZK+rbdRmuaSOaQuFlPNh4hGqZuFt3aXnCfw09tvSLAZVnz2MkfrHcMePlBKLLFlry1KBVqpaxuvcqURKwoOBYmgPPGhzt7EDO7Y7b97W3WeNHaZtyDsKPvcQz2ICs8r+DC9aoNfUsPOO8GqbCf58mS0YHSZH2xEMrmpCSnmzwPYapmsvfmcLNG4ZWgn44ZMJBKaNzFSzb/p82VIQJhJCrCV0YHa4gvs5vqJ/5j8XdjZLbOA5oA7JSRI4KeW2U3ksCRgvNaHUozH6CQse+Ez0MVgInyUphfEyo++fM0GcmAfz9r0hKNjc1ZEq2xhsKE1WXzdCeSSTd77yU9m6ir7kdwbs1fBps6/EFlIA5I40bfKiZI9CbD/IXiIdQR+ckoz4G+Tq0METzwNAmgjW2O5NoxE5S9Vafa6tI5TGu0GcqDr153tnTzYWOYP5EjgkV3i1gIMQcg9gURqhbYtBA8n/K+RuccTalyTmVHw7GFiZArreEiQ9woimB7QRC60euXcTr794NepeCDFlfyRzp4OgyNHooPRhbhL9qgU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecf2d542-880f-4476-aa5c-08de64b09c22
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB8223.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 12:18:03.0784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ny89ItsEGJwU0pbscSnYRbe9QE3Z2ktPrYhZuz1btg41gO+WAIiJMh6CZaapKaAJU/CU6Npqufv+ahsEoVUdDdoTpZFMOM9MD8/hmDZ/f6Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8489
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-05_02,2026-02-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=702
 adultscore=0 suspectscore=0 mlxscore=0 phishscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602050091
X-Authority-Analysis: v=2.4 cv=Db0aa/tW c=1 sm=1 tr=0 ts=69848a7f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Br9LfDWDAAAA:8 a=xNf9USuDAAAA:8 a=p0WdMEafAAAA:8 a=mNfDwudMRzgtxQzGBBUA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: ncdl-DJDaYekXBxzWdKCnqNt8aWJiyIr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA1MDA5MSBTYWx0ZWRfX0ASiYUM9b7ef
 4Xc8/IFZMuqRG5s7yYLlDV10c0//negsjQjgr0sc/cVrvrrNmiTGbsXrnlj4+8f7FsIB8osfnHA
 /lyyvWdm3lQfdj9oCjWKPo0SbTsf0HrKzfPBDGyreg37E9j+rBc7s+VuavudNT/dQMzsTJCwr9R
 tUPNoql1sJuFdjdZEfv9JyUOm+bGCqLSLKrns9KFxg9xvfDZL8IW/HwQqLmiN1YcSnRVfJ+6zbe
 f/nCgzU2H9rPbvC+/CAu6QMFiJFggbyw+YIJbca88wuQdDUbXTh8DMvUWQ1IhNguiqqdm0ngSOa
 nobbJNwdCDJo61DFMTwMkMeDgFa29cb70niH2Sd0LWdg10+Cez/jM+5qil3mDAajJiA8NWvckwK
 zpUivyT15XUJHDQTUb3MuWXVDDwmRXlsiBNzWUADNcithCtVwJytZmynEekISopDsspNzGyFHcL
 jDpU/VakBAzXrsSEUBw==
X-Proofpoint-GUID: ncdl-DJDaYekXBxzWdKCnqNt8aWJiyIr
X-Stat-Signature: dj6wgij34n7trfiux1suhc5nkxpnm5oo
X-Rspamd-Queue-Id: 6097740011
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770293907-123166
X-HE-Meta: U2FsdGVkX1//i3LzBK07RsVxS23MYfssu6yIvUYYvny/32cEnN5Bd5VJXOBNiVqvGMXZZAwolOvWZsMP4suPpBLT/ymXn4Z3qRCq+AjGFiYSjqZhUElpp84KCKAJG0QTtgmyX6AQw3mMwci7GERT+hN5GPUj88QqymBX0Y00UvX2UYXPyiCsga0OixcgFrvXlj8qPL5KZd8uvRnx8Wrad/SCT3sVuJR6MhPPrGzKSrAxTnPAQAFLU455WJ2aphHTf7hcqEyr77Ea5Ht95bz8T8hOZcsC8U3yv1t6S3PKxUDwKKMoTEzIyJRx4VLyKypi04d2d13RDRsp598sJPqDueWWG2gkzP/+jWV3ldzGYPFkMj8vo1YpCat2fFG/8hdcMaZ341QknDwyrk6Kt9DJ7IETdw8cN41/4lYhd/FZ8ivHyVO9GlTepees2uf2F53vxRwIP0wexCPegBPdDmWLAGzaau5dA4E3rEuy7p2+e238GS8H5KjFkSvPLzgIGxO3kyeu2pTXtcnBii0ZWswda9cboYIbZiYKZwWHyKpN1YNYgY+WIWRUzy/ysDw47PB29SP3qqGSzUwk+2uuDW2Q2jaVjmwWWruHPBmKMS5i6YEEae6Ze8zpOq6ZUTnybWuGVaEZD4vBfsksk8rSdaGcmiKDKT3zIl0OSTR3XYSIFslJEoowoQyB6YvgNhknYTq8NUScC5Y5FHExHtA/0ZZFtuFXHeQUxPDmGV0msZjM6ABPUcOrDCHxu52l2E6/9iUYluGkqNv/ZJysQCcXoaVpYWzNu6XgMHVA4Zx0k3wU6Q9mihEHp589fTH398/SA2sSMswGO/ZegV7SKjzC+pMZJYKfaK2ahOE1tm5xiByPfGqyNQMIZpg3zlnt9CLq83L4b1c11ac0YUYNqhtP7O8IhYUPm2df/Aziyi+ruBOaG3mN111LXe1x1Kc8HMCJIrn0HB/vyaMIMBjsWGbAZVl
 uKiTGU6O
 i/wS3HxNOvMEi0Obg66aq3LzsOZs6be4zoMoRvm3tDG90HS81PiavGpJngBm/4plusYyPjRLAj5/6kD0etJGCcnwQqWHi5ryOQqDM4gRmoDgpc4l2OyRfjvfH61c70bIqkMuJ0NwBDGpDs090+l0zRN2GwELQ+tKODlKyddrJB4w4wYeDswrumqrsmsJz3JVNq0pC+QyG1RK6jZmTTTTIzGBzdJ8/NW6bi2xO0JtbTIMUEejqI6wn8V9sm6RRH2pag+u64VRiRulaVWlLg+QIc+wLRtyp9MNKQ2GdZWbwBMA/1PFmXT93d7uQzfKZO4n8jcSsW+OZcM2qZQE28hgfeJIjVJtl8T9QMbBiQ/SWauQabPEKCAOjhKB/x8FCuNj+1suUo+gIvJODGEM+MJx5tyRD0dN3XnOF14jXdr/JN9020vm/oA2r5nsBN4EFS3GIIkMNv1Jb11jpYz+OSUW56PIJLWWZeOiRW4HFaKqwaMOflSKimUv480zwsz3/BaXhbzcqpEMKBLeoqDXFQCtEgmRVqSVT+Q3PVPT1VotGCTybT0jlfYT69afl4XUi4TUuBfvstUH844mLffRwVqjaFe6xGWllnmQPZpVCHYaiOgARcYayfCSSyhoXC74E5n8dRTCqjLp2ZITxUNQT2+m/+zKj9Ea9Xo2cFxDE9utSL+nXiMme8lkDsjFU+l7ZzLjbOgh3P7QwuRectTdDavlN6jYbPSmOxcEh29vOsgvDDZu3xueM4QMb5EH+Vn+ZxNIQnJzKbD6FeTrNQkGUI/zq/6ikyw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 12:07:00PM +0000, Alice Ryhl wrote:
> On Thu, Feb 05, 2026 at 11:29:04AM +0000, Lorenzo Stoakes wrote:
> > We either need a wrapper that eliminates this parameter (but then we're adding a
> > wrapper to this behaviour that is literally for one driver that is _temporarily_
> > being modularised which is weak justifiction), or use of a function that invokes
> > it that is currently exported.
>
> I have not talked with distros about it, but quite a few of them enable
> Binder because one or two applications want to use Binder to emulate
> Android. I imagine that even if Android itself goes back to built-in,
> distros would want it as a module so that you don't have to load it for
> every user, rather than for the few users that want to use waydroid or
> similar.
>
> A few examples:
> https://gitlab.archlinux.org/archlinux/packaging/packages/linux/-/blob/5711a17344ec7cfd90443374a30d5cd3e9a9439e/config#L10993
> https://salsa.debian.org/kernel-team/linux/-/blob/debian/latest/debian/config/arm64/config?ref_type=heads#L106
> https://gitlab.com/cki-project/kernel-ark/-/blob/os-build/redhat/configs/fedora/generic/x86/CONFIG_ANDROID_BINDER_IPC?ref_type=heads

I mean you should update the cover letter to make this clear and drop the whole
reference to things being temporary, this is a lot more strident than the cover
letter is.

In any case, that has nothing to do with whether or not we export internal
implementation details to a module.

Something being in-tree compiled gets to use actually far too many internal
interfaces that really should not have been exposed, we've been far too leniant
about that, and that's something I want to address (mm has mm/*.h internal-only
headers, not sure how we'll deal with that with rust though).

Sadly even with in-tree, every interface you make available leads to driver
abuse. So something compiled in-tree using X, Y or Z interface doesn't mean that
it's correct or even wise, and modularising forces you to rethink that.

folio_mkclean() is a great example, we were about to be able to make that
mm-internal then 2 more filesystems started using it oops :)

>
> Alice

Cheers, Lorenzo

