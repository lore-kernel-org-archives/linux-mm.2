Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACBECCF65E2
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 11:40:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECDA56B008A; Mon, 26 Jan 2026 06:40:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7B436B008C; Mon, 26 Jan 2026 06:40:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDDE26B0092; Mon, 26 Jan 2026 06:40:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B84AB6B008A
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 06:40:33 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6D39A8C1BA
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:40:33 +0000 (UTC)
X-FDA: 84373922346.27.CC9198F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 218CF80005
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:40:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ouOrzDxS;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UzitgjyI;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769427630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G5BXf7FSbCjCYww8s6rfo43ETB2ZfJ9g9i3XGa7RCC0=;
	b=D53wNq4/XqcxFJjw3UMrEpxtBZoXRzOAHJ9JgCd0OAJ8QytcBdBGnJAaL9zhFVROGIWtWu
	98KneqkxC/8Gs/N1LYXv7T3y8BHT0VE6SHjxyl6ytxOr0/yzWz7WGJwCuyqzuQXHF0iFxT
	sqbHzR3/xVEJRk5xuSYJxbxhzcje78A=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769427630; a=rsa-sha256;
	cv=pass;
	b=aQE98OdJi+QJXa1CulbM7knyMJCokvFTI4SGkqXcTuJ/sz8FgXupijsCPRNah2GohAmxXf
	KerQALtl+Y2+k9axF8LghWn+dvJrJKF/7jp7DvRZueyS0EA/Rw/JJJruas9sJzGNuTqFFj
	/nmFQ3rM1IbJZN2SFN4rwvUYdFM1M04=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ouOrzDxS;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UzitgjyI;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60Q14J5A440971;
	Mon, 26 Jan 2026 11:40:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=G5BXf7FSbCjCYww8s6
	rfo43ETB2ZfJ9g9i3XGa7RCC0=; b=ouOrzDxSx0r3aY4ar94mt57NhjDkYJKHgK
	SOmk/3QAhOmrDaHcRZMpVr16LoFOru9POVC5IFwkOBGh3jhDbpRKYas5CDHYjZiZ
	l5dqyfL6Q/JzVyMrCVE8HW9QN5HUKExXC8rm8//rqsRLMnFR4GG1s1h72kRfea7V
	faf5+tWxY4ilyW0WdLdgdpB0rEDm+8HIt++/l5V8b1Sbi2MQsC8c/bMLCvD2X6l4
	UCq3+Xwkt+YQlCLnliePeaHI2s2UyHBLtVHqV1nAVr6b+2Zx6j83AGeeRGJ77Ok7
	t8cWYo8LidYyi4cXyHePyLAjkMEzm0/FuFIJSzk/0qG9lnM7s8KQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvmv2sqcw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jan 2026 11:40:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60Q9AVrF001961;
	Mon, 26 Jan 2026 11:40:27 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010042.outbound.protection.outlook.com [40.93.198.42])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhcc5c5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jan 2026 11:40:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sDiKWB1HoFpRUp8b5Zh9bJ1ok39efYGHx74obFglE2vEV0m0S0N60qwEfJN3ejFca+FX2oASdPJ6oEQFgEd7N2+32XFyS4rW6Imn3bjwbne1WAKcul6ROMF97nFyrXIhauGCCdHPNYn/k+QpDdUQR9uUgt3hi6Jy3l364lL1MYgDLq6WvvPx7RkRI7sHocWaA6kSmc0+bChazNuH1muT3d/tJUFBXsHGKZ8WSOmkASplRvHFSjJafqEpeuPTS7WjY6Yn9QCC40KyccQ39FENVE0QQ6Pd5kvB0lDFKoAP+PpIO0y/HSIYczLW2AfboU+WXtt5PbicTBxGTEcuHO0r1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G5BXf7FSbCjCYww8s6rfo43ETB2ZfJ9g9i3XGa7RCC0=;
 b=XJ0ikYWCB0iylL5HzWYxHWjmtg54yt00hiX5rcjJ2jo5g5DFxGTos8zQMVK5NmmKml978FWX/PVPXAulIWwQnspROtgfI3gmfMHIfKhldc5X+Y/BmfoiPtW9qR32gHV/H0wt8ITNFoaS7qvTOmuX6cMxKCR4co08tibjpnzToZsbNw87wkYgbpIy3gisZlxtB3/zM33ws/BoEEtzpyGWq/xXfFmoU6GqEMfEglPkAkctpcrRCC4Q671QEH7xs2KGx42Gg+fUk1rR4KouShiffxn9TxKALzgWoj2J+zkILGX/32QBd17JLTovr9iUy4goYAxXMLQePSyG5jydoQ23Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G5BXf7FSbCjCYww8s6rfo43ETB2ZfJ9g9i3XGa7RCC0=;
 b=UzitgjyInP8z13g4d27M5/22ImQNCrnshz+7Nb5kvG8nu93GedwQ29CbyfEjwPAmIeJUX6jxFOg6B9s26bkfoTvVUVunI38WR9HcXxLD8Cg3YBXiYbt806ZUBhUUSwqtdyZBhohzzp2KaywloJ0tp4pZ42+9Rbdif1/IutvM9JA=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by BN0PR10MB4853.namprd10.prod.outlook.com (2603:10b6:408:115::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Mon, 26 Jan
 2026 11:40:21 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Mon, 26 Jan 2026
 11:40:24 +0000
Date: Mon, 26 Jan 2026 11:40:21 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: Nico Pache <npache@redhat.com>, akpm@linux-foundation.org,
        david@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
        mhocko@suse.com, linux-trace-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, corbet@lwn.net, rostedt@goodmis.org,
        mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
        linux-kernel@vger.kernel.org, matthew.brost@intel.com,
        joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
        gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
        jannh@google.com, pfalcato@suse.de, jackmanb@google.com,
        hannes@cmpxchg.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
        anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
        will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
        cl@gentwo.org, jglisse@google.com, zokeefe@google.com,
        rientjes@google.com, rdunlap@infradead.org, hughd@google.com,
        richard.weiyang@gmail.com, David Hildenbrand <david@redhat.com>,
        linux-mm@kvack.org
Subject: Re: [PATCH mm-unstable v14 03/16] introduce collapse_single_pmd to
 unify khugepaged and madvise_collapse
Message-ID: <0e79a766-811d-477c-83ee-389db29d41bb@lucifer.local>
References: <20260122192841.128719-1-npache@redhat.com>
 <20260122192841.128719-4-npache@redhat.com>
 <65dcf7ab-1299-411f-9cbc-438ae72ff757@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65dcf7ab-1299-411f-9cbc-438ae72ff757@linux.dev>
X-ClientProxiedBy: LO4P302CA0041.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:317::19) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|BN0PR10MB4853:EE_
X-MS-Office365-Filtering-Correlation-Id: d6955fd5-b9e5-4e0e-b0a6-08de5ccfb1e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sihabNan3laCk4c0rIfqrRIcF0SyNVOCHwyFmcCXP9xJGDh8simtNESg2qqt?=
 =?us-ascii?Q?Zo6oEU1uumfjX9JEG3v5Y4laEkKjnDjWuOXAOESOGN2wWkgEXgzLdsiEwkhr?=
 =?us-ascii?Q?r4y9Fo0F94aXaauIRV2chhjaUvJbW0HJmGmxkklmfu7/taynf4P/n6kYhKk0?=
 =?us-ascii?Q?5+wvzRcHcl91CwAq6h1xylp9IKAY4rMU5LjQJL6R283xEKKTwUHre/F5uvdk?=
 =?us-ascii?Q?GnHTImurQ8+EX6O8mFM0a93AuPSWFmSefMKovg5JXpg1jH3hbSX7o6WD2a74?=
 =?us-ascii?Q?9FhnktSVWPnlkZSkmtI1oTqwmmd9PHcDP73DtmAThMsf2gzuna6XcgDR6qhU?=
 =?us-ascii?Q?ljBky1B0prfg0fsz4wzNJ6ySpXkWLO3GEW4ZW9FbxFZXKf5PtUlV2J0B2d9o?=
 =?us-ascii?Q?0imisKfeNqJL0k5NsumopCRCFG6GXAUsR7d9XX3M3hlmhKlXY82Y33gu1qzE?=
 =?us-ascii?Q?DzH2kUTEn6XfFTmUuNqfQQDg0ybLtkK7vSv74AQ/7A7I4zLbfeeusdPvm/hB?=
 =?us-ascii?Q?a8WwWuEBhsFvuOhJEwINz9tqo+GV2oSh/XZjfRMVO3BDaZP30/V0BT4L0VOH?=
 =?us-ascii?Q?XvOZlmlqxDBI/HegpHQc4ZpqUgeZzVm0kw0GoeWx06dwSd9cLG+QISwNyqff?=
 =?us-ascii?Q?IoFNn60go36Ey6RrUeT+FNDxM0AHXDSjbnsM27yY+X7QHJnbxL7ECJNQfjr4?=
 =?us-ascii?Q?4wIH+TRs6d2LWCvnCH8kOr3zuVucTGR1Ebq5CwPOImTmYSbT+p4XnoEPzM9q?=
 =?us-ascii?Q?72M5dCWrkdKeah2TCLnu8vRmCv3sk2U6dhYkOhTxMzE52IBiSG+504FIAACc?=
 =?us-ascii?Q?dnW7hsHPMwPSUdothrxCt1k4L1uXJYUp0Dbfrs5G6pATN2FH9TasqRkVdbhb?=
 =?us-ascii?Q?4VbmvhtK88tmd7iCzSbXH5RGlNYcu8HUcPpcoqJJNPmZv7jsK95XJ4LxTHx8?=
 =?us-ascii?Q?qufBp29MqXnE6wZ9CHlm3smm1vjMtxEDCBPDgRUx5ERQlpMCDPnD+akTllTZ?=
 =?us-ascii?Q?YoYxOg4RWOypYqAzNJYR+tNCqI16IeOLdfMwnkeN3IKHYzpu32uRbCUSMXS0?=
 =?us-ascii?Q?ToCl+QZTQg8fL7Cw7qB2vc+3YWkiXQ6pAVpaeIyB7EtYmDwqbF1puzeA0i3Y?=
 =?us-ascii?Q?w2LGgqv91TB/s/9v3By9bD8hzPd4b9DpNNS+CpNSReVU4izutmBEjCHI8wvj?=
 =?us-ascii?Q?3rkFTVzMoULodCYKkhg9481wn/dyb7+CDlnsWYsIBPPIuWx3Ya0bOPHM7iEA?=
 =?us-ascii?Q?+n3UXz2yfHEk6L3A8IB51bKhzqg2urGmFlXQmTt/ht+j7k8e8/VkFk+J4gYY?=
 =?us-ascii?Q?8vHAmN12yBYu7583ZBGztB3A69nmD9k86iJes1+dOHbt7PX2gi8ebX0vUYN3?=
 =?us-ascii?Q?MusBWqXG9xG9mjhUsM4tl4rQErPXWUsYTOSObTl7w8ZeCTxxuafgFnGk6aJ4?=
 =?us-ascii?Q?6FduL7iP0Qj53rlIjNZKhnZNtfGWrJjUca4H9D5FYdvj29nWKkk2WFJQ9q5f?=
 =?us-ascii?Q?J2kzji5dTI109iKg04kIbRVkJww4azFfvlGpSLQy9sDBycBue6XVqojAVEyZ?=
 =?us-ascii?Q?StZhzil+V317f7GmoKk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WGnCix9Gq0n/uTy0VzIOpm1vOxBOwpS/lABEm1fKboGDcLajA8nFZ42a7ei6?=
 =?us-ascii?Q?3Wymg7W7pOg60stz641ohO0PDRZVodEhfbjz3NGjb6XbcoFl5bw7ESeCB+C6?=
 =?us-ascii?Q?uRm+Im2GkV764+FM+dNb9S8L7oUmorAhvD97VvKitlz2xBBpTMXsjSiDctuk?=
 =?us-ascii?Q?PqJFU+5k9+WOdNCJo1ZHWJZyRKEHQa2PKYUVco277GL2FNaxqoqgCVAh5oxi?=
 =?us-ascii?Q?m0lFF8rARNvnIbsx9wBIADHRmawHyfHp4RMhqCdgMn8K7xSlPUg69Vkj3a8o?=
 =?us-ascii?Q?JjGpat3zHxo7V1ZqwmcgrMYz9tdT1N67rtuE1ph1yBZ3m+VoJ+MF8bWOox33?=
 =?us-ascii?Q?t/ZHK2lkjmso9BW6qnKdQP569hY7Z50HixXDCypKae+JI7epvwwH6vxLAyYT?=
 =?us-ascii?Q?lFhW3eW5KavG8/5wtQtPUrdpoaAo75O/s750q/rbcGKXwx36FnBqCwM0uRYT?=
 =?us-ascii?Q?sOYv7k2pbaAqRRpEVmnYgxp4FxfYdxhzigg5MbgYiI7FjYeNCiKlGPApY5mU?=
 =?us-ascii?Q?KE0rtXjSv4y0o3+8gtaQ/I/u6fM+vtpcZBE1Xq5QcOAS7DbcUkwyBPmPQKAZ?=
 =?us-ascii?Q?jOFqQL3blad/JocEIBTdAWlNgk5VlYY1XhBDveLsAzIVxN4jiu1mexHBiIPT?=
 =?us-ascii?Q?WIPxVk+msHDpgxw43LP3X5S2u+uJbm70Q7MA0f6YdD4K235MFGOz/z68dTGf?=
 =?us-ascii?Q?EZFEZhRa0MhoRl8NllTk7yzg1YqqsfuYmjRc+T4RzmB9jfo8kDVsHs02bgWo?=
 =?us-ascii?Q?NjYaiC/gylrPH9p3mFaDrh+8gKNO4Rc0MM+aWthHvQEmtVXwct/+rCOYUyDa?=
 =?us-ascii?Q?xsvIlUP98kxm5rvYtvqYIe1bSlAEJZUrB3d5K5R4oL1MhFBEdgEWvd1EJu1i?=
 =?us-ascii?Q?lqkYcLl3MGxIaPsONwy4goK0AHYDCckr7BY+Hm83irk0jPYJJqsMe+MgfnaB?=
 =?us-ascii?Q?wWIik2R2UZDhsQLBAYH2kM2FMRVGiV9s64BJ9EchJdNlZYaNe3g+oOzZ0cGz?=
 =?us-ascii?Q?F1IDTxHrrY1+MOQ/zOvx+z8dEWjuimM2arDPX4x6ILY+PqmXrabBJMr+LKEZ?=
 =?us-ascii?Q?ZOdz3gHxlABaU2gbduNN2Si/IxOjmAEK9vdX7iYguzKB51ECwffSmDuiPGL2?=
 =?us-ascii?Q?0xfVXS4IGo64hNzEX2xBoOW+zCm8ntDo4GdtU4IvKwBTlCVTWCjNx7dJnflI?=
 =?us-ascii?Q?t6SsBUcM45y6whPRMPAShf+bTDnQc2GWjKI06cKq8vy3otbOmLvUKTvlLVlU?=
 =?us-ascii?Q?1Zd7cqoa0+P2Coh3xC3IO20MYHd8KHf5ng8BQnzMkav4UGr+eX58lqXOWQYq?=
 =?us-ascii?Q?ob9nC4sItAef/CtycZLB8JdSONZ/DOFesZxTnerM4nZEQPkte6W7BEXZX2z/?=
 =?us-ascii?Q?4GJzvV7j14+bSYyYL+RSDZFU88kUG7vsxkBJrPBQL4RsQPtkXIBN76Dtwr38?=
 =?us-ascii?Q?uPqu9v8l34rCxmqcIi3ZjiDJJRJ+pUDUzIa4V2WhINmAv86hQMBAQKi0dtfF?=
 =?us-ascii?Q?IBf4T0Z74f7uQejSOOnV/XYjTOcto+sme1LvuM/nQJV/H8oxsyT2ZIkU/S93?=
 =?us-ascii?Q?3OHTZeW8o3r3Hb+gfKjnhU4bEvzasudPOzCVQ0xDcUA+uBtSD3suBR3t2ykX?=
 =?us-ascii?Q?ybMsK0gRXL3YMrPfxSdAeuD5XZPIuHN92FJxn9zJJjiRv2Jc/svpUmn2BUuW?=
 =?us-ascii?Q?wIGQOMxjmeUOH/mpZbGOTzbaXmhrFWaV5VtmWpyZphtqEN3mSzQkvDiwzosa?=
 =?us-ascii?Q?iw7e1y1kvGgkNTDDeGiyj9x9FBtb0DI=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rYDXvYe3UZiApEa0S5sw/h7iHgA9Wa+qwqPFuYzupTxCE4IfrxmlLTZxaEdxEAfUX2Nqp/DTI3VpUr6uRz6T9Ps/QlQeWM8DnfpoaJJ/d1L4cFxOhEQeydjKl2KYNcrl4oP3UEg8+2gQiCHB7ZqqsnKhDe0514YfePG16bTElJvu49qci7SxvPUSCFxP96awHt3jMs0c8AIJ3wErkVkMLcpMYnohm514dNYDEuqLE8nd+C5Nm7k108Mu2gf2RnGaDJFTYvhWgF9uif6ywctSlS8xfmAV78c2XEnq5KVrpLrRWZsJBDoQjzeBgsYiJnaAdq/kt/kaqYR+/LXlcAzSMr+NIrx/oYT1sI52T7YrM2f812o8dIsCjSHl2o+qJsjSZO4zl3n9RrfKdK0OlMGAhnsUdhWiDD5tFuqfWFFfEyNFCJ2SDJLP4oXk3/1ZkuDZEPB7KG51X80B+fGEM9IlhFQ8gXxNiiQCMor+G9P+ELGo7hfjnkoIy7Sk/YewmK1DYbyG5wpkgq5QqCYjw/WeH//J+QdMB/m3dekDgM6XvvMm+lv1ZHAsUh62qpqxDjgJGw06/uRHKD695jvZIFwBm6tbNGfywx2nCM4tf1ombjo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6955fd5-b9e5-4e0e-b0a6-08de5ccfb1e7
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2026 11:40:24.7698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NhHzk2UhekRpG8GZLy3sCz9bg1rBSd1xofApxa5UF1eG5C4JmPGN6xo3dCoYZnQggRatKbZzPtCkiegv1/TtN5kT3UDkpBt29B2v6/h7t24=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4853
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-26_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 spamscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601260099
X-Proofpoint-ORIG-GUID: dN2msfpRvKtGSTpb0RHpJ6fNGGrV85hq
X-Proofpoint-GUID: dN2msfpRvKtGSTpb0RHpJ6fNGGrV85hq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI2MDEwMCBTYWx0ZWRfXy0Ijt1fP70oE
 QhMg1qGgJrFy15nSJaeCxSyhrpqdITa8u3ULaX9eDqb7oJqVFI0nHAU3k3Scv1FZoe1FNqUT0s9
 rXLEuJ2RLHQULEXIXnzL1vGQC3KYUe1fz64M5TtLCTHrtC7olQ1dOyOq0XMNgZcwkjZxbuFfSDS
 JaPQodhjeQxndTtodDT7zWHoKq+G2x48yFtr67NkiNBFQqADik8ypk2EkZRwWf0S53XCnkcr7po
 Vrs+wj4Ocou2dkqhzSChIbvmXWJ0fnl2yqN+ocq3lnohbFT3iZJfkRr49u1XUSlql6XZ5zG5Qhs
 PmZdHqBcwiPoNrCTRYIkQwpOu2l7WBUf/OldszvRPclafEC8/P2Cjljd7CEVG+lHFFixdmu3RAN
 1HDUwM32hFgs3fu4PPcSjGyA+0cYVe2LljKMgyHpotbKHUoDp9rN++lHC1m0qaG9ARZLRkYyMSj
 56/WG/Hu/6ER0P0G62ps/GDIyskhip+oJPAP6ZTo=
