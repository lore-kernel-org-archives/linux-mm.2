Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86B68606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 19:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=L/Vn0wlM
Received: by kanga.kvack.org (Postfix)
	id 9F38F6B05B2; Mon, 26 Oct 2026 15:08:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CADE6B05B3; Mon, 26 Oct 2026 15:08:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BC326B05B4; Mon, 26 Oct 2026 15:08:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5B4F86B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:08:42 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AD21A12087A
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:08:41 +0000 (UTC)
X-FDA: 85365714042.05.59E82CC
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010003.outbound.protection.outlook.com [52.101.56.3])
	by imf08.hostedemail.com (Postfix) with ESMTP id BEFE4160006
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:08:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="L/Vn0wlM";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.3 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793041718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tsk4dTanj5TSHJ9iLUUMmb2ZTOUw1JbpYIxC9YGu0bs=;
	b=HWeZ+HPaH9uw5kEec6d7qBw1iDErqbMQWH2xnAdbJKL/Y1asYRQC2wzi3Fnn5j/w5SoI8P
	Ey4G/3g7l05tXDoV0yiju47fJI0vUYNoZGbUPNlgm57c3koKM+hsVjh0dl/lmosBHZOhSa
	RKprd+Jz0/+abjqgWzUBOm+8EFtx33A=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="L/Vn0wlM";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.3 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793041718;
	b=17qh13x8q1JDoNc+iFk9eHV6WnGjJ7+N1SpRdkw6zQvCFhZah+k8W3UMH7H3trKQ4gR5l5
	Hh1CMkLJIQatMaQi54SbZCyo7CJi4eGcJjwnQtn8f7YGFttZZ1UjuhTI22JQJuB4w4zehF
	Wc8SRsVG+9c/IATZtFUJJXbPvPHB56k=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ky+ma8B1MXWfs5QTfPJcqpqIzHObtETODJooS5MVyU+qCNs60HzV3CaKF0HSOV4e1l0CK8+ftlfBVki9Kf7tsEELuJDq7P7wo3tfARgMwguCA1+00HGZwW0cYyG6Iq354c81hY4SJSS3DHzl6KrvYleDBj6kDS1oeWcgxh4fOPEbV8tFrBMq64XXJkKrz2Kdq5zoZzJV2iY1P3GZK2xgipMQpuQWs+QPaomGmYbpwRL7g6mBXfljbt6a5AR7VTsJS5FQZWXqxAhoKEoSGQ+mGzAqaOc4K/UgnMhxAyOF1RcY94XaFT5S4PEzYnPcC9lgA/Y/jcJsLda3yuSML3m8ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tsk4dTanj5TSHJ9iLUUMmb2ZTOUw1JbpYIxC9YGu0bs=;
 b=p6lpD9jxx3CXqqUWCD9vVXg8VnAnpqquXREsLNdlevzPIkvrS/zeH8hDuIr80jbwyBybivsrqgpBf+apE/67L+60Zk2YdzwtxDzcee92Qx4w4vNmWjaKryZ2eIoPqH+z0GQkmXCXvwXYt98Vv5iG/yo8OZ4souvG7iDqlYSO71mf/Un4oirEFITUKYQkRuKXk+9Tf6GM99m3dyJe1b+2uPsLG3zyMSKtjWOc8ceOHM8b+yO3wyPnnF9tena8ymYphmJScuhPHbh0h0YW3o4jNqUftbS5IBCER87ERa94jfOu/XS0VLRCfDDDNb2Nd/6/D6KOaiAXeuj7GSfhc/tc9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tsk4dTanj5TSHJ9iLUUMmb2ZTOUw1JbpYIxC9YGu0bs=;
 b=L/Vn0wlMFjV/DuRSzxqmO+X5Jxfk/WN47sN2m7Mtc9dPc8R83NDZcr8D6FcEI9iDCndR0HIqCI92GeGGSYhvOnL5A91f1nqTOIT4+NaWUxfaFbQmj3nJsNGdDuX6Qdx9S7HFbYySqSHR/Dg43znq01G6EVSb4HY1j7fHCVY6uaP9ijDMrWlVFlc2uhI+hjmoowXhJ+h2ECfGqgkn7DExH1sVIZKYnLzbM2ir10dADj928+zhRd09SPKQAvc9YKmrIqdr5MKhbUzBq/0MIwoTCZid8D6N9tgjDZT4rVy0LoHGJvl62EumkR5FOYnQLjxAsK/1GIlLVGKBnHmcuT1B9Q==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SAAPR12MB676730.namprd12.prod.outlook.com (2603:10b6:802:301::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 19:08:35 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 19:08:34 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Lukas Czerner <lczerner@redhat.com>, Carlos Maiolino <cmaiolino@redhat.com>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Stevens <stevensd@chromium.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 William Kucharski <william.kucharski@oracle.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Eva Kurchatova <eva.kurchatova@virtuozzo.com>,
 stable@vger.kernel.org
Subject: Re: [PATCH 05/16] hugetlbfs: enforce F_SEAL_EXEC in setattr
Date: Mon, 26 Oct 2026 15:08:32 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <D0209A61-A2CA-430E-A76E-0507BEB66728@nvidia.com>
In-Reply-To: <20261026-fixes_shmem-v1-5-703206d5fa0c@kernel.org>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-5-703206d5fa0c@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: MN2PR16CA0053.namprd16.prod.outlook.com
 (2603:10b6:208:234::22) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SAAPR12MB676730:EE_
X-MS-Office365-Filtering-Correlation-Id: e541803c-d507-4aec-1401-08df33948863
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|23010399003|376014|6133799003|10067099003|261026121527099003|22082099003|18002099003|56012099006|4143699003|11063799006|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	mRqjt63qpWSSWFKM7zvJ2b9/T6JkdHbbH+50IqtKjxQsmnZFydpFCtz7grlB0n7nAfYUEam2ce3//70EozUTzZVgvF+J9dkcQRS7L4j5EiRnFuQuF3rnqATche+nkvdX+MVi7E484UIbEoxe28at3FJ6sf0uM2Qs5SapRx5WhQZygRKt0ZfwXi5Vk31EgsPbLKH+gGuCbFRaPAxEOPBxzTtjrFbvTMneyQI/MzQnAbecBdcmHgzYR6dslxbb9TlY4Ep8WZ7KgRfxlzQro93/xps5tgDDZVlE1CK3DqB05/GuolMwl3H0Fb97aulyimwpQcVhTLgUNpMaLNsiO/xKSYkApAoU7AVN+s7CdmOMipWKr0jBvfOexgN+zie3PK8Gpqx73H9kNEYeXa7trCcK8spGiMN8+1d16Go3X2uWj8iDkLCQuKtX3skRCa3GnAJyWIVF4+suldXiVNokVMR0H3goP8gszOsM8/EmB4KdQXuzdVjF94WNCyNONM792z80K4QAtbb0sny+ZnzaIjPZ+UR67AVcUDictYFKeiueFG62++NOIXQw4CNVNgZ5hs7xp4W8nTDz2aDgSMQZuanabHqkyFwzKfVMvKezcU0SfpfxaheWb3mo0lWS0Hh8u2UPPm9Zms3h0rYzoQmM9r/QJ2s8ADiIzNqcMrNz8qq5E1c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(23010399003)(376014)(6133799003)(10067099003)(261026121527099003)(22082099003)(18002099003)(56012099006)(4143699003)(11063799006)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?F4MhOmd1xJZvTFTnqyApSb6ewnrT5GkOj72fDPHo7ah/Qpx+H/wdVKxgyPEu?=
 =?us-ascii?Q?kApW+VeosTYxZ+nj0KHgDkZlAHd4J4HD6VxiiG7KOM7Crhxv4uZuW6ND3Sr6?=
 =?us-ascii?Q?CkW4YlK5CDj3OTbbviOQy0c+z6XwMcvMMlbn+8jfxsixr8enMIPfiV5Pi1vC?=
 =?us-ascii?Q?BafK9mAm6BF94fZp/Y5vR0n3XDc0BdVDb46wV/oZYsmWKQcHoVnzjVN0Jem5?=
 =?us-ascii?Q?AM8SS3SlTy8syaT0s61WtgkAS4cd/gFtAhYxfn7wW2WfhVRi2DAjDVzdXo0c?=
 =?us-ascii?Q?7mWLaTSCCGbY1AeSfEDjFtiwAIc5vnWaZ0y941Mu396VTZNnZyxWfwc6oRpa?=
 =?us-ascii?Q?saXUCJhHWon4izCwCEnk+8fdCZhXk5ZBdCTTrcE2vGTO8puO0g0q/6D/OkXy?=
 =?us-ascii?Q?YdSnzWbCuLrtlAoVz8XlbsmGNAfkG6rMTmxN4O7n9YMPsHh90rBWbphkC4Ln?=
 =?us-ascii?Q?+cQ4USBzEdranl+mz0QwncFJSYNp1nvKKaOtDOFZYpv7hFa2sWvN7l0RSmHO?=
 =?us-ascii?Q?hkO1IYn4Ba3Czxo7ihfH78h/tVI/njGDrGo3vtAYwRK8BSHnS6EgMFDtiYEt?=
 =?us-ascii?Q?aFy8CPLYYQ7kmXkeW62A3wuwFZ2vRoEpo2EOKrylFO93Cex8G5OU4Dg7YCXk?=
 =?us-ascii?Q?TTZ+EkZejfBB/K5Gxcsxhk0j2r+6Sewqa9tPA4L8BonDtlE0Kjox8PbZ0MG8?=
 =?us-ascii?Q?TRiBtJNaefeDwOQY546BfZM6WrQEUysMHnJoTy2f89H3KlWZm5CEpiZJoN8l?=
 =?us-ascii?Q?FN6Wt5bxnOX5AXQ4Uk9nTn2QSCGMF7WguqqjF8Cj31iv1HGu3hjox1J+V4cQ?=
 =?us-ascii?Q?qnpdw5a4BQBq5iJNcs+vcOci+FqWhRwHahdz74ZFHikrqciDazX4ItMLpDou?=
 =?us-ascii?Q?+/SOIOJ8Uf5qlqo59wxQEY+khfc6rGsi6uBOSgIMLcecNkHYGXdPAylfegFQ?=
 =?us-ascii?Q?U6qCTbEAQbyHXIinqSKd5ITY0qFYZNHw4oPwbMzF1g60ZeSSLR4a/hSsBzLm?=
 =?us-ascii?Q?rHtdN/l0+Lm6NUZtcUtmB04pc9bWiElFd/t1McsX5t202PaIbJ7MJw6Lk5Ib?=
 =?us-ascii?Q?zkZXHbRr96n+uxmxTa1AY4I9JNZbFA6YVv+fRtXmNJXgDg2UatC0BKFUla4U?=
 =?us-ascii?Q?yASu3/fyrKku5y6REqY6zzvnUmnDity/QvtRCp5gJbreslKC4C5OqTKymyff?=
 =?us-ascii?Q?MnK01XPQph4oRPfRMkNfdxLCkYMVZa8i6YR0H7iaN2XyYuDy+22pGTCCoOZC?=
 =?us-ascii?Q?4L/SHDzgt0aZxfZG7NndqtQgCFbo7BDnpTasoB6KBkJlsU1Lay8UWfHsq0B+?=
 =?us-ascii?Q?5Ei8Fax4kyzqX1dMmJ5+eav8M3JVjM5JiqM0ZCyjbtkQSI2++4IyFhu6ZyMK?=
 =?us-ascii?Q?xpgf2YorGYnTHiyt5pT0TPXiEL4x0D9lVzBPiGqFMs4ShXHPXJdh7Py840Pj?=
 =?us-ascii?Q?ChJpJ3UCWJSrn4kP3LGuAc+QY48KaJZG9BYdbthuYYzkOjRtjmuh8ztuZVNR?=
 =?us-ascii?Q?3Jb1s9RpupocLe2HWxvt16G3zrNNiDwSn/12XaN+tqwOam8tB2uxe57TqpGZ?=
 =?us-ascii?Q?QhNICP8uohFplfwctDAud4L6v4Bso27h0ISd6siwHmVceTcF3/2ew1me4U4W?=
 =?us-ascii?Q?OSAB5J+m66YWtZLEz71hW2WM3UCXgpNtUl4Ah8YgoFpJ5rfZ5Y11EnvH+CN+?=
 =?us-ascii?Q?c7TVaRJ5AZK2FiDLu+6CiRPVeEt8RlAGLwTKSaOUwv0e9PgR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e541803c-d507-4aec-1401-08df33948863
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 19:08:34.7983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Y/Qcsru68Xeconjbur9LhnlK63b7jhd0SGK1qL+5OiDm5Ft86lDaGeRois15ock
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAAPR12MB676730
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BEFE4160006
X-Stat-Signature: 8om4cdcwq9eqnkcxhinitm5bdmsu51k1
X-Rspam-User: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793041718-662355
X-HE-Meta: U2FsdGVkX19xTnAQ1DkRNLitiQP7ITjkuKPD1BHD2gua6jvxWWldNP8mOJrKb75EdIkgUhF90r1HT9HVC5gC2AB6YgyZVrEK64ViovYh+ur96TeY6nVyZGkqEBLzYg4bV10FErDJ2a+/tHsV8fcXNTlvjVjmmS2j5dhRRD/vt6i8Kp8lZhwh1R3vuZo0PI9lVqbqzi9B2iXQNDjIyuN9v1I2YAX07FXxFyIsKCWPRdqxNj/kgeaaH/TWQqE5I6y1fm70Qwn7FPsS/XBTj/SLzUCGoNd8SGiU3DNQvK2J1ylM/WP/M6IzI7I7fBFSyT7lmLNEJXJ51tk9VzB9V74dWJpWUFSZ7YgG4I3qSU3Sd2ZR4TvLLg6cmc9zlhmP6OpRkz6s6t/RTv5H1STZEoAlSXYhDw1cFzVkxZQkuU1VlW4bzMW3UHSh6HzI/inU3YQl+yZZSpMbXWs35Lmsq16waGrutsmqqPC//l4T8/BqoLB+lLTs6k93xD4+hhsenjIvjE47+432WEIZXR9HqDN3w27jG0OhEIQOtUjk1t0u9VrPPiqA/WKBFFppJohYjDUlWI1CVmdfHa75DnykAeGOsZ3YQ6oSI3ADC7c9S5wZg44qHdhDpVQIZILJKDw4XZr6jsj3BGuQCst2zZzjqIgXBO/4yWQwMafpMvxSTFegxk1z5aJ1L01Xpc9I3djqrCZgzVs0Vgem3+9iV9fnY5Uc3b3iw7FnVCuBDCyhn5dyd4YwQw7nAJ92+FjMDh0MEjG2SyfcE3hfHei+ruzrYO+fsVm6At8w34/Fg9DocD4ABXyNunK+DrK9T+UOMvZ9AG/1QhxwQWrQfGoJGQOWWNXKjqh0nfCVYWbQDEDeBAQBSrnB2FL8o6KbFp3IeRTGh9/nX5DS1iTXJ2cDa8ovtV2mGo0rpMtbRcRPoXP50AP+71pNQaZhgCk+Lb1c/NBYYwh+NwAEDN3Fn95UQtAVjcp
 y6nb+AG+
 khJvSCrLMYqAOMCfHC+UF8ZwGWZyafMi3qirDmKWIn1HUj5PDy7C5p4sLbAezEfcAj1H1/W6baoYBJx5A/yFnMHEe9eZknyRs2ofRlAJ68fZ9aFWxTRtBu3RVlDHeWF+wZ+RkkDc5hCpT4YBQylfST9bXpbS9rhOx3+zHNAbBdnSnUECowpjN/yekP23MH0Jl/r3C3kh1LSPtpDqS0vfkjILJhQVX/LCZhhs/JsfbZdOfGaNLlwl58MSw97xzeJIZdMQf9FlrABt0ks0HNkrzJUVrcvMfiwq+Ucc42vOM1w150k1iDCYwtGk0AxwZNJHo5Hw9tNkIOM8okq1au4QtFfZltDNGBqAkfOTjcCkH6SjGkU6LAUD5s/TzKaJLD1oQMqgpBPt9BFEiYO1UKO2fv+0nb0wPq6KBOwSpF+Ao23wghPZIXrccVGgU8+v+CDPFEdjQ3sMX0HHsHqxcX9YqKDuhfSN0VcEqQeLyLA+F6t+vZ/GTLML+Dy8ZXAeSLbAMHNCyu1nj92nV1Z7Hw3aMKpDQRIdL/9vW+dx+BnmRY4Umv2Gd0HdAwaGzXGhVfkXudYJSXQ1DnFcE/Vq3Qji3xi0m7KvEZs3FUzi83aC8rp6pQxtGudbWS+txW22VFqAxNJSDnmTUZSAXx5ChmegvbNGHu/M5JO8IkIkGENrOVBAZvgU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 26 Oct 2026, at 5:40, David Hildenbrand (Arm) wrote:

> From: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
>
> F_SEAL_EXEC is enforced by shmem_setattr(), but hugetlbfs_setattr() doe=
s
> not check it. As a result, fchmod() can change the execute bits of a
> sealed hugetlbfs memfd.
>
> Use memfd_check_seals_mode() in hugetlbfs_setattr() to reject changes
> to execute bits when F_SEAL_EXEC is set.
>
> This also fixes the memfd_test hugetlbfs SEAL-EXEC subtest, where
> fchmod() incorrectly succeeded after applying F_SEAL_EXEC.
>
> LLM assistance was used to reuse the helper and revise the description.=

>
> Fixes: 6fd7353829ca ("mm/memfd: add F_SEAL_EXEC")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
> Link: https://patch.msgid.link/20260629180247.2343229-1-eva.kurchatova@=
virtuozzo.com
> [ david: use common helper; fixup Fixes: ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  fs/hugetlbfs/inode.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

