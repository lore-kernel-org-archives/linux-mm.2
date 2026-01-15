Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CDCDD4114A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 09:14:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5D416B0088; Thu, 15 Jan 2026 04:14:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C13C26B0089; Thu, 15 Jan 2026 04:14:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC0C66B008A; Thu, 15 Jan 2026 04:14:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9BD846B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 04:14:45 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3CDCA13A249
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:14:45 +0000 (UTC)
X-FDA: 84333638130.30.B3D6A26
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id 85F6C4000A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:14:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RumzRq8w;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=vEjOZbOD;
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768468482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n9LjRgf1YljqMiYGAo5E80Jr5sxCorBu6PBN+8OBV1s=;
	b=QLGXd1CDczPjrPz9aud/euZYWAFHd9HYpuNFOdBmE4ypp8bkLCTkJr6i9gXDrRmQiC9BqX
	sTkinc9xL/SP7GPWV9BQlmLrCp7j/P+cZi4tUD1Bj2uyLVWF4awEm3UTd7fQIxw267s/QP
	rguuO5Ni0asZMgdM/YCDmLjrWrTof1w=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RumzRq8w;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=vEjOZbOD;
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768468482; a=rsa-sha256;
	cv=pass;
	b=pL3l7rEeXz8mNI4Fn68splUvhdZMI137W8iNb5WZHPrx9s7ljG/GhZ1r19Hg1oAwrwzir5
	0dKAjcZBZ83j5FGTzCPU2Pu+FPpvr3wFpVBJR4hJWUnd2xLzFEEQ7EaxUgUcI9lieJyRvD
	iJciXlU3IVhkcxQfLJhLSKsRRJYC3z0=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60F5v01H2419350;
	Thu, 15 Jan 2026 09:14:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=n9LjRgf1YljqMiYGAo
	5E80Jr5sxCorBu6PBN+8OBV1s=; b=RumzRq8wRe/Tn69nKLkefhN/WokjLSWWAs
	06+x+AJ7P8/pF7SD3k0fsgMZZl5Ls8TG36PunTkqSvXYSsXEPfuZ2ZnRY/FC5faZ
	mNeMxBkj+bdtf2K0GPWALyEeEdDkvPumksuUjzQQydZKmU0+7zzFZewGB9A0RNSg
	/7OzRCOO1AcnEDQ9VqXo93wmbF4bNXmN2iO2CVSroK1CjFDIW/5xR14fGPEShN4i
	2hI6wSVw5KoKC+Fn0GlW/3RWHD34sHfiz+I6ZH3rQYHNbhiLJJ6Z1A9KIB8xJHlc
	W2oOMKpgDDu78o6a4zjQpGwH/W0XTmmhk+Lz0cAZ974W6wbg5otA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkre3y57d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 09:14:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60F8RJvU011825;
	Thu, 15 Jan 2026 09:14:35 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010012.outbound.protection.outlook.com [52.101.56.12])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7b3v4x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 09:14:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dYJbTuchVPSOyL0VSAKNWZfOo0W7Ip4SksyXy+xSq+xVhNZ+JZ+twoYJiwFZeDrQ0td+wX/rg1tfUkj5LcPP1NzpVYpqaITZZRiFlPlZhBgjtkQK7ZZsXbbvElBYg/L95HrdZ0ND42S846QQnSHtb9W+ppnC+j4RfyqQ+mEFHS+5LW34jKmyg1grI///hryb+nrxnuuylfTj4U4q9zM3n3e871M6PIFA7AK3HKZcoxs0OdhjvDT8h/NFy4W/jgUvwafSctZhljIyIIAH8++x3FcV5fERyhBOT2e0VpoJo4VvK5iIC1jjpQkt9a8+g1byo8y9FouxofLR6KwCVR3WnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n9LjRgf1YljqMiYGAo5E80Jr5sxCorBu6PBN+8OBV1s=;
 b=aTRLNohqFhbWzL8zeV7FOEbd32jBBiHiB4pdXGd2w+v0AtpiW1+u+uu5JynbLmB7CLtE9GTMlekDI4yqH04kKFRxJ6uaSUltEVIQUMV18ASBqtv84wTDEorpVxZK7EyrUG3ASBwH/etJXh+b/oMwUw6BJ+yEYsBBR/UPpTNG4YWia3Y1QXh6Ci1GwdIlrko5eYX3eaqMHrVuPaes9WauToV9tVhyk0qAOLJ5dTrTwVc0cn0Fs3RNbh2JIXVKs9UA7wAqLMx/Fy2y8w2EIP8hcz1gW/Nv9DZsNP3XgNjItBSW3vLz2yGmeQ9hkfVWMnLxZbZ/A/cWNTQn+2euZPkPWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n9LjRgf1YljqMiYGAo5E80Jr5sxCorBu6PBN+8OBV1s=;
 b=vEjOZbODOLKnRiBDV30P1F46eJp3W/LhV72VMFbvObfnneQhfzJ1WQgtlE040YiJ6v2GAY94GGSnzBW784c4uDm9lXHc+2gH1h1NNDf+mWKwyatci2TQg0FV76LGq+e5BgvtT8mAy3Oqh/fn38BopQjsAVcY9O4OaFd7UoZ6uMA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH3PPF2A078470E.namprd10.prod.outlook.com (2603:10b6:518:1::791) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Thu, 15 Jan
 2026 09:14:32 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.005; Thu, 15 Jan 2026
 09:14:31 +0000
