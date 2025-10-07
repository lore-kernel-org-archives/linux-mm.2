Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A69ECAC5B8
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 03:31:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0D898E000D; Mon,  6 Oct 2025 23:31:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBD6C8E000C; Mon,  6 Oct 2025 23:31:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B37498E000D; Mon,  6 Oct 2025 23:31:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9A4378E000C
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 23:31:56 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 62A901A0746
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 03:31:56 +0000 (UTC)
X-FDA: 83969894232.06.E045A5D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id C92B814000D
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 03:31:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Rt3smpPR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OtR+AgBU;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf26.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759807913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HbtMa4L61oPlTl+j66iCMI5xdRIf9lxLYkfr65gslHI=;
	b=r0V0fH2tQ6GRcu2B9HBFrbpmMi5nabGpvqEDblM5E+zD6EFpXWTHtYc89wlFnnu/iK9LZA
	PXu9g+eT+jFOMH9BQD6aElkShM1TQYb1nhbi4c4LbWEPT9ecx4KX4R18jxJqdN9K5Vqdjk
	3fXZzQdRQ3Mdh0IL9RfgYA0SeYovNgA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759807913; a=rsa-sha256;
	cv=pass;
	b=JCTgCyeZuwvOJfM9d1tB091MwLGWNJRRw+4+ncCy2HE8HY9IiWkhpOQv9myho/MSiIE0j4
	teUekGzIJ1w5tIiU8RN0wP27FTvTmcCEtbar7TxOJKbbsKhO40Vq6QWDueZteGpIssnzTU
	gH5KIEloEYUzl8oM1OIJhICu+MN4Ku4=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Rt3smpPR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OtR+AgBU;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf26.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5972aY97000544;
	Tue, 7 Oct 2025 03:31:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=HbtMa4L61oPlTl+j66
	iCMI5xdRIf9lxLYkfr65gslHI=; b=Rt3smpPRh5WtT2uAvLBMdCdl8UWf0oMN46
	LtOvdosWnNDJPwHGUZOwGD+/i6LtiuwM3DhRJ0mPJ4e/CyBTHpha+WdV/3lruR+2
	cx1RqxBmlpwk4LWjE4QDG4cXwZcVwxKJBKr9q+qV7L6xDwq6vC1dH7TThkQGH3vI
	fRBYauCRiNpVDdN87433Cs/vei/VKmHg7tcAQ4xoHNDEhMI0wNLwkk+Y0aC3DIu3
	xc8/CxuMRAooJKDk9mlk9NDonF2lfXbvj1YADvPFj2gGoZBq/Tbu1XOz8padxq39
	MNsn34jJXle8tv+2B6NQ+ucL7/p78Lv7lmfLmjhFXm37z+YEqkyA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49msu201xe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Oct 2025 03:31:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5972H1w9035250;
	Tue, 7 Oct 2025 03:31:40 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012053.outbound.protection.outlook.com [52.101.53.53])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49kdp49v0r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Oct 2025 03:31:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NSBp+COAoIrl1BSbN7t7yINZ4k5vERg2LdOttI0eAJYHdsbTkm2Ep60FD1j9N+yMmqjr5ohkPMFzKxDfw32I0TnDDRe2pzD8iv1YDu0bLttDmjWbolTLMQdmd2gdoru5lw7YnEDfSsd52rkmSiK9cpED+7ayAXsGZukWPgAUNCQjLBc5YCVgZ5ZfjP5o+3pLRt7+5fVSw4AKdWFOCD6eG9DeSTgtIlS7/kpqLyFFFlcXrDONBrklf0hCwjugxybVzrbcaICt6Sz9zYpihycN8/96wDNp1fZlSJZJKjwxdnZkSlrJWnmVEoosxpEBohLNX1t11VX1gw5JNVAc50c6Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HbtMa4L61oPlTl+j66iCMI5xdRIf9lxLYkfr65gslHI=;
 b=Jo7v+sFuDTJyUyQWEG4kn2brmrz8zsi7t7toV3hD8YBCytLGylh7aBKUHOtK7unTuxU/pe7N6IDdPUP2VFe2pxguusn/6PK241SSzudWp+8YyuAFVYrDTILfjn9Lhz+Es5YUZ5gvmiYlMMN4+c3aa45+RU3gt7/eWS0F6Cx/cWU5Gz+yBFfNMZPnGswJCoUoX9nkkjDWxErUmCQxNCW6aKjQSW8Vgq3KflBknCgTBPQpNHYtfebfp0XgwMluivv4rxf9DOvfWOmf/vGmhLEALymcMAWRCg0NpBt3pUD0V/fWE01duuFYmJw1lTPpWb4EjSgxpkrVW0VhlUSov6ExCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HbtMa4L61oPlTl+j66iCMI5xdRIf9lxLYkfr65gslHI=;
 b=OtR+AgBU8hdj+DoiVAx8rXorjRc6izERbBPetGxJz431drLRSNOSZG2KyCgWyCZNGV0LoimYWPmsyAGL2Jy5uFHmXODj2TujSoWBP/gHoi4A8i7KQiGQ2a6dLz9JtzTLiNJH+FRch1A8t8Z4AYKUkktfj2JkNziO+bk/qOzMwNY=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH3PPFBA17DA552.namprd10.prod.outlook.com (2603:10b6:518:1::7c3) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.17; Tue, 7 Oct
 2025 03:31:33 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%7]) with mapi id 15.20.9182.017; Tue, 7 Oct 2025
 03:31:33 +0000
