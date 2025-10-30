Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F59CCCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 20:25:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 567918E00CE; Thu, 30 Oct 2025 16:25:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53F7B8E009F; Thu, 30 Oct 2025 16:25:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B8848E00CE; Thu, 30 Oct 2025 16:25:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 25A8E8E009F
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 16:25:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BB751C0284
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 20:25:14 +0000 (UTC)
X-FDA: 84055910148.23.B06679F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3012540004
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 20:25:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=pnZFUGhh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=h0oM3LOz;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf07.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761855911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0gq0hwC3o0K9D/3SaIsHnHg0sYqxzU+u3RPJhTD3pEU=;
	b=SdcCppnKQyQXEkIFn3E0uHcmN6kRceNjK8W8+CWj6WFgjpZTtOyTHoZsnbk67/35TED3uI
	QkjhCYb8PM4xgBC8EjNsRdYbxoUuHP1p9pMeCEWbx56viFMdN6WEg9HpTqwi9CxqRkF112
	Z5qICzD1uoM6htGLSwptEYUaWlzT+3w=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761855911; a=rsa-sha256;
	cv=pass;
	b=YTgi9bf7gfYl0do8l7zFj+7dr5Or/prKsJaa7Yi8hXynXcYJMUpGZLzGKNLEapsVZ/AYXo
	QvT48lAwUEwYLDmnKED6YXP2mR0aZstCXSsfrVpRpKyqnbDfNU551l3yPl5nEs9Lh9jp4U
	Ze4AkYQ+HTJg1CCaKPw9S1W2xmYF3XA=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=pnZFUGhh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=h0oM3LOz;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf07.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59UKNFN4011573;
	Thu, 30 Oct 2025 20:25:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=0gq0hwC3o0K9D/3SaI
	sHnHg0sYqxzU+u3RPJhTD3pEU=; b=pnZFUGhhDlRU8GImu9du+cFu2IMQWqPvQ1
	CZxahYwZ5aDExDsSuKwJ5uPGiKGYfHetXfz0r0vFr2JckrOKueU1Q4Zbfq2UVPF9
	ZrLGgUUs6bPZvJA76DsSlWWTVd/U/HtZ3iZI/G38hjy0khVzIK+Jbg23VbssuM5g
	kjf7NCxZ/+0thyjVmKrABE3eMpkCUIP6azn9mGLTvOfAb8USaryjQiy2LrKu3VvD
	SuI/2PgBkGxh/RnWzw4ND1VoA+fVpIc2OCsIftbrvHon10SQ+RkknG0+XafbYu7G
	A3NDVbqrwCu/sE9XkVjPg1K+cRl5LvVrZIv6AB6D5c2bCgsDALoA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a4dg3r82n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 20:25:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59UKFmaV017503;
	Thu, 30 Oct 2025 20:25:02 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010040.outbound.protection.outlook.com [52.101.61.40])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a33y15aad-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 20:25:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mP1AdOY8Fkqlz6rXC5naow77NKGMekoQDWXwtPlB1157agp9bF6O4zZmPZFQ6elbpsTMkZV2/zBm75WRSuJ8Y++3DWmi/3ZuOfPfsnyy5FVq3ynRoX6x3j5K1OFDLc18ZNezXaMsb9EDYVVt0vfzK1h5VhEcTwlBM75i3M7oKPVtKOaVRFsYHbzryhRka4IrQFs4aOYrIHTfHp9HDjhkutBwd7Ev2yjGZXg3e4AcHihkvfdV6xVaIM6kmsrMSQHFQVDZzEw9wigLprGPLtuAcwpjStw0z7cHcKWS0mvhaxogils4N31/8DR9OuPfTPwUGo7hkecSpEQMLy0zs4eyxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0gq0hwC3o0K9D/3SaIsHnHg0sYqxzU+u3RPJhTD3pEU=;
 b=QH8n8i/14VBcCzIyShVTk1j0sI1BiqSN9zjB0nXD29g7o2N0DiHIjZ7wwOETqf5lutUNkbAuq0RkkKYqQVaZbZ69XFB/8Ptm/yvNnlYgMdr/jIoKT8s3iDu6quGo6rcelrpgQOdVpDO/DORtfTR+u2DcoLnFLN65C0/EViaI052PKhQ3ve3kX4FvdCjp32gGSexXuCwf+ANfKd3UgbTJ9x+5HHbxs6SOg3w/fFmi93job8wI3rHJu27t75o0zjQ7xiJvnU4AbeHnbYYGqUcnYw/6ji5pDeqUup5eAGAXRd3RDQbHOwgxtscDCAldQ43IjhpixMq8zpBvKmrNrnL64A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0gq0hwC3o0K9D/3SaIsHnHg0sYqxzU+u3RPJhTD3pEU=;
 b=h0oM3LOzz/n/bj1lGRC7xeJet4Po4ZLdsTxYk9PpmKbNgJShLX0V/aDizcEQrFNZGTzv3oBRD1hMZ3Alh9tOrn4Q2YSuUZyk6wWpGV/wbEO/WbziczykCWbydWggVhZFpaCZi5Fd0Cn2cq1zQ2PlhfCUFv/MBbwEo6cGrcVrdW8=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SJ5PPF8CB762A0C.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7b7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.14; Thu, 30 Oct
 2025 20:24:58 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%7]) with mapi id 15.20.9253.018; Thu, 30 Oct 2025
 20:24:58 +0000
