Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A3D0CCA470
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 19:49:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 780BD8E0006; Tue, 30 Sep 2025 15:49:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 731718E0002; Tue, 30 Sep 2025 15:49:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D2008E0006; Tue, 30 Sep 2025 15:49:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 414DB8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 15:49:54 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B6E8311AF32
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 19:49:53 +0000 (UTC)
X-FDA: 83946957066.05.A1D46F2
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id 48959140007
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 19:49:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lwATVlSe;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CdhhZC6I;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759261790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eBhIJKKl+QH72VbmDq4VCN70OJo17sGgxGQ1dboGlH8=;
	b=lmMnlZ244nv6kY8UbphFLcvbjSvlBDztWjgXR/rgc6ssKjRdnzaCxDGLdc1MeZKv0weuuF
	JH019RNqyvmBRr0H2n1gghtIiD0WEqOqsjbO4ZkVGzxy6LGbDpS+gHQwp+6g/ajP1cv+7u
	rOTAGM9qUimdtwfvZTVx9SvZqI7RpGs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759261790; a=rsa-sha256;
	cv=pass;
	b=pv0Rh+Ke8pvDg3ANXGWo2xlloOdF2CuuSsfXLRuQduL5jKIUYdxr4enVY99TiH/IKrnbQO
	yY4voaZmFHEr0VvXqPkXTzMXhIyfEEalX6E2vo9GtE00SPGktBX5QwyRmkLqxbPAe9L6hx
	5NIpafuAroP7h5lJcbIqitjwob2lo3I=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lwATVlSe;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CdhhZC6I;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58UIEniM007080;
	Tue, 30 Sep 2025 19:49:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=eBhIJKKl+QH72VbmDq
	4VCN70OJo17sGgxGQ1dboGlH8=; b=lwATVlSeRRxFb/XQd0Z9WbdRX5Sg5kejJc
	2LenbM57t8qY2kpYnHyi55W3aTE3Y0vPN5cZOhOL0vcAQkbJzK5ZJwOXAwZxz6WQ
	Po8wbTAld94ufF40yTPPluXwCCttFJyDjBrwMBlT/KtDSlEhPiKHbK+lziiT8l9d
	uGIwxYE4eliE2LKTw8arXBYrp+xZCyno91xsJxZDzLIr6C4ckpSLW5mEn6MUcSWt
	YmG+TGgu5opJC3+uXto6MPWZL83iFlzPjWW/BvMs3NJHRaQxzYcQDIwmKTVdckKn
	TzYP2Xnvmbytu02K9fOKY5IahoFuVerpqdujp9wTT3RhM7z+wltQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49gmabg5h8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Sep 2025 19:49:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58UJXZSk001490;
	Tue, 30 Sep 2025 19:49:42 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012039.outbound.protection.outlook.com [52.101.53.39])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49e6c8bauh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Sep 2025 19:49:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ec8dvYKNPYVFbeGMMEh1Ffigqz25kDf7vOZyLy4VcSvZV3m/B1JslXCmXYLM3SJpdtQd6+sWeO7Q7d5A/POQ276CEPcIcalpzQ/PnVYUFw2+lIz+n8saMTI4AZdwIQ6cI9jY6h8cZb5KvT6bkd55jL3NJR0CZAimXeNrbvyUlh8BQbt8/q6O1jUQk5kxfBC5TNAQ6W1FnUcoqEHZ/pDUkGUkKNUACxO+eYppMNux4lQdB93G9J4MtqiQmZ2FDTyngOVbirU1ahx2fWxG2AGyJh5w+Zf2GZoMoQKLCSc/X5IZy4jsZfFnItcqI95pdjtKRQiFCyPx4iJLA749nYYn8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eBhIJKKl+QH72VbmDq4VCN70OJo17sGgxGQ1dboGlH8=;
 b=uW8/eSJnty9lGU4DXqkkj5drP31aL0vJm0iPV4tjUnWo1Nj4/+xTC585rh1PldUXUKE/dTeYswi/hpR/AxZ3rbG6dR+EwfUl0HYchTML0c6Do6VRse475kJebAHxmzmKv96QXEg5z5AYP1SAsp+mb/VbGn0YVeg8oq7avS2HS2EBCpPbej1iWNxgwv24gLdODSZMUcdBb3W2YZ9Caq44sUuyL1lqHZu7KD76Dt7x4yuzr2DvBsF61+8rqevG+gRA5Gp4cSb79ZbLqaQI0wiba2ewh8upVb5EXNLa24fOy8OZOvn3hCJaGEHP57kc9EFQZwnV7psUVnSwV/rnHksxZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eBhIJKKl+QH72VbmDq4VCN70OJo17sGgxGQ1dboGlH8=;
 b=CdhhZC6ILHGaAnprM5In9WwRkb65vQIV5Rf2WyP0dBMCShYeIVuIOoMlRlDc2010LbDgbNM+rXB3p2Sh2wsTVtr6cYoXdVH0tKqOvcKfAag6g2b9aTGGDeBmO5SCRQfHinBrGNpBf+/gEHCLTWutn5Gt6WjjhMT52ScVZ02kAOg=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by LV3PR10MB7770.namprd10.prod.outlook.com (2603:10b6:408:1bb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Tue, 30 Sep
 2025 19:49:39 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%7]) with mapi id 15.20.9160.015; Tue, 30 Sep 2025
 19:49:38 +0000
