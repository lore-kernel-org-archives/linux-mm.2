Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F59DFF8861
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 00:50:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D32CB6B0088; Sat, 25 Apr 2026 20:50:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC2976B008A; Sat, 25 Apr 2026 20:50:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B84FB6B008C; Sat, 25 Apr 2026 20:50:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A09B46B0088
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 20:50:57 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 54BF9A0456
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 00:50:57 +0000 (UTC)
X-FDA: 84698877354.19.5737116
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013068.outbound.protection.outlook.com [40.93.196.68])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4DA7A4000B
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 00:50:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fMEvDcf0;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf07.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.196.68 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777164654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C6obAYdsaVw1n1EH7zveuzmetanWFfJqfA4jEc8y4Ik=;
	b=Ha2vuh/JnWRpk9Zd4uEp1A0nNToC+HyS0tbmufGGZ3WBs9NsRvow3wRr5onJzusHCBF0Ad
	cd9ylWoRoN8foP2d8J+zEfQDkKtCybFHJHqkZXM9oMY9+lsWQbvQYZo4+3hTOW8dnuGVGO
	1FM97mJat5iIHU0MrVMzPQyoiuDuCoU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777164654; a=rsa-sha256;
	cv=pass;
	b=wcM/iwRpvteO9dLUlYisyZFtFl5oTBdfOj9bUsD6uKjMZABDUyrDUl7lqNRVXf6EyyCcs7
	vyoCdyfpdMgzcpOQBFJuPJffypE336KtiUWCMVMGFIxsmp27ThchVuAseZdWWps6BHbc0f
	RYjLPhSlwmVTMr8iZW9vy5ZxeRcFPKE=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fMEvDcf0;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf07.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.196.68 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pdn2iwMsMnIBvPxojAXm466cbETD5jLPqYDrIyI0p6CSQz1S8L2V2Rfc0KpaNafiV2/XXtglEHQEnMnTqXyuBwsKyoh9rkQW5kTbRxWIdFr/uDqT/+grXD2LAa3nXPO9SW00dv1zI80ulmfNuUKDe4hr4kubC/ge2WmZvC6QcCwezJvZB25fK4Qol007Y5/zoV+O/7NVzobaeYcneMLX77iDr1NN5qOeHPzBlfKFyKRE2VFnS+lC9pDKtjkR0fMgAlJZmh41isEj/jmNBnDvXBuKE0a5/PmyVXsG5/UxtNHVSA9HqGsETCBki7pHDSVIIKU3d43YwCm/BAc8DtNYQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C6obAYdsaVw1n1EH7zveuzmetanWFfJqfA4jEc8y4Ik=;
 b=i5wo+BA+Blo9rnflqQxBFMUIMqARMZ36HHN5+pVr0/sLmJor9R2fE7YgjZdTs6h8G4/3GcJE9p42v3qMeFcKL1z6aQBUFWrYxmbk7X3WUTnVPRwyCR6BNN4JA7jzwkVXGfZGUl7NSd79mcGrix7ON/riAGMzjSdFK0BNrgR5omEGZnDvcb/ZeRQ7qmo94WLzQEBjoKnK+dT1gJIJVriedwdihPpmTsyCb917tD8nz8NhUF1RQ74inYWbf7/DJHgMmGt7wiUb4vrD8X0atfQyUpeLfv9cDahKfhiMWLZr1NLO5SIGcH7xN8fgwn3m/OyIfV42GWVAabSRDhTqmSArUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C6obAYdsaVw1n1EH7zveuzmetanWFfJqfA4jEc8y4Ik=;
 b=fMEvDcf0p/cHnf4urM+XEC9JptpPYwHxuNoFga35d+DOWDIMekAR1oNfUcD486QG2kFNPHW/BxtMvSTH47ffjv8khZpo3ouTFpCA699iGwmUywI96ebm7bVGIgGyS54/ZdNGB9YSp6nFZCuwpzdxnzZ4RaPbdRTiEJoaA5HanlcXUg2xBrMIa5tdYd1r6VFp8kJfTHsBOLwUD+3xpQsvoIdtXrGdG9QjdCH4MS5CgdaWVfsOPDHAZcJ45aRMfHJPapZrtYPyv0ukGZcGWtkphoJDrr/ngbLKkgOot6T5f1ApW1KNTpNp1i09zj0y9NARMpgSVhU3OYY/9JUeVv2jTA==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by EAYPR12MB999132.namprd12.prod.outlook.com (2603:10b6:303:2c2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.12; Sun, 26 Apr
 2026 00:50:49 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.20.9870.012; Sun, 26 Apr 2026
 00:50:49 +0000
Message-ID: <a0377989-5c2d-4102-bef6-86480ad09c87@nvidia.com>
Date: Sun, 26 Apr 2026 10:50:42 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate_device: fix spinlock leak in
 migrate_vma_insert_huge_pmd_page
To: Andrew Morton <akpm@linux-foundation.org>,
 Sunny Patel <nueralspacetech@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260425133537.17463-1-nueralspacetech@gmail.com>
 <20260425065411.39842a941750fadab250cd79@linux-foundation.org>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20260425065411.39842a941750fadab250cd79@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEWP282CA0034.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:1dc::17) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|EAYPR12MB999132:EE_
