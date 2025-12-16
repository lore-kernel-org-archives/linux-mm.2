Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B1BED5C0D1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 08:10:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC8E16B00A6; Tue, 16 Dec 2025 03:10:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5FB16B00A8; Tue, 16 Dec 2025 03:10:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F7856B00AA; Tue, 16 Dec 2025 03:10:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8AE7B6B00A6
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:10:57 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 448FEC0541
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:10:57 +0000 (UTC)
X-FDA: 84224613354.09.455C9CF
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010049.outbound.protection.outlook.com [52.101.85.49])
	by imf07.hostedemail.com (Postfix) with ESMTP id 61A6240002
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:10:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=TnDfFdfS;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of idosch@nvidia.com designates 52.101.85.49 as permitted sender) smtp.mailfrom=idosch@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765872654; a=rsa-sha256;
	cv=pass;
	b=uGHaD03sqi6fI3Ui6x3bJ+cZHTbXNfFFj9EnbMhezyh6pLPGSTD0If8kRvYEMVRLf8Y8rp
	bkT3gHIniRwj9K723qEDbIQxR0ktEKmkqO75VXi7k5ifDxmwlMDsk75U8aqpDgHanCSwCs
	7b55zQYqmiD9uLIY5CSOI37y50grEy0=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=TnDfFdfS;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of idosch@nvidia.com designates 52.101.85.49 as permitted sender) smtp.mailfrom=idosch@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765872654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ml4hLnysdu+pRUQKE1SCNbox8jlqtOFBVtq8LGX5IgM=;
	b=kJv1Rxbjve1q3U8Ur0ux0i1OnWViAnGqV4R7U+O/s/bkwbd3aS9zRwruy6F7KhaD6X1Lii
	htWNv95uZIE6dw8EkDfLy9kyoBqxPytpwcJhZlDX+xAKqFfI7CP9i5epnBVAoiRC1cctOH
	DERVjBpNa+2aRUWSuNPqto4ZIrIgLFk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mXve7OSXvtv/5gSaMxTLRaj+HGlQauenyDMEKfLQQbCJhvpnPU5Mnk7HWYTejn3+LjIFconj42qi6wP47GjFomeaAXYDouKq1dQixVwwwqGTl+yKXVaSDhovK5dinP6l+ilsz+umnCJcZSoSPROb0wvbOub7KRet+EtzcUVmdABTHV67MAjM2l2ZVUy8qVBbU/qbEESEOliVuKsly/zUSgKdNmCtsiP770L1vc6aT8FcxAMUErz2rAlXKs/zvlG07WHGFusrEEpsk8xjroTyhVwco7pyUS0jqW01u8rO/ECk7KVim5avmXZ8USA2eqGHV01HLcmdxFH6/Ys8E5NUyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ml4hLnysdu+pRUQKE1SCNbox8jlqtOFBVtq8LGX5IgM=;
 b=uXTkU9JNrhAdWziNwi92hy34E4hmxblQSZJf8IoopqE/gpGd3whtIfdLuMeQvBujC0Wu/FQgw7kOeuZXkNBoliyuemsSvmq88iHgHH7NkR3C1j29V3j4/wjUZ7mJwkpRZBUpI18Ehjdc0710javw/4SdZ9CtHMGzxhEoH3MPoYqcWL0Mkum7rNDyaRdsOl3oIEcfmdLRQWJWxKd4+egjc5A/CBZ9X6PdS/9pH6KKKXcwMNhwZOKKpy11beCniaaK6v7FTO5cNa47lpVX7Z62WObesn4EQaIGL/TmyBgJr6j8thQ+5vPNTI/y5dM//FyF5eXlpqOB84x1/FdmrFdbGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ml4hLnysdu+pRUQKE1SCNbox8jlqtOFBVtq8LGX5IgM=;
 b=TnDfFdfSSTqxrPj/D0FBqPGEFLwd6kBkIS4QYR/XN1MUiZZCJMvmdVHjQZu20iUhBLYc538+q0mIIAn+pzKACEs/O4C21Ig41g2R3pRf5fyPMww6ndA8TDL8sBpPOj/U3kbFxl5iztxvaEXJYgDwZqENTmCWk5zqshocAsQmIJj8h6kAKTZv2I2a3bofr3uOq4JSIeVk2BtpI5Vu8qsb2fYjEwl0xY4Uq8sA1H/Ag5XvyQvdLihuHOaJR5+dGnk9kK50VkyIldBFKp6CSBB0kd6Q3A7YreCvZbAy53spmcHk/9lFHycAzoKMdi3NCbkZO+iZNSrhFoD2iuAswGl//Q==
