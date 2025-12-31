Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1597AE9410D
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 04:32:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AE1A6B008C; Tue, 30 Dec 2025 23:32:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7586D6B0092; Tue, 30 Dec 2025 23:32:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 613736B0093; Tue, 30 Dec 2025 23:32:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E3AD6B008C
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 23:32:38 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D2B561604A5
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 04:32:37 +0000 (UTC)
X-FDA: 84278495154.06.ABC7222
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010035.outbound.protection.outlook.com [52.101.56.35])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1073EA0008
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 04:32:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YIwqHgBQ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.56.35 as permitted sender) smtp.mailfrom=jniethe@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767155555; a=rsa-sha256;
	cv=pass;
	b=qo7om/kkWZrSmO8u7k8G4EvnQG1pQ2LqmiuHptfZcSBD+2YMjfQBqVNIGF3F/FbBVtXRe5
	Zs/HPl/Mxs70edLxJfSy3YRWrptYxj6ufdcBlMvhGIF3Y0ehixAMFgsqKmRMtspjqawCjW
	//3AJ89vkMCCRXS9DPyO2C7OtyD4wl0=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YIwqHgBQ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.56.35 as permitted sender) smtp.mailfrom=jniethe@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767155555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wd04w2eF+OegCBwh6Tl3Cg/lo+z+2EG8wU01bAHcJx0=;
	b=MyVTBNPap0ObhNo75btk2n5/v45y8SMa1U4SXcTHlLalp3p/AsSLcl6wKXhlNVyUHhA/Ir
	COgvN6Zla+TvOczsWz4KtyZ+/MUeO6Zo3/SRwWly7fAG8IVH5FOwH9aTIGYja7DZQ2309Z
	SMusPKVBj67MVdg51efbYcF78AxsizU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=APnhQpTJrTLrf80WVjVdue8usk7sCDy2muOyoAcbMkOqtscvm2k8k69RoxyKxaJhA8bUYZnsr8CJTaNPNMU178Hrw1arRvlTf2vej1P3tR9a7V6J3ODHMLyXRNG7Uq6Y5/XFJH45F/TN/nVi93End4f8RS2bDxHxhob7z09G637vAIT0xZBGu5lEl4Fk+UC75SNSoKgOeeyjxvj0HRMrU19DOIFb95oNoGTUtES6cXbONEoTL6BPY8D4CftJ1/85hIQYPIpHncJXtCHfrBXCAd2MRzQucqKwhDBmw6FpJCwY1A/t9lwpT7VefnJUhM0RxJCvYAtcvN7sGJqr25Ti9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wd04w2eF+OegCBwh6Tl3Cg/lo+z+2EG8wU01bAHcJx0=;
 b=kjqJfxNbREoHYa9m1LoJGnCjDpcApl30kzKTzdxbtZfqxTokRyIuevb9csPPhlJdGpULk05t0bohOu3TyuQfJgCq+syvee5QjjW0Yd+jdcauaIomm6/StXu8dDY2ocuQCA38sq+EOrUiY4yFO3uM2YYSyXyNaIxosnQYwVJ+b1/l4SYwXuHEfTSZpqvy9yH2FVFe2DBJxyEWp8z4AncP+vGIyh1TPPhlgeS0cdT0WpdEuhCmWS0fb4hAeM+F0tYloBNAwVEnlxPiQ0bcno61A1Phb0FNzvWmAtGGHnH6f0JZAL1zXw1vulGdMO9AFeWOIbGqgKCxr7Csz61idtCzEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wd04w2eF+OegCBwh6Tl3Cg/lo+z+2EG8wU01bAHcJx0=;
 b=YIwqHgBQwLy5gP483qIuup0nZvNAA8S1zUFHofMGSlEVAoHgyeK+n41Sln9WJEBXCMXHWwBpCX8xHXj/73+2L9McxDnEbW3l9VBA49LnHUDdRH+gUqV4m840FMNqE+LXu5tTCHZ8sSThHG9kFFRAwp0fnbWfPYjm4ZK5wErcLeAHnW1M58v8gXsTwW0qB6mnwQsgZjgyQoSeELPe1v+vf75OXaoxdRBX7TAvSuIz3va7czjiGLzcqr0JUvNVi3pdDPfdTZJZqRPCYZOxzlZYZUFh+Lq6jg3iFLdUGB1HrMKKwq6ZtWAfPhWd3CDGp5AaEOdUEarX2vyiOwn7hVC+Jw==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 DS7PR12MB6045.namprd12.prod.outlook.com (2603:10b6:8:86::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9478.4; Wed, 31 Dec 2025 04:32:30 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9478.004; Wed, 31 Dec 2025
 04:32:30 +0000
From: Jordan Niethe <jniethe@nvidia.com>
To: linux-mm@kvack.org
Cc: balbirs@nvidia.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	david@redhat.com,
	ziy@nvidia.com,
	apopple@nvidia.com,
	lorenzo.stoakes@oracle.com,
	lyude@redhat.com,
	dakr@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	rcampbell@nvidia.com,
	mpenttil@redhat.com,
	jgg@nvidia.com,
	willy@infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	intel-xe@lists.freedesktop.org,
	jgg@ziepe.ca,
	Felix.Kuehling@amd.com
Subject: [PATCH v1 3/8] mm: Add helpers to create migration entries from struct pages
Date: Wed, 31 Dec 2025 15:31:49 +1100
Message-Id: <20251231043154.42931-4-jniethe@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251231043154.42931-1-jniethe@nvidia.com>
References: <20251231043154.42931-1-jniethe@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0345.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::20) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|DS7PR12MB6045:EE_
X-MS-Office365-Filtering-Correlation-Id: 01eb2fca-5efe-46e8-c7a8-08de48259c0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?j7jccLwNWmj6qRt0BxaS9vb0rlW6abZ8yAdCJ9l3Awh4FKt/4YiRumrbWBMO?=
 =?us-ascii?Q?9whsC7S1O/Ajtwaz9zR+U18etLHk1+m2tCabkaWqPjvooukEQxWOLDWO7Iz5?=
 =?us-ascii?Q?FepE/ZNwLT00StqHRanPUROAMYAnBLAUa962qhWJ3mC966XsUBWXvjypYmo9?=
 =?us-ascii?Q?9zqJb6sZcxsWRykf/C0bvsnGBenHG6yc4+3wAFvmSdh6LLCBJNN1lQl9Hr4f?=
 =?us-ascii?Q?1974R/MVQ0LmNrUzsfp6d9ib7oBcSLukukSUSP1fd7fvecQBeVl10hMrOeZM?=
 =?us-ascii?Q?4H+e4gVxvsg6bPNZ0WTC6vlo6//fbUFyx/VN39c+VLRVWvgpwQ6uVx9lEx31?=
 =?us-ascii?Q?6ZAlcnfxXf3u3KDxBCkhUpW+8nEx9L23U8JuwcYb0gFRmpccRofUrXP6p+tC?=
 =?us-ascii?Q?YtUrTUcY+ouYg77AQNZYMlmUexwTsm3wlOsDlwjphoqnlCWhkRjTPglJSRy5?=
 =?us-ascii?Q?wm5M+dFTvnR/JqcWPZ86XEf8W9r8zaI2c+nECoNPG8zqqiIMgoe0FGj3CfdN?=
 =?us-ascii?Q?CNTqppF5futYw0982oATP7EGVTMg/br3VJd8+2CPnqdFq9AVEzm1Jq5x5g/K?=
 =?us-ascii?Q?uWiJqfrRq9/jo7lHnv1LBrYqOCm1Pobi7bSKsaIqCvxU+RPXJJGLZHlYDNBv?=
 =?us-ascii?Q?9NrGCXtV+mmq+xWRJ4IpzmvJ9XLtN9ob7+lPzb6yirz4f3c79cmVP5UZkJZv?=
 =?us-ascii?Q?mTcIvw6zoPki326P3BlK8ko2I8Qd3N3MiZU1KFu/ZcSQr0SfPAVuWf5bmAR2?=
 =?us-ascii?Q?Z2LkpRtZvxS6dxX3DPW9T6r6QdYf4N2XdXmMdtb2abwx2Q+rL1zLyP59hIMT?=
 =?us-ascii?Q?LsM3D4W1dbGpjIJLM5uV7aO0DW39bsGtQMWwk75uwl8iHwqrBWL4fJgCRPMY?=
 =?us-ascii?Q?xkDVLmGt8ta7Fuly5H/NHIrT8nZLyBHxv/UxCgZgdAhooncaIaaf4W+FwsIq?=
 =?us-ascii?Q?X5m1slPdTrU8oTHOuShaI9R8J7l+Tv6/p0N2Zk7ZGs2cs1Eeb7BKzxRz48ts?=
 =?us-ascii?Q?n5eoizvP3YhucRnBnyDFUaFVNWf1wk8rO3akj2r+n3yEhHSKxBXWmvtFTxPd?=
 =?us-ascii?Q?civISKjI42pmLJSeGvCIsbeSJXFNxRzWucR8RvGGvgreAFNC1l4nU6DYVbn2?=
 =?us-ascii?Q?eM/RiBAqvGYus2GJwkXh1XtWGsZmZtdQhIWJzAgqX7QuJIfZYIGlZvrEJy1E?=
 =?us-ascii?Q?vOL6Ot6C9tS5v58XHqtXQwVMrKIrkmECjnhkBe7sxkZdjddeOVEsYl6+PyjZ?=
 =?us-ascii?Q?F8YhyUEXeUL9DiBaWcjqO37olbgfqyJvRBsOgwl4PfSyauMDbYeeDi8LSFio?=
 =?us-ascii?Q?KXL4T3J/PTvjAhR54eKc9gsnPd5ZuVwruGavzLW7fMuyKj6ocrNdmM+V2q1Z?=
 =?us-ascii?Q?tiE0PxPcGVCdyHebODtERjVTLqwodjc+Zbs1AfAwOk89IlCkPBHmB8oZCdP5?=
 =?us-ascii?Q?CH4UDHmmdzvndJe4hUwB9X4xDPhZKNgx?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ELeqYrQ9NvLis9fOBxUoUQzM5zPl8EWcVKj6L8YCfkGmC2lvejPuBi38aIN/?=
 =?us-ascii?Q?dj1jf60GB2egkQDfknKfi3D25D/Mdj/M+IvEB2F+oZnCI9v/vSpj88yTelfh?=
 =?us-ascii?Q?+lSZMh8hI1P0YZwzZDdiSsoY+iU6+St9yIvEyjJCk3R9vxTD9r19AAVRB0+3?=
 =?us-ascii?Q?4Eg9Wz+FVYwraoO+BEq0Kd79b/omXAphB6ceTlogI+EcpDvTretKLqM+rtC8?=
 =?us-ascii?Q?s0q4Y4FtetxMrSh/NrRLIo+hdT4gILFptlqXuWrS0e5YlJiqtmSZ/Tm5V0Bu?=
 =?us-ascii?Q?vtGFNFHNRdjxYNg+t2WTPz/5c0yFWsKvfoUBYOkTkRQW1bCTixO5uAcxFhnZ?=
 =?us-ascii?Q?r2spRi7UUK/A5Q63h0pk5zus94jpdBmuk+eeFaePWac8KgNrRucXY5F3cqT7?=
 =?us-ascii?Q?AK8Jg7/PUojFqnlWhXu+7F9ftivL1WdhX+oPSRcNVjZXVUM8p58hrnRQx6lm?=
 =?us-ascii?Q?wj1iI5nAI0GN7+OOKZAIRfEEYSwueJS1WaeWs8DU0feej8MT8A+wsMPO5h+r?=
 =?us-ascii?Q?656H3g4pOLSwOtOqeMQ4ljitedYMGJTSDd/2MXsroaDqxxHWVR/JFyTejoqJ?=
 =?us-ascii?Q?cLxGhcb9gDTccGiBRDlG7cnbgzkBqDzBX5ypyPRSDPyJXbZIkO1gNjol9T1z?=
 =?us-ascii?Q?M/vtcz0ty4yxHlMLcYAym2vdE7n+BYAwXq2D+LAcOT7Xy2UQtGNMlcnc6XvF?=
 =?us-ascii?Q?bIkxJMgQylt+2Sok77ieVJCnNeU2AWMBtCIbJuWpeg6PEjb6IOvnswLKoxha?=
 =?us-ascii?Q?Pc9vLUCn4CCwCzHbNXvrhI7CQuBlxLj8iwIQ8Hq0zTnsSotmqcHZ2d8k9zmy?=
 =?us-ascii?Q?inOwXq5sCluhsNjlZC+6c/bL3/2RcDCoMKERVXuAJOKGQyKUN3h6OnYZleHq?=
 =?us-ascii?Q?OPCdVT0XycAwl8/RdcBJ5K3NMH5amQIZQVvcEdYPUZHkczfHl8psM5x6QTSK?=
 =?us-ascii?Q?CqVIvs6+D8D3RjcDM2CIJK/bkCu8nC91i52Xp9dFWdokELS84CQCNQqf/m4L?=
 =?us-ascii?Q?ZYKw6KL6MJHxJYNGSLh9Jbr0P2JcS4GVUcCzpS6G4ykGMSGMYGTYBFd2xxK1?=
 =?us-ascii?Q?+avFm9EHyLYB2Kj0WUyau1vf5jT8DFS7k9epV1wwZOpu007ElqP/kurlZrRg?=
 =?us-ascii?Q?jT1PPwZI/cHKGHHBBahEvZXSSdJxmLvbxnsYiT45kcU6rICRCsz2OXUWxmBG?=
 =?us-ascii?Q?DElxUAQC1F1XeVi+vFLKFKxyoPmZZfhBkl2Rsu+w1ajS2vK1XaiTO/19NubR?=
 =?us-ascii?Q?+ycdE5F0k1OlsgVCHhuUVP4b1W3znOtwhq6PhNV6alZdGMUa9oGTHBts0g9V?=
 =?us-ascii?Q?OJauZJMpaTuWuVX1BMuufNzylhkevagaPsq6oktmzF+v0jnBM8ulnDiksjzd?=
 =?us-ascii?Q?lxFtVP5a1+MrQxHwnKZfAfcBlbRvOCCDryVth8pwudksyuNig7o9K0Kwsqid?=
 =?us-ascii?Q?/vD7YGmn4erVtdyXXWn0PC8ppZ0pGMmQbTH67lvexbw8dD3q0QrnQd0ThNq/?=
 =?us-ascii?Q?uzFC7tD+RmoOJgPla7GKnHOlX8AT/hifj6zTY/0ZBvgihluwLwy3oyUNRgkL?=
 =?us-ascii?Q?TRhc0F2cu61ntkKaEXGSnUDN6/OFVguoLov6ZOB92xohZrIEwa4JU9ielulK?=
 =?us-ascii?Q?FzwCu79oC0546Nhh/z8qd1kFgxg1hIOzsZ51dZp72r5VpGkvX9StzRsH2gXc?=
 =?us-ascii?Q?Y4fe2/cp5NsDpkLM2KqjG2Ua2y53GnrrhpNU9fV9Z0Ae44LlUMyLgGLebpyJ?=
 =?us-ascii?Q?nHFRKfKc9w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01eb2fca-5efe-46e8-c7a8-08de48259c0e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2025 04:32:30.6597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c5xEf1gVkb6AovUVTNaobkKXWvy33HElQDwqHPRHQkaMZ31+10AnwGIWgpHsB9k1Wf2jsmu6RPd11lfMQKh8bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6045
