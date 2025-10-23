Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7A7BCCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 08:00:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13ACA8E0005; Thu, 23 Oct 2025 04:00:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C4838E0002; Thu, 23 Oct 2025 04:00:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA7468E0005; Thu, 23 Oct 2025 04:00:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D25DC8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 04:00:42 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 88174129A3A
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 08:00:42 +0000 (UTC)
X-FDA: 84028632324.24.A2C7246
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0F8D080011
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 08:00:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=I3dE3hF9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=NKHaqv+I;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761206439; a=rsa-sha256;
	cv=pass;
	b=sethFrY8/M98PTThDecd5xVMaOfztjCMqu2dUZkcHl7sjEDHOAe+TspCbDKw+Xy5PTNeye
	qHODfoOYklwBFf9moqI0E6IbyLrB89ZmVhsJm/F7QqG2hAwYUvT8SQuoIXYtpDLWtVvkQV
	ZWkGQHfpMyGfmTmAcSAJwA1cmiEIEKA=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=I3dE3hF9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=NKHaqv+I;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761206439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eNq+J+xP/odxNYi1sGknbdVWSJMEyWo2kLFERXjr9xY=;
	b=qHFLY5zXQVWiJehwzehE1Y+Wto8MGhiNczixWpPF7gUKrwtNBmyZg0hj5O19GuC7MTDEnZ
	gbdpSU9uVhekY/GoyJd/NpvDr2IysJtab4ybKgEnuGj8bRCPvTI/v+b+mLQ08fpa+DyBGO
	Yz+kY+UIMGQlIKKrV5gHSf2WF2zVAuU=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59N7uMwI030987;
	Thu, 23 Oct 2025 08:00:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=eNq+J+xP/odxNYi1sG
	knbdVWSJMEyWo2kLFERXjr9xY=; b=I3dE3hF9Gbf59r8GSVvRBAw7Eopq96ILsk
	xHqhsnDL+FpROfbaAES0EHfyjM1RlVdjs7Vnmmr/bzdVL69wQfCgRzwMiPTVX8Uq
	M/dhxIKBwi0d2zDren7UmoXQIa1/FL7sdCr+HgVS46pA9NILmzDwlBQ1aOELQ59h
	G9S9IQDNQc4Y0GuNHg7PRJOAcDTFy+PeUGIEMkarQHPzb5Kc25L60sEUdXAwQ3t6
	pc40TQburRx7TtWyIh7TBHX4vD9d2Y2JJA0xEhLNXUPE/vFFCcRllRTmsoSPSIq5
	gR+2NiyrcaB3RADWDtkEgFb3xLYGh2GGSIniQTYAwfwXpfFxPpgg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49xstyj96r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Oct 2025 08:00:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59N7NY5Z025278;
	Thu, 23 Oct 2025 08:00:16 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013053.outbound.protection.outlook.com [40.107.201.53])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49xwk8r92k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Oct 2025 08:00:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oQMwsif7wYYiXiRO2uBts4aTDcoi5GxSjd4YW4GwxcLyyr4qldkh5ZOoUIkQm9ZBURTzNQzHx5BWO0YBWGuUQsB+Jwh7cjXTLo0GUfSt6Fax70e85R5HV/5666jASLGQ1mRVgrsGLn5sd/CoZW4bu5Gjk4NLcKrhhj19gAWOONxVXJU/Z/xi0g0dWsl+rGx/IvDCMjFVfw+cwPaG6Od7FRacChc7aNeUq4IL/NmRok/SkQ3UwVqbcpdZKUfEKno8XD8nhMHMbPQy8mRxS9qCphc6RtQztMi6dvb1a9v7ED+Yo0Zxo1FGDpK1GRBzZZwTgsIXIZItTuAMP/WpnA/4zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eNq+J+xP/odxNYi1sGknbdVWSJMEyWo2kLFERXjr9xY=;
 b=cLZG40V/m/FdsJHv5/YgEaK+DUciPCBYHgX3CZLt8b4sR7C+tif01jGnn0fg2lE2EYvlMBI1Q+2HcAmlJAzDe59Zx8ud9d7VFBf3DyIJxTX90oF509Sk2E2P14GgdqLl1YsTEkQQ58uWXdIThtcAL4gSn/CgkY7E1uFyLHcdXGMgmjpUeNc2W4+d/FHIFnP79oJPuQ4HIJA7brz7PRoPzMoD2UPjtxuHhAFiU8VwY/ny5ExbLHphvFGJTEq8kBAhvAIWSfCmCC56eJkO5/2PouqwOm4JKLpe+2rFdLQlU25UcGcfJhMYe2gtUoKQUVClCSQlBDL3owgXYSYsAw+PXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eNq+J+xP/odxNYi1sGknbdVWSJMEyWo2kLFERXjr9xY=;
 b=NKHaqv+Igr8MFdoDBIx4gP2P9P93I+hqEHewfawwcziANbKjkivwP/zTYOTUxLVruubPD2psbJV0+XZK/xEAaH68W24hA3Z71LdAfRB9AVlx10eXGRcbbxB4WhvTQoi1FvlAKQVfJeUxICUtkZ//voX5hd9t4dL7dXCuAX3QkUk=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH2PR10MB4230.namprd10.prod.outlook.com (2603:10b6:610:a5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Thu, 23 Oct
 2025 08:00:12 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.011; Thu, 23 Oct 2025
 08:00:12 +0000
