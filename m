Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74BABCAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 12:21:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C09E38E0008; Tue, 16 Sep 2025 08:21:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B93868E0001; Tue, 16 Sep 2025 08:21:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0DCF8E0008; Tue, 16 Sep 2025 08:21:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8825C8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 08:21:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5DDB3138524
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:21:57 +0000 (UTC)
X-FDA: 83895025074.01.0C5D0BC
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013001.outbound.protection.outlook.com [40.93.201.1])
	by imf15.hostedemail.com (Postfix) with ESMTP id 805EBA000C
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:21:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=oTWJJWAA;
	spf=pass (imf15.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.201.1 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758025314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hALjG/gGUN8TXNS63afq9VN9N360lq3Oij07SHwtIXM=;
	b=8dl48zTJSfGeTBdVJFNjdtHx90DDPvjkSnk0RY+jwi822aY2vNHOO9j5nRjVZROw4vo6Tt
	ssUd0ORCe7sSkfYcsbqp1o7ZzLrvQ106VlXFQi6x7r4V6rtdKH+/gbi+gtqR6bbe1Ff3ZK
	ya8PlBkquDPUxiEub+tVRxC4HUVkdGM=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=oTWJJWAA;
	spf=pass (imf15.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.201.1 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758025314; a=rsa-sha256;
	cv=pass;
	b=OOmmlwtLHfEoM05ZInEM0TrTwBjA0ZD5EMolhDZGRHVnH3/nc4kWCwnqPzK9JXUKBd6VSt
	gSeEFYDzVDB9UwV2JoZxc2fUtDH+eGqpyxktkSuntHleD9P9BDKcow2XNACrkBqZORVAww
	935/oAeasScUl5lzp0skImikKDLQxy0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qzKMsaVKWRWFyx0/17h9xWYZf4Rpd2Jwv6dLEwwiBS8451Kel84G1t2P6vS9A+vpIDbA3Vswzm+kV0Z6uX7+p32kcnXyAgdTxaEkOhXWwkZQoN8/ml3bbdwEu/sw98st5eMIBlW+94Qh8TUI8BfWmh4CUM1Vhe06H9sBYQKlH5fl8rsXDpHo6uDAjiY/SKWfEaXPSmxfMp/MbsANywG6RirHFuGI2xUkZwmu0zn6A+hgfVsO74GSXwFxsqu/q8Htc8UJJVG0SL+rvLBNJOFfCnRlcmTbW10wewQDFcorwaDXwxZzvEEqlmaxxUUXmMdirrQkrpHPPcN38vCdPAifKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hALjG/gGUN8TXNS63afq9VN9N360lq3Oij07SHwtIXM=;
 b=t++zQT6XFl0X5TrdrFKUEopA9S5PPmYjmUZS5j31usmWUWwY0W+o6RCXQyLb6FNRBBXyXeJGJBGgsBwS0p2k34otpX4K7+0PaonrxA1aH5HBrNYtJSZdYwXJZhDd0AUkPOCvt/O0J0JjpJXOH57y27ipOjOziYRgaoHpLbzxiOAEMNgalu9nF4DkkAjyvwJACM1fk2e1S7ACvQPQh5xWAXSpbH+uVIsguReDwpseaL6XjL5orzInyJ6OoF0S4rqou3N5xOc419l3HnEonCen6M8WnueYLE/BzyesFVfX2j765Ey9PrZvfhm3SuDi4v0L7P3/0e6/akqOukwqygqmNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hALjG/gGUN8TXNS63afq9VN9N360lq3Oij07SHwtIXM=;
 b=oTWJJWAAMnEYk7woNr1Qlet3pfpNWtzW8hIY7HCaArj8eXu13qwWwSlHV5vjKxqu5bGSk1ai5yQbO8demB640WM8mNEWJAom0HGV6LSuVZ5JaVmn0Mj4kGOz+BqvbkzpWwoLb5o1HY7IuXBv34c4Gi4aaBswWwt2qJi1q5RFjT5ZKVBAGZCBuObBhVaLTN51C65hjjjb82Pj96v1w2UFk75qRdII211d4Rxkj0j/sIPHr7a8fmY8shCsnQH9z620lpXdAxVZ3ykfY9a/YstlJUgnsaYmlrRm04KgDdJtViI0dyqYsIO54wtELxJaZDm/2PY/lzozyEZ5vCEHX/QeKA==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by PH8PR12MB7373.namprd12.prod.outlook.com (2603:10b6:510:217::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 16 Sep
 2025 12:21:42 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9115.018; Tue, 16 Sep 2025
 12:21:42 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: damon@lists.linux.dev,
	dri-devel@lists.freedesktop.org,
	Balbir Singh <balbirs@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Ralph Campbell <rcampbell@nvidia.com>,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: [v6 02/15] mm/huge_memory: add device-private THP support to PMD operations
Date: Tue, 16 Sep 2025 22:21:15 +1000
Message-ID: <20250916122128.2098535-3-balbirs@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250916122128.2098535-1-balbirs@nvidia.com>
References: <20250916122128.2098535-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0100.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::15) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|PH8PR12MB7373:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b2963ff-fba0-4826-df9a-08ddf51b9817
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|10070799003|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T1l5TThwZGptV05tYWUrU1dkRHRoQ0J0cUFlTUlZRS9TQmJmV29BeEdDbCtK?=
 =?utf-8?B?cllHeW1tbUZaRWsrL3RxK1NwSEpjK2NEb0pKdFpXTU1wbXQ4OVNWVkhQZWxm?=
 =?utf-8?B?TDd3N2JhNDNpZU9CanFZN0lsUmpSTXVHV1ovK1JhRlRuZlB4eDFiUnJrY3hI?=
 =?utf-8?B?dXZUSEdPcnIvTDVMT3pycDVYQTNsbERFWEs0N1JQVmVLajhZVWRoT3R1cWo4?=
 =?utf-8?B?SllSbnIvZlRkTlZLcXVrN2xYM1F5ODhrbUZKVGhwRlZFWWFmMTdQNVExYkFJ?=
 =?utf-8?B?RzB1M3NvaDlHZnFZUExISytNYzlidFMyZEpkbU1IRzhmeWlaWEFhTUFoVEJZ?=
 =?utf-8?B?bkRnc2s3Z1YzaGFiZzlMY1U5dVpWck91ZDMrd3AvVXo2b0ZIQWFSQ0pRemx5?=
 =?utf-8?B?d1ZuZTBWa3pBTDZPZko5M09zbllpOE4ySG9XcHhQYWQ2RFFwL1pwbjhIVUxQ?=
 =?utf-8?B?cGQ2Q3BNMW9aUHd6dmgwNmlSeS9XdlYxV3RaLzVkUG5LbDlqWXN0Ukk5OEc0?=
 =?utf-8?B?VE53Y2N3ZGVORjJKUktzVzluTGtHRDcvcWNocFRHaWcxNzFaZWozQlhuVER6?=
 =?utf-8?B?Nk4ycjVzaWI5bVlKZlo2bVlvUUV3cFloUmxjZHhmUkNKNzVtVG01ZlkrQWJX?=
 =?utf-8?B?dEJ1VHd1T1M4L3NOREV5d0JJSUo5ZEU4eHJDVkpIcWFXWXFlM0dYekI3SUdp?=
 =?utf-8?B?SWN3eWpaeEw0MFNYdGsvREZVMUYwU2pLZ1BuZFFxUUhNZ3IxcmFOcnc0V0F0?=
 =?utf-8?B?S0Z2YUFHOEdGTHU1MHJvOWd2ZFdPMXZyOWd4Z3dBL3VFZjJaVGk5SkZlL2Jt?=
 =?utf-8?B?NWgxVERvYWlBMUx6UERaWDNEQVViZk9WR25jU2FqdU0vdnFxNkJkRHNQZHFL?=
 =?utf-8?B?cXRXTldNN1lUMEZzQm5yMmFzenM2OHhieDlRazAyTXNrbHgzWEpocThrR201?=
 =?utf-8?B?REtxWHphU3F3eVB3RTBnNzZyMkRyMDQ2UFlQYzZVOE9Cc0gzOHJDVmlxd1NK?=
 =?utf-8?B?Sjl3SkYzU0JuK2E4ZlR0UmtTM2NTK3JEbEFQRXE1Q0VtYXJ5SEl6UlhzY0hu?=
 =?utf-8?B?dU5rUEV2ZUExU3FpLzlYYVNhT0p3ZWQ3TkdLR05veTh2WGRSSndUd1E0Skpp?=
 =?utf-8?B?cHVjYk93dVVCY1haMVdVSndMVTJlK0pvZXB4VjdtVDJnRGoxNEMrSE5QK0NL?=
 =?utf-8?B?S3g5dWlOaDQ0aGkzWXhwUEZVeVNlZ1JRUnB4emFCdURrVGNxLzNDbGpFQXpi?=
 =?utf-8?B?bDFqTW5GU0NJZFp2VHpoTmdrbjhIM1RZRlJnNkRRb1RzMC9jQ1pUVDdhTThB?=
 =?utf-8?B?cFpvUGpMWXZ5dUswRkR0WkdIUVR6MnRUYSswd3VRdWtuQzgyZ083WFp3VEty?=
 =?utf-8?B?ZDlaamFqUVdiK1dsYXF6WE1ubnpDQ1N4SUNIWFdwcnJaWUtKNFdMTThYeWFi?=
 =?utf-8?B?d1FHYjZScjZuOGk2T3VsSWplT1YvSG02NE4rdEJHQ3JPU3pIaXNaaVZGbHlp?=
 =?utf-8?B?cWFJQUxjMzJEdHdVZWdKTDZ5aUNvTGpYZEJPdVRyUnNndGhoaU5zSHlBS1lk?=
 =?utf-8?B?ZjdnM3U3OGh5R21HZmdlVVRRUmp6bUJFeW5wM21PbzgrRU9BeUdIUUJiQVhT?=
 =?utf-8?B?TlZQVFRoSmFKYWhWaVhVQjlaaGVmbXdxeTJTVXN3OEJuMGd4dWFOQUdjelJC?=
 =?utf-8?B?ZnBGWHJEWktVWTdVeE9nSkFhMjRsV2dhWDVHdXlZOGs0ajM1NWlyeTkvdGZW?=
 =?utf-8?B?SkhYcHhBWHhNSzk0dWlKWFcvWVBqZmFJMWRUbjZBbVFUbWlrdGRucmIvM0tk?=
 =?utf-8?B?aGtEaTVZK3RpYkFvQ3dwZU94c0I3b2hXN3pET2VSU3A1OEJTM0d3OHBhWURO?=
 =?utf-8?B?YXQzUndPd2VEYmNKdW5TaDN5bzRuSzZRT1JtZWFQSnZtZFA3WGpSZXhVYW5D?=
 =?utf-8?Q?mpMHwnrrXus=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(10070799003)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YkFtSUlDQVE2eE8zRzhUZFdBMUVJS1B3ZXdLdlZIeWg5VDAzUzRQcHMxTVpr?=
 =?utf-8?B?TWdBVjJ4ZVpRTGMwU2hZZG4rYjFTS1ZnY1JlWFd3c0dkeGxSSk5HTzRQSHRm?=
 =?utf-8?B?Y0lsRWNLcEtac3hjc09ONDlBbXlqamtMY3Y2WllINHNrekZ2dHdkYXBzaU9G?=
 =?utf-8?B?UDNZR3crajJ2bCtOSWRZR3g2djFlTDhwTHhSODkvS1haZ3VJMC9Ld1BXcmJL?=
 =?utf-8?B?WXdXY205bjZWdGs4aG5LRlg4V0xxOGRiQWdrcDRTZ2VxOWlBRHd3dGFDbGJm?=
 =?utf-8?B?VXQyNEUzZnJqUHdxWUVISXVUaXBiZkl2MmZiVWVlMUxSZHFwWVBNZEJ0bEtx?=
 =?utf-8?B?ZXh6cytNSk5oZnFEYTJuWjhxd2hjYjZITzg5WEZrZXQybkJNVWhnVGErZ1hB?=
 =?utf-8?B?TEJSZmtmZTRxMWJDMGdFV3l6VkhEMEhwZllOb1UxRXgraHBkSU1zcElkWGJC?=
 =?utf-8?B?KzNnSGhIcXF2TCtSTnQ5RGs5a0IvdWNHOEg1dXc5VFE5VlAwRlNESkFERjBp?=
 =?utf-8?B?WEVFRTR2dDM4V2s5disvcFBBOHNsVXFiZjFua0JlMDl1QkM5MGZNWFFpblRN?=
 =?utf-8?B?R0FiMzVKY09keGpwcEFGR2FEbkhlLzA5VkpQcHZyNXQrUnFQWnZmd1ZaK3ph?=
 =?utf-8?B?U0pqbDZETm1EWWxrUVd0T0VwWEtRYWRPYXNxbXMwZkh5MzgzL2oxYjFuem0x?=
 =?utf-8?B?MHlZakd0KzRHb3ZuVXVIZHVKK21BSlFlcGEvMGNRWEJ2VDA1QlM1Sk11clRa?=
 =?utf-8?B?bHp2Q1NKRkxReU8wNVJqQ1FMVHBJTyt4Zzc5NkxlM1dQQU9aR05PQVB4UkZh?=
 =?utf-8?B?MnBqeGRpZjF0UDFuczlGQXY4RjEwaXhMRTJKcm5zd2V3MTNmRU9xS2dtWUZJ?=
 =?utf-8?B?QzZYZm1EUDdnSUxJSDc5akw2SzVWcHg2dm5nTXp2ZDBqZVVSTWpCUFFScXJt?=
 =?utf-8?B?Uy92a3czZjZlbFFFOW1BWmxtUDZYWVdCZWJOdkZBeEhFUXovTlZXVS83d0Fh?=
 =?utf-8?B?ajVVRHBFT2cxdlNGVWR6TGpxMFhnbGQ4Q1dKUGtkYXd3Y0s5anZqdW9sblIz?=
 =?utf-8?B?M1hZQkVLTUR5SXFObUxWL2t4UytYdDYwR3lWYVVxMFdzV2h0M3FaeFJWNzZX?=
 =?utf-8?B?dmxudFYrcjBybnI4S2hNZTE4Y0MxL0ZvQjRCdTJFMkR6QVFrdHFTVWR0eUx6?=
 =?utf-8?B?Rm95ZGxpbnAvL2o2eWRmVmZJK3FEVXArZUdkek50cmwzQjIyT1RVeGQ0VWU3?=
 =?utf-8?B?K1B0VmdKQ2JNby9SUDVNeGwvaWN5ek13QVExQmY4bHZHbWthY3hlZ0RZdE03?=
 =?utf-8?B?UkppR1pIT3lraXNDNTB2N2pFUDB6Ny9COUJUYlAwZjdmQzJvKzBURnJ1R1lB?=
 =?utf-8?B?RkhiN2I5UDI0YUJpa1JaMXY2N3daTFgvWktrRHp1QlVuZUlZekNkVHd2R2VJ?=
 =?utf-8?B?UDdTUjdMc1cvMlpxYjNhTVNTc1FESzFPd283NjBWYkdweGdlQXUzbHMvc0Z1?=
 =?utf-8?B?ZjdVOFd5VUZBS3Rhc2VHcnZ5djRtMGh2VjhuOTVRNjhiY3ZFNUFwUXJYRHdN?=
 =?utf-8?B?Ym5sNVdxVWNwR2JyZ0JMVko5UkRpUmU0ams2RHllYU1waG5aQnA1NmRvMER5?=
 =?utf-8?B?cWVVUXBGSTFSbkovWXVlV1E2U1VtT0dubTlhN2xPdWtYQXRXU1lEVzIxZUtB?=
 =?utf-8?B?ZjcrNHZha3MxZVcvNnR2Sm5ublZXT0pTVjROaEpYOERyQWtHcC9CaEJ0WFdG?=
 =?utf-8?B?YU1OWGtoU0d5UGN0cmhHdUQ4WW1BUDFOMUc2dU1DOWliL0p2MjlHa2FBK1BF?=
 =?utf-8?B?S0xJT1FlU2luaFh6a2Z1bjRJbXdNSDBQT1FmSERlU3E2MUxmZkgwQlNsbUxT?=
 =?utf-8?B?Q2Q5V3AvWVZMc0hRYkUyTFhPN1grQWYybmdmaXFPSWFXb09TQytvZmlSRHg5?=
 =?utf-8?B?eHFLMkQyR3hiVmFnOTJ2MC9WZXRzTGllb0dySUk2RkFRTmQ3ekhHbklRZkVK?=
 =?utf-8?B?YjFaVnk0NllTd1ZxNkptTi9jQnpQY0NGM1ZiczAyMGNacEVmR05GdXRmcVhI?=
 =?utf-8?B?L1NsdmdxNWllK1AzUG91cytBOUczUWRmdTZQdUg0YUc0OXhpTWhnY2N2ZzFJ?=
 =?utf-8?B?M3BjVmRUbFJIS0VESHhUY2VBVjYvZVdGMXpZTWIwWGpBNC9OTG9vZ0xySWFi?=
 =?utf-8?B?RVE9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b2963ff-fba0-4826-df9a-08ddf51b9817
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 12:21:42.5827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fJSkG3QCsDIJC6hnZTlIEyDTICZEG0uSXvKErAWlSwiSB5uw1MKDCad6ma7+4TcJDw92hagplwTICwa1c+hZng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7373
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 805EBA000C
X-Stat-Signature: erg35q8kjknje9oy7cnq8jmcrunqxtkg
X-HE-Tag: 1758025314-543433
X-HE-Meta: U2FsdGVkX1/o7YEUHJFwchy0/GzJbFV0yw2tnQBE17rrQzmc26gCw00asIF5BwvhVaurNqCBtXCsvSDm9qnOCKV7tRTSqYTIw5HJb+HFkULbPBZMJR5ir5PeWn1XNeYH9qzEerTiW5hHJKqRwdHCSgyK/TZl0ybdXtc6Xm5KTsJGbSOIhcGn/6q8TjCXCF8dBN8TBlyquvNE4Spsg5wu8+pbtFzh6igbpdN0tRVBiwLoaf1L4C29AMUFpaiFIPEwD5Q41v0hYwcFkKV34oyXAD6dtqmFLH4yqxrD2gekVC8kfBgRkisvPbLH6ojzqKE6yDKxaWl0dZw8jin+U1fIT93SkDAHeqgUTMrERDobrkjaET/dSq6OYp7zDezJpsi6a+QjzGPM8VOOTMdZd/CaEVzRd5M05gO937ACDCZF37ZHvo18O/sXY9IJzaivqjIyekneNJYipKCWYpS5S3fha7aQwHQShNwNpOs60XdU6TX6TrD44oj4sHbLWv7e0o6twIT8SJEc8RfUgk7lK3auvksIh9t0i7gSVugCsl3U63j32PtM6hvy+XB0eTQt58Hi68dHyAkAaOgkCXvTOKODp7Ba9LMfWfWqyBh6YkkkgHTpMTw3P7q+nhJuCBEmsAJfSLWsUnsYhpFzeNurkzSccR14Ns3m2/UWkWTW8lKQN6PTJkuf5F8Bi1kV26hX4SCcbMuH76fHxSJ+5eT1b0UHT7K3McOq6FSjm2WFEJL2MIbO4WYW5cQFoBCpxTiERyTor6fVbb+sb1Ka5guLjuisBrY9A/FPRGA6vYW71Bhj9vE86Uczp8kjdekY576ZGLYVrAmvsbKYIl0ALEBFN8Nr8NxC79SkLVgO6Ly+pxUO5LMM2PvqyjRVCbAJ1wyrd6h2kWX5A70511y4F/hqzFdeD2lVBwrz0eW0sYJ35C1KaPx6a3VYcSh1PrSSr6re93Aa5DxjLlx+Ja2/I5g7vPq
 xlRtOord
 7VzZ1dMJl8gW9QbZZ2Jz4T7luI149xmMavC+uHN2wZ5R2Mu3myaIQiQ8WA40X61876Y4TnnYNHMTCs2Fn7uOL/1OfJxQA0qK70+frUFotl18Sn84kxGXRTseoBjRED8kWy1zSiV1HoIN4YG14tK5v/eo46BpZn2juthlei5XfjjpyJ3ZeYrW7iA1834IATCwX1qcgn/qfTgUQAz4j006C8TqEW1vQk25Cbpl+8UpnfC2MYSH1t1ne8Xo37eXDAHgD0oPjjlCCW7FmqCyq+kBZZW4wDHypPzahrHXQjlD+f1eExhwqDwDE4OQzTHS4ftFcQ+OYYJeeNZuNkaAsftTMwRF/tzOOQrWCke2gRZXbqazVgH85mlBWN6POuVVflJOoS1FsJUfkjXuEvRP7W/oD6ntnhBrWUT2X9sRJAoHxTfhgmYYmWRKYDXKbQWsy45Lno/ozr7pSFL75V94V8V6rzQ1Q314q7WAzOCapGRF0qnaHNMv2z+hTjiY5K6fjxnUUvsrdTvnTpj+hkL7Q9sWpBzLGw7p0uUJSkHpwtyXxoRtZSKeDaIvohY1OlqrN8owHZJxYS1lQ4HaFZNtwK49X7hnWQGP1MAUH2xY/CjHuoWtJT7XeJ3r/mWoFXBSV2Vjv6N+d7POTi6AzUHz0shMnJxI4mYLWXDa2sWa3lhjBX8DhhQJ2iY422d7ZjQj6XbqqzeBzUu00azdo4aF53+BuchSJt1cocjB/QVGIV7bMACma3PMLuO2bDZ4eZDeCYWf4klaQI+DysAShjnZdaKTL0oSYRSxi0kUmCLfgOknNTMS1/2os2IWMZQs2xbyXLntJrXdUrsuh39Hz5eWhsXkWW0ymOGPPXbtlz15EZ4KN06VgfxnqjRm+gGjqMNk7yGh58pAgbAbnSU3bZSETurxwh/bMSWsoNPDwx9D75p+e9tDKyB38ykqssZbdKPdavpRj/HH15abZURGRR8zjEFbDiU+AamxS
 MEhxHYvA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend core huge page management functions to handle device-private THP
entries.  This enables proper handling of large device-private folios in
fundamental MM operations.

The following functions have been updated:

- copy_huge_pmd(): Handle device-private entries during fork/clone
- zap_huge_pmd(): Properly free device-private THP during munmap
- change_huge_pmd(): Support protection changes on device-private THP
- __pte_offset_map(): Add device-private entry awareness

Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Balbir Singh <balbirs@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Francois Dugast <francois.dugast@intel.com>
---
 include/linux/swapops.h | 32 +++++++++++++++++++++++
 mm/huge_memory.c        | 56 ++++++++++++++++++++++++++++++++++-------
 mm/pgtable-generic.c    |  2 +-
 3 files changed, 80 insertions(+), 10 deletions(-)

diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index 64ea151a7ae3..2687928a8146 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -594,10 +594,42 @@ static inline int is_pmd_migration_entry(pmd_t pmd)
 }
 #endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
 
+#if defined(CONFIG_ZONE_DEVICE) && defined(CONFIG_ARCH_ENABLE_THP_MIGRATION)
+
+/**
+ * is_pmd_device_private_entry() - Check if PMD contains a device private swap entry
+ * @pmd: The PMD to check
+ *
+ * Returns true if the PMD contains a swap entry that represents a device private
+ * page mapping. This is used for zone device private pages that have been
+ * swapped out but still need special handling during various memory management
+ * operations.
+ *
+ * Return: 1 if PMD contains device private entry, 0 otherwise
+ */
+static inline int is_pmd_device_private_entry(pmd_t pmd)
+{
+	return is_swap_pmd(pmd) && is_device_private_entry(pmd_to_swp_entry(pmd));
+}
+
+#else /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_ENABLE_THP_MIGRATION */
+
+static inline int is_pmd_device_private_entry(pmd_t pmd)
+{
+	return 0;
+}
+
+#endif /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_ENABLE_THP_MIGRATION */
+
 static inline int non_swap_entry(swp_entry_t entry)
 {
 	return swp_type(entry) >= MAX_SWAPFILES;
 }
 
+static inline int is_pmd_non_present_folio_entry(pmd_t pmd)
+{
+	return is_pmd_migration_entry(pmd) || is_pmd_device_private_entry(pmd);
+}
+
 #endif /* CONFIG_MMU */
 #endif /* _LINUX_SWAPOPS_H */
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5acca24bbabb..a5e4c2aef191 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1703,17 +1703,45 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	if (unlikely(is_swap_pmd(pmd))) {
 		swp_entry_t entry = pmd_to_swp_entry(pmd);
 
-		VM_BUG_ON(!is_pmd_migration_entry(pmd));
-		if (!is_readable_migration_entry(entry)) {
-			entry = make_readable_migration_entry(
-							swp_offset(entry));
+		VM_WARN_ON(!is_pmd_non_present_folio_entry(pmd));
+
+		if (is_writable_migration_entry(entry) ||
+		    is_readable_exclusive_migration_entry(entry)) {
+			entry = make_readable_migration_entry(swp_offset(entry));
 			pmd = swp_entry_to_pmd(entry);
 			if (pmd_swp_soft_dirty(*src_pmd))
 				pmd = pmd_swp_mksoft_dirty(pmd);
 			if (pmd_swp_uffd_wp(*src_pmd))
 				pmd = pmd_swp_mkuffd_wp(pmd);
 			set_pmd_at(src_mm, addr, src_pmd, pmd);
+		} else if (is_device_private_entry(entry)) {
+			/*
+			 * For device private entries, since there are no
+			 * read exclusive entries, writable = !readable
+			 */
+			if (is_writable_device_private_entry(entry)) {
+				entry = make_readable_device_private_entry(swp_offset(entry));
+				pmd = swp_entry_to_pmd(entry);
+
+				if (pmd_swp_soft_dirty(*src_pmd))
+					pmd = pmd_swp_mksoft_dirty(pmd);
+				if (pmd_swp_uffd_wp(*src_pmd))
+					pmd = pmd_swp_mkuffd_wp(pmd);
+				set_pmd_at(src_mm, addr, src_pmd, pmd);
+			}
+
+			src_folio = pfn_swap_entry_folio(entry);
+			VM_WARN_ON(!folio_test_large(src_folio));
+
+			folio_get(src_folio);
+			/*
+			 * folio_try_dup_anon_rmap_pmd does not fail for
+			 * device private entries.
+			 */
+			folio_try_dup_anon_rmap_pmd(src_folio, &src_folio->page,
+							dst_vma, src_vma);
 		}
+
 		add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 		mm_inc_nr_ptes(dst_mm);
 		pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
@@ -2211,15 +2239,16 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			folio_remove_rmap_pmd(folio, page, vma);
 			WARN_ON_ONCE(folio_mapcount(folio) < 0);
 			VM_BUG_ON_PAGE(!PageHead(page), page);
-		} else if (thp_migration_supported()) {
+		} else if (is_pmd_non_present_folio_entry(orig_pmd)) {
 			swp_entry_t entry;
 
-			VM_BUG_ON(!is_pmd_migration_entry(orig_pmd));
 			entry = pmd_to_swp_entry(orig_pmd);
 			folio = pfn_swap_entry_folio(entry);
 			flush_needed = 0;
-		} else
-			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
+
+			if (!thp_migration_supported())
+				WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
+		}
 
 		if (folio_test_anon(folio)) {
 			zap_deposited_table(tlb->mm, pmd);
@@ -2239,6 +2268,12 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 				folio_mark_accessed(folio);
 		}
 
+		if (folio_is_device_private(folio)) {
+			folio_remove_rmap_pmd(folio, &folio->page, vma);
+			WARN_ON_ONCE(folio_mapcount(folio) < 0);
+			folio_put(folio);
+		}
+
 		spin_unlock(ptl);
 		if (flush_needed)
 			tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
@@ -2367,7 +2402,7 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		struct folio *folio = pfn_swap_entry_folio(entry);
 		pmd_t newpmd;
 
-		VM_BUG_ON(!is_pmd_migration_entry(*pmd));
+		VM_WARN_ON(!is_pmd_non_present_folio_entry(*pmd));
 		if (is_writable_migration_entry(entry)) {
 			/*
 			 * A protection check is difficult so
@@ -2380,6 +2415,9 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			newpmd = swp_entry_to_pmd(entry);
 			if (pmd_swp_soft_dirty(*pmd))
 				newpmd = pmd_swp_mksoft_dirty(newpmd);
+		} else if (is_writable_device_private_entry(entry)) {
+			entry = make_readable_device_private_entry(swp_offset(entry));
+			newpmd = swp_entry_to_pmd(entry);
 		} else {
 			newpmd = *pmd;
 		}
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index 567e2d084071..0c847cdf4fd3 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -290,7 +290,7 @@ pte_t *___pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
 
 	if (pmdvalp)
 		*pmdvalp = pmdval;
-	if (unlikely(pmd_none(pmdval) || is_pmd_migration_entry(pmdval)))
+	if (unlikely(pmd_none(pmdval) || !pmd_present(pmdval)))
 		goto nomap;
 	if (unlikely(pmd_trans_huge(pmdval)))
 		goto nomap;
-- 
2.50.1


