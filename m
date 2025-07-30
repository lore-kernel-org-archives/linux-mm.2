Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99CBAC87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 05:10:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 102536B0088; Wed, 30 Jul 2025 01:10:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08BFF6B0089; Wed, 30 Jul 2025 01:10:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E471D6B008A; Wed, 30 Jul 2025 01:10:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D08B56B0088
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 01:10:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 79C46B7E01
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 05:10:08 +0000 (UTC)
X-FDA: 83719754496.20.FCBD88E
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 142E6C0004
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 05:10:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Snx0iIyB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="z/QmIoU2";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf10.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753852205; a=rsa-sha256;
	cv=pass;
	b=KqDsDcZOGwe7gefKZ9kaN91uwM5JXIGytXWDV2sIet9V1MOj8Dd+2nXQy4hKnzFzV3fp+Q
	/yfymNbLBNX7ARzECNMeeqQTQXrm+Ih7EsgqB4aL5dEg9wt5XU4S27IKRo83gUIQua+g8B
	IVSFy4IU5tS2WMs9myI1lWG9XDjfBCs=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Snx0iIyB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="z/QmIoU2";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf10.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753852205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bl615vrcEL5ZgVI5CwYsbuKrwnx0lk/4G/NC7ZH56dA=;
	b=sBac+vwlDX85gq7f8+vMmAd0HE2x+puzl1E0GsOOWkApoLbGRFUVGT886kK0QmrkIIJD77
	4crfGl2tzKPdeLVm/xCJzOgnLzhEXokjG9kz5uydD1i1V+fOUWaQgN7dsNX+rrm/aydY55
	9lADEhXeQQWFs3zKKNltsaGVHkWgGEs=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56U4Dsq8003883;
	Wed, 30 Jul 2025 05:10:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=bl615vrcEL5ZgVI5Cw
	YsbuKrwnx0lk/4G/NC7ZH56dA=; b=Snx0iIyBzRg/c3v9EW5YaDahYv0rGHejic
	fFafpYOq7YSvCpx/wiHvGqoQpZbwX+Drtx0jW9QMYaCFLSx9/TZlk/X5WYvezxaY
	o2dSUwgTHW9ErXdJLNk3ZlRuJA5DEIaxtK9ttTwxbalUD3yabJs9rvUmw6H6C3on
	fsQ3PgRUT8PtNzOPeAPqAqvYb+dGXS1mKJF1GWgQmXcnaI2yuKbpHouCKiBQwoii
	b+4XMjrbSoKe9wP8bddNxjVms52Opv7ZewvRNzQGT0HXxojscpoeo1NIR0vWIfqd
	dVVrlwAd1gDPmlBvj4ggaqYbOPpcZgtOA9BlNbPqLTuclFVtEAbQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q4yh2cw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Jul 2025 05:10:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56U4uj4f003161;
	Wed, 30 Jul 2025 05:09:59 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2046.outbound.protection.outlook.com [40.107.220.46])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 484nfarqru-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Jul 2025 05:09:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ARjRmo1z2uWkG0wsEvFctQLIvXTNh5ZSmRYzdxZWySNSvWJtQtfOAMVQiz5zS0Y7ls06wT04oWvHNk+6INBELKTYMcBzsh41rRw1H4v6EI+pBhvzfT9rjB5z1GP0QKUjIwnFLRPZoiFWqZxtzcwGxEcOSPfQwxCScoJWsEPPMwKGsaKHoPclUvvbPgJzMx4wkNPJQ7WdgBceZWaNpgewZtZrVqHQnM+K4qOzpfCX7T6miXw4bfYWY178OXeX60M7nLiaItRdG/H0naZYtFRXYpqgj/COBFh2bZP3Igg+34r5l2jGfx+Ac/aRTl4MkGDSCDEJE8tEFJv2Z1adnc5yrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bl615vrcEL5ZgVI5CwYsbuKrwnx0lk/4G/NC7ZH56dA=;
 b=OBNJKxk2FIXVP/rHFDkfEuRN2neailK6Y3VHHQ0nLrVyM8it2TiyVgTWtNqC06plS2UbJ4cqz+rDgiDLUTiWqztAuVsaAL/+Mecg0c3kHvKnu1itzsig9/YMO4XASYOLoqMFRFPFJmwEDzqNXjOw5ERPoKv0POgFkGeA0qjFlv6IeTwSgYzvfZ/YxjnVcX0yrHE41ksmjQXJyLUInP+CzyOyh75thZMTwu2R77c9bjRkgWy9JE0Rxp4Mllhw0KDt2Ok9arQD2kI8FkoLohT1hrPbDAtYNrWx1fjJ2jH7hPWgGMHsIjcqurwAtgjJnOci86sYLvVSdAWLVxsKuPFy2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bl615vrcEL5ZgVI5CwYsbuKrwnx0lk/4G/NC7ZH56dA=;
 b=z/QmIoU2Neppby/L7+XEHxYQeDtjDdVUpalv9s46zKguKtxM7gShxPvjugGizWyKlHy7LhMybTM/Ao49pU+J9i6TsQpww71KWuBUAg/2AHUqghK/DySjBqfahTS24B+CjHvkMxbMmvAmvuSlgMd8/rLlJxAZVut+/JJP17s/lMk=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH0PR10MB5684.namprd10.prod.outlook.com (2603:10b6:510:149::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.26; Wed, 30 Jul
 2025 05:09:56 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.8964.026; Wed, 30 Jul 2025
 05:09:56 +0000
Date: Wed, 30 Jul 2025 14:09:50 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Uladzislau Rezki <urezki@gmail.com>
Subject: Re: [PATCH] mm: correct type for vmalloc vm_flags fields
Message-ID: <aImpHhw5-2laCo98@hyeyoo>
References: <20250729114906.55347-1-lorenzo.stoakes@oracle.com>
 <e74dd8de-7e60-47ab-8a45-2c851f3c5d26@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e74dd8de-7e60-47ab-8a45-2c851f3c5d26@lucifer.local>
X-ClientProxiedBy: SE2P216CA0189.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c5::13) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH0PR10MB5684:EE_
X-MS-Office365-Filtering-Correlation-Id: 9745da93-f8db-4624-f5c8-08ddcf275317
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ib5nH6IMbsb0BDPllKmqPGaiM7Jl1aXHxTZGLrtazgpzj2ro5TOSJbQZZdzx?=
 =?us-ascii?Q?OQA+lE9neniI/uAI3lev/QNcSp/U4nHUvv2up+UsUlltf8BnYx6CLtHyZsiU?=
 =?us-ascii?Q?3P4Fp8w65qUlj8VjEhINLsgQCUcyWI7mdSI7IveTSS5wNBvSI41923PHNYGm?=
 =?us-ascii?Q?fZsJicrOz9nVpPU/ierHDFNxP9ICPkOf6U99vhQDv/FfVlQ+qLlsLJ/1pYgs?=
 =?us-ascii?Q?Oz8YKvxo8tgdI0YNNVJERnioCr43sFrxrAg1r9dHwVzrT+LroIPxB1l+YfhU?=
 =?us-ascii?Q?iU1SaYM6KLjH/KAiQCMrgXaUh0QTbtyGdBNlXfTQ7qitJib76p/0S3cqj1kw?=
 =?us-ascii?Q?P41WRKaJQr9my/V8dkgvM19580blxrxWyyY7M8hOSFIimwQ8p0gTyDr6/Vgx?=
 =?us-ascii?Q?6OQCdosaqwO+tNAdU3MjZkWL5zjp4unkGUOfjQL+f7JhSN1Cjc8IP49jppO4?=
 =?us-ascii?Q?Iu4arYkeTebmY0ALjJVdutGqTCorXhvApgKcicJLQn/G7n4kjt3WWEYCuYnW?=
 =?us-ascii?Q?3Wbv9Syn8DGv1PiFP4EkhTaTCbOLO2EtyF/GT59SMWd4JzeTeSi5TOxKPKZu?=
 =?us-ascii?Q?ZUydc+mHiFWI6wOuYVQAnD/AdoHraCg0Pr7fdq5BJIqO11vOPtqwqB3Ucoob?=
 =?us-ascii?Q?I9EVgVkIgqmB2rSjifclYLdEw6PyG409a+fg+nI907GyfjyxRTWQV/1PdM9/?=
 =?us-ascii?Q?8qrFaNaL+t9reLa78uSgP8Wn8i4FQm8yyhyGHA30HaCQNtQlVtcnam37+ppb?=
 =?us-ascii?Q?WXcmQzMgk8CNBW/wK/HS+vp+Ox2rNLvl2zNQPVwxC9tiZsaMlwA/ptXIND8N?=
 =?us-ascii?Q?c+utu3QQ57RqTdzY4YdZgx0w3/jjtHwm9qklMEiOtfNoY7LY/mlejA9WrC5y?=
 =?us-ascii?Q?8pzmswnLMgOnHelkI6SLp6l0+HP4sBkjT3pe2mOp7R3d7fPuEu0atdhVKYR4?=
 =?us-ascii?Q?GIN7qfVVR5XcbrN6olGzra6gJ3bC2JWIWJ8fta8NrIBabKzCnX11t115Pfb7?=
 =?us-ascii?Q?lZYf/yX7x18ppmQXtdxx6UHxYsXSDM9uApEgVqrPpR8OtUWyuLXtWPp7T82i?=
 =?us-ascii?Q?kEGxJpndNsA7fX+H+KPN0HThEqPKI3GVKIvywdXaN88omTmVCvTjKZkrJoFc?=
 =?us-ascii?Q?vTCYarHf8ekkD97y4hVna3WeLOqJIxhkN9FOtN4aTsdrjAtnAQXCU2r8Rvxb?=
 =?us-ascii?Q?kmk7zSzenTFnuUB7GcmQwXvHLsjOaPGOhlqawa8+dOFX5oipO2sUBaM3Nxa+?=
 =?us-ascii?Q?F6w4tyEaCyN4fJueBkgvImDI1Cyct/wot7jJVRDqRzWl5XKD8StefF4FI7bs?=
 =?us-ascii?Q?6PmYCABSapW/bJgE06qjCtyeXuvnChJw9+mxMNJ3S8xR17tzn+2bolQlWVb1?=
 =?us-ascii?Q?EzqswBN0Hq+yoVLsjXjzxByz5Nznrkvf1evMSQg86Ri6ZEi2Kw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EKREngulpMlRwk/crk4jpnswD/n11lPnfzMQkBw4x89Ta+olSVurqw0FqnDj?=
 =?us-ascii?Q?NMu6UId2aLCefPuWTVlMIdtXjOJDmRZuqZFAYDfHFitXXtBi9JjJB33zqKgr?=
 =?us-ascii?Q?zP7s9lycnm4AT6qriC2O/23VQbKrWCSTSVqkm+K0xJvMzBHrCQAmDJ/AHFww?=
 =?us-ascii?Q?GZVkCVJn6Ts7VemMA310u7Pe0on2whpEXFwxY57nw38OZECNAASCQ1l7SQGh?=
 =?us-ascii?Q?rGW3yj+OuHzQSASW+NQDYjxXCH80LH7sOfFQraoZKNhC93N9uiH8T5gJe6UE?=
 =?us-ascii?Q?fgHvGe/ZONcrqpntG6NIIRIw69IKv3FtTs2xnzCMvKYsPmvqpc31+tXaISmO?=
 =?us-ascii?Q?/Kx3Go+Jjmg+vlsDq/dhpp7tcAx+kkgpp2xLSBzQLuOsHhF9+79pDetrSl7Q?=
 =?us-ascii?Q?1FzR2QYiLTwzP+CgkFiwHOaCDqGdVZtNaydZQQWKLuMPhpaMHJMwstB6khKg?=
 =?us-ascii?Q?roaweY6APm2qS3FnKBn3tEyWkKTV7tonkGxoV/cpv/T7fYdTaPhFZPHeE+sB?=
 =?us-ascii?Q?zvZInAtBw/tXEGa8KiKp/BSkcUm8DiETL56SQEfwcEIUTIC0QXrsT6llDt6d?=
 =?us-ascii?Q?2C33VhwqMzioCRaOON8MQo/rWOY6Q4r4SCVJRcGB3fcJKQe473II0IvjnlBo?=
 =?us-ascii?Q?3i4Nep6s3LErROsWusXWFODu6bFNC8ZWeb+91/hJQFa02YC7cIo5OQtWlTLK?=
 =?us-ascii?Q?XZQ9VfnDfMpttf5i6fOEYufAvXudDuHPd5Xw2EfcdAd5DphDycAMNHuwqUMT?=
 =?us-ascii?Q?LoYRJe9DrPp7Rng/+dD7vxhBpulvMsvkTcGMK2YfbAtkmiytnE/hgyazuxid?=
 =?us-ascii?Q?njSvIKi5MFF1oisPPQNGxPDnHHw5/ZRpyg25tLijKAfeQFeK5z4xgGPYsaxM?=
 =?us-ascii?Q?9M7seJZsHncHJ9+FeSXYmT+qTaauOKcQXJjI5GZB7RcVZ+2wRwyczRYjf9gd?=
 =?us-ascii?Q?vA9222+JXWBWdMtmCPssIty9dbgBSA6+MHLESqptzCl8Twp5kGBVtoqj+A6l?=
 =?us-ascii?Q?j7n5aG+D7Okan1RSOyoXBxI+B2fnGPq3wJp7/PCVxJs/T6QXx96Da2VdawWf?=
 =?us-ascii?Q?wrLmhtB1QFNUNutBOKJy4i3LX8CgMC3h+9Q2mYSxaCe5j5CNQ7pll31XdyD3?=
 =?us-ascii?Q?pKhKJmUvmZAzDY8j15bL1qQOaRwGzWK0T0nX6qe8q6TUGjBJRpo5ZA+rqIPa?=
 =?us-ascii?Q?4b0sVALDJov0+OapRbbdeFtnKmmZvNFYHOoyNPkN97PRz9T9gczidBa7O05R?=
 =?us-ascii?Q?KG/6fIn/nmlsdoQmXehI0QP8hjJzJCR/VEtHBKZQhFXImN4X93xKlNz0i1ut?=
 =?us-ascii?Q?rZYxOjYP+y2g0fU6lVElv7eOvMCYIQbJ5sBr/ekmh4JfQuLX7VDP23thz+Sr?=
 =?us-ascii?Q?8rr4mmbSPilJodJc8vPmVVqH19ORYRVEMHZNBgZcvj2fn3U7FALPxvk83sFQ?=
 =?us-ascii?Q?zAd+0Q6+FqhUUK0UiJFkopFlnkCWHigJOddtoFHwPASlt7fR/5230SFeUdvc?=
 =?us-ascii?Q?mnCD/Zj+nhT+SVHMqj6GhIKkGi9TrTTLmn6eH8esl8bmoG1pq9NhSZH5J/ZE?=
 =?us-ascii?Q?iZ3M/7QW5HbhWGNrHNoCnyimkrG4uTHhEc6GNpcc?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0Eru60TsR2zw8QHu7G6Ib2UWUCgyeviq0WZOlzMNyh5CWAuVXZSHb4TOP+9pftBlKnLxU4gfwpHSN/1dmGYSF89zAn6ih0MY5fuYNbBftC/qET9HFbaNdRgzsw+jZ2+ke7XQW5Zxvi7oSf64ajO2Ml0LWL4Zn2IOoAmTKW4VDWOS9RgmJJMdmc/5iJRYOBW0QRUP73wUYx+XlhFxFEHcyzKL6MtmKgVuQFdZlsYOveZu6kKuvgnx/np5n9fff+IUxavxeggmyUn7gM94UuHVcIV5n6lzCBtZmygy34v+qC7B/Hr+VzhWsZfyqzuNpmywBmj2N3Ro7wa+Pqv0PbsChjgoAkToQn9kXPufchnnSFDuScXcF2hvqHkF5J0EVghxZkVPQ8pmX9L4cfi9wrWAFtpNN47ZKKysBnrpIRuy07RXYzPg0lavMPeRWlrHRqZsGmdOdhNzoqgSYonF+oh/hzRfuAsKZurMiPhjvy7fa+rML/BjGuOqbqNebWfeNESHIC9qnDFSYMQ9KMR/thD49dI0EAb3rHUJyq3PwKV9sEgEl6ZdPXBt08ea+A4rQBsyijyJHAqhldoCWgNKW7Q9SUYctwPyD12HEEQU1InZ4Xw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9745da93-f8db-4624-f5c8-08ddcf275317
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 05:09:56.3307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5igTCT6tRFar9H/r4hrhixs6HzlFObc9IUq7vi32zwndHZNYwALNgHFu5XrSb4/cd5/dEXtauVEJyLCc17adzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5684
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-30_02,2025-07-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507300034
X-Proofpoint-GUID: m-8EAUgVxYV7_k82N_Do31gAmqdlNVAr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMwMDAzNCBTYWx0ZWRfXw83orwKuSJZn
 4hh2DM6B4kFXSS2FrHmLVlO/Y6w2y6f5SLQAMxTKKC6W4jyJjJi2xBJJu1JwPQqSFbyIEy18R9y
 JU+A6HLATrJpmi5OaPU5LzfHCm9Js3mbvSEMwCn1NhjYcc7Q+hoSqftZaebYXrqXw+OSN29ooPO
 yNElEEIiip9JgIfYMhXR7z2+QSnMy0Y5m3xJpo29c90rW123LBgRJhO0hWbUaJdBZgmYIAyoaBv
 9TsL2jIBUvqnP5QOFJrBpIdasG789YBD2yVaZhiKq7YEoB3+0jTz1H+zEqvbj3qpDRxRPUB6CPW
 wK6Je9YqhMSo6bHba5S0cQsBztaSw9vI+SztlpMbxwiVUpHyWHYWl8ed41M92fQj2CkrbkYUU7F
 QWfdYZ5bETVsDpLGgQN7G5slBF60XIJC09L7tG/fyu2JUSlLCSIl13iMZ1WkiRJh158p4gxL
