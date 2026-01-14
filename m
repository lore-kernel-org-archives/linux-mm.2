Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ABBAD31A15
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 07:30:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A10B06B0093; Wed, 14 Jan 2026 02:30:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BEB36B0095; Wed, 14 Jan 2026 02:30:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 841D86B0096; Wed, 14 Jan 2026 02:30:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6E9AE6B0093
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:30:44 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 21BAF1BA71
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:30:44 +0000 (UTC)
X-FDA: 84329747208.04.F20EBB2
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id C8A14160003
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:30:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lu0MzlgI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=kyHFuk2c;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768375840; a=rsa-sha256;
	cv=pass;
	b=P3Nc1NXVC4KHNb7TPw7a0ld7LuIFQTqNcvi50ywrPn4Yj6w6NQIkrISmDMlJQjDaDc/GU3
	3zVkiFvyVcy74tH8DAFIOnNI65D2TRGnuHuDQ18ZS4albWzn6scydIMhKJuSjqHUCYzcgn
	W4S5aP/dkan+phfC5ox6y3IuwaFh8lY=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lu0MzlgI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=kyHFuk2c;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768375840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+vZe1c9367IxNe8GrVnQUutQtwYHx5Ai9TiAXw9NH/Q=;
	b=5zzVIRgiW+DrtxiVk9mWNWH1H6WailRRx7lGZcQn+2rR45WVw0kJMuwn6SPhOV0qHDbHY9
	qhRHJQGmMn7SqVXd0G+D7aWvXqxcSjNEJ6KYOIiJJdYadkY70hzERw+tzv4gTEl/5mTRdO
	CogpKsp0qcvJZngTJVdFdyMddfH1XMM=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60E6CVND1940060;
	Wed, 14 Jan 2026 07:30:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=+vZe1c9367IxNe8GrV
	nQUutQtwYHx5Ai9TiAXw9NH/Q=; b=lu0MzlgIcwSoI9NNFavY4Opedg9UquZiDH
	TB7f6ZeWooylB9kahXgYH0OMfcVzNjQcrDfCWvb45wO2M/Ou2p7H8YQZuM/ukD/L
	I0p2opDDO/EDNtibjC7SrdU7ZwPFmE8b5UAnvVUhWMXHty6yXXXMgh5cphq/vv+y
	k+jAK1ngyO85/NhZUatEQqWo6XTKNxT8jwZfPypF2kIKHljLaPI6zjCNPD2ISgDl
	0IOszq6qqgI/LVvu1k6d7f0qXWy1lW4CYABJogcKzvSfDy/Kwkt/7/7hu16xbkCf
	WpuN+B18E4V89j2WAwNLL2XYJ9BNMxmQwr2cfC6Nkv5eoFmZNBeg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5p3822y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 07:30:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60E7PPUT033952;
	Wed, 14 Jan 2026 07:30:35 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010018.outbound.protection.outlook.com [52.101.85.18])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd79qj5h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 07:30:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZEmrmBjBClkSdSu7tpPDFfEJ2Yf89/pmrwyCFO7Wo4OmdbCvddZpZ7hiW65118llp+3FSbGc4YW4R3ld3TixCrCFATkIhfUtb4SDxzBcj7D3b1oxay6tfi8NWUkRN8JttHhRRdjF5fcOpc/A5dGh9tGIqBBP/sIRqObHvSq54dH3fhBZwAjjR1lplPAWXqwx+/Fb2ULHKIgfLJEHHA0y6z2DjauM1rNf/nUAIys+KUyyUtKlQE+mCs3bCj13JMcZaENdScQVBj2WX1iA6lwrFcE6p84Z7frGsFi8oMVcpP+xyCfmtk2bkEr7GZ8FWH3Aw5sQhE5lm7qK3qKDNwN0aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+vZe1c9367IxNe8GrVnQUutQtwYHx5Ai9TiAXw9NH/Q=;
 b=yTquXRnBu8H4UR1GYbqQZI9z+kZONgLc3cD7XsQ3+MNNd016WyJ+MjIgqhdT5+cBGkDcj3QoYdGH8l74/xIguIENWmRhSkonhQJisYn4mRRAA7HcCrg2qOzP6vSI3EwLn7k3ae8CACdFYPOAdDQIBJS+I51GTxuIfAVgu2eNpDfmErO2o6Sqe75I0RrssU7Gu+OtGHqQsJeZz3gmvjpZPpGbkPNw9OHjrsKc/ZDmu7g1aZ2q2YezrWvH2ZznyhAVgRYOC73i4hgxvQsIPQzplw017VlPaNaJrWcaExNVOa0ikdXb+rxpAWZiPF7RJ8wwrZzmR2ob/yMrcMA6OO/6wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+vZe1c9367IxNe8GrVnQUutQtwYHx5Ai9TiAXw9NH/Q=;
 b=kyHFuk2caHB78Ni3K792/F4icBY8+BalVu9Ro7XeyHNPqjk8lNjzNJF1I14P0QLL/DR9IpMIt9glyyCwb8IyMaodke2msKtHg3KqIfbjJRvZb7Zx7ZAfz06YH15pzfyUpAIjBkdLMSCKdwjQBxuFJkle7CVhkn/msnreFxQyN+U=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by BY5PR10MB4354.namprd10.prod.outlook.com (2603:10b6:a03:20c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Wed, 14 Jan
 2026 07:30:32 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9499.005; Wed, 14 Jan 2026
 07:30:31 +0000
Date: Wed, 14 Jan 2026 16:30:24 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>,
        linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Mateusz Guzik <mguzik@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 01/15] static kmem_cache instances for core caches
