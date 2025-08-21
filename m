Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F960CA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 08:56:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB34F8E0029; Thu, 21 Aug 2025 04:56:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B640C8E0002; Thu, 21 Aug 2025 04:56:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A04A38E0029; Thu, 21 Aug 2025 04:56:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8379E8E0002
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 04:56:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B6387160339
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 08:56:11 +0000 (UTC)
X-FDA: 83800157742.18.7F2EDC7
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id A2791C0007
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 08:56:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cdaXMzcn;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OSWeydiO;
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755766568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i3ATrHly6nUgjsehLEIzzR+xUMzaX+f0FvEtvBmYqpA=;
	b=1cQWdbfHadAI1/CjpQsAMMl3ro28JCJkuV4emwkUiFRxgjqbiCt0XJN0B0tN+ls/J70geq
	0atBjPwmOzBpjDcnpQcnojvBBpzO2TtpJVL0vJrGSApYj1or5KNWcOs4V0qW5NVqf3kz92
	NMwb+8job3x+DJs0fmtITfoThmw6Ns4=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cdaXMzcn;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OSWeydiO;
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755766568; a=rsa-sha256;
	cv=pass;
	b=Tjn9m39MNeOxSbm6QhIP2c44onqW6s4JXaxeSL8NGIXn1BxC2Avw8ar/iNAroDRIaLKt3k
	O/IdXLO7PjNpRQj0jN9qmJK6VvRpRImFSSdfCC4Q/ILdmqw4qUgjpNQeOlIKjQ7kJI4y9P
	R5XoSd/xWT2euRfb51Rmhwgvbtd7VNQ=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57L82iLM007718;
	Thu, 21 Aug 2025 08:55:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=i3ATrHly6nUgjsehLE
	IzzR+xUMzaX+f0FvEtvBmYqpA=; b=cdaXMzcnO33rUXZgn//Edb6+npww7lVyU3
	iOemtxWR+Wa6ai2eJ7xMt0QPHusZ/8MtyZzGtt7u37+1Ez8cCXPHWTz7j7KF+UUC
	2C+FsawumtOymAMzRwjOJT7aECmV3ThsZNTVcQKFOMvMP7xXJGqwHh+xRB1dONDC
	YqG4QZzb9fi4SzGI1JUP4M3Gw7pCsRj1sXcAGxol7iQCVDP+IFLXNRLFQCxp3BZ0
	LorlDGQ9P+rwWVaxgXJHi14Y6KfBsKRfkbTDRAtVMSN3UCC7e6VoZAfGV2/om2p4
	v3/sqp/NgYgtP88k+Ii+mKm+o3LymkNsOBZdbHvjLuigvAQW+5uw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tsb213-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Aug 2025 08:55:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57L8PiFg026402;
	Thu, 21 Aug 2025 08:55:34 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2071.outbound.protection.outlook.com [40.107.223.71])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48n3sx9ssr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Aug 2025 08:55:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CZIqV8YTYgpsqsdGaRAYAhnXsusvvUegNomAW1fFegU2uUhnjzn+CAJt2ueCNomUplyG5uQX/3gPL/VniyfBdQHDsdviHhq8mjxtKaGAUYdTy/Ct9maj+/QY5siGuK2DjbhD75WOHNYyrDrNzSbnXkwSeeVl8njZIrg51+KVqU4pHG0XjkdL17yoCofE7P7dBYtCl+p+NeaaTQUhM3NnE1+HxTJqp0zJIgfyxy+uouEMtYDsykhAsROrHeqH4UwDBPe6zvvFj2mYfohf1GxAWSFSjzkf+wYMNqyYpuQKqNm+j56KeakdwymztmKq8alKau92K2BUxvdHNq9WyP4+nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i3ATrHly6nUgjsehLEIzzR+xUMzaX+f0FvEtvBmYqpA=;
 b=xkzsnqoRIG3iPHWHAhLMkeoo2ziT780F/u8WLVhuRLIWwvIS2n52Cnvkj+bu0L0tEnWAkudVB/TPaxBwb3XLaFgNeBfbCsUGK4017QNQSIEI8HCgYp9lzpwrO6QpIOPZEnt2qWHjK8ZvuX+ZKl6p2ZfUbdWG9GAFCG2XS7t7MY170driRJ3D4gB+Da2tTcx8Qz3Ie4whKCW7i7yWusaFRJR2sVX2r7iWZXNMUgEhyPKaQiI+seigRnIP5kgfsyfm1aK/sD3T3PxA5hWlgND6vQuHOwOz4C+3y3NoJb+ZfSN3p3qQ4SNWZkhnC3YtKXzzupN9Ay+Joq2ydYeiAiaXyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i3ATrHly6nUgjsehLEIzzR+xUMzaX+f0FvEtvBmYqpA=;
 b=OSWeydiOcmOJHbwWPBcexB3dQVWAXEoG/75C6Akh+1mCzp/MXrk5UkTLqo795+7VcQCQD+A5pruHrRJfgg7nKO2v1veOYQEB8Pv5jVejunKPMAuTFyy88Xu6GGs5+T2rXvMQY6yR3fEr7PwyxHR0zfVGI1g3O9/PN+GmrZ1hLvQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CO1PR10MB4724.namprd10.prod.outlook.com (2603:10b6:303:96::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Thu, 21 Aug
 2025 08:55:31 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.024; Thu, 21 Aug 2025
 08:55:31 +0000
Date: Thu, 21 Aug 2025 09:55:27 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: peterz@infradead.org, bp@alien8.de, dave.hansen@linux.intel.com,
        mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        david@redhat.com, derkling@google.com, junaids@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, reijiw@google.com,
        rientjes@google.com, rppt@kernel.org, vbabka@suse.cz, x86@kernel.org,
        yosry.ahmed@linux.dev, Matthew Wilcox <willy@infradead.org>,
        Liam Howlett <liam.howlett@oracle.com>,
        "Kirill A. Shutemov" <kas@kernel.org>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Andy Lutomirski <luto@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>
Subject: Re: [Discuss] First steps for ASI (ASI is fast again)
Message-ID: <cdccc1a6-c348-4cae-ab70-92c5bd3bd9fd@lucifer.local>
References: <20250812173109.295750-1-jackmanb@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250812173109.295750-1-jackmanb@google.com>
X-ClientProxiedBy: MM0P280CA0100.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:9::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CO1PR10MB4724:EE_
X-MS-Office365-Filtering-Correlation-Id: 11cd83e9-d310-4572-6942-08dde0907bb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?robJVKQbV9sxVJJ+OHf734CUMs5dyjFXAjdOVVSdm43PgCI9F2RjH2bFmbLx?=
 =?us-ascii?Q?rx/6yx/ZGM0Y8+wsx959ypkZai05JYst33nPLMbUnbXd2YhtOKOEq6Spi9BS?=
 =?us-ascii?Q?GKkVlcJ4kzdubXvWoLpZbVQ7l8GxoGn/9OHjOT1EjL9Mj2Gr+u/tJm71o37K?=
 =?us-ascii?Q?STIYU6TSnScXE8hKh/Q0S4/tCSty/A6eMVb09zf9xcHipL5hMkgOQHEGFbyW?=
 =?us-ascii?Q?g8M71A8pFEnViOTkKes/cgMCAz0q47AM7wYCk5A4or/V5NsNZSJTUCrzKIGT?=
 =?us-ascii?Q?UIpoPWKMd+W8iAAuvQ/xhcTg7vBB4qZWEh7cEjtyPqgLyQGqtgPuRgkfaFxq?=
 =?us-ascii?Q?tQkCfkTz/Y4N/mssDNOcH+ylFAIbVzrK3ZSDJvqaY3vhHHqz3f1+cIkplBJo?=
 =?us-ascii?Q?17Po8QT79I0mHuVXMC69t/pZtj7kiDnr2FD53pcu0HPIBrd6I+pZ1tF9aiGN?=
 =?us-ascii?Q?9xW5ivPUiHJlz5MawzSDp7f0wuVH2odhmYgRky7wTmufNGWDXf9lBbHiTjkc?=
 =?us-ascii?Q?aIqod4wtJWzHVR8LuF7DYdz9QScLDg5b1y7Y4z+OehFbl7FJwL1bq16YjpS1?=
 =?us-ascii?Q?GsyNtGYzmtIp0XpIy19UDK6WIomYm49ON79bjX2OJN/4Y7NCb6oFq3dmW66r?=
 =?us-ascii?Q?uR3XZky8HfZqq84qOzdEsfjl5DTU+cK8Pb0DH6hoqrcOXODujJs6fN838h0N?=
 =?us-ascii?Q?oYJSd/R3ld2nFauWtBhWSM0xgN8v8ZixYLjgHfGhDC63PD0hD++fqasAQhsQ?=
 =?us-ascii?Q?S+SxkNz9N4qDjs+npUK4qhLXU8uBG34K1CKqPTVHsCfDsIRjyvOiadbHd662?=
 =?us-ascii?Q?CeBwwTlw9Xgu86D252fUbmAGXQ4mUKN1OX5mllkx6OLSkk3tCLY05KJn/yJ4?=
 =?us-ascii?Q?uaEMuv6NIK6XaadqFvcptwVPWGgExm/6VQEaZYZJSeemRLyKNmIsm133MM/q?=
 =?us-ascii?Q?fMwAClZnMSt7pIYGA9s47a6Kv0OIYd1T9RKSgRaAPLIK6iDZNzzxBeAHKIdD?=
 =?us-ascii?Q?Pk5ARfOwraM3DJS9E1nMCitFM6C4sURD5zgoFlsjs9VHrQdc4ngm7Jfdsh4/?=
 =?us-ascii?Q?yMrtySfcdOTEwFCr2C6ARaX4sLZakAO/yzrnxUUPE35mTwdWQ+vqNGW9TIXK?=
 =?us-ascii?Q?aoda0QAyVh7DcOsI6qqcGj+wx8nqY0rR/eObnbSZwPTbV54K2uq2WV2B9vqZ?=
 =?us-ascii?Q?9NA1/rffjJPpkfXPmAThe5tV5Ug42DBvISkyGJbcOKlzmtZT15c3pIccqCkp?=
 =?us-ascii?Q?AI4hIo3OGZjXBSban1cSw5AIPwKslYxzmVlbJdmWmwSVZQE/ID3swcMQuhej?=
 =?us-ascii?Q?lnk4+ClKTh/LiEOmzuibgvErpDfEe+3NvPjlcFMx1Fc4lSjAVmFCzPC9nxAF?=
 =?us-ascii?Q?yDEAP5ACA68E+tx/Ye03vz84AwYTBm+yM4+JKhB+0YWMP4xk1zK6+iMX1WXL?=
 =?us-ascii?Q?f3+4Q7KAOps=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pmNJqevhagDIuMqXStxiZG4n3RYgP2eyYbTg5FcZ84U+CLntH47saGieWcAB?=
 =?us-ascii?Q?jJUsLHm6FDJRk2qs0Lw/WTfGUgaKp2Vn4RHTq9OhsCCZMb7YxW8pMjN5Z3au?=
 =?us-ascii?Q?v9AOY3vA+l5+pjh04+Ou/WiE8Ms+9pVEAOQC98ILBBky1S0gW+gxT7+WvkhL?=
 =?us-ascii?Q?fNEElfD/eF5nb5dxL22r+xUHiVqnpqxYcBmAY5fTxMfcq0+q8S8nE4E6Wce6?=
 =?us-ascii?Q?9KzbREO3min1lhodbBucTcguppEnZ9xg+LfFl+CE811DJAlwuUbS74jrZYE8?=
 =?us-ascii?Q?5iQAMUOSWBiSatvt8TCjsNzsC1Z3Tx6tlBVX2QlrKs32lJtDmlkdLJNgO9km?=
 =?us-ascii?Q?tM4vPKEYF64HXb6jDpIoOJahFyEqV2d3FtZ76Vou5a69X+NqyP3TaImHrxoY?=
 =?us-ascii?Q?2ohPNjFmlhgMu4H2A6qtwU6LFZOW1wAUIG2cI1AjrYYwza72o6xKVZAOtWuZ?=
 =?us-ascii?Q?zopnJN4+gNqfZX4o6BieYNGAASbOIxeX8HRZoSrWa692wuIDRkjvupMTuJJJ?=
 =?us-ascii?Q?3PNTEUvGimHcESDw8nuUF0K4Mu9u5pU+Syo4Oz9J5Zv2X6agKt/MhETduRYO?=
 =?us-ascii?Q?OkT78ce0ht68IMco36DejYQ5CJUo4edZu9nDOlh6KI+iSUdZEucpeaOOMBak?=
 =?us-ascii?Q?8F/Cjw+rWvsBhkne+iNnOcTX2Xgl4ElP1ZDZJ2Ffm9xwi5Xx+rj+204NrKVT?=
 =?us-ascii?Q?GUaXAOc0lkKoqbeOXenU+O2Ydj3wDvZk/+AYmQe4VcOnQ23EkDZPVN6vxVKD?=
 =?us-ascii?Q?+uW8vfxcAqnvbEbLQtRrt2h95pH8gg4xp0ykV0QkOQpTsUamocIaRE1m/6bb?=
 =?us-ascii?Q?apPQyMuF3U/fjg+LOANX0d9kRaYf2NEg+QmJOjNNJDHS+pUo9pj6OFgWtKUZ?=
 =?us-ascii?Q?nFTOVLsnRsFNN06l3VtYHcq2O2dtMGIKjqZnm5jP/o4us3liIqRbSamU/orR?=
 =?us-ascii?Q?FNIAD6I4K/e1inWYwoltyD0+uFxndEZnXXhngAZr3rSSKVQ0W4N800/bLEvE?=
 =?us-ascii?Q?WXYhyn1gCtDfKjk90gvNb8VqXRG9kMZ2vkIkutUguh4J4XKFBzw/9Nn36azq?=
 =?us-ascii?Q?CEQ1dLS6NnPa82+q3GEfFuMVF4kMsgbT/vbJ0UFa+UldyJGwHk0D4qok1IlX?=
 =?us-ascii?Q?9HLiIdmQJkeZbjkyKeZrySegAQwJ7tqWLezVP8DTFPAq43RXSMILbj9fou+p?=
 =?us-ascii?Q?lThjlMWzqWkWxwYBol3OFm3So04MrmmWHc0mvxOsLKfsq8dJG/PnoHbslM8Z?=
 =?us-ascii?Q?McOX+f/+7FqfGsX5Sd7e8RpJIqsFhxYELdSxNKZVH7DRgYpJNzgxoYgs7HM4?=
 =?us-ascii?Q?+bXjuXIKnZ23tw55kLYsR12Gz1xW/9ll8M9FuNLjtDZ1klvZ8wq5lrvoaBEn?=
 =?us-ascii?Q?Xp8fcUzBTzHMIE82Bjtbuns+Puno3NLGjxEYng694Z61zNuY8dn+KSWKJcmW?=
 =?us-ascii?Q?5TI6Talit+PEq6EDWDWrIlLxneiHLrNv1t4FMrnh58e13SrK0Lmvm3nhB/nJ?=
 =?us-ascii?Q?bszqGjBcc0ufAtiXK4BcipSdH2LRkInrAPnDujtC38PKcnE5xsBvxqVq98v1?=
 =?us-ascii?Q?FqFX0O80KGTediasOjufKtxe54611KiK2CLbhccKkz8DKJxInmpZX/PjeHRZ?=
 =?us-ascii?Q?8g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Up4eNhgbB1e43qIOTNUPEWDBo4DKlgaRfio84bzKIFVBdsNUkW/ytz8B8/2kz1yu4vFFxMaFgZaalQGa+EnZuruEL3NfanhKcMvibfGYdypL1D52RKINihzb8jNMhyvYqT6bAKqIlRyl8GzNDy6WWVlxVt2G5YlXtF7n+YroZAEzWfmhvfPwcm/D8p86FnVTghGuewOeyvgNGc/0pLVn7V6CtrCK5jgGRvjp3yIbLeNe4a/Hq0KGf59A/H315VO+3o0l4aVoqJcCpj7vnnGFpxhABYZZMSzntbh5HqaySQsvMnDGhMILFP2EJ7O4FfTS1b5sCAjVF8oCihOyoF7E9NE9Ch8sl2t9EFTt22V573wd8GMvIHv2nL5dM8EQLbo7nqTeNbA1pX2yNyP+n7ISj1CMURYr3xhILM6jCuQAtQOnB33teH/L+as+PtIe4R0SSNoBQ2sOCFXuJdEMB0PiTNxtRPpWnDOKjHWvGv7S5CCi04NBD2ZrnBAajr9GV+/Cm3/YMEdwwOeZdEO9cUnNgoAb0lkoTh5vfScsEY9nk7FuwJErgH62EKdYeFaIxexCQ4P6vaNoOW8NpLlGmDBcngCGsFpOhfzthxNsqBg2hr8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11cd83e9-d310-4572-6942-08dde0907bb9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 08:55:31.4802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dkavRbo1ghjXYq5sZ+wUhLHObZFYW9/tJBb19PRbLtsm0Fo+yxHjMFGpT+gpFEkyXOTU6h720svowuyXMzkWPf0l4bUAC0mE1GraTfWHg8Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4724
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-21_02,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 spamscore=0 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508210069
X-Proofpoint-GUID: MxNV5-EtyGvb67A88C7Sd4ZKbuj1JJNi
X-Proofpoint-ORIG-GUID: MxNV5-EtyGvb67A88C7Sd4ZKbuj1JJNi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfX504FgkvUbi6D
 o1ECISVsBGwv01N06R7fc4teHbHZh5khxBS3poKwc/EqB4+TwBaiT+R9WkMBM7Fu/YO7o0ZpU8N
 YJzhzyQUeyICqZ04TpbTqKU2zwlF7qUs2gFfOtv37Nhd/Ik0uw3uw/kAkoB/u/QUzuzqVXrSVT4
 01uG9SgFN7mvdg0UBwr0GP+/N5JEoR+Uy+hSGurQPFZPP3q6e+uS7QRPrkfuKdATttjl9tS0zet
 koiRfwoc9bFC5b7k/t5QsR0QRKOqUeUxeMhfCV9Eq0kEh8KYhSqQb4heYkf29b+BJLV5iEJnGIA
 jVRPJJmfS6AhXxqGvGLrexlcFXlzfVvXmPYomZqhJkFi+VnnEJ0DB4a4l5wFUGMlkjpugGEfJ/9
 c1R6rolYgZpY/jz9oIYJOQUvR8DYNQ==
X-Authority-Analysis: v=2.4 cv=HKOa1otv c=1 sm=1 tr=0 ts=68a6df07 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=1XWaLZrsAAAA:8 a=NEAV23lmAAAA:8 a=RmfY8Sjn0mIEeRol1GEA:9 a=CjuIK1q_8ugA:10
 a=nl4s5V0KI7Kw-pW0DWrs:22 a=pHzHmUro8NiASowvMSCR:22 a=xoEH_sTeL_Rfw54TyV31:22
X-Rspamd-Queue-Id: A2791C0007
X-Rspam-User: 
X-Stat-Signature: 1634beqjtxhypgzomf4sgzrqzy8n7qmg
X-Rspamd-Server: rspam09
X-HE-Tag: 1755766566-781212
X-HE-Meta: U2FsdGVkX1+9gEToH1l1PundYnQLGnqCtlPxqT/509kbjWe7lZXSqVWqm59O6nZVB/MMnst2HHULdDGN55F4ZSfIx4YL8f+3bvLGiQqXZClI087HPr9WKecGa5CefM3sh91zWz/mSYlsTXVBEpxG+M1u2gc0NrkjbJmPGTyHnbOUa1Rb/vBOA+A/WfbN0aSJSNZwZXlphfNPxPb+hCMlXs6UOvNss7fvbhxPn8JVXl+ajA6J26NCLjs2KaH+gg2bqdMmFEfkS9wxy4SZ/IVtXCuXcA39N7JpFaDu1K7t6eYSd/DviCsrkGHoLNIF3pkjXNIvFe6j6dGAShO5/EELaocbA+rihG8v0XmCmXjjxBxbmtfKp7MziH5I9P/123w4PMRY/y47sTUF5K/PE1LCz4bNiUIqgCt3DQDRDn8xChh7EVLKTIhi8dwscJ9fSGGh62n7fHG4a3WLxu76kV1fzywbzbCmLWaQx6TkMsIMBNR19wUXBoIq6FcEdiwsDU1WqSOixRRrEs3PPXvS21RnKNE6sh5gQmsttctvHtQ2VEF+OR537f5LK5Gzt8zsvlauLXgNlZqvgYBEYwYHNt6X3kbcdr/3Yb1SH+QY/uNyVw7/LJQiDtRYLxdTEapk10SY6sZB0xt44Jmtl9IA/4zWqsHJfBPeIJVmtElFltN5N1O1d/5CidV3NA4LCZayTXZ1HurWr4XQgYQ7R8VRgYgXSK4dwZuxhGxgt6sU3KUuByvEnHQvwb7AOQcRQIC1knzAkLaEQf84Q5v/X9Pbw8Q9lIGkge+ibAya2SjdlkgCWbCohCmvYoolEf1dboxncOrCZxflQGbgukGu/NGM3MTW8DcDLUfij1CIw8CqYQa0Rfu5JApVKu2RCwIKRH/M4GDcEXiMALuXVXTBT0AmE/FzBx26S0azxI7B6pkdx6iX1ndSf7bqdsKRgiXw/x1TrOWk1Vkfzl/9QYZXgYbbZRc
 QDPXGdZB
 iO22VqqT+2ohwbyEXSqmfX1dRStHUjkSeYBJxuxQPmYufc/rND5S/LIQSj4zt5ei046UJKaDPGOGRwJ8dfuPpq6gwuw4DzgJGUU/7OxALGwE7WB5142ETO7LFJGLLzcvmnz4CMSOgwk/tigXLviM/OEEwOitz4m06hSvvUQmOTHd1+eb2D8xaxWCIH6UllZNSf1L5KBv5BL+IPa7o7sC0veOGnS8SGjfp/JDbWnIGiK8yozYCS7yJ9G0VOSglQGK5fjUUEx1FgQay8IWwKzEaEtTNbqua/Jx/MQ6us941P663XRor3eaKyLmWrVDVwGnZzeHFCwiK4RRq6DCtKtn+P/TpuCU1o+4a33K8Kwh450pxkmqzxgmKrxeibD6lokNVO+IgscZ1olH2kAPA/LeDC78NUce7I23wXOABF5m5uCw6IJL4B8vn3zAZUD2gA0+m519nVZc3qy8lRKL6tot6NiPUbnnoe7h/fgNBO1i2OQltOHf/GFplE/F+Fg9LEExKqVxt0Tf8Zfu27+YQ4Cadv7FeeLsOoTCMv4HSLRbfB5ftt2KbW7kDX62RLIONKSlwvYtZmmpExC5dSvTG8QdfTJDZvwklPpXsCwAbCZr8AXaZb53Z6pvY3vZJEAo4NrIlbc0qbhNO8qRY/yA+u/ipz/SKWjtCeL0PJPGamtdmsdn55+FtBkO5f/ETatlubutmhIU0y/yEDDNIUVzfBqSxhU47yNjyKGOqgM8eGmuELmeRUfl3PxmBh7yPK9hixfxKLyZSgDzLHWxW+38=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc Matthew for page cache side
+cc Other memory mapping folks for mapping side
+cc various x86 folks for x86 side
+cc Kees for security side of things

On Tue, Aug 12, 2025 at 05:31:09PM +0000, Brendan Jackman wrote:
> .:: Intro
>
> Following up to the plan I posted at [0], I've now prepared an up-to-date ASI
> branch that demonstrates a technique for solving the page cache performance
> devastation I described in [1]. The branch is at [5].

Have looked through your branch at [5], note that the exit_mmap() code is
changing very soon see [ljs0]. Also with regard to PGD syncing, Harry introduced
a hotfix series recently to address issues around this generalising this PGD
sync code which may be usefully relevant to your series.

[ljs0]:https://lore.kernel.org/linux-mm/20250815191031.3769540-1-Liam.Howlett@oracle.com/
[ljs1]:https://lore.kernel.org/linux-mm/20250818020206.4517-1-harry.yoo@oracle.com/

>
> The goal of this prototype is to increase confidence that ASI is viable as a
> broad solution for CPU vulnerabilities. (If the community still has to develop
> and maintain new mitigations for every individual vuln, because ASI only works
> for certain use-cases, then ASI isn't super attractive given its complexity
> burden).
>
> The biggest gap for establishing that confidence was that Google's deployment
> still only uses ASI for KVM workloads, not bare-metal processes. And indeed the
> page cache turned out to be a massive issue that Google just hasn't run up
> against yet internally.
>
> .:: The "ephmap"
>
> I won't re-hash the details of the problem here (see [1]) but in short: file
> pages aren't mapped into the physmap as seen from ASI's restricted address space.
> This causes a major overhead when e.g. read()ing files. The solution we've
> always envisaged (and which I very hastily tried to describe at LSF/MM/BPF this
> year) was to simply stop read() etc from touching the physmap.
>
> This is achieved in this prototype by a mechanism that I've called the "ephmap".
> The ephmap is a special region of the kernel address space that is local to the
> mm (much like the "proclocal" idea from 2019 [2]). Users of the ephmap API can
> allocate a subregion of this, and provide pages that get mapped into their
> subregion. These subregions are CPU-local. This means that it's cheap to tear
> these mappings down, so they can be removed immediately after use (eph =
> "ephemeral"), eliminating the need for complex/costly tracking data structures.

OK I had a bunch of questions here but looked at the code :)

