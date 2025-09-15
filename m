Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E06ACAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 10:44:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA2088E0019; Mon, 15 Sep 2025 06:44:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B52B08E0001; Mon, 15 Sep 2025 06:44:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F2D48E0019; Mon, 15 Sep 2025 06:44:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 84FED8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:44:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 50E9FC059E
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:44:29 +0000 (UTC)
X-FDA: 83891150658.25.09A7E14
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id BF590120009
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:44:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qOPwODOe;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=yIe5Vh8c;
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757933066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fbtcbGtrK6IdqAww1PknZu3h9Z4ILyqS5ad9o9qaj/w=;
	b=uTixkANxbu3mGesSZKfFqDRsNah3Lg28+kHHIQQOCl4yUaSoqNO9KUoPZsSCjA8nEIQCAx
	gZYFnNn9Yhl5Ody9OFIHRlOySH3E2NDGRCN007JifWexATUHlDFerKejpYy85Wih2uBBk7
	fYmfjdiR2VwXAiTdLJY1xLgXvJpd8/E=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757933066; a=rsa-sha256;
	cv=pass;
	b=OEEProh5zUS3F2CNj4VrdoTXlPl+lbNmymP4uX1L+hhn8KiiVZOW+PTQbf6Xqk1YUHnQI2
	l45+Neg/qJidZJwYAijbkw1lSCb+yTudUwdEvwHqoUGChw4jYtPbdBs7KIAWQ9V0IDjFc5
	+l437XZcZUTiB8xIcZBah037ZCHy0Ec=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qOPwODOe;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=yIe5Vh8c;
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58F6fswH026635;
	Mon, 15 Sep 2025 10:43:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=fbtcbGtrK6IdqAww1P
	knZu3h9Z4ILyqS5ad9o9qaj/w=; b=qOPwODOenBo4G7ntjE+NwOFlvPn8RHWMdD
	gGcHq21GgcwSbxayNlwF0sB2lw+udNETecCqIxc+BIgFezAMhKBwg/UISEMbsDh7
	F4z+oc7PD9nTbapAhV2UEIQb8QsBrdaQl7iHpXsyUwE24yiAtkSGBzXA85Q3BNxt
	nUGdRRpQJ+QrgwY+Q5r6+CsP+Zs6+v6Ge1PtcyuOjxtkAvXXxmZl4CZKhtjrrvxR
	TgsJXLWT/jDqzstk5A54GIaDtS0TI1O0PS0T99X0bpZkTHLKxwAtvR5US2Big0p5
	d7xvuBUIFR0FZrJO7MlWTYvdDUg/Z47hKg227HyT7v6o7a4FBUDA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49515v22bx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 10:43:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58F8ZAoi015233;
	Mon, 15 Sep 2025 10:43:35 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011061.outbound.protection.outlook.com [52.101.62.61])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2h480k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 10:43:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b0GdHNq4WJ7PBvUpAQCNAuvPVAa1bp3S+MFgn2joqA3EKSLw3XTZTaFE6AmInVKgmZglC7ksknRmURVNbAhBz0B771J5BcampbcErkLxf9NnZBXcDyHQ/kgWKEHvV/1aokl/tIbi/3pt0RM8J602mylRdRpgegwE/+4Oc79uS/bn2sCzEPYNLwvTmM2zkEXCFqp+jG0t0eG6DAK/fi3NEw21H/ZOSrsrIUFE3abR1PUTEFwvutQNdknhPpi/4AMrjEA1fbXlfdb0tecRCnIxtpnNyPI7jSG2eGcWs+mg7paR9xiN7JRAyvbjwuaZRUgECkVJLR65Frs3SkyBe6jifA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fbtcbGtrK6IdqAww1PknZu3h9Z4ILyqS5ad9o9qaj/w=;
 b=GaDSwGpwz4SEMnNYmmauaA/KqW16WnTExINXIIIBd/viw7tsnXAayzPteL3Nhhi1CpOJirEOcM629XLan5OtidOs3ld8ZUpNQLCj8A23ZfJY55dH3VIx8LKbTZ+B/s3Itp9Q0np0ndWFKMp65dfxMY1l/655kxZsYruItlbJZVfDh9ocVu3j569Rg0/5UWfBC1Ywi9i5yVadSU+JW6IqJys+BhnUusiOBU7U+30d66WswcZJSERZ9CoyhNtWrzDOFPmlUen5AnkJNuVzE/mp1nCOiU8N/v8O9mZEgEObv1DEf+s5RUkYFYI3vVUPxri1EukLzeajnYhW1CvSe9PnzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fbtcbGtrK6IdqAww1PknZu3h9Z4ILyqS5ad9o9qaj/w=;
 b=yIe5Vh8cKDrV1ys3uC6jRINggodPoBNrwNDoSl/6fHh65ij8VnhvWmIsJ8nT6GwUIVIf6QPHpVRBxQi0ZxyS+xHk+/4MFlqfN6GUbXNk64XM174mM275FqSJJe4u4Y0D5lSEz19rrKwf/rgjcKahwXoCLocDNuLxJDyNbJ7at2w=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS4PPFF257CDCED.namprd10.prod.outlook.com (2603:10b6:f:fc00::d58) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Mon, 15 Sep
 2025 10:43:31 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 10:43:29 +0000
