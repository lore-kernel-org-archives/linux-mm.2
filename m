Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F276D29C37
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 14:52:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 887576B0257; Mon, 19 Jan 2026 09:52:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 811366B025A; Mon, 19 Jan 2026 09:52:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 589556B0257; Mon, 19 Jan 2026 09:52:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 28CE56B0257
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:52:21 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E2859137F39
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 14:52:20 +0000 (UTC)
X-FDA: 84349004040.02.2079646
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 06A0C80004;
	Mon, 19 Jan 2026 14:52:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Xc3LkLZT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lkrGccOR;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768834337; a=rsa-sha256;
	cv=pass;
	b=br2poAMWTkl+OtoRMK4DsoV8tK7Npyjo9+pqpltdv9fVkulKr8wLon0yAUj5pwspexMGuP
	I/cx6ALhjX49yijSojVb/LeK9fAeO8qehY8opGm9PS/DEnCeBWcZDq9wo4f2pJqaIbEtKx
	chm8i0ViKLDUCmnC2rRNlzOiunLpBSc=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Xc3LkLZT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lkrGccOR;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768834337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5nKvo/ijHSu/25JRarQSTXnEAkK2pZ4nhK7tUu2N5WU=;
	b=MruBwfYiMg3pWejBHB54g/4yIgY5cH4tgt8hc+qdMIAyClmT/YpjpJa+T+mi6V5mQ3Ye4m
	mdz/EpMPKKy8A74TCUz7j//wH/ReV8cGBVC9kYp7KfawdmZtc0xJON3Q2V9B8udGLEz0IT
	54DFn+h2Hyr/KwwAsCKf9i8widf94S4=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60JBDQ8d1269390;
	Mon, 19 Jan 2026 14:52:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5nKvo/ijHSu/25JRarQSTXnEAkK2pZ4nhK7tUu2N5WU=; b=
	Xc3LkLZTtHQPpdE6mLneb3ScyjXZnE5E1AnMkPkbPudxOAAO5ihUVjuUGLXpivJc
	bm78pDjW6hjz6V4524X0AiVjHSLSNlE21ylys9jZhHOXmbMS4xwLE4j9pXOCqqA1
	4ITcLWFy96AwWgHiH2oHWoJxaB7hA/zzytP67Fs0J5JlhCAqat8DeuwsB23bXlLu
	lXxNoNyeF25a4Tu9z2zXZUocyOWg8+uofTID/5qnQQexTbR4YfL6VIOWJ8GJAgVe
	WP1AGBHmflKVoNbXyt8t/0MSrmBiHkGWbYYzI6Fao9ImM6E67Gax7pnWyVzG3pQ6
	46h2c0CATeJLAD6DHTfTmw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br1b8ad3e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Jan 2026 14:51:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60JEb1iV008474;
	Mon, 19 Jan 2026 14:51:59 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012020.outbound.protection.outlook.com [52.101.43.20])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0v8g00s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Jan 2026 14:51:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S2arbgOhlk4FSMUJC8Mm4/KWKzqcZulpDdHEGgeVIJQdQqRkVpQy/JHk4abyRCvAtu0yHOaZtGKm+NeMRhsduOr6FosTHw/VF2/4yKXeXCeotxUA6weeW76r6yvblbcm7Hk4khwQzvtG2/B4GeLolTjkWvweUj5Qngngz88jMHHvkBcFpjTDBveNhdZvoRBeC87lbvIycXWrF7j/jHu2N7LamGN5CSpJ2KzcL4a8r04Jksj4ACh/9vvFUWYlxQFQZb6YeEX7wlSZ3flHI0AjJarROh8grLIuXht7liqtRAFkAwUygjwjNnCmPkcPBvWtMkLvtz3/Oo9RxYWLCCyMSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5nKvo/ijHSu/25JRarQSTXnEAkK2pZ4nhK7tUu2N5WU=;
 b=PeX5ow4ZtG/wzoXDmno07PtdBsB3KwumeD/FzZnsZNTimEEat5E1bl1jDHJvRN4On4azDQO6KkUXeIFOozsUaQfsws/rjuhT9cxZTHNhS3X2znvwan74N/mZVjJhNj1joQaPT2JZ3msch5HQFr8dyJ8daKs/n1Zys5+ilZpgJHMUVO5WcPhEiVm8hpExuyRjq2oiESoCFoRn+CSMXsh17lpJs7OnvZEAgRnVM2ve/HVPEYZQSsr+Jj8T5EHPl4WFikcwyptcfEV2TVc4UnPHIidsFYOXTy6IgKk55WO63k2ukYdqQWN5GfUXP2NFCmhsxS/BPaUD18OYmBGK6zXrYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5nKvo/ijHSu/25JRarQSTXnEAkK2pZ4nhK7tUu2N5WU=;
 b=lkrGccORUzWPGrLRrnGByRBL6DKTAkyKkpt6lQjtjneJBFNdDzWxTMGvF6CvnOr75/rZLGDrP4paqSibKyld30UlgZoXhiNE0V4jU/jTdCPRap97hO3xdA2+zNZ2I+OU6dzIWQjhd3K+U2DjjUAcTNn2lOiRIJ+kw6rPntluTio=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by SJ0PR10MB4767.namprd10.prod.outlook.com (2603:10b6:a03:2d1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.9; Mon, 19 Jan
 2026 14:51:53 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Mon, 19 Jan 2026
 14:51:53 +0000
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
Subject: [PATCH 09/12] mm: make vm_area_desc utilise vma_flags_t only
Date: Mon, 19 Jan 2026 14:49:00 +0000
Message-ID: <8a80f23faea395bcf29cdad8ab903de6becd64c5.1768834061.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1768834061.git.lorenzo.stoakes@oracle.com>
References: <cover.1768834061.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0201.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a5::8) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|SJ0PR10MB4767:EE_
X-MS-Office365-Filtering-Correlation-Id: d2f7e32e-90fe-4be6-6d02-08de576a4854
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?v85ttRn9jucCVTpM8fw5gQwTjaf+ZNZFjHdVhAFd/P0vRL03jYHBw8XK0dCk?=
 =?us-ascii?Q?ykShc/A2F0a4x2g4Lv3CpPafNVECGm+s+FWKZOzJ34HkqF2L1N0SJtsBnaYP?=
 =?us-ascii?Q?rft5T07ADcTfwzzdwFgMNsgtZVnMpfWG5RdWv28NZauhEzaphmzJx5Xp9JsW?=
 =?us-ascii?Q?oSoN58GJH6PZTPcKKcnOedz5XO/trmPpMEJ6IrjhStNiaZ0UOccRmUZd1Q6x?=
 =?us-ascii?Q?g0RDqz8A445XhAsv0iQjc644BKSKsCOVxZJZ/cAwHF0piAK82OLaZZ1ul69C?=
 =?us-ascii?Q?VcI92uTAb5phW6mD0p6QaqtRmLfHJumiK6/fiH5XrJ96RF4Udm7A6H1UW7rW?=
 =?us-ascii?Q?PiiiyRIqTKLUwrowKB98DqQcPNfhfaTammoO/zkPvx/Mq0pYWz94sG+HZYaR?=
 =?us-ascii?Q?dtJyQBTEwgeC/5y7mERlGIye2ZCNPW60bZZSlFLq5JVVncikF75xkjAeG5ue?=
 =?us-ascii?Q?fJklSi/wLDIr+SgYlh+wx+WDkUQ1WLORtsLPfatAOsbGeg6Xz2Zimorkavnk?=
 =?us-ascii?Q?cg7dODfahisDUTlh0Xph0D2uy4xHuSdYIso+i+4Waa/Jsik8BsRd9A4KIJJi?=
 =?us-ascii?Q?rKnSOTarTWkCPwKmWms9l75hfewbexx/apIDWaC/Bmx8XcRnLcsqIzIIfqj/?=
 =?us-ascii?Q?3NYTJiT54LybEcfQUBdyXGi/qYEmcerPYNk6dyHOwziYxceKCI94BtDhkXWu?=
 =?us-ascii?Q?9jc8tkiVZlGmVivwqrSwBoN909+d3nOiEqdIHEPg8HQFcI0AHvg30FTG69A5?=
 =?us-ascii?Q?hMN9bx7FLWRmuflTfxwzauXJ6Q/SoHT5AchTPHPesbyE2Xje9FSddI09PukH?=
 =?us-ascii?Q?e3TZ4LckF5GFt4BhDVpJrBHeRn9/PBcpAZLNMTCybEbf5AvIwIL0OulQ/Uvl?=
 =?us-ascii?Q?tUECU5MsXaQFGuJNBPFPkcwgYkqi3J92sBAZcMw5FOJOzQZ82KCwQ374HmWk?=
 =?us-ascii?Q?6y5zUJfLEljuAkyw4IGbk0462TS+unUgMkZkZyobU10t04zTlb4v5oiQoX8V?=
 =?us-ascii?Q?Db2YG3Ia6kM0zQzQOCu8/b61HLUKYyY9Zi2S6Xh/ncyf+Lh+DsPD3kIKpW0l?=
 =?us-ascii?Q?l7pIIvoOIW//87NcWuzwhS8rkJjD60QaqZmlUwHg1ICOsSd7dqBmb5nQjEaH?=
 =?us-ascii?Q?b+NtwZinLV2Nu3+uRpAA9NAZ9rZzNQ1LmYb64Paq7mSX445Uc3LEOf6AbGof?=
 =?us-ascii?Q?HfmnJQR90MrOEg/BVlYYE8LTrpnh//SZJ7qZBW+cphWM5da2SIIThK7AvREV?=
 =?us-ascii?Q?jwrvGRZreX4cXTod0nTWLtIUQf26ur5k7CGXz5zbHCZGHFUP1l4R3WR3zS3i?=
 =?us-ascii?Q?PnpYg4r23QMAdPZ4TpZ06yC9c6TmxzTEM4aUw/X4yMvfNWqkWw8NxwHjCryG?=
 =?us-ascii?Q?247YhTH5zM11ZEuezwj8GvlfqLfOL9i5hGKXOQkneA/+SD/1ViTQcMcW5B5y?=
 =?us-ascii?Q?Q1jHzPPUtf9TBRMnUmEy3rvzctBkjHYHyMLkKQc2TTDVn31B8Yzy5QnzZ2J/?=
 =?us-ascii?Q?/6v2qj43Lpbo4lLmOxdV2EQa6n0eIp1sEH7CQfU9mBUsKEP2UxKX3gU1/1Oc?=
 =?us-ascii?Q?cj3ZCWZZx3hv1e20NLw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GvtJ1wGZ5C0OwgCnGK8DmMNmOLoqX9MiXLUEAqWk/tSwAkv2aszxC2RrFuIS?=
 =?us-ascii?Q?xLwbfJjD9MdcUe/08nDEmYOzbjmb0jzGOaYitTYb2zpYtByfwpg9BWAvfU4v?=
 =?us-ascii?Q?kFHHjR9OGemztIhYTQoxmzkK9WFZWs1x226EgclNzgI3G5cGGW88RlPiqoGq?=
 =?us-ascii?Q?zCMc2Oxbf4fveIxtyInugftHSlMZO2NQjtcuRY5VYJrUYteDF0w5P3JGjOy0?=
 =?us-ascii?Q?T00DDsMhXC7uoKwCJJjesx22s5MkwsR3fsEm95dDObDZc/nmToUiPi6VNbuC?=
 =?us-ascii?Q?pFJy8tw/4oLjs6+ouvA8QgGSMaPibgUKFBau0V0KRU2X71iNt+ZVExokeiUx?=
 =?us-ascii?Q?/SZ0KrBu8hARN7fY7A0osGPQIEvej19jxu+uNHHuskPG25OnAcN8+gHYPKzQ?=
 =?us-ascii?Q?7/VKs+Z+2EkcE4PKzyVNJcTK1hiXOx3Artm1l3R/46uk/fD0j5Dufbeyco/Q?=
 =?us-ascii?Q?Yc9qBTTKDtnfjL4/0TWz/jkxBTpSDUWL4tgvS03BdZrz+lMDK7MiRfcBbQxf?=
 =?us-ascii?Q?bd887tOi/I/C4URZ3Ifu66Dmthg9sTet5MlO7gQ+nRswFfMTMlpRZnAwj5t5?=
 =?us-ascii?Q?1gHRiCV4ewpxBzsSzWBURuEQjEezlQvIvZ5GCvySOlbLEbCp+vMbLR3uGsuA?=
 =?us-ascii?Q?Ak2lfLvKp4JYkGZeCiHkG2dspJ1ZlqzMqKZci3I+JPdgjfNFJK/FeXRGMhgW?=
 =?us-ascii?Q?zvUSEJxYSOmJlE/QQ2vB3k0ztbppg+Jw31sn6YRAhZOo1up6OgHXgiOYQ3Vz?=
 =?us-ascii?Q?ERbLgROCOiHqe0ri0urjNk5+7ugzI/kM7UITeXA2sJj7VmEYvPpisVFpTX6s?=
 =?us-ascii?Q?JW6jpuLqBj3MT0g1JNIUVSG/60cYMK7yoywl9uwtAcnSzN6YrVicgvAFJdDt?=
 =?us-ascii?Q?u+rcY+rfuQryXYbzM3g3tNiw99IcdwxYniYUGj84aFPb0QWoQZdPZMpBl0VY?=
 =?us-ascii?Q?XQ+492GgoH6SSyshoPDJzU2N0axEHgN/LxvX5r/fVPN+s/ZsHA3z9FRK6zoN?=
 =?us-ascii?Q?iDuB3VwSAZGtgGVLrLtjayqGFp+2AI9Xw/QeFFICx/DduZJXaX9W+UVSNIPG?=
 =?us-ascii?Q?TYlhcyt3wPAAQBw3i4T1hDAppGruZVT/z5Eu6ndNIefeEvEdTgMmCsoBEXNz?=
 =?us-ascii?Q?7iU8+HIJIJvjRyL9i0aq1/9eH+iJMUKlG2PXJWWLfjB4cgHjCQKxw1nXMDm4?=
 =?us-ascii?Q?eulsgqTc34wHCvULTOo9BvvTsU4AcTOHY76QwREA5VCmgcMcoK2P2SFjj9+a?=
 =?us-ascii?Q?fZ30h/fxkxtJ9lQed3zhzKHyUeNnSFs5UMUC9QLw55m55YjOz1shzEuFCEbj?=
 =?us-ascii?Q?phWsK5UiESEx1UrwBDMBlYtXPSXyHRq5R1oyBxe54V5dHaa6E6h1S9WVpVr1?=
 =?us-ascii?Q?3V0bMj2/dWMDeN0QcHvNLEqWQ9dnkA3k20efRg/X5WvUogWgn5+7QxioXMnk?=
 =?us-ascii?Q?NV8dnz77ooYSGrzklB+gUw6unIqHcAsBV3BXkFB2U47latmK7JkMH1b11QcK?=
 =?us-ascii?Q?yEBhDfQ8hr2tEiqx8GsAaiMW/902B17giHCUOYbAdaSvNnIUAusgotiU+IoZ?=
 =?us-ascii?Q?mptJ4Y8WpZmGjLgIIxsV4yfqg6FRdi6QovK0TC+QT7/Lydvs9kelaOwf/yc+?=
 =?us-ascii?Q?9ZPsn1Vgh6A3Rkd3FIipxM2/OIvab7iIrePnack733SwGar/gWQmPbEmbsxA?=
 =?us-ascii?Q?RralNe5UP1d47mvY/i7hN6mSN5/d+YRS8t6Q6KdkB7GXRmgY/nxBO1OCJGW8?=
 =?us-ascii?Q?ai2FhNV8eKkk+ahnF6R3h8KdD6IALCY=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NQWtLoa0KWAvl+PO730l9x+NkPTrG18ggzgBHnGh412DUfTVQ912J3OIfu/bnJM0lR0GwAa+6A9+BXiuaAHeJ9wlyTi/mEfx2KqUUa+53TrPF++UKJxbafXrAxpDRi7uxvxM8m/vyKfNumln9XlLROaqAK3V2j/QSpR0A+1x/6zu8IMWQxjiuaExPGbKRhwDGs2MY73rpUDuwo/MQvfHpwR7VmrXUZwMqejgPzBzWTCXqQv4xcA1N6WUuFA7hO11VPNaL5wjW34RcUOhCj3wOxMy7kUpsXxDAP2vuFOQgqSEO29pIRBm+Zz5rGixLd/FEQ74xxuWuB1ZDTH4WSBEfwhgOQ1LQi1tMBJorF6R9Z8s0YYJZbHOxFNWy0MH8h+fuwT8vEyeCJyoPY6nGAy9404SROUp+Pf6WWNw0y3fH1lcrhQcu5n4xzykd5NGZedRO6AVTaztjMu56UJZMZk4XUY+ncMgUqC5VP9VOFYheuk9fnXQJycggBdAPZNmscGsnzknkKcm21hftLoXOKVv8+0tzNH3ua6Aikpv3/vZra7fqvkPeLU05TmDPos1OwXWzhdhWVd0hZEAyOUqFhPxj5e8yAzPG7RVs17r2HbjbTc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2f7e32e-90fe-4be6-6d02-08de576a4854
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 14:51:52.9338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C7c8Gv3n+Wydbw/piRVMsu2w7vXRCGYGvVXDu6QaN8dMq6iavJARtgw0JH7a/JSMWyOs4wyESl+z0phzB8uSKZzyN+P5UPDd08VvRh9/zoc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4767
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-19_03,2026-01-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601190124
X-Authority-Analysis: v=2.4 cv=WbcBqkhX c=1 sm=1 tr=0 ts=696e450f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=GHGLKwWzlU46qEklTYsA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE5MDEyNCBTYWx0ZWRfX6eGVQAljx+fG
 e6xEszL+OJ0YktcQYDHZbCTQnfwvKOsyuCRD3os7mJPb8De729vzeq0diO85wmGrb5xYG1x//wL
 NRda45+e6Co/5VW2lSd2FYAFaUGCppKVSLO5EuCIUhRewX8cjxPq0y5QdCMOuh+IDDOlEYxUslO
 jHoYPqkPOrbsCed5kdgySS7DNPey8E8kxLCJjJ/SVmaej+zq0ZbA/3sswfoa6CHzp/4nX8NvabJ
 6ATmNHodUnm7IBmsEzdJv1bKp3KBikb9IjQqTUVtJDr7f+BCfvYBLI6qMHJW/ncyfifMDIuCwSp
 GqNX8VG4nZx6ByMGeLOHbK7j3vZPi6oPJqYpCqf6gQE7Qp1JGeNhvy7nK96x75+lzgTGlCQ8Qpa
 j5/YEKt8bndTxFjXKJhLmH7RNpn/6UX/PXJvqDt2l4vp3PwuWql/MyGlUrvnS3+GIFt7Hr2LjSH
 TdADaBW3r4OR53QdmXg==
