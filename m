Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE4D3CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 17:35:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 462268E0028; Mon, 17 Nov 2025 12:35:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 439398E0002; Mon, 17 Nov 2025 12:35:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 328188E0028; Mon, 17 Nov 2025 12:35:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1D95F8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 12:35:13 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BE18E1A0237
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:35:12 +0000 (UTC)
X-FDA: 84120800064.12.CF55E40
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4790518001B
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:35:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=HDfaYkSe;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lzW05XrB;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763400909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5NbG1IAAzqQyvRXuTiFjpv6Ffh7TT+M1KTjae9HT8o0=;
	b=C4DmZZbfuqRVs5X9/7eRnOWFsdc6aoGbBwvVXZCc5G6P6iI1XBJbIBjTwNExTQsEocYsbX
	vy8VSHtwKVoLLULAbKS27gn4fe6rF8necW5rxgIJYn0uxK4WaLXTkOVKYUBy70fVDC+8y0
	VOv5iny9QNVwT+eqFFduzCNQ7ljibhM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763400909; a=rsa-sha256;
	cv=pass;
	b=I7rzY7+kBqRbr803dGNwb11RMD7HFwoPn1Ph/p+Q5TPN/pomrIlIrwrSoTqHbsFuuuMk2m
	J5rvbL6fZf3xUtvZUjLeZ2jcn1ZwD+uJuE0tnmwHjyAs1yg6V5bOPwLxfxuTMM7g5AEz1A
	SHXBwrYnXAEQWF3AQYjlkjhNvONoR70=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=HDfaYkSe;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lzW05XrB;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AHC8EkE005481;
	Mon, 17 Nov 2025 17:34:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=5NbG1IAAzqQyvRXu
	TiFjpv6Ffh7TT+M1KTjae9HT8o0=; b=HDfaYkSeZuEbdo0QCAQPc3nXLAqSfmFT
	YikpeWUIxzEYGgVojjstzbzhNlITpn10kq9/6CtApw/oakolwK6pQ4bC+pghDzcu
	33WdFCWtIeFwUKwKPueQos+v3s0f24WyMua82+ab3i/p5N2eTjAIUAMO406qwFry
	5k73YZnhHyBOcDFJqilnew387NQ04R98XQMLzY3R6mBD5vkeyUh2MNtIw7i/2Qkf
	xNgojfyo0jXhSqR8Gul+LQZMG3KxjcYgMBUsHsU0EjNAGvufKMkjZh2zRZwpmQmE
	alDL2LNkb+qN7+c2Ux4CI8u2eg0PKv39Ei+4uSVjrpzXQ2gth+ikhg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbbtyu4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Nov 2025 17:34:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AHHPvU6004274;
	Mon, 17 Nov 2025 17:34:54 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012007.outbound.protection.outlook.com [40.93.195.7])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefy7qsgg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Nov 2025 17:34:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q32Ey7Mi98THPietWWyl8fxGBvDjptAqJNrnTUTcj9IRQXsixrdQmZ3RoVNxXcdbkBjyupoeyMbnp59fVoBQJLbVLieCW+3Z9Ay0iTOkntRqd/31s3MlpEjN67MQ6zASF3T0yBz16nxjPeb8R0F+zjprPnO4Dp+KKxJH+9DaeaND74+qvI70lm60P97IEn9K3CgrBZ3y7jQg32LQEKjU9+RZGrg/mYEb+Bk+V8vXYqMT7ku3tjxBfMz3nVPuhn8CUTPmtOMrHNtuTXq4iyDwnGiQb/puUbc2C61ZbYGLQTyk6urS7LXRm18KQ8L0Q3F7R4WQXrbY3NSwM/dXmEomAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5NbG1IAAzqQyvRXuTiFjpv6Ffh7TT+M1KTjae9HT8o0=;
 b=troPIZ7ZVUjkxZbs8d35fyPnLGiPCXpcYIb+eDxv2eVy+KdhFi0q/OFlvMC3Qh9aDBNXFlB2cr50+RAkHLPp6V56gN5hnKZkAVL0h1mV/cw4X1Ug8QMiSqzF7B7nO/rPbjzE/swBIq5jomtzwQE3baIJpkI/z28TAcOG0mSlHQPYxrUORTa3M+H2VZv1RpYqYwE4f4JypzIGxypjzCH0a1NtsitoPaGcKfOyWepJAFCXXnnkrEsj0kNetS9BmGX4yfibOC1O6bT08+z/Bkn+sUmTFAdKeyFb5sRAvlr6RJcXfi55VOAkLrVLxFh6WpJZ3Xazu8y9BR8WT2C4gTFXUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5NbG1IAAzqQyvRXuTiFjpv6Ffh7TT+M1KTjae9HT8o0=;
 b=lzW05XrBCfBifLoxG/uefM4D5zI4sEVhkqQz73LkS2vTLw+p5/hz0kOiSf+yIpqGaaIiSXaQCl4llMeBEcCCCgXEjO7FPXJGXJZGb3YqBA9vKFFL9yfzyi0OUOI77va/KZA19ZmjN/iEBPYutnnGN1qB0wXLYPl08lPKBvOkVCY=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV8PR10MB7944.namprd10.prod.outlook.com (2603:10b6:408:208::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Mon, 17 Nov
 2025 17:34:46 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9320.021; Mon, 17 Nov 2025
 17:34:46 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] make VM_SOFTDIRTY a sticky VMA flag