Message-ID: <aWdGEI6iQBl3Xibi@hyeyoo>
References: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
 <20260110040217.1927971-2-viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260110040217.1927971-2-viro@zeniv.linux.org.uk>
X-ClientProxiedBy: SL2P216CA0199.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:19::22) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|BY5PR10MB4354:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a76f226-df8e-4798-15fc-08de533ecc55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5NRnG4yqhOzpWuqPtUm6f5oAwPUrN7gjcXST4Z0ETy8dFWz/O/jFdIyU0MUp?=
 =?us-ascii?Q?fRDfr9LlBjJ9Vmrn0kLjUOOsv2lrUXbBTlrQNc3KKcUjpNj5JrTlGIC4dA5g?=
 =?us-ascii?Q?RvYAkyh+JFVfgNt8DptMCTJfxDR0ktdDYcTaoEXxCPA9eicIMVG/aGQvCkTB?=
 =?us-ascii?Q?mxYFb1KMejFCwSpSAblTbEN1Pe/b6F6kwhGljmqIv17P7PyrsABYjeiXcs/F?=
 =?us-ascii?Q?RvIBa8fpgEX7Bl63yjY4kAVK7Lwr/LUC0IrMJH5218zzCmADM2Z/qVqpEImK?=
 =?us-ascii?Q?jTuFmLVGXfT9SGgjtmyuP2r3BMcqybcyIxugHHSI36+LLLibXh6GtnBdbufq?=
 =?us-ascii?Q?lCDAja38Q1wdaAho7NxU68irlYG4oHaQb0kZ5RnaYuAz/nNhkjjpnS2zuSho?=
 =?us-ascii?Q?7hRg7/QfWnWOfUO3eXyb+jgs4luEv7EttN0e4dscUC3hDIVVLCOX10r2HdjN?=
 =?us-ascii?Q?x1RK0njIXBbVenl6ONSsUwUX18SFmnf5Mw/7zJ+PIioK/LX6WY8Z+ti/0s36?=
 =?us-ascii?Q?uIR5KfzitGSCSYwpXQf4tunCfKxOE5f3nQVpAftduqPZD2/y30Tchhi90qLS?=
 =?us-ascii?Q?PjwOtlQMXBmN9FQRR1NU9mHhzkn5sfiQ/drurA0UrZZIvi3mVk0wJzJpKrnT?=
 =?us-ascii?Q?7Zo66PtbDPR/FM96yjeVRTn7oW2zv4Tr+mI6QlEkPjttsseAAwMqisZI4dur?=
 =?us-ascii?Q?sp+u1kgVZwn2ihqksrB8oYP4bX5tY1hBJr55mqrSeFlLYBZ0p+BZ4yP4+MlM?=
 =?us-ascii?Q?Dnpb/vkCJjuloGv65QOBQRRu8L2yEaPQaqPb5dYJ8yiA3VcjmApKQwV14M3d?=
 =?us-ascii?Q?1uw00hOlpPWkyvSn44UE4ASSH7XSwCMQ+t1+6h4ZWqK0yAVRmS+L7qnXr/pN?=
 =?us-ascii?Q?0peO5EFBhcdUzGjVAxhoOwm220doWCWEWTceSICL0LPQM9YTy+EkYJ1k/W+k?=
 =?us-ascii?Q?uQtNKp9PwN+HZlwVNZBEL0duPjYpqMlqrN2xQCYHdS/vw2zTVFdW+NwE5fTQ?=
 =?us-ascii?Q?XlcgXYNRBi/z8tR/oKIKJrcsmdAqBmst89eRPspR2aeRP/OY/hSk99cFlpN0?=
 =?us-ascii?Q?oxb6X4OVJRx506IxWt+CnueMLkVvl2XfoKCHaaDd4bR6UC7ZqZ4yI/ykg9Tv?=
 =?us-ascii?Q?tlPyt4PCMdEg6m3YLQO+QmcJY6Hw6+agOWFPOCg6lb59KHntvab4+fvsqrZb?=
 =?us-ascii?Q?lJgQrSSzri7uHJqxLVEfdPFHVPcCpfL6JSy9emfWRwVQm5e+K0VZJTBLvNz9?=
 =?us-ascii?Q?DZJ5h6PQtV4515h70U62EayRzRU9XrCsvf7cW+DZ/4gZO0sZk7BqGl3JSJSL?=
 =?us-ascii?Q?x3uKvVet7CwiswxBldJ+rNvhFWGSIaVPmGGJCx2SJTKvT9cUwOpqZoQUm6P/?=
 =?us-ascii?Q?hdfmNkSrLxVWms7lRrKDPDrWWOle8Dl8zklNYKuiWBK2Zxwkp49peYOHwgzA?=
 =?us-ascii?Q?QS6SPyVNKveDRjd6cURhtW5Vn0V9fnyg?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YOj8sRFfc8Y9wAq8Qs1r0cd8kQP4VNhLhP1rXRu2Ae600B411WPAGTDoAzxs?=
 =?us-ascii?Q?0aD2y68FRbOIwXYpZZ3mLpZXhDtvDa1KiWG8yT8LGlqRL9NXZ3UPQZoCkOgg?=
 =?us-ascii?Q?NTsH5D7hiWQHevprg9Obzee5vzXOpq7OxkKxCQFxo2SSlE4yQDp9gTLQiZH5?=
 =?us-ascii?Q?Ok9+Db7vKrdcnb3sIGFFqFY4w0j+QtL9ANphdD3JP/vqTN2ZoqqY0U+2BckR?=
 =?us-ascii?Q?5NXM9gkcedMtbTqEUC6ZpcE+j4EW8QJmfS+P8M+GmC9ryHGuAlA2oFq/3yHu?=
 =?us-ascii?Q?keM8y7fmOmJyzUPddu2oS5DDq0DDfLFvDd84Qtnr8BB2ZgkJVy9/MJEd6bNK?=
 =?us-ascii?Q?otXB3EHODvh2SKpn8M4Qbj+nF6pJ8YyPBXbskHIDF97247iu5+XHk107MI40?=
 =?us-ascii?Q?IeVtN77Tip0ilf+nVzlniNJjAkbNnLFZNn/gQKzlbMOABzMgO12msm6slv8Y?=
 =?us-ascii?Q?4lCMRoaIA/eqy8fET6hvkG0sxK+Psx1d4P7CgPtjSDU/XnLilVMag3cpimna?=
 =?us-ascii?Q?P3Et6F2yVbW/f7i3pfJbHafiaImi+v352wnMRRpyabbLeESOpIGOSYcbJ880?=
 =?us-ascii?Q?Nt7YZvvnJrRRwlmKZmwRbL+5du3u9RU1WG1VVzh7++wiHDWdhiNo51l3qXFS?=
 =?us-ascii?Q?RBhQ06JTVfw7eUl0qS9aLp+PgGjpJ4qn3JLULoJ9MoGAhGDLi+Wlb6c831vR?=
 =?us-ascii?Q?d93NRJxhZLT7MCZGqowl4NoQJhY4u7VTCWpW92Pvp4zmXMU8s9VOhha8I4T8?=
 =?us-ascii?Q?yNmK36y5YQJ901Liheo+yW5aQkS+II8i6TSzov7OGS86NOw/CnjuBaisaflt?=
 =?us-ascii?Q?L40rw83JcUXcEwYFXWsk6GllzwR5GvXp8ST28sNOEUj2HGstN4IB4O7ojUZC?=
 =?us-ascii?Q?JsOQSBAc307pkx9gfurl3gtGWQNlIWtFVuhj/J67qfvlOzw57oXrtt1mp/EL?=
 =?us-ascii?Q?BfLFhcPoPlBBzJuztvrT/7tNqUvay3g83xRxTQ2XskUuhMjLZ0wffxc7cqJy?=
 =?us-ascii?Q?Cub3NDFbd4bWiFXMhUSj+5nisnWE83xvCLQBKliimECDEgAhCzdTqQmyM8nD?=
 =?us-ascii?Q?RJBTIsg7oJ3GdjPIHd77PfMNiKakJ//Tdo6KGuxHvXTZydcVVrU6qGdo3cay?=
 =?us-ascii?Q?UZK2cdodZyU7WNVSCcq3SlLX9Q3Z6FOn7ARh8Pjt2vYjNQ5RgjS/sUd4DJUc?=
 =?us-ascii?Q?BXhEA8+brS/usyca5DBgx+lcDLrKGeERuGyS90hABjUFUFnfjNYEfkQWgchF?=
 =?us-ascii?Q?MUEirjnExPLDiKzyY1LdqDGxrwMFfwr1uLaPETk1t3JQ9GkSSmZ2CkCOoZ9z?=
 =?us-ascii?Q?h1AGVY32sx3XVVFPI6GaKJOFxelVbFd4HalG42qM9ceggJTd8UcyYyirNXUT?=
 =?us-ascii?Q?NaOgS/Lse9apTdcykmN20CP5u67CPB8OwQA4pOYmSOkDTC9sXVCzZviGJR5n?=
 =?us-ascii?Q?korTsXp/8vR02kG0sokwblUNkKiG+3+wWZi2u+ngK0W+wiU2LnQd7WE5h9JS?=
 =?us-ascii?Q?d+V0jJ00Wm8+7pg5jKyo9kGFmz7w1O7n37O0xOsY8GLtKhvnQdiWAP60AEDr?=
 =?us-ascii?Q?GfFhRXrxQUnqZNM0bLmBM4NcDBIJMmFuAVKSsRwuXIplQ+OIFaNoVzV4QdLU?=
 =?us-ascii?Q?xEojG6E0a9VXDc9qi1w/uVxN+8o2V6Sma+awXF0T+6HtmUgx7oZXh6fDLc1x?=
 =?us-ascii?Q?M/keKlswR886inmiU/RVKfMXujrMjwhEBNWgQGUuEtCsesjZObKl/idzr5FB?=
 =?us-ascii?Q?WoZITKmqrg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wBsozzTCqrx3/SKxiXyo27eJiKgC05NHobjFQiMhfLK3//oSmJOIe5ODqrv2mkTm+NrR5wBNriFumyRP3UT1F/HcWe7hidzvQq3ZxLvLgSWXPXQQIq3ztFS2asTmK4vL3xxeYocTejpeWmWJzwuV9t5TFb+R+thON2fBhR6uu6ZeBHnYj5sfdmJSllBJKCa7WP911ZvPVEKzkGs5IAOH9txK5ujN7RU/bTH3NeQbFnoxRIoQU4ngN9D6EzPUWJb5JFO2o5m/GlVCKeeJu9460jp6z9LURy8sRCenADLzUzQim9nrQ+Y10Ei3bESklttF2FXoqoGy1k610Bt/D1KnQvmIo4SXVK1Cdwb+G99OnBrv1GLeSKKpb6oMZtEwJJbznrjbdvOMoIKPBGXaj/mZ13MTQQCAo19QqFMpX4Mo+sAaPO4U4bhc7BdMiER4EyVjgRhunNugB/SojAZBPPXWyYfh9mR3L8zskwCNbQw6PNHDQEKtP4yzbZvu/2UJG8VQBPpq1DgIgjSVaH8HQYZiQ6j80znS6g4LIf+3Xfpk6WtNizzkfnryj1UV7ecR4g0sSIMrOnWy3wCTbRXpVfapQqLhr1VxN90JK28rLdW20hE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a76f226-df8e-4798-15fc-08de533ecc55
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 07:30:31.7272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0G+DaxlckipB9Yd/aDoEZ1KrY9o4h0rL8HbxcxrS1I4cxSKFEeMQ9AnETfQ9nVDZGa7eTMwA12Z8aY2a1BDk7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4354
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-14_02,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601140057
X-Authority-Analysis: v=2.4 cv=OJUqHCaB c=1 sm=1 tr=0 ts=6967461d b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=drOt6m5kAAAA:8 a=XNjKytXy2Y2ApocmP1kA:9 a=CjuIK1q_8ugA:10
 a=RMMjzBEyIzXRtoq5n5K6:22