Received: from SA3PR12MB7901.namprd12.prod.outlook.com (2603:10b6:806:306::12)
 by DS7PR12MB9476.namprd12.prod.outlook.com (2603:10b6:8:250::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Tue, 16 Dec
 2025 08:10:50 +0000
Received: from SA3PR12MB7901.namprd12.prod.outlook.com
 ([fe80::6f7f:5844:f0f7:acc2]) by SA3PR12MB7901.namprd12.prod.outlook.com
 ([fe80::6f7f:5844:f0f7:acc2%2]) with mapi id 15.20.9412.011; Tue, 16 Dec 2025
 08:10:50 +0000
Date: Tue, 16 Dec 2025 10:10:37 +0200
From: Ido Schimmel <idosch@nvidia.com>
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux AMDGPU <amd-gfx@lists.freedesktop.org>,
	Linux DRI Development <dri-devel@lists.freedesktop.org>,
	Linux Filesystems Development <linux-fsdevel@vger.kernel.org>,
	Linux Media <linux-media@vger.kernel.org>,
	linaro-mm-sig@lists.linaro.org, kasan-dev@googlegroups.com,
	Linux Virtualization <virtualization@lists.linux.dev>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Network Bridge <bridge@lists.linux.dev>,
	Linux Networking <netdev@vger.kernel.org>,
	Harry Wentland <harry.wentland@amd.com>,
	Leo Li <sunpeng.li@amd.com>, Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Matthew Brost <matthew.brost@intel.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Philipp Stanner <phasta@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Taimur Hassan <Syed.Hassan@amd.com>, Wayne Lin <Wayne.Lin@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Dillon Varone <Dillon.Varone@amd.com>,
	George Shen <george.shen@amd.com>, Aric Cyr <aric.cyr@amd.com>,
	Cruise Hung <Cruise.Hung@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sunil Khatri <sunil.khatri@amd.com>,
	Dominik Kaszewski <dominik.kaszewski@amd.com>,
	David Hildenbrand <david@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Max Kellermann <max.kellermann@ionos.com>,
	"Nysal Jan K.A." <nysal@linux.ibm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Alexey Skidanov <alexey.skidanov@intel.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Vitaly Wool <vitaly.wool@konsulko.se>,
	Harry Yoo <harry.yoo@oracle.com>, Mateusz Guzik <mjguzik@gmail.com>,
	NeilBrown <neil@brown.name>, Amir Goldstein <amir73il@gmail.com>,
	Jeff Layton <jlayton@kernel.org>, Ivan Lipski <ivan.lipski@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>, YiPeng Chai <YiPeng.Chai@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Lyude Paul <lyude@redhat.com>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Luben Tuikov <luben.tuikov@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Roopa Prabhu <roopa@cumulusnetworks.com>,
	Mao Zhu <zhumao001@208suo.com>,
	Shaomin Deng <dengshaomin@cdjrlc.com>,
	Charles Han <hanchunchao@inspur.com>,
	Jilin Yuan <yuanjilin@cdjrlc.com>,
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>,
	George Anthony Vernon <contact@gvernon.com>
Subject: Re: [PATCH 14/14] net: bridge: Describe @tunnel_hash member in
 net_bridge_vlan_group struct
Message-ID: <aUET_bbW6KyxtQKB@shredder>
References: <20251215113903.46555-1-bagasdotme@gmail.com>
 <20251215113903.46555-15-bagasdotme@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215113903.46555-15-bagasdotme@gmail.com>
X-ClientProxiedBy: TL2P290CA0009.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::10) To SA3PR12MB7901.namprd12.prod.outlook.com
 (2603:10b6:806:306::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR12MB7901:EE_|DS7PR12MB9476:EE_
X-MS-Office365-Filtering-Correlation-Id: c99754f8-7600-423a-a605-08de3c7aa003
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qkXm0BjdGAi9VT55N2GLH1J6bsnNuBFCBwMBR2yCqs75pzLJpg/epURp95hP?=
 =?us-ascii?Q?YmOlmW/O/zn+f0hpeky9N9he5zJlc4nxJzHKgvEG7Q0KGzO/dzirkGSHjAuE?=
 =?us-ascii?Q?WMnZo4xaKWnFaxo7D1OBZKZfIRZenW9US7H025qI8cEZ/3DQzldcIhOELmKA?=
 =?us-ascii?Q?osoQ/4YEy4G8pZDXdBy2/947Ej7xXUB3oS68VfUgnhBpx4W3cS9YaVufWGQc?=
 =?us-ascii?Q?b6Nmmp9E8u+P0JhgUtT/6mmOZdWVOF+k4Wi4djLL6lNsNHcS9vhiYet5UU++?=
 =?us-ascii?Q?/DCBYdih5WGqI6s91PMWPrnaadkiGBcCIkX4n6bh+cWYrYOf74UV4knx4NK5?=
 =?us-ascii?Q?hW9I07m5vtwHwKuHYC6GnuEOO9nqMDYuzpALPDEHvaKLJwqYRcqL+Td576Js?=
 =?us-ascii?Q?aKlFrwfFQbH6jqbUcEslnKy46ovXktUB02A25U0RZpUl2Fl3KfeLaMxyjS2W?=
 =?us-ascii?Q?PJ5n2gviNK+d5kTifykm808oKiID98CN8rrtTUltiiAt8Z91Y4L4Yy39n1/d?=
 =?us-ascii?Q?hoLPqGSDWm5teJWwRF0wo2pgUQU4z8bQMzZHkiECN3ZlyM0sIMEY9m3QPHhc?=
 =?us-ascii?Q?3MNp364/b2wsPSlSc4Rww2WmfovQF52rmo4HcX27GNlZ+AvAQJCIpp363TSe?=
 =?us-ascii?Q?+9R1nAlW8pTVanabC5+dgQAdGg4kkcKgnzunxPhvmnQ+9mozeuuByC9Z6lr9?=
 =?us-ascii?Q?SjwZIht8+h6IFmp1+6SyQ8GT4M/PHTkFIRbo8sDScjFCBWkP+MxMQVRFJwNy?=
 =?us-ascii?Q?FjQHtXP44rlUxgcfyZPWZ1lzt7hIzZT4jVxLA5inmyd9ystdsbTCIs68lcLX?=
 =?us-ascii?Q?PMDLBZp4p2NdasmZ5NggNeurU78GWsTPQqp5EivXk1RH3t/at6lFpEP8arET?=
 =?us-ascii?Q?Zi+tOSpetzmFuZrxqc0nOmVq0bq1sdtTnfphk41AbDPhe7m1TSwrCV2OsxLr?=
 =?us-ascii?Q?GZDJjYYCY0BJ6CoqrpXfdzPGc13IPTT1G0AEt/YTJ0GVQ536S59VzBf5AHHq?=
 =?us-ascii?Q?SBX83ugiI1nTcRwd2qC4ncQr6p84RhyAqTTUG7l85anUfcvghLHUStY94ugs?=
 =?us-ascii?Q?l7yyJOxMalgJw43lmrO/LfxcCeN+KNnFOTWRUTM7pyNsPUR7R8Y4BZi6QK4R?=
 =?us-ascii?Q?s3hSFS4R2EO2hHb1Qo6D6Cbe9ICeKDpvW74fdGODR0dljLXduMdRfQ6snUep?=
 =?us-ascii?Q?C4iiLxdLxdDPske0KRKRRQbBHX3ljrWJkcvfZIE+gpaEdYAXfgcNm7jdh0e3?=
 =?us-ascii?Q?iG30ianLApDBUb87dMvNdYDeWDl8N3sAFM3vuxY2bNXbkNn49nJo8HDsRpIP?=
 =?us-ascii?Q?dyng77uq/GtwqnaAuLpwkpype42rXNVv5ZwKgIlRqN44gIjFHXk7X7CvveH2?=
 =?us-ascii?Q?teXf81LuKCRipSXtHR1P0Q2F+w7DF2GZoM8XBA0a87r929nl3qRfj6JPpOzP?=
 =?us-ascii?Q?/vqI651aAm0PksX5cYuSQNeeqsqhFtRW?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB7901.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GMR1rsjwA+mZmoSMlv2Zqg5PhqQvwG8PoT76TB/A7KZed62KBuWIauK+iQUD?=
 =?us-ascii?Q?uqpmWREc30w6mRNi5ZM+SjzSTCLZkPr7JV+KMTFQe6swH7d5vHQ+zf0dpYEt?=
 =?us-ascii?Q?GIu2nHe0s1+O5gi3kbCSy4YVOPvlhsWt7HpXf05B24SpVoI+noihEmsQWPnJ?=
 =?us-ascii?Q?ILZaQm7+mm3b7LyanIN1PbEQTmA3+P92L90GLscWYjn7YmX2SfAEZabSuwST?=
 =?us-ascii?Q?EjzvPmwUggnpTDt1TC2ihx+at7BwZdyEs0eUyFNvKGwjXTz7/hC62JXuJQg8?=
 =?us-ascii?Q?XoUrra5DhVrRL3aw+Hddml8cPqNRCa5l9abdCYsXe0uQo1F2O9/1v5+zNlNW?=
 =?us-ascii?Q?4DU6Q9xKfxVXNzYRGLxrdf85/q7erU9E21eZeE7pGRzOEY/mhnaCk/75vEkt?=
 =?us-ascii?Q?QH1OpHfZit7YlGftmEmS7aEiqIjnFUPlqF98rweJ3l/V9DIfjuXuqAJ5PBj7?=
 =?us-ascii?Q?UnsqzCJQp60swuQ+qy2Ba14FIGUlM9BSBOiyUNormsAzpmmzzoaJDu8DQxAu?=
 =?us-ascii?Q?L+16lHUrWCg+mkcf+8lciTm7bpaWrqbBsmlpYBILrgRtdngKMchSkQO0CPZi?=
 =?us-ascii?Q?F/oYlyxHw4x+R90OERWWufHHpvkwH0A3mL3LllKG39XTJMaoFNWxT8w4mB0z?=
 =?us-ascii?Q?i2B5+voSnM6kCEymaC867AKfDsXAG5sK9R/9+kV8HabwMYND7BSw8/38zRqF?=
 =?us-ascii?Q?DNSAdyi82jDhA48jTTCObFQLoLfQVODKyD1VAzp1sCn6CT6nONj/DTK/H0uN?=
 =?us-ascii?Q?Vx1sQS8aiEG6QII16LPjMdpXowgqN77vM11t+g0ixxdpZRTBWBXOaGDdW7Fd?=
 =?us-ascii?Q?dx2gNtLpzxqMWhz7Y43E6QHY5HzYiiSgThF8JzGT6YeuKjNvQRAp4SWC3CUr?=
 =?us-ascii?Q?tnfcoFBpmqJZDOps2W/r6TJ6PWJw337aiqNbSXw2b3eg7F2K0DS/2IS4kRXv?=
 =?us-ascii?Q?YQV6Yc3vwaT9z6yvPk4kGqcZsou6p1sHC47KJm3mLwVaJscJAk1ciDNvRNU4?=
 =?us-ascii?Q?vmiHRt4ek71JrydTLI8KdF07jnu36Sr0WPFWVjCcdGBLQtbsQ31Wdezm0ecI?=
 =?us-ascii?Q?JhYsNwavM2eC6zIceUUh6fzAx463Pt6R1+pO4Y8FIPVTvnBRry/btE0aTsB7?=
 =?us-ascii?Q?82aUOmogWVosQj0I10Z+Pmh/pS1bd5H+IBBhirjKJJYFmmXvqquDHgdx4KJ+?=
 =?us-ascii?Q?hiFN+omF4jz/iGrIrIrbOJpICy35rsfB5zJy25Kh5B/niJnHDoJFc9LHwBnh?=
 =?us-ascii?Q?U2PFkdA1AfchKfHeOL4THF2tbpnjA6eLSlpBovdzTLvMRm9yQTpXhycJJOPV?=
 =?us-ascii?Q?D2uTb0krBVKe6qgTZ50sCTfhoI3YmXH4JfAhXVsknrQbZyygV6sab6SoBwCS?=
 =?us-ascii?Q?/5FDPaa7Q3yttccbpijFvir4egNbEwBU9KOM5w5KWM+V5JIEVz5ZKf5pU99s?=
 =?us-ascii?Q?Ud465tArDFqI/avl1KA009dDNBLcOjYElirDsKEl6Ye3S1O1texnMUWKO11d?=
 =?us-ascii?Q?frEIMFMUdr6tjl00pNuvfiyGoJ5yWrAlXM3Sddfs6wLYPs7T0SV/2dhN1HKF?=
 =?us-ascii?Q?ny1xJLWxk2w+I+uF3fEkAqZW+bWWRVolqxRSdDKC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c99754f8-7600-423a-a605-08de3c7aa003
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB7901.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 08:10:50.4122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Jn1GRAVl7fWR6i2nOitnqAdyxeLG+agMppQMoqRYGdALbOZFDDkQLF4Y8PSVW8MdLCtX3o9nK8w98LWXl102A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB9476
X-Rspamd-Queue-Id: 61A6240002
X-Stat-Signature: oowqua1ju75radoyz538b1x9nqkbb6g1
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765872654-363770
X-HE-Meta: U2FsdGVkX18xbmcErLsA/Y/ENdJZIj0BgWlF4x3IoICkfxUDHwveoo3WP6iAU+cU05Dj5GlYVEKjiUXc7S6eoG0bbjdsqZ8a+dbD0qRerse6AS9zD6WF7H0n6H9gMnxR7F8ZYdbGDqvIBTHORQ6/2L0e8Hw+KjXcG4liNYTzVkobywCzir0BWpqkSTvQTYzucTzDHi8nK+WRO9kxkiu5H7jh7TUQU6r+Q6P5iWfoZGkG2NFVIGMR7LydHG7lod9rSAcYN0cE4qMAlREY5lsmqoyyf8EvT2zUE5cnDdNQJxawmM0/XP0IX1w3LsAd1P8i2CmPxz+gromY6f4tfA9EAgtXaTTD2mIss5tuDG94PGWh4ucrr3eLdG1une+eo+u/EefxL9eJkB85HTr1BGvo8H2No13Icu5F6LFBmz7Xs61MVKTqs0KgJu5rISvglf5og5Er9vCIjaKcofg/mGyjqryV9zs3R0HqfXV4b0K7D0nGFVDoV1b5HL3Ysu0UyIyLaCYbDEN6HQRSMYVP/4bAramgylk0sTrwGlFUuhR0pJtrTah0K5HOQyEcly/YbntbPXSyx+AvbXUicOpmZ03Atz61k0y5gEL1JRWmBd6LNGvGr73temPu1NPbam9GMUQwW8OBlPdeZVvPyBwMgnHpJ80hTfLSqXln45jybt3feX8VO+LoUcBnAqoDwsYRmzEr1Jf/FrldbwnuMeIwvfJmhfUA0QAkr9MRThdDr3fhznciuA6tbnCyeYRrDO/91VK4jjknDcr/1WUdEJ87kKMuUJyW9DBaEd6fit7k3bufHut+WWXx3IzcijQ1osYI2SdsP9XTQvirZH/EaZk/hZPOzDuYdKOcGwOMRIR7ITl7pHmrPK/JawJ7wKWVAWxvweDIXwd92UHXP3DH+txfHbPMjZnk0wrcOYYug3BCbuGIDCS4dhSBkD6MxAmWhxbo8VqFeioT2i2DEYBfEpQE2QF
 h2vk7vUf
 5Ta3OjTq3R/KhsBBjpdEdkIUBbMF2oEXb+vK23CY3PHB3DKJEgCDsCWgeawzfAaHczAUaRLDi5x7/8Uhk6nhmEafg4duRK7l3TDR8qJ1grtMZr30h8pN/joNJWZi9Icu3mO6iEsEEyS96ARCsBACbK00yanMj7aGdMlXLZWP4F8T1ASBvuqwmUJeDP67dULhJV/caV+Lzd2q0ITTkWoPpTeWSnNkyiR5SjbRqCvSnUhO/rUoVnT+gcWOt6Lz12xAwjEYXBjrC0Zswig4/AdGCtDT+1nOmSC/QOVstP7UFEgdO/fYu3dyyGlpFATpHkL01GOd+fBxdhL9SHVveHT4n87unHqnAhM/vSJ8U6a1Jo41o2XEQuMRlEwUknRN8ImemgZJtCsY7YG3cYQge14i+iHiLYAN7dM5fmnlsSsdlz1BFqe5oR1PIhadkMsX6zJcS35QCv2tQNj06FJpl+wjXQHj1rIAmOS8yDXqE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 06:39:02PM +0700, Bagas Sanjaya wrote:
> Sphinx reports kernel-doc warning:
> 
> WARNING: ./net/bridge/br_private.h:267 struct member 'tunnel_hash' not described in 'net_bridge_vlan_group'
> 
> Fix it by describing @tunnel_hash member.
> 
> Fixes: efa5356b0d9753 ("bridge: per vlan dst_metadata netlink support")
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
>  net/bridge/br_private.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 7280c4e9305f36..bf441ac1c4d38a 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -247,6 +247,7 @@ struct net_bridge_vlan {
>   * struct net_bridge_vlan_group
>   *
>   * @vlan_hash: VLAN entry rhashtable
> + * @tunnel_hash: tunnel rhashtable

While you are at it, I suggest making the comment a bit more useful.
Something like:

@tunnel_hash: Hash table to map from tunnel key ID (e.g., VXLAN VNI) to VLAN

>   * @vlan_list: sorted VLAN entry list
>   * @num_vlans: number of total VLAN entries
>   * @pvid: PVID VLAN id
> -- 
> An old man doll... just what I always wanted! - Clara
> 

