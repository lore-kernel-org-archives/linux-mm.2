Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69EEAC83F17
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 12:18:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E11DC6B007B; Thu, 31 Jul 2025 08:18:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEB846B0088; Thu, 31 Jul 2025 08:18:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8A7F6B008C; Thu, 31 Jul 2025 08:18:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B9FC56B007B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 08:18:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7E888BB20E
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:18:52 +0000 (UTC)
X-FDA: 83724463704.20.CCDA0F8
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4D28D20002
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:18:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ILxreK4J;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UbBYa670;
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753964329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ariRJ9Wldf28lyVl4FN6kbOhp1K5ajtdiwOBueIcjIQ=;
	b=QbvCF+cVGqHvX36uTlJ6Ni5vMxrgM1klD7TN5C0eGwDt9YJC/nk1IRUYIstSWZblcc6Eky
	7p8fF72UniKDAVFJRQdFNM7D7s7FvNMXGgm97DQr0TCrHVlMWa1u6ENMmmf5SxIrcwGJlB
	WjSjME0I4iEEI2AwkZgxMC3d9vhqApw=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ILxreK4J;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UbBYa670;
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753964329; a=rsa-sha256;
	cv=pass;
	b=ZyYxhlRoHxWW7BINBwMRJIBt+/97SFRYQHb+PV+bhV/Z1qp7o7UVo6eymWnuJ9HwdXrJkJ
	L5qBPmYE+XvHx0Z+WBNlavqYR3LVkyjWB3R0zU0eBP6SsRj+1KhriGS+wZ+hebKgCqjF4j
	Ea8R3TS74l0q5p3VTyGJQfph+n01H/s=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56VAsjVi030876;
	Thu, 31 Jul 2025 12:18:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ariRJ9Wldf28lyVl4F
	N6kbOhp1K5ajtdiwOBueIcjIQ=; b=ILxreK4JxdJW/n0s8aNh9h3ejnB+K1rDxw
	OL7ZBJ+8f3UkYtAFMLmgt2hCr93KunnNaVF8heDEWo8WyX9Bflb35eZDeFUNYs1Z
	FknOm/3wMuVF9onlNY0Alg2kbB3NxxcBZLhl5Qi0e0/Oxf5RscWr93WFUZWuLZOM
	z/nrww99VSBFN7SGdGDuyVWSTskIFARKiFXs5ud2y6DHjFZsqHjtSWPFAC/33JTR
	97WXtYccR7qoSzkWJmeXR2HsJYObA88icCVQn4BMaqBUHRmIgQaqeoOJg1z6BfO/
	Y+wt1sO1/vsfln3BtIMByZXEiXXOmgHDNpvtiMPZn2H4NuH+daRA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q2e46cu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 12:18:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56VBZ5fU003128;
	Thu, 31 Jul 2025 12:18:42 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2044.outbound.protection.outlook.com [40.107.236.44])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 484nfcdyx9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 12:18:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oaoZm/Vno6i+Jw05KUbqgplyPNHLkCm9G3dvskPW4lyAcrqqBBLOoCPgh3PJ+mALk7tescnGvXgnJmutimUae0fevOyn9FPaAykTqYUt7kFziF7iZaAii3CrWYNjTv2ufTB/CWBE9a8FMbrRdcpUiA1rCe65sMhTYpLHpphhNQZHQt8dr8N4sxmvFxtF7KL+NemShXFthpOWmrv+J4Jdq2md0t5XNIqIbVrOewnT3/+VPAJXDXiqu0GFuD971TCcpB1W4QEJgBJVaEhPkRiJOyjAime/uQmPSq1cSCtK6ViOK9LdhMyhhYMkpvbGJmk2ewWxF7HVFStOnQKTqadBEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ariRJ9Wldf28lyVl4FN6kbOhp1K5ajtdiwOBueIcjIQ=;
 b=ZGtnVY/K+9pjNHeJABo0KV+fcEuBIvMrtSFDCYO5t2M0I06Hir62TJZCJXLUorfTxQngGGBPye5Kaap0ttvg6LP3Lkom6QUaiHl/1l990IQcItofGkN5frb+mqRL8nV+bL49aN78djAiaaTeJr2DGrM3Tr2nUL/GgkpYjMZVsG0fmhNQLvbK4UYPEDE6Z/6lttek/IKR9Hx2UsJCQxTgQ7rE1UHf8+wmZuUJDb+UiHyrwQ9tFstUJE+UDytGsVQuRc6W5nIxaOeO4L4O/sVrEkmXOW2FAFBYyCZroL7W0VRzWSEFuj4uAseo3Y/kRjpQn92A8fyBmQQJ5gxg+fcsbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ariRJ9Wldf28lyVl4FN6kbOhp1K5ajtdiwOBueIcjIQ=;
 b=UbBYa670ZRFRX1nMkVIJp9LRvvxm51Be5EVt5BFxCoQdixf93XctIADzmuVII7pXBzm7+4Z51rFVwdtO9totxtAvlSyCM+04OXGEgQBoy8mYd/H1VbESZ9O7EuBfhCIaZ/UWAeQY6NDJAhpcyTsPsE6Zs4Sv+LSJj0dhfASKWDU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV3PR10MB8058.namprd10.prod.outlook.com (2603:10b6:408:286::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Thu, 31 Jul
 2025 12:18:31 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8989.013; Thu, 31 Jul 2025
 12:18:31 +0000
Date: Thu, 31 Jul 2025 13:18:29 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: SeongJae Park <sj@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Jann Horn <jannh@google.com>,
        Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Pedro Falcato <pfalcato@suse.de>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, damon@lists.linux.dev,
        kernel-team@meta.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC v2 5/7] mm/memory: implement MM_CP_DAMON