So the idea is we have a per-CPU buffer that is equal to the size of the largest
possible folio, for each process.

I wonder by the way if we can cache page tables rather than alloc on bring
up/tear down? Or just zap? That could help things.

>
> (You might notice the ephmap is extremely similar to kmap_local_page() - see the
> commit that introduces it ("x86: mm: Introduce the ephmap") for discussion).

I do wonder if we need to have a separate kmap thing or whether we can just
adjust what already exists?

Presumably we will restrict ASI support to 64-bit kernels only (starting with
and perhaps only for x86-64), so we can avoid the highmem bs.

>
> The ephmap can then be used for accessing file pages. It's also a generic
> mechanism for accessing sensitive data, for example it could be used for
> zeroing sensitive pages, or if necessary for copy-on-write of user pages.
>
> .:: State of the branch
>
> The branch contains:
>
> - A rebased version of my "ASI integration for the page allocator" RFC [3]. (Up
>   to "mm/page_alloc: Add support for ASI-unmapping pages")
> - The rest of ASI's basic functionality (up to "mm: asi: Stop ignoring asi=on
>   cmdline flag")
> - Some test and observability conveniences (up to "mm: asi: Add a tracepoint for
>   ASI page faults")
> - A prototype of the new performance improvements (the remainder of the
>   branch).
>
> There's a gradient of quality where the earlier patches are closer to "complete"
> and the later ones are increasingly messy and hacky. Comments and commit message
> describe lots of the hacky elements but the most important things are:
>
> 1. The logic to take advantage of the ephmap is stuck directly into mm/shmem.c.
>    This is just a shortcut to make its behaviour obvious. Since tmpfs is the
>    most extreme case of the read/write slowdown this should give us some idea of
>    the performance improvements but it obviously hides a lot of important
>    complexity wrt how this would be integrated "for real".

Right, at what level do you plan to put the 'real' stuff?

generic_file_read_iter() + equivalent or something like this? But then you'd
miss some fs obv., so I guess filemap_read()?

>
> 2. The ephmap implementation is extremely stupid. It only works for the simple
>    shmem usecase. I don't think this is really important though, whatever we end
>    up with needs to be very simple, and it's not even clear that we actually
>    want a whole new subsystem anyway. (e.g. maybe it's better to just adapt
>    kmap_local_page() itself).

Right just testing stuff out, fair enough. Obviously not an upstremable thing
but sort of test case right?

>
> 3. For software correctness, the ephmap only needs to be TLB-flushed on the
>    local CPU. But for CPU vulnerability mitigation, flushes are needed on other
>    CPUs too. I believe these flushes should only be needed very infrequently.
>    "Add ephmap TLB flushes for mitigating CPU vulns" is an illustrative idea of
>    how these flushes could be implemented, but it's a bit of a simplistic
>    implementation. The commit message has some more details.

Yeah, I am no security/x86 expert so you'll need insight from those with a
better understanding of both, but I think it's worth taking the time to have
this do the minimum possible that we can prove is necessary in any real-world
scenario.

It's good to start super conservative though.

>
> .:: Performance
>
> This data was gathered using the scripts at [4]. This is running on a Sapphire
> Rapids machine, but with setcpuid=retbleed. This introduces an IBPB in
> asi_exit(), which dramatically amplifies the performance impact of ASI. We don't
> know of any vulns that would necessitate this IBPB, so this is basically a weird
> selectively-paranoid configuration of ASI. It doesn't really make sense from a
> security perspective. A few years from now (once the security researchers have
> had their fun) we'll know what's _really_ needed on this CPU, it's very unlikely
> that it turns out to be exactly an IBPB like this, but it's reasonably likely to
> be something with a vaguely similar performance overhead.

I mean, this all sounds like you should drop this :)

