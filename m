Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B56A0CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 14:46:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE4506B0006; Thu, 28 Aug 2025 10:46:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E95226B002B; Thu, 28 Aug 2025 10:46:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5C756B002C; Thu, 28 Aug 2025 10:46:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BDE616B0006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:46:16 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6E73A1DBDE4
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 14:46:16 +0000 (UTC)
X-FDA: 83826441552.27.585AF2B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id E9E0F10000A
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 14:46:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=q8KoGuqQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XxG0pQFp;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756392373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wOJ0ZfETJtm2MQBK//l66cwel20ugHvoMZ5M+Vvu2Zw=;
	b=Xr+MQw3CUMAZIM7Icdw8wHr4B6hQflhoXW0izWUZDMcS4UXn2E2jUmi+h4r6ZbXYAjKS5F
	IoVEso+BiJRXZqA6XauOCb2l2lLEJbFvShHncGO0qyrasfdFPAk6jQg4F03qJRfipFD8sG
	rujcwHC0qCowEpfi3Q7DaUA41Kcze8A=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=q8KoGuqQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XxG0pQFp;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756392373; a=rsa-sha256;
	cv=pass;
	b=luMc7y3032/FmTzUz8xybQYZCIDLwGaHAbz/eGJWMVcLNWkBWBSAxYhIwcD68vCLvswASS
	iKHeyR7TIOfX/NfB14z/NzKTRnOtzHkIqTQahFGFUSQN8gqu+z+jjErC5MT/k0mydZwY6S
	kieMO4geKYFTjLgxRZIEL0kcQJkrWNg=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SENH1k024524;
	Thu, 28 Aug 2025 14:45:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=wOJ0ZfETJtm2MQBK//
	l66cwel20ugHvoMZ5M+Vvu2Zw=; b=q8KoGuqQwskYXFqLpWIcML9Ozqguvj1l39
	ryNj300rIR08i0AjsZ3JjQktoTToxsSnAgrz5uOPdJ7SWxxpq6IIXvbksHs5Ge6s
	JsIyUVQ9j4R9Tn46Qz0JurpOB4N/PAMTkP6DpImoC+YwjZrmkgdkv2OtSCg43497
	wS/sp6yel44BC9xdy75Rr+zC1k5Y05ihKQm+6E5gh6IuZ5sZUbKKyMr77B6+Ti08
	MrZSbQVkZ+gBib9CD8jLthBSYF/cruhcli5vm/X8DrNz/seGpbRDCGz9DdSVKPsZ
	VnMR8aYPjD0ohhB/8uRsZLD7XxcDRoaKRivR52zQfB0/GkaP8dDQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q48errxx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 14:45:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SDtQ5E027313;
	Thu, 28 Aug 2025 14:45:54 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43burj4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 14:45:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sU4TVzZ7eBK2NKH/joqJJoi1F927Adma6LoQ5lIGdNnBuZAArvtzcetZP1lHNAGW3Z6iWDniNgoVEk7Dcz2r4zAshfkhisU8PyErFoTbIS38LkmAYJ648/leqhcs8MLaJpLHcOaZ+8y0PJ7BKb1D46yNlASFhyiIsR1Fay/hmVz310EPRZH/m4MH5mBrRtbWcHphkEmZmO2DZ/RbWOGBNjLrAkN70Mle9RlXnOs/INQLGrN9wDKUsXfbBhiwDu34nr7K/YRubvOkXvNs1bEnI4U2B2hZVubdDCTtLpQpcelgcR0G4ovnR2IorhYrJ9fkAKeTiCBrRxcwH+dFBvvThQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wOJ0ZfETJtm2MQBK//l66cwel20ugHvoMZ5M+Vvu2Zw=;
 b=dGOjHfb5yI/APwVS4Rsz3TH+xHNjL9Yqqw9ACfgZ1QK/BaewpOBtsbBcFC838BsK95kAbAXWYyahqaWlopsXDXd57Od3T34F/sJGPXsp5oZURRRSW/dVQWxsF+9DUjOymI+c4gxn4LO2rXqKUl87tONuCR2iF8iBqIckzqmfZLcDiTOOPdkL+9IoGOqzZW4YRaiL2hluQYx9d9rWmNDtXZs/DF0jhz0jS/c8q4GKZExHrjeZHLEKZXCSYs7eUWfPsL4RoNfzESd3FJIlwRRtHw7DbheFv+/GSS4p/ZXT6BRLX0vZ/brzMEMpRyDefDDlttnTHgD/TUiFyDZVqpguQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wOJ0ZfETJtm2MQBK//l66cwel20ugHvoMZ5M+Vvu2Zw=;
 b=XxG0pQFpT7JhlLGIEb5VTK5+bYlkK+PRTMH2ThGrtfY+zQPtO21XkP8f4Vm0RWj3RZR2+Rz4d/fAjZojbL0qjDpi+gxzcSQhDcUjtfONmZi/NgPQy1qHaYGC74sOzCKhFYr/zHvXqDIdscrQ0Ff0AWoCjvY/t6E70oHQL1HZ4Ww=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH3PR10MB7530.namprd10.prod.outlook.com (2603:10b6:610:155::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.13; Thu, 28 Aug
 2025 14:45:47 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 14:45:47 +0000
Date: Thu, 28 Aug 2025 15:45:39 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Brendan Jackman <jackmanb@google.com>,
        Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
        io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
        John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
        kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mm@kvack.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
        Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
        virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
        wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v1 08/36] mm/hugetlb: check for unreasonable folio sizes
 when registering hstate