Message-ID: <dd5cd44f-3107-4337-8673-2d5667dd9ff4@lucifer.local>
References: <5acc6af3-91da-4dd3-834c-e8923e5d3320@lucifer.local>
 <20250730042106.54750-1-sj@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250730042106.54750-1-sj@kernel.org>
X-ClientProxiedBy: GVX0EPF00014AF7.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:401::31e) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV3PR10MB8058:EE_
X-MS-Office365-Filtering-Correlation-Id: fedc49f5-f0c8-44df-0b77-08ddd02c5d2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NtswpY7dk5qZ9xMnvd0919HrztODGGY3/8f73a3+sEtMnrykAssvPL0RO96i?=
 =?us-ascii?Q?/4elVEOIYZ6hEjzTnVPw4uDgCXn2vvqdib/ww6WHMLa+EZNRvLcnU8m5oxtV?=
 =?us-ascii?Q?VYwLWKhbHgicZjZapQkZPEJPT5ncqS/6KUqOUEXnjq8HU5tkgfwzURH+Us1n?=
 =?us-ascii?Q?9H/DLCDn/L2Z/3OWHuOOdwD03Un+Rrom7r406PXSq8IX7u9rSG4/H8DyRDMD?=
 =?us-ascii?Q?rbOkVphZJAgfytoQgNoAAbR1YG17MKOrwP98VEv2bbbbYw7BNFjVfsd34mjw?=
 =?us-ascii?Q?X4vZtCpHu0mdtCM1v1nQiQfzewowPeWp+iO3YWQShmSTLcPlJMY9pfIEYEL2?=
 =?us-ascii?Q?ij1XlSqq+51YVOPwZGo0k1Zu40HcpbzYJ72hWzf8PKGwrsjFtLGclLusIJ+u?=
 =?us-ascii?Q?qApDXOiokDbBA6kILFVKiEFn9FhWYb1lo1R5sF0iWn4idhOpTb1iqdXNivxP?=
 =?us-ascii?Q?XPSNp58UNamKqA0+N1opMZ7nTz7uQIE7Ix+kakNKdI9L/xGEt1X3uCDz0byB?=
 =?us-ascii?Q?uApzYQbwR+v1XvRFNcOlXTGoZuJnqrq/Ri0OxY6X7jPYZQaoqKgC7kEWx1PY?=
 =?us-ascii?Q?grQtafoOAArlZOlBoWZiV0k5J6ZwcZoKa9EqkraLDE0UYInfHkkYAv7p1+rb?=
 =?us-ascii?Q?CqYPn7XBfcITMW4cRjNZDDrcEBKnJ/RgS6N6apzEG3EGl3RMdmCi/muxd2S5?=
 =?us-ascii?Q?p+wEZLURSximtfL7GtrCk1T+6M3Y+G4vqtqKn+rCJ5rPZiBqm0gbqFCMF//3?=
 =?us-ascii?Q?rTgLAYBqbV6FgOXxog0AWzANSf4IJ6T75ecVJaFUFMP5orT9SNnopnGLmWiz?=
 =?us-ascii?Q?60PLodKo64wnF+g00/+tJAs5GPs4mskLQcpX/S63DOHJjdoL/psIgHUCMAUz?=
 =?us-ascii?Q?S9cfk2jcVVtISFLfjKuQDItbU1th9PasQNycnGiwURke9he9NftPKja7BaEQ?=
 =?us-ascii?Q?UFlwSMk1rExJGK5sTjPNezmLGL2lGy117vndmQ7NimHaozpY6aEOmk1Xs6o+?=
 =?us-ascii?Q?IXCOpz7jn3r5KhVaba+ZOsJz/HX9CtJ4V3rxT6cvpK2GVSUTeWqrdcyv9tEW?=
 =?us-ascii?Q?T203TPJolW8cIM/GZ7OQYEDYCoZBxShuJ1UiqAwXQBX7RoHxzczfWX6qtsio?=
 =?us-ascii?Q?4qCvj10Dj4nL1zO8wNFx4i7hoCCilpAlu4gtZbX/LOEcwkmZxvvuAxjnZM4J?=
 =?us-ascii?Q?D2vXnSma/tLNH8POZPyjHa5FcyLmO2FCjXVA1lcfhXu76PDaaUjLBZXUoN5D?=
 =?us-ascii?Q?PSr2C6bQL2S2p7AXp0B8249XJyNfgFgKIuVnRBLv0gx+QHIoRw5id9liARaM?=
 =?us-ascii?Q?6BtDVhYIUthyErdMNX64vuYwjlGZvzLOUzizRfrqEOzXy8ne7dmRKgeqn344?=
 =?us-ascii?Q?3JdqFGypoXVHk5Kn9pemNdTyRT0O8j3jk3xdFr5Gfz9DhK1KOAprdNLfPcsO?=
 =?us-ascii?Q?mYktXTorI70=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rlgaeW++bm4eGAJ81n12c+P7wyyLNeHUvK5Hwv7f2sx9010pHkjp3PgXZmOn?=
 =?us-ascii?Q?dapJ/4+R+uC3L7YnPOpHQTp/NJrs2518S8awtRYfJwuESL7x+edocKXjO4zF?=
 =?us-ascii?Q?eupTkiWBWepN97W2xfPA3ff28oMzd1+WN4nMQGkkJQfFltvvAoMyVCsRcjg1?=
 =?us-ascii?Q?2HWYo3OvE+n2i/RoyPUziqAaD9rdCxe41R0xQIBvl76KB8hW2t2H+KPfdxRV?=
 =?us-ascii?Q?Z+A/S3Z5s72Zb39WedcuhPn7t3rynbGPzZYJs5aVcfC5HRthl02sLTzALKTw?=
 =?us-ascii?Q?XUlewK8LWWeaidGnTBoyuMjohus/TLqqmlp/TQ8B5jC+nbtxwsvniS3NM5HG?=
 =?us-ascii?Q?XFH4rkW/ABD06R2KER0OOqhThpW+EXWXEODCaEeGiv85f68JonVr0qVdBQ4N?=
 =?us-ascii?Q?/npd66hWcpSD3ZUXxj61tFfj8m2kYGEHtgGD6ikC7LlkENCH7X5rIbVE8TJn?=
 =?us-ascii?Q?p1MZ+8t92aVrWTGSNYkOUdz8a7F17wGXfTF1dakCOQrnIA9wG0kKc4HPmr5R?=
 =?us-ascii?Q?KhSWlYj5JmN5CUeba4qN1i5PrH5hzlmLTCWEvQ5bfwawzjOLHVXKxzNpplmS?=
 =?us-ascii?Q?1RExgmnUD2rB/jiFkxgT4MaVd4Pf7f2u95aV2aeAl6+adZbUMm+/4ktKbDtP?=
 =?us-ascii?Q?0GECi+z7dGAm4qIuKbmneH2pSJe7wacB96r6wcVZq7AAOx8wfaAR90DiC5am?=
 =?us-ascii?Q?fvEQ+4mdzelQPMJULt2dX+q8mg81/QNNjFzp66RIh2AbCyO4g3SqI5r7QBxh?=
 =?us-ascii?Q?yyg+sxerCwa4nQYLodcJVqkRls1U9iQA7qOE35ztKx7FSrHh1H5Fm4TMSj7d?=
 =?us-ascii?Q?1hklZFaBeuHG5FRMhVrbdZ6a+Dvj3pwbrbu7K3dakrDIYIp8BviVfzBzJfV2?=
 =?us-ascii?Q?I8XLvJsuuUG3c3N8q6Oz/P0Uzlv8di76ietNBvARrT10tQE5EJ1YofxV5YLY?=
 =?us-ascii?Q?qD4njZHsNBI5XerlrjtaZlEWPfyE0vZAJfZvKyTbsWeCN0qJOICoykmWaA42?=
 =?us-ascii?Q?prh8hX62ouu7LVg0ELZ4fswDTTnDSaqYtLSsnC7dwZw+CIICk/t1KjAZ/QQN?=
 =?us-ascii?Q?11fRISkx16q4m5g6fa6U0rqne3hnTHuRWmS4bKd9HScIbjhNejVsG7qieRRM?=
 =?us-ascii?Q?yQpsU5I/zlLZfR69Iz3+/rDbwXoHDdpDFAkeP8YH56yLCTC2NV59gEedGxBC?=
 =?us-ascii?Q?UxK2UZWOS3o0Hgw2s8VCSRrMR15YAMLsFjHlg+SeDKKxFt3sGYWQaRpQeUIm?=
 =?us-ascii?Q?lPS2qqrrZYtN+cqsQZUOmPHkdxgB9y3LXOX66xftacml6YVIUmDcTHx8qF4I?=
 =?us-ascii?Q?KYrTBmXORMt/YauODhpFvSJOXDdY7MfBKeTU4c7zz+w7m2fxznmjs1kYSJ2U?=
 =?us-ascii?Q?9eyRPZacpQ3oqcf05h8vRa2PdwKIpB7odhZNR2qwgizTzD4u3iQY9wzpJnHO?=
 =?us-ascii?Q?UUrMamGw0kibXEy6mgu/nOBKoJL8AUc/5yAmwEfAUsqBR2qNmzbC0UC4GeXe?=
 =?us-ascii?Q?TTgrpOHB/CwwSqNJ/rx6vbZhmcGb7IlEh2FHGWDDlN6KQ3Qec2a+DrvLv0FO?=
 =?us-ascii?Q?TiDSNqZnV/zsMQwTqksxhO1B0MSxUMmRV6dl6lGLA5kECxWn8I+W0bibTcav?=
 =?us-ascii?Q?1g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BHqAILAKujLNv+QSwJQ+wrgBZAEcbUzQfTvZMq5xwxiqfXyNlHh7e/tcHeAokYtpt8UMUzV9XRrgrEcPb4URlIa7dTGpLC5yPSEBuuMSlXhH0RzmGmZk22Y7fardiq9XSClxPpA2fFwY5ztfz00mSMF/CqMNYdWmBO8YvysjqaylCp7Eb/l8jQuXCKlB2/Tzb+3cMmxcd30uCt5xPHjDU3okox5xhEUSRIeJr5EhOHBlU8BlCephQSGWv8Qjej6UqT6AzHl4MlnRW2KNJwrIh7OHGDI/0gjrgroQR9Hj9bf4pAnzLRYmISGVP0yjxjm1rqFPsLeFUUVf471s8s/mD64bYSGDotD0pDN7oTwnMSK4TqE9E22/b25iUX8l2KDZmnynA60im6c8ZUJ+TrEMM152AIptrFgjL2ii1Fw/zdgmOJIwy0ijNbYGFvWb0up7pNYgpeW86D52e2evFiQSRDyMoaGoj9YyLmNn8Xpuzr2k2T/o2yin+RkSnUxuzYCWvTyQr+8DYT+gnu+x/Y3AblQtl8fODcOsVx/jgBO0/Kz6iA73VPCRSkouqp+hZ4njw6I2wo6b9yhHjH723k029jivnKw0fXESRtnmkIl7ehY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fedc49f5-f0c8-44df-0b77-08ddd02c5d2b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2025 12:18:31.7692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /q+TqZcFeI3drcJfBoZkcqhzEm5UvI49xPnUbZjWhJwjMfgUL4AtDCs41rwRbrcgUVm1no80S7+IS3oGIo7Plt+uBjvVDTIBzfHFAa319/w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8058
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-31_02,2025-07-31_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507310085
X-Proofpoint-GUID: x6_YTbrynTcYbzWHjf6HTtqVAR3S25-j
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMxMDA4NCBTYWx0ZWRfX8FbRY2BdEBmp
 nJ6YVUhT3shimUuj3wyjohrNMNlJZie4DahYUutGZUUjHJuGdwbqaqScBs3mUH/aUnGz6NElC1j
 jC72CbvRBoICOyglvnnFx/5iilErjFmodIbUK0Nm2v6h6GaTuaxoEo9Rl/2SX4OTsWPBRDjXntI
 aWFYPb7MXtsjvFfMa+QjsPGCVtisgvZ9edy3XJ29DYTTMLgD1eb7IqwjSN1PIF2Qi8ARPS2ABUh
 MnBxaqD76gSDfucSjw0uRxAqvShSTT6MpxWJQhKHFqxwcIf8oFuLS1+GfVHWDaYVMqtTDIlPLF0
 8kpmJc814vqkncVP3wbXcTxAxpO/aNPCLTqgwGwS1ZCN8nqlsMPFRogunKAxnpGSW9u9QcQ/E8H
 4UeQVI2tMZpGEqLx++VB9RWygShfjP6xli70tAOdejvGBdJolnjtStXdQoKd19Xy07ask/8h
