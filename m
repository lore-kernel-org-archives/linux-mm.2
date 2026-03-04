Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70970EDEBFF
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 01:29:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5E5B6B009B; Tue,  3 Mar 2026 20:29:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D11596B009E; Tue,  3 Mar 2026 20:29:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B957A6B009F; Tue,  3 Mar 2026 20:29:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A6A9B6B009B
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 20:29:42 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 702361C3BD
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 01:29:42 +0000 (UTC)
X-FDA: 84506648604.23.AFF4C1E
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011000.outbound.protection.outlook.com [40.93.194.0])
	by imf15.hostedemail.com (Postfix) with ESMTP id B05C5A000A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 01:29:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RYiZja5N;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf15.hostedemail.com: domain of ynorov@nvidia.com designates 40.93.194.0 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772587779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cH7iO9Q4dZ8KuVQBv2cYkhEWudXwCWScxmGAOwonoNc=;
	b=UO1ZDPJj5x5LPE/PgoAHrP5FTy2TntonVM6IXkN5KbomyIschkNoSHjrhCRPGt6doaWUiz
	0qNwqMrMQYgZmLd4ZgmzB22KZHdxi587b3VCWU0LuHGE7AxQqo1Kd8cxFBnRhooioE0muF
	8Q3Xc66KCm8kKX5TUiy3hZOYCfw0jm0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772587779; a=rsa-sha256;
	cv=pass;
	b=Wc2F0XMqByiwN6TmRyVJgl7m9qR1+wkTeaHSHK1yUHVEDih8x19rKTSfEQGjVqF8PubxsM
	IyT3oqy4VfQ2SV10M6tl5mOnI51v3Xjt2V4HiNNK5CrnJcz4B0zPqQ3KZ7N4UiVPQyC21e
	Ywuz846Q6yPMhd9jqrGmy7lyGPR6npU=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RYiZja5N;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf15.hostedemail.com: domain of ynorov@nvidia.com designates 40.93.194.0 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GUEpwqnDbdPpBFRDxd8rnb3Vao87jMfH2abY4/OrjXVEGZc9rOA6dtPM9sl0ZHHPA9cyyL9xKk+KkW6bElnzgtt7PyI0PIAMRPES0cn+yAhCTMfwzBcSny6Euwrtq+UPFDyqSwRIVSG6k25wfijiYiPook3rNZUzm9xetExw5YmCEqtBM7OrbEbgfJR4EIhJFIrwz/AAu1BQVWGB7hqTcyTpKh+WTt57sGy3WKJ7U1Ey5p6wgNaXjUCNtW6lzw0/Qz9FaSuAXp2xcPovmgXNqCLz7PuFh4e6JGP1W3Fkb8z2oN4gBfSsTTRz5WV6bIYoqRY5ZquiPxS9HArdSmZ+LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cH7iO9Q4dZ8KuVQBv2cYkhEWudXwCWScxmGAOwonoNc=;
 b=t8wacObLG0AtvAojklDfDBN7M+nNgorS+XHCHCBT03FGhzaMrqG50IqW2452P/566lxsMgoPpiDWDPgXMOs01T0zT7NDFr3BSLHBVg+Du0aL/ipH/l1/4W/c48GAQTo9ROV2c+oGqaag7pXbY0UfUC5xNfP5zRMltohel28YdwkYgcWgzCO+ombJ5LLIkSAi2Fsd2Baj1PfCwg4bMSsn5I6LY9u4KOm+jtTqLOQF1Eyuj/NXVkRi3fDvO/fF7TVZ+Qs2XYTnEbe/JiTVpU4uPVYTb9Vc8j4lPZbAKFWmGxolWzl5s2veg6jErv6F36Rp8zqlULNZ9C8FV1uyao3u0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cH7iO9Q4dZ8KuVQBv2cYkhEWudXwCWScxmGAOwonoNc=;
 b=RYiZja5NTXFxA/THkqh9oYYNQ7N6NlCbbe3SeoUPo09/eEzXD8gihvHKCM/RaD/iQcIZOzmWSNLPept1DFHUHNQYv+eRG/AwmkhkGbqo+N4t46p4d1SqRPPeOAHgMPXhKsr7gSP5XXLqaJCBWvlmWWRlXS3Oyt5zAq41WlGGh2z9J2p82btAv1AyjLheMFf7r+vwpsqib0xz8iA3NIHCqeVxQow0L7Dh8pWi0CUIIRWKa4XosCAmH874K9vZiU2lZ1UP8ZlzpwNGmmLSHkRvKHigv8hSdDpJfjwlHg0wldEAvm7E9IDjlMFLfL5op9vdKkyZKrbO1dOE3GE0cuq1oA==
