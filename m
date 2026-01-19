Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A0E3CCF2E5
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 10:54:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FAB16B0176; Mon, 19 Jan 2026 05:54:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D29D6B0178; Mon, 19 Jan 2026 05:54:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 756036B0179; Mon, 19 Jan 2026 05:54:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 61D146B0176
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 05:54:31 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E6191C25B8
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:54:30 +0000 (UTC)
X-FDA: 84348404700.14.DBBEA1E
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 73D061C0009
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:54:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=N5TJz6Nh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=vc40Rw80;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768820067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mPwg4XI6mfU06GoIinWVoSSBEXjlCU4eF/dPq/K76ss=;
	b=KmSi82YIBF3scFLOtagi1WDPElSPE7Blk9mxzRQi43JHtfsbvvPrxzpDMtL7L6eXmuKonH
	CwriCB/UcFTQ8s+hhfiIudO0FBOkWW5/GAx3epweixG6bDhT9ERAI/NeVHz7MVIIyuM2dW
	zknkHFBbMCvQmVjw10K3vYKbZsRH6U0=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=N5TJz6Nh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=vc40Rw80;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768820067; a=rsa-sha256;
	cv=pass;
	b=peR8Zl2Gr6PrARm/YfdHYrIjeChPbcQxkj77/KvN/VvCp2j/JQLEPduyVlAzr7mSrRgM7Z
	z0pJphQk8+5vGnqwQwDMiLq2SCq7TLtP/VSzTTkMVv1VCUJo4uICUsxAssd3qR9SXLfJgC
	kAjW6UYwR6pavGnacep0X0+UpBuYq5k=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60IN4I6P106065;
	Mon, 19 Jan 2026 10:54:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=mPwg4XI6mfU06GoIin
	WVoSSBEXjlCU4eF/dPq/K76ss=; b=N5TJz6Nh6euKdTVtam2IRXMD/7keZ/HhRX
	xN6zXL0SM+7S+To5X7zvLtPTk5IDkZ1Pbz7n/5pmjKUuZECxF9V/DUjxq7eaUyzR
	eMsJ+NrkAzpSpMkKa1Nex8z/Yx7XxqyN6cW4lBh83QCTsnAZzqsHMxcn/RM85u1X
	z+lM2gCJRLD8pHriOlCpTo4ljd0FJOAxjG42G0UXY1+NMiFtlDU5XwBGe7oTGhBG
	02QhuYJkowtQV9Sagfdv4v8zAfDnJFRhiLsZ2qnNZP4GUNGmHiDsO0d+vx6kKMse
	9MZ4k6FZLCGIK4YH1vnY8T0/CsOiF/As/y7dRNkMfJ118+pDBLFA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br1b8a426-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Jan 2026 10:54:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60JAW9dM022480;
	Mon, 19 Jan 2026 10:54:02 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012052.outbound.protection.outlook.com [40.107.200.52])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vc01db-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Jan 2026 10:54:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dsDmBU80bIClB3ON7UK/IpXdQ9JVZgMPtps8G91ZoMov8t/kR8Jjh9lyjvwRO1YmVj2Gg2z72Y8q7v+OoOt8mXACYFYILlbybsr0Nv4yls2NKVshI+Q72XuUYaEJppyScBvZPP0/MLwkj0WgVc5/JwS/ASv6em28zaHROH0BX6S4ja5Czzu45xe7mV432CoST3QNUVUIW/ZFSrq/sdgMAKudGBNQsRecTnfRW3kTgMyvFYt4F0rW00a0ByK3e1JEOD15WfFojIsIquvccEt+EQg3HgLw//9xRMTFpTHOp0CFsL2HM9Bf7OQWmFtcIojZbWe60/KJSsXxNC+9GSsIDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mPwg4XI6mfU06GoIinWVoSSBEXjlCU4eF/dPq/K76ss=;
 b=Q++vEbjQtju53rlWmpxS7YrZXfWKuucBR+TCTyChF3n0zq2w+t9YWPsEKwqydNoT9tYvZsZZ1Rnc3z874dqsjZpjwObwGKw6LWYzG4fKSiAgynzJ1qwi35NEz08SgCCzoHSMnrQYrHOP8VQa56qPgmDJW4kytB3ED65/PxUcYOg/kUGASbk5UvCQDiGmWHjREg1xXk+YU7V9b7vLDQqQ898/vwuIg4oRYoMHro6zNEnT0MLq921fMDvHZTj49A/J9H1kp4kzk6iBWbqTNa9yif3bXRA8zyR0fxBGMFzqK/X52udSzYbBmbtxqz1MqUTUyh7qZLp8IlSUkjxS+aI4gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mPwg4XI6mfU06GoIinWVoSSBEXjlCU4eF/dPq/K76ss=;
 b=vc40Rw80A6/1nBjMNHsr9ZhDJpMbIR1BOvL1oJkxZAhG/gmZE/XMPgRFWkbl7199CGOM/tcyXPW+NR5lN/3/Gwu1IhODwnhLDgZ7O3TqH39xyAtWYUo5XrVW4WuZY/HK82KfLFU3M1WT9wcXtrJfa9bdvcHPDrLknLgApip/Fp4=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by SA1PR10MB6614.namprd10.prod.outlook.com (2603:10b6:806:2b9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.11; Mon, 19 Jan
 2026 10:53:59 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Mon, 19 Jan 2026
 10:53:58 +0000
Date: Mon, 19 Jan 2026 10:54:01 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: "Garg, Shivank" <shivankg@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH V5 0/2] mm/khugepaged: fix dirty page handling for
 MADV_COLLAPSE
