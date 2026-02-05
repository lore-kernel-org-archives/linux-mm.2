Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D216BEC1EA5
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 12:11:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2032E6B0092; Thu,  5 Feb 2026 07:11:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B0316B0093; Thu,  5 Feb 2026 07:11:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05A7C6B0096; Thu,  5 Feb 2026 07:11:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E28696B0092
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 07:11:09 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8ADECC1E53
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:11:09 +0000 (UTC)
X-FDA: 84410287458.25.0D1D8D0
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 24CA31C0004
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:11:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=l0IQuSvb;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Kf5mYo67;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770293466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HSyyQmo7Dc+72qCBP+PM6DefsdKwc1xBpqv+s0TIc8w=;
	b=sjs9aKFULZpsQMnQyKdma8b0g+MAvJMPH8Bak2O3NzIJB+iHvDUobBYuFcB0JzBfYO/d5C
	ZqxRjOvjNcar5sU5tO47jWMDe2p4Qnv5oQcQoOzZ4Kaq97ljAMuZ3r6n8SkyDLw1Rl+QFb
	TFMwrv+0TddO1oY3k8Qe8Bsic/D0zzg=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=l0IQuSvb;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Kf5mYo67;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770293466; a=rsa-sha256;
	cv=pass;
	b=qU9JZnU0L/LdC0hxjrgT1tsFuY+YIkrKC7pjcx9RvwlrT/isefDeL8AZtjGQCRe7pCxNKj
	OyJ1DcxL+30tuK0qJX1PrdZOzu3VaggTVdcW8TRDWC9njrdh4ldR98HdozWsd50HYbSY/f
	dgLl5nL2UTGPTGC34kI1KG0BeFJW5FM=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 614KfDgH3032801;
	Thu, 5 Feb 2026 12:10:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=HSyyQmo7Dc+72qCBP+
	PM6DefsdKwc1xBpqv+s0TIc8w=; b=l0IQuSvb02SO1ekb6xaC/5aD/Klmlp5WEd
	PRKOapOhfbIhG1Br2moad3w3TmYAVJ5iogEBHJRlsVBfZoMuNTjrvMyXupr1D/en
	IUL+IAz3e0kfumA3TgqK3A7ev2sjZ9FmkbJkJVWxCntEKVJ6bFkH8HxwdLkLXfqb
	58yVG1qWKxUsILjkLOLtUCfhe7tBCARmy8zqoqByXzKwnaK7Rcgnw0SE1tSx/0Aj
	YZtjo5IfCPovqH4gcnTs7dqXChOiiTcahcphu99guIUuR+hBoGttFk5P8iKpg9PI
	nB8/ZLilY0wRBJ3gZ6HYxHql/Vnrrxz6bnHR/8GySoReDXNKiZZw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c4dc3rw58-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Feb 2026 12:10:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 615AVOE5025774;
	Thu, 5 Feb 2026 12:10:44 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013053.outbound.protection.outlook.com [40.93.201.53])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c257bq06t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Feb 2026 12:10:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QE1Km89BAJs/1a4uoM1xVJ4WJTw6i/vmKRQ9nMV6sRGfZ4B6GWE41n3YKD+KDAex+Tthtpfxm1Mya2cIUDXUKl8xBngpGC7PAqwqztjFnFE/o46dtwrUHRkMub8rQsYvoRo0V3dm6ULXpKsYoFSsxBdQg0ccTrgYXvRnWSHIdQVbnKamBtjVM0mzgB6XhbQtZt9h71uD23lR23uEmU6X1EwKVFNw9vRM/+DI5vk6TmddeBrvYttBOB28+S67A6aWQ0sLGEQj+czjZfkZNgfqPj/WL05eLXkqZcKFkUtfrm2Jc2MfwrPkrHHffMAG7mgznOp5og6zEc/+zOMgC58ESA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HSyyQmo7Dc+72qCBP+PM6DefsdKwc1xBpqv+s0TIc8w=;
 b=CGEv7U+Tlxr0qVHu5GotrR1nxJGnSZsXNh1O3SCiMNzKRcMaP3S7ea2Ckdz2+Mc72cAqnqlYWIJRtCIMX54JAPzBSqyJA4U+kIfJ8sxXcZN4PqWbAZtP5rAWOUSGA0ENAM6Azn3GVqk3matpctRp9sxqNoTq1u6itpUOckBjb6saSR5bF06DbOqJHFjeCmi81YICtHyEIfMauxNX1kvwOcNIMvz2cy3fXZb+t3bHHDvf8U2oWDn+7p6vUWUMWfnDatvAW4DmSxVrR3jwXO3TD59T2G79HST9FXOuiTjepbH7nkZ7i5skXx/xca1rM9iyPg+Kq1g/u+LKqGTh7WvXzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HSyyQmo7Dc+72qCBP+PM6DefsdKwc1xBpqv+s0TIc8w=;
 b=Kf5mYo67nBAUnyW9SPz5b/4Y7xCDwWkCy0p5OP/dN9vu4bYfC5C7HMQqn3hHt3NxznctHXyWZdbXhL0GFeAVBo4DAdCHQLCUGjqaJCBZy0yjISjmMGiSqADeGcRz1oX55/5E/qwrE6YkRHXsMZQ/KD67Us2X94gTDvx1rku7ssM=
