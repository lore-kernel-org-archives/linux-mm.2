Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 533A6CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 02:42:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4DB78E00B4; Mon, 11 Aug 2025 22:42:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFDFC8E0045; Mon, 11 Aug 2025 22:42:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9F0E8E00B4; Mon, 11 Aug 2025 22:42:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B25AE8E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 22:42:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3BE8A1A0189
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 02:42:29 +0000 (UTC)
X-FDA: 83766556818.12.CA13968
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2075.outbound.protection.outlook.com [40.107.236.75])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6E942180006
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 02:42:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VG3cboYs;
	spf=pass (imf24.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.236.75 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754966546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FLRnZ3g14MH+A0H5eZGV2PREorZoUiRXRp7IIDGKm18=;
	b=kgC9qnQGKVkNazu8afMNnCHih9y0lyw+zLmt8JyPn1Y+MaMoA3H91ASTqBg+B0b/cmXDsC
	1AiEGczPOk5vGsg+F+TUyzDGmSaQo2u/P+e3n4g2xfmbT4Oup4mgpWCH1rEGUbSDpeVD1O
	91qAO3Ld+Ukx6jTUi4bn2P5xBZ91+pA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754966546; a=rsa-sha256;
	cv=pass;
	b=ZJFOjEVGGtRaJrnSJgV8yByHfvD2lPM1LdBrVCSuJ6zDhXf2x28KR+dTAeipxbk1lIzS7m
	Zcm+rMP4zrmQBxIp9tAu/OnIVjFc+MjSdCTJrBh/yY30y1s0xfCf80efvdzwuwysMFl7Kl
	aBLjrPXhPG5xryGwQwk1wz5BPuuUNJY=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VG3cboYs;
	spf=pass (imf24.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.236.75 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qr+Rr8mPYW1KDgN9bznF99ET5kvzhBnd3rEDXC6HI/oN7hougXKyHfSn5SnDSAmj1XkUrTWE/yXV4lUp0jE+uvCA0F2/4x4eFFUjbhtImVaiKsDQbt3HOlrtYniwec560KPfLpNOIn7n3T48EEfzTG8aDrqjx4sk3XQ0STY7g9sdt9UhWcwv7y0xta7AwsFA7TrDOp1jBLsEUvTq7S1+7uzrGBZ+c1lqd1O/vD5htDw/N4JdzWVdReae1uagaIuaqO16LxwzkUxrZoH8quYkRhjsPVzbOpctLxQUlgPFL/NsVTbFX+sPltTzTkffdCild8drZlgW32EMBgcK1NuJ4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FLRnZ3g14MH+A0H5eZGV2PREorZoUiRXRp7IIDGKm18=;
 b=cD1qdbFfLCL7jSJh5jDO5BM65+dr7Af5hn99aAlO8S6XkJosewy96AC2gAxuM+uU9nrBgQDfb65WzUMwm8ZDVgg2vr1KQp6Rlq7/WbTS6NX4fPUXDZeQJlKrYiHiacCs7Up4NlnhakdGytzEUDo+z03HmK1HZs/Q2O33u+nQ2gsDtpuQfpjUg9x9bKYWX2+mqTHs08opbiyAwbMgoKBw7di8eVu1ztuNy3qKgZXeIx0JhZ3pAAVWGqS7VzUhgT4sPTXF/h5cmf3BFgqCV01N0OC3jta3nYeeXa3sgolJyJ+BwFYA1kbfhKKdKjMq3tHqrd7WZbd1hbaE63SCQyHyfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FLRnZ3g14MH+A0H5eZGV2PREorZoUiRXRp7IIDGKm18=;
 b=VG3cboYse2B0+8O2WYzp6eqBGIg6zr8orY6qAFzEC1nKYs0r/31iOYUX9/o8vXHQo/lQwbbKPw5yv2yugizaeWQRcq/urnusmN4QZF/yeW7Yei22d8jg1PN17JwEucljSG0eW4MhRWdhJ554myr+1cY2SU9wowvOdiry9zV0nRi7xIFczs4EV9+YfOrhpWcl2zYT2wZVfwgQoDjJ9xoomQsOcwEXgDckT/TnLtrskmDh79DsV2r/9nyjzCYE4G7cCMgho37V11IHbLoG6d45BW/NU0PTORXlfyxdk0YomU+K32QtEH6ysE/FkFVht1SImDindNFH37Nt4xy2NugMRA==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by CY8PR12MB7172.namprd12.prod.outlook.com (2603:10b6:930:5b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Tue, 12 Aug
 2025 02:40:45 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%5]) with mapi id 15.20.9009.018; Tue, 12 Aug 2025
 02:40:45 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Balbir Singh <balbirs@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: [v3 01/11] mm/zone_device: support large zone device private folios
Date: Tue, 12 Aug 2025 12:40:26 +1000
Message-ID: <20250812024036.690064-2-balbirs@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812024036.690064-1-balbirs@nvidia.com>
References: <20250812024036.690064-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SY5P300CA0106.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:248::7) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|CY8PR12MB7172:EE_
X-MS-Office365-Filtering-Correlation-Id: f015bfdf-0277-46c5-8ef0-08ddd949a304
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YUNDQWVQVFhQMzhwZDlVS2x6MkY4OTh5OU5ja043V01hcVpCenVuZG44TE4v?=
 =?utf-8?B?ZkkxSkd4bmJENDFEY0hOVWROWnl3TEYrZUNqWmpKaEtkc1ZzZFN5Zjl0cUVj?=
 =?utf-8?B?YTNOQTNCa2ZOVC95WWN1NzdPa1dtOHB1MDRSNnN6ZkJmdmJiMTBSSmhMU25o?=
 =?utf-8?B?Wm5XQm5waWFzcHJ0eWJPaTVadms0RHI4SGZlTU5tVVlUeW1ZNmxubnhNUWsy?=
 =?utf-8?B?U0JhR1hKdFlEYlF3NDFiVE1NVmV5TUVYdTFGamFKSmVTSWIrK0gvUlBuU1Y4?=
 =?utf-8?B?bGtuTkRyZDhHekRYOXlKVHR1TFFPZUlJQ21OcVNLNU10cUQrUDJwalZmYzFD?=
 =?utf-8?B?eklWcDZMRndieWpIc2svUXJHaVdTZjZISmlyQXdwZUN4UnhsNHpQQ3Jqa2Fm?=
 =?utf-8?B?RlFYNmcvbC9VT1R6azZwNlQrVkE0b3NCN1J3QkVNSkt6TUoxeTZrais3YkVY?=
 =?utf-8?B?V3I1WStoZDl0ZHBiekZWOXM4U0lMamZXdDJZZkhDLzNuSTlFaVJPK1p0UmZ0?=
 =?utf-8?B?VXNUcEVhSjZkU1Yvc3Z1MjV2TEcvL0xXVGdyRmVvNlJKQUsrK2ZuTGVWNGl0?=
 =?utf-8?B?VC9uTnhIL1dIMSsyQ2RtRmYzS1N1eVJRRGNjZm5KYWZ6b21YSUxEcVRwRTF0?=
 =?utf-8?B?QmxQTHJsbUFYdFFTRm5Zd0E4WkpvUDBrS1VtMTB4dUMwVkRJcUhOcjVqWmNN?=
 =?utf-8?B?UndLMXNvelRtaUxDK1FkV0d5SkVTakxNTE5wVVk4elFBODdpcjBJaGFOOFFa?=
 =?utf-8?B?NENQQVdPb2xUWVFTTmgyNkordGJYOEtVeStHazl1WDJNZ0ZlMEhydHlEMlVD?=
 =?utf-8?B?R3FMdmdjMDBuYjJaQVJTL1labFJRRmhGR1E1R2lJNHc0QlpqYm9DbW16aWk5?=
 =?utf-8?B?ekZqZGxGOGIxOEtwbkhBS2RrcVpZQmQ1bHkzZHp0SmlvYzdoU2x2M29QeER4?=
 =?utf-8?B?ZGpOdGcvU3owclp4MXpRVG40SXhOWTJrWVNhb0dxSFFySjh2dEtNR21Hbmpy?=
 =?utf-8?B?RGc0QU8rc1ZkbllBdnE1M2JuOXZGcUIraHloWW9tS2dxR2JNRGFWRXFSL0tM?=
 =?utf-8?B?MkFkZnhGbkw2aFk5SjdVa2krVzlYcGNNSUtWQ3BGbDNFREVRQ0J6cTByTFZu?=
 =?utf-8?B?UlMzd0NFZlVqU1JqajNGQWJjR0NwaE0rWWxVL2NiYmY1QTZKdHZSVThyOWxK?=
 =?utf-8?B?b1NLSC9hUmFINlF0ZE5vQ21rb2M4V2tZQkUwQ3lrQUtzdDNDcCtuK05oL3E1?=
 =?utf-8?B?MndDS3RTOTduK2RVVDBqUHNiYWlWVWg0MmgwMHkydnZpRnpuN044cVR0am40?=
 =?utf-8?B?VXdiaUJRdGFjQThWamVZZG5zR0sxcXFTRlRGK1A2ajdycjdoOGJJc0NIeWhL?=
 =?utf-8?B?VFRza1lCbkg2UnhKUWROMXo2d09LNEtFSDJhaVFucHBPdVFzMTJhMDEwVm52?=
 =?utf-8?B?WVVzbk1CRFIweFBhNnhoQVY5bDJGTnp6SDk2WUtObFNpUnNZdW9hNG9ibkV3?=
 =?utf-8?B?elY4elhWNTBiYjNxaVZkR0tyR3c3Kytjb3pMaldHeHZCdDRKTDNOSkVyWWU4?=
 =?utf-8?B?RGxXb3ZDdDFsQ1dseXV5bDJSYmd4R1E4cmJ1MFFhdnhuTVUza3U4VjVRNzAw?=
 =?utf-8?B?ZGxFU3l0cm1KT2kzYVN5VnR4Q2VCWnkydmlDeUpudGhqcldGYmZjc1loS1R4?=
 =?utf-8?B?VjVXTUJPYjlsZTdyQnhVSy8wQno5YkJQSjIzV3llRUhxbGZqT0cxYm5pcmt4?=
 =?utf-8?B?dUlBOFJXbW8veTEydjJ1MGYwWFQwQnRsTEhpRHk5c0dQYS96TlhlOFc4dnVp?=
 =?utf-8?B?R0RIOFFsZnNzYk1JRHB0Tm1VYjcvRmpKSnN5aUVSQktYVlVKWmFpRDYvVkdj?=
 =?utf-8?B?dE9QUnI3NW5SRUdLSFBIYUJSNVNPa0FwaXpOUGVCOFFMZURjNjVUSEJxU0pF?=
 =?utf-8?Q?0qZKDY26qIQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M0ZlOGlUN1lMQXlxSThGVHI5OW9OUkkzeVdqRTlCakZoelNmRWY2RmFMMU52?=
 =?utf-8?B?LzU4QWQwT0IyekNOWXJLbkZkSVMwSkdrMEMrMUJCWUNDNytrTlplUWJWQVlx?=
 =?utf-8?B?T2pSaXM2N3NDTWh4bkJoZXhIL2Z4bDJldG42cG9YRS9aeVJpR0E4akc2Qzgv?=
 =?utf-8?B?V3VIOG1YbFY0VStOMmpNSVk2alNtci90NkVLRFpXK3RENTN3cFhQN05OV0tQ?=
 =?utf-8?B?S1I5WlNocDRoNnd0UWh2cHRzR1JyQ21nR2dLRndBSFJNcTJnSkIyZU04a0Zn?=
 =?utf-8?B?UkdsdXFid0lJUUdCcGZONFExTGl4RWJqVjczOGdzK0dDWk03b3hSaWh1cG5X?=
 =?utf-8?B?di9vZHV6Y1hmLzVwMmt1TmxIbmtOVWI4WWlyZXR5aHBvQ1dxN0s4Zmx4YWxN?=
 =?utf-8?B?d0JnUFdkS0o3d2ZyclRqcFZ6aWJtNmtnOHhFc1djbnVUZzY4QUozSWRhSkRE?=
 =?utf-8?B?YWEyMkx6RFpnMStvcXNkYTFpMjI3c2hqNm00MmZ3YWR6KzVCWCtucU5Qak91?=
 =?utf-8?B?aEFCOHJWMVZOVHRGS0pzOGlXazhxUVRyRlU1TFJURHRxWXRJZksrNGp2enpu?=
 =?utf-8?B?eUQwWHVxek1DTU82alZSbjMvVUoyMlJXWlVmZ3pMcXhVTmlsOG1OYVk3OStB?=
 =?utf-8?B?RnZtYllzRFRQeUNVS011UXdEODZsR1UyUUpVcUQydnEvMjRMcGFDUEMyZmJQ?=
 =?utf-8?B?czlFTmNoUFFOQjlpUTJqRmVsNC9GZFNyZDg0dk5iR1FwS2E1b0F2SXkyU2J5?=
 =?utf-8?B?b2hHZ005cHdGQUYrUzZLUGE0dlJldll5clFFWG8zcFdSYmRReU5qa3RCZEtR?=
 =?utf-8?B?b1QzTXRMRk1SSWR6MmgwU2lOK0lZVDBpanZwVUJqMXFhMDRhZkhmd0dIdFdF?=
 =?utf-8?B?aU1LV1R5dE5WMlRCa2VsZmhBY1V2VUUwWjdPaU9hNkE2d1NMRnN3cmtrUzlE?=
 =?utf-8?B?UmFsSE1SZVZXZXlWaDVwNlVZWTBqNjNrNjFwenR5N2ZFRG82QjU3UEdYTjZu?=
 =?utf-8?B?TkVQc3ZVNEJMYWVFOE01dkMvREdFQ0xMNHVOalBYOTZaQnBSOHp5ZjMxU3kx?=
 =?utf-8?B?ME5jV2l4YkVWRUxZNTdhdDV0SGtqS1ZVUVBoWWJUb0VLNlFuM3N1b3cxVHlz?=
 =?utf-8?B?RTN4ZVpHNnR2aldabmdiN0UwSXZTd3dkZjJkWGgzc2ZWd2RTUEN4TE1OSWVP?=
 =?utf-8?B?L3FoVUVYcjF0SEI5aDJxWXdyTktpNW9Wa1Rtck9SOWl1SjFaRGFTdlhNY2ds?=
 =?utf-8?B?cnR0Yy96L2VvV1FLQjZJaXNnN3d1SzJLM3hHUVJIS0Vyc05PVGt3bW9PNjVG?=
 =?utf-8?B?VkNhRjQzZmRuaTZNWTdiR3dzVktVZkVvZWhONGxhV2NrUzFBR3FtazJpNWlt?=
 =?utf-8?B?OG53Zk5qV1BYRVNoOG5xc2EyZUpVUGtlckQrbWhGM2VrcU9ZN3pyUFh5Qmdz?=
 =?utf-8?B?TEZMeGNLVExQR3lmOHBOTU1kV20xeUVVRENweVJLcUVZNml0dkM3Y0JENUUy?=
 =?utf-8?B?YmQ1M2RSdkNUSnhVQ2ZzM1M5VDZ2Z3kxbms0NmEvMHJEL0IvSUhPMlF3QzR1?=
 =?utf-8?B?eW5RdEZqa1o2Yk9rQ3ZTeDBoR3BQY0p6eEduN0g4QkVnMmRYRHorVzdKQUFk?=
 =?utf-8?B?cTlVVUlOMVBndGM5aEpkbzZCcjBWNjhXWFdEVHRValA2N1pxd1EwN0NRdFNS?=
 =?utf-8?B?ZXlrdHpjKzJ6OGd6S0xsK3p2U2hqS2pBVlZMTUczTnVyUGhKQVFpYWZ2dHlr?=
 =?utf-8?B?QlhsNGVuMTVXeFlJQW9nclNvU0p4ZVRlSDJzTFpDY1hHeG5rbGE3ZlNxTTR0?=
 =?utf-8?B?ZzgxNVIvbm5xN041SFdlYTkxY3pXS0w3Snp2SUNDY2JnQS9hMWtybTB3REI5?=
 =?utf-8?B?TWVETEFZQ0VxK3JtVXQyTjNYNGZwUzUwWVNxeE1RSmNjeS9FZjk3WlJkeHhm?=
 =?utf-8?B?Q0NTUnA5MUtBeUlMTEh6UUhzeW5UZm5SSGJtNnA3MWhFVVA2VjcwZkkvSllL?=
 =?utf-8?B?Tll1bVF3V1RScHZpRG92M1VxeS9hZGZwZUl5MFdScldGK3JJc29MNXpIVURp?=
 =?utf-8?B?d3FZR1BVV3dES2ZzNHR2NXBxbHUzaWlXMkR2eURWZlZpWFAyRStzbDNUNjdN?=
 =?utf-8?Q?AVEB63sr931e4QR9Y35mbBkof?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f015bfdf-0277-46c5-8ef0-08ddd949a304
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2025 02:40:44.9996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rNLvql9T9Agr0CVSl8GWzCFbD7f8a/0XKEuLfSZPUWJIATpy1Y4mtp3rEqjhPkTJjVfgvBaKbtIM+hU978EprA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7172
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6E942180006
X-Stat-Signature: 87dzwpni9q1799w81e4j17hyaoubm6bd
X-HE-Tag: 1754966546-838308
X-HE-Meta: U2FsdGVkX1+SvzZ4k0HE8qp+QVnKvx/o/jOXOK6RukrDYWrDr8Kmw8QxXpD8vV7it08MGJJt53gVM7C5f+T0SQuxxkuJHGP61sfA2Bgi5gjX6e3KEzCAydSbiIY877yUvr/weBwwrcvBu+uxgFH01ivBwWhwN6VTNJpErHVG7zDkH1NOEYVgbxTGrCjfJuVxB/MI3r4OXujKCbx7ogPFS9hYONyPb/rwBIva9qk59/a8rSD4cFVLQpma154qVcyJmsrb1mUZHUJL0ZmPLIwoMXRgoZo10yqd1WB9y1Sxql2FaaSt9AuB8+fp9Kkxej0DzvDQ1blu7NTrRYQJrJwkPowVU9OZiCj6j4TWH1t/2oE4W8N60PtmqaRcuNK1mA3oEUgPiehcVbaNBEJSp/oEzkpVMdWqR1MNHT86uQFJt+DDKSqxvNoGkvwvCAeD6uHFu2XGnXVHFHDUvBrpn/kEASPeRvprswmyM/OhCgvMsftCPamqQ+ef+onbalPOnX3Z2Ttoe+soqiR3VmiWJ4RYkCbWYl+/E5hkyoRHY/eXq4uIAaunDncAAnHcK3ODCI4Ruuy9Iqe0Itlk+Da+O/nJACE+UufWYQnqodNLLAmmWsLFi4JKr3QxbzU2FEe7haXOAfJ2eBP+3+tA/JGEUKK+dQ1eM2GhQ6OHckfL5Oj7PClFRAmZEmTXRAGyNLMRXt8FcHFeRkD/iFEVYs5UgETEzJ3a0VrBOpjBmHIUJsFRaYrC3GmQNozsKksfwKmuyEHsReVNESEMa8WHAGf6SGdDdjuqulsmZvKEOTHvSzptYQ1HmPv0OgYHdX8FDDSC+/bJxR7ab43tVi3Y6J9EmcdPJ5Tl0UdGT6LmHJNfJPfjNJ22WNnLAvX76ffhjwzXjz152FSQUDDnfS1iAOhT1CSReNr1B0uJ67qVTwgw65FMDnAtCT/GcreXELTonWyZyxqweDK21Sn3gNxhGiLcYyS
 ToTuZZIO
 9tb8THqROOO4Yc2UkbA6RK0qUJq+KyEzSlAFQux3Iy2LW+eNUA2KrUqRtUZ0DqjqdJEpMrkwSMOTJ61cfEonuC2zKQiU/coVbz99DTjP5cIytuEdd+8E4nfAp1umdhraJDyp2xZuIv8/k4n4TdbdIQs+q/ss2PGRquASBH5ncEvHtZ4NUWO7A4mVHFGYiMjdCiMQOgLoxkEwL6WwNuQW+m6XmJeKsF3enuFU6BlMhgRVj8Ms87O7VBBQjD/cXv86FJn199DJRXXNCHJpbj/ASFSeIUswFe/VBC07cYtXJogs2nuZPBJeufeph1AJS+a8zxEkvF2M8Azk+9rHAMeTrR2xtSRCXdj7Kj8Mm6aS51zZ2S8AgCLzGm30RFJZwlLYHU97anFZz/nCVffP76VCZ6TWB4AUW3tura+DByoMJXy8cVLUG80u8hqL+z2wk963rRfYH6KI2JV9T3K2xVVTum28K8WUHMeqotMVL8zjYNEu/T+x0U8qIFH/q0gTXVWSkd1J3L5Bb1Xw7wbmc7rHDF4fAg2mtQXNUe3kp/ZvgquQ0/GW42q9hyUYzYXVc0W6p8KGmyPA5YEvbQhBosvgFHy83RR3bJQSof2YFzUtdSwXkEBCWzb69FlHAPfL1iXIdcA4jZxuIY3HMEWP1Cn61lFOzvea8gWg74TZo289xjDBY9HEn5zFn17VMEi4JATzpYewqC9F+BVef6qm6PQJ0QZheRlWxieRuOYrxyUB+fs5cwzzUpGvR5S0ZzP/s4Sk0rBSe72QoOvfj4zXDGjxXTKZVCVOAlizKLCX6U80E/5xCFstoMU7RLCbjK+cq1tgcd9Ed0vt8OAFLWLBEfxtvwZ3iaQFcx3CA0nkM9vhyxQW2gYjzy7Kf1AHVY6YD/iTUQAWBDy7AgM5KXNoQDCpuZT+CnwGYhrYNDWAL219mTrqCQzzEvddVYx7oVZcuVmD6OAyUsF2MMc1DFFmv+KxI0JPSodqR
 xyr3uhiD
 Lg5CscD6WCJobxGjgD7JzCXODIc1xcsEevY3qbJU32oF/W7O0NwUOnFRJv9WFrtKp6pLEfw032S8mmwWj/C+3QCbOYALhtAiLZyiNREBDqpIaZGK3Y7i8D/CeYv883eDAXhmf+jujNxhwk2qq1OUrzi0itRXdDwqfC9BtGOCM+d7a+5yyr1YXwh9AmifrcIt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add routines to support allocation of large order zone device folios
