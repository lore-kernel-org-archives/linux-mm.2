Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C99ADCA0FEB
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 15:13:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 066596B0095; Tue, 26 Aug 2025 11:13:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00FFA6B00B6; Tue, 26 Aug 2025 11:13:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF26B6B00B9; Tue, 26 Aug 2025 11:13:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C70DA6B00B6
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 11:13:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 652C482F5D
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:13:41 +0000 (UTC)
X-FDA: 83819253042.09.37DDA3C
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2051.outbound.protection.outlook.com [40.107.223.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id CD050C000B
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:13:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XCtxg3ZP;
	spf=pass (imf22.hostedemail.com: domain of jgg@nvidia.com designates 40.107.223.51 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756221218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BuL+cvL2MDd9IlDTuU8Z384iTnIIgf4k1sQwqy3ueck=;
	b=a5p3uqWrM0WCcGrfGz5cqdEpIWiw80gptZDPVqNvQcGG+CfdfHVNpi6IyIhgcrVNy6Bv7N
	u8lIUq6g8D44dUqHUuWua3OzogxgUeAeHe7E1LTk+SQd+Z+SMlLJyBdEnkH16I2QEylxAH
	I7+2dBSrqG7x5DXoluANdkm4+DfdlZo=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XCtxg3ZP;
	spf=pass (imf22.hostedemail.com: domain of jgg@nvidia.com designates 40.107.223.51 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756221218; a=rsa-sha256;
	cv=pass;
	b=uO02ClpHhmImBAMNaR/4/AXLQkCA1jQ8NYvQfZTZ0iR+bDZp3x10jv1NyVNGo6uE9XdOJs
	emlpyW9Sbp7THNzDln0VIZGLo7BQKG3jbcIOIFh+lNT0LLhytwb6LKSE4/sxlU6+nApCdc
	BiE0IBEC7p20avFqCNFMF+sa+oeq7DY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CcTM2c8lXITK8Dx7JWN6KZfqHAj2Nl6u1M7qumOZ0ws+uC3bAeQunFlQ/2e6iAieAGwt6mCQhx5j9xGGbqsueLRLoXZ4C9HVtRMCt9dSyJIxvGIxBiEnVMXFzT+1d65h4dEQsgfLmTdLDbwyOq6lhXBkBm5il1AtndpBPMDClBFG5/OSSLUQBqHlo58zJ4yqQcIAgdQNKszJSy73kERqPwrjx8IAF5RHcHlgbGbOqZHcZ/w4BGPuTCnjJY7dQQr6+7H33f3AsvhUf5Dia3ecrY8so2bsPDKsf0+Zd+MaCVgyKGR9KoYK6pPWinkWTJyrNa/Mv9kWv+5MwpPRg66RRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BuL+cvL2MDd9IlDTuU8Z384iTnIIgf4k1sQwqy3ueck=;
 b=OLmtltKwubDO2SWswZQ0q64AQQMeqBrYtJZICycnwsSKTpap+TpItBkLy2ZDmcRw3x0tGyWal9vQgtj5BEFIRGZSO3BrypZnBFoaU5/4F8hAKbETtf/G9Cl7Aa9fbKmglWv4ShF2ueXMtXK+ovEQKcbZvTi+ZU61EcjDHegPICt8uMycqgcmgq7h7CNXVqcrkKy4pVT/KVhGGO+TsJSGBJAxg7RQojwqMoMokjPJ2R/Qagn+Ifndf3Pxlo4bQEfq6cjnc/k81tfSQXxnD55Jz/2sKYyLHt6TygE/9PvAqeEWvc4TIhDTxTi0ZFHwrXpBhiBBDis2Z3kwvnB+5/M7/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BuL+cvL2MDd9IlDTuU8Z384iTnIIgf4k1sQwqy3ueck=;
 b=XCtxg3ZPHNdQVPVOaYIzkd1IVcP+e93h8Pv7G0doKJSFYKPWcqdVu4HgHVxteLj//fFHewifuOoAOIHA+c88ikDJ9bGKoojhFD7k1QqOSFSkLTiN5HGoQA1hd1H08OPuROM2UnYI3V77gsKDnv0tsASMAfhZmshsSL2HZdRQpm//6zffYdNjyD+sz0z+uTM8mJCJpyl8+RNwAaXTL6ErajuvBn4jGChk0Ab711xB2yY30gqf49wuGkHQajHlOFpGw4gn4vFfaqig49J6fFBEmzhR9fZUX8A/awbykEEJi9HUQUfZNVzMIC+cOnUYrx0MtiG6zlKFlaQlNmQEgrm1Pg==
Received: from SA1PR12MB8641.namprd12.prod.outlook.com (2603:10b6:806:388::18)
 by DS5PPF8002542C7.namprd12.prod.outlook.com (2603:10b6:f:fc00::657) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Tue, 26 Aug
 2025 15:13:30 +0000
Received: from SA1PR12MB8641.namprd12.prod.outlook.com
 ([fe80::9a57:92fa:9455:5bc0]) by SA1PR12MB8641.namprd12.prod.outlook.com
 ([fe80::9a57:92fa:9455:5bc0%4]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 15:13:30 +0000
Date: Tue, 26 Aug 2025 12:13:27 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, jasonmiu@google.com,
	graf@amazon.com, changyuanl@google.com, rppt@kernel.org,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
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
	stuart.w.hayes@gmail.com, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com,
	witu@nvidia.com
Subject: Re: [PATCH v3 00/30] Live Update Orchestrator
Message-ID: <20250826151327.GA2130239@nvidia.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <mafs0ms7mxly1.fsf@kernel.org>
 <CA+CK2bBoLi9tYWHSFyDEHWd_cwvS_hR4q2HMmg-C+SJpQDNs=g@mail.gmail.com>
 <20250826142406.GE1970008@nvidia.com>
 <CA+CK2bBrCd8t_BUeE-sVPGjsJwmtk3mCSVhTMGbseTi_Wk+4yQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+CK2bBrCd8t_BUeE-sVPGjsJwmtk3mCSVhTMGbseTi_Wk+4yQ@mail.gmail.com>
X-ClientProxiedBy: SJ0PR05CA0013.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::18) To SA1PR12MB8641.namprd12.prod.outlook.com
 (2603:10b6:806:388::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR12MB8641:EE_|DS5PPF8002542C7:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f9bf4ef-26fa-4fdd-8156-08dde4b31d3a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uM9n7Tyr6W2x5ysgWXrMa4AeGFdVHQATY4w9+HHUdw5yVRVZ5kf3bbZj04qO?=
 =?us-ascii?Q?WENwcGV6P2xTYcqdx1pSg4c2lARJhNpIYl+FUbia/EbOgli3sdn/fETY6o9E?=
 =?us-ascii?Q?xu71ePciwhKaiQ4Fj7SJ2/qQ+eunO2EGFEtdVBl1Ruu/Arf3cD7qgdNE6Pzu?=
 =?us-ascii?Q?rFSEZ9Zc3ZaJUeuDSVsXEwLQ8TXuje//Xra0ec4JFrPuA3EdYcdlSwhaC8wv?=
 =?us-ascii?Q?N3AvZ4ZqHRu0uiTBuIw33aahi5J2P05NVPFcvztMbpgezxM80p85b43JmIn0?=
 =?us-ascii?Q?vJ4DZYUOJ9RKRuX95XE0DnNXvxufvqbFNA6lR99Qpp34i0i4s78C9CYsjTgw?=
 =?us-ascii?Q?/Tp8d7bHWTMetxr3QhUOzy+rDQu+h/tjyHY8dO1c1ny8e+ytMqBTdpjYm3pN?=
 =?us-ascii?Q?scBhGJAxo6hwM0YA/Wr5xbMPSqweTcaqkkMda558MVbxH3Tja89OFRKzMNqx?=
 =?us-ascii?Q?vgTbt3jd4b0jpYw/OKcOnH8ZWzM8vemUZym5hk9WfiqqGSv56kVGF9EXtD1/?=
 =?us-ascii?Q?NT5S2oyg6N3NZCUJhUgbzICyRQc4f8qs1+7jpjsnbdqJa5dSgQ4iwZ+pvMcF?=
 =?us-ascii?Q?gcN3ghpt9usPv8AHnr0orYMvcSWj4H3Ee36bbhECMUKFjlCZHzQPXKAEdUHj?=
 =?us-ascii?Q?CgaBePHnRBd07jCrC+7W9tgrq1GrdNdJs0cFRPKRJ7LF+ABfJCHuVnrRcSyD?=
 =?us-ascii?Q?3XU+1+aQskBr83qwjvi4YjkQDJaK/GorM32p+nfUzPjJW72N2kk4cW3zuJHH?=
 =?us-ascii?Q?AqG6nOHBEA98gHrf/9OSLNoyG9aialay840fghixmPHqHItBy8h5n9EO7Ipp?=
 =?us-ascii?Q?hLw8TRYj7TWWQj/aS8JQP+wqfcys+156ngn0NheO7xSDPV9KIIizqVc+w2x/?=
 =?us-ascii?Q?SAk1qyZ6frvxKPBRF/vxqN2L6h/wIhx9rWs4xBG5WRd+t8NXh2gUv42xr1sQ?=
 =?us-ascii?Q?WKG5rCUbnbsQKP1A/RYfQnDUIp42BFu8vjDsMjiSElkw0jU6U7zAIKduVOtl?=
 =?us-ascii?Q?gx6hd3xCZ2LaQ7u+A2gbqxrh2ZMMM55/J2dfM2m3lLq7WPX2R0tzupAFY9ZU?=
 =?us-ascii?Q?+OtmTMfsOcVC6B9JhypIMOmK1dE/W/Kb8dZrn2qfc+Z/9M5cK2czlQ8dCly0?=
 =?us-ascii?Q?b35psb4RMWHqugZqTA8oArfL59xZg9v+1eZA5VfYBR6/2lwhOrCHpynK3F9K?=
 =?us-ascii?Q?Uq9lUPxowYjLD+oVLk5SbvcuJRPzcByYg6wROmHiVXRNCG3ZPFlj6UVzpm4x?=
 =?us-ascii?Q?wsxqUR4+L+TVV2LEqRAXfb0mS8ost+tal5pfvsqaaucl6syDoo/jveCzkHCt?=
 =?us-ascii?Q?+GixfY9iOx/uhZCi725kF895cHIyJtPlK6TY49fG6NM+QJG6aLBb02X9/Qq9?=
 =?us-ascii?Q?IYAe/BXUtwFmHKzjjK4667YbCC6Bu7V3SJFBICm+VSzaW/A95Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB8641.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?g9Wqhfrf1wD5UIFc12C+WxRz+z69LtQF5C95Y1ecq0hiCt0vhXNZl0CQfWRJ?=
 =?us-ascii?Q?pOP9MEqGvSMKolDiU3Hbp/iVyQo9z+NRekVp62Q14VeidCoPrmzEU+lF9KzZ?=
 =?us-ascii?Q?vJpeYAiRh4GdRyvnaBIEdTqlKzW7wqddETK4MvNXzAQJHdNqNBWGnLfPaLNC?=
 =?us-ascii?Q?RyPeeamEiO6piYlyzRLRD+yvDBxYzBHNlg7HZlG/jaI6sSTXUscbFN5BIe6q?=
 =?us-ascii?Q?W+xOekoOxmH3hhjKO+/pLLhT7fxg4+7b2AOKavgbd58NBORYKrMJp2BwDC+K?=
 =?us-ascii?Q?3cQtaQe4HSMVi8nIx7lh0Cbj6Ot9qH8iCBdC4kFhYivUStAydATUniqDh04M?=
 =?us-ascii?Q?sHB0MkGhPgbm3BamFutaiBR+2bFtCfiWlgCKXYKn5aXvVTa4JOLiYCX5cvT7?=
 =?us-ascii?Q?dwO9WKpGyd81FHRXpClfhpv2mET480TRg4j7DZB5QCxJ7Gk1bLmMvlTKY8LG?=
 =?us-ascii?Q?YLFKO9tljqxxXSVZANlyI+/q+TKLk1JrRjLSlYrjXinJHTvSVVh//MvZN3VE?=
 =?us-ascii?Q?OZRCSjqqjY92RuRKGepUlDvMOb7JmyI+wl6OAK/g3MtNcoW0o2A8lFWecQZw?=
 =?us-ascii?Q?BQkmhfEGMClBHW6+t68uHc9NgDnAOABBg6t6DwNIsQudPA2iAdYIe6LFmFea?=
 =?us-ascii?Q?RN5E/x5l6gZHf8kIYDCHtWSwWewUhQxA7TI9/MHfLLlAy+72ngDXnZrTf8hc?=
 =?us-ascii?Q?Cug/69Ic4CACNiZRmjRHSCWwhUJQgnhWxueHr66BLa6mf6TQ6kWGWC2Fc4w7?=
 =?us-ascii?Q?i2DgSaemdawHoe3inx0apUFYfFP3a9mIfhaCogneLCkr0AO4iW4WHoDVHT+c?=
 =?us-ascii?Q?9j+A2zM9Fj2Fg1yJ+aDF5uH8hMK2ofUqUyZuYkEpMOtn0OL6rP3843cwSsgj?=
 =?us-ascii?Q?U1ibc2T50s7paDZsXurWyWYN8ok3by5isfyCQIgEgphHvfivqV6HjZS28WnW?=
 =?us-ascii?Q?ojon1iHla97MD10c5qEM0YWujBYnm1UMw9oESxP6SPgL5xQlgse0lUdl3JNC?=
 =?us-ascii?Q?KeU056yEuqUAPpqbBszymGd890h2JMsYfqV2KbCL7FgGXz6/eurY3QSjFSAZ?=
 =?us-ascii?Q?hhuf258mmRJxXW7Pm73/ZlnzpdbICr++8EPPbML93CoDKJ3O9kMTuuukCCRB?=
 =?us-ascii?Q?Psp8/pTkq+fz+9jRidHZStooxayyHS8G/S1BHUAyrrR+QrEfvqhUZkwVGStd?=
 =?us-ascii?Q?UXqO3A4j6pQyMJmkyb8t0r7dDpgoDJ/g9Y9AHxFeNEul9N2XL2z1mVvMEWUO?=
 =?us-ascii?Q?zkm6AMZp4kv4b28dY9Pz0IlaWIi5z4UTdPMmaNO/zUsLmusBWeBCdr9ydYoU?=
 =?us-ascii?Q?tW3f+npgr8xMaylD/rjICD6zWlgI8XcJKzWvgj1vCab7FXCVltn7326l/Uz+?=
 =?us-ascii?Q?C8mDKGRnATyACkw2/A/hJtXEmRZ3PaRmkb37NfKiw9vBFsDhjz2f5EJKaufw?=
 =?us-ascii?Q?OdqeJPz5ThFIMdZKhVqApRrjtZM/xYMUBZJBkmnsHENwL9Pvp9/cbV8G1npb?=
 =?us-ascii?Q?H/r0P7i8HZu1otcM5o+Ut47TTbhKXq1SgaVwwncubcj3oODuc9kAyU6KE6yy?=
 =?us-ascii?Q?njx3MkO792ZaNNx78g1JimKcDnnzHImUgrgUiD9R?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f9bf4ef-26fa-4fdd-8156-08dde4b31d3a
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB8641.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 15:13:30.0123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6rtLPIlxYDTN/mV32B8fO28jUUS01qKkjPGycPX9ziyHfFKxDxvCryPvYSTNDABb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF8002542C7
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CD050C000B
X-Stat-Signature: 6a7fq3pdy6ozehy39iq34g3ywdd8mhx4
X-Rspam-User: 
X-HE-Tag: 1756221218-215550
X-HE-Meta: U2FsdGVkX19tEyqZgaHCeVAD8G6HpOyFho9KbXp4tasMrp6v36bJbD+IvixZZOi7FVdIJGYQC1VLBYfEo2LxCyL8wILirCN1GbEfclh/RmvUoVLkX8+42bBbUzkodYFFk+xYwV7XPIob0QAFFKbXXB/+wYTsSHmbeoTNIThjrE0Wahj9EQ3J2abi4VPunhsPGbPclakMvDtBfiRaz8DfufijARBQnqHOS7A+QSsV/+uq7lS/rfffMcdOkA7Pbj4Zhh6wRbOFax9HZ8bzfwI7O2a6eMyWcp9S1QtJhG4qkPxgmLr7Z14Mc6ED9oGN4+yxEavXVW9NRoBxCzmyP2PT+AlqZqME70J9y5QQoi9Gqhzt6QOegtlAaOT+7T+MOy3s5vwHJ6+NrMLkHvaB6aW/SvIz64+9E+/pmrk0hVufIkH6jMRS2RyYSxnmIhpcpVMAgNzuK+t1jksUasbzGJRceMJlFJQL/vRPkezm77CKvXshIlGOmDR+nJzuD5ySPKFkmX8dvsnVf73198jbuFoXr/MW8HI2QjC1IIOAx97308GQLEjdX1ZqMHCEk3iZKLgYeBmWTyXl4VQQq1nLYbV13BP9pYVIQGe8NT52SK0m/zFNrotJLcBBtrFlG52Fk/oOkSYN56zB3696EHYEvQbT9ZnfoWnxDVzaXeUWNiFl/LHv1wtdo5kPrDW4/BUvs8n6TcwwNczxw16H2igbIHZvakPQ9k7Mv68HrvBuw+XErOQemu1NXWTeumbrqHihaor27hc9+t5NC4VxK630qTgrT67LCOnfbinCdD5Cat0yzuttS+sNkGB9+y03pZ2pLo3DEvlA0asrrSJt7m6IckBI7xRF+LLbrFdputgMyTG8UnHa/m1qlAhUrRy8FmaVVZgVfw6XDVrVDSjhA3QQbCaZvPJl6hTrtCRO9yrJxrd81snEBVwxkg6hRMH/ZmBVwRytpZbIKIJn22f4YXN6y8Y
 rM2k05wl
 rERZDKh9cvaylPDAf9ATqlk5iUgbMnJqM+L3I
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 03:02:13PM +0000, Pasha Tatashin wrote:
> I'm trying to understand the drawbacks of the PID-based approach.
> Could you elaborate on why passing a PID in the RESTORE_FD ioctl is
> not a good idea?

It will be a major invasive change all over the place in the kernel
to change things that assume current to do something else. We should
try to avoid this.

> In this flow, the client isn't providing an arbitrary PID; the trusted
> luod agent is providing the PID of a process it has an active
> connection with.

PIDs are wobbly thing, you can never really trust them unless they are
in a pidfd.

> The idea was to let luod handle the session/security story, and the
> kernel handle the core preservation mechanism. Adding sessions to the
> kernel, delegates the management and part of the security model into
> the kernel. I am not sure if it is necessary, what can be cleanly
> managed in userspace should stay in userspace.

session fds were an update imagined to allow the kernel to partition
things the session FD it self could be shared with other processes.

I think in the calls the idea was it was reasonable to start without
sessions fds at all, but in this case we shouldn't be mucking with
pids or current.

Since it seems that is important it should be addressed by issuing the
restore ioctl inside the correct process context, that is a much
easier thing to delegate to the kernel than trying to deal with
spoofing current/etc.

Jason