Message-ID: <fa3425dd-df25-4a0b-a27e-614c81d301c4@lucifer.local>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-9-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-9-david@redhat.com>
X-ClientProxiedBy: LO4P123CA0422.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18b::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH3PR10MB7530:EE_
X-MS-Office365-Filtering-Correlation-Id: 40cc3033-4fe2-46c8-871b-08dde641930d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sVaOtQgISIAtr1D8WGPkgV8r9k9NkDcDY4YsgvlcDHKBPHOojGeneot0ASdL?=
 =?us-ascii?Q?14OSc7znWUlv4xO7pzB9t6KH45Jv6YLApk06cchu5RQh4ogXUi3y5a3/Sz95?=
 =?us-ascii?Q?e0XRZrRYLwZwb9PMGloQKqnvrs9mxXL9oiqT1x9H2bSnLBPZUADP2ZuYp2g8?=
 =?us-ascii?Q?+wcrj/dHIXPapccVMnvSvUnRNvtctDCEAxRtWzf+jNLycM3BBqKBugy0Fff4?=
 =?us-ascii?Q?TFlm9l6TiL0jpdDd9PPwSlB7Huh0fsR9+fJjro0gcYB9lRHpVGXTS8ysanGt?=
 =?us-ascii?Q?QVDRMX06Pq5rRDqbG5dwaK/kFlwldiM3zEVr7PImAJ+QPX/0pXxxxVkUBYFx?=
 =?us-ascii?Q?Y43/fNyx/+mwvdxMqCXyvjvoWrl199jpsci7lpPWQ8oceGb0Tv4C621cDXDG?=
 =?us-ascii?Q?PwtrmwoUfFB3M8MrEW6MHB9VO/PR2LcIIMnaCz71t5Je84CjsreuNeJaPbgR?=
 =?us-ascii?Q?YcDLI/6YevuWEwPkiIgmLdSlhM7NEhcoUL+jZ+D5yfi4QyB6GwUQfVSbjc+0?=
 =?us-ascii?Q?89bUcYzzvKa5PfOktxtZWLu0ol2N/3oXPSyfFJfmHUV13bE7Bhg5+JSIOd4Z?=
 =?us-ascii?Q?W6V/jwHq+RP2+UlM2hKF8vICGGYzoVIiDSUwjd+ZB7VrjF8tTtmu85hAw3jh?=
 =?us-ascii?Q?gv84D+9tvKZ29cwOC0VOXpsyJr7S/Uw12lbROOUgeYcOnZ07rYmooLmXfgcH?=
 =?us-ascii?Q?PRYHq3yMDjjUhtFt2YhKvj5ktHPeiFrGspJJLSb8ujEPzIn4/evH8i1nC+Jx?=
 =?us-ascii?Q?1T8X11UJHSCHKO0oMyspIRlX9n0dl1B8wRayWB2pzwWuSRDzSTixQoMWaH/K?=
 =?us-ascii?Q?AU5NctfBanOlX/XUV1uEY0aYcGfqDb/mGFmw5t/PuILRilP3qYjlYhHwdk4q?=
 =?us-ascii?Q?sPhblrrh6PX+cSC/frWA25YQsPcmi89cQLif8TeOLE7BRNWkx6EDJVmLr7fe?=
 =?us-ascii?Q?UHK6pQHPW5tqJ327WKqV/WbpJ0wBHgTdweHtCB8XMP8LGtyPSmenqvO6wMfe?=
 =?us-ascii?Q?483I8DYcYu6/rwwkIX3i3J4Q04pn9Zc4hhXQdpNO+YbT0fOFO3NvX6rDHE+h?=
 =?us-ascii?Q?7RcPi/JJGGwoFaed2Em/j7qr30DdIDyCcvocTNuEGOWbeCIboVatkFmlfTgM?=
 =?us-ascii?Q?8WbzwrNFMOVdF58XJ4diwlvz2HrfdXQTONoskX4nOGWv4TfX8QBflkwUM0XN?=
 =?us-ascii?Q?s9UBda8LE+Uqopjf4hkI+x9Ru+0ZJtbSxxvmdu96rYe4C4QXpi2Dh0aqYdBo?=
 =?us-ascii?Q?jLxStXyoVDlsFPy6ZLbOjQc8IkIn7jLSz/tkrLWsd1Bx/fmufnMt7T/u+sJR?=
 =?us-ascii?Q?Ba3hhipffsslwxDkJA8nq+pWffgK7jz9pEu1jxv/pSxrOnpzwMWXX+NyjMwu?=
 =?us-ascii?Q?7RjipgBQPq5XQZWdEpOrzhFfwwiDMVq/7WVN1dghBT2+B52B9GGNvGqbjjSY?=
 =?us-ascii?Q?ci4epALYN70=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Y5ikJeMC3zmMyoqeBaQYjUa+pqQeAqkLMmSpQVZ32Om/8Cnrvpt4weU9NYSi?=
 =?us-ascii?Q?e+oH8QunvWLjVOjsHEBJAjW6XlZALMo6e9nYWW75ZGINg5cAmP1Aynry3zEz?=
 =?us-ascii?Q?hS3K4bvtHVthKH3xbLGHjCrnMfifTOOyZki8cZWvggHAwjGMBut+brQRWBii?=
 =?us-ascii?Q?FwcxGOq9c8fz3c5hr/EINNVzIbgBYvK22/2gWKB//s9mhi67ffPVtZnWSPJ1?=
 =?us-ascii?Q?f0zyUWDHAeI7oG5FjtXVDBhBQnCiSBD7lccVLscsU+1suSpq2OpMTsVD3G99?=
 =?us-ascii?Q?EgrkZbydJfEG7NIQ8NyrE4GHYtZu9peEM+FMFB7CXIcY+IoxCwm/Sq9G4vTg?=
 =?us-ascii?Q?vXJC5xpAZz+rqEPTW47p802pubSkeao8A07YAoSwy4q/IB0FE0OYYUJnHcQH?=
 =?us-ascii?Q?sDgKjL5FGCHjGIqEAnyUIsuwuYFzwa0rfHomyjWEcpOE0yLqBUUROGn3XIyO?=
 =?us-ascii?Q?DWpebCAKIXgz9VQX2NiOLLmWCBfEAE0VHXuxShzz5BECFy2idVptaxOXr+XS?=
 =?us-ascii?Q?gtPv4RuCdYRAY23KUNxB4xJzlZ50ZD/eeMv3XOThM3lgqKLq6XXohckcVhQT?=
 =?us-ascii?Q?RKt5ydSfIN4kH2D8BV4n6nTPPJjOhnIDGAUBVKhMGqYMzqcjaQpBEgDc2w2O?=
 =?us-ascii?Q?eL6Hyxc5iUiweD5tnPCnsNq8qG/ZwxJA+xrTidjs8cGFQxWFVxxxENuUzUZ0?=
 =?us-ascii?Q?94j8vYLKDgluHJ34eiEJs4O+eSq7IIS934QZUztzLBD6Xm4v3u6outQP/+QM?=
 =?us-ascii?Q?Po1X3QUg4qXL6H5lq7fVFMfxq4nlNtyqy8+KF9yGAMJiERFH5Q1vnnWOIoR+?=
 =?us-ascii?Q?xN3DyNywZVtb+HobPrCGz1ubKNeugIonnOmEqVCwq8R02DmTbKOB3w80zTiW?=
 =?us-ascii?Q?+kYjSQ+t6f/OQ4iB18pUOKKp6dHcDxOOPGjar+omccJZGLmxRcBtkHK7z1ve?=
 =?us-ascii?Q?KCnxKTS56m541tlp/Kce5QX/rZ82F7/Yo0tH4Z+X0tATwsodtSAfZrRLyHpZ?=
 =?us-ascii?Q?2RuKSyPJcBjIC0Fm1RUHnXiFsF0hcIIRnjcPJdBSGTzTdgQJGjFFJYn29duD?=
 =?us-ascii?Q?lbq+JAZJ4EeFUoJAu+lpYTL5KM8ZT+RxqwMLzOdhBFNtPpJosHzs4/aKIeqs?=
 =?us-ascii?Q?a8h8CLSM/U6fkbQXwQYJ/VLsljUMa2jKsIj9aUY+vLPaq8QmZNt3Suo5i0Md?=
 =?us-ascii?Q?DSF7CRLUfkYmlyvP+U24V5DHddVT+VeIylq+/1drcssNZ6jIpZSj5d4IU8j2?=
 =?us-ascii?Q?6UMFCzXYH1FGGD9RJBZgyNtZP9GMcQD4Z8srapAWG/371iJJWrbxURAJHxX8?=
 =?us-ascii?Q?1ztZkE1eaokXRFGNrgJhlA3mIeGpf1NDs7TQaq5EDV1DdkYuNmqyKgdQhaW6?=
 =?us-ascii?Q?/4EdtDYK5WHsOEskwZPvJIVPt3kifkn9nOAyFvjOLG1wxLvS8l76fsYwKQ7a?=
 =?us-ascii?Q?VEdzU/1s+0Z7mqczmCmc1B3NYGIhCjdRGDRZ+nxdZZ7J87myAbUaoLlbqKBs?=
 =?us-ascii?Q?x3Xkw+qroupWY2ZG5fMxbCWvIW54xbFiFl0eLTNem9TG4bnBomZImYRzm+mQ?=
 =?us-ascii?Q?N4rxz4hyIfwG1CoAZVRLG+Sj86H5tZ6wue/1uBxq9nOVHNhD2dlvH+hOlDXV?=
 =?us-ascii?Q?Rg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7YiiDieuljhinE+0Eg0agrUS5WxqXKbmNwN1pADXO4BMqniudB6OQYXmMjgbIU6bcGHYYHt+XFOURGgoAAVDPNlpNAoMz2VXUOYqeYN3Q8xKPFefaV+hqULk2UyWIArqgwd9OOzh5/ASpuYMdRkJAeNy6ws2p1RAlJRqMr+2r4dFABWzQDInoAPvQB6e5CbF033twlrIts69Wl6wGo9X01yrwrLFIpez0BOhndwk67ld8uto2cNo39segCrCA1FbuAbXg0Z1epvMynq/fqoizQQ5Wb9tP7vbsEzgI55xr1SL1jShUUsonRW2gGJYoAHrWfPjlpexfdsdmDJKPKgSrzH7fw6vywu9h5SPkuyj9KXj4RP1QYlIAYz6U9U2TNIYdpM8E6efIP1KXcLZYbOkpPBtW1dTTR9XWuaQ6QLlLJT5RMJMfGf/kLw7dzIXHjAF1k3FIxUi0zEcrwIXKzb2S4CQJ0FAZ8qgl0BPYc/31xC+qjopo+crZe0bR/UvcN5htmx1kXb6yeRIA1QGczNUNJ7EjU8iHMz5KocIqjBNVCG9B/ksNQKtArcsurSlzx65KyRj1hxHSQDuoumPOgl/0s5eC++5qA+YiO8LB2aSHxE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40cc3033-4fe2-46c8-871b-08dde641930d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 14:45:47.1735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: toN5GIq5HdgHC/+W/X1VH5g6PItucSbripLmPDmzNyEVLnSdNy2UaNqDsEvUQXL5KzHEtGGMLQf2AJOiEvrXA6xDkYvVVDUKBtT+xWtLAeQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7530
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508280124
X-Proofpoint-GUID: UY-aZ_0k4KZBPJh5SQO_D9BXJ1eGFdM9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxNCBTYWx0ZWRfXxVO9nhg6tKhm
 GWvB57uAbN1h8HfJQsqwVYi1kddfDdzMGbnAIIpf0s1luwOy7ejt8Ssy2TpQHfVjdZ5V22W8mPT
 dMRI6Z8stBaDnEtR26rFI0bbeTmKWzCD0y6t/ybf21wD0L2jY+iUTJ7+hP7Rd868bIHpMDuJfDD
 z6pTyxLP1VGrdEH8iFDR/6+C5bq6NKAWr13wdy89AvLHpscRZsKbjXK03TvIVVNGptU+ac/PhXU
 Lc80Ug5/48JOSVkfGbtaar3ODEcfd+LwH1SYjGpGIl23ivReju2iDjVfjnw1VmlUqHAgSq0Ef8J
 XFrkYUQKWqP1zOQl7qZti2T9O+ukcsHP3QW+i9X5820AbwE/d80DTgEsZf2J9tRJT+hcNsarkcr
 Aj9yWu+V