Received: from PH0PR12MB8800.namprd12.prod.outlook.com (2603:10b6:510:26f::12)
 by IA1PR12MB6651.namprd12.prod.outlook.com (2603:10b6:208:3a0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Wed, 4 Mar
 2026 01:27:31 +0000
Received: from PH0PR12MB8800.namprd12.prod.outlook.com
 ([fe80::f79d:ddc5:2ad7:762d]) by PH0PR12MB8800.namprd12.prod.outlook.com
 ([fe80::f79d:ddc5:2ad7:762d%4]) with mapi id 15.20.9654.022; Wed, 4 Mar 2026
 01:27:31 +0000
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
Subject: [PATCH 5/8] spi: use rest_of_page() macro where appropriate
Date: Tue,  3 Mar 2026 20:27:13 -0500
Message-ID: <20260304012717.201797-6-ynorov@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260304012717.201797-1-ynorov@nvidia.com>
References: <20260304012717.201797-1-ynorov@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0595.namprd03.prod.outlook.com
 (2603:10b6:408:10d::30) To PH0PR12MB8800.namprd12.prod.outlook.com
 (2603:10b6:510:26f::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB8800:EE_|IA1PR12MB6651:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ff22217-fd5c-4cb4-bb7f-08de798d3498
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|10070799003|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	kNpItpHekTNXaKTKIoYtGV8Ypn7ulc25MzyvMa2NB7zhSgWxNFJ6YoesWE480hRO3kIFHehi1NL1IAFEF3KjqvV3lkLvFxRPalMczBWKU48rBG9YCt/iyiFTx3U3QRa135ph3fAxkK4pqm076Ap1smGC2bfo3pj50DEcTd5iOnMmN7Wzrb5T1Vzw1dv9rGBbyzetDoXhygbazWgvTZgeLoFfmierJeksW6ztYBDE1EQNDjJp+ne6ODaVuPIZyNSEOaPTTU84902A2oVkMAAzvzl0JCsPTk/9B2psN3OXDCiYeFIgo8YkT5bANW3qxmdf7SocpEpL+rj/lG6YqYFZTD8fNIRQanarlNMaXlFFp9mG3IrYPXwsB+5a41IiNL6ofEnTLmcEZyjRh6blNWr+cuC76R5uk1CdlgoGHJZV3JBXbW9odm2bBKGtsXSlfJzbr1Ax1uYmZSbPwgjMmpiXY8Q28Sh9pG7Qpu59S9loQjFoeuLaMT7qNhUIrcE/5e88qU0LQE500uvcPyVbKp2r0hWH80EkosvIZRxvUr5ZjaPUEw+DR/lRC7gOgrUkBG0gMyDH4YX5pb4MiWsQr7n0zOIf4SiGwz3zxdK8g8byYcGd2Nfv/tVVm0W9hzCm6M1CphhkW5juUUIdwXoMptDar5P8tqSLeP8d3lfndR1eaZlC4cANgDccvwLq++HeWiWBuGbBVDH6Z1RNrscJyfyHhd5ItUAhGylKpHVpT6m+ExIka1qj7HSsQeVUyvcIlRMnx+Q4QWBZB5Yy9LBrHs/c3Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB8800.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QovhxB1t0D05zU82J7ljlNOcfFani18E55Vci/LJ5lFSVxGGxTLMHD8dNWwM?=
 =?us-ascii?Q?Da+r91pDr/AjeXlSvVnuXr9KvAOYU+u9spNyh8YrRm7aV1z70UuBwFET4gDJ?=
 =?us-ascii?Q?fxDxS+Jbfg6JiKlOhMh30S4Ea2PaeyFaUA0U+2ORN/ql1E1kJetHVNyPu5vM?=
 =?us-ascii?Q?mVd6wmVWNygYY7pvVJiG/nJlAK79Jex4vNlZqZvyi12S3fcy9Sfmh07SsP1X?=
 =?us-ascii?Q?4oVT4s84uL9spRPxpKENVyrNNik7bEEQRCQQ3pP2tL7CFwO5rTx4qf+0YZ9j?=
 =?us-ascii?Q?y/QD2q2v0nqFgbER3FB1YJGEIN6cJsh9gtOvAV2CarMqdUIZxC5A/tHIw5LQ?=
 =?us-ascii?Q?Wv+9QpJ0GLCvHBPB4BfVs75pK6ARqPVvY1JF4XW8WA1ksRT73nDAPDsVn9w6?=
 =?us-ascii?Q?nMPo81N0pUsLNa25STin4h/fSUQf1Y6JNqLDQeCSKD8vaJhgyibg8eqigNzX?=
 =?us-ascii?Q?Nor1uobYjGsFDTklxq501v2u9N6zh8giRPC8nVXJzzgKSG+IUGa5mOkx9vhy?=
 =?us-ascii?Q?Xy1to0vOqEmXnsvqaFPmXO85LqjtLGGJEDuGFgP/2yH3VyDSWwlwuGUiA0Xq?=
 =?us-ascii?Q?hU7HBKgtNhmFqC/sHOw6QUreYRUr11Qn5k3+U9is1qHpR+oVS2oLfwoy8i0a?=
 =?us-ascii?Q?J+rET2Ft1bKpUTiuvdPn/lAYlcQQ1YBtBNJpxj+UceOZRowiiY/rvt2sSU/k?=
 =?us-ascii?Q?Dipd2WP/7VGEg6rLW8z+55Qq4D9jtkRxw6sQUdpI1PCz32BNzRBDHgUBH4n8?=
 =?us-ascii?Q?QMYroBQZqPM3jTHwwAuJr7qV9mxn7Q6mStMIdpr+7CJ9fcSC/f1GIw5RgdlX?=
 =?us-ascii?Q?5fabSXQnw4w+KKincKOThnWPArA2EzJklK4vBKYJalDmyoEw3/orxtxqRbsB?=
 =?us-ascii?Q?Zj4J6lAtU3semknfNPdiR+hqd4IrUmKHet3qpxdLA1Tqw4wysCvLftZ2F+wa?=
 =?us-ascii?Q?MV+xK8Btl9ooNwm+B2wI32UM+MNDgdhqRIrC3546u/HjopTuUShPV+WtWK1S?=
 =?us-ascii?Q?NUxkCYO+FX0XWapL4yKZWzevaiGmjxiwb7QQ9u5ohFZyZe+K5v4kwHZS+GVt?=
 =?us-ascii?Q?hrzF9jaQMJ4DHVQQun2V071lsUnC69dnpQLZqfkcnlfPwcw/bsqomaBU6y/9?=
 =?us-ascii?Q?6XTB8Kme3WvCQOEBib89w2prRquH4XaQ8LX7NxIxPNE21YQR7dzvLP9YziHs?=
 =?us-ascii?Q?vV92Rq4bD0WbB+uLxt7Ruooxim7k+wIo32Hqo8P1m+qsRoUczWkzBqPVl4Yh?=
 =?us-ascii?Q?saZyekj16IO3xKfAEfXTLtYRZV/Db3gzzHKdHVwlfqyJFrhOtK+0uDSNwLTX?=
 =?us-ascii?Q?ZA/kaws0Dl+TASCHgepQsYBXjYscXVVEOM4gQh7h+QcxefwGxlo9Rv7ndTgr?=
 =?us-ascii?Q?KDqoB9mPwFzUcjfkqYD1+K16nmcuYEBjp3tDKMrhACtpIgijR4FiPPIgdC9E?=
 =?us-ascii?Q?+8p9BmBvItS45Mu3X096L8WIuhsXghje+0DHjSEGVtU2LIAyVJA3Syuw6Oea?=
 =?us-ascii?Q?oYYTr2IPKXvYwyxT6aW7ANzcG6NGdL2Lr2uRLz6Nrps7qglwqFkf7nMqfuBQ?=
 =?us-ascii?Q?A6+Hid9KKbK1sQULk8y6jYJFHzRm5pVWv0BqbrVoPaxe0rCnO6wsFhEOO0Q+?=
 =?us-ascii?Q?eCkGhPEhFG3bVg9HsHOb2ZPu6Szp0HSLTotSdfbdes6hDAI7tfo7l/2655/S?=
 =?us-ascii?Q?u5ycHPNHo3Ou/aNHd2VwYkwQXzeCux1TJpz7vAew8R1OGQoXQTP9J+FhEJUo?=
 =?us-ascii?Q?5SWPhbsow7CzkcunqJfeuNfBugEHsQtZb556aLKW6pCL+NaI4T8L?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ff22217-fd5c-4cb4-bb7f-08de798d3498
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB8800.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 01:27:31.4195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qJG2wZNcH0YZXZvPE/LWYWJh2EsHiMu0N3jfwzgwN7cnGTkwvvZpsqSRJA5D3KC4+XlZiwL38K7Vlhu5R4KnrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6651
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B05C5A000A
X-Stat-Signature: bopndi1csfgnpdjn8whz47ydhxxr9iie
X-Rspam-User: 
X-HE-Tag: 1772587779-589676
X-HE-Meta: U2FsdGVkX1/w2djI1LQsooRI8c6wA5G2aaKgc6zd9WgNxF58uCbOlM9lppqh+MoAhmASrnUcNsFuujrhx2nClRoGDNhV4RlfBjaGn+piDnU59aQRpAVIWecItc2CLt0oHUBAaRMU+XD4xDgv8GVtBmG44L+TzR3+hdP+8twfffODNM2w5kypboSgiY3W0G3WVzgtFTbl/0yUcMohjD4CwEeDYOH9XPRi7H/lX1VPOb2SfkbO1BNqI7rrHER6Enc3Gcd3U45+PN8vKS5WECxnT8UUoiQEN48PpYhQMrSeTxpyUTXhbS89FIIGg2a6JJSe6DMo8mrApiFWmjRR56RIe1XMskY4E3lk8rJzzGKsdDwZkkmhP0/etGKKYnG5MqO304ftW0VPEsRBSg0JTqrTj6zQ40vLb+EJrZP6tq06ENllJLGhsQ7hlyPTjbtLdfsNB/3NW5fbv4EDlaqWpv510yOEu6TnvRJAdgG2Dq+5ROY0mXdzq+q8jP6+malGJHz/CZg9r/PPTh/duAZSB3Y77mCq0uzgKK6dVSIZi1yGF9Ovb1oHcjKL2+8yKFEO0grPoq94C1h8DbMrIOgwzo4xGxkP34tuu2TlOZ8ICOzo7MMbcJpoUlXS3aArZJCePQhXr7w8RespvvOkyQwHBoC9B9Jh72zWQowKWuQNOfcuI/gCn3JfokCISTt3ip1zdTQqp1e6QNmUjfgRmXPWKYf5CXiNheZwlIg8XvnnILgdeuPm5grlBEpM/C46dbBKJkWwwAEQxqa4j9piElKOyrIp9gI85Sq9CBF64VcGv8BAOL5jcZtPbTjW6+hVRlv4f5hV85mT29G0S6tBskF7bjVzEscE/UF6gSHjZD9JUjTxWNApTjRuCnVFxLG44bHPQ/RlDrdMBl2HqgSMYsJACrHaMZNcM99fy7mWyLj6DnFC/VdvYfZb1tX8sLhoBbu4AMqCKbFWhjMqY0bTwxPMLaf
 1VuDne+y
 8HBViifRjKaUJRt0Ep9t/wQdXxB1qbCBxe1nzl8e2cFfNd6QY5BYn/mNcCWKWbua5XOGSIOKvTlQ2GPJRQ6cGf+7TtkVN0nWIs27eYHTeYrBViExjPgUYXREBPUyMzrGy7XKFK80vtIx7KLYcfbTWyWWqvjY40aqBWsUFqqKqRbdBiCB8XjQRsDvmWViIaNm160saDdC2A/WwsqKXMdgVPrpn+0c8gUImzmuQn+Ewamh1h5iqr1HDoyy4kpJxfeQ9v4PbQpelazOLqg2Sbp7VaHCsWe15GiTkTBocUcrvS6uBYGF+490670RHST2X/GqlX07cZKD4Nxaet311zgDFrqeNwgg6WSlxnObq4Y/aM+4+PLmPCTTHtCkgW8N4BSXhjXla/JqVqLDhGNx0+6d/2j+TeEIABuSNRpgwGKDqZBEcGQKf0luUKRu57HPpEveAzxEf/znLU+ggNT0oN5d5NQClnSInHmIOzmOuWnrQB7X97vS4aQ65ILKSD9m1D3VAew8Lu35P9z0+LM9C3QadDquke+oSkaGcf01ZcQMAcT0SfU546x+HJQyqjcaXjEcpZiuH2sikxYhZGYE+DNAq+SBG+daCIMhRlJBFzlcnCq546PHoWZpLFCg5xJYQ3xnEqJI7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Switch SPI code to using the macro. No functional changes intended.

Signed-off-by: Yury Norov <ynorov@nvidia.com>
---
 drivers/spi/spi-pl022.c | 3 +--
 drivers/spi/spi.c       | 4 +---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
index c82cc522776d..78fce33ff422 100644
--- a/drivers/spi/spi-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@ -761,8 +761,7 @@ static void setup_dma_scatter(struct pl022 *pl022,
 			 * we just feed in this, else we stuff in as much
 			 * as we can.
 			 */
-			mapbytes = min_t(int, bytesleft,
-					 PAGE_SIZE - offset_in_page(bufp));
+			mapbytes = min_t(int, bytesleft, rest_of_page(bufp));
 
 			sg_set_page(sg, virt_to_page(bufp),
 				    mapbytes, offset_in_page(bufp));
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 61f7bde8c7fb..cd4a18f3afaf 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1162,9 +1162,7 @@ static int spi_map_buf_attrs(struct spi_controller *ctlr, struct device *dev,
 			 * the desc_len and the remaining buffer length that
 			 * fits in a page.
 			 */
-			min = min_t(size_t, desc_len,
-				    min_t(size_t, len,
-					  PAGE_SIZE - offset_in_page(buf)));
+			min = min_t(size_t, desc_len, min_t(size_t, len, rest_of_page(buf)));
 			if (vmalloced_buf)
 				vm_page = vmalloc_to_page(buf);
 			else
-- 
2.43.0