X-Proofpoint-ORIG-GUID: DIZJ_wRXzhYrDUcX1bp6_6POHmLFAOrl
X-Proofpoint-GUID: DIZJ_wRXzhYrDUcX1bp6_6POHmLFAOrl
X-Rspamd-Queue-Id: 06A0C80004
X-Rspamd-Server: rspam06
X-Stat-Signature: ibijok4z8q4h5sin8fj9fxbpeosuu5wh
X-Rspam-User: 
X-HE-Tag: 1768834336-775361
X-HE-Meta: U2FsdGVkX19kdGfm8k4rfI6ygIP8Z9GXy6ag4SJ08aruyTG86DipGGBxvjZoRwHWMUVeNdaSQvBxK/j9Gj0jdx2TUyvdMkOs0v5+s48BBZgTiWHgmzzHhwhizlqJ7v8h1+tfqAzfs9BWSv7sZ83ppQKcpAdEMCy/Z00uiZR4CVzJhCj74rwojTJU82iKHlpD8YpSXXM7rusDtn7Sji7uPLY/BPXO7wFFIbHAiwxW/RHBP0ULWIqlIDDEf4rihssG7NRz4El2bt42/NbqfMee/HeAE+lcGR52/k37rblP5+n784+RHn3qIDDNTgOr1R399p4dwIke/oy1fO6CPg94nu2T3KMF+hJ3My9pzif0qp/RbadsmWfGvYggdhbUfApLGBUKFPqsoM1KeauTH+UF6RHelVtiYowkJhRXv5HFTmHQIu5eoesLnWAiue2OJNpPdaVH49p/zks0LFKfcECcooOkYBgh+Nne2iaYPbCsfUWAQFWrm3KHbMxoSNU43etkRwNsIPwXPlFfMbjTSybRDzP0gPVX0AjD50IOvDn5Yy8K9Qs1nulkc0PyYDn9iU7UYASohIAze4PNkgtWnMKpDdLiy2iiDPhNb3ju/hWBvrnhatVkr186GLCXR/nfEQpDv/1PWF9D0OpsUr+0r49fhxz70DrnrHK862RdjlG7FRyVV47EIp9h1/jiOK2c0Km0Ast69mzhCsHQ1dhKz7CEAjWx0iD7RlphRh6UuLjIJhBR3IWdXkjpGrTcU5b9AoLg+o2+XgxGhTB1nKjrZoArvzNcsAk3rPke4teadaldhuP8q3gM6YaSSRQa8AdMOI/6+nBWRoCxLDON8PrAx/rNBNaMUgrbkCSHXTbXuriznXb+Cisi1+s+tHXPu1ulKuN10WuXAY4xVAqf/Z10oOhOjgFcXvfwrlOVdKdz+PeIt56S20l37nq18HWzRbYenjCFqVuTwpF7PpeUT8TYJCM
 qxJS+lC1
 FHOKpuCKcz+Lab9+1TztFHQ7sv1EXs7bi6xysiCcSSpa30bbfKgFcc/9l+xc03YW8csmCx//8JO631f2aYiu9mBbHgRJJRbYP/0iwLa+IbLe2WNLeZHZidQhCBu0SYK2G82+zGExB00XU0hT5pAX5CRTbum2oOByXsJhKq9SwB5cqHT5sfNiESGTP0ZqKcIs6kPaXy3/RfJlMkCc4E2YxgwFWdY7Zj4zL/BXZm9t70YuCYXD7ZubMNgIs3OmnI2nevsGRBDIVf2eKd3wCxufB5lxXhT4pkH1KQX3EjuSUVLPqVo7zFyKhuBn1r7xZTsMmafhjE/ECVD4gSG+2/k7/jTeW8lgOcqXOC91P0Txst3b/AUfgQ6js0CGxPjjq1MX5A4bFY9Iv1+kj8f4FBv0k/pO91U30DSGlLhkFB/CM5iHig7/feE6+oxZX/uzJuhnGdCWuJ0LDreqO5xeNLu5ob7pBY3Gtd4oGyzZztLVPMi+msyT2XYO30AdcBrlCUx5NM/80bWRumVLeIlU4p+nst7i6PXsqFOSSMqYlFHHuHqrhSHTPFSXOXOBW35PZIWIl5DMRKSDFCRHSsT3ji65QL2Jk5W2YL0Xr/uglrbfeasRHjQf6keAR5+vBM35gsCFSP0f0Sx1I7laDqXkDEpR7nHFCp7Zgl8JZDpssDsR4hsBJnfDmg1AKb3FCW03YcMOFAD3DOOjW9YwBLiCZn2lQBD9ZEog70rUtYwygIGxocY4gGEndEXSj5tPQiroilKSSaLEp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now we have eliminated all uses of vm_area_desc->vm_flags, eliminate this
