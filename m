Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B87BCCAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 15:54:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F81F8E0012; Tue,  9 Sep 2025 11:54:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 182218E0003; Tue,  9 Sep 2025 11:54:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3D678E0012; Tue,  9 Sep 2025 11:54:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DCFC08E0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 11:54:15 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 98C32160500
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:54:15 +0000 (UTC)
X-FDA: 83870158470.17.3D44CBA
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2085.outbound.protection.outlook.com [40.107.95.85])
	by imf13.hostedemail.com (Postfix) with ESMTP id E31C020009
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:54:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EJr8viPW;
	spf=pass (imf13.hostedemail.com: domain of jgg@nvidia.com designates 40.107.95.85 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757433253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C1YjSLY6o5MP5/Zj21h6yLIShZmsmDX1LxEStPSdbaI=;
	b=EiZPE7YNzYq1oHXjjTjbJzWV9ImF+eTMW1oUf1PASI0nnqJQhXbVrCf10IV9KSTZoI6VSE
	4f0BD6Z1ziNBq/HJKZo+2OP2Ibk8MWbkV3JIo+k/9xqjtDeKlxyudBqfejyh4c1947XolH
	NPWKY8F1ITESYC+UXI3Fs+ljGIXe38g=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EJr8viPW;
	spf=pass (imf13.hostedemail.com: domain of jgg@nvidia.com designates 40.107.95.85 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757433253; a=rsa-sha256;
	cv=pass;
	b=bW9zglq9cSx7FJUXSE4JIIn55ygCpyJM+OV3en2c6tbRORA2qh0oU3V9Zemrnkwcqw+rbb
	vEvg1/jsuqAaRlarIQgeMk60/5QtIRXWerBCyQK0qRiYtYsys5Pr+Es0qjCqCKT0CBvdir
	KVHVmAJ6/f2RbEiTv8tWZ4jBy0Log4Q=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GFo4Zm8DFBK40L+8u96LMufXDL8hTXUtKIUE1kF18DVxXOGM6V8yY0twSi2e/RCgIiKG6BaA/xBsCEt2G9xJYTdtxcpDs4y5zULE9Tu1lCNSe4Oy3AipAfPr5wKR8c4k1tMG1prLqAbcMJTz2C4AOo7+lQhY5OavLDsJbikYy5cOcwFVJ2w7QKLxXmu3NfjdBmLOiI1QxThEDoDoogvpEqJ2YE8kQP9QEY5DE+hPsiLMgny+PxT3A8ZIaQmgNxZY8OHnR3glaIt9O4lnZI+CdaDg3+cYrhbZZFOJ9kPhNuxxGzyQa62QQCW6QEZVrv0+rmbJe9eE27ySuPMinaAdTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C1YjSLY6o5MP5/Zj21h6yLIShZmsmDX1LxEStPSdbaI=;
 b=kku8Lkp058IYuHcYzTWk4rUmsEK4FsRs9XXkiaNiOzwczmCXBqD6UPDlHgYLKb6efOMP2RV38qHI4kwX/HviQCpCtSHJRgeCZ8bMAQ/H2FvS+/L46DE5Tlbjg4Qk/acdM7sYq9AUaOCsdxigSvuje8aLzlh7z8DwLnmUJ8utMz/1mMFdk/bR+UrcNsFLbX9rhnr8LLKgBo8ogJHFA8yU1AzK8pMVL6Bee81XQ/ySkwYKotZfV5DeKBkKCmFSnX0AH1iCAgFZtJWayvhjnruAL5nlpIjItjQpkLt3dxzkDb0wJSb2I6LmTZ7plk8WnBdqorXteBGxXiFq8+ayhQoKRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C1YjSLY6o5MP5/Zj21h6yLIShZmsmDX1LxEStPSdbaI=;
 b=EJr8viPWMYbJkqY/rX829duPjrHSDGS5xhG/LLAnCxcBPfc6NisI0rkMyG9f8k2fPCE7edTliAR1i6pS/DPP04iY0b/TXGfJ/yM1mPOhIN8q3kSisy4DGwrLIEfIVdxmft7MLPvTjvtAx4mLONmyl7DlqpqKrUAD6SiKs6kKCwulPUj+J9lb5N5ia0nrXuQrbclFypIgsfwE9t2AAQtVqAhMKqnRnID0v+KFDkTiLRdZVlxVmEQX+z1pMbm5HcllLOqdtVCyLnTY+Bm5jPoRR9JouOiYsdVUj8gRPGOt4H3XZOU7ZTHzu9bs+geqxCMdYx/Ze46f0SsH44ONegU8oA==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by LV8PR12MB9417.namprd12.prod.outlook.com (2603:10b6:408:204::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 15:54:09 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 15:54:09 +0000
Date: Tue, 9 Sep 2025 12:54:07 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <me@yadavpratyush.com>,
	Pratyush Yadav <pratyush@kernel.org>, jasonmiu@google.com,
	graf@amazon.com, changyuanl@google.com, rppt@kernel.org,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com,
	witu@nvidia.com
Subject: Re: [PATCH v3 29/30] luo: allow preserving memfd
Message-ID: <20250909155407.GO789684@nvidia.com>
References: <mafs0bjo0yffo.fsf@kernel.org>
 <20250828124320.GB7333@nvidia.com>
 <mafs0h5xmw12a.fsf@kernel.org>
 <20250902134846.GN186519@nvidia.com>
 <mafs0v7lzvd7m.fsf@kernel.org>
 <20250903150157.GH470103@nvidia.com>
 <mafs0a53av0hs.fsf@kernel.org>
 <20250904144240.GO470103@nvidia.com>
 <mafs0cy7zllsn.fsf@yadavpratyush.com>
 <CA+CK2bAKL-gyER2abOV-f4M6HOx9=xDE+=jtcDL6YFbQf1-6og@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+CK2bAKL-gyER2abOV-f4M6HOx9=xDE+=jtcDL6YFbQf1-6og@mail.gmail.com>
X-ClientProxiedBy: YT4PR01CA0126.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d5::14) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|LV8PR12MB9417:EE_
X-MS-Office365-Filtering-Correlation-Id: aa873257-f9b1-4375-75bb-08ddefb91cc9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CkbezBpYzYgKp0EzQBqraghY9zN1yFBeGl2UVeHLaHZ4eaB6+9Htm/VhLRJ8?=
 =?us-ascii?Q?rXFPbJ/DcvQltit1sp0ejweJd+WAwKN7budVx93oIWCrb+1DYRT/E5msmCnT?=
 =?us-ascii?Q?gb4vM1w3bgaoNGOvjJZqIzx44uiztPIk7vBHuWs3la33R6AlVIXJG4mWtyf+?=
 =?us-ascii?Q?Oxc+UWwYPOn9qEjnznMpEpviwSP8ZUh8aqKavVCfslLf1Khs/V1oCCvu1ULl?=
 =?us-ascii?Q?Wryf2MIbtsZR5R9GSozR6aSt/bu/TfKaNKBzz3smvwDLvYkwWmhSwwBWS1V0?=
 =?us-ascii?Q?tSEpgpdzmczGWK8k/9MOyvRXu5G5gvXXiKwfBdzdhddtoLReVZBp6Pfef9Gx?=
 =?us-ascii?Q?osMqA94ayJCS0p6MIwCn1tibBi6DzJZgaGBEVkAGzBGMPZJ8TnFt1U7dfkA0?=
 =?us-ascii?Q?aYE4XcplVtvegN+STXq3cMxfftjEx8zFZ08J7pEEPOX1K4/Ga4LWA0VaiTlv?=
 =?us-ascii?Q?TAyW0jrdVdcnhB/R6cPXOC3fS1WvWC53mZNONVOWmJcIfWncDwdEMivFjU3T?=
 =?us-ascii?Q?5yuzLMMcPViXcgTlh1RrQ8bO6UGninPahFRRLqvgzFzXIa22pSFvd1B0Keji?=
 =?us-ascii?Q?NxYdkZp+HA+CkPIHgM3fw3P6t/005jNtcPzPVeootLJYleczs7I6jsuMd6oi?=
 =?us-ascii?Q?Dw6LeVXDmPXtnImpbZm0tbFjPAvSASvAKdKjCesaeLgyjAYENF3GUxauKdCu?=
 =?us-ascii?Q?Q8PNh5lKHDWliUs2fma4W3CIZZLYPf84I6rcY1rGlsqKlPwR/Ph79YD5yA9X?=
 =?us-ascii?Q?ODx9Wp3eBqEkyrMOIHogHpgsx5SGozE/pn1w0+GB3ORGiKTk+TW+Ou7yxlpG?=
 =?us-ascii?Q?d1NGwd6KAEdVDbi1M42ToiayiiQStaWdJjDzvhRlBWoMJVQm8k0bDD89U8Xn?=
 =?us-ascii?Q?+Y9zwvC1AskVazMYiHSmXSs4JK0E9w6/vsmI5cK4U3aJ/DMYMTtzKfXF7cpZ?=
 =?us-ascii?Q?fFGm/qjG5vKXlnd7j0FxNzB9jU0xv8gRYCbFnU+QO4LufYEgOd+AEWzJoQ4p?=
 =?us-ascii?Q?pZjj19BoYPAfay4JbtBGalfPdMjO/exCFxGpGyZL6vZz6kyl7+bjmQQaHk1Y?=
 =?us-ascii?Q?s504DN2NLi1UOIExEOW5n9QDMyAVDwYDw4GKQ0XYbbfbhnMPhJJDnLi5aloK?=
 =?us-ascii?Q?D0Skhvo92XoVZF0A18Plg5/6mxtQZjKX88iGiOffkEpytf/xRLnwvPpnpi6A?=
 =?us-ascii?Q?2BBdpOwYl0Ig6gBYa9+qtf7GBkuz60XbzUcNbTB+tTdKZyeJDLy09a1ba97r?=
 =?us-ascii?Q?0PHmG141SY1t3tqOkjuqDm91R8eK6Ws9LeeJh3upMpB2g+FCWUNQ21bqyFPj?=
 =?us-ascii?Q?5yrJyREEJup/Zt7BeGyCf+LBPy9+0Zx49VZyw8+gWf0+nAoJ9D+0kGpnCgZH?=
 =?us-ascii?Q?Ckq2Ga6AYHDYeuG2fP9nLWEIohn1s2aCWZ+P3CPetF32/cE6lQ+AwKu5fM3z?=
 =?us-ascii?Q?woTUJpq8r3o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9jHwiGeG5rmiBVXOAGFmPo1FjFuNxzN7u1NFCRu4DUdevuN5IlT5/txqsvME?=
 =?us-ascii?Q?vxX/YNnMhiCOZhpVukYVd8fM7tBq6oVPDl6kodbdsUQeIzehJfBgOiNFMatr?=
 =?us-ascii?Q?hGlB3G0CUDHYP6YXAD4ajwb4ADbr4PBtu1QzaXFWmDCHIyT75PbCIBk7jyfl?=
 =?us-ascii?Q?vCVop6PuCb2BTV/KCDKWad0OGuNXVL1sU4QOheL9ZNEacn7m3yZZ8Ig5Ypq7?=
 =?us-ascii?Q?o8q8yfI2YhmE6mdvfaEjRl5EwD0rMjJS/IJnMTK8tiXHi1kNWKXGxqUKyjwf?=
 =?us-ascii?Q?CTHuPDy6B1+OcTbiFRISDCi2fH9j0xceQtfoo3AoEvnYvdVQvSipY7Md3Bx2?=
 =?us-ascii?Q?gsT+gz8xDodBoTkFtoC9Hu7o+A7F1KGHnxOqRGFSsaEpBehoHTFj1wJk/yxG?=
 =?us-ascii?Q?3nbAgIib0OHr6JUYCJ4RcpxbQ6NZwI+MhRWX+mRmHYH41Qhei9uY0GNYEklK?=
 =?us-ascii?Q?Wni1b4eWDHdpvXYxYYSbHtrbeKmljAyiPXgkZPIrfIwSotg5TOgEPCJ4grUV?=
 =?us-ascii?Q?1IBL+vuMAiOcOtURlB+DUsF9YwQTAsz58iu097wjZ/PZ7rSxgijwQ9QrDLF0?=
 =?us-ascii?Q?VRcWROOUX7jYJDs85KXVuCFJePuPpzyZ2jZGruXs070aHWyIJY9FmnYUHHSs?=
 =?us-ascii?Q?dVFEui1+18R1QiYA8H/RT8hOTbMyZIGmQZrDnZLWKhQbKuczUPBZ0Weo0JsA?=
 =?us-ascii?Q?amZrSu9aRFTbQK6OYLTT9gSMuPtbLiYpBGyI/YWsw9Fj9bTqe9NNd+SFOMtZ?=
 =?us-ascii?Q?Mh+huXd2wxs0f9QW0xkctmK/lphRlGeGRxx5cCKfP08On7mlpSKUvbfXhPVY?=
 =?us-ascii?Q?RktNPadz5YmBZHPegrY185Rvqt4O6UMUAEK+7N2EU1jUpUlFRbI52YkOY/Me?=
 =?us-ascii?Q?M/5Q7y7J7ILhpatUd3PPOvyKe9chTe/BaS9PyQWMQYXur85Ua4gnAeNYSgr5?=
 =?us-ascii?Q?GBMgmt0FJ6j172qu1T9gxWbINq8OEibNxnpTS4cLSrZop0pm3VHvQR+6YJ6s?=
 =?us-ascii?Q?on6rj59M/DMqjHLNI0VV+BSrUV8y19yT6bBJ1o7YE7BezMBrqprl3BA9fix2?=
 =?us-ascii?Q?yg785DhI7A0fIL2Apup/GC3JFZxyWu0bnx8Up364feP+z2cRk/KlQo6w2HwC?=
 =?us-ascii?Q?uvjmSquWGDK8K8cuqPibQMXknIjAsQcKGt+pxxLqNx/hlJDJng9YePLZK94G?=
 =?us-ascii?Q?fLBFKks/JEgjG0Kf8T1a52Tkr/G6J+HJwSb3Lv0Xxb/Q9d//L2SBK0V53+b8?=
 =?us-ascii?Q?2VaMyeXaZz5A58ny8+EWXYKpdU4wnKUSRBI5mX3v+8ie/dCMHU4FNrB34in+?=
 =?us-ascii?Q?SXsKqoWXlYoWPEtOAz2LqWCL3h/sQ9VW2+ecxA0B6WmHts0YrWmzqGP3VjIW?=
 =?us-ascii?Q?gg/G+59g4Fo0ps8ujZPU+gZGYyFxGNx2ZrPRfiX8PylEVUBj4E+Ud2i/huJ5?=
 =?us-ascii?Q?ozxdqLpAvtoRicNvZOdn2mIuE8aZFTF3YV7yOeyfXmDW5758X4o3dxCHd4yA?=
 =?us-ascii?Q?sQAXFgsKQ95TrSgLWmwQdBaDXBAbiHWHskY9khIdjMJUVrNo+SOzL4qlWt6E?=
 =?us-ascii?Q?hpenPNblD4icYojzHdw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa873257-f9b1-4375-75bb-08ddefb91cc9
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 15:54:08.8983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kjnua0nDjAXmF/PT2tbBqZcf9YD4SDvbMYj4C2ecMJPmFR3T/GxlC7q3PjPc2hCH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9417
X-Rspamd-Queue-Id: E31C020009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: xky76cgx87ueqdqk8miog4c5115e4gfb
X-HE-Tag: 1757433252-228739
X-HE-Meta: U2FsdGVkX1/AA+Jir1AEDBliGYJJGApdXrF5/Z985JNVosrTpAQcGLCCaodBgIUkyvmz3JDrtou8nZQHyeYqiuTfjztAlkdRBkqXKVNT97GamOHwE+YbTabMfW86C/EIBsx9wiWNIk+NgNx0LyySRvl6GXeBfjZvpJKvS5RWIGe4gpgRAjDn2ZydV7T0XcRQwZcpEYFEHEObMQR0sS2HNL8IC8ciSNCk3ZNQ7ItGkLfWqgHq8fW2wQx79a2VVKXyLFGF5Dgm1dM8/wCImETOVyRbzWox9HQB1bbwY/dytsO5+wnumUVW2pXNaH+mPYcFNZ2J0dHfpSFb05uZXFYohkGxgKBi8iA0lhz9csrOs8lSSqPLo6oTdvNwKmxjdfQUXFhwqeOar1uLYplZrKWtsC0Ou18kAVDsLaO7Oqx0cT9OPHDxLaiHwG25TIgoWxjW9mu5jcmIGe4kkf4/qbY0excCjupeMItuoPo82W5VuHOsqH4iWya0WnLCzypwcMSvMbDwDu2u+FBXmd8p9wX8M5qqiemdCzXTr6LgsSWdT+0R7Lo4zglYZXlMsnSYGLtEK0baipO+ImRiELMGe3xsQpj79OM6PX1sJk13GHA4WpjbveZbOOSwNr86v/sxkKsY0+9c/B45Beh9yPGAUGdK4iZUOGpACAnpUraPp+YLBLZk05MISlaeTt6EAXh3p6pMRkgT/Ts7gnS+MqphHIgwKNdumP0el0QjUfXPBBmbwEoVd/U6Wf5dsbLQ9ZB4B/TjPVqoDJkfNfX4xmU85qCyTg7C2Ar7ScDKzTcyVmMykvn3WFl6ZoYtfsluaOLZ+5mEUGUA4w8mi1jRYDr6l2iUhlJ0BUXTJFgSygtIX1Tc/OeJWTJOpCglR4S3B/2KFOc+5rVsm05aNQugLJLoCGZkOnmPhoRaCGJf6+fzOffI4uWP5EgUgynxQubyoS02QBDQSQ5Xomex9Ws2Z/x6zS9
 y2W5MDqo
 4kZybUMbWeJUG/i4MIYwmfiacwT1KU+GxI2mtXG8jmxKNxrlYdMR4svYfe+IjUwbww+6GWuFA2KqTp4bZ1eIqVpLOU7bne8CIOcHcLMsUH3LlMqKEAJtfCwUxcuxwQv7UTSvY91dLzbRqdFN23bRCNnaf6fRiWKGgTwPalqKWBzxbG9mFIhUlfpwmFKC8939TbXYoJg0/xFyeN7dp3mIIWUs2vGcHUNMghkKeg03vXuyqSyHiCxFrO2sTdEU9yHzyBhu4qLO0EQ9Q3Ob7XNjYecty7ttRXmC95D8Oe41vOkVGgXkIpQAC3I1NPHQPvvRjD+KFCRcUksbTA2WPuF1tKiM/bwxa5ww4gXnPYBRADWV6kYqgIIF0D0kbAShOzG7s7kJZxnCWKQzeFpMy+VPcCJXdTswXIxsEKlVFAgojVktWb7tQsnP3mKYz8CqLg4FyQuJBM4aJtluV8rY2Knpy8poxYz9bKjPfd49ULVftdF/y1OjveJHUQe8vqYp3Hk8e5cdV4gV1EBzbsUFjiFvNq5yVUFufi9rHOV33+x4P6DLE7Bc/VsObixKWTRdrLLXy0pS6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 11:40:18AM -0400, Pasha Tatashin wrote:
> In reality, this is not something that is high priority for cloud
> providers, because these kinds of incompatibilities would be found
> during qualification; the kernel will fail to update by detecting a
> version mismatch during boot instead of during shutdown.

Given I expect CSPs will have to add-in specific version support for
their own special version-pair needs, I think it would be helpful in
the long run to have a tool that reported what versions a kernel build
wrote and parsed. Test-to-learn the same information sounds a bit too
difficult.

Something with ELF is probably how to do that, but I don't imagine a
use in a runtime check consuming this information.

Jason

