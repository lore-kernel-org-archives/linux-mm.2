Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4345BCFC28C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 16:42:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AC256B0024; Fri, 21 Nov 2025 11:42:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 983FD6B0027; Fri, 21 Nov 2025 11:42:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 872266B002F; Fri, 21 Nov 2025 11:42:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E9E66B0024
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 11:42:05 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2447389816
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 16:42:05 +0000 (UTC)
X-FDA: 84135181410.15.3297ED3
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013057.outbound.protection.outlook.com [40.107.201.57])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1E418140007
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 16:42:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EKNXRdNa;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.57 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763743322; a=rsa-sha256;
	cv=pass;
	b=YJCK46cb0wRC92mTGuG3JKNwQ33zkO0HaKeaRxeb40Q6l0ZW+BpooqFC3f4XbrLVt176v5
	GY1z8sJTLho+O0afe1eoLifeVx6hdR58G6mJICKNdAozT7Pw+cD/1x2/JxSUtaVcd+0hFJ
	ZNATWhaDwoOn2S+BsLxfdl5Qzmv0/rM=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EKNXRdNa;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.57 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763743322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CCvOO16pGJ6wiU3PfiutbrDFXC1XK87m9axUJVS7VRs=;
	b=xqG6hL2WGMQ81409r32XZoXmNZP+cC/r7/kGtRUJ8B8G2C8keJVKkSJP3VIy5UxGIiWEtz
	lY6bgkV+hGrhZ6lf6wUQBSX16v8us/Mmop3FsBQRVSjIDrIQy8VDnEQlF9ucnn6jwo4Aiu
	E7ZoQ5GDSsFdXIcQQrrCNj+8RliCwfo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wpXQoR8hzOg5g/40D5FyGNHUR+U0sWUx4PeK+jEPmmKWythBrth1SSsA+divXER/eLebuA9Ke7v5EGHtbe3S/6ECGmmVIX2iXtaWDndq23CnHESjXKEhYlw+K/py7UkMa8drbbMj9NJ3hm0RgpqpUGJR1dwQI0aFWH09qiE9JW7IYK9wJ8HT0+v+l6Ev1DDdUDS3tRzkoroJyjuhCL7HTJJU0GgCHOVz67rSbJAHbZ5XP5ABLXGg339JIgrr97T6ThlIcAveU91wFIgpx5Ttog9Kad2pDXu5FFftlgVyteIMETcHDy9F9icCig8c9pxmu51lFykyppBpudleM5+qrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CCvOO16pGJ6wiU3PfiutbrDFXC1XK87m9axUJVS7VRs=;
 b=zLjZYjV4XQy3w1IwVWgaMnTbKbL6+aYIGA4klhekUkX8nsb8XBZxxofVtHDHieP93k8AgqQgD/vhdmhxZTglfuhft9cxLSqz1S1fGWgDo5Eqc7LZREpJ1E6049CvK1KSogutU/Jt3cUrL+tQ6kxXVYRA9pG6AEWe/V3GXTMpZ3ytPaHUGlFPLF364LPMdEPoUeDX1/fYZGa4ee4Vgxc6ahB1tISSyik7gkacZxTz2cFax4qMVt+ofjpMWB/VFTXE1xQeVa946FVX4zNCbh0Pvvi075tIoo3i51etgXEeU+HkJ2IE5nNBSHUNi6Vni7UF7L95T1q3+BAOB7aAWzkBnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CCvOO16pGJ6wiU3PfiutbrDFXC1XK87m9axUJVS7VRs=;
 b=EKNXRdNaoaEVVEQWPrzHPE5oOIdU5JPeh/VuEnW5d4ThwFFAHZCMePH6Skfq8R2YEUZvk8rHYIyYKNRsZ0rXu7eOkZ2Zl+ayzntM8nZWJ9H4rjYPV5EIv3LrN+EwrSw13Wy9zaCu4PYu26/snxAkaq1tUbRTICX7J/XLHKu9Q7WMZXmjVHQXHTZ5ZVuhKw/X3Ny8P+QVH8u7fJLiWaig+qYkfWIyi26sr/WA3aSVfIb72/xk/zVvJ4Ne9Je7OZtS/DAp+XOHfQWlScyvJBRy4YatQIqhJhJ5UqV4/WKJ5mt51EvVgbFZ+zetIqQSG0xj6AXNDBDetjlAEwxC3yWFLQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN2PR12MB4472.namprd12.prod.outlook.com (2603:10b6:208:267::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.12; Fri, 21 Nov
 2025 16:41:57 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9343.011; Fri, 21 Nov 2025
 16:41:57 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/3] mm/huge_memory: prevent NULL pointer dereference
 in try_folio_split_to_order()
