Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E24EC83F1A
	for <linux-mm@archiver.kernel.org>; Mon, 21 Jul 2025 23:34:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 652368E0002; Mon, 21 Jul 2025 19:34:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 602918E0001; Mon, 21 Jul 2025 19:34:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CA528E0002; Mon, 21 Jul 2025 19:34:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 36BA28E0001
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 19:34:27 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DA78812EB83
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 23:34:26 +0000 (UTC)
X-FDA: 83689878132.19.78B301F
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2049.outbound.protection.outlook.com [40.107.220.49])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0AD29100007
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 23:34:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=odPAQllk;
	spf=pass (imf05.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.220.49 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753140864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GuaZJz0DmpswwJe8ZsUzr+HUOIdIqypVE+67RMHhgOg=;
	b=oSM5szJz1mtGH715PXVMhKAV3xcNlQCN1okvQwkkpmovNBx3YTdkvCscSVciVQ/iTAJn4w
	gd2DhRZsmKsplafSQrj9taLxBtigE8mECaHqJ0CCRNrZRzyuzSiCZIWYOSYQ4VQa0nsZff
	khbqi0zKIjH7X17YDgTHz2nL39alTrQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753140864; a=rsa-sha256;
	cv=pass;
	b=tuPrhOqHph1A/r49/+whkaYkAphgJaprIj5oKabtWtHaKbspYswYDXEhpWx9S2YXF8LxNC
	BsSDaew1j0jkZLQ34XC3d94I7ujuhzPq88QVTxegfBdQopD/XVHlyi/sjE+9g+U2VxQ532
	v9KVpQHfLAJaMeMVWO1TZCdUk743LZU=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=odPAQllk;
	spf=pass (imf05.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.220.49 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qmPZqz81/SbS9fx83ONFi3R+av9bRGSdo3B0QdMHsuZKinRx8gjU2h1zxfMQLlrMOWBsr8OwQS6CzXnrBA0tdmfUc7Iwp9eEvUNuBbOIlLHyKM96UXDcX/hBvtbmfSw3crrP/DTba7lFBaiO4O5oXmjbTqTZEYVrz0yqRxYSznD45D2tqVy/nvZEqujMqg7FHBem9rz61klEu87smSWLLiO0OUZZnQOAZx2PSLFoi/PHlLMKI+eL6kfZj4OH0/JBXqTlZBFmk5yQ8fOKn5s0f8h1lTHB7zEN53MKAOnQN/OImJkRtu8dzjoji4biCVuRybx9x6gLvXaPQwvgOl2INw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GuaZJz0DmpswwJe8ZsUzr+HUOIdIqypVE+67RMHhgOg=;
 b=jeFsn7R473lApd6v0BkWRvZuQfakgIRbs7vR7YP5B75ew+8Ava37ILS1LMzSqlv1iaXMWJLPgc/o3mNeQogw8giojnQtQYyZhxBg8NstIGZwMeXROd1r1Pl3XKCvkT73nC67GCmUOcdlh1Hk+7+77fnqJlYZUUdUWfQrBDKiU3GSSjcN5DoRLaEMyVKDKSqufH9QGLbHcawE5F6SlSq2XdDbkggAPmGZ5AAqm7FvykOeEeJqT69Hee3OPx+qk5r2JnACBZpalCf8E1MazZ0aLQAGVX3dJa6bkpB0vs/EKWFArQHXhtvCWB7ZogtBMNA9Dqem34vGVUYsxgnPqt2dYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GuaZJz0DmpswwJe8ZsUzr+HUOIdIqypVE+67RMHhgOg=;
 b=odPAQllkqlCcBQ6TrKQjxmQsm3bJpdMvTCi0oakULN4LNU3vXFAp0cOViF/qnEer9NlDULr/0+cytHF0Am5amLTrqgYPwEzWF1em5hHC+b010R0UREjMWDIpA7uSbGmwq4qSoIGTd1w+B3JLM54QzzUJ7ez4mh4JHbQ5lGG76rxJ7M1VGAoOPtmrpgkL99NReKcudhRjGbnkQJVhXd6sLyWdbW0v++RL0jwrPDvqWCAHNG6AYltQIKNJYwi7uA0li5yvi+1E2RjKoVbYEPs1yG7HlmIpvl9OLDGy6L4Npzz+Zg3Uxi3lVMnf3pc87Z02gC/tH45rSW3z6nHnkpy6SA==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by CY8PR12MB7436.namprd12.prod.outlook.com (2603:10b6:930:50::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Mon, 21 Jul
 2025 23:34:20 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%5]) with mapi id 15.20.8943.029; Mon, 21 Jul 2025
 23:34:20 +0000
Message-ID: <9ae3e014-c7d0-4d58-af0e-925bcd9e4cfd@nvidia.com>
Date: Tue, 22 Jul 2025 09:34:13 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [v1 resend 00/12] THP support for zone device page migration
To: Francois Dugast <francois.dugast@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
 Karol Herbst <kherbst@redhat.com>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?=
 <jglisse@redhat.com>, Shuah Khan <shuah@kernel.org>,
 David Hildenbrand <david@redhat.com>, Barry Song <baohua@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Matthew Wilcox <willy@infradead.org>,
 Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>, Jane Chu <jane.chu@oracle.com>,
 Alistair Popple <apopple@nvidia.com>, Donet Tom <donettom@linux.ibm.com>
References: <20250703233511.2028395-1-balbirs@nvidia.com>
 <aHmJ+L3fCc0tju7A@lstrano-desk.jf.intel.com>
 <09c5ce76-f7c1-41c7-97e1-74448e6143f7@nvidia.com>
 <aH4nibzGVLiPE5-4@fdugast-desk>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <aH4nibzGVLiPE5-4@fdugast-desk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0177.namprd05.prod.outlook.com
 (2603:10b6:a03:339::32) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|CY8PR12MB7436:EE_
X-MS-Office365-Filtering-Correlation-Id: 187e930a-5663-48a2-9598-08ddc8af1da6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WTYxWDFmY1NQakdSQjRmYjdJRzFoVFFId0RFdXdiZmhtL0NOZ2g1L1JBUE9q?=
 =?utf-8?B?Mi94S3dTaERsZTk1OERiZEpIYU8xalJXVXhPZW81OWZPNXYyQk9welJFZ01K?=
 =?utf-8?B?aVdOYVdwUENHMitOUVZSYUo4ZDlNTmg0K2x1MzM1YXR0UzlwZlIvV1NjM2NM?=
 =?utf-8?B?cVcwMjl5VXpjY2hWWVpwK1cwNTNSVndIVzVSMWFFaGw2KzFtcnRpTXBrUnJJ?=
 =?utf-8?B?ZW9Fdk1Kak94U2ZVYldFMGVIWWFPZStIOCt6UHpBcFpIY3B2UksxTVFMWGJS?=
 =?utf-8?B?R204MDBIaTFma1l4L1hjaEdrbEh1cHlWeGFPalBYaEhweks2NG9VVlpxd0xv?=
 =?utf-8?B?WUZWcHBTZ1JoQlhnT3FHMVVMUTBpdmtEajdiaGpQOVlrQXM2M0N2bUVQQVY4?=
 =?utf-8?B?VnptaHEwL3FkNjRYREVmQXkrSEJhS3kwL2xhUW1JUWdJb0lBaWF3RnlBcEd3?=
 =?utf-8?B?MG13RUNwVjJ0b1A3SUZOb1dhR2g1dzhZTXFQR0w5S0g4QjJOV2pTaTBGQS95?=
 =?utf-8?B?YUgwQXpLNUNZZGxsWVJxTEVubmowZGRVUWdKQzRubDhzc3lxelFrMzV6REdU?=
 =?utf-8?B?K0Nqd2tQaURsN2d4cmNaUmFXaDU0cEM2OEg1VDlReU5YcHg1cWc2RlZRVFpy?=
 =?utf-8?B?cjZOOG5pVXhFR2s5QzhrOEg0V2pnSHZzTmtDQ1pQYlVGbzNrakJyVXhuNnk4?=
 =?utf-8?B?cUZ4bVdjS3RvWUpxYXpIK2hkZEtEYmpKeitPR3d1cEs3cHpDVmljd1lQc3BF?=
 =?utf-8?B?RGNva2xGZEVxTFZuMmJ1RkMrY2VMVUNVdkhVbC95TkFGdzZienBORlBaQlV1?=
 =?utf-8?B?QTlycjhzN2Q5OENmVGx0STdNNVVyMUlKMjAxU0ZUUngwVmRpdVg4b0NWUFQ2?=
 =?utf-8?B?VWJDeXlldE1ibHVIRmFBQWRHQkhMN2s3U2ZrUXlqWFFZT2RqOU80QVBTQ3Ex?=
 =?utf-8?B?dU1UejdHbDdzK0NjV3E1aUo1UXVtaGNDOTIrRlBmeDUvUEUyZjg4cUt3cXpB?=
 =?utf-8?B?ajJzTHovNzlkSjRMcnNxczVjYTJBWWJRNm8wdmlhanN3QUNRUUtUb0xoczBo?=
 =?utf-8?B?TU91bWpudkF1WkJDeDFERGw4TFp6ajZsbEUyOUFqaEV0anFmYTFyQjJWTlpP?=
 =?utf-8?B?aGRtcEtIRkVUSmR0Wi9TNEMrQTU4eGwvbC8wcFVaQ2tka2dZRTdTc2dkbSt2?=
 =?utf-8?B?NFhHUzdlTHVaQlFFTE5FTkx1dVhkbmIvdTZJMVMzTXMrNnZxcmUvSmJoN25Y?=
 =?utf-8?B?dmN2ZEdrOWR3Mi9qSGpPQ1NxeFdTY3k1ZDFTNVZGRG1VUWpCTFUvWTVXODhs?=
 =?utf-8?B?U0UyTEdZOVY3b2JoMTczbDBTTHZscmthNzdoc0FwRjNVUy9pKzZJay80NzVR?=
 =?utf-8?B?ZEg0K2MvNjIyMUgxOE1NeXIxV3BKN0xQLzhXQXFqTGJWZVdRd3V3amxaT3Ir?=
 =?utf-8?B?eDJoWmJmMy9vMGFMN2FvWWlFY0V6RkhORGxndkJYZ0JjbFo1L2lVbGhsSloy?=
 =?utf-8?B?Rmk3VStEaDJ3VW5LaVRUb2MyWXJ6YVZNcncxT0Z5YTFOUXJ4U0hGV0lXUUFV?=
 =?utf-8?B?SkhwMEZrNVdRTVJkVmlmTFBObGZ4ZlhvaG45TGV6QXlVZG9hNWNEdy9lc0t2?=
 =?utf-8?B?aERZNTNhTFJGTXVIR0k1YVNJZTMrVHQyYnJUdDFsUmV1b0V0YXBFbUpUenE2?=
 =?utf-8?B?bmd2UWZGOUU5c0VNSU5QVXh6ZlJwL3B5QnV6dEdmVCs3eDJWUldidit2MVhy?=
 =?utf-8?B?WWx1R2pEOXE2cmIvMFZmbzJrQWJzTDNZc3YxZnBzMG9yKzZHemlDUml5MWoy?=
 =?utf-8?B?VE5POVpSblQvWkFOSEY1Wk5iL2UrQzNkQi9yR0RwbzZMUU5jV3RWQXpzNFE4?=
 =?utf-8?B?L0JZN1ZrZ1ZBaVhvOHFQdlVDT2FHY1B5QjZOVzFTaXgrcVE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(10070799003)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?LzhPTzh0SUdRUUlMMVNkY3VNcExxbzNJNUxwRW0zQ3JYOThxVzNxd1JZeE9k?=
 =?utf-8?B?QmlFWjB0Q2h3b0tyQU9xbUptVklqdHJRZTNob212aytLUGUzVlBBVXI5aE9Q?=
 =?utf-8?B?Z1pncjVtSSt4anUybmswMUpKeDB1N3VCVjB1NERkQ2c2anp1dUtINXFVVHFn?=
 =?utf-8?B?bW5VcXhqeVl0cGNyYUFtMFFEeWJha1BxYW5WV21MV1VTaC9lblcrUlRDNlkr?=
 =?utf-8?B?eUlMUW5Pa0JNSkpMUE5hT3RjK3I0V24yL0hJWkVlNE1KMVZDMVlTRjdRVXVE?=
 =?utf-8?B?bVpkZnZPdlArcTZhY3RYUzIydUtwS3grcGNQVUVyRFVWcEM3WjMvemdtSFIx?=
 =?utf-8?B?ekN6NW9SaGlIWGtLMzdXb1ZsRWZRcTY2eVlIQnhwRDg3MlFJbUhSdytVK0c4?=
 =?utf-8?B?VGdFSEo1Qis2MWhteENYNTlUMHdsc0hoWkFYYzQ0WEtvdnpFMWdJVFZJUVBr?=
 =?utf-8?B?d0kzdnd2WFNORDJhK09UTXJjcDMva3Rzc3lTSHRpekFYQy9JbWFCNkgra2pv?=
 =?utf-8?B?OFJRWTlLN1lZelB2dC9MQTczOG56c3VhSFdsZ01PTWs0VktucStpQVNXUWli?=
 =?utf-8?B?U0diSkxjdVh2YXQ5M1d1MVBRWm9uTG8yTXVkVjExSVpwOXR6RlJuZW5ZRThU?=
 =?utf-8?B?eGtTQWw5VkRtc1p2anJzZTUvSThld29WQUpqRmpNNDJDaFUwVEQ1NitXWVJD?=
 =?utf-8?B?RDIybEMyMW94WGZlZFJoSGx5dlNBRUhTWmc4Z2dkNmRzVXl4ZEt2TjBnQWFX?=
 =?utf-8?B?Qy9UQUMxT0U3ZUo1TEt6UFNFZ1YxbjFSZlRPcUY1WGZMcWQ1ZUFiMVhJNEhF?=
 =?utf-8?B?KzlYV0Nad1Zob2NveUptYXRXWHozK0FBQmxIUmp4TjhCaVRKR3hVZjJWZ3hN?=
 =?utf-8?B?dGE1N2xFejRpUDhsTHpVOW5iOS9YRTdFY3hxbU1LM1RUdVliUHAwclRnRjR6?=
 =?utf-8?B?Y1ZkNWdZWDVBT2tpTElHOE5EK2M4VzRTbGM4a2E3dEhYa3JWSTkyQzdnQWFX?=
 =?utf-8?B?TTliR1lhbmNCMStBam9kNXFOaEZsUmNNL3REbEFHVkZkZ2I2QTUwSldlaUNI?=
 =?utf-8?B?N0piUGZpaG90SUNWakdXL1B6VnFEM1pZekpDVzh5SlVLYUNneXhkNSsvT2lY?=
 =?utf-8?B?VlNHYytvUG9uNWJMMmdLdkIvYktnK1F1S2hLbG4rcEhGbWZTeUNmQWc3cmVO?=
 =?utf-8?B?di9Vb2hiM0R5dEZ2UnpsUk5NL1lnM2ZlQXpwYzRRbzJDd3JSalJyVW4yL1FT?=
 =?utf-8?B?WWs2ek9nR3EwYlRhUjBSRDRxTE5zQzN3cWUvTWJIVEkrWjVvL0hrbG83SHho?=
 =?utf-8?B?aERIR0dFdTN3dDIwYUYrL0pWLzV2NVQ0SDVFR0l1YXBZQUNkS2FoVTB5amFu?=
 =?utf-8?B?SmRHaVNLa3JuSFZ3QWs1aDJudDQ1MWNZV1pLb25XdGVUN2dBVExSTkNsVitZ?=
 =?utf-8?B?SFQ0VGdZYVV6S3N4aVdxMGVobC96WUNFcHA4T3VDdWQwNS9ucXpqTktwNXVx?=
 =?utf-8?B?YmN0Yy9MM3Y1TWlhenFSQUQ4UG5Fa3FwMWxmc2ZnL2VNaFpPS3VOL3gwNE1m?=
 =?utf-8?B?Y2hoWFE1eXY0MlVXUmJOb1QxdmVHYUNIc3FSQncwSHFIMHIyTUc0VFY2ajU0?=
 =?utf-8?B?Rnh2elRIdUROc0dJZGRtZXRZckNFV1M0REJCWDE0UWRMcldDbzVSUXhKbFcx?=
 =?utf-8?B?U1pHb3hqYmE0bmtEbFFISWRMRFlZQVFBMnBGMzhvRjg3TGI3enVqN2NmNm81?=
 =?utf-8?B?WjBkSGx2c3YyZ0ovV0c2Z0syWk1oaWl0VVYvWUhwVGNWRVdBWWFhMnRwdzRT?=
 =?utf-8?B?TjN2Y3FTTW84T1UwUDdHc2h2NDQ5WURKMk14Y2ZJSjJMQnNkOHk5NHJrdU9l?=
 =?utf-8?B?ejBhYWNNL2ExM1Y0T3NvZE9FUGxGaXNHR2o2b0VMZGlSREZPOGRObUJoNm9y?=
 =?utf-8?B?eUJ1dFNaWDdrdzNRM2N3NHE5WHZISzk1cXZ4MFVjbkV5UFpGVnJxd2dtMXB5?=
 =?utf-8?B?UXpEN3U1MWUxTVZyckRsK0hPZmtOWlVCREM5cnFPTkhnUkFiYWZ4YVZwNkx0?=
 =?utf-8?B?bGEvS3d2TjdhV1Q1MzB3SU9QVGdiN3FsaEQwSVVvZ1RINWZHWGhTd3JnNjZR?=
 =?utf-8?B?cE9BcEpaZkxlUDROb2hCRTYyVXpnMVpXcXJIM3ZOVUlpbHNibXdSNUhSTGVq?=
 =?utf-8?Q?3d1inEE3Ikvuifdww/LBVPjZMQ4u1AMLo1ZmjW1FX9RI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 187e930a-5663-48a2-9598-08ddc8af1da6
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2025 23:34:20.1402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y/AXMwN8i4IjYc4XdBFiZkOERaehNeiKEYZOxbWzHkL7/v+RDYGM7t/7Jcf5X5Utw7ENj4moxNOajRr3qBmdfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7436
X-Rspamd-Queue-Id: 0AD29100007
X-Stat-Signature: yfpgxpbjt9bjfknrzrmp3f13q3tbi5jd
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753140863-805460
X-HE-Meta: U2FsdGVkX19boVP7eJh4AuUocG2ksPBbtR1DQaoJIfw/OiA+I+lk2Ycg4PxaagXZNHYp5fUwaj+gT+bMobC+WabH7iavSNBlY2hhMVzwks/ImCa1uKpjMG7R7geM2lL2U4GS4LD7/7G48JPmEqwpUNNmPbG/zNBoKhZD59s0YfHAs16DGPwrfXIyfbLjprav9RSwE2CsGL6IEaJGCfVBEGhFB4XqSZBjZ/dzHBwWUGIdhm96XwIfEJRRLLIPv4Zeu9tOTymmG7Jxf+Q4GLwrrDKz15Mehwy6Qzpta9cchZj3tA0YEd5wtV0tvbQDNko96LvDyDT4ojMTshCBcGIzeKdotB7j2YyquGfe8HqEzSz1Kkd6y4huMaR7oFTRVLb+qPczeSIqw2PcLpv5TFiTuaom8O1W3DTny26BVQDWCQ3Jby8I7em+bqlvyG0M1MF3cNgSELGJnwScflTuJMUOGrmIbTjjLkh0iEdfwGtCqmQOj0ZaAszD9jkEEkNriwnCvU5tGOJ6HmEjFxHOm1y0sDRgxDF7+z9Gpi/ZJ14ad1/RsKEg/zf34h6N4Ca5JtBYU+Frllrxd3OTUFLlXdkZN8meUU/4rNfhGb8coaryUBjBf8sGiFKw4qCF43+fXdqXwVgMArnZuBtWoAq50hmXnx5QDq3xONK6XjrQhsR0ySx49XgeRpnghABepwWghvpuGQwo26RTxXV+T+c2a733AiVqRSjviTRCYBGRZkOQFMQ2S0MMQ0xTKCx3XmHisnQ/6B16jIIYjCBSz1f4PdlZgIDLTWOwL6ofI/LaPQp+ci5uRh0dYx223vOg00Iia98CHc/n7tSrNaO9AUxuKaEG2LhqXmuHguFwP8HFefBXf0YKI6/vTaYBlLHq94irhgMqcxqehrlPhUGiktIKr4tFiPpG6qCpHUJ7Co7LNYrmpFmN8uzB2IpYoRIEClg6hQRmg2R08TGjO6sOOKmmzLN
 6l07mwVR
 U/52z4STdvlwHWcrLns2fFKorIn0DVAEm9/Xj860HE+NM/aG6dSNPEM3QcjSzSz5Kv9A0jjHUi9w55jJ6z1pkdbgCvGofqHOZDot2XXop7tTV31vCCc2H2+K5DP3+cyb9YDuVEQ5zXFa1T/wfFed650+sHDpFhP0hWvLTgUix5jdY1tJ7GWlkzs4NITNWFe3lF9E2UD+WeeSePG23fFf8/kH4h2UoLpvOfLgGt5ASWytWenYGNqSEKYVIU50j8EGED3IjDjmgBhrBvSCJTqvpFMtkl4ksIdZhrp2fd/yogml54l3YWrFkVD3O7OBTJ+6myATT0t7QhwBUfCy1dGmsNhPvdOzqkL19s4suP9HqGWMECRXJOAp/vUrxtAw815dJjs9OnZyCpY8tu+o1UgkatGTu5a/QkZRstUji+gCbni/yS5Lv+DSsqFG7V9XQ/VKD4fSf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/21/25 21:42, Francois Dugast wrote:
> On Fri, Jul 18, 2025 at 01:57:13PM +1000, Balbir Singh wrote:
>> On 7/18/25 09:40, Matthew Brost wrote:
>>> On Fri, Jul 04, 2025 at 09:34:59AM +1000, Balbir Singh wrote:
>> ...
>>>>
>>>> The nouveau dmem code has been enhanced to use the new THP migration
>>>> capability.
>>>>
>>>> Feedback from the RFC [2]:
>>>>
>>>
>>> Thanks for the patches, results look very promising. I wanted to give
>>> some quick feedback:
>>>
>>
>> Are you seeing improvements with the patchset?
>>
>>> - You appear to have missed updating hmm_range_fault, specifically
>>> hmm_vma_handle_pmd, to check for device-private entries and populate the
>>> HMM PFNs accordingly. My colleague François has a fix for this if you're
>>> interested.
>>>
>>
>> Sure, please feel free to post them. 
> 
> Hi Balbir,
> 
> It seems we are missing this special handling in in hmm_vma_walk_pmd():
> 
> diff --git a/mm/hmm.c b/mm/hmm.c
> index f2415b4b2cdd..449025f72b2f 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -355,6 +355,27 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
>         }
>  
>         if (!pmd_present(pmd)) {
> +               swp_entry_t entry = pmd_to_swp_entry(pmd);
> +
> +               /*
> +                * Don't fault in device private pages owned by the caller,
> +                * just report the PFNs.
> +                */
> +               if (is_device_private_entry(entry) &&
> +                   pfn_swap_entry_folio(entry)->pgmap->owner ==
> +                   range->dev_private_owner) {
> +                       unsigned long cpu_flags = pmd_to_hmm_pfn_flags(range, pmd);
> +                       unsigned long pfn = swp_offset_pfn(entry);
> +                       unsigned long i;
> +
> +                       for (i = 0; addr < end; addr += PAGE_SIZE, i++, pfn++) {
> +                               hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
> +                               hmm_pfns[i] |= pfn | cpu_flags;

Won't we use hmm_pfn_to_map_order(), do we still need to populate each entry in the hmm_pfns[i]?

> +                       }
> +
> +                       return 0;
> +               }
> +

Thanks for the patch! If you could send it with a full sign-off, I can add it to my series while
posting

Balbir Singh



