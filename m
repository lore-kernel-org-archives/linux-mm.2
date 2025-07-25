Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E38BC87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 18:41:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DA216B007B; Fri, 25 Jul 2025 14:41:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AA3F6B0089; Fri, 25 Jul 2025 14:41:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 771B76B008A; Fri, 25 Jul 2025 14:41:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 65D206B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:41:30 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 17139C0905
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 18:41:30 +0000 (UTC)
X-FDA: 83703655140.16.BAC5B31
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id 940C1160002
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 18:41:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KyF3+Nby;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=LWPfGzwu;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753468886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YYSg+pGwV5fLhXP8j9NbDYXRysE4ntKglIkbR62/83g=;
	b=F1NPmXeB3ttxRVtgVFu2jzUSkMT7U30Sc9khteS7prG9UEGBOzXkpAvkhnrzpwIk+03aGz
	s2m9owt8Up2/3qzYSeYnNs5UMaJZdwdQITsAJRW4wbEiUUx44UvmXOAuqQnChRqFZeHJPo
	TspI8LC5otMpXOm4ssOH1Ct3knzjw94=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KyF3+Nby;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=LWPfGzwu;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753468886; a=rsa-sha256;
	cv=pass;
	b=MrPbyOzPVCtRPaqHtpz/AfVSvgMg2B6rlyV59CMg1XxAn49XveVSMWrUh68OFkbJLQlJ9T
	tmeiVavTrshMF1g7RN554a44qqRxLFSFwy6CcvmKGNXJMZ7rWP8V+hj0y703BKdmPMq+GB
	NCJXBMEvupmIMr+289Jic8LqiXLWMl4=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56PGC6MR007398;
	Fri, 25 Jul 2025 18:41:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=YYSg+pGwV5fLhXP8j9
	NbDYXRysE4ntKglIkbR62/83g=; b=KyF3+NbyjZIyyKBgeK2TNVCO3XuP6KcSTx
	4keVNWecx/YrpG3HDEX2RIJF5TofVjfeTsBJAcWQHxrO2Yv7fdPvWFvPo6Ls9vbU
	w4goA8l1OD+xcMxAAA5GECqOOwYWCGFWM6Qn0LoqcyMdO6wjM6ISKe3TP50LfG5y
	sbW5uqDiwiOqJPAwv1CM3tPEFJGzzvoJhFuKwx39uDs/bSGzK3BrQVuJ9l3p5h/6
	+cuhDibQXOvZT2RGW8ngSDfzVAgF+u/TdYITACaiPVrZqEKyciX0fD4oasPDA1RD
	rOICdQ1tEQTmEGUqYIzOTsv7bQdZoKrkbNRKyI8OGn9QQJrZX7jw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 483w1k9ntj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 18:41:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56PHsotY038403;
	Fri, 25 Jul 2025 18:41:21 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2045.outbound.protection.outlook.com [40.107.92.45])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801tdf3n3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 18:41:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mx9H5QglU3JvmBgvx5vH2QEbRAKM06JgGZzms9vX4jQbdSku19M+w+qa8jG7KCo8pzNcNyfWd0s2f/dVwvaaVdYDAkT6m1mL+5SClhQAC6mMUoOFpOO7ZvtLxZXKrFqvJQ96p7DumCuTaQRD6yvA1za2nldkLJWDt2g5dX1eJAxaWZ0YgGahlr2SnoYK0ZumWr8uhzM+SlKDYly45CzpIg/nApkvQ5zq3j2MJTk5B+z4BrH2iUwKns/LO4/RtjSuiQ7+Ysn+G29eZviMxVW06hczfSndl5o86oyAIfnnxmtkXzvTRkk7HYCp/uNRoIpmHgY6SDt3cGa1G9UuuYCoIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YYSg+pGwV5fLhXP8j9NbDYXRysE4ntKglIkbR62/83g=;
 b=DNNFYdoJzrIlIsiTvixkCBrEVZ21rGT0c9ixlHi3y4e7J4jEjnOHSIkO6XE79vCN9VI1DZPwa09jKXYzV0r3eiIs3DEnElwX4f9erCJ6NNjGfMB8fHfne84w/QyKCidtPAw5qGRZp3Kr1vhufqHbMyV9fttqi2Nej95EI6iVSYqF0Mg/Ea2VtpdpTKmtR82GFpvSABRfAT6yCItJNTzNx+vYGsNmlnB0yetfjoCHfWwASaiovClQuSemnSZeYHLq1iKDeaPX3qyGix64gqkFTVOVVq2hXQQhXJVwMo66L2GwiOdN5jzXgneav2XhNk7YlKOdD/TM/MNT9hCKpXbqdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YYSg+pGwV5fLhXP8j9NbDYXRysE4ntKglIkbR62/83g=;
 b=LWPfGzwuHIxdee6LWMvnIlwUXY25QOSAdSb6EFbCq94K1hZ0EJdmvLZatDAc9TxWhNrywhLJVZF4x/9EvKgcuId2ywmxQuLt/jlIVkQMt6yCVUgN/TaS4n3jmFXM1YvKYqYvDHTWqEeQGroyz7BZyDzQdm4Ni7uCRC6IRQtFHMs=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ5PPF8CB762A0C.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7b7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Fri, 25 Jul
 2025 18:41:18 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8964.023; Fri, 25 Jul 2025
 18:41:18 +0000
