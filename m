Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78EEBE9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 04:33:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B1D86B0088; Tue, 17 Feb 2026 23:33:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5896D6B0089; Tue, 17 Feb 2026 23:33:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4093A6B008A; Tue, 17 Feb 2026 23:33:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 26F276B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 23:33:05 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4BA3B1B4638
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 04:33:04 +0000 (UTC)
X-FDA: 84456307488.20.FA87826
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6012110000C
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 04:33:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YXu4bUpw;
	spf=pass (imf05.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771389180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=LYoBW7Uy3QZC73f5r5QMxWIr1BaiiWhc8rqaFDWR1Yc=;
	b=5ENlNKBUPHciWOUvX/yXRfCJpj3MASNBDmuYaxGDHE1DQj+xzllbvKpvwm2yy+xJaP6OCx
	sNeeAcaJA2CspkK4rogAXZ5zBn1zvtu4VLqEwkOpHaSNIa4GghnmN8lYppbx8zDwJCbfAL
	/UuTIKbHWDHzY142h6Pz5GxV0NEvsyM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771389180; a=rsa-sha256;
	cv=fail;
	b=p7dKYh7mUigpNxvOvzPotbNN5JBut/8ilXwp5wZK8jvz5Yzw3Ccom+45SzJjLWLBndb4+A
	pkF+NyuaIX3mRFkPVL+ADv0UGb8mxZeKXX4312yRz2dHuoAXKZCV8Ihf274l7e7UrfJWUv
	uLd0jI2V51y32IsK0gcOeggb/osHSHc=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YXu4bUpw;
	spf=pass (imf05.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771389179; x=1802925179;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=IaZ0slcQ6SbG31aK0WopN7uhNMnnn9+dcjnVvaGI2ag=;
  b=YXu4bUpwC9gE/bSPEj5f1FHDrtdGWBSamFrReYNjX9/VJuXdFe9SLvVg
   egSfsLUlt5xhrydEjAQGZa6xPZUoW4nQrJhSVGNxdIXyb9Alk8Ha/CPMH
   01vpBz4fD/JTKXQbhOmXrCsu3ZZKJZdkIfwVyqpU78n1d4TBxEfCWGcxA
   Gx20QXltnb9dE09wwWkihHMVJaF9D3I4Xiy9LCv8GgfcL8l3V2to1pChz
   Db8fF0d80sWLByCZGJNx4NgUNGZ9eVemWNdxovi0cmAHNUCDUHQIP48Js
   HUP3R/s/2VDLDN5ZLPLhiVpZksnWx9/Klfzqh/fBzxMGbt3sceR12dUVP
   A==;
X-CSE-ConnectionGUID: HAORkzElTuC8SryUiaCEtA==
X-CSE-MsgGUID: G85PzTUOSFCSbvZRIDCj6w==
X-IronPort-AV: E=McAfee;i="6800,10657,11704"; a="83182733"
X-IronPort-AV: E=Sophos;i="6.21,297,1763452800"; 
   d="scan'208";a="83182733"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2026 20:32:56 -0800
X-CSE-ConnectionGUID: lKIW7PUuTL6bUvNrvwUB/g==
X-CSE-MsgGUID: Ylt9QLClT+C1WF/nZh/5KQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,297,1763452800"; 
   d="scan'208";a="214086921"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2026 20:32:57 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 17 Feb 2026 20:32:57 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 17 Feb 2026 20:32:57 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.21) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 17 Feb 2026 20:32:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xBLocqUxcVzVBJZ00EiDydunNapLDsvEOVvVDZF72AaM4vMFhg+vozkKwQa8pudaMbFetr+WGiobhn4+Tdjw1VH8Z51WNts9M73Ezyx4ROJ174M/R3vpAFeAm17j7afoMJ77Mrnb4guN7Zg6ybzZdAesTayvL8H99XNrndCEJy4UmxZYFE0XF+c5UUTK8/FDcxVz529O0SG0cVHVdqM+sHolCUdByKyMCdD+2aXaPB02keUA48dfpVyRVfUrqauz169jWAlUlwfvkmomtyD1zVqVRSiPkhSU64BKGV6FA+CXiNQ0kmGAcwWtEJbebEOpKX0dvbDgEd8zSaHwTXpLsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZjnR8rz6+rXk4jF8M0boxiOA31IbdpgB6d4BMvWMqX8=;
 b=uAUvot4TtAaOlGJdH679v8WE+rWxyXDIGn14BzIcO3g30QX4H5TKRvhp2e+69dRQgJVVlOs0Ia86YE9ipA6QL1r/6Weker4dhG3MgsaCFlIBjb7nr4ycLyzCZpYNhdklAmlIlFfZIpaqg15ICaE8ytnyF8klh7OsIML34PYo3mCrd70UBSuadxLKrJuzwcO4ridn3YhIqzEzePXx+E+NGMRBmlpGMKITmeQhdWWJ5kxGXQDrJxvs1KQyEj4A8Oh6YRLyKeCgu+Jum0KudTcmG7N1krq/db+JWc7q352gsB6bQwwr2KPsgOfMx067G/0kN4q9C9eZ//YZnFJdL8W3ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by SA1PR11MB5947.namprd11.prod.outlook.com (2603:10b6:806:23b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Wed, 18 Feb
 2026 04:32:52 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::e4de:b1d:5557:7257]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::e4de:b1d:5557:7257%5]) with mapi id 15.20.9632.010; Wed, 18 Feb 2026
 04:32:52 +0000
Date: Wed, 18 Feb 2026 12:32:38 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Ankur Arora <ankur.a.arora@oracle.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Andy Lutomirski <luto@kernel.org>, "Borislav Petkov
 (AMD)" <bp@alien8.de>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, "H.
 Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, "Konrad
 Rzessutek Wilk" <konrad.wilk@oracle.com>, Lance Yang <ioworker0@gmail.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Li Zhe <lizhe.67@bytedance.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mateusz Guzik
	<mjguzik@gmail.com>, Matthew Wilcox <willy@infradead.org>, Michal Hocko
	<mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Peter Zijlstra
	<peterz@infradead.org>, Raghavendra K T <raghavendra.kt@amd.com>, "Suren
 Baghdasaryan" <surenb@google.com>, Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>, <linux-mm@kvack.org>,
	<oliver.sang@intel.com>
Subject: [linus:master] [mm]  94962b2628: will-it-scale.per_thread_ops 2.1%
 regression
