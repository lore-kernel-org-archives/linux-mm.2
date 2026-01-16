Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95873D4660C
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 10:28:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEAD36B0089; Fri, 16 Jan 2026 05:28:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D43B86B008A; Fri, 16 Jan 2026 05:28:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C115D6B008C; Fri, 16 Jan 2026 05:28:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B0C8A6B0089
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 05:28:31 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0F7AC1A05EB
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:28:31 +0000 (UTC)
X-FDA: 84337452822.29.B451B5B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9636480006
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:28:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UCU5t6mI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=THLYtFVB;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768559307; a=rsa-sha256;
	cv=pass;
	b=hKOuI9gZzBJpa4/LbuOmNVXj/vH1b8MDsRkLwLTcwGrLY6tyAq3TNNx5lUTy93JxJwzF+G
	tP3+9NEOIWlxqjD7TCk4EPYJUVjdxABWBmHSkcutaPCl3Hyx5daIxxU9AA2C0pxH0IBb9/
	2AnqC/UL5ao5bAhNq3U8VqkYWPsLfMA=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UCU5t6mI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=THLYtFVB;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768559307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vCwhsCAbVWvkWcsHZfG1NjhpJ9liIgn+fCwIi6wkPuA=;
	b=nqXI8fvjfbOE22Iu0MaIJ9MDItOS9fVfQ15rT17TXWYdsdqVdLkNpvqDwMUDlzhgv5h0RC
	XQUmksfDfVlRb/exf2/bNx1y8HHTsv3LK1lLnpY7MIsMxUjlLpcg3y/gIS+INUlH90KRy5
	1MzeQS1nErmdWJBYh4NSQhB/XZuTLx0=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FNOFqH1431572;
	Fri, 16 Jan 2026 10:28:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vCwhsCAbVWvkWcsHZfG1NjhpJ9liIgn+fCwIi6wkPuA=; b=
	UCU5t6mIWfGNp1alxrwQ/0whLugDQl4/zDB6vypC/hDFKBNxeqzZ7TbCVHM+h7Uj
	kYqtMZffWkyRIBclNzR9EN/4D40I27ioVt6GIgANykVql60VzqkZTqmQaokmYprt
	VfpN2Z53t8JOfE1uWUVdsVcdkqlrZtC3Z07hlIWIb04y8UuG9DpUZilrA0O/d5zF
	/0+IeDll41I4/RClYWLbE028IzGohghQ3GiSQuHFEO3XlDUh+bdUJjitOKfY0EVb
	k3MbPxtKHxorhIfxFxYAQ+OIDY4IImPwWHECl8OiTQm4v9DvnZOKaT4aQAGddEEm
	jEdcZr4RxQWEvL8/dph1Gg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkre41sh2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 10:28:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60GAG4Xm029363;
	Fri, 16 Jan 2026 10:28:21 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012001.outbound.protection.outlook.com [52.101.43.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7ph50w-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 10:28:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B2Ea83DeIZ94CI9Fjx7n3lGhS/N1HrnnejBB61vlMP+qtfg0YxvqZiXeIju9zLU7mvsuR/JJfwMtI06ZKghgkqwfju5mH9aMtqmmZQC9R2twSzufaF1vuC5WikqV4OIYDDMJzfw+wubwHLwspJZEpSU+n2xrDQu8MpOQslt//aGH9weg163KAyrnzv/zBEAtOpVveJGLDRlfq+VjNQiPghul70PWAH7MXvo/qj6HsUzu2q/Kmfm4JWYBsi3uXjOojDW7CRoHTwFG0IIYZFuFXZah8OTySzrKFmZpobm56phaXsNCedVfj0AZwOxQHEsZZRBVLUSyxNIlYigH3/g0PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vCwhsCAbVWvkWcsHZfG1NjhpJ9liIgn+fCwIi6wkPuA=;
 b=kG2DIWPXIcFFH5ck6EgGLboQg0OW8v3/r1QyCLxrjd16r0gkOYPXNT9YS3uGpgqSRhUZqSCDzIzh7UZFjsfHbFbqWszO845atfDEfzhO3eW8MQH2oJ+/qGLKFIQj863g1FbFaYNOtkR1BKp+lrvwWriKZ6oPoy0JAmKsTcilooWPgaLBs0naFfWDhNTQzKLoDPDBVB1yfhsjOKuvEZiN6wX/oqkOj6rOaHOubUdyBF/Fz5EYIO0oHRTpagujYHt2O1PPdT82oi+TX/r838pRLeXKoazCtR3IqJ0sKuSphFjGX2ySEo+P7Qb7x5NOh1t7rx9/QnPFawbuMjg64mnSzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vCwhsCAbVWvkWcsHZfG1NjhpJ9liIgn+fCwIi6wkPuA=;
 b=THLYtFVBJFsRrCBP+ouzhkfbj2hfXlzRqNgNcAJmE7mG7i2xZWCBEgRjU5LqzztjXsNeGiONIyHnSLAGtbSAt95B4QiBwADVDsRn4L056AF99Phlc036Pt5hQ1Jq6df8qhvJZlnKTZwuvBQ6lcHaPUrjC0hzPLAD4yvTzigWGBU=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by PH7PR10MB6084.namprd10.prod.outlook.com (2603:10b6:510:1f8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 10:27:58 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 10:27:58 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mm/vma: add vma_is_*_locked() helpers
Date: Fri, 16 Jan 2026 10:27:47 +0000
Message-ID: <500845052f79ef0e23aba79fea767a42bdddc447.1768558900.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1768558900.git.lorenzo.stoakes@oracle.com>
References: <cover.1768558900.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P302CA0040.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:317::15) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|PH7PR10MB6084:EE_
X-MS-Office365-Filtering-Correlation-Id: 45e77c47-8ca7-4c07-faf5-08de54e9eb34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JAWzxiKmsOayniVblJ8GYMeZsup8APihX7uuPS3yGK1vsrl5S/OKOS74TOKl?=
 =?us-ascii?Q?UBdVVwJjCkRc9Q/gA7vpjFheZQ+SgU5ka4UKdSfBBsZl3gqj3MCK5+F2wAs0?=
 =?us-ascii?Q?LfwSskSdfOaW+mDOM+x8ihPhdVKQfkoEGqeu6WLlGJDO5gig3tBUa1yzZjSE?=
 =?us-ascii?Q?y6N9HVVLc7Cbuy7g7g1vNIwwDdNYV/qQdcPExY3lVxYEknYIj/9sG3nwSec9?=
 =?us-ascii?Q?kdiwLyzP86Az7SA5IWzO2nIE+ZQXBInhE1o8n4uBOPe+/5APmc4MJrQvdrgu?=
 =?us-ascii?Q?GnHgbuaTG8847K6LZ3VzrJZxGYdSzVn8gKmUtwkM01TjCHxBA8bUcwWqWAKH?=
 =?us-ascii?Q?o0PiPPZWPL+tozxYarc4QCwkerZoBSI7twJTODLLv+4qSmCTGSQZPFDNcuvq?=
 =?us-ascii?Q?rjVDrs7Y9ioQgF/9wQtj3W00gZgzzy+/iAdEiirf56CFYQmPUrudQMhzgFWy?=
 =?us-ascii?Q?iyyAQGnKWJBHQWTRt42xYhGQX9PaFPaDJPi/jD1XixpgIm8bV6wu3VuVVUGh?=
 =?us-ascii?Q?pkX5AD5VU/7gt1XpKCvp04hedcw+mCoCgWJYf1/1nzuOlfd9+CkMIaXP+FaU?=
 =?us-ascii?Q?mAFBgj5fVugdqvPkhcCEcVUe6LQU5ZhVmVsNFZtNEeoOepnFg7NzqU3QKlob?=
 =?us-ascii?Q?ITtzm6/M9hIV7BYVRAmLLBuSZauciTXetFQmUaZL7BkFsLe822ROnauyUKad?=
 =?us-ascii?Q?3C0wjKljAi4mE5dcxf3ji+SYLkU4FpPuUN6Qwrt+kEsflgyamxLqr+16S9WM?=
 =?us-ascii?Q?ud5AxoBPz0IbAW1ZfNzGbxLcTPFImTobrygZl6IQw70+RfcfzsS8cYXK9ATm?=
 =?us-ascii?Q?Ootzu/jqyIb/vsBqRknqqoIih7mZliq7D1RNbx19ZWj8aSPzWNb/cGcXoK5v?=
 =?us-ascii?Q?aN08ZS79pCmaV9Mtf5O/bAuydpF/CxJlgWCOkhvnqhvW3Hufa4HCZKZGA4Wu?=
 =?us-ascii?Q?v6XIpk/28ICOr93nk4buD4VZ4LxQvEVPQf/p6drpVYHg3NG3gwHRCNHiuY+t?=
 =?us-ascii?Q?cllL0VkayTwLRFLxJuzyhCYG9qqvfTgaoUKKxBcor0pSwN6jATRp8AFUPc65?=
 =?us-ascii?Q?9uXNYHaCHfDmlrBkltVcmXjRTyKDWyIbKlJ+Bp/Qkquy7uXrkJTE2BeT2mHK?=
 =?us-ascii?Q?2/CalEcQO36xQHxdXx4TGsGOXIyKu8ek6THvpQ63N2WoImnRa4Eaj5Bx0YYE?=
 =?us-ascii?Q?DeUgpx0IgiziR3PjtHcSUrBJPbdiTWCrlL/pfZmfwuBiiizt8aRtEKJdYnhw?=
 =?us-ascii?Q?RNGreHiBvnoBxMIM8BcECTrBNAxeQA9Vbx6sHIfUIb8lap57VJtczZykgB1F?=
 =?us-ascii?Q?CLrj9wIigbuaGV9wU+elM3O4+uVnwaoAiMzZN2MakJI92h6DsT6ISR5ZNx39?=
 =?us-ascii?Q?0KTYr5OhJ5RRLFpljTcobPiKdDEPuDKJvOvS1Q4X7ERSbxT0ZB12i5fJ24tt?=
 =?us-ascii?Q?gWWirYs0+LhT4Jq6UnMcVY5axdLqXssiWB+X5xYYQyDLWWyBsOjv6zQc4OOq?=
 =?us-ascii?Q?VW+FLxg7P0tX8dSaUPGFZVihP2zKoq2vFvJ8tvNyod1XYjlkZz40mXKkYqgc?=
 =?us-ascii?Q?zdYiAEYwu0KQD7ytBBQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qyN3I10YjVkNRm8q5FsaWdDoI424oPVchPFK8PLC7DoC/7i6oE/t9w+XH58m?=
 =?us-ascii?Q?8393eaNNSNO9SfWqYOrHTjbYuBjy0Dl3d0BWA96meR+epi15jg3OrM/kHwgl?=
 =?us-ascii?Q?P52RWZ2kgV/4k1/uGdHdBpGmDFT9u0n56HOyrSD273QlI7vErUVC/uCjXAeD?=
 =?us-ascii?Q?87YJr69/GARUD2wcy9qzPAWnKzeCOOLrHO9sEOcBXE6eTn7en11qrIS7UjX6?=
 =?us-ascii?Q?X3GfpVi4XEuXBlK9dWNy/VAwlWwnMt+IpWKl97Rj5G/ZGlNoYIDPCPxyEiSM?=
 =?us-ascii?Q?2G7WzjhGNhbGUIkPRglly9UhFq4zU2vz30Nq3WxdI7LlWvo1CU+M627JNMcC?=
 =?us-ascii?Q?Ib7PLtAt3v/LpJTIPuEnSRFkZEYeU0ymHXDPYLQEGekVhpcOrtD+R67CJ9h3?=
 =?us-ascii?Q?nYTXXoTItgvT6Azky43erv7x+9/KKEwzpzbWJ2nI98Kppmgo+BSxIiP2jtEp?=
 =?us-ascii?Q?kwGmC64ND3MCW8ip8+Ucka63J8oL/X/1FNC3RumY1R7EuH/Mq/ykRtzFPnv/?=
 =?us-ascii?Q?2tD0pQoxfLVhsBxOCbI/3ZrjQBimM9a6Ye60e4SnsQVJYvgqNgtKviqGg+Dm?=
 =?us-ascii?Q?AF51uVsrlyedOHkO3h65PlrfoIDdy4d4loER9PFkWwt8J4hp2+QCKkoMQLWG?=
 =?us-ascii?Q?+pdtvRoTwxuAErY/RWr7K7dVkzGMKdAur4IlQ+4qGxhzzfmNZsf0yXFd9FI0?=
 =?us-ascii?Q?mLQFhkutz5uH89X8ekUXlAW6jX9+fWZcjwMbpRYa5VzOJIRBaQwku3rFxMv4?=
 =?us-ascii?Q?USwPNtKmx8xSjAWyN3crENW3SB9JQLj4rP6zP0aVaVFIN8wC24MvFURC8kjd?=
 =?us-ascii?Q?OAmUcCsJ/P490FxxBbzToPuYdW+4/9xJUIe4d2bKGKiJuMGyLmDLQ6h8O3ZU?=
 =?us-ascii?Q?hX/C6HH3lWXY4jJq2CJzPhWQOFXU9xWAeSM8WzWyFhJsXYTI7U0SlfDQoro/?=
 =?us-ascii?Q?+g8Wzx+OUj9PnV69D4A/5eoSrnshMTNyer6xO3U21M/rP3jj8pE1OsbNeRzX?=
 =?us-ascii?Q?YhGK4QDhAnfuR0g/wwMvhL0SNz0LO2ZgtRH9zRXSgrhGQQmNJPskj6lP9ljP?=
 =?us-ascii?Q?Bjo4T/tX8Mq3unJmXSoj+WTR2LNJk0H0ZePnzE9D1Ttj4rZskNRJT2FFH6Jz?=
 =?us-ascii?Q?osQuI9IPT7YdNUIPV7ZipMDi3rOSIq9Ip9s8cuGrWory58XWoTshaWOtm1MZ?=
 =?us-ascii?Q?OCpRPf0yG2MPZLTcj4ou1+S2zEQQKdd7p1Ji7DhZZHAllMyUumtaNnsffrpK?=
 =?us-ascii?Q?X168RRdjB3lJwopDl+8HSzBS9NLrhYyw8TNDHDOtao0Ed8dGQR7zhctqPBg3?=
 =?us-ascii?Q?NOL7w37v/emrE4jQoOmN4wME5ZQCGvS4s348MQbyubcG5CY74jGs8ioyCGiP?=
 =?us-ascii?Q?8YJU1Jy0QBGRx7V6U1uGhHIx+AFTDruszbie6VJesQ52dZhzqUDanhSKGaL1?=
 =?us-ascii?Q?1ENgDZJi8FNMEDsw1sI+p/J/7D1/LFlCFH/Bhzch7V39xa5Zd4/SnUapPqot?=
 =?us-ascii?Q?9AuK7Gjtqr1v1Z0Llh9IYc+rctC3MNG+2ZppEcFn4HsNeY+OzeOvtS7zaUkI?=
 =?us-ascii?Q?UgiDthXIi5fyvAVo+6g+Ok5MwUcK1IUrk4x2GeQY8nnEGk6CBhPUEsbkYQds?=
 =?us-ascii?Q?VkNJlDRvicLbXu/UOBS6QsT2zjbZxOjLkvISZ6AlVznLAqBtVb2xNLCUR+xf?=
 =?us-ascii?Q?f8PSA/siv5FLe9cqX69cH/cLA8psa6pjcAG3xa5Sd3z6FJPSJWHIn7m8XUVF?=
 =?us-ascii?Q?iXTcjhAcckLgEdY6I82r4JEQWsG9avU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8Q130FgODxZ8EeoFnnffmpghMT08r9zEKHwkFN4CPfRavyScTsDhCOQWgFmXFoVJGlxRYj+Xd/C2drO/wdahF5OGSGbhe3SR3NA2N/1DvrPx4reXU7m54ffTkbMACj8/fOztU7jAuGU7adiS9GB8gMwirjZzm6FzVw15M/qd7T+Kn70WctRysp9ofJIovgbOZrHB5vFxtGW8EoxgVAC12jYpMZZscngLwFWG5nkLn2tLX7DHuG9oFMrmqzIcJXmcUNxj6cMT/B/3ndPI6HVI1pV2/YNNEENfsjLCkB0CuUXsRWTrg9PojwjyoBQqNG1XFP/U792tTuKHSK2wPu1JXaId7X5DZCgRLRGEnI/V0p0Jq47DLip7IYnsBx4H6qTjBA63mQx30B3F9nYrGqizkn32iSPtMJ8d6A8/SZ2nnyyRkhFEZd920LWB7L6E69u6EYgu50cqihbI9dL+1B88EOuct2BccbvLAv6EyDkg9UtRVujcquOYfvCwUVt3OOOrGsoX6tor4M914IGustqLR+VNTWkCoGBRNzksnv1aIIoJKnX0ghb61UIfihbsBB5lFRSU66RcBNjMChwsnl98GcOm+3H/kb5BUllMxuwo+fE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45e77c47-8ca7-4c07-faf5-08de54e9eb34
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 10:27:58.4218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zkga77QJ6YZ05ey58rxcF9nb42wq8fC2rCub2WoqT73XUoQ1vm0iwvK5VRiA6Rwx0GKJg8S7yuO5s7TC9g+w7RauJXB0Rvvj71DNfRh0JGg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6084
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_03,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601160078
X-Proofpoint-ORIG-GUID: cdLnykWp63aN3HPw1VwbKKXUoZ6BI_S5
X-Authority-Analysis: v=2.4 cv=YKOSCBGx c=1 sm=1 tr=0 ts=696a12c6 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8
 a=ifxR59YiP-webHxj34sA:9 cc=ntf awl=host:12109
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDA3OCBTYWx0ZWRfX35djrMXwBHl0
 fgHn2ZUT28X/tkoxwMfhiOEqNFl3BhjehCvBxBmh8OP4U+SHXMGNUvBMvukKXWKG2BwVX7h83ot
 lGavhz/WvTOvEg2Le3t50tam18Pw16Rb81/hAOoDfkGuurZ7Vt0PwTor822Q0ttdRnNxJDXeUjc
 OAh+sKocx1/nLxzm0jw5T4vC0vRYtkAqdtZbp1wrS8PGnX2Cj4IhcAJXMV0k+XayFx5fSWC6FSu
 CutJAFyiEi1l6Pq4edUDqc3JoFH/u+2P0eCzyMO2T+UUZVgRujZ19JfFZhyYyvCsJ3iEq3pYNrU
 V4xqcHKmObUOQzun1Ismr5q2GxI/n+S9JjuMO49f6cFfkqSXk73xmaZhIWQDjL8iaguCTZQwdE7
 tpfc1lfVA8ujUiZhTekovlDDysv29zp9ylg/df0zICo0fQ5je4NT/zn57lr8z+0+tfDhmckUOBf
 ytsBiIfOO6sX69zSOMrSgNw4P2t4Betdccg3Aeto=
X-Proofpoint-GUID: cdLnykWp63aN3HPw1VwbKKXUoZ6BI_S5
X-Rspam-User: 
X-Stat-Signature: eh3d8guse1hxd1zmtxcfx46mc1w77dbz
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9636480006
X-HE-Tag: 1768559307-539575
X-HE-Meta: U2FsdGVkX1/TweydP3VsxzADcyLI6dN7cxpE13p68QhAPVSAbrbn1tBxMO6j8n36jKBeD1Cp1E242sj/R4Y7/j5pdVF4k2/ALe2V3Q5hv6CguyqTqFuZv+8FCOpWcTKC6Iw+/d+itx/OPLL2LCgCnvi9RGdZglwsYxYUnRuPiVfVz5nTW2e7Heg+P9WTE0tiHyfhVpsxXX3rGY/JV/ICgUwgb5Mckueet+Nyx8do4qQh/8MIuq+kDxRaXH8GbsAZdzfI0yoM20bRaRsuH4Up2bIyCrZZv1EJRdtb0AXDIWrB0nIRIw/TDVdG3jge0u50gjYd5NNJh5yTQoTClEsE9TU7xlZIUY85kOAr/sg0WZmVupWRcXlMof+FM+cAkHUvmsnBaUbooYDWJCLx2XxaWG4ung6Z/g4K3hfPZzNyIlyd8UrwLby4G9pX3TbWeIUfNmdwyFjT7ixI7AKFRKiBXjELyFt0ThY+HeGTyiG0NEQQF9MBYhFY4Un92FFNZOiqgtjqrDjTAXW1+t0kyqMRSRFqFaenGCjVr1XkywKlaIUmsZIIPSpcUCRDiO2BOor2WUGHnvsKrUQdwWIKGsTSHNnNELazG6z5vOSNpZZBX44D6VqDKEBbwhJVLbs/mvGb2yExNCSCIpu4O1ILcKkl8DGkKrC2qpDEB+o9VNP0sv19Yd4rCldArRSAaWY4ZjTEREnlOOLGyTBMYLhTEm/vXwP1NfAe4qJEgyBw7ILqKmExBub49O1d4yxq+HmHdI7q/9xwcA3DJq6I8X72ky6sdojAvbBgrvrWmgNhB1Tdt+/1miLu5S/JAEXfxhkfAFyvzhvTApP3YmjPO/grAihrcuUmF++dYaquz5rlarXaf0fjekQMrRsYCHSF9ozfVsQ0RoVJux8x7EcNQ7J4KBgZdYR68WSsHGi+9e8FpuucRR55bqaxonDlNOdKCnIRGwOcWqwqV748TfkkLB+H2fh
 7eWdRTgX
 9w4flH12uZDxcoSSCoVOoYe4izinxm1xMNGeM+TM/q10HV5lQWO5vW12fZB9VRxE5eiJyFKAlIg9xOn6lbrG6oDwnLlxTG6V3JwXFw3C/BzeSCU8yrJJbaUfYIDt2pkjiRrILW0wCWiNmIXZh4/BeKnwuiw7VJDLGcseB8ao0Evjpkm+JpaeP6T5SrWbSUS6srww/Pnrl2GHvMGYPUC02o8x82YVjaN0fBoTjCmK/UIancXQIgPUd8M2RVoOHKXmFz1+keOQ7DxnMozv1vRqqSRypSRM1wvjGjIl+Rx7g9NFKpHp71gkyhQHCjtCFZw3VzS7XGRYBcngwP9ccUPG/kxrlwFWPRukOat+EkN7+gFf6P9AqNjncXq5MmVEyXCG/jDjGiHsfcSvA+BNdTWjC+YqQefVioFs/chq1UvdtguvCtgj2vN5ayI8jLhb5+qtUFYOiTEBBE1yoGoSGUK9qqqDN5URYYzPCg3RduODC/I+Tj6pmSjrHpIzSLJoALOOKEBFafL9R/Gi1gWlPKRmYkkUyC3F1BJjilh8DdZKWQfRuBKZk3Htfu3pZ+UpN0pmmkxPRi210zxNCAtpkynku/JMOgGNADRS8QimsHr0FkHnjQlXW5D9aQyKax67ZaWV4+u7QCkhOD5UcyZVc+dlNYESH0StqcL1Wv9dcONIq17M7l503Y9NlWQzQAQ18ItWEgs5Qupla3YCk1WM0xeAFROf8RMeFgKtJpZXJZ1+Px4oMh9ZQCJ1c5Kb+CA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add vma_is_read_locked(), vma_is_write_locked() and vma_is_locked() helpers
and utilise them in vma_assert_locked() and vma_assert_write_locked().

These functions will intentionally not be defined if CONFIG_PER_VMA_LOCK is
not set, as they would not make any sense in a context where VMA locks do
not exist.

This lays the groundwork for a subsequent change that allows for asserting
that either the mmap lock or VMA lock is held.

Suggested-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/mmap_lock.h | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index b50416fbba20..cd51e0a43c76 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -236,19 +236,31 @@ int vma_start_write_killable(struct vm_area_struct *vma)
 	return __vma_start_write(vma, mm_lock_seq, TASK_KILLABLE);
 }
 
