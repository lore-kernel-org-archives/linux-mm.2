Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7285DEC1EA1
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 11:21:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF5046B0098; Thu,  5 Feb 2026 06:21:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCDAC6B0099; Thu,  5 Feb 2026 06:21:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA2066B009B; Thu,  5 Feb 2026 06:21:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B4AB76B0098
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 06:21:16 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5BCFC591FD
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:21:16 +0000 (UTC)
X-FDA: 84410161752.25.982DE18
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id C40E02000D
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:21:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RMNdIAD5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="HZypoi/a";
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770290473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LsvYWJpDoyu6W5rZrKba+MMesi0Uy1XBhgnlB2FJzws=;
	b=qbwnqIbe4ItzEmRCG54tYzF9giJ30B7teFFXKAyW5Hqm2LnOcmOqPoI3NPJcGnzQru59u2
	yWjIxV89iDplX14zNfMZmxv7A/jr7+8ymjt2lE43qMPHlqDCuNz7ONJ36CiuAetmQEIutu
	i8he5/nrjhzxZx0mmQQ2CXYembcClJY=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RMNdIAD5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="HZypoi/a";
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770290473; a=rsa-sha256;
	cv=pass;
	b=uP9F9FaJ0JVq71ObJnNuJ5V3Eb9bqd+z1gZrXwzB8F+2kxoamI7gTyrTfulohAUHIPIfZM
	jFTErKIsfwjWFX/NBPlI0PI8gU09RBsYYWB7QE3NpSl9GSvIVpR79DFOq5eogCiZaWWJW8
	E1OZ+t6duMMWWHAByE4N1OWwpbK0z9g=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 614Ka2Qn2731276;
	Thu, 5 Feb 2026 11:20:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=LsvYWJpDoyu6W5rZrK
	ba+MMesi0Uy1XBhgnlB2FJzws=; b=RMNdIAD5Fk9s2+gWLk+qYIZ4xLbBhdIV59
	Hw0HnoNmarpMhI+Xv97zt+Q6C6Ejgxo+376Lxx3jVHCTVRlvPbhQlhtLDe32cQnn
	N4fh+Lt2TcoPZiMhCkG066JoWkc7/QWkiLLznNdD3Fi8PozSzph1SQGba24WK7R+
	Rt55m6SUmHVW66zWFHZ6sIcbB9EFObW3JdHxCkILabeHAmpUKP11N93RwynWjQGK
	rtKStoHKGTdvdiFMMgkk7XJ33/w4w2TS2TWrR5SKKx1J7uU5YfmfwcYOLczG+izr
	7gyJhsktAesRFf2rLfgyAO7d4Ng4NnqTVgHeHuynmhAkRIS1+yAA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c4d9v0vac-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Feb 2026 11:20:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 615AplW4003511;
	Thu, 5 Feb 2026 11:20:38 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010010.outbound.protection.outlook.com [52.101.193.10])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c186d16s9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Feb 2026 11:20:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vFsQ7SJAsY3T43PQDzUHtjx/VJVp5/WReDKoHXU/RFbyEiT2JPntHOdBnr77Kp99eh9FQ6ztf/bPuEHOcEHpgBvREpSBtu/hbsxiEpuG52BYgCXWehXhU7J5NtODAedEmvPBpGtobOCREyUpU6TiIEWZC04vPn1jE3sh1Fg/FL6aVfMjpNghrTHef6Hkc40FFpo73wHwEzQPm9wreka77kO8ZSSeMfYPMDZCh+FFDhdUP0sWd4F9EXOzHkuIvIhQjY+LnfBebG+XjHV6jkmXxZNN0fvIkXnXzTCgSA1EvoHNnqpRjHr4MDL3oHhpPoNrqdSBTzeAKu26if7hKqOrwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LsvYWJpDoyu6W5rZrKba+MMesi0Uy1XBhgnlB2FJzws=;
 b=I00BkmBAN+I5deyiIyRfUJ6kc31EAeXX4oUsRic4oN1YNiZwyU8LuOIb0RYONScAAVFYQ9qbfNS2ll4kkkL0yc+ZbbxrkOpwZN16DabSsCG1EVyjc30K1m2GSLlHP7aPm9a55Mbn78d71uU4/RyLIBIiw9qr11vEwHef0MTQXnL80dCxJ1lR3N05KSJb6bg3fM4EPCFFMR9qm9kAPzRUTCJRKGosPcA8fcY9Q7SbCVtwfIMuCny1UcJVk6xB6NzO+TcVL4+Qyr3a/Slyy3VEqUJHOB/xKlPcdrlhzPPCkHwBaOsFhO/oCGeLG/pVydVLpPtYdkbaAipbIM8O6cLrLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LsvYWJpDoyu6W5rZrKba+MMesi0Uy1XBhgnlB2FJzws=;
 b=HZypoi/aG1IRFylXNF/pMwRU9eZZSMCjbSaDKdyxcnShZlNDqhY3cfVChEWrK04Q6CpyIopa9eZu/N+9HvSt4PtE2lK7Gfo7H9iSeb1CiMAW+WgXIjyj2ebJBLAZxqx5StsgBphHApotMtSoL7oby2iM3O7we9tr35xODAIojgg=
