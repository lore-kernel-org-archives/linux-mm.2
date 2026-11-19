Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5C8760A2600
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 14:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=dxj24mLm
Received: by kanga.kvack.org (Postfix)
	id BD5326B062F; Thu, 19 Nov 2026 09:26:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B855E6B066B; Thu, 19 Nov 2026 09:26:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4D1E6B066F; Thu, 19 Nov 2026 09:26:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 796FD6B062F
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:26:38 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 02532140AB7
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 14:26:37 +0000 (UTC)
X-FDA: 85452094476.24.4B853E0
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010052.outbound.protection.outlook.com [52.101.193.52])
	by imf18.hostedemail.com (Postfix) with ESMTP id 215141C0004
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 14:26:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=dxj24mLm;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795098395;
	b=JFfOFf8a3z4icey2LGGhgsVt0z4XCgYcy+Y2La1Xu4JYjqRecPbgm11oPWRV0BU86p8cJY
	xAIYErYo2NUGmpUD2/6x9XiH5b8f7mObmsJVFhe75wpViQnQPDKYkiRz8eaExWtaWFkHpY
	3n0EHijBDKd2TBxOueNgpYYbF/Me45A=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795098395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kLo195nhj6xrWbL8tyBoGiuCWkNbEQUhJFfP0/ptvxE=;
	b=EmxEZlgmM+BlxzjwjODf7C889dGr2ykVfq/Au6IsdILaOt/3E7ckSCETf0TEW12dzQDMHA
	Yywb424H17+9qnVyH+VHl79mnEAS7r6L09BSIno9fpztg5ffK6F2cMIj45iJbayRGNBqIL
	S9zV7cOeu5/nH3nJ85+tdpY4ZOhvFAs=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=dxj24mLm;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QFmzUvZ1MDS2JMuzboq3Q6y1wrdn58eOOgLMXLXp8A+n7cHABAYxyiFlFF/1RvMy1eDZGsZEXDcF+PBmMw9hm/ara5lYJNVX3oFRyoNt5Bxj8BVAuf4shKNvM764k7H5M6htfH+gry0K0ENhQPMfiytTmwgM/gTTYj7cU5K5VORdZoTdWuc5wXOdJPS5uwZ1QvTiw20l83MxKB4fudkOD40pVea5vFCoXC9L82R/G5m/Z4qneZBl2HM53yeoLsd6oSHQRNu4Jy85QGs/22kUzGBE2XJtm1xj2f2601vXAs2HcQK3LuxbSyIakzruJc14PN88lPzRWIpLyegpJ/u6tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kLo195nhj6xrWbL8tyBoGiuCWkNbEQUhJFfP0/ptvxE=;
 b=ryt9Q6pGTcre7GBagiwEg2sQVqrNzMtjcz57sUK6VJZcU29+cwvMkrpuOcbZJrlUAcKCErKmvpwnjsXwg5DKpKYGHTwxlYcpdSvJ3ESFX5oUU1zYp3Zfhx6m4VLwmA8SjISRTJmBXUpyrqNIKxBuuftkZbYsgk4FrbmonQXZGSb6xRqwgWg4vs0qm7h6+34dNIDRH4Xm5MpfUUjy6mCaQgsTT72JVgdFIUXu7beEtIROHYXg8ojAuZ5GNTVY8CQv8+Qfj0cXIBtyHshJINaXBTE/slnN3m4j+CG02NOQSMv39y8GF5SL5z/osHRFeBvlmt9iePdPzHFnImAPjYjPew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kLo195nhj6xrWbL8tyBoGiuCWkNbEQUhJFfP0/ptvxE=;
 b=dxj24mLmxvhLZvtpMgeytscyY3hwLAu3mB9v5tc3MyPaGDbwUOrvdpYwt/BinWK9/U691wkg6/NaP14zXlO+4MKEAAOC0jcuibqs74warY3FJIV4Dw45P3MEr0sUsWH5gH7iCg6kcKvbdZJ3vCoDUVw2rvf1+DVhmHLTvnFbLdSk+BDUumi02MkSq3lyKeLIeQjojzfx0sB0l9WlZlEpDdbK7TwOUVWDvfWslQr782jsOrpv/bH5c8NFdaRq89TXivvp8+mKPb03RUlmyT+X+Yo2jmncz0u5tRT3+kKVbjuLKsB9Iwz3WBe7w5UJaorJkwyP4kaZKb+IVOD7Feqn4A==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CY5PR12MB6156.namprd12.prod.outlook.com (2603:10b6:930:24::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Thu, 19 Nov
 2026 14:26:31 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0615.009; Thu, 19 Nov 2026
 14:26:31 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
 Usama Arif <usama.arif@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 stable@vger.kernel.org
Subject: Re: [PATCH] mm/memory: don't map hardware-poisoned pages in
 finish_fault()
Date: Thu, 19 Nov 2026 09:26:28 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <60EB5A48-93F8-47DC-85C5-C83A60A72083@nvidia.com>
In-Reply-To: <20261119134236.3745231-1-kas@kernel.org>
References: <20261119134236.3745231-1-kas@kernel.org>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BN9PR03CA0496.namprd03.prod.outlook.com
 (2603:10b6:408:130::21) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CY5PR12MB6156:EE_
X-MS-Office365-Filtering-Correlation-Id: d0542311-7f5c-45c9-1e1a-08df46491ae9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|261102123227099003|261026140227099003|261026121527099003|261028144727099003|11063799006|261022075727099003|261021121427099003|261022105027099003|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	RF8PySqMdsCCEMvi9ltvs0XWl8/7FCQrKBaMLdeH9NLtGctKTQW0mQkGo9hrn95e0oPF7F4qVl837CE/j89yAm6BloRoGXX73dQj9+rQHH9q4rGnX+H0AODJt5Ri96jTf4l//HVqMy3ElEbcybQiRC6hmHnjl9gcYqPAqa0EdCFFOY0IpDWif5pQq+dyqlqTN2SmQho71iNkT6tNe/Izk0aMnYMOitpAR4TrZGh+K193y6HFERKusmhk68j5ecQ9xhVTFDP6DePwQ/veLo2njRigic+J/MfT6USy0DbelrsRagjduITrgfuec0KpnhKw8bkI9rfQreUSF02JpxKNta9+wVqtadYCXeSkIh6miril+W6J5Yl6quQv6iCr0TdaKpPY59ZWbY8SjIlN8QuItjgAhmFQedAVxIQtASZaYqic5klq5fXPscUQ2wiotM21gAgXuhzzGUMXkO2r32XYn1TVnyu7WV1xtX2epAbx3vdOLB1eElRi/HwwJ6lqUWPN6f7a+l4wUNkbJxbIQMOw33dsRHVESGG1+l9HzWMtqhgASo9b7k3nkVLlpI66vOZAD0P60hZFl1UI5Rud9Fn9Kya/GaxFSrD5W37cJXtXiLDbqhNh9YX+hQLkXzTcGk0O0pGPeEULtDf2g1TmAX3D5n6mVuQl0hF6HgAM/0EKEVE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(261102123227099003)(261026140227099003)(261026121527099003)(261028144727099003)(11063799006)(261022075727099003)(261021121427099003)(261022105027099003)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?u+JgTXwG5LHNvVH2B+H1f3xquloowLINbrH33L+9t7xhJ3XFkTAqdYdjaSnz?=
 =?us-ascii?Q?/RIAdbsM7Uhg6LRYag6SMnDrTNhn3ShrvADmixgorsAmIp0IGemmqok4zYT7?=
 =?us-ascii?Q?o7eBxF7Pn3Og4MNkWL3raCD5RLuUgFBpbnVfBkaHhGwlSuLce8s5fiXSh8zH?=
 =?us-ascii?Q?9wuEuEf3nqwRCtfaDdTmvirAZozvur+iXgxQH2vT6hx2u3YcymP4rORjVWhi?=
 =?us-ascii?Q?x/Q9/lyLJACuw6d3G7cM9jeiVZjabYM2f45+5jpwDxfg9l5+xgtD9xVV5fxz?=
 =?us-ascii?Q?NMblPHmyPSq3HgmrcsxEPVA0SH+Ep2KlqwD37TDoe5/DjY9WOzUY+dxLc5bd?=
 =?us-ascii?Q?g0C6wlKTeR7hW9jynykau80eo09rQrRnOt+OkeH8qJgVJV1ULexTWqtHQHis?=
 =?us-ascii?Q?2xcUMKZANTLlVu2LErwae/S88uJ5rkBSTpWp2qlAcqXFZocXpJAdNE5YQlZI?=
 =?us-ascii?Q?RK32ZgyH1O8uaP9BEFtDWP3rPP5GtyZ+YHsB1cs83Z/CtJ+ZkxAWe+zsTDfn?=
 =?us-ascii?Q?lGA02t32ySJkXL1kyQ+3qfeqagFqsBcvYYyj9p219LQFe2/HeDV5apWkhxSH?=
 =?us-ascii?Q?b/NYqgm0e/YxhhyUbSaK412gOyMQY2JYXR+dlu8G3cq4VRnd4HRFe/tozr7l?=
 =?us-ascii?Q?FYoBC3/Ow9w+QmFUosII61NBeP8vFi/lNdZ86KUiyctAdCyM+yguTrRGbFAL?=
 =?us-ascii?Q?YewvDln8xcHZg70Y+xMwDhPMPrsgCyiz92xmYeUQXIQCghKuFOmvt1myYsuZ?=
 =?us-ascii?Q?l7nCyjaZSGJrQxdi1CjQroTKE88ca+ckjtqJa82qXpASiraF/CRxwanS+JYa?=
 =?us-ascii?Q?ojGCk8gbGQFE5AToYOy19dDyIL2NBZt/zwaGg5+Gu/F1ixWCBhMvnHSkIlzt?=
 =?us-ascii?Q?I+ob8+auVQIbF5rNAiD3V37/0rvjaPuQYfZCfv2g+vCtFaWF5SZrTfRsWq+0?=
 =?us-ascii?Q?eailiW+OMHzdcl8loGzbbUFEfu0Tss/77ezn/CSFFJaq+hv5TFqT75jISIVU?=
 =?us-ascii?Q?VtMPmPGZmotGUbBt1ct3KQJFdD89nYsppdYKlJYhIksYJBBcolzYkxEDjOsV?=
 =?us-ascii?Q?49lfnym+5BiB9n64K/JGZuOoByrwfmsuzw9P0a9FRXhVscef//m0g0NculOX?=
 =?us-ascii?Q?nCzOi33qPNhxBgtaCAmXGJa7DUy3CT6hvlY/G1JKrx+2nrahs0HvfhMACICJ?=
 =?us-ascii?Q?C7c9grenFU1XC5MU/LobuQ2oNlHQ/RrKwY2RphJU2gh/Ha4Grs4n0vNOW03O?=
 =?us-ascii?Q?rGcU5h3VCOVk1EH6Z3/DgYWbw7Lm02AxU+JvvF06d/GhEhSBCaNUbf/ReAdU?=
 =?us-ascii?Q?6qgkShmucfbZdYxLIbGjCJG+Y520w0u6KEjo6gS+Bi0ew5TqKYD9O70ymaPW?=
 =?us-ascii?Q?JSrC5angWUO2ATlLqQNTE2itewrzX3tTKCBLdwpEXFKRWzpoU+NUzPlig+A7?=
 =?us-ascii?Q?5xIO+j32HhJ1JbKJlqI/DzfvSyfnE22Y3d7H5Ov/bh4M1fRmBPnS28TA5Dl1?=
 =?us-ascii?Q?8W2he8FdqtfmGxHqTWva0/ZWCQMzPwKSv5lcLJMAEMX+nUQ5N0JhJfXwHCq4?=
 =?us-ascii?Q?yIrj2VC6WspDwIaRC5mmSXwX7P54fSI3Wy5jCDxo0PLbrjfd+pV/lAaoBVHb?=
 =?us-ascii?Q?Tr7WCm1LZNgs6Fjr6BVZ/axrlDBFK/VwVyKLgZPj7jNq11KDj5TunBWcJJI1?=
 =?us-ascii?Q?KjLSge5sz1xC6k/ekOLMblrTl7F+zYH+vzavEOwHE9fXfVFr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0542311-7f5c-45c9-1e1a-08df46491ae9
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 14:26:30.9334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IyE4O1225+oEbh1XwhhC5EKfM8ktGWUcntWlCl0VG2vr1S302UrB7SADPQzYbH6/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6156
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 215141C0004
X-Rspam-User:
X-Stat-Signature: o86bz6z3bmyt9jsm4ycfpntsztngkpjb
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795098394-601965
X-HE-Meta: U2FsdGVkX182vMkUJbv7VNr5dj4rcDchzLqwmt5NPem9N5IFhZbcIwKDG2Y39v28vncnKlI4QH+mq3oqhmAmDIOH7nMEK21C66w51aYeCHW4c2y+4GPHmfibhwiEvfqi1qBZXArglhkegdu+atLRPH680tJ9Cg5xS7XuYzOEDxX3ATUEowmX3DRZvfW5SkTsYB43i5Y0MzSk/S35un7FTzXNKweLC7uBBSa9J7Skvs1ABjZKO/BARrUqMR3MNqcSNVppZPa7o8ePGGiXRBCtRXVAuwpNu1jhuBXKUf26d0OFPhXthmZ8+paD6HYB6/GqJMfl2Vrjy9/95CXjQVF/tDTYk2XbJg3rEP7aGztVmSpbj8n9QXfZ0OoN7qGdhWHBkxH8NjQuImuFb3on4wL9EAbQdL54i2dCddX29RuHvDzJamaNPisUUr08w99UG1gON916atRL3/ttnPXhAaW8yuBDbwoHyNh04Gs3v5BHhcyqnenT60wlVinQMTu4qFlbgi00j1zgblZhJdS78jBzTHeC08W8rvyBAVC5v94caMmFakUS7QyxA5MGVYeg4/HaV7C35q8W3F7ZEp6vAHEk08dwAlNLyM4oA556Y509U9EGw++jVqabQpsu8sQnOl0ZPOM6DWqJGzZxqccGSy9+b648YHkyxEx6ILREm9UPZroypbpyBo5+GJk7WfQcl5Xdp2AN28RcC+yayYtlT04nE7bMQpN2fdLyhVrmVI5AZ2wzj2S5s4i7Y0NlUhBJaEOvcgIGQ+ntMWQZRRkH7gTs5FDu/GMe5HsVFplrkinnTjbL1ni0QyWnW/sPg/s7G0gJAAF3IlpvsVnSLkkUm5QGjCiIMUeVsoYE3zK9ZwTHNGBMwBwzZEP6SPL7iGRSsUM8K1oOdBEuvsptfwK6fowJ0tgQ5Q+dwjwc3tAFy6fAIjFUrOdk562mjk949+ezOoeVMBAul91gZxpEX1a51o6
 /AbVIhMn
 efGF2U2Z9emlpSOfBOfANfKazooZ6hY2BHFpD2IzTXD8fVnpeEkYfwhWDK3wHzrUja8eEovEmHJwL//w2RuqyrU749HeX59x9yqXGGGfadG/emem0iJiLyRytodtGD9mCEpVb2wUZb5rnMgZwBRNzsvMQStGGsecje1KjXdDj9/AkIrZguB1Hu60jHSvDeh8WnBi5omiHJjGZKDLZHHzofgvkgqPhIq6B07vOHrP8n34ygoGSx72m5UhXRw+fR1iZrBnDrVAEJt4m+7pN0G0P0KdVb6IoDOflTunhgDVLk9a+n0T9YSzDviN/94IvuOnXohhmsJe4f/GxtgA48c2iAbDHWd1hnBZqlxEK2LMTeBq3r/fnm+XEyiMm6q9HpX2S3+QmXn5XKBX1tUZNLdMyNhB4Uviw7elAcqJ75b/bUbyUqnAqrl3a9czWkkst2TMDE1XE4lGASKZr+bsSDB6Jw5PyJmvgEmk0exh3jKVEl/jeKpdEZEjhl1rpn/EIn/c/R1IdCinjD8KIqtA1BJWGUfGbaSyHIWXSnOX6e7A+E95jr8yVU6pkRktHnuEcX9cOi6e9zDwzYUDrNXDZeD9brddCbSmZJkgCPyXt3fftcMqpvNllbEF3ZcYWycNjyGIM1FTaJtVqvhsVqpmm1ixtFkkAFmcy9kZgIQmeg5pFX+ZN5/YT3HDtvywacruzqA1HcQ6PUoiS1T3kTtQUivinpnGz17+5oatNhrLEH8Og9z1AJCeM0HO9v4BGgLnysUu5dzr+Jkyhp8xkN5YJ7R6MV4R2pPZF4J4fxpWHGB/oZwQx07ruFowkRAVEjbZRtr4JRw7q3hwA0KucsWQDKYqC9cQve4R7G2SL3/TRLdVva585xTM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 19 Nov 2026, at 8:42, Kiryl Shutsemau (Meta) wrote:

> When memory_failure() cannot split a large file folio, the folio stays in
> the page cache with the poisoned page in it. do_set_pmd() refuses to map
> such a folio with a PMD, so that the poisoned page gets its own fault and
> SIGBUS. finish_fault() then falls back to PTEs, but maps the whole folio:
>
>     do_shared_fault()
>       __do_fault()
>         PageHWPoison(vmf->page)
>           // the faulting page only
>       finish_fault()
>         do_set_pmd()
>           // backs off on has_hwpoisoned
>         set_pte_range(vmf, folio, &folio->page, folio_nr_pages(folio), ...)
>           // maps the poisoned page as well
>
> A process that touches the poisoned page takes a machine check instead
> of SIGBUS from the fault.
>
> Map a folio with a poisoned page one page at a time. The poisoned page
> then takes its own fault, which __do_fault() turns into SIGBUS.
>
> Fixes: 43e027e41423 ("mm: memory: extend finish_fault() to support large folio")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
> Found while reviewing Usama's fix for the swap-in side:
> https://patch.msgid.link/20261116063624.1382944-3-usama.arif@linux.dev
>
> Reproduced on a huge=always tmpfs, with a THP that vmsplice() keeps
> memory_failure() from splitting. A write fault on a good page of the
> folio maps all 512 PTEs, the poisoned page included. With the patch it
> maps the faulting page only.
>
>  mm/memory.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
LGTM. Thanks.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