Date: Fri, 25 Jul 2025 19:41:16 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Jeff Xu <jeffxu@chromium.org>, Kees Cook <kees@kernel.org>
Subject: Re: [PATCH v4 4/5] mm/mseal: simplify and rename VMA gap check
Message-ID: <d85b3d55-09dc-43ba-8204-b48267a96751@lucifer.local>
References: <cover.1753431105.git.lorenzo.stoakes@oracle.com>
 <dd50984eff1e242b5f7f0f070a3360ef760e06b8.1753431105.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd50984eff1e242b5f7f0f070a3360ef760e06b8.1753431105.git.lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: LO4P302CA0004.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c2::9) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ5PPF8CB762A0C:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f4cbee1-2005-4051-78c8-08ddcbaad7f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?P+20FedJHXXNVCSGI8DlrWLiZR8UePGVhuNTdAQXPswFBI/b2JRbsbLMDm+i?=
 =?us-ascii?Q?RxilbB2nzUdfCghmIdyKsWrv1fVtjUZbdUgRVDi8tpOFEWt2WwM/xZunUpxt?=
 =?us-ascii?Q?c9kDGK6vOaurg30vsmWTnUzxQjX665Qt2Ur1Y1EBOu/xnjOilXO9cukj8Tod?=
 =?us-ascii?Q?ReYc9UyRDT3d7CbhrWcC9mpeK5D/H3P5iQZHToi9F1OecTlsVYEn7EoD0NRE?=
 =?us-ascii?Q?c9JiY2AvhPzyHpzJO2Q2cAbHCzPC9FG1DuDy/RkapHDHwmZcoymJTe5/iKU6?=
 =?us-ascii?Q?ytLuzWftexVf/6M5N3ojfD6cb8Kcnp7Y5ii/OOG/aDmwLUQ4S3++fcFuhCX6?=
 =?us-ascii?Q?Z7BKdNeGyl7jQxL6Izu4DhJJfbwF4b1A0O9CRt/ng3LU0ebkf986yLTAupPM?=
 =?us-ascii?Q?xOuvTj4zeOvchDwJNT5E6exAkHrBd7+x+7Oh01w5CeGdeyyivHBia2hJ1GM1?=
 =?us-ascii?Q?mr9Ed2r0pX1cqHvXAUGPiYL4VLyE/pKeC4ygVPco7Ev6yKTeyLUe708npml2?=
 =?us-ascii?Q?dVu6AAlv2+arr2WVtMnes/T1UTOHDrOtPKupYFAgCALiW6a00hxUCK1oQ7TN?=
 =?us-ascii?Q?c/WnF1konlQ+lutbFjpD7afTGB8OlE7PHgarNzvW4DA2pQnijUDnIho3QG8Q?=
 =?us-ascii?Q?/iOaNRa/78nTREMZjR9264pXp4Qrld2zqmKDcYUaWqMrd3RFskz4eviaWUWG?=
 =?us-ascii?Q?l9PsNtaIx9py0on+8nmUDrA89DobgWoqSQOU2dWGiWZNDuBQMaLK8FN0pmD4?=
 =?us-ascii?Q?BlCyoYg+hzbYd0sfirt0IuFnbqW4s8TPohY9W5rS+m23JXZ/MSldiuJ/Mcfz?=
 =?us-ascii?Q?MM82Jb3mjNCPH4t/UZA8XlfTAZ2Twp2fVtVMj3G0dPAnewK8G/gnVECSunmZ?=
 =?us-ascii?Q?uw5HFo3j/8TBvSW9c3/oTDCs936x0pj8L7OkvKIYm2/pRbkcX/JfwpXYQyOk?=
 =?us-ascii?Q?JU4HaVbRXqrgELMb/eJv5BvIont/QFLaDnzsouJubnXPuBpMio4/nYaDFfuc?=
 =?us-ascii?Q?hizSxLkQkLfB5nafmQloqbDQfZPfudV8s7Y6H1r4WeSRyuFNZf7cpQccKfo7?=
 =?us-ascii?Q?rBG0UOMDeMez9zUoh+sa64vbJCKVr3BLQ+UvPCl8F7aMUtYFySWPAxQ26iaX?=
 =?us-ascii?Q?ZywaiePgJmfF8WDRSB4xf2lCIJw+lTV387SPqDob64rPw0agzVhVM0wLkuIX?=
 =?us-ascii?Q?YmOtzFK15EcLGNITm1IOXtw5TAVxE5DRWBfUbRdjLI5iiezJGcqw4kz89feo?=
 =?us-ascii?Q?DeJQwRD8OMCMIwlW4gJEhqQHl0fiPCJfpR2iwK1YjksMw3YTw8Iw8Z3d80BG?=
 =?us-ascii?Q?+dCEp+MmHh4D0WWFdocK5/eJKyfvCQwXX0xUGKlNmyedGaV0VAH65ilBiXmQ?=
 =?us-ascii?Q?vRkR65GZOh2Q3MRsohu/LgyrRQswZCMBDn3jhx1ydWfz0bkiyfzlRaEUdrak?=
 =?us-ascii?Q?Hs/98tgi1GM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qe4LkI+1kN4ssCcsEy5swRTpl9Rrb6MfrYzYzNM8/3lzni2hzlBh64L+TucB?=
 =?us-ascii?Q?NgxSkJHtJb7PS99a/k6JCg6G8KWt/o1VnZNWEvOZXxHHWxQjMoCVGymqlAgx?=
 =?us-ascii?Q?oPYhGN/9LsPu9f9MAfadFCoV4iC5zbBlDcuTmwqhWZKU14/ura1VTmRbw2wh?=
 =?us-ascii?Q?hgDRthelmUt1qbfnZeG61yZ6cbOlPo/p5Xp6l3tnZYrxfRzlzWN7stuWifsS?=
 =?us-ascii?Q?Yirii4j7v5UnPOsOuRO1YLCEPysbeflOXl1QvY+CWLNcmN3+7HH+EmAy2FUw?=
 =?us-ascii?Q?ar1pZ0URt+OAPQbuQ0VlsU3F2laI6VucMXd5PqqSL1RPCMCEpe58q/kVDfzI?=
 =?us-ascii?Q?qatB1Nv6Wlt0sAS7rf9WnrewBxdR7PllLniDVK1uhGJm7IHGE7pE3d6+nKku?=
 =?us-ascii?Q?dHhCXtKZzH5L4KUVzB/ARJKkYfXpxvdQ2s4x+mG/l//ToyurOt/eFPIjADxg?=
 =?us-ascii?Q?n0xLcPfFK05iTc7V+Wqqb48T90cT1LmSD6DstYSJ90ZwHClz1u2Wo029aUcp?=
 =?us-ascii?Q?GZlhmVcPZFSDMoukeC51UrXGb14E1m+/BqPd1gfsjMKj8GiUhYKhCqO4metg?=
 =?us-ascii?Q?KR7CoWdolNxfKj+ECC7Th1m/W0/iInMfthyxACDnSCXZm3cPoHtM/eoNcq2H?=
 =?us-ascii?Q?r6iFpd9P6JwwFxcogy6aZsoyQQ8Wvi1/FhMQGkwHVFykvfPXfpOIBE0TREaS?=
 =?us-ascii?Q?JQL/ORaW7cmk+wFIeqAUkxcKZyZm1d0gszQBBojnbdlpTp8oe+UzoxotBeim?=
 =?us-ascii?Q?oUnVCdAan4YZ0OE86hwZ1vyDXF1K8D563Zd8WQBAn4rf6aFjD1u+hhpLMq4r?=
 =?us-ascii?Q?PCNpulhwBjPiAcPGe+ChQXCdJs7BgE8/8al81zqWMvj2IumUQls6knw6PzTD?=
 =?us-ascii?Q?plJRbqw/q4L+DWgAxWsepE70ndcIeQKiC64lc8g+sFmRtAvebYf+XN4lBMhP?=
 =?us-ascii?Q?LrVl9Uajm/quL9jEVOdUIZzviJCmLjZenPk8PiOoHg2YBUC4rOwLliSiVsOg?=
 =?us-ascii?Q?w3OvGkJZPJw4JcI9XLhYaM1qJzHuhHJbxwJH8FFl6hsdXr7PJpSw9mEL1Fu+?=
 =?us-ascii?Q?lSi61mIoHZsRe52H706BJmTJU+ajNMyEgtwtjdjTYdCZLEPINyuZiJMZusEH?=
 =?us-ascii?Q?CzmoxL0kr4MPVqvVy+WDhhhVAz8LqzWfFg4SHNKdwNeEagVaon346fmVn0HK?=
 =?us-ascii?Q?Y9y63RogTs6QALH69SoHNCv+J37kiVANl3Tlq7THChWlzjC+D09oQegJaExq?=
 =?us-ascii?Q?qgDL3XkaVrMPdQcJz5PNKQei3cHOrKQFK9OFY+nVvpUCpvTWD7T4wbyF9a6r?=
 =?us-ascii?Q?QfslePh5LZM3bCYfTr8U6+zLBUizQo1byMf+efqmauHIgNVnmoDNgjM0XaJX?=
 =?us-ascii?Q?zmCsAY96HmmwgMHUch2K9BIFXkSvVxgik+qpxsLArPweo5lXE1KH8kCn4IP9?=
 =?us-ascii?Q?rFTd88KNkxr0gYqn29EB6WrhCNDQCro7B/hZi/kluf26swWH5+6c3rbKtVAF?=
 =?us-ascii?Q?OfBiZZ11oW2jKLYAaMYsuckVWugk75Mzf5AFTtr7BLT4uitkH4kBDuRwjW30?=
 =?us-ascii?Q?Ta4NliZjLmU++ol+/lmkhtLUyMg3f9ZZ+9QyNSin/I1u7VSyaQEjikLfarTv?=
 =?us-ascii?Q?sQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HpzENBCaCZwnCZgFSVm3EvMMG9wBsP0wQ6G1jhmoNRh+qEFyUAHisIzASD92BNVVN5xPhu6Q7wIivnPiOevby5mtDrI7cQV9giLUjPwZ/Mg0yrHUOMT+T0XuPsw95XHzxlThWozClGOabtkWvgRhJrIb57sGi9jgA0rx5YqWF8nLTwuvttnEZA0ujyXz/35I1oPKz/XOIpXTJUny0iUyAfhMWAvsCAZBcgN7cKqL7uPgKA/cGNUsqFSCznx5dEPhTVzDBOBj6pHlwSR0th+tbIT3JMarkRoaWXv2ALKBtqB3UKK4gsllDNmn16kNR4hIgQb7coO0vUtyy/kAaHXoQeoGOw6uKk3P3H1To3I8CRHMONOHuKpbNxRDKkVXQSiuczr/mI12H0dV0gm/tqru90S5cnZehNmfThS5l2V0FQ9mjaCNzmESuTubDJIrDX4xGHg/D9vRxFhNtK7mACBFFaILWWtIAhrT21l5SbLQ3OzrU5vd3nZLogl8KXKq4NAtP5YoJDqqe4Rhc9lZBgwf2DZS9w8dSZDOfAiqeoIVdkWzuAutklQYgDKAuygDiQSIm+vNacDthGuc5qGAYj7X/EsW/QAiR6hCuSdZefpXum8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f4cbee1-2005-4051-78c8-08ddcbaad7f7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 18:41:18.5230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TD5z8XZgh4jpGixF/N00e1qtagK1kp1AoLw7gxMTWokYh8oR/ZFmB42JhA2QaFmzzFBrXz4BXjrgrYMdZxTAZJfbiXed3ZIApHW5wVV7ycw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF8CB762A0C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-25_05,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507250159
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDE1OSBTYWx0ZWRfX7k78QY6DCoMZ
 P2iYPg38W+GmUCAh/H3yIwEPvDhwiPLy0QuqUXOJZnLKoO6AFDUTapIWPLbgxqbmoIvJgOKLENP
 hTxGNK0yTIp6e5Pey687VYHv4QCjFidOhsxwYzv6Poi2HTEpQ8D+pOQ6Y0q7kAnKRA5M1fDxn03
 0NsWlGaCotkr0zLjO/8GTZ1SsRhVxQB2tnyB9lbcfxJsLci0kpKhsQejXTK/w9aq/VKe7W3nMdv
 qFMtpxwi5n0QjrKRABFduW66sszixArk7dR00fpvDZh3TMw+WCAQPRThvGYlmS2RLZr8RhItAmN
 n1tzCIgyw37qpeAyhBUwi4xh9Ps+DZyFe8TYV81RxXErLRe8YcKBLQRoHJaT2CDkGj8IDOnY6FQ
 vuoDjBNVSj74eSEinJYGzGhZNwP4iSUVl0MgCKXXB2+WnJjJ0lwrE8P1p9LFpPqzLpCm8/TY
