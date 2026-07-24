Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97A23C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 14:01:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 948946B008A; Fri, 24 Jul 2026 10:01:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91FC86B008C; Fri, 24 Jul 2026 10:01:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 836DF6B0092; Fri, 24 Jul 2026 10:01:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 584F56B008A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:01:02 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D268E403AF
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 14:01:01 +0000 (UTC)
X-FDA: 85023831522.03.3B6E60E
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010017.outbound.protection.outlook.com [52.101.56.17])
	by imf03.hostedemail.com (Postfix) with ESMTP id DA0532000B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 14:00:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EDbsdMqF;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.17 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784901659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eg1z7pWgfMsp+JkbtTGcKPBwFWmrAgD7M5gqYlN7Mx8=;
	b=NtEWx9YA1zme5s+Gl3bUlDbkbiA9vEGab6urQ9t1ROB4Q2g9mSFCbYLqwxuLKL9G2UmHUE
	CZOKtvd4D/rxv4R3PCCxviTLSmEhDgwLUe93qVPBjvr4qCG4dGr+aEjkN3DBQWsg9IbL+J
	+2iqPGvXtMiGFWZPiZvG/GyeGWQeRiU=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EDbsdMqF;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.17 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784901659;
	b=zMXSdZRKoAZLjBntnylZMi5DGEwkwQ1/vVED6ii6jk4+krqRBPyNj+YanN+XiqxVM1+Uqi
	bzz3pQWs/fYARiq+CgABWaXHT5eqJBtimU38ilWdYAKKrAykxqBMC/GnL6Rz6K5sGZ6QpE
	ir2inWQro+dMAVgdlvAhj20MiJzxUHQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D3jkFCVy272/idZZjMXKvWLOqp9rQifWhzGbB5+F/0rClzMVeXTatKtTPVgNgVeAGxmSpJr6dzoG6HGX0/tE/ulOjTW2NQ/0o7Teheww5IC+61J80llESnSkF0h9n9KGLz3FoX3RKRp+vuD13LWFkso976ml3A3+kgNlYDreXcVP6JjqXcLCNo08ts4mNknXn3jCAjy3e7CFqQwt8zItV9DXlxRrmYNLruJHaBVPJ9idjy1HjlZU7Z+ArcIBfIM+Up17zgWb4f+CmBcwbM5upWiTa7hjCtLk4ILC07O0LXkCwBkR0WtfL6cIbdE/9dxf0bDPvmJPdDy5hH7FBACS5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eg1z7pWgfMsp+JkbtTGcKPBwFWmrAgD7M5gqYlN7Mx8=;
 b=qmImNb4I9LXEh+2LT1JGNO0FCbB96xd7AzjvREX752W0yVKmc8ECmnpRbgxCp4ziPwoEBeaKMt0rGe6DKBjY8yjgcLoyzsJl4q6Puf1MzUwGof8PZuxLy//LNa1t7kfNA+LRN739NVoruYP1Gorm40irjHqZG5N23Udc3ugAXOzIxwIWTTpBgOARCcebHbmcQiDWpcl3POWFFDmmbOZo32pS6KEshlikWT+HmNujTFq8EeAbOHEW10WmXbtER2jbJwJ44lFSapj1z6TzlSb6ua5Vq4O3PZzLBdSjbHEWk0V9lRCX3UewZfeuTLQ0eXN0Ared255ApKLItxzVP/s6kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eg1z7pWgfMsp+JkbtTGcKPBwFWmrAgD7M5gqYlN7Mx8=;
 b=EDbsdMqF2iu/5a/pYOrpWWxIMzmaDa39d7YuNUHQZq9aujTObOfDtklIPASDKpauiiiua9J71oYZbYFFALmL3QhBrEcS8f6xHqKZwScYAb2VnMklEDwglwI1A3JHVuNx57tqDtoYa5e2jrZFTODL2P9HscQaGwgrt3IY/v5Z5rYYHwSTucpeNuCmJHmbZ8+CCMyaWz8ng8lsBnUfxhPk30+yNuvUhmLpzAlnEDkpI7AzTmXE2G40m9oQxsbkM8DD8l4CZa612IA+uAR08wpHrW11uDFHuLmExiqW1SFkNP6Q/abzFM+Lq0VpPY1b17IKJvY9Yu4J00vC/FroLkSEzg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CY8PR12MB7362.namprd12.prod.outlook.com (2603:10b6:930:52::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.12; Fri, 24 Jul
 2026 14:00:54 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0245.010; Fri, 24 Jul 2026
 14:00:51 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 24 Jul 2026 10:00:50 -0400
Message-Id: <DK6UTU928W2E.3V82M9GO94VI7@nvidia.com>
To: "Arvind Yadav" <arvind.yadav@intel.com>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v2] mm/migrate_device: Clear stale mapping after freeing
 swapcache
