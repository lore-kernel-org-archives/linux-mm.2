Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5357CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 03:25:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 421E98E000D; Mon, 10 Nov 2025 22:25:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F9718E0002; Mon, 10 Nov 2025 22:25:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E8F38E000D; Mon, 10 Nov 2025 22:25:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1D8608E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 22:25:53 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D110CC0372
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:25:52 +0000 (UTC)
X-FDA: 84096886944.26.D4CA7EC
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012030.outbound.protection.outlook.com [52.101.43.30])
	by imf08.hostedemail.com (Postfix) with ESMTP id D8CEF16000F
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:25:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="W/h87OjG";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.30 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762831550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5INBg9jNnvIMmN0NR8lVODCaHdgNXGPLmCTUuvpExa8=;
	b=zUma7O2+Ue4d4QGw3iKXa6FQTENgRGJhp7Samc4MHnZuACFSYwQhXw4yI+RkJ4M8LVIJqt
	mhWdmjZ2uGt6hv4GWMX+3zGbOalPZsljYBxuSdfN3dQl9CL3Q3WDluxArVg6l6dWnq0YU9
	0T2Yx8s9PxPWJDhSWDrbep7ipNOtI/w=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="W/h87OjG";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.30 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762831550; a=rsa-sha256;
	cv=pass;
	b=p1AsZvxjfeN7JCJ8Oz+KaPorUdF1ybjNMNHf0OBowj8U18JA3dgZjTGERqjeRHxyLSnL+c
	mypviYi4y9Cj/XvbdDNlbwpoIVu36rf1Wh19gkTCQgvefhEQXcM4aqUwa5xmDVAH1dXhQX
	hWJ1kRcmEF+zPORWmZmqzTgCZRJbBiA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=usRfm/7IGRAtDBTinuFHpXCu1rgHvKdvLQUpWZuQV3N8qLzK7Fe9Qhu/fGNLZVtuZuNhPco1W6um/o9wvO4JOvXK8Tr4x4tpVL/bjyzcrcHsjnKaNDsg7ZkRid2lrNJQ5MM4+v3kUVtMgVPUxzQhmfM+Kx7djjmezF9fKYA7qEd1ixXZ5VHtKUgSDNTw3axlHUzT1P6PdwlgO2ptsnASIv+pWHO7iag4uLwLvaIZ06s6pGHtlcDdwPR4fb66MyLtJN01krRh3gkLChw+PxHlP4DwR+i/l7IcMgr6nJJkyw5syG2pr4HQxHkRa/yBXNTM0knbPQehzuffwRmjOvJOTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5INBg9jNnvIMmN0NR8lVODCaHdgNXGPLmCTUuvpExa8=;
 b=mnRDQDS99dLo0PCVn/se4wVsGogdFkx4DgCIijhR93UvUU3Ulu9eZmi0DXi5iqvu/6UduCMlMi4kImTIYdI/lXCB67ftTeI01N5i76mRGR5yj+qtCA2PZHoU7e7s5dSV1/5V+MeRqBYZVU1HWuBC7nBkCCDGzfYM/uwUa4gNyxgDHYmhniUOwuhkK+QWiplsX99sbn1sLDw/HLW/PFZ3Tezo9/qJjy/XgRs4W/+Qxhb5Ys02MicCy7lp75KRCHoX9vVsfjXo0+bmI+XUrTTULoMsFWnLjKi2il+7l8NbZV2YrJzmvzHGJZLa4RVNHweZcz0+kSBgCE0ZMK26X1KWQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5INBg9jNnvIMmN0NR8lVODCaHdgNXGPLmCTUuvpExa8=;
 b=W/h87OjGyLYKzzql5iRnFjFH0RzuvCpmxZEk87SaxTvnZNMLJ96chyPw0urRkbpSNmQhvtR09bTMBd3UbrnkoymesS7Bi1DFsfbTs0l+QDxfIFkM8D3i0dsCL9vOurw8HMU4PZxkM89XHKyPCgxTWHPpbFOhBD/Vwr/G55wQVFozUTbf+rKCAG+yysaIl91X39X5VEFxdlI2UK6EbTO+YMm5ogtBJj1BLScEXOwIXNJbpeNxugdiX8s2nzTGS4S8Bi2OkQxo7f5MNe/Bk3ScR9Wg0jNOsCO0xasQmZxUDPwvgtVIrgO0KQc7T2lJIWu5bjM8D1PGjF6bn5uNpgp8vg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN0PR12MB5881.namprd12.prod.outlook.com (2603:10b6:208:379::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Tue, 11 Nov
 2025 03:25:45 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9298.015; Tue, 11 Nov 2025
 03:25:45 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Arnd Bergmann <arnd@arndb.de>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
 SeongJae Park <sj@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Jann Horn <jannh@google.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Pedro Falcato <pfalcato@suse.de>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry.yoo@oracle.com>, Hugh Dickins <hughd@google.com>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-arch@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH v3 02/16] mm: introduce leaf entry type and use to
 simplify leaf entry logic