X-Rspamd-Queue-Id: 1073EA0008
X-Stat-Signature: 35knn7ebkbtq4r1ef1g47eypiw7tmzei
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767155554-670284
X-HE-Meta: U2FsdGVkX18Rr7pGqvC3dvhKjlTQ/xoGi28FLq5HPR/csf0eBFjEEevy+EE3A4LAvy5mDDUZ6h6zwpWaaGccbNAMIh2j7V+nmb3WDhfj7zJd/RaDLZWBgaxr/yGcaTn+e0GgOZSZjP75YeL9WVsEOA4KYL01iNOccw6PCcjx+eujeKJ6zvvbp9OTdrgKTcnHKT0xIv7q3gxeFD6XMt5ZKpMZyh8z5UizUEy/Jxh1NNU151Dc9L7/vCJ7EU72uX2cnXtNZ2vsagk7vLwnHe33KsrsxmCiVLb5w9cg7fTteq0cHftLSGhLwYjEs8XnuFU68k0Q6jhGML6MIryUAMmbbpstQmxO6Rup0Y9E4DxscaShY6OQGSnfvtjXXL7KHSppmXUxWS2ggQ9OE0aQJd1q8gRerPoDN1fXjSn6MeAIiY/FSMtr8xFc4oo/nlvIOTdDHCgzPArdm8TwCjGAxN4SduERyqGA9GWiI7B71hQAM8sYN63r3qAX7Jxt5Rl7jFj2bMnAku1d0AadVvyC+PF63PQqqKcx13BIHoNKJleaKgyAFtdQspQ1MVXneMDXlTweTA17H8Ybck5KvUrhG861paL6a1T78igMznyM10Q16R2b0ASI44QwJQOaSHQJfVFZhvZzSPAjQSrX9qh/7fejDMRCzjUOfG+kj/o7wmxaFqgX4QlntLoqhdOe7cS7uLjdqGCwbp9o6rnIfvtXQ5KcAXCkWrEnhVOKHnA8jPUXwLNqf5AcGJDBz3zFEg2pFDEt/sDeR6+OLuUzOiVUXPk7tcp9Apo2nt938ZPIKhFbHqSslHG1QojfDOhhZLOMrVMcfwJalxYjhC0g+13eGu8owPuOLva4ABdzsqt8aR9OFKDl9fUT6Dmi6czrIkBoAxyIzSw6sDbjZju4oKJlMtqYZnsQuBNs0dhgh2ql33Nzow+Z/H6U/FYjZ48qNmJtILu7wuW/hSM5WIZpgi+e5jh
 4KgRpgfn
 UPsBM0RlLnaYuhSCk+UFCcE6zkrlmXyaL/5ZzY2MzntluzenqOqvxBnOKuu4QAvec/BIij1i4v9ZnY3+sBZlWvUrDuBcaEaXgCyFQ4G0uHno3wR9hs8EyCPlAJ45Rev3oKhforBwonlFSY8WpGxW2wkFYu3qoCg5c3fSRLhA0kHDM42RczQCq5FT5uA0t+8QKtWWUTXm69ljFTM3rCJpegpBFgYmj7Oai9KJgZZlplV+N3BzhO+Tupk07pKQ86RtKIE5muaBlSmRs1fUUM5HC9WhbQUuwiGxm0eEouJ8bQ0WHzr9CmwvwKvKyJwc2Rtp0SPccE6Bbaq8v+bVzZoutXg2AjZVXd/haM/VhFwLYVX2s5SacC2dw/MySQsJ/8ghax0uvA/eLpXs0KrUb+KSl86Njs+gI9wX3tHQ0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To create a new migration entry for a given struct page, that page is