Date: Thu, 30 Oct 2025 16:24:46 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Mike Rapoport <rppt@kernel.org>,
        Muchun Song <muchun.song@linux.dev>,
        Nikita Kalyazin <kalyazin@amazon.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Houghton <jthoughton@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>,
        Ujwal Kundur <ujwal.kundur@gmail.com>,
        Oscar Salvador <osalvador@suse.de>,
        Suren Baghdasaryan <surenb@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v4 0/4] mm/userfaultfd: modulize memory types
Message-ID: <6odeeo7bgxgq4v6y3jercrriqyreynuelofrw6k6roh7ws5vy2@wyvx7uiztb5y>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Peter Xu <peterx@redhat.com>, David Hildenbrand <david@redhat.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, Mike Rapoport <rppt@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Axel Rasmussen <axelrasmussen@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, James Houghton <jthoughton@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>, 
	Ujwal Kundur <ujwal.kundur@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
	Suren Baghdasaryan <surenb@google.com>, Andrea Arcangeli <aarcange@redhat.com>
References: <20251014231501.2301398-1-peterx@redhat.com>
 <78424672-065c-47fc-ba76-c5a866dcdc98@redhat.com>
 <aPZDVuscFsYSlQjI@x1.local>
 <dtepn7obw5syd47uhyxavytodp7ws2pzr2yuchda32wcwn4bj4@wazn24gijumu>
 <aPe0oWR9-Oj58Asz@x1.local>
 <nnxhd7zxjza6m4w4lr5qyev2krbkp4yfcgcwq6nkaqrqt6bzpb@iklep2xxp5gv>
 <aQO3Zko6Qrk7O96u@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQO3Zko6Qrk7O96u@x1.local>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0503.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10c::21) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SJ5PPF8CB762A0C:EE_