Date: Mon, 15 Sep 2025 11:43:26 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, Nico Pache <npache@redhat.com>,
        linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
        rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com,
        catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org,
        dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
        jglisse@google.com, surenb@google.com, zokeefe@google.com,
        hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
        rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
        lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org,
        jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
Message-ID: <155c821d-402c-4627-a723-6f8c88a2f65c@lucifer.local>
References: <20250912032810.197475-1-npache@redhat.com>
 <ppzgohmkll7dbf2aiwhw7f4spf6kxjtwwe3djkx26pwy4ekrnd@mgeantq5sn2z>
 <d0e81c75-ad63-4e37-9948-3ae89bc94334@redhat.com>
 <CAA1CXcA+pb5KvEnJJqdf1eSjaFiBZ82MRB+KDmyhj3DbiQqOxg@mail.gmail.com>
 <enrgrocqajwu5d3x34voghja7pbvau45oobxgabawrly44ld4u@ahch3xn6rtq5>
 <cd8e7f1c-a563-4ae9-a0fb-b0d04a4c35b4@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd8e7f1c-a563-4ae9-a0fb-b0d04a4c35b4@redhat.com>
X-ClientProxiedBy: LO2P265CA0447.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:e::27) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS4PPFF257CDCED:EE_
X-MS-Office365-Filtering-Correlation-Id: ce42181b-2418-46a1-5af1-08ddf444b583
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1qrTJNcv7abNv0vg5hIZMnJiQSf8PuBI2qkGwO/p95BBSnadFj5vcO0ZXi0b?=
 =?us-ascii?Q?oiOVaQepceA6GhNn7rrI5xVa8Wmqb4YnZ7spRE80esb+GMICkur5xUJjciWt?=
 =?us-ascii?Q?XKE4siiA7rK1yhor2T9h2bskvAkZcFlcsOz1gMmPoMUBX0iCJA9ne+n6TFTx?=
 =?us-ascii?Q?dchTcRdD5Qk9/LVRqeiV21Hy2rVRw1FnHYtRZ2uvxfPEQ2Mg+zGp+b89AKRc?=
 =?us-ascii?Q?SO7XycDSFNVGX50nbfbuSmPbwUZ49OcJ6PcKjug2CC8FWHOvdYKXCjo6qLAF?=
 =?us-ascii?Q?Nw9KRrzNqbkZNjnHMZ2yYdArKQ3sR1LH8F0EAKw1d25c4GhrWuw9/C10pA+o?=
 =?us-ascii?Q?gPGNQfs/yuzgFVcNBZ9KpiZQ8Wc44jr9B0mZ1Umf05Idl3LJBWCAiA6Pc9TJ?=
 =?us-ascii?Q?NCAKnXnj4+0v9DqAU/+6KQYgEH3gsAbKV+L0XDgpjyPz9+omjF4s06to6KQW?=
 =?us-ascii?Q?y1cCyuNAjRXwMgbVmXyL1rB7Cn+c4BhhN7JemK4xvR7PAniZuyAF+hcZdygh?=
 =?us-ascii?Q?XbtU851ALN4UE0qEDYSppeiBkQdksOea8uRuKxqmtWpWn179nwm1fGM643Ov?=
 =?us-ascii?Q?qCWlL/Pa3V0TWeGxTH8ee6NBNTd7CX9Y6pCa3NyLZ5YHsd0t14JqK00W4IQm?=
 =?us-ascii?Q?KktuK9j+DNE8EXbT+cjSNVdJfrhDQttQcvX5AybTBjXa0iOlpIJwnwkit4QX?=
 =?us-ascii?Q?vKr2FjVRhugo6wzJMa1JalOZSNZyfDkIwMK11hydw+7xbpNOakZTKlO+hHtc?=
 =?us-ascii?Q?zakqV7cwJsLRhF12DrhInftrscexVYR2o7IDMcHhn4RelDJ3oiLfKM6EF/q2?=
 =?us-ascii?Q?P8LR8Ht4MWjBqOaJETDr4rx8U7BTVObogRJ2XpboGhY8arRBvs9ul+OLNkMG?=
 =?us-ascii?Q?AMhLxS+zikRGZ6Ut4eA92S5Bs3ofg8OKvTWQ01Tzl7yBj1zNqEe/IWAml2Dr?=
 =?us-ascii?Q?uOe7YPxIkaJ1tTVsqlEOQoP+yo6uGnv2dXGm9Jq+fPjHb8g9tddcy4bqaixU?=
 =?us-ascii?Q?Bj3ULJajajxfdG/v9JoLUdY893KZkLDq/U4o2fvra+6EoESkiXpjmj0Je5/F?=
 =?us-ascii?Q?vEBnzX6yCUHPv7oQ4sxf/K8WYUpqclBkjkZIo1fJvoZ0ISlEJPYsAHxhUrqg?=
 =?us-ascii?Q?WVYxnN1qUrRhcJIwUtFX56lgGjmmSP8ThiXvwas+8w1tkQKMwqsV2S5GPktX?=
 =?us-ascii?Q?KiGp4RAuR14YU9Wzz72hrSHMLOp/ypcomMm6Y22s56UZuKXH7nRrV6Y2Kv4a?=
 =?us-ascii?Q?AUkasrEiYybF3vAIAC1or1H7C5A17qXeK07w+Mfxqs36pzT2FkdKocvBdGs2?=
 =?us-ascii?Q?hhfXfhSFI5JvRQvyp9ZXWLZY/sm+fTIWkiJ/IZ6d/Wq7Q+zRKSp19BeK1NP1?=
 =?us-ascii?Q?N3fMhisez16ayqAIDVWVEM/ID3bPeUf4+8rRr8f8EQfVV7hF/g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oD9MLYXzu3KLkQnNK6gLZIyIdYv8AFlWKo/bq7Q7Vl360tqrIfw6mutx/Pdb?=
 =?us-ascii?Q?7Nx/wSSvX7inW1fyhKteUQjGlu46dxoyaD14a1S+iWH49ghf72jIr3SpDG6z?=
 =?us-ascii?Q?nldJieXCzEMJopz9Yw8Gj/3Oimsa3qIyNm4Fq+XeDuXsmkTDZxDa7ozdFMMG?=
 =?us-ascii?Q?6hhJRFSV7D+2NNnvMK75EYRmALEhc0miOvau6p00/QRkeFCtYREtafem4n9o?=
 =?us-ascii?Q?KuzyQwxXLcY5u5YqmdTydOjHgD15+2mJC4Qmq6xt1eyHQjdCClUDJP4nh2H7?=
 =?us-ascii?Q?Za5fWYc4mX4UIvfLe5Gp34+jB95cdwkDGu4T90L0h+BK+D37lVcMuegwdybV?=
 =?us-ascii?Q?WJBnIYeccPuQCSvHOrTyhiQj2qyrNP+6i69wolqJn+aFpc9/djy5FZqZ5I5d?=
 =?us-ascii?Q?ZB5v7ZXpSuzvQyEC79sVD88zZqM1hLEj1DJZcLhGl8RyJHFOUoOwZUonnZX0?=
 =?us-ascii?Q?3jugMCmilKkMqVrcr+2ui9Qo+b5cWx4RHGPHuZ7mQis7j9kceAXdxevckMp4?=
 =?us-ascii?Q?A7eVMz4OBRsCNf4kZPObIGyAQPinhIUME0BN56fZYRhzjgtNckdmjh/spW/t?=
 =?us-ascii?Q?bJTAr8g/EW6y6bdcnNJo/mzp1jnucAftk/RYQOMlKX9xzWrC+KNEJxSQgRHO?=
 =?us-ascii?Q?ZYx0fu2NniDPGhVcvFAs7WYLw8oEgyozS5plp6vqPcrSBOLcPcNgZxLoco0/?=
 =?us-ascii?Q?H1f4TTXkR2/hALgBherT8pcu1EehcP88+dmAENUH2H863XMQPsgEo05DESpO?=
 =?us-ascii?Q?1xuzSxQWBW/ArVNFqO1EvqWgZAN9W8Dwj6qO3zJ57vqFrNQ6SxAhlmGELF4+?=
 =?us-ascii?Q?/aCNz+EBpVVtafKuAyvUKphxeNT6U5hO7CWUHx03FfRT2Xrmr/MsMtCB9lZD?=
 =?us-ascii?Q?8i6INq2jmM7JAE+YF4pzxl0o4o5tTyZOPABIQTYY49M/XDNc1CqqUU8snCcW?=
 =?us-ascii?Q?6MyftzYhZeN1yjOF9raaxoKp8b6uyaqVhnytwNif1uMyc2oU4dT+sb+Nwk50?=
 =?us-ascii?Q?XDucVc+09+xfsIrQo7bgedSAD+zeXO06JCTB9c/K+013ji8yKIsGqn9/4TSt?=
 =?us-ascii?Q?tyEFs0k40kTFcFH3mLZ7xBjhHLexQK08MqY0FjehmeiwGRa4F65r98tQstu0?=
 =?us-ascii?Q?0f05LkGcqTb5Udep+MUD6789ZC6pA/2BWFXlx+3h760RtJhn5WpvFZ4g5eTA?=
 =?us-ascii?Q?PjyvT3rB+F4Hep4H2kdPy8KW9o0sL0S8JNNrpV7BJcCBZoxR3k+fAbFa3fNG?=
 =?us-ascii?Q?nmO1i/0x9X3a4yZO6HD4XQDFmYA0kSKJxW0c7FtKrVRsaprH4v1DCSHH1dqw?=
 =?us-ascii?Q?UVyS9I0u+NN31Bv13LxHfpu1WFHZ303Vp8VptGAYIN8j3Ewak0vlFxvokPi8?=
 =?us-ascii?Q?cpkR6OcrHjfgWJufPI1zbzictDwsfQgJ4SgVKoIuUEZDFXSSHri1xtrtvGEL?=
 =?us-ascii?Q?Zr1g62/mAD7IQLOaZ9Zj8W29SRIzqykvrHkNX79IZ09H/25sS4x97ONgDXwX?=
 =?us-ascii?Q?oscQaKjUc6wW72yelf3yLZ1t441uTxMy1WNlN78ksrwa2fh4JEBioiSc3jX1?=
 =?us-ascii?Q?phA9OPkjj/ONFRKlTAAbXBfhrZoGTDbbCo1vss4boV55OF62EgV0k5QYimJ3?=
 =?us-ascii?Q?DQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hHWkdy0BD0ok93fH10Sb4sXQPv56fpIqtf92M4aInNJtxB7z4LI5wOWWzd886qI1DDHpSY2SOddD9tZbIK7d4Mh0ckAwyCGJ3mPCgbM0pK0C8qd9O+7J8hLatRR5UmANjJOtvufc0gglUzcdwdzOrYir9C2jYNcKVx6XRM4Rcv+hUJCJ1XgHBIiX6c1qwnML1iy5eR32l3yMUNRMeEI4xkMO9eCgP4QJdtYsRiD4yfmHsPdz6gQNJFtAcjpSIH0WGdexZGi6lDIuligE4RRCZ5h6gX9VyqM6LOqKr35OY/VUAIUGcWqFml1ErX3u88aAb8gONuJsHPO5c1ZpENFpzuqi0eOrrAj4tVKIgdfL63jsUk+cKMacJuCU+V+vq6qSGmMYcHlE3+0k08nPxAAyHE9eF34VHPlCRdsfnycJh3v+OXwssm/Dq/Yw3+ZD4Wq5Djn+rxBScJaDY6ucFhrwYdc/skkbmE6o/PYwZjXfMhrIC4zducV9r6pujQuwF/iq+072IljNifaMZrPqzF9dyQIuahU/kdRNiWEvSa/YMvMjFHFssd8Raqa93Xoa22UcXEGcY72zmUB/syXF9k22a9skIKHqhLIYgS5vxEeqBWo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce42181b-2418-46a1-5af1-08ddf444b583
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 10:43:29.7291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JEgqciy52T8qUAdmpkAiAS7RTnNtnjGr7D8lEDyxYHys0BhOvAQvYuEeTLnbEa0bWrQmMvjBWs0l3c4lHBL3I1Wj2oItveYFnE5mIzSFOCA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFF257CDCED
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_04,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 bulkscore=0 suspectscore=0 mlxlogscore=860 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509150101
X-Proofpoint-GUID: Uv2NUYZxZce-wJrUCQ3GaoCNWnW5QzaJ
X-Authority-Analysis: v=2.4 cv=RtzFLDmK c=1 sm=1 tr=0 ts=68c7edd8 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=UoBxVT_nrnoE5Tejwa4A:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13614
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAzMyBTYWx0ZWRfX4zqZmFy3q+AW
 fOllzjepjrnvMB5+jDRFrNwEPPWBfEVoNyK7SqviqO2LgNTbUwM35W7o8hVMzfp/ixUbdksw7WM
 bX6pw6c8nXc/Cj1J6xf3W2DOBM2Ob26lPE5eHNlETED783owSwIPacblFyyOgP9Y0PIcOIqyTeR
 L1IbW1+1dz7Kp50fKvFJCJJl56ilwySFH7rInNPFlG8q4rowdvtj4jDoLcSWmWK0ubVLA2uT2vn
 xmKfQjcVWBBy9Ho6swAyLKdbDrnOIbPhvLbBg1wT/fPasfMDAwAutNgA+mwvBzIqMEMeobr0x6W
 10ZvLrnZa4jzTnA+AkbjglzJxcjRyCBfDH4sh+V0mYXWpDYwAS+Pd8deWQeT1SUN2Hur93vGAfE
 CCxa2Fr81ThPNXpR4V7vFTOWqtYJrQ==
