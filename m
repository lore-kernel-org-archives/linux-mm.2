Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8FCDE6BF2A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 16:50:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B7696B0093; Fri, 30 Jan 2026 11:50:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33B0C6B0095; Fri, 30 Jan 2026 11:50:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C85E6B0096; Fri, 30 Jan 2026 11:50:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 05E5D6B0093
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 11:50:50 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C5C45BAAFF
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:50:49 +0000 (UTC)
X-FDA: 84389219418.25.D869243
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id 56FB01A0003
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:50:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=B6nfAr5f;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="se/lO854";
	spf=pass (imf19.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769791846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/zGME7X/BllD56/7/Bs3RcZhoGtJm5/843+pXz7rPz0=;
	b=xZkIAulMoNEW60o28Vce/a7JIJ6cBDZsKOyw1KSJxwnxqlh7502CBEw6tJsFlCVIx9Ismv
	zyOqY6f4V5TFZmTCdGi1vpEh+hZ7otjvT3td8mlBHaZDEZ4wjunMZQFOpS8k/alezl7mxv
	IUfjyae8lQ7MV67k1LCt+CL+l/TqirU=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=B6nfAr5f;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="se/lO854";
	spf=pass (imf19.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769791846; a=rsa-sha256;
	cv=pass;
	b=5sJB2f47L6WbmTq1qwYYuhitHOZiBu+iz1xbOUnsmfKZcQXV/kH4+qh588pGJmY2/63pcB
	V9nB+LuDDigIyG1iLKsNIdc6+6Oo/Gopvgs8WlQDe863+Io8NWkt1vBWozVmUAtcCR1BmT
	Ld1VKd9V/hefciVuhJZW8yo/p8XEnfw=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60UChCxv3324518;
	Fri, 30 Jan 2026 16:50:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=/zGME7X/BllD56/7/B
	s3RcZhoGtJm5/843+pXz7rPz0=; b=B6nfAr5ffmUMTUm+bSedsVXwgn9C6+CHkv
	fEtdBL7As1gHe/T5AHPC6DEzHqKVdbp4TQm9+1bG5H6EUsr8BG2ikrJXbzogS+zc
	JBLqikZn6O+8WVWaevCa159PkVshq10w17BiLCAZBwNDs+LHyigdFVQtxwNEN+wo
	3QGAzlK++1oiUO4vAo8MuUAMM+IyDTTQkGGuiXUeyzRkb1xhsXermUQWMGOpIuv2
	/UA4bpKmePs6W2BXzjsuydu50QZBdXQJcTCChH2eY1iL5s1/mm3zCspymH7MqOSN
	1WIqReJ3vzNaaHayViM86jzEHxmGLmuWdHVe2+D3YhpmflNa/3yg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4by2vgnktc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 16:50:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60UFCBZd012456;
	Fri, 30 Jan 2026 16:50:32 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011044.outbound.protection.outlook.com [52.101.52.44])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhdw334-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 16:50:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Svcfskw7eq4IZFWi9Vnye7xD9br1H0aop+aA3Xx8LEQWwM/DoDqO1J+7qX7AtDgt0U6NDK6BdpweuYbHjIcSioQoOLzwIzlVic/F/eKgLCn4SzkirWcTDFWyYeGAia486PnwcN4PWNaRVNJBBKD01hU5cqJ7JajcrRktvaBXPPQZREXGP9+1erKB3UVBq1c5SRvD9rFw4lu+IH9Q6VEPjj2KpP4BP947vlgnIJADBzM/nvlZnAVukjRTvY4tvJWcWi+tycVX6Uq0ny4v6pz+7DGBK/jbTqnUKq3E3Hsj9LADbWjdYiE5vYZYez8WVFtwSbBzh/MhfSYq6bRwwja6eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/zGME7X/BllD56/7/Bs3RcZhoGtJm5/843+pXz7rPz0=;
 b=NEA6GrG6orTbeOixhr5Kwaxumz3JJ78eNy2+SKjAru1XY5M4MX1xqP/qo2VcONlv+vCLBK0EE7j6o26ESbaOL3EpMdkbNOMcqg8ZD7V2yFlTAmswUfZNaHDVhneD9UqxMu+/+WGx/W4cn4R5fNHujyg7f9BxshTK0ZsqeLLwGk8fWDqH9OdCE5HbvcfuW8lGG4m6PUnnhpa1YbeiVhmeNU8CjIB3Fuw+zE1MBRgLn5j8TAmbeEEmVnqRfH2Z3u7Hx/gxIhmtSIVbu5onpsFSrmaOnE/m+tha3iQuc6GWGccv04i4KvyjQ2rh86qGJR/8ESqmKqdb3PNS1WM0ISssxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/zGME7X/BllD56/7/Bs3RcZhoGtJm5/843+pXz7rPz0=;
 b=se/lO8547oWvOWDPAiG5el6r9yFCRxFGHIS2JvtBiYWqc3DdEG1B4NZzYU85TUpoS8yf7V/vaJxUOGeEKQ443l6V9PztqwvvQMAh4eZ10kOm56P+u1U85WyCkfPPKAC+RsdIDLbdTudvQNF947PJye8m05WHKLChF8Fb093NnwY=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CY5PR10MB5985.namprd10.prod.outlook.com (2603:10b6:930:2b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.12; Fri, 30 Jan
 2026 16:50:25 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.007; Fri, 30 Jan 2026
 16:50:23 +0000
Date: Fri, 30 Jan 2026 11:50:19 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v4 01/10] mm/vma: rename VMA_LOCK_OFFSET to
 VM_REFCNT_EXCLUDE_READERS_FLAG
Message-ID: <vj3zkp5nbazyp7lyguwdcyawzq23s3ztf6jhnaukslvolqkpeb@t7dppnyn2wg4>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Jann Horn <jannh@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Waiman Long <longman@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
References: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
 <817bd763e5fe35f23e01347996f9007e6eb88460.1769198904.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <817bd763e5fe35f23e01347996f9007e6eb88460.1769198904.git.lorenzo.stoakes@oracle.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0479.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d6::19) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CY5PR10MB5985:EE_
