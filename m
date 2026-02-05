Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF625EC1EAD
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 12:24:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 472C16B0089; Thu,  5 Feb 2026 07:24:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44B786B0096; Thu,  5 Feb 2026 07:24:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CBF96B009B; Thu,  5 Feb 2026 07:24:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 19A946B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 07:24:52 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CD7EB1A04CD
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:24:51 +0000 (UTC)
X-FDA: 84410321982.22.ADB1AC8
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 558F7C0004
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:24:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=iNU8ylyz;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=otWDOplC;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770294288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sX96eYP027zTPvpMPOlul+6/dG0xPUhF94+Ml/6WmyA=;
	b=QbC/dYnrBdYkc0OzNocvjo68wshbKO0W4p/ADOkbjButyBXt7d7VlT+0+d4LXRhu69cxGv
	8E72HNPgDK19AYNowtRU8OrU96R7nCxpTN0Z5xlo0qco7h8vPPYX7pGsaBofc1G9pZwSX3
	tQTOkIWguLc5elVZGGj12zbsU16Q/BA=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=iNU8ylyz;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=otWDOplC;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770294288; a=rsa-sha256;
	cv=pass;
	b=N2YKEkR1c2NkEysdIVrojfg/fHGeV8VTORvUQza6Ifm+znClA4pafZSSMuA3Gp3uZ78d79
	E9k34r4RgkTk/T5bnbEtmRfEuYFS9pTEB/qPksHYUeT9zfPZFdC1yZ4q9EIkQ9KJbcs1HQ
	qfQW6bZuIUNp9RKdxJ90HzauM3+ycOQ=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 614N7nWw1717984;
	Thu, 5 Feb 2026 12:24:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=sX96eYP027zTPvpMPO
	lul+6/dG0xPUhF94+Ml/6WmyA=; b=iNU8ylyzGddWdfmb2xvIQ31sII82OLVnR8
	APepqtJ0ZlN9YBN8KViaO+QINcGJCjD+jwMOadYOmUHEFaWckgx2v20ShpdJS0A/
	9Er5A0r+29IBrf5AFbZhc58MZKkzPf56kbRR59dQQ1hSj9c6e85XhD9F48pkGkRe
	IG/a5EtgTJGXMcHCHcdeTFzXnh6Mc2jxLEYnB2XmydIPemd+rI8hlnuydB6bUiLy
	HEzPi9LJEDOWMVa+lWopoRkwUlSD7i5xXi8o4mv89kxWn2gS/KLFcv80yHApYM4x
	1RxKmDxsOqmBzsZFvB7qv/NesnMwvUcXoGvObUCX7zvmUMHQOe6w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c3jhb3meq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Feb 2026 12:24:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 615ALiVt018722;
	Thu, 5 Feb 2026 12:24:25 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010053.outbound.protection.outlook.com [52.101.201.53])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c186qms94-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Feb 2026 12:24:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ISm5IKLotGnXLcZ8UEZYF7aSMPgouYIVWOTi4WP7avjPEkHIlRRF1bfezNhdbWFxLYTEqRaRdNlKPdevN8x/Je8hn9bXGHZY/BK379arZgFyztYWQmU3Cdk8gQQjvxDrVWUZ5GRJl2l8Sea6oaEJ3GbS/gnItNy4JpdQ4TeYPoiU0yz6DorfweHDs5P+T2wO47ZAOcF663eqpD6vrrf8tRoterUC+/5ShxkZX5wRZV8ZaWHZBzRoTgB83a3IECsgDL5iYXM2Fz9VIuujdWpmbWMHS6ISsV2MBXjYf4mKHajkFitpQOeeHYkQ4nEtNwet8OrkmbxhwdzT5jsTy5hIuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sX96eYP027zTPvpMPOlul+6/dG0xPUhF94+Ml/6WmyA=;
 b=EJ9zr2Pp9FDua1V34OdXSYoFkmrE2nk3gG9x1JB+SHjuIFZI2Lsg03+fQcT/V+WNSIQ3DqyqA/I2InRotjYMJGuedMQrO9ABPVFsMNGtL4D1I2SO1fK6ZECtThyOOV2pw+azj7hKjp8moOQOcrXNBChVZ4TuRRLeWKDTXnRM4qW6WlVL9nVOe03WhM6eOi2mqU8av6BpR8QUWDaFGE6psCx68gzNVHi0B/WLaSbQXcXphdkPKGFoMDMAVzdL43cQxLOpDKcAuGFMicpZGBNaDS+dbPJyH3QocyyezARcK7URXJlZrAp3Ie+XVUmfURNDqw3Rl0e7be31PQcUJvRv4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sX96eYP027zTPvpMPOlul+6/dG0xPUhF94+Ml/6WmyA=;
 b=otWDOplCo+v8ROYJJj7KQ18tNU3s2G61CXNxGnaoFYkkwOm3IjimaNmBqCfVud0yXV2w7uKakxeRz/3tdELey2+5NJGz1xZSeqeA6Wbma2c1rbWVdFQBwUbnrXZ7NYKdUda5y0xDXiEMh/UTSuDoZW/2Mr2bznvqISM/Ac2CROw=
