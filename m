Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E264BCFC518
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 02:57:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECE716B002A; Fri, 21 Nov 2025 21:57:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA61E6B002B; Fri, 21 Nov 2025 21:57:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D97506B002C; Fri, 21 Nov 2025 21:57:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C84F46B002A
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 21:57:18 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E6202C07C5
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 02:57:15 +0000 (UTC)
X-FDA: 84136731630.28.E74B52F
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011044.outbound.protection.outlook.com [52.101.52.44])
	by imf30.hostedemail.com (Postfix) with ESMTP id 411D880006
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 02:57:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=eKR8vVfp;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763780233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TdmHT6S1wDNDaRCBSiZIrVT4sj9oiyeH/QoXqklZDcc=;
	b=q2BXR+GuaUVqoSbFaFp78/6MfKuLM9LnrrUxu8mnESg4MamBpaB07J+66TpE//K2B0o1K8
	lenXw1ClW2PDU4Q3oWSwCTn1jj5JchBcbEjCj2yYrXjUG3fJYK7lMkqgmiD9l0v12SRv7T
	LDWoXgNx/QMwS/Z4N7IFUEsAJLyPEzs=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=eKR8vVfp;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763780233; a=rsa-sha256;
	cv=pass;
	b=GRO+SYZD9P180TBFFNNhKF1lYrC7sXQKoc2/5pq5sC/FjE5V7r3Ul+w92TJNFYt1zYaUU7
	C0ZfndkZ/waoySwMaCh/4BgU0uSBJONOO5VWzyNh+YH1M3Q5ZoDY7h1HHuUFuhxZTSAL2T
	Bvb+2NaWjp1OyV/4RgB7rXFiJGmIGm4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lRtl9ScrjaLg9CxuL9OPpefb0dsXBkBR9oJSmvLaeZZubXqMzqCTx/tVAXc1A8EJEow+NUOXMWTBiIigk9Loui6GQ/hdsE/wpOmfGtK2UBaa3s01dCM601477556qlvG0r/L9gJ7oINOyZc+dSfM5HtnvcqvR3syh1xxslb1iHJknTCi1gTJzMjkWF/nAdcpZ6VqeF6d8aQiIrt05u9NJnoEyXSNMFkx00nwUfzVWxcRC1FaDMqvLoHLg/tEHEa4dZaCDKttGyk8sddBs33YqD9J86MWxGtQg0LuctgvM4ljpwY7D8tJmLLqJzOf6YPEdVN/UdvSO6H5zUM+W30SzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TdmHT6S1wDNDaRCBSiZIrVT4sj9oiyeH/QoXqklZDcc=;
 b=rztvSzVhuU00M5q5sqCnmCAlOCTkin6XdpGL7kjg9YLd081cw6yqpcYRmE4B6ZnMYD1lQQeYXXtKYr7TRBNMlHRZODAKCavFiRKRr/uAnn0zVJrdhWGli9VWOYDChq+QrH1QNmfSXS6CEJleZN/o4aVfPPbZeqdO2N8LBHoL5gPr91SIzPOxjGRD1Rh476IQAm5f4cZmeREh9fvQzcWnK7EANZ/K8dq0E4OpEfyiOhLF6pOdMZrzrwIXWl3rkOwiSfivAQbBBVuXQpMPp95eQmF8mqBcftb5RhEUZMqXL1KxBq6gIZ2NFUC/AEp0bDlPl9lppa5Q1tZa7QUppvI55g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TdmHT6S1wDNDaRCBSiZIrVT4sj9oiyeH/QoXqklZDcc=;
 b=eKR8vVfpvBHQkoyQAubnyPqfQ2aLvAJ7T/ph0fKftvf6KiFPD9enYbwCBSra9pG5SHjNnBeEOveePkUpl+/9BTl8ZZDEPj/hOzOJKX4yGUn6lrgJ9bzCdfb97KhTYugLSu7YtXMBOh5BvxZVKYTtxLfBfM/fK9twHnua9t6OvjJoCnvwY6hdBeewrJ5nVCBOvBQD9BTLYBj2ZOs0LoRjzh9MrZ1BzKVUM1vW7zZsdL7XQ9LQ+SGOubtFjD6ewGBEUYuLfWjoiTyi4wv5tUnBwifbnk4arZpPM/ZxajMY4V3YZSFQsEcYIAMP3eGH9t40LqVuOdN+iw8QMN5EzSDE5A==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA1PR12MB6994.namprd12.prod.outlook.com (2603:10b6:806:24d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.12; Sat, 22 Nov
 2025 02:55:40 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9343.011; Sat, 22 Nov 2025
 02:55:40 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Balbir Singh <balbirs@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] Improve folio split related functions