X-MS-Office365-Filtering-Correlation-Id: 6eb8c914-506b-4ad5-ba9d-08dea32ddba0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|10070799003|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	1JwYyv7cPu6qmgiKbXuzIbYnc8sTsA10f6unJ8/5F6GG81HeFiFHCd1DWhE/7aW00WxHHA0uA8mB7D5X1nUaiUIZmWXtwXmYmPHikJr2ovyfvz1HqOW6r+LKJElK5sp0vtAJm07JTodsAGG+M7HxP24SWL1BMttOsx2nu2rzPv4LorIMF1LOT4WQ16wo/24GhNpnMTUCY0B2BsfkxO8Xve/4hIzTlW/l34XuAt92Vhun0Pq3TeDAzBMBc6vIF/wsJ1ga8SZTGDE4jipRkrErcXNe0OHicLQTfxonU+hqHToSi7uOIuxvJngvUhwg+NzgvTI8pkoxDpiAwcH7K4TnA3d93x/Gn0y01h9pEuKynbKvznKj4rj+jmf5Py17H+rg5DBbApKtkgYGRegXqTo6JNZ/IfJutUwq6TeaySceUNsbdRUkYRDnmD48YLu+huSFjETCmrQvJlnEMe5PLGKLJEdapmunJfzPGATVx2xXKKrdtEUQU8xja6vCMO1NcOadEQaXd6oMUfr5TNwsZBL60NPVwDQit/sMm0mf5UlLJALdKiCUIQboLd2g3O6+/ZPAQngi54aBqmfS92KHySauHQrl3Lbz9Vve63KkoCRb30hajOKUJEiJzWXnRtcqw0WcU4K/wP2Nbv0CNNOBXPAblKwKc3VYgkegtUgGq4/QtvlHfQlooIjxw51DBLWHul5GwpjaU4s70mfoVcG9wgT/kp5kyi7AIIGuiIE/BrqPYCA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(10070799003)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z0RCT080T0hXM0hJSzZjczhpSnZCVHAyZGEwQmFLSW4yQ01mR2RQYnhlMVpY?=
 =?utf-8?B?UUJoMkUxQ3NEekJreGd1MkVsQ1VtbkUwQmNGR2oycXFjeXZ4YVkxQTVVVmsr?=
 =?utf-8?B?WFVTbFhjN05NZlZKMnl1dzltMUdRWVIrd1pRd2hjSm9aelVvWjBVTWNLK1R2?=
 =?utf-8?B?bWJGTmhBRnBLbVlQdVFvc2FyRXBySzhLbXZsenBwaU1GVDJwS1BKd1hmUlhl?=
 =?utf-8?B?TllHOVI4S1J4cjVtQVZmaDhiUHFJenF4UHpUblRqczdWUVQrcWU1eDd6cVkw?=
 =?utf-8?B?K284M1M5dEdYUU1YNW9yMFlsOXJyaXh6eWsrWkZ4ZmRTT3kxOUFsaG8vV01N?=
 =?utf-8?B?eGtWN25zUUdTeFJzQmZkWTJ3Y1Z4OWtqdWNIS1F0NStJb1RSemRjRUNSR1JC?=
 =?utf-8?B?MlhUTTNuaW1ycUMxZE9WcmlKL3diemZ6dVpRYnV1bVc1ZHRJNGZja2MvanBK?=
 =?utf-8?B?eTZtS0paTzN1WTVmTExNWGFNMXZSWUxNN1BlZ3hiTzM3N2dkbDdkWnMxRjF4?=
 =?utf-8?B?bk1DaStLem1tY016aXpEVUszWWlKUjdMZzlSZS8wek52NGJqSXAwOTE4d244?=
 =?utf-8?B?UnJKd1FjVFhaS01hZFlBVmo3RjFyUm11UGxBYVhYRTd3MWMrUG9QN0NDajVR?=
 =?utf-8?B?azlaTVRUT21aVXM1Y1pzSGxuZmMxVUtGVkNGWHhKOVB5enNyeExCMy9CV0dE?=
 =?utf-8?B?d1RmWTRmY2x1TUNzeE5pV29xNWsxVlp0RlluVWNlRkNlaktyZGc1ZHlFdDhQ?=
 =?utf-8?B?dWd0akhvVXdJbkhmZ3V3aE9QelROd1BBektNNGlmR3FaRUo3eTQxMEpqWlZO?=
 =?utf-8?B?Y2hMc2JkNHlMdFJ3Zk1VcVFCR01IdXJkdElmV0pNNjNvU0JXREVNWWZpaDhB?=
 =?utf-8?B?eWgzeXdBdTFObUhDMGt3ZTlRSVNsMXVJTTR2RG5lb00vOXovT2hrbHNPbzFt?=
 =?utf-8?B?ZzVFUnpnaXNZS3lhQTNIdm9BRThlRXlSUndKMlhxSjVxVDZBTENYRlpzTWl2?=
 =?utf-8?B?Rm5HclBlTTBvYU0wZ2hwTjNkWkJRVCt4NGsraXhlL3J4Zk1uRzVHZ2pvOGp0?=
 =?utf-8?B?dWVIR0w4TkZ0MmtrNkJEOVVqN21aMU9BcEhxYTBURWNpMElGZWtBZEVFeHVD?=
 =?utf-8?B?M096c1duSStiZVhoYXlxSjNDb01QMi9kaCtRTy9KRmhpNUlqZkdPWGNKQk5J?=
 =?utf-8?B?bjhuOFZnaUluaTBGQzJZYmtVVXFRVmQ2VkFzMTNsek1mOG53cHBHNUEwcDFL?=
 =?utf-8?B?OGgycFdlK1JpcDhZbjdENE5qSjlTZjB6K3VCc2dJeXR4dm5aaW1XYUVzaXB6?=
 =?utf-8?B?dlZiZk5lYnFWcnpYYk9NWXdhZWoyR01WK3BISXhndlp6NnA5RUhtZEYwazZm?=
 =?utf-8?B?aG11eWQwaTU4d1haT3VvdjJQcVNXeE5WNitieDMydllMRXZ6MDI1NzVXd2Zi?=
 =?utf-8?B?b05oWWdheFFGZHBsaHc4NEx2U1kzQnJzODlVZE0vRmVHaCtscXhwZno5Y1hM?=
 =?utf-8?B?MUNWMXpGelVRZXh2aGVVaSs2R3RleHl4Ny9leGhoVzFXRjN4M1FqbU03ZGN1?=
 =?utf-8?B?UmlkZm5PSHhqcjhiTXNNanlRUUdWNXJ1Y0ljMThTeWE3K2svY1dhY05HSGp6?=
 =?utf-8?B?ajRIOE82ZzVreG9NckFFSnp4RnZXVVVCOXhDN1dQMTB6eXgyQTE1UGJSWkl5?=
 =?utf-8?B?NWdsbE1yWGx3MWtDbnplRkg0QXJQTWJwYXdYVWJTTnc1T1FSV0RTdWdhbEFO?=
 =?utf-8?B?L2MzSHpEQVY1UmFCcVpLeE10c0xNMWNSN29EYTdiYjRMRTZqVFFMR2dac1dT?=
 =?utf-8?B?aTVHMXhNWU1sWHd3SXJlcDFOSlJGK2NoeGF4eFBxSE9XSk14T0hua3huTnJF?=
 =?utf-8?B?Sk1FSW96MGJ2THBuUEFYbllwSzVKRW1WS1kxR1Y5TDhoOFNScjhyNUd6K0tu?=
 =?utf-8?B?c1B1d3Y3ZktPK0llWkhzQXNJWnBXUzZMWDBnTEtOUGY4T3pMNzFRdlpDZDNv?=
 =?utf-8?B?NkJhS0tZem1ONVJmWkw2Q0ltRTJaMXpTemtXZTdFMkZNVHRzcWhiblpudlVS?=
 =?utf-8?B?WmN0QVVQNGprcnZzbGV1SG5rc3hTQWVwQ3FFU3hIRGlvamRZTElVdWNDZFFo?=
 =?utf-8?B?bUtnTmtLbThBK3ZrdUtqR3FnRXk3Vnd0NC82QXFDdHBYNkVua216dXdSRGZZ?=
 =?utf-8?B?SnNqT3d5QkxaSnlIMkVzREQ2c1ZSS2M0VE52UHU4QTd3QlZGTFVSUEp6elVj?=
 =?utf-8?B?cHdDMmFlaHdVQ3FsMExJa1F1T09nL0xGcXp2SEpjdkRhY01WTHptb010WGdw?=
 =?utf-8?B?MmVHcTB0ZlNJSlU0YStaNVFhMXAvdG1pdVRLckp5NEtqUm43YldCbnRXelUz?=
 =?utf-8?Q?a074dvFl0j08NFbtSoXbydOTA5/nSvDztYEgBfD1m50g+?=