X-Proofpoint-ORIG-GUID: Uv2NUYZxZce-wJrUCQ3GaoCNWnW5QzaJ
X-Stat-Signature: 4m5o4hhspe3n863mjgyqx3tnu7euaryr
X-Rspam-User: 
X-Rspamd-Queue-Id: BF590120009
X-Rspamd-Server: rspam10
X-HE-Tag: 1757933065-828729
X-HE-Meta: U2FsdGVkX1+tAiiGJbNMH3BaV5cH4RWEqZADawjGYEkNyGz6AxKCCUbLRDC7/fQWPpOKIe7uZ30a1TzCL6dt512qaWpPx28qELJHJBIq1cFvcs25rtPMbpTLVNVM+OzmZSUJ/K/XQzX3spKXoKoZCl8LbpvLbyswCq1rgnBA7kWzV4MCUJDK2y91LeQGaZ40SI5qQ0xIjmQrbO5Kxlh0Nqs/lgWJTT7LkPZD7UWAsKyjTl3sC3KMHLa+5E9ijcaXvArykkd371oGYc8QAVcZhqPk5sF7HPddhXPOq5JqwPBhLKFd+DMU76qsyF6gREVmUTIEI1M7qJvlSVp84PjbZQ4PIobbkX4Qru9ksV2IYWj3TBekzie/PR8ai1RoEnD2bMhcmvxP9oTVyODi7aTtOejUbiecOuVN9afCG0R+BVUViUdA+NwS1xW0u5DvKSYvmz0rGWo8mbunEfemDLjhqfA//E9ULTJaVsklvY5fIukx+gA8v/SlNqXzANNtbZJHR+sFNkgEEmf5r1B/VP/yHxR/lCZ/cse6kZ0csoqy8W+8kXOkUkJ2bHpVmE1Su+uc6ykjLithgi0zFnt81hylYbfFboU8qVkxSK4CBFgM6qoZQbhqo5m98UDvABYAnpN01V+RrTspdKv+8bmfrqkTuIzJXazIVaiQj5sy65xZpo7jADsB4A03mvFHFmjHIcOCWumGymLda1gGwlljTqYC5P/qgZF6MjAjsuII0ZbX9sflB8iUzxWgXZzbyIPeWDrckG305NC5khxY/VCuL3MCdd94fygUDbiJ7ra+IEwTVi+Yu3tQYCM7eJTAYrYQelfSa871wy3LdDt3j7hC8X+UC5YQpY3wECa4Gp9I56XV0wk01uVlV8f8rYdgIx4YYxwdznpipXdXWCubBNfqKcg0rfpfuMlo8fYBaiCSfoHIo+8gHwvqf0htvGFlc+WvV+Pue0luuPUI9xfMSq/KcDX
 23a8MpMz
 sOOgetueHWSXVKZHnX0cotcwKJLr8CqCBCsz4kfyq7p7804ycSaVLWy5ltPn1qnMS8Zk8QCYhvP+Brhn3nC2GMjEUgjOpYOHahdjCVgTjmF/Z/DyYSypYdAbghPSVsXB6ySs907EEEr1MxMBajSRam3ydPAWOqteFV3CU2rWCRMVocsk9YgIebE3FecF7AuqWpP/+1hU52NIISixMkyx7B1j3oKfW2K0AqHGf7ob6aYi3gsFIPedzuTu+rO4zTir+p/IB1c1v0ertnX8T5CWLLqiL1gknUGM4+kVV3iKhiYJW0sc6zjKD00Q7qE4dtwOZn7OqmDIJGjPgyzDhI3quf16CYNbkeWNzj7rSG559H5IhiOgn4Z2bL2AJBXZSp/jVTwWjrXWG69GtzATlkZriO5gkK4jMNU/pn47XtthdMZiWYnk9vngitr+rHQSGBx/Eat72Cx0CfC/nYUPwPwOe+BYPZKMX+O1vk3KMXYCyHVLG2P4S9yQlUTRUPfSleOtP+OcRNRp1XMgAgqO8z84FPvS4tZZQ8N9lsrdmVGOy9qY3KAerQDKuimfv7Ac5+uMIL9n06IT2xvfg50Dj4/yXFqS/WeTKhUWqlJgfcH0xVL1NC9WF9UGqBW3gyi+3EahgO67mbmVrINFdv/XY5r5lGhH28N6UEIJ2NK/HLPxAFhAhG7Lt0jOm+gzwqZwBhKaqX+PjIHlFzlDP17ZrO0bPB3FyIzQSC8iUL3MKwz9HOG8lVuZtn79sFApk4d8G1mE8UnLELQTfMqnsBQATy/xVh89759y2JZbfIBqH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 12:22:07PM +0200, David Hildenbrand wrote:
>
> 0 -> ~100% used (~0% none)
> 1 -> ~50% used (~50% none)
> 2 -> ~25% used (~75% none)
> 3 -> ~12.5% used (~87.5% none)
> 4 -> ~11.25% used (~88,75% none)
> ...
> 10 -> ~0% used (~100% none)

Oh and shouldn't this be inverted?

0 eagerness = we eat up all none PTE entries? Isn't that pretty eager? :P
10 eagerness = we aren't eager to eat up none PTE entries at all?

Or am I being dumb here?