Date: Tue, 30 Sep 2025 15:49:34 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Axel Rasmussen <axelrasmussen@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        James Houghton <jthoughton@google.com>,
        Nikita Kalyazin <kalyazin@amazon.com>,
        David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Ujwal Kundur <ujwal.kundur@gmail.com>, Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Michal Hocko <mhocko@suse.com>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>, Hugh Dickins <hughd@google.com>,
        Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH v3 0/4] mm/userfaultfd: modulize memory types
Message-ID: <urtzlj3wwjmmgdon3goi2qopxlxrajewdxhhchzw72exz4of7l@vlmbjw3i3xth>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Axel Rasmussen <axelrasmussen@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Ujwal Kundur <ujwal.kundur@gmail.com>, Mike Rapoport <rppt@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Andrea Arcangeli <aarcange@redhat.com>, 
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Hugh Dickins <hughd@google.com>, 
	Suren Baghdasaryan <surenb@google.com>
References: <20250926211650.525109-1-peterx@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250926211650.525109-1-peterx@redhat.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT1PR01CA0055.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::24) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|LV3PR10MB7770:EE_
X-MS-Office365-Filtering-Correlation-Id: ffe7011e-f522-4e2f-5cdc-08de005a7d68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xF9vffFiIgZAgteHL1OsKKixKjVQRbLFe4mRkF5rGHL62+FeIwkQp4AAC9OT?=
 =?us-ascii?Q?gp9K7tm9OQIz7lD7dXBoIvU0180RnwuK0Ge//FqUKQqzV+hoKHcWOpfh55nA?=
 =?us-ascii?Q?L15tOquA2Iy/fcUVBZsshtc2pQKSlwv11zCPj4Mbu65rP4Tyu2NXiEMk/aeM?=
 =?us-ascii?Q?VzqaCvuHsaqz8vr5iOmp+4J3/zmHtjQlVQ8p5F4DS4Zx007BT4GayF8GPriP?=
 =?us-ascii?Q?lbka2sD8hBkMwkVIYP9e1NRTvQfvKgK0tXDBluGiOnbx6A4469C6bNWCqEMk?=
 =?us-ascii?Q?ITdPETh6euqfG+crVExirprxCv/WfbWqCx3We6/wFJsI9CMb8U8H153uKOt/?=
 =?us-ascii?Q?c946RsjqOxJeHl+LMmSLqH0iMY5+DVG2M5ZndfLWURcIigqQnrgzpu+qjXcs?=
 =?us-ascii?Q?XrJdL4CJLBFRHz5k6ZBbqrdbir4v0P8r0imJ+gOf2PJKRDa9KdFAr+2Zgsmn?=
 =?us-ascii?Q?jX4x6+fMifaLfDofKITXkswV4PFfu3E7EomDoH2csd3gO3q5OFCGHbjBux14?=
 =?us-ascii?Q?T+JQOsNep9SEcHfFPW8roL7RxnTYtvgNvJvDuOfX4oAYkFTDX6fVUQVItxgi?=
 =?us-ascii?Q?3VXyU5j92ycq192krar0dT0CKZuznCFJMmmoH5tboq5BnXMRVL8JlMPjhTyC?=
 =?us-ascii?Q?X8G0uzRRTwtSFLPTF5qXr0SC4BWrXWo8dfopJIlj/RsVecSuoKqwmGbPt4Cm?=
 =?us-ascii?Q?C7zVphUHPTKf4GWPnOtd0uJA9xRUU4Du0rQlYZxGzn6sRwqra68Ojkb9yqEX?=
 =?us-ascii?Q?SMOsIiFKe//MnR4u50kmXSRImnu2sqde+eg2uMWe5RnrRvVv2E3uBANCnRCm?=
 =?us-ascii?Q?H8x4OpDXUj44xPghlvk/2wM7ENYcv0Br+8CjIU6H1o3QUCXSIG+xnC2OJs+r?=
 =?us-ascii?Q?1CR4eYACDfBzUQDk0IeuYPFVTub7en4zdAuwUMvxmjJ2rgtQrXQifcplYBLD?=
 =?us-ascii?Q?wROpImzya2IetynNJVsaFOX/M6KTdfzqR1/DzWzAoCEOoL4QWgMiYozev0s0?=
 =?us-ascii?Q?3qAMtWBokaEkg/M9WxCgg9zfgEbSUwdyjD3riPyeOciOBBY7fqWE+P9IsO/q?=
 =?us-ascii?Q?9bd76JSeW/p3R4YTQX9idesA9EUiX13hZ0B0z3hMat4zG2xTaW1quJUXL/+z?=
 =?us-ascii?Q?fTHjR5grGDSTN26fLSAxvGuPcNXmWGZUe7qhAfnYdfl2GyvH1Oi0tU/wnFlr?=
 =?us-ascii?Q?iFkeackabkmTT4hlUVzjNw2q8JzS8iyy3QWwXlH63Tlj7Qf0E2Tq7FNeQfhY?=
 =?us-ascii?Q?L022Jb5gkmLMQmal7Ii7i6Gcst8U0vtjKTQaq4hbxXdAN0BKhNIGOicdY4DQ?=
 =?us-ascii?Q?sMgL7FvnpR349g6ROfpe1VO3UrNEt4b2MgV06lNrWXoWAhdGkLo2fCQqvN3y?=
 =?us-ascii?Q?EXQmglVl/jXtAQMBwgMpVq5hxOT4tfG4O5ARcRcQG1HHPm4JOHhiAIzkvjWD?=
 =?us-ascii?Q?x3miXp17UjXSFRs1CdpDg7FbhZm0abYDISvpRBczgLc47wzbeGckAQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?D/R8jyDX/2P3OoVA2r2y+0HDoF5QtdhHteYzuefjnEU8IJeHhQJB8UYbvJnj?=
 =?us-ascii?Q?qPRxyRIKHqJKyWEELFiMMBaqk96ntiNHbRqB/6A8DN7QeFF8tNSCRwU5u7TZ?=
 =?us-ascii?Q?W4YLur1pvKtinbj8mRdXEK7XQQ2Bm5QfJ4FX8VxCjruicQKFXqjQbMHYV05h?=
 =?us-ascii?Q?2QRjEQR0pHLR2Joe11wqhhm2LXpTOp5y/XlekRkdy1M/wvy+N5XbhnquM9Ve?=
 =?us-ascii?Q?F871gHr3MwQiedZBKjt1rG4gu1xWQNoAZBmhVBFRy8Q6BTP29M5tcMAYsKgL?=
 =?us-ascii?Q?3LmF5480U+agWprOK7/8tnjJvdr36mk9lJg1lc/b1ghCOUhKwF5Dy4aBtIHG?=
 =?us-ascii?Q?tT1pH7eUPJ8v8ZzUiMo0GDY2plD8q+LoCk8x2pLzqLGHC1VOOzgNZFLNJKsd?=
 =?us-ascii?Q?ZUnTjEF8fzeYAzKuI6WnBLjxhkZBOdUQD2CN8x4dpeuowzl51T8BHdtmNaSG?=
 =?us-ascii?Q?KXGmEHzUMpLukrgpy6MzGU8Pt6POd8Mo6F1eaQYH/DJR13mQV7K1xAjR9q+0?=
 =?us-ascii?Q?38EtiD09QUyWIjoHOKaYH8gvzqKI6g0sA+E65ScyhY5Sbwz9zsnLTYDeAWMA?=
 =?us-ascii?Q?VE9tDdftfwz9bsWbZyusRx6Wkg/+A062cAhQlUxXi2ScBqjKuPmIlGKvU/JU?=
 =?us-ascii?Q?TiV+qanyymL9CMNMr07evHolxFYsgFjJL3MH4HE4aRA+Mb+NQFBo2kxADQlP?=
 =?us-ascii?Q?A/z59mPR3ca3vWOQz0UuLnV4Y/SepKVYlY3Tn7NMwg/ljEs9SrSLGYvi0mk6?=
 =?us-ascii?Q?OSPjB1GnBsYNN5iMjeyvXjd/7s2xbv4M3ziH3+e0J1aGICLcNjxGxqZy+C9T?=
 =?us-ascii?Q?Y+HYJjIcA3CHW8Wy/MwG1FxbRgbRHAWCxmUa8V0/HPZExuSVHH3gLXsuPXJE?=
 =?us-ascii?Q?IDzyYqhhovNIktE/ec3ZRKFNYqBblXcLn8bqTCEQpkSdWEToffzWR1ckKToF?=
 =?us-ascii?Q?/MIZfKTEQ6vulkLQNPCu6fIuz5k+ixtM0S+z43pLFtM7g84XbcirFAkQgL6V?=
 =?us-ascii?Q?c2cw67NmGm+ntpf49d8ZWyQQFx6pX0dvgrfxqBGVKRNEMX6S9DckzZkkhPIN?=
 =?us-ascii?Q?Xyeb1ypSxrRt53slilLvmS2bN4z91lec7tgr8g1yINkE7K2XnFUbnKaEcNy2?=
 =?us-ascii?Q?SGkJk8ncizDYOPXhM19qVmbDFF7NGV5wdyAASHDvOuLpVMfsBK6gPdmLfSGg?=
 =?us-ascii?Q?WIcfq5Hrs4dOf1ukpKg8U6TNJkTQAf5cIpEqQP28Imq8w8/730ouCbGbiDI0?=
 =?us-ascii?Q?UvdwBuDzWEWmWnYbByrgwZveyVwA7xCZr4HWDp7f1CqpE6lOP14wPzweTXr1?=
 =?us-ascii?Q?nK1mzAQgcREa4KoybEK7mcgIibZWQkuPM4Q3kV40BncHU2k2hkL03Yi1kTAM?=
 =?us-ascii?Q?zM1sbU08QKBjZllpu+9294swWlktUHcRfoQp/e7pPJawpHTz3fH0DIrQGlcc?=
 =?us-ascii?Q?PjSCvr4RpFy7UuN8bUTW1GFdSNzghpxDbWlzDzfJsf3wMeoZLi1O+oPs5I63?=
 =?us-ascii?Q?10DrggML3yA6zPMo1DcH8R7GJSWijdTR50Vwbw5Qw9QrHcCViDg6nxLtOtQe?=
 =?us-ascii?Q?W6dwDPydRyWbG7t6Ftgs3t3dYjsQVgRnLv+1ozl+?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	84gIb2o63r/+olhRtiKUg/KXnkFraMU65aDLa1KG9eRWhUqMRZgdQOC2HT2zMO4NBlyDmx6R26TgyqAOd/a6i+dTggMuf0qf3BvbOZCnoiR7Rg9BLKULI7FqLcUYLXM/z/C4Ov4sMzNWJ67TZxlC0ebrmV9N/HRUqugLpf9GZDBcgxHiLPiw3joqB91zetCKsTYw+fF4sPUxrxdLqEMPghMwj1Nphczv2SrnUG+I176WUyVYeSIq7YCE2AENL/lRZWxRVnPbp5YPq+pj4tHL58KkWsw24pKsrwX39ln8oAR5VlNRUJGFNLNGOaXdpFdjpPwi83TVofIggqI1qRvatRhfGgqtoFYXUWA5maRtBzXWJAAQHENXEgjKHqpWyNixZ3zyV7uWUB55g3q5wHFfLSw7GgcjQR99nFLIaaydNJl6tUqLCAyqlzHe8oTVPbYraTYe+ZVAL81R/tC/adlwJjUwJDBrrqH88q5N07Lxq3/qxhvBybB828M62ry5n86gKkL14zzHF1GDux3FosGRVGm8c39tZ7Fh8YW59yDOYvsrOrBlMwltASIhBZTmklULfmvbl/B6iPIVN5W61e735Gsu/6PH4QKXODNrp+Pob3M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffe7011e-f522-4e2f-5cdc-08de005a7d68
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2025 19:49:38.5949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hac50wmQtczmH+qTVZiRipu4KymyCT5Kgah5rXpAv5hmJgJ5t8VeB8fJqmoaUVWjVz9pG4JD4ULEU698tTv18g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7770
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-30_04,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2509300180
X-Authority-Analysis: v=2.4 cv=SI1PlevH c=1 sm=1 tr=0 ts=68dc3457 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
 a=vggBfdFIAAAA:8 a=QIwU4_ZsRPGQXcNizn0A:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12090
