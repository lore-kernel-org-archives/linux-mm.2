Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3692CF9C72
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 17:13:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31DC56B000D; Thu, 20 Nov 2025 12:13:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CCE66B0010; Thu, 20 Nov 2025 12:13:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 147E66B0099; Thu, 20 Nov 2025 12:13:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 007876B000D
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 12:13:17 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 81A7412F279
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 17:13:15 +0000 (UTC)
X-FDA: 84131631150.04.2595A82
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012036.outbound.protection.outlook.com [40.107.209.36])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6F9391C0002
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 17:13:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=WhWJewt9;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ankita@nvidia.com designates 40.107.209.36 as permitted sender) smtp.mailfrom=ankita@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763658792; a=rsa-sha256;
	cv=pass;
	b=4NozDa+Z4ESbmw080a744dHGzSg34SWizLS0pL7edo6GWfz/JLcKP1OBjuh0XUU8f7xNwy
	DIHJMOGjH/CZvPTM9ChBRPq8jYiX5GE+B/sCjF7zldgx/uBr/LjmBdPNH7E/X40zhxvxlx
	9mUqK0abnYMnEVCchKBrhh1iCg/Fddk=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=WhWJewt9;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ankita@nvidia.com designates 40.107.209.36 as permitted sender) smtp.mailfrom=ankita@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763658792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ueReyUd/clxUCPeYxsUeGzslCCZDKn3U4DhzTjw3Bhg=;
	b=lqY9Q0HekSyDeTIuDLGFkRzIxrX4E6aVFeeDYpXYQUUDkLPdudIM2PnG86wH8shCmvcBRh
	YSrePgxPqUrosVavFJBmim40xQQwJocefvHmL/KUSnoWrdbGx+o5CNeJqZQRFq4Ln48ICa
	E2o2+mhLuZyHmnwycmqnaPN4xrhHNY0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qwlguWTWs4dEHYvVYsWQKogU3JCr5usPFPPpuryhTSEDQ0Pw7KtHEDw5B+YnoG/OC6nDsMSQQ1lN/uheFLWFVkLPpeEuafTc/U3iEDiotQhHytlYWu+Xh3MtVdkkO5J/PdTCIqwIdd8gGnqtvD3H58ZPsy+ai11hbmoHIidZg8kIOWshP2Lh8ldfO6LtToGfqm3MqM7UTlpF7Hp0/r2eVkPGjlsbrJDnXN5RmbPUoxzONT/ufb3kdihzU8EP7jmQ2jTZTiNDdBFOr/rF5K+g7Tbd4nZrtRS1egSJDCG2RUBFrYnB/xYJuwH+KbE8eUbsXtuPDoACaopJ73MUUMB7Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ueReyUd/clxUCPeYxsUeGzslCCZDKn3U4DhzTjw3Bhg=;
 b=V1u1ilDcDnXkLTkgm4JAKscpE3bqk4co9r+RfRpNGuibk2Nx4mNgF0oqSr9D2UeOKcnPVCWaIVDRL0wOeQMzY3Ka5yf1FwYHl276H96E9sxMnOE7wySiciUdj6MDzyHrV0mm71AsWhtpLbMMQAkntliC9ITMC2Fbr2+XN16gmlV9hTbCIIVuNJGTWhVi7+3K9lgvpBCcO1+F9fjyzKIcfW2l/q6hFudAgdu9NbEiKLi3rejoQZ2ijfvI8Uu9M1jxdnCENa7hixJmQbA0lBHb/ldhaPDtido2Gi1RrdLE//3IZBMug3M7ZR/EBT3unNiqqq3/9O0GTJQLAxkbd+zgZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ueReyUd/clxUCPeYxsUeGzslCCZDKn3U4DhzTjw3Bhg=;
 b=WhWJewt9cWxCfLOafluiv3qZUVgaWFyqM7PtNGk/8if9DYzvXHrTF7J0pFvtWoIvvhtsaS/DfH7A2sCJh2L/wcSfz/WElMSo8C6xiUxcMH34l+Sdi6Yitc3ECfPsiFKkfkb9ZdGFvGkqcuRL9HqRv+BIXlUpCmCG571hxdTy5kiZH83fGfGZPU7rAYYiTEq1FpJnUEL7S7dEkE7KsZm204Qge9zU9fOQMGQR3/5YikwDqOqRUlfp5JetEMXqYIwaJfRrlJhRK3Luy96cPAMgFJbLHTPXptOhBY0paKPoekqzz8q+V9JLWoVOyRyMkfsOCJY8UDojonnXWgm1bwmLyA==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by DS5PPFBABE93B01.namprd12.prod.outlook.com (2603:10b6:f:fc00::65f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 17:13:05 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::928c:89d8:e8d6:72dd]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::928c:89d8:e8d6:72dd%6]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 17:13:05 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>, Robin
 Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>, Will Deacon
	<will@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>, Jason
 Gunthorpe <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>, Jonathan
 Corbet <corbet@lwn.net>, Sumit Semwal <sumit.semwal@linaro.org>,
	=?iso-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>, Kees Cook
	<kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, Yishai
 Hadas <yishaih@nvidia.com>, Shameer Kolothum <skolothumtho@nvidia.com>, Kevin
 Tian <kevin.tian@intel.com>, Alex Williamson <alex@shazbot.org>