X-Authority-Analysis: v=2.4 cv=cPLtc1eN c=1 sm=1 tr=0 ts=697752ac b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8
 a=SRrdq9N9AAAA:8 a=Ikd4Dj_1AAAA:8 a=w9PpIFtyoLv_KdPcWbUA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:13644
X-Rspamd-Queue-Id: 218CF80005
X-Stat-Signature: f9a86pp6e5pgo7i63px4iqkiwu3p58xi
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769427629-535532
X-HE-Meta: U2FsdGVkX1+2PX4bPPURnctG6mvVZg8/pFEeeBFKcxf+EJWlQ1CnivKlRpizWFL8GIG9AYMHEUwyeMdaoIO8/+0rma5Lc/gw6gCRBweVpLHYj85jVwTWQBs0FjEmitGmpAhTdh3oGmNfmDtzlgGQxZGl28T8qT1DrOKDutEYzi6jAy21+nOvwJyF4L8htJ7e78tYcAzG3MHNdKW94Z7Ojs5VdOFLMM8J/fuUX8GqJ19Iru8LF7DQAtAdJ+MiXPdy7+w0A9TaCPdwVjw/zxP6dN9+rl3pezVIXrVUF1BNdQeLdfarCWFFv3IlM5VejxkvtcQi43T2RWImpPmcRZdrjKVoBCHLAw8eUulsICd0myp0sc1IpP9sTCiLAdBrKqJzJTO5o/sarJjKlaFMkLw7MCwvM0N4r3+nVZ+N6qExa7qKaUOtj7N/KwL0TVYK16x8PWbR3CrwCwrMp3p8maU7tKf21cfbBFFuTQtNGU85cc8VvBYBLJPggToWTwKa0942LKGfRvwe4x6TQliclSdXI6nVoIhn2dKloN+vLh0QiaFxvhPmEU1gpUthy/G+yp/3rBcUu7oh+umMjsTp19YJJk5Xu9AnTGMoU6k/i0Oliit7TxJIEwBKB0w8nF93ijSXeGdIi7YDhfI5KoLwQ6AR1ur3yFIdWb4efNKnorEWzPIFlNFReT2wEbl3gmhm56zNDypIBCxFg2OAAUHBdnWsWpUaGw76sHr4O4h2JUh9Ms+Y0Z6ruSV9QKj+2l8aAs2cdksQRe8wH7pEX8ku8pgjslswxHpIdny5GxD+7mKUY3eyCPj5Mb5jar1yNvCLvDD7A2KVY9OVD8CaE84JU3IMLjR8HEXBhYaNtvchZJNqw8Rx9xgIV4FowSVpyeAXpDSb9FRQiMuLwsQg+Zovr8Ex8MqOpcTA/DabCeHSwKN0wWCaWiJKtqmdi5f9NY9tnkmrOeWyXQKNgj0lVQfmO8o
 qaui0SAd
 AZXnR+EORdxFfQz6QGqwBEryxIQdq8pcJos8p8wdO8IvUSX0h9haggCpF8iMmlk7j/hEnMsHgf4tLZPcEhveQagiHFfISeb6jlH5ANi+imAAwc0FZa26jVSWpRaXwyMPlKZYWnXSTpiW/ur+wL7WVw4aYyyWZYGRWLVbAXxtYHOuPyyyriqJ8BqYysSLRRwoIz7e6fadbfy0IAxUNvjeLKVWBTN0qecmKdKoqhQc+Sq2rne439OOIV6DHR0Z9nygq7TkkPNkHUe8zC9H8mSUZzueag9/Rrz2op/ivH4H0ktvxmJQCL/Jbs7p+hb71yQE/1TuTNnKJVK7uDipWodbsVb/n7rXz5VUISW/OsQF+qZjW/snWAf5S/WsPjV1gDvvcNwVk5RzX59t+73Q66h5XrOYgXPpqkvqtZVBsE+1+f9jGJIrykPV6ylt0/PcEcuTKT79wjWDOfd5up/U8H0okt/SlLRVShB/K1a7QDp3hg1lMgticyJiTNcW0vh9sCer4gWQb6NHRw9SVu/gaqOhaWH/azMp0GdNfno15Q6uh9r+eIbg74sAn9Kdy7Yxsn2DnhRjgzcw/k14TlLEbjcAJ1bShNSTIZWnT86uWnAqy4lhh1cy+gvNCVfL1buh6uEjwwrRr5vGIWZyPNCCi9YhJeReg7Zozow+ALd3diLxQGcsB5kMcSo9+N9k59r/JHQx2gJdoBO9v6O38QvkjdsC97QaBOUuJJDKlSGMtRj2CysXj9VvlqdTD8dDGEbeItTEPwGMzrp3PnrqwICwNqMzuDMY80apRb7GQ1Zb5dmHHH1z47B3JYrtL7FAHM6fyEDQEOFuVg+dPlxdqF/Twhal8to7MFdS+pW6F9sh2jiM+y0AguqOkZjZBXN736Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew - when this goes into mm-new if there isn't a respin between, please