-static inline void vma_assert_write_locked(struct vm_area_struct *vma)
+static inline bool vma_is_read_locked(struct vm_area_struct *vma)
+{
+	return refcount_read(&vma->vm_refcnt) > 1;
+}
+
+static inline bool vma_is_write_locked(struct vm_area_struct *vma)
 {
 	unsigned int mm_lock_seq;
 
-	VM_BUG_ON_VMA(!__is_vma_write_locked(vma, &mm_lock_seq), vma);
+	return __is_vma_write_locked(vma, &mm_lock_seq);
 }
 
-static inline void vma_assert_locked(struct vm_area_struct *vma)
+static inline bool vma_is_locked(struct vm_area_struct *vma)
 {
-	unsigned int mm_lock_seq;
+	return vma_is_read_locked(vma) || vma_is_write_locked(vma);
+}
 
-	VM_BUG_ON_VMA(refcount_read(&vma->vm_refcnt) <= 1 &&
-		      !__is_vma_write_locked(vma, &mm_lock_seq), vma);
+static inline void vma_assert_write_locked(struct vm_area_struct *vma)
+{
+	VM_BUG_ON_VMA(!vma_is_write_locked(vma), vma);
+}
+
+static inline void vma_assert_locked(struct vm_area_struct *vma)
+{
+	VM_BUG_ON_VMA(!vma_is_locked(vma), vma);
 }
 
 static inline bool vma_is_attached(struct vm_area_struct *vma)
-- 
2.52.0