X-Proofpoint-ORIG-GUID: siKzpCqft_nlv7ROR3NmljNSiJFcUN6m
X-Proofpoint-GUID: siKzpCqft_nlv7ROR3NmljNSiJFcUN6m
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTMwMDE2NSBTYWx0ZWRfX18q33+WbJRxQ
 kZkkoogDBtUPtXZmZdDmkUMExiAIrX5Yb3Wv9uJ0JO4aNeX4cxn3NrBwGBBZdYdoTYrlgk8FAGM
 gD2R6EmcxIp1umEnphONkA3vdHRSMO3EHtb9Tux04rp6krQ127o5BCZT/2N8lgL6Iq6OwfiZ+7i
 CYl0MO8EYjdSxbfx14Y4wugepyQuUjnHczw1j8tlN5rJ9b0Ct654WArnHY5l3RgHhENwHzr4gfg
 yiJBd5KTI32u70yKdqKe/ccdWfAalqSDl1r+Q0TwZQFLycaXZMeqEmFzlGR55tN3Eefmlusgm7w
 SGHnoE0IPrH/mVtxC/1qGzd2fjdyHWtyxYGg9oZ6N7MplMsHnOtrCoxCjWQfQno576dyFfRYkDN
 MbgtW2nFB61rtKuUDChW6/Ps+158QF1l+ps1Z5Vc1u3PL9fuXkA=