Cc: <akpm@linux-foundation.org>, <david@kernel.org>,
 <matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
 <byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
 <apopple@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260724082702.2531024-1-arvind.yadav@intel.com>
In-Reply-To: <20260724082702.2531024-1-arvind.yadav@intel.com>
X-ClientProxiedBy: BL1PR13CA0097.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::12) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CY8PR12MB7362:EE_
X-MS-Office365-Filtering-Correlation-Id: 45bd385e-1d02-486c-3423-08dee98bf831
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	WPFU1GNp7JvzbCJkzTjStHMgAEhN3fJZJfpot3wZfwFzfh1/Em11I2FsxChzsetjco4R7nVy5HeTPw6bkP/gnA+8C1gA9kNFC8FR83Mo2AelJjqM2lgneg8lOyrzTddgrHgSTKljmWkeBmryF1j43UZkpHPfHcqujByd3uDcbuy2mbTOaVfGzgAvYE/S9IuzwgdnOu5+ZBs2qQfGMx0yIKlbBzC+RMT54foAFDiS8EqG4PsW5UvNXlun4yvEOaPN0iYbyBO7v7y3lVZWS2zg8jGGe7SQFK6ARqLLLVSD3DlXbBIhSvJd4FP2FWGt5+7exZvc0xMpm0ThemXFWy6LVZCF+e4L2wIPFUbRqM4SiFyBVf3MqdpA/ebJ9ej1rnTG83EYLTWbT35iowiq65fDSw+Gq70x6D7igBCfxd3uo5Vj4/bpeFktAjXMgRJgOBmd3Ut3wz2sySKLVMPYTM3oL7C3WjUGx5qpMLHBHd5IpD5aW2xKwqDueN8RxYCX069VwttUpnrn9LJ7vxARTilPeeqoGHDSnxvMJpBT5UgegCN37UeZSyBOEa7uZUrdu6BxfLQPkEGHEJIrGReE0rQ8WlAQdbOzWDydADEi1SfB1RVRaHQHQv67dIkVUYMYeC2VtS36zXlb7a9oGUMBKyGSXL1UEqV5Dvspliix92YB/7k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Ri9RYWY0OVZaWVlZM05EWVVQbVVpMDVVV2xoY3lIcFQxV3NQcnMwTWVTcWk3?=
 =?utf-8?B?ZDN3VmhheTMvT0VYUzdWYkd3aWFjaWFIQ2ZWSkpsVFpjVlFldHVzV3lhUWcv?=
 =?utf-8?B?SUJjOXoyQTE0aThjV3JualU5Uks1Yk1rVnJhaVBLMkpjV2FmL2VucCt2MlJW?=
 =?utf-8?B?RWlhREY0U04wVDhlVzRGcElMRkMvb2ZJaWczUGthYTd0R2x1RkdkcW9WbUNK?=
 =?utf-8?B?aTJqc0dmUStUdXJ3eEtiUVNNeGprWkZzZUNsYkxKM1dTVjZnOXYyQUNQNlo0?=
 =?utf-8?B?M0k3cU5scmVKRmVyWmNkcEJ2cTQzZi9aSDlyWERtazFBQWdFT1NGbElxQThW?=
 =?utf-8?B?ajJyT04rQzM2SnBWdCtsWHliS1ZqTDdwWnArSlN5Tis3WGZnRXk0TWp2Wnpv?=
 =?utf-8?B?YjFKaVY1K1hPUkJLYmxoaXhFK1htOWM2V0wxS2t0UFBVNWZtRzlXMWQ2WmF2?=
 =?utf-8?B?S1BVMWdyTkE3TXAxLzdSejZIWGs1cVVWdS85UDNwMytHb1B3YjdZaS9WZExj?=
 =?utf-8?B?cDRPeFlpNEk2alBWczhhcnQ1SHAwV1czR0J6YkpFZEtHT1pFc0Y1cTZBUE94?=
 =?utf-8?B?VXA5NEhacGgrTjhJaFdoT1VCR0JyM1Y4aFVoLyszeE9US0RGNkg5VXROMHlV?=
 =?utf-8?B?RlprcTl1cUhzZnhFc0paMlh1UDI2aGdJRHJuTEl1dHo2TFE1akl1a2drTG1Z?=
 =?utf-8?B?cWlaemVyQ29xazBSR0I5SndJWGVPeS85K2JnTk9OL3htUStEdCtKMFFTZFdr?=
 =?utf-8?B?Zm1tNXZzWTZsakF1Ukl4Y0YzOGRjTjRmTXpYSWc2MUtncW92emNMdmJadmZt?=
 =?utf-8?B?TkVudUtLTWp2WHlXQ0wxbUFtMzEydXRIVTIwSlJGUldtQkNDTGZqV0drYkkw?=
 =?utf-8?B?NVkrRGhHZHVHREl0WkJFUGNnSWlCWW5Bd0NJYWxzcHMzWk1MT1V5TmZKeEkx?=
 =?utf-8?B?eThGWmEwM1RHdHNkTmlUcmhTT00xSm4vaW5LYlV6VWRrR1VYRmRBeC84ekpV?=
 =?utf-8?B?ZkREbmRuWjZYazN6VGNhenVkNjNnU0ExVi9WMCt3dlltcktzcGRsYXV1dE1s?=
 =?utf-8?B?bi96ekFSb0VTVzRRQ1kzdU51UDM4NEtMMENpUlg2Y3NVU0JKVGFsVUZSS0hQ?=
 =?utf-8?B?MXlFQnhZRVpycHBWWGNObkFabVQxWXZRbkdBdGFLRXUrMXF5d1V3cmk4MHFy?=
 =?utf-8?B?T1Q1WWQzZ1pVS0FZZkRoN3JMSDBHZTF2SUdUZGdSU1dLalozOGZYMExqNGJM?=
 =?utf-8?B?cjNtK2ZSc25yYkgrUDZPZVlGTzE0R2NPbE45ZndiRVRqZVl3WFB3UzY5Vjdj?=
 =?utf-8?B?NVFNWG9sbXVaM21WREp1SHdhRHJxczlXNTFRNWNVckJFQWRKalZwUXF0NmR5?=
 =?utf-8?B?c3BLRWxpK0QvQXZaRkdJTkQ0eThNOG1GalZja0JpNFkvYngwam5CUUltNWNS?=
 =?utf-8?B?ejdSd1lYeEZ3UUUzMXBuSWtESy8zeWVaNzR6OFpBQkorV0F5Z2xuNWpGTlFr?=
 =?utf-8?B?TmppampSVHdmMzRRSXZsTFZjVSs5ZXVrZ1JtNnhEQXZmWWxhOHl2ZlhzTWxC?=
 =?utf-8?B?aTlxQzBLQzVUeXg3ZllhYjI4cjlVR25CcVNpT3FPYVNSc0JQODh6V2dCa0ZE?=
 =?utf-8?B?Q0ljTVBEUGFzdE9CM09DR2QzdTBiRUc2T2htMUJaNWFKVUMxRWdQU1NuUzVj?=
 =?utf-8?B?UXpFaldGaWhCaGNIdW5rWWpKMXJqdXpVMEZSM1YwQlU5VG00dU5IK2hyTk81?=
 =?utf-8?B?WHBiRG5SS3VPTUtUNXhSYmlGWnhpbFhtUU5xMThSdGE5R1JWbzVhU2xWYVlr?=
 =?utf-8?B?WkVyMGs4VEFQcUUxdEZtOEpScWFxeWdVdlkyMGhrVDVoZUY4dDhxZzl6T3Fz?=
 =?utf-8?B?eCs3TGIwUjloa3NtOFFFZXlpZFNKU0h6SHUyUUphWGpYMGxQOWJKcGdEbGUr?=
 =?utf-8?B?VEFrQkNBV0o3dWtnTUdoYWE1bjRKL0VEVnNMM2UxVXBwRVltaVpSUythWFhu?=
 =?utf-8?B?eVozS28vcG43SUtGd1JKYmp0UGdMSTh6d0NrK0hKbW53VEJJaVVTVHIxajFx?=
 =?utf-8?B?NkgvZEZDLzhmZXdmUk9oZytIb3kyckoyM0Zvc1duVGdBM3JZOW1PWFByWlpv?=
 =?utf-8?B?NWtRK09VUWdjZ2V2SEZCbVphV09QV29sVi91ZEw2Qlp6R2FvZHEwQWdSOFFL?=
 =?utf-8?B?OHhURmNDYnArOXB4M3hSeHpJRzhtTFZDRUNrYnVmTXlqV1h1Z0swNDNxU0dG?=
 =?utf-8?B?YmMzT2ozODZDQlFkNHVFSXBHUWgwWGhDemcvU2xVL1B3cmIwTzRsQnRBQTJE?=
 =?utf-8?Q?mU+NO50tJeJF8pAxfk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45bd385e-1d02-486c-3423-08dee98bf831
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 14:00:50.9352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: McXwz+YpHFtRT0EQ3dSq8TqeZ1FagXuEfZKz6Hjpq8o3pgZZUMkYIesnqBi9cVAI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7362
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DA0532000B
X-Rspam-User: 
X-Stat-Signature: xzjqx4u97x6k69ftis7cnxntddyi9doi
X-HE-Tag: 1784901658-601233
X-HE-Meta: U2FsdGVkX1/05TX1OCaWSftTLe18abgOCL5opwyj8SpxuhEk67q9If7WeQbLs7oNJSLzU984mUeLZCe2Ert7trZZ6DZW3x6vT9/jzsTRh1pm2oUHnrlxv81vPcBAQMODl0CbcxBmIZuBY9NGsUsshMWEJbtFqkvewnffqPxFxngV6cpU5DQstIDUn+ButP6/lnbexzkxIrOBkUoASMx9yhJ9IcRQW40rvTsrC1jjMhb9a15JG5lR3ny37mSioVpMAR+yBNLDvM0wY9/da7C4UrdBdGl3rPOH6c2oMaAD8+H5emR6uf/aTXqZB1TBEi8q6EC2um/BMRV4W9koTtkes6T+In3VbwQJ0VM/8ZpL+DPGcFLjW+s7QzEDMleZrRdZ8w7BkAnwKUOToWUTB0L+5xK9LkbpPjytHCAMJWkGW/5XA0ZnvQpzyMipRSms91ZXio+UKdmDRdmq5HlFjLKi1SAcaIeBhaYoIT71VJCKqcUeSM65VriK9KNxmp8TmOR2JB3nsZF0K/x4/ghYfMww4uHzbD9KhfsFyl1bi05LXJEKuDnmlFygncKU42NzO7wKBUi0uNs006GAMjrmuBEZhyFxjeMr9CDsh7WkbsDvNM4grUmzp67PhaaR39WqFOeKx4LjV6hom2i0yP0PL4uFCDpwMpB07G34bXuFizBNBdVLMomeHdk4MrDz1aMxjHlaRB3CkdM5aJIzTfjf3Ofb6R2QH4+WkCAPV+ftiLN8oNnnELOOg+n5D9Z4hJ6IeS5fdVgdzqRWRKhma0HmPakJWSkKL3wJ7x8mxwas3atoZhh5KWejjr7D57WoofYRHZNgpAGTcCMzYTdCzXejkPNIGGoBUYPcgA5/KpTtiDEcGV85iR7YTQwcLdKktPSSiAY5WiGkKRNaBmHeVLwCo9FosndsMemqA8TV++GhOQDHxpRF4o1EIFFe0Lod4rtErIRDrgr6TeiUJZoJnf7JT8q
 LMrThwhJ
 kEBSqbKpa6wh2KnGuQApsGw3LMpAogiwYHc5mfQM1VlvXBJd9qNJtuKzskU7zKAhKy5d12U9Dc2ELY5kr6H+Lx+xtbfT1FljofbO/hvIWcQngh50Xf0zevOciXqH2A2e1kfJQuc71TwG4GmoiK/Qacy35np7imG19JqMITZOLMnvac/FpcGhRvURhObAiB7Z7uUptozECbwsIrsvOUz+QS6zFOael6gdDYWDYJNJsQtoUGzSqSfEUU4KSWD2mhKlFESv208pgP8EDNpT911fh0AeSSgVZd6W1lUBHSYgqQO/7IJdsRWVw6gdiuNol03gyUDQEF4xsA9SYMP7ffJzkzMzXj7tPjuF6t8P9dotkQ48onlRaJuC0yqLWLXgo4oUp4LYGnITqU7E9ugGrRqJ2/w3wnT1qBxLpfWXDP7VDJ6rDCxZkR42zkk07VjPsyx3vq84/2MFjyCpykaGbmkIf6dH3kNaX/sYfWXf8qMoYUuStU4vYTi2EsFtWg8YlReOrXBlc7ztGmdDKgPUT93W+LYElY5dKhHUkmCpKyHCWrlQ0tnf1T/JrOkR3e9Caqn0Ndvotit+xP5+BzCBb31xse49Stx2aOJX+/pz92bedQCY4LF2ifRxWsjp2T5KvDLz5ifivA1EmHMQzZbGT37V5frFARkjXUoKEqvmkOJ+jqY7GUmm5zu/aOBQtWk7X+pbyZuXv0OR7xJ0nTTx+tgsvN9gpmaqoHtdkIn8PRflWmY8+7H0tsAXDCIl+gII5ibtSJ3rLq0as9xQtzrIFYB7ecvb7kLrRxgqqOnWB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jul 24, 2026 at 4:27 AM EDT, Arvind Yadav wrote:
> __migrate_device_pages() reads the folio mapping before calling
> folio_free_swap(). When folio_free_swap() succeeds, the folio is removed
> from the swap cache, but the saved mapping still points to swap_space.
>
> Passing the stale mapping to folio_migrate_mapping() makes it take the
> mapped-folio path after the swapcache reference has been dropped. This ca=
n
> cause an invalid swap_space lock access followed by a folio reference
> count BUG.
>
> Refresh the saved mapping after folio_free_swap() so the current folio
> state is used during migration.
>
> v2:
> - Refresh the mapping using folio_mapping(), as suggested by Zi Yan.
>
> Fixes: df263d9a7dff ("mm/migrate_device: try to handle swapcache pages")
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Signed-off-by: Arvind Yadav <arvind.yadav@intel.com>
> ---
>  mm/migrate_device.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
LGTM. Thanks.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