Date: Thu, 23 Oct 2025 09:00:10 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>,
        Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
        rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
        anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
        will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
        jglisse@google.com, surenb@google.com, zokeefe@google.com,
        hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
        rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
        lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org,
        jannh@google.com, pfalcato@suse.de,
        Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Re: [PATCH v12 mm-new 15/15] Documentation: mm: update the admin
 guide for mTHP collapse
Message-ID: <666ee834-396d-4a7c-be89-96c58b5c2ea8@lucifer.local>
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-16-npache@redhat.com>
 <bba40f08-1b87-6b57-0e10-6e96e4d7bde6@gentwo.org>
 <ed0887eb-6124-44ab-9d1f-1e87e9640e14@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed0887eb-6124-44ab-9d1f-1e87e9640e14@redhat.com>
X-ClientProxiedBy: LO4P123CA0665.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:316::16) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH2PR10MB4230:EE_
X-MS-Office365-Filtering-Correlation-Id: 9586bf44-e5b1-4da8-57b3-08de120a3161
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ygh+BTW2JV+jAt9nVVfCEvqBCU8O0mBGj9KkbfCUCw3NSFQYVBg2TNpEXOmn?=
 =?us-ascii?Q?8TaQiABl31U3puh2+sHeDqpa19TnujNuhUFY8OjKzaywuNPvE2S1Z6vnGqRo?=
 =?us-ascii?Q?APwkRBeOoXH3zorSAAxBU3CH+zBLNabIqknaet7O6tsIduwUff5Y2Eo+sDGk?=
 =?us-ascii?Q?2ogMwf/sTskWRMeK+jIu406OmClw90vCzBwIWTZ6aVOUNNk4CQbEoQkCxXVN?=
 =?us-ascii?Q?pX+Fj7YHFruUOUJVBhL6e0kUV9SSIo+fkrM06ziux60B/lEm3ZJTVZpx9H/t?=
 =?us-ascii?Q?aNA5A3qcqwo38k6zfUTaBfmXEWeetrxTn26x0lKtNX74rXuVZCJKaskV9wL8?=
 =?us-ascii?Q?Jn2DNz0hs6VyRdjdFEwzyDXUlkWDkTXq1Bq+Jojk/x+mX0QMNkld7TePFV3f?=
 =?us-ascii?Q?fERHuWMjQHzeR3xnM2OPG0wtpqdsQjebbJCNwJBBD1jDyst7wmHBqDvA5QQC?=
 =?us-ascii?Q?FreJb9NsABc4zDtB8P2dTjvJmjduEagq7qbpl6giGNeTTQme83jgyyAzO+ls?=
 =?us-ascii?Q?/16FsT2X63CaxELIp56zcO2w3pTKse00LXx2HpBmXHzxiRJUztFE1+IM0/rr?=
 =?us-ascii?Q?dPVxJ71CMrh+/Va62lAXi0dtgbzqHwPA4Zvw8+wdpWoGatNhoF5A8MQJAbUu?=
 =?us-ascii?Q?MGsZN1iOKhbbcDWsoLroabqMK4PP6Nm90VZBNXTZnSHWRw1f1OAf47D+oX0I?=
 =?us-ascii?Q?Rqen16/8lmgnDEpl+dXGzXvDNjFiSPQ95S7mZyAuttqfKWMj38OKnWoXDg7a?=
 =?us-ascii?Q?Djqf67RfqZEAwJN6M7EssVgV4H1zk3FrqcX5oLLaWm2cXfcA9rIHjqeZG/Xk?=
 =?us-ascii?Q?okjaGUqfdzmX8nJgdi+63r8ZWdwJmsiQx8RDhV7nhTdYQIQmNvLlrdmtIH/t?=
 =?us-ascii?Q?ANeQGwIpDBEYUXojn+2tuT81UzJQftebuEvglWOyuLb5mU8dew+vkwgH2FBL?=
 =?us-ascii?Q?YrfddBIBVVQ3GH4fZGjKxv2rSI3J8qdL4XyUOhW+LGa5oBUT+F/GlP4gdXIf?=
 =?us-ascii?Q?wjH2EZWDkVz48c8CPZwrKZE+uaRde9d6bQ7DitR7iPSG51HuT2F6WZtd3qyZ?=
 =?us-ascii?Q?yKDyavFToHko2pxPGOEuGuqQNEFq+0SOc5Mqog1aZ28NBkmytDYbswEPcte7?=
 =?us-ascii?Q?j3adQSrtB7c/joCe8kibrIkScjQB4BVE6eR512V6vTnN72e26O7bGIM66Uim?=
 =?us-ascii?Q?8ua4JE59QY6hQgKE0e0Bu4XplMC3OYicLgPGm3UUtCCq82f2V/DSdcg07PaN?=
 =?us-ascii?Q?qdOLG0aeEo1cVnpBswKZqMyEFoOWQvUow5aSa4Ki5ipViZOAuvtBkZ0fybKD?=
 =?us-ascii?Q?WNPQLDrdGZ2Y52SSQHdQ6Bgx0akmPyN3Immr8nACrqbCH4DwBImDMW3xWkzF?=
 =?us-ascii?Q?XFuZhFpVxOpCladOY5pfjbj0rUyVlduN7GFnwk1GZL9i3dHTk47iX4x/B5el?=
 =?us-ascii?Q?hgyi4P3ubGlnTUGhSPI3kBDUDFaL+cdZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FyRyYpETckwvYKOsijbBVHc9BI6Le9MnEGUM6I5hfbWAjPV4IPdoslJbqfLi?=
 =?us-ascii?Q?RR/rRj79Jp3CpHyV0KvAHLr62Cg03US44eBMOfU0jZ2XzPG7Bk5OxpHwvCTV?=
 =?us-ascii?Q?1OzG6QV8mOTkxN5RBpIyij6/xNt3/9J4CmxsW5zEpqfdDgPNXmz52ZV9Va6v?=
 =?us-ascii?Q?wsSCWh2n7javWoXVUBuZ4b07xI6BjEVh05Fu9NdzPhCnXqXdtngbOzqEz0e0?=
 =?us-ascii?Q?gETfHVdS63Cinrqnjb0kTuONcu+LPz/Jlk+I/3fxZ5OD2KdJ2qE9MQxvPDfr?=
 =?us-ascii?Q?RszgBm6MIK5WLN3ZiGFCeit4yd8oqb1VWKQ8dLplKvogojiPc21mgU7TNRbo?=
 =?us-ascii?Q?GzrA0kgX0SLT/gP5U/+VwmRPb9jTwAAEJuo3hqdfjqPb89q427d2Fg53EYa4?=
 =?us-ascii?Q?TJsHBa/FCvUO3DQrsO6CBxY1dG7DmUnHBRdnQ6+tpqcdLPY6m9+uQ3h18X3J?=
 =?us-ascii?Q?7Zy1EBP6nn9hUQQf0hVw1yuuStJ+mYVGKFy0tTzK7vmtCC0AxqO9XcEGFPt+?=
 =?us-ascii?Q?KgQeC/8/kmV4IEMHZO8XWg/GKuytvLijcBlAZMP7EKEfvmfq7cT8DbqhDcvh?=
 =?us-ascii?Q?Map+l8+hI/kBOsrU9KwSOO7FeL9uLP7EmBHi80Hfm7WfLEdDQNY4v41wAWHQ?=
 =?us-ascii?Q?k71+lAro2rnAONvt1vJX2TYZ6LdVJ8ZiqvNF5daHo0+HgcWyFpgospubXZvt?=
 =?us-ascii?Q?aV4IzY8OVWkLdzP351acYv7XNDSZT6omyUMB//nMdeXrejfNqvwNI/U9c2Jf?=
 =?us-ascii?Q?fMceSBvoL1mUYk/kova8Xedd/MsJ9rwKUS2N9rz6ICrlwaTJ7nrLz7vxEZ5Y?=
 =?us-ascii?Q?n2z26x/kIQ3vET7fJeL5J4wF2K+1FEqefluXQU9zBRAoX/xxfvU1/Ue5UwOn?=
 =?us-ascii?Q?yXR7LlSa4Zbg7XEDEbsD1nVcilcfdrVHRDu0vVHU7gCKUX8NJ4KZ3bztFyyy?=
 =?us-ascii?Q?BkbvtnNx5pzDLVgcqwVV22Uhnb+mTpgQnQRODDEwvxFElAAzk3sZPIIcwQDB?=
 =?us-ascii?Q?WUtKLqkKAr94SvKn2zt3VNxJet9VGHocGzwusWWDYU19Sqjl/t5UxNqf373v?=
 =?us-ascii?Q?NzlOz1LLt2fS+KKTJBN+SUyCq7Uf35u5HErgGODoN0gIdnH9dbtx83kw9ziS?=
 =?us-ascii?Q?o0cc0Q/UzYjxIjlEPBOHHldlFGnMiEGtTR9ilkMQs6qXEP+p3Lzxo2pr+ehr?=
 =?us-ascii?Q?JR+Vdg4WmVq5SrOEJ7Om7SrYgyEwJRdxnXIs5n0nCL3Y09oTFbOjBZJ4/DKO?=
 =?us-ascii?Q?LhT+SQncNuaQUL+as1IS/j2VGqXZ4mDY69shgOgcycbnH5dJRaVYcbc6TAdD?=
 =?us-ascii?Q?fcWVrIsvqSG8Yxf2Wx9MfF/WzX+2dMyVZ9FE+9GbLqG8cREfvz4t3IJlLs8g?=
 =?us-ascii?Q?X0gvyEasGNgzBZLDVXvZdcNSJ/8WV+DhZbJH/r6CmqGxzgFzEHeg1eSmPtzn?=
 =?us-ascii?Q?DnGK1YdqS0XMMciy4PJsDI4Ig1hEBlsy8ppFVVP3P92rEMd4Ns+V7HHXcSek?=
 =?us-ascii?Q?+ps9M5pjSc6VQEKaBG4eOSh+nPEs5eypxYxXaO0ildG3CIAZpJ2h86yq99i7?=
 =?us-ascii?Q?O7bWR3DheSvGG0yqSdanMW8qhnnDkXJYsqY/WB9nXDfJSGAGOaurXZbXnD0B?=
 =?us-ascii?Q?7g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Lp0MFowg29f67Iz1axGTr7Fp2oBqjTO6P9eY7Z12J5GciJ1Vd8rv8iFKH+t3xpo1SdkKnkbsfkQnvkUxoR6GQVovqrnOEbDTbCvPzY13lqCjeIspVSY3K2bINTxaOr7kGIzlLiRgtmIUpZT1RASHJYiqMZ90P6oqG9ThD9mivCsY1E+zgZg5fDfM/13EKip7Vjfr4VO38ly2Gb1GPi08fXoHH471dUJ6awcrTMpdyH+NQpKnq03h4ev0yFBFzadfQrfCYlhmF4c0XBvUfl8d3DhTay1kWh508527opALMehzL9eJD5GFirBHR5kcqCCi6kiDrkt0nOqMLgsZVXzelOiZs0YseqZziPwrUIch5YGG91q5/s++pL1Uz5eTI0UEXyWwrAcwtDvGgmG1+ivtCzzi9821h1ZUAzb8p9ckLZ+gEhV+ugCRiPSi3HLL5FHE+ZAdGEDt5M2dFyET4AV26eqwXAjfdOj6jCvOjdPHjTnlBnv9QPnPGNp7Ka7UFdvnWJZOYjD1EZTis+UuZ/P5WviYd94ABsJ/Ie6ocStFvr/lu2RFUIJjTSGz28OqxdXWlQ10DkY6woIv8vZlHJCrAkAKpmS14Cf5B+BYUp8EI5k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9586bf44-e5b1-4da8-57b3-08de120a3161
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 08:00:12.6072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BzB7vP7rwA8SRbj3A1yZpwOrfwyniM4yQ5SI0fMkCVt2/Wm6YhMBQmDxWdpbMRZeKvRKQCCWE9iXBgCsBHGN+atdh8bJnrH+45gViLhghM8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4230
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_08,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510230070
X-Proofpoint-GUID: 4hZHWSc3s4yJDYekWINkZclChLfMjwHz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDA1MCBTYWx0ZWRfX+og9brhzdh+J
 rKSl2L+h+e9q4yh0tCGUJ22GQuwjwh9jJGt3HGOl3zBSTzTel0wpz7kY6gmFxwU5zydH9zDuqAc
 c9BJBsKPBsWAPSSm652G0tnyD0zPEM8FjSsLdliOSm6q/W80rzUMwOZj/IueDCJELkZ0D7JWr/G
 FSKdVESrOwyq0tf83IdTu1P1igJ6pBK95s+qyjU/WXTFacFoiQaLk+QM7QycW9EoUeU+4W4lobe
 qDH+3pWtbOM1GjiWLF+GybxM9thD/VgT4D3H+X6+uu9f4LH9VTZYF/VT3Uppgjd1GEUumTTqUNR
 gfXmmCcbMjTsc4R7Ztj5I7KCPyTpnA/gAZVEWQuoSpYmURW4cO80vKxCtFtDcWGBykZ+KskgRc3
 7xMwFS7pc+LEaL+nWLqREtV70JfQBNMTo+CRJg1qkaQOO7dIdrs=
