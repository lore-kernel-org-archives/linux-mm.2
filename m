Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43867CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 13:34:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A45818E0021; Wed, 17 Sep 2025 09:34:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A16578E0003; Wed, 17 Sep 2025 09:34:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DE3B8E0021; Wed, 17 Sep 2025 09:34:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 75B9C8E0003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 09:34:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4B83C867DA
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:34:30 +0000 (UTC)
X-FDA: 83898836700.11.01BA6F6
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id B45FA1C000C
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:34:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Z6jGa//T";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IB9NgdfU;
	spf=pass (imf20.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758116067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qhQMk/PqIgSP68y2p/p0sd3OWMbtZ4R+XmVRhpk/tHc=;
	b=jEWn93nQRHIiK2metZNt67eGufA9qfVyFdJm72KaxYzxJfuRXOyibB+3naIXDiQZ+D9+a/
	I3rH9rkNfhJBMTXjWyY1DrTMqXb8HJiilTKBenAOblJzVN2p8eieVu1jFzV8eQbCpMOtwn
	f/InS0ECz7ROlE7p/9xJCnx0sUsX/ss=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758116067; a=rsa-sha256;
	cv=pass;
	b=OTs1+OJRqRJcaOYD1Q9DLf3/xjr83ArBuIICGLllRvS9o7JWCYyjwQdM+PL0nBRFIu+9DR
	u+JDcSWWTHjqT0ghFmsbkDnA2vUhsPp+IZuJnfQDw67FRj98MH9ye5CP87Lv/cScVbD8Vt
	OZOCEEcuTBlnM6zMXFJXGsKS3aGRd0g=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Z6jGa//T";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IB9NgdfU;
	spf=pass (imf20.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HAR28A012260;
	Wed, 17 Sep 2025 13:34:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=qhQMk/PqIgSP68y2p/
	p0sd3OWMbtZ4R+XmVRhpk/tHc=; b=Z6jGa//Tjv54iPW3JQGLIsED3jBe6dyex8
	GEbGt5Bv1XameMDgV80SJBi2R7YdiXUS3QEOW2OijQEjYUrx2/aHsL1mNs8Dzkky
	7xvAYII+LG5HXrB1WMFRDe4KNBNdff2lWV+XtB5zaoIKn4oVC9Lkhc6S4e46KeGo
	2IsyRkYiAop0izprzQ+auVwFusagTKnk3Y3NXxirKNI4WK0sYGsjAwUQ0jcz7R2c
	yOukqnMw+SNi1KC6C4J2hsI5JOPlauDLYm2oA/TrSEl48GcT8DGoc8G5H4UPkYrr
	moRC9dyYOoR3EPWL47N7xwORzKys257tAjAG0/H1jnu1V4jQHECA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497g0k98bt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 13:34:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58HDAAMQ035162;
	Wed, 17 Sep 2025 13:34:19 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011052.outbound.protection.outlook.com [52.101.57.52])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2m2y5k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 13:34:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EIvJM+u+GQ2z5c7TtzLMWCyV8EULLy10YeCPwGYkeK15gFJ0tOc/oOqMuCCmPaxMHYTc+Egbxl4NLYJySobR0xC3clHH2uWlJMXqpbFeCxxe9EAJWMS4oFpSsyUdRlVQK0HUU1TPjfRrAYt+Ea9D/OyoduAq+oRNGsBwDwa/8hamahaY0zqfHzO8XcH0uZo+JdhoH+NVuOPylNH6AM1G16AMZ8rtrbabByxZthq6v9tQdL6jJKN1A9fJCmDdhNtsd+AtB5edWQT9oitXzn0M/pOjGxq48plZ8IlsrlANgOyDz+y6Lq3o3j3m43ItPI9GQDvDKKgdv3B8ocxeODCSPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qhQMk/PqIgSP68y2p/p0sd3OWMbtZ4R+XmVRhpk/tHc=;
 b=rc2sVnhG3vHUuJCna8EFq8b3wn6+7puvoaQ/ce7mGCqLFlESBNzo5SQCykdAB1UVODY4yfNRvmqTy4wRUY714+PMnUP+BpK/e6NGWtTG4yNA1nRtMp5MXmHyUJ9mJ1LgqDg3UiZ15gCvo+rWWOi7rRClnT9PvjOnULmD+Rsy0r3X5xf6ul7prWkKGW/qRHSx0h2IgPPXtikp+g7xNNAYMHT1Om3OFlJ/T5C5dgPlJGYwO6uSL/BcDcZ76EPM0LzGSjq/7zQK+lUrHKtjVifBTDIeWmI6U9zqhq2r/FlZMg7zHL7OkV2qBKye8N4o+LPgfB5O4aAJ9Ev21ucBHOCEpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qhQMk/PqIgSP68y2p/p0sd3OWMbtZ4R+XmVRhpk/tHc=;
 b=IB9NgdfUnJ/5jR5lOoozsMUp1QFNh6PuE6X+Hkd7JkNvK4JTiLHmCKRgDRk7p9737w+TIvZxL/YcwFH2nOqxM7Q7aJLKRdVOiIVCLqiZJfjiCj3gKWRBvmIrzSnPpStJkiAcQ2wm6aPH3okxgCcDsSABp3VATO3CerKpT4/4/G8=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by LV3PR10MB8034.namprd10.prod.outlook.com (2603:10b6:408:28e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Wed, 17 Sep
 2025 13:34:17 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9115.018; Wed, 17 Sep 2025
 13:34:17 +0000
Date: Wed, 17 Sep 2025 22:34:10 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Uladzislau Rezki <urezki@gmail.com>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
        maple-tree@lists.infradead.org,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH v8 04/23] slab: add sheaf support for batching
 kfree_rcu() operations
Message-ID: <aMq40h5iOjj8K7cc@hyeyoo>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-4-ca3099d8352c@suse.cz>
 <aMpxnACqmsQl-lp0@hyeyoo>
 <bbda8c25-b575-4e98-b1ae-b103c6598d38@suse.cz>
 <aMqcXyKRlZggLxu_@hyeyoo>
 <6f92eca3-863e-4b77-b2df-dc2752c0ff4e@suse.cz>
 <aMqyn6nenR8V_p1y@hyeyoo>
 <bf8b4741-1025-4cc8-b9ed-5b566bdcb2d7@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf8b4741-1025-4cc8-b9ed-5b566bdcb2d7@suse.cz>
X-ClientProxiedBy: SEWP216CA0113.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b9::14) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|LV3PR10MB8034:EE_
X-MS-Office365-Filtering-Correlation-Id: 460719b1-aa7e-4dc0-c517-08ddf5eee622
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oVmUy0ex3GJxmBg91PPYTD8+jkeAQgRB+TVJPIvib9y4/cwat2+LPw/nb6rN?=
 =?us-ascii?Q?dcqUCc+Ot+kEF/oicHO8uBAqhM1zW0uOn55kicHVkEQBMuxwOg1ATyXmqMbP?=
 =?us-ascii?Q?xsOH5KzcMJ2LVH2BsXoE4QqA6RiqfJfyu+86TWoOMitiS6sf6IQElZ1a68yt?=
 =?us-ascii?Q?dZyfAH2XYDUlxFyOmuIJUTlmXqszPTXyXeyGYnqZY+/MIUEXQ1CHZq1E6SG6?=
 =?us-ascii?Q?9zAYRk41ELI/7e8B3aXkBzJO+mL0PK2lo8QG6vlEr73zTAhTOyLMLW5FMfss?=
 =?us-ascii?Q?uzxNTCfQ6OdODrnt+pEztb70SaNN2/KLZb+wXSWtKzXbOTTuEvilStI/nYCh?=
 =?us-ascii?Q?A9uUweACGzJrchnAvdlAEFO6KUQTU+IiFO1S2SOFqm9mLH69s9xUfwl92fFl?=
 =?us-ascii?Q?HCIjA/EupCYH7J/KoVFtnIcqYlmjJMjfGZVjUwuCJMNs4jf7hIAwjehvnOIy?=
 =?us-ascii?Q?RO7IJvkPHoTPZLMAS5Y8JGqDh/Yimeg60ZHYu8aSb7xnXo34o/JtJKEhYkED?=
 =?us-ascii?Q?YNLelEsQ07SyJae9OMhLEJwfuA82nrkcvMx1tPdvWEG+jTOgAEt5AHqLX5u0?=
 =?us-ascii?Q?s3N/Vjq+sakFzPZ3Q2gFdz9GVKWHImUwsdXi6NwpeVPe0ThxTyCTPqQw2kea?=
 =?us-ascii?Q?MOgcvZJ9XO8/IOcwuwl7dAlt9o0vie4NS/lXdxq6kR/5cDo8BrjYMjjK7dVX?=
 =?us-ascii?Q?UEWmAIskPc9cOn1Oi4WwfF/D05vg5UEvWA1b4SkTv3p/ja1Y1RDYKSE1BKoH?=
 =?us-ascii?Q?Y8m6HtfFqFoS3hKVXwAaGmyHl5PHUdiMAJBUVZeeKcm+/UENS30G1XOQaS/S?=
 =?us-ascii?Q?X3xGLHxtZvm2dUbUhGyXzUtzG8Scwn24nVLBwQ4n374LgeiJKGNoTLJKPtOU?=
 =?us-ascii?Q?m9644ZTEuxJZw7zZcezmWceGGaZ+tTDlcmz78wtkcSO0PXC9WIW+71+iqcZ4?=
 =?us-ascii?Q?Bnf+Qqa98z6DSJYW/+gQsLNgH12rRVjloopcSqR8lnm+Lgi1ASp3wuHlNTwC?=
 =?us-ascii?Q?w4T2CS69Gesd5cpXIGP83O7CUKyPr0iwxFJNWmSPCJ8qMB2sw8C9aIDFH264?=
 =?us-ascii?Q?4fpKzkTuOn0zgOoijZ5thrap4+LMYyEbAthVLH8jfbRCdjb63OcB4G2frwoP?=
 =?us-ascii?Q?5ZIlX3Yztx9uxHnicE4Eb17ke5c7WKe7e0DS5N7OJNOP9wWrkNk0vpSL8XoS?=
 =?us-ascii?Q?PlV8K7of4CH1HSq3NpIdtmGIo+xEY5Ip8QgjsJXyvI0nO/xB3zkIy/E0ABqQ?=
 =?us-ascii?Q?8wBrPyKrYlLoWQM2bO+b93F4mC9vIK2L6Oz7GLJ55SwOJrFIY/WJjsVAmxac?=
 =?us-ascii?Q?+pvh/yQCTl02K94w2YliQhrzxyrZqhvvhV0oyBmMr1pQLnkc+6euF/tVO8NX?=
 =?us-ascii?Q?jlJX3d1XBq+cUUK3aOzfk1ld/cB5tn+iDDo1NDN4e4YYs1RIYHeNNgoht4W5?=
 =?us-ascii?Q?vAuMOC+Tsoc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jDLZoP3iCGClww/4XrV/UuKNE9ks0647Q1jl32FDoE612ohyS/kAivASZwvb?=
 =?us-ascii?Q?9JGV6UshBEGvpWe9oMSQiD3ezcYJJHammvIRw+wv2AVmvxeT1CpniQxKd1pi?=
 =?us-ascii?Q?WoFPv4G7R2+frSiI2DAZeUEGahnNtSvLCnhesHOBICjt5KBxBipgzoS4WCMn?=
 =?us-ascii?Q?dKj+SoW+MP0imAExP/RbOxcYp+GzhSsxCKHaqbSderyDBZv/ntTpStG3B/qr?=
 =?us-ascii?Q?fLdDI5+J2fOvbV9q9EZhKkwyijqbPiXc9yaGLHGwrwxVq9QWNFUxaus81cyz?=
 =?us-ascii?Q?r79H6uKtWf8YYL1DUSx+k3bD3Vg22AA9qiaXxNWOTuSR4Kw+vXVvPz2L+TYc?=
 =?us-ascii?Q?riuAdOtuiV9vnW8jdYfvVxhyNWTJO4pw9CsSOvJPO3EAzbbxxIMAvQv+Qxn9?=
 =?us-ascii?Q?tOKSOnt0bxbY53VBYIhQJWAqTNrSiBQbI9uiknm7Qx+EbZK1gSB579BeQ3f5?=
 =?us-ascii?Q?c/ncVoRsqutVGTd9Tu61JSmyX2UMJSyL+ZtBCA8T9rwUU+LsoqcSX1Yb4PPd?=
 =?us-ascii?Q?0xL/0r/vPTqzBH0Rc8HrpvkVH7qcGNkpH6XcvEKJA0dyJSmtGgATypCYq5VJ?=
 =?us-ascii?Q?6HFs6+ihS35WDWwkbGMEKD/wt9G+fpyJBIg92zprRQBzpVqo+8JpA5gTtjZs?=
 =?us-ascii?Q?ge8DLJsUGZBm93dNhnyPSHNSPlKxh8Goy9V1OMnx6kMDp4Kf0KJzCD85dFqw?=
 =?us-ascii?Q?TLstfIH7eDY6Rc/tAwM4wQhXTRSCvA98zBrFhKOmdrzEzfYD+j/D1EoMn+qy?=
 =?us-ascii?Q?OEek9Ju9FThsbbuN+YhKQAWYQNn5AEeWFdOwEw+qI3tkBxw9qnys8Hz7mdhK?=
 =?us-ascii?Q?c/J6ppdfjudojrZQDHzJVmuYcYjnG61C/wMBct+NtghKr3fg2DyJrMnEz4Xm?=
 =?us-ascii?Q?Q4XX4B7EBwSwAM4nFFp4iIBVn/pow6fyulLbfPBNDj2jSj/7BFnFB2jxTrke?=
 =?us-ascii?Q?tdlaQmH/PbhLgle+ZUcAxleCIr4l3y58OQM1ZDszfqteoMQDf9B95QU1elrd?=
 =?us-ascii?Q?hG464I67FTS7EBtBnMXeuY6laXvMw11zNreSgMmqEQ0OXzqOKXCarpP/iUlV?=
 =?us-ascii?Q?BaYBq/0S9/4XYcicfZRHJu4OIlnmDgfHyYNk0xZfmpOOnfWHgcf6OToRj5MN?=
 =?us-ascii?Q?GCRIYzHdBWXvLILp8/WA9ZaMc1lCiDLZ60AwhPy9N2zG/5LI+a6o6l0zCtM1?=
 =?us-ascii?Q?QSXmkHVhAIoYR/n3u3oRPHCb3jWp+psfTQ9mLfYoxFuX0D7XbEgAtfR5rxZR?=
 =?us-ascii?Q?deR3Gn6mLhk7eEYHIsTFmlI7ASBok87q14893LGAk4lS0XAWCcIdp+JLTGTI?=
 =?us-ascii?Q?pXLVkXtkZQjUvBAv+2el7OMaZwiI5MsHyF7G+VoEYRP9+3he1ZBALJfcaqKL?=
 =?us-ascii?Q?ew9BmDtgYUMfHoatUA4VgrZLnou5XigFeMIec6Ss/YiYTEHxVzYSj7FHjcvL?=
 =?us-ascii?Q?NSWwQlwJVCHPCCc1Qi1Epk1gVEi+UaHmKvp5sd11mt+UyvDtxosA1s6B+Pgt?=
 =?us-ascii?Q?3XYz69nKBUWRlAg0FB2gI4hGVx3fM9fWFGWZwsWMhrhKHRqtg0zHzmrqltcw?=
 =?us-ascii?Q?BUBS4b/Qy+FJKtj2e7IungNoP8SvkFXmdULOUwzk?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hOAh+jfHMVx4YSgNLv2lUatOCacV8IfrX0RwZNORKzA16sJbSJ/1H3qNWqDgSn2PbwHfvq3z016jGPPsAVh04zcd8+IIpPss6inituAfP02mmF67g+SrxGK5AtI37clZsokGB5EC+HxExKIwe4XcM33OhPb9naqWlN4rHgCCvoZYIRCrsIWdyIwK8gNAT7VTR5WxbpgOkypRVum1vocB9h0O4DNBTBUXKYpGTwObxliauoGVPeOiC3XOL6I/ggDFhKkN7hGrNE5dMf6CKnGlBES57jT/46OPeiUUsnJl67H3zoGeT9RLm9w+1stz7jHsIvihoYcMPnyPzuWbUpSWZgOn6ecYRefPZD53ZXbt4/KeIRlrbEaX70TkA9/bglRZDWVsS6UbMCGIqVktWBdcIvMLiUJbp82E3tL+3lWbUCwS7P0WwDd3ZksJcg8BcWtbH1hfFS+AeXH0hwUCGn0T2Kz6REws5VEKn3PF72DVpc8DwMVGpTZtr/VQrypmsVidEiePk4r9kYN8lAF9/f/iMaSb3wHYog9qCX2hiEAAZ6uGs0cE+HcIthePwuS6l24a9a/s12Jsc5ZG45W+x0/uBnnJeYvSWstp2vQyUhJZ/4E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 460719b1-aa7e-4dc0-c517-08ddf5eee622
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 13:34:17.0389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NUqqaI+Q9Krp4+CfAjl9skelnPDKbVNoj1mk/D5X7wVRJNJRmiW78lqkHv4FFJfnAy32kVaF16JT7LeCFYwpEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8034
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509170132
X-Authority-Analysis: v=2.4 cv=b9Oy4sGx c=1 sm=1 tr=0 ts=68cab8dc b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=ILiG1BNqy1wTlrwMNIUA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13614
X-Proofpoint-GUID: 0fuUue9BbQoA4V_k0-Yrkg6N-RMEa8Ug
X-Proofpoint-ORIG-GUID: 0fuUue9BbQoA4V_k0-Yrkg6N-RMEa8Ug
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMyBTYWx0ZWRfX0qla2lv4VHRk
 7p9HAzPUyI/U/1K1xr2ru8EcE2WSwJ/aPh7EUAYHh6aIKoJvntCmKUjPPJbKumqpWHG35fB7KXC
 /md+WFdifha4gsJW8EFHjLyDnWT7YC6MPagSs7G+PFAgNgxc4WQXtC9Xjz26D44Y/BhRmNOlZdO
 Z9BPcDJO9IusLX+zNwgSnkz1nNKnAQw+ll+t9M4XnDwmnAXWZ8xp/eSPfOJwNvjcNsyoi/i58d4
 5edgDj2hzRZmM431QPUiw5N7ChPQr7dyisvHvgSjWfoo74mS3hQJQb5HKH2pY+joBOIgvYaehyF
 MEf8maa27VPClu76WNn1nWXTgihoWI+LQT3+VFGNzqFZ24nZ7cDPiOeoKsEkxHszePGAa7v5c9j
 lifOUwGj1xNd1W/g+B7mp327ZtRjuQ==