X-MS-Office365-Filtering-Correlation-Id: b242a558-6f8d-44eb-2830-08de17f26560
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/E1pOW3jIbm2BFUr2knAY3yuXK+9Vge7FQ2F8o/uqmPuZiUxELm9Ua/Kkd+M?=
 =?us-ascii?Q?KOQBzdJLU4YDzv9rvoyGotmGAx/rnZkDksod8f4ThO8c9xrf5C7KAdKN7Rvu?=
 =?us-ascii?Q?gbnbZEsdhVIWSsZbuMbjq2zVdEF313NqTy/HnJG83d1mnFFXzb564bdfL4DI?=
 =?us-ascii?Q?Le+IO4PNRlQfI9fwig80DIT/FT4MWSnJzChhrfOLmEDP2Zysagibf2FWpoQL?=
 =?us-ascii?Q?nYOj3sei5lN472eyOyrvR2OoK0AENB5IhJejQW1GHC5itW23clbNL6N+HXha?=
 =?us-ascii?Q?fYoYLLZy92CQTKVgmYtl58NCBv18e6rcq23KYu8t82V27j9MavEJVM5qwhtO?=
 =?us-ascii?Q?ENhCxJvzzV5KKe44ACSZaOFukiALuXrg50RDBfSSmK4l5orX16Os/eTvlnN6?=
 =?us-ascii?Q?KTR836Df4syBIWheXUvnF88PpEtCYbTXqFOMrZqHlHiCyz/LAXyoujb4/fjL?=
 =?us-ascii?Q?zIgYVlY3fHeN2v4/7bwBUCc/c6sVRP3Vi2VdRkgjgmHJWM3k3g72fXXdodAm?=
 =?us-ascii?Q?5W5Wk8WwziAOZKcAA5eFjfMqULPu+b3NnMJF1lecVRoKlaBAO8A6vZ+wUWjE?=
 =?us-ascii?Q?R3fwa20D2Qo3XtX1BwPIz3Hr0iqJMpfJCkYTIEIoYIk8tcdYE7M7a4AqCZ+I?=
 =?us-ascii?Q?DL3LQGpAl5QN28kHNb02IHCeLbVCoKZVv/eNN9URvcS95dfsNS0Kwuma/5bq?=
 =?us-ascii?Q?OfHaP1uWmMAnI2z6TYobAqsvWEIPEuv68oLtogy2n55YwJbk3bGprq9sV7sz?=
 =?us-ascii?Q?I61Y4tkLmU/c1iCJ+wAmKbFlbiuqlW7uA726xFsW8tsc+X21yF4zSjZmdIzu?=
 =?us-ascii?Q?8DZBX7h/Rn8gBS1dwDXkvz0AFU+ah3x64UczZ2GIi79GQrkrp/FIUEaSmdih?=
 =?us-ascii?Q?ZwN0+fiXJuZPU4GMxezzj3WiWKLZMlBiZyHupjdsnQi5AobB/gwDmQifpai0?=
 =?us-ascii?Q?qwifcWdbOyMymXoyniRpT3QZrDumV6+X4Nxn0IX4uAGcxb7tUOwPqVntmm0h?=
 =?us-ascii?Q?8sXCRbe7cr0Y/O1x5ei4uPRtvR3YDqt6fz6mvhTRJb/xGyghRrJxba8r+GN+?=
 =?us-ascii?Q?F69DnrFxtZIA/8WG3qeuKfe4K+lJkRfKmS0HvfDZRVXn34+uXfHp2DeOK7dZ?=
 =?us-ascii?Q?V9+tJr/2dKUCEzALSDuoETRo5rlIhvvO6YqYce7pwGoPT2gTcSRmCRtdi1Fn?=
 =?us-ascii?Q?QaanEE3l3cwiz3WparWCunDm519jpJ6h+/Q2WRYwFiFNXNIINGGtAoWs/+vm?=
 =?us-ascii?Q?9rTI16K2IeUj69eRmastxw0jctLMCRhHUneqlJ68rvh0pBPzDwgl63PiVQtg?=
 =?us-ascii?Q?mjCrVB3X05V0EjDwa/SdmJxLewYjL26NHcSc+CHaXj7hl9a0YrtLKfS07fyp?=
 =?us-ascii?Q?ykiUporxbSxQfqIMYlYxDvCuqYnvSpm0oAoKrGkVvXB7TdubXg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/scdZBOHMTai9QuVWJ8tvIdX01znXkcD7O2AfnpjonJ9H+IvcxsBPWbPJRon?=
 =?us-ascii?Q?358BFn/b/aakXFNCL03d5pHRDc1rZrW2N9BfaSK1vFvkLmn6Ouav4FWFzxjd?=
 =?us-ascii?Q?NdJI4setn6ZvYB+KRMiAVJQRDVQaJwpKxydkzpHWa+nMubNKMZaX7Br2jhEE?=
 =?us-ascii?Q?9/SD9ADHh1cjB6MTQPdl98ZwUIaJPv9BjdBY75gaNsSE9Uwhw5awCcSTQCmT?=
 =?us-ascii?Q?qNDK/ICzn51gcTCpocNFyZjeJlv6ewr9N9NI5Ev3k1bE7ZHolW0wZRw1OiH8?=
 =?us-ascii?Q?C/lvao5j+WyLl7D5FU5bKG4eB2xvyUxE12AN54leLL+K1E15W0lrStPeQETo?=
 =?us-ascii?Q?9b3H3r0Hk7UWAdfziGHHxumB5pDDOCsFTVBhiXqv99z71RG5fyZQ46ua6Xtp?=
 =?us-ascii?Q?FeeluCWFpWBxIaz4w9A+BQldkWsFbeEkghYJf58a3oNZIuh2hHaZ1B5NKblq?=
 =?us-ascii?Q?Mv9ivqaBTAgz0aBHENjKa6ZA3XSWn1RVThASM/ttSS4yYR/dP51BDbBxOpyx?=
 =?us-ascii?Q?Y0Etpe/VTDN3DtQc+OY9pfuicfZ63FFycQusQh7beklDu1BZ+7+OWHc6e66n?=
 =?us-ascii?Q?5vS6ueb3KHD8gU6QgGoe5c2lKBJzbRag/ou3qGWAFQJ0wk+hS3/Qbh77uWJd?=
 =?us-ascii?Q?p29bUG+FSlTxCYvZujNU7o1nzTiM5AgejA3fJ4cgNSQk4SrAGsbBSClkCyPu?=
 =?us-ascii?Q?llZJfpswD8eeX0Pz+NF35+Lmv+FFhKYhQwAhf+zWUaRLIgqiJtAx0CfFDyxw?=
 =?us-ascii?Q?H+ZAedUxB3Cgn0kwe9EhYpYAIFUyfJsi72w1SULxucwzlb1Nqz4X8MITNsot?=
 =?us-ascii?Q?9gYs9tcDeRNHvUoGK5ooos/PwiETeGw/14adhOKstTOlcewTC/a2SnAL923w?=
 =?us-ascii?Q?EDzqYJrDomhovhmqlntqcdenHiQ3/QH3UAls+JMyKRqYpTZ3sw+47zJQdLW8?=
 =?us-ascii?Q?jPyEayJlWyXxrFU2CapRMGnn8OBtcAzK3tQEj95VCqgyK1o07bvSEJil0TgP?=
 =?us-ascii?Q?/j2ceIflZHK6859GwcjdptwkBHGebEIOYdMONxO7D80l4UT9UB+B2qWtB/he?=
 =?us-ascii?Q?Yo73P8mZnvFl+rblRwkbxmRpz2fRE3mY0iKSnUsS2G1Uv5zUcdJHH7Vucd3P?=
 =?us-ascii?Q?FA+EJ4LoRL6JAAlm5zQzoZ96UgOWmZxsgbV7U/nWlofsycq6q0BSPZV7W0Qy?=
 =?us-ascii?Q?ZoT+1mmXXOKwmj/kiQmjX9y9b7DHOrepHedf1aCanmkOb/8Jl0ynedHO4LFm?=
 =?us-ascii?Q?6iNPzcml5TQJgwY3PZiLJuTsrJSU3KtblTgCnU2LXbsZzfi9FVrrzj74fppg?=
 =?us-ascii?Q?kocPotoD5CxokgLBgu/vmDD2EScezEXqdYENvDckcoMn70mKkPVRMZvkVbmy?=
 =?us-ascii?Q?cQiYuMklMwiFHlkFCT8GdoNOj1pQUrfgMBuw4tfm2EutqRTtxG7jD825s1TI?=
 =?us-ascii?Q?QwpxsUE2Vp5hcjrgqaHA55Cusj0FHWA8vEovJ57Zs8xPs7D6bWGZvEdC9ZDW?=
 =?us-ascii?Q?P+pVd536IHc+i0qvLcLFHkIUVv+OY0M96s4hg7lAbrDhQLf2YULBdK5bGvMB?=
 =?us-ascii?Q?38EPo8996AVU8+lsXknzCl6Qo6KctHOKaCPgXenm?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	J8b1wx8Sd3UCwzMnY1ar8YpumNYwBPPQ3qi1Y4Mfpsnkt/v7LrSfYQjrWURzmdABtmrukjNhBLjV21LfieT6q9XWIN53lX0KWU+eEE1k1kW82hF+XUduzkkF+rXl9C8fKb7I43yf4IcnFci96uwadRUnew50Z7kAtsAacZN7e81eW8UMcRqAHVLpPukzOLM+FQkoGlRHT4JdeyEheKviDPReyY6u5Op9XA/f4SXduF5nBFRd1JkYmfwaTMm7R/tQUEmORJkx5qYIB3GlDeID4rRCeAfHqjemP2W1leI1ew0zqrH48Z617BvAfhqW3A/ko5xM/cEhAbfI9dwagWSlQbPkoCf8P8FM4QR6lBopw5ECdqcXGzlT98moTmsFQhs6T/LKOkqs1FKxO6r23ZhEMrMw8wSfjnNxJEF23rw1uNI32K4j6HRXJYWbI/xNRiKcKgig+dYeL6d0pUCILM17i3J53bhASlfNHbK0whahJ7Q6hO8Li8cxgvchQylH9YaePR1mcQ4wECgs+gf++bysCFSGZuYF54eyKmsIY1AwrowGbdCE32/Or3ZjkG6owX+BzGvRm2Bzve24e8cPCpTtGql8kgq8N1oPhrBpKo7WcAk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b242a558-6f8d-44eb-2830-08de17f26560
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2025 20:24:58.6217
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KEBq33EyhXDGopRCq7Q8VDW6qz94e08+efA9oMp5p4hZkm48x1PrxOCkMtFw5B/4zu9wkkXvJJXFUBgtlq062A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF8CB762A0C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-30_06,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2510300171
X-Authority-Analysis: v=2.4 cv=ctCWUl4i c=1 sm=1 tr=0 ts=6903c99f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=20KFwNOVAAAA:8 a=5DXmKuEzLAkomQ-cdAYA:9 a=CjuIK1q_8ugA:10
 a=1CNFftbPRP8L7MoqJWF3:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: IrzpWba89OYdfR2voVDljVOMOSsYpMXc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDMwMDE1NSBTYWx0ZWRfX1NPAIxdPL5PP
 V9CJY4eLClLC+vk58T4K2cx65ISQGyHK5aR1gbdM1jnQgJ7x1YZSV4XQUN7TD1fRaofRui9qRC2
 NOH9GYjdmZF+RBV47+8QHjXA2E5LzWjGK3k3KYjz7HOFMCWCZe1Fqv7LnmHdlRi3EETcsAESAJ7
 UF2o6c/pwWAdDxo6VeB6gxOQOf2SNPpeYM0k+br6QbrEgP/YQd0aKUlyDyM+FAuZ+5ozldnUvXs
 3eYt9n/j1azIoI/9G+8v5TVFssps2GW+IDK+Ob21vuZwMLEmZpPNa7LONri+v1zTP8+uawW4Onz
 lJ61EtYSshJGEf7IJUwVM5s9/HkUq/VXrBnXytpzBqodE8iukk1xTp9RN0u6rUDd+yMqtI/m2lS
 /ShfSmUtRNwIDKuZ5EF8HVzB/bHOfg==