Date: Mon, 6 Oct 2025 23:31:19 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Axel Rasmussen <axelrasmussen@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        James Houghton <jthoughton@google.com>,
        Nikita Kalyazin <kalyazin@amazon.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Ujwal Kundur <ujwal.kundur@gmail.com>, Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Michal Hocko <mhocko@suse.com>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>, Hugh Dickins <hughd@google.com>,
        Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH v3 1/4] mm: Introduce vm_uffd_ops API
Message-ID: <akld3v2mtnjdqvs5dgwr4gnffdqf5dojwhmfylq3mkfzakjj7j@5oqqxsymkcbp>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Peter Xu <peterx@redhat.com>, David Hildenbrand <david@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Axel Rasmussen <axelrasmussen@google.com>, 
	Vlastimil Babka <vbabka@suse.cz>, James Houghton <jthoughton@google.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Ujwal Kundur <ujwal.kundur@gmail.com>, Mike Rapoport <rppt@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Andrea Arcangeli <aarcange@redhat.com>, 
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Hugh Dickins <hughd@google.com>, 
	Suren Baghdasaryan <surenb@google.com>
References: <f1da3505-f17f-4829-80c1-696b1d99057d@redhat.com>
 <aNwmE11LirPtEuGW@x1.local>
 <f409cbe7-7865-45ab-af9a-6d5108bc5ad4@redhat.com>
 <aNw_GrZsql_M04T0@x1.local>
 <43d78ba7-8829-4a19-bdf3-d192a62cdac4@redhat.com>
 <aN08NxRLz7Wx0Qh4@x1.local>
 <ad124fb6-a712-4cf5-8a7e-2abacbc2e4be@redhat.com>
 <aN_XZbQjuYx-OnFr@x1.local>
 <cq3zcvnajs55zr7cplf5oxxjoh54fb7tvo23hehd5dmh4atvum@6274mneik6hu>
 <aOQuZy_Hpu1yyu29@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aOQuZy_Hpu1yyu29@x1.local>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT3PR01CA0126.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:83::22) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH3PPFBA17DA552:EE_
