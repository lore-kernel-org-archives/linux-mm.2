Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B48CD3EE8A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 16:07:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 390DD6B026F; Thu, 22 Jan 2026 11:07:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31A796B0271; Thu, 22 Jan 2026 11:07:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 173C36B0272; Thu, 22 Jan 2026 11:07:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EF0386B0271
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:07:12 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C42D2D2BDC
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:07:12 +0000 (UTC)
X-FDA: 84360079104.26.B0DF60A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id E86894000B;
	Thu, 22 Jan 2026 16:07:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Gk7+qaV7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=A5H1PXRq;
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769098029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s9Q3bmmX0Y0SVFXEdXQ5FOtVISY7aFrN9t8eFSxHDRI=;
	b=jY8/GVRsISHYCFDR+mvWNlIeyxGN530NU2nrg5+FbgjRyTStcc4Ply4zWUYO+x8fcq/qAG
	/VvFOP5/FEGhpJyM2BgYUJ2eFVoVbj7ZobXJWua73x2La099vsbwtG4Wq5o8T+g0xRBeNh
	c1CnAxNyRJ6gkwZx4m0A0XsgQrThWPI=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Gk7+qaV7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=A5H1PXRq;
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769098029; a=rsa-sha256;
	cv=pass;
	b=2XUyImaRzyqVr0gYBpiISREtYl5nMDa8feH6GII8U3gTOgD5trmnsM5ER/7afv8DORQtlR
	wEcxVGIeYSEmVSp2hdTk4Y3HOtKcF6rPVdyaPd6UdcbsoPfjkdp6x01fKMl5+IMtNerQEa
	YMkgOcjGLJZibzMKyk7nKlOk62dXMb8=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60MDgI75197742;
	Thu, 22 Jan 2026 16:06:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=s9Q3bmmX0Y0SVFXEdXQ5FOtVISY7aFrN9t8eFSxHDRI=; b=
	Gk7+qaV7j6MnDnwXDtLg37Jmf+778XoyTaYn8JJ8ESeoD39zUsDcWVFUVN/M1RkW
	4KEIPoGIfbbOMDmqA8NuqfqN006QyBRl+CGKoQ1JVUCxwYD8K6RTIpX3ncXmBKbS
	lvIfoIm5FcSjt/cjuRgOFyJ/zfKQ2Ns5qmSamSUW7s75q4ZJhK5g4lZo+uftmrOo
	6LpO1YQBGJ5ZG63NywFhwM1jIcauWwmCC9aGVix7a+KOIdDk/5LjpFlFj+GJs8qw
	7esoDUNi5rlzgp8q6gcNazAonwSFBhMiLxo0HLJCrqSweEmxJQnB8gtllaO2oN+z
	cTIpi2Ok8YHTA8vP9d0a8w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2ypyvmb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 16:06:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60MEgcCN032257;
	Thu, 22 Jan 2026 16:06:51 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012013.outbound.protection.outlook.com [52.101.53.13])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vgusre-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 16:06:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XmsGrg0x6uSaMfvsyq2giXXeeuLlI1ITVTNoEkL6ay/420RvKCTWWZN38unihrqFBPtb4U+pYK2gJOi66pb4xpmAIK83hWhBRz6ANrVYsugw23hYJhJjynfXtYKHta7Tg/IVha+IIHPDjt2LR1TOmc5k667xwy676ngurk7q9srrFwOOJcQjv6lrwh5yt5IalMXXvDCd4aeKqyndVrZF2Y2Gsiasw2gXfx9NYBiUZhRvOE4KTshP+9DI7OsRC5QwBQj/VxLJYnia9MGmihIDLfRhlpjBbbcR5rwpTej2KiCAWiI+1FFRww6288PwNTEIwNad5Teirpzzd1S5B+Er0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s9Q3bmmX0Y0SVFXEdXQ5FOtVISY7aFrN9t8eFSxHDRI=;
 b=dm3korXgApYMnFAyoBqf7sLpqPBi/z/l4sueXFTY5ICr/k7gMmqYOw6mdESip6nilEWu9AU5DW9lynhCtagiga3cipa1jrtHlv7K8Q+oRoRVI8p5VVFysThmNJp2Tc+VXTvqCsKzpIvsPGK8CSH3DdpseT7OHYoepa8oYLUltkshFskDvXJ+ond0dcvkbL+yvD5ImxNvNH890FYS+BK1Gn+iiawlLk2zXvag+nk+OIMDaMfJCNZSNJJnQsMKwSNuVXOiPZLcmj/VhxDm1cxHhjjw6zVLR6DNM5AIACE6hVSg4gHdfP3H0a1TKAIpRQzSI+bki4Jv+99BZl5oGg1a8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s9Q3bmmX0Y0SVFXEdXQ5FOtVISY7aFrN9t8eFSxHDRI=;
 b=A5H1PXRqucggfeeMUIIWa2EBqpt5ottyzXqpx/fmuHNJsETFv+/7QzJ0JwW0HRCR+1anAhj5hMpZwQsRZvJ03yVJPz5Jsc0QBn89zvBDk4Mm1XVwjplvbFTjqGVSuFOcqYvrOSQL2rVB90dt44exU/H5Y2eKms/zvqtiONFJmdM=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by BL3PR10MB6065.namprd10.prod.outlook.com (2603:10b6:208:3b4::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Thu, 22 Jan
 2026 16:06:37 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 22 Jan 2026
 16:06:37 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tursulin@ursulin.net>,
        Christian Koenig <christian.koenig@amd.com>,
        Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Benjamin LaHaise <bcrl@kvack.org>, Gao Xiang <xiang@kernel.org>,
        Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        Sandeep Dhavale <dhavale@google.com>,
        Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@kernel.org>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Mike Marshall <hubcap@omnibond.com>,
        Martin Brandenburg <martin@omnibond.com>,
        Tony Luck <tony.luck@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>,
        Babu Moger <babu.moger@amd.com>, Carlos Maiolino <cem@kernel.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        Johannes Thumshirn <jth@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Hugh Dickins <hughd@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, David Howells <dhowells@redhat.com>,
        Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Yury Norov <yury.norov@gmail.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
        linux-cxl@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, linux-erofs@lists.ozlabs.org,
        linux-ext4@vger.kernel.org, linux-mm@kvack.org, ntfs3@lists.linux.dev,
        devel@lists.orangefs.org, linux-xfs@vger.kernel.org,
        keyrings@vger.kernel.org, linux-security-module@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v2 07/13] mm: update secretmem to use VMA flags on mmap_prepare