X-Proofpoint-ORIG-GUID: x6_YTbrynTcYbzWHjf6HTtqVAR3S25-j
X-Authority-Analysis: v=2.4 cv=A+5sP7WG c=1 sm=1 tr=0 ts=688b5f23 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=mwxirpOD2YPB6wsPFj8A:9
 a=CjuIK1q_8ugA:10
X-Rspam-User: 
X-Rspamd-Queue-Id: 4D28D20002
X-Rspamd-Server: rspam06
X-Stat-Signature: dusnu6tn9d1i7qrukyeku3t1ijbxmmw3
X-HE-Tag: 1753964329-672378
X-HE-Meta: U2FsdGVkX19W2TG+MLEde2a3xuzfDFjaN8I4bsPddlfNusSxa9HTsC05cuZVODieEjxcocTKasSs2i5u4laYW//SD2pO+P7arF3NTO8IDtd+1PV6cPV2a9OloKCkeir/b6Jr1LAlTG0iK8bNwp8G2jOO7u9bGDycBqbWpn05x+WKL9ZpHVYevOuaRAUvrPSQfN7A00m5b9Qh+wGBwW5TRzSxioRtmEGG+4SvlJ2XVw6CLaJhvEodkjB7r17Ez9fC8UY13NvqFgHziP21ugnRPsjfUJutZ2tjGQt17bqXvitgGb4VhlwteO1UILa7unkmhKFW7lMcAVTPhdTgotRVfDixEF2b7vBdcQJyOOdKlntqPpZ/TzEPJQ8NtcQgRGUFTuEqGsH84ETK8qr22KdK79X3KkS0yR5I5PT/kliJcENCzJRBlGGNnQM17UswABfl31QuNOWBmNfBQzUYtDNM20wbcFbfy9htHNFxpZR2TBUR5c8Z/QRXkVwY8n5b508mSO3ZjKo4bW70FEgceOGsdyK9uLBylC7Pz6rmjV1aViiU4LlXV34zhs18zrbcHUiPJAdBa4Yi9LDdop9lBnKwp9vz+eweh9KovdZsNMxlSf+qR05gorWY1jwIicXAf0uj59YAOdMvo7Hs/mGPeTu7MheJW5tpTV0hPdKcR0Nwc2XD/yGPM3POC2Om1QOeXw+HBzH+6gNU+MrrP5eVIa0dqvGnY/3lvy/YJjXcIYYuGuez8FrTvvI6MdnHomeQvvZg3klDyH9LfLsDw8jShd/oTrIOa3sBOd+SqDlsOOwRMruXDEu21LY+LXsGy+i+dtjvXSZypBcVSIcTMAgyEjgVJo5WRuBabWAdMJJUMrfzca8zZ6+rzYWjdgpuA9I5vqUBZ77+6BkwPUGRc1c7C6VHEKcd8PYCchZiYd/HcZAN0y6vhwGxbttvjAkJ72AL3wHAr9BXQoFJlJJxaufwsYN
 CmSO399r
 WC728KCzGrzQFmOOPfOYVexZRijdDViI+x+OV8gg8jrrCMSRyD3n2GsOSGHun7DFYYkl5R9p0bL7J5jZKAuJCG+LeBw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 09:21:06PM -0700, SeongJae Park wrote:
> > > Thank you for review and comments, Lorenzo.  I fundamentally agree all your
> > > points.  I don't aim to merge this as-is.  Actually this patch series is more
> > > like POC, but apparently I was rushing.  I will try to adjust your concerns in
> > > the next version.
> >
> > Thanks.
> >
> > I do wonder whether we really can have a whole new faulting mechanism just for
> > DAMON. Because if in future, we wanted to change how this worked, we'd be
> > constrained, and it is a very specific user.
> >
> > The issue is you need the PTE to be restored to its previous state, just like
> > NUMA balancing.
> >
> > And I really really do not like this 'oh if you turn it off you can use it for
> > DAMON' thing, it's just really odd and asking for trouble.
> >
> > I think the only _workable_ version of this would be to convert the numa
> > handling to a generic 'fault then restore' type mechanism that could be hooked
> > in to by either NUMA or DAMON.
>
> I agree, and this is my current plan for the next version of this patch.

I think we'd need some way to embed this information somehow, but I'll see what
you come up with :)

>
> >
> > But really I think you'd _need_ to not have significantly different behaviour
> > between the two and _not_ constrain this to being only when NUMA balancing is
> > disabled.
>
> I agree all the points.  Especially the current interface is ambiguous and easy
> to mistake.
>
> >
> > But then you'd need to know _this_ PTE is for NUMA balancing vs. another is for
> > this stuff.
>
> Yes, this would be the ideal.  But, memorizing something in page level is ...
> always an interesting challenge in my opinion, and I have no good idea to do
> this for now :)