What do the numbers look like without it?

>
> Native FIO randread IOPS on tmpfs (this is where the 70% perf degradation was):
> +---------+---------+-----------+---------+-----------+---------------+
> | variant | samples |      mean |     min |       max | delta mean    |
> +---------+---------+-----------+---------+-----------+---------------+
> | asi-off |      10 | 1,003,102 | 981,813 | 1,036,142 |               |
> | asi-on  |      10 |   871,928 | 848,362 |   885,622 | -13.1%        |
> +---------+---------+-----------+---------+-----------+---------------+
>
> Native kernel compilation time:
> +---------+---------+--------+--------+--------+-------------+
> | variant | samples |   mean |    min |    max | delta mean  |
> +---------+---------+--------+--------+--------+-------------+
> | asi-off |       3 | 34.84s | 34.42s | 35.31s |             |
> | asi-on  |       3 | 37.50s | 37.39s | 37.58s | 7.6%        |
> +---------+---------+--------+--------+--------+-------------+
>
> Kernel compilation in a guest VM:
> +---------+---------+--------+--------+--------+-------------+
> | variant | samples |   mean |    min |    max | delta mean  |
> +---------+---------+--------+--------+--------+-------------+
> | asi-off |       3 | 52.73s | 52.41s | 53.15s |             |
> | asi-on  |       3 | 55.80s | 55.51s | 56.06s | 5.8%        |
> +---------+---------+--------+--------+--------+-------------+