Date: Thu, 22 Jan 2026 16:06:16 +0000
Message-ID: <a243a09b0a5d0581e963d696de1735f61f5b2075.1769097829.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1769097829.git.lorenzo.stoakes@oracle.com>
References: <cover.1769097829.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0115.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c3::19) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|BL3PR10MB6065:EE_
X-MS-Office365-Filtering-Correlation-Id: 402e74aa-75e0-4614-22ec-08de59d038bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?il09dWPZ0kOdYvNPbDMSul7uFf5aPhDGlq9wemAcC2FxYtUEQOEIIyTIhKSA?=
 =?us-ascii?Q?dIX125YoFCYpFX5qEIh1GykErQHqNFLftKFfx3bn80FWdDu3bMo+GoLU5x+7?=
 =?us-ascii?Q?RrxJlZl/Vx/MRmsAWIV+9oPyAq3uOqsWlC5UGvPvljTkSeDHhLwBItNLfp6v?=
 =?us-ascii?Q?cZRXFKoNj/zj5+uv7DMlC2YgHplsb37czlpWRqCX3R4apbQkH4WwC01sYlWt?=
 =?us-ascii?Q?HKg54oD1bDmJE/ZAYJns8szWSbzrJ5s6c6OqILJRATmKnpuVem+LalIu8Z4r?=
 =?us-ascii?Q?UY2DZpLiWkTFEVfoXrh9kO45xQRk72HMZGe1baWxkTcj88z6Bj7q3GqEodJU?=
 =?us-ascii?Q?Jg7b/UMCqtglbXk77/vkykV/Nyk5qgEehbwcaYg1cYJKnUNo6XMCxbqtojot?=
 =?us-ascii?Q?ko2kET93/9lhY4XHIDi2gNpSuszJGjsfQT756DUiA6IrB6gaSuVXHixyeIvZ?=
 =?us-ascii?Q?zKrd0ebsr6fbXrr9n/7cD5fUOeuABbz0+rt6tHV8A07MZpMx84anADByMhoo?=
 =?us-ascii?Q?OmZ+AMqQhL3o390pD2OoHajGac5i5fdFMPTGL44tp8ItI+6Y2o5tbuwq4a+g?=
 =?us-ascii?Q?oU+VI2YEBSRYD2PFXuL70YSmL5gja+Sd8TapYTt4der7nMPowY7tF1nD9maG?=
 =?us-ascii?Q?gxL5FV0mLaq4uiOT+JjwoWvy+AvL/CKb3/R78LUETscv62XFTR0Uyn8icJMS?=
 =?us-ascii?Q?DxKZammIndwn18Yo8T2r3jDlnvBhbXSFy0TiLxmm+uo3fOkkyBChUFVSHlEA?=
 =?us-ascii?Q?w/MqHxZG5HWA5huO+Ry5JSzkJROsAEXqoVfZl3Y9J6Zk1D1n87eFjOYX1y7p?=
 =?us-ascii?Q?K4etODX5+/GsVgbEFdLrFiWkGakCMfOnUcyaNW3YZOoLBKMbpAsq/aq3N0rS?=
 =?us-ascii?Q?XD8xs+FIgvKZ0iF8zmrZ3K3fj4ottBC+vH9fd5Y5hurtVnyYpfTXji5OMxE+?=
 =?us-ascii?Q?MHnPs/7ofnSoR1qrF7D2taEc4sbwLLJqXd9nyvf18trYymlPVF+G8TFVz0Jj?=
 =?us-ascii?Q?Naibm2Kxrccz1lL3CxPOsAOTwq7UbCDqo0ovY9Lf6S1hWT9DxV1vZLaHdw+B?=
 =?us-ascii?Q?dIOQ6fhqt2Bc0Iw1CkINfz/pyZp/2eOZTYYr86ACoQuOeDkWaI+F519yj+gW?=
 =?us-ascii?Q?8p5y3gF18ijVLOuXwMNdOHMvac2MzK+qMPPfDzNHidttflYpDYEgCmEo+/9p?=
 =?us-ascii?Q?oryqijed8+WE3IKzKt0Wts6+3Dq19X4Ctz0NGvvQJalH1LGxpIMUlSUZUDcy?=
 =?us-ascii?Q?0U7lW+M3UdFTHFnwGF/AtoDSTv4nc364rhRfWSqIpUhv5R7WkrVhKUz6xcsm?=
 =?us-ascii?Q?B45WmYjjucK2rcuy8QxSOujxfs5XAbet3PhIXB67PpGnbzTu0GBHYNEaqhg5?=
 =?us-ascii?Q?S/lqqCr6XlcLfb8j5B8rY7l1GQb3G7nKK/mQQmI8eKqHKpTmQGeinX9wX3Xa?=
 =?us-ascii?Q?qtt5RXDqOKbuiyktuj1MJ/4SO5WplXn9OfaNKvO0fObcbSt6TARiOy8SGIzG?=
 =?us-ascii?Q?UxV7jAdnosDbUwe8/ykQErA77/oGOCn15nqmRPGfwmp7SLd57N00kikUWEZy?=
 =?us-ascii?Q?+honiw15j9vyvnD7T60=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Bj0VtQS2FlsCDRvhvrQw3Tytd55QE1TRlIcg0Qr3Jx8jZNs75qiEMAWg6NWR?=
 =?us-ascii?Q?zICnhV3pbL5envYvgcuXY2Fzg9NO5p0gZ841YN98XTcdqgVhbaJRVJln1D7O?=
 =?us-ascii?Q?uQI+VOgxcBQ/G5UVJEtGuEy/QefKtFPT8CBSOcuCxPIXruO5Mb7dQnFIQU06?=
 =?us-ascii?Q?PCMskpHMqD2gscScGtK5+zk9YKFir1upWbfFEGH1r2ySDiwyDWdsfGuS2BjG?=
 =?us-ascii?Q?mrXtYxTFPUROjzuqudLq04AYbSJ/Hm+MMhYMG44QAOhQjSozuTwxtrZLKDaq?=
 =?us-ascii?Q?u7RYpCClo1Crd8Brth86eam97kGCgmZ32+lJB68EFKvxAawEu2viMlGT/plm?=
 =?us-ascii?Q?Tk/R/o5i5c02j43UvZkFIurmepTVQt5oPeNji2RXWSj4DfCOFyVr3U0hO0qO?=
 =?us-ascii?Q?63zNRGPtoienX5DXKwoUtmeyPs+/KsUwWkuEFkgyzR5+wCsGb47b0ixkB6iL?=
 =?us-ascii?Q?TqVhQw13RLjssC44tzyKdp0WAmzN6rdtGzwU9GdctZL6mfXSWtel6bLJG/xZ?=
 =?us-ascii?Q?EdPhMSAfHosW2KZJ1S5P+3sjePrDdWRdNhGs+sbCU4RCJmX9fKAqnUMy4gp2?=
 =?us-ascii?Q?z0brNq4QLfBdloZq3rOUr4GBeSQSlANAv2AD3mY0yKc3lCFwDjHrYHwvR0TY?=
 =?us-ascii?Q?Mki3BSnSEFkUJkp5BgbE/TjCmEgtLgM7l0nc7grGkbaldQdx604cWknN2oHE?=
 =?us-ascii?Q?y0T0GVZk8M0dx5mE9v2xN029+jKs8Sh42BwfLjJ89j+8BMTpw2oXjFHBZyqV?=
 =?us-ascii?Q?ffcGYjF0K8YpocE3yQCyU/k9QMF5RmCcwMLaOEJNPSUOMLfG9NDeGtNb+BZw?=
 =?us-ascii?Q?+eB0ZM++aOZHl5zJDaVRe6FhmiS6680n7xqapF/fTSVVoE/q2HA1j2HcOHhF?=
 =?us-ascii?Q?Rk69rcO1KWbCNN6jgf4iz5Z9HMJfS8PIZbFvk0a4DxQ9PZ814d8LGht8j2Vn?=
 =?us-ascii?Q?VwMEllTYU1YPYNOMbn03PJrzO0hoHH441VULah+PVbAaNUW3PriUME/tkhIn?=
 =?us-ascii?Q?CZ5wjfOfHXW3YoSfzs+yIBd7SGkyUvpOVDE9kHSwrKdvOtye1IOSqpvesm13?=
 =?us-ascii?Q?HG40vZuXH0eiMjeHMIG9apNjixQBNOf2r7cYXZj/uworqR41jKVOANFa6Hnk?=
 =?us-ascii?Q?lVNZx60jICwNkV589NF2JVvnaBZhI7Z+b69qoKA7B/KDPOmos/bpGxurRrno?=
 =?us-ascii?Q?7/vNMaGEHRnGPlef6gLoG2LkRhX1Bd4vV1JaaX0i8I+0XIycJHiF38NeqaYU?=
 =?us-ascii?Q?ynvpuHej0QSMuLG/gdLOjXlYSvfxRWtNdR4pvf9BrA64kFtZejjJVatTZKou?=
 =?us-ascii?Q?UIRA+KDx9w1nNARFqUlmSm8TgFPiq3sgInfCpE8zDVNwHTscXDuDlqt82UFE?=
 =?us-ascii?Q?xeDibMXVfz4YoTyFbt8Wn4oKIzN2bd91PmL1Eut61dg2qIqrkdiJzmnRp6x/?=
 =?us-ascii?Q?x3zly5ldVo9H62ShMm2vsVRBUBNK+ioKasK21A6er0bqGLUoOa6/BJWt+Cy2?=
 =?us-ascii?Q?qHm+1Rdm2MuDyPHOVWafiOsuw0tyk3sTRN8yBDfYs6Qk2IP980tJiOlaRU87?=
 =?us-ascii?Q?7yZdCeOXy9R+drmlYL15u5ogbtUWqWhJxdVoMdiSOHPWpHuEDP2LeCnarfVr?=
 =?us-ascii?Q?g2qVw304zaxroU8bI2y6N5f1TRaC2OKphgs8/dCelb1GBRxs1MIg2a/rLHHG?=
 =?us-ascii?Q?mZaQxCTcPqHsDDxq0jTeZmc2Xrb1oVtqI5T2uNfUvefa4sr4YjXARDaQFYr7?=
 =?us-ascii?Q?rRmEW9g46RI1YSdBC7C0AREkfPBIk1c=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OYAEXZbvfnV94wFJ3AkWaVeKxNlbI/Rf42q2KXMa5sBF79Xba/r+24uMKIhDnrq6FcODdJXVC+LDsqmEdh1LMI4jWa4v91Lk/qew4YSZN8blsbyrJ9WTIt7E30p71K0tMJApwQnmrPkKKX7U4j9osGcas4ajzQ9A9tjOVEnlb4V5l04TKedxyQNLrpbxht0ZlT8evSuns2NC0yct0h8P5kH4gU+cqZDPui7bgbqJAsaqgYLDKA1ek3Qz0oLq5bd3U6FB1eqUGvtWKmjdMQhCHFUD60mqkgjtWRlU2eCfGHM2ia4am/1ZUgQECMg3FVbbPqFPJblsTnIuTT1Z7MtYBk3vdY52xDklu1IMHtrmOQiv50B09vqMB+7Y3pP0YkAE6JuKbXmrOVtdF4GjAgzlBOd84+FLfNjE40HhczLog8eLeIa00ZPDuIW6ZAkA6jvTPyuvNpn15ee8HgDBTAZFxVfhaYnibP4ZI3KtAx3NzNhEjRTCF9wI8wanhqns+mg3lAufKTJrqJByC2YiFx6gWNpBFIw8+bXYUi8XRPu1to8Q87Gw5OZF97+XZ7n1myG4pvIJP5owYKzqJzmrZ8NGF5JrUsh3yykymXtnKD4YJ3w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 402e74aa-75e0-4614-22ec-08de59d038bf
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 16:06:37.4935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IY4z2RkwG2ZC3PmjluqvXjrxapKIOFJ9MvqdrkcjIj97bs+j2gw//0cElne4i3Tg5FgQHbyP1aTzZVDMLFwGMTwV/QEmtTitcAc5oPd3QMg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6065
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 spamscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601220123
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIyMDEyMyBTYWx0ZWRfX5ObAWnTEfjQf
 wmAAFtkWrKIyOn6jXI23rHSgUDIilA7Kwe/8aOqarYlDxvPrHoFzkUAEwEtp5GvRZgLecSZpTMY
 qWHmpWjm/icDmkVLUSGWNBW/X6XX5fRazW/VZWT/f9uBNI5xs6ce6C3baZfSQtBvngDHhMx7T24
 ZcC7rGND5ncmjY0cDjPA8uAfdujvp75xUPqLIzGSQWYFmnsUpYt7R9stZSeMig1kifQ8ktYbvoA
 8MxUsf5m96RCYsNa21p684cRh9deE2BSikiOwqjbowGkG4MThL+QxfTxqX+VNMmcdvPhx8coYId
 unEewiLAt5vx0f0KF8Aexaxv4oxK4BL0haNi9Sr0QuO+SIx2lV46ri6ECxKzURnDm7Tua2Q1tlE
 ZaQw1Roue6IWYhoUonSnV6G2QLme5AUDPfQqPBlNo43GlMUcXf6hODqY4WtLuDAkgkwN1wztK+Q
 dAo+f1Nzmxg/2wTmc2nojW6lC4fr+VEgqYwA5Kpk=