CC: Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-media@vger.kernel.org"
	<linux-media@vger.kernel.org>, "dri-devel@lists.freedesktop.org"
	<dri-devel@lists.freedesktop.org>, "linaro-mm-sig@lists.linaro.org"
	<linaro-mm-sig@lists.linaro.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-hardening@vger.kernel.org"
	<linux-hardening@vger.kernel.org>, Alex Mastro <amastro@fb.com>, Nicolin Chen
	<nicolinc@nvidia.com>
Subject: Re: [PATCH v9 11/11] vfio/nvgrace: Support get_dmabuf_phys
Thread-Topic: [PATCH v9 11/11] vfio/nvgrace: Support get_dmabuf_phys
Thread-Index: AQHcWgAs+ixHoXcoSUC3aT08aR+6zbT7uJlO
Date: Thu, 20 Nov 2025 17:13:05 +0000
Message-ID:
 <SA1PR12MB719993F747B09154A3DDA788B0D4A@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20251120-dmabuf-vfio-v9-0-d7f71607f371@nvidia.com>
 <20251120-dmabuf-vfio-v9-11-d7f71607f371@nvidia.com>
In-Reply-To: <20251120-dmabuf-vfio-v9-11-d7f71607f371@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|DS5PPFBABE93B01:EE_
x-ms-office365-filtering-correlation-id: f48bc750-6a3a-4945-18f5-08de285811b4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|366016|376014|38070700021|921020;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?cjIaEK/tVvTVZXpwpovCni3KHELH8hQF3811i+HBgT7osmi1W5M7lYrRym?=
 =?iso-8859-1?Q?m7kklAcGtKJlS/XSRYwQnfWUdg8IROUd2fsS7DyscezZKa1dlQ+GggrLGo?=
 =?iso-8859-1?Q?knTmzwY9VuDNB6pXzcqcof1IQ4Ic/OajQSk8EShMConIUjyESs01do6+Zq?=
 =?iso-8859-1?Q?OBqw3TIqS1hacvYIq1c4RueuRDj+aeD21L5AzMmgYlYHsJidlRnhim4U+Q?=
 =?iso-8859-1?Q?dtluwfg0sMsh4Lu5h4J/OIZcklrhB6Ht8Zv2R69H/2m92qVdWCVUpr32Es?=
 =?iso-8859-1?Q?j8kjZR5/HuIFsYnPqiFj8UlHAGBOXWwIZJ+iU1bpWcyA+C8NE09fLs5GZP?=
 =?iso-8859-1?Q?IhsF67h5KvUqUsV22+uE+NHPyi/AtVvhYLd5mLv849Y5b1r4XTuQ17dHDj?=
 =?iso-8859-1?Q?VQ4oRTJeASJE8439WE369lXBUpGozemRcKMiAnADtjm4IAmXXhrRUHUbcg?=
 =?iso-8859-1?Q?vxiaXCpptaVEAn0RTWsJc/vhJ4/aX9Fmx7ex8ER0Vp3+eVTYSBKG+OqCY3?=
 =?iso-8859-1?Q?aLsC5ia9uM9uM0OyTHBsTcSWoDrCpAYzJr90Vd1wMfcrj4e+ntFOAYlEhS?=
 =?iso-8859-1?Q?C1HIsOJTpaMJGhOWzAs9F5Q14eAYkeXZYXLelmoLAGYKHISf4asxAkEOqI?=
 =?iso-8859-1?Q?InGF6m5DJSR2KxVW0TTtHnZgJNyVFI/GJyWH0RPiF0LF5087rltlFGLbXv?=
 =?iso-8859-1?Q?TH0mN+bGJG62S0zgnK6b5KP5wqz7gOtFUK81pcpwyGSALWCjLFYcUYix3l?=
 =?iso-8859-1?Q?MTusY8VTfYHwDUJGUq25dvrBpNIrHHIoUMGB9ouW/ab3+wbq2yu0j2aGlB?=
 =?iso-8859-1?Q?Oa1iE4I18PwROF2P332rknUaGRkcs6QTMV5wJZFEv/3mLj6N+PhI/E9ZbZ?=
 =?iso-8859-1?Q?WCTtu5KCdAr1jQ1HOmvjAMolcX5Cl/6dIMsy8iVVd+VXR5oAM6MFhcP837?=
 =?iso-8859-1?Q?Y/kUN11ncVWlejYV5T4DuV2HO1ggh02fG/djCa/NP6ok6rJBshD2EbUrom?=
 =?iso-8859-1?Q?vgP/HcjyZ0vjxUURINun/gBfIw3IBHl/JXzTU6XrJMIYJGFwU2Vl38xTC5?=
 =?iso-8859-1?Q?dRPzzc8SX47p/9Gzzw6q+j+n/x4ofqFZpD0W2vwd6o9GX2YTWl6h4Kbr7b?=
 =?iso-8859-1?Q?hH6WGHVFaqAjWGORYBrZOyWE64UdYsay6obB+j899aR4+vGhPYjhVmYTVY?=
 =?iso-8859-1?Q?EI2YDVMIs/FB26As2Bfi37vGX2G519OzoxVkXy13J0E7mJI/6iawxOcpRp?=
 =?iso-8859-1?Q?WCZPRA86N0RG2PnLDkb5uRsmULCUbmVny/vcPNwgRblBvnD5JrVxYeEBi1?=
 =?iso-8859-1?Q?6ayPCJBB9V+2FGamG7/2VY7qpwE7T3OrUfdiNXbJnYSdImXojdVfKABqn8?=
 =?iso-8859-1?Q?tzIBLEIytFkjhwp67CqoUukqGX9FezOMJvWyGu4xRbnYKGDfprYeJRKhHu?=
 =?iso-8859-1?Q?LtDHDJdiGcNFlTWbxmTG/aPugQr2zfF5tPJqD3CaY2PXVMYABOvouLqTde?=
 =?iso-8859-1?Q?b9691L6jsriPcben23rJRs327Kn1c71O9RqlAKLNAjqfRSzMusVJwS5gpr?=
 =?iso-8859-1?Q?72UZ9TMPTWkbOkVNyBZ/TeCuAn82a43OvEKWbKiaSdKBYVpC4g=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?bM3zs/GB5WQ5w6MS44YWuO1rWrybf4KPCnHuPwF93xwb2YCUtZQQFW/+ey?=
 =?iso-8859-1?Q?BPM13CQ+CiG018QzMGnt7PGhhOa7vclGHI5tWP26ePUCUXTKLEoaENjrVw?=
 =?iso-8859-1?Q?/MbH2UqKO3i1Hvw9Apwfx271cn1DaVa/PzmblfmB5CxqkzE3uw8B8PJJZs?=
 =?iso-8859-1?Q?p+uDSmsT07Y9kiARfPqiqSmFhtGQlpaojdY4QWhswt+JALrf3txGRAcWJq?=
 =?iso-8859-1?Q?MGFqLSzoqOHFXJ3rYIoCVh5fpJIIVWf6DuA0sP34KheZUmk7NrUYCBwqR/?=
 =?iso-8859-1?Q?AWlXmqyi6YOeQ4ruHnmhQkm3vsIlk2s2QsJDhpnWHharQHCtEi/frrgTMH?=
 =?iso-8859-1?Q?nUP+aiFDQ0Sf01IYl9W+KT8KEjNyI5P+aJytDHEQZYRAWtJWlyTCjEPD3v?=
 =?iso-8859-1?Q?aNSI7CopcUSo7XpRSx0504UrhK+qida9tl+k7DlDiTkfIzbr36sefSg5el?=
 =?iso-8859-1?Q?m8YBUJ/u9dazsnEIsa5z8A+Qh/3aAhsehxQSDUt2TTr14MqNaw2mW9AnCR?=
 =?iso-8859-1?Q?O2ejTEBn9yeg8P+nYc8Oo07hRjHloI9jrT1hhY7QbblHx1iczmgOEAAXpm?=
 =?iso-8859-1?Q?UOYFv3oBE3uozP6JW09P+hTWOICr+VrAbIHtOYsMundVMR83jWR1KsM9YK?=
 =?iso-8859-1?Q?JLogRaekCJil6c5kcwrrINr3cxBocM/O879aHc6Jf+kDzdB+sQKhDzPcVs?=
 =?iso-8859-1?Q?D9pPZTsPAwatUFQelJXyK9w+mLeRA9mX1UqxBQUYukXeD43FcxMEbJykMT?=
 =?iso-8859-1?Q?THRAxveYQfp+tQGgFZqNZHIkQpE2N/+MVWrWqTS24P4Y2AfElTiFO8+S6s?=
 =?iso-8859-1?Q?0UfAnFIBgUgp1sDSlOSw8E/GXz0IIJPCzCKogpMFDdnWBZ1P8g6DpVU0ni?=
 =?iso-8859-1?Q?UOFC1Glv1zv+7ikaaafioQ4NvGR1bxy19nQ8Oh8MbPtVijOLRcXiT+IB6w?=
 =?iso-8859-1?Q?Jy5x2scVvEGBKBLYSsty4nfsNVJoCuxMkHrWG2biWDlbJaAPtnNUn/n7Lh?=
 =?iso-8859-1?Q?tY/suT7DvXsOmjOXURW2aCFeYmpZIqOSsKJkX0ttPW9/t3HrUNDrtACo2u?=
 =?iso-8859-1?Q?UaRQn/43/5DX0xJFViZOp4nTluyOHYy2Voi2pjnWpTTIaUMw6yyRh/Uh3X?=
 =?iso-8859-1?Q?bfkfVrrvBYZ3tVdNsSMVOQBj53Q8/68gr3DbKH1ZsTUO20pEY76MnNcWhS?=
 =?iso-8859-1?Q?h19wh0VesbYFy124LFo07jpyAJHQfEp0ORPmM+nYxHvYtg9j2fvPPatTY2?=
 =?iso-8859-1?Q?NgrKgf5e+8kh1Hns/oD/imXX24wNhkn4WpEHJKXkKsr+xg7MEBqtX7q1sU?=
 =?iso-8859-1?Q?+JwskaiS8Uow0gUKzdT20FvRfqgI0cpWdNA2Yz4iJDtRy64McqNKBcq++I?=
 =?iso-8859-1?Q?23U9hDSJIGE9cNYLIJ+Vt+eEXqud4AUdX6hAjaJjWixjQ2m0mHWHfpBxeP?=
 =?iso-8859-1?Q?smAAHcKYosb9QFTsyDSFmqmowjG5eC29ZQxgHA9B9n4h64bL8RSJKVvJhU?=
 =?iso-8859-1?Q?1Xdk/Q0xx9yYacdet7578SmBNT6iIcR6mKp4swzZXR2IJhgCnlh6F7IK+K?=
 =?iso-8859-1?Q?8Uuc5TB9FjdZSdGM6Npw7IDfzqjfm/Mok39u9G2f6krWbWjyGuR5PGqqPC?=
 =?iso-8859-1?Q?edu99kGoC9Cag=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB7199.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f48bc750-6a3a-4945-18f5-08de285811b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2025 17:13:05.2368
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g21sYZC9KoTgR7vpp+ZqzPYvTNoKNmeZbGKHTWNmdiPEYzcsidZk1+O10LVnwkfN0dTZr4V46jQKjj5xIEES6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPFBABE93B01
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6F9391C0002
X-Stat-Signature: 7beqbmgyi1bdcity5jcjwz1htgyx5333
X-HE-Tag: 1763658792-704536
X-HE-Meta: U2FsdGVkX1+lNka0d1e0KRspHlmGHNord3c2HU7hzniv/WmdltKYhPcvH8HpPYc/ocQuBnzb4EcrpX96U+pLNxB4AW8TIatLiWMu1y2VQzk+J6yCCyCstewE9J0OtK8CU40SY3ooZiaxig1E1CiL5injzOs+eVjzX5hNAUR4+81MrjYlcC8srmsegouMghGV/WHUfs7KRc8CCX9flAH6wZDwwOxhee1a5tOkvtVnlNTDu1uO0GnzjNArEvexvBDP901ZZnCMsP2LLh3yFcEtlkiUZ8lN6PPQkOtG/M/PA6z0t+pBaZ4WkQ0IQuucCE1CKQ88qQPiveDgggkH+nlKsNk9S/qgcmiFw4WhLugT9UY8H3gfChm2TBiOWbKETN1jl3iYnhMn+4wVMQv+Igy5W490DIFAEnymECgWWXugejSTRbGY9D5b5XDgCADlgU3nKsjFEQGIAOLwHTog/eIv2sTeI7mvLsqqZSHOY5c09z/+0vnfiGj1sxdMK3KJa8JtvJuI77ci+0dexUEgyuddHeYLtutvuJ+R2GHEX+geC+HH6pxoaTl39zTyMDYhmK3LUyfAguQ2qrAY/n6+RRYsr1FT75tVKBVREyBojyL3DthZ3mRZtnuwPoJsKl2K9cPva8RTohOBsH/8LyQeahJIR6Lv4RCx/kodjK6A/M0LUJVtjSZQbMpjDl+aVIIvx0XcMgwkQsZ3ZfAhx3pfE3ZR4p17SXw/UwzchVug96NO2zEiMrJx+4kpUF9irTBGzGMw+P005oCwq4d6VggVPdy5TlNwk1a1ehvQ+Svor3Zh8bKPPmlieEVrQV1buIgLNX0G6yK+gZr97l9Ld0KJ7QqLZ6JMYCPpf5IsLXq+1mxNt2w8fln6mPkgowOIYuua2fOKNr3ZLW0i31KWTIEQW05XDrC3LZUYPXbFzjohKTNd7YmTeVduu/tEFXbsQFlHjwgD5wKRPrRq6wDZrgJW5La
 Q+gYBFrj
 KaA39WWm0wuKlBL54Zet8OqxCT3eN4k6umzJd5fK9PKByqHIIYqqKeIV3K8C8+wCZEbHHdEOgBSzbjN0+4zxLSkmOyI6GYJ+ho1WL5/c+4N7sWwssKQueimwbQgD/xdhmTsxw+8rThZqgOsxoAlkxvNC90kBQ6G19G8rHkTc+otO8I/qCFAifzVZNd+r/fChLjN1qjf1zwdpHqtzME3fRGLszPMtC/csmJTkOGzEYc5DkEHoOH3VIPS/Jwuq6QUUUVm0CLVCXB6ymDtVhbznA3n0jS4+xm9eKO+RvEbg784Ej1kHYPw+hy5MasW3thIMOv5WKurYQJ8r/6+s2986My2he3vlICV3ESHBZNDjvRvmOd3fpRBxJDoxEAV+wyNWU/nVoFG+Me+4I349hxIfvbE/j9L7SQSEe5WobM7oI4rq7QEfbtturmQ6hAnzvMg/M9iZYLKT5IjqSVi40Q0UcK5QXY2HirHgiHoMJ7CjDMI0oDsDidIwYGJF29BZrEXHKA8RWR7R1K3MQ2OoHmGz03C15o+AedV0sHofFulYVVSnPGEVuiRwo7fQsGNukiOy0NMMi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> =0A=
> The "CXL" ranges that are remapped into BAR 2 and BAR 4 areas are not PCI=
=0A=
> MMIO, they actually run over the CXL-like coherent interconnect and for=
=0A=
> the purposes of DMA behave identically to DRAM. We don't try to model thi=
s=0A=
> distinction between true PCI BAR memory that takes a real PCI path and th=
e=0A=
> "CXL" memory that takes a different path in the p2p framework for now.=0A=
> =0A=
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>=0A=
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>=0A=
> Tested-by: Alex Mastro <amastro@fb.com>=0A=
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>=0A=
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>=0A=
> ---=0A=
=0A=
Reviewed-by: Ankit Agrawal <ankita@nvidia.com>=