X-Proofpoint-ORIG-GUID: LoZlWmW8mj3D8ZeupoR1Z8UylQgbCaFk
X-Proofpoint-GUID: LoZlWmW8mj3D8ZeupoR1Z8UylQgbCaFk
X-Authority-Analysis: v=2.4 cv=JIQ7s9Kb c=1 sm=1 tr=0 ts=6883cfd1 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=yPCof4ZbAAAA:8 a=mwLXZKzjd4ue-Yc61lQA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12062
X-Rspam-User: 
X-Rspamd-Queue-Id: 940C1160002
X-Rspamd-Server: rspam06
X-Stat-Signature: owxtb51xp9fg5oz6fry5bredjozcqkyj
X-HE-Tag: 1753468886-22951
X-HE-Meta: U2FsdGVkX19VEqA1+QhR69X1y6J95Z+wIttsKtQqOZbPTZdPEs90N0GRt6RaNx3R0WnSIlhyZ0dpokecziBCmyQCpCwQpj1n1O3qIKr9b2s/oJek8ot0k7u+Uzr1IHr88hGx8JydZpu1YROOqc72wQFPdnxHVzRu85c/v2JNOf5cnWkFfTb2jcw3C5jTua9KZ2pcbhOYTyxQUv2zeMXmbzU/cxfHQdfvuNOg2VRj4T4PJsupfvE8RmK1NqFzsZpMo5MIr4LfEwBdEc8W3CcAUPp6dffgJFqKUAa8+M94vGfQyBUi48UVbJi+IySvS74HkEz0k1vHMFPcb1uebr/VK9+ANqSDz1wgIHCyvez3XGPG55NnYZa9MA7dlbS3j/ZwZ7aEkx7jIUNqzlkQjqvcppo0Zs8J9cqJZ0HqnkaBWR3PHbsOBz28fVQ6hso8id0pZH/+/p0jvg3CQ6M5VqSf18r72ndaWs9vR/JZOseMZghd46joFlSs/5ySqAevQKIcNKOEZHAWn9w0m2LjKi9+4xqRoomENSPLkq50EF8SKP6j8Qqm73uwisc/a62oEBFHmlPjfIxqwDqwgisoW9aK1c+LrxwsRUc+0nUZrQPlDZXXNGE0r65xMApK38CyV4UOvFyPclqy5W5FG4dQ96PoL7bWzf2Q9cD6pTomH81wg1EJaSvk4zalG8IG5+Els8zmtvNkV9gcEquTEnlT9F3qeplv/qiZUCJHhWokEharCoAdHoVq7uus85nvBrxALfM/oYeqjhzDyHPi1xJdnBobnZ5NNBfSaYSg0DuedfQSvRZ9gq+Jl5Nq0cp4KducBYlxF3dqz9Ld0lue62qIBUVe4Ma+xqFbj1KVe8q9jlZX5pNP2q3CMkPEyx2knaxR7/ALk22Pj8Kh2Vlgz+r2CAEp4+SFuWpEL7GJll+/LTmBbtWw8DPeA6n6p/CCdbU1PdKfg51XbmT/69qismJLM0S
 M3aLO551
 YjLW+dW1/3Oipd2xuhm7Na6w7f4HMlKzB+9Fcj2NcB8jak0aorKbhxNoJIJuW5DxBdl5FiezujqCF8uQrKmTziwJAv3W2ranIzpfOLkOsYX0c3rUaZYNK/RGdMKlQbUJjJi0J51QX4QP+ootdh+dLf5Wyt27I1CCnrOdjkBnMO5SYIaWRU9siI98WJxJxyRqC/JPvpBKxiutBdAzoq3r5CBAaUNeOGwiPyq4HeWDHiAwgu6Z+9QqbdFzOorXrWzzONSVWum91r8N204mDdZYovka3x3SF1gdVjzI3GBEUlUpjP3vIIYX89ynMOExKt9mi65THs3VsglqeJM9cWomRYBE8IdKitg4Bk40y0UG8bm9815THDZ9CasfR+iRqwBnQMykO3wSW9THDyqlHDs1X32j/MCn9J3zzkBN8ygor7GSPYa+zoKBs+ZVJV9dX9Foyem3wca1M8ZqLZ3ae3GQmZWrANl42LNZNW/oNs1KWzBKLtQIfPrNfxAT1phjuM6g9z04V/AZlZPyKC4tMta/0+SY6Mfc60H5/Ty6JExLIvJ0dbtmgaEzKhwuAgwlTLtO5w+l3G6wHmGRc60fUgQ7L0FW1fpDO/OZTki6lmiAavOMvdcjxg87xvBQOB4AhUnwmPdcCTSP/UTSQ2P9JwinVTtA+MC+6bgiN/WiiTIVR74SHjkOFKB4ZCELFnLARuE/EIWYvrKgjyDC5rqg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