Received: from DS0PR10MB8223.namprd10.prod.outlook.com (2603:10b6:8:1ce::20)
 by CY8PR10MB6660.namprd10.prod.outlook.com (2603:10b6:930:52::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Thu, 5 Feb
 2026 11:20:33 +0000
Received: from DS0PR10MB8223.namprd10.prod.outlook.com
 ([fe80::b4a4:94e3:f0bc:f4c9]) by DS0PR10MB8223.namprd10.prod.outlook.com
 ([fe80::b4a4:94e3:f0bc:f4c9%5]) with mapi id 15.20.9520.006; Thu, 5 Feb 2026
 11:20:33 +0000
Date: Thu, 5 Feb 2026 11:20:33 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Carlos Llamas <cmllamas@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <muchun.song@linux.dev>,
        David Hildenbrand <david@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
        Gary Guo <gary@garyguo.net>,
        =?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>,
        Benno Lossin <lossin@kernel.org>,
        Andreas Hindborg <a.hindborg@kernel.org>,
        Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
        kernel-team@android.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-mm@kvack.org, rust-for-linux@vger.kernel.org
Subject: Re: [PATCH 1/5] export file_close_fd and task_work_add
Message-ID: <9d0d6edd-eab4-4f31-9691-78ed48e7ad5b@lucifer.local>
References: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
 <20260205-binder-tristate-v1-1-dfc947c35d35@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205-binder-tristate-v1-1-dfc947c35d35@google.com>
X-ClientProxiedBy: LO4P265CA0016.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ad::10) To DS0PR10MB8223.namprd10.prod.outlook.com
 (2603:10b6:8:1ce::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB8223:EE_|CY8PR10MB6660:EE_
X-MS-Office365-Filtering-Correlation-Id: d801c557-6e92-4ea5-c7f9-08de64a8941c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Xv9me2K/17I2vkWt4UlCPCeIChYn8vzJmzVF4rLgdf4z+iXrQcepgGUx7G4j?=
 =?us-ascii?Q?6nK/mFyAYkuh3Pj26732uzdBQq1yoqN/EovwiSSOI9bpYbUjxP59LfdJH2Oc?=
 =?us-ascii?Q?1IdDhBOmJpQGj30r8MJD+xACIhAtqtSQj7E/+E9hHNBW5oTKrKoVmpHNnOGe?=
 =?us-ascii?Q?77jnjb7sPSQZYgS1tgts7y2xIy8Yrdyq5m6Ia7hAnY8/C0XWp1RAVckOvLpO?=
 =?us-ascii?Q?gkX6aDMk3t7efL0k+c7wUoWxUjY6vD654sfGSbwYaroHJY/9DdwBf2MjHeMU?=
 =?us-ascii?Q?uq8mFExW+tf5MlTvJFwcSC/Fpvcgn95IvOgKbZMI3UlVa3fMcT7EMh8ruAYo?=
 =?us-ascii?Q?B+We95xcsFvrevtQI4t/TG8s1qSbbvTxPgM8IgOcqUgAOYJDaM73JmZtrcME?=
 =?us-ascii?Q?B1ehXT3vedKAOo62dKMCCI0EhH9o1VmeMbALmH74PqwL+7HOZ9Sxl3O2mjQH?=
 =?us-ascii?Q?nDuU4RLOSSNaWaGQBuoq+SdBZmGrS4hsxidLOdls85WxOb9TVXkl9cQiMX06?=
 =?us-ascii?Q?GUrYhISKRr6Hy8g+zT2O3t0sFj1KD4VfEu/u3JzPdikCSV+lTRRmYeMp28/P?=
 =?us-ascii?Q?xmanOtTfV78s0ZEJ35NtGhWKiWfL9+XIPfz4H+b6+XSshZ6GHWTApilg4H9A?=
 =?us-ascii?Q?iutXXfP2rl6D/Z5/hrDI9uYDS6wXdT81mpITKFwxhe16ArPtU9x/M8cpywJi?=
 =?us-ascii?Q?vYzQIrGpvCUeNKYz5HnGoP8Sadn0rXfY+Ka/3rrC6q9UfEE2XKMv0iKEZ13Y?=
 =?us-ascii?Q?nRT8QPww8cL8L2qNanBJM3AjauFgMx8tFz9Q7F+lHvsIUcsE2Fm/qUl6wn6S?=
 =?us-ascii?Q?CzxN7skBsIXLkQE9KGTQHdfC79HJmunIX7w55v4vEZPHrerzeQhQL4TiqEfu?=
 =?us-ascii?Q?QLUXxHLF4o2BNY/B9pvcPG5LdmPIl5Phf/uI3XxtcvyPVgK/rRmxGe+lQVJz?=
 =?us-ascii?Q?Br/qaab2t2VetwzjGNJIxB9U1OqBtAlOMX2chZPc4WacBP07AjFPse/G7C8p?=
 =?us-ascii?Q?dcHpR/kDOpgaxsJ60bd4uGwWHwp0sH+MucCTAhUJA3NCxeD54yee3RH+en8Z?=
 =?us-ascii?Q?bmG+NJFQUBsZm2GYUiJEfYi98PtEyOslN20YAYy7fvc+jtRb96GF9hT/z2on?=
 =?us-ascii?Q?JBLymf8hh0HyI/WuiJ+psK+bTSG0SRG63VtmmDBs2f/6FQPOZ/ZEw4qPEMiO?=
 =?us-ascii?Q?+KrMyMrdzRwBXZ63mvi0WT2MbpO/KQFJBqapCf/6JQWytwF5utCTP/4Rj+Uw?=
 =?us-ascii?Q?bxy+AU1EgZM9VZPeQO//LUH5zQO/YR2K8zGERPSvaRcbWbsD1sd7mH7gjdVK?=
 =?us-ascii?Q?4GwqxWhBUirZZtpYutlTkLfWXUgSGNuw9QbutzQNwf8NLuXmSK4XVk4lIJF1?=
 =?us-ascii?Q?mcLASvcIpgZEJIpV0II7JScyPoeCYzq/oLr/L5sK6dV9jmcKCzT6g395cTRz?=
 =?us-ascii?Q?cdDJ+AuzMe665kIvjM2z/sxV7K+zBPCsVO4Z6JuqQ3nUPhcvcWVbrlbkPs0b?=
 =?us-ascii?Q?sjveCQgWwlmdupVM1kkyk+hB17qBRU74gYaXoZkFhZAdNANJqWYbgdzDtg/r?=
 =?us-ascii?Q?AEFxoqh3BlA61aFGqjU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB8223.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?I8EC2/JQRzbWXVLfpDOcu3vz53ZJJg15fcQpshr+q2j6ZpNSK6AtMmj8LiTf?=
 =?us-ascii?Q?MvZXdsIva5bWF7Im/V9JqD1uHPoNHgIQjIJM+S/WMsHxR2jzB3ex4tJADvsp?=
 =?us-ascii?Q?/e8UoinfPFz4yR8K/f/1R+oy/p8xfE6UJIF6YmpZmvfnYNkUqRCXS+djIX7q?=
 =?us-ascii?Q?Gb4471m+fHkkBR4SomYv6TFIXhSn4rtRPjrwOIoZMHTMVebPIWtukKZEfnni?=
 =?us-ascii?Q?iTBk+//gCEwgFiG3imd3z+IxpxQlkgqCfc7ERxp8IteG7upCgJcvWC9Ztwou?=
 =?us-ascii?Q?ceAT5ykq9Pv5tBCqqWtco4CkRMUwxQtvPudNx3+4CYCS33penYG8AV+tggd+?=
 =?us-ascii?Q?xm66/mlCtGkXMX4L0ytO1bAFw6U7BgpiXKmm9SLUaYHSS5p/8Sz2SWwnT5qk?=
 =?us-ascii?Q?9iCjhT4hneRVH1WbR+HIzRL9o9PAO3nHtlv4zUh1dk8KwGa/74k40hA0o1Ul?=
 =?us-ascii?Q?gkXSL/r+N1br1ZIjOYCQO856CTLFCCmoMNNVqCyr8so68mjKLBDIGsjuysuH?=
 =?us-ascii?Q?YiZpl+gpO0XBv/SMNQcebIn1yBKE1kyOaCHnQWIZRxitjwmcBhdBldRRYzHz?=
 =?us-ascii?Q?RkQVlG/HYfsLt5S/OahJsSnGlxRL3IhoqW6gfvlJQXWUnLoC0kHD3ib1AkhO?=
 =?us-ascii?Q?sYq7NVJXpQzM7YrUzRwvBTiDMhnCN9ZIOkbGQRznENTZDU3jsO+A+swIng18?=
 =?us-ascii?Q?jQ8BgceQ5g5lauF8HvIDftOb3raR9fxOWtF+uMYuDSHrSOlxOURhdPdcJcxL?=
 =?us-ascii?Q?l51GQ4XvXRwHYQZsIeOXXgqXmrKjSqWP33ZGhtMvr9CUfnuSB9aNsn4oQfud?=
 =?us-ascii?Q?4Y9atI5uC6hYg5Z1NxRiAEsMN/0PKoDUEvPVsDOOqZ1lcmZwMffW/1dW/PYt?=
 =?us-ascii?Q?FpuwsS4DkoeiSHjDS31UZPEBgvqTGXg2/AHtzm/MxLZoKHtl5z9FrAUzuApN?=
 =?us-ascii?Q?npMP5NN7zP65Wca7CP5EI3y7lZs3PpClRZ7GGLzVU3Vivf/0FBxGbbx/u4Xm?=
 =?us-ascii?Q?6q0X/npqWxPCFD6t/JFKWlg0XkeJJvVXipcSZVazOwgaxFDFslYxsjt5dQlD?=
 =?us-ascii?Q?WtgfrvqmX6XIgoS0Bj3R/AzVTsvc9FooyJsB8R8N5fEL5FRzvxsqnzJltr7F?=
 =?us-ascii?Q?ZKoVM3vEHATNvuE0VHBNgiuSM6Fri37KAH9u1whYMKYIU4CH7C/1L0k73bhp?=
 =?us-ascii?Q?3T0HHVLnh6zo8wxFApoDDEW6wMrCytmo4R65LBRdxFe29lh1qqppBfEPNRx+?=
 =?us-ascii?Q?sAD7ZJnE5xxtYxRJwWOY/4Lcu+4rk9zm4LfxohDn9GLZhywF1vJIjxnyqksy?=
 =?us-ascii?Q?iZ0hbp76Kfn8c8tgLYD/PTujFqt7TUzHjlBo0MkwL0tyoR+N7LL4ssbrwqkX?=
 =?us-ascii?Q?6skaDQfcNbLLzRqgdROyQLslh/h0IFWVwNwWR12bz23+jJB6gPMoYbTYWNIS?=
 =?us-ascii?Q?q+BJkqSV25zISmrNlS0yA1AhyLKrCqfbxdcgnQJlQhGD9zaqI9FYjV0aWkJW?=
 =?us-ascii?Q?ypjL4KSrQzublsqupbukDOQVc4nKkaJ/MvDclhRmVDE+oS/UmBvdKLa+SHkl?=
 =?us-ascii?Q?1CwU1Ew4xAU3vH67nCVhFAi79ziOWH4PrIcHe9i7PiBsjGC8gAXShc4APsem?=
 =?us-ascii?Q?VUOmFtk3VITtZP5yVA5WcGRpass05ViVgj+yGHOKGECPlR7dcxXgVCsG7P1B?=
 =?us-ascii?Q?PleYc616Qu5hynKCFXj4QDXZxbAdCKSOYhd6qzmmXRBUnX4SzJs+LVwnf97H?=
 =?us-ascii?Q?B9Peqts13VhBSHWU/MKPNv9zJHQR5Zs=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mjjRsvjMFqGcSvXco0Ldi9Eq+8BzfThBCX07lNzsSz+kRKsQkKBUqWSWUQXcrqKiNsdJc/qbVCsmEoAs1GL0boIiWg0XD55zi83pZGBHB3wU5eBw0MhNMquinsxiXrSB3xU5Ur7W6ePBt09HFemDq8tIoC8b4IL+KsdBeELN4ddnDvyNUzIAON416UoPkdombY8bIV9E1r+YAhG7cjscHlqSE9zP5mdWU1tvJb7m19D1zkvx22Goj9QuwYhp466BlZX9MEi09gyxLaB7fGfsUXMUbveRjmua4ba8b2WgUNQfxhziJpqG/W+AYjzzyOjIAnqZP9T6KhqaW7ASBc3kZL6GK8LuQeC3jD4SV3SzJYQL4xC2TP9B6GEtAMFQdNCHhCvOLYjESxsUxMeVSoahPRdB8ew8qJbEWfkk6AJcDbSxr2lgdKR5LpF5/l6dFOxBWl+xeqcm7tkMtVHj+LNfE9/XdGptqLMDdBqcbeSWmbA3wUrAFFDaZfwbI45fxRhwF657YSrV8bvT3Ejc4AA2xAMXkh5zLQECDCNb6oSiu17JENFjKnvEayxPY4Ej4tuTmZs2TUg8fLVk1WcEcBOCceZ9EmKg5wSOK8eVhLF2d/A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d801c557-6e92-4ea5-c7f9-08de64a8941c
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB8223.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 11:20:33.7419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UN0VL8/96CziumhMTQcvNq/2PpVLSsYR9FWlNVmYo6JttD1PbWxjOGCo0A8sPApL9dxAx/BYkTe0txriPlO+uh/SNlu1Bh4WL0A9GY0JCEI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6660
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-05_02,2026-02-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 adultscore=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602050083
X-Proofpoint-ORIG-GUID: g2Gnuhjm2PP64yQPz72Z1KqFQzdffHqP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA1MDA4MyBTYWx0ZWRfX3RBnf8spokRf
 Ka01F0pSM04dttBR8d9x2GDW0LfkL3GhFLI1K4vm3/89R9hqUZTqRcKjVT806WInClFKRim8rPH
 95t86M+cdkaK5eyH3j/l3b1s+5hwOlhmIGJ3xVfZBIHRVM1p+LXNr0km8JwWwPZbnABsupYlRfl
 hrmPZJZWH2fKdRJJqRGwzVLW9FExMPNYNvTIciwUurSbx7LgAHnW9ChsFlyp6Aka/5nBHFkkREk
 u7BRneEGpd5COjVUKrYPvzh0MuLl9Te4UzxeFD8k2fcSPN/M3R8rQXhCLb83qTYyBFZDNPT8qkN
 AW1YiD45obU/TsLdsR9xTz+0IG5yiLdz2yQ7EkhLVo/2Qnrj/OqlbmlDuo/j+E+eI/vGZycV40x
 LYTTgfWHezfhIJu9P+qE65x6l3YCjUULPABHKQ7x5WYTGc+C9Gmwj5TMC4SycYlMBD1vZ3mXZVl
 k8EK0ca36BkEN7cIN9Q==
X-Proofpoint-GUID: g2Gnuhjm2PP64yQPz72Z1KqFQzdffHqP
X-Authority-Analysis: v=2.4 cv=NprcssdJ c=1 sm=1 tr=0 ts=69847d06 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=1XWaLZrsAAAA:8 a=3e4AOni8SjVUjLuj-NYA:9
 a=CjuIK1q_8ugA:10 a=1CNFftbPRP8L7MoqJWF3:22
X-Rspam-User: 
X-Rspamd-Queue-Id: C40E02000D
X-Rspamd-Server: rspam07
X-Stat-Signature: n9s9uyzupqd77bq6icutkzd9hqbwd3mt
X-HE-Tag: 1770290472-515405
X-HE-Meta: U2FsdGVkX1/n5weIRYmy/hdMu8dMW+MmS1ZdLFhDQeIMjcLZk7NdEId8NMj1aPlae9UUuWOkV4zVLY38XRKNFm+8BYcybVDePJX+x1Y7Q/Vxc2xbbQN9gMAEXhmUcJluk6TnM25x10Ar3A3tWY14Q5+vNc0GPh+gcwAHyylg0kMC8QMgnp11S9J2ccOMyXUvkgnkcFJ0U7pSNXSqUboXDSOyGZG9H2wYqYCM03tTaJcetqNs6fnvWHDfGXiqSbdcW1JgvtAUJA4ylt4x2Oy/nIc/DBZgEGGVC7dZymqz144ruZ+sxUxO62pcsf2WozB7rwIuX9Na0OedF/JlMsuRhIdFBMTckaIEq0nqiEOb/zqpoW7Ns9mEjCHu89eR89F9OrD/T+C2d2c0yLWT8EMauvJ5r81AhqApfxYT7Es6Fapq4Mu0+2AEj1BGc4aY9XEsTonRGTVljTsaczOdhu4Tnty7RROBMtz1szTawyTHkSTxUauoZCQOPu254gl8URjtJG6fEEBNvqg7TKyanhpf77glVCvgpitRit09dWVhIrNspPeHj9JEfBEuQrEh0F8CLf3g7VKgdvHfTW9uXwp4t/p8JlAr2F0SglIFMOGH8FjenUFUjXe/9DpYMyTitXgzqLQvp32ueQ7egqi5RlRJokk3b4Ga8jylOWnLAkoa5dyjt93gaPxJ2M0y1tznhpmfcZP7rhzX1nxILtbADzvBiECsxbPcAiJQ/XdhlImVbEMbjNA3M/xAXG7ediuV2KE53A+4Z/vkSxNGhB7cCVAr0VEzwiaIUz9gN7YR9uIk0vZbAnYp6iCviuZoQtqU1TxjtsuFZimgUuMoSWWNRdDz0CEeZaW+aDFC/3Uoe/xiGUrUx3vBeBpjfMT7zvlhAmzcOh6HaCCsmDt1eO0ogMHJASSCzrPM6NJ3V5DoxpzsHpP4fl3ZWXrm9XcNXKd5+E5S2FCD3Tmx89NtP9KMPMu
 Znpa4Qfl
 ZyZSY+sAtzMAtV7+KcU1WMTwBtD9P6jto8PprdjzFFABERg9H6LxCrJyhVUKfLp2qfUYGj36MYvtJcmP4BGsdu0ONn2DY4EyF6FFOvQ5SHqJ0WjqkOLNP2cVxXsyOFTE14OrVhXyO5jBIXfg4zGjjjfArqZJqVnHay9pSRKC6U0k/ywPm9F9pcuBJpC2888+avbrvHwfDCdHchP0DpOT8laxOHoM3zHf9irWXnIOA3LKofwrKEdbBKRILxr2DKfMtT38m3fpgVRWGjTuDu3LrZi+w93YZDK1LIn0bbNYXdBjoArO2FjfMnZ/3FW7J9YOyShjbya32yXm0xNMTCsEGiujE9k/xGBhmizreb7v09x0D3UPFUIlHRYNgASv2VAsoFGSXHgB0Ad9xV2Hq4azo5P2TldfVswsCwQqtwgf4Oo2SZMBmm8i5qQw4hvFl5lYNGCpLtJxJMb0PEZW1xpB+LJAKzIjaBhkRWqTGWoffPLMU9Zpx8g5ZkvVhvzfqnivo8YnqRbBQq5zqPjrIIvBHSPUd96vGPeyM8L5LYJiz9rJgLztmvUT4ds6Q9yhnQUT7YC2UVw4nF25ojJZSv1pG4hhyjRNxcQ7OJfYNG2SjwKScK8OVuM8v8aUlOD4m4/czxm4sy+7pEms0q6tgmCrjGXT/R/OP9u11Alip9udQdSK/odmI9xU6xPzpY641bi2vO4wsMY7cV4mWTt5JwIc2S+ARK70JvvSXUlFM2JnenZaJaJYOMRChJngep0XcnWt1V0LzWCrHu4LcMHWi3iiB/lzcmO48b7xrygfCqUgrwU3Vb/6gwMYkch4FPw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 10:51:26AM +0000, Alice Ryhl wrote:
> This exports the functionality needed by Binder to close file
> descriptors.
>
> When you send a fd over Binder, what happens is this:
>
> 1. The sending process turns the fd into a struct file and stores it in
>    the transaction object.
> 2. When the receiving process gets the message, the fd is installed as a
>    fd into the current process.
> 3. When the receiving process is done handling the message, it tells
>    Binder to clean up the transaction. As part of this, fds embedded in
>    the transaction are closed.
>
> Note that it was not always implemented like this. Previously the
> sending process would install the fd directly into the receiving proc in
> step 1, but as discussed previously [1] this is not ideal and has since
> been changed so that fd install happens during receive.
>
> The functions being exported here are for closing the fd in step 3. They
> are required because closing a fd from an ioctl is in general not safe.
> This is to meet the requirements for using fdget(), which is used by the
> ioctl framework code before calling into the driver's implementation of
> the ioctl. Binder works around this with this sequence of operations:
>
> 1. file_close_fd()
> 2. get_file()
> 3. filp_close()
> 4. task_work_add(current, TWA_RESUME)
> 5. <binder returns from ioctl>
> 6. fput()
>
> This ensures that when fput() is called in the task work, the fdget()
> that the ioctl framework code uses has already been fdput(), so if the
> fd being closed happens to be the same fd, then the fd is not closed
> in violation of the fdget() rules.

I'm not really familiar with this mechanism but you're already talking about
this being a workaround so strikes me the correct thing to do is to find a way
to do this in the kernel sensibly rather than exporting internal implementation
details and doing it in binder.

But on this I defer to Christian and Al.

>
> Link: https://lore.kernel.org/all/20180730203633.GC12962@bombadil.infradead.org/ [1]
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
>  fs/file.c          | 1 +
>  kernel/task_work.c | 1 +
>  2 files changed, 2 insertions(+)
>
> diff --git a/fs/file.c b/fs/file.c
> index 0a4f3bdb2dec6284a0c7b9687213137f2eecb250..0046d0034bf16270cdea7e30a86866ebea3a5a81 100644
> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -881,6 +881,7 @@ struct file *file_close_fd(unsigned int fd)
>
>  	return file;
>  }
> +EXPORT_SYMBOL(file_close_fd);

As a matter of policy we generally don't like to export without GPL like this
unless there's a _really_ good reason.

Christian or Al may have a different viewpoint but generally this should be an
EXPORT_SYMBOL_GPL() and also - there has to be a _really_ good reason to export
it.

>
>  void do_close_on_exec(struct files_struct *files)
>  {
> diff --git a/kernel/task_work.c b/kernel/task_work.c
> index 0f7519f8e7c93f9a4536c26a341255799c320432..08eb29abaea6b98cc443d1087ddb1d0f1a38c9ae 100644
> --- a/kernel/task_work.c
> +++ b/kernel/task_work.c
> @@ -102,6 +102,7 @@ int task_work_add(struct task_struct *task, struct callback_head *work,
>
>  	return 0;
>  }
> +EXPORT_SYMBOL(task_work_add);

Same here obviously.

There's nothing else exported here so this is even more questionable.

We want to export as little as possible, and I'm not modularising a driver,
_temporarily_ is a great justification for doing that.

Sadly the moment you export something people start using it :)

>
>  /**
>   * task_work_cancel_match - cancel a pending work added by task_work_add()
>
> --
> 2.53.0.rc2.204.g2597b5adb4-goog
>

Cheers, Lorenzo