Date: Fri, 21 Nov 2025 21:55:25 -0500
Message-ID: <20251122025529.1562592-1-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0049.namprd05.prod.outlook.com
 (2603:10b6:208:236::18) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA1PR12MB6994:EE_
X-MS-Office365-Filtering-Correlation-Id: f7428aa5-b8da-4e8c-513f-08de29729ef7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?v7Z8cKHdZPpxRZjqYczywohYVmZsIvJ9gM403ZplbYEDpXvKOlZH2obnhiuV?=
 =?us-ascii?Q?aiZReeDs+BkZSOCXEL48cg09PqeSLcXtZqZLw7VMW8EJQIvCJtH13qjxYr0x?=
 =?us-ascii?Q?USOsXg2P6fqqNPEH5CzWASAviC4Iktg1Mk6LxsdIkMERAFXNqhcAaAKegPIj?=
 =?us-ascii?Q?aAwFRT56ZI1TrF/l6GoDRYddxcDKDiYZMrz1DVpy1PJyY/0UKixShhNfNnUN?=
 =?us-ascii?Q?/tI6ejg/qaTO1Yh0X4bF7E+k6uK+RomuDhZCqh51XfPAHjM+fOU7PXTuwT6j?=
 =?us-ascii?Q?VWN7esuy9Lu5oGgdsOZREdaj28OHYc045bjSB60Nw3XBJxk+lBxWh/1BmX03?=
 =?us-ascii?Q?zQKKIAPRAltSSl/PZUkTy6XpXot9BhPDkEhIH72kaY2f4Rpld6k3YncyFDA5?=
 =?us-ascii?Q?tR/Vkbxd3TG3t9RNW1AjvSELYZvG/r1noI/20xL9VhHRrkf2bN4810EHpQYo?=
 =?us-ascii?Q?smocl8Q4hizws+vhPtQb4xoJV3pbhC1uBh1q5ChPpFfXSbBQv05QDadYDIQx?=
 =?us-ascii?Q?twjaDzu+G5v1b48IaI7GhCEFPjq0E8VkOnQtNJc3zHIoEOSQGnoeX2cADYpu?=
 =?us-ascii?Q?p9pKqxGFk2VJAh9kOnVJoxcKza+w64dxRfJfEiQMPnPEnSiqwbqiHmSvwFpt?=
 =?us-ascii?Q?xG9dJHIsDlO8GY8ka6k3JatFkXIphW3dTFoYIawkGLOk76DRlRRKM+GVL6KI?=
 =?us-ascii?Q?yxYvFpkDV9sQjT3un61LLlyEwvBOYpha4uL4G471lNhcQv5ev+W6uc34iH07?=
 =?us-ascii?Q?XDQcTB6o9CNY6lqvrzg5jsIWrtoJHPN2l380svCE9hh3+UfSjznBKqcXTWVr?=
 =?us-ascii?Q?39mPpUrPd7noSSWkJh6xrkRA1g17f4Y6ozK9OKnGKTQR7R8ZxK5oMVzc60rM?=
 =?us-ascii?Q?xn3OtHiCW7+g5r8RjWlzds3V0AURvdRTInsH5ClhMtu4Aw45WQcLAOwPTGVS?=
 =?us-ascii?Q?AOGFZ9qkOyQ+W0/OkOO/wL7Vas1ehelzR2dAxEIVSBuZlb//DpAmRkAxfXRZ?=
 =?us-ascii?Q?TC+XwvHp2DEuFnnJc3BbCqDIAJUUPllOXaAEF77rp6l7/wwz3Q9OoxNmcQ/E?=
 =?us-ascii?Q?6ntpvClWG/QRfe6Jc+wPGiTUbwLU8ydoYjHC1IyCgYbn+V0U7zuOkYuMbhlb?=
 =?us-ascii?Q?1wz9Vzm84GloXOt/A0527drJcAc94T6z2eUBvP2EwkCFRPZCCFlcocQrhoc1?=
 =?us-ascii?Q?xXUm0fpxzGIlc0j23+eJl83yoCQ4GYtuRX06DDjcuNyBMQ/0f8rt0FmeWUHz?=
 =?us-ascii?Q?3SE6ZIfG53PI9n32JN6KSnHiJiqO/a+6OXW2LP1q+hdUZEaaKLeGGjHqW0Es?=
 =?us-ascii?Q?MQDB/fgZtnABHk+pB3ozm7VgFWTd3ZfOlXre+I0M2vrSY4XH06Cn/DUrLA8+?=
 =?us-ascii?Q?Av5GkRlZfMA81ZRXzR6tA0xf5Z2IxGbq4yikYCgjTdiwS+fzeeJnXY36DaR6?=
 =?us-ascii?Q?6xUKja2gJqqQKEfjymbMNEtxn0i80hWBUxUShscKjzPyGlQly+7ZMw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nUK4ldjDeRlEy/In2XBDeuyUYomiEVX4TuzXOZsBkVeJKsFk+wztChpGlOqF?=
 =?us-ascii?Q?2CExOmnQqAkT8ZULXtoj4lUSiRrE4o1IT6Wvwqjh+NKHdTtillzhlOfCWf55?=
 =?us-ascii?Q?s2FkFH3deIy8voIR9eDnYFZIAsmeUmZA03TdsWrWZAAsUNwJOq943BfFOnsM?=
 =?us-ascii?Q?8VTVyCkFXej0YmSVrsJcrLGhEX0UX11gdhSEl0sl5+3+FJk5fSVDaHZW26cf?=
 =?us-ascii?Q?ptAXITypOBw3qaiIzsTtUHIDvh11DzbLCOSZvJEhqm0T4zXa/GhBE4iOoG3J?=
 =?us-ascii?Q?GJDYRtQJzKATVBikTy0v4jYrvZpTQjRUKPgEPiKPcA3Q8GrFi0weum4ffhVx?=
 =?us-ascii?Q?bSzdO2WJMxBF+vN/zpAxswMr3EyyidxqCx0FxCOGn+kqodU5PRW7ycAqCpZX?=
 =?us-ascii?Q?Xd/K986rhovUVaAxadIEv460Ez7jmIWHlP5Kc1r2eTc2WH58ve9/X330CE+N?=
 =?us-ascii?Q?25G1Hv1REzdnIaB5oZJXAGixnSHQbPS+Eu0itSNUFt7JpPLiKcJqCsCinifl?=
 =?us-ascii?Q?KHpGNVQ9wvI9XFn1Zmed5W11Ns5CqwqYlA2QOSBJ+zHChZlkknroJtks5xTT?=
 =?us-ascii?Q?0NWNtI71Mae0IfDimwjyhW+CyGpKF0xTnoitZVIAfPspf+1NuaqH3O2fcOXJ?=
 =?us-ascii?Q?9hlB/6inJyHILm0yXC2WOTJ1g3GBklRSqqt0vh82ecfYr2zMzjKvHqDHP9SF?=
 =?us-ascii?Q?o9pEirZSNQM9hfdWZ89LCPFcBugQHeS6CSaSp0VykW34hVUN2VnpMEF8G81d?=
 =?us-ascii?Q?e7DoWJVJTBZ2RiYdjNadASXhfGpnnJLKLVsCdn1LsTRNZKaZTkC+4DWAOkqc?=
 =?us-ascii?Q?p9Krcun6OYBcWi0NCzOJ2ZrcP9m7OF7eYVDrVpH3sLdpBWVP6sV+NduawZ0q?=
 =?us-ascii?Q?RVpYYNIAYUuecLJn+1ww0xHDfoJrwHgPOiY4B3/w3SMmAbspkOJIEM25P+z2?=
 =?us-ascii?Q?FIgiHW0/cr2qRHQ/5ArvLBoNTnq3HVYEiXMLRNeCZfNyLtvxDFUsrc/grseb?=
 =?us-ascii?Q?bWBgXQxaF9NyEtIg/JZiS5HVupe5Q7D829ZuOJpRmHxOp4xKgerlXLLSliVk?=
 =?us-ascii?Q?ZgyrOLsDLEzT4YBCgZy0Y3gz2sfRk6R40ROyYZu91E640MBMyKivYVqyt/hc?=
 =?us-ascii?Q?GUn5Ak7kScFir99azp5HVFfsPPrDwKbmSYQgpGwn28DWmg0WeJbMS5zmw0Qc?=
 =?us-ascii?Q?OT8QRhbvyzNDIcVQxCMs/HJ7eN5l4FpDndZdKAheCK7xgY2acAUtqjbhr/jR?=
 =?us-ascii?Q?DlxUFi2RBl0ETsUy6+2FAX7WTqwl/FDfRBB0KvzbFXwh2dR4tNRAfg3t0TAb?=
 =?us-ascii?Q?qpDV+JrczjIHlVCiA9F+L57YItOjgI6n3y7eNgtrZTyzEk4qbIWQGNr6mtsT?=
 =?us-ascii?Q?jAP98+dkWCqJCeu8uqjao9bCKprUEWXqkLthXVP4A1PHvnn8Sz5y1rnsD+5M?=
 =?us-ascii?Q?bYTRxaq0fXqFKbsS9DRXveiOw5FH7CVzxvjchxtZkLvtOeF0MzijCBKBxF6/?=
 =?us-ascii?Q?Y0OfrHxDgJgZ1dQ1mlGdGaECZkWXicgSRz8qlkzBZficM55m6N10oGF5xhM7?=
 =?us-ascii?Q?tFz1Mgz3VgVmiQvZpYSHxqwHOXAqIdAB7oig2KGq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7428aa5-b8da-4e8c-513f-08de29729ef7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2025 02:55:40.4181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wcd7A6ndyHtP71ORSNXuoHFgIarvY2HDt1Ksd3VERB+OvN30/FmzDVRAJPxvMdCB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6994