X-MS-Office365-Filtering-Correlation-Id: ce4cc562-c65e-4887-02a7-08de601fa942
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yaVsdXtH20ZkztSGVZLEQJmdUPO6B1EgXd2tlf2ZFWXn4iOq530ZlsLaOaEk?=
 =?us-ascii?Q?n6QmSDIr8SBJFLHpyTgoxlCuCAnRaFClT7OtI4z/lm91i4rHhByKFSTrEJBu?=
 =?us-ascii?Q?QO2aULtZaq9XQzLicMUQgs4+KrAHq/FQsGiK3NyPK2eqsS05WyQIMzKOEX1N?=
 =?us-ascii?Q?iwl/iSdW4By8IQeXj3t1ug7h/bWL3pGWMrEP19+Vyz19YBRNNunFj6NCi/6w?=
 =?us-ascii?Q?nVK4veZz55wPn+rPiaVIHsDKXRPs2IAI7aRHu70LGcGNR0cYcglWGOAvyS7e?=
 =?us-ascii?Q?qVHUG/PbTE+r8AxD6YohpIoupns/Dm4RxHQRMjvZ3qdenFetRmgMGsV1ppgf?=
 =?us-ascii?Q?jRra+pjHI12315hVMF8gtbSMH/P42ZSury+LGu3NlMvBpdEVPktGs8Jq1Ox9?=
 =?us-ascii?Q?J8RhEwqO5CoITIPD0fdNGi+UXkVUO8H9tZsYJs3+5mBag1Y5rTkkWUvMSD3n?=
 =?us-ascii?Q?+0gSl3Fi+ZB4522kWV/c5wFy74rqVbuf+YtrKpWB5z/0UDozKSf44IlhDXuR?=
 =?us-ascii?Q?vpHem1HyyBR1AWWMaH2UQCY4Yf//6VfCIJHfK2Jh5lQ06XRf7QVLzrbKO2z1?=
 =?us-ascii?Q?sIdvnubEJFx9EYwBDzPMC4++Iw9+QBr9DOpPFvpQDM0E271GnPgKl9hu8Ab7?=
 =?us-ascii?Q?rCtPoRIvawswnxuT+1CCk8SAO3ZBGNa3qZ0GL2NJ4iWzzNbCs/eTijVkGrdW?=
 =?us-ascii?Q?fvIwndz+Ihua+N7htAEFlbit6q3rESZrRbbzg2kTDb8KNMeiOceojCcR4PF6?=
 =?us-ascii?Q?7a1h21zAb2fZXNHZ+3Zydhyp53/zqg5AhGUFoia0V2me9EQe7elpMsImM70k?=
 =?us-ascii?Q?pT9z31qw8PgS1s3QvMnfE3ChG8BiQK8gk9u9zR5XznPtvUXmHpmtHZJQchDO?=
 =?us-ascii?Q?2oeGZV+9895b2gguoWUVAYDwsLx/a4p+zsVy3UZuOfzh3RqmeWBILZQhGfYS?=
 =?us-ascii?Q?9F2gq1+K3yWBsZTXigbIW6UUCnFY+B7OynIMrkuybriZGJ7Wu19yxor7UEQu?=
 =?us-ascii?Q?UXbanAQwGnSycbneDSU5iDMYCNX2Md1JjB+H4vkr7Hcmpl7ggkfqh6BRZD7e?=
 =?us-ascii?Q?exHBjeePuX8lfrdCZVEP+9sK8xOgV6A69NDvMNCdNvT8NE9CGjf/abX/ltaE?=
 =?us-ascii?Q?yw+8840k2A4KXQTwILOZQ3VfveZoHabQJHgS+KXssKB6PFhQBSO4whlojmiq?=
 =?us-ascii?Q?sZ6nN0/Cwt78wkQEp3zXm+BwxPdpF4ZTQz1R5uj8ZaPrpzMMT7HiOhYyvn3w?=
 =?us-ascii?Q?SGGqrMOB1iDHedrx5LMB3jJPFFDdZQhfRrxPIb/SKb954K5lMvLnz2Ta1DUr?=
 =?us-ascii?Q?ej6FPgcfggY6KtxzHUm3owwClpF95+FjrTk5V0QtIzbkglQLvzbW/IJ302yc?=
 =?us-ascii?Q?VzBNyHQNabwt/T314p8shyxellNFHVg3wk2qa03ln3gV3blDttQ5iqQiCbQF?=
 =?us-ascii?Q?60Xba6/jKUpdx/4TY/RkyPAS2ZPte1RqG4Dhy8TvTYG8pErCejh9iLZNj5Ae?=
 =?us-ascii?Q?3yZtE5IbJvvqxHPnI4SI1t6k8NG+IK+BSjhVyVQNhfTYCbVg5xEmITbcl35Z?=
 =?us-ascii?Q?zjn1bHFjtG6MRs1V8Bc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DVi6tkvG/C2JQDinxmRxTI4boLXdSFNuKxofCOqLGcZWnSI4b0tjNt6gRgd0?=
 =?us-ascii?Q?bkMr/P2+dH7+NMEDTuvWcVTG9p4eGCdcyjV2f5VZqKEmVESi7sQN8tXJgznE?=
 =?us-ascii?Q?oetqHLU4dM4cD+RNNxcA296ePKBGD3QU5mWVpv3QWrH5tFV+LbgXJGL+qPF3?=
 =?us-ascii?Q?8KyPIOid3QjjqIZUAODwvZ7rWYDjvImsPK17XuUEuRSTYFQuAIX/gwZIHoED?=
 =?us-ascii?Q?ukLfk5WOpVAdb+oMCZnfKYJYE5gM2HnKzyv0wmg8lCTK/xlsf6h3vEGr4eY/?=
 =?us-ascii?Q?2BOrA0iYZc8hFbVhHxmWzQ8SCsuY1Rr4dfAN1Y3D1MNN5quGJ9Czl0j2PBy4?=
 =?us-ascii?Q?OuXSyLtRp92XHVabBeBfCp6UW49Z/2xlUqhDUIg2K+4HuQduY8KfA/ADGkTk?=
 =?us-ascii?Q?Li/ti5ZaJAcFIZzKOYFxOKhz+nJ+HMHIVgmtD1QmUKkLz9McxrrwUuicOkDy?=
 =?us-ascii?Q?K6UmBg01McASTZcbN1MPJDv4dsJb7+RY40UgNxrban2TVYzgSm9UCiw9Fhiw?=
 =?us-ascii?Q?ii4pWtm2QlhTYg3Bb28/pI/J7jjAkQBYIUn5gbWdVjvjJk9/ZZU6FIDcHyN4?=
 =?us-ascii?Q?Hg5rfPxQ5Uvqm8XCz/HyUv/s4bUU96OMgcJ08WTXjz1J/lHyL0n/RrokZ8Rn?=
 =?us-ascii?Q?C9eyZWnwYtjeE18Ipkswcv9HkoMFOva2xuUJTVox/TFIhqVcg3tk4KHke8QU?=
 =?us-ascii?Q?uYaiOZPFalkhjvr+D1QXfYnoVVE1VYTGMtntXsHby2cMpsOlFrFTy1ZQmU/5?=
 =?us-ascii?Q?s6ZVhS92VEppAorlhCDAQBfWpbd6ffpEh4hgzbDOZTcxoumRZ4R9URh9aUwj?=
 =?us-ascii?Q?xvEulFJFsHWKrPbTMIHzQ5FSLfHGN/d/MQxGQ60mKs8WiaqhEmRq6JJ/qOrO?=
 =?us-ascii?Q?NftPJhztVIACnujuKZ1jQN59AFt3EqAPLdrf5+hZ6zU6RqKW1rTgZjfaIFWv?=
 =?us-ascii?Q?hTE98NdAY1u70/wEG2AC6/YMcV7PJYwM52jFfQxTaTKC/2apwF5UfePJ/oYK?=
 =?us-ascii?Q?Jffaxy5mBr2i7SEErlCyJsBeHy1wUV+SSlFWSi77K1MPb371y6DpMly2PrzZ?=
 =?us-ascii?Q?pcHKtJZjk1wpqeKaAWEhNlzHC3FTGgWhbF1p9s3e4bwlvNZqxpF17jGBVHWS?=
 =?us-ascii?Q?d1lpaWoxrjia054yu0YeraeFlRxj4Y3CstHtnxGnHq90EJNvRTfw8FY7tEDQ?=
 =?us-ascii?Q?qzL27qPSYdysnSEso/u6E4RzcPOrHhsYF8ElIijG+LL2+/r9LZqBc+OTbENZ?=
 =?us-ascii?Q?kV9WLCeJIQ/NnlDLIawkAY2J5EzSwreQVPVqZlUw2zDBO5dOs4984j1LQX8p?=
 =?us-ascii?Q?N2wrWbgOnt07qXPdX4GcAlqQtOA/aLpHvrgMdmHkAx6CDOPdbqFGvcWNcj1/?=
 =?us-ascii?Q?ytBDw7wZmRNdBR9j2ZovpJOGJVMseA/JzuLV8J6itDvCdE1UlVjsbkXY48E2?=
 =?us-ascii?Q?zWAjf7LFCbKQZi2e74ajzz3K4h1ppNiEUz2uLBEdVAXN07t1LVb17pgAfz78?=
 =?us-ascii?Q?Nb5/ERvXupLr+3tS3pblJ8L6q5kjcc0xUYK0DaIcpDHsSeTDQZRJtDhs1Wfm?=
 =?us-ascii?Q?R//haTMSsEfJZTW8wiktGat7mzraXPv8YCfVsemA6pQ+ooYWGDmpYQMF+0Fu?=
 =?us-ascii?Q?Q+7/z7RRnutL9u485rdc/Znhum98GkVKeK3TKZiyWKabSnnDrMsVgeEwd0WA?=
 =?us-ascii?Q?wYRAikniapXmccL/2wKhD2fvEd4e6l2vPGfBOjyGRomr0PtY1NsZ0yvFUXpd?=
 =?us-ascii?Q?1W1+CldnLg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	I1pDcdBTtIh9Er2SLuSUTmxObjL0qBh/8by1n9Hj0HKg7gqITyT5Pgp6j1IgwICqobBgjooNm+yMzINOmQWXUMCpA2R6QbYrdKcBpwyZzh2/2Cdx7b0qSMToLkyIzC1kVhtQx8hJU023qFK4R7lFIywdNFVnUt08PcRXLeoYlz6KSEHj29rUE9gNQ7z4N+1k6kDpF+kswCsGI0TFsh3xg+bK8bZtYrvhIQSG4CBDua0bw5GLzZLSSBu/YNlsA+GaSGsMnhHHi/FDFdyfLBOThORla7gb1MG2PYD6j/mKYQbe2LKuTrNDDLZcAUq3Nq4pE71YANrpGg/EMUL+7VlT3fdxJYW3hhCW1L1fOLIb1lzBO00iWUnoLbK/Br2/a82ZjisHANI+EOvevqA7zjN2ePGuCvw7QpMLy4TQxxHwbR9i7duLXuuFgnipL1fSiD2ZFaGDtU4l6KCvGchwOR8DD9ozmlOdf0ZxwrGTjAT7fJmJ0ehZbiutJcjhloo+nNx7NpyGGRFqSncMqExs2IGulVayCm/gXRef0H3WW1Zl1YYojfTRikvUopYb4Kvcus4S0oBeO+5v5Dj2Mznvay+j/uHHig4HJUZfBwLKjgq7OhQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce4cc562-c65e-4887-02a7-08de601fa942
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 16:50:23.4400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h+yC8sJmC5US0TI3y7QwR6F22bgz8tJoQkSA8PSOZyouPlcKAzN5pvLgqlzLNgHi1pnQC5ozxiNYkMW4/Lofvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5985
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_02,2026-01-30_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 spamscore=0 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601300138
X-Proofpoint-GUID: og5JLHw99Y51J_dY8hdaVXl5pr5ZuRB-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDEzOCBTYWx0ZWRfXx1GiMUx2W0gF
 E4zmA5f7hmFW4YC55XRXq+mECEVJyaVHHH4nVK1bHBciyD9TVg1hX1q7CpLH+YndXrIxUcO830q
 oM/YdmFo5vlIR8/uw2Eu9LxFifB2pVSxnKW6H0zvTEOoz50pVGos6zFRlPehj5VYbfZOHF1G/bk
 z7JVgDfp3NVM6bI2i1wiN26l4FI/YZqVBNi1idAYzqbosI01KLS4UGNu5Rb82FKzyL4kuqzSTe+
 yVL3RjFFNq8dK7zCVrmytY0dDu7RmgAGyLFhy/y1xHa5/zl86UZtnwjpS5bzolOmNQ5L115n9yY
 e8e1CNmN7BpV0vW8ixOdaNhn61luk8ven7avbis370oyKI5s+wJug2ZN5KXTIqKx93KUD7/HkwO
 2V0z6fVZOt+Bow36zEF76tkzLpTTS4kMZTAgigH4g2GFzNOMkBGLT2/KN3gDbF3jLo4L8+8pF/G
 f4fw9hnwzt37pFd9UsA==