Date: Mon, 17 Nov 2025 17:33:37 +0000
Message-ID: <cover.1763399675.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.51.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO0P123CA0009.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:354::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV8PR10MB7944:EE_
X-MS-Office365-Filtering-Correlation-Id: 41f2732b-cf7c-478f-62fa-08de25ff99ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?i6grgnrwocYprDroNswfPOaOH+yAHGSmRBRLhGNP1PQ919y7AaMMUYWNFuOV?=
 =?us-ascii?Q?atLkWc1Yl8A8Np6alHQXMflNJSZqj9SHXqYrqj1NvXf1WIYoylVZ+PPMJLUd?=
 =?us-ascii?Q?HOgaPxb/UBDpO676W9VbOVaTgXlTuFZ73sKB7waPAUjC+gyCRHWB3DmEn0Wy?=
 =?us-ascii?Q?YYmZyGHCV5eyMn74SivRc2+SYNBqeuv5PThmlOr2E0qTAhFCIyE8NzlK6Ujm?=
 =?us-ascii?Q?7rB3WBmaBMyyv0mWe25L9owCdO9jmNDcStdMLv2VCuUvYEqEKmIxG0RlnMGk?=
 =?us-ascii?Q?kVC+3MeWlODn+IC0n6LJFIG+zl0dRz1u12sc56FqDt/KkxyvoyM+aFfJRdVd?=
 =?us-ascii?Q?tBoenPxylgYzBD1AjR0a2BVJTeMv+qVWX1XBnex3Pn4M1DVEIzebki5ussjR?=
 =?us-ascii?Q?baspColy8y49IVbYxIit0mnmGuzhEVPDHV5uXi2N/OTKl814yLjjo45cWgRO?=
 =?us-ascii?Q?H54D7OZVU2HDHK/sqWMxTYTD4fKzEOyt/MbStfUepCGAhWwAyWqEwAd+T56a?=
 =?us-ascii?Q?HCcAu1w/pBotwOXcST0S+Q50dYV/Z7AxmWVMcsM0rLsFn1ahR2V0pqur+WmQ?=
 =?us-ascii?Q?LHLHor13wqWtg3q3UG4M8Z8TQx2ctd+jOs7SmCOTL/8iipqoUnor+UelG89W?=
 =?us-ascii?Q?yCSF1UPKpwojgLuTKm5w4kml6fTdJxkIEk5HAE9AC69jPwugjM6tCAiMGaoe?=
 =?us-ascii?Q?B7YzdRdoHx0TD3KAvUHae0ZifFmjNWaUV4BtzB7nMjgc14IBh0hMl17SBUdl?=
 =?us-ascii?Q?BIHKyhG6Pej0FACdO3lm6zo9gkBkXotP6pFt0OMbc+Y7KiUv75F065L4J0cU?=
 =?us-ascii?Q?pErvb7xoCrgVp2ACgMRfc1GBRPjFrawp7ohKZEvJRqRxeNI6AuDFvzuqtMKN?=
 =?us-ascii?Q?u+Tn4FqwXv0tBEPc3T8o9rdcdHGYagthEh79ZZNZArnRQ7dTsMc3k/Mcuxqu?=
 =?us-ascii?Q?8rQ5tLMCuStxSZXZsJjCD9I/q0XQNfPUTuUbEoVDJlJ1XigjGVKw/njkdI0O?=
 =?us-ascii?Q?MyIMoORJPP29t8fYRTWVwM8Z9tfEdqzgvrZ9zv6zCq3QKElShy9i2/0UGQOD?=
 =?us-ascii?Q?30yNVb/t8THTpbCfeqccLLeqqYmOag15p4VlcGiCBpDWfjdrpQF32q9XpghP?=
 =?us-ascii?Q?QkMEwHhIBI4K8wH+5bHuJcEXqW9DTiCHLeUQvHcn2yf/TJWYcfE1e5ozFLmP?=
 =?us-ascii?Q?oj8pz/yTlnjLgH9w9DWjtaZmcA3q5INfL1H+bAoj5/9yvcdDIfLUpYeDf6hy?=
 =?us-ascii?Q?PlE3EnGAVtAalc+7CkjePkRK6ZtwT/43DPUeGLLb9YzB10RQXAkf7VvOjYc0?=
 =?us-ascii?Q?7lzeWM+U+P59HIH+x81dAywqV3GmiyA/i9HyX2XzU4puyMaX44gLoDYRHaCK?=
 =?us-ascii?Q?uBfkvo/T4rVsBsnpDk6pAFevSs1+gCecUrv5UoJsWG5i2wePUx9zgDD7wPQZ?=
 =?us-ascii?Q?TwKqtz1U1qO2HzTnTbgjxlVo6wPMgTbo?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eKBW7OO+K0MAvS5Nnsui5Fvnzi0Re8w5Qv2TtdMqXzNYRMWIX9FzmrI4x1/M?=
 =?us-ascii?Q?0NxyiluvTZhOMUsrnst1ctLxAd9RivRJpncAHkY4ht/40JRYkUGY8/iUkjHV?=
 =?us-ascii?Q?KKVjZ1+CaJ18zJyEaKKdLoXwp0nZMpDzNYGoflGUlT/rEmZEBjPST0Zh6CM9?=
 =?us-ascii?Q?uOgvGC2Ek45fL/8O17HCuoS5eh24rQeurl6aYo55C1hzY+qdlX846wKUxPfN?=
 =?us-ascii?Q?HNtHDN3kxcb4XuA7lB/qoZ9oLMnISn1MSyLZsKYuTEkm/t5mJsnqi2Vd7nGz?=
 =?us-ascii?Q?ExKtbKYxxf9nqkc25JT+v9k9nsAfKPuFpCEPiPUWXubVEnrZUfm/kmmoKtHU?=
 =?us-ascii?Q?PG4C43o1WkpW7gLSzvsVt6FXczGZrGQJuOf0xXdlD8YYx46gO54h75o8lDSk?=
 =?us-ascii?Q?6MHtsM6xHmCnxViZZCs6OoBFRpjfsgELd31O/oLw0WNDqdK1/cTCcqMLArHy?=
 =?us-ascii?Q?/i50zs5uBqKV9RdUomRdtmNaHp4eIJfCHH7W/0hsg3Y90lJr5KM3m6A+MFhY?=
 =?us-ascii?Q?JVT5xSFV0kgInt0yQ/VXGm6N8RX1ACXwb4h4t+X47Nj/mKR7nakt6H898W/m?=
 =?us-ascii?Q?A0ikyZ4BhNS4iybBRd7oui6wKKYSe8e+v8mdgEOSXAlpQDA+xcyAQSjH/icb?=
 =?us-ascii?Q?8lOCUNfay27ybTVEVPC1VVt/BGKaF3VlBIR34bAOVkxKrHnPC8pnFDR8xKMu?=
 =?us-ascii?Q?4WcfnugS8Le9xcbvEPQwv2uK46CPGp9B/ExLHUiqE6uqEzqNWXPByrkZIx+e?=
 =?us-ascii?Q?nb7WnqtsBuAYz4BgHDHzIcGdibdTuVCSTBHRj3sWXnibtED0KuyhAmaxoHPa?=
 =?us-ascii?Q?acqhRcfOrlcljjR/uJZ354z1gHTmwQukqoVXydswjYHEXbedWl0PP+VgA2Ov?=
 =?us-ascii?Q?jmUBzHxlEuo3IgJ14d9q1D6R2Oia5wIODwVr37ZqGjwXx2gOgThvv5DjJnXj?=
 =?us-ascii?Q?qAk8HvtYTWrX7ubQwymoAibcIAgeoLscJtl5tmbeA3xi8cTzKnA0tq47faWn?=
 =?us-ascii?Q?ga0WTNV6F2+4O/kaQo90nOw08PZjGhgThSyCgb7vJ7T4Q3v0TjUrIvaJDoQ4?=
 =?us-ascii?Q?a2MEDYXHPJHrlNeoJoRW0aH3jNWnoNXmPip5bccmOX/wM9ch/Sr3yb/jHu+n?=
 =?us-ascii?Q?+/qCTPxVu5b4o5Cv/M13V5jUDW9hlcwekrwyI0PJKGMDp53We+LcFvnM9CRc?=
 =?us-ascii?Q?wzDiltZnBv0Ok/mtFUU4k8Hy4LlJEuqmf/mMp9uAeU5s/cILAMJW+w2RFeA9?=
 =?us-ascii?Q?yooc4mOOLxhCcZzOSQ7+zqW7ZDZ1VKdQikUkLxfUQO//EQBvfK+p7GdNdnGS?=
 =?us-ascii?Q?83/UBQyU0F2eXIccb+Dt7rqOSU5EPkYg5KyTlq949/AaU8ZtPTU21mwMxTrG?=
 =?us-ascii?Q?vipOmN626VHsft7LfARYudfe6lWIMvsvL6wb66pr556Asr1n1UUq4CH5AKD+?=
 =?us-ascii?Q?CNWIQBGzrZHxV5jbxU/xrE0PoQwaS4Fm0Jr4v6bajTdUt17rGVQ27kQ26VAy?=
 =?us-ascii?Q?RQtaIWrcEDBfTbliuUdq/UoXIwjwrJpNE5geCX9Q7ALOedICDEhxc3fd1gCo?=
 =?us-ascii?Q?Bx3lVk8dl719SwpChhLvG4RvjIKHanVckm3wpCX/ksyZTvWMuN9MgV32q65z?=
 =?us-ascii?Q?Jg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gb/HRgxisEsIPpCs6n/JEpgb04bcZVFlMPD4nL0iZjjUC2oco/wPb7p7eKeONEaWuERm7Cp+pS1yhHGyj7f1LzALdziz6XF5INMyORbuYIBpQJZMGysvypPYpAU/3ComZXDC5qKPYPBjmeFygW7LC9Z4Qyd1wv/pBihGgpG05mrQHos8DPxX6mGgUzvFQow2YE1dS6xgLUEHWOmo5e7nv4r7gHBhIAVTP3TQ4+FuDxw2d8PtmCBEuV58nBwHDKTCAtPX1GuqoKh/CLZcdPsX+Jp8P8m7b8rG5QkjEY7YDLMQTSsT7V37r95phukRN8FzMhfAlDqTdL57uqnD5Q48tciq9xgrIpw5ZGLD1RvU/2pI0CmifcxBya/UM+UFAsBijSqEyPK5vRY+iC3ejuiQvuF2j547GyJOQkXka4xLAIYfnZkar6q0NN2/jLXBh6+lznzs416J9UXRPxY7n9OGdoXAjSFOAqS8qcMCbyYUJOI+PHdL/+ubGIPDhi97H4Lp/MWgyjAIgLgKPremI3AZcdcvW+FKsybirVzjMegQAcTwr3fB8GWVxkMd8rfLrHerwWdoGjPz9KQCba9kpHU9Z/swDMRkTmresx62lLMtetk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41f2732b-cf7c-478f-62fa-08de25ff99ba
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 17:34:45.9901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ME3OUImF5jkDnjCuarnysiSPGTB9lgYmWQ7nReiufIovezS0MKybhbHfEmLuZaauprQMJ1DyUcnNAPTe/RsBKA+WPG+V4exEpDNl+66xgv8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7944
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-17_03,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 mlxscore=0 bulkscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511170149
X-Proofpoint-GUID: SpBapjKHL-d1UU14rJprzRXB6qG8yXKI
X-Authority-Analysis: v=2.4 cv=JZyxbEKV c=1 sm=1 tr=0 ts=691b5cbf cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=jKH5f8LbNFGNSl5Of2MA:9 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: SpBapjKHL-d1UU14rJprzRXB6qG8yXKI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX9+JX43qhLhu3
 Ka9iI4Jtwl/K5T8vQez6slp7R6N3s/yF4FP3szLGyUBJOeDdP27fHPOc81q5wURUUHdosHqEduX
 Gqa02TsAiMc6PlyBxX7gST8ciNHZ/jx3g2Lu/6VIjzqTYf9F9Oe/bhFl7Yly2WaAI+opius48EX
 8y1HjvyEH0jWUH3Yk1eY320P9Y23WgsdNaaU83e4u3KRXZ4uyHrLO6fP8wdp6WM1MeCac9yRLk5
 7QSK1H42/1mKhJzEJmBm4YHey85+18MPzMC0i65eZSSpN0yTpfu15zIzYtcJzNxSBIcJl2RIBLy
 yfJqlGmItUYehUsgkBS1gFRua4qqyw/sRdK/OuFbZ+P/TkLaArVJIyl20RlzUhiD0KcSyuinLI5
 exBy3nuJvziAAlQfO08jgBtN7eri2Q==