Yes this is the crux, or another approach will need to be taken.

>
> >
> > I'm not really sure there is an upstreamable version of this, but it'd need to
> > be made generic like that if there were.
> >
> > I think it might be worth taking some time to examine whether a version of this
> > that can be sensibly generic (which could have hooks for things) is _possible_
> > before sending a v2.
>
> Agreed, I don't need to rush.  Let's take time and discuss sufficiently. :)

Worth just playing wtih different solution.

>
> Nonetheless, I may post a followup version of this patch series that contains
> this one, even before we get a conclusion about this specific one.  I think I
> may have to do that, for sharing the future idea in a way easy to understand
> and test.  I think it might also help us at understanding the real ROI of this
> patch, and if there is another option to move forward.  In the case, I will of
> course keep RFC tag and clearly note that this patch is still under the
> discussion and not willing to be merged as is before the discussion is done.

OK, as long as you please highlight this, indicating that you ack it's not
mergeable with the current approach.

> > Well, in the above you say that you can't help but do that when a race occurs?
>
> I mean, I can't help when CONFIG_DAMON is enabled.
>
> The race (or, handling faults that caused by other entity) can hppen if and
> only if all below things happen.
>
> 1. CONFIG_DAMON is enbled.
> 2. CONFIG_NUMA_BALANCING is enabled.
> 3. The user repeatedly turns on and off NUMA balancing and fault-based mode
>    DAMON in runtime.
>
> If any of these are not true, the race can completely avoided.  I was saying
> about the case that the first condition is not met.