X-Proofpoint-GUID: IrzpWba89OYdfR2voVDljVOMOSsYpMXc
X-Rspamd-Server: rspam01
X-Stat-Signature: r99wf5magmmwr988e3hzaynmsmz5m4ws
X-Rspam-User: 
X-Rspamd-Queue-Id: 3012540004
X-HE-Tag: 1761855910-650827
X-HE-Meta: U2FsdGVkX19kTt3Hz4+M+jULdwiZGvwHV7uLbF4WVTQp5ZPUgPnzcVaBQS+H43QRROTIeFANHqcDcEdmGeY3A5oUl3U0/MatHD9qW3fgH7CQuz8F4LRriy4ovdF3oxOs+n4uRQbl8jyCmTIwhUF2Vus9O9Q2Atd3bYhYWTSwYHBQQGB/OWU6CjYnnHmMEV0slGenTOdvMS4CekdjYd/fOz6JkgesAknCrfJbOrBq97T7FPAR6XdIccauMFBkFrqiU/oE9pUgH/IntcdVL72N91LAZ0xyVlUml6ZlTLm42EV9eLGOnJoPpwX9kdfSicjlFzshjzC78dJ2Wl6PPDbZX0fDfMX6hss3fVA73YA3seXiKdCZsQZ2iJvFHBUcfnIf9WtrQS8ut3ihY5iVwAKEsSjcXIf4wgerWyF58rTnhQPPlpLXyqXrGK7H87YMhfxEOyYj7xFOyIpMg6eZZHG1vLCAadSC0lXTC12YkVzXMv2mox8pOqTtlNf1A/KFGq3bqRHpe1sPkjpTCfemiTLWwlfyGYA9k5YhxOma5MNhBMeoHywcGJ/2UD+40ZLVjM6TpnnQQ2vlmE+7FY0rXT4C66xTx3wWL0VbE416ZAYyU4UKuT0mM5ipf6+FGSCFwwWqCyZclJWYNZ265i31WDyw9ASG8l1WijKAXcLdTfusaOGIiauw6BktT+xjXFzWf6Q4/FeIkVU0nyLkaWVd7gL/TE+7DItAcrC9Cbnc6EReV22ysANS6vZHzZ85Ls/NgDmaMLZN6YBKOfvXfaHy5DXQgioXEtm/tar+odd5sWZYyAwHmharSETuceOknSIEGiKusXUa+CmSbmZHgLO+/mZ0KHanH6+R4L5rv0NF4rfaV313hbEG+5yWpl4DQiueVJtPIkWIkDKi2g+LAV63VP00FO73qAaiZzSb3GFzBd29JA7BdD67PVwg4cxiunYnAG2uKhaTI11rFz7ERWAhyO1
 fXPmCqHe
 AHJb3K+QBiRv9m+Js/ordBbb1jPdvtLb+4elj3u5Jo/F62oVTDWrEsSkqMPmGsysDUV67aO4xU0GYb8MjcBlmH/0unidBreHYcB2g684Ab9s1V7PY78KRlIJcYMTubhdQxaCXPpsEOnI1pnQ1+5PjTST4dgPSZmQfxSahGVWA5TG87xbJJ6nSgOCV+S7idhUkn9n95SUmXuX0ScY8IhcY9uxexNfGN/rFLeLvFkju3R69FvPE7eDIyUVPfcXcWOuAJrvl1FWpdMRRg/oegNsHSqbS/IvXMHBEL+55vO8pCXHIMfG5bWXSSkAjgeLOTJfxF8ue1dYE5WiATU0+ZrGG/ngLqgzVGq4hlJSx7zUcp81nSqAmPtASDp74rmcgJNXr4inITJdfXBncRaXsdQXjJXdbSBLn3Q2MinMCPhytniMjp6Ok/iHZr9y3mWn2/KtOo9DUWBJ78gRN823eO3K82rjG/UsuZRYoWmyew2bBnDQOqNl4EamWkqbAkKadtYqgm3KJJTu780VnCWlxykSo0j8O8QplKW2zpod1by/n06Bx2vchN+qcA74ho1tufFAInvDnNVL9vFnizyIW4EZtTFQVTTzhjmf6pTSVe/W+1KOuwxwcLsAAd1bAypFXGMVnPN3rk7HNgOb8eDWrrn9padwz+U0I3OPW0VQWWJY2yJsB0gvnyNdB8gnMTU9WQFvuLV90R5XU3O3DZy2/4+UcmdUa1Zx+LL8PeloGD4Cm1sMISoW4kgZx7/j+hw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Peter Xu <peterx@redhat.com> [251030 15:07]:
> On Thu, Oct 30, 2025 at 01:13:24PM -0400, Liam R. Howlett wrote:
> > * Peter Xu <peterx@redhat.com> [251021 12:28]:
> > 
> > ...
> > 
> > > Can you send some patches and show us the code, help everyone to support
> > > guest-memfd minor fault, please?
> > 
> > Patches are here:
> > 
> > https://git.infradead.org/?p=users/jedix/linux-maple.git;a=shortlog;h=refs/heads/modularized_mem
> 
> Great!  Finally we have something solid to discuss on top.
> 
> Yes, I'm extremely happy to see whatever code there is, I'm happy to review
> it.  I'm happy to see it rolling.  If it is better, we can adopt it.
> 
> > 
> > This is actually modularized memory types.  That means there is no
> > hugetlb.h or shmem.h included in mm/userfaultfd.c code.
> > 
> > uffd_flag_t has been removed.  This was turning into a middleware and
> > it is not necessary.  Neither is supported_ioctls.
> > 
> > hugetlb now uses the same functions as every other memory type,
> > including anon memory.
> > 
> > Any memory type can change functionality without adding instructions or
> > flags or anything to some other code.
> > 
> > This code passes uffd-unit-test and uffd-wp-mremap (skipped the swap
> > tests).
> > 
> > guest-memfd can implement whatever it needs to (or use others
> > implementations), like shmem_uffd_ops here:
> 
> I didn't look at the patches in details, however I already commented
> previously on a similar comment you left.  Since you have solid code this
> time, let me ask one by one clearly this time inline:
> 
> > 
> > static const struct vm_uffd_ops shmem_uffd_ops = {
> >         .copy                   =       shmem_mfill_atomic_pte_copy,
> 
> This is optional, if you did the convertion it's perfect (though it's buggy
> right now, more below).  Yes, UFFDIO_COPY might be a good fit for a global
> API like this, however that's the least useful, as I mentioned, I do not
> expect a new user..
> 
> It means, what you did on this may not grow any user.  The whole change may
> not be useful to anyone..