X-Stat-Signature: ojws4ic4suwrz5cr8ejq863j7pdexnse
X-Rspam-User: 
X-Rspamd-Queue-Id: 4790518001B
X-Rspamd-Server: rspam10
X-HE-Tag: 1763400909-696056
X-HE-Meta: U2FsdGVkX1/D30e/LQmWQAsL9H2RwFrA2Xf2rnx+GK93nlYOJN/5tN/GdSAGuw1PO5Pr4m04UtxajNS4lITaNjj8tlrQXP883j1f0E7MAfWTf7JNf73i0bdFQdTPP0B67MnTgeglto30t8TsEQlhIUzMHdLrSDIrbB+OIRWvdapLbKf7MKOY5AqwEv5wJpTJq7uuTmD3aCN7BAAvI9+Cjjd5STxoznHVOGOqX0tDyfhglYGCaxo8z4bMmg8vuUzmi/2wC/qJPBVSNt7KvxB5cOGoUZ1jVfYwBEqGGYqcIJuKHpRbJwZyja65A8LGg3SadtDALxh5yPExHxH40FIDxdR3sjDVlhXu3PzRacFi1YHvOgU+kxGEDIaRafAuM1xnNDWqsE73q4SnSvoPmtVUdaol/TiZKQjqOvVMcr+N8kZGp6nLSZgT71n6JLjoTTxwM40khmHxTNK3b80CTHzUDsoi6erl5OgBo/shkTUncmpnGpO7txLxFX3LdH6QhHRENgoAY0UqExti3B6sK5gv11Ju5bfcXbMblrKvCWk1qvVHmtYNLqaKvZ3S6lDwVIJdUh1cHF+eiWs6UcNALZ5DYXLbX3GFmQtED1wzsqSbGuXiH4qinknxc96Up6+Mswljnr8j7yNUVLSrSY8JSnJfdjxkEA3sKPbkHxGj6ql+jtpdOs7C+qxV2B2lRTCM2CbI6qsW5OaW7TdonN/w0YbkBLoTPEOxEKTi7X6ZpPaBLnTyqtBGoxRcQilRCZ7skYNK2oQzowl/I5tKY07GDqIP22F0Hf0ZRbE7TiX1Erja4JWSubvUjetv7kRC8F/7UcJRUu7AMLB7Vr8YCkz+DWNxrq0wjqeDq4Za036Vxmmuq+HQqjq5IdKCeBYHR1AlZej5E1DskUG+TFMClnQtDhK76M01/H6ycp6g02005zOUXWFx4h7Qgh/kibSTs7SDUISfL5jMYJtOpeW86ZV2ros
 UjfUfHgR
 wvwOFw2zYsVaaNSs0aC2DXWJZ7hLBzER9xdL+EIGoTM/3NsmciLm/hSmWQZUBtmjh9upZ9iXkJBMpEUozdQfavs1IgP/X//CZptKWHP9o4tbFEKkwnCdF4JeTp24gEuCm0MNlU9jNfRuGQNPcrB5MbK0r6OZ20i/f1xx4aTFzTAGNweMVUnaL0l6vrvUI8BFh9VJgzbeTz/Wk076Y6ST6okFa3FIAOy3AB4Z8nroVOVIDeErmQAo91N89o4/MfunD7T+aiyFqVByEL2P6HkvleDQpIcHCnfCuuLL7DU7OBK7Og08sNL8dRENPFb1AZRdusZFrS4wduIBEYt0aXt4/WQPMeB9rzj3ph6tWek+eJdldaLu+UQSVm0S0sMhK3uLuxguoJLVWGjRl2S7d5tYOO+kcQBN1wlo36JZbnyC0f1Sz4h8MfRsn4oNkF5M2PCHmhDtfS/piG1gZomBfIN5RsG2+oG+BaVjmDYrN1atofRb/h30Eknk8Emaa+thwDeXLCTAviXGpnTCmIO47zrN5mNQtEfjITc+fiiRrOSROUeczSp2JmCdWqkXXgYTohAWcKz/EVjHpY00S9CeFo04w1gWBlU+knqF8aDBbXVnNHQaXdrIVL394ecQA8308poFC3tveoOboJfVB+etv7wDWs/gwFEWd8MhKXJ2J/0DbktIifQY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently we set VM_SOFTDIRTY when a new mapping is set up (whether by