X-Stat-Signature: shy5kpagr7oj7cq5a4nk7esurhb55jq9
X-Rspam-User: 
X-Rspamd-Queue-Id: B45FA1C000C
X-Rspamd-Server: rspam10
X-HE-Tag: 1758116066-373920
X-HE-Meta: U2FsdGVkX19SkQ60EyOjQcU4xk6IDLHCNb/sW5I3NUUrnEJVokPmAPVqTazq4eGi0iAnNJ6h/FbKS0HvEN5HAZQ+iCtgwHmbJrXOYA0Z5iEAnI9dBe7HVFcnXcUhl2F16f+EV297zhkb6bcXgG9k+Oc6cKj0kOXrc90L4RbaL4DYLxyJdoRfeMDm2LJokjKIkJEn+Te9hE/yV6M1lqb+2SGW8ZoJs817h/bmJxzcKBZ+OpdXxM2riwMwhyqTE3U0/EznsIf9YIzb8XEJWT0eZoMq7tdsS/aNJxZRlFCjl2gJCVyXPv2RLdid0kthREFNWXeQM/xBke2X5sEQmfwSq3GokUIhdo+UIVvBBfo+9fYKaZxPUHn7N3KZVNzFETB0BZrr5LtpFQcpA0TSr25Cfq9qMI2fVvZoOY7YAup8Z34ohL/bpzabzG9Wsx46JGisR5TdYz4KT2LMVEBMxDf92q3ZbeXThwGa9YRQXhyp2WizNIBffBIPIpJ3LQMvNLSjpjhGYSV+w1uQCJLherhiWwvQU1h5AHXABopYO1WVNWViyKNZmdrXv4KTZgT4k+tldALT/hrr6Xg50f/6e8S0yufi690D1ncP/jnoi8VsGIkJ1ZrpaEkqM4fnRx9W9gxcJqFI0WRaQKEaAfQxL4GrHYew60xXyqPP2BD6EJKILDYJ3NwQBdWs6LxexAaNCkc2n6xK749r735nykHOx6yuqR52LMt4xs3QcQcM3qy0SlB6LPnYCgW0YYzXCnExMlZrJCaaXIBpcga+GzWVpwQxPKC9hTT3RDBNrEwylw4cZS2cNNO8RTRPu2HtW678Oedo1n17edb2Ulq4iFt3SVATDgPZLdtHfT8ahtG0s0Z4G7oNDzJETv8r2P1kpXXXkTljLhF5S0KP77hRFVxoRDFy4OL8jLlc8FT9rrbEXqDrdkkAyHi5x5tQN/blqwYfjnzxnx3Xzm4ClhpjgApYHC7
 Y/cvbVtc
 AfqpG3eIvStjjmM0MWLoMlYoSzZ1mgaN/Q3MkRfOHEMLem1t/22Q6vUs0IsCPjmz5D1ufTJEK6sx7TrI0v44oHcPRv9ZmESTdt+o6rtk4O4wmyhg1mR3lYNX9Ei1S+aP2/cW7DpCWW6EHx2Wcwf2o/nvLOe2KuAtmZ6g8FUSPmZ9/a7CY+I6Z2JPfLSZsuJcyM0UTkKH5llDNGMoQJRrZ+QtDjQDLEdCloKDITeSBi318r65zqC5M2MAHSIXgJkv3JbOhCp0LkbCnVoSnmFdcRU5dsRk8qP0/l9GMoEqhihuhqiL2jlp01ylKFjY9cRTUaNbyNX0fZoP0by/jXZTJSYixQb+85KRbZu5qx7iFA8E4FV8gTXoQb/DEB1CckmKTWeJSMDA/fHI/rYcf/8UnC2a3fH4Vj8kYSy8JWh3iNws3/LAoyinj+vyGD/IVPJLQ5DOkXUZ81HX9CnGZ1ZXEwDzEIn4Dkxy0eIAba7Gqtz8TEFWC+Hm06RxDDXSLtgYvgDOnzUDMG6jRlmOuA4lhFKQ/TzbJw9ZxEh0HoBQrOLglxKbQhQIxSLd1GUOinl0WVAVPJrBLpaK9+bCXis8XBmcQOs8tBohb3Gx3Ek5XevlwLIpN/6CwCKc/vmB9BsVAWULN8oTpEnz9RdWFWBLcQz98szGfYBxGU0uA3NSlHVadJgR8FzXmMdPr7ITtzlPaeKQm3sEZzBotwqASv1LYuBDp15ZJuj7Rt3WPzXcr3zY8/fBIgxDuoqarESbghYmEgXp8san3/qlu9u0akVyN22oX2AUhR4KtTLPDfWWu9atCy+Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 03:21:31PM +0200, Vlastimil Babka wrote:
> On 9/17/25 15:07, Harry Yoo wrote:
> > On Wed, Sep 17, 2025 at 02:05:49PM +0200, Vlastimil Babka wrote:
> >> On 9/17/25 13:32, Harry Yoo wrote:
> >> > On Wed, Sep 17, 2025 at 11:55:10AM +0200, Vlastimil Babka wrote:
> >> >> On 9/17/25 10:30, Harry Yoo wrote:
> >> >> > On Wed, Sep 10, 2025 at 10:01:06AM +0200, Vlastimil Babka wrote:
> >> >> >> +				sfw->skip = true;
> >> >> >> +				continue;
> >> >> >> +			}
> >> >> >>
> >> >> >> +			INIT_WORK(&sfw->work, flush_rcu_sheaf);
> >> >> >> +			sfw->skip = false;
> >> >> >> +			sfw->s = s;
> >> >> >> +			queue_work_on(cpu, flushwq, &sfw->work);
> >> >> >> +			flushed = true;
> >> >> >> +		}
> >> >> >> +
> >> >> >> +		for_each_online_cpu(cpu) {
> >> >> >> +			sfw = &per_cpu(slub_flush, cpu);
> >> >> >> +			if (sfw->skip)
> >> >> >> +				continue;
> >> >> >> +			flush_work(&sfw->work);
> >> >> >> +		}
> >> >> >> +
> >> >> >> +		mutex_unlock(&flush_lock);
> >> >> >> +	}
> >> >> >> +
> >> >> >> +	mutex_unlock(&slab_mutex);
> >> >> >> +	cpus_read_unlock();
> >> >> >> +
> >> >> >> +	if (flushed)
> >> >> >> +		rcu_barrier();
> >> >> > 
> >> >> > I think we need to call rcu_barrier() even if flushed == false?
> >> >> > 
> >> >> > Maybe a kvfree_rcu()'d object was already waiting for the rcu callback to
> >> >> > be processed before flush_all_rcu_sheaves() is called, and
> >> >> > in flush_all_rcu_sheaves() we skipped all (cache, cpu) pairs,
> >> >> > so flushed == false but the rcu callback isn't processed yet
> >> >> > by the end of the function?
> >> >> > 
> >> >> > That sounds like a very unlikely to happen in a realistic scenario,
> >> >> > but still possible...
> >> >> 
> >> >> Yes also good point, will flush unconditionally.
> >> >> 
> >> >> Maybe in __kfree_rcu_sheaf() I should also move the call_rcu(...) before
> >> >> local_unlock().
> >> >>
> >> >> So we don't end up seeing a NULL pcs->rcu_free in
> >> >> flush_all_rcu_sheaves() because __kfree_rcu_sheaf() already set it to NULL,
> >> >> but didn't yet do the call_rcu() as it got preempted after local_unlock().
> >> > 
> >> > Makes sense to me.
> > 
> > Wait, I'm confused.
> > 
> > I think the caller of kvfree_rcu_barrier() should make sure that it's invoked
> > only after a kvfree_rcu(X, rhs) call has returned, if the caller expects
> > the object X to be freed before kvfree_rcu_barrier() returns?
> 
> Hmm, the caller of kvfree_rcu(X, rhs) might have returned without filling up
> the rcu_sheaf fully and thus without submitting it to call_rcu(), then
> migrated to another cpu. Then it calls kvfree_rcu_barrier() while another
> unrelated kvfree_rcu(X, rhs) call on the previous cpu is for the same
> kmem_cache (kvfree_rcu_barrier() is not only for cache destruction), fills
> up the rcu_sheaf fully and is about to call_rcu() on it. And since that
> sheaf also contains the object X, we should make sure that is flushed.

I was going to say "but we queue and wait for the flushing work to
complete, so the sheaf containing object X should be flushed?"

But nah, that's true only if we see pcs->rcu_free != NULL in
flush_all_rcu_sheaves().

You are right...

Hmm, maybe it's simpler to fix this by never skipping queueing the work
even when pcs->rcu_sheaf == NULL?

> > IOW if flush_all_rcu_sheaves() is called while __kfree_rcu_sheaf(s, X) was
> > running on another CPU, we don't have to guarantee that
> > flush_all_rcu_sheaves() returns after the object X is freed?
> > 
> >> >> But then rcu_barrier() itself probably won't mean we make sure such cpus
> >> >> finished the local_locked section, if we didn't queue work on them. So maybe
> >> >> we need synchronize_rcu()?
> > 
> > So... we don't need a synchronize_rcu() then?
> > 
> > Or my brain started malfunctioning again :D

-- 
Cheers,
Harry / Hyeonggon

