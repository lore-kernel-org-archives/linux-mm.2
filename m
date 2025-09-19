Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46EF9CAC597
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 01:51:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73B378E00C3; Thu, 18 Sep 2025 21:51:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 712858E0008; Thu, 18 Sep 2025 21:51:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D9F08E00C3; Thu, 18 Sep 2025 21:51:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 494E68E0008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 21:51:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 02D9259587
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 01:51:13 +0000 (UTC)
X-FDA: 83904322068.25.DB8BE44
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id 840041C000C
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 01:51:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=l0ASlmUW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=LZ+yCTgI;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758246670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l2HbhpgdTEsSggjpkk4g1vOI4erXgAjeoUZ5ATaqUJo=;
	b=vzboECHYSmNcVRvC6HJrdEIvrdXawuMBz4NVcWokBy0IBLdviVJNEWQAB/Uhd2TnRflVe9
	Cw7XqBAg4GgNgcL8oLG/A6YQaM89/rfT0Fruh0gRxHsjSreTYScqCQe+LqjPj98lQUQ4A4
	Z/oEKYPDcHZaB+7X6AvrF/BEw8I4VUA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758246670; a=rsa-sha256;
	cv=pass;
	b=vB1uTJOju572sn6gPepNicF/chl4D+alPTbFXKAQg8d8aBWJ+TOxPVQwsH6Se/VzXz3EDS
	J8EKwOG03ycU7wv84qyKs36s/2ElwUq07s+Yto+887krOHmJYhiFaDy+0aFb21V07Cz8eo
	T8LVlEI6Amb6LIEgOgzxKY42X0mhrF8=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=l0ASlmUW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=LZ+yCTgI;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58ILFUIH007018;
	Fri, 19 Sep 2025 01:50:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=l2HbhpgdTEsSggjpkk
	4g1vOI4erXgAjeoUZ5ATaqUJo=; b=l0ASlmUWUnGSzH0dNX3ddEF45v1TItf4aB
	Zym6+qClAGEbSPl/CCy8n7krlV8/cBlKG/JhCDsHjDC83hl8+GxXU0gZ6xHBfwam
	vOmevUJVBTxTJxsyEQ7tCFLftLFE8S5IUxsya6f3vbSLp2XF1sFEVpjJ5lUcHDL6
	fQJ5EvlrbV1fjPKfyh7UgJOU7iCa5IN0jgZszN1z0WSw8kpXvC5hjnFK/TfRKSkC
	u73dZm+SF/k2bjNDSy3sk0AVFBcpgh/cVMW82aW9ptX8s8jUpodNfCxlT2oDHCVf
	MiGqTBcTbyBFCdwL1G93FjioUmqWmFrdnW3EuRP8l5Ij3WvL0epg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fx6mpsp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Sep 2025 01:50:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58J1ofAN027235;
	Fri, 19 Sep 2025 01:50:56 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012018.outbound.protection.outlook.com [40.93.195.18])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2p6atf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Sep 2025 01:50:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CH5lzoHzX67da8GCWjSs2ZLTFENWlIKOXKcK37vUBqCerXliDIzkReZb8p3NXs5RNMoFGSwG0aOGBrCLzIUBaFuvOwjnoepr+P8grLdMBUISGKwDPx/A5LBuug1sD3YfEuJ2L8F0UJizdwuH7Jl4ruTLKw/61UwdeL4M3apBq7IbDqCGIqfDsoHpGSaUQw5k8mOLFMRzsoU4sn/6y/qBD3YrGSmn1EVUiG1W06QKR524HaSSndNYigmSFJvGQdcFFdcz63Rz4oAoeEPVy4xwrgIkjwTwcJjSVNgfaXdNVSRQBHx4/nDdE+gkfxWEJZhO5VSAqRI2GEjNxH4g4mAydw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l2HbhpgdTEsSggjpkk4g1vOI4erXgAjeoUZ5ATaqUJo=;
 b=EUg7vosPgxVNGG3JDiLdRvMJksDhXQQphFu0cxXfp/F/y2BRz8eQS6Yr7mLJSbEFfpVrJ+Yn6V5st1G/x8R6I2crW5UVSZKrvFZIcJKSPIb7Lug99b3xo2TtC/NDuH0pIrIDmGZST6jBNwCtZ+uN7wq1ixB6tLdkD/0WfbklKH5NmF9rMYkpCNJb+IfNFfbSEcF0MXBIJ82bzUbYX+Mbb3xvAsp8nmtI/gwuXJC4hzW8CHZezZRGeRNWjG4uTulUSeT/+reY7YBM6TimacDAifqPQ8fFEnZsO3rDxKQB9muWDuLHIdIwS2HIOA402yS8opN/1Xu2XMNIDwR+8cvnvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l2HbhpgdTEsSggjpkk4g1vOI4erXgAjeoUZ5ATaqUJo=;
 b=LZ+yCTgI4jeSuia0n7jaRQU7egndbz8mBYXZ0ANyRODKppFMuIrQP0RMPRnq+4vpP99ataY5ryfQK3IV5tDmyd7ExGjYn4q4VG89xYYklsH2uQETu9izhojPpqB6T79qhnPbZmDgzMa3Fb8PtZt4X5Ia5YND/qrmmqG8rcetMWE=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA2PR10MB4441.namprd10.prod.outlook.com (2603:10b6:806:11d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Fri, 19 Sep
 2025 01:50:54 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9115.022; Fri, 19 Sep 2025
 01:50:54 +0000
Date: Thu, 18 Sep 2025 21:50:49 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Nikita Kalyazin <kalyazin@amazon.com>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Muchun Song <muchun.song@linux.dev>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Houghton <jthoughton@google.com>, Michal Hocko <mhocko@suse.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Ujwal Kundur <ujwal.kundur@gmail.com>
Subject: Re: [PATCH v2 1/4] mm: Introduce vm_uffd_ops API
Message-ID: <swfs7qpgrezamnijhheiggwdfklfqdc6ahp5g7nvprr64m7wz5@msf2mqajzbuz>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Peter Xu <peterx@redhat.com>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>, 
	Muchun Song <muchun.song@linux.dev>, Hugh Dickins <hughd@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, James Houghton <jthoughton@google.com>, 
	Michal Hocko <mhocko@suse.com>, Andrea Arcangeli <aarcange@redhat.com>, 
	Oscar Salvador <osalvador@suse.de>, Axel Rasmussen <axelrasmussen@google.com>, 
	Ujwal Kundur <ujwal.kundur@gmail.com>
References: <aMp-kW3OLqtZs8sh@kernel.org>
 <du5pzxmfk6lile3ykpaloylwz4eni6disj2oe25eq6ipzqemiw@ybcouflfnlev>
 <aMvEu9m7fJLnj862@kernel.org>
 <4czztpp7emy7gnigoa7aap2expmlnrpvhugko7q4ycfj2ikuck@v6aq7tzr6yeq>
 <a1a48a0e-62d3-48d0-b9c2-492eb190b99f@amazon.com>
 <7cccbceb-b833-4a21-bdc4-1ff9d1d6c14f@lucifer.local>
 <74b92ce3-9e0e-4361-8117-7abda27f2dd4@redhat.com>
 <aMxNgyVRuiFq2Sms@x1.local>
 <cigo2r2x22bk7wzr6qvazcdkmt5kfqhbgb7nslpuff7djufucg@f6xucfuntz3q>
 <aMx0oGwRpSTcfdnf@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMx0oGwRpSTcfdnf@x1.local>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: MW2PR2101CA0011.namprd21.prod.outlook.com
 (2603:10b6:302:1::24) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA2PR10MB4441:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f3dc9a8-5362-4532-d8ac-08ddf71ef803
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Kx/E1J/y/u9nbRL2fiKfa9odfXsGOxm+8uggxP0S+g5DNmisWKmsu2ETcu8k?=
 =?us-ascii?Q?p1sWHQdPyRAXaD4U5CtAbhB3rXsk4oH/nUx5R9SmA6fIkBxxkpPK4SdUqqVS?=
 =?us-ascii?Q?m0UR3aZTkFNWW41pdJ048so6VRxOY5FOxtofWSURwwyl6OygGIi4J4GIBY63?=
 =?us-ascii?Q?v/OOoR1+BmgKubUYB7bqZfWRTigAlp7eJXt+n3DaBi6qe0mJuzTAXlZiCU/b?=
 =?us-ascii?Q?zZNUWXHZq28V6XwBoRCMXmTkzNgxb45SjzZYQdXtNlOfYhQPIk6z5ib9ah2V?=
 =?us-ascii?Q?LbGWmF8S4wBaUqIi94e0ZZe2aFwM3EIp2rv9ZnP7bXWlaia12r+7GUL0Ee0V?=
 =?us-ascii?Q?8DFvnLRdpYt7O+FCTpGXN9hHmb7tH1OGbKCkSzwlZBGMUNK9RBzoJk62DDj0?=
 =?us-ascii?Q?0CgP4DxDVZ6V97O475YY4oNxK06vjnhqoTkXuC7agkoZfQJFPPHCN61/LIy4?=
 =?us-ascii?Q?lVl1lvGKcYrsvPuwoSTdextVO1wwLOhiOjRnUWtg37ohgFPmF3qEVHk+L9sE?=
 =?us-ascii?Q?IQFtjIBCgF3MPEubtXnVBofyExs7kBVlq9PrH+yhFWdTUpLim5mdaWh72oF3?=
 =?us-ascii?Q?tS4JQosqJxMH0f1jYddkpjDUbPYIyhIO4nf+VQx4W3F5/ghuM1uAwlElJ3Pv?=
 =?us-ascii?Q?3rPKQ3VpqRLEgwrqeiKOfNYwZ/tJJVXuakLl6461SV9TH1SChsxBQIl4ImKt?=
 =?us-ascii?Q?enyVUNHgQ6lJ58bYwlXhcozeQmBxI+DAIcTOWfO4f6p/AN1/90q8knjclmOn?=
 =?us-ascii?Q?cVH4YIkmFS3uCJeHnqzRUquGW+8jNsQ16ODnd/L4SFXqRrV/f/R2cNNHXdJg?=
 =?us-ascii?Q?0lrY/BampnvGN7u+CI0BqiUGTpHqyXNcGKPQgvmlGVDE6yPbH2T0O7cb0DlS?=
 =?us-ascii?Q?gZYCLsVQZfqpE09d8E163wq4J9hmbmhRleqEyAFEXN7aNUSELHZYqhXLFy1j?=
 =?us-ascii?Q?t98oVhvfcvjyIgvIBnXMSrjF+AFV+sAIZiKwp2pCCRkTUeXyd7AVowzpi01t?=
 =?us-ascii?Q?U2dj2ubzYRIlniVK5jqKQxwyQdrba+cX/wBvxf2179OB6NZzhXkyZRHG8FHy?=
 =?us-ascii?Q?DaeZXCw6xu8dgRrv3y3SAxWirig20+VwM64mtMd5PULsv6iwKP8dLhzE4oAp?=
 =?us-ascii?Q?QZFn+BW0zxU5T58DErQG/f9yj+7mRfdxZ5NhxUrup2qORN8LTO4Vz0D+jqk6?=
 =?us-ascii?Q?ljD6G/52SraPn4kMddgKHhthaJF7OAtec5VK2vHCHLe/N2XigFnKuU5yMY0J?=
 =?us-ascii?Q?E3GozyYWbQr1pPQJJTZ6sYaTzRB9f/woC7pyT+a/bLe6jaPtBwnPL+tdDdky?=
 =?us-ascii?Q?YvathWIGDB59Sd56xqS7SqDTa7FHmFCWgKqT53SckP/E44cFsb860JzeXS5z?=
 =?us-ascii?Q?Vi9CvPbGIvSNcFxYd6U9ts/VrVgk?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?z51mLFqhpKCCyzKtcuidA7GWpzybOgQ5kt2Y6YZKyKzSnrUyivZrEzlaVZLl?=
 =?us-ascii?Q?YDJNE6c0pD5awAW7nBe/XZxzbpjscN12lCu3qoVkFJqAsRNKzSXtNz1PobUf?=
 =?us-ascii?Q?N9VeW12dYhSo8FgjFMkUJgc/RkQ5rqfdAfY2p4CJQzqlUw57x/AU/T+LoGH7?=
 =?us-ascii?Q?3VZE1nWaLFo+kPPgU/wPzPaLImZKG+AkLylSzYVMLAcmCLwHFDaQC3h0xjLh?=
 =?us-ascii?Q?V5mmAal6z2kjrua/5uyDjY2FkAWd3u4zIlvlaviWsCEU7kKxm7YxSCGnN/3+?=
 =?us-ascii?Q?X5fSkHRJOr3YJNpE+FWlnyfBYO1B0vdyGgx0UpCN23u0E94+Y2mYTTR6KOAl?=
 =?us-ascii?Q?bSYvtKNxUtYb1M4WsbRoAxOZzzGGmvBpefkP3oc3UTMiXcIjjZ7Ue+hjEc/y?=
 =?us-ascii?Q?/Eemf8XDtY1JFc1OCTssXSrHC/oN4vrtETSny0vxBYlUQnNxF7Np4ABwGyM/?=
 =?us-ascii?Q?SiqTiZqnYP6TEUpQHk5M1jrx1CQEDwTALtbZLQKN955s8dguLuwUQpwfsWHr?=
 =?us-ascii?Q?/yjC4FLjcbybTFiSY16rzW8RxmW+pDFHtks2vLYT5PcojTU5LmRR2NmWDn+w?=
 =?us-ascii?Q?Kp3nKH/OYon5IFfSWZ8SQhelK2K8VPgo+QGbxm8QzUS9cHbH204wEnwi/Z0b?=
 =?us-ascii?Q?K9QnEy9HOUDiH6wCS4yGXtEj2viYYIowk3DRiX41GpvWlzpr/wivF/V+zapr?=
 =?us-ascii?Q?eR5tCEw7+EgrbuTX/SwlsEIt3yCGH81M/jaRGFB5AM5+bwvWQ4gOE8mC/vph?=
 =?us-ascii?Q?cu8fKF5oMr7mOxNMa+1bextOuRvE10kUyC0G8aHaAOWKeW96f3+nIdgsAEgS?=
 =?us-ascii?Q?Kj0a5XCbQQ9ZuT1+8D5XnOezxFiPjzInJfZQ8UfKsNdXmmODvIDapEUs4UKi?=
 =?us-ascii?Q?psKxX/JOBS1GexPTz9nWHatw3+UJDW0hiejRBux7gBWE7J/vOeEfGfUMeN4y?=
 =?us-ascii?Q?tJ1J0npn2pg5miFxfbtGALN0e2NQc8lxD3MrhgFM1q65SUKRkfaokX+xvu/X?=
 =?us-ascii?Q?nD/He9bd9Uo6xN0Ko/Y/O6G7D5oxj7wZLyjQewVNqRJtXs6inFMqmwpP8E3h?=
 =?us-ascii?Q?eoB0MXYfbdT82jS3kJwfZ4jRb6zCEUY8i+rb6aA+5FY7weviRS0OuwfxqR9T?=
 =?us-ascii?Q?0IhECEv12HZfcBOT79QQ7Z9TDoUnw6PmcfjIUnmN33xeNj6SsoehexHEAkWk?=
 =?us-ascii?Q?CXDiXD95EGOtdfi3vgbOlSCQDULi1vKa4F8s7GecDF92Slm5HQnpYAt/WPHx?=
 =?us-ascii?Q?+nGKPfWhze46CGX5rYAvDbsH4zYPO5/OWUtY74Wl+MhxyIlWfRg/R1sMfGNr?=
 =?us-ascii?Q?HAaLtwcyvjn8EKsYoQL05AeDzMMTTKgJhEzMqXz0qzW4GQYdQziRkvJO8+jS?=
 =?us-ascii?Q?uvoqegjrj6UmU8FRPAw2/lHBnwM7wZxDgd638zubSi60aVfRG7yrIljoOU6M?=
 =?us-ascii?Q?Ny/9lCz+RUiQ6ue3tFeoEWHRpLGNSWfQS44Quu7axqF4QFBQlaNNRmxKlRME?=
 =?us-ascii?Q?oz3CMXgwrlBt2m8yvEpWnKeFmlbXOlEnfQiSuyI5bHEKuq6QQkqz+hXu8WMD?=
 =?us-ascii?Q?fADJgAXLIEU5p0TouFruAeOFbTNy+jr58CRNl2F+?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LrVxx99GGsaAcELdKqU95xeGGpRcqDAKNEFj3j4FAKHbHp3VWLC8Qzcblj8YnRPKzxU9rehl2IRp/7FQTXnnYHuBPfRq2cNmtSGVjj8G6YYEkUVH4hhBbp1Jt0W9GZ88g1qkU0Ypq8dvFUMURpVvIJ6CmQd3PfX2cvHcXnDkG4aJ2PjmtD+qG5nHlxgAHrbzmRlhNSbXAe/UHCKpFns2Iogfe0OibajHemn2xh8b3XAQtGmfnBGEoEjJfFZEbc+LqwrzVM+YDQWrvtZGRtpiGtX7CwsLFoMGf/XO1Da4pAF5iR02LrN/zvzOQPi1+8hyaCVxRowliJGnE5ODwdbHSPNKQAXjVJBDlAn9SRVu5JtZApq0BocNKu7gOjkxdTg9ykon9IiqQKmAso3t+WAPjNLf+MXF47iG0iUXvav3xMUjgu1bdpz+fStVQyewI/jb1DIVTgxvrD1XO9M+VFc46QeX0lH2ZWIjGxLZCObEtV6pHjcz61IvZtUMOgomFrMFEAqFYjOdN9t3BVPcZNvXcTin/T1OVVb7Z8Uz96lnuTUGGowHkYVLDx6hmxAiAyqcG/n4nJzbi6Oqd+SxkwfutIAFoMbGumnmoYcwTuF3LUk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f3dc9a8-5362-4532-d8ac-08ddf71ef803
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 01:50:54.0518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /L/F+NMbT0vRthAkViUbUjRBV7NB3zUYN6/5hV+IwIa7he/I7VWZ29c3wOSoQJDq0AyUXZE/2cYGpnIJ6AQPuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4441
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-18_03,2025-09-18_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509190015
X-Authority-Analysis: v=2.4 cv=TqbmhCXh c=1 sm=1 tr=0 ts=68ccb701 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=vggBfdFIAAAA:8
 a=20KFwNOVAAAA:8 a=ezW0XxNm-LSnuw-XBWoA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12083
X-Proofpoint-GUID: jQUJgGnu00E2Lt6eFJXMnw22eET1tep7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX7bPUVNL+HDGx
 RE/pFFERMA3uz1kyCizNKyO51y/6sye6wZxgYWNlTeJ1eo5Vzf5Ap9mcHKakjH/u38Ff4/wpf+5
 3xYA7uqkIH4Q8RilPFvPgMg8CQBqr64jlYjZgM2vBYfZVMLNdx68EKSNWo6LBnILkUHB+bwdrUZ
 HdU+hO+rtEJzLxWKny6JwdHOYr15ZrYp9YAi9QfrD7gXJFONF/uN039BVvnvxvTfnjEyshoWG/F
 NpcYQGa4m9JMbJxn1wOA8oKN/gQeiJvRec0kP0l4pVZkm1F7M8tVh5JlY/QT7544JitwRSOp7FI
 bSCabWdqyzV42SEGTm8XkYSu+PQvMVPlsWEAEGPIa0Ia5UEJCBtKQapsiYFg8dzbeXQzpQs4ya5
 5BppV4LdwyKSR8eiqqmbmkVtSquOkw==
X-Proofpoint-ORIG-GUID: jQUJgGnu00E2Lt6eFJXMnw22eET1tep7
X-Stat-Signature: 5gzz7ccrx1i6edkshfeokn4fwny4ii5c
X-Rspamd-Queue-Id: 840041C000C
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758246670-348089
X-HE-Meta: U2FsdGVkX18fPOJIIZJUcg9hl8jt/l4YsZJOFLrxR7i0BXnueidPZiKNMVmMoM1VCufo+nqe/TlBSkPsJbMjJ0N4EYXFcBfdsbIrmUH/pnW7ahT7Ublsp4g5wzuyaLwWHqMx6zi7P9qnmNmHjkrxOdArCsO+3mZ05+1r5f1ZkRHLvO6SAWYDvsjo5t1SEGtGV7WTNgYKTKNT9spzrp75K9SDaxtpDEZZ3d0hJ7VObu5dpsx7Lh+H6OkEzYR9bfvsDt6F5tAWxKqWjv0hqLAJEbfRIDhdgKh8a3QJkauVtSx1Z4LGrCqnM6y/KVYobeieXc8AivFkm3HoVMgHeWbZ7w0JePklie9kstZ0zkLc39aC6satnj7v08t6sGFpRlGQt+ICSl/XveztcFPF7XKqvLaCv89yxsUuig3ylBT1Zq4ujpB7Ik4iMwtLskxmLVP0ePEEkMhpx8U/QmrQ1TGfNgIEqh1TPwKe2J7+2LIj8LhciXlz/wWUU2jbQi/ADZ99E0AwlZrWX5niAyAXGhRv6T7N01OztFWIQlOoxnNSHxG2BHUVnTfRSQEQ1TQDp8m2lr+PPrgDPuKCFhKwUaWC0nE0V2wE1kwnuJQyeLh72vnX35e5kpbcXMIqJ8Ep/uGY10mi5VJ1sHRYOTFAskDXHxADTKyfFjPr2ydUHeUYaFCoDB3tTzqozJNuh8OimgrJq/lHVYdyF9uin769cTVGdzhtIK8pOMcFUvSVkdbFIUqyMTXgrK1WllQaeQFukewxoKxeC9oid6WMaPDlzq4VYMa1ryNuvgtwKWbfDouT6Nbmpt8nUIqBPJ/HoJeHI58wt3/A+6uImV0WkxZ6Tp9u9vlnMZHO4xe7DO6B5koSe7wnBSIniBIQoAnx/OrxI5fJxdfa3U6r6PjVjeyVBqS0U1imJkEPH96HI5ErLKP6zv6Aqc3aNoAi18PIdqhTl8q0PgQnqTbo3rK2h3E31x8
 P5bElcup
 6hm8niZAvzYeh3AgBBgRQhfbit7PgPQUX/zTg2nw75oj9sX+2JCCTZYHvGk9y2B4RTdDT1UhWvyHXPHRKaHOiDycV2mHq1AVVmnM4tHcaHFyedle+QpjESD8WOikj2KH5+r7nxyQtBL4Gb1rbGrm52SpRzXcTEBNsmv/eDw8tfobN3aWD78qGugdOL8c4HUXQYacwq/3ZmAJXhOvSGYM3drk5nkOcymdsbhxKf6GZXv6xKF56nI3Pl/Pyxq6WstoQxLyIA9YRJT+VZcD9rsfUVsJSxGYnYuH03NtV77VHYMDjixGk+5MIwtW+zeEbwYqfPDjD/y9PJi5YlfneWV5nOsgPpHy91lPTX404SUjtC64CyyR777kOb4ZxkAgAVhtqUNmKJCTE9WMRqLDUtH1YDLLhoEll1mAiZPzM4BUbjEDvCln5cO/dmi8v40fLm1Tjh+CKIjI7xaJPsSyPlH9Lw+sU0hwtk3c10vXzHUXPTKFRaXHGGQNLG9O3aE+nckEHPC8fljv2+fBJGTnMnUxz4g0MyrMq96u86mPqWzTtShgLulhc2TykSvgJpz03quJFZHW6NxYDw/PQKda2j8fmYer2CDFt6fopmsvIuhrFa/nPnQstLV9qRMxdJv4BkYbEtYocCcMPWRtT7+iZ4bjeNTJlDD+9OVCuwJvkkp6pQs+4AyP/1t7+SYzHqTkP9ClzLZJvEbRS6cJNWWrXjgqh8IoDhgg5zvvKS/snqrZRQ9lgjl3zk+onlCnA81wUs74nWn5cpcLRSbZv2lPdsnlLOzt51lH4tRndm5t9pt/KaisGraB+B6HOdWbZPFxoPXB5E2LnJ2uMPGgOHeqgYs1v1zSC4cL3Ba+Q3SG/XTS+b/3Pwq/Wf6wFt1jfI9nc8hOkNZGbbKJigqdAqZ83z6FeaPE3Mg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Peter Xu <peterx@redhat.com> [250918 17:07]:
> On Thu, Sep 18, 2025 at 03:43:34PM -0400, Liam R. Howlett wrote:
> > * Peter Xu <peterx@redhat.com> [250918 14:21]:
> > > On Thu, Sep 18, 2025 at 07:53:46PM +0200, David Hildenbrand wrote:
> > > > Re Nikita: If we could just reuse fault() for userfaultfd purposes, that
> > > > might actually be pretty nice.
> > > 
> > > I commented on that.
> > > 
> > > https://lore.kernel.org/all/aEiwHjl4tsUt98sh@x1.local/
> 
> [1]
> 
> > > 
> > > That'll need to leak FAULT_FLAG_USERFAULT_CONTINUE which isn't necessary,
> > > make it extremely hard to know when to set the flag, and comlicates the
> > > fault path which isn't necessary.
> > > 
> > > I think Mike's comment was spot on, that the new API is literally
> > > do_fault() for shmem, but only used in userfaultfd context so it's even an
> > > oneliner.
> > > 
> > > I do not maintain mm, so above is only my two cents, so I don't make
> > > decisions.  Personally I still prefer the current approach of keep the mm
> > > main fault path clean.
> > 
> > What we are trying to say is you can have a fault path that takes a type
> > enum that calls into a function that does whatever you want.  It can
> > even live in mm/userfaultfd.c.  It can then jump off to mm/guest-memfd.c
> > which can contain super unique copying of memory if that's needed.
> 
> Per mentioning of mm/guest-memfd.c, are you suggesting to take guest-memfd
> library approach?

> We have in total of at least three proposals:
> 
> (a) https://lore.kernel.org/all/20250404154352.23078-1-kalyazin@amazon.com/
> (b) this one
> (c) https://lore.kernel.org/all/20250915161815.40729-1-kalyazin@amazon.com/
> 
> I reviewd (a) and (c) and I provided my comments.  If you prefer the
> library approach, feel free to reply directly to (c) thread against my
> email.
> 
> I chose (b), from when it was posted.

Honestly, I don't know what I'd vote for because I don't like any of
them.  I'd chose (d) the do nothing option.

> 
> 
> > 
> > That way driver/i_know_better_that_everyone.c or fs/stature.c don't
> > decide they can register their uffd and do cool stuff that totally won't
> > tank the system in random strange ways.
> 
> What is the difference if they are allowed to register ->fault() and tank
> the system?

One less problem.

More people with mm experience looking at the handling of folios.

The common code not being cloned and kept up to date when an issue in
the original is discovered.

Having to only update a few fault handlers when there is a folio or
other mm change.

Hopefully better testing?

> > 
> > Seriously, how many fault handlers are you expecting to have here?
> 
> First of all, it's not about "how many".  We can assume one user as of now.
> Talking about any future user doesn't really help.  The choice I made above
> on (b) is the best solution I think, with any known possible users.  The
> plan might change, when more use cases pops up.  However we can only try to
> make a fair decision with the current status quo.

Planning to handle one, five, or two billion makes a difference in what
you do.  Your plan right now enables everyone to do whatever they want,
where they want.  I don't think we need this sort of flexibility with
the limited number of users?

> 
> OTOH, the vm_uffd_ops also provides other fields (besides uffd_*() hooks).
> I wouldn't be surprised if a driver wants to opt-in with some of the fields
> with zero hooks attached at all, when an userfaultfd feature is
> automatically friendly to all kinds of memory types.
> 
> Consider one VMA that sets UFFDIO_WRITEPROTECT but without most of the
> rest.
> 
> As I discussed, IMHO (b) is the clean way to describe userfaultfd demand
> for any memory type.
> 
> > 
> > I'd be surprised if a lot of the code in these memory types isn't
> > shared, but I guess if they are all over the kernel they'll just clone
> > the code and bugs (like the arch code does, but with less of a reason).
> > 
> > > Besides, this series also cleans up other places all over the places, the
> > > vm_uffd_ops is a most simplified version of description for a memory type.
> > 
> > 6 files changed, 207 insertions(+), 76 deletions(-)
> > 
> > Can you please point me to which patch has clean up?
> 
> Patch 4.  If you want me to explain every change I touched that is a
> cleanup, I can go into details.  Maybe it's faster if you read them, it's
> not a huge patch.

I responded here [1].  I actually put a lot of effort into that response
and took a lot of time to dig into some of this to figure out if it was
possible, and suggested some ideas.

That was back in July, so the details aren't that fresh anymore.  Maybe
you missed my reply?

I was hoping that, if the code was cleaned up, a solution may be more
clear.

I think the ops idea has a lot of positives.  I also think you don't
need to return a folio pointer to make it work.

> > 
> > How is a generic callback that splits out into, probably 4?, functions
> > the deal breaker here?
> > 
> > How is leaking a flag the line that we won't cross?
> > 
> > > So IMHO it's beneficial in other aspects as well.  If uffd_copy() is a
> > > concern, fine, we drop it.  We don't plan to have more use of UFFDIO_COPY
> > > outside of the known three memory types after all.
> > 
> > EXACTLY!  There are three memory types and we're going to the most
> > flexible interface possible, with the most danger.  With guest_memfd
> > we're up to four functions we'd need.  Why not keep the mm code in the
> > mm and have four functions to choose from?  If you want 5 we can always
> > add another.
> 
> I assume for most of the rest comments, you're suggesting the library
> approach.  If so, again, I suggest we discuss explicitly in that thread.
> 
> The library code may (or may not) be useful for other purposes.  For the
> support of userfaultfd, it definitely doesn't need to be a dependency.
> OTOH, we may still want some abstraction like this one with/without the
> library.  If so, I don't really see why we need to pushback on this.
> 
> AFAIU, the only concern (after drop uffd_copy) is we'll expose
> uffd_get_folio().

If you read my response [1], then you can see that I find the ops
underutilized and lacks code simplification.

> Please help explain why ->fault() isn't worse.

I'm not sure it is worse, but I don't think it's necessary to return a
folio for 4 users.  And I think it could be better if we handled the
operations on the folio internally, if at all possible.

> 
> If we accepted ->fault() for all these years, I don't see a reason we
> should reject ->uffd_get_folio(), especially one of the goals is to keep
> the core mm path clean, per my comment to proposal (a).

I see this argument as saying "there's a hole in our boat so why can't I
make another?"  It's not the direction we have to go to get what we need
right now, so why are we doing it?  Like you said, it can be evaluated
later if things change..

My thoughts were around an idea that we only really need to do a limited
number of operations on that pointer you are returning.  Those
operations may share code, and could be internal to mm.  I don't see
this as (a), (b), or (c), but maybe an addition to (b)?  Maybe we need
more ops to cover the uses?

So, I think I do want the vm_uffd_ops idea, but not as it is written
right now.

Thanks,
Liam

[1]. https://lore.kernel.org/all/e7vr62s73dftijeveyg6lfgivctijz4qcar3teswjbuv6gog3k@4sbpuj35nbbh/