We currently have two users, that's why it's here.  It is useful because
we don't have hugetlb in the code anymore.  We don't even have shmem
code in the userfaultfd code.

> 
> Then I see what you introduced as the API:
> 
> struct vm_uffd_ops {
> 	int (*copy)(struct uffd_info *info);
> 	int (*zeropage)(struct uffd_info *info);
> 	int (*cont)(struct uffd_info *info);
> 	int (*poison)(struct uffd_info *info);
> 	int (*writeprotect)(struct uffd_info *info);
> 	/* Required features below */
> 	ssize_t (*is_dst_valid)(struct vm_area_struct *dst_vma,
> 				unsigned long dst_start, unsigned long len);
> 	unsigned long (*increment)(struct vm_area_struct *vma);
> 	ssize_t (*failed_do_unlock)(struct uffd_info *info);
> 	unsigned int (*page_shift)(struct vm_area_struct *src_vma);
> 	void (*complete_register)(struct vm_area_struct *vma);
> };
> 
> The copy() interface (and most of the rest) takes something called
> uffd_info*.  Then it looks like this:
> 
> struct uffd_info {
> 	unsigned long dst_addr;			/* Target address */
> 	unsigned long src_addr;			/* Source address */
> 	unsigned long len;			/* Total length to copy */
> 	unsigned long src_last;			/* starting src_addr + len */
> 	unsigned long dst_last;			/* starting dst_addr + len */
> 	struct folio *foliop;			/* folio pointer for retry */
> 	struct userfaultfd_ctx *ctx;		/* The userfaultfd context */
> 
> 	struct vm_area_struct *dst_vma;		/* Target vma */
> 	unsigned long increment;		/* Size of each operation */
> 	bool wp;				/* Operation is requesting write protection */
> 	const struct vm_uffd_ops *uffd_ops;	/* The vma uffd_ops pointer */
> 	int (*op)(struct uffd_info *info);	/* The operation to perform on the dst */
> 	long copied;
> };
> 
> You went almost mad when I introduced uffd_copy() in v1.  It might be
> because there used to have pmd* and something around pgtables.  However
> I'll still need to question whether this is a better and easier to adopt
> interface if a mem type wants to opt-in any uffd features.
> 
> So are you happy yourself now with above complicated struct that memtype
> needs to implement and support?

The entire thing is crazy, really.  I don't think modules should be
doing any of this.  It's nuts.  How can you register for a memory type
and not know how to deal with the memory type?  It makes no sense in the
first place.

The only reason that this is approaching acceptable is that memfd
already does the things it needs to do with it.  So we're trying to hand
something back to someone who already made the damn thing, but has no
way of finding it themselves.

Otherwise, this is stupid.