X-Rspamd-Queue-Id: 411D880006
X-Stat-Signature: qpkg1uqgrmosit4psxu67fakoc9nkfob
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763780233-796919
X-HE-Meta: U2FsdGVkX18EXubly9OmYo3aiq/uBJLk38y8ZMAOqU7/QvCkNkKfKmXTxAqIyWUNi86JjNRpfX9sLsNJdwdWnoXjiOuRQdgUzLSMrngD5r4hqxJbA+7R81Qmdx4YkJmJNVptwXI+ryTeTDNmTqh81FYEu+748QyekUcsw2keF8hAVwSbn1a1fhtKXGJAAvFP3vkYT/Sm8lBmpCHWu9Sf4Nwb40XbTQf4mKM1Yst4MQzeRGrgA9ciuXzLGDrOYy0xGogF/eeKUy7oAqk648C6je4HQxRXhqoLHp/plfI+MVns8b89qUdGzlSOCkDwmr3NQCjRgMduliIQtn+fIE8tZXpgGDAlXJtQEBGYNLgZQY7xHqfrJDpZGinNGVZJ/msRKz4Awj7CVLuXXdXyIynTwjpBjk0R1JHNqv4IaTstylpp97Gt9obmPML0BPQZDKCcnNoreVNgdEKwlQWUCVwZO4EZYZRG2OgG8X6DgVikVCsXhA3y2dHYRKQjX4vr25FDUuQEuJ0YnkRPtLD+PJLVC25gF/Llp8zC3C7uXqm6/ydRoxMhvrevevbQ1v/3OGRpDF2M/lO2rgbWQDKZGAPlvJNZmUqM/4vgGIWgBr9Z616zIIwoMqnNUo3DZUJla8JiXtUEz6fQyiD0+5T6t+mKaBr+BkPALYNHS1caHM9BPovNJM01JfLc8/uu6NVk/BkE7iXjtVt66i0uahEjkZAHb1/guHrssykXWAu2Gh9QhaCBzPEmWJCyqtWgH7QNGm4Ejkn0+0ESsidOCfBphxhz3WTzZOY/EG0vvjaMJ4wh0nGHplvR4fVEUgUx3sWE/1oaLx9yyqyZmXs3+j7H9Xn6mbgjLQVQp/cyfxNHOZF7HROH0KNLdeiELgDfuj2NbY0YTOMM6LErVTcihNXwXAmFXrL3mRaBlSyTf24HQ3N4Okt+OzU8yFor0pBZMcEpvTAbmnGCsMywnjIRxk3E9dj
 X9LJQeAx
 ZVTuO3JltR0eXIwqyz2Jm47Ct/3QnLRbN2dBXXMJgB8zW12IXSeHQ+2pib5w5SeY56j9Ip1ThbAe5oY7k6lxc3g16SO9nrVFDiXDp3TWqTAWbV3Ug4yCnVY8hG5tPqi8EDGMn5V9o/3eESmeOhvcgeg4kIkA+vuJJUFGNA8TLvqgVGz8spUiFS0IjXRkt4Vgmoy6g+YnF0pnc8s6dXxs/PBtHNzqJvl3Uk3SeVrzn9lDP0LewBnRgIJp96rK2zLq4GcR0tpWAk6NCbywBRAsgz39/FC3DSaJOu56Vekz2OcwnB1AD+c+kDdQ4jQ7iapbbLYkAoNaLrhw4dPvfYZMv5tlBHq7yTRUnxPU9cxWR4N+FvvF5csg5NDdWgexr+SJX3hXhWiB3zgazqJwO35G+ickzjRBT4jS14PCJyD1/SXTBAIA6BMN9f8VJERSURpFEWVyhpfUIh7N2Z/3+2cjlkiBXMbzdYVex5HTG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This patchset improves several folio split related functions to avoid