Message-ID: <eee7244e-af6a-4d4b-9514-77ee766641e1@lucifer.local>
References: <20260118190939.8986-2-shivankg@amd.com>
 <20260118122229.dcdda884bbb19a9c30ec6f1e@linux-foundation.org>
 <12b6747e-b844-4931-9918-fd095a6d772b@amd.com>
 <c63df10d-c61c-4337-9c88-ed1ce81204a1@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c63df10d-c61c-4337-9c88-ed1ce81204a1@kernel.org>
X-ClientProxiedBy: LO4P265CA0096.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bc::14) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|SA1PR10MB6614:EE_
X-MS-Office365-Filtering-Correlation-Id: 427a70f1-6fdc-4ebb-febd-08de57490c6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RzVkmb3gW3e9uqlfVjwUmeTPK43TokbsdalywyORezcbm10g2GHbaxQ/m2A3?=
 =?us-ascii?Q?QRDM8bvrR5s71NBcAh+9VoHeH3QZ1ES/uhscXMZ/s1fC6iz8cQZGrVTVWCCp?=
 =?us-ascii?Q?38IAOCo4F76RBrJqmWyHOq2I6/khtNPGbeaY/nlWDHJ1RQQz50ExMddu69G+?=
 =?us-ascii?Q?Di8IJBc4M2LN5JCIYtF3wV/4MaHpNk0sprOnRnG8+4hWwZUx/QTh3xgxg3hW?=
 =?us-ascii?Q?L+lhOnsO1xf9uBZJHZ5FFlg6kT5Z0FGaDqzjkrECkWfGLGfZr0nneHhefUwS?=
 =?us-ascii?Q?iO7fArYeSxvWULC+epjRNfmZ43WTJrk8k3jPt20Ow1x9gGt3b5nNNFe8sn9K?=
 =?us-ascii?Q?sJOfpsA6jPzf0KWp3PXjMrEKovL7SLVFHUEkO5eztYrUaIX9MeR5MSUjFMEA?=
 =?us-ascii?Q?vnYfSH6KRYP/xXH/Urg1u+P0e3H+l+xVMaP2j7IHePPhdIjlRG0zFMVDmv3K?=
 =?us-ascii?Q?PD+c6NSa7KCUZLXNda07srkPH8jgms6DtJN4IQXoTxZlL4XZdbCzoOgvdle2?=
 =?us-ascii?Q?MN9Fcwxglxjv0dZrzNNXJ2H9nTetPzV6JTJ22kPE2Pkxjw7NV+43/D+Y1Zjz?=
 =?us-ascii?Q?4nI2lb/EhHCLARSZ7X77AwzX7rsYgkgPfYTDprpx5liFIn9+ITw8/gWnkWDn?=
 =?us-ascii?Q?boKHjq/uZs0hCojx8uKSb9B7iqeMiJGI1wO0s7Yun18PGHnbhnQrgG4xcQin?=
 =?us-ascii?Q?teqLtWS4Xtmmv0VYrU5+yVDbbIdhcezjvXRcj7fVuj/bJWKsfqmRXEPebAY3?=
 =?us-ascii?Q?9VjBNy3XA6zRXItKgB0wCnl7w1Dri4ZdfbLaG/mjNyeZvtuau5riFTmeiFvp?=
 =?us-ascii?Q?IB80ePcpegzNkpzeNKPagZ3M6re1bAH8skiRXNK/J9lbaEoqGdSlZRZySmuL?=
 =?us-ascii?Q?LzLcF0vD5jDB9UY5JS5hGKnwdRF+Ce6dNa7BS2/lCmTabh5COL7hwNsSsXmC?=
 =?us-ascii?Q?aR2kwIxaXk85t/E+gmP+CoGjeQE2/aDLFY+wW0JhkGYcCWzLesWTO0+Al0lF?=
 =?us-ascii?Q?NY6xzgYXssgfHl+bUKETqkYBQWG+JGcxBswr+AfgcOG6IJCRyd6ZO9BF/CnH?=
 =?us-ascii?Q?XHxAqUxqBAsiQ2XKx5sVv93PRMmPS/5s/HEYVSfumfhYDfXd71OWHmiPO25o?=
 =?us-ascii?Q?sfJpoXJt3E0z/fbIMyn8XXh4QkkYsp7Fd4YGBg7L/I50ui+D+asT0JH65xA3?=
 =?us-ascii?Q?nHG8YHX79BQLsOsPXCouG91R8bwrgY7hAyI5qgAOm9i/g84SX9Dwzf51OPBw?=
 =?us-ascii?Q?7g8aCYdv7eqMASkVUNiieiKHzDAbPTrleju/+/Sg/7giGXgBgUu4ddhe7Lc5?=
 =?us-ascii?Q?52KS1U10W1V5XJGqaglFt7bHsKG79ru80OmGkRS1YK2Fp31sGj/haIQoX3ck?=
 =?us-ascii?Q?bCteUJ6gawyPw1GKoBF6u4mTiKi2OI23xVH+UkqMiibtoW8eQKzsnbDtVKV8?=
 =?us-ascii?Q?mg0M/pVu1IXMbmOnxhwUDvuU/taJomhYdfFeTfabMUAckMfrde/fwPCqPNiZ?=
 =?us-ascii?Q?PDjj/iPFztRIFc+O5NMv02sEV6N4CIYljAuiOzjYgtIAawbOXBrdMAQWhXgA?=
 =?us-ascii?Q?3fps8Ys07tDajmniN4o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Xbd9yfJeU3Tk230prd6L2l0zK/hcaqNUVZif6CHPiIpQekBTP8wF6Gs0NOBL?=
 =?us-ascii?Q?BUZBNXgniKnb9MJ/2ID+ZIxdPu3MB37ijz0YkH62FCM4/92pqBeBlnm/8m7a?=
 =?us-ascii?Q?JubBVmzYZIdi3SBNARc9ND6cOPbQxA3b77YJiFIwiwdKA99mQaOb5YkY/Rnb?=
 =?us-ascii?Q?YDbQSDXsvPUlYSbnUx4nj63RjvISPYzUzFIRhOROlZJSpiT0i0xeHIGJflTI?=
 =?us-ascii?Q?re+Cpagwy/KsP+Skwgn3Hvzncs54GPHHSC3kgSE0F1OrKcAHDeTIEq8ZJ6+8?=
 =?us-ascii?Q?Ik9lyGzouQZIq5zQZoeFLXLrbt8sGSMGyaFqrMbzbAygW3CoBCEVZHIzcXVW?=
 =?us-ascii?Q?qe14dFJppHdlfKtnQ1HxxXtEKVi45jYW7UgqZiQW2540XNt0SP2P5xars6B8?=
 =?us-ascii?Q?Sa8Vlmi1Z+gsixzHufAP+iWRcZTnbDbE9hypOKDQ2d0TA1jaCGz43/4F9hSY?=
 =?us-ascii?Q?UTDKAoLMwkWdCl6qACgRZnZt4ayWoOla1zwyobX9mA9kIxLtq7CpB23y1i5F?=
 =?us-ascii?Q?TagiEtyiMKcWkzWyZT5haQ4FQhwXVlZ8Zbn4lxCB5m+j9Wh2xrl5L+ZILWXB?=
 =?us-ascii?Q?SduUa4O9v9awWMTkZqRf6tOPjPQzbu829cQbMABsV3+syhTJWaiVbXtXqzCp?=
 =?us-ascii?Q?bqTJw+TCnZ7loEOR3hhfSxp1wJpWIjWgdE/CpkLdGVWQrhUgerAs4bb20KAu?=
 =?us-ascii?Q?xagxRNwstxjiFY1IUFFnog0OtUGCEz8la9Vq4+FetrzxmnByHuoIzYBWSSlW?=
 =?us-ascii?Q?nE+MdHE09o6zMkrzbJA22ovAh+L72L5a212bnnuBE8wleeDKlrqxol5+VpoD?=
 =?us-ascii?Q?lfeqT0UtNyW0QcgIxwnT6qgwGD5/kXjKiEqlyZf1TtglA0AyCB7a8DIJQlBY?=
 =?us-ascii?Q?lWNSGFCnB81IYnX7mJXIzRd8789RufI4oNDPGtB6P5A7nd20uPoMiLmy8tNa?=
 =?us-ascii?Q?dYcgWWySbCaXPUQ31g7VpwQeTL/70X5tsXHJe+XX8rGGBi7/hjr5KIQcxFWK?=
 =?us-ascii?Q?8FmBR8Mx8YZVsGtfpGVdd9DrAY5InK+EyCqP8cqv0VfYFZWXe1YHQpvU2YN8?=
 =?us-ascii?Q?Nh0CbF93Up54o3SD3tuHfB/JWefA37/twkq82e4q8Dhlp3jQ5QBHmpp6MfSr?=
 =?us-ascii?Q?qA60o5+8akrPeZWXSdPVhzZzFWyUgXlI+lVud/ZvbTy8KOOqdnUeQ0gqMEDc?=
 =?us-ascii?Q?IKc8xldktzpDAtsoPBb1DrSISNkSvdfkoWymqFxvdD6a7oqSH8CcfiLGnfS4?=
 =?us-ascii?Q?9hucyHGj1fikImvwrdBOLpDbsrE37QeuRX4k61N5CbBW7V3Rhzpj4+AgI4zy?=
 =?us-ascii?Q?sxbBS4JQYtYaslYOjs02cmoYHJwufD48qifudvI6MpwmyNXufZAtiBbJ/Bve?=
 =?us-ascii?Q?2k6VZJ54kLgxtVa7rAcm1GPq8KuvYPrSHB8xYRqIwJ8UbH1VMr+g9uJIf8Nx?=
 =?us-ascii?Q?SfB+ibpBNx3Mkg/MZXTC6NpTJtdR2P8BJhITQJxP7c9K/GLYizgrqamtMRZg?=
 =?us-ascii?Q?CZpvvcNLbw141pmxN4GKRsHm/7JlU5bfnl5KtgDHu5m3ESyVeDyAkVbV6QZ1?=
 =?us-ascii?Q?yaYnARWwp54ReX61N6NrwQSkeHjQjQqrLeFLO4JbpbNkzwlm1LbaojFbQE8Z?=
 =?us-ascii?Q?ckRCJWrrXt9YgpCM7uqVjOKrI0YDK6v/vl+pui3yiO5WK9ddIEX4wjxhRHDE?=
 =?us-ascii?Q?EwkZyGNQbp6hA+uci9xM9yvuDZsZ+P1lxOOSNxH+X9cQWK/ycLWFNew/6r7M?=
 =?us-ascii?Q?HUS+WvDJxo8Ujzne66Q/jBzp1VOwah4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	t6DpQCjfFaTWKLsktGFBVK08DnJS/JIshuvGvCLJ+dAxkpHpAWhujxeHGwP1+7ZL4haHCsBKbiD+eqos2nDb8xGUZs+mRXHczyGzd+ReIHSaRBi8U+b7gtaiblrRkfrzUrq9wSpUcRMpBUHLZDF/BFnpflaG5fdQ1CVIUBmdGakiMnThHorLIXQdbpsIptBGGtQWZhKaGEcZTJ/9ndlf/UnanDNpsqUYc6PI+NukhDB00LQiX6ygL1Wa6js0VQ4RyCgh9URxfvx/65zGvEfYFAhKWAdVtl3Ni4Pmc3VXU2mLugvGIo/ZRV4k1Ovk9q9G+ob/2jBgX0B1nvmfP6hJx8wpsje2Wqmxdbtqs7fUX4vGZaQs9RKbkq2IJXO2oa+VLUK3bU56M/frypMu5RVoYnGPXP/mwnKKH1L8KNqiJzXrfZrVq3BHeyEaWXS4MbYc9r5UjKZpIYt7j/796csZ/YNfHB/+AC411RRllt+l8eezWR/Mjolam4a37KNp4RiBsLQC9v+bGieol23huE7iC5hT6f9zUAGL/m2WZXl8+Dd1RUPmIuCBLiQbP+jQlRGzSaUzZgnf4edqYxTDdZh3jezHeqtENWd3E7yljxp1qm4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 427a70f1-6fdc-4ebb-febd-08de57490c6d
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 10:53:58.9427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c7Vq11LE4I+jgQQdkc5yoE7tIcpREUYJOUAoguKF78wgWVT4rraAZMzGtqcVB6+Hngc3jfjBwamxmVWU6PI4yr5SK5LK4PXxb+37ORJT8qk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6614
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-19_02,2026-01-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601190090
X-Authority-Analysis: v=2.4 cv=WbcBqkhX c=1 sm=1 tr=0 ts=696e0d4b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=zd2uoN0lAAAA:8 a=Mvo7nO4hehIkFS7eSN4A:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:12109
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE5MDA4OSBTYWx0ZWRfX36wmEdeIJKyY
 mFKlQPfl8HM3lSoZET9g0pObNQZWW0GbqkDXX1B4Xqt+darle1NEojkDs2No8bACvFVruHl6gue
 3+oiyP9IwA+5Xq9zpV8ZSEv2uGvH7TlH3rnjb+wOGGwr0+JJFlDVNbfcTHFO71rjCScMroJRTSI
 T1elCs57jv8ax57pGQi7VkQUMBqMMOShN0MEPAufPzN9ivI6XcoX1jgAfQgL8WETHxPD9mNhEID
 emml4ecFkxi7PJaM1dt3j9wUy+VTPkGLWv4IGa6tYtOCjEWI4iehHSFMvpMAFe6XD2glcCOqkXs
 z+yXtTL7fyHZwoKPCJpP3ud4N6XP92oe5kDe8+SNYpWfG+OM8FfF5QpOXguLaXf1l6lNd2eQjG4
 Dbcl+6xAnGJXnTMIJyqYl6EvooOOqKgP9dg8l6a2j8h3devQE8yPX1wBmX1mngRmscQ5aVu2Xme
 Ud00MKtV3o5833Kg7IrWnskMN1p1m8nSzO87Bz/U=