Received: from DS0PR10MB8223.namprd10.prod.outlook.com (2603:10b6:8:1ce::20)
 by PH0PR10MB4536.namprd10.prod.outlook.com (2603:10b6:510:40::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Thu, 5 Feb
 2026 12:24:20 +0000
Received: from DS0PR10MB8223.namprd10.prod.outlook.com
 ([fe80::b4a4:94e3:f0bc:f4c9]) by DS0PR10MB8223.namprd10.prod.outlook.com
 ([fe80::b4a4:94e3:f0bc:f4c9%5]) with mapi id 15.20.9520.006; Thu, 5 Feb 2026
 12:24:20 +0000
Date: Thu, 5 Feb 2026 12:24:20 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: "David Hildenbrand (arm)" <david@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Subject: Re: [PATCH 3/5] mm: export zap_page_range_single and list_lru_add/del
Message-ID: <4c399644-97d3-40a3-a596-e4c93b713bdd@lucifer.local>
References: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
 <20260205-binder-tristate-v1-3-dfc947c35d35@google.com>
 <02801464-f4cb-4e38-8269-f8b9cf0a5965@lucifer.local>
 <21d90844-1cb1-46ab-a2bb-62f2478b7dfb@kernel.org>
 <aYSFyH-1kkW92M2N@google.com>
 <e7247f3e-8a88-4b46-91ba-cb73cce1346a@lucifer.local>
 <8856c839-1a94-4e4d-9ded-d3b1627cd2cc@kernel.org>
 <aYSKyr7StGpGKNqW@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYSKyr7StGpGKNqW@google.com>
X-ClientProxiedBy: LO2P265CA0360.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:d::36) To DS0PR10MB8223.namprd10.prod.outlook.com
 (2603:10b6:8:1ce::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB8223:EE_|PH0PR10MB4536:EE_
X-MS-Office365-Filtering-Correlation-Id: d0878ec7-7719-450d-1749-08de64b17d37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?o+st/NYSDZLLFykhcHOGOfDO/QAZ2bYBSpxOnOl/aTrCLRoDSUBebCGCKSrl?=
 =?us-ascii?Q?5thqzu45+ZwI6A+jOdzHxkrblB8OgMas0LyY5xzr5IlU4qRl8ET9Ac6pWLgG?=
 =?us-ascii?Q?ciP/rddspz839DfOwrr8eB59Y4SklhGSnaNnxrZdG+H5yTwbTE8aPM9lS/E+?=
 =?us-ascii?Q?ya0QNZz8uA0fum1zJ38t7+hB+0Kl02Myer/nBd9bDA7N5dIQDgdnHkCsJiCT?=
 =?us-ascii?Q?hjBkLbza2BsjL+IOKdAVdLSHFT2ncAiUG5gKUex2Tznm0Eo4IitGFVdLh5Aq?=
 =?us-ascii?Q?eVXX0AAZ/DFCBZOwvoCBEgjoQAxAZzf9audpa2jr+RHFjnRB1AY4UyGegsdt?=
 =?us-ascii?Q?zixGamn+A81w3Ncq8DWGF/Qyqk7ZOOWvyjGRQMRH8PnffAyALUkQ9zQNpZxx?=
 =?us-ascii?Q?LwTo0VasDCL+gteI1CHTsGIohHahDklocLxIjO4yFU78CPV+Sc8ywG0asKKo?=
 =?us-ascii?Q?H1yCKNYbwqpHIirxpUQj8VTb6snF2VaMCUaWWJDbWkFWTVqrTa+vId2C6aKl?=
 =?us-ascii?Q?uiAlNZRWtmNyb6ziMGkcSNux69dXEhB/watKcjeCR176WMNn8KAS0VehU8/S?=
 =?us-ascii?Q?HZ8erHQ2CE/fEh9Ex10eTu33g4SGOBqniAD1fUwa31uWd4Cdm+Hlj27DFZdF?=
 =?us-ascii?Q?r74HtQWvd0DBsMr1/7UBNIJnZNtAs+IF3EQCbDcD3wQEvFoTWgaIaVAsOmmS?=
 =?us-ascii?Q?PDWwADQ2xd+P/6Jiyn4Ewdi0mU4HpYxi2O0IZK9xo2PKeE10z8//cJJ394rZ?=
 =?us-ascii?Q?Rm/54BMuVYKk442PJp++E29Xhw5wV7739dcKC3Sj8pJE7zeAw7QxJR3GPIUN?=
 =?us-ascii?Q?+DVHh1GBTe+XqoGXt0JmV1ZQzbXwegLTWeqmjTKruB1uR80KJ+IFQ7SDILtX?=
 =?us-ascii?Q?Qx06kNlTVCEHy1eVtMSEjp6oZHArDJVDP7bnlmiq3DNeiHdx3Tm1LiWtXhPP?=
 =?us-ascii?Q?zOIg7haXR07HBfeboPt7RKnCeZraVzhjBTP6KBlw9IljSUUWpmUtxIqWXl+8?=
 =?us-ascii?Q?vlDfXZzhGLm9eNRV7oZckqkZKu4ic9t4BremDQPZqOVB0BonPnY1tiEyzvVR?=
 =?us-ascii?Q?9jC3Qhy6D/GzngIwCNSt1aAXcRjDQ3kD6iE/qhe15vwRa5XCNI5CUEyucR3A?=
 =?us-ascii?Q?h/lLS/5q46GTWB+tPxczDQ86LXOwYyuK84HPbEZQOwhr1xvhMdFPjFW+ZyEk?=
 =?us-ascii?Q?nTBxx/cIX1riojXBO6zS0tj3DdXDDhMcJ1oDzbm5NrsiRXSz9D4fnMdthrVw?=
 =?us-ascii?Q?w6GlyD8VLrsQLI+xrOZFL/TkkG+B3RcyCKhZgy/+uHpEFIRXrpZDms7Hdl5W?=
 =?us-ascii?Q?iYduGXBke3OdfAczGmQXjiMz173apnJz/1fpYXRlR04NvCfYwqfrKoZFGzN6?=
 =?us-ascii?Q?6k7Zb2r2zmc7+yIl2MifoZwox9L133JLo5jT7iIeZmVTz6RgYpZ9WOQ4FJ/X?=
 =?us-ascii?Q?6x9TxaSO6leV5lmZz0OIU4VrIRhErlVGPFEjVmSpKOJ1+PVVEKSbJo+3v1Mi?=
 =?us-ascii?Q?lkc6DMyDi2TlBj+m0z1M/oyo7sqks+NyfPsAbR/X0GC6RYa7NhKA6tL/OsMn?=
 =?us-ascii?Q?B7wDY1+6vBs+ZuG/QjE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB8223.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pOG0cnjGiJ/9y3KhWUMX517al2S4c7MAJDx9FUPbVXE6szkX0igHnbIoBUWB?=
 =?us-ascii?Q?DothVrf+MQ2Okg1PnisAsLjsrcvlgUSYhZrV3RzpwCalqzZcOD3TYS9XGJ2q?=
 =?us-ascii?Q?YvOVu84J8khO85F7C8wOzYHCiZN3ZiQx/sm/QZISmLU7qGnFPT4eqzj2uSId?=
 =?us-ascii?Q?WOb/fYLeY5NAPSbKyXtx3g6ODULab4Rzv49Rjxa4DbZW3tWuYfDH2iggBlQA?=
 =?us-ascii?Q?ciJmt7Zg6D1G6wskezcLhE0YvoM24Uy6dXd1D9/L1BCpGWqB/haRvVig6ZH6?=
 =?us-ascii?Q?FRpNWyTfZNfVz8N1KBeyvhfUzwaPufnegTkMYNLzQol4SrGUvdzNtolxu6MG?=
 =?us-ascii?Q?9oOFX9tiqYSt1fGctXLnqDXRTyaiB91QW2/Jl9aMpLT58369w20D0YrVt1vX?=
 =?us-ascii?Q?+d2wVIjaO1m89oCf4DKIe28QZPp/aaWcf3Lh1ss2n1MdhWLrzJ65TytgMHh4?=
 =?us-ascii?Q?aIP6kOqgnC9TzrAlOzJ6YEJlSmm+NHe0H8EXAMcFiHLzqGInX0uEq2r6HjFU?=
 =?us-ascii?Q?fE4NpoLiDm/LnWXIC0d9ZOv3B7IEmI52GrSSsmFO7G3x+Fv0Fs6u4S458Hci?=
 =?us-ascii?Q?fN2h9/7zR7RPg+b+jB1imgci7+tdgrdHx/96wwwTMpPIRtdfGTVyhajNTow+?=
 =?us-ascii?Q?rVQ5paOBkABbpz3SvCPR+KaaKY+GLDXXZttN/LgR3ooc+zG8DBNmZPpmSap5?=
 =?us-ascii?Q?KHq+D1LSn4sC17ROiB0QOX8dJ7/qSf4moQAdP3GxfbaxpqfVyPGwi4dXn9J7?=
 =?us-ascii?Q?Av25oblme8h9Sk+d6figlaj2SyXUz0IFbvdHbziK312/YbMufdx1iUblNMAq?=
 =?us-ascii?Q?1SXdDNdT1ax28CqwHMit0kpOtsa3qk4qQwRVah4YqZx2pB7pl9pZ3syReKQt?=
 =?us-ascii?Q?CANWDLigAlLec/nOrG0ocNDeRiuSSOhA7o5Pm2N5gg9V1DG8495gD7TDd91v?=
 =?us-ascii?Q?KthObjhklKJQgyAswiEzX5f28AInf/kTzZvwlU/LJhB3VBq16AaNSFk3PDij?=
 =?us-ascii?Q?z/IKYpsUguszIn30tUBdQDgcPubxdEpLUM2AM1wGcXFG1779xfMCCU+g0tW+?=
 =?us-ascii?Q?9Rp0N5uBf0zxmxFwS8p1q3i8v2O6MsC23H6TZwusLNRTIO/E5URbizNfu/sq?=
 =?us-ascii?Q?uL0RUOv8eLsJOTmR/PxRDKhhC0eLqdd+ZEfvxpOSxD7rbXvXT1/l2xD1Afo7?=
 =?us-ascii?Q?6I6ITMJ4GLMhe3Cd6Fj7JO53KJi5mxp+YAPHPYNij+e6YEWcgeWeRNGo+gG7?=
 =?us-ascii?Q?2M01K6Aq8t1jE6rbxynHuhLuiLmkqyOtozDx3HSElhm6eEXaCoQzPN2TPrhe?=
 =?us-ascii?Q?5ilpxSPami7qDb941vMCcCOtShhB1VTxeHOCqT+qbjGasLg5UJafi1a9A1GJ?=
 =?us-ascii?Q?b0nM5YOTY0xHgTKuxi8TOREsQqaZeI0Z7J05DeMEfwnMPWOhw57APCNPvBJW?=
 =?us-ascii?Q?xUzrPd8tFoctrADmLRL0Yd5oXnYj5kNhN+z5wm3CJsoQfm/NVA+8EbRVuacY?=
 =?us-ascii?Q?aJi55SUb29fBpWNwLB3SipaM/KLStjZsz5laBczwZfBkQzJhV0zyEl7ISL8L?=
 =?us-ascii?Q?cxWsHuma8Cymr9pG5SpFYOTT2/LTRg4nFM7TKlQh1MGhcKeRAdabFz2v1ZwW?=
 =?us-ascii?Q?CrflauM7dogmv9bxH6TFJByzo7dWf4yZcvYtt9KVd4Bof/tfhUYLOTU5NJZS?=
 =?us-ascii?Q?XFBrVp8AtZTbKg3gspEStuSmlTyVzhkMeMFB7pA0OD+zqX6ReD1kFhOLKVwu?=
 =?us-ascii?Q?3sYbAlOjk7YMqgNyd5UiU8hV3drPYNw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vQ74etiZGJZ0HmYse+LoIBHSn9XaQ2yUiGwVKlMs/ko0RfM8jbwzR2RO8w62COPwVz962DwSiXDeX+tXYbgIMCRx+c9Ya/p53crrxq2PyUFDKXN67kaRPQ1GNFuIEe9ndOtWDgg/Tbwz3idHuIFsPmPxIvNGDlmRITluy1hj85kok2d3S/h3z0fiHookr8QzAxpgdL0a1IZRNrG+1+EowV5c/rk7GDc7krW8X8x0omXa5RgDhKKOgLlkW8kvx/efw6VJAmXk264JNeqBME3CT4y+mFNflErxIuTstMmLESUQVma66rf/HKtX5Ho/tgEd5OqEGjcZ+vfmjm3OUuFg4uNkinttxnMXJOULWG/gw0+l+SrkHKXE9d9RHxtAp2dihQ0z2JMyh0EBvj704UALs58F0y4nJOnVdPKoV1IHjd7PmIsC/EEaI5mCgugYAZX2glscKBWhKQRaDXH+Tx2hxChDsW/DKjIbCC1Fqdwnx+pHkK6ua383kIUM/+HKmhgYH9Xf/fzxRkXjNjcDlDT/6opSsvaOEQk+iBoRuyCZzxtYJ/5sK6FXcN9+5pNCZABUWQ5BrkYmzk33H0ZikyY/IcwcKX9F8DSwjtzF558asX8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0878ec7-7719-450d-1749-08de64b17d37
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB8223.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 12:24:20.7065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9tzN2aXA2PurorXoEY0zXyIOkysqXvj2MdQ9l4l68Nztqivl2XtWC72EKYWhf2726LrChWx+dWNnAuxjJK3w2knWbH/m7fuBhXa5rv+viB8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4536
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-05_02,2026-02-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxlogscore=698 adultscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602050092
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA1MDA5MiBTYWx0ZWRfXzsuHDXoJD0sU
 +8tO+EpbmyCfKNw6a7vode459iLBlYt16Uf4M2pS+gPMJNxNL/wl5TvRn0GKGXkambuCNnRsEWZ
 0bOffNO2VBAjvhQ4w0IFDQTiL/RTXVgkkUmvrIUCIOOpRJfUShYAW0ZWUChB4jfAR/z8CvnNsM0
 lHqixK1yA3plxENnb859ee4Ib8Qpiv+KpTIYFS6YwqjfgvOtcI5nbjY1IGKQX2RdfTGmGlhyHF8
 HldP3elU64j4eLfefaxmN/2inCU6GZsPkROQ5dEUVWz4GLjaNsgGrHph8WsakLYnWIL+G/5PfHO
 TMkMeegeZqvwu/1lvENkmH9x/eSvyycL/9yzvHRARyj7cpR1nlyoMS2HixC3StlnksH0LCVklFk
 nH8G/+/4tW6xb4ki17XIb4+UBdCwSspCpCHK+e/8mxW6GI3ovRhs3spMYO9kfHkm+qp1P4NHhld
 L4w9fa8OVO+DkYXUPj1DiouLCwpPEgVXq3IL4XQA=
X-Proofpoint-ORIG-GUID: s9Gdc4lHJUlebFug3jidyGT1qK8sA5Jm
X-Proofpoint-GUID: s9Gdc4lHJUlebFug3jidyGT1qK8sA5Jm
X-Authority-Analysis: v=2.4 cv=CaYFJbrl c=1 sm=1 tr=0 ts=69848bfa b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=mOT0BPNQVqf9xHTbl3MA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12103
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 558F7C0004
X-Stat-Signature: n3eh6x8565sh7d1eztff5e7ceakmxkpt
X-Rspam-User: 
X-HE-Tag: 1770294288-664767
X-HE-Meta: U2FsdGVkX1+oYRJOZXjJHa+28Tnj6SRGQXkHe6SNoVTZ6cyiFAqokOS+wt1Mj7OxEN/pGeZglafObArdLQRSoncedzImS53LY9qdAyAJOKa+F2UF68hmDum6Abf8dzavkbbOEi6NfAxT3JvkHFNOS7q25fUfCxnB3A188dK+91ajzS6xIsA0G6XL0XbdXe+vjG4uXUznYNK10fUnWTD24SM/SakvOFZ2X0Os491VqNXqB/eECyjbTHuiC8O+jP4wkloNM1dWZna3TRwtnf6yJdezbnad4Iin+EDBx9z8+IdYXTDJiIayJQfwx5Pki7yl6QmILk9Pov28085N0/dRCt3qm8EKlhHNlk2Y4U2JwYbyxfljgfE2LIpRDd8P3dRJVhdf17isj3gGewi+MJm1VS/S1TP/rlMNbA/dGP3sOI2h47+vsUyw4o4KhK5DCHjKlHzBWnPMRMo/VNKDohFUs6lZ6Q/iqY8KHF10Si2Nph9F7GTAgwFfLJ5riviwSWwVnk3JsytUIKYzYy0ICTeNwN5tssTAlWDr+KTqcgHNOtiWgJVbnEDtWVBUQdhVC8B1O8IxnuAmjt45+9PzOyRjDZDnapOSo0eCHLtTVHBkfu5WteKQhrodx6Cv2BIkNG8mbctvMKSuJ4Cd/RM+GflOloqb7XTwLfINwig7EfpwYbCLUEpkewpYWoOAS5nKX5orWrQFfOzKaLXdZUtlo1ws9EV+G4HrVmTUD+gbl2Ri+gq1G3qF3jkEJjxYHYtWYEry1GUrUGk2SlfWD4SZ4VB3BrWFr7KcBp+gl5irkoprfow+wsQyhDMhTrhtSMcp9GElHLAHvylBN/EdNEfUSF1+WQkoe1o8+0b2QDuEydVZEXYvMoowC4DE49mGkErCo2pGR07YjHIlKnVo5HiNgPa/gLnDhWo7kiJ+c6qHX1LF/ZG/PfJXF3Lxc1qHKd+nVkR64bsnufN+zYcb+nXLYFf
 sx++DaSv
 +tOP9O2HmzKnZjxpsx8WdGJSCVk4tvyWWCb8A+f0r+UA9Bv20+GbbgcG1tf6ZKRxo4ga/PZcQzoczHhX0tCiCCh29qTvlfM3r5dB29rDTv9sElsVVUh7jpBVKnMRLaaxGjBjpZSabTshEC0gxSBYxkvgvqsuUrRLYTsmIacWSv+TfCgu2J9pcFEeUvp46/NwAQJgPm2haEDUAK/6WSMfOPyNsiNOolRXqNXpkYwLzlkEvs1voN9XsYL/VqUXh0V56H31tHtGQ3yf2iEYLaIpEHpzsavrCK53kB1KO1Mtjz/zke+x6koUK8tvmMYoFqgQAH9Ya4e2Yk3OewZ81yLh4VPgFg43maFhuMOkiY53FKw56SN8mo3tkJ1chugQ1fuYySLMYeJ+1zqbMfagWnQEWzcvPK/B+tpM5KjjH4b95+kD4BahKpNEPXzjha6xJC3aE3eXSdFhXvG9XkvlMB6xFOu7qzrTyWP/bEsC+WpSnpjTj+rZ2TFcmSiDLkTAgPZ7MpVbe55FqIC0NP9eI3FSZEbJVFBcJOwc5eNH+MxtunLBxgUuQmmK18UxXVVlsmrMK7GcFz9fg9Mj8wY7ty7FOik5Eazc1czrueN3iih3HmKX9HLFUIfsSoLVMTDrJCJ/V3w5D3OGRuT/tx8W5nYMML6Qg0+YgQylaKyC+bDAMB5Na6aSk6IFIePeMrTyMswm/eQUGVMmXWqtI7rzjDnzFxrn7yyHnJspav161pr583whh2Mg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 12:19:22PM +0000, Alice Ryhl wrote:
> On Thu, Feb 05, 2026 at 01:13:57PM +0100, David Hildenbrand (arm) wrote:
> > On 2/5/26 13:10, Lorenzo Stoakes wrote:
> > > On Thu, Feb 05, 2026 at 11:58:00AM +0000, Alice Ryhl wrote:
> > > > On Thu, Feb 05, 2026 at 12:43:03PM +0100, David Hildenbrand (arm) wrote:
> > > > >
> > > > > I don't expect anybody to set zap_details, but yeah, it could be abused.
> > > > > It could be abused right now from anywhere else in the kernel
> > > > > where we don't build as a module :)
> > > > >
> > > > > Apparently we export a similar function in rust where we just removed the last parameter.
> > > >
> > > > To clarify, said Rust function gets inlined into Rust Binder, so Rust
> > > > Binder calls the zap_page_range_single() symbol directly.
> > >
> > > Presumably only for things compiled into the kernel right?
> >
> > Could Rust just use zap_vma_ptes() or does it want to zap things in VMAs
> > that are not VM_PFNMAP?
>
> The VMA is VM_MIXEDMAP, not VM_PFNMAP.

OK this smells like David's cleanup could extend it to allow for
VM_MIXEDMAP :) then we solve the export problem.

The two of these cause endless issues, it's really a mess...

>
> Alice

Cheers, Lorenzo