and helper functions for zone device folios, to check if a folio is
device private and helpers for setting zone device data.

When large folios are used, the existing page_free() callback in
pgmap is called when the folio is freed, this is true for both
PAGE_SIZE and higher order pages.

Zone device private large folios do not support deferred split and
scan like normal THP folios.

Cc: Andrew Morton <akpm@linux-foundation.org>
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

Signed-off-by: Balbir Singh <balbirs@nvidia.com>
---
 include/linux/memremap.h | 10 +++++++++-
 mm/memremap.c            | 38 +++++++++++++++++++++++++-------------
 mm/rmap.c                |  6 +++++-
 3 files changed, 39 insertions(+), 15 deletions(-)

diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index 4aa151914eab..a0723b35eeaa 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -199,7 +199,7 @@ static inline bool folio_is_fsdax(const struct folio *folio)
 }
 
 #ifdef CONFIG_ZONE_DEVICE
-void zone_device_page_init(struct page *page);
+void zone_device_folio_init(struct folio *folio, unsigned int order);
 void *memremap_pages(struct dev_pagemap *pgmap, int nid);
 void memunmap_pages(struct dev_pagemap *pgmap);
 void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
@@ -209,6 +209,14 @@ struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
 bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn);
 
 unsigned long memremap_compat_align(void);