X-Proofpoint-ORIG-GUID: og5JLHw99Y51J_dY8hdaVXl5pr5ZuRB-
X-Authority-Analysis: v=2.4 cv=a7s9NESF c=1 sm=1 tr=0 ts=697ce15a cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=QUVIQEnhbz_Uhz5UDeUA:9 a=CjuIK1q_8ugA:10
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 56FB01A0003
X-Stat-Signature: r9yynynyqkr6pn7imuxmoj9ktm3pytto
X-Rspam-User: 
X-HE-Tag: 1769791846-448206
X-HE-Meta: U2FsdGVkX19Y3sTlFn1UNdD6yi0ztUI4rUNx+9QG2bMfBC4jKKSt9BxWkj5fcHWBiLhk2fFistZ0cDP9bnJmY+YT2Wz7umvrz3Ox3mrIx4KJh63Ww8QLBJS6insP+mcCrSf4z0EvG7vyLWUhw2+vTzO8IVbHRTPVVdiZSWX/LO7+iSMfc1luGO7uOBp+cHP9xVXxnmBNT3q5tSZ/DQf+VCsaaHM75PASdgjLJUptWs3oIX/7dJQ6zPgKZziTzJRkjZu0SJSLTnUERA2HarQTAWSeOZ5WA+Z5tCpy74aD7ZpY5d6QLRh1SSXv3hY0WT2o7ZhIQ0TinfZlruOxA5k4FKAe6pt8jhbUCB0tFEs+E5bZoKk9CAvmWNMkVgr3O2/XGUfGY3u+whaUe01nUdCPfr3W9H1tFGBMq5OLI6wL/WQTxTxv6n/K8sxHrkDT71I3Rpx30WcKrMOXyp4iTDXo/8X/5pSVenejf2eNvODAoFWonFtrwheJ+vnJL5UxVRbHA1TkxaDEKdt83yplrOejzYQPz3jusIrHxwoGJ+s9021/nQXIcjxZ2ncxlAZK8ZxTivGe5DlPa9infK/kNRHHr62NmvbLJmbMUIxKmThdkBBJSF58EZsPdiM5+vCn+kB99+HkvcbmvMoqqurmsjsoitzb8G/ic6qUwO0ctmNNjqk6tZMOasOo3ddzpxA2WCFgYJu+9Vlluk46pnVDZuEHDFeYBK2JZAVQXXLTCrpY4jwzuh+WwG2pNl7I8IY+rvogAE6UcVVCb4ZPvWxP1XTxcaeQprCGHiufUD0C7iAi5Tobjr3x0uBy+0Du0rbWfE0KNxx29AYKm3QJ9pWH7HOmf83/sjBY9/BQL/Ih6S3hrYJ6lsVsPKhVgCRv9nB1n0KM345mflwlDHMDWuqrIadLQgLGzGWbYFJkEEy3bybez+xbtXGLGfoJr695H+ThI6C0PT9ms5VIfEC315tCQ7R
 cQa0iLSR
 Uhg/puXgwyYmnV4/lPiI3/r6sAr+Ne3yioSZ0fZ4tOW1Tz34Sln18n/9Iw5lH0fsbLXjzyzERSMmBJxZ5KTdbLuGyh39j7Wn44WS7vG6cmkIuIhdJuoj6JbD7cB+cUwzXiYzJdC6xLsS1lzLpjAlhMGTLumzkCod6fGfhO3kgk1RJ0h5y9lVH/fTRUU0HvsUy0W67OB6i74yBGH9NXFOZ4Uny/Y9UYsF5bqm6u37XJfCrd2Qpi80kikiNrrJmkdfpzfiVauLHuKPbDjNuveBUkO3OCdCSI4Ct/8cbUgruUv+i7ZKSy9l9pUdlEOTPCE/G++5LhlWmXb8y/r+gkri4I5bhMbYk4c9PMGjJ+Q4CYbtO4NvXzKmaCXDl0n8ladt5tlBfnhTlLNLmdT6g+nmV9PI1gk/KryexvYKePyD6X1l+F46dr3IE7B+dXzuudpH6QLgp6XDa2BaFYC0zRH+nBPNqx2mCZcXjMnCUBC1bYq/SW6t6tjRPWY4e5RqtGEC7ezGETWPbQLas0RkBSVuQdMgn1/6NeW5KzOOJNugdD/cVsySBj+xKPYnjU0rbrm++OQaQq/oytLSNqlYVo0+DYKpTA8+dIle3kyvtapspffvo4kQ54W0vxQ43zzSIkZ25/PmAX/IISNVcAWaIzCKOPKNp6oXWcvB0w09B+0Lch1AXKB4pY52NHN3vf93t0YaeANzoJFTbJP0Xsx/5PZiihD0C39vr2szy6FIlNTaWygEY5OnEgSaWhRdeaHI10S4g6qVMUpnyPosqQi7xVXKFLf0n/78kQ4Z3X42G
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [260123 15:12]:
> The VMA_LOCK_OFFSET value encodes a flag which vma->vm_refcnt is set to in
> order to indicate that a VMA is in the process of having VMA read-locks
> excluded in __vma_enter_locked() (that is, first checking if there are any
> VMA read locks held, and if there are, waiting on them to be released).
> 
> This happens when a VMA write lock is being established, or a VMA is being
> marked detached and discovers that the VMA reference count is elevated due
> to read-locks temporarily elevating the reference count only to discover a
> VMA write lock is in place.
> 
> The naming does not convey any of this, so rename VMA_LOCK_OFFSET to
> VM_REFCNT_EXCLUDE_READERS_FLAG (with a sensible new prefix to differentiate
> from the newly introduced VMA_*_BIT flags).
> 
> Also rename VMA_REF_LIMIT to VM_REFCNT_LIMIT to make this consistent also.
> 
> Update comments to reflect this.
> 
> No functional change intended.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  include/linux/mm_types.h  | 17 +++++++++++++----
>  include/linux/mmap_lock.h | 14 ++++++++------
>  mm/mmap_lock.c            | 17 ++++++++++-------
>  3 files changed, 31 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 78950eb8926d..bdbf17c4f26b 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -752,8 +752,17 @@ static inline struct anon_vma_name *anon_vma_name_alloc(const char *name)
>  }
>  #endif
>  
> -#define VMA_LOCK_OFFSET	0x40000000
> -#define VMA_REF_LIMIT	(VMA_LOCK_OFFSET - 1)
> +/*
> + * While __vma_enter_locked() is working to ensure are no read-locks held on a
> + * VMA (either while acquiring a VMA write lock or marking a VMA detached) we
> + * set the VM_REFCNT_EXCLUDE_READERS_FLAG in vma->vm_refcnt to indiciate to
> + * vma_start_read() that the reference count should be left alone.
> + *
> + * Once the operation is complete, this value is subtracted from vma->vm_refcnt.
> + */
> +#define VM_REFCNT_EXCLUDE_READERS_BIT	(30)
> +#define VM_REFCNT_EXCLUDE_READERS_FLAG	(1U << VM_REFCNT_EXCLUDE_READERS_BIT)
> +#define VM_REFCNT_LIMIT			(VM_REFCNT_EXCLUDE_READERS_FLAG - 1)
>  
>  struct vma_numab_state {
>  	/*
> @@ -935,10 +944,10 @@ struct vm_area_struct {
>  	/*
>  	 * Can only be written (using WRITE_ONCE()) while holding both:
>  	 *  - mmap_lock (in write mode)
> -	 *  - vm_refcnt bit at VMA_LOCK_OFFSET is set
> +	 *  - vm_refcnt bit at VM_REFCNT_EXCLUDE_READERS_FLAG is set
>  	 * Can be read reliably while holding one of:
>  	 *  - mmap_lock (in read or write mode)
> -	 *  - vm_refcnt bit at VMA_LOCK_OFFSET is set or vm_refcnt > 1
> +	 *  - vm_refcnt bit at VM_REFCNT_EXCLUDE_READERS_BIT is set or vm_refcnt > 1
>  	 * Can be read unreliably (using READ_ONCE()) for pessimistic bailout
>  	 * while holding nothing (except RCU to keep the VMA struct allocated).
>  	 *
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index b50416fbba20..5acbd4ba1b52 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -125,12 +125,14 @@ static inline void vma_lock_init(struct vm_area_struct *vma, bool reset_refcnt)
>  static inline bool is_vma_writer_only(int refcnt)
>  {
>  	/*
> -	 * With a writer and no readers, refcnt is VMA_LOCK_OFFSET if the vma
> -	 * is detached and (VMA_LOCK_OFFSET + 1) if it is attached. Waiting on
> -	 * a detached vma happens only in vma_mark_detached() and is a rare
> -	 * case, therefore most of the time there will be no unnecessary wakeup.
> +	 * With a writer and no readers, refcnt is VM_REFCNT_EXCLUDE_READERS_FLAG
> +	 * if the vma is detached and (VM_REFCNT_EXCLUDE_READERS_FLAG + 1) if it is
> +	 * attached. Waiting on a detached vma happens only in
> +	 * vma_mark_detached() and is a rare case, therefore most of the time
> +	 * there will be no unnecessary wakeup.
>  	 */
> -	return (refcnt & VMA_LOCK_OFFSET) && refcnt <= VMA_LOCK_OFFSET + 1;
> +	return (refcnt & VM_REFCNT_EXCLUDE_READERS_FLAG) &&
> +		refcnt <= VM_REFCNT_EXCLUDE_READERS_FLAG + 1;
>  }
>  
>  static inline void vma_refcount_put(struct vm_area_struct *vma)
> @@ -159,7 +161,7 @@ static inline bool vma_start_read_locked_nested(struct vm_area_struct *vma, int
>  
>  	mmap_assert_locked(vma->vm_mm);
>  	if (unlikely(!__refcount_inc_not_zero_limited_acquire(&vma->vm_refcnt, &oldcnt,
> -							      VMA_REF_LIMIT)))
> +							      VM_REFCNT_LIMIT)))
>  		return false;
>  
>  	rwsem_acquire_read(&vma->vmlock_dep_map, 0, 1, _RET_IP_);
> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> index 7421b7ea8001..1d23b48552e9 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -54,7 +54,7 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
>  		bool detaching, int state)
>  {
>  	int err;
> -	unsigned int tgt_refcnt = VMA_LOCK_OFFSET;
> +	unsigned int tgt_refcnt = VM_REFCNT_EXCLUDE_READERS_FLAG;
>  
>  	mmap_assert_write_locked(vma->vm_mm);
>  
> @@ -66,7 +66,7 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
>  	 * If vma is detached then only vma_mark_attached() can raise the
>  	 * vm_refcnt. mmap_write_lock prevents racing with vma_mark_attached().
>  	 */
> -	if (!refcount_add_not_zero(VMA_LOCK_OFFSET, &vma->vm_refcnt))
> +	if (!refcount_add_not_zero(VM_REFCNT_EXCLUDE_READERS_FLAG, &vma->vm_refcnt))
>  		return 0;
>  
>  	rwsem_acquire(&vma->vmlock_dep_map, 0, 0, _RET_IP_);
> @@ -74,7 +74,7 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
>  		   refcount_read(&vma->vm_refcnt) == tgt_refcnt,
>  		   state);
>  	if (err) {
> -		if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt)) {
> +		if (refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG, &vma->vm_refcnt)) {
>  			/*
>  			 * The wait failed, but the last reader went away
>  			 * as well.  Tell the caller the VMA is detached.
> @@ -92,7 +92,8 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
>  
>  static inline void __vma_exit_locked(struct vm_area_struct *vma, bool *detached)
>  {
> -	*detached = refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt);
> +	*detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
> +					  &vma->vm_refcnt);
>  	rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
>  }
>  
> @@ -180,13 +181,15 @@ static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
>  	}
>  
>  	/*
> -	 * If VMA_LOCK_OFFSET is set, __refcount_inc_not_zero_limited_acquire()
> -	 * will fail because VMA_REF_LIMIT is less than VMA_LOCK_OFFSET.
> +	 * If VM_REFCNT_EXCLUDE_READERS_FLAG is set,
> +	 * __refcount_inc_not_zero_limited_acquire() will fail because
> +	 * VM_REFCNT_LIMIT is less than VM_REFCNT_EXCLUDE_READERS_FLAG.
> +	 *
>  	 * Acquire fence is required here to avoid reordering against later
>  	 * vm_lock_seq check and checks inside lock_vma_under_rcu().
>  	 */
>  	if (unlikely(!__refcount_inc_not_zero_limited_acquire(&vma->vm_refcnt, &oldcnt,
> -							      VMA_REF_LIMIT))) {
> +							      VM_REFCNT_LIMIT))) {
>  		/* return EAGAIN if vma got detached from under us */
>  		vma = oldcnt ? NULL : ERR_PTR(-EAGAIN);
>  		goto err;
> -- 
> 2.52.0
> 

