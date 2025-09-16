Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C597CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 17:40:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A21A8E000F; Tue, 16 Sep 2025 13:40:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 652178E0001; Tue, 16 Sep 2025 13:40:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F9B98E000F; Tue, 16 Sep 2025 13:40:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B6428E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 13:40:39 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F0D8E85666
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 17:40:38 +0000 (UTC)
X-FDA: 83895828156.06.B738ECD
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010007.outbound.protection.outlook.com [40.93.198.7])
	by imf06.hostedemail.com (Postfix) with ESMTP id EFFAD180007
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 17:40:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pL+P+FqA;
	spf=pass (imf06.hostedemail.com: domain of jgg@nvidia.com designates 40.93.198.7 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758044436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZuOm7RAr7ULO4gzMgfQKYRi1nq8gzxqXtlxew6kKOQo=;
	b=gHkjDDZ0LxmieMRLBCramJdhlKPWLX5K2GS95yL8f8lyYJ/mT4g7kuoTIFW3OLKVlcoEVY
	0fpFdpF/LPjd6ZhTTAEf3asDawaCh+TwzsjGaD216xx4ej/Sy+YA8WYc/uFnJhnu1lEwuF
	3iBZ+6M+zIXHbvxePq2f+8wUdV5azUk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758044436; a=rsa-sha256;
	cv=pass;
	b=UHOhzBFZFtZ1647r8n5vGXlhAhcpgr4PkqvrTPi6MYzncYqgWZsPg8A/Rov0fCCrmQSmFX
	nQ9oyO3rYZ+wUBBgNq0Xnst1nyITMobaF39tuNVLkaPGwPbYQ1wrE84/SGEIFtr6LD8ZD3
	uLENYrl3/jY7h2PVlZpUWTlN/zcdmAg=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pL+P+FqA;
	spf=pass (imf06.hostedemail.com: domain of jgg@nvidia.com designates 40.93.198.7 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rBgA4Hg1sov6XB3H+Dyfkvlo7JctE9hLSbuhC8CrcDy8EskXn5GhheflqXaJOPIIQnLZouyNmxxw/4j6hyowcGYFEI5+hYJZLIje1pk+UF9zzentynHBmMdbFnyhbbmzYNPmpqOqHkvrmifn7k5Pj3j4uHsYocT/Y/Zsm3KmrTIFOIVJ//KFKh/lEcNBdGFUfwi3H9i6dC9N+jxeOBnV6Mni8VXm/I+oEtdM6QP4w46LjJmA/P0OzxrI3nXo1Wqyl4QSgtYFam/9SnTQTuzvEXorsufvwF+lm9bvmgkW+zoUGZKkpelolwX6QcXutyxA5w/3DI/aJdLZ1kj860WrjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZuOm7RAr7ULO4gzMgfQKYRi1nq8gzxqXtlxew6kKOQo=;
 b=pI1svxL9HSDh2zpFj5thW+L5LeO3yInWM8Pm3ZEaE1qDTGZLdl3GlNN/NUJAWBlvtzP8rwpR2RqIAFzd2OxFWN0ZbilSr1ff0P/gSqBj6hxPx81A9GhcpC0/+43D0ld+ASSKjwcLqOkxKkf+d/fsuXzkpZQbCK7EPm80YzhFVnuMERV0w5WqkIqvDJgJD8DFDiB+Zlo3wilkscj9RcpIO+oW07q0z6PX8eAxfMaq0Legaok08aOzo4E0DdIyaPt8DZXknBs1nvQXG8xgK7OsC0sPQn2K5rRQKW2GCQNoyMulAxMpN/Upr9OioJpEDE9lDADlmPel+WX12Ej4p4pPXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZuOm7RAr7ULO4gzMgfQKYRi1nq8gzxqXtlxew6kKOQo=;
 b=pL+P+FqA4e8weWctvjgQmF5DeRLa7lDJs+kQDw9ozkIvgIcivo5dXnjRBbzGCOIjDUgoElSg2R5xDeoXcDAGty818IvqHI1Ln1oiSG5xrC8IKbEK3cW+im2StQlqEgkpucTNVezqBRTbMWGbuupWJOhYdZQbUX5UeuaO/0i2iSlUnvZXxLXx1CRQ4cAn1YW0kqK5VWGMF5YPwqjwLDibBOK5ny54DvCIlGX/6jjPHMBuT0ZAUgrNxEeUL/lARePwu9F+HITq2wvDcuPku5xBStes34mrBJFsk48Dvnm3xWb95zDaMBrfywQ2dBLY/3HgeabEbtjagllpuU4SPKyBHQ==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by MW6PR12MB8662.namprd12.prod.outlook.com (2603:10b6:303:243::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.23; Tue, 16 Sep
 2025 17:40:30 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 17:40:29 +0000
Date: Tue, 16 Sep 2025 14:40:27 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Matthew Wilcox <willy@infradead.org>, Guo Ren <guoren@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	"David S . Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Nicolas Pitre <nico@fluxnic.net>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Baoquan He <bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
	Dave Young <dyoung@redhat.com>, Tony Luck <tony.luck@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Dave Martin <Dave.Martin@arm.com>,
	James Morse <james.morse@arm.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-csky@vger.kernel.org,
	linux-mips@vger.kernel.org, linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org, linux-mm@kvack.org,
	ntfs3@lists.linux.dev, kexec@lists.infradead.org,
	kasan-dev@googlegroups.com, iommu@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v3 12/13] mm: update resctl to use mmap_prepare
Message-ID: <20250916174027.GT1086830@nvidia.com>
References: <cover.1758031792.git.lorenzo.stoakes@oracle.com>
 <381a62d6a76ce68c00b25c82805ec1e20ef8cf81.1758031792.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <381a62d6a76ce68c00b25c82805ec1e20ef8cf81.1758031792.git.lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: BL0PR0102CA0050.prod.exchangelabs.com
 (2603:10b6:208:25::27) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|MW6PR12MB8662:EE_
X-MS-Office365-Filtering-Correlation-Id: dc7453cb-6f04-40ae-ad89-08ddf5482099
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jOUMyQKJcTwCYdsu4ieFTku4iJqky1IW1515otgkTCMR3Nulu2xlCmYl2GuV?=
 =?us-ascii?Q?perHlBRyjVXKAYyfHD8j+RYUx7HwBqIDB2+UCx8N7JTfGsV55zeq1yFEmYKl?=
 =?us-ascii?Q?zrbuDHNLkbxTlFxUDHh5AzdXnNFth7HFfhkBFh2W2ld12PBk/EaqToEPoj7V?=
 =?us-ascii?Q?ZwFyGN9NEB1KvqJ0jK/iQhvPihUy3shU2WSlsQG5H8+f6vv1yyJPfgpDPFuw?=
 =?us-ascii?Q?aJvfHhL5XxCXAAMtgkrCDYkL5/dJQ/JSPzWZQPCTX8hwxsV8VCWQReLgqRz/?=
 =?us-ascii?Q?LnI9ZaLz3bLihFFzD3kUexAp5/U/cXbPyesZCETCtc+VRGtVgBM9zNm42LNB?=
 =?us-ascii?Q?YUf2LQfQH/E5pBMYKJwPyrW4V1W7arLibPi3mlwuoKT/UY8iUitBCSfjRrp4?=
 =?us-ascii?Q?/AJS4WJze4ByC4jHHE5h7PSj3CMtl6ddXsfwXBmvqwFf9vxdIvOCjviW00Qt?=
 =?us-ascii?Q?JREuFqFXYXCuM+UMaEMBe/sY+bLDOjhAu+YQzn8v6lkR40yG87oJYrLlUqnU?=
 =?us-ascii?Q?DwSY9P1msB3BcTm2ACSAUNlWUAq+sw+s+K3JuvcBDIjdRM26lEL2W/Vnz75x?=
 =?us-ascii?Q?LpMX4yDek6g8NPrGJzI+7GkpBTlZqKFjvPDAp4Ow0IVwQT2jqn7cEUXichmN?=
 =?us-ascii?Q?AlWuAtHZarbinb4T+taQENAVyKVLzrxY5lI1PaephN3RLtLnxhogMVqikQRs?=
 =?us-ascii?Q?+B3fErB3c6CzS1wm4NT341tTX2T1CrC+B0oq5pVwnOyh9FuRnc/MCg5e66Gs?=
 =?us-ascii?Q?QDB19EADO8pqIpZ+KQmPmup5Mw5aSsh7bGrzkhqVfqpKfwg20Hjco21PCz2Y?=
 =?us-ascii?Q?N+Lo+M7XSkNiknUii7uFI9yYTv8uNimfGDZEfVdn9J+ICf5iOSAkYrMb31Pk?=
 =?us-ascii?Q?VngNHhjloNzwaJTxlJetD+a3pevZWqlfQNHm1+w00tSvBFqYj0454W89TOfq?=
 =?us-ascii?Q?fdhwkCaHiWUlaeybq+r1lRp6UfBrS0pcYN7dpyEkIMWXPdIlYxJAjHmec0+H?=
 =?us-ascii?Q?sa0Ot3FyXkMRZkgrq21mGaaE/ihvhyR9g3RARJoSU78mTB/j18WPTR5mSFt8?=
 =?us-ascii?Q?Llvo7oKLWZU0eKyUZSJgnysBHlm8j/2TcvFIqFrMVzEiIRfpw3DxMK0jVbBG?=
 =?us-ascii?Q?bvjaHApP4ZJWU3sVOEcxsmsKOT/3lmn1D6746m2DXaNNXahcluVUPgU6unwx?=
 =?us-ascii?Q?kWdx6j9I+TZD8ZUym16BfhhVi5cHwDYroOTx0JmMogs4N91VOvcjWOmr7oAH?=
 =?us-ascii?Q?la1QkG5s178WMJ17M313E7VE0qOYpYOlQpBrV7is+5OlV8GTkBL3VnbTlMgh?=
 =?us-ascii?Q?KOLIQV05gg+cv/AUgidDUkFYA8+UsmOv+zADids3x066mL+6bY/TIrB+P7YU?=
 =?us-ascii?Q?FqNPC5ARTJRPtL1kQiNgd9aTaHM87MPb/yb0akdXrZhniriT4Jz9uCyTaalx?=
 =?us-ascii?Q?lGLQGziD6Yk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CdpyjK0FiSO0J+4AX4wH6kdK1JYSjeAeAvwt2qL7AVcAviDeHpcE0eYtcL7f?=
 =?us-ascii?Q?VwLGjYiaD/dsgPpMbM2gV8BqW7jewIv2Gd30wv7xr0arAMTsQLz6lzsMorOr?=
 =?us-ascii?Q?yd4WHtQjqpBrgXkz/KCkevpkZmpCTkaNYuIfRlv82pmvLM6pyXc0ctaYNjTT?=
 =?us-ascii?Q?KXdcLHpmIyUDLqPUtX0QTxsjHoImJ3zy3LPC0Ef1kLV44WHEB8vNLrjgOFaU?=
 =?us-ascii?Q?Kxogre4cvLyBlu2L3TmT6Zuvl9TrUw+9v/hpWZr1r3HDA4aGqXws5B4CVOTz?=
 =?us-ascii?Q?OztW3L+ja7dPX5y9k0XVY7AwZK78D6vmhU+gSTobMFncPBoaaE+oTaFJ6GzM?=
 =?us-ascii?Q?UBjaYBkSXPTaPV5ZvPFpWLvnA2sLaq3PYrxVhw1E6Np1rng7PjdhSw7OqxYt?=
 =?us-ascii?Q?ZagYNcwxnt+dST9ixQgqAqykkaHX9OBlKBzmzDecgglj9kO/xbflURn90yJk?=
 =?us-ascii?Q?c50zWdrxXyic8rlAcCHY0NL1LKpgkMJDRlTPYYEJVHXU3BRPjnCidj7KrL2f?=
 =?us-ascii?Q?BxcX1FlDAFGzIUJ7Std2wLyx87ysuGgApVFBmi447+yfOeSpdzfsxsh/Plax?=
 =?us-ascii?Q?3caNoZ24khup6xUoRtMO5xO2Ub5DEEEriqbEhG1+vYY2oar5bHIch7BE/599?=
 =?us-ascii?Q?Cg16b3jQ9qQ/G8ihfBTA7Z3a8R+FhZNxzrN8AkU07Coj1cZf1sMQupIoyb+v?=
 =?us-ascii?Q?/A25rsnft2gHcCK9Le2ZvFxp7YUCoDQBo7WDhN1h8YX5hUm5yEE+lAjQlYw9?=
 =?us-ascii?Q?mdFBvJ8nxM91J6+7cVGuU/et4zXZsia2Jp6lHHvMQf4NGplk7qAqTtgyoQQo?=
 =?us-ascii?Q?kdU2s6FYtNAoflX+FoVdAeyWEa1kvwgL/g5EW5T8r+0o/zeQF9JPI3u8Myqk?=
 =?us-ascii?Q?ePWMSkMI1S0RdFz40vdWUA2vUwZn47bNFw1ZT59ggqcn+JIndx7WAIsl3w2A?=
 =?us-ascii?Q?bAQW0gCSCQD0iSlUkNND6qlHqvGB35EReLqdbIZGh8D/xkM9WG6VyT/+180u?=
 =?us-ascii?Q?2UBKHCCcKHO0vEGuq1Ra3NZo3x5BrM+4+StGDNftBk+GQyzSvffKYV+Z72rG?=
 =?us-ascii?Q?SO9f2QHIqSy4aVugJtjHN5g92IzupR+1thp7+1VJzRNWUxaMUJXp3EIs6/Uk?=
 =?us-ascii?Q?SFEyEUXIb6U9jSy1Zrr70CE3jIchUnD5VIZBLYNV+yHids0sykOSPzJXWK8q?=
 =?us-ascii?Q?WqFdIGc88XBsIw9F0EUmrE1tI8fX/RTxdlXnRAV1kYMP07DTT7seLTXtdsQI?=
 =?us-ascii?Q?1PGdbEfJz5e+Q3rsJn5Ca24+WtbMsUy97akAzcgoCXODbLqY5WLPM56OfN/s?=
 =?us-ascii?Q?y1uJW2PvU2hrP6IRXBQTD8NbkHGRnrIibC1d7p1Ds0dD+Behd284xxaT2bjs?=
 =?us-ascii?Q?7YFQf7qYa4vn1HEVvywTuxM7d7UuKx2FxpcwvchRhrrxYaz09wIqPxH1FgwD?=
 =?us-ascii?Q?RNivrQLaLHsYUsHMnZ0uno0FsTpaWFbu3MdEBo+ljf1kiDNxzkCfELA3qqcn?=
 =?us-ascii?Q?T+rcTTU3Hs6Gi/WrFiP4PtxLAAUmK1xCrKE2Q2pWP48heB9w80O/4NORamka?=
 =?us-ascii?Q?EziSsDQS2XQWnUrAMyVegUfIQFZEEWgGvM+JlH8P?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc7453cb-6f04-40ae-ad89-08ddf5482099
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 17:40:29.4783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CrHnireU+CQRAOmXYmtBwasgYF3N3WvN3x5h2upeCasL8XWg26inook7KFoAIqHl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8662
X-Rspamd-Queue-Id: EFFAD180007
X-Stat-Signature: 73nu6f5rp476jhtphaj5pj7de53aaakb
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758044434-79760
X-HE-Meta: U2FsdGVkX1+7GL6Ahp/+zAyPkzi92kh4ii098kLddaSZRfv0bvVD6sObOxHI7WQPLYAt3y2WTqO3CV2n3mZtMVYoTSDeE6JNWrikry4klTDVI/APfRjQHY4eXak1Gtoz/4qogJ/PG8rTrcz+m8AMnPrsw7KhoXQzU5swW88XBdPlNIA7wRMkL2W4YUtwfIW76qLRjpBNc9zZv6XrHUXk4QebmFvYfpV5UtbCEi4u0xnrXfv+BK7T9l633QMbGocmNt343gjtS9Xmwe5NCgOyQWef/zqwg1Kpc8g8Z6As4oojhxSQyThmo4VUwa7MUelsDCFD+lP3De4vXOFs/4aI6zMjves3RvGutotauXy6aohrSeI5ekMTTtWwg/ZCHtFy6UMnZ0R8jD6svzRhZ9PRX5wzIlH1c6Po8duT1/gBgZ2wQ3AXMF5nOTkK7NqeYv1fI8pzOdTUd9XbdWiR1ocL6yxtwfISGsDll73aPfWaKObxegD7+uupQwyz1AtjSoQq/AXEzUSQMK1h0qnpTDSjY+rFkSKiDJ712FvPgWys1yOjvruj0gz+XZ6aFs/397DqUIM5uzBtvFr22Do5HG4blYRLkCTzhB68GjkpgcGLWgp5uM42gZuyFcZZX76qeyQPnUWpcWSQMyxV7/tIcjk0f8qAVj8jESy1/DXHx4BNnjHx7bBzSCJtXcmWFLjFYyJf4D33lHHZpeJPFaTBwKddV76TLg1PvZqZ1eQau9nz50peOQ6+B6Qqdzr31qFSbL2qb7HmamczpdQc2HlLOFuHceki+QOH/cLEXMs25SzTpJaA+8fhmIQ8i1PafidtEkICQRgWgOGlGWKc4/Mttr56oOv+k5fD3fmTrg0dueYGoyhHsqA7l8zstuE7cRICzpkQksI4EJDOBJjIuzWUvu1DRqLh1SwpPcSzqiYgQGVgURIv2XSJdA0gx3UCgnXSEKXrh5Js8s8uWtjd4gXX2WB
 WgdvfdNa
 HKYXTECjgwcuxjNxv4/0q9TX9vQ3Bde449PDidXPdbwKnOHCOsZ8N+JwrGLruySQ+pWAOs+ISXsUsmcwBdUmLxOmqgtUozh+xEg/7OxMbPtVvVxn709i7fOgsJsmoYQ/UlGBCmKMdSafdORsQHQvqaUw8A6v7LjcSD4F48YkatjC77gQayqpgdLPpHDcQUdgVzctcGcC1LuWpsN1eoDS1BVXnD+14j6b/H1lQXF8RBYkd7aFGCsK7X+E9xZgF9y+hs8t+cQgXbDumfGosFhmVPiXspdE0uSMTWYuHNFf3FCJxv/yoJO4vsfPRGo+avVPEGZd4wguNWPOKrjZMwtngPJLlLM6f55QbUoPG2EMoj51nZhtrzM0sWhHZEQfg8SykZiSRj9Uutpt+A6VnKzqKtbuF/o95EXr5o/kH6vkS3Hb/bu28m5QXP91tzOe2m1y/o8EYNxlN8TJqNk0NlAaIS83ARdET/7265cL0M22q/vjuEHjEmayeEb3CDp5IrIS9Vc8jTGOFreVMeXH/akm24oU5U6wJ0WRr/0/bbm9pihYBHu/vuK2YBWY0iOJYB0uuAPyAG77WAMD2e60Na8l01mdp9+dGWafGzW3+jshu+AbN2BgOwFT2Q/FI7OFQoQBcvgRNkCtS/SWabI2+PV1tQm3L2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 03:11:58PM +0100, Lorenzo Stoakes wrote:
> Make use of the ability to specify a remap action within mmap_prepare to
> update the resctl pseudo-lock to use mmap_prepare in favour of the
> deprecated mmap hook.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Acked-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>  fs/resctrl/pseudo_lock.c | 20 +++++++++-----------
>  1 file changed, 9 insertions(+), 11 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

