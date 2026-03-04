Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 464F4EDEBE7
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 01:30:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF0346B0089; Tue,  3 Mar 2026 20:30:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA6C36B0093; Tue,  3 Mar 2026 20:30:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9511F6B0096; Tue,  3 Mar 2026 20:30:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7EF6B6B0089
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 20:30:56 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 38A2C140386
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 01:30:56 +0000 (UTC)
X-FDA: 84506651712.18.BE1F4E8
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010056.outbound.protection.outlook.com [52.101.193.56])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6B2F5180002
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 01:30:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=maidt9YU;
	spf=pass (imf06.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.193.56 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772587853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SMCVXE/QqXcN89uo56glYVb2KUIcE1svTHLTUm91N2M=;
	b=uAtWg3wcgYhBkqXSP+jN5G7ezenhpNKkGL0gNSegKbrM1VhXWnb3he24SLGEmIQKzzU05r
	YuZI8AXXfU63PHU1Tm7MmvKVAcem8hZcjYcPxnuXxvEbjwyvNVFenN67dxtUAa4Drde0Bj
	wAcpnpHERo9MwgLyDQQ68II0GUq0MLo=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=maidt9YU;
	spf=pass (imf06.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.193.56 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772587853; a=rsa-sha256;
	cv=pass;
	b=5s/aNJJaNbrCAIURN2isVA30WdgVXuBL1SB02gxpK+pINyrZAk4HUCpraEF80QhVx6eNLt
	GAFdl2EUI7RciPit9Zc5h531Oju45aMIpzyHoME8eiII88i3M6+E5lPWKMrkLkBlnhZLOO
	iwlMJhs8zd0Pm6VmoAdpY7lK2N0lJNs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p7IyXyBnfC59bhh/QDlC4xjm8gnxI/aVjCQ8NWjD+TQ/phVsvcvuW+NLBwz88oegj1uUlu3Eo3WVXfBEPFYLVctAff3OGVKs6Xv8Wggf01j3o0MSOeSxHA5GJqJjudqqXN/2oDkFpLWG7rNbgythWaGJW701F+WT+MDBwzxmlu9SXw/oaP0PeGTAWeV9kaOO841TnqajI5htVvdPBVcphxbO0+fCcLLs3ACa6zPrI8LdN0/pSUTyF6rkpr0iKAmaNhVLW3qunh4s7ITlNquQXbSIEekdoDCyuvRtVfUJe+oVe99SGOdiQIwubQe36N7K0Itb8+4Q5Sa+OhGYRxeCXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SMCVXE/QqXcN89uo56glYVb2KUIcE1svTHLTUm91N2M=;
 b=w+esDmCCph9thTxJi6D9QEtzrUzS5rQDHMVxzz6TS7qPP7AfnGlXihVXA05VntXiv4B6vEmeBEDvccO27e4Ko2dC7bs65ACkzY3wPreezzZgngCi9P8sE/duNHHHgFmmJN9NBZsU0Us9uaLpK0fJZ3mT/4xh4/TBtjrO2R3aQOUNEn7ml8MMFvfkHLLP3AVkyhgcLytd9ojZ31UtxREx6DQU0dataSsAq3aoeyhGOxQFcMtKumoym/0xXP8VzElidNH1V2VsQqfhnizX85t/USGwEFg+FsJhWpfu+cj7+GVZy9VnGvbC3Ym8VvzmSwj3kSb6OPoRbdlrpNeO3pp4+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SMCVXE/QqXcN89uo56glYVb2KUIcE1svTHLTUm91N2M=;
 b=maidt9YUEg9SE1s2e15IkLkTmsj5XGLJ0eWvmZLG17QCRfvRHNiGN9W3S5yzM2gLA3ZwjtK0HMjZkNSiN9sN7bTS9l2uk3KeXEbIqBn3LZ9aPcH2V7tMnIv7aSCbInGtrtlF2wl2hQtVVFRA0iLD8deJv7DgLNRD88+Qtd+yFA1TrYXYHfU+Y/QQCMYfQ8QTzb+CCv4rUUsIG1ZLmGNhWtC5E+8P0TBA208y90uayInBW54MyAATkCPSzlbHYLLHap/J/tssthm9awMpbHFDACRlatTjRTT4e7jAMrCvGEqGDgfcCtwSioUqVWfEw6oStZDZTh77KMsRBqjrVmO03A==
Received: from PH0PR12MB8800.namprd12.prod.outlook.com (2603:10b6:510:26f::12)
 by IA1PR12MB6651.namprd12.prod.outlook.com (2603:10b6:208:3a0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Wed, 4 Mar
 2026 01:27:38 +0000
Received: from PH0PR12MB8800.namprd12.prod.outlook.com
 ([fe80::f79d:ddc5:2ad7:762d]) by PH0PR12MB8800.namprd12.prod.outlook.com
 ([fe80::f79d:ddc5:2ad7:762d%4]) with mapi id 15.20.9654.022; Wed, 4 Mar 2026
 01:27:38 +0000
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
Subject: [PATCH 8/8] arch: use rest_of_page() macro where appropriate
Date: Tue,  3 Mar 2026 20:27:16 -0500
Message-ID: <20260304012717.201797-9-ynorov@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260304012717.201797-1-ynorov@nvidia.com>
References: <20260304012717.201797-1-ynorov@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0111.namprd04.prod.outlook.com
 (2603:10b6:408:ec::26) To PH0PR12MB8800.namprd12.prod.outlook.com
 (2603:10b6:510:26f::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB8800:EE_|IA1PR12MB6651:EE_
X-MS-Office365-Filtering-Correlation-Id: 2609bae3-d7b5-4d6c-cdad-08de798d38be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|10070799003|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	xtr88SI7Q4AcFK/iCkO/xPPWk0+R3vDrTpAEkNkbZ8qomfK3bAqE3XXgk3WCNroUewaQ35DD4OpAJK1mIhUjhWYvBFTqoeATTFnLAmqOp15cQE84BTc+8CnbiKwRE0wOPvR4+P9wrFVo6jX1SM5uRem1u/Gq0/uFWMPPtwK4pVRqQ6TaZagPbb9tU2AbyJI96CdJV+D/9u2lDuLkmio5k8PimILuLSWNRKkjzizNdjFIBx5FcpjDsKEPd36qCC8fgQ8K5WsoA4hd5dyEORYzDfvI2oH/zoDgA0hctTSJSGry0uzr+8AI9tV8nUZjlMsrDCf2UMGeEBPxCmE01gt5eH7odkBaAXu3EvlsN6LtmIu5GU5fD4aHKyOhJRiFYkfo3RM9lHPrff6Rd/B1e0mihJxDWgodSpZDp2Bpzx+5nG3mrD3EQJBDgDvfDixNyRZ+D2aSppWErIY/rwuO20KAcDloK2pH91Uj1qnwopT2ICDEqyTmNOvm+Gnr6DBGgKdRRa6zeWiOM/aYM9V6u0Pp7f4YTFLa/5PvZfCBhkWFIQy0buCigXXjKYExH4rTtmmMH+bAOCnV8nCxPP4RNKGZRMZGwhL9BYG4V4IVzgQ/aZ3+XTJFWe/5uwHcrp5qPa1zQTsFD/7c32RWrSRS12+/v+bw81rbNRTnOAvEZy5XDi1Eenxd3W6HyH5I09MHMhmlW1TOC/u2untYVG3C00LNI6+bNraN5Rg/0lUN9gfUQLS/TQXgz9Ud6SR48QdzfL6/4dmZN94g9vM+nkmTSClPgw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB8800.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jZT52MDM+eEm2ajfhuGGg1je2uDA86dzD5RM7cWtaSUcZsmLo3p4LUo+VZgH?=
 =?us-ascii?Q?CcFY4fZq73cONvgI/up9p5BMyftLSMlvV00Vm3N2XA2UaJorXSvVHlN6e9rG?=
 =?us-ascii?Q?+BS2M5jomKURFg3P4QGjVyE9mdjFeF/n4cBQznI+N8UtjPZtlqzw/pXI8KHJ?=
 =?us-ascii?Q?Jx8Li/Gt32NxfUzyb0Re2KRK2EpLasBGScpnd5rc93/stq2s6BEU/S9JEtQK?=
 =?us-ascii?Q?0J2Ig3D27nnZt1DlT36YFV/Z+bGIN1t7oc+eMYIJpkmGuytatGb6NtHeW9Qc?=
 =?us-ascii?Q?otPJ6O82PeDiCAbVWKAIGs3yRNs/jU7k0xlBn6jLHxH7TFNKFK5kVghg523j?=
 =?us-ascii?Q?oX4r5I9M2ZnolMGZb1AZcCOyJZe+YZOBWqTA8i6z72KvugdAVo9VtSpTTxLS?=
 =?us-ascii?Q?BiAlthrnV8VTo2+a4EracIh+n+0e5ma3dxFtYhg41j2oJp5krPwgvyFpYE1q?=
 =?us-ascii?Q?gMgzWOMwd+/EjN7Jmg97D8iRFNCImOLvjk/FwATm86gkRu7Fpj/L2qJLcp8f?=
 =?us-ascii?Q?9OirouLpKCmoGuAycTa4DutOGkyJXTl0yb5aiFywqakzGWYOCiK8p8fOjzVw?=
 =?us-ascii?Q?iJmYDNPuAuXYA6ifAnDtnyXjSYpku7Vd4oCULY+YgrnR+mD8jN8oUbTsfxDJ?=
 =?us-ascii?Q?70dcbbGaemRAcZ3oDRNwmkIIMM3OmgbkVbyPt0V4HT8ZIOCAN8xFEF4p6cGO?=
 =?us-ascii?Q?eW9Ix7e20XVgZMGLl7Rf4bR0GJbrbrvHzK5p6O8K530TWx2RmTkMKKovm9d6?=
 =?us-ascii?Q?hRiCXlxG9Mwxk8xdLTLIgXKCd2DteHO+ouNXq8Vy/6bTe2q9lFY/nozPKuSj?=
 =?us-ascii?Q?3XiTDROtScMtG+K/Sx8p0yHfEDmN8m4+AcFQDS5z0pUFiNGUNxzyWTdSlqXp?=
 =?us-ascii?Q?NCH3PO6j9oS5Rz6N9b7La609E0iQ+8jqEkej5ry+SuPdbJtjfWcZsxcpbA2l?=
 =?us-ascii?Q?PKq1KNKu5R4L67Dt5dzmNkYIj1t5aezZMVNdaTUYopF69DGNpu6XCnMIdzmx?=
 =?us-ascii?Q?YuclF7I1XJRth9WYwy50lhD7wU0Yx7UkWn0srKPJcBh6COcsxslET61mBVZY?=
 =?us-ascii?Q?hiRG2fLtJQw5l3Y7iLDndQBLijJWAeuWbrOFhTMeYQiOJsLuZD34AcS4n6I9?=
 =?us-ascii?Q?CSKMBYHwj3GQ1sjrBRQcLTs5r/rAu524+LplcySqtzj31wxZWNEsSGDhkhWq?=
 =?us-ascii?Q?gUHEJGESGgSe7ricmXWRJu/bL0g555G+7khTbaBSErtMHZO8cp4BPDMjlF8Y?=
 =?us-ascii?Q?AJh3p8vJq0AxIeaJW7+CEweIQWdGYANN2l/oBAA/seklaYQhht7LMXx47aEv?=
 =?us-ascii?Q?fe7x/gjpSQ6qh0sxrjjga5a2bxc/M1BYS1G0gpwCM7jIEl3r3Woh6Np/SssN?=
 =?us-ascii?Q?0bRjcJjYMdGY8VfCjp2wtkZgxg75kLzeHKTUkw1jiUTz+zJxIFneVF9ZOBS5?=
 =?us-ascii?Q?TZdcNGY9VNNZdRgyvbi61Lu/TOCIf+vn3O9hJ4SQzqE+XF2Fyvbf4qvfYGAj?=
 =?us-ascii?Q?TC+KI43yWW7FPkdnVxH0fYofJDaG+Z7428TtImGS7j10tIa2cscZjOsPhgHW?=
 =?us-ascii?Q?7r7El9t92QBbstiWTNULLaGH0t1N2FN8XcT0xQ8t4xk5O7IeK/48IZ6YiYqg?=
 =?us-ascii?Q?Nb04R/5oI4l0W1ht89mqdstkVexYsc2UQ1BQEX0A1uDg7sXC0xuBvZQ4yOKh?=
 =?us-ascii?Q?5ceyzxrZLiFnpOfqTHF2HzrtUnQDhu2Xj+OZwNZcxC1k777PWjJy30XAifgM?=
 =?us-ascii?Q?XXCFrLmaSRas1lUilO2bKMt1CtRSz/X7urTZvi79BSv9E/gD9ePe?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2609bae3-d7b5-4d6c-cdad-08de798d38be
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB8800.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 01:27:38.4368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CXt8e378FJ0B3MzdzzWaWK9oK5KIDe3bPOTtrn+uSqUA2hwKB8rT9SRgsjZlbcdaW7oWw1Rhh0hszU/hvHkVeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6651
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6B2F5180002
X-Stat-Signature: y64qg7k3c3x9ugmnxfw3ysq3ywikqedi
X-Rspam-User: 
X-HE-Tag: 1772587853-352207
X-HE-Meta: U2FsdGVkX18SiHgAjQrsaClZ0QsAKg/Oz2RrvVObltiwgm/eQWPdJ82ANa2Sa6IogcHy+9aHYopqQxH0XJmK6Kd+mY9/7smlW273dxRGC5ZfP5dHWZp+Qp9LOmOuDU8KwCKErAxgWMhzlJeNIQi63h/k7sUVIdp3YpciqB5vwqCiviOpBrteT1swKKRLFTYCH9GA+rlaghEfr99YrRCMPwgUd7oGIB5k/jGAz+ssZ4XwTrM+Yuyd2O4Cwdz86zuKwozScn6Q/xi34KbEXn1hvxh3FQEUHvTftYF6cwAmWpn+mmie7RKmMZ4ouwMmfOl25FlvyTdvvJdN13Wd32Zn7zdP3yEMRus8IXqUjbtzwcPYayXfMMzcYPFzN7MZlzg2xYfS3vmXc6XXKE4jKxfi2XdiJofFRubUcQ8xrEXCPYt7h0ejAf9VRd5xBATgjpmrq8VGCBg0JKo5wzdoNRvHaTLW/InJglqsKKvoUCqWHMJ7AKiNiJjLIAVCNnzj7YmfBMLlzSap3F4k7m97YETELlOUw3/4gzhqUwKX/XoslLM6aqxv1wrxxcsDW958ohGjxKu52PIHWN6OghS7VdNqDQT3Kr2p3oGdqe22YQBDKLZvHhQU9vgp+RQ8rK9faQtCf8BeADc4GKhpr6ktx74zl5neGu6lRPE0YsbJTUcrfNVmgOAshZoLwBGI5Dh6ZX2ac0EkZ/eULYtvTL7bbCjT7ueYe+C1DbgKE0NhnLddn+jlJhQDWmUj0Q9YDgT9O9PhlUkKU3qdgExB1DTebcBK7HrAt2uTLPL1kT01h8gi6l+4/fSSJJDf+R2LEs80P8f2p9m66XlbHnonjV9/dT6AhY0QCzNMrn5UMJcz0CI9/b4sjyflt68t71gFskSIhx1nhPFid7+hYLsQmivSosIhpFgtkCUCauXdT/MTqK8JdrSAQBPXk9KEwxrC365CH1y2pWltZ/at00wTV7zWr71
 VxKwPxMP
 ZDe0FkPzILEgpkQM8MvGdmLxnsWWPzO51iQZsc3ewKFe9D4PztqEPSygyCGQTp/QbHzVXK/F27f5KvqNl8kV4kM4A4B3qJSp2cu37GDGa/mk7yiWGV0QmQhQN7acdDHBOphCPgNjCCzvXOEs3OGyAl5n4LO/uoUm29KdT434q9GAym84jm8xwTtit0PO6XRQ7Hjw5A0Fc1+6uHuxS94Wj2zxw1BcnpxozMo9vPpihf7q6vbvGUH0LuJ1DYW/11qZuM+leGj7uabYujzckSdWLj8fDB0lJeNXG2uWLwCkVqxThucXtT0nWjByRW3iCWNgeii7P3pVLvOQe/LmtVe9g5AjVVVqd6nS0a0QnSD1h4KJO6ljwC3fR5JDC2tT2Qrf+tNvsW7TEHvJ26Hrp5HD/XVd0jw07pJDGHfTKpbl1laZ2SdvkVYCYDB9AMnqmPnM4RwE07XUFn1Wyo1X+2CMW6BBHXgjk1YJ/wAuIvlmT1bRHiA65VgQ5rlr6vjF0D+rsQnWiBA6Ds2u7BXZL9amYBvJzUEXWz3Uy2vObffS7DjVutfXfj6AmM26oNrUeS5yaeTKEINGNHFNHZsEpTTrmq/gOBEPRwn3apNe+SARLLlCoZ371dWfjNQ5nkvM3WkRQ18i0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Switch arch code to using the macro. No functional changes intended.

Signed-off-by: Yury Norov <ynorov@nvidia.com>
---
 arch/arm64/kernel/patching.c     | 4 +---
 arch/powerpc/lib/code-patching.c | 6 +++---
 arch/riscv/kernel/sbi.c          | 4 ++--
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kernel/patching.c b/arch/arm64/kernel/patching.c
index 1041bc67a3ee..4c3a4401719b 100644
--- a/arch/arm64/kernel/patching.c
+++ b/arch/arm64/kernel/patching.c
@@ -116,9 +116,7 @@ static void *__text_poke(text_poke_f func, void *addr, void *src, size_t len)
 
 	while (patched < len) {
 		ptr = addr + patched;
-		size = min_t(size_t, PAGE_SIZE - offset_in_page(ptr),
-			     len - patched);
-
+		size = min_t(size_t, rest_of_page(ptr), len - patched);
 		waddr = patch_map(ptr, FIX_TEXT_POKE0);
 		func(waddr, src, patched, size);
 		patch_unmap(FIX_TEXT_POKE0);
diff --git a/arch/powerpc/lib/code-patching.c b/arch/powerpc/lib/code-patching.c
index f84e0337cc02..186a9cb79ee3 100644
--- a/arch/powerpc/lib/code-patching.c
+++ b/arch/powerpc/lib/code-patching.c
@@ -463,7 +463,7 @@ static int __patch_instructions(u32 *patch_addr, u32 *code, size_t len, bool rep
 
 /*
  * A page is mapped and instructions that fit the page are patched.
- * Assumes 'len' to be (PAGE_SIZE - offset_in_page(addr)) or below.
+ * Assumes 'len' to be rest_of_page(addr) or below.
  */
 static int __do_patch_instructions_mm(u32 *addr, u32 *code, size_t len, bool repeat_instr)
 {
@@ -514,7 +514,7 @@ static int __do_patch_instructions_mm(u32 *addr, u32 *code, size_t len, bool rep
 
 /*
  * A page is mapped and instructions that fit the page are patched.
- * Assumes 'len' to be (PAGE_SIZE - offset_in_page(addr)) or below.
+ * Assumes 'len' to be rest_of_page(addr) or below.
  */
 static int __do_patch_instructions(u32 *addr, u32 *code, size_t len, bool repeat_instr)
 {
@@ -554,7 +554,7 @@ int patch_instructions(u32 *addr, u32 *code, size_t len, bool repeat_instr)
 		size_t plen;
 		int err;
 
-		plen = min_t(size_t, PAGE_SIZE - offset_in_page(addr), len);
+		plen = min_t(size_t, rest_of_page(addr), len);
 
 		local_irq_save(flags);
 		if (mm_patch_enabled())
diff --git a/arch/riscv/kernel/sbi.c b/arch/riscv/kernel/sbi.c
index c443337056ab..9a2f656f776f 100644
--- a/arch/riscv/kernel/sbi.c
+++ b/arch/riscv/kernel/sbi.c
@@ -602,7 +602,7 @@ int sbi_debug_console_write(const char *bytes, unsigned int num_bytes)
 	else
 		base_addr = __pa(bytes);
 	if (PAGE_SIZE < (offset_in_page(bytes) + num_bytes))
-		num_bytes = PAGE_SIZE - offset_in_page(bytes);
+		num_bytes = rest_of_page(bytes);
 
 	if (IS_ENABLED(CONFIG_32BIT))
 		ret = sbi_ecall(SBI_EXT_DBCN, SBI_EXT_DBCN_CONSOLE_WRITE,
@@ -631,7 +631,7 @@ int sbi_debug_console_read(char *bytes, unsigned int num_bytes)
 	else
 		base_addr = __pa(bytes);
 	if (PAGE_SIZE < (offset_in_page(bytes) + num_bytes))
-		num_bytes = PAGE_SIZE - offset_in_page(bytes);
+		num_bytes = rest_of_page(bytes);
 
 	if (IS_ENABLED(CONFIG_32BIT))
 		ret = sbi_ecall(SBI_EXT_DBCN, SBI_EXT_DBCN_CONSOLE_READ,
-- 
2.43.0