Date: Mon, 10 Nov 2025 22:25:40 -0500
X-Mailer: MailMate (2.0r6283)
Message-ID: <CBBF1711-5881-4B5A-ADE6-1D86C0E94296@nvidia.com>
In-Reply-To: <c879383aac77d96a03e4d38f7daba893cd35fc76.1762812360.git.lorenzo.stoakes@oracle.com>
References: <cover.1762812360.git.lorenzo.stoakes@oracle.com>
 <c879383aac77d96a03e4d38f7daba893cd35fc76.1762812360.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0439.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::24) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN0PR12MB5881:EE_
X-MS-Office365-Filtering-Correlation-Id: cfbb3817-367b-4c2a-26cf-08de20d2005d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gAIge3gskcRqDxzv5xi4+a8G1uPZYkJm6OO4w8+hQ+BjJh14JpOhDWPkTZia?=
 =?us-ascii?Q?g2q1hBE6JnJHZphSP7mlvcaxfQrLLTSGaMxn5OKyt9PGj/DboD6Am9mD7A/G?=
 =?us-ascii?Q?35ttTb52bpVUEXif9zxYO2X2w59XEjH11UOFRZUOdsdP+J73bWcriVw9km8h?=
 =?us-ascii?Q?avvdFDQFvxjgduuix0dpCbNAFKxSbhgzKHR8LkCK1dqmH21XL3utL22QjaMW?=
 =?us-ascii?Q?E9qlJOKvXOn8Bg75aI84ZKePBwKqbRgI0GEXfl7mjP5aNQynyqii/0S3Kz18?=
 =?us-ascii?Q?IPqHSsAeLXMqpeDT0R05yOEJ8j1wJ6pM+96AVqTtja8NmT7nJBJ45qKXYFDc?=
 =?us-ascii?Q?U3qYP/M4z6m0S2Hp4KyjyF7bllUAIpuj+WaCjqO+nDnAQDTvKE07fIIIsFH2?=
 =?us-ascii?Q?4DCPWyxvGJW6M0HtwHqZEshqViEVFcmyHSyPjj49d7hu4cy04F/zhs/HZDVY?=
 =?us-ascii?Q?bgfbi35Lndvsmd3tXakj7wyw/41Vf+DZ3KLzDbVNA98daVcvK2+IQ0xwPjzt?=
 =?us-ascii?Q?QdDFbOtSI38i6WK3pEC9Ir7LjZ/gfc8JoAIVkWGustU/AMFkk/30+jw5X1Zy?=
 =?us-ascii?Q?HJHZT2DYvwlNInWdfQ0xPXSZHKALVV7OZJ1OKR2rTAvqpB+jI+l9vPLhZLqf?=
 =?us-ascii?Q?pUGv2ANs4NkS5cDidx5jy1oSDBwM7JTy57AcWYtk6ifRsElVIs7DNyS0AuO6?=
 =?us-ascii?Q?63YzEia16/CEWmBjLw5Y+Lf3LUcX/PUFqaiVt7igZL/hbyBv1OTHr9d/2hmR?=
 =?us-ascii?Q?MErWmpjrQQ/3WoginnvfiYoxEOVfbOP1clueXE/wN7MT3RByNpJ2QRAJitbP?=
 =?us-ascii?Q?AtkoLq0i2qsVktJ8d64dEVMi8Rdu+Ststy0hnfyc1lT5wv5l8FUEn/S9CnsR?=
 =?us-ascii?Q?qm8O5yimHYrRSR6Kb2J+xTOS+nylhGAYsfKP3Ol+9QtU5/jbHEy+AQKfyA5G?=
 =?us-ascii?Q?+VvzysnxzURL1GsUAHoOnVq+39w6gyXLZuvDUbBS8CW04SdN8Nwh0/RbzMMh?=
 =?us-ascii?Q?Kl9278pq/IVHti4psf+zc4r3moZyYhnioYErF5f0oCfRSaVZjFioWazZ1dsG?=
 =?us-ascii?Q?IuGvg7CIaTBQVrzrGTscvGL6dywI0bu9VlCLJJu1pzXI0d5VHL4nD//Eu7ub?=
 =?us-ascii?Q?GCrH8F691azfKIPI+rEfrDTWaihW2kHADW+JV615olZz2AICr3kEMliXCPZ6?=
 =?us-ascii?Q?HeSPmtF3bbaonsSVr0OwD4zI12l1dSbTwhX+arFVTCOnvYcjZqeTKKF51mAQ?=
 =?us-ascii?Q?n7i++oYFAle5rqNfTIrK98rNztTmW51vfElaJqmd5lXngknk6nQUuJgIxyZh?=
 =?us-ascii?Q?rpyIkcWN0c0enohUQ4ub8og3raVU0gPCcpCN3rwrmHGyv8R/DlqWN1/5piGc?=
 =?us-ascii?Q?nkrrdP4JL2+vBF1W/8DTKalJj7yIEHlQOdtDRIkEnvg85qvOa0HT1J+usZdB?=
 =?us-ascii?Q?C2+ReZ9Vmoi/w+N/Lh7ObE7JX7WQ17F4?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wXaFwKf5XzPLP1TGuWDOyNKkfs5VoR4hygRbt7PBa7jYBhlta7TKzeunihjM?=
 =?us-ascii?Q?VXgfNGPO13e62+QjGOOX/nvx4zu89vsUc3gisn2euZHEu8BRCX0GGB2Nyd8K?=
 =?us-ascii?Q?Z7TsBlbilKgMWRcxnDd6dLEYiPrdKkLw5E3HXnUeQujc110oIZu9QRCGFGfo?=
 =?us-ascii?Q?VQsh2dWfnbN92QjI71J7NOSupBnqqeIfeVDuEi3a7ArGYqcpQvySOHZOBVrk?=
 =?us-ascii?Q?kzavHnqDfsLIPbkXJtGNQ698h2H66xQo1H0RqlhxwKkoTOZvlkBgUIhwSCUJ?=
 =?us-ascii?Q?z0EY5sCplqt/jyJSXO/UsJVfeSAWjn1ZPMVCEYj9Vn9k5NDj5N3cjfrmtYno?=
 =?us-ascii?Q?diC2dW8+pMjeu5oz8PeRMbWNaHeZEGKCWcs6oxAEKsdWgJTCZNW6A6Fk7ZlR?=
 =?us-ascii?Q?8Bw4EXye59VcIPXRwzdEvb0+9J2T+SHXwGAuuaCi5YNMZK5G/egzy4FoG7a7?=
 =?us-ascii?Q?ssJekc3mY+hu6Nf+H3l5KbMUqlrPcLDAH/URIoY4DRgnBMMgtyqfrzbvEsSC?=
 =?us-ascii?Q?MW04GUrMOScZLBarBF1Qf0cBairruYoKVnPeUF0Sbomsxy2FbMjydb8eHsLs?=
 =?us-ascii?Q?+Ps6wQkZoAUfFQWErjTEFvFS9dllHtqHX35L8MVxPXcuaCRedZ5WFHtO/gb3?=
 =?us-ascii?Q?ABrNtU850PlQwRksnvxDcyfl91iDFiz7/nqcg6oyObRsE3Gj/SEZV8NbIRuC?=
 =?us-ascii?Q?vY8AW6yh9g/4fGlFhsS2nxzXzXZeRgk1RWFCgJfpRDYF/mX8/XxuWAv+cvjz?=
 =?us-ascii?Q?i5dGJC53FZzktFRFWPqpBuhQoj4/kXoMQUjSVRLgBq6pHTxPHzMRnPV0kSRo?=
 =?us-ascii?Q?OAGHzU9FBctamdGw8zwLAgN4DNnxhSFJt6xsh7Fh9NvZb+5BvRfqbo8IcNIi?=
 =?us-ascii?Q?Aj4ssxaLMn55TOy4tWbdyhXDfbYfdCrLEPEDznus3jcqCqqWFMDISZWejf47?=
 =?us-ascii?Q?XVB+FyqsHnMityUdDKaH8U5GkzDcckRfgLjF72m8aDhb8PrGaWcLX0gI3L5v?=
 =?us-ascii?Q?IYaG4V526yKUWIDrk+yodY1TFeG4xmof+nAwb2NZg1Y3+uKqg0Rj4/ITD5Sm?=
 =?us-ascii?Q?saa4pXAzzFqM0jCBGWvX/FCxRGDgQ82ufgQxo1w/hE7iuXq5IoVecgL+hfk1?=
 =?us-ascii?Q?n0zPJW2P4C5x9LBR3pq5pHr/MrHFS+QYL0N4r6A7xCSHagg0befqwtmMFLn+?=
 =?us-ascii?Q?ZD9cqU/2ZY0FsOxe3iSVx4P9XWwGm/kff+dX+MtdwxkoQUY+1rnrAUEl4PmD?=
 =?us-ascii?Q?EDCzb28IWbQVYKoVu0QOZ4WVOH+F715LRmHWoi1mzdAZ9TWu/1BtcxxvJxGP?=
 =?us-ascii?Q?4cvyLIHJE7I3LyrjKWmFjS+PouQP6c4c8ggf5XmGlJPmY9XjB/ywnitZxbaf?=
 =?us-ascii?Q?fQhwZ3laSAlleox2aqTGRTl462MiApgyNajweI4zUqEHHrUHZtunL82xIsJ8?=
 =?us-ascii?Q?0VERmbeudrEXSoacWBEAOM91+M3upMCdKm01dezvMwbDzOVTLupDzRqyDZM6?=
 =?us-ascii?Q?4IJmiIpOYgDqIELMxYI6wjV4YAvMhEY2kGXVtXcEi9MEVzuY8r6YIlOZ8r8H?=
 =?us-ascii?Q?AmZ4EUUqLX57Gznj/zgPDtaqbXnjNPgjXpJp3JRC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfbb3817-367b-4c2a-26cf-08de20d2005d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2025 03:25:45.5971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eAAdXOF4E5RKnARcMAg+R9tax9eeAsQA897Vpu7k4Lw/d0KqVfeGXIPmHUjZNTh2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5881
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D8CEF16000F
X-Stat-Signature: o6iemw1gjyftrjyamtzuuc4joai4j733
X-Rspam-User: 
X-HE-Tag: 1762831549-10773
X-HE-Meta: U2FsdGVkX1+L14ZyZG+bSfWlMz2MqsKgGBfEQUcL+RZfUf9Vvjz1CFhfA/z8Z3K8lPCCkiNuRynkqqyPDTOQzMSZlSMFKlHNSpApXotHwx04v3xkv9E8lPPdC3Nt089+PsW8bk8+o09mQqlO02tICBIuTNPptsa7IgAzFmIpqtWJed7Gw0M2drIOmi8NWrYnzYCl/U28T2XYoNXN04dUgsrnBH3tlAXfRa+JKm+D1idetjrfTJhxtg3/6HiexBUTlLHhBStKgfj+TGNUFPsAZQaLYYqE9LgstGoh6gkC18i34lB0cNjjWhFhqOX07MLK3nRmUkuIW6saZMx8xRe520UVkBpeEsZ7LWAdXm5Lh/XeP6x8uXsIZKnQyXFoAWMvRezTGRsTpDA7Zg5O6QQTzo2b+nrmK+OwVDM49F5FxoRBqJUErPhPnJc9SXcGtDIGesFZxAVcvHM4WKnbUYxj7hWqmlHdk+QBSKQw2bYPactcirysd6DDq2BV6H1naZM2ruhVYp69WT1KiPVJ4vRfF8DJZ7ZwmQm9cfC1qDTaz+G1KmyZk/hC8USnduRoUW6MnR/QpaDkuL0brs/VLVbJPiEx6QHLcD2tyJEzyAS6lSV9baXzKogUs+2FNtPpeqC5YF9cnGEJWn7GBnp0LnhejzUg4/ieKStxRDu+bgTwPigzbS0rJTEJZ97yj3gVk8ojyzCapWAtldK6O9jCQvh5MJOImmEdoG9ce8N4vT/P8Au4krd1zkGDxMwbGdV/B2/P9BCBd2VFvdKGQCy/EnR6CADYPyIBsibEDzgg4Lh+GopGuizixh4Q/un1vxse7kTpXlnhAUVwaC6LbeTR3uhIPLOYfEt+Z+JkpBpv6woSw8UyIwTGNNYScqh6lqPN9azVI8rSa7Gduxvtz8k3tooxHf4veE2U4xM/L2vp/cbhzxgjNGAl5yQjVPMpsADLju4L4Qk+1xpj9nD1MqpYPnJ
 HXX4Yat2
 XjMTI+WRevkKjPVTuagnpDGVHBAfI2bm7c/IcDuCRX58+WYbTHxS24D7sViHVXbEh0TTxLMgcPO5H5jCmOl+9/7xiol1Fve+bIACi9acIs5AgmlJyx0PLh7aOdJf19sRUceuhWhv3O/EAOiM2cePiMMCSCEkfaDxmVqMzZj3B/WeYkRxjgOkb7JwqpUfqj7yNwecARL7C6nOsSYTLXKkzizXpP65ZHntfsD1v0sjyA+I+3qAfhUmhd0IbX/iXKND8xvEiAxtZS35wRYi+EkABG6qOnf/0LM0VaFe0wtpAZ96HPOtZBz+BiEINd3KBPZQkCSKZzWkyYeLESRWnKC7b9ZZTOM+cx8DXoturmcHZHFXlLrDWz1Pxk1wJIwBqhmOio9jJuZUlomxWk4EsB3RtOHnsja0M1dZEhrAh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10 Nov 2025, at 17:21, Lorenzo Stoakes wrote:

> The kernel maintains leaf page table entries which contain either:
>
> - Nothing ('none' entries)
> - Present entries (that is stuff the hardware can navigate without fault)

This is not true for:

1. pXX_protnone(), where _PAGE_PROTNONE flag also means pXX_present() is
true, but hardware would still trigger a fault.
2. pmd_present() where _PAGE_PSE also means a present PMD (see the comment
in pmd_present()).

This commit log needs to be updated.

> - Everything else that will cause a fault which the kernel handles

This is not true because of the reasons above.

How should we categorize these non-present to HW but present to SW entries,
like protnone and under splitting PMDs? Strictly speaking, they are
softleaf entries, but that would require more changes to the kernel code
and pXX_present() means HW present.

To not make this series more complicated, I think updating commit log
and comments to use pXX_present() instead of HW present might be
the easiest way out. We can revisit pXX_present() vs HW present later.

OK, I will focus on code review now.

>
> In the 'everything else' group we include swap entries, but we also include
> a number of other things such as migration entries, device private entries
> and marker entries.
>
> Unfortunately this 'everything else' group expresses everything through
> a swp_entry_t type, and these entries are referred to swap entries even
> though they may well not contain a... swap entry.
>
> This is compounded by the rather mind-boggling concept of a non-swap swap
> entry (checked via non_swap_entry()) and the means by which we twist and
> turn to satisfy this.
>
> This patch lays the foundation for reducing this confusion.
>
> We refer to 'everything else' as a 'software-define leaf entry' or
> 'softleaf'. for short And in fact we scoop up the 'none' entries into this
> concept also so we are left with:
>
> - Present entries.
> - Softleaf entries (which may be empty).
>
> This allows for radical simplification across the board - one can simply
> convert any leaf page table entry to a leaf entry via softleaf_from_pte().
>
> If the entry is present, we return an empty leaf entry, so it is assumed
> the caller is aware that they must differentiate between the two categories
> of page table entries, checking for the former via pte_present().
>
> As a result, we can eliminate a number of places where we would otherwise
> need to use predicates to see if we can proceed with leaf page table entry
> conversion and instead just go ahead and do it unconditionally.
>
> We do so where we can, adjusting surrounding logic as necessary to
> integrate the new softleaf_t logic as far as seems reasonable at this
> stage.
>
> We typedef swp_entry_t to softleaf_t for the time being until the
> conversion can be complete, meaning everything remains compatible
> regardless of which type is used. We will eventually remove swp_entry_t
> when the conversion is complete.
>
> We introduce a new header file to keep things clear - leafops.h - this
> imports swapops.h so can direct replace swapops imports without issue, and
> we do so in all the files that require it.
>
> Additionally, add new leafops.h file to core mm maintainers entry.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  MAINTAINERS                   |   1 +
>  fs/proc/task_mmu.c            |  26 +--
>  fs/userfaultfd.c              |   6 +-
>  include/linux/leafops.h       | 387 ++++++++++++++++++++++++++++++++++
>  include/linux/mm_inline.h     |   6 +-
>  include/linux/mm_types.h      |  25 +++
>  include/linux/swapops.h       |  28 ---
>  include/linux/userfaultfd_k.h |  51 +----
>  mm/hmm.c                      |   2 +-
>  mm/hugetlb.c                  |  37 ++--
>  mm/madvise.c                  |  16 +-
>  mm/memory.c                   |  41 ++--
>  mm/mincore.c                  |   6 +-
>  mm/mprotect.c                 |   6 +-
>  mm/mremap.c                   |   4 +-
>  mm/page_vma_mapped.c          |  11 +-
>  mm/shmem.c                    |   7 +-
>  mm/userfaultfd.c              |   6 +-
>  18 files changed, 502 insertions(+), 164 deletions(-)
>  create mode 100644 include/linux/leafops.h
>


Best Regards,
Yan, Zi