X-Authority-Analysis: v=2.4 cv=de6NHHXe c=1 sm=1 tr=0 ts=69724b1c b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=1EN7IFrRoGoyj_JuQOoA:9 cc=ntf awl=host:13644
X-Proofpoint-ORIG-GUID: ssBfsmTx-FyMiVG-bU9iAzXFexDYDL3Z
X-Proofpoint-GUID: ssBfsmTx-FyMiVG-bU9iAzXFexDYDL3Z
X-Rspamd-Server: rspam12
X-Stat-Signature: a5w91qik6c6kb89yuj4y9mn1kczozdtr
X-Rspamd-Queue-Id: E86894000B
X-Rspam-User: 
X-HE-Tag: 1769098028-269815
X-HE-Meta: U2FsdGVkX185bYmVznq49Qa0kHeRcZGcaDlSjdujdBjp6g9ufCgWYMWFSukXhdGjZKD3xXaiRi3EnUMY+Gr7AthP/awL53NIYROFebM4LjVYXGobJ+/FQWdyB5lRI8JqArQiKIygX29UaS5IDptuP1BxYB89RGTFoR7alitP3BGq070ksDiXhZpxSTwgs6waqX76yQq/bVYQTrLvcqS9wA831e3OXfhXGMwSYFvqsP6sbFWaPp21R0AmMUDaaR60HvmXvDnz7Qyf+TymAT2Krn+gNGmmOFKazhoH+ojQyBuDYJPnFX4A1FpAFvCVuPOBJe4hAYXn2iQYe7waoZ7xEEs28rjAc5ptbpCTf3a0ckozF7TVmu4UC4uMwtogMsKlcaOWZTWmGXrML2WhUMzKMGPTTQoenPhRTDs6xrkDkYUwa18hw2Mk/SRxRs4c8sdOno/duoBSs25SJSPHTkYKpIAQX6DdoiJllUbW12MjroThJSpT/cLHds8thfrgY/B5jyVdfQJgcEbNAWAHWiopy8IeVvqX+rtTRPciOEmggddVp9pBcMfl5CMETu1IF51hzS94CR/om65qRJqu0u91NKkgSlhkB9fJ6+Q2T5uazjmhJQSLTApOX0nVk7nKw5YeW+5cA6k4XjD36p6v/yQ7QtjLZW4TepBS1Mttu12/ZAQWCtVcvKCIsy8aBHVpYafwwZmLwu42UW6zsmv2trXiqxYGQHZgX1C00u29AEr4058k1pc64FHhOMthLvsPwinI0wsuXOElFlSdMgI/WBzG3TXAr6gtsipv1QgP9dZhCmbAg5TFeamvxrg2yLp0RUIr+kxtwXNEhh1iemk+Ivlzu43km3fIH/CJ6kIHfk4sNI8/wBmm4kJ7HDf/MXvJsCBnkJnoBhdRtxb4Nl+LmUr2SB6LOGF/MNthslCQPHZOokf3YjQ/XwcI+aOtp2xBSomBMFv+DSaVeREbQ/7HN86
 q5E9BD9x
 2DPnUrigX/zj+fIik8z9IimRjdbAd8vCu+xrhW38m8hwAPDobSbc6QfF4519+Laug27nNtVthMR0xe9t16xxVQrlUiUpCz75LvzzaMDr3YYlO/yIp9v2dwDpsb9fqBGw4F2omBmpp/EA4TpR6b8GralppAsQHU/xAKHE8/dSMCRu7bAZIN8rOcBRjuIRfO1nT+AFjY10K1Po+juzR1d23YdhFzm1V/Nkc5cIr4OEKbC8mK796ni6vxYy30bPCyhGT8tl0r/VBGS7Mhsy8wrAmxJMkeRcW0IDI2PwWIrIehseUgyZ3P1893dVPE3LkzL3x62G1Ph4EdzLQwQvHz9uw8K3/IFlM5M8zqbsP+w1xAROslkCJkpj/CwtzsYGNp8UMkcQLKIzZe+i6SQQaQ73lOvP+17oo0ozEPKYK7fxWfT+jTFeW4ZIAikoF+C8lj1Rs96gNtR07WtstBixxUrVVSTMMlYeXFNvSoG5UB7AC9kUYrUlyA7txjigcBOEmA6bYsb31yeNGnBvitRpABLZ9Q9EzdElp1k3ELmoyJUvmIgtW5ZyOpxMRRCHwAovRb/rYGFePMUEtG4BBzfdvrGSXDY7kiS1Z9bLnqxjXvtMJ8G+WpatfUTQX0Or6oUvtcCsqtlX9Ws+a2glwoqO8TsNGf2/lpjOdf2qw+WAEYBoIYznhlUbEzk6uqluE+6MSAY413iQK+hnXiRuuxieI4zyH9+8qaFjb7EDrHpJgtg/wJZXxNGyjsa0ZF+ZctP6GY5YpupUHSKa8vqecP9/8kp8nAoQFAclHDC6fXplD36IYMAp0rkA6v/NrpHwgdRQqpO58wteBMfAH3Z7RPO/RNLtM0lwlmK+0+ruCBiQw40Rbxwuj2YassQnbFyvkXLQ2NwnLibiOiUjQnG5ybJhOIMGCNw+wdF+sGAC7T2iO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch updates secretmem to use the new vma_flags_t type which will