drop all tags except any obviously sent re: the fix-patch.

Thanks!

On Fri, Jan 23, 2026 at 01:07:16PM +0800, Lance Yang wrote:
>
>
> On 2026/1/23 03:28, Nico Pache wrote:
> > The khugepaged daemon and madvise_collapse have two different
> > implementations that do almost the same thing.
> >
> > Create collapse_single_pmd to increase code reuse and create an entry
> > point to these two users.
> >
> > Refactor madvise_collapse and collapse_scan_mm_slot to use the new
> > collapse_single_pmd function. This introduces a minor behavioral change
> > that is most likely an undiscovered bug. The current implementation of
> > khugepaged tests collapse_test_exit_or_disable before calling
> > collapse_pte_mapped_thp, but we weren't doing it in the madvise_collapse
> > case. By unifying these two callers madvise_collapse now also performs
> > this check. We also modify the return value to be SCAN_ANY_PROCESS which
> > properly indicates that this process is no longer valid to operate on.
> >
> > We also guard the khugepaged_pages_collapsed variable to ensure its only
> > incremented for khugepaged.
> >
> > Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> > Reviewed-by: Lance Yang <lance.yang@linux.dev>
> > Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > Acked-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: Nico Pache <npache@redhat.com>
> > ---
>
> I think this patch introduces some functional changes compared to previous
> version[1] ...
>
> Maybe we should drop the r-b tags and let folks take another look?