X-Proofpoint-ORIG-GUID: lgzjV4VlRi6DwMUzCe7SS8YDlBvJA6GW
X-Proofpoint-GUID: lgzjV4VlRi6DwMUzCe7SS8YDlBvJA6GW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDA1OCBTYWx0ZWRfX1tOq/fOpG7FC
 yQMNPBXkdz5qQeQW7CIYR5t+Mciyx9MVBiL+ylof9j9m56c+9ztGR3WoCaTo5xP97xCX/PpGqxZ
 tdsqithXX6xuGLZiCkDZCOvtrBn/LZvwXuH2/h+dvMY6a+JUaWKmndHU44cmw3/M9o9yUMgAIpG
 nD7eblpVlzC/oZF6eCF8sj6NYosHooZ4dd3HJ14UgEqB2IZQXHcrdeR9uQE1vnmGuX3R/qcLpmi
 8J9MuqZBYZzmAhM/PzRZvjQNggw8QRaO1tJTulMJI/kBx4TbwcrvSq4CfK5AuCZeH2VWvwwv8m8
 Y+26sfTjrD/7XnGDaFE59gzdgFZjSezBAsmgVyuDIEHhRTRFzZjRRCxW07YlZJmnbpeEamDQtAR
 vN10547gnvuPv8ExvLxIm99UwJ6TqVvFbo9A2BO9E1UqJ3glfaeNNMKyQWS5bhI/Yks8+A/myqo
 DFEdjTFlIMSlZEGwU8A==
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C8A14160003
X-Stat-Signature: 83ydriggjpj75czmcepcpoo968dw31zy
X-Rspam-User: 
X-HE-Tag: 1768375840-925982
X-HE-Meta: U2FsdGVkX1/ZxUTsvwKUu5wetaUSSNtQGtuAw0UCHrx4H4dcFYO5JfObJDcwmlq2Npw+oYaH+hztiNNbGnQjfC5fRFozltjCygtvg+5m7T/fG6LhplcVmYydNgbfxgZXMOMblc2w9opFCuNxlDg4V59MUskkE3Ca+bWoeYJdvr/h2Nhhj8UcW3Jc1tvjYeZcaPmnpfZHcP7hgXYtvhu6ZGsepf2Ug7F1dGEkcHV/mtc97QIqcuDek3EFMtGEF6/KNEIv8OQeHEMSGB/PP8qOgjGP15sAaHHFVbV6MK/xy8E0A8l7fjj7GcFILL4sJYb58pEXX8zgKqZt1ZCgeZOfyH467jYQ406qUyPHXtfFTBBpJqwIfKwxi6wHfZ6012nyIT1JbtqwAlzTzttWLMb9EJPAh5+p3u1gv5ig9Co0pm1x/uH2hw+y2aknRFakmxu5Yfs9yuaNWbIA2cbz2PiVUQwPcFmr2xhMsOPW42RJS3Sebzo/rHZr02rzF7anpBQwm0CRWmILmMLzLjdeoybOXu/ZavxfBSC26JvD8Xhh4sjEnInkq+xA4SN/Gd0iBUGdMzoV4vFEPET0wbsFpSGv57YTwRvnwMOAnFWYD3KCQcd0D7rby27Lx35Mtr1y+3d3UDmoPZGEBTJv5ZOuJg3dbqjLjE/FMaJwm58Y3czwYr/aGnf7Jtn2KuLxYAYLRdzQXoN00MK8rcl3BCDHeb8+au8EhWeWduieLPxzzXuQ/6NyhiBG0n+0Huviz3t4XmqmeS/pwEUZEK4I969lQVPIWVw10cIUCpR72Fi/8Cvi8HQQkBoMp+rCNzF8T/4G/4kj9XszSuXOGk7N3ExOi8SljBOYKZ//rvcT5ahZA5tR881KrthpLWqfG4AYyJPP3b9LedXS9RYKvkZPETA1gg5R+SDhohmJILIdD1ZtU2ym1EoEI7+OqHXAwEZpek3+yAvypvq0aNKfc1+gJKMdgmn
 3jeihzbO
 3As00yK6xwliWDx74KI7wlL0fM8JiAuedRzq6HDEkce38sLt1dhVEAeE5G2t/+mF4ZeJ+MJZu6lN/PCQNebATTddg1EWI6A9qWQGIz1yJ3k76N7zThdg1sBNFBAI1qf+Vs/NjAvUerYa/NQoXW6svqVj4KBrKX3KMDZ7Tig2N6HuhM93ongy/yVCUIVFiEqZucsQOYRpCgDHPQxqncTUR+N47bBR8+jJgaK+dX7LHqxWKZs9TReK3zuQ/x9Ls2kyNvhoDxrAPeqCzK4QNvV/Mt2IlBoZ5PPfa7d+RvU0rydwLJ+If4cGc2+chKFae31rWK4ia5Qk8RDB1f79WecEn3GXEonr8zctrP1YmxsKiUu5TXFmUeJKplxDx0ltR0+FOHPpXxaIdZH+qbrGzRCuMLLXELS7bJyCL3WneVW8AEEO1yc0I3eX0aRifltpao062NZSmH6WsffsCY+OJViJEt4xhScqug/sdfFL8d7jlX2DnU1rHn9XDZWb1JwIPuJXN8sZNtfsIDb+Gx+dvOPSvRFre9RP3ZbR0fhhGa74CE7OQQ0+B84shTmGrP7DE8GTOXkH8q9F8dKPBvHdGhLmYYK9UfKlbXQfishmD7HMTIUemNnz9dMm5RVgLZtf84pBoAlrSmEMifk/e14q9cAwcrVz1THDyY5jM+3PF79LJk8pZSGJWjQ2wJA/+6UcPKKi749eyHk797C/N5MVpPTsXE83IYOMF9nX1CEd0G5QA5yDBvjmIavXY2xxh9o5fVxHQhlhKPcRBiYPGJ3I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 10, 2026 at 04:02:03AM +0000, Al Viro wrote:
>         kmem_cache_create() and friends create new instances of
> struct kmem_cache and return pointers to those.  Quite a few things in
> core kernel are allocated from such caches; each allocation involves
> dereferencing an assign-once pointer and for sufficiently hot ones that
> dereferencing does show in profiles.
> 
>         There had been patches floating around switching some of those
> to runtime_const infrastructure.  Unfortunately, it's arch-specific
> and most of the architectures lack it.
> 
>         There's an alternative approach applicable at least to the caches
> that are never destroyed, which covers a lot of them.  No matter what,
> runtime_const for pointers is not going to be faster than plain &,
> so if we had struct kmem_cache instances with static storage duration, we
> would be at least no worse off than we are with runtime_const variants.
> 
>         There are obstacles to doing that, but they turn out to be easy
> to deal with.
> 
> 1) as it is, struct kmem_cache is opaque for anything outside of a few
> files in mm/*; that avoids serious headache with header dependencies,
> etc., and it's not something we want to lose.  Solution: struct
> kmem_cache_opaque, with the size and alignment identical to struct
> kmem_cache.  Calculation of size and alignment can be done via the same
> mechanism we use for asm-offsets.h and rq-offsets.h, with build-time
> check for mismatches.  With that done, we get an opaque type defined in
> linux/slab-static.h that can be used for declaring those caches.
> In linux/slab.h we add a forward declaration of kmem_cache_opaque +
> helper (to_kmem_cache()) converting a pointer to kmem_cache_opaque
> into pointer to kmem_cache.
> 
> 2) real constructor of kmem_cache needs to be taught to deal with
> preallocated instances.  That turns out to be easy - we already pass an
> obscene amount of optional arguments via struct kmem_cache_args, so we
> can stash the pointer to preallocated instance in there.  Changes in
> mm/slab_common.c are very minor - we should treat preallocated caches
> as unmergable, use the instance passed to us instead of allocating a
> new one and we should not free them.  That's it.

SLAB_NO_MERGE prevents both side of merging - when 1) creating the cache,
and when 2) another cache tries to create an alias from it.

Avoiding 1) makes sense, but is there a reason to prevent 2)?

If it's fine for other caches to merge into a cache with static
duration, then it's sufficient to update find_mergeable() to not attempt
creating an alias during cache creation if args->preallocated is
specified (instead of using SLAB_NO_MERGE).

-- 
Cheers,
Harry / Hyeonggon

> 	Note that slab-static.h is needed only in places that create
> such instances; all users need only slab.h (and they can be modular,
> unlike runtime_const-based approach).
> 
> 	That covers the instances that never get destroyed.  Quite a few
> fall into that category, but there's a major exception - anything in
> modules must be destroyed before the module gets removed.  For example,
> filesystems that have their inodes allocated from a private kmem_cache
> can't make use of that technics for their inode allocations, etc.
> 
> 	It's not that hard to deal with, but for now let's just ban
> including slab-static.h from modules.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