Message-ID: <202602181113.b28c053b-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: SI2PR02CA0035.apcprd02.prod.outlook.com
 (2603:1096:4:195::22) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|SA1PR11MB5947:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c23ec22-59f2-42a1-f322-08de6ea6c757
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?IWqjfzi6gUWWbUSAdKhvhrNwTMaD/y8BSqYPl/nGuaZUB7+pPly7TJqJVi?=
 =?iso-8859-1?Q?cKKnA1CQXPvkooMtCBk4CjtVOVGwVOEpW4LJGkWG6gUR0kZZrgRl1GO9Nb?=
 =?iso-8859-1?Q?9PRWWcTaEdk0H8gR10SpBDJT+Len0o0OWiLuOmStmyrdiHj2hkcMM+/3pN?=
 =?iso-8859-1?Q?fOTwRGEYO6UhvW7QLf+CxsaxmFlia0KBy8kB9EH/0J2M2yDLom7qecEezf?=
 =?iso-8859-1?Q?IiVCBCyCEb1+KpqmJ7VWil+TzjJcdogf+D1UpmeVVLBUcl/zlGw/0L0J29?=
 =?iso-8859-1?Q?CFHIi7FDEoTZ5pI2AeDCj7X2ODRb61HqDmz9CQqcOhahALvnYejFo2/uAd?=
 =?iso-8859-1?Q?VLbZH1NwsibW4NWEmkd5cSyR+9/T1/mRPRFPAOIFjgZ/g+CMOOTvBmdIaC?=
 =?iso-8859-1?Q?aFZdOQikii5vcQbDNUOZpe6F84V2ncNEult5Uap8uKkNp8koors5dYJkxO?=
 =?iso-8859-1?Q?z7C+fScAXhhoat4iJJnNWEOinPC7kMS525tHiXr+tG8RYgJ0BCLUdPTUIc?=
 =?iso-8859-1?Q?5nqchjcbWCarorcOamXbbHNECS7zb+v9AtRQ0sR1PY/S7SrjNLoWKim0vK?=
 =?iso-8859-1?Q?A/hs3w/Ok8n3lak4ydv9qMcB+CqtjPngloqfUONF1hVFNbBdFQ+67lpBex?=
 =?iso-8859-1?Q?RSLlYvqRiMKHPhW8ne+DcqRKILzHQiLdRTJ10YjlXVhDpUVOEKboLpKmmZ?=
 =?iso-8859-1?Q?aUENcHJa74BVgc9IK0By5cAraaOQAH2WqBTO8qtEuuq2GtpKf6B+gDHzsF?=
 =?iso-8859-1?Q?fAUCGLWAAnMQDNPDRVUiSygGeugshWA+Bko7B6Fw34YOW3FR74dXm1JeTO?=
 =?iso-8859-1?Q?msTqxl9awol59jPqHs3TxynKj6yTkK8vtSlNi56yvhfQViFFq2sh0jdEGE?=
 =?iso-8859-1?Q?GdVz7SXu4JCcx9/vbUCy1c8eBjwmXEWWi5sRUcKmO+lYaRBLhkWsAcOZzW?=
 =?iso-8859-1?Q?T+f4dQbbFHm+J60Gk8noaHA311t3RJQroPYe9ApM5cE+NuAbp8x8t9br0H?=
 =?iso-8859-1?Q?oc3njnwFigVG8g5vceLYbnI9gF8bNfwAP1X8vcNxS4k+i60Y7qmR1hjWcF?=
 =?iso-8859-1?Q?gBX40Fgt5GLC/nW2BkzCvlnP+cvBinZxUk/QBhxZpj+EVjz4HpvKJXist2?=
 =?iso-8859-1?Q?3bp9QaeAxrYQFoYirzqUWOu0qY2a0F9K2BmUnZC2CxXM2+DPhis10AFft3?=
 =?iso-8859-1?Q?MdXUVTC8xoU1ZIy6x2rC18JP1pXozCoWeAIVtd0cpFUjIPQmhHOd3KG2Jb?=
 =?iso-8859-1?Q?oBWrmbI8guuYwJ0L4Y7alCih3lO7Mni0qr+niUmdiOdac44l71JljSBFYp?=
 =?iso-8859-1?Q?uk80a/dcKWj6Wgfyvti5n2HncRVVHVoNJDmiuNhaAyNQXa6ttjYYptB0mc?=
 =?iso-8859-1?Q?wLvbqSf5GAKxR6S3XpQhJ/D2IrnaRIiebtuTqUJCzwYOQ4wfWRtgnLF8uX?=
 =?iso-8859-1?Q?0uA6g/a7mOIIe10s32wA0Gb88u4D3aHvAg7VvTfxgKUhQbKw57EiKWEAu5?=
 =?iso-8859-1?Q?dVaZP4Mn/4Go1VO8/hKulATmQ9wG82DlwfqGq49xH+f71Yh41Dyv1BEX3T?=
 =?iso-8859-1?Q?8nXX+52O3HahlskHbMyXV49NJNqJuZ5OqslT9idNfA25PEK+EP9kL9we+A?=
 =?iso-8859-1?Q?/7qpH2lTbrh2tQHGzhrfNIe/fjdn7Y8yaU?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?okava4KWDfhAcFuePL9ATiTICiHyIT6NzEPA9VXBECCyfipNgIjda4r8Kg?=
 =?iso-8859-1?Q?10XK+7qffdzlM7Q39dVwVtMH99f6SjaWvB9TbK5n2LI464QqYf1uyVl3Eh?=
 =?iso-8859-1?Q?4AZ3mIakGFs8hOxxLnDh42iMEgS1sTG+coWledBtZahu7VQEMIvog4cq0U?=
 =?iso-8859-1?Q?UF+r3dx5N5t5FLmse1LuYBBHevAH0gZoQ8CLsShQgejlAqwrAuI7kDaFSX?=
 =?iso-8859-1?Q?kANdbNTZWAFOmA1zwuWq9ln3P/YSe4PEvXSEFg3CpHw68kEgvVI+H1sOPC?=
 =?iso-8859-1?Q?dkQ5CFi7lgKiN+lkPVc/SNDxb62VkJ+lxsugPHtfJU4u28jJsvPKehteK6?=
 =?iso-8859-1?Q?J0CdfyhSyTVk3ZnzNP2bzGKgIClYqpGqvbOjms+m9G1myrch4lsQyrT19X?=
 =?iso-8859-1?Q?iZSDBSmHe+KL/+H9bbS+qRh60yiCwuzICS+QDgk9tH8rOWtNUrV/OS2l+J?=
 =?iso-8859-1?Q?xMOXZngP/ic0/eOCOpS/FN7MuAL68BK2BqQGDw/6FkXsnMkwmFV+IDsLxP?=
 =?iso-8859-1?Q?7pOtLdsq86g3Mf34IvI5FuZvBg7Pi2i/pjBHLt0TYUyNQGKWw74mpz+jKk?=
 =?iso-8859-1?Q?krivZ8le0oiBS+A48pzxFdEknlRkJNdUQAcSX3thT1/hvRtoMsngsVBHUU?=
 =?iso-8859-1?Q?odJ1bKB0BrzHA2lcTcl2ig2VH24q8OwZp4kQv1T/sqZJ8GWSUGf/7WN4d3?=
 =?iso-8859-1?Q?+MxbPXS6eX0v7+F/oQm6oO0lwEqiohY5aZB41oisV/2iwvoMmMPsj7bHOt?=
 =?iso-8859-1?Q?G8Y3XNpaT1ZIr8H9zyrOBvPSeh7BRLQM+9uDvOTIEOcl2BANVnXarU7kFZ?=
 =?iso-8859-1?Q?Tq3adkkAcnXzM6+DS356qvhEKjjPXaaJYY0+hi83mRyHQP1FVuyNhIAclV?=
 =?iso-8859-1?Q?Se3HZXyM8IiDO/LU39o+OVTTyHV9QV9dKLfS/aI5NPQRPTy4e4/UkMi7PE?=
 =?iso-8859-1?Q?Ht+8jBgcI7sfKbLVfuoVvdQspfSOvtoBoQ0ze8LFtpwYlKFqTH6eO8Jokp?=
 =?iso-8859-1?Q?Dk8AErME0JYKYOHmMw1nX3Bf5TmyzN5oN91IEcpLPsALRxS2xqhPvc+DH5?=
 =?iso-8859-1?Q?TQge3pVopMMWAFBbxC3P4Ey6REuuBxnDp0shth8PhmcdZ3mywFu2aa+Fua?=
 =?iso-8859-1?Q?IEwa9g/OwYXuQuyy6cjXZJ1/1OZf3xHrQP0S/E1r/i+uoqCksR/JGK3wpp?=
 =?iso-8859-1?Q?GFFsU+kqKIB7hWUTlCU5IeLMrcv3ogs/Ir9msvWSE+1HYNjDubHq6d/ce5?=
 =?iso-8859-1?Q?DFpu9TvR6loSLGaXiqIvwLDKZMEdPeFu+jVu8RN9tbBkE40fNeZlgo6A4z?=
 =?iso-8859-1?Q?I9XdLSJN2BznYuo/OudF93a0CbfwEG76sWC+RjAR5eVVridZ1Ss5/iW8pg?=
 =?iso-8859-1?Q?sCRlt6UYF55cVsUjk5+O42lBIXJy7hVzHCpaYv936YmINBzQ4Jm6HxZJuq?=
 =?iso-8859-1?Q?wsqCYMygRIKXW/eHjnPTwPxmwfxB8RT3Ig0aLj3IVoAWTSrjSy1wki/Yb0?=
 =?iso-8859-1?Q?VVLEMKOizu+dWOJJ8UCrxog/w27qykGVVYGN6deNXwU+4y4l/zZWitcpuv?=
 =?iso-8859-1?Q?qWrzxQxiQim7kyZTUM/P/5yTEM2SjYJhb7vc9B//BhOzvXUs+B5yA7xosp?=
 =?iso-8859-1?Q?GUYxFG+pSfAWysVre5suvdLZBEeDV099KvGrHgramOVW0sXRTuELULswse?=
 =?iso-8859-1?Q?f0k3vTDbCgAUXx2oCQym+dU6/yeQgEDZCzVVv3gM7ioyXbnIep0NsAVUE1?=
 =?iso-8859-1?Q?77/tZ2V/vjJ0nnXjlYIdS7RzUf714iMX52KJoPAGv3PTLdYXgptWoC0bZJ?=
 =?iso-8859-1?Q?pYV/Ft+Y9w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c23ec22-59f2-42a1-f322-08de6ea6c757
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2026 04:32:52.5464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: im4xXqBUh2cOF3O7VDnzUSC74gkMZTty17KK1d30fF8aI8YY1lae1Uy03SoVnaF+k/yJYYxtiNJjHuDDMdiZRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5947
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Stat-Signature: f5pdkxpzp5ejzarzsfek5k1otei1rjc8
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6012110000C
X-HE-Tag: 1771389180-473846
X-HE-Meta: U2FsdGVkX1+bN3eogC/xRdNtpsB7WLmv/1Fb2+HwVNzmyGI7quRKIGUfadqt168va58gkwWJflEjv6+w+unwD5O/FRFM+pr6YxIVdxXMG3PpzQcuZFJyNFEybkU4wcHbSiAZflPdASO1r6OQYyZVhW0qBIqnWMmHgXPkJTqSm79W4KFMinEOyI035rv6CLuzvVcg2phew23PKS56WpAfHu/ShqW5gSwh48Ti6NQ9w1YZohJlO1398vT1rO79xiP54mBrcB64qiyh4aHT7M+TUawHxrN59by7p3iIjZhlTH7RDdY9JuWMg5hoKl7KUT9itJFXBDdTb00MB80iPjVYi56Ldf0CT4CjepWCFLP3LWVqeV3blyLI+HqfWToSDjMh1HLAuJlsCdGk/lOuKW2kRMjoWCZu3XK187LLaTNxwp84kcnLin7/3G0qmTTmUafrJQ9JFIA59KXIpBNbU+9B774R8X6+3nXdKLldnkNMRXSaxpj17+359nNJE6A9E27QmEPPVduQpg/jFkgLprz1qDJIntXuP+6rFn2sqZ4e0z7aIo8ssZCFh96OMXR40f2hflDmZ4/3hl3iCYkty9myuGlsQLGqD4+n1QmHvi7ca/MJNjy7ePdEGSzg77EIeXEaTvH8t6KN8xKASRxAU4cRG3HS313uP5mF5TUskLqtqaE8nusWH5LzpnZ8fawpOYCJfMaYGDoy29QxrH5Vw8c3ttgEU2F3L8VU0xkl1/ruw3l9dEcMsDpJ/9A7yQeI3yAFfscZiX2I4m3OUlUx9Y2AaxgPNqiQrN7ObpT5mpg2L5IVOFM1pfkICODzV5O6vvaAY2QvoWZSWAneogBa0uEn5Swiben/t3IQ5QRfiE+MROBn9Zr0hkXNsK2sENtdRA0oRQ7FtvJq5/X2U5w3iQIa1R218HUA72VAXyXxlS5LlfzeKK41gc1joGSJE9jbommePuBjpbCJZ1EPMr2LCww
 2oLjnAcN
 mCgHQ25iTgsLSV+3a6f5TY5p32C/SEcSe65X0+Pq73N8fqQ/dc7xATbJYCM4kt6CmqP5owbIN+hIFgAhgGNv/mCUR4k1t1LmwWgN5J56FcxgbnNNbeB/pa0czqYSPF/hcCkkSSekzh4BT9Fnvu2kpqGOI/iD44rS7A+L/uJY23ZEgwkhcZx0K9zwatANu3ZRQwUBDWStdWTJ9dLQSOoN3IM77l2V0iGhVMgetydJaod/c4esCJRddFuaGrLsuPg83qYy0uV4hU9p+yXDSa2oPOcHeHhIrHO1msIdOPzMb3KgkiNArHia9I2eA6iah4qohvaFxXzdmGIB08dJn6iH1rSDXLYaKU4Fn1fSZxaoE41IBiu2KmXXaphGMfYztZPvHFK+7NmlBFsrSRGbBg1kVsnh6CJOGhyJSHeFq8kYJMDlAmHrFCMmWQNI69TSbKEltGCykCwEkF40IOUBVqNRQyd8mdawLZETYTCU50LoekQyuFcpVWjS/zo4NQa0WTF6Kou0A/Qn17SGqYpvDZFZvlc6eO0aq4KVv72OEl10l1oEGwvqwHwWiWD2J8+i0vIZG8YXm1dkuKa2zEQ82lsrVbNQH+PkXiuivk7J/Oly6NalTKursriR7rzHFsHYS+gimlaFu9Qz2jFEjCeU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,


we reported
"[linux-next:master] [mm]  94962b2628: will-it-scale.per_process_ops 4.8% improvement"
on
https://lore.kernel.org/all/202601312034.df465f26-lkp@intel.com/

now we notice a small regression. report this just FYI what we observed in our
tests.

(previous reported improvement as well as another improvement are also recorded
in this report)



kernel test robot noticed a 2.1% regression of will-it-scale.per_thread_ops on:


commit: 94962b2628e6af2c48be6ebdf9f76add28d60ecc ("mm: folio_zero_user: clear page ranges")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

[still regression on linus/master      9702969978695d9a699a1f34771580cdbb153b33]
[still regression on linux-next/master 350adaf7fde9fdbd9aeed6d442a9ae90c6a3ab97]