X-MS-Office365-Filtering-Correlation-Id: c71cd606-f938-4c44-5ffd-08de0552033d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HIxG1B1N/RabbaH5+yhBLJbBTqXCaIUwYsU8D5ewdzvqEY1qBiHSBxYPi+MM?=
 =?us-ascii?Q?gkZHuOjUfT3Q3hhLfkVO+EA53UrI62Y8eY2PikhgVmsvLGbxhcktxSWmy+01?=
 =?us-ascii?Q?jBLmTlzIkzDC6ec/lfN+SIWCJhHVnZeDwIPlum67eroA051g2I3s/gqW6+zz?=
 =?us-ascii?Q?wuj2QAQxh4z/paKPNylmjs828dZPUOFzbEruX7T0V7g82v2/QjT374NzZfQr?=
 =?us-ascii?Q?swzktEIP90L89q/QQ/m43bf1rwgunF2M0yYWWfEAI7EdqIxu+/N9sX8pzWSx?=
 =?us-ascii?Q?MLulGyZbmAJ2tVvxujWlGKWZW+tXYsyMKKvXVJwZc3CjRadAmKh0Wu+AaGhW?=
 =?us-ascii?Q?dbxxEc4laACYop8GPOhzVpOP2top2vBZ4hvTNK2mEqavlag53ncS13XvPYdw?=
 =?us-ascii?Q?Z28s+LJoCUuIy5qWBTtGXtdDvI9uy0ZBaCgguJsQ8ng8/zeQEFKyhIwxyw7J?=
 =?us-ascii?Q?WCY1w8IBYA40izP2t7eciGvZfpl3Qwb9bsPiMfOCiFYCutDBEKhsd8tRX4Tl?=
 =?us-ascii?Q?jjxhB1d6pRKN9PxEiGaNIeIo8+U8BhpxX9xMofr9Gbezx4ORFpzjMlpVV6bw?=
 =?us-ascii?Q?AD+EDvIOzfVWpGzucJSWY2jMW4LsmeJuPMRWkAy6ptv0+3xlsuEqohQeT2wR?=
 =?us-ascii?Q?UzF0/aCX+PZ5xRfjOmGpD/hR/fOxXyXAUnZKMgykFMgCUkw1j3GXLS9ZC2un?=
 =?us-ascii?Q?RK4ZnGvP4twb/Lm/+rucWoWPXLeX009aL3CL8Ygeb0dBvTYanxiKsbhwsDcb?=
 =?us-ascii?Q?YQsc/NgTPv9A8+/3Ny0GiZi9+Sn96bonjSu6aGl1KECuzoR+LKsRk5044to3?=
 =?us-ascii?Q?TO6BC+9ccPvwCsYE3pNAHQufOBMTcB9ai6RAMdiC5uoAs5O3yzKmy5otqvjh?=
 =?us-ascii?Q?bFvretVtArEmmvyVck83Uck3S3xFMl20AwtSJ8NEkJFcepOjyYH718keftVs?=
 =?us-ascii?Q?446lOQX7O1sePhmqK4ASnBbYV9olHbUrndwwwH4Dp3AM7Y9Zi21kOAuphCw2?=
 =?us-ascii?Q?sj7WD3LncTL0Kcx5Z1WrpWBnUXRFSYinSHgTDvoyXD34+teuOE4Iuyq0gGkR?=
 =?us-ascii?Q?WtI601slJUZXlIUlUM8X71oCiN0ZqB19VVVJzzhYPDMQ8jJWmSPfCrWk/bZE?=
 =?us-ascii?Q?kRGkWXzD0b/7NqNHvzj4u8u+P1ldygYMhsW06poJiMLJBfzn4LB7ZYjciawe?=
 =?us-ascii?Q?DtaPd5jEyLRHM6KRltrCZkSIbUcLwBmPGssne7TcXsgv2pzVjJoIBaVcuJSs?=
 =?us-ascii?Q?0SKvpVxeBfsFN0Otvmfexny9zj9WU6ai3IVgrpE8RV2GMCN0sTu+U34RMs7C?=
 =?us-ascii?Q?o6pvDHqKFW4gCFxLTKEW9dOAiRBvNYdisqFz5fEIIPmdCOpZHDPurxkYM5jb?=
 =?us-ascii?Q?t13DeA/8FVUoWs9EXnOnT6pHFVIXdp4AvH4rxO0HvlxfI0j9+r1k2hWyrS0Y?=
 =?us-ascii?Q?6yoYZ5wJQlFJZNnlHLX6Hom2ZY+8yuYE?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gmSVeJlaCpapXEd5CokuL7q9TACe8/Iymp6PVpPLcZpQ+P9qVfodIhLwzhoZ?=
 =?us-ascii?Q?5DoWFDKKNr5B2HXqKMxFRVfjLNmyg6IPRvSDY9vHrPPLrCPhyu/SY6tIDHRT?=
 =?us-ascii?Q?7QkM/UqP1P4bFR8RvQoGg7vSSU6XpV9f8J7i7WzsDRSr+FKm790TCQ+lls8a?=
 =?us-ascii?Q?hqLrJMY1F+Xg6ORQp9rFM1Y8/SpsNClAs7NnR6QFqKAeG028/jl0rTWdqdqV?=
 =?us-ascii?Q?JMkZDwY4tQrbR9L+//cxYxj0C3DsKBb0NEnesDSLUDgXSIfGjtH06Q/wBxpL?=
 =?us-ascii?Q?jkT1gV6gkBJnv/0DETv9Ej6NiivQSOdxWiiFzD/z3echC23aXdy89R2MAP/V?=
 =?us-ascii?Q?2JAbAusg/3nzalifak2Wuy+pbpf08qMEdzJi9JjANn5v0s2DiZL4xrAEmzFh?=
 =?us-ascii?Q?310PA/HoTHPlGwK1JHWuBkzQReY0i1qA9xekihu2fshfsZFV4HWsa2lG9dKI?=
 =?us-ascii?Q?Xv08PDVxylB7APwZCPbpkYP/6pBOhmP4i0C2qwVeGWxLhYbBsyhM4G+zzE1/?=
 =?us-ascii?Q?hX+Q/9FJz4tKJ65fmabSLUGD5BfKIBjNVec4U282dTSWNdvXim/tZongAYAf?=
 =?us-ascii?Q?s0hSzvlyB16YVzODnsWOZg8i6PhEt4+U8cKOTC6OIUz72bdkp88I8rM297j2?=
 =?us-ascii?Q?3Bu5Ompm1kXeUXI0oHZwKMO77Dv86pD6f+cX15folxzINvYQ9ZRQPTqBHpUT?=
 =?us-ascii?Q?PmkM8HE3/ryZHK/FD6b39mqZDmPGuzuGaVi2DLdajlkf2o5Z+FanLcXVAVq+?=
 =?us-ascii?Q?6Jeo2yCd0t7BYZmeQs3/8/q1Kl7G3TYRxmTa+fdsYb4sIc/XR8R4vKub2yIX?=
 =?us-ascii?Q?qjb1L9Eqoe27hvUiYAWu//1P7diz6i5jrJUCm89rviq6QtYDAYL/B9xPdvQ+?=
 =?us-ascii?Q?xb/+stLVoCgsf5MlGNyVhViLBHjnAozZbSvGbBOtjydhjVvWl3B61YD6RA8s?=
 =?us-ascii?Q?/92xVcAGtoi16TUVU6DMx2ekh9Fyvbq4+WWomwQv/ay4zC4YVge6ODDigBtV?=
 =?us-ascii?Q?/kjRdRRP6OcbQX4UVSuT/A3sxDBQo0Meq3YTB50GlI+Cl/Q8PAnIsEqwc4R+?=
 =?us-ascii?Q?gbOAYZmbSEajJehqgdM2QK3z9Xukg8TqL8L85U1/7yM0Sfr54xU+5mZQhH87?=
 =?us-ascii?Q?h/Jals60m/39I19Km89i0R6TErQGYO0VFmVLp66krH1Pch6CvsT9wihtg+7v?=
 =?us-ascii?Q?oXjAFuaXiqrBGR8l8nyNXqVZwUDDXqbYJkeBId9JzchmkxQetEaDJumSk3fT?=
 =?us-ascii?Q?LeO67ZU1fo7AAvVX1UmUYpFkYzFEv/7+8EQfYsqm4g1khUYk9Pqe6Vwp6irN?=
 =?us-ascii?Q?zQMyMEk/bnFRAKrWc+jmCwqdkqNYSFZTk5JsvY0CwTD2EM5+DwXR28HeRJo3?=
 =?us-ascii?Q?rPDlXjQhGFicRMCGtVLLuo+okDtZhZgXiPAIMRYMoUYi5DUApEzQRPP3sfdf?=
 =?us-ascii?Q?Blff01KyTx120u3iwpf28hMLgsQWLaCf8FYVT8vw6xsSGMUG+CW46q/7zIRc?=
 =?us-ascii?Q?ihQwS3Ml++FoN2mlkeCRB80Oo8Skf9kkVuRydd1KMpBHrV0LI9t9QY4zJPQ+?=
 =?us-ascii?Q?QnJY3T5Z97fBpNOa9XDeE4Gz/Oi1RC9nz4X8kZk3?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vUb6UanCbRY9YjYbe+sxPLGfotquTHw/ajySomHs2XlqL/buj0YZhqhWle6SdwpPBlHO1GQbsHNuHLfm0AOHRLyY8aB8YCdVDRq3XgkjVTPWlYdNtOqbcyTReTNGsDmX6g/zXyY7PxGKDxMBsgO11l2v3mHIB1I4wpfTVw+p+7K0mdkWJfGOFJZyWB505pAYHAhosJHAJoJfnJMMa4Mb/1owIa6Nw7xooHR3+jm6st1pUGBwlWayTO8rmK7kgFcsAqevcxO5lfHaw1NT/9lqydlCLM+t2hcE7xZFKATIAzbtu6lGqgzz/2XHUmrfa0qLxzSwYNcbV4ULDWBXSYeO2qbscKpk+DC7wV+R1Os30sTzlLFnEDJiNgHZBpa4a++lq6qE4EKwUBhdigceYFIquLU72vIpXlxlWroFJpPJ2pJKVBrQ/Zkb5WhCTzh8JxSpVyaXZSTk9trEtuWWSdRsyEbMI0usgzG2E4RhD0on7zoZnAXVegtoz691SnvFj0c5PJrzDx5ZvELp/ffaWxbJIaEcM8E07ab/w01+88oakw3/bg4iWHI1qHlSomhVg1OYWQQrrItKiIM1ONVTS34xEM3w2WJWXi8fIYlXnxhWNZM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c71cd606-f938-4c44-5ffd-08de0552033d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2025 03:31:33.7221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 92rY/3eBUKBMP2egR12Zjq5zBB0k/xs7ib1eK7wbTxUYe8CKmQF0Bu1rFOy5ZSuJuvHw85KXpu2jjf3F/s8WBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFBA17DA552
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-06_07,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=696
 adultscore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2510070026