Date: Thu, 15 Jan 2026 09:14:31 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/8] mm/rmap: remove unnecessary root lock dance in
 anon_vma clone, unmap
Message-ID: <d41bc94a-0ea4-48fb-905e-a6603682fce7@lucifer.local>
References: <cover.1767711638.git.lorenzo.stoakes@oracle.com>
 <9b5a438237e4ea3b19a986a4f8fddb8848cba54a.1767711638.git.lorenzo.stoakes@oracle.com>
 <CAJuCfpGcdZE_Qnm4c7MgyZfZr7fepXuJkc=6ucwUNwUo_JjU0Q@mail.gmail.com>
 <2808d8d8-e772-4210-ada4-2b39d30c7029@lucifer.local>
 <20260114141204.d13c3a00aec1333e8ad45a8c@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114141204.d13c3a00aec1333e8ad45a8c@linux-foundation.org>
X-ClientProxiedBy: LO6P265CA0019.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ff::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH3PPF2A078470E:EE_
X-MS-Office365-Filtering-Correlation-Id: 27d4ccbd-4b81-4661-3c7a-08de54167e1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EngFd8T2RDJTR4C972ipSO2UcvFaN3djQNf9iJ7mQMD9sL4rXsVcEwlxp55p?=
 =?us-ascii?Q?29Y5BZ7dbRWrUQ1PgJlD7G1XXXUDriDOzLr4zrAfaJib/4TwFGuu3gSRmm29?=
 =?us-ascii?Q?dauOEiNUY1R25nugFe8o3+aiz4qFZrYErl1OeLYJ5WZM6BpG0bjh3rYxmHvI?=
 =?us-ascii?Q?jbtNDVYQYIRaTFIxkEnm7Z/kl4IN4VqQQWG8TO7eQnFtceOQI9DgxPti9nch?=
 =?us-ascii?Q?fKjxDkVBDyB5S5ScO2fcc6PQhQc1ZE4BgV+HJfBg7QaI13MVFrY+kfKoIUw+?=
 =?us-ascii?Q?NzOMPiEZ0mUYywzpJS54HCweJXOrgtRhbbaMpR2J8NHVhJS34I/6ngB/O45l?=
 =?us-ascii?Q?IrhZxEo+sZxMfxeixN7D2kQMJTJzwjpkycZTGtM3sVRRz/xOkCfdz4cYl+F1?=
 =?us-ascii?Q?qFTGbpqDJJAjUXx8KxDrF1u2z8iEXMBMH9uDr3DHEQF1PwA6aKQF7s35E5V9?=
 =?us-ascii?Q?tTymupgDBuZ38HOuIzivF8IvGHSyHnqF76kMqB5S+evtcD0x2YRiJmthflK0?=
 =?us-ascii?Q?8AR4orVwrSgQ3DV+PJUXrXKyd74C3lNKz/IySVKJL1f02SVKKnpLr4ykLYtz?=
 =?us-ascii?Q?AoguSM8Bq0GYziXcY+cCayvOuCYCJEY+cDzgArVYOMsyTyDnedrL44l7B3pQ?=
 =?us-ascii?Q?huNx9HhKizE0btptqBKr2F6HWpjvUIYlz9ScOKi4Pcr98Nicv7X6B24INtBK?=
 =?us-ascii?Q?2cWFhuBWvXVR/5QRY7ZBtod+AcmuEKIQTEKXjrh9ktLxpYEdKFG8L0lfVPRW?=
 =?us-ascii?Q?nHUXLrHeagbUZTfn6LXbhPJi7+EM8opcA9GD0XvgwSwhg2ig0eBXnr77WRLa?=
 =?us-ascii?Q?gnyqVAKYTa4IIkQ9yP6J8wERoRqeHJBNzXlgW/dDC9JX7dyv2xA17dk9hC1p?=
 =?us-ascii?Q?COXCYBjD7Qhr5FfuoYSjFRzwTVeRDB1miJQYaol1+6rhhK2vDzL7cUXZWJJ8?=
 =?us-ascii?Q?cvFxlvcCk0D96wIq8FSCdJQsHx+tkUGr7pOcva9b1gxvvC8e1Gk2jXGQo1wi?=
 =?us-ascii?Q?8jrxgFM8k9uVX2kT3A1LsIvhGO+YX+UlobxyoVkQEfaEaaIiIXELSO+6SUHH?=
 =?us-ascii?Q?BXtn8pgvcL3auxrZ70npEgQOrtimQsmvqgoXi7mQaBR0789Qd7rTbDtqvhTM?=
 =?us-ascii?Q?Jl0QqGW8zhLbhGov4i0zATaAR1lGpfy0t+XVeJkeWEUwrVGbIu4qRpeRFB0D?=
 =?us-ascii?Q?mKx9lmkU2G8/4TtNSCDvR0qsEmEnxGli22fwL1CfA7A1SV8XRNOmt1H3Qus7?=
 =?us-ascii?Q?M21Zn5IBUQtP0GYbiKnSjyysi6mmwqj6vslPTe8jg/ciI3AG9z6wgfgoaxXh?=
 =?us-ascii?Q?py4xBpif+2lzhRxh6gXLUP2tcCpAyTN4QCE2RycD8FN+oM5xh+JLSg8L6bku?=
 =?us-ascii?Q?iT6F7grU1QgeGo/f6PklOcZAvODyjRMB9Q67Bf9L5OKAsMu7wyQ56FiaSUa5?=
 =?us-ascii?Q?SVKiUQYQflfuYZNxzt2H256eFq+ru162ZuJpFm6fk4x461gPiLteqeGQkWvr?=
 =?us-ascii?Q?PPJ4KU1B4qkPplbUk8+TI94K3Ir54agJG7BVWH1ebZXTQi8JN3G5Joe1U7TN?=
 =?us-ascii?Q?zz/ISF2gOt0I6y5fv/M=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?U4ZjR9PVKeePL7q7BHSf8rhtjyF1m8ejwe/NOXFLHLMbOfvGun+BSSAMFsZ5?=
 =?us-ascii?Q?YDZdr3spm4P1tSaMxP3DEuBwq20IQbrBNdHu7W26m7ucLTiKx+O/RY/8FRx5?=
 =?us-ascii?Q?nMVWyBe90YD0djHpuW8xIzeBQtP6gXun5r1RIAVRn7Hhp84baR4L99IvQ3/G?=
 =?us-ascii?Q?Pl7g22KQxsYWPBNZQq5pMXYyQ4M1XGGLARSpaue973tTPbeKZGUbagleIC2r?=
 =?us-ascii?Q?XnkPicob/0NT4jVRVf1XRRmFrDGJMTYIAUzXskAGfVgPhYUqDYYnj8YB1x2C?=
 =?us-ascii?Q?m+YLaEkwh+46HuTF+tWlsvnXGxutt4up0ri2sm+qm3skYRXgNLVe9q3aZnJO?=
 =?us-ascii?Q?EHMsYoz6a7V3kjCP5B4g5V6Ujli7SJb1dmSeua3EW55nWeNELZrNGW0yVEiN?=
 =?us-ascii?Q?XCPARyd2iNQwOzHHsNsRgjC5PvXmBhNttnAObRxaXPzyeUUl2EtYfMvOCTNR?=
 =?us-ascii?Q?+ndzzY8IuzMYPX3flGcUaVkFTFLI4JS/f2s6qLjRft8NDgRlxI7LSk+n2Hwt?=
 =?us-ascii?Q?FY6aSt8A4GRCGp5RhWH1hbYaRVJaUy1pb5nIYuX6h2nqrNoX3YW3xxTcyDIC?=
 =?us-ascii?Q?p1V1egk/k673qJNskzPY2vUifcLn9TrO1DZi2gWZHFfS6wLiGUqZog84tTIu?=
 =?us-ascii?Q?d8T120yajVJdhwRky2NoY6zdyNl4Ib+e3r4Y5+b0uRFlgp14mZXtw2EvAHm0?=
 =?us-ascii?Q?fWIwXezdvmlhdguqBecTo9UbR5qkWpEayb3kJdw2RB07DYB/kjiHnzeMEsY+?=
 =?us-ascii?Q?ksr43XroFxQiVLjsRt73g7LDJmZPPdqciQ846zJjoxgLm6DYz6LEN9Mb4WqP?=
 =?us-ascii?Q?aQqNgCtdlUcV+90x4lDJ8mbzClOsuTJqV1dtJB09TkiZ1YZ6zFXzElwBzs/s?=
 =?us-ascii?Q?ke2pg0ay9fHcxe+TOzQaEZN2xqBitMJLZxlj1vc+8igKd39kw8bpsH72EgPZ?=
 =?us-ascii?Q?sBziGTsJQ5rkU3yZDDhBSXFnsqViVdcQhfekx90Td5OnbdyTClPcbTF7ldTK?=
 =?us-ascii?Q?1Bo/U/+iW57RiVkJ/9t5Wz9XzHNs1x9mFHGBfvbyAWbZ71f8CTmrcdv+Dn9u?=
 =?us-ascii?Q?j4uxZJDxcPlfM3FlFNEXiS8SCzMnPSqyliRhpo4+ZvF6LMK2jNijAK/l/4eu?=
 =?us-ascii?Q?I33lCKvF7lXEsfCZnKxkBJFaDn8XGQPmmC/xP5q5mRzp+VbmMI4z7bOjVJKe?=
 =?us-ascii?Q?TStojjTmTXwiPI//tSYgQ3s2jZmiSTY4Kp/fOOlz67W9omvo3yfk20cXv/dz?=
 =?us-ascii?Q?EoNR8Oxu1QEZY5kJ2CyV/LcuHoKKVt+acBLxeFpvdH0Qp8lm8sy+wQspS6sS?=
 =?us-ascii?Q?kuQ/NcLGQ822UqWHT8eaLHp6HsCW4wznNB/YrSwYzMGrRw1WGRs4ndLsaWPL?=
 =?us-ascii?Q?kE8H2gIzH6QeBpU0jBjkqEHig50LDh7maWYnfF4bUtiQE7XVXNUocdZW1f4d?=
 =?us-ascii?Q?XJaOXnXCE7xTVyvaZX2cCk3sUWJkDONFWGJNzGG3v5fcZdgMvk/4eyUIzevB?=
 =?us-ascii?Q?+f+5dKhlkSg2Qsfq+yxnQjf5gFnQR4mZbfiKVmrdM0+EiSdziDs4aztlZKPA?=
 =?us-ascii?Q?3OcIST9ioxbS3JfbR6g8IVrPsiLCU4DI1D+UQiDXwsxlvKfe5JNwqmLpTnm2?=
 =?us-ascii?Q?vwY9wd5c3NXxJQaQi4xJTQtd3WUhvFd3G5+SQ+6vUw5/7EaN3F/zJMXf9pl3?=
 =?us-ascii?Q?wVhJDYLT2xZ9wfFSQmSGL3aXbXW/NsJPqIxu7kLddcEVbG9fUcCRokwqJO3x?=
 =?us-ascii?Q?7C4xEo4ZtyC5d44qXe8zdSZR0Djf10s=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yTrreWaT/q41SkDvv2TPGU5bIfygT4DF9KjQEmN2DpH09AvgAJ67s2HHaC3FmQ1R1RH5qnT6TgjYjtz9hSLHfwZB07KOE01jcWqyRGWz5uqo+2Y4s8JR/X9ayI5zAewC7nIco5c4tMpOfGSSa3hNquDUVq54/tk4bWFiTCgazFrCoQl3ExdWBHg9Lh/qYkVRD/Vo/hyH/Kif/iRxSGQlglbDoniiiT0s6ESmKkUDIJerQD9NISN+cOAOHYdh24albYuoa3yIr3CxmkWj4AIlRcM7rMnyUFan7bjWsiA6oGFUrF+3UbAYwhaQtGEF4Cb2DI1YHuW8sEvhYSanYbhPMl4QRdVA48lhlTlwcpjW7AfJV85V6uPu7uHM2NmpRtIP2y9Wn786J/VXfLjg7YoUqYMmyXHBdieREQYqzED5RPEaLJrPW3KSWj+if7jd7dE8WFLfGOnVdCEUjbeg4frN38qqS/a60JAXscoVFLuWp3s65wzbP5N1gjtyaJUppEeqfKfVyMrZnU16Y3N1oCamtel+rdBOnR0peB97RVcHNXBbIlTcWwq7VM30dd3fVVmK/beYqdYytBxwFW8n42uoDBdJqpdK5L91pPTMCOQGtwI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27d4ccbd-4b81-4661-3c7a-08de54167e1b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 09:14:31.6358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LrMuAKZAwNrMNX1/Nj/kZweHl7rgShEsmbOeRS7/Hxio62vvibE9CCbb6yqADkcfpRu1PQHi21P8a/6nd6nuyR31J8QFVzfO0YYjCQcI4kA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF2A078470E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_02,2026-01-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601150064