+
+static inline void zone_device_page_init(struct page *page)
+{
+	struct folio *folio = page_folio(page);
+
+	zone_device_folio_init(folio, 0);
+}
+
 #else
 static inline void *devm_memremap_pages(struct device *dev,
 		struct dev_pagemap *pgmap)
diff --git a/mm/memremap.c b/mm/memremap.c
index b0ce0d8254bd..13e87dd743ad 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -427,20 +427,19 @@ EXPORT_SYMBOL_GPL(get_dev_pagemap);
 void free_zone_device_folio(struct folio *folio)
 {
 	struct dev_pagemap *pgmap = folio->pgmap;
+	unsigned long nr = folio_nr_pages(folio);
+	int i;
 
 	if (WARN_ON_ONCE(!pgmap))
 		return;
 
 	mem_cgroup_uncharge(folio);
 
-	/*
-	 * Note: we don't expect anonymous compound pages yet. Once supported
-	 * and we could PTE-map them similar to THP, we'd have to clear
-	 * PG_anon_exclusive on all tail pages.
-	 */
 	if (folio_test_anon(folio)) {
-		VM_BUG_ON_FOLIO(folio_test_large(folio), folio);
-		__ClearPageAnonExclusive(folio_page(folio, 0));
+		for (i = 0; i < nr; i++)
+			__ClearPageAnonExclusive(folio_page(folio, i));
+	} else {
+		VM_WARN_ON_ONCE(folio_test_large(folio));
 	}
 
 	/*
@@ -464,11 +463,15 @@ void free_zone_device_folio(struct folio *folio)
 
 	switch (pgmap->type) {
 	case MEMORY_DEVICE_PRIVATE:
+		percpu_ref_put_many(&folio->pgmap->ref, nr);
+		pgmap->ops->page_free(&folio->page);
+		folio->page.mapping = NULL;
+		break;
 	case MEMORY_DEVICE_COHERENT:
 		if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->page_free))
 			break;
-		pgmap->ops->page_free(folio_page(folio, 0));
-		put_dev_pagemap(pgmap);
+		pgmap->ops->page_free(&folio->page);
+		percpu_ref_put(&folio->pgmap->ref);
 		break;
 
 	case MEMORY_DEVICE_GENERIC:
@@ -491,14 +494,23 @@ void free_zone_device_folio(struct folio *folio)
 	}
 }
 
-void zone_device_page_init(struct page *page)
+void zone_device_folio_init(struct folio *folio, unsigned int order)
 {
+	struct page *page = folio_page(folio, 0);
+
+	VM_WARN_ON_ONCE(order > MAX_ORDER_NR_PAGES);
+
 	/*
 	 * Drivers shouldn't be allocating pages after calling
 	 * memunmap_pages().
 	 */
-	WARN_ON_ONCE(!percpu_ref_tryget_live(&page_pgmap(page)->ref));
-	set_page_count(page, 1);
+	WARN_ON_ONCE(!percpu_ref_tryget_many(&page_pgmap(page)->ref, 1 << order));
+	folio_set_count(folio, 1);
 	lock_page(page);
+
+	if (order > 1) {
+		prep_compound_page(page, order);
+		folio_set_large_rmappable(folio);
+	}
 }
-EXPORT_SYMBOL_GPL(zone_device_page_init);
+EXPORT_SYMBOL_GPL(zone_device_folio_init);
diff --git a/mm/rmap.c b/mm/rmap.c
index 568198e9efc2..b5837075b6e0 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1769,9 +1769,13 @@ static __always_inline void __folio_remove_rmap(struct folio *folio,
 	 * the folio is unmapped and at least one page is still mapped.
 	 *
 	 * Check partially_mapped first to ensure it is a large folio.
+	 *
+	 * Device private folios do not support deferred splitting and
+	 * shrinker based scanning of the folios to free.
 	 */
 	if (partially_mapped && folio_test_anon(folio) &&
-	    !folio_test_partially_mapped(folio))
+	    !folio_test_partially_mapped(folio) &&
+		!folio_is_device_private(folio))
 		deferred_split_folio(folio, true);
 
 	__folio_mod_stat(folio, -nr, -nr_pmdmapped);
-- 
2.50.1


