Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0F74CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 13:12:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9259C900161; Thu, 14 Aug 2025 09:12:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D67D900023; Thu, 14 Aug 2025 09:12:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C581900161; Thu, 14 Aug 2025 09:12:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C16B900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:12:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 286FB82F65
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:12:00 +0000 (UTC)
X-FDA: 83775400800.23.18AFBD8
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2057.outbound.protection.outlook.com [40.107.236.57])
	by imf07.hostedemail.com (Postfix) with ESMTP id 708C740008
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:11:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=V1H8bGP7;
	spf=pass (imf07.hostedemail.com: domain of jgg@nvidia.com designates 40.107.236.57 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755177117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DvHCizeAGj48lsyZU42BEID37dtd7IXAvZjIB9veYwc=;
	b=UCz/X8BDuM49ivHDxkwMTR0VpSxZHwwZBiqFGSoEgRxe4iNx2js9Q9H+VN8Srgz5IG1e8Z
	rsPJzaRXLjiT7PUmf5bF+/bX8bqXBTP4CrKYumQO/Y1EDiwdQnERgdVlrbfv4ci/nsDE+7
	Ow5/2sZLDgabZ24xHe8yCxEwg2q/4CE=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=V1H8bGP7;
	spf=pass (imf07.hostedemail.com: domain of jgg@nvidia.com designates 40.107.236.57 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755177117; a=rsa-sha256;
	cv=pass;
	b=qTbN3R8POtZitj1JsIDFDukbOWAzYg9oHQAOla2M8c/uolvk6P5txD8O6EbU834mn8zkGb
	WtkweG4RmIAfQ97EQp5piZr8DXXgc+Y8ee9Lhk1VqorT9jvWxbLpFH1PEK4Hp+ehCrnu+M
	eGo6v9GvEHvuM+HY3XxjIyWM4Xj8BsI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jX5xLlmqhLJm8XQrUtDnjjM9fmsg8IUKVrYCcl0yg4SVa3uzoflLbAnpQ7WX9zh8VN3A+AA+Si45hLiB8R/SK/xtQUJjtx1QLJQtK7h6t9FKYPXk7ZGMBNRIt7rTpXzwP0AvHoJR3+CT0Yajdbg9UvSs1HNvBky4hEMITJH3Id07/VXID9GJ8Czn4njVEpB3E5HV+kkg3vminKgu4OrLF51dLtaWjDXGcEsZTQNZMQIJfw533ERyZwHG0sMWMHpOQExh5GpqVx0wwFkF9pP8xbJqR6rdsREayUDDG94Fj7zg6j8zOKSo1MDQhaT/hMhPuNIdYDbA9QctFYUkavmlMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DvHCizeAGj48lsyZU42BEID37dtd7IXAvZjIB9veYwc=;
 b=oKsNnWpQDzHCHUE86EsEhWWRQKpnKlDs7rsbKpUZqe+ZuB1gA2zb+HzE0kokiYb/MAh6KSDfcy09EktqKmiqdSAGwaN/ixxly7XmG08kGpL41muhY9EuNFYnfwll2BMm3m1EMflZZQOgIVRJ2iE01Da1655KakDTtaEVAWmwH3q+5J4it9NKR1wIkFOwb1xK3gdFLNllcYJvrCfuUX/v9giyGl1tHruj574Hqeg6RFMcgKLOl67Hyt9Bvi20UenfyJ4ZfshN7p4qeagavjW8ZrmCXGNIcLubORtGK9hAQSjaXg7jwzHsYK6b1nx4sziO4PRfRW9CdALL7E1goPDJrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DvHCizeAGj48lsyZU42BEID37dtd7IXAvZjIB9veYwc=;
 b=V1H8bGP7F6fGrzICnM8/YR8xr9zqg/AlcBMb/+9Y3akxZw+0KX7geh3P2MGTKtdkPfxO5Cvcu/e5qDxFafz6Ur91j0B3A5mwnoGWKO1ml+2PD3NGnMPBxihjCSZoHlLpypbEG07wuLrlzY02Jz7kC+nXE0OirjABWjGotkYNJnW+IMrzJiCcEIE6nZo8Ye0AUdzfh4FGyjiLafdU95lhLS8KvX4JZaoLX6ICG2V7sJmHdxrd39J+0B0NcUw5dPn1Ev8gT0iEh8oQz9putdAYBW9UdnIeCarHZQnZnsK7V7mW8d/3OpXL7ZqJ3CJPn3NmalG8g48lYZ/7KbY1vuD7nQ==
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by LV2PR12MB5968.namprd12.prod.outlook.com (2603:10b6:408:14f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Thu, 14 Aug
 2025 13:11:54 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9031.012; Thu, 14 Aug 2025
 13:11:54 +0000
Date: Thu, 14 Aug 2025 10:11:53 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	changyuanl@google.com, rppt@kernel.org, dmatlack@google.com,
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com,
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org,
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr,
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com,
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com,
	vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com,
	witu@nvidia.com
Subject: Re: [PATCH v3 01/30] kho: init new_physxa->phys_bits to fix lockdep
Message-ID: <20250814131153.GA802098@nvidia.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-2-pasha.tatashin@soleen.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250807014442.3829950-2-pasha.tatashin@soleen.com>
X-ClientProxiedBy: YT4PR01CA0488.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10c::18) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|LV2PR12MB5968:EE_
X-MS-Office365-Filtering-Correlation-Id: affad82c-33a2-4c6b-f16b-08dddb3423b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?geAL4fR7j+em5NJXadljk2ptisRcYskGPiI/IklzYvRdC+ufzkW7dVqsuI//?=
 =?us-ascii?Q?KXdYLy8xyIEQYkgBbV40c+GMR2SW4oTlXbZfSHQ3sKKlEAv/Xd4FEu0CkW7u?=
 =?us-ascii?Q?OGEGDZALIEVAcmolEFEcPlSn1tNBevErFXVTZg8uhW3cL/GJ+YbEm9UhGrP1?=
 =?us-ascii?Q?Yuog0HYmvsp0W+PbFDOn7oI7XqlnV6OMJ4GdKrzmN9N79pFElhtul+dnLVMi?=
 =?us-ascii?Q?iJxs9NceBh8EnR6oa10FDn80Y0k5PNZCU3vp0+ua/gTrQIa7lE7sRbIALnlA?=
 =?us-ascii?Q?vPkrAa3yZgzkrb5hUWIzHc2YKI5hoOTnHF/jUnl/P0MFC2rD2cbUj/kKztEd?=
 =?us-ascii?Q?eVX+a8ZzxTUIiSj3dZJFRvXHk1OoZfQdRo/YULT4NNriQ+61naXLahYbwo5Z?=
 =?us-ascii?Q?1boI30G4L4UbqNsj0N4pKNlk9u3EIdwbyJopWwBj37VHijb26SeS+zJ7eHAj?=
 =?us-ascii?Q?7Psz5J1F673TdnELUEdLG9o9bMNvp/pUVijRX/WAFghV//fUUthC0LUzUZ29?=
 =?us-ascii?Q?Je2Tsub2V1tXZKSSseyxOYyP+GE9lxL1vd3mo+h3J5k04j1oXXDMxV5vRR0u?=
 =?us-ascii?Q?WOJoV/qw12nNzF5hoYOTTfFKp6y341tlJf2+N7r6vUUbXqbWL0rAwF0MVTub?=
 =?us-ascii?Q?iymeIA5QqxJvtdExwWRMT9EXn8duFrdMUx2LHAM94GRV5A8Ab+REKLW4luUr?=
 =?us-ascii?Q?AHb8b48gjBQUGRsauqbwD8+SLNzK72yQVkIXR3Jx/vXOXjeNrLHpYghzhOyx?=
 =?us-ascii?Q?6vQf0rkpb6fqiavxWj8NdjHuSo40GNv6u4fPcFkvrivZ1/OtY1XblzJ++MOC?=
 =?us-ascii?Q?J7GrgjP2Sh5rvJ6MKCGBeohL1weaAogDvwhO0zG2hhUnqICYALdVWnzsqEqG?=
 =?us-ascii?Q?CUtE4xXSIB10FoQUVY3bIHuAG0JTn2kEzcfB4r/2n4MBiG1WLcMcwy32sXQ+?=
 =?us-ascii?Q?AXtt90pa7RTupYMU00eJPyC5LRzIyr7t9WgqryC1wIlOlIDAeYqWk+BZLAjd?=
 =?us-ascii?Q?kN9eM5WHPP/DTxKZ4VoR1NWXPW+NGFqoR+draVZcPpf/VZwdBq/KVPMQ+pCl?=
 =?us-ascii?Q?1pWEbiY4FA6Ty4QXTBrQ71RkB9fViltcPYfRj4LwuTEBOzzkglSEfB4kGl+t?=
 =?us-ascii?Q?3FwaHER35l9xq6Phq0mE1CknotkdPeicwnFe5Dzdjjq/ReSUFi7g2GQc2dAF?=
 =?us-ascii?Q?sgC9zBD2s1Hza4AdCupfMjuCPbsiPW79OZZCf78lBTm3/y/COjNsCyTPjgF5?=
 =?us-ascii?Q?q3DQlo2TPt92mr8smKpIOBnDiE8o0taMrMsjGwLll495yiaHsaw0ThVdYn9A?=
 =?us-ascii?Q?OPnlke8CE5f1gCl+ajiDfmfHrHDGz6s+qxqGLXCOC4ijA0sq9/vDVYvgSwvv?=
 =?us-ascii?Q?5kuyHB4RqdZoOw13JTQCsMi1gcWH8bie/GknSoUX3sP554oj0aZEnpib4H/4?=
 =?us-ascii?Q?ZHgor+4Yhmg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YXQHqE5eJmpadpGnTE6Bh02riG453GYgZxS8HKNqw9Bekf4qIgp12ZIi9LDl?=
 =?us-ascii?Q?lYchlI4ct4msYwUILiP6cD7IIsngltdBQjk0N4mBTjNCx5nqgLz/vfoKuABY?=
 =?us-ascii?Q?nrZGt3LYU0doU3xwsDJ5EX2/7DZdkU8twIvq0o0kqpj5xYGnd/fPuFSFMdei?=
 =?us-ascii?Q?VC8NX/QbIXZCeexYpyQFykHrWBKAdEvZzDzj5Mm9flHvj9IDG21yjeWZRUEL?=
 =?us-ascii?Q?XupTgbR28h3p2nOpFUqKhwtD1HWt/i/SOVxFWl1K7DP9Q7ICRfprE5Kjz5W/?=
 =?us-ascii?Q?K9nspjT/Vn9/MHPK5zF3jG+bRqiGuODvTZYnrQvSqPd4MQJpxK4/XhfzZAxj?=
 =?us-ascii?Q?f6d3Z7y+EVwInUZp13SWNtPGfAlR+YP/9SuChrIAHOX2szWisrldLxP7XJ9W?=
 =?us-ascii?Q?7eSoEJIls/NWxiPOoZkp1g6/ZIIur0x+o8YvI2/v5yYwwUxlMtmQneilZgXO?=
 =?us-ascii?Q?BAVx4to/RgrbCrYKOw6DKRUZgre3k4r/7g1qjkvtjICpFOFk0SG8KcTHXuZ4?=
 =?us-ascii?Q?kDQBUMi/xeEAUGvkyv45iJVNZqPty8Pynf1dd8ojvdi8z+p04D0xVgSOUX/n?=
 =?us-ascii?Q?Mmr7V5Z02IFt2xZtJIJAzSZJGpP3by82neAuyHXvi2glKmoXlwlYSDJplkh2?=
 =?us-ascii?Q?uZr7cUG0Rc19BfnGFPY4XFWv24gcT+l/vrgwzLf6jvB/MLWW+sP/M4PYcpr9?=
 =?us-ascii?Q?tsEQnAZLUTIo5Gl2vexUFOkGZt9rOtzpaEDFN6GcBS4dKrZQjKbe9tYcf4Mz?=
 =?us-ascii?Q?KogfY6Q7VrR4oj07vlajhJb2v7Ksq+mF3O8pwewqmzWPvRXF+pAlgGAteKOt?=
 =?us-ascii?Q?E4qFhjxg1S3AhDNC8p2wIdlg2OgF6YPZra4FduL4RE6Z/HyXi/rTd/A8YhWO?=
 =?us-ascii?Q?hkHt9Ngu5eAawFJ3sRchBJ+/19Yh7L/+nQhJ0n8ncSmAsN8C0dL9u7p14SE1?=
 =?us-ascii?Q?f1NRZMtdoTl3Fv/zMlQA69vfv3wfHLYDs+kzmWKKY4stw/sHVcGGVKKVbG6u?=
 =?us-ascii?Q?Qr0hz+p7YWFdHfM+MmIrd1E7VIuHfLPFqu6oNzzcGMlcxDcpnKiZcZVia40/?=
 =?us-ascii?Q?MffA1JCXAPTHZMAkFk8zJRt8uSZvhm9dyvVQ2vWKedFsYvAvcPJuNddElV4r?=
 =?us-ascii?Q?hDSVnPILWfAwYAVJAYni9v6yZDtKwJ8TYEeQbNMgKxeHr4r5g6WdJDh+Ip5Z?=
 =?us-ascii?Q?U2Vb9Mti+9MHw98A+4PyHMoR2sYWewY73YNya7Su+9CfF6CYSRdT4nTJVwAB?=
 =?us-ascii?Q?HZ0xJl29+JnHIjRM+Igl8Uu+VGdwVSagYpcMwOoBOIY+iiIbGRcjSB1YNsSZ?=
 =?us-ascii?Q?SfF07/4/9mbdY8e+Yc0+jucLTiMJZLlT/v7GrIB4fEvHS4FI6DGHy/9tuQce?=
 =?us-ascii?Q?g0TpwYhjO2/0E2anHFNq1Q/Z2pSwceGx6JzZrru9vC9AdvpnVmEySsUdZrjb?=
 =?us-ascii?Q?HXN41nLUw1qOh187Vv6+z/QbapzeJeGlfgPtJJVByNmhS5iDfJyXDMvYQ1Nd?=
 =?us-ascii?Q?Dvi1gWxFYQnjcA3bQ/jOqA8sW05KXWeSC0GWA1dIlRxnQZ1KEt9LblXeqSPE?=
 =?us-ascii?Q?EdRpk1MD0++gJix2Kbg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: affad82c-33a2-4c6b-f16b-08dddb3423b4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 13:11:54.3164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PfSWL2JVFFFJqLaUyrIFM6oITRJCDEQN2+lXwS3v7OrMQOkYMZGxleHO483Q4n6A
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5968
X-Stat-Signature: ixrwidj69apxnsyyqoxxxjo6uae4mu9j
X-Rspam-User: 
X-Rspamd-Queue-Id: 708C740008
X-Rspamd-Server: rspam05
X-HE-Tag: 1755177117-494722
X-HE-Meta: U2FsdGVkX1+zo1N5pK0RoL4whd4z1mEEOHywm3f4uogxmxB0DpyCzbHmoCtWSO0koXc7qU3tXRnaOzBBv9mkbbz9hw/xS/juFCfVsuZKWWaVOgGX+iHFaaYV2SGXZvrUy6UrxhEfQo4BT4+EF4zyVRQq3cUX5kFDKVAzzDoUypo7DQzOALYp3KQRev9+zx1+vD+2Wdnf6IODailmXMwTFNTX2cvdB9RSjDwCG6+QZ3qSnEQW/2TFrO2UdpsG4BORLrzS3ZAIz/n4PwBAVOjS50/tFTp9fxR1D6kGajwTIYrfkhdZZidiG2WAqeRTFD5eWS6eTBb7y3wGmZFhr2cD1CsQ/vhXS87bgu1donfs3gGEPZdpFDk4/hhVTjVXxsyKDZ3NNY4haPEVEg1esgTFt3e11SMag/T4fI5r/cv94PfekmJF7z+CH1tzsVWevcpfcfZ7kMcZfr51Yix+L0fT5241qM7PAcMZPtZgcZTZKHIxpGgJ1ZTAySPCgQsJ22V8p2ONB9baFg74RTy9Zn9OeGBcmwzHC3xs455gwQb5NUqh5rR0oz/WHdlZzhcBz6WEJjfX0AP19UUIPhBdIhPOxIf7hXDbzvz1bZaGp4CzJjBgEpqJtziFWT5UoyIayTg/h6v0IbVQJAV9POkuWQIa0JHkrKx40Jf8ZyfMc8U4sNrZnHW2srteWXfyYsm8rdbwttB8uVWg/E1l58IUSwOkzDJRmKhoY3tHYqLkAUnxD6/LsBNIc8EiWCZ41Qm2MJziPkzql1k8t6Jwnf06o7NyIchOBIRRA83OXwlzq3rx49sdYy5K7UtVbEFe10S1eEZYnrEv/04RreSzGs5j96v1lXJZyRpxee5BIQBLbqQd6yHfezsWixouzizd8YXlR3LSHLW5DjocMTPeXcrujcacynO9z5VNPB+r11qmwVdS2DNzf7LV32pJ8WKRuyflwxIsBKpoNk8Ejjn73xI2Tr3
 lcegbZi+
 dNQqkxUJ25DEukzv4IlHiseR/kaTjz7UnFRGLzxIi/sn4/VUaYccNPRecyCUMu+tsnVvPpAJM8ZjTWpILvSvB2+xQzqZEZI2l1CunGbFw/ES2YXnGsvGOK/i32L3kC6bw0ReUXdDQySUfhUKvIfO2VOGsh6uL4pK0hrXWNgnHgR4gjT0IGLZ9odirzOLGzTM75gPI/1vWZ/DMLS+SR9nTzh8md8CVkX0n8nWINWdDy9n1gaYJFOWUwYpcUsO3t4iKQWACyFNHROXYr2h0AaLMmvcUMsNkcA6FZsvexr4onW9qP7XSpb4+A4JtUrxjOrmbWOL2SV8Aa7Ft/ylUh3CBhEdCbK3+YhdHRWaFSgzDR5B8u3kqUm0IyhMwP2K/mRB8QEOIijKK5yxF6mPmCWPb3iuXCdIWaWo4SoRXat0ELqnbjyrAJKQYw/sAPn+WwYuQyTRDRtdjontfCbHWCxfJS51fFj4zCkmvju08I1WjukU0IWR7wiL8ByECT5QQQFBLwN6VvnSIeb8rkW+vCDk9vKIa4FI8cncu7UlFIQcfUQKIiqaUHaganxdulAnJN0rlxES+npyVwFtp3AcpaglaT2CNhkpB7iShqt11n6hVunMhyb0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 01:44:07AM +0000, Pasha Tatashin wrote:
> -	physxa = xa_load_or_alloc(&track->orders, order, sizeof(*physxa));
> -	if (IS_ERR(physxa))
> -		return PTR_ERR(physxa);

It is probably better to introduce a function pointer argument to this
xa_load_or_alloc() to do the alloc and init operation than to open
code the thing.

Jason