(tiny nit but I think the bottom two are meant to be negative or the first
postiive :P)

>
> Despite my title these numbers are kinda disappointing to be honest, it's not
> where I wanted to be by now, but it's still an order-of-magnitude better than
> where we were for native FIO a few months ago. I believe almost all of this
> remaining slowdown is due to unnecessary ASI exits, the key areas being:

Nice, this broad approach does seem simple.

Obviously we really do need to see these numbers come down significantly for
this to be reasonably workable, as this kind of perf impact could really add up
at scale.

But from all you say it seems very plausible that we can in fact significant
reduce this.

Am guessing the below are general issues that are holding back ASI as a whole
perf-wise?

>
> - On every context_switch(). Google's internal implementation has fixed this (we
>   only really need it when switching mms).

How did you guys fix this?

>
> - Whenever zeroing sensitive pages from the allocator. This could potentially be
>   solved with the ephmap but requires a bit of care to avoid opening CPU attack
>   windows.

Right, seems that having a per-CPU mapping is a generally useful thing. I wonder
if we can actually generalise this past ASI...

By the way a random thought, but we really do need some generic page table code,
there's mm/pagewalk.c which has install_pte(), but David and I have spoken quite
few times about generalising past this (watch this space).

I do intend to add install_pmd() and install_pud() also for the purposes of one
of my currently many pending series :P