Yes thanks Lance, absolutely this should happen.

Especially on a small-iteration respin (I really wanted to get to v13 but the
rebase issue killed that).

I know it wasn't intentional, not suggesting that of course :) just obviously as
a process thing - it's _very_ important to make clear what you've changed and
what you haven't. For truly minor changes no need to drop the tags, but often my
workflow is:

- Check which patches I haven't reviewed yet.
- Go review those.

So I might well have missed that.

I often try to do a git range-diff, but in this case I probably wouldn't have on
basis of the v13 having merge conflicts.

But obviously given the above I went and fixed them up and applied v13 locally
so I could check everything :)

>
> There might be an issue with the vma access in madvise_collapse(). See
> below:
>
> [1]
> https://lore.kernel.org/linux-mm/20251201174627.23295-3-npache@redhat.com/
>
> >   mm/khugepaged.c | 106 +++++++++++++++++++++++++++---------------------
> >   1 file changed, 60 insertions(+), 46 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index fefcbdca4510..59e5a5588d85 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -2394,6 +2394,54 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm, unsigned long a
> >   	return result;
> >   }
> > +/*
> > + * Try to collapse a single PMD starting at a PMD aligned addr, and return
> > + * the results.
> > + */
> > +static enum scan_result collapse_single_pmd(unsigned long addr,
> > +		struct vm_area_struct *vma, bool *mmap_locked,
> > +		struct collapse_control *cc)
> > +{
> > +	struct mm_struct *mm = vma->vm_mm;
> > +	enum scan_result result;
> > +	struct file *file;
> > +	pgoff_t pgoff;
> > +
> > +	if (vma_is_anonymous(vma)) {
> > +		result = collapse_scan_pmd(mm, vma, addr, mmap_locked, cc);
> > +		goto end;
> > +	}
> > +
> > +	file = get_file(vma->vm_file);
> > +	pgoff = linear_page_index(vma, addr);
> > +
> > +	mmap_read_unlock(mm);
> > +	*mmap_locked = false;
> > +	result = collapse_scan_file(mm, addr, file, pgoff, cc);
> > +	fput(file);
> > +
> > +	if (result != SCAN_PTE_MAPPED_HUGEPAGE)
> > +		goto end;
> > +
> > +	mmap_read_lock(mm);
> > +	*mmap_locked = true;
> > +	if (collapse_test_exit_or_disable(mm)) {
> > +		mmap_read_unlock(mm);
> > +		*mmap_locked = false;
> > +		return SCAN_ANY_PROCESS;
> > +	}
> > +	result = try_collapse_pte_mapped_thp(mm, addr, !cc->is_khugepaged);
> > +	if (result == SCAN_PMD_MAPPED)
> > +		result = SCAN_SUCCEED;
> > +	mmap_read_unlock(mm);
> > +	*mmap_locked = false;
> > +
> > +end:
> > +	if (cc->is_khugepaged && result == SCAN_SUCCEED)
> > +		++khugepaged_pages_collapsed;
> > +	return result;
> > +}
> > +
> >   static unsigned int collapse_scan_mm_slot(unsigned int pages, enum scan_result *result,
> >   					    struct collapse_control *cc)
> >   	__releases(&khugepaged_mm_lock)
> > @@ -2466,34 +2514,9 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, enum scan_result *
> >   			VM_BUG_ON(khugepaged_scan.address < hstart ||
> >   				  khugepaged_scan.address + HPAGE_PMD_SIZE >
> >   				  hend);
> > -			if (!vma_is_anonymous(vma)) {
> > -				struct file *file = get_file(vma->vm_file);
> > -				pgoff_t pgoff = linear_page_index(vma,
> > -						khugepaged_scan.address);
> > -
> > -				mmap_read_unlock(mm);
> > -				mmap_locked = false;
> > -				*result = collapse_scan_file(mm,
> > -					khugepaged_scan.address, file, pgoff, cc);
> > -				fput(file);
> > -				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
> > -					mmap_read_lock(mm);
> > -					if (collapse_test_exit_or_disable(mm))
> > -						goto breakouterloop;
> > -					*result = try_collapse_pte_mapped_thp(mm,
> > -						khugepaged_scan.address, false);
> > -					if (*result == SCAN_PMD_MAPPED)
> > -						*result = SCAN_SUCCEED;
> > -					mmap_read_unlock(mm);
> > -				}
> > -			} else {
> > -				*result = collapse_scan_pmd(mm, vma,
> > -					khugepaged_scan.address, &mmap_locked, cc);
> > -			}
> > -
> > -			if (*result == SCAN_SUCCEED)
> > -				++khugepaged_pages_collapsed;
> > +			*result = collapse_single_pmd(khugepaged_scan.address,
> > +						      vma, &mmap_locked, cc);
> >   			/* move to next address */
> >   			khugepaged_scan.address += HPAGE_PMD_SIZE;
> >   			progress += HPAGE_PMD_NR;
> > @@ -2799,6 +2822,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
> >   			cond_resched();
> >   			mmap_read_lock(mm);
> >   			mmap_locked = true;
> > +			*lock_dropped = true;
> >   			result = hugepage_vma_revalidate(mm, addr, false, &vma,
> >   							 cc);
> >   			if (result  != SCAN_SUCCEED) {
> > @@ -2809,17 +2833,17 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
> >   			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
> >   		}
> >   		mmap_assert_locked(mm);
> > -		if (!vma_is_anonymous(vma)) {
> > -			struct file *file = get_file(vma->vm_file);
> > -			pgoff_t pgoff = linear_page_index(vma, addr);
> > -			mmap_read_unlock(mm);
> > -			mmap_locked = false;
> > +		result = collapse_single_pmd(addr, vma, &mmap_locked, cc);
> > +
> > +		if (!mmap_locked)
> >   			*lock_dropped = true;
> > -			result = collapse_scan_file(mm, addr, file, pgoff, cc);
> > -			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
> > -			    mapping_can_writeback(file->f_mapping)) {
> > +		if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb) {
> > +			struct file *file = get_file(vma->vm_file);
> > +			pgoff_t pgoff = linear_page_index(vma, addr);
>
>
> After collapse_single_pmd() returns, mmap_lock might have been released.
> Between
> that unlock and here, another thread could unmap/remap the VMA, making the
> vma
> pointer stale when we access vma->vm_file?

Yeah, yikes.

The locking logic around this code is horrifying... but that's one for future
series I guess.

>
> Would it be safer to get the file reference before calling
> collapse_single_pmd()?
> Or we need to revalidate the VMA after getting the lock back?

Also obviously the pgoff.

I know Nico suggested a patch in a response, will check.

Cheers, Lorenzo