field, and have mmap_prepare users utilise the vma_flags_t
vm_area_desc->vma_flags field only.

As part of this change we alter is_shared_maywrite() to accept a
vma_flags_t parameter, and introduce is_shared_maywrite_vm_flags() for use
with legacy vm_flags_t flags.

We also update struct mmap_state to add a union between vma_flags and
vm_flags temporarily until the mmap logic is also converted to using
vma_flags_t.

Also update the VMA userland tests to reflect this change.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/mm.h               |  9 +++++++--
 include/linux/mm_types.h         |  5 +----
 mm/filemap.c                     |  2 +-
 mm/util.c                        |  2 +-
 mm/vma.c                         | 11 +++++++----
 mm/vma.h                         |  3 +--
 tools/testing/vma/vma_internal.h |  9 +++++++--
 7 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 09e8e3be9a17..9333d531baa4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1293,15 +1293,20 @@ static inline bool vma_is_accessible(const struct vm_area_struct *vma)
 	return vma->vm_flags & VM_ACCESS_FLAGS;
 }
 
-static inline bool is_shared_maywrite(vm_flags_t vm_flags)
+static inline bool is_shared_maywrite_vm_flags(vm_flags_t vm_flags)
 {
 	return (vm_flags & (VM_SHARED | VM_MAYWRITE)) ==
 		(VM_SHARED | VM_MAYWRITE);
 }
 