X-Proofpoint-ORIG-GUID: nR0mEC6-i9qcRz5Wf6icC6FUrXWrchc7
X-Proofpoint-GUID: nR0mEC6-i9qcRz5Wf6icC6FUrXWrchc7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 73D061C0009
X-Stat-Signature: dq1o7p74si41w1gqcsikxx5sh1znikcm
X-HE-Tag: 1768820067-685217
X-HE-Meta: U2FsdGVkX18Zcip8kyWGahUtx3AY37ifim4YThadrpq/e1lxuGY/YG51rDQmOi3yaRx6UfQIgisT+X4BHPuoobcSTESHIaAsIpfGHTkATbNqAc1V8qWHXg2zeGZ5an2zGJXR1BQCSiFXxuoO8aM7puHoTDiI98dT6K1JtFQ45bVd971FTYu55fggz9+BMIya5TC1ZSEVWCWAN78JHtxTdWZhJ9zkem864bdw9VTfL3A/UrHky887lKahp7rC3OwzcsSRVnGCjA76m6o88wbcXcfhncItnxcmLWUYteLQBGx7kD3vxYI6uszGQqbeuBX6/Xq+l7phl/65zGDA8CjRJHGsqKoZCF9K9Qhd05b+EqYzgPVoMmkALJt6P2CJ0GYjo4cw4BkRap+H3B2C0iBPDS979Lr5QmJyESJu7eJ26KHSCr0FAqafxKK/apNszJS7vO5RWNTJoA9jICZRZB1gC7ONYmjDdFB+v9Jkh5qvJAVQPKcmUdBNY35/OnFYAbj9vUfzc3VL6jCHDJZvLJXnbGYWGU0x6bbGPKosQSf2gMXUPtMVDyCWnmiav8LgFIFegjRO5ZstcXT2el1EPfkrXDyWPFCF7nsRmfv/eJKSkP0HZDHwZO1YboMn3/mxvg2h4iy58oEx4MUyZzv6RyAGUiHvJM5MsVn61wB7wNuS/VImprq66mrmOUwEQWi724wPYoqJDMCL7uIjoiSoukvX7xDUh773HaZNRk0Ix9nMhu29DIG8VPq10KqbgtHeCWpoASGNjv7WWxCnlwqtP1tP+Bkqa8nh4OiByPGy+hx3s4LAKtlvZ5o4i5mgtH30hHVdq6IKV4bMvOR7NCWf8pQCBCrledsuX+70VqNVGjZowWm95bcoHdeTYuK25wktrWbBUtiXQI8GI0D2EcsZoBEjYBVQelPZVuFwhBtEVf3ihSKHV2W+IAxK9lgztF/TbsHu4S3A43ZWORyG/mkcNpD
 OEY3YCx9
 9BkKvibeCTTrukoLK2+bQJlBnsbaH2qUTCP/PQdL6AGc+edITYcUj0hIDtVBNANiBOf8Fz1ZwiBOXFfftILRHo7vcKALtsZfFXsqHiTXikayRSUCWdyFln8XV9XvjmVT53Kv8DDNTr9DJf+ln2Y7uil5iBmJzG0DQdv+nQxxjLv9reXAZm24IrnKMd4sRTD9KvaugcFi27lSH7wEOSusqPWYAkfEn2aLIWfpjDqAW9ef0F3fr29sApU0QXY/GBzdWBXM4f8cX/iV3Ho7qNyvgzR0aCv6qkHEHZyCefgUcj5oe+G0J4rcsv4UEaZdZrG7rtGvPXWToFUydnYwJOH97hvQRjI3q6PHYGrUXVKqGy4CZu0C0uxCkovzKGau53BwFuIXTuSjwlFiUnehSABUAHi06yjOkzwa6OBi1Et2lRxnr6cc3wdkfjOIPIQKE3Sli3NpVsRj7ef+KvR+KOcJ6v69GxbBVLvTewkbEaXhEpFmdIB0ue0WT1kjLYKqRuX+Sr6eZSyBh7+v0Q5+ucsylOfJj3t19rdC0ulWkCzohnzqaBPXohWZSN4L/VrwM20u/Lxjne/LusASESxhRbbBWqbBARuXdT9ARPZ/UV89/Uv6DeXDlQE+r41PkvaiiLgD8tcXu/8jBu3N4uqqs0f6yJ2fW2+Xt5Q65qnvjfkfEEFSSszlD0+IQNla6BlTY1mI0fAFyCovn7wQx7gNOIYLgLPJGlA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 19, 2026 at 10:58:39AM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/19/26 06:07, Garg, Shivank wrote:
> >
> >
> > On 1/19/2026 1:52 AM, Andrew Morton wrote:
> > > Please tolerate a little whining about the timeliess here.  We're at
> > > -rc6, v4 was added to mm.git over a month ago, had quite a lot of
> > > review, this is very close to being moved into the mm-stable branch and now
> > > we get v5.  Argh.

As co-maintainer of THP:

Can I explicitly request that you not merge anything in THP without EXPLICIT
sub-M sign-off, i.e. either me or David.

Obviously I have publicly and privately request that we do this for all of mm,
but in THP especially, we CANNOT accept series landing without this.

THP workload is one of the worst in mm and is completely overwhelming.

Again - David is working whilst being on holiday to handle the load because by
default we auto-merge.

And here you are complaining that you can't auto-merge (...!), it's completely
unworkable.

People can just _wait_ for things to land sometimes. It's OK. It's part of why
the whole rc- approach was added - I think Greg KH explicitly wrote about this
elsewhere - people can just wait for the next cycle and not be too disappointed,
it realy isn't that long.

Stability trumps speed of merge.

I don't want to have to write a script to auto-NAK anything that doesn't match
this requirement, but I'm starting to feel like I have to... Let's try to avoid
that.

> > >
> > I sincerely apologize for this.

You don't need to apologise Shivank, you just might have to wait a cycle.