testcase: will-it-scale
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 224 threads 4 sockets Intel(R) Xeon(R) Platinum 8380H CPU @ 2.90GHz (Cooper Lake) with 192G memory
parameters:

	nr_task: 100%
	mode: thread
	test: page_fault1
	cpufreq_governor: performance


In addition to that, the commit also has significant impact on the following tests:

+------------------+---------------------------------------------------------------+
| testcase: change | will-it-scale: will-it-scale.per_thread_ops 7.7% improvement  |
| test parameters  | cpufreq_governor=performance                                  |
|                  | mode=thread                                                   |
|                  | nr_task=100%                                                  |
|                  | test=page_fault1                                              |
+------------------+---------------------------------------------------------------+
| testcase: change | will-it-scale: will-it-scale.per_process_ops 4.8% improvement |
| test parameters  | cpufreq_governor=performance                                  |
|                  | mode=process                                                  |
|                  | nr_task=100%                                                  |
|                  | test=page_fault1                                              |
+------------------+---------------------------------------------------------------+


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202602181113.b28c053b-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260218/202602181113.b28c053b-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/thread/100%/debian-13-x86_64-20250902.cgz/lkp-cpl-4sp2/page_fault1/will-it-scale

commit: 
  9890ecab6a ("mm: folio_zero_user: clear pages sequentially")
  94962b2628 ("mm: folio_zero_user: clear page ranges")