soon supersede vm_flags_t altogether.

In order to make this change we also have to update mlock_future_ok(), we
replace the vm_flags_t parameter with a simple boolean is_vma_locked one,
which also simplifies the invocation here.

This is laying the groundwork for eliminating the vm_flags_t in
vm_area_desc and more broadly throughout the kernel.

No functional changes intended.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 mm/internal.h  | 2 +-
 mm/mmap.c      | 8 ++++----
 mm/mremap.c    | 2 +-
 mm/secretmem.c | 7 +++----
 mm/vma.c       | 2 +-
 5 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index ef71a1d9991f..d67e8bb75734 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1046,7 +1046,7 @@ extern long populate_vma_page_range(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end, int *locked);
 extern long faultin_page_range(struct mm_struct *mm, unsigned long start,
 		unsigned long end, bool write, int *locked);
-bool mlock_future_ok(const struct mm_struct *mm, vm_flags_t vm_flags,
+bool mlock_future_ok(const struct mm_struct *mm, bool is_vma_locked,
 		unsigned long bytes);
 
 /*
diff --git a/mm/mmap.c b/mm/mmap.c
index 038ff5f09df0..354479c95896 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -225,12 +225,12 @@ static inline unsigned long round_hint_to_min(unsigned long hint)
 	return hint;
 }
 
-bool mlock_future_ok(const struct mm_struct *mm, vm_flags_t vm_flags,
-			unsigned long bytes)
+bool mlock_future_ok(const struct mm_struct *mm, bool is_vma_locked,
+		     unsigned long bytes)
 {
 	unsigned long locked_pages, limit_pages;
 
-	if (!(vm_flags & VM_LOCKED) || capable(CAP_IPC_LOCK))
+	if (!is_vma_locked || capable(CAP_IPC_LOCK))
 		return true;
 
 	locked_pages = bytes >> PAGE_SHIFT;
@@ -416,7 +416,7 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 		if (!can_do_mlock())
 			return -EPERM;
 
-	if (!mlock_future_ok(mm, vm_flags, len))
+	if (!mlock_future_ok(mm, vm_flags & VM_LOCKED, len))
 		return -EAGAIN;
 
 	if (file) {
diff --git a/mm/mremap.c b/mm/mremap.c
index 8391ae17de64..2be876a70cc0 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1740,7 +1740,7 @@ static int check_prep_vma(struct vma_remap_struct *vrm)
 	if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP))
 		return -EFAULT;
 
-	if (!mlock_future_ok(mm, vma->vm_flags, vrm->delta))
+	if (!mlock_future_ok(mm, vma->vm_flags & VM_LOCKED, vrm->delta))
 		return -EAGAIN;
 
 	if (!may_expand_vm(mm, vma->vm_flags, vrm->delta >> PAGE_SHIFT))
diff --git a/mm/secretmem.c b/mm/secretmem.c
index edf111e0a1bb..11a779c812a7 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -122,13 +122,12 @@ static int secretmem_mmap_prepare(struct vm_area_desc *desc)
 {
 	const unsigned long len = vma_desc_size(desc);
 
-	if ((desc->vm_flags & (VM_SHARED | VM_MAYSHARE)) == 0)
+	if (!vma_desc_test_flags(desc, VMA_SHARED_BIT, VMA_MAYSHARE_BIT))
 		return -EINVAL;
 
-	if (!mlock_future_ok(desc->mm, desc->vm_flags | VM_LOCKED, len))
+	vma_desc_set_flags(desc, VMA_LOCKED_BIT, VMA_DONTDUMP_BIT);
+	if (!mlock_future_ok(desc->mm, /*is_vma_locked=*/ true, len))
 		return -EAGAIN;
-
-	desc->vm_flags |= VM_LOCKED | VM_DONTDUMP;
 	desc->vm_ops = &secretmem_vm_ops;
 
 	return 0;
diff --git a/mm/vma.c b/mm/vma.c
index f352d5c72212..39dcd9ddd4ba 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -3053,7 +3053,7 @@ static int acct_stack_growth(struct vm_area_struct *vma,
 		return -ENOMEM;
 
 	/* mlock limit tests */
-	if (!mlock_future_ok(mm, vma->vm_flags, grow << PAGE_SHIFT))
+	if (!mlock_future_ok(mm, vma->vm_flags & VM_LOCKED, grow << PAGE_SHIFT))
 		return -ENOMEM;
 
 	/* Check to ensure the stack will not grow into a hugetlb-only region */
-- 
2.52.0