X-Proofpoint-ORIG-GUID: EdY7DU6tT9zu-6WHlVpULEeoyRP6dvCc
X-Authority-Analysis: v=2.4 cv=YKOSCBGx c=1 sm=1 tr=0 ts=6968affb cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=7GoXqpWjAdck0pIUf8cA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDA2NCBTYWx0ZWRfXwsoZcX14wdzw
 I5+rAFJxqzJ1h0CGGpMdRPBsDy4DXHVyAhCuIQXs4aMgPARvGPpyf03JCjVmxvyXX9C0trejWWc
 9q4e2eQN23c06Xrc9LEQscQwAb/5K92BaFOtn7oYwy1WaYVNwNhX1bYIbw1GQP8EsckFd2cEReh
 hc6VDFRyJRnBDtS0b0ZWvTYRMyLVbjic1Twrbhy80A7DCwIRha1pq8hB4Db+esQl2TYtViMjwij
 +6BWpbEOOQ3SYROjBOpkZ4//v0m4k11+8qtVxKGr9a3fHqDWn84o14hpBC/85P8WmxgNlruOa02
 2DdPugwk/gvtdbTJTxz39T75A+MCJ/Xz3CgJBNLoZGVLQdtMN1HfuARP0LWBglB7+zx4iakuATa
 0v8k5ofRrPaRva1qDuUKL2itl50HNvlb3ahofRcGq/uuux21O8Sv7NOee5b2Sg2P2r0v4psy3Gd
 V33LMlGtjmeSHJVDstQ==