X-Authority-Analysis: v=2.4 cv=OdeVzxTY c=1 sm=1 tr=0 ts=68f9e091 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1Ej83D0HtKKX2GgpQDMA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12092
X-Proofpoint-ORIG-GUID: 4hZHWSc3s4yJDYekWINkZclChLfMjwHz
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0F8D080011
X-Stat-Signature: n9o3q961cu5p45tqtq7ezrr5wh1sfot6
X-HE-Tag: 1761206438-437380
X-HE-Meta: U2FsdGVkX19yNejCkCqrEyGIKM9qulDPjmctcS5ueO63OunmKx0xQFXeKO05655D+ONmQbhbCSKoD7ouwpwhQno4AUTRub7WFMzsjY3w5VI2R8GKOZ9OulvKtMRVaLceVIFouVDx996wLa/cJTB3GbZ9F6xfI1sRoijQGlXQ7MOIoznPhSnxiGOfDAj3+YwqLvQsXwEGnyfR6g3DUklDKhNfKPGD29MpjLl+eP4EItmzjEYmlwo6O5COHfbaAaLZicWfVVHg0ENZnuwCusBXq5SHN/ISx7WtLJRRWoAlqO/NQ9ePshypQlmGjh5HxJy+rJ/05j2VniapRJmrYHVIrCf2vYnes9zNjlOyV638uWQ5qlNu+jOk9sWlq7D5pZ4WppJuDYti5clzQNno+RU9USnukagghW6otsguTk7DDsWsGU5vs70iyPiF06KV7Yr2ZNTS1ldabdWqLYSfd056wEADcMVeY/rIiz6Z67CBh6VsZKk375xFNE6LMB0IH9xphFOIBXeEf2EJ1svVJcO+CuxPO2KB7bZZ+u6Rydx9/JAcbqt/35zBtoMSnD5AmF+qcWJy7tVsYUHHIqFZIGZmednPBPxkYZLiDwJqUk5tWdtmE2G9Af2ErFV4cuxzZbxWHPkbHMwtTfoeo9IvArJjs/Cc9F9JruD9iGd1HxB8GomLijZqj+flbevjup/NwlYCF6HVrmjZUnEpie/bDkdRtJAlgA7pqyd7SJlsGw8s5t+ZdYPpJ5eXyz7hPWf9aux0sH1BXjsQDOsEmgP93pAQprZDUXXvbLgFtMXLo2W0hBVk9DKsIk2y4Xg33H6lz3e3txzqwbTYK4uN6jQevpDkQGmesj+92GICxAKdw4nCFB4FdxYwPceCXoWL+i5qq7YMhRwqeE5iRwXjSjXPdarEKS4ODumoGGwYX2xiK9GeMYgzsRqIIWL13oNeTHOALj4xAmXcAayWhCBJ5Mrd2se
 HbcHKL9m
 6IBST2F/ueDJo2a06z5VNDgGCear+XO0WbsqVyx3a0jfdopW37ipR/dRFF6qjWFmHU6yK6Wk4OP0x+Pv5kefGky/XidcuCHKrAEBsRUpUpO5an+4lv7WZrA7a5Ooz1AaZRD9neMW6kyg5XGl9vBCXLjpMdKNK1XBOcA6qSsGjrx2gSISV5/VYv+T0fEs7MkJfcd5AHcdmb5oAW846wgtZZjVvvkXMhcn+9zSCr9Jge+FzJwkMuqv1fvOYV5L9m0yFVL3DQ7a/1C0S4qOSf52tFFXe+cF6+Q0KHwORXGkdiMDfk+ZiSB5Oa0PM0DuQVTS0Dr+kbh+RNp/JKLjw5iVPVo27H3jOnPKc+zjXKzDhK7rwdDGTId0u5z8K7NpmUVhwLuspQa0tI88yqwNzN1bUqIE3zV19UmotOKgQ6oAVpApU7w+vc5kwJ2E88tZ9Hk5zhJ3vGhuSWK/rIxLrjW9ud84qa3IzORv+ANvjGaobN8bKQ7PIgdN3+caZi9nYBb5frV89GMufVclWfybF2NnmEYPxzwNlGKn5DsGeL5MvydgU4YrLxtx4EL1vxqtqCiff2f/IHqld2g5QEFyV+Z/0KYjng3QZ+65jBy2ng6lcuirHjOPG62n8MfzQ83dYHVqhlPekjy3bdV/LMIHucL/L0y7JgUsSLYQFzOTt0sZCwGsoR5PjloXBMnKruh/eDgUC3VLf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 10:22:08PM +0200, David Hildenbrand wrote:
> On 22.10.25 21:52, Christoph Lameter (Ampere) wrote:
> > On Wed, 22 Oct 2025, Nico Pache wrote:
> >
> > > Currently, madvise_collapse only supports collapsing to PMD-sized THPs +
> > > and does not attempt mTHP collapses. +
> >
> > madvise collapse is frequently used as far as I can tell from the THP
> > loads being tested. Could we support madvise collapse for mTHP?
>
> The big question is still how user space can communicate the desired order,
> and how we can not break existing users.

Yes, and let's go one step at a time, this series still needs careful scrutiny
and we need to ensure the _fundamentals_ are in place for khugepaged before we
get into MADV_COLLAPSE :)

>
> So I guess there will definitely be some support to trigger collapse to mTHP
> in the future, the big question is through which interface. So it will
> happen after this series.

Yes.

>
> Maybe through process_madvise() where we have an additional parameter, I
> think that was what people discussed in the past.

I wouldn't absolutely love us doing that, given it is a general parameter so
would seem applicable to any madvise() option and could lead to confusion, also
process_madvise() was originally for cross-process madvise vector operations.

I expanded this to make it applicable to the current process (and introduced
PIDFD_SELF to make that more sane), and SJ has optimised it across vector
operations (thanks SJ! :), but in general - it seems very weird to have
madvise() provide an operation that process_madvise() providse another version
of that has an extra parameter.

As usual we've painted ourselves into a corner with an API... :)

Perhaps we'll to accept the process_madvise() compromise and add
MADV_COLLAPSE_MHTP that only works with it or something.

Of course adding a new syscall isn't impossible... madvise2() not very appealing
however...

TL;DR I guess we'll deal with that when we come to it :)

>
> --
> Cheers
>
> David / dhildenb
>

Cheers, Lorenzo