9890ecab6ad9c0d3 94962b2628e6af2c48be6ebdf9f 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
  30035370            -2.1%   29406354        will-it-scale.224.threads
     78.68            +4.0%      81.86        will-it-scale.224.threads_idle
    134086            -2.1%     131277        will-it-scale.per_thread_ops
  30035370            -2.1%   29406354        will-it-scale.workload
    152.57 ±  2%      +7.1%     163.40        perf-sched.total_wait_and_delay.average.ms
    152.51 ±  2%      +7.1%     163.34        perf-sched.total_wait_time.average.ms
    152.57 ±  2%      +7.1%     163.40        perf-sched.wait_and_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
    152.51 ±  2%      +7.1%     163.34        perf-sched.wait_time.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
     74.61           -39.0       35.56        perf-profile.calltrace.cycles-pp.folio_zero_user.vma_alloc_anon_folio_pmd.__do_huge_pmd_anonymous_page.__handle_mm_fault.handle_mm_fault
     80.40           -11.9       68.48        perf-profile.calltrace.cycles-pp.testcase
     76.97           -10.2       66.78        perf-profile.calltrace.cycles-pp.asm_exc_page_fault.testcase
     76.85           -10.1       66.72        perf-profile.calltrace.cycles-pp.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.testcase
     76.85           -10.1       66.72        perf-profile.calltrace.cycles-pp.exc_page_fault.asm_exc_page_fault.testcase
     76.78           -10.1       66.66        perf-profile.calltrace.cycles-pp.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.testcase
     76.77           -10.1       66.65        perf-profile.calltrace.cycles-pp.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
     76.75           -10.1       66.64        perf-profile.calltrace.cycles-pp.__do_huge_pmd_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault
     76.15            -9.9       66.30        perf-profile.calltrace.cycles-pp.vma_alloc_anon_folio_pmd.__do_huge_pmd_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      5.86            -5.9        0.00        perf-profile.calltrace.cycles-pp.__cond_resched.folio_zero_user.vma_alloc_anon_folio_pmd.__do_huge_pmd_anonymous_page.__handle_mm_fault
      1.03            -0.1        0.92        perf-profile.calltrace.cycles-pp.vma_alloc_folio_noprof.vma_alloc_anon_folio_pmd.__do_huge_pmd_anonymous_page.__handle_mm_fault.handle_mm_fault
      1.00            -0.1        0.90        perf-profile.calltrace.cycles-pp.alloc_pages_mpol.vma_alloc_folio_noprof.vma_alloc_anon_folio_pmd.__do_huge_pmd_anonymous_page.__handle_mm_fault
      1.00            -0.1        0.90        perf-profile.calltrace.cycles-pp.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof.vma_alloc_anon_folio_pmd.__do_huge_pmd_anonymous_page
      0.99            -0.1        0.89        perf-profile.calltrace.cycles-pp.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof.vma_alloc_anon_folio_pmd
      0.93            -0.1        0.85        perf-profile.calltrace.cycles-pp.prep_new_page.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof
      0.37 ± 71%      +0.4        0.81 ± 19%  perf-profile.calltrace.cycles-pp.tick_nohz_handler.__hrtimer_run_queues.hrtimer_interrupt.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt
      0.71 ± 19%      +0.5        1.20 ± 17%  perf-profile.calltrace.cycles-pp.__hrtimer_run_queues.hrtimer_interrupt.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
      0.81 ± 14%      +0.6        1.42 ± 12%  perf-profile.calltrace.cycles-pp.hrtimer_interrupt.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.pv_native_safe_halt
      0.82 ± 14%      +0.6        1.43 ± 12%  perf-profile.calltrace.cycles-pp.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.pv_native_safe_halt.acpi_safe_halt
      0.00            +0.7        0.69 ± 16%  perf-profile.calltrace.cycles-pp.update_process_times.tick_nohz_handler.__hrtimer_run_queues.hrtimer_interrupt.__sysvec_apic_timer_interrupt
      1.14 ±  9%      +0.9        2.04 ±  7%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.pv_native_safe_halt.acpi_safe_halt.acpi_idle_do_entry
      0.85            +0.9        1.76        perf-profile.calltrace.cycles-pp.free_unref_folios.folios_put_refs.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_finish_mmu
      0.93            +1.0        1.92        perf-profile.calltrace.cycles-pp.folios_put_refs.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_finish_mmu.vms_clear_ptes
      0.94            +1.0        1.94        perf-profile.calltrace.cycles-pp.__tlb_batch_free_encoded_pages.tlb_finish_mmu.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap
      0.94            +1.0        1.94        perf-profile.calltrace.cycles-pp.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_finish_mmu.vms_clear_ptes.vms_complete_munmap_vmas
      1.32 ±  8%      +1.1        2.39 ±  6%  perf-profile.calltrace.cycles-pp.pv_native_safe_halt.acpi_safe_halt.acpi_idle_do_entry.acpi_idle_enter.cpuidle_enter_state
      1.02            +1.1        2.12        perf-profile.calltrace.cycles-pp.tlb_finish_mmu.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      1.11            +1.2        2.28        perf-profile.calltrace.cycles-pp.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      1.12            +1.2        2.31        perf-profile.calltrace.cycles-pp.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      1.15            +1.2        2.35        perf-profile.calltrace.cycles-pp.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.15            +1.2        2.35        perf-profile.calltrace.cycles-pp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64
      1.19            +1.2        2.40        perf-profile.calltrace.cycles-pp.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
      1.19            +1.2        2.40        perf-profile.calltrace.cycles-pp.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
      1.20            +1.2        2.40        perf-profile.calltrace.cycles-pp.__munmap
      1.19            +1.2        2.40        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
      1.19            +1.2        2.40        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__munmap
     17.66           +10.3       27.92        perf-profile.calltrace.cycles-pp.acpi_safe_halt.acpi_idle_do_entry.acpi_idle_enter.cpuidle_enter_state.cpuidle_enter
     17.67           +10.3       27.93        perf-profile.calltrace.cycles-pp.acpi_idle_do_entry.acpi_idle_enter.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call
     17.67           +10.3       27.95        perf-profile.calltrace.cycles-pp.acpi_idle_enter.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle
     17.71           +10.3       28.02        perf-profile.calltrace.cycles-pp.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle.cpu_startup_entry
     17.72           +10.3       28.04        perf-profile.calltrace.cycles-pp.cpuidle_enter.cpuidle_idle_call.do_idle.cpu_startup_entry.start_secondary
     17.97           +10.6       28.55        perf-profile.calltrace.cycles-pp.cpuidle_idle_call.do_idle.cpu_startup_entry.start_secondary.common_startup_64
     18.02           +10.6       28.64        perf-profile.calltrace.cycles-pp.do_idle.cpu_startup_entry.start_secondary.common_startup_64
     18.02           +10.6       28.65        perf-profile.calltrace.cycles-pp.cpu_startup_entry.start_secondary.common_startup_64
     18.02           +10.6       28.65        perf-profile.calltrace.cycles-pp.start_secondary.common_startup_64
     18.10           +10.7       28.76        perf-profile.calltrace.cycles-pp.common_startup_64
     33.38           +19.1       52.51        perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.pv_native_safe_halt.acpi_safe_halt.acpi_idle_do_entry.acpi_idle_enter
      0.00           +23.8       23.83        perf-profile.calltrace.cycles-pp.asm_sysvec_call_function.folio_zero_user.vma_alloc_anon_folio_pmd.__do_huge_pmd_anonymous_page.__handle_mm_fault
      0.68           +35.4       36.07        perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.folio_zero_user.vma_alloc_anon_folio_pmd.__do_huge_pmd_anonymous_page.__handle_mm_fault
     80.51           -12.0       68.53        perf-profile.children.cycles-pp.testcase
     76.97           -10.2       66.78        perf-profile.children.cycles-pp.asm_exc_page_fault
     76.85           -10.1       66.72        perf-profile.children.cycles-pp.do_user_addr_fault
     76.85           -10.1       66.72        perf-profile.children.cycles-pp.exc_page_fault
     76.78           -10.1       66.66        perf-profile.children.cycles-pp.handle_mm_fault
     76.77           -10.1       66.65        perf-profile.children.cycles-pp.__handle_mm_fault
     76.75           -10.1       66.64        perf-profile.children.cycles-pp.__do_huge_pmd_anonymous_page
     76.16            -9.9       66.30        perf-profile.children.cycles-pp.vma_alloc_anon_folio_pmd
     75.05            -9.7       65.31        perf-profile.children.cycles-pp.folio_zero_user
      5.90            -5.9        0.00        perf-profile.children.cycles-pp.__cond_resched
      1.25            -0.2        1.05        perf-profile.children.cycles-pp.alloc_pages_mpol
      1.24            -0.2        1.05        perf-profile.children.cycles-pp.__alloc_frozen_pages_noprof
      1.10            -0.1        0.96        perf-profile.children.cycles-pp.get_page_from_freelist
      1.03            -0.1        0.92        perf-profile.children.cycles-pp.vma_alloc_folio_noprof
      0.25            -0.1        0.14 ±  4%  perf-profile.children.cycles-pp.map_anon_folio_pmd_pf
      0.27 ±  2%      -0.1        0.16 ±  2%  perf-profile.children.cycles-pp.pte_alloc_one
      0.26 ±  2%      -0.1        0.16 ±  2%  perf-profile.children.cycles-pp.alloc_pages_noprof
      0.23 ±  7%      -0.1        0.13 ±  5%  perf-profile.children.cycles-pp.task_tick_fair
      0.98            -0.1        0.89        perf-profile.children.cycles-pp.prep_new_page
      0.16 ±  3%      -0.1        0.10 ±  5%  perf-profile.children.cycles-pp.map_anon_folio_pmd_nopf
      0.08 ± 13%      -0.1        0.02 ± 99%  perf-profile.children.cycles-pp.update_cfs_group
      0.09 ±  5%      -0.0        0.05 ±  8%  perf-profile.children.cycles-pp.__memcg_kmem_charge_page
      0.08 ±  6%      -0.0        0.04 ± 44%  perf-profile.children.cycles-pp.rmqueue
      0.10 ±  9%      -0.0        0.07        perf-profile.children.cycles-pp.update_load_avg
      0.09 ±  4%      -0.0        0.06 ±  8%  perf-profile.children.cycles-pp.__folio_batch_add_and_move
      0.08 ±  5%      -0.0        0.05 ±  8%  perf-profile.children.cycles-pp.folio_batch_move_lru
      0.07 ±  5%      -0.0        0.04 ± 44%  perf-profile.children.cycles-pp.its_return_thunk
      0.08            -0.0        0.05 ±  8%  perf-profile.children.cycles-pp.mod_node_page_state
      0.11 ±  3%      -0.0        0.09 ±  4%  perf-profile.children.cycles-pp.native_irq_return_iret
      0.05            +0.0        0.07 ±  5%  perf-profile.children.cycles-pp.down_write_killable
      0.05            +0.0        0.07 ±  5%  perf-profile.children.cycles-pp.rwsem_down_write_slowpath
      0.09 ±  4%      +0.0        0.11 ±  7%  perf-profile.children.cycles-pp.perf_rotate_context
      0.05 ±  8%      +0.0        0.08 ± 12%  perf-profile.children.cycles-pp.update_rq_clock_task
      0.05            +0.0        0.08 ±  4%  perf-profile.children.cycles-pp.free_tail_page_prepare
      0.05            +0.0        0.08 ±  8%  perf-profile.children.cycles-pp.__schedule
      0.05            +0.0        0.09        perf-profile.children.cycles-pp.vm_mmap_pgoff
      0.07 ± 16%      +0.0        0.11 ±  6%  perf-profile.children.cycles-pp.rcu_pending
      0.05            +0.0        0.09 ±  5%  perf-profile.children.cycles-pp.sched_balance_find_src_group
      0.02 ± 99%      +0.0        0.07 ± 13%  perf-profile.children.cycles-pp.arch_scale_freq_tick
      0.06 ±  6%      +0.0        0.11 ±  6%  perf-profile.children.cycles-pp.sched_balance_domains
      0.04 ± 71%      +0.0        0.08 ± 13%  perf-profile.children.cycles-pp.kthread
      0.03 ±141%      +0.0        0.08 ± 29%  perf-profile.children.cycles-pp.ktime_get_update_offsets_now
      0.04 ± 71%      +0.0        0.08 ± 13%  perf-profile.children.cycles-pp.ret_from_fork
      0.04 ± 71%      +0.0        0.08 ± 13%  perf-profile.children.cycles-pp.ret_from_fork_asm
      0.08 ± 17%      +0.0        0.13 ± 13%  perf-profile.children.cycles-pp.rcu_sched_clock_irq
      0.05 ±  7%      +0.0        0.10        perf-profile.children.cycles-pp.__mmap
      0.00            +0.1        0.05 ±  7%  perf-profile.children.cycles-pp.__pick_next_task
      0.00            +0.1        0.05 ±  7%  perf-profile.children.cycles-pp.should_flush_tlb
      0.04 ± 44%      +0.1        0.09 ±  5%  perf-profile.children.cycles-pp.update_sd_lb_stats
      0.02 ± 99%      +0.1        0.08 ±  8%  perf-profile.children.cycles-pp.free_pcppages_bulk
      0.00            +0.1        0.05 ±  8%  perf-profile.children.cycles-pp.update_irq_load_avg
      0.00            +0.1        0.06 ±  9%  perf-profile.children.cycles-pp.free_frozen_page_commit
      0.00            +0.1        0.06 ±  8%  perf-profile.children.cycles-pp.do_mmap
      0.00            +0.1        0.06 ± 13%  perf-profile.children.cycles-pp.__get_next_timer_interrupt
      0.06 ±  6%      +0.1        0.12 ±  4%  perf-profile.children.cycles-pp.tick_irq_enter
      0.00            +0.1        0.06 ±  9%  perf-profile.children.cycles-pp.__folio_unqueue_deferred_split
      0.00            +0.1        0.06        perf-profile.children.cycles-pp.check_cpu_stall
      0.00            +0.1        0.06        perf-profile.children.cycles-pp.lru_gen_del_folio
      0.07 ±  5%      +0.1        0.13 ±  2%  perf-profile.children.cycles-pp.sched_balance_rq
      0.07 ± 11%      +0.1        0.13 ± 20%  perf-profile.children.cycles-pp.clockevents_program_event
      0.00            +0.1        0.06 ±  6%  perf-profile.children.cycles-pp.__page_cache_release
      0.08 ±  8%      +0.1        0.15 ± 12%  perf-profile.children.cycles-pp.sched_balance_update_blocked_averages
      0.00            +0.1        0.07 ±  7%  perf-profile.children.cycles-pp.schedule
      0.07 ±  6%      +0.1        0.14 ±  4%  perf-profile.children.cycles-pp.irq_enter_rcu
      0.08 ±  8%      +0.1        0.15 ± 10%  perf-profile.children.cycles-pp.sched_balance_softirq
      0.08            +0.1        0.15 ±  3%  perf-profile.children.cycles-pp.zap_huge_pmd
      0.08            +0.1        0.15 ±  3%  perf-profile.children.cycles-pp.zap_pmd_range
      0.00            +0.1        0.07 ±  6%  perf-profile.children.cycles-pp.update_sg_lb_stats
      0.08 ±  4%      +0.1        0.16 ±  3%  perf-profile.children.cycles-pp.unmap_vmas
      0.08            +0.1        0.16 ±  3%  perf-profile.children.cycles-pp.unmap_page_range
      0.18 ±  2%      +0.1        0.26 ±  2%  perf-profile.children.cycles-pp.asm_sysvec_call_function_single
      0.09 ±  4%      +0.1        0.18        perf-profile.children.cycles-pp.flush_tlb_mm_range
      0.09 ±  5%      +0.1        0.18        perf-profile.children.cycles-pp.on_each_cpu_cond_mask
      0.09 ±  5%      +0.1        0.18        perf-profile.children.cycles-pp.smp_call_function_many_cond
      0.25 ± 12%      +0.1        0.36 ± 14%  perf-profile.children.cycles-pp.perf_mux_hrtimer_handler
      0.05 ±141%      +0.1        0.17 ± 62%  perf-profile.children.cycles-pp.timekeeping_max_deferment
      0.17 ±  5%      +0.1        0.31 ±  2%  perf-profile.children.cycles-pp.handle_softirqs
      0.19 ±  4%      +0.1        0.34 ±  2%  perf-profile.children.cycles-pp.__irq_exit_rcu
      0.15 ± 51%      +0.2        0.32 ± 46%  perf-profile.children.cycles-pp.tick_nohz_next_event
      0.16 ± 46%      +0.2        0.36 ± 42%  perf-profile.children.cycles-pp.tick_nohz_get_sleep_length
      0.24 ±  7%      +0.2        0.44 ± 11%  perf-profile.children.cycles-pp.ktime_get
      0.22 ± 34%      +0.2        0.45 ± 33%  perf-profile.children.cycles-pp.menu_select
      1.41 ±  8%      +0.4        1.82 ±  9%  perf-profile.children.cycles-pp.hrtimer_interrupt
      1.42 ±  8%      +0.4        1.84 ±  9%  perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
      1.76 ±  5%      +0.7        2.47 ±  6%  perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      0.85            +0.9        1.77        perf-profile.children.cycles-pp.free_unref_folios
      0.93            +1.0        1.92        perf-profile.children.cycles-pp.folios_put_refs
      0.94            +1.0        1.94        perf-profile.children.cycles-pp.__tlb_batch_free_encoded_pages
      0.94            +1.0        1.94        perf-profile.children.cycles-pp.free_pages_and_swap_cache
      1.02            +1.1        2.12        perf-profile.children.cycles-pp.tlb_finish_mmu
      1.11            +1.2        2.28        perf-profile.children.cycles-pp.vms_clear_ptes
      1.12            +1.2        2.31        perf-profile.children.cycles-pp.vms_complete_munmap_vmas
      1.15            +1.2        2.35        perf-profile.children.cycles-pp.do_vmi_munmap
      1.15            +1.2        2.35        perf-profile.children.cycles-pp.do_vmi_align_munmap
      1.19            +1.2        2.40        perf-profile.children.cycles-pp.__x64_sys_munmap
      1.19            +1.2        2.40        perf-profile.children.cycles-pp.__vm_munmap
      1.20            +1.2        2.40        perf-profile.children.cycles-pp.__munmap
      1.31            +1.3        2.58        perf-profile.children.cycles-pp.do_syscall_64
      1.31            +1.3        2.58        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     17.74           +10.3       28.04        perf-profile.children.cycles-pp.pv_native_safe_halt
     17.74           +10.3       28.04        perf-profile.children.cycles-pp.acpi_safe_halt
     17.74           +10.3       28.05        perf-profile.children.cycles-pp.acpi_idle_do_entry
     17.75           +10.3       28.06        perf-profile.children.cycles-pp.acpi_idle_enter
     17.79           +10.3       28.13        perf-profile.children.cycles-pp.cpuidle_enter_state
     17.80           +10.3       28.15        perf-profile.children.cycles-pp.cpuidle_enter
     18.05           +10.6       28.66        perf-profile.children.cycles-pp.cpuidle_idle_call
     18.02           +10.6       28.65        perf-profile.children.cycles-pp.start_secondary
     18.10           +10.7       28.76        perf-profile.children.cycles-pp.common_startup_64
     18.10           +10.7       28.76        perf-profile.children.cycles-pp.cpu_startup_entry
     18.10           +10.7       28.76        perf-profile.children.cycles-pp.do_idle
      0.27 ±  2%     +11.8       12.06        perf-profile.children.cycles-pp.asm_sysvec_call_function
     18.16           +27.6       45.73        perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      5.48            -5.5        0.00        perf-profile.self.cycles-pp.__cond_resched
     68.70            -3.8       64.86        perf-profile.self.cycles-pp.folio_zero_user
      3.54            -1.8        1.75        perf-profile.self.cycles-pp.testcase
      0.93            -0.1        0.85        perf-profile.self.cycles-pp.prep_new_page
      0.08 ± 13%      -0.1        0.02 ± 99%  perf-profile.self.cycles-pp.update_cfs_group
      0.08            -0.0        0.05 ±  8%  perf-profile.self.cycles-pp.mod_node_page_state
      0.11 ±  3%      -0.0        0.09 ±  4%  perf-profile.self.cycles-pp.native_irq_return_iret
      0.02 ± 99%      +0.0        0.07 ± 13%  perf-profile.self.cycles-pp.arch_scale_freq_tick
      0.06 ± 11%      +0.0        0.10 ± 15%  perf-profile.self.cycles-pp.sched_balance_update_blocked_averages
      0.07 ±  5%      +0.0        0.12 ±  3%  perf-profile.self.cycles-pp.asm_sysvec_apic_timer_interrupt
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.should_flush_tlb
      0.00            +0.1        0.05 ±  7%  perf-profile.self.cycles-pp.__folio_unqueue_deferred_split
      0.00            +0.1        0.05 ±  8%  perf-profile.self.cycles-pp.update_sg_lb_stats
      0.02 ± 99%      +0.1        0.08        perf-profile.self.cycles-pp.free_tail_page_prepare
      0.00            +0.1        0.06        perf-profile.self.cycles-pp.check_cpu_stall
      0.00            +0.1        0.06 ± 11%  perf-profile.self.cycles-pp.menu_select
      0.02 ±141%      +0.1        0.10 ±  3%  perf-profile.self.cycles-pp.smp_call_function_many_cond
      0.05 ±141%      +0.1        0.17 ± 63%  perf-profile.self.cycles-pp.timekeeping_max_deferment
      0.22 ±  8%      +0.2        0.40 ± 12%  perf-profile.self.cycles-pp.ktime_get
      0.78            +0.9        1.64        perf-profile.self.cycles-pp.free_unref_folios
     16.48            +9.3       25.78        perf-profile.self.cycles-pp.pv_native_safe_halt


