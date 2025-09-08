Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CA88CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 15:57:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9BBD8E000C; Mon,  8 Sep 2025 11:57:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D73868E0001; Mon,  8 Sep 2025 11:57:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C62238E000C; Mon,  8 Sep 2025 11:57:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B4F7D8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:57:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 64466B6CFE
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:57:03 +0000 (UTC)
X-FDA: 83866536726.26.2A58880
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2085.outbound.protection.outlook.com [40.107.94.85])
	by imf27.hostedemail.com (Postfix) with ESMTP id A2DA24000B
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:57:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HqQrKfD+;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of jgg@nvidia.com designates 40.107.94.85 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757347020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gLc2Ono7eRT6bURvTS975ofope9Ft8lC0RdYO3+RG3o=;
	b=RgariHn28NmVBoCQDgrjYMuORpH8xwxburFooU8b4Tv4G/p9uHaH8BCEFTOQrDqlq2SdGg
	+xc++g96Zn7y3TI2Yuh6XRIzeg+33r0qa+bLo2q/dBylFKg/WKjj2Wxe56b8fKb8dP0oia
	NU8Rv0e5G69cFAbkhL8m8LAjJwIjYd0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757347020; a=rsa-sha256;
	cv=pass;
	b=OxMAMWtXjVShdEho3iEjp1uPXqOog/tqwJ6D0csTj5NP8fRB8fIpWnxHWwuVREsWsVUwcm
	zcsfKuCVzYSRCGQC1PbNmb94/KhSapLHeTXAiRRYCNmESeh9Qazh98N+iik9+mtw+5xj0o
	V6rlPdcd8O2n3PnlAXwOrzxhgldW5Nw=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HqQrKfD+;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of jgg@nvidia.com designates 40.107.94.85 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NrNvK4KUjRc115XTYlyaTB70haWbVuuuCHdTP3nwZTxXEsK7KOkzhb5OC4P8A6o+VFAnIOagbLUFShRV4VZYgcBBBlCpH6c4S7Ls/4ug5LgbvLRi10hXwbOL3xfZjT3W0p/9MFIrknTyApJOMmSDSK9i71KpGSmXWWSjUPab3GPDKARGJu2etAL2rS2jhAsiHCfS6rHdg4zQCzmfoUp9wfn5d11xoIAw7hpPSH/b/cEKVOe8vHa/4MYTGreKBrCpuX0CxRImNFMc4WcChnfcQB2AtTd9lixqpOXS49v1TpP/O1UsdD1DxnYBmwkXsGaYEv5mHedShXA81fXRlVLuBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gLc2Ono7eRT6bURvTS975ofope9Ft8lC0RdYO3+RG3o=;
 b=qqRh4vMbr4PxZVuhidgcXWfc1a2snZh0W3fEW0uYxv2NJcSV+WWU4j/IzepPSxf++d4QUNMF8dzqZZNeW13RTkWn2Sy2v6Lp76zR2LTwCBk3Pb3cdOiqHc9m8+zEJ9t1VBbiAhJq/kcRJRW0+ZxoW7jAkYWCRMTXe5CDh1U1g7p4gRuBnMC/FF9LQ7Ow6xzt+vVKcV3dVjRgWOxMS0xMlOeYRSM8F53RS6Mk4UGD7yOMwU/Y7g2i/d3GfI10Iwgbz4nxe4W+9JU6ayjwJSWQaHGid1Ec7RPCUMpXWWSeZaXhi1Zj3uhNsh4552Z+3lnxrWCjla0wtsYYW5B6FG1RXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gLc2Ono7eRT6bURvTS975ofope9Ft8lC0RdYO3+RG3o=;
 b=HqQrKfD+PS202Kv8nIvuQiqFgc8K6eKuKeR8+S7qnInGepgR6JWGii9rNvDj9Kuf+bvEMj6IEn38Wc+PpzKbSBCiWWGjsU+4cnXTcfxs/87nBagYgNpEaiNJMn5NtNlrA3CX3NBdIVXi0ps96Np/YBTSZNnZjzem0l3d7VReDxDc18ChDBv8hsmoarLZKm9Kmnp16J3s+uaSO8xGL0f3vHTRRDqGM5D0Nt5jtOp/G4IDcRqDOJx4Q3+wPWDIiZI1CEyLKYFK6cAWNQm0TMVj+pO9V/yxLoy1hkz2cNq1xb/oj9nYnCZ6fKBKnaCZRErabngmn11bXf1GmMVvD7TGoQ==
