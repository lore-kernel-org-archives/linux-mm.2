Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09C7ED74EDB
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 14:20:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F7976B04D9; Fri, 23 Jan 2026 09:20:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CF406B04DA; Fri, 23 Jan 2026 09:20:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 087586B04DB; Fri, 23 Jan 2026 09:20:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EB10A6B04D9
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:20:05 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 977011AFC58
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 14:20:05 +0000 (UTC)
X-FDA: 84363437970.20.41D5C68
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011030.outbound.protection.outlook.com [52.101.52.30])
	by imf28.hostedemail.com (Postfix) with ESMTP id E0CDAC0014
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 14:20:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=el7vGzH0;
	spf=pass (imf28.hostedemail.com: domain of jgg@nvidia.com designates 52.101.52.30 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769178003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8JTaNeQL/J3Ep2HYkEXMoLwLL3wNRp+4crnhYhLek/Y=;
	b=1D42E/E6PZgBkf2wWDiw+PZ5rFM4LKv7i8SO6Wl9zjr1sw3CsJ8yCGxsxUJOVxcNz5SB+P
	BNigzwMNag3KsP5aHOzXZ5NEfmPlMQm5cRuMnQlo20S/nrcA8VH25VAp2r36N7NwaRoIz7
	8PiafHeolRZOGJ648/j6fJbc1w+yw8M=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=el7vGzH0;
	spf=pass (imf28.hostedemail.com: domain of jgg@nvidia.com designates 52.101.52.30 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769178003; a=rsa-sha256;
	cv=pass;
	b=vAS6ADQc4E0j1iJFD8+/zbKFmUtyCj8NY06MfBVQ2fA3+iuhWj9cCM8nGXuDVufXIt+XFE
	DSkXG+ZZnOPH1NdVwqSQxvbdI++UoNp/USZSN6WXLo+Q2s7Y/ClEXIg/99SXcAfI19eNt3
	rMzGmsjFx62hU89kYm/rNnG4UJTAz+U=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p8SO+JMQwEqTjgmDXJFNi5nW4kAIjY8jCG5P2YqmLgqJtGPSwmQ97KEhq1smDrxbnfkytcqAumb7fet+uzf0bLzymVRudDYNILai0Oo21EDpXjWjcUGNMHTBxrcx0cdC8abjmHvfItou0wn+IuuOvqFnrmQ8CqaefbzzIWazYIZRHgcgBS1s/KtbvXeb+/jIbBPGdpBF7vWoYe0J1g+XZi7RDztgEy0hsE6BnI3jNXKJV4CJlAx3ntAPp2Ufw+dUA3ZfXZ7o/Z8CjVpTfXI9jiJcY2GFu6H8YYg0NMQaMXNSbSnyqCAZdxd+Y139M0MuM+NAvzNtQcSVZzAkqfcJnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8JTaNeQL/J3Ep2HYkEXMoLwLL3wNRp+4crnhYhLek/Y=;
 b=WWI9TKBqw+QuSVFM6cFcAeat8S9kEBp8qIwozYnVCf3x8MuVBfvN+QcSPwxXLAX0B0HgXEZKj1wYWRfOCCJus+6xNZq3I0jzt13TeD4B2GxBxUtkA7KC1TijfJHlJ8HGYj9iG0lLC1aNcPQOCZwHU2iFfvo36ezvb4Zr8X8ih2CwcIxWuPKWhn5wxsiYjJDWO0sML3QiSrS2ndE7gZQXVviT6lEXKcukCdVgqVoHkTVhBjS2XfddnRxGYMoFJJAVCq7lU94aa4tsC+LNgAiDTM8IRLhuNw3p38Ba2Q9YfoopU8PZOL+hgl5vtKAcbhNO5porG2ZPD08VeQLkEr3VQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8JTaNeQL/J3Ep2HYkEXMoLwLL3wNRp+4crnhYhLek/Y=;
 b=el7vGzH0seoDPX5Tseb3Y+Y5unxv8q9f7dXRrgQhQw/B4IPvWeX102ztEeH6hBk7/Nk2ULkUVW40DjMCnBaLYq6iBZPQemb8MbDHPnh4dLQkNSLAMCBRFk4ZOQYvH9wZqteBvYFHurH7z9Q2GX5ZGZbZ3BYgBmeaI+7czXnUr3f2xnyTd1wDAWeNqO1ZxUI+p37Qt2hQzmFUUyKqyjcEGCyEGgqIQYJ+PiDDw12M6ZNd7lW1I5toQuckiSySBNFBEhIZ0g8GKp9EbX1cb4NhcQwzq00acVO8Y1R4/mo8olflCqQaJSvWtHtP1tZbCHhZQmKRylxM+dBFjWmadu0Cbw==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by BL4PR12MB9481.namprd12.prod.outlook.com (2603:10b6:208:591::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Fri, 23 Jan
 2026 14:19:57 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9542.010; Fri, 23 Jan 2026
 14:19:57 +0000
Date: Fri, 23 Jan 2026 10:19:56 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>, Matthew Wilcox <willy@infradead.org>,
	Alistair Popple <apopple@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Francois Dugast <francois.dugast@intel.com>,
	intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	adhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, nouveau@lists.freedesktop.org,
	linux-mm@kvack.org, linux-cxl@vger.kernel.org
Subject: Re: [PATCH v6 1/5] mm/zone_device: Reinitialize large zone device
 private folios
Message-ID: <20260123141956.GZ1134360@nvidia.com>
References: <4k72r4n5poss2glrof5fsapczkpcrnpokposeikw5wjvtodbto@wpqsxoxzpvy6>
 <20260119142019.GG1134360@nvidia.com>
 <96926697-070C-45DE-AD26-559652625859@nvidia.com>
 <20260119203551.GQ1134360@nvidia.com>
 <ef6ef1e2-25f1-4f1b-a8d4-98c0d7b4ad0c@nvidia.com>
 <EE2956E3-CCEA-4EF9-A1A4-A483245091FC@nvidia.com>
 <20260120135340.GA1134360@nvidia.com>
 <F7E3DF24-A37B-40A0-A507-CEF4AB76C44D@nvidia.com>
 <20260122154646.GQ1134360@nvidia.com>
 <1EA077E1-DDF1-4356-B8F8-CB13F0D6D8B5@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1EA077E1-DDF1-4356-B8F8-CB13F0D6D8B5@nvidia.com>
X-ClientProxiedBy: MN2PR15CA0064.namprd15.prod.outlook.com
 (2603:10b6:208:237::33) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|BL4PR12MB9481:EE_
X-MS-Office365-Filtering-Correlation-Id: 6790f142-049b-4a0b-522c-08de5a8a7c95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XfBziRKFhuczKRhhH1F43GrarGdbnQ8CbriBGShPP3aaqfOFTq86iS/kqfmk?=
 =?us-ascii?Q?dU77II+Q7PPlwQdir7YxXwlNSVQeSMJFcsKuyUUiDi251J3btSOubaqIP01N?=
 =?us-ascii?Q?nr0FZwOWq7+TUOyxvX3CyLJr/jF4oCMLuRNKkjBzT1zKr+g3vKs7nHbrbARe?=
 =?us-ascii?Q?VyWyg/w+h5fea4fgwg0ReNn3/cqVEitlAgBcUJfZo/Aubhy0OCPXYZkbd7Ln?=
 =?us-ascii?Q?km0mMbTxA/agzIuVEjWWtxusUzGdgmxg575Sa93ZxaTSKPIRDf+XsYy3cssy?=
 =?us-ascii?Q?ynSfAHdt76Wa9T26ZRCtbl4/kcLRvYmHRYDg9YZB8V63K0cjWJBchX8IOYtB?=
 =?us-ascii?Q?gG2APC0B4lKJrvmi8v/AnHoiRgZvgL/NBwBL+DcDfFtL0fJAD4qoLI4tQNX+?=
 =?us-ascii?Q?GNYdaOiABCG8kkShjIaKg90rED5KGeEgFymzqBGmuyUoemwcIoDPo420a1Fv?=
 =?us-ascii?Q?WvCyhMxk0Am5w18G6KBdg2t5iIrP5U/ilKBhXOSpGtm/ljBZ2mW6uq8z4baI?=
 =?us-ascii?Q?JgNba3Ig1Lck2fea1iib83mUaXlIc5Djc0FUCJa5m9GfhdZFywLOdxj0uIHY?=
 =?us-ascii?Q?wt+bKvRiMgs3UD/P3HoFw6Rs2Kd7WtFR4GR2tGdl8H/EfkhMfe5BrEsRGPuu?=
 =?us-ascii?Q?9g+ky4S3Ghz+lnz9edIPao10It3CfnC/SI/ScXhDuIf33F8b7aLGKZCHQJxH?=
 =?us-ascii?Q?6R2a+MqR7RFgMDzeqKuaV7KbfLlpomVXIhTo4YYLgMwlbQuiBJ2Lt2WNWZsg?=
 =?us-ascii?Q?7CYBrGGbJ20+r7FM4vLCr3cMjQ3msOYmrTub7AOjqurKBFRcpEZT1BKiZ9kP?=
 =?us-ascii?Q?XK6vxoHoxkrrmfdj5gXASOQdx5OyEKShLYsqsUoPq4Ha6YJmob01hgnZgO5k?=
 =?us-ascii?Q?yQeLodpOIghNI3q4BfphZqgKKKwmNj6bnJr310LEmNaPrjE64bZsD9WAx6pK?=
 =?us-ascii?Q?QBVLGeDYdj3KDV3JXBHZz2Mf1t9J+M+iSl3KCEsG1KDyIahPXNcqW47XgoP7?=
 =?us-ascii?Q?mGlIWUagkpJ+VHUdWSFBEIQXxfSYIuBHdAh7JO3sQH5oo2kJmjW79TSP0H5e?=
 =?us-ascii?Q?GvvZn3JvrfkAkWOu0weSljQfUyflvmpCj3uW2JwBYBo8AwrbdJXShBuOIaIU?=
 =?us-ascii?Q?RanVes5lUXk8qM+998/vsi/Hub2YVt5blAyw3AHPzZzDXHsSWveHj5wZzZWA?=
 =?us-ascii?Q?3BHDhIMrH8U3cEcpe1coArAf0/WVX/qkTmr3HUsEEsNYaL7oZoCYikdSzik+?=
 =?us-ascii?Q?l3EzjqMScWwQIB/ZJQnRKej+uQo12tQ3LmivopnPKSXj3j06l+ff6AHv/UZM?=
 =?us-ascii?Q?I6xu9B8rBDyPq31VSC2tGLmQQ/GvvXZYFVhq1mFhQT0qa8Rit9qnNGEJrR9g?=
 =?us-ascii?Q?f2yYvp0jJWoFX1j9AGz9IkncYf6NDfhmYndmOB8po22N5rlU4ms/CPIfD/H/?=
 =?us-ascii?Q?duNe0wR7R+Zw9j2irsNDpMJ67e9JFohLPkVeA8P66F/1EL1WktwdAxi8duf/?=
 =?us-ascii?Q?dgfuL3wkm2JSiAXg2LptzsTJa2SQTI4hAG1SjwptdmpGyF3/4NaAn3amBUBo?=
 =?us-ascii?Q?uBnhl46UVJFgb7kdAnE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/ECCzDQIfPEf/trEg2ai9Iy+ukyqfClFGgWoTJJmVq8s/pawJsDpT0H3MQns?=
 =?us-ascii?Q?D2sccYTbhBrEFPvvNpNno8YzvO5uKrRkJBytKZKT+5RQ8mjGz2j2jlAlpsJ+?=
 =?us-ascii?Q?mt5uL91tzKDnNSWClx0lO0UXSRFY9SiTomzRnY3Tdub6numocR9Dbsgy4SNi?=
 =?us-ascii?Q?OMzQw+cC2lC+31/JO6d5sV+Y1VyAoqjStxfxnr35P0+v9csImst3H6Oq+e+j?=
 =?us-ascii?Q?OuCyjwO8+wD8TK9fRYjbc4tYy4P17Mhz0fL/2bQq57KX8CAcP2VezN/rVE4U?=
 =?us-ascii?Q?e0gDxktG4lEnO1fjoKRsL3GKQc8eCXlAZB6H+bBdtXl4cFbJEkXPRKPn+XeW?=
 =?us-ascii?Q?2UOjsK7iQwrJ0fAb1hcCxVDMC1OfsF4lLtqlYn86vIZ/Uoc5RF5YxCC0MqW1?=
 =?us-ascii?Q?6c+VN8ps6fHK1bkhHl4NP9orjIUYf8S7hiajtAmUwSPNqAzt5CxZCk5cJsYN?=
 =?us-ascii?Q?3MHZe4RqmbvW13AXsl2Ip4618W83hgOFcgTieRgBC/JM+wiAPUxHcP1ZwwoI?=
 =?us-ascii?Q?19YT1p3MGRJsZf5o1Nkbs2GSF+FG9vQQVaoSCHZPD+wBChZ3qyxaAY70YE8r?=
 =?us-ascii?Q?uOAVu2DJ3pPbABRHrKXmGPX6DIYoLP5ZBnSn+A3D3ilugvUtZOtHCzYNUHz5?=
 =?us-ascii?Q?2BEhh5vcdW6scd69X27CyeDWar8pCD3fy8WqQRQFmzM1ClFPJiauJdsRbIYz?=
 =?us-ascii?Q?cnAIuYvtvToQjuCyOPDPrOaE89ZHMkFw1FFLAgQepCMENuEJnfxezYZ7CQhp?=
 =?us-ascii?Q?o9YXfHvp5LWKK1xKBSXFEgEj6DKyfoHf4575UByNVwlzB8dVGXDQpH7iBvf3?=
 =?us-ascii?Q?KZ22l7M7M2zQOTJFwhrp+FUIvlOVpx5z/4vJTm70U3yTegFsIkt+DJX1A4sC?=
 =?us-ascii?Q?aXa9yNnkBETDZwhcWcd8pxUXwsA2aUQVFUDAHA2JtBTxqO2OHm4ZOjZUWKiW?=
 =?us-ascii?Q?2/XicguuG2HD/DORs1XY2Jl4KoaY/UuZCWWgCrYsL8lM7rjRaMYtgcYHPPKd?=
 =?us-ascii?Q?p5+Z6QD0pmHbzqlZdV9GgS8WNf1fsR20t+YR9GGr90rFC9ZohtSlMXyirvcb?=
 =?us-ascii?Q?2If4IeNU9aFUCszZYEA7yKflIeHrAnPCIEhiZB9WWCzpR+enPOYRNldeOaXp?=
 =?us-ascii?Q?4UGi/mfRTRTuKAAOEc/CXRuR1ljWNXiDeRgIUpUbpz0rOoLNLrJ6DnUm5MtP?=
 =?us-ascii?Q?TSWmdM850XS9FfNu13HUi/uPQCtcIoty8z5noOI6Aj58y+PSXVLf0OwNmART?=
 =?us-ascii?Q?ZiNCce6fePR7WGuAAgvlMZjTBCxQOtQ2gUypfrqIKqhWfjVhZTo1q5D/ZjjB?=
 =?us-ascii?Q?lhBVnAghj4pZRxRi/VGw8FTr271/n3nZc+OmozCOa/Fh2H84VNUt3901ZH2C?=
 =?us-ascii?Q?ZY6vLuwwXNTHwzCL1YgYWr+WEC1qhaEKrSLErQWZOhhkvWEmvHAC1aZIyZNj?=
 =?us-ascii?Q?H7NHMfq9g8RJ8oQeF84Xv5Du6Z/J9ueJmoIQWkGLqk/laRoHankHQNjj64fO?=
 =?us-ascii?Q?3gXhodTx5q1XzweWqjnbuyAYWvXsb5lEqeo6sTnLnNZXlIvO1dIbA4Unh3WR?=
 =?us-ascii?Q?Wq4LSpez09xiWUNbyLt8dfKKUe/F/XZBdQkLZ99Mp76dBZPccPY/6aYaNDGx?=
 =?us-ascii?Q?caDAKxXAnULgVC5sVBRLdq7lc6kJfTIOU7iXLqVKiwPB87oawCIypEO7fMmn?=
 =?us-ascii?Q?8OTQC27vo0IBVraZAc7Z9UGpMeRB9bAEwFPY4rXK1U7bgKmOHzX1bECF1ZGM?=
 =?us-ascii?Q?AP3FubL0tg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6790f142-049b-4a0b-522c-08de5a8a7c95
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 14:19:57.6850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ytA8cwVr6uqEbBQxOXFHPRG6mHdoLzdJt57p1SQNj8L17g9G6amd5O6EYhkKe2pe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9481
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E0CDAC0014
X-Stat-Signature: r9r8671ci9i7zcstik14gdnsjchbatnm
X-Rspam-User: 
X-HE-Tag: 1769178002-97618
X-HE-Meta: U2FsdGVkX1+9pqXYmD+gBDqTP91FHm7DREComGUL2+VObjoBpep8FzEWeQvJo4jXtrFxehb4bvR5VWSkOlFf5K6OOXlPXAseH1DL8v1vHdJn+vR1XSclGIgwJD0yWuZTc89GhoTMFSOglFEIxOO1B0K7DYR9YYL72DwVxjx9BrXgq5Z0sHrDpzXBty415inpa5Jry47252pdNTJBMGB3BfLn8HA8pAIMsBiNwUIVceI6V77A0cZU5YgUzrIJYkHbohh4PJRpLgj/jOlVU/i/vpT4eI3+Ar6nENt/B2mxyYxvEDRz0zQaYtTH55pGLtsrFeCgOoxvks5AXF3WXb2Y5MudFRMLD1Ol20TODKC5IfzV7z/+NIVZmUfxF6kJlUt/gCezXEOkZ4jdDOZDrnIfC/1ilrRWQVVL4ZTQt8t2BEtlWadq9ZMMwxvANYPNBKFDD9Rw3gD0lquAb/3n16N8ynhdveI8Ahjvd3GAKE+9RyJtVS1ZS5q7Sprwv/dgyrI4pXkS8hwbSUcWNFCMvA79cowTlrQ63aJ54kFQRBhlMgA2CY+PXo4+DtMIkIqSoEj3QaX3Miiu2DC3rbwh3POz8TJA6YK+dq1LUgBDQgMQ7uhHHyE7mpCaHu/UbiUJ8GooT12dJKZV+l0yxas94Mmlc+jhyqkgJ4bnwh7BR4HzmDDjQzypKskFFBqKLFs384PDalThv685INzGR71h4AYwGsPuOlYODmqg9o83IiXR3wt9tz/ZCtFoXAUN2scTP0ds9o/IUbtq3tBPU9of6oix8zJMdt0BvY1GOMtHKhe01gUoB2nh9EQBvyPNRJ1UOVYseLWSb/HhQ113plNO/V0sEbJ7fkFV4bV/4YRjuRT0CWKzoaW0qehqUc9CyucPSYddTvoPudIiHdm1t0apdZibVQflTl+8Msq4JyDg2REb9PYxSfYhXi676M9fPJLCRMc/lI8qyCzCcSvJrldjEdb
 ki93x5JZ
 zKDqIhIYKKsA961wTPHDyXDuGirra2v1xNomd6wDJiJeyusfdmw/znagw1Jh6HpbjQ/WMzDcjazUHi+uoRsslguAxr+8KnUTrgBgwsc85zXDvUUDDIYlIqYd0/iWNHjZbzXYgKvo+jo2v+zP/8Sq9SW2uc7Wy3q+h4oX9WIzt/hqNaizttbu321bTcZykbThJ0hVBFYpUVnEXQQ/lQGLjsDi2s4/d5qkTNLS6ZahiMt7TyzHMfQ7EJYlSg6SmYsGp8iw2X5wAnhbdj/wUix1/VvEFBkNe24VF+pLYi6Yb8DWOuek2WjPlVaYnO1YiX3Lc1E7gXyCzThFPeW2B8n+I6o18CLbBMuRazlJ0PY4Q0yaM3teX4WgNeGbPjsqoIaTJLzLdQuVHS+Y/p5SLSsquBDavI047EAcGztLtV8QsZtvFjAI9kFRUSOWYI4x/9vRNRi33LsKxLmGwtvQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 09:41:03PM -0500, Zi Yan wrote:
> > Now that we have frozen pages where the frozen owner can use some of
> > the struct page memory however it likes that memory needs to be reset
> > before the page is thawed and converted back to a folio.
> 
> Based on my understanding, a frozen folio cannot be changed however the
> owner wants, since the modification needs to prevent parallel scanner
> from misusing the folio. For example, PFN scanners like memory compaction
> needs to know this is a frozen folio with a certain order, so that it
> will skip it as a whole. But if you change the frozen folio in a way
> that a parallel scanner cannot recognize the right order (e.g., the frozen
> folio order becomes lower) and finds some of the subpages have non-zero
> refcount, it can cause issues.

Yes, and this is part of the rules of what bits in the struct page
memory you can use for frozen pages. I've never seen it clearly
written unfortunately.

> But I assume device private pages do not have such a parallel scanner
> looking at each struct page one by one and examining their state.

I hope not!
 
> BTW, it seems that you treat frozen folio and free folio interchangeable
> in this device private folio discussion. To me, they are different,
> since frozen folio is transient to prevent others from touching the folio,

Yes, but really it is the same issue. Once the folio is frozen either
for free or any other use case it must follow a certain set of rules
to be compatible with the parallel scanners and things that may still
inspect the page without taking any refcounts.

The scanner can't tell if the refcount is 0 because it is frozen or
because it is free.

> >>>>>> I don't think so. It should do the above job efficiently and iterate
> >>>>>> over the page list exactly once.
> >>>>
> >>>> folio initialization should not iterate over any page list, since folio is
> >>>> supposed to be treated as a whole instead of individual pages.
> >>>
> >>> The tail pages need to have the right data in them or compound_head
> >>> won't work.
> >>
> >> That is done by set_compound_head() in prep_compound_tail().
> >
> > Inside a page loop :)
> >
> > 	__SetPageHead(page);
> > 	for (i = 1; i < nr_pages; i++)
> > 		prep_compound_tail(page, i);
> 
> Yes, but to a folio, the fields of tail page 1 and 2 are used because
> we do not want to inflate struct folio for high order folios. In this
> loop, all tail pages are processed in the same way. To follow your method,
> there will be some ifs for tail page 1 to clear _nr_pages and tail page 2
> to clear other fields. It feels to me that we are clearly mixing
> struct page and struct folio.

I'm not saying mixing, I'm just pointing out we have to clean up the
tail pages by writing to every one. This can also adjust the flags and
order if required on tail pages. Initing the folio is a seperate step,
and you already showed the right way to code that.

Jason