***************************************************************************************************

=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/thread/100%/debian-13-x86_64-20250902.cgz/lkp-ivb-2ep2/page_fault1/will-it-scale

commit: 
  9890ecab6a ("mm: folio_zero_user: clear pages sequentially")
  94962b2628 ("mm: folio_zero_user: clear page ranges")

9890ecab6ad9c0d3 94962b2628e6af2c48be6ebdf9f 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
  13476248            +7.7%   14514344        will-it-scale.48.threads
     33.34           +22.8%      40.94        will-it-scale.48.threads_idle
    280755            +7.7%     302381        will-it-scale.per_thread_ops
  13476248            +7.7%   14514344        will-it-scale.workload
    150643           -20.5%     119694        meminfo.Shmem
      7092           +16.0%       8225        uptime.idle
 4.869e+09           +22.5%  5.967e+09        cpuidle..time
   5918255           +98.3%   11734444        cpuidle..usage
     33.98           +22.4%      41.59        vmstat.cpu.id
     31.48           -11.3%      27.91        vmstat.procs.r
     65679            -4.4%      62801        vmstat.system.in
   8297721            +7.7%    8938848        numa-numastat.node0.local_node
   8328248            +7.6%    8957443        numa-numastat.node0.numa_hit
   8311573            +6.9%    8888746        numa-numastat.node1.local_node
   8330871            +7.1%    8919765        numa-numastat.node1.numa_hit
   8328220            +7.6%    8957249        numa-vmstat.node0.numa_hit
   8297693            +7.7%    8938640        numa-vmstat.node0.numa_local
   8331000            +7.1%    8919461        numa-vmstat.node1.numa_hit
   8311702            +6.9%    8888442        numa-vmstat.node1.numa_local
      7083 ±  2%     +34.2%       9504 ±  5%  perf-c2c.DRAM.local
    670.17 ±  9%     +60.2%       1073 ±  8%  perf-c2c.DRAM.remote
    104.17 ± 10%     +62.9%     169.67 ±  6%  perf-c2c.HIT.remote
    683.83 ±  3%     +45.7%     996.50 ±  5%  perf-c2c.HITM.local
    328.00 ±  6%     +65.5%     543.00 ± 11%  perf-c2c.HITM.remote
     33.69            +7.6       41.27        mpstat.cpu.all.idle%
      2.02            +0.2        2.20        mpstat.cpu.all.irq%
      0.11 ±  2%      +0.0        0.12 ±  3%  mpstat.cpu.all.soft%
     59.81            -7.4       52.43        mpstat.cpu.all.sys%
      4.37            -0.4        3.97        mpstat.cpu.all.usr%
     69.61           -10.6%      62.22        mpstat.max_utilization_pct
      1993           -11.2%       1770        turbostat.Avg_MHz
     66.61            -7.4       59.17        turbostat.Busy%
      0.08 ± 24%      +0.1        0.16 ±  6%  turbostat.C1%
      0.33           +11.4       11.70        turbostat.C1E%
     33.05            -3.9       29.12        turbostat.C6%
     23.22           +74.0%      40.42        turbostat.CPU%c1
     10.16           -95.9%       0.42 ± 24%  turbostat.CPU%c6
  23619013            -4.8%   22494143        turbostat.IRQ
    786722 ±  2%     -38.7%     482404        turbostat.NMI
     48.75            +1.2%      49.32        turbostat.RAMWatt
   1085441            +1.4%    1100796        proc-vmstat.nr_active_anon
   1042491            +2.1%    1064848        proc-vmstat.nr_anon_pages
      4927            +3.2%       5087        proc-vmstat.nr_page_table_pages
     37642           -20.5%      29926        proc-vmstat.nr_shmem
   1085440            +1.4%    1100791        proc-vmstat.nr_zone_active_anon
  16658966            +7.3%   17878556        proc-vmstat.numa_hit
  16609098            +7.3%   17828945        proc-vmstat.numa_local
 4.064e+09            +7.7%  4.378e+09        proc-vmstat.pgalloc_normal
   8715038            +6.9%    9316930        proc-vmstat.pgfault
 4.064e+09            +7.7%  4.378e+09        proc-vmstat.pgfree
   7921062            +7.7%    8533004        proc-vmstat.thp_fault_alloc
    197820           -25.8%     146873        sched_debug.cfs_rq:/.avg_vruntime.avg
    158878           -33.4%     105864 ±  3%  sched_debug.cfs_rq:/.avg_vruntime.min
      0.65 ±  9%     -22.2%       0.51 ±  7%  sched_debug.cfs_rq:/.h_nr_queued.avg
      0.65 ±  9%     -22.3%       0.51 ±  7%  sched_debug.cfs_rq:/.h_nr_runnable.avg
      0.64 ±  9%     -21.7%       0.50 ±  6%  sched_debug.cfs_rq:/.nr_queued.avg
    639.38 ±  3%     -12.0%     562.89        sched_debug.cfs_rq:/.runnable_avg.avg
      1149 ±  4%     -14.0%     988.67 ±  7%  sched_debug.cfs_rq:/.runnable_avg.max
    636.30 ±  3%     -11.7%     561.67        sched_debug.cfs_rq:/.util_avg.avg
    385.99 ±  9%     -30.5%     268.29 ±  7%  sched_debug.cfs_rq:/.util_est.avg
    197375           -25.7%     146615        sched_debug.cfs_rq:/.zero_vruntime.avg
    158380           -33.3%     105649 ±  3%  sched_debug.cfs_rq:/.zero_vruntime.min
      4057 ±  8%     -20.8%       3212 ±  6%  sched_debug.cpu.curr->pid.avg
      2909 ±  5%      +7.7%       3132        sched_debug.cpu.curr->pid.stddev
      0.65 ±  9%     -21.8%       0.51 ±  7%  sched_debug.cpu.nr_running.avg
      0.30 ± 19%     +44.5%       0.43 ±  8%  sched_debug.cpu.nr_uninterruptible.avg
    569.07           +40.3%     798.46        perf-stat.i.MPKI
 3.989e+08           -19.7%  3.203e+08        perf-stat.i.branch-instructions
      1.97            -0.4        1.56        perf-stat.i.branch-miss-rate%
  10443546           -22.9%    8048304        perf-stat.i.branch-misses
 8.814e+08            +7.5%  9.479e+08        perf-stat.i.cache-misses
 9.207e+08            +7.2%  9.871e+08        perf-stat.i.cache-references
     60.91           +15.1%      70.11        perf-stat.i.cpi
 9.433e+10           -11.7%  8.333e+10        perf-stat.i.cpu-cycles
    212.68            -8.8%     193.98        perf-stat.i.cpu-migrations
    107.56           -17.6%      88.59        perf-stat.i.cycles-between-cache-misses
 1.888e+09           -18.5%  1.538e+09        perf-stat.i.instructions
      0.02            -7.0%       0.02        perf-stat.i.ipc
     28563            +6.9%      30537        perf-stat.i.minor-faults
     28564            +6.9%      30538        perf-stat.i.page-faults
    466.73           +32.0%     616.13        perf-stat.overall.MPKI
      2.62            -0.1        2.51        perf-stat.overall.branch-miss-rate%
     49.95            +8.4%      54.16        perf-stat.overall.cpi
    107.02           -17.9%      87.91        perf-stat.overall.cycles-between-cache-misses
      0.02            -7.8%       0.02        perf-stat.overall.ipc
     42233           -24.3%      31976        perf-stat.overall.path-length
 3.977e+08           -19.7%  3.193e+08        perf-stat.ps.branch-instructions
  10402795           -23.1%    7998989        perf-stat.ps.branch-misses
 8.784e+08            +7.6%  9.448e+08        perf-stat.ps.cache-misses
 9.176e+08            +7.2%  9.838e+08        perf-stat.ps.cache-references
 9.401e+10           -11.7%  8.305e+10        perf-stat.ps.cpu-cycles
    211.95            -8.8%     193.24        perf-stat.ps.cpu-migrations
 1.882e+09           -18.5%  1.533e+09        perf-stat.ps.instructions
     28465            +6.9%      30433        perf-stat.ps.minor-faults
     28466            +6.9%      30434        perf-stat.ps.page-faults
 5.692e+11           -18.5%  4.641e+11        perf-stat.total.instructions
     79.26           -44.2       35.05        perf-profile.calltrace.cycles-pp.folio_zero_user.vma_alloc_anon_folio_pmd.__do_huge_pmd_anonymous_page.__handle_mm_fault.handle_mm_fault
     88.02           -10.0       78.04        perf-profile.calltrace.cycles-pp.testcase
     81.83            -7.7       74.11        perf-profile.calltrace.cycles-pp.asm_exc_page_fault.testcase
     81.76            -7.7       74.06        perf-profile.calltrace.cycles-pp.exc_page_fault.asm_exc_page_fault.testcase
     81.75            -7.7       74.06        perf-profile.calltrace.cycles-pp.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.testcase
     81.60            -7.7       73.95        perf-profile.calltrace.cycles-pp.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.testcase
     81.53            -7.6       73.89        perf-profile.calltrace.cycles-pp.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
     81.50            -7.6       73.87        perf-profile.calltrace.cycles-pp.__do_huge_pmd_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault
     80.88            -7.5       73.38        perf-profile.calltrace.cycles-pp.vma_alloc_anon_folio_pmd.__do_huge_pmd_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      1.32            -0.2        1.10        perf-profile.calltrace.cycles-pp.vma_alloc_folio_noprof.vma_alloc_anon_folio_pmd.__do_huge_pmd_anonymous_page.__handle_mm_fault.handle_mm_fault
      1.30            -0.2        1.08        perf-profile.calltrace.cycles-pp.alloc_pages_mpol.vma_alloc_folio_noprof.vma_alloc_anon_folio_pmd.__do_huge_pmd_anonymous_page.__handle_mm_fault
      1.29            -0.2        1.08        perf-profile.calltrace.cycles-pp.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof.vma_alloc_anon_folio_pmd.__do_huge_pmd_anonymous_page
      1.28            -0.2        1.07        perf-profile.calltrace.cycles-pp.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof.vma_alloc_anon_folio_pmd
      1.20            -0.2        1.01        perf-profile.calltrace.cycles-pp.prep_new_page.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof
      1.19            +1.4        2.54        perf-profile.calltrace.cycles-pp.free_unref_folios.folios_put_refs.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_finish_mmu
      1.26            +1.4        2.69        perf-profile.calltrace.cycles-pp.folios_put_refs.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_finish_mmu.vms_clear_ptes
      1.27            +1.4        2.70        perf-profile.calltrace.cycles-pp.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_finish_mmu.vms_clear_ptes.vms_complete_munmap_vmas
      1.27            +1.4        2.71        perf-profile.calltrace.cycles-pp.__tlb_batch_free_encoded_pages.tlb_finish_mmu.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap
      1.30            +1.5        2.80        perf-profile.calltrace.cycles-pp.tlb_finish_mmu.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      1.38            +1.6        2.95        perf-profile.calltrace.cycles-pp.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      1.39            +1.6        2.98        perf-profile.calltrace.cycles-pp.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      1.41            +1.6        3.03        perf-profile.calltrace.cycles-pp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64
      1.42            +1.6        3.04        perf-profile.calltrace.cycles-pp.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.45            +1.6        3.08        perf-profile.calltrace.cycles-pp.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
      1.45            +1.6        3.08        perf-profile.calltrace.cycles-pp.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
      1.45            +1.6        3.09        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
      1.45            +1.6        3.09        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__munmap
      1.46            +1.6        3.10        perf-profile.calltrace.cycles-pp.__munmap
      9.68            +7.7       17.36        perf-profile.calltrace.cycles-pp.intel_idle.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle
      9.89            +7.8       17.68        perf-profile.calltrace.cycles-pp.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle.cpu_startup_entry
      9.90            +7.8       17.70        perf-profile.calltrace.cycles-pp.cpuidle_enter.cpuidle_idle_call.do_idle.cpu_startup_entry.start_secondary
      9.96            +7.9       17.81        perf-profile.calltrace.cycles-pp.cpuidle_idle_call.do_idle.cpu_startup_entry.start_secondary.common_startup_64
     10.02            +7.9       17.90        perf-profile.calltrace.cycles-pp.cpu_startup_entry.start_secondary.common_startup_64
     10.02            +7.9       17.90        perf-profile.calltrace.cycles-pp.do_idle.cpu_startup_entry.start_secondary.common_startup_64
     10.02            +7.9       17.90        perf-profile.calltrace.cycles-pp.start_secondary.common_startup_64
     10.19            +8.1       18.32        perf-profile.calltrace.cycles-pp.common_startup_64
      0.00           +17.5       17.49        perf-profile.calltrace.cycles-pp.asm_sysvec_call_function.folio_zero_user.vma_alloc_anon_folio_pmd.__do_huge_pmd_anonymous_page.__handle_mm_fault
      0.74 ±  2%     +56.7       57.45        perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.folio_zero_user.vma_alloc_anon_folio_pmd.__do_huge_pmd_anonymous_page.__handle_mm_fault
     88.07           -10.0       78.08        perf-profile.children.cycles-pp.testcase
     81.86            -7.7       74.15        perf-profile.children.cycles-pp.asm_exc_page_fault
     81.78            -7.7       74.10        perf-profile.children.cycles-pp.exc_page_fault
     81.77            -7.7       74.09        perf-profile.children.cycles-pp.do_user_addr_fault
     81.62            -7.6       73.99        perf-profile.children.cycles-pp.handle_mm_fault
     81.50            -7.6       73.87        perf-profile.children.cycles-pp.__do_huge_pmd_anonymous_page
     81.55            -7.6       73.93        perf-profile.children.cycles-pp.__handle_mm_fault
     80.88            -7.5       73.38        perf-profile.children.cycles-pp.vma_alloc_anon_folio_pmd
     79.48            -7.3       72.21        perf-profile.children.cycles-pp.folio_zero_user
      1.61            -0.3        1.33        perf-profile.children.cycles-pp.alloc_pages_mpol
      1.60            -0.3        1.32        perf-profile.children.cycles-pp.__alloc_frozen_pages_noprof
      1.48            -0.2        1.23        perf-profile.children.cycles-pp.get_page_from_freelist
      1.32            -0.2        1.10        perf-profile.children.cycles-pp.vma_alloc_folio_noprof
      1.33            -0.2        1.12        perf-profile.children.cycles-pp.prep_new_page
      0.33 ±  2%      -0.1        0.26        perf-profile.children.cycles-pp.pte_alloc_one
      0.32 ±  2%      -0.1        0.25 ±  2%  perf-profile.children.cycles-pp.alloc_pages_noprof
      0.72 ±  2%      -0.1        0.66 ±  2%  perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
      0.71 ±  2%      -0.1        0.64        perf-profile.children.cycles-pp.hrtimer_interrupt
      0.46 ±  3%      -0.1        0.40 ±  4%  perf-profile.children.cycles-pp.tick_nohz_handler
      0.60 ±  2%      -0.1        0.54 ±  2%  perf-profile.children.cycles-pp.__hrtimer_run_queues
      0.42 ±  3%      -0.1        0.36 ±  3%  perf-profile.children.cycles-pp.update_process_times
      0.86            -0.1        0.80        perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      0.22 ±  2%      -0.0        0.18 ±  2%  perf-profile.children.cycles-pp.map_anon_folio_pmd_pf
      0.18 ±  3%      -0.0        0.14 ±  3%  perf-profile.children.cycles-pp.task_tick_fair
      0.16 ±  4%      -0.0        0.12 ±  4%  perf-profile.children.cycles-pp.map_anon_folio_pmd_nopf
      0.28 ±  2%      -0.0        0.25        perf-profile.children.cycles-pp.sched_tick
      0.07 ±  6%      -0.0        0.04 ± 44%  perf-profile.children.cycles-pp.__irqentry_text_end
      0.09 ±  8%      -0.0        0.06 ±  6%  perf-profile.children.cycles-pp.__memcg_kmem_charge_page
      0.12 ±  4%      -0.0        0.10 ±  4%  perf-profile.children.cycles-pp.rmqueue
      0.07 ±  5%      -0.0        0.04 ± 45%  perf-profile.children.cycles-pp.folio_add_new_anon_rmap
      0.13 ±  2%      -0.0        0.10 ±  6%  perf-profile.children.cycles-pp.kernel_init_pages
      0.09 ±  5%      -0.0        0.07        perf-profile.children.cycles-pp.__rmqueue_pcplist
      0.10            -0.0        0.08 ±  4%  perf-profile.children.cycles-pp.__perf_sw_event
      0.10            -0.0        0.08 ±  5%  perf-profile.children.cycles-pp.___perf_sw_event
      0.08 ±  5%      -0.0        0.07        perf-profile.children.cycles-pp.__folio_batch_add_and_move
      0.05            +0.0        0.06        perf-profile.children.cycles-pp._raw_spin_lock_irqsave
      0.06 ±  7%      +0.0        0.08 ±  7%  perf-profile.children.cycles-pp.__flush_smp_call_function_queue
      0.09 ±  5%      +0.0        0.11 ±  6%  perf-profile.children.cycles-pp.__schedule
      0.06 ±  6%      +0.0        0.09 ±  5%  perf-profile.children.cycles-pp.free_tail_page_prepare
      0.00            +0.1        0.05        perf-profile.children.cycles-pp.__folio_unqueue_deferred_split
      0.00            +0.1        0.05 ±  7%  perf-profile.children.cycles-pp.__x64_sys_execve
      0.00            +0.1        0.05 ±  7%  perf-profile.children.cycles-pp.do_execveat_common
      0.00            +0.1        0.05 ±  7%  perf-profile.children.cycles-pp.execve
      0.00            +0.1        0.05 ±  7%  perf-profile.children.cycles-pp.free_frozen_page_commit
      0.00            +0.1        0.06 ±  9%  perf-profile.children.cycles-pp.__free_frozen_pages
      0.03 ± 70%      +0.1        0.09 ±  4%  perf-profile.children.cycles-pp.menu_select
      0.00            +0.1        0.06        perf-profile.children.cycles-pp.__page_cache_release
      0.00            +0.1        0.06        perf-profile.children.cycles-pp.lru_gen_del_folio
      0.00            +0.1        0.06 ± 11%  perf-profile.children.cycles-pp.down_write_killable
      0.00            +0.1        0.07 ± 11%  perf-profile.children.cycles-pp.rwsem_down_write_slowpath
      0.06 ±  9%      +0.1        0.13 ±  5%  perf-profile.children.cycles-pp.do_mmap
      0.02 ± 99%      +0.1        0.09 ±  5%  perf-profile.children.cycles-pp.__mmap_region
      0.06 ±  7%      +0.1        0.14 ±  7%  perf-profile.children.cycles-pp.zap_huge_pmd
      0.07 ±  5%      +0.1        0.15 ±  8%  perf-profile.children.cycles-pp.zap_pmd_range
      0.07 ±  5%      +0.1        0.15 ±  4%  perf-profile.children.cycles-pp.vm_mmap_pgoff
      0.07            +0.1        0.15 ±  2%  perf-profile.children.cycles-pp.__mmap
      0.07 ±  5%      +0.1        0.15 ±  9%  perf-profile.children.cycles-pp.unmap_page_range
      0.00            +0.1        0.08 ±  4%  perf-profile.children.cycles-pp.on_each_cpu_cond_mask
      0.00            +0.1        0.08 ±  4%  perf-profile.children.cycles-pp.smp_call_function_many_cond
      0.07            +0.1        0.15 ±  8%  perf-profile.children.cycles-pp.unmap_vmas
      0.00            +0.1        0.08 ±  5%  perf-profile.children.cycles-pp.flush_tlb_mm_range
      0.18 ± 17%      +0.2        0.42 ± 11%  perf-profile.children.cycles-pp.rest_init
      0.18 ± 17%      +0.2        0.42 ± 11%  perf-profile.children.cycles-pp.start_kernel
      0.18 ± 17%      +0.2        0.42 ± 11%  perf-profile.children.cycles-pp.x86_64_start_kernel
      0.18 ± 17%      +0.2        0.42 ± 11%  perf-profile.children.cycles-pp.x86_64_start_reservations
      1.20            +1.4        2.56        perf-profile.children.cycles-pp.free_unref_folios
      1.27            +1.4        2.70        perf-profile.children.cycles-pp.folios_put_refs
      1.27            +1.4        2.71        perf-profile.children.cycles-pp.free_pages_and_swap_cache
      1.27            +1.4        2.71        perf-profile.children.cycles-pp.__tlb_batch_free_encoded_pages
      1.30            +1.5        2.80        perf-profile.children.cycles-pp.tlb_finish_mmu
      1.38            +1.6        2.95        perf-profile.children.cycles-pp.vms_clear_ptes
      1.39            +1.6        2.98        perf-profile.children.cycles-pp.vms_complete_munmap_vmas
      1.42            +1.6        3.04        perf-profile.children.cycles-pp.do_vmi_munmap
      1.42            +1.6        3.04        perf-profile.children.cycles-pp.do_vmi_align_munmap
      1.45            +1.6        3.09        perf-profile.children.cycles-pp.__x64_sys_munmap
      1.45            +1.6        3.09        perf-profile.children.cycles-pp.__vm_munmap
      1.46            +1.6        3.10        perf-profile.children.cycles-pp.__munmap
      1.66            +1.8        3.48        perf-profile.children.cycles-pp.do_syscall_64
      1.66            +1.8        3.48        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     10.02            +7.9       17.90        perf-profile.children.cycles-pp.start_secondary
      9.85            +7.9       17.77        perf-profile.children.cycles-pp.intel_idle
     10.08            +8.0       18.11        perf-profile.children.cycles-pp.cpuidle_enter
     10.07            +8.0       18.11        perf-profile.children.cycles-pp.cpuidle_enter_state
     10.13            +8.1       18.23        perf-profile.children.cycles-pp.cpuidle_idle_call
     10.19            +8.1       18.32        perf-profile.children.cycles-pp.common_startup_64
     10.19            +8.1       18.32        perf-profile.children.cycles-pp.cpu_startup_entry
     10.19            +8.1       18.32        perf-profile.children.cycles-pp.do_idle
      0.12            +8.7        8.80        perf-profile.children.cycles-pp.asm_sysvec_call_function
      1.04           +28.3       29.34        perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
     77.74            -6.2       71.54        perf-profile.self.cycles-pp.folio_zero_user
      6.11            -2.2        3.90        perf-profile.self.cycles-pp.testcase
      1.19            -0.2        1.01        perf-profile.self.cycles-pp.prep_new_page
      0.07 ±  6%      -0.0        0.04 ± 44%  perf-profile.self.cycles-pp.__irqentry_text_end
      0.13 ±  2%      -0.0        0.10 ±  5%  perf-profile.self.cycles-pp.kernel_init_pages
      0.08            -0.0        0.06 ±  7%  perf-profile.self.cycles-pp.___perf_sw_event
      0.07 ±  7%      -0.0        0.05        perf-profile.self.cycles-pp.__rmqueue_pcplist
      0.04 ± 44%      +0.0        0.08 ±  4%  perf-profile.self.cycles-pp.free_tail_page_prepare
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.smp_call_function_many_cond
      0.00            +0.1        0.07 ±  8%  perf-profile.self.cycles-pp.asm_sysvec_apic_timer_interrupt
      1.13            +1.3        2.43        perf-profile.self.cycles-pp.free_unref_folios
      9.85            +7.9       17.77        perf-profile.self.cycles-pp.intel_idle