first converted to its pfn, before passing the pfn to
make_readable_migration_entry() (and friends).

A future change will remove device private pages from the physical
address space. This will mean that device private pages no longer have a
pfn and must be handled separately.

Prepare for this with a new set of helpers:

  - make_readable_migration_entry_from_page()
  - make_readable_exclusive_migration_entry_from_page()
  - make_writable_migration_entry_from_page()

These helpers take a struct page as parameter instead of a pfn. This
will allow more flexibility for handling the swap offset field
differently for device private pages.

Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
---
v1:
  - New to series
---
 include/linux/swapops.h | 25 +++++++++++++++++++++++++
 mm/huge_memory.c        | 18 +++++++++---------
 mm/migrate_device.c     | 12 ++++++------
 mm/rmap.c               | 12 ++++++------
 4 files changed, 46 insertions(+), 21 deletions(-)

diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index 8cfc966eae48..72aa636fdb48 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -173,16 +173,31 @@ static inline swp_entry_t make_readable_migration_entry(pgoff_t offset)
 	return swp_entry(SWP_MIGRATION_READ, offset);
 }
 
+static inline swp_entry_t make_readable_migration_entry_from_page(struct page *page)
+{
+	return swp_entry(SWP_MIGRATION_READ, page_to_pfn(page));
+}
+
 static inline swp_entry_t make_readable_exclusive_migration_entry(pgoff_t offset)
 {
 	return swp_entry(SWP_MIGRATION_READ_EXCLUSIVE, offset);
 }
 