>
> - In copy-on-write for user pages. The ephmap could also help here but the
>   current implementation doesn't support it (it only allows one allocation at a
>   time per context).

Hmm, CoW generally a pain. Could you go into more detail as to what's the issue
here?

>
> .:: Next steps
>
> Here's where I'd like to go next:
>
> 1. Discuss here and get feedback from x86 folks. Dave H said we need "line of
>    sight" to a version of ASI that's viable for sandboxing native workloads. I
>    don't consider a 13% slowdown "viable" as-is, but I do think this shows we're
>    out of the "but what about the page cache" black hole. It seems provably
>    solvable now.

Yes I agree.

Obviously it'd be great to get some insight from x86 guys, but strikes me we're
still broadly in mm territory here.

I do think the next step is to take the original ASI series, make it fully
upstremable, and simply introduce the CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
flag, default to N of course, without the ephmap work yet in place, rather a
minimal implementation.

And in the config/docs/commit msgs etc. you can indicate its limitations and
perf overhead.

I think with numerous RFC's and talks we're good for you to just send that as a
normal series and get some proper review going and ideally some bots running
with ASI switched on also (all* + random configs should do that for free) + some
syzbot action.

That way we have the roots in place and can build further upon that, but nobody
is impacted unless they decide to consciously opt in despite the documented
overhead + limitations.