future misuse. The changes are:

1. Consolidated folio splittable checks by moving truncated folio check,
   huge zero folio check, and writeback folio check into
   folio_split_supported(). Changed the function return type. Renamed it
   to folio_check_splittable() for clarification.

2. Replaced can_split_folio() with open coded folio_expected_ref_count()
   and folio_ref_count().

3. Changed min_order_for_split() to always return an order.

4. Fixed folio split stats counting.

Motivation
===
This is based on Wei's observation[1] and solves several potential
issues:
1. Dereferencing NULL folio->mapping in try_folio_split_to_order() if it
   is called on truncated folios.
2. Not handling of negative return value of min_order_for_split() in
   mm/memory-failure.c

There is no bug in the current code.


Changelog
===
From RFC[2]
1. Renamed folio_split_supported() to folio_check_splittable(), changed
   its return type from bool to int to return error code directly, and
   added kernel-doc.

2. Moved truncated folio check, zero huge folio check, and writeback
   check in folio_check_splittable().

3. Changed zero huge folio check's error number from -EBUSY to -EINVAL.

4. Replaced can_split_folio() with open code.

5. Changed min_order_for_split() to return 0 for truncated folio instead
   of -EBUSY and added kernel-doc.

6. Fixed folio split stats counting.

Comments and feedbacks are welcome.

Link: https://lore.kernel.org/all/20251120004735.52z7r4xmogw7mbsj@master/ [1]
Link: https://lore.kernel.org/all/20251120035953.1115736-1-ziy@nvidia.com/ [2]

Zi Yan (4):
  mm/huge_memory: change folio_split_supported() to
    folio_check_splittable()
  mm/huge_memory: replace can_split_folio() with direct refcount
    calculation
  mm/huge_memory: make min_order_for_split() always return an order
  mm/huge_memory: fix folio split stats counting

 include/linux/huge_mm.h |  17 +++--
 mm/huge_memory.c        | 152 +++++++++++++++++++++++-----------------
 mm/vmscan.c             |   3 +-
 3 files changed, 101 insertions(+), 71 deletions(-)

-- 
2.51.0