+static inline swp_entry_t make_readable_exclusive_migration_entry_from_page(struct page *page)
+{
+	return swp_entry(SWP_MIGRATION_READ_EXCLUSIVE, page_to_pfn(page));
+}
+
 static inline swp_entry_t make_writable_migration_entry(pgoff_t offset)
 {
 	return swp_entry(SWP_MIGRATION_WRITE, offset);
 }
 
+static inline swp_entry_t make_writable_migration_entry_from_page(struct page *page)
+{
+	return swp_entry(SWP_MIGRATION_WRITE, page_to_pfn(page));
+}
+
 /*
  * Returns whether the host has large enough swap offset field to support
  * carrying over pgtable A/D bits for page migrations.  The result is
@@ -222,11 +237,21 @@ static inline swp_entry_t make_readable_migration_entry(pgoff_t offset)
 	return swp_entry(0, 0);
 }
 
+static inline swp_entry_t make_readable_migration_entry_from_page(struct page *page)
+{
+	return swp_entry(0, 0);
+}
+
 static inline swp_entry_t make_readable_exclusive_migration_entry(pgoff_t offset)
 {
 	return swp_entry(0, 0);
 }
 
+static inline swp_entry_t make_readable_exclusive_migration_entry_from_page(struct page *page)
+{
+	return swp_entry(0, 0);
+}
+
 static inline swp_entry_t make_writable_migration_entry(pgoff_t offset)
 {
 	return swp_entry(0, 0);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 40cf59301c21..08c68e2e3f06 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3183,14 +3183,14 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 
 		for (i = 0, addr = haddr; i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE) {
 			if (write)
-				swp_entry = make_writable_migration_entry(
-							page_to_pfn(page + i));
+				swp_entry = make_writable_migration_entry_from_page(
+							page + i);
 			else if (anon_exclusive)
-				swp_entry = make_readable_exclusive_migration_entry(
-							page_to_pfn(page + i));
+				swp_entry = make_readable_exclusive_migration_entry_from_page(
+							page + i);
 			else
-				swp_entry = make_readable_migration_entry(
-							page_to_pfn(page + i));
+				swp_entry = make_readable_migration_entry_from_page(
+							page + i);
 			if (young)
 				swp_entry = make_migration_entry_young(swp_entry);
 			if (dirty)
@@ -4890,11 +4890,11 @@ int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 	if (pmd_dirty(pmdval))
 		folio_mark_dirty(folio);
 	if (pmd_write(pmdval))
-		entry = make_writable_migration_entry(page_to_pfn(page));
+		entry = make_writable_migration_entry_from_page(page);
 	else if (anon_exclusive)
-		entry = make_readable_exclusive_migration_entry(page_to_pfn(page));
+		entry = make_readable_exclusive_migration_entry_from_page(page);
 	else
-		entry = make_readable_migration_entry(page_to_pfn(page));
+		entry = make_readable_migration_entry_from_page(page);
 	if (pmd_young(pmdval))
 		entry = make_migration_entry_young(entry);
 	if (pmd_dirty(pmdval))
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 5d108ddf1a97..7eef21d63364 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -438,14 +438,14 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 
 			/* Setup special migration page table entry */
 			if (mpfn & MIGRATE_PFN_WRITE)