X-Stat-Signature: 7cmic18iwb1pem5zroj1k1da5cuphuhp
X-Rspamd-Queue-Id: 48959140007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759261790-214080
X-HE-Meta: U2FsdGVkX18XN7acXFdxqUiWaijABW5FKzv0ot37ULPgPhmfGTek9oL+eh4srf2Zwh2Wyp/1PL9wkRC8ZjHhOwkkVBDxZy6SXejTT4/IAwd+R+ypRbvVdg30HpK03OsoekyR/7wFE28KDtj99x964kuDS01OHjV5p9T9X4ZeecqMQOs/8kXSKQCX7GOWKb801+Y8fNj9LrA1a972h3A5I7xxuHtIwQY8gYx8QxUUt3IRzIJUq9dCzvPOVdDNon+9+WlUuZoGGyqPT+UmpEVJ8Oyr2WjK41Z3iDCWfCwrLZTKFokXVLY+SsA1BLyz2MBl3cRuXPjoe3Fg5525mhhbN540fu43Vs6DHTBCbsz6do9zx5t73GPoJ8ENJtCm2/Z1BPd+r9ulR04EAyz++XpmGOb2rQRlPz7nl1jYJi0RX5O2QMbz/6AV+HYsVdEfv8UhAwFXQ6E5pcuy684oyfL1bYO5Rt9w4Z+BjwLAF9jtxNxVft5WG7B+O70vfoLDP80GqWfIvC6/4hvHiXUc4m6CUtYOWTnlEB5TdMrZdyiXTw1p3IXoaY1NE5rquPwRp52/686bI/qrFaiJRQDJUSQft+LilUZlvtG8CJE7JvHK6TAtHW2C4X0PQI2MNIOIqJSZJXnsVEmo2tdaUcK+vKuVHD0h8A8rVBwjgnbFcQpY8UTruvOlVgcmtzDwNHgalF8FxzAY1Zk8X9/gk1L9s6HZSKSS1ZVGv1a7ey6eqitgqMHegNOlbdpzPwsxlMOOc3J7n2qqwTYKRK+gcAtV9cx4E+Ea50XdGtnx4pLqA4+iPweo4HKBktesg9KpGZb2Sqv6yED3lyaBxiQlUkh70PHtSGz+z3KrjWQRdYqLH7z1Ad4PXjhYEVi8ZFHJqaKN/ky97cqk2/WqbbT4OGYf8T+3M2SKVtllpQraCV7rIRS6z+h+LY2tLLtaIwt1bw91Q9YAsupQYV/t/CNfGII6bml
 B7cpjhYg
 ie/Z3ZBQVKXnR+tjL1WXYkSznoHpvxxSjtrL5B0A/vf1SPft59cXrUYah2MR63vBXX5CO2ZpA0xn8xwYp19FJQP1FAQ4uaOecjkH/qhdbc4wOGtKmlK7BbyHO16Un/8gqPAH6t121HvtFDGtH8E0bRZqAOlMbctZQDZhszQXqSpixqt84nzPEyvN0IqkNiYi8xJdp3Fnl8tsFXncf5E7rMEA2FkcVOJXq3GzN72goz3gwwgATmdH+56SWLGJ7BlVwMbHuxvyE94sSD2gjoYT4Wxu/IJr6sJf4ZEfW0M5jidBVIhlCLHNVvYLK3qPBEcKotYCWHzxSNctKeqQASHZ5ryhldxZG5nc1liVEa4WHL4kcqDQXJw4MTbhIWw0Za1r9X3eE6+AQ3pUKMm+Hk3IDJIOXRI4ggUKnguKDu+XZ7wFQ9L264qQAfe3wkqvYm3wfGX3uM9TLGa3I7xScnWPQX8kYUTiY3VkV/NbAK44IJJqdjEXt4z0eJeqCrymKVeoKWI5USgs9yf12hBv5oQ0szeHXfle5eLgb8kErrqpPdidijcEEqpUQH1fasZFqhkFyiPOiTqKQc+yDnejkppLtu9YNJfmiJXik9krKQIUoX8H63EJVEoX8qxvdlyZX9ZN2dldzjx9l8jQ1wmMjV2D3bByC1adpA5Nq5bt39eHe6XZeAotf6fu5Yb88bgKvqyhS0pQceY3DMQdThk5zoil1RHbKEtjfFeFkORWEWwGOLlmRhU09icuTEujQdG0Ln5zom9QHLbGa+fc1LX7HRHLXsA3R/pbAmwfGeHu9qUuhoGPC2Z4PrzJIE0j+/IMVn38O4wfbHFyWNA+yZINGGY2JAUfhxloepBzf1ezLkoSGNm7VMfw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Peter Xu <peterx@redhat.com> [250926 17:17]:
> [based on latest akpm/mm-new of Sep 26th, commit e612c80ae0aeb]
> 
> v3 changelog:
> - Fixed checkpatch issues on spaces or typedef
> - Dropped uffd_copy() API
> - Refined commit messages here and there to reflect the removal of uffd_copy()
> 
> v1: https://lore.kernel.org/r/20250620190342.1780170-1-peterx@redhat.com
> v2: https://lore.kernel.org/r/20250627154655.2085903-1-peterx@redhat.com
> 
> This series is an alternative proposal of what Nikita proposed here on the
> initial three patches:
> 
>   https://lore.kernel.org/r/20250404154352.23078-1-kalyazin@amazon.com
> 
> This is not yet relevant to any guest-memfd support, but paving way for it.

It would be much easier to review this with the guest-memfd support in
this patch set.  Any chance of including the target user?

> Here, the major goal is to make kernel modules be able to opt-in with any
> form of userfaultfd supports, like guest-memfd.  This alternative option
> should hopefully be cleaner, and avoid leaking userfault details into
> vm_ops.fault().
> 
> It also means this series does not depend on anything.  It's a pure
> refactoring of userfaultfd internals to provide a generic API, so that
> other types of files, especially RAM based, can support userfaultfd without
> touching mm/ at all.
> 
> To achieve it, this series introduced a file operation called vm_uffd_ops.
> The ops needs to be provided when a file type supports any of userfaultfd.
> 
> With that, I moved both hugetlbfs and shmem over, whenever possible.  So
> far due to concerns on exposing an uffd_copy() API, the MISSING faults are
> still separately processed and can only be done within mm/.  Hugetlbfs kept
> its special paths untouched.
> 
> An example of shmem uffd_ops:
> 
> static const vm_uffd_ops shmem_uffd_ops = {
> 	.uffd_features	= 	__VM_UFFD_FLAGS,
> 	.uffd_ioctls	= 	BIT(_UFFDIO_COPY) |
> 				BIT(_UFFDIO_ZEROPAGE) |
> 				BIT(_UFFDIO_WRITEPROTECT) |
> 				BIT(_UFFDIO_CONTINUE) |
> 				BIT(_UFFDIO_POISON),
> 	.uffd_get_folio	=	shmem_uffd_get_folio,
> };
> 
> No functional change expected at all after the whole series applied.  There
> might be some slightly stricter check on uffd ops here and there in the
> last patch, but that really shouldn't stand out anywhere to anyone.
> 
> For testing: besides the cross-compilation tests, I did also try with
> uffd-stress in a VM to measure any perf difference before/after the change;
> The static call becomes a pointer now.  I really cannot measure anything
> different, which is more or less expected.
> 
> Comments welcomed, thanks.
> 
> Peter Xu (4):
>   mm: Introduce vm_uffd_ops API
>   mm/shmem: Support vm_uffd_ops API
>   mm/hugetlb: Support vm_uffd_ops API
>   mm: Apply vm_uffd_ops API to core mm
> 
>  include/linux/mm.h            |   9 +++
>  include/linux/userfaultfd_k.h |  83 ++++++++++++++++-----------
>  mm/hugetlb.c                  |  19 +++++++
>  mm/shmem.c                    |  25 +++++++++
>  mm/userfaultfd.c              | 102 ++++++++++++++++++++++++++--------
>  5 files changed, 181 insertions(+), 57 deletions(-)
> 
> -- 
> 2.50.1
> 