> >
> > I had this doubt on sending an incremental patch or V5:
> > https://lore.kernel.org/linux-mm/7a42515f-ae57-4f4d-831c-87689930a797@amd.com
> >
> >
> > > > V5:
> > > > - In patch 2/2, Simplify dirty writeback retry logic (David)
> > > Are you sure this is the only change?  It looks like a lot for a
> > > simplification and I'm wondering if we should retain the v4 series and
> > > defer a simplification for separate consideration during the next
> > > cycle.
> >
> > Yes, patch 1/2 is unchanged and patch 2/2 is the only change.
> > The diff looks larger due to code movement but logic is actually simpler now.
> >
> > I completely understand if you prefer to keep V4 and defer this
> > refactoring. I'm sorry for creating this late-cycle churn. Please let me
> > know what you'd prefer and I'll follow your guidance.
>
> There is no reason to rush any of this. :)

Yes absolutely.

It's patently INSANE and in fact a ongoing security risk to rush things in mm in
general, and we really need to stop this.

>
> Review was not over and due to multiple factors my review on v4 came in
> later than I wanted.

Also you're on leave from work :)

I have taken a step back from review somewhat due to this insanity, but now feel
like I have to step it back up... due to this insanity.

Or maybe write a script...

>
> Andrew, if you prefer, I can start sending as a reply to every patch set
> that I want to review so you are aware that it is on my review backlog.

This is ridiculous and shouldn't be necessary.

>
> Unfortunately we can't have nice things (sub-maintainer acks).

Well we can start having less nice things like a NAK script if this unworkable
situation continues.

>
> --
> Cheers
>
> David

Again Andrew - as THP co-maintainer - I politely ask that, while you might not
want to implement a sub-M A-b/R-b requirement across mm (though you should),
that you implement one for THP explicitly.

If you don't then I don't really see any other option than to start NAK'ing
everything in THP that hits mm-stable which either David or I have not
explicitly tagged.

Thanks, Lorenzo