Well not necessarily continually, just at any stage.

I do think you're limiting yourself rather by requiring NUMA balancing to be
switched off.

But in any case, for reasons previously mentioned, I don't like this approach
and I don't think it's at all workable, rather we either need a generic 'restore
PTE state' mechanism (that can somehow store 'both OR either' NUMA/DAMON state
with them), or an entirely different approach.

Another idea might be that of converting the current NUMA balancing to something
generic, whose semantics are such that:

- It restores PTE state
- It 'happens' to relocate the mapping to the node the CPU from which the access
  was made resides upon
- It also calls a hook.

So treat the NUMA balancing aspect as sort of implicit.

Then you can just use the machinery for marking ranges for NUMA balancing for
this, having defined a hook.

If you're indifferent as to whether you get the hook called for arbitrary NUMA
balancing faults, or have a way to identify whether or not those mappings were
marked for DAMON stats, then you have what you need without having to customise
_anything_ in the general faulting code for DAMON.

Instead you'd just set up the hook for DAMON.

This is just an untested and highly theoretical thought :)

> >
> > I really don't think a version of the code that results in the wrong handler
> > being used is upstreamable, sorry.
> >
> > I've not dug into the nitty gritty details on what would happen in both cases,
> > but even if it were 100% fine _now_, this is _exactly_ the kind of thing that
> > results in horrible hard-to-debug issues later, should something change.
> >
> > Implicitly 'just having to know' that we might be in the wrong fault handler
> > seems like asking for trouble, and the RoI on an optional profiling tool (this
> > is not to take away from DAMON which is a _great_ utility, I'm saying it's
> > simply not part of the _core_) isn't there.
>
> I completely understand your concerns, thank you for nicely and patiently
> keeping this discussion.  I don't need to upstream this in short term, and open
> to every option.  So let's take sufficient time and discussions.
>
> I will take more time to think about a few potential options to move forward,
> and share those with a level of details that can help us easily further
> discuss, hopefully in a few days.

Thanks!

