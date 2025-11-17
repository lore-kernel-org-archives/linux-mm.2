Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87D78CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 11:35:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7A346B0007; Mon, 17 Nov 2025 06:35:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2A6B6B0008; Mon, 17 Nov 2025 06:35:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA3DC6B000A; Mon, 17 Nov 2025 06:35:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC7D86B0007
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 06:35:00 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 654FFC0C8F
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:35:00 +0000 (UTC)
X-FDA: 84119892360.27.7A1854D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1E9A2C0004
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:34:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=pAaBw28h;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="cHt/FxsI";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763379297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ukmvM8X8XhNl3ccyfjWtnztQat7KhSHLeq2Nbe8MjkM=;
	b=Ydf9X87NIAJNlSrD3aU3PcAN1hJWhgIORA2YzABIvNNUnUNWsBbPJG8CUlfMBSjetg5/EB
	GGtLrTURmocanc+nRuVuOflHwrVKEExmHQZxB62x+sWsar2AWnAgMbhEKmIWS3WL1qM89s
	oO0j02fg0bG3A5aenz2EkF1UWQzf8U8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763379297; a=rsa-sha256;
	cv=pass;
	b=w4B5Woncz8taut+I+1DFpvzpVPpPjo/Y6kkqA+Dz+QTb+gb1DZb3qUFRpsqJysGhCRNIdI
	V01M/OQPTv3c6z7BF5BrS3Ck/LxKyaD0V3nH04r4ELbPWqv5eOE3O9nENwvpJZSh4e3kPx
	wb+gIAfj7GL/SXvp+polG5D5hNMDcKQ=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=pAaBw28h;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="cHt/FxsI";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AHBNWLk022588;
	Mon, 17 Nov 2025 11:34:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ukmvM8X8XhNl3ccyfj
	WtnztQat7KhSHLeq2Nbe8MjkM=; b=pAaBw28h5X7G1OR/Q3sfyLUYP+guKaEQCb
	DKjmTzJkAs2OzELCTxUePLlvKh3WcXYLnFIVSeMWKAH+MS7FtrpR0GM/nHongK20
	sxfGpg9VcvgBSpoFQLyeMoFOZkYkXfqnjolUPit4af+s3LZ+CGkCslzpkbFxuJ5g
	HE0gXIth6icemjq1tARQDNrdt7vDp/v+EZGAoaVpHuJEIknvA56qw1HHBd8tCnlo
	xFPs140E9THkVrvUNzckUARy0M86ZH6ZfIjRCenuUWddIeCxXYXXbjdmo5AwhZpP
	56KVvuaSLYjTepfUXBf/oJJFV3MfSoEbzOv/6U2Uj8/i1k49/27g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbbabn0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Nov 2025 11:34:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AH9Z60e002526;
	Mon, 17 Nov 2025 11:34:49 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010020.outbound.protection.outlook.com [52.101.61.20])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefy7jncs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Nov 2025 11:34:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gwm7CFrvIZN/QmBRnnw0//uPRsWnyPrqFuAmKUP9FogKkpvF6/jm/leBRUGEDsw2VNGiBGPIAlB98ES5+gxF6aHOp71ImYOz4FjqlrtOctTrvPst8Mve8E/Opi/Bm9XdR9GXjoGllrxkG8DBQLuOdn/mS+BiRlhwV4olrH8KcxPlJjRCOO824f7kyGFl8RJDcB6XSXmJAY+myL4m5afE/H4Ho0yOeNdX6QWESoEhHFntdZ5RrMXPQFTuNS3ZBfNdirgEnbxW58SX3RDDZwQcFIafvRimC2FRpDFKpLKYKpX4Vcq2bnJc7GH7Xt5NtICegxhI1xmVDIeyC+AD2mxiVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ukmvM8X8XhNl3ccyfjWtnztQat7KhSHLeq2Nbe8MjkM=;
 b=ZOfOyN0hPqpGwksu3fEe2OKOLE8a5KFwKuLTo2Qy7e/Kz85jTrRsOGuJWmEWuDTRs4w3zwxTLtIzzDArTPjOEMXLLpfF9qZ8lPFy8Uko0sx7dosutxYbiE5eV7pRnK7OnK1PGOXpQpZcXXgx4x5Tj6anqzNixn6IrQ8qbWmu8+Dh2R6Vvfp/3c/EeFnSHvVqnbMiQwuawAIaZCEuZuhbkIPBWeCfyipUkcCuyZt5jLYSjE3KikOQSAKs4kP4RqMtDutdLJx5aFPAhBoy/8Kc8qlrytpTD0mrgOe0Eo+UeJImpePL9QEUnBS4lkexbah+9fIEqVbxmAZR5mhfeZSx1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ukmvM8X8XhNl3ccyfjWtnztQat7KhSHLeq2Nbe8MjkM=;
 b=cHt/FxsI+QTtpSQ5GAO5GI3zFEKXONMUyd4KTbujE69G53SSg2rRNtqlCdrIyurPsYboN1MU+QXhCxsV/pfYK07fatn5H0sH+kMUcoRSEeXvrYbdXXRa59k3NTafZ07ypygItPFHJtgumAt8iglHf1zVyI6gVj0B27gWb/RnuXI=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM6PR10MB4154.namprd10.prod.outlook.com (2603:10b6:5:21f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.21; Mon, 17 Nov
 2025 11:34:47 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9320.021; Mon, 17 Nov 2025
 11:34:47 +0000
Date: Mon, 17 Nov 2025 11:34:36 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: propagate VM_SOFTDIRTY on merge
Message-ID: <94eb837b-26c7-4f44-b261-7703ab776099@lucifer.local>
References: <cover.1763142412.git.lorenzo.stoakes@oracle.com>
 <addc338c8b33aea3c31202180448ea32ef37956b.1763142412.git.lorenzo.stoakes@oracle.com>
 <f016fc4a-8b95-4064-8808-5ce61bf5b7ec@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f016fc4a-8b95-4064-8808-5ce61bf5b7ec@arm.com>
X-ClientProxiedBy: LO4P123CA0579.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:276::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM6PR10MB4154:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b985a42-50b3-4b4c-f17d-08de25cd4fbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?x09vkYw7WWqJP3mBZHSUVCKKvBhzpjft34xUvJWhGll9F96OCSWtY2C2IiI/?=
 =?us-ascii?Q?Q+3iQJF0MxIZu2FCYKrpbaCOgpznK/ptDvqpslF0MGW8Yh1J0FfSUl0C8OIa?=
 =?us-ascii?Q?fn35O0fPWEJTvoiKvTtGsxBBIfxRxQYcbTc47hJyLYLU1m1Ev/8x27S5zobA?=
 =?us-ascii?Q?Julwi2LwC14Ztvf9ysSXWdvCIXxg6tHzRklMo685Ltwv1C3VtyjawL/3QNMd?=
 =?us-ascii?Q?S7uzkNmUI9d/smlHcXL7B/atNnWUG1Wgsx7OWijhc3WCi3hi0A4sEa4ZpVsO?=
 =?us-ascii?Q?HScRFoTRjUMsiho78bnKQEXNKLGjKKrWy6kmGJrMc2Gy7DHkWrvDHuPPmOS6?=
 =?us-ascii?Q?kT2oVsfn+hh1PghwN2k2RpeQZFtBozjt48UYb0v7XQ7yT9TP3mQFbXTqhz/S?=
 =?us-ascii?Q?eaQ4S/aEFDUVeBs4nnvlVqtXPSYzhDcXDEYQoA5PR1T9i6pNER8pygaBVkjr?=
 =?us-ascii?Q?kVV9HQc9V4bseCnTwbxlr5yFYcENreZs6o/cLiG1nSxNC5GugFlCxetEC0cN?=
 =?us-ascii?Q?Yo1a0E33Rw+LlOt60Yyv8iaSs7EQGx3M8btWEfIpGrAYvbKWUmazZRcMZL4v?=
 =?us-ascii?Q?eiJFQytzPzPxqG4p29MsH7IVJjHcPZBJbJDCXQd0VG7ANfgKOeS9If0bsu7P?=
 =?us-ascii?Q?x1smBopOPDlrXYCmufFUhUIXMsp46ufV3bP+5Y/xm5xJ68wMf0OsgBmJWIBl?=
 =?us-ascii?Q?y8jxEdoW+mMTPX2rs4O4G3z6FkpJzbEJ83Bpv+kN3bBxGG5NwAp62hqATJqe?=
 =?us-ascii?Q?f9dG6Mj6yt/WiNdV0xweGI+b8NzoH/RAOx8su3sUDizf8qcRJyqygXcqyyO8?=
 =?us-ascii?Q?q7oYAKKLiSkJ5vQp40qJ0Kw0MFF+PZy/9XjO5NjwPQt7Mh4sc7Ub/gvxVqqV?=
 =?us-ascii?Q?J0I4WHocx/mLWUK7EN/LwLN+DR9qTUqgtRsoecQ99woS/rem/pdFW7mECaKL?=
 =?us-ascii?Q?drOjYOOCtnfnR27voU4sNgefPJiJGXxUJTCdTS6wU6rHz3mXWr6Qqs78MKEB?=
 =?us-ascii?Q?9qgpE4wrGxIWOS4wz/ITdwWphjdJoDiOVh+VLp6bsqh3JJ8jA5cG9m/EMk7V?=
 =?us-ascii?Q?ocGx+yDMQ41fCHlxFY3CCQCtmUysAEKTHS2Vkp8ilc69hV0UhzZ1/gWGD+MF?=
 =?us-ascii?Q?nIQKiUSavfCqvxmBiUmeAHOOZ4ZJ2yx9p+5CavuKb99bsC1cnSVTT1c8/J2w?=
 =?us-ascii?Q?95cP9KPN331vc73r6pcVumrdQkBmTU5pkqjOu+4VWWBytdrZXbyxdX6c2iUa?=
 =?us-ascii?Q?MBNnyHSsaKbQST6GJd+FYOSz/IXn+rds36TwvTXmMNx2YqeKdXY4GnLP3gqN?=
 =?us-ascii?Q?MQB6kYt2JfbvyHnYEpDABmQJPZ1U/qbGSYtzGSeuBWXdmnxIxQjRDxtpZZC/?=
 =?us-ascii?Q?nAMvZjMZDvCdLVIq3A9qV1h1Vlru88qxtOQMwxOHyZq1LX2kYwlAWpYJeuIs?=
 =?us-ascii?Q?caEPp1ZVH+Pdxgd6u+Teaz+dIyeX4CA1?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9UBC2y7Hfkb3tKdBT0QfMV1RA0/yJF45+4SaN8p6QCZAU4goN1SL1XuNctVe?=
 =?us-ascii?Q?+n2J8fDpOlir4tBrJYXh41qEPuR3FeeobFrzCKGhVqaGwr28Jb+5hsBhWdFI?=
 =?us-ascii?Q?RSwWi/BetFEZidf58SoVqX/9XRBgDTbN6TmjqiToseBN4GjIy7+Zroafr2i6?=
 =?us-ascii?Q?QXKOhHN9wQfY//oz0cVdtG0PafTXH/LA3CK8Yv+VD9dVlL3pJxmPh8fuykOv?=
 =?us-ascii?Q?yVZnejVQ7RaRVytVokr/A1uQQ/tOTvnDoa4sc/cDLjFFfHdV8/0ZfPUJo/UP?=
 =?us-ascii?Q?EatWMR9xVeX0CLcliBjVbqLlIjwRlv5o7i1lB6zqYAvGOMqp/yAxwNWb5RhF?=
 =?us-ascii?Q?hRt6QWYxJwFv/JmxzEmHQ3UrobXDhT6PIZjtEWEWLGmuyB0nKcmu8NFuHYk3?=
 =?us-ascii?Q?kCZsmGBLx6MV+6zsKHp3x+g+inznP1yv7U855rS0KbBDIQ++rloO5LjW0l9j?=
 =?us-ascii?Q?oswiYEPGj3Yc8C6fcQGIZVBwLTIUsgMKck6JKsVVuYd2xvfIgnCrJiYNmGwx?=
 =?us-ascii?Q?oltK5WOuab+zFwsxLt3TGN7/zfYCixDh4FIJUDsE1A8fCfqCk+X665PsRCm5?=
 =?us-ascii?Q?MR6Rf6hPd7bWdbR7z6oI7WhAm3JE1U1UHHWdOxYDNU9tzoe6Nol6vlViF40V?=
 =?us-ascii?Q?pzjFFr/v6w/NvwHP2OBOGFN5d/AcZ4qaumhjrN6GC2CEcdZD1FCvuz4GI0fS?=
 =?us-ascii?Q?TU79c6HHHEa5b6mqAAvHZR4n328S7eP44ZWovi75E8ivMgdXqs4yrWbcLaqx?=
 =?us-ascii?Q?hAtJ+zzhOduF+6p9hcDilPgQv3csX9erQcsZTvBhe4NZxgRxABrny/NeK3fl?=
 =?us-ascii?Q?Jh8AQOElvmdvIMhW8tQADP+cPUsrDcF14xuqB2eoK0JF8NBuqspe5PWukASR?=
 =?us-ascii?Q?9Oe5VyvaPZJv/Sj77Ny4jYD0GhOjTK+CHwypjrhKUpQhdfcvlqyxmk3YIKwF?=
 =?us-ascii?Q?Gzio3EjV6A0y06pegnM8aWBNtgZN1lGXV9YndTlMCk2lKLG9ZgLvMOK5S12E?=
 =?us-ascii?Q?Snd7RMdq2GyXoiW3obaiJr5vcHB5D2iCCXY2aHX25CLwTvBZvEpXYVjKqztK?=
 =?us-ascii?Q?Brm/8QQ5rG7wb/mwJOovMpnmp+Wby74AHizpO/Tsa6HrcUSCtEQMOXlxbyZC?=
 =?us-ascii?Q?EVH8C3LGAfQg9rbV4ShhOXCJtaDZoS8CVP0vXQoZNOHIy8GfjQyPWZXHapiu?=
 =?us-ascii?Q?t3SqwRa0to6EZ2zGR1Ihl8O+ZVoh+V31EcyIvpZbeDobbtHTUT7eFzGD3fy0?=
 =?us-ascii?Q?2dJoRDxXSiVcfqb6BzUvI/FE2ylK97cv/xpFjfrfFYskg0gqyOPJRP36X/94?=
 =?us-ascii?Q?utQrpRqxEClNh1Qt5ajYY4W7fz6Aiq80B8Oi0M3XFyJOVKzIpN/If1fS0oKT?=
 =?us-ascii?Q?vI01BDBNx0nvix6ralLpERaJQiRMXYSf/Q7nUfQkmozeD4ZMy+zFWmxmpVDN?=
 =?us-ascii?Q?6pTAR9N8ohsribYGf43RiEgWFP5zeOJoWvKcTIHSstVjxFaXfXdbiACLsKX7?=
 =?us-ascii?Q?qmQIkhYhEYWmeBaQjdd+2xIpkxajEKBUbcuC/2DcOKRYdWdhAmznj933n2e2?=
 =?us-ascii?Q?q3rqcdeoKVGRZtXiFyei2vESIBvWvRCBfYHpYWwrYwq1hEdMoW1UohxJ/1yM?=
 =?us-ascii?Q?wg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hrAw7TnW/TjGOwyzs/GVuUH9F0eWqp7vlcrgApvhgBIzYxevSoWJOSvG5QJzo8hvYBgC27jJ/VJTGz+IOmGo7ZULnUQgJ3O/rBj61GnqX3CDyUsl8Gbwgv9VrPMYLNl9cLJJdY48KhekIEX9Cw4NAxjnh44atktJesbAKeMq8jcDupknoE9Z0kAODNi2sPkc3BLCGJD6Xh0SljcwfpKqC/8uw/INE7RR2CITXdQn+iEFxu7IAP4xHlmQbb+ITrMDyq0arsx7DX4X8tutoM4r3ZJDnMvdGXkWanCt+PXxryiDYqGi12Nbrqk91w56mytzG6EtB/cBGKoryaJVvZUBl2NOKx9K1kBeglUWmcUQDj2mdelnz6MW65kq4q1Ljud3JqinDMeJbieFD8n+wDo5LO3dDi57HcdDvEMX969QvdTarEIikY5AN44oAuXuT4qGw+/5hW/p5DuY+oY4Eds1p3FN2ssFpb2J5DAFWTk6/odJBqwdrgQY5Ghz+Ql3ITF4DmvEEZuqqbPb2/VQzLli/q+qaFEEbGn35TiMTruW/C7VQlW1cKFdEYLClTfJLf2f29Sg6tdANcnhyY+oQXSNZgUWucFM3yIzwt/GbCJ1b2U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b985a42-50b3-4b4c-f17d-08de25cd4fbc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 11:34:47.1167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zqlQcqexSYuz6/xMzTUUJK+Is9jp193lO05mfH/PFpY5mckuhnLiufbbyv3OCO/kngA8QbOYTgZhIma8MQ88403j/OjYN0hmqy19CzbBSzA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4154
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-17_02,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511170097
X-Authority-Analysis: v=2.4 cv=BoqQAIX5 c=1 sm=1 tr=0 ts=691b085a b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=Ha4xNe2EoM_l1MVAvkwA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: HDURKNgpjDuxeYotiT6FDh3fJqEc_AcK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX2MYpVTOYRWBv
 09uVe1ayPMSLpOuehnsj9IFjV7diRIS2BDQGOkD1/vjPYuQzd4EGpgdtfyRzZDtzfQBfyrbzvDu
 CKiii7r0Q1LCnvhB4gE62KlFmBxMbsH+Z1wGAeowxw8Z/kDYrcvh1zWAuBgfG1iGDF7PhecERKl
 Qwr83NmChpwut8trKvIzEZuacM5f6X6LtHbs731ceLV3Qy4DFMhOvsCAK6tpnj8GmDSZR+/nQwH
 vhUo1ct4fdYj/WeZMPoVCk68sLsGmrlywR0j9cpSQB0xlUxalfwKwZPMVK5MJvHuMmSuhDntQ06
 SUGjhAjaPM6nzFjTbiMR2olKfmgSzGZYleAIGcYN0ppKt0Xc30fcJAktj6TakaUkCstjcJOqEEU
 8Gv8DAx659MqwcSQnT3emMbGzsMeXw==
X-Proofpoint-GUID: HDURKNgpjDuxeYotiT6FDh3fJqEc_AcK
X-Stat-Signature: itz3mwrhcw33t4t1u4u74xafcij9b65z
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E9A2C0004
X-Rspamd-Server: rspam10
X-HE-Tag: 1763379296-230513
X-HE-Meta: U2FsdGVkX1+yC4gqjri6f0WuEnVVHyCVWdpXmuyU0o/lVoelaco4kzwOudB+IatG3/olko/DrMrfCsubB0yfGsJySqmfpuCRrDX4bRd3IZMGlJruySf2cETGMd5Lcqnvgm9KwyD9FD+JU5QJhjU+WAJuZl1V4Dz2JqDVKySKD3OMri0lsDnUSO4fOViQpuVhxrpVEQs+F1wZc3W3zWNLNbMrj7l6mZk1bcyh1MRbyIggcds9rnfNMPGntDwaSidHLtO55NZMDiY1fUcwXnwXoN4PupggmFx4L+TG6ogsadicSczExLOjxlbMYpoxignX9Xt0wklI2GLtlHRGuZSpM9vEIQui1/dSze9oY8n1t1fGgu4Ew81UL12+Fc9cjdmyoU1kCIsQSMl3SVG4jG+YJLY/9BXtF1GdVylQAgipR/PZYlgIBwmHADbGi0/Y5QrvUttcxpvvF1Bu1OB+8KFLBIm0rvk4r9uuz652j9RnBaOZt5VK2EvhNtpfQyvSUK2rehelEbRaZJHhy3uFPJY2cyTjX9Kh1m/D5zU2GB4hlbICsYCIkudQ2Ukp8+oiY5Qv4htBNpX2AJ4C08oEAu+NV3KqY3C4gkBndNszIr6WACbyyQaYE4hDgGgKuIZVypj+RPmOahCeBZQJ86gk4XkF9mbAaMtEjrLNu9gIfyRIU3ftieUjIJc5kIHcmpC+a4FixVNsA4udRQPH5f4AT3Yox2BJqXQ2yL+xOolrKDpJXcAC8ZDqdWAsrUx0HRHODPZz2RcxJlFX/W5vLeEFHcArHNBYHtA6XptpMnQ0FLG2VKM+FogU4nF9UHsrkwvFY3hXOMxiRztt6aQ5f6GI+Ra3SBRHmtw+EuSjJEpP/E3JekjN78yVfdgcMSiQO2BI9tyCx2v1kZcpVmY8aHAgqJGI/A19qGJOwhTGdicc9+96gFJ/ZASgzND9JKR+k0P8zW0ka8vpLVWNj5/CTbLQ0Ej
 qgNBy/b1
 drDXOWw3OALF6bwtZcfMaYfBt8kQpC6Cx+fKq+WKyylgmDMFgbQtWF6vsGmUDdfKNkrgRg/MOoA0iE5SJdr2vz5nE+tVTZpXMs054Xh9jLcTQAmAhXRJbmLJvONXgK6YmMqcSdxdYysQHPuiiF7anzIjDWd9q3b5r7MGCnD7eQx1fNRtqMBohKwqR4/H/bXddmCYcZAALOjxjQ/W7DEkvdSN9ksOOcA5E7/ewzMW3ot9HhPpxFhOVWLgCkZ1rOSxVZJbe9xG/wBIWsByEFC1UpBvYmot7XSNuc1ipwLE3zsCcyz9NwAJS70rvjkpLgXhbPOlBx9zO8aRkb4IehLvj7N4bn8EcSOObMekX+VDBil9jPco1lc+bMR88fE5m3Wu5p7hjsh8XSDySIdTWsLwtZhba0juTvWzFD9LM6gi7AWWaVHpQ4JqX84D3lsdvsnvxxHHaHgKpPdsfr3UZH9oH46u0LQQu1D/LW3bXoyNa3vsQhShwGdEfvBfLvamOTzXaPKtNexnWkhV75incL1RJvLEzCbO28MPEomfmrQ6XQYgoWLemgZM0vUV+tTIb539SLtGU+xBMjwlhQvNkAFZvN2SCadw0POG5U08IENB37NHPbKxGdohTK0G9OyWsVCjPj7/Ty0J8/ZUExefbNHpjGObbsOXxTv5k/u/SxmWXB2XH9Qhuz4A4YFhz8G6hQeJ7lfOk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 10:09:37AM +0530, Anshuman Khandual wrote:
>
>
> On 14/11/25 11:23 PM, Lorenzo Stoakes wrote:
> > Currently we set VM_SOFTDIRTY when a new mapping is set up (whether by
> > establishing a new VMA, or via merge) as implemented in __mmap_complete()
> > and do_brk_flags().
> >
> > However, when performing a merge of existing mappings such as when
> > performing mprotect(), we may lose the VM_SOFTDIRTY flag.
> >
> > This is because currently we simply ignore VM_SOFTDIRTY for the purposes of
> > merge, so one VMA may possess the flag and another not, and whichever
> > happens to be the target VMA will be the one upon which the merge is
> > performed which may or may not have VM_SOFTDIRTY set.
> >
> > Now we have the concept of 'sticky' VMA flags, let's make VM_SOFTDIRTY one
> > which solves this issue.
> >
> > Additionally update VMA userland tests to propagate changes.
> >
> > Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > ---
> >  include/linux/mm.h               | 23 +++++++++++------------
> >  tools/testing/vma/vma_internal.h | 23 +++++++++++------------
> >  2 files changed, 22 insertions(+), 24 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 43eec43da66a..fd9eeff07eb5 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -532,29 +532,28 @@ extern unsigned int kobjsize(const void *objp);
> >   * possesses it but the other does not, the merged VMA should nonetheless have
> >   * applied to it:
> >   *
> > + *   VM_SOFTDIRTY - if a VMA is marked soft-dirty, that is has not had its
> > + *                  references cleared via /proc/$pid/clear_refs, any merged VMA
> > + *                  should be considered soft-dirty also as it operates at a VMA
> > + *                  granularity.
> > + *
> >   * VM_MAYBE_GUARD - If a VMA may have guard regions in place it implies that
> >   *                  mapped page tables may contain metadata not described by the
> >   *                  VMA and thus any merged VMA may also contain this metadata,
> >   *                  and thus we must make this flag sticky.
> >   */
> > -#define VM_STICKY VM_MAYBE_GUARD
> > +#define VM_STICKY (VM_SOFTDIRTY | VM_MAYBE_GUARD)
> >
> >  /*
> >   * VMA flags we ignore for the purposes of merge, i.e. one VMA possessing one
> >   * of these flags and the other not does not preclude a merge.
> >   *
> > - * VM_SOFTDIRTY - Should not prevent from VMA merging, if we match the flags but
> > - *                dirty bit -- the caller should mark merged VMA as dirty. If
> > - *                dirty bit won't be excluded from comparison, we increase
> > - *                pressure on the memory system forcing the kernel to generate
> > - *                new VMAs when old one could be extended instead.
> > - *
> > - *    VM_STICKY - If one VMA has flags which most be 'sticky', that is ones
> > - *                which should propagate to all VMAs, but the other does not,
> > - *                the merge should still proceed with the merge logic applying
> > - *                sticky flags to the final VMA.
> > + * VM_STICKY - If one VMA has flags which most be 'sticky', that is ones
> > + *             which should propagate to all VMAs, but the other does not,
> > + *             the merge should still proceed with the merge logic applying
> > + *             sticky flags to the final VMA.
> >   */
> > -#define VM_IGNORE_MERGE (VM_SOFTDIRTY | VM_STICKY)
> > +#define VM_IGNORE_MERGE VM_STICKY
>
> Logically VM_STICKY should be the only flag qualifying for VM_IGNORE_MERGE. In that
> case should not VM_IGNORE_MERGE flag be dropped all together ?

I intentionally kept it to be explicit. This is self-documenting as-is.