***************************************************************************************************

=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/lkp-ivb-2ep2/page_fault1/will-it-scale

commit: 
  9890ecab6a ("mm: folio_zero_user: clear pages sequentially")
  94962b2628 ("mm: folio_zero_user: clear page ranges")

9890ecab6ad9c0d3 94962b2628e6af2c48be6ebdf9f 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
  13326899            +4.8%   13968231        will-it-scale.48.processes
    277643            +4.8%     291004        will-it-scale.per_process_ops
  13326899            +4.8%   13968231        will-it-scale.workload
    188907           -20.7%     149831        meminfo.Shmem
   2571826 ±  4%      -9.8%    2320837 ±  6%  numa-meminfo.node1.AnonPages.max
     55533            -5.8%      52308        vmstat.system.in
      0.05            +0.0        0.06        mpstat.cpu.all.soft%
      7.97            +1.2        9.13        mpstat.cpu.all.usr%
      0.50 ±  9%     +66.5%       0.83 ± 11%  perf-sched.sch_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      0.50 ±  9%     +66.5%       0.83 ± 11%  perf-sched.total_sch_delay.average.ms
  16857808            -5.8%   15880074        turbostat.IRQ
   1047246 ±  3%     -43.1%     596149 ±  2%  turbostat.NMI
      7632 ±  4%     +53.0%      11676        perf-c2c.DRAM.local
    336.17 ± 15%    +172.4%     915.83 ± 12%  perf-c2c.DRAM.remote
     55.17 ± 28%    +109.1%     115.33 ±  9%  perf-c2c.HIT.remote
    548.33 ±  7%    +119.2%       1201 ±  4%  perf-c2c.HITM.local
    158.83 ±  6%    +183.7%     450.67 ±  3%  perf-c2c.HITM.remote
    980465            -1.1%     969931        proc-vmstat.nr_active_anon
    966522            -1.0%     956717        proc-vmstat.nr_file_pages
     47257           -20.8%      37450        proc-vmstat.nr_shmem
    980461            -1.1%     969926        proc-vmstat.nr_zone_active_anon
  16479858            +4.5%   17219093        proc-vmstat.numa_hit
  16430403            +4.5%   17165377        proc-vmstat.numa_local
  4.02e+09            +4.8%  4.213e+09        proc-vmstat.pgalloc_normal
   8603457            +4.3%    8969427        proc-vmstat.pgfault
  4.02e+09            +4.8%  4.213e+09        proc-vmstat.pgfree
   7834289            +4.8%    8210993        proc-vmstat.thp_fault_alloc
      6455 ±141%    +750.4%      54895 ± 70%  sched_debug.cfs_rq:/.left_deadline.avg
    309861 ±141%    +750.4%    2634973 ± 70%  sched_debug.cfs_rq:/.left_deadline.max
     44256 ±141%    +750.4%     376343 ± 70%  sched_debug.cfs_rq:/.left_deadline.stddev
      6455 ±141%    +750.4%      54895 ± 70%  sched_debug.cfs_rq:/.left_vruntime.avg
    309855 ±141%    +750.4%    2634967 ± 70%  sched_debug.cfs_rq:/.left_vruntime.max
     44255 ±141%    +750.4%     376342 ± 70%  sched_debug.cfs_rq:/.left_vruntime.stddev
    219.53          +873.1%       2136 ±185%  sched_debug.cfs_rq:/.load_avg.max
     60.71 ± 10%    +444.0%     330.25 ±167%  sched_debug.cfs_rq:/.load_avg.stddev
      6455 ±141%    +750.4%      54895 ± 70%  sched_debug.cfs_rq:/.right_vruntime.avg
    309855 ±141%    +750.4%    2634967 ± 70%  sched_debug.cfs_rq:/.right_vruntime.max
     44255 ±141%    +750.4%     376342 ± 70%  sched_debug.cfs_rq:/.right_vruntime.stddev
      8.51 ± 12%     +67.6%      14.25 ± 14%  sched_debug.cpu.clock.stddev
    148335 ± 37%     -79.4%      30520 ±  8%  sched_debug.cpu.nr_switches.max
     22646 ± 34%     -73.7%       5946 ±  8%  sched_debug.cpu.nr_switches.stddev
    586.24           +45.2%     851.22        perf-stat.i.MPKI
 3.795e+08           -23.6%  2.901e+08        perf-stat.i.branch-instructions
      1.19            +0.4        1.55        perf-stat.i.branch-miss-rate%
 8.737e+08            +4.8%  9.154e+08        perf-stat.i.cache-misses
 9.041e+08            +5.1%  9.506e+08        perf-stat.i.cache-references
     94.80           +38.7%     131.45        perf-stat.i.cpi
     83.43 ±  2%     -10.6%      74.57        perf-stat.i.cpu-migrations
    162.14            -4.5%     154.78        perf-stat.i.cycles-between-cache-misses
 1.806e+09           -22.0%  1.409e+09        perf-stat.i.instructions
      0.01           -20.5%       0.01        perf-stat.i.ipc
      0.10 ± 36%     -59.3%       0.04 ± 38%  perf-stat.i.major-faults
     28196            +4.2%      29394        perf-stat.i.minor-faults
     28196            +4.2%      29394        perf-stat.i.page-faults
    483.60           +34.6%     650.80        perf-stat.overall.MPKI
      1.92            +0.6        2.51        perf-stat.overall.branch-miss-rate%
     78.25           +28.5%     100.54        perf-stat.overall.cpi
    161.80            -4.5%     154.48        perf-stat.overall.cycles-between-cache-misses
      0.01           -22.2%       0.01        perf-stat.overall.ipc
     40822           -25.7%      30316        perf-stat.overall.path-length
 3.784e+08           -23.7%  2.886e+08        perf-stat.ps.branch-instructions
 8.706e+08            +4.8%  9.121e+08        perf-stat.ps.cache-misses
 9.009e+08            +5.1%  9.472e+08        perf-stat.ps.cache-references
     83.08 ±  2%     -10.6%      74.23        perf-stat.ps.cpu-migrations
   1.8e+09           -22.2%  1.402e+09        perf-stat.ps.instructions
      0.10 ± 36%     -59.5%       0.04 ± 39%  perf-stat.ps.major-faults
     28093            +4.2%      29283        perf-stat.ps.minor-faults
     28093            +4.2%      29283        perf-stat.ps.page-faults
  5.44e+11           -22.2%  4.235e+11        perf-stat.total.instructions
     86.63           -58.6       28.03        perf-profile.calltrace.cycles-pp.folio_zero_user.vma_alloc_anon_folio_pmd.__do_huge_pmd_anonymous_page.__handle_mm_fault.handle_mm_fault
     97.92            -3.3       94.64        perf-profile.calltrace.cycles-pp.testcase
     88.40            -2.3       86.08        perf-profile.calltrace.cycles-pp.vma_alloc_anon_folio_pmd.__do_huge_pmd_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
     89.13            -2.3       86.86        perf-profile.calltrace.cycles-pp.__do_huge_pmd_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault
     89.28            -2.3       87.02        perf-profile.calltrace.cycles-pp.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.testcase
     89.18            -2.3       86.92        perf-profile.calltrace.cycles-pp.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
     89.49            -2.3       87.24        perf-profile.calltrace.cycles-pp.exc_page_fault.asm_exc_page_fault.testcase
     89.48            -2.2       87.23        perf-profile.calltrace.cycles-pp.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.testcase
     89.56            -2.2       87.32        perf-profile.calltrace.cycles-pp.asm_exc_page_fault.testcase
      1.32            +0.3        1.60        perf-profile.calltrace.cycles-pp.prep_new_page.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof
      1.43            +0.3        1.72        perf-profile.calltrace.cycles-pp.alloc_pages_mpol.vma_alloc_folio_noprof.vma_alloc_anon_folio_pmd.__do_huge_pmd_anonymous_page.__handle_mm_fault
      1.43            +0.3        1.71        perf-profile.calltrace.cycles-pp.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof.vma_alloc_anon_folio_pmd.__do_huge_pmd_anonymous_page
      1.41            +0.3        1.70        perf-profile.calltrace.cycles-pp.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof.vma_alloc_anon_folio_pmd
      1.45            +0.3        1.74        perf-profile.calltrace.cycles-pp.vma_alloc_folio_noprof.vma_alloc_anon_folio_pmd.__do_huge_pmd_anonymous_page.__handle_mm_fault.handle_mm_fault
      1.45            +2.4        3.84        perf-profile.calltrace.cycles-pp.free_unref_folios.folios_put_refs.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_finish_mmu
      1.54            +2.6        4.16        perf-profile.calltrace.cycles-pp.folios_put_refs.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_finish_mmu.vms_clear_ptes
      1.54            +2.6        4.19        perf-profile.calltrace.cycles-pp.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_finish_mmu.vms_clear_ptes.vms_complete_munmap_vmas
      1.54            +2.7        4.20        perf-profile.calltrace.cycles-pp.__tlb_batch_free_encoded_pages.tlb_finish_mmu.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap
      1.55            +2.7        4.22        perf-profile.calltrace.cycles-pp.tlb_finish_mmu.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      1.64            +2.9        4.52        perf-profile.calltrace.cycles-pp.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      1.67            +2.9        4.56        perf-profile.calltrace.cycles-pp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64
      1.65            +2.9        4.54        perf-profile.calltrace.cycles-pp.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      1.67            +2.9        4.56        perf-profile.calltrace.cycles-pp.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.67            +2.9        4.56        perf-profile.calltrace.cycles-pp.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
      1.67            +2.9        4.56        perf-profile.calltrace.cycles-pp.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
      1.67            +2.9        4.57        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
      1.67            +2.9        4.57        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__munmap
      1.68            +2.9        4.58        perf-profile.calltrace.cycles-pp.__munmap
      0.84 ±  5%    +111.8      112.61        perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.folio_zero_user.vma_alloc_anon_folio_pmd.__do_huge_pmd_anonymous_page.__handle_mm_fault
     97.97            -3.3       94.68        perf-profile.children.cycles-pp.testcase
     86.84            -2.6       84.21        perf-profile.children.cycles-pp.folio_zero_user
     88.40            -2.3       86.08        perf-profile.children.cycles-pp.vma_alloc_anon_folio_pmd
     89.13            -2.3       86.86        perf-profile.children.cycles-pp.__do_huge_pmd_anonymous_page
     89.21            -2.2       86.98        perf-profile.children.cycles-pp.__handle_mm_fault
     89.31            -2.2       87.09        perf-profile.children.cycles-pp.handle_mm_fault
     89.52            -2.2       87.30        perf-profile.children.cycles-pp.exc_page_fault
     89.51            -2.2       87.30        perf-profile.children.cycles-pp.do_user_addr_fault
     89.60            -2.2       87.40        perf-profile.children.cycles-pp.asm_exc_page_fault
      0.75 ±  5%      -0.4        0.39 ±  4%  perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      0.66 ±  5%      -0.3        0.34 ±  3%  perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
      0.66 ±  5%      -0.3        0.34 ±  3%  perf-profile.children.cycles-pp.hrtimer_interrupt
      0.56 ±  6%      -0.3        0.28 ±  4%  perf-profile.children.cycles-pp.__hrtimer_run_queues
      0.44 ±  6%      -0.2        0.22 ±  5%  perf-profile.children.cycles-pp.tick_nohz_handler
      0.41 ±  7%      -0.2        0.20 ±  4%  perf-profile.children.cycles-pp.update_process_times
      0.27 ±  6%      -0.1        0.14 ±  3%  perf-profile.children.cycles-pp.sched_tick
      0.18 ±  7%      -0.1        0.09 ±  7%  perf-profile.children.cycles-pp.task_tick_fair
      0.10 ±  3%      -0.0        0.08 ±  5%  perf-profile.children.cycles-pp.__irqentry_text_end
      0.10 ±  4%      +0.0        0.12 ±  4%  perf-profile.children.cycles-pp.lock_vma_under_rcu
      0.12 ±  3%      +0.0        0.14 ±  5%  perf-profile.children.cycles-pp.___perf_sw_event
      0.07 ±  8%      +0.0        0.09 ±  5%  perf-profile.children.cycles-pp.try_charge_memcg
      0.04 ± 44%      +0.0        0.06        perf-profile.children.cycles-pp.mod_memcg_lruvec_state
      0.05 ±  8%      +0.0        0.07 ±  5%  perf-profile.children.cycles-pp.mod_node_page_state
      0.37            +0.0        0.39 ±  2%  perf-profile.children.cycles-pp.pte_alloc_one
      0.06 ±  9%      +0.0        0.08 ±  4%  perf-profile.children.cycles-pp._raw_spin_lock_irqsave
      0.36            +0.0        0.38        perf-profile.children.cycles-pp.alloc_pages_noprof
      0.05            +0.0        0.08 ±  7%  perf-profile.children.cycles-pp.free_tail_page_prepare
      0.06 ±  9%      +0.0        0.08 ±  5%  perf-profile.children.cycles-pp.__mem_cgroup_charge
      0.00            +0.1        0.06 ±  9%  perf-profile.children.cycles-pp.x64_sys_call
      0.00            +0.1        0.06 ±  8%  perf-profile.children.cycles-pp.load_elf_binary
      0.00            +0.1        0.06 ±  6%  perf-profile.children.cycles-pp.exec_binprm
      0.01 ±223%      +0.1        0.07 ±  7%  perf-profile.children.cycles-pp.charge_memcg
      0.00            +0.1        0.06 ± 15%  perf-profile.children.cycles-pp.asm_sysvec_call_function
      0.00            +0.1        0.06 ±  6%  perf-profile.children.cycles-pp.bprm_execve
      0.00            +0.1        0.06 ±  6%  perf-profile.children.cycles-pp.folio_remove_rmap_pmd
      0.00            +0.1        0.06 ±  7%  perf-profile.children.cycles-pp.asm_sysvec_reschedule_ipi
      0.00            +0.1        0.07 ±  5%  perf-profile.children.cycles-pp.free_pgtables
      0.05            +0.1        0.14 ±  3%  perf-profile.children.cycles-pp.__mmap
      0.00            +0.1        0.09 ±  7%  perf-profile.children.cycles-pp.__folio_unqueue_deferred_split
      0.00            +0.1        0.09 ±  4%  perf-profile.children.cycles-pp.execve
      0.00            +0.1        0.09 ±  5%  perf-profile.children.cycles-pp.__x64_sys_execve
      0.00            +0.1        0.09 ±  5%  perf-profile.children.cycles-pp.do_execveat_common
      0.06            +0.1        0.16 ±  3%  perf-profile.children.cycles-pp.vm_mmap_pgoff
      0.05 ±  8%      +0.1        0.15 ±  5%  perf-profile.children.cycles-pp.do_mmap
      0.00            +0.1        0.11 ±  4%  perf-profile.children.cycles-pp.__mmap_region
      0.00            +0.1        0.13 ±  2%  perf-profile.children.cycles-pp.lru_gen_del_folio
      0.00            +0.1        0.14 ±  2%  perf-profile.children.cycles-pp.__page_cache_release
      0.08            +0.1        0.22 ±  3%  perf-profile.children.cycles-pp.zap_huge_pmd
      0.09 ±  4%      +0.2        0.25 ±  3%  perf-profile.children.cycles-pp.unmap_page_range
      0.08 ±  5%      +0.2        0.24 ±  3%  perf-profile.children.cycles-pp.zap_pmd_range
      0.09 ±  6%      +0.2        0.25        perf-profile.children.cycles-pp.unmap_vmas
      1.47            +0.3        1.75        perf-profile.children.cycles-pp.prep_new_page
      1.64            +0.3        1.93        perf-profile.children.cycles-pp.get_page_from_freelist
      1.46            +0.3        1.75        perf-profile.children.cycles-pp.vma_alloc_folio_noprof
      1.79            +0.3        2.10        perf-profile.children.cycles-pp.alloc_pages_mpol
      1.78            +0.3        2.09        perf-profile.children.cycles-pp.__alloc_frozen_pages_noprof
      1.46            +2.4        3.86        perf-profile.children.cycles-pp.free_unref_folios
      1.54            +2.6        4.17        perf-profile.children.cycles-pp.folios_put_refs
      1.54            +2.7        4.20        perf-profile.children.cycles-pp.free_pages_and_swap_cache
      1.55            +2.7        4.20        perf-profile.children.cycles-pp.__tlb_batch_free_encoded_pages
      1.55            +2.7        4.23        perf-profile.children.cycles-pp.tlb_finish_mmu
      1.64            +2.9        4.52        perf-profile.children.cycles-pp.vms_clear_ptes
      1.65            +2.9        4.54        perf-profile.children.cycles-pp.vms_complete_munmap_vmas
      1.67            +2.9        4.56        perf-profile.children.cycles-pp.do_vmi_align_munmap
      1.67            +2.9        4.57        perf-profile.children.cycles-pp.__x64_sys_munmap
      1.67            +2.9        4.57        perf-profile.children.cycles-pp.__vm_munmap
      1.67            +2.9        4.56        perf-profile.children.cycles-pp.do_vmi_munmap
      1.68            +2.9        4.58        perf-profile.children.cycles-pp.__munmap
      1.93            +3.2        5.12        perf-profile.children.cycles-pp.do_syscall_64
      1.93            +3.2        5.12        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.96 ±  5%     +55.6       56.60        perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
     84.87            -1.2       83.67        perf-profile.self.cycles-pp.folio_zero_user
      8.24            -1.0        7.28        perf-profile.self.cycles-pp.testcase
      0.10 ±  3%      -0.0        0.08 ±  5%  perf-profile.self.cycles-pp.__irqentry_text_end
      0.08 ±  5%      +0.0        0.10 ±  4%  perf-profile.self.cycles-pp.mas_walk
      0.05 ±  8%      +0.0        0.07 ±  5%  perf-profile.self.cycles-pp.mod_node_page_state
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.__alloc_frozen_pages_noprof
      0.00            +0.1        0.06 ±  6%  perf-profile.self.cycles-pp.free_tail_page_prepare
      0.00            +0.1        0.06 ±  7%  perf-profile.self.cycles-pp.zap_huge_pmd
      0.00            +0.1        0.08 ±  8%  perf-profile.self.cycles-pp.__folio_unqueue_deferred_split
      0.00            +0.1        0.10 ±  3%  perf-profile.self.cycles-pp.lru_gen_del_folio
      0.00            +0.2        0.17 ±  2%  perf-profile.self.cycles-pp.asm_sysvec_apic_timer_interrupt
      1.32            +0.3        1.60        perf-profile.self.cycles-pp.prep_new_page
      1.40            +2.3        3.75        perf-profile.self.cycles-pp.free_unref_folios





Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


