Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9525CEDEBFF
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 01:27:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B73206B0088; Tue,  3 Mar 2026 20:27:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B40F76B0089; Tue,  3 Mar 2026 20:27:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D7AB6B008A; Tue,  3 Mar 2026 20:27:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 88FF76B0088
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 20:27:31 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 317631C3BF
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 01:27:31 +0000 (UTC)
X-FDA: 84506643102.21.C8CBB78
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010034.outbound.protection.outlook.com [52.101.85.34])
	by imf29.hostedemail.com (Postfix) with ESMTP id 692F7120003
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 01:27:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=T1x3dr5b;
	spf=pass (imf29.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.85.34 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772587648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=qRSvKdolX3cJvMiUv+2Pa5U4bClslgETVtpoYDq3wrk=;
	b=S5HS1M8z2yylSwWHSgch19Bm7wAHlNqP5kUxTbNj40RjP7XGqqQvbXfPvoLAV5XA1JfW7l
	p0qsPZsiqHB2ytV7bBzsh02icgvaysjeYPskkgjx+tE8Q4iMncb5mVtQxi1UKdVxxFx/Oc
	Rl+jBWhdcUOnbdyBsE7MuxK7CqGsvW0=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=T1x3dr5b;
	spf=pass (imf29.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.85.34 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772587648; a=rsa-sha256;
	cv=pass;
	b=IS037p/8qZUdpus69fX9VF5FejagTSBhUvnkKhH3RFFx5xktUXiFcPqwyVcriPb61aZWmH
	eBCwvTqj5fH43Evo1CSUNxYZ1nroz/ZIeVSpdJnKLU3aD1kc6SHx88oqZkdf61iTsRO7wB
	2r96lBJhJRCZypjRU1A38KERy5Ifp20=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rm/VnHnpDPQIQYcS+jZghbeqSPlJONh/rihh8kOsTQWeaBwcMzwMS6LqH824SpR6XQmLXCKB6IJ5fAW5CucBjmY1Q/T6mPOLIuSIlhiUtCYHdnmdu8ZsCncnXuqkuiCzACJRfGGIHrU/z2tUx1TQ3gA+6GzB007lzRcNyeKrhy7gjSxHdET7tQM0oitkY9X0irmdTAuUbWgTBql53P92zRBFsRJwOcf792R7lKiN2z2YWOgT9+GuSZnKxVW5ionNW28amrx2Jie6dIhY+V8CcfrgUXM2hBlJi2JbLedarCNbHobtoWNQLmFSiaWNlZtItvHDf4fXu9uWU2ijzhsMsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qRSvKdolX3cJvMiUv+2Pa5U4bClslgETVtpoYDq3wrk=;
 b=rA9wVEHd1De4y7fGlzc10SS9PTIqUmoAQ0UqdOKk02GVwAgy5I7aeA9crrkpiozGuAPreaeqdfUKvWc71Lm4z1eRYIFbFeaaK7S8nAvMJyRpvFDGWA+k+LsfJJJ54GMTrtfSfD5vb1QkFKktBJuyYrSnvpQIQ2lMNsEZ5tilKkZhRSedVcz2+pvLuxCbccj89m16Ki+XF8GAU9BgxegM2ciy8a5VuNUeVGaaBk7jEko+EOUZZhN8uQfqi8feTxs6o+0yO68KNlVQFFU52xX8WbfATPMSWMUOQ98oTxY5o5P3vOQu4ll98eFErPd2onGevRjA7C4PUh5x7OnPw2BK4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qRSvKdolX3cJvMiUv+2Pa5U4bClslgETVtpoYDq3wrk=;
 b=T1x3dr5bl7RHDFLPNxCv5Er6PT7PKmd1nW7DArldd5hr+qqrMi9gybc9TRxgccBUO0PKGieAeUnN6vVeFYc+s0iFUqYO94F68sabpuZfom4W+MZFjvbhRnFojnOPBA3jQOmQ0l2OKh/QRWrRdC2UB+Xw/56QDaC4E3opyqU2BuAX7wxs186698bPb3d4IUveRSNLjajFHV0EO+aScaF3sJw+JMsNfYPEIcwmJwRMuirU+cjCuycd6YZFRFHCpi4xReJFBz7yWpPQTZ7OIbPyTuGnkt72/u/tCv9uc2qGttEDMBEsblz7KWSKPSr3E8k5PY/yRF/r2sDuGv37uZpuNA==
Received: from PH0PR12MB8800.namprd12.prod.outlook.com (2603:10b6:510:26f::12)
 by IA1PR12MB6651.namprd12.prod.outlook.com (2603:10b6:208:3a0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Wed, 4 Mar
 2026 01:27:21 +0000
Received: from PH0PR12MB8800.namprd12.prod.outlook.com
 ([fe80::f79d:ddc5:2ad7:762d]) by PH0PR12MB8800.namprd12.prod.outlook.com
 ([fe80::f79d:ddc5:2ad7:762d%4]) with mapi id 15.20.9654.022; Wed, 4 Mar 2026
 01:27:20 +0000
From: Yury Norov <ynorov@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Duyck <alexanderduyck@fb.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Anna Schumaker <anna@kernel.org>,
	Anton Yakovlev <anton.yakovlev@opensynergy.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Aswin Karuvally <aswin@linux.ibm.com>,
	Borislav Petkov <bp@alien8.de>,
	Carlos Maiolino <cem@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chao Yu <chao@kernel.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Christian Brauner <brauner@kernel.org>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Airlie <airlied@gmail.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Dongsheng Yang <dongsheng.yang@linux.dev>,
	Eric Dumazet <edumazet@google.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ingo Molnar <mingo@redhat.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Jens Axboe <axboe@kernel.dk>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Linus Walleij <linusw@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mark Brown <broonie@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Namhyung Kim <namhyung@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Paul Walmsley <pjw@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Simona Vetter <simona@ffwll.ch>,
	Takashi Iwai <tiwai@suse.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Trond Myklebust <trondmy@kernel.org>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Will Deacon <will@kernel.org>,
	Yury Norov <yury.norov@gmail.com>,
	Zheng Gu <cengku@gmail.com>
Cc: Yury Norov <ynorov@nvidia.com>,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-block@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	dm-devel@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-spi@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org,
	v9fs@lists.linux.dev,
	virtualization@lists.linux.dev,
	linux-sound@vger.kernel.org
Subject: [PATCH 0/8] mm: globalize rest_of_page() macro
Date: Tue,  3 Mar 2026 20:27:08 -0500
Message-ID: <20260304012717.201797-1-ynorov@nvidia.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0194.namprd04.prod.outlook.com
 (2603:10b6:408:e9::19) To PH0PR12MB8800.namprd12.prod.outlook.com
 (2603:10b6:510:26f::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB8800:EE_|IA1PR12MB6651:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e6ed4ea-07d7-47d3-22ea-08de798d2de2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|10070799003|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	EJSb5AO6p5oAuFPpEYmGGSPtTg65RgEQhbQzAgFRFsoY+L4pkN3PI53L9q4qk/lDqSuTSprt8Q6a2rBdmBzd3xiGIhBYQWn72TwJi1O5TC2/gxxzhYqzMxi5OpoZSrm8e4Tr8Us456TttKhQZ2v4cJb2flYpxK/JBKqkpdmukliE3Ov4LQyCwLes2VNF6PNcdpd/ZSE+jZPDw+P1qb/9/+QGZ2khiFPO8jxf9iNDqi3uNMVGfddvQWLPZJd5lFbXzEjdPh43dOX3W2ysr7Gb7PNw066wkrMa8MX/U7jusY7A1Y0N78iZBNQhAX15Iesk7y59SQ8PlindxQ/rLCko8GysTd3NE8I3R62ddu9e/LlitOWkNjPp5XUis7sCrDZ4CcPLP9rU3siYy8C3yqhOXEo+bCwq8h7suPVbgRQVtF3cCUIJkvjPTZr5FM9H7Vh31W5hjBGpjxjMZeINBzZ/iv8TjcDfIEfGesCyzZYawS7hV4bAL0PzvuuaZ7C1172bv1ezc7a9MMHq/+096Aqy7tKFGq4JdM2q/MraGfS2j7ZHFdezZWJJqpp+tkH4sZ3sTyLC7R24A7Kip0PGh47V9Ti+TGExBXVeIFDFmAm9ScPjIc5pF4Q7XZTyT9v0sTbtFK1Fl6Oo1OANjeMWfNJvN7ZsYdSRGgaDohrru36CxclHRkbsPDlQHetn1NHziKEtO5tJzEz+KtkF7AM3t8OIi8SnqQ4i9OiH744/4H3BVm8gQsvaXGbqiz/kSl7NRsvFJWk/xm8sNYKaJKMiKKBY6lIi8rWMq4uLJufj3E0A98g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB8800.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5S/xGfJhxq7PH6zLNWYwhusHSMrvUYH0Un9YPofehcsuyq37tlRoAbcoKgE7?=
 =?us-ascii?Q?B3FhdSpJu0cWLnk51jwgWmrAmlTj0cTI5MFhy8NwE4yTHRMtNPYIzm8lSJJL?=
 =?us-ascii?Q?PEBdmpf9rEczOCoN30GBnabffRCF/cUrmwNJRkMpps7xBOVMVIHxLtJ6CpW5?=
 =?us-ascii?Q?Uj9SaoeprEjwZEcEh0FI+MngV8ki2BD57VWzzMZ+9uiYhLDjQguHH/Bv6FbR?=
 =?us-ascii?Q?cyE14m8n0pbMGsPUmYIx1bWfUVJoXj5qWr4Zs2IUXQiWYFdHJGfohr8Y/E7J?=
 =?us-ascii?Q?AVfuDfjp3OfMDcg/cYNHS8OelMiIlaOpT7Lnc9br07JRkZ3eNuxftu0oOzYh?=
 =?us-ascii?Q?emdBx82p+SBinByHoPw0aPrCNGNHOHwMXerHd2CtGcetK2pS52xKukAx3Kpr?=
 =?us-ascii?Q?4Uzh5OG42/7t5HMbpxQVnbPUPOPDCt2BbfvYZk9J+ZCxN3pIK68sUdbrHMt1?=
 =?us-ascii?Q?wcO373zT5EBT4+EyJbZ9s6o28DNWwL0Q1aOFsYrqdJ0o8Tq6dVxP5XIvEHMC?=
 =?us-ascii?Q?+An9Wuz6fiaFTLL1IMm3PGoRAndk+z/xnK7AjkJA7dlSZzi2On0ltyL6LM7Q?=
 =?us-ascii?Q?eAKZDuxwbS5W1OamhrKEZ8agZCYB0NcazrVK+Xm3NJIv2qRAm86mjz+BXZNQ?=
 =?us-ascii?Q?vt5tUuKc71XXuXlJnb7hCso6myekDc19VP5UWKSpzWX52FVDiwrOUAhNW1JH?=
 =?us-ascii?Q?/N+KSGG1fa8We+fQleRZaA/mc1zx7PZq0L7wkk2Z0NWbI9AkGtFMhBYE492S?=
 =?us-ascii?Q?j6qeC0H1TsTVV3/6CHeY4psAL39btt6IshskvcJjGUWK3wZAlck8lVNyzrHa?=
 =?us-ascii?Q?djTtvnCsVCvXS/oXrznc3xQhMBisJsfct9fgBcG9z7cxo/B2pLrgr9OH3wD4?=
 =?us-ascii?Q?kZDfdx8XFrRDNwbsFeIj2m6mleQowKWLzsfP0h6zyY/5JfNcwdpz8i6vx8bl?=
 =?us-ascii?Q?ccnno5iLoF5u1gF0+Vxmr9wvOhIkBvMFPOQwtuab7iL5AO6is8ZkKs3PHmf6?=
 =?us-ascii?Q?0lRc0StRnN4/60EJf0H2xSZADkbRvqIlDX7Ia1WlPG5oCQyTOs+wIdQANf2/?=
 =?us-ascii?Q?vxSmcYVNYb9goJhgIwQ55CJxrdFQzD2NPO3uSlramK4zfulzHkPoq0f+uNBf?=
 =?us-ascii?Q?dYMAgeKeoRauP5i2ZDaAB4m4y39PJ4NQesQIwA6LtlURhumee4zQH198wLVD?=
 =?us-ascii?Q?qO2YsxM9F++y7+EVywl26hq+LgFz2VsjIQvEeB0K7GoJU20nwwua8V4DL0nb?=
 =?us-ascii?Q?/qQ+FM3hs7iaGcrUYE1u/epwv6ZgzzbyVP+bisUxXNKF1QXfHwziARbPl98r?=
 =?us-ascii?Q?HjBcy0kSELG2X9GdAsG6yg0fHm1xX/4eWrTBC4pl6YTbU95z0+QnEV1oUNa9?=
 =?us-ascii?Q?US8FEu5GnOV5tO5kX/t7QgbYRsEWGRz7eUUaVj6GtY2KZV1+mM23T0RYz/4x?=
 =?us-ascii?Q?GBJV5W6KTd2I6QMtaG3jGsJvDwN/vLDYUDsFzjstqbQ0r6WSS1fNiVRJoa+S?=
 =?us-ascii?Q?P0lRAxTRScIbX28G1wPUyhHi34Kk0Xhb+9FUX7pssSt54Z8Vccc02HAw5dJb?=
 =?us-ascii?Q?Llgn7iVV5Wco/3up56kFUcmvXHf6lSPsGrdBlIE/Ylf5kCFX52O7ZQhqG/Hv?=
 =?us-ascii?Q?4kKCXEF9I2/ufZ5K5Ww9jBvduETWekINb6+A1YbtW5cuzzqiu9ddeTB4APz/?=
 =?us-ascii?Q?6maz++AVh+e84Yxx4MeGqvZ5f73onH73V1vl1cpjDChSSB+ujkmJHEGIvyew?=
 =?us-ascii?Q?vHi1dyWLH/GNctIyBHTNffTLNGdaMs/dZGi+dRrjaBdlkgv7JeSB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e6ed4ea-07d7-47d3-22ea-08de798d2de2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB8800.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 01:27:20.3880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /+Lmm+XVjZYyMMKaXXXS817iT5VoaRx4GbjtH3sXBl09zO/C4kzjI8NuzoQ2rOW9d6TUbJNSeZvIbtW2k70y9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6651
X-Rspamd-Queue-Id: 692F7120003
X-Rspamd-Server: rspam07
X-Stat-Signature: tsf417kiyjgy9uymx5mx6dn7zgfe1t8t
X-Rspam-User: 
X-HE-Tag: 1772587648-413953
X-HE-Meta: U2FsdGVkX1+uFbXZ+4QMU/gd/89qXAeoZV7fFJ+3hu8nPVR7CA/exH+RaS5kHz35vFcs68PmpbY4Ngdza65omtGpVQrT4BhSs5SpSDMblGnthoSxfaZEjjr2eoo8jbiIb2Jxp+sYU+IIbUgRFVKkWWhIIETFXBF2NejYUHATXNWzRdNm542u33SA/QbpcGlPHhEOrbObfrM8S31iQfM5XIkrfccmoQ2DK+B7Jku5UrmhIdJpAp3VdgFvikERkZNnmUszNHmR/wHgAb6zVG1IYxsoKg5uX5r252+j3JRkzl5EnylRpHT9qNK6V8Nae/MpVisNIXk6VqBCo6DJUNdt41GoD9Y3+MhYuAoRJynFixK4hwKs8lqaH5g1QffR36dvyjT+AM5vZi45OjAH3vTpBEytW6Vjz1/ySKAfx71tM9SedM9JeS/lFg4Ymlln99gXNttvSE63N7G1p28RvGPDaQr/63wx/kyKjmiO+yygLu6glAXTe40ocDQXpHUegT7SFySdswsgsuCEXHoNNTO3AOta9eFYKkF/DLDt6vMoU/IJIqVjqYGC83DVExAaqBmyXdAlVk3y6E/Njlp4qKkZyMEPiuVyPU2i6DQhvT7cM7RryEwgaxXVSFssV2JGVfgr/jzO5sHSbOVWUm++ZQSSBTidnsd562pt3QY+kortTEwZDNsNvF3cScr9tL6MkeKVPwGwIYvU8cD5MRwROG/o8YceBE3mE64VEUyioj8U/+bCsnjh6Y04xCoTmCi6HDd2nAsUhOghs7ddhBrZjxCQa5ytIxIBpYsVo4Mn5cikpOg69iPC087fjiHyW0j8sQeiFHm2zrExk/IR7XbdBFwxnbf+bRpfBMmt3Xh+8lMjbN1N9aZg+UGgXWbiUzJDhfgMD49HoL4SQpTKNoAAu5IclcpGicwDRBh6oSyAe5udGQTcK2NTJ6SfOSgCXLGXkgN49BKPNd+kJjZuZpZM787
 qgowxPOT
 kTejacEMFY4bDKS3inypF5FZ1yA4fykWE0jm6bw3OVJPtU4cw0mDENPU3Ai0ilLOCXeazQ3X0RbpvuSatjhZ4kozzexm57T7kKih5EmDe8LpmNTQukvgWIb1z7GQnraSNFYA4e9AyUCeeDxP6FEjESrNYPMOSEi8FM0Jbvz9StCI8zztSu8wWTzNQCHd0h4h3h8SwkyYnWE+MdooLqJM0Cawlf84OamdJBa6ZZYSxe/rykMFfSrnAn7pgCduQ+aNj8K6H0DTGlZXwXCw017uh3gvhqv+1UETlP77yKLIqjcfevBpw4IrYj3EwtZ1vACFIy5TU3Soalbm59Z6dbSTskbrKH7+I7hHHwY9kc+8quMN/oMvGfdeXlU1yOME1e1ahd+ShwLSdU3T8hByWyqxucCyPEN3cYX0Ltdn7jKM31e0ld3iq0kfERJ3op4ksp+lpUum0XkTWAlU2YYZPPSwjrN6DPUhgeC5BJIMUmSDl0nyOjtT27CXXDb90Xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The net/9p networking driver has a handy macro to calculate the
amount of bytes from a given pointer to the end of page. Move it
to core/mm, and apply tree-wide. No functional changes intended.

This series was originally introduced as a single patch #07/12 in:

https://lore.kernel.org/all/20260219181407.290201-1-ynorov@nvidia.com/

Split it for better granularity and submit separately.

Yury Norov (8):
  mm: add rest_of_page() macro
  fs: use rest_of_page() macro where appropriate
  net: use rest_of_page() macro where appropriate
  core: use rest_of_page() macro where appropriate
  spi: use rest_of_page() macro where appropriate
  KVM: use rest_of_page() macro where appropriate
  drivers: ALSA: use rest_of_page() macro where appropriate
  arch: use rest_of_page() macro where appropriate

 arch/arm64/kernel/patching.c                |  4 +---
 arch/powerpc/lib/code-patching.c            |  6 +++---
 arch/riscv/kernel/sbi.c                     |  4 ++--
 arch/s390/kvm/gaccess.c                     |  6 +++---
 arch/x86/kvm/emulate.c                      |  4 ++--
 drivers/block/null_blk/main.c               |  6 ++----
 drivers/gpu/drm/i915/gt/shmem_utils.c       |  5 ++---
 drivers/md/dm-pcache/backing_dev.h          |  2 +-
 drivers/net/ethernet/meta/fbnic/fbnic_tlv.c |  6 +++---
 drivers/s390/net/qeth_core_main.c           |  6 ++----
 drivers/spi/spi-pl022.c                     |  3 +--
 drivers/spi/spi.c                           |  4 +---
 fs/ext4/verity.c                            |  3 +--
 fs/f2fs/verity.c                            |  6 ++----
 fs/fuse/dev.c                               |  4 ++--
 fs/iomap/buffered-io.c                      |  2 +-
 fs/nfs/pagelist.c                           |  2 +-
 fs/remap_range.c                            |  3 +--
 fs/xfs/scrub/xfile.c                        |  3 +--
 include/crypto/scatterwalk.h                |  2 +-
 include/linux/highmem.h                     | 24 +++++++++------------
 include/linux/iomap.h                       |  2 +-
 include/linux/iov_iter.h                    |  3 +--
 include/linux/mm.h                          |  2 ++
 kernel/events/ring_buffer.c                 |  2 +-
 lib/bitmap-str.c                            |  2 +-
 lib/iov_iter.c                              |  5 ++---
 net/9p/trans_virtio.c                       |  6 ------
 sound/virtio/virtio_pcm_msg.c               |  4 ++--
 29 files changed, 53 insertions(+), 78 deletions(-)

-- 
2.43.0


