Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C89DDEDEC02
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 01:27:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CC986B0089; Tue,  3 Mar 2026 20:27:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A0406B008A; Tue,  3 Mar 2026 20:27:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2787A6B008C; Tue,  3 Mar 2026 20:27:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1704B6B0089
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 20:27:45 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BC9AC13A91E
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 01:27:44 +0000 (UTC)
X-FDA: 84506643648.18.80F573F
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011048.outbound.protection.outlook.com [52.101.62.48])
	by imf10.hostedemail.com (Postfix) with ESMTP id F05DDC000A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 01:27:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=eBEpHeIO;
	spf=pass (imf10.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.62.48 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772587662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b/9cw4rVtdp7nDwwEt6tY6A4ufMWASgOefh/bePnT78=;
	b=XhimB85l8YY24b9XsGSZlVhsUpw+144gVqLLjgfcnTELELZcrUtjy+G4/fTiDE7GX/FXu0
	vhwVuHPOTxMETxJA62INkjfk10St/iEh4wVopeGFtrT0J/X9KKa25k+zteeT9u+ItIS+qo
	H+IGNT10150TIXK29phgJ9Sq7rpfLrI=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=eBEpHeIO;
	spf=pass (imf10.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.62.48 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772587662; a=rsa-sha256;
	cv=pass;
	b=DqOpQtH3sqZy65+LfNKi20g1MCaqSl5jHvTNdkfhJzjXn2p2+b0x0J4etYOxWmTAibfGpT
	S8HUGbE4O6M4hYN9p4lzfX0xL+NgWJycBUUZDAZJnDjFDfrxuPumqjegjHQGB8s5YpZiGI
	V9w1jYqU2lpAvmfuTOmghUQC7Fy8JZM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P6TZgo+oeI/syCj0K89Lqw/iVCGlbrnb0GosMxKMYmR2n7EWuQou7itMFJ/D2xh1Mnf4AyLISZSKqMxZ3E0cR+iCxBCGm6NPXWhrT/YQ/OWfcdnL5i5uJ1JOyEXubgDgJN+RqUbdfiFoTLrPW3/2O4aeOlw6qeezy/MjQYXvzG5piPBVukrV9n5ySMq6QMPNxN7RKj5Hqeu3r5ZV/1Pg9QWZx3Wbx+kPlKNazdRbEcJ8gC4caazcl8S4OQOONj0UERVtfBlRC0VhQmNxG5jSNsP8ytCtUAMTxKf9QecpVNoKPTiCXj+Vg1Rq3AYNstvLjM4MvukES/+cp/oZjJhKEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b/9cw4rVtdp7nDwwEt6tY6A4ufMWASgOefh/bePnT78=;
 b=jqEVC19h6/2MTph8IbumFi4ofPBD2jbcJXKbZSULPJdHV8iyX7Py2mISBxuAzh/gx/oss8Cf5XmzVwALImk4yai4WTCRLkzkeEEANWFkHTWjBxVdAfp8uPEuqCeujsf92cf4Pnq830WqJXB4CEI9jhDf/5Q74vgaZsX8SjdzVCJnL/HsaJ/wNUuGzhI8e2xKLcXFCAa72f+d9/m5Tqpte9Rjf+OklHSoLZExvoSKh0iPDQCI1/244FUBY/dhfaQQfJaQ9u20Iv0jZAXrsc8i5cNbGfYycA9HWqXowGqdi9HI1npVQoGLU7pyykSfxxfwWgW5qjTg0OmSgZAvQasW+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b/9cw4rVtdp7nDwwEt6tY6A4ufMWASgOefh/bePnT78=;
 b=eBEpHeIOM9IjDQVERlKqt7Na3Ndrd2joTLomQ/4Ka89uyT6w4Ydi36IWC1XGhKT0S+ZD5Tm0hrYDK0fbuF5+P/Ow08Jrf27KLb2ZfwSDtPezeOVGZTI8dEkxp8mc4VX397tw142+t0lHK7PqTC9IiUpBn6rSfF6+F8ron+BTAkpuT8mRv8S9yF1mNEeqEj4ZmIVuoPW7Pu5+jE08lWTHaskZJk1oPAHDscg5IF5rxfid5HTawJiZj4WB1tZsYCDW3KfvSy0cNWPKDEgWRXEBn+hsUbo1LrXZQZVgoiXJgOlHC2vWQeECyJNsvZ2GHeW2J4bsOjEv0R7ZMbtpJUsUOg==
Received: from PH0PR12MB8800.namprd12.prod.outlook.com (2603:10b6:510:26f::12)
 by IA1PR12MB6651.namprd12.prod.outlook.com (2603:10b6:208:3a0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Wed, 4 Mar
 2026 01:27:22 +0000
Received: from PH0PR12MB8800.namprd12.prod.outlook.com
 ([fe80::f79d:ddc5:2ad7:762d]) by PH0PR12MB8800.namprd12.prod.outlook.com
 ([fe80::f79d:ddc5:2ad7:762d%4]) with mapi id 15.20.9654.022; Wed, 4 Mar 2026
 01:27:22 +0000
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
Subject: [PATCH 1/8] mm: add rest_of_page() macro
Date: Tue,  3 Mar 2026 20:27:09 -0500
Message-ID: <20260304012717.201797-2-ynorov@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260304012717.201797-1-ynorov@nvidia.com>
References: <20260304012717.201797-1-ynorov@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0020.namprd04.prod.outlook.com
 (2603:10b6:408:ee::25) To PH0PR12MB8800.namprd12.prod.outlook.com
 (2603:10b6:510:26f::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB8800:EE_|IA1PR12MB6651:EE_
X-MS-Office365-Filtering-Correlation-Id: 91646663-0fb1-410c-8504-08de798d2f20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|10070799003|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	fU99pqqk17BJVt6QXvk2IuF/OQrOb+DohtX6opQBkFEUWcCy3b4bk3JK1L0f85TLXFomh78StXNK4lFSZ0itH6zDsXIyxPZ7J3nzdCGUcH6USmHStqJDYEZvl+hS1x++wVubsSYRGwIVBeokUSNZYAMpQLKZO7z9SRqjPIvWja1PlPuJp87sGMyvK8dQGTtE717gdagFzdtdEVyKgYvqaO1QiRTJESvGLpeL7tv7kt9txETSWKZdShLKVeO43wejV6DbVyTCRDmPRSKZvWtBJUb+I/1r57CiRKt4xS4rFT7WvT01Iqnh/658bMWfc1kxV7DSAO1XZ04WgfWwIi+yeZXKRwnOGwd3lcZiPg23XAUuRN1r8GLosNCUigbfiyF5MhO3kqjVQOMD7OVxT0Qy9QFs3J4y8gVTstGhWI1j4lAHVYHVjvhyQ6Gwp9IaLs3XcSSMkhd5Mhonoyu0awxffzzdMzactv1pt58D+bMBKB8KyGC9oF766vZoGtlguKufS9BM0zmZ1awmEakTCM16TrwiNQTMc2G/VZWNskfd5MdKlLJ5C4O0rfYlz5EjOTbW7hIx2Ej22oSD56QJW4A9SrUvNToK0jmFW2LYUmC72g4CwnBg5m6WPvV9ABdco7Q3/ER6EjDOeyUs6mTdrsCpoJGg1K4xeHSBF16L1cc87q2rI9CxmDdZxv5B6WBIuqSbDihenlq4dGsDmpjy4AOgALXIyJM4vku0KGgJ2tf+eWoFwiCURfuyBllcV2xxevkoVUXdIVSaLyJSwFOhOdSvjw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB8800.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Q9Y/45eNtOTC5hhXD0yobfpuY8bV4TLTzCHMAG/P8tvYRkl8kGT+Nd7eA5/O?=
 =?us-ascii?Q?1iGyhULX8Iq4xoV/C/Bu7bPjW68wTFJRZWXAoa9xSax6haXTJOaao6E4woHX?=
 =?us-ascii?Q?aZC7YNBEG8r9c4HZyhhJv1YnQcu0Qr74EgzNLsQqonM9xVlThd0r50f0vHtO?=
 =?us-ascii?Q?Dwl1U4dQkwFtuS+Zyw7Tk091HNwZkmvu/1NrI2K9z8Z5tfsAaT3lNvl0M5ma?=
 =?us-ascii?Q?MhltJilH4B4osgwEmIpDKFH3ky+PEga9efiSyJVqP/sJV+G2jKKqg9aQogPT?=
 =?us-ascii?Q?jLkg8Hh0BqaHEilvi20YJv23gqkQfLFWq3vs0M+9iY8WXpmT0DJf5px+APW1?=
 =?us-ascii?Q?bNBBgFyCLvfHec5F/m2IplD9DCXYK4G1RVjTLlb9ZaxeXzw6bMBLjULPrmXP?=
 =?us-ascii?Q?Ujst8um9kY8WiCqYQDNYz7N3JZU1KWhYxoxmYBEfDRGEKybh2Flroyz7F0zP?=
 =?us-ascii?Q?Zd9QZ6zxK62a1ebzrPrHFFiG1zJdkGxhOOI5iD41Hp0XReUX1aqazah7OO4R?=
 =?us-ascii?Q?SsKH4CG5b90NCtrMfwIIyz0RcTfy1Se4iCz8BXvar88XRL/PSYqSStqDSpGh?=
 =?us-ascii?Q?yLupESAxb1g/j9Y7qJXLgazSH1FaQU04b6SG04fcgQ1MQ9KdQLAFjiNt4av+?=
 =?us-ascii?Q?+C5rrJX1GGmNJ+t3yw9tt1xWlk66tgCXDcAuTAmbkP+EL01YJs+XWGnLp2HB?=
 =?us-ascii?Q?nxec7rPO8MS+52H1pkmArujIpvhSc75sbZBs3FnRFiH+cmH8hx9zWtI0zCw+?=
 =?us-ascii?Q?0rz/CNb2KwE2/lkVarRitHI7JEcgspxZjHxX1whgepK3NY1GdLdQw6EjN0jE?=
 =?us-ascii?Q?TYMXAASpN24OPEkdiBwkm+6ofuG9UUsOmjpp/Yif7l4EceEZkYAvbTzCwVvx?=
 =?us-ascii?Q?eQ72mnVl3v7UYVIwTAtkOUV+Wci+894cf2iauzJvcV+fnojbb3zvov+BX9YE?=
 =?us-ascii?Q?BGZgQ07mQad3w0jM3fynXmlo34yU8NLVazlcUg+9BaUEBlLAoaSPUuQ2NVtl?=
 =?us-ascii?Q?bkPFa/A5dZ9g0kV4/b5PECTZNkzsBll7iYyRWxiGdcovGcDTOt5m0tcEUFwW?=
 =?us-ascii?Q?L4BlMPg1rXYjXnv+EO5WiQHLRHRHzJUxNH881Jsmoe0o4RCYKAx6PlOdtIwF?=
 =?us-ascii?Q?rIpVH4F0ay6bzsNbXmi49BNbLVid5XHBJbh/hZcFrBXWBGlx6mCwsxYjYVLb?=
 =?us-ascii?Q?XTTeVBWQ2+5Dibte68YCJA2z6NW8fpJlaxSbVKWltz8SLI5Xlhxdri06K+J2?=
 =?us-ascii?Q?e6doFceslyFfdFApmmvY/R04Ew52HFjxWCnRLV5ijSuIALH1Xe30VXd1pILw?=
 =?us-ascii?Q?aWcl/a/UR+/o5QdhJl8Kv5EqSa5E/Gy/EUMGfF3ANOPkIBVW2/Pi9Ar6h21U?=
 =?us-ascii?Q?wbuHY9df1SVeiuoPcCLMa7i+kB1SmP2eF7DKfwdMSLl+8ltTEs7U/3KVQLp9?=
 =?us-ascii?Q?ljwpBiC1LU2uYJWilvNkYt2t/LzsOF4wd66U6Cn2FngAS6S2mPhaWdO+2G0D?=
 =?us-ascii?Q?glPCk/2ElZltwA/B/naAFofSZmB0Z4mpHL7I2bhJTZ0NFgef/20VVd4o8aMC?=
 =?us-ascii?Q?J+JsHkvb5aPAO8wR4yF2wlDgXuh1E596fAuM0pyo1+eU1OOfUPGmt8O/XNff?=
 =?us-ascii?Q?aXAdrIwQd7y8GeoUgaD8igUQRYqbpNYKDywVPmEoi4Zq7+QKHhxXURACdWVD?=
 =?us-ascii?Q?JImA5PCzD6WALDYOQQkOxX2RdKJnlU8LK4M20JO8UnBSsfh+fXu7fpnqmsGV?=
 =?us-ascii?Q?jN+q+yc1BiZUsev5dh+te4LU1syKdI+tMXJ0tWYlC1TZ9ZGq2C21?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91646663-0fb1-410c-8504-08de798d2f20
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB8800.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 01:27:22.3158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tP+vYllAriWEV5CfNanTz+7OCoItPyz0x/RDnguVzEzo324IJjPvzKK15Qg4SElyt5HvhUOM8GVqEm1rSxdolw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6651
X-Rspamd-Queue-Id: F05DDC000A
X-Rspamd-Server: rspam07
X-Stat-Signature: ncfdbg5a1y7m7hqyq3pxoaid1fm5into
X-Rspam-User: 
X-HE-Tag: 1772587661-413633
X-HE-Meta: U2FsdGVkX19KYNwaFnO4u0JkE+ug8COD6sznFLfAUOI2gU7KUGBNyDJ6eDa1h5gta1rAHcaQE79gS8k1gVFjuE02BZyX+hl8tDlii1AmLHWMVkRQqTgKQ+GTREiBvQRlInp+cjVJq+wYnGwp6etGN1yG1U4iS8ZIVavqsVRp1E3kQRmmR+UgfpL15J9bojbJFhUyKDYDU3yumiQ86iH/pRqombaH2XDdH2XNcRFBD/93Uls5M2wMfQpbIlNdE2ZAX8ArCElynYDpUms8GSQ8hYRK4nBzfmsuMcLfjlXxYTYHsi+4vV3IWakeOtqMHbhavwaS9HvLOoIGc84BfKdMzL1hzr6s2lxmIhTehCKRBTdCMLNg78hdS4ielYLPBEYKt8b+uHltJS44capWtHyhoEUyl5773fyfr7non6ZQpvbhT4mgWGnK6eaIhfwNsNrx3bZGkhVbh5Xcf0mMlA61S9lEpKS5RJxGVWgrz8QnpZnjbWMLDz07WNO69335t9mYzNDOs7cvVApM+z4yQuyxtPijzUpOgjJZA4plKnuPUp8gan4h5pPe2meiqDwHJJZ6RlIV19orrvmbuAwHGqxEIwgSTOVUPXSWcHuxgAhXaEGzWIiauBwuq8VhlLNrGw5SKxpM/irgpHrePxwbSCXBrCosnpNNnpk0q3QHmhdX98D00qvjGov+hZ5Ru82xpj5zoZ2OMXSiEfHx6xXAPwzVLnnQefJ+eBlOZYWgzhwGmITYEEjaEnL0qD2xxCTjIQmOxVYA8oG3Lf3nMZAMO8P3BFxX1sLtr1tlmd9YlUWW8ebwEr8o4d1/4/PfRlAa7JdwI9THiM2RFIt56bjiZKH9F2lsxb+w4ZjMKBd2lj1mOCd8YQSZPTxeuVLIOL2sYSF0E+q3rJQ3wJ1cTMEOVuzf/DEsAcMGsNDbGEKF35ncosALepFokbajyCBPT6/Pq/0v6Md/Xyg4EJbYsOqRuyC
 YGhJibwx
 ZdUXF+ck13HTHfXQDTtHWTwWncvlkZypt1VFk09WneFbcDl/JJEpUhjov8SzKq1QWxV3bABhrOlJMPO8toIEoiEE7t1ld9vAIlWurAECMOPG+4SqnLeyKm/8UX4e8NdtfBAf4Ax8KhZNYsswbUET/ctLK5zMLk4jIIplaQm5w681bgcdHlyCxChmuDSkOk3mk0gM9TmqSrS5EzFUtudrpfPUvlo7oyyI2YSNYac+JI06PyvU578CKA5WeywubPjNBNQJTgNNbOeNI/iRGe0IeZCQHxhQsnI3izchujbExSA69VDvqgy5fWjcPQU96rWcjRQL2FO7B4j7A0gjcu77l0SHxT0CF1M4B/+XPtVHBQFRyLaDrSQXIk0q9uMaX5rnllyWOSWWO413PrKMHOrgCq+Kk11ga+OTLVHvOnPMr4JcA4UTQdrsGT/OhVm/iBvFnWw7i7Xa/sDyvJpeSJkADqFbuNdNyqL2t56gu00MKYYes84JniJBQ5IcIHUyMDqzpAlBdDX/BAVdtRLuzdyQrGwGxHcaz0OiE55/v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The net/9p networking driver has a handy macro to calculate the
amount of bytes from a given pointer to the end of page. Move it
to mm. The following patches apply it tree-wide.

Signed-off-by: Yury Norov <ynorov@nvidia.com>
---
 include/linux/mm.h    | 2 ++
 net/9p/trans_virtio.c | 6 ------
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5be3d8a8f806..6d1025c6249a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2793,6 +2793,8 @@ extern void pagefault_out_of_memory(void);
 #define offset_in_page(p)	((unsigned long)(p) & ~PAGE_MASK)
 #define offset_in_folio(folio, p) ((unsigned long)(p) & (folio_size(folio) - 1))
 
+#define rest_of_page(p)		(PAGE_SIZE - offset_in_page(p))
+
 /*
  * Parameter block passed down to zap_pte_range in exceptional cases.
  */
diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index 4cdab7094b27..1ca53209d036 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -87,12 +87,6 @@ struct virtio_chan {
 
 static struct list_head virtio_chan_list;
 
-/* How many bytes left in this page. */
-static unsigned int rest_of_page(void *data)
-{
-	return PAGE_SIZE - offset_in_page(data);
-}
-
 /**
  * p9_virtio_close - reclaim resources of a channel
  * @client: client instance
-- 
2.43.0