Can you apply the attached trivial fix-patch which adds a clarifying comment to
mm/mseal.c.

Thanks, Lorenzo


----8<----
From bf8211317183353b3652baac1af1d35555733d2b Mon Sep 17 00:00:00 2001
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Date: Fri, 25 Jul 2025 19:23:50 +0100
Subject: [PATCH] mm/mseal: add comment explaining why we disallow gaps on
 mseal()

This explains the semantics clearly, the 'why' of the situation.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 mm/mseal.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/mseal.c b/mm/mseal.c
index 1059322add34..d140f569c4c3 100644
--- a/mm/mseal.c
+++ b/mm/mseal.c
@@ -37,6 +37,18 @@ static int mseal_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	return ret;
 }

+/*
+ * mseal() disallows an input range which contain unmapped ranges (VMA holes).
+ *
+ * It disallows unmapped regions from start to end whether they exist at the
+ * start, in the middle, or at the end of the range, or any combination thereof.
+ *
+ * This is because after sealng a range, there's nothing to stop memory mapping
+ * of ranges in the remaining gaps later, meaning that the user might then
+ * wrongly consider the entirety of the mseal()'d range to be sealed when it
+ * in fact isn't.
+ */
+
 /*
  * Does the [start, end) range contain any unmapped memory?
  *
--
2.50.1