Received: from DS0PR10MB8223.namprd10.prod.outlook.com (2603:10b6:8:1ce::20)
 by IA1PR10MB6219.namprd10.prod.outlook.com (2603:10b6:208:3a4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Thu, 5 Feb
 2026 12:10:40 +0000
Received: from DS0PR10MB8223.namprd10.prod.outlook.com
 ([fe80::b4a4:94e3:f0bc:f4c9]) by DS0PR10MB8223.namprd10.prod.outlook.com
 ([fe80::b4a4:94e3:f0bc:f4c9%5]) with mapi id 15.20.9520.006; Thu, 5 Feb 2026
 12:10:38 +0000
Date: Thu, 5 Feb 2026 12:10:38 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: "David Hildenbrand (arm)" <david@kernel.org>,
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
        linux-mm@kvack.org, rust-for-linux@vger.kernel.org
Subject: Re: [PATCH 3/5] mm: export zap_page_range_single and list_lru_add/del
Message-ID: <e7247f3e-8a88-4b46-91ba-cb73cce1346a@lucifer.local>
References: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
 <20260205-binder-tristate-v1-3-dfc947c35d35@google.com>
 <02801464-f4cb-4e38-8269-f8b9cf0a5965@lucifer.local>
 <21d90844-1cb1-46ab-a2bb-62f2478b7dfb@kernel.org>
 <aYSFyH-1kkW92M2N@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYSFyH-1kkW92M2N@google.com>
X-ClientProxiedBy: LO4P302CA0026.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c1::18) To DS0PR10MB8223.namprd10.prod.outlook.com
 (2603:10b6:8:1ce::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB8223:EE_|IA1PR10MB6219:EE_
X-MS-Office365-Filtering-Correlation-Id: a5f695f1-2025-42ab-e67a-08de64af92fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Jdet/Y+EcxQCOQXpkJmaelzAsIR/LlRw9JJrmRgWCPdjguQv5Yx07KAcGPMD?=
 =?us-ascii?Q?G4WzG+7NEztiyMvaMTh5UeeJQSjAu34Pjoy+Mh61ZnBCV+/vgxYTWvAw2Azb?=
 =?us-ascii?Q?j45n3PvHaPwlMPpqN4XWllwgg+miWYbzj8/x6H/gZv3qBRX0AEZKb7LoeHuS?=
 =?us-ascii?Q?bXuUexgA6ZXUG6XV+Q1p0vYQDneHqa+uN7QdjfZ1jYlWT0m72pAxQRcoS3MI?=
 =?us-ascii?Q?Y70k8yGtJdRjKFMKakGoyHvUK5V/vBB7ugk7ZHw6+dCrWT8C31/bvToA3DWu?=
 =?us-ascii?Q?xoAxP83FIudDa12UAfX1ukCu0LKz8O6gURSDn6lHleUsUtNw/DZ+duyor5uU?=
 =?us-ascii?Q?A0YWJUxxi5f32Dw3rV8Iv6hnqBGEgPxdvMdMIGY+G72g9oF5QU9PAokfAGNm?=
 =?us-ascii?Q?nkhu9SbXOiCCstTc4s7ww8AJFwJrPfznMO4jV+kYZCMQMkdKoC7CcU7xKlA4?=
 =?us-ascii?Q?x4hYqedy8MrDHGObl9y3o++ogOx+0ZzCz2smFX5Jnbmo4vqieYKdcWvVhdsg?=
 =?us-ascii?Q?MEB9BfAgKOliScDSru6WMAvFS7A5m91pBZS8Mo3wvlAPY2bebyG0TnZ4SP6Z?=
 =?us-ascii?Q?VmodShd50jjANn5LU1IbQA75d2E8maccVP5pPt9njuxGMd7c6GVCz+o8n9rG?=
 =?us-ascii?Q?iHJbx4p1vs+HXWPsuMkn/ZrTWz2v/R+KwcmDoIIjKmnAAjIpCSz9zytzmVsq?=
 =?us-ascii?Q?eI/Ti5X9BN5NMhFP6MyursI8FqO8EchzZPWHBgy5NE3rub9OvvS3wCy/Ho3k?=
 =?us-ascii?Q?PQMmXeWT8UwGVmhFAfb1amUzrZghCN1PH1uBTm9CwckOR6DeUTvIGuH5dn4k?=
 =?us-ascii?Q?xsHe7G6CcLx/Lpyxo2e2uiwVyHoL3u/l4eRi2/UePOVwy4SGedy/p9MTX8qS?=
 =?us-ascii?Q?gqJ51TumW6Ux8bbjcF03ft45wNd9m156DEF43maLS7A6N67nHcFl3TL3xQ/o?=
 =?us-ascii?Q?r2bcNYB9lUCG0s3rwVALOM4N1fr7+eOCu9luysIvOxNe28Re4O/8nqQ6aNoQ?=
 =?us-ascii?Q?QPl9GwpySfFB8YblKK6g/sLUqKxy0GcleIX30eHYc2ENIrUlyCeP3Sg0ezL8?=
 =?us-ascii?Q?oCyXD4TGQLC07DDavIgF7PtjqgKDrg8mpiSYSmgZwKvzXQQtKMILzowBE7jV?=
 =?us-ascii?Q?Rw9FavP+V+YAI2ZFnFZ+mYiW0wcJP3Hg280LcCDsBEO0FspvfA/ctaU/oUZX?=
 =?us-ascii?Q?ZZFrK5eMF/r8L8elYJmKL/QUS097xZ2lqs0EW++N7T3nAP9X6rhR9Yq8kx/k?=
 =?us-ascii?Q?7LANfVnopSFT38dajFQddjt6V8F/CPj4AfDws4TKhg1fiWvFgdGk1bl2BK37?=
 =?us-ascii?Q?7x5YN9NbgILtT/cdZytjgKCV4LRh0/dx7elYCgGg2VNN3IzxNgC+GKYPZCu2?=
 =?us-ascii?Q?uNwQiMhggCZcrY9UGjErTuiR69//9bHM3WMCKmPXmf+XVUJyznNKnLNs9dyd?=
 =?us-ascii?Q?1tbgxdqqlfrZlj2Yh0/hhuRE9Ll91wSKhQAGMBeX/YjXyt9pHlzeTcWCLk/8?=
 =?us-ascii?Q?hwPHm54L5Y1Q04OaSqjBkw889XgUCKX4y02zbCE7UowImH6WpYmWVqf75AI7?=
 =?us-ascii?Q?YVv1/i70Op26lq1Qv7A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB8223.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CrLvNQJKmlorLgH12y6/vsBL+I+nPIU7bdmAQLaIUPwchte+sZGi71IPAvW/?=
 =?us-ascii?Q?9MRv/K19W2qU6SwWicV5pdOeGwjnEh3LXWnUM1mlFtZqu6VaGxI3zI5Vn9M1?=
 =?us-ascii?Q?zhNlPOebV3bfK1zvlMdfkMV1PEKiTIPuTPaBb2VKsT1FACmtK5FVE8IhlHZm?=
 =?us-ascii?Q?n4s4ZTpzjzEAxLFxI40TnS2377cD9gmcMvPBvCHaTWsmogDarG1A8hl9KCe+?=
 =?us-ascii?Q?VKYkhfTWSkQRPBHVdH8MJHNnyqPV//jhO7/64mfeR+/GIeLt87VW5l5ihVg5?=
 =?us-ascii?Q?FHa8fj9II7Ll+gaoiZbjms4RTIaKfCvF9mGOglmiko2cuAB+lKj4LPoKfQQr?=
 =?us-ascii?Q?nGfpeJbwuFvGhDeAodtTP8Us60oqtsdd9Qgp4GBcQvgvUJ3JWPV0giYvzoov?=
 =?us-ascii?Q?KidzTnmKxU0xIuE11Sd9Ar9QPXcKjqGg3jBLBvP8EZe++E1lQ3nwGusiC8RQ?=
 =?us-ascii?Q?ZKnlbqXvJ2KPIE2bczft+RMrkJkV61RHFjciX0mYzfeg4E0M3xLkdxoQ7j1R?=
 =?us-ascii?Q?0svFpZmwG2GtTMHvJu4oXnwXjsfgkf+kNHOr0tmeMZrAZgxL7fmAxVaNj+BI?=
 =?us-ascii?Q?d7WevWP9nlsPdti6CqCBBLg+bNhfYo8f+54fVBcNVtOVIkySsr3CS/L9DQxi?=
 =?us-ascii?Q?C0p9qRBGjnpI/ad1aY/OmQBUGYZuiKttYz7UjFad3DqHNiSqHBF8lIo77Hau?=
 =?us-ascii?Q?SBgqKKLlPrjgHnc16pbg1NRxMAr3oDo9yrOMYcM8LEPtiCJH1iFzfsytk3Zj?=
 =?us-ascii?Q?9qnIdPnl8YfNOxtX/Ae2if70biXC/oWgEoeKY2uJFqoIkxqjdgL9eMleULEi?=
 =?us-ascii?Q?obarKWfI9ak1UOQ0hU771H2hmwBPGYm2GR9T065PIB5mPkGTmFQdq2ZJ/des?=
 =?us-ascii?Q?O0eGwJx8cDIm9XY5WKCFuRDmu97aH7NJP6mw8rUELFTdDsfmWYO6h+Kgqx6R?=
 =?us-ascii?Q?gQOcbSNJ85osxMb8j1LRLPLK+6LQ4Ya6auS8z1uD7gpzpbJBcYV6eNXe+WWk?=
 =?us-ascii?Q?mD8oBe/qRU3j5KfHQ3ShG44qO4CiePOGVHFi3WBsYEYTqfZuf9IguXFGQyIh?=
 =?us-ascii?Q?0ON39GIEoDRhiLfyzXJH2NG/84og8TO7g/+gRtdMx5vlDtAkly+yKO3CNKVm?=
 =?us-ascii?Q?1fa/c8YsXLks5rGJutw+S0KDxXcG3VwQn5WS3qAWF5rX8LVVIoa36QAOGnHN?=
 =?us-ascii?Q?VYfOWDqvgr0mLe9v9SG6G1BBM53YDvmRrksRzJASp6pOJP7zSjLMGdnooE4p?=
 =?us-ascii?Q?oIG57SUyyMXsRQ8t99CyT0aTrsni358y+DC38rRcAgTXB97ZKdmpeZBHM1dD?=
 =?us-ascii?Q?LuKDE8rb5qX82fa3KygS8fp/o1x6SJR01roRclL/Y7pHGZUx/lcv2kMdKwLv?=
 =?us-ascii?Q?xhFlHTwzwAyZ7JhkfGZQxVAqsmssMiBer0ezVCcYJKrXUaIuTcOPoWcLrXai?=
 =?us-ascii?Q?TZ81Tcio9MRK97H52M4d9aQ1JakmUhBC/B1vURgPd+7Ouc7cElW+tOf8gENV?=
 =?us-ascii?Q?vNHvmaE4WH09l5a4ce4tdrYRh+MIzz2XZmZRfpqOZifZRYHVoj4WSyEcOmEJ?=
 =?us-ascii?Q?gk6pvjymxcyVZ7RW6p8AVDNmMUnVsSOHHWOVbcJTAngjpslO394+g7nRCQ0M?=
 =?us-ascii?Q?f+6wvTDjeXHl3pv5TP/FN1fGTHn3JWOVvAOlB8tRDtBg4jT0IlFSPwGtEIpE?=
 =?us-ascii?Q?Gqxf6YDu9ETZW+HGsEe09tF+4yOWUwdkAunGlYWFq+GNRgBa/iVfQwwnOEW9?=
 =?us-ascii?Q?gVFD0aP9SdYT6JdiPVqM8191poRTaGI=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	I+Nd0UrijIC8Tbi9xAjtrco9O3GYrpxbmfo+RzRi6BVxl9InFGF7jdIEQHk3SNO5IBFfYXg0DXUNTlGm+E6GZmBTrigMRhw+o+xGWEmZSm5Ycozd84EyioQuHCdUBmyd/eFfE7pJK04WwmU2NFqGZ3eZWmAgYjGwgwXCWHa0hJ7+2+XzHsO5PVENwXDpBcVXeXNV+P9rCxIdBcuP4ItKuIpMEK18/2jkX+TSUlGIKegBoYcdOGG7FdaL7FT8198kjtpfiY5Cg75eoR07GiRWYycj8Ciw6XKQa2CMrlfgdtitvIFPZkpS5DlvYdridjvz74W5jWZ1j1DC2ZsXi1DyC8/3/l+IRXDH2sNQW2BQWDiAxotLdatDqyhnd6I04Lhfq80ncoJKwc0Q4Gv4QAC0gPfw0/0uU83h5sxPP4NcwIci30xbINr2EIAlbbqlokSwouHaJyzmrKbj7u55mYBJSSpxtzcDl0ckseJ+qh1N2r+0Z/qRcEzE0nVSn4KxrNQ4qDpzk+YpCgjMzwjJ1X+FWxGfClU7JDuXA3sB1DYwBcwMfHoxOuX0XzOEf7QDllQo9z63u2kNhfPnGaQ77F75QO+bxHnQkxbGB23R0vhRkqc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5f695f1-2025-42ab-e67a-08de64af92fa
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB8223.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 12:10:38.6147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EyJ7IydR/V7knNqtuHvnqwhi0vyFtr+O4T84YcKp7lvz+4RKAZh0RQPzdkH79mYg/+nIvNiV1Lx7IgP1CLiDYmdUUv/VyuzVDpFaPjtX+64=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6219
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-05_02,2026-02-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 spamscore=0 bulkscore=0 mlxlogscore=884 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602050089
X-Authority-Analysis: v=2.4 cv=SMtPlevH c=1 sm=1 tr=0 ts=698488c4 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=xhZCieq16BM-jj2j7VsA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13644
X-Proofpoint-ORIG-GUID: CLIe21AezCiiML15V65xBmupJoWbAehT
X-Proofpoint-GUID: CLIe21AezCiiML15V65xBmupJoWbAehT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA1MDA5MCBTYWx0ZWRfX64/U3R+UH7iY
 s5jSkcC/cTjIU75crGN6lpavLElagcAUjV9Qw20RewdkPMP5jXmgHD7RE37EZ1jA7ORnV6bKYAc
 1+XwtsYqLKvYO68hbOVZw6cw3E77KqcVEVSHccGJW3JUOOPfM4Q/e0sWLVlqe10k9JnDmqRZWv+
 IOPood76ctjUgPh4m9wyT1xqyDzMp/cR49vGvP9xHdC3+Zx/dx6qdYSeww1nmYoY1YU22Gj9fm4
 3nx8vU5l67DnJIAkoCjncXdzcvEFjPW35BaZpEjaMjTGAzfAYjIKOli1Wp2xrjKoNozSeR0JqMT
 /vfoB2/H/Ruufhk1gpJYvYfwJU43I22LngxXUvSey8oaKkaXpGNpSdOp7bMZZ0kqeptFTadKQ2m
 t4NiLhIavi6BoNSyUtCeyXkbL/6dSPDhghGAG9/JgYITfNbhfFCRLt0nQ48s5IXHr56piEJB1eB
 QpMRMUHs74tAZoNWLMUTYxPjuhLJH62InBjPLxhU=
X-Stat-Signature: fxt75oo7q6npriqsq67gqr3h3zqhbdfe
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 24CA31C0004
X-HE-Tag: 1770293465-771419
X-HE-Meta: U2FsdGVkX1+1cEoEK612LfIiG6h1wyUDYS2luRDsRjON54+t6uW2HIsIfdJTV31sjGe6kADMOmUqzip4YXsTBIoFPhXkQtT/z7HYqDhlKg8xZpuU72NvZfJpqBdTR590FjHKta6lJys3G9bEyMjPz5j/CPhIZiBbEU155cV6pUjAOqxiARGQVLfZUXgLWD3nzc9joBuvFrcuoJk7omuAzit+A3sMgcqigCUahJVw+RiaP2x0sXIfbnw7hwadZ5dE+pTPCeYGBOlEgEDD2jftzsW7k1XhtGJMPCTr7jfFyTZ19HUZSOqE5bFXYfSPp+HvPx9uDPrKL2+lXuPMYrOZaS/U41oVs7/1gtWJAyBX8v4/ge8OJ9dh9/4FTamKS6Q4zgvIjJUTRFMXQV3hSJMfo2+vxvO7Jx/Q673D2FhRnkuA9W4yEb3QSZ8Po7zjgrEnDvoJB/5wmeEJmLkffTZh174fWT4fGF1NvmEu3D4UcVnp2Xo7/+/+u4FhgJFZkVuNwmhk/HX0uXRxQB+or7ATyhwQPHHh94IWpWBZuxjNfVm7tCDORuot06tTXulEXXUDvFkKN1mE9wLG1Vd3J8AsTRAqfmrNIVQD4GxKmu+C2mbNx6jyYYgrE3ApC8mwmrc1phOD7WCMeFyXfBIZxk3ew5amaRvN7/V/DLwq7EmT95fJTvuX7olGKmQAlMALWq199uV0kzq3EJZjvrzxjU83yJedBFeXtlP+Oi9GA6ehTQ7YwwhIcPZjlu/hUw9Yhj+Ww5Nq1buH/obfdM1hJOBalpCYAeinXT4KjK/eQ4L3E0Uj8d5oY2N/HCyvLiR2T+nvt7HQLpBrNxFNf+kMvsspqHgJ2aP1avdb63EuAbOptrbTMUbgCQ0qEgfjBsjZ5luB4s4PvViXLuxjZKY5ZuUzS7O+dpGCH3/TXuVmrqIXJPj7hTcF7y09JHTGcG6AkXeKOpplWcwAqHTvMRZ9Lnt
 pNtF8HNx
 3XbXQFvV4Dp/Mlp1EJokgtLouoFR13bLnnnuZr0kh1cweKEl/aarwmesvZdVfPbu3qELimKbp4PQSSghvgHfp8vKLyItB0JaasKOhbuw4pUl3yCWKZvlFUVl9O2oBeo17Tqn1JB8Aj//41UGSjOGV7jKpGX2mvYdS+hTnDKG9F54zV40wV2vCraOjjtagwl3uYcGJan2Ny9aHzpLnCtFz6I2h+thozOQ5YrOT2AiRV7Uj24I39LZvi3+LrSeaIz5LU+EmVX3/VvUntTzyrFRxfl4vKuahhEtMB/LwWnlYhEpqNOhuS7TEvOEXLMI1MokQr2e67Hb0KCpAHIdcmk0d9lykK13/tu+rEieB4pn+WeiARl52823WSkZJLdmL6e7tXiF1ngfT14f7Z28PBR6nhCUOhF+pI6Zw/YKqvjbRJ20GIOWyOrWGPqs3Bh2hTvsSqmHxsPVXbzRPLIwbw+qxirQgkBNVpuMk9zbWRVMo6slfqjk/4KKRfApOzvKC0mH4vPJNID2M3s18eCfhC8nMw6VgflPFTB3yjN1Fw6vAaU4ZkPWnAT4vNAhMA4O3wEZFbPy+455biE2gV8KuCKYuHKtKFlMxZ6PeG2HqXM2aWqHjjdVqD6Mo4OS+nCc/IpmcHHkbHAZssUZwPkpHahmeqlTu8S9FUEPQkmWcpPN3Vg+OnxpJglxD56yhKXu4Qsy15JCcJqmeFTXYS0UJ7iLQq4F/ZJXMb1O15XBaEiJQh1INT84=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 11:58:00AM +0000, Alice Ryhl wrote:
> On Thu, Feb 05, 2026 at 12:43:03PM +0100, David Hildenbrand (arm) wrote:
> > On 2/5/26 12:29, Lorenzo Stoakes wrote:
> > > On Thu, Feb 05, 2026 at 10:51:28AM +0000, Alice Ryhl wrote:
> > > >   bool list_lru_del_obj(struct list_lru *lru, struct list_head *item)
> > > >   {
> > > > diff --git a/mm/memory.c b/mm/memory.c
> > > > index da360a6eb8a48e29293430d0c577fb4b6ec58099..64083ace239a2caf58e1645dd5d91a41d61492c4 100644
> > > > --- a/mm/memory.c
> > > > +++ b/mm/memory.c
> > > > @@ -2168,6 +2168,7 @@ void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
> > > >   	zap_page_range_single_batched(&tlb, vma, address, size, details);
> > > >   	tlb_finish_mmu(&tlb);
> > > >   }
> > > > +EXPORT_SYMBOL(zap_page_range_single);
> > >
> > > Sorry but I don't want this exported at all.
> > >
> > > This is an internal implementation detail which allows fine-grained control of
> > > behaviour via struct zap_details (which binder doesn't use, of course :)
> >
> > I don't expect anybody to set zap_details, but yeah, it could be abused.
> > It could be abused right now from anywhere else in the kernel
> > where we don't build as a module :)
> >
> > Apparently we export a similar function in rust where we just removed the last parameter.
>
> To clarify, said Rust function gets inlined into Rust Binder, so Rust
> Binder calls the zap_page_range_single() symbol directly.

Presumably only for things compiled into the kernel right?