X-MS-Exchange-AntiSpam-MessageData-1: 2fkukOJZ5IE6HA==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6eb8c914-506b-4ad5-ba9d-08dea32ddba0
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2026 00:50:49.1452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BxRomtMolGTQMmkMrBmnx00TYdcOAJYcF+lz0GVE+lT2hdnNyVb3eV6b5hXjNIrutZK1S4zKlaHatXiAXwKTMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: EAYPR12MB999132
X-Rspam-User: 
X-Rspamd-Queue-Id: 4DA7A4000B
X-Rspamd-Server: rspam04
X-Stat-Signature: ae4167h7zptimajkttx9x8b61jrykoze
X-HE-Tag: 1777164654-54891
X-HE-Meta: U2FsdGVkX1936MXi/bXEqIC/ZTA8GBt7OeM5cp+tqCnPs5CrK8q6z6JedxyE4wsaz+0+ACVig3lGiquFLb+5JvRQapIBQ9Dxjg6mDwxx+X4P0iOOW9AkaSezYDh2AckS/95XtKVGz8Hi9LRjzuDKtVw48Mcz8POE+IhN6x4NOY52gG0s1FSEl+bccTvkkIePGBA6tXzxz5pswnPYLxojo77qkleeRqv5kFeAO5g5ILpP6GIaiW1nWfPAP8/hK0VrD7M0l71yoA2PFfDoCPQ8/W2Y6LoUOfD7pt6Tn++2Q5+FKn1JTvqqBOwrvsuGNuKcbIT58kiSM4FL2rqHze/f3Md2RRVHlRLh5YdDd+a4SBQoFl5DEoGf6ZK9kTp1SftFLUCNFC538FGETLvT44die454kCvktQ83prtMsBFPPhk4fod9A9Nrmf7CtSZ4mpG967Lzvuj8IrQsZMQaVtr096W3d59vkcYLSJTgf/8V5JdHGN3p4de3t+vX5O081U3eP2NwRBGDkhXbTOB0YF9pqRQvLEAtE5SNLinetxCL/UlUwjrAPhUaDW19lOd41blSXBi8abHHo5qMzRX2iR9Ca06Bhx6y5NLbMSqxBxeZBInc+AEMXkoHckPZb3b+TYmT7Ed7h9B/hvClgGexRAC2uSjT2Bj/K08jIvpUMXXzLFJ3DNTmk9dnTiWq8V1i51UEvnrL3pm3hpNClU3948wnOaQlrudpPbpD8caGbcaL3KFCr2JUF8v8LQW/U2VPORPpzcvMrQYbnCpdIQR14VZSpwCcbja8ifwHN4973gMH/RQpOlc/Amv7BX5Ip03olUHiJPxHh8FfLCOEKp2Zcz3rvfQwJj9aDYkrspWhKkyKYaL1HM5Yke3d1hW+cUkB6pURZHqvrWu5v7vb6W0sqX1bO5IKYmz4vEGomujCkjjHk5nt7OQINhAffadbhik0bwXOxYEhDhbDHezPlzSCU8x
 21zlTGOo
 pQ6weiJQVNQUhbMo03sIz70ew0RwEpqDO7PANN7pYrB/vrd9Rdhv/4rJ6MZqI+vydzo1+wDNd7Ewz+w6oSI4/7vnvUE1IuaQq8bKMqOAaG0PB52V683eUqp26C0ckWFIAWTwdZ1ZCmgkyOvevMnKl4AnuEwkIsbjYAiVanMQbq5I8+KO7nfzsSVCNiS/KZ+rsQvKyXsFdg0RNFOIHHb5QKCtBqdp0B1X6K6cHqVCNjacVxYN0+wj2iRVHweukoDYCDVCmdPxIR6qXcVjLJXKFwZ5G76DH12QDSToPF89vbum790lifQ9h5plHY4Y3QyELYaeVnJlX+hGe2Bz46Te8jKNVvEB592H1lMcOe50ms65sFlGSo2C5TvPrWJ9OdRaf7nlnatqEpk6FKpW4hAsRfvm58B/Fy9wh+YByR77RmzQuR7NWpfQhQQJSl2dRHW/1EwvH+3upuOvcEUcszBTcAtLvu5Ta14vMSqlLA8MU/Rb+NS55MnM76yq/fmCR+Y2VKttRDlXrv8I3UFlzKjxVHyShZuQMU8WASQKT1sJexGEWNECsE9RJoOZtLFfSCAd331GITg7gswfAbQNI8/C0MXWmwev4//HYRBm6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/25/26 23:54, Andrew Morton wrote:
> On Sat, 25 Apr 2026 19:05:27 +0530 Sunny Patel <nueralspacetech@gmail.com> wrote:
> 
>> When check_stable_address_space() fails after the PMD spinlock has
>> been acquired via pmd_lock(), the code jumps directly to the abort
>> label, bypassing the spin_unlock() call in unlock_abort. This causes
>> the PMD spinlock to be permanently held, leading to a deadlock.
>>
>> Change the goto target from abort to unlock_abort to ensure the
>> spinlock is always released on this error path.
>>
>> ...
>>
>> --- a/mm/migrate_device.c
>> +++ b/mm/migrate_device.c
>> @@ -850,7 +850,7 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>>  	ptl = pmd_lock(vma->vm_mm, pmdp);
>>  	csa_ret = check_stable_address_space(vma->vm_mm);
>>  	if (csa_ret)
>> -		goto abort;
>> +		goto unlock_abort;
>>  
>>  	/*
>>  	 * Check for userfaultfd but do not deliver the fault. Instead,
> 
> whoops.
> 
> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
> Cc: <stable@vger.kernel.org>


Thanks

Acked-by: Balbir Singh <balbirs@nvidia.com>