> 
> >         .zeropage               =       shmem_mfill_atomic_pte_zeropage,
> 
> Why a memory type needs to provide a separate hook to inject a zeropage?
> It should almost always be the same of UFFDIO_COPY except copying.

This also has two users.

> 
> >         .cont                   =       shmem_mfill_atomic_pte_continue,
> 
> It's OK to have it.  However said that, what we really need is "fetching a
> cache folio".  I'll need to check how you exposed the userfaultfd helpers
> so that it will support mem types to opt-in this.  To me, this is really an
> overkill.

This is literally doing what your subject said: modularize memory types.

> 
> Shmem impl:
> 
> static int shmem_mfill_atomic_pte_continue(struct uffd_info *info)
> {
> 	struct vm_area_struct *dst_vma = info->dst_vma;
> 	struct inode *inode = file_inode(dst_vma->vm_file);
> 	pgoff_t pgoff = linear_page_index(dst_vma, info->dst_addr);
> 	pmd_t *dst_pmd;
> 	struct folio *folio;
> 	struct page *page;
> 	int ret;
> 
> 	ret = uffd_get_dst_pmd(dst_vma, info->dst_addr, &dst_pmd);
> 	if (ret)
> 		return ret;
> 
> 	ret = shmem_get_folio(inode, pgoff, 0, &folio, SGP_NOALLOC);
> 	/* Our caller expects us to return -EFAULT if we failed to find folio */
> 	if (ret == -ENOENT)
> 		ret = -EFAULT;
> 	if (ret)
> 		goto out;
> 	if (!folio) {
> 		ret = -EFAULT;
> 		goto out;
> 	}
> 
> 	page = folio_file_page(folio, pgoff);
> 	if (PageHWPoison(page)) {
> 		ret = -EIO;
> 		goto out_release;
> 	}
> 
> 	ret = mfill_atomic_install_pte(dst_pmd, dst_vma, info->dst_addr,
> 				       page, false, info->wp);
> 	if (ret)
> 		goto out_release;
> 
> 	folio_unlock(folio);
> 	ret = 0;
> out:
> 	return ret;
> out_release:
> 	folio_unlock(folio);
> 	folio_put(folio);
> 	goto out;
> }
> 
> So are you sure this is better than the oneliner?
> 
> In your new API, the driver also needs to operate on pmd*.  Is it a concern
> to you?  Maybe you don't think it's a concern now, even if you used to
> think uffd_copy() has concerns exposing pmd* pointers?
> 
> The current series I proposed is not only simpler, but only expose folio*.
> That's at least safer at least from your theory, is that right?

I disagree, it's adding yet-another-mode to the code instead of function
pointers.  When do we stop bolting on and start fixing existing issues?

This change stands on its own without guest_memfd support.  Yours is an
anti-pattern.

> 
> >         .poison                 =       mfill_atomic_pte_poison,
> 
> Why this is needed if UFFDIO_POISON should exactly do the same thing for
> each memory type?

Yet, it doesn't so there's a function pointer for it.

> 
> >         .writeprotect           =       uffd_writeprotect,
> 
> Same question.  Wr-protect over a pagecache folio should really behave the
> same.  Why do you need to introduce it?

hugetlb is different.

> 
> After all, even in your branch you reused change_protection(), where the
> hugetlb special operations reside.  I don't see much point on why it's
> needed.

hugetlb uses hugetlb_change_protection().

> 
> >         .is_dst_valid           =       shmem_is_dst_valid,
> 
> It's definitely not obvious what this is for.

is_dst_valid checks to see if the destination is valid.  I can add a
comment if you want.

> 
> Looks like it's trying to verify vma validity.  However then I see shmem
> impl has this:
> 
> static ssize_t shmem_is_dst_valid(struct vm_area_struct *dst_vma,
> 		unsigned long dst_start, unsigned long len)
> {
> 	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
> 	    return -EINVAL;
> 
> 	return 0;
> }
> 
> Why shmem allows anon vma?

We can drop the !vma_is_shmem() check from here, but I just moved them.
This is an existing check today.


> 
> >         .increment              =       mfill_size,
> 
> This is almost only useful for hugetlbfs, same to page_shift and
> complete_register.

Correct.

> 
> It's ok if you want to clean hugetlbfs.  But if we want to fetch the
> granule of the folios inside a vma, IMHO we should make it a vma attribute,
> not something special to userfaultfd.

If there is a user outside of uffd, then we can move it.  Until then,
let's not pollute outside of mm/userfaultfd.c please.