Date: Fri, 21 Nov 2025 11:41:54 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <73075A18-3C07-46F5-B8C8-9018D2CD22DE@nvidia.com>
In-Reply-To: <c29e2ec1-c607-4467-b500-617584c8fb6c@kernel.org>
References: <20251120035953.1115736-1-ziy@nvidia.com>
 <20251120035953.1115736-2-ziy@nvidia.com>
 <875584d7-5a68-4f7a-8549-2a9cd6c7f9d8@kernel.org>
 <FCFED9E9-56A9-4260-8B42-D0BCFC83C506@nvidia.com>
 <c29e2ec1-c607-4467-b500-617584c8fb6c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0195.namprd13.prod.outlook.com
 (2603:10b6:208:2be::20) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN2PR12MB4472:EE_
X-MS-Office365-Filtering-Correlation-Id: 001194ce-fd43-4054-bcff-08de291ce28f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N1RmVDBXYVhmQ0xHblBTVVY3dUp4N0VuVzUrcnFDVGtiK2VWWVRRcStOQzVZ?=
 =?utf-8?B?cmxQRmtSRmQwU2Q2T2RMMWZBc2lsODZYUjY3THZBV202ZGVCOG4wMGRrNWpJ?=
 =?utf-8?B?NEh3L1RCcFJWMndmNHFaNTQ5ZjhPVWFzV3J2TTNDVmQzdWlHN2JJRy9zVmFT?=
 =?utf-8?B?RjI0aUxiaW5TL2YrQ2Q4a0NWbW1UZVIyN2FpcTdacWxoVUY5T0tqa1AvREdp?=
 =?utf-8?B?elZTbGh1dlgyVVpYMmdaaFpFYm5jN0JMemo4My9MVU92QjhnR2JpYmJGSmdF?=
 =?utf-8?B?SkRuWGw1VHJGa0FnbEd3RnBuMjRkbTUyMlJCU2RWZGNXMXhXaFZRNWNia0pu?=
 =?utf-8?B?TTdFUW4zUmNtbHdRMlBGK3JGcFFVT3MzcmdlMVczVWFRTSswREpEM2JHZ3dX?=
 =?utf-8?B?akZKcEMvczBpVVd3TzB5L1dMN3dZWXoxQnpwSzNtQXNpNnd5NlVMOER6VHhD?=
 =?utf-8?B?Q0Y0VEJPYUczYXJzcVpjVTEyTlFaVXZaeC9pUlZIOVhEV09EcWhkaHprcWp6?=
 =?utf-8?B?TTBmNVptTFJrSjU3YUNHd1JBSURXOVp6T05ITmlvWmN4QnVscHljRU9QVHFQ?=
 =?utf-8?B?WGVUMjBtaUU0R1FXYUkrY1hlQ3QvMGRnYVFMTXBwd1ZoOFk0dVBpNXpaUWdx?=
 =?utf-8?B?QklyeEV1Z25PSGxIdjlnVWhXWVN6ZmZpb0puRjQ3Sm5vSkh2ZVgzVk5pZFF6?=
 =?utf-8?B?bU1NNW42akV2aFZRcjJ3MU1kbCtsT3hOMDZZQytHY1FrUzZjbWd2U2JZRS85?=
 =?utf-8?B?emxXUXRqNEQrcmhVMjFFUDdQVnNLTnRyV2NVaG5PdENCdjdUTlBmT2J0N3pZ?=
 =?utf-8?B?QnB6anN0Wm1URUcyMk5CSWN2dzRLdWxIdFNyUTRaZjFJUU1aK1JKNmthUjJO?=
 =?utf-8?B?ak43KytWb0VBZ2tDQWlGSVNDM0ZxOThxc3Z6ZXcyMEVoLy9BVkFSV094NG1H?=
 =?utf-8?B?VkdXZnMzNzlTSWFDOThjZkd4eFpTRDA5cFpNMHdMMzY2cCtNanBhU1hpenJS?=
 =?utf-8?B?b0tiMTVINnRRU0NLbE40VVd2TFdYQ2FLcVlNcHFFakhxM1orSE9MNnFDMFgv?=
 =?utf-8?B?VkhxRHhzU3FCa1EwaW1kbXBmaWdVQk1BRytBZWtQeGU1VjBwNHZGZU9BV25u?=
 =?utf-8?B?N1FpQkEvSnJvdWdXTHNLQUtKU1l4VE9zMXQyN3h2Y2F6ZWV0T0IxWExMbnly?=
 =?utf-8?B?SVYwS0M4dHl3dm50Ullic2lkbm1MdEVCb0tlTHdjL0tITG03am5ZNDY1SytN?=
 =?utf-8?B?bXRPR0t4OWpueWtJT0U2aXZnbnkyRHFHc3BuaFdmOEtFWEtzS3c3azRuRDVy?=
 =?utf-8?B?L2RicVhQUkRMZFBnOFRhWTArUTc4emdPY3RpV2pnY2VCVXJnUEVnSE9NK3pL?=
 =?utf-8?B?S0NZSzVVcWhMWnlNOUxwVVR1OFRoV2JPVWVQTHFoamQrODZNQTFvODBucUFr?=
 =?utf-8?B?RUdjNzhkYlZvZE5qaVhwM3BtRk5lUU43aHdNS1hpSnNzZXJscGRLaHVWUTg5?=
 =?utf-8?B?T04wTzc1NExZRzNPTU0zOTBxNUZFaUFzZXU3anZWUTZoMGNxNWUxTVBxeFh3?=
 =?utf-8?B?OWs5Qkhad0lyTWhLaUptUk42ZzJqRXBYM055T0FUbXdSUC9PRVlxMFlxdTlp?=
 =?utf-8?B?S2VsQ1RlRVY5TGFPVGgzWTE0SWFnNDdQWTVXYm9CWU9xUmN1OHd5QloyREls?=
 =?utf-8?B?K2xyYjlqcnpQMThKTE80SUJTeFl5bktJUHkxVmZtYnNrMXEwRlg5MjBTcWZU?=
 =?utf-8?B?SmxqbVBKaTRaMDlKejJmQTlYTHpPRXdHRGhxTHBlNnNjRUltVVp1QnZ0eVpw?=
 =?utf-8?B?RGp3clRKaXA3M1dQUDdwUWZCcHgxMTR5eERvZlArUGRLREtEUkdDZldHV0dE?=
 =?utf-8?B?eElxSTNYUGFNY0tydHIxclhCNTFRdjVIYkxBOWQ4NlZXQUFPMjBaUUxoTW82?=
 =?utf-8?B?TFRQakFqQ0dVY0traTE3RnFxMExXajlLK1k5VjRxaEp4eVVJYVZmNWNGNzdR?=
 =?utf-8?B?dUNHQW05LytnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MldmeERwZG1UcUJQbWFKcXJtMkdxeXBnS0Y4L0l2MTBTTVFZZGVvZVlCZmVu?=
 =?utf-8?B?V2prK1R3MkI0MUVnMi94ZzJMVWx6ckthVHlOaFBoeHk5RVd6RTJJa2dzai9i?=
 =?utf-8?B?WW5VUnQxSGhCQUhnTzl6aUFjdGFlS2d1SHJEL3UrUzNpRFl0d0U0WFcwN1Rp?=
 =?utf-8?B?OXBteDU4Z0xyOGFRK2NGb212NStBa2YzN0tDV0dOUHNUcjA4WHU0RFFXV0hk?=
 =?utf-8?B?QkhGNmJiblNmVTJoNkkxOUFhQUJFRlFjRXhrWW5lMVFxbVUvVGRZeGlwemxC?=
 =?utf-8?B?bkFCUFliTitLcjJGdlVzNmlRaGZiQ0k1aDR1Skk1eFN2OXZRa0dlK3J4S2hP?=
 =?utf-8?B?L2VxSk8waUpIT3FmbmhmSWJDd2xhZjRXclNLNjdzNjRvdGNIRW9zWXI1R2xr?=
 =?utf-8?B?K1k1WjNtcWlkWEdrTjRtNklURWtoK0Y1b1p6Y3FtVGtCZERSUXNxTENQVFBR?=
 =?utf-8?B?L3YyVWRUaHluZjF6WnBOK0dUNS9uK2pJNXppNWRrR2cwRHJHK1JvNEx1TU53?=
 =?utf-8?B?ZTNvdjB5K1RUWGF6aC9tajBYbmptRXBVdGQ2K083K0VZMGRjbnM2Tk5DeXJ6?=
 =?utf-8?B?M2djbzAveUtiOE0zSm0wK2xQNEV4YTFZVXZjUTdHS3NRbExBK3pxV3ZxWFdv?=
 =?utf-8?B?cTQ0ZXp0b1d4TlhrTEY5T1NETStGUnVXV0ErRUllc25BblFIcytTNFZRNGV4?=
 =?utf-8?B?SnFjaTE0TC9tdW1FN1VNQ21hTkdYMlVVUlBweFVUZlpEYjRoL3pHZmdmSDVZ?=
 =?utf-8?B?amN3WkMvWkl1eTZzYmJoNklSTDkyQUhHNi9KTHJVVU5qaXJrblM1cDlsdGFw?=
 =?utf-8?B?aitPYmdHVm05cW50WlNaZzBMYy8ySzQzWjZEcytKeUlnUWhkeDNVK0tZSlVj?=
 =?utf-8?B?eW90U1hXSU5LZVp1TEt5Y2NzT1FsN01xZjc1Nm83ZEF6SVR4VkREWDREYy9E?=
 =?utf-8?B?aXNBTHAxSzBFQTgyVUs4VFlLa2VuMTRQRENZL1l4OWtHSkhpYkJaOXpjN2Nk?=
 =?utf-8?B?QzNrejRBejFsM0RnaGJUM0szQmhEMlFTUFo0VExKdE5yN2gxaHBoYVhQVmIv?=
 =?utf-8?B?Z3VmWFBsN09pb0d0L21jaG5UOHdTMzQybG1lQ3diUUlMZGY2cFROUWJZcHJJ?=
 =?utf-8?B?bFVBL3FOTTFPaGJEUklRcGU0aEd0MnJlSDNtL3ZZOWphTEFLMXFaKzlUZVll?=
 =?utf-8?B?V1FCcUwyM3dHcm9TTktjYTkzQi93TmpIelRHK3BvempCd0NVc1AwRGVtNlVt?=
 =?utf-8?B?MzF6VW45b00vVUp4OWRsY3JXQXFENzVpN0RxSzdkUFIvbWgxU3ZVTTRuSitq?=
 =?utf-8?B?M2tCenFoUVoxRDZRQkNnNDFCYWxJMXp5bWN6amRKMnlsWXJEaG9HZ2tCaXdw?=
 =?utf-8?B?akZtSWJGYm04NDlzV1QyV2hZVDFwa0RHenc4dWVGYi9PUEZkekYzd1RNZjZ5?=
 =?utf-8?B?d2JmdDdnWlZXYmlzN0xxNmlxUzJkTlM0V3pDWnd1bENucWtCL3c0Y0wzYzA4?=
 =?utf-8?B?OWY1ckNraUUrUkh3MFloM1hDSFdZdGxDcEJLREdKa2VMVFJHcXdFbTdkTnRM?=
 =?utf-8?B?bmxPMEF2TEhqMzc5cVQ4RzE5OUVPVUJNVW1VWEFRWUk4VHFlN2wrcU0wWWlN?=
 =?utf-8?B?ZitaOHRYWFF4L25IVlErRE14QjhFTW9kNkRHbDlpcU5Na2UvSFEyODgxMG9u?=
 =?utf-8?B?d0h0OHNSbjYrM0I3NnAyM3VzbFk4WVhEVWM5SUh1SWNoYXBZb2RNWXE2RlVC?=
 =?utf-8?B?SG5uZEpjL1pTQzZjK0prUEpJL1FNT0JYcThyNS9Ob1RlT0k2dnVHTnlELzI1?=
 =?utf-8?B?SVlxRUJYQlIyYnkwRmpnMUlGUWhMUERGcHZrbWJGRXN4TmJPM2k1akVsTmdQ?=
 =?utf-8?B?dHlFaU0zUHFEZ0ZhV0pEUURNeklGWnFzNUd2ZlB3bmVJMVpzSHVEVmZVZ284?=
 =?utf-8?B?QkoyanNvN0dTZTNRby8xV1czUlBrTHJOcHdILzZ0K0g2SkhnK1M0aWNzSDVI?=
 =?utf-8?B?T1lvZm9sY2RGK1JsRDF5TUtXejRrNXVxVVNQUmJETENuWGIxL1crdFA0R3hJ?=
 =?utf-8?B?SWNlcUZuNmw0N3U5Vk85TVRmQldhMkJlTnZna3NPVEhJVkludFhsQWVmdDBj?=
 =?utf-8?Q?55YFzShduV/qYTcnNvmOmUZCo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 001194ce-fd43-4054-bcff-08de291ce28f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 16:41:57.1535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7GCYDEnMSjLc6xA9kkwkYHzcQL9DYan4IlqUqDwNrlIOKrPQG7Ea30sTP+K4Fr8N
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4472
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1E418140007
X-Stat-Signature: 9qekymt44gy3xb1wq857eg9gqwjx4zm8
X-HE-Tag: 1763743321-455184
X-HE-Meta: U2FsdGVkX19fdNgEtlElEh0UEqEnZVTlQTfkcxRwSfHIXOJqXtF3QMHGV1SUM3CCd6xIqkYoGTw9icWa2yUVYGSxUg8MFhVB+//mB9ceTzJSi2s+M6ZXIyH/CMKjfsVkTzsXnRoq5HxMko4zA0w+HHxdYioHS9B6W1sj5yRGLMD1iA6Ag7Fq2zS0QQkQCwB7zKxZmEmE4qG5iPSzsZYSR14w38HYfS6pkgdXtnGFFMRPmEWTTXwRVseNvEXwUbzyLgKb/0I1ZbnhJCn1A7Z07NjyW26fae+ce45sE+NyyOErb4xWrmxilFZyKGekibU+VVat5cdZM3Fd65e2kzzCnE+eqcwS4UMj5/m7efy8UhRUsf9Fw7UeQw0qRoQkJbADzPASepZnIZmiiOE5FKeaYbKa/pmDiIHphQRsHpilFQJLH6LReglXL/ox5zKJUhESKOgYymZr0XJfewlD+9B2t2gOCYWR8Ais/BJ5q8omc6NMagqn0EQTRQjOoFUwu+Ya0q3LKjEnRFK0Ti9cf8nkUX/REDuNwthDJJxm+MObrvPu5+lDSEewlnXBqc6JKE1USd1ySA+pBDlR/VdYS6l39bIpdc3u0Df/nX1jFQJlhzz5gRnDolACrAJ2Ib8aQg5OBJ+7TntUsBry/nMoOy7b/1pywlz59S6/p24MdvmQUX38hAwj2kho5YiimTn2mDPfxDCkCcTa5OpzybdsYYOZpKaEHzKbQCnguh7nM7GA3RtYiuvgmh1Fe9uITYsMyA76jjq4sVK4qezFDlne6jto8UYxEAPSsloHSZ7KR+FbQPITqfmyGQ8mnQzVkfi22ifEJgS0d3cjDE/xFwlQvkC3vbTiIvYaDc4oF7Gs4UHWPYoRh/4yXQXFbfS18LduNjAmcN7xDmwoodm8hWN69rEW9zdGW3HO4iapYRLMTDg9GMk5jrUrZPrQAt8v0E1CY2ALN5WvyCmdeXTYk+eFqCu
 2q5x6RfA
 X2pxUd6yr+zJOtKSpFafEICwTOg6sV2xg/yHzVmVBm+hpi90rLs6KzNG8u3GbxnMlGQFidsOnISEXWxqzEkZ02Vt1YW2NuylM16y8DqQ2oJ9GzK6pf2/5Gu886mJrQAj/nM7OrJbCi1RwOOSTQjDJsEoNHeCGVdBn6lDF5+CLBU9XTKM7Gw3wDeagv46ckwsw2p+St19SseQt5KdaWXi+ndY5oXqomFH/31DcKWctB+Rrio912tnjjspiMGPn3MPybxVnJTFP1MSB9eNUZ7sMmBMY6X+9AD4fK5I2hHu8a7WmpSJwxEez+3v8HbsUioZJB3HXzbvO4ZDUGsVt/fyrLhVKTvC3vL+PmMssHpZ4OYxvTeth3ViDtDOJNwXjgCvszZNrk/z16/bMUlXNz0/Mtdf4TPojeSRcPkRiAqFew7rW6n+xipKHdP3Sbgnpyo5vCdeugiQqm26mV5FgNo/VtZqkQvx/QSzdg4S5vDgCrfudb3gisBhIn7A6n+XvQ9N3xH6YfFFpl5SwoY3W/ErP+kuGCxTmLoTcxHiIj7yfPpqwHOp/hBNZya9mgg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20 Nov 2025, at 14:56, David Hildenbrand (Red Hat) wrote:

> On 11/20/25 15:41, Zi Yan wrote:
>> On 20 Nov 2025, at 4:25, David Hildenbrand (Red Hat) wrote:
>>
>>> On 11/20/25 04:59, Zi Yan wrote:
>>>> folio_split_supported() used in try_folio_split_to_order() requires
>>>> folio->mapping to be non NULL, but current try_folio_split_to_order() =
does
>>>> not check it. Add the check to prevent NULL pointer dereference.
>>>>
>>>> There is no issue in the current code, since try_folio_split_to_order(=
) is
>>>> only used in truncate_inode_partial_folio(), where folio->mapping is n=
ot
>>>> NULL.
>>>>
>>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>>> ---
>>>>    include/linux/huge_mm.h | 7 +++++++
>>>>    1 file changed, 7 insertions(+)
>>>>
>>>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>>>> index 1d439de1ca2c..0d55354e3a34 100644
>>>> --- a/include/linux/huge_mm.h
>>>> +++ b/include/linux/huge_mm.h
>>>> @@ -407,6 +407,13 @@ static inline int split_huge_page_to_order(struct=
 page *page, unsigned int new_o
>>>>    static inline int try_folio_split_to_order(struct folio *folio,
>>>>    		struct page *page, unsigned int new_order)
>>>>    {
>>>> +	/*
>>>> +	 * Folios that just got truncated cannot get split. Signal to the
>>>> +	 * caller that there was a race.
>>>> +	 */
>>>> +	if (!folio_test_anon(folio) && !folio->mapping)
>>>> +		return -EBUSY;
>>>> +
>>>>    	if (!folio_split_supported(folio, new_order, SPLIT_TYPE_NON_UNIFOR=
M, /* warns=3D */ false))
>>>>    		return split_huge_page_to_order(&folio->page, new_order);
>>>>    	return folio_split(folio, new_order, page, NULL);
>>>
>>> I guess we'll take the one from Wei
>>>
>>> https://lkml.kernel.org/r/20251119235302.24773-1-richard.weiyang@gmail.=
com
>>>
>>> right?
>>
>> This is different. Wei=E2=80=99s fix is to __folio_split(), but mine is =
to
>> try_folio_split_to_order(). Both call folio_split_supported(), thus
>> both need the folio->mapping check.
>
> Ah, good that I double-checked :)
>
>>
>> That is also my question in the cover letter on whether we should
>> move folio->mapping check to folio_split_supported() and return
>> error code instead of bool. Otherwise, any folio_split_supported()
>> caller needs to check folio->mapping.
>
> I think the situation with truncation (-that shmem swapcache thing, let's=
 ignore that for now) is that the folio cannot be split until fully freed. =
But we don't want to return -EINVAL to the caller, the assumption is that t=
he folio will soon get resolved -- folio freed -- and the caller will be ab=
le to make progress. So it's not really expected to be persistent.
>
> -EINVAL rather signals "this cannot possibly work, so fail whatever you a=
re trying".
>
> We rather want to indicate "there was some race situation, if you try aga=
in later it might work or might have resolved itself".
>
> Not sure I like returning an error from folio_split_supported(), as it's =
rather a boolean check (supported vs. not supported).

Right. My current idea (from the cover letter) is to rename it to
folio_split_can_split (or folio_split_check, so that it does not sound like
a bool return is needed).

>
> Likely we could just return "false" for truncated folios in folio_split_s=
upported(), but then state that that case must be handled upfront.
>
> We could provide another helper to wrap the truncation check, hmmm

Yeah, that sounds complicated too. Putting this truncated folio check outsi=
de
of folio_split_supported() looks really error prone and anonying.

>
>
> BTW, I wonder if the is_huge_zero_folio() check should go into folio_spli=
t_supported() and just return in -EINVAL. (we shouldn't really trigger that=
). Similarly we could add a hugetlb sanity check.

Yeah, is_huge_zero_folio() should return -EINVAL not -EBUSY, except
the case the split happens before a process writes 0 to a zero large folio
and gets a new writable large folio, in which we can kinda say it looks lik=
e
-EBUSY. But it is still a stretch.

Ack on adding hugetlb sanity check.

OK, just to reiterate my above idea on renaming folio_split_supported().
Are you OK with renaming it to folio_split_check(), so that returning -EBUS=
Y
and -EINVAL looks more reasonable? The benefit is that we no longer need
to worry about we need to always do folio->mapping check before
folio_split_supported(). (In addition, I would rename can_split_folio()
to folio_split_refcount_check() for clarification)


Best Regards,
Yan, Zi