X-Authority-Analysis: v=2.4 cv=ZMjXmW7b c=1 sm=1 tr=0 ts=6889a928 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=LrXbFZEXMHY5fmt-3A4A:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: m-8EAUgVxYV7_k82N_Do31gAmqdlNVAr
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 142E6C0004
X-Stat-Signature: d8ghugsspn5qwoiege6yfnffyiccpu4r
X-Rspam-User: 
X-HE-Tag: 1753852204-803655
X-HE-Meta: U2FsdGVkX19cWoonKEW78/+AgmKxL3Zbz74h/21Na7atlWzAfSCQoQvkROYISzttxEaal9f36vkViMfKGjK+QjwpNyWA03oEcAF7RWiGXWrYAmu4fpZcegmSYmuzbup0FODgL3AjjhuztK224xQ5CC8OgwjkV54EZzJhVIrBgGtPbyew4UeG/goAUGjRaWI6Dpq5JXCumBZevuE6KNUpstf/vztd1QytO++yF1nyb7/5R5EertoPiJAiz6YeXOsevycPCkYgOHgdxLd2v75ONwOKQaHQ8sU80VXtPZQ/pXU+aZi6KG2Wjwgx8SAWqxpFlRMCjAbyp2LhyZOH54olpsceBdPW6DG7/eiz2e9CoLJpYOrvZ14aDhViatyGvekeQ16gUB99ZMma/kOibvC7Q70rJDi/dRCQDwN0xwidye37e3f/GuftULoFjei2TZ+t8+Vbf8pYxeTaALei1pP8JpUxvS2rXBqnXZ9bPGml8wiIqOmImwv5S0Uk3XVEoA2sv/YGjtRBxUXhQUprwWZNPCpWnPkwLuYsd339oyEOPv1zNBqWP6i/TVzy9FypaDZG8PRNGk2rRj7MFCvhjm4BwmfmUejIPRsMADDclB4K2ZD83OWZ7Fq6GxdWkT4d/1ix8Zb3SNlijiuCXnVwVXsYM6qocAsQAHBFUANyUXd+TrwxdmTg+M+kgpg5lR0u99ngo+AYQqDZ3HZGAcn5ok/MLvApUzszTQ5I21gtqP3ZZV7To20lLvygkX5nNbBqO4QDA/IunkxvLxFvilvDKdXndHTknnUVB5jcTyNHrWlXHP8IsNKEJXM2/hlqafoNGd1M0OTkSv1Kb/fPrFqVPiQGK9YuWiVfr/4lZ1QELv316kbohZWQ6kFmVG8sfXubGe5GaVonBamrjzUYUJnrv+ZuvN7G/yl3bw+5mQf1NDK43/2GI74/+HXcOmneu4vEAoNiheaxEzXl1HufaQyDFG0
 yt73EnRJ
 VACyRyOBXnWFO4uyKnGSSg+VuyGdRq523lZwAw16AlodkZdEP7S0stRiEtnyWggVm2L6H/YOhPnyeTZyzAbZ38A4ZbC4D7yf36j4XgWOfWN2fVq4v/u5tJf+Bg+7eK66iI67QfRg83eLkDy2CCQpN/QXpkz75oRTp23adwFHHpZgv8g6aX4DGkkmXNkZik0ZeRk0oaHdiX5brxKqBg5yc77wdNKpdoEHrbEcOuR117N2p8JIsIOYOP+TQCkEMyyXmbKPp4pZz3D7VwwM3y6Aq5SHOYSDBsYgii4g2nmfPxKTm8pnfBKEWq4al/xP1FJhX8C6/uoW9Ax/UIkW6CSaO99VPLzCGBbYgDzcy2uxTyMKCfki8RkCyS3i+og1oKXgMnEvAwARtjCxJ1JgbtJ1mv+H02CBgmFrJeRKCpVk9dRJSyRpsz4KiqX25FuVqbhHzLQiBsgYXi12B4yMeqtmFrXWjk5FhMApbqDV4PJaD8EbyCGJdl5/J/Es76/c4r1b85VqUfxgoTb7ZujWh5qoYsjUaC+zeDOFjzmRsMW9p++RzEEQckDiLE4JfxWmpGa/t2WXq0mXI4TeAnjd14H6nOK4yHGqTW08ZNRDVdHKeZykzzllEsJv9MCQMaBEr1oQbJGP8tP3oONzkCu5lOMVJIfhj22cuR2qx+/XBEjibGO3hRVHJEHvwRWXI5aFEcUbmVphJbt05x7WeN8IOQclJodc4+0FJmooFi7TTo3jXJkY0g5Sr6u1CITe2te2UovWG4Iu/+HM0gPJge6z4vmUlqHtXCtNOZfbYmVbDDK9Zr6Iuftq3/pyIUmKw+gd+gHam9DYf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 01:54:07PM +0100, Lorenzo Stoakes wrote:
> Hi Andrew,
> 
> Please apply the below to this series.
> 
> Again to re-emphasise, there's no _actual_ issue here (using a typedef for
> unsigned long vs unsigned long), it's just fixing up things in preparation
> for later changes where this will matter.
> 
> Thanks,
> Lorenzo
> 
> ----8<----
> From 94ccb0c9e49bf3f9a5a31e2f1da4a722b0a2de50 Mon Sep 17 00:00:00 2001
> From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Date: Tue, 29 Jul 2025 13:48:50 +0100
> Subject: [PATCH] mm: fixup very disguised vmalloc flags parameter
> 
> The declare_vma() function in arm64 arch code liberally mixes the concepts
> of VMAs and near-identically named vmalloc data structures, so I
> accidentally changed the 'vm_flags' field' that is assigned to a 'vma'
> thinking it was... the vm_flags field of a vma, which it turns out, it
> isn't.
> 
> Revert the type from vm_flags_t to unsigned long.
> 
> Given vm_flags_t == unsigned long, there is no change in any behaviour
> before or after this patch, but in future this will matter.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---

Apologies for the last minute review and not reporting it at one go.

For both patches,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

>  arch/arm64/mm/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 20a89ab97dc5..34e5d78af076 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -721,7 +721,7 @@ void mark_rodata_ro(void)
> 
>  static void __init declare_vma(struct vm_struct *vma,
>  			       void *va_start, void *va_end,
> -			       vm_flags_t vm_flags)
> +			       unsigned long vm_flags)
>  {
>  	phys_addr_t pa_start = __pa_symbol(va_start);
>  	unsigned long size = va_end - va_start;
> --
> 2.50.1

-- 
Cheers,
Harry / Hyeonggon