+static inline bool is_shared_maywrite(vma_flags_t flags)
+{
+	return vma_flags_test_all(flags, VMA_SHARED_BIT, VMA_MAYWRITE_BIT);
+}
+
 static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
 {
-	return is_shared_maywrite(vma->vm_flags);
+	return is_shared_maywrite(vma->flags);
 }
 
 static inline
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index c3589bc3780e..5042374d854b 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -877,10 +877,7 @@ struct vm_area_desc {
 	/* Mutable fields. Populated with initial state. */
 	pgoff_t pgoff;
 	struct file *vm_file;
-	union {
-		vm_flags_t vm_flags;
-		vma_flags_t vma_flags;
-	};
+	vma_flags_t vma_flags;
 	pgprot_t page_prot;
 
 	/* Write-only fields. */
diff --git a/mm/filemap.c b/mm/filemap.c
index ebd75684cb0a..109a4bf07366 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -4012,7 +4012,7 @@ int generic_file_readonly_mmap(struct file *file, struct vm_area_struct *vma)
 
 int generic_file_readonly_mmap_prepare(struct vm_area_desc *desc)
 {
-	if (is_shared_maywrite(desc->vm_flags))
+	if (is_shared_maywrite(desc->vma_flags))
 		return -EINVAL;
 	return generic_file_mmap_prepare(desc);
 }
diff --git a/mm/util.c b/mm/util.c
index 97cae40c0209..b05ab6f97e11 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1154,7 +1154,7 @@ int __compat_vma_mmap(const struct file_operations *f_op,
 
 		.pgoff = vma->vm_pgoff,
 		.vm_file = vma->vm_file,
-		.vm_flags = vma->vm_flags,
+		.vma_flags = vma->flags,
 		.page_prot = vma->vm_page_prot,
 
 		.action.type = MMAP_NOTHING, /* Default */
diff --git a/mm/vma.c b/mm/vma.c
index 8f1ea5c66cb9..e5489b283de1 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -15,7 +15,10 @@ struct mmap_state {
 	unsigned long end;
 	pgoff_t pgoff;
 	unsigned long pglen;
-	vm_flags_t vm_flags;
+	union {
+		vm_flags_t vm_flags;
+		vma_flags_t vma_flags;
+	};
 	struct file *file;
 	pgprot_t page_prot;
 
@@ -2366,7 +2369,7 @@ static void set_desc_from_map(struct vm_area_desc *desc,
 
 	desc->pgoff = map->pgoff;
 	desc->vm_file = map->file;
-	desc->vm_flags = map->vm_flags;
+	desc->vma_flags = map->vma_flags;
 	desc->page_prot = map->page_prot;
 }
 
@@ -2646,7 +2649,7 @@ static int call_mmap_prepare(struct mmap_state *map,
 		map->file_doesnt_need_get = true;
 		map->file = desc->vm_file;
 	}
-	map->vm_flags = desc->vm_flags;
+	map->vma_flags = desc->vma_flags;
 	map->page_prot = desc->page_prot;
 	/* User-defined fields. */
 	map->vm_ops = desc->vm_ops;
@@ -2819,7 +2822,7 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 		return -EINVAL;
 
 	/* Map writable and ensure this isn't a sealed memfd. */
-	if (file && is_shared_maywrite(vm_flags)) {
+	if (file && is_shared_maywrite_vm_flags(vm_flags)) {
 		int error = mapping_map_writable(file->f_mapping);
 
 		if (error)
diff --git a/mm/vma.h b/mm/vma.h
index d51efd9da113..804f1ee143b6 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -243,8 +243,7 @@ static inline void set_vma_from_desc(struct vm_area_struct *vma,
 	vma->vm_pgoff = desc->pgoff;
 	if (desc->vm_file != vma->vm_file)
 		vma_set_file(vma, desc->vm_file);
-	if (desc->vm_flags != vma->vm_flags)
-		vm_flags_set(vma, desc->vm_flags);
+	vma->flags = desc->vma_flags;
 	vma->vm_page_prot = desc->page_prot;
 
 	/* User-defined fields. */
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index 656c5fe02692..b217cd152e07 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -1009,15 +1009,20 @@ static inline void vma_desc_clear_flags_mask(struct vm_area_desc *desc,
 #define vma_desc_clear_flags(desc, ...) \
 	vma_desc_clear_flags_mask(desc, mk_vma_flags(__VA_ARGS__))
 
-static inline bool is_shared_maywrite(vm_flags_t vm_flags)
+static inline bool is_shared_maywrite_vm_flags(vm_flags_t vm_flags)
 {
 	return (vm_flags & (VM_SHARED | VM_MAYWRITE)) ==
 		(VM_SHARED | VM_MAYWRITE);
 }
 
+static inline bool is_shared_maywrite(vma_flags_t flags)
+{
+	return vma_flags_test_all(flags, VMA_SHARED_BIT, VMA_MAYWRITE_BIT);
+}
+
 static inline bool vma_is_shared_maywrite(struct vm_area_struct *vma)
 {
-	return is_shared_maywrite(vma->vm_flags);
+	return is_shared_maywrite(vma->flags);
 }
 
 static inline struct vm_area_struct *vma_next(struct vma_iterator *vmi)
-- 
2.52.0