>
> 2. Once we have some x86 maintainers saying "yep, it looks like this can work
>    and it's something we want", I can start turning my page_alloc RFC [3] into a
>    proper patchset (or maybe multiple if I can find a way to break things down
>    further).
>
> Note what I'm NOT proposing is to carry on working on this branch until ASI is
> as fast as I am claiming it eventually will be. I would like to avoid doing that
> since I believe the biggest unknowns on that path are now solved, and it would
> be more useful to start getting down to nuts and bolts, i.e. reviewing real,
> PATCH-quality code and merging precursor stuff. I think this will lead to more
> useful discussions about the overall design, since so far all my postings have
> been so long and rarefied that it's been hard to really get a good conversation
> going.

Yes absolutely agreed.

Send the ASI core series as normal series and let's get the base stuff in tree
and some serious review going.

>
> .:: Conclusion
>
> So, x86 folks: Does this feel like "line of sight" to you? If not, what would
> that look like, what experiments should I run?

From an mm point of view, I think obviously the ephmap stuff you have now is
hacky (as you point out clearly in [5] yourself :) but the general approach
seems sensible.

>
> ---
>
> [0] https://lore.kernel.org/lkml/DAJ0LUX8F2IW.Q95PTFBNMFOI@google.com/
> [1] https://lore.kernel.org/linux-mm/20250129144320.2675822-1-jackmanb@google.com/
> [2] https://lore.kernel.org/linux-mm/20190612170834.14855-1-mhillenb@amazon.de/
> [3] https://lore.kernel.org/lkml/20250313-asi-page-alloc-v1-0-04972e046cea@google.com/
> [4] https://github.com/bjackman/nixos-flake/commit/be42ba326f8a0854deb1d37143b5c70bf301c9db
> [5] https://github.com/bjackman/linux/tree/asi/6.16
>

Cheers, Lorenzo