> 
> >         .failed_do_unlock       =       uffd_failed_do_unlock,
> 
> You'd better at least change the name of it.  It so far unlocks some
> misterious locks then try to copy the folio without mmap/vma lock.
> 
> inline ssize_t
> uffd_failed_do_unlock(struct uffd_info *info)
> {
> 	ssize_t err;
> 	void *kaddr;
> 
> 	up_read(&info->ctx->map_changing_lock);
> 	uffd_mfill_unlock(info->dst_vma);
> 	VM_WARN_ON_ONCE(!info->foliop);
> 
> 	kaddr = kmap_local_folio(info->foliop, 0);
> 	err = copy_from_user(kaddr, (const void __user *) info->src_addr,
> 			     PAGE_SIZE);
> 	kunmap_local(kaddr);
> 	if (unlikely(err))
> 		return -EFAULT;
> 
> 	flush_dcache_folio(info->foliop);
> 	return 0;
> }
> 
> How do the mem type know what locks to unlock if they do not lock it first
> themselves?

We can change this if you want to move the lock to the internal code,
but the failed exit due to the folio mess that copy makes required this
block of code before.

hugetlb has a different block of code.


> 
> >         .page_shift             =       uffd_page_shift,
> >         .complete_register      =       uffd_complete_register,
> 
> Hugetlbfs specific hooks.  It's OK if you prefer rewritting code for
> hugetlbfs.  I don't have objections.

Yes, hugetlb is a memory type and so it is also modularized.

> 
> > };   
> > 
> > Where guest-memfd needs to write the one function:
> > guest_memfd_pte_continue(), from what I understand.
> 
> You did mention what is required in your new API:
> 
> 	/* Required features below */
> 	ssize_t (*is_dst_valid)(struct vm_area_struct *dst_vma,
> 				unsigned long dst_start, unsigned long len);
> 	unsigned long (*increment)(struct vm_area_struct *vma);
> 	ssize_t (*failed_do_unlock)(struct uffd_info *info);
> 	unsigned int (*page_shift)(struct vm_area_struct *src_vma);
> 	void (*complete_register)(struct vm_area_struct *vma);
> 
> So guest-memfd needs to implement these 6 APIs to support minor fault.

Or, you know, call the existing functions.

> 
> > 
> > Obviously some of the shmem_ functions would need to be added to a
> > header, or such.
> > 
> > And most of that can come from shmem_mfill_atomic_pte_continue(), from
> > what I understand.  This is about 40 lines of code, but may require
> > exposing some shmem functions to keep the code that compact.
> > 
> > So we don't need to expose getting a folio to a module, or decode any
> > special flags or whatever.  We just call the function that needs to be
> 
> I didn't reply before, but I don't think supported_ioctls is special flags
> or magic values.  They're simply flags showing what the mem type supports
> on the ioctls.  One can set it wrong, but I don't think what you proposed
> with above 6 APIs would be easier to get right.  Any module can also make
> things wrong in any of above.
> 
> UFFDIO_CONTINUE itself is definitely getting much more complicated, it used
> to only set a flag in supported_ioctls, provide a oneliner to fetch a
> cache.  Now it needs all above 6 APIs, one of them taking uffd_info* which
> further contains 10+ fields to process.
> 
> > called on the vma that is found.
> > 
> > If anyone has tests I can use for guest-memfd and instructions on
> > guest-memfd setup, I'll just write it instead of expanding the
> > userfaultfd middleware.
> 
> Personally, this whole thing is an overkill to me:

Absolutely.  And it needed to be done.  You are welcome.

> 
> $ git diff --stat 63f84ba525ea04ef376eac851efce2f82dd05f21..HEAD
>  fs/userfaultfd.c              |  14 +--
>  include/linux/hugetlb.h       |  21 ----
>  include/linux/mm.h            |  11 ++
>  include/linux/shmem_fs.h      |  14 ---
>  include/linux/userfaultfd_k.h | 108 ++++++++++------
>  mm/hugetlb.c                  | 359 +++++++++++++++++++++++++++++++++++++++++++++--------
>  mm/shmem.c                    | 245 ++++++++++++++++++++++++------------
>  mm/userfaultfd.c              | 869 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------------------------------------
>  8 files changed, 962 insertions(+), 679 deletions(-)


Right, so the existing code a huge mess today and you won't fix
anything, ever.

We currently have a uffd_flags_t that sets wp or not then passes it
through to set another part of the flag to pass it through again.  This
is stupid.

And then it gets more stupid.  We then check that flag exactly once for
the second argument in a global function and NEVER LOOK AT THAT PART
AGAIN.  So we now have a type to contain a boolean, but we keep passing
through the uffd_flags_t, so we can see if wp is set or not.

And you're fine with it.  In fact, let's add another one.  I mean, we
tried for two but people didn't like two so lets whine and whine and
whine until people get frustrated and let you push a second one of those
gems into the code you REFUSED TO MAINTAIN.

This is what owning a problem looks like: I removed the uufd_flags_t,
because it's stupid.  I removed all the hugetlb checks because I
modularized the memory types.

I'm happy to address changes, but I'm not happy to accept more
middleware and "it's not part of the patch set" to address any problem
as you push more trash into an already horrible code base.

We need to fix things too.

So I'm fixing it.
Liam