X-Proofpoint-GUID: 5ZXG6qaTLlK4LekUszaVaP-f_jxswwPx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA3MDAxNiBTYWx0ZWRfX093KPwaaaha0
 0qW3vlRjc8uW1ptnqOJLrnqLWUcxwLGxfRF/fyS/2A8HFSF3QAbyFredJM4by9Ozbp2Bpc5hwxC
 AqMpMiTDqQ2QBykQ68XJq9CMOwf8JLBOcwFr8eItxu60dPZRrBPtTJRgTPsTDsnPPrpSXMn8YPF
 vZknsDvDKQnx1JE02L0mX3DacNB+cuDiNrqmCxVW2PFnTnDYa665Bl0bdN3qZuDlffMfdAdPekl
 vc0d/03bWyVGerjSmIAYNv+1Ib3XtXe10J2nq/EPvZmX9qFuNcUwD3yxlnLzdVlboJA5qtxJhss
 KgkLU2PmfnadlmBoLXlssMb7xsro1lR7TZFS/ibED0ITc+fE1cSTrx4hdLHBYHDOx7cwge2m/C9
 09Mu0YOdPnEk1VqH4tjnOVgnJGoRL5wDVzTGqDUcTukIS28REoA=
X-Proofpoint-ORIG-GUID: 5ZXG6qaTLlK4LekUszaVaP-f_jxswwPx
X-Authority-Analysis: v=2.4 cv=OttCCi/t c=1 sm=1 tr=0 ts=68e4899d b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=fpBn1pKCIQfrk2pDKI8A:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12092
X-Rspamd-Server: rspam01
X-Stat-Signature: bm5yo31eyjc8s1a8611kymneg6eb4c4h
X-Rspam-User: 
X-Rspamd-Queue-Id: C92B814000D
X-HE-Tag: 1759807912-738749
X-HE-Meta: U2FsdGVkX1+tVv7m7ltbCtQBZggqxRKKcuOQVyEKKx0FZ/xP4E0KQ70mB6EKgjzkA5OEzApzzfznaA2Og3xDTH5F1MOUpWxDR3EGCP+gYTDHgzvmxGuu8J6jGDZ53bVvVzC+6+xuyYxvRFTeWj8BQy9pBncrPIF9cNSB9sc8WznAkvJyWf1qdV3m2JNFBnbkIQlpSWXmpg9zWxwq+WJDqe3IMswFLUjKu4GdOa8uV3aMJXfwgd9VHnCCpfjGlJQE68R8kkLSdVybkV3cYclaWA4tHs1CBLmBALUzCJbv9bub8OF3wVyXOxg7n/dWTRgLYkeqpGhOTkk8cDyqbdLzfa3Ug6AXNnbK3LnL7Pn0gLJICiD991Ri2WwJyAYJyYH4/JY/hHhQ/NDEaCvETZWQSSKBs/lJ/gN3VDB/Q0m5TlEU4GFTHUSmRctB4Bj3kjkZrkf7BdxsDSSDCV7YgbSnmCea75PrgIuB+eANYpVDI17CGLPKNWKJbeGpF5XPg92IffrjUa0nuRuCXM61dDagMafBfLVfB6ueJGYRf0+XqN7Xih6pqGsvU3FDmZlOgLjf3NYSvEVSCvr7BPn6VO688bx64v/yFmdmxCIEV4VXsNm3OFyqg4D+S7yyunI6paE05jt6d1o5nbt90zvbvaOHEejuV/zFrdtRF5ZF+jg8qtH6EuCfKbffjEix7Kmdf2cOFgsxSpbb7ahFGWdERTD9qhyHccFG4UFLZ6hrsaynJjGZDSNv8FXfdxg5BZwAX5lWW8LqTbtBEaYABH5uXrJU8SK95xDzbMco7T8Lhhu/tob+LwFH0Z+OdHpMP1xaf0pJnxfEe/6dbRdQIdhoRfvHAvA2MK5QsW+ZvR+d67MCCSDa1+g7/eT2EmqAohQTC1XiSENEuWFNtaT9VxJGGUFsjaHNhkAerbRmDi9lQQyIfgktEfCoBVAnVmT3URZUKrKbZo45NjaqPYZQCF5fR5P
 fmp3p88S
 igMwAxsxC2tQJZLD/mlyg1p+9Y/n5h6GoWIw6WiWzjOFvbB5rjEGibMhOxjvX283DSeLjyrfpMZ/gKsgM0vTQMtRFZRJbYNtBOWDk67VXnFlbNflBSk0RF/dyP4NNieh8G2HBAjeFVWw50h6j1ZmaBfuht3JnJBkaG9IUzgQm7vn71oO1zcXAaZSDp1s4PoISlRNQvmkUBKSw6Q6mup+5GQmFW+Gvf4/eiWfhdbvaQ+KayIgrv+9HLktR1BAlQRrmVjMdKQ22WSw/jK6yShcyT9fiJUHkRHo60qlyVhwGzueSq9zHXKsBeCE3WODflkgYMdqKxFaPZm78Kt+VoLpnDFlyhCya+ULF073/hBcVEveF9pdWRRXBy4Pv7G+jsU2WUu/LDJqlOthji1+cOV4iIO+7ENBfIiPMNeUNwRHsItBkTmRImzuEkQzcd9mAIjRMvPXur/uqhWBViZlUYWxDunfIABWZiLaiBrvB2KRLYP6QPtwhdkOFvJkxsDDtGAOocNdq8u2mW7Ye07RY/YNABh9INLibwmmGaqx2za4PualL6WwEqI0BIjIr54OtNmZXz4YtPsXfoJRZqCP0g8DmTVZf3lK2j4J00qVfIu4WsCDfKvI0RYJLb4R/IlzhFOHxXKZVpVFduuRIbk3FTj6NLQZBLKK+Phrx7/F51yRtKO25o0ooOXMN9VqAEL29pX5guRVj/pH4CCCpFFVHfIdGbmTLatuKbrskBDaB8TUbZh4h6MYlw3DoBdbbqO2O0rEDDHN2faEhSD6EXGU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Peter Xu <peterx@redhat.com> [251006 17:02]:
> On Mon, Oct 06, 2025 at 03:06:39PM -0400, Liam R. Howlett wrote:
> > * Peter Xu <peterx@redhat.com> [251003 10:02]:
> > > On Wed, Oct 01, 2025 at 04:39:50PM +0200, David Hildenbrand wrote:
> > > > On 01.10.25 16:35, Peter Xu wrote:
> > > > > On Wed, Oct 01, 2025 at 03:58:14PM +0200, David Hildenbrand wrote:
> > > > > > > > > > I briefly wondered whether we could use actual UFFD_FEATURE_* here, but they
> > > > > > > > > > are rather unsuited for this case here (e.g., different feature flags for
> > > > > > > > > > hugetlb support/shmem support etc).
> > 
> > I think this supports the need for a code clean up before applying an
> > API that generalizes it?
> > 
> > I would expect the uffd code that needs the same uffd_feature would
> > logically have the same uffd flags for the uffd_ops, but that's not the
> > case here?
> > 
> > Is this because uffd_feature != UFFD_FEATURE_* ... or are the internal
> > UFFD_FEATURE_* not the same thing?
> > 
> > > > > > > > > > 
> > > > > > > > > > But reading "uffd_ioctls" below, can't we derive the suitable vma flags from
> > > > > > > > > > the supported ioctls?
> > > > > > > > > > 
> > > > > > > > > > _UFFDIO_COPY | _UFDIO_ZEROPAGE -> VM_UFFD_MISSING
> > > > > > > > > > _UFFDIO_WRITEPROTECT -> VM_UFFD_WP
> > > > > > > > > > _UFFDIO_CONTINUE -> VM_UFFD_MINOR
> > > > > > > > > 
> > > > > > > > > Yes we can deduce that, but it'll be unclear then when one stares at a
> > > > > > > > > bunch of ioctls and cannot easily digest the modes the memory type
> > > > > > > > > supports.  Here, the modes should be the most straightforward way to
> > > > > > > > > describe the capability of a memory type.
> > > > > > > > 
> > > > > > > > I rather dislike the current split approach between vm-flags and ioctls.
> > > > > > > > 
> > > > > > > > I briefly thought about abstracting it for internal purposes further and
> > > > > > > > just have some internal backend ("memory type") flags.
> > > > > > > > 
> > > > > > > > UFFD_BACKEND_FEAT_MISSING -> _UFFDIO_COPY and VM_UFFD_MISSING
> > > > > > > > UFFD_BACKEND_FEAT_ZEROPAGE -> _UFDIO_ZEROPAGE
> > > > > > > > UFFD_BACKEND_FEAT_WP -> _UFFDIO_WRITEPROTECT and VM_UFFD_WP
> > > > > > > > UFFD_BACKEND_FEAT_MINOR -> _UFFDIO_CONTINUE and VM_UFFD_MINOR
> > > > > > > > UFFD_BACKEND_FEAT_POISON -> _UFFDIO_POISON
> > > > > > > 
> > > > > > > This layer of mapping can be helpful to some, but maybe confusing to
> > > > > > > others.. who is familiar with existing userfaultfd definitions.
> > > > > > > 
> > > > > > 
> > > > > > Just wondering, is this confusing to you, and if so, which part?
> > > > > > 
> > > > > > To me it makes perfect sense and cleans up this API and not have to sets of
> > > > > > flags that are somehow interlinked.
> > > > > 
> > > > > It adds the extra layer of mapping that will only be used in vm_uffd_ops
> > > > > and the helper that will consume it.
> > > > 
> > > > Agreed, while making the API cleaner. I don't easily see what's confusing
> > > > about that, though.
> > > 
> > > It will introduce another set of userfaultfd features, making it hard to
> > > say what is the difference between the new set and UFFD_FEATURE_*.
> > 
> > If it's not using UFFD_FEATURE_ defines, then please don't use
> > uffd_feature for it in the uffd_ops.  That seems like a recipe for
> > confusion.
> > 
> > > 
> > > > 
> > > > I think it can be done with a handful of LOC and avoid having to use VM_
> > > > flags in this API.
> > > 
> > > I waited for a few days, unfortunately we didn't get a second opinion.
> > 
> > Sorry, been pretty busy here.
> > 
> > If we can avoid the flags/features, then I'd rather that (the derived
> > from uffd_ops == NULL for support).  We can always add something else
> > later.
> > 
> > If we have to have a feature/flag setting, then please avoid using
> > uffd_feature unless we use it with UFFD_FEATURE_ - which I think, we've
> > ruled out?
> 
> Yes, there was no plan to use UFFD_FEATURE_* in vm_uffd_ops.  It's because
> UFFD_FEATURE_* was introduced to almost let userapp have a way to probe the
> capability of the kernel, rather than the layer to describe what features
> userfaultfd has.
> 
> For example, we have UFFD_FEATURE_MISSING_SHMEM declaring that "the current
> kernel supports MISSING mode userfaultfd on shmem".  This feature flag is
> essentially of no use for any other memory types, hence not applicable to
> vm_uffd_ops.  OTOH, we don't have a feature flag to represent "userfaultfd
> MISSING mode".
> 

hehe, the overloaded terms here are numerous, but I think I get what you
are saying.  It's funny that FEATURE_MISSING isn't a check for a missing
feature, but really to check if the register mode missing is available.

I'd also rather not have ioctls and features/flags.  It seems reasonable
to drop the ioctl, like David said.

I assume there is some future plan for flags, or is this for versioning?

I'd like to one day even remove the suggested backend types and instead
use handlers in the uffd_ops directly, although it is difficult to know
if this is reasonable today.

Thanks,
Liam