Received: from BL1PR12MB5753.namprd12.prod.outlook.com (2603:10b6:208:390::15)
 by CY5PR12MB6202.namprd12.prod.outlook.com (2603:10b6:930:25::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 15:56:54 +0000
Received: from BL1PR12MB5753.namprd12.prod.outlook.com
 ([fe80::81e6:908a:a59b:87e2]) by BL1PR12MB5753.namprd12.prod.outlook.com
 ([fe80::81e6:908a:a59b:87e2%6]) with mapi id 15.20.9094.018; Mon, 8 Sep 2025
 15:56:53 +0000
Date: Mon, 8 Sep 2025 12:56:52 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	kasan-dev@googlegroups.com
Subject: Re: [PATCH 03/16] mm: add vma_desc_size(), vma_desc_pages() helpers
Message-ID: <20250908155652.GE789684@nvidia.com>
References: <e71b7763-4a62-4709-9969-8579bdcff595@lucifer.local>
 <20250908133224.GE616306@nvidia.com>
 <090675bd-cb18-4148-967b-52cca452e07b@lucifer.local>
 <20250908142011.GK616306@nvidia.com>
 <764d413a-43a3-4be2-99c4-616cd8cd3998@lucifer.local>
 <20250908151637.GM616306@nvidia.com>
 <8edb13fc-e58d-4480-8c94-c321da0f4d8e@redhat.com>
 <20250908153342.GA789684@nvidia.com>
 <365c1ec2-cda6-4d94-895c-b2a795101857@redhat.com>
 <3229ac90-943f-4574-a9b8-bd4f5fa6cf03@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3229ac90-943f-4574-a9b8-bd4f5fa6cf03@redhat.com>
X-ClientProxiedBy: YT1PR01CA0052.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::21) To BL1PR12MB5753.namprd12.prod.outlook.com
 (2603:10b6:208:390::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5753:EE_|CY5PR12MB6202:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b19a764-0afe-48c1-f96f-08ddeef05496
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iQpIZRgDhZab1adJi+5jTxTwudIarN5wBJ7BD+gguiRayriXtA7PeP0NGC0p?=
 =?us-ascii?Q?Q6BsLbdIHuL5GE1JKipLmzkmFAuVv5zqcFD5TZ1upaSABI7N22mHWud52/Jr?=
 =?us-ascii?Q?COH+I+w9bM2ziYnoC28qXFm9lfzImL9jDQaResPecKO+lVNUMcFQxflJO2gb?=
 =?us-ascii?Q?Ab7Ted9YlBo/0f0C2KNgQpJjtPEOZN6x8sHaC2AgQ7OkXrSurDlLY/gQu82Y?=
 =?us-ascii?Q?XM1NDPwg7Fl3cnYdFkxzUBJtpanTOfGGmaZNLJL5xZznRWtsGtAs+JXtS395?=
 =?us-ascii?Q?rYpRDlAbXUniOSfTYWxIzxtbrPTZ+0r0MO6qXkDOcseGi9Smmkh2Kt2/uU0z?=
 =?us-ascii?Q?EMfPTNxC7c5Tj74YAW3OZMLU/X2wM7FCi7uasd92YcubkJLY0W41WZi7XH6/?=
 =?us-ascii?Q?L/rhcvXL0O/gkwe1UJ960j2DikI3vYlwcoeXpnBLfn5pYp60krTraVMv3L5Z?=
 =?us-ascii?Q?XloxMjbBRE0PLd7lEEInuIiNMEsuTPiwq5zr5gjb3qX/+VQuW3OeunTz/H0A?=
 =?us-ascii?Q?P/3lv2daq28kvNb2jLTJrnAIHDvnBPLD1/MeKi8PggvbmWHotsJqoSuxDoca?=
 =?us-ascii?Q?QNXWSwhOf23OVhjheq+PT3vzcvpcDHVFdrsHD/UTYo22UC/QEiK3on/8TV56?=
 =?us-ascii?Q?PJV8nAr1zHCyh/NcyaZGhu0pr9B5Og1Alana8O8Xja77tM+ML/l0t56Y/leX?=
 =?us-ascii?Q?VeZfW6jh1RtUaihDcoG95e2dGQorEv0V75QaF4p2vLjadJdpOSaZ118RoFrx?=
 =?us-ascii?Q?rGW9sH8IwThg3lQ981dZtPG49Y0oScbSyq0tl86j2xwJvshB2ejw+PuQm7jL?=
 =?us-ascii?Q?fvoV4qIkxxhom+icrOYyzP3olD77B1q1Yoy4nVc2O7EG1zQs1yM64A0Cupcr?=
 =?us-ascii?Q?bwq77yWfCeKuqSv6OPxX+tnVFr96g7SFQq6rwPWD1MMqlE1P354KojUTrLln?=
 =?us-ascii?Q?LP0pubjMq7+EjmUSwzxwgMU3NTWTk/O4oXEsQSm0YqQT0a7gi9DLbx23iWQ0?=
 =?us-ascii?Q?sCYxa/Me50DO/p8uGcvC24s3kGgvc+YPjrkqxuN584kuvTOL4YuMFH1NG0fi?=
 =?us-ascii?Q?gEcvINpRBC163sjPV4kKhhC9IfO6XAYx4l1E7A3Pk5eyj2YMtkCd5AKjBPTL?=
 =?us-ascii?Q?6F/5lRd6siFcY0Lj1YDkJ+0Qm8BzGCokPRIfYZU/aeJEDktdMuF1M9iPkluR?=
 =?us-ascii?Q?zfR4Zl6M0ZuW1tnhgw8svbObEvgZfKkZuDaUq23fJm644aLkIWSx83kHS75C?=
 =?us-ascii?Q?xkxyOSiQ5J1tE0ZnRFhGaMmhB7QJqd6atboSTjn5aJyozszHQk0Hf26BEyT0?=
 =?us-ascii?Q?/Jzi2vg3Kq8EY+CzyfeDSyuOsAqkAhUANroAFv3PnRBnbAKgdwG2eTnupOxX?=
 =?us-ascii?Q?r68krLvrv7xK31Qn2td/IpMBkEWIDCZU0+eaPw4qexoSRAN/40P5h2x5ZIjC?=
 =?us-ascii?Q?0OlpetW7jGg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5753.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?k2WGDM93thqz9g+3ndn+U7nRm8ZHL78l3QvtMK+nI0KQ6Vj38I/0wQrQ0YVp?=
 =?us-ascii?Q?qONw/0XjBQA7b5vEHWrqf459ST7YWjEfE6HUKFTibdeAJltejXniA3UdJ4O8?=
 =?us-ascii?Q?xe+nYP8ACkq8HFwWINThs1CaD5JfhRsTMzfWTqh1ycpoW7bg1QqBpM0wiXCg?=
 =?us-ascii?Q?XfoguX8KFMMFlW9M1VDs7iksK66+BhQ4PjbgILlIUDxfIR2DWRdW9NAtsqjS?=
 =?us-ascii?Q?D5qX4joV7G/Co0lQNv2LUzrQpPmqYOpZKBApVwYRCLPSWLvY7lbUAzP6zXps?=
 =?us-ascii?Q?zKnsIJCPIgzhhhRRwY0JcQN8ab/I7tia/Pp2te9C0tprEL3w183wklfFKLGY?=
 =?us-ascii?Q?8khxcfMb9RA75zbGSr/3mhFIsWts+VYcvIW3+1TwfYYMljJCB8alWhb8E3BP?=
 =?us-ascii?Q?y5JP0OTIuumMofmZe8puahtM5KS0V+dOx89e37mMlSLRlFS9We7cHpjN6cIw?=
 =?us-ascii?Q?wYFKGuxpjzhW1xYW7KXzgOUSqbpKhY94Z8d1epTIXREqDDH1DoyRh/Av8lwi?=
 =?us-ascii?Q?Sx28zNx44ZGjYbTOQdxyFLWaCT5LCUeZC3dRy4kZMJl0GZqJQxVBaUtkqjwv?=
 =?us-ascii?Q?xayz6eIIW8cvDV6flP77twnR7pyk2RZyY/vURyB3FAqGsem9E8pUH1VEyuGJ?=
 =?us-ascii?Q?1R6urMNAFxX0mRKDZhhf6BzvlG/Hy6MrBfUFy8d4GFYRww7zkw3lZsJm1gsq?=
 =?us-ascii?Q?Ttd79gNq2+gkWFjLdR/besbwg+DfxjsuwS0uX4DrbQ/WaZanawl83RqDdS8Z?=
 =?us-ascii?Q?dWqOE0cbV6D0yfYtJ0nyV/OYsKLyXOvirNtCfU1HluaiE7K9Um20GmMminj5?=
 =?us-ascii?Q?B8m7PjVhH1lhui/dCF3MdYD5U1WuOvbVDvXU5XwUHqyP9N0lphgbdxwoboRa?=
 =?us-ascii?Q?8MhV+xOpQ9X/ykDI0II140z0pr1o5xaaI20DglU+Rh0uhBCloHsz1bcQFYxw?=
 =?us-ascii?Q?XSFEgGLsHGHrvUpmFigV3e8fo5VPEoJqeGiRtqHVfNJ9J/y9eQxPcU5yBhf7?=
 =?us-ascii?Q?EPmlj3nTcJRjcjO7q8e2vK0FSkpuGabU3wTFZ4StHuuGvNYocRnulaZSfVCc?=
 =?us-ascii?Q?Cf4KWqC9p2Edi49vHYpe/IExXGAiQHcZ5JNV4xnK7QKegjj9czFKhXIoXq5V?=
 =?us-ascii?Q?sE6E7gB9WOWYWn3UhjPpa4o/mMwlwgxpGBCg4Pw+P2iAeaQvCVZl/qttPdDO?=
 =?us-ascii?Q?YZIwADW0F5A5LwNgv2QKmWBs4nn8P5vk+dKrYA/4JIixON4FVfIwaUctLFu1?=
 =?us-ascii?Q?yxOxguG56ulzXvw7QCpXpgpf8T/beW0p8SX5L17YI9IkiEJGA8enaqiWHwne?=
 =?us-ascii?Q?lgFfgc9oGF2MWaMGX1cq8FpYEy1cPGzLWKBbJN4MvJ0o9EnSePhrUhZMAky/?=
 =?us-ascii?Q?kLHnkYBxnc/rOYMwk0l74Ux3xoZLhR/YSD6918fgBmx9K9JEdL00+i7CXa9+?=
 =?us-ascii?Q?LhZNHSVJm/VTw3Y8OCV+VZ+V5BhhjSvI8WAE9SjQus6R5RJDe3IpgCElSHi2?=
 =?us-ascii?Q?+d1K4HMLV5quOGBmHrfrWHxvi1P83Cxo4cODx/XuZV7dLMMV7+lOknz/00oe?=
 =?us-ascii?Q?lXZ6oBRN4mIDlrWCBOk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b19a764-0afe-48c1-f96f-08ddeef05496
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5753.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 15:56:53.7301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zECQ/ducSeIa5E7VwCdAlvmSlct/BfMSN0JnP1VjTChk8XPai14GelVHKi02FYfh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6202
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A2DA24000B
X-Stat-Signature: 6azxnsn1wtyry3bef37iti9ospq9swyu
X-Rspam-User: 
X-HE-Tag: 1757347020-789379
X-HE-Meta: U2FsdGVkX1/Rf77euBUS3gt1YG4Su4AJIQBaLhgxAdNfebsSVR2j93Th/qzMIzrme+7FIM+4o6drlrI33hqIkO1OZjaXiJMHJN1hb9XG/nrC7uBHBZ6JlUYeD0sgEkdqF3xTsFtHDuKJcIzcJdrMvJsq3AVcovcHQ0JnEIEwr5yKOyvlEbVprvS0boBl3yGZewP70MvwpNjsp1sFBpn1MPyEwQKNnz3WWNmQdL7e0ZyX/CcJ3S8iolvk0AiBqX0VbEEd9gKNk0tyVPdcBTadJLVrxuGXk8VEaRgiEt/Y5hgQ974yBd919JRDEdSgCwOONtDMrhy/rH5d/PAZRcsSi89RdaXa4BxrW86pfKihW/PX19zETiCQn85u6QAG37GuZtqVMJXjCN/bJwF/jv5xXZ/BWIzAuOiBs4S97eAPtScsuaJ44zZdF81iAn1YMEq6ceoPAF0nu5lVI+KzQqsnLLk1yjKPjJqBjzLRSR9N4EDzYKDl4Tn67TMRgF85gy2U/SyIIbM2Ag1uiYS9D1QAQ+FCEeQwrp4vaCyINFNZTE2IzpGi51OCkMNmE5uTneSHofdWcA4aBzCEC+q6NCAPX+cNuH3lhiy+dFENilQPAN3KU17YyGI2q4C2hu33rgkV37T0X/anV0L5JSrKGKKrKG10IREmIKBmosnDRb6GxS4tzJxyn/M8hp1aOPUTwd/8N3JFC/w6VnPSKfIxELvENZ7S/Jm1+TBRBhAI7phMmkizrIcUA9BWMKhPshCjQbEUZ3DK3WAKyTn8ZuKAJpzCSSiDMxKva6sVH3MAfVl9+/b6aTYPsH7vvJMZTwRNXDzIXabipVvNlXtnpzLzIqevePk6CcTKIbEIE/0N5hX7j7K+aI0f+tU8+7OrORvgyNCLHe4xrN/i1klWCMhkqZ16ynOFUI60TtXaHVtzbM1vKFG0Qg/Y4XVgvPR3ya1KRGphWGnkhJf2X6HIertqeYs
 HJ1nadzr
 8odFzapE8mrj/pGsDAqSZb/eQ2WhS+Xf/9vzbzp5hevHlhYuVu4tC8sZc+a3kGTacwKZr+d4shQhb4ZXjKdWLGw0gRiUhHg017HIymFi2AttysyaXWpxH+m8QQHPQzXKHyhy6gxFEFNKP/mGz/bLqNuhqyxuN6eX2p9aaPNddxIg+FXNfSIw9Wx6VS6REjIDCyf0mx9EAczNKdcKZ1BBRyQQoUoMIixFu24eGinLlDD8V3Z/QvzhN8Ql5MfOy2JsfsxJ1wn/f0GC7tLUAk1hrjBFEuIskQdKmOxaYRL/7gG8uA7jx0UVLvY/GAbYesHpB6+TswMrnuuiL/UMuNaFXNT7C70ezvxtqLpPgRzIW0tHkg4Fd7bu98zgzfwfeViQixO4g9NRdDPud2wgWiv5yrczpqTMxX4zUORukJteGaa7BS6F/l3znNpDoTVR7VSorkxBpy45nyFFQD16wxQSt5HyaqfECiiF51f5bJGbV+I7NaXkbxr55VRLHrvdUKk03pwO03LiV0HytCdQaRqY1FYO+oSSN4Os6sc43o1kkNUUIKDUSHUbf3ZWol8ePC9SP1fXY/o5jj7hQX8w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 05:50:18PM +0200, David Hildenbrand wrote:

> So in practice there is indeed not a big difference between a private and
> cow mapping.

Right and most drivers just check SHARED.

But if we are being documentative why they check shared is because the
driver cannot tolerate COW.

I think if someone is cargo culting a diver and sees
'vma_never_cowable' they will have a better understanding of the
driver side issues.

Driver's don't actually care about private vs shared, except this
indirectly implies something about cow.

Jason