-				entry = make_writable_migration_entry(
-							page_to_pfn(page));
+				entry = make_writable_migration_entry_from_page(
+							page);
 			else if (anon_exclusive)
-				entry = make_readable_exclusive_migration_entry(
-							page_to_pfn(page));
+				entry = make_readable_exclusive_migration_entry_from_page(
+							page);
 			else
-				entry = make_readable_migration_entry(
-							page_to_pfn(page));
+				entry = make_readable_migration_entry_from_page(
+							page);
 			if (pte_present(pte)) {
 				if (pte_young(pte))
 					entry = make_migration_entry_young(entry);
diff --git a/mm/rmap.c b/mm/rmap.c
index 79a2478b4aa9..bb881b0c4b06 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2539,14 +2539,14 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			 * pte is removed and then restart fault handling.
 			 */
 			if (writable)
-				entry = make_writable_migration_entry(
-							page_to_pfn(subpage));
+				entry = make_writable_migration_entry_from_page(
+							subpage);
 			else if (anon_exclusive)
-				entry = make_readable_exclusive_migration_entry(
-							page_to_pfn(subpage));
+				entry = make_readable_exclusive_migration_entry_from_page(
+							subpage);
 			else
-				entry = make_readable_migration_entry(
-							page_to_pfn(subpage));
+				entry = make_readable_migration_entry_from_page(
+							subpage);
 			if (likely(pte_present(pteval))) {
 				if (pte_young(pteval))
 					entry = make_migration_entry_young(entry);
-- 
2.34.1