X-Authority-Analysis: v=2.4 cv=FtgF/3rq c=1 sm=1 tr=0 ts=68b06ba3 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
 a=AC1hTx7W2U6TmaToLwYA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: UY-aZ_0k4KZBPJh5SQO_D9BXJ1eGFdM9
X-Rspamd-Queue-Id: E9E0F10000A
X-Rspam-User: 
X-Stat-Signature: r6axympy8bk4x5x88a6q9rtoc6rm9sc1
X-Rspamd-Server: rspam09
X-HE-Tag: 1756392372-558480
X-HE-Meta: U2FsdGVkX198tMM1ZofBNNnCudhvJEZvcHWzwxhEM5MXGRV0lWt62hmqebp8NgQUYtQb+EuEABK00laGRuWaHnME7UvE5xJL/vyWslvlkiH93DTmixc8ZzkYVysaRL3sOPsAHaecA6CybQECl4YryQhHRvdjJ5JWJjwjLecSg08Z+/NweX/NrzXP4dVBN3e4TiFjSP5Yn0RyJ+tsOyRwR+R6sBhr3TKWISio3xdbHNgJgatc5dEULve395QBWEwIULvS6VYcLWJQUy5mWGeRTL8AlI8NkD5BfrqLpGopN/wDEHhqcfDkepylHLtRKRgX0WW06mUPhkVJDOazD2fPXiCJJjW8Y82Pj72WM8+0rLsDJpLj/BSsZXGSVZPSC1btOStVXRLbFQKuLnczJybXL3y19IcYh6PjpyU7oKcLputiMm26Bm6jA5I4SzJl5fZDuSRATitUc3gnbz8kPTPHixYY/8hDC6hTnAaqdoxmUtm/CzhGoobgM6AIsAoQcoZXn814GxV+po3ux7hMx0OC03hSAfgz10u358XcnIyVaoTn1BR4UOPLLYTnCOEMamsC3oW/LnkIPCZMRdrFGkoX5vzSxXdazxuPmGBUU2bcv65f6qRbOwitt94leweJW36SrQYz+8IVIuoe3AEf5TMvlV7d0JNsI46yv+18dZwz0i806jYCvwY4hjKTraQwkZovdaG3YY0u6165WD37Rq68nCsvtmJjLfkFfdqvWYyo0J3YCN5AZifR4ZEukbPHn4eh/4m0BXzR9Zay+TT9gtS1BCimGRjLJRbGnpheGtzvOcqv2DUApTbuxTNBMo/9yQgggGh76BbVIcZ1KeVBtbS1kDPky0+S/yKnwblOXnGYUfHisJKoFx+p5ALBpwpQgaNrTSFRL0kWhuA0atPySdBeDZy+WKK/O+k/aCF0Oo3SFjLzV8JNGrDDbQ5/5100EREkjndSFym+b226gbpRfCY
 jgDmsWim
 YxnK+DpuOcvxWuLoQwpx9FiSXqFMq85rDIoX6dT6BNn+9Am3FL1oXu2FUpf5jmw1YOAkMSe435JNragWPMQS9LGsn26Nw0bdF89QySuBDjVJt//bHmukPRTUKvVFarK56mKtdcvQS4zV1lYBg3JKh+T7j1oxlbm9yKVXrZbm5X0+jwQrRiHaUlBd2gASpq5jowWIQanTh/hlQ7Il5P1I1PW/Mw0BpD/yE3gBsShCmpS/XS9oBwjxcjC2vi0l21+kiQBt2mb2N+02ejn2fBuUxg4eRgnWYuzwXF/yFXoZBhbAotn8zSVcD4M9gI91hmDX5qMR7Mon/4nr/azva4TcEJOA7CtW+t4we7e/Pq4IcfgTr3thXJJT+uGXJLRI31sbqSo7WxC+sOvxTniF1/3OX1Uy/Uzu3m1+9lXJtZBn+gfmUkbTL+x+oXHimh7MDS4c0UCMqGheKWL4TjB5GaF/hincVcMIdhSYZlxNTUpCH9dtl1g5RFaBQsDncTwzoavOkDK8OaqWv0Pzk3iGuYGJ+ituWCtZkCQNnM43jke4cHuJg/+bRR0DkkZhAjGAilcLULvRkp7n6f/8QxYB770mCdHEKJhtkTetOatBCuyU6N2QEiHiGTGgZpU+D+Qn4HjU2RnClVpobi5Zjm6XJgVp12Ig803/PMiIozHtxtuf7yEhDVboMwbRBPo2pqardQyq/Jr59wmJOKFsnRDBF3ilTAYdeSTEIGeBkAHRV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 12:01:12AM +0200, David Hildenbrand wrote:
> Let's check that no hstate that corresponds to an unreasonable folio size
> is registered by an architecture. If we were to succeed registering, we
> could later try allocating an unsupported gigantic folio size.
>
> Further, let's add a BUILD_BUG_ON() for checking that HUGETLB_PAGE_ORDER
> is sane at build time. As HUGETLB_PAGE_ORDER is dynamic on powerpc, we have
> to use a BUILD_BUG_ON_INVALID() to make it compile.
>
> No existing kernel configuration should be able to trigger this check:
> either SPARSEMEM without SPARSEMEM_VMEMMAP cannot be configured or
> gigantic folios will not exceed a memory section (the case on sparse).

I am guessing it's implicit that MAX_FOLIO_ORDER <= section size?

>
> Signed-off-by: David Hildenbrand <david@redhat.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/hugetlb.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 572b6f7772841..4a97e4f14c0dc 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -4657,6 +4657,7 @@ static int __init hugetlb_init(void)
>
>  	BUILD_BUG_ON(sizeof_field(struct page, private) * BITS_PER_BYTE <
>  			__NR_HPAGEFLAGS);
> +	BUILD_BUG_ON_INVALID(HUGETLB_PAGE_ORDER > MAX_FOLIO_ORDER);
>
>  	if (!hugepages_supported()) {
>  		if (hugetlb_max_hstate || default_hstate_max_huge_pages)
> @@ -4740,6 +4741,7 @@ void __init hugetlb_add_hstate(unsigned int order)
>  	}
>  	BUG_ON(hugetlb_max_hstate >= HUGE_MAX_HSTATE);
>  	BUG_ON(order < order_base_2(__NR_USED_SUBPAGE));
> +	WARN_ON(order > MAX_FOLIO_ORDER);
>  	h = &hstates[hugetlb_max_hstate++];
>  	__mutex_init(&h->resize_lock, "resize mutex", &h->resize_key);
>  	h->order = order;
> --
> 2.50.1
>