X-Proofpoint-GUID: EdY7DU6tT9zu-6WHlVpULEeoyRP6dvCc
X-Rspamd-Queue-Id: 85F6C4000A
X-Stat-Signature: i5yaf1bhggc38rgu6owdgoc5xizkkpws
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768468481-708736
X-HE-Meta: U2FsdGVkX196Fs76rZ9C1ftayA3zXphOryyGkmS2/NuuaD3WYGnW5SknWAbcugFNlB0dGfeMgALr4ihiH4lKxCBWXjSui7VgPhyoxfPBqJUf8UxpTXCIHnxfpN6brntjxlphMM02Q5i/qaSvhb0fabHDCshhTqEv5NdFJcLB4uDQi92Abg2DUO/9RqlciOEQqgWDql5iuQuYjs5kgH5TydKh86Xokk4EUsl4Y/QfnMxp4maAklHj4H9N8ONBLkLtEiTuss1d0FFphT/bSo23dEHvPOXspSRjh7No+0/LGPknHW2GVBPOhKpCOZGmJ3fi66iPSErkG56O78CePtuWgVwVSQFx8715ziZY5W/oB3lDRzEt9Kylu3Q7K8C+GQv9UXFw9BuIJ3/SzQ0++qXEUuDwYiM4g+gKe+hyo4qcV5JosgMMBlRn6dCpwD+qRgEplbAxsBCu/JPeEuYsa0hOzZJgNyWGXW3AOOjVQWpnNIC+9YrnVHyCbCnXqdq2cf6ekzOrMqnppZWyOyofXjTFkoXYK44d7NPjZa0hMndW52TxOlb13sI7ghZ4F0WDb6gJGTQKcPwjCiikXXGhZmLkOeuG8q4XrcGth5PTpKzHSymC3y14S2EnWETd6P1ZAch0jnP+ZG0ThaBZW+shpLaTlwAhMqSicJQiokkpKpFj68pb1860Ij2nGlKYDwrWNPwkr2di6JR6FeJJM2wKmLkvzFbv3Qh+qov8+v9N4btIg03aWEdT/pwadnauvRsgAukA3WbplKrR5rlmwU4zacXOBTPELRZ+ihFPbK6eVpJAzUTxgYaC05jJcrpB+xR7yFTw42OZz9It+EueO7yKS6wVPu1vgJvccOO+6WGvEEhGShY7hEvfE+NgQ0mzv1tbPqCASSmbUhAnNuyEIUHk4j1MH8DgwWKsTH/IvzL6V7aqW7gAkwdFU8sDAWb27wmJTsciYf6uPrawtHdm7h2Mgeo
 B6oqvq60
 IuKEAGnN0XwmewXc1fKE14oTKiXOlXR2mPKfe9VbuT48NySdGIHA3f3q21Ks37LsQaTO1Is/cgSi5c8yV3dhE5LICeq47mqNDbCozC0Z5pKj5wvYMwd4/wvkhKJyBToXRKbC4jIH1LU9CsZAubFCNN/PU92N8pMchW5fXZgLfm+9yQBWNNA2zTBcUTVsQz3ePrNt67rSZVqhAguq4SziLxH33E/v974QayORPvRApO+KQIAOPxA4+e4edi2hYBdRW65awAWTwQK3UU7Z5hCI/TgLbax01qfJWWK/wx5x5TxUVNbk9WsJGToJKsa4ucKsaZKQi8T55a0W/v3l1DofziAT5+bImGaIvE8KsKWoxfI4OlyAxBJNUOsJxpiZ9o/ARIh/thm2vPzfhOYqFDskWeJp0kunkgJKv2D5jLVbYT6XPKOdUDUkMlkuAfpdOxNGP4zhAUk1cxb9FjAyOHXXZ23KFQZhqD26womrGKr9NXlAv3Sl3oefV4Xvn+4KfS8ltIUDELe9yeIm8haPSadyElO0AiR7/KdWrvAK83OC2U/WOcZauBJt8Z5YPX7F4GVtH+WlGqJRyFos1Wd5hKSYxiC8RU32+MjoGGSRXHwPzynkuEys9W2JJoR0PT0vJW5yFYErW09c0nxaNAg8gjRjEplOxaykqOqQsEXpF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 02:12:04PM -0800, Andrew Morton wrote:
> On Wed, 14 Jan 2026 17:54:07 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
>
> > > >  {
> > > > @@ -310,26 +284,28 @@ static void cleanup_partial_anon_vmas(struct vm_area_struct *vma);
> > > >  int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
> > > >  {
> > > >         struct anon_vma_chain *avc, *pavc;
> > > > -       struct anon_vma *root = NULL;
> > > >
> > > >         check_anon_vma_clone(dst, src);
> > > >
> > > >         if (!src->anon_vma)
> > > >                 return 0;
> > > >
> > > > +       check_anon_vma_clone(dst, src);
> > >
> > > check_anon_vma_clone() was already called 4 lines above. I'm guessing
> > > this was accidentally carried over from the previous version?
> > >
> >
> > Yeah I don't know why this is here, in the tree it isn't, maybe Andrew noticed
> > and elided? :)
>
> Thanks, but I wouldn't have done that silently.

Yeah I didn't think you would!

>
> The later "mm/rmap: separate out fork-only logic on anon_vma_clone()" removed it:
>
> : @@ -281,17 +317,17 @@ static void cleanup_partial_anon_vmas(st
> :   *
> :   * Returns: 0 on success, -ENOMEM on failure.
> :   */
> : -int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
> : +int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
> : +		   enum vma_operation operation)
> :  {
> :  	struct anon_vma_chain *avc, *pavc;
> : +	struct anon_vma *active_anon_vma = src->anon_vma;
> :
> : -	check_anon_vma_clone(dst, src);
> : +	check_anon_vma_clone(dst, src, operation);
> :
> : -	if (!src->anon_vma)
> : +	if (!active_anon_vma)
> :  		return 0;
> :
> : -	check_anon_vma_clone(dst, src);
> : -
> :  	/*
> :  	 * Allocate AVCs. We don't need an anon_vma lock for this as we
> :  	 * are not updating the anon_vma rbtree nor are we changing
>

Thanks yeah we figured it out, luckily it's completely benign so not a
bisection hazard so good to leave as is, but still also - doh! :)

Cheers, Lorenzo