establishing a new VMA, or via merge) as implemented in __mmap_complete()
and do_brk_flags().

However, when performing a merge of existing mappings such as when
performing mprotect(), we may lose the VM_SOFTDIRTY flag.

Now we have the concept of making VMA flags 'sticky', that is that they
both don't prevent merge and, importantly, are propagated to merged VMAs,
this seems a sensible alternative to the existing special-casing of
VM_SOFTDIRTY.

We additionally add a self-test that demonstrates that this logic behaves
as expected.

v2:
* Propagated tags (thanks David, Pedro!)
* Corrected comments and added ASCII diagrams as per David.
* Expanded self-test to check for mprotect() case.
* Updated incomplete cover letter.
* Updated commit messages accordingly.

v1:
https://lore.kernel.org/all/cover.1763142412.git.lorenzo.stoakes@oracle.com/

Lorenzo Stoakes (2):
  mm: propagate VM_SOFTDIRTY on merge
  testing/selftests/mm: add soft-dirty merge self-test

 include/linux/mm.h                      |  23 ++---
 tools/testing/selftests/mm/soft-dirty.c | 127 +++++++++++++++++++++++-
 tools/testing/vma/vma_internal.h        |  23 ++---
 3 files changed, 148 insertions(+), 25 deletions(-)

--
2.51.0

