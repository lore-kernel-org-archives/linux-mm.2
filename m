Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16B94CD5BAB
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 23:51:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 696306B0099; Thu, 21 May 2026 19:51:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 646776B009B; Thu, 21 May 2026 19:51:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5368C6B009D; Thu, 21 May 2026 19:51:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 439416B0099
	for <linux-mm@kvack.org>; Thu, 21 May 2026 19:51:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0C74D140484
	for <linux-mm@kvack.org>; Thu, 21 May 2026 23:51:03 +0000 (UTC)
X-FDA: 84793075206.09.8C917E0
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010052.outbound.protection.outlook.com [52.101.61.52])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3EE054000D
	for <linux-mm@kvack.org>; Thu, 21 May 2026 23:51:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QRn4LuoQ;
	spf=pass (imf07.hostedemail.com: domain of apopple@nvidia.com designates 52.101.61.52 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779407460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U5uhkaIBbCWGctWdWDWYOZQ2W4jkf4mQcfxoPNUQPoM=;
	b=5+3XbOJIboLYBuKboT1rVWYzgCFBjCdKyoV50VBq+udUtBfCu+h/Q6XBDYS+uAqVY3oJSI
	Nx1+wf2T9BQ2HG0oRsnzk6jBHJkMa72BNbkS+7W1a2ZXQ2MG+MB9j53V5RX5ocikjkAu+0
	klbaEww2oV12g29M9TqCwYX0J/N10i0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779407460; a=rsa-sha256;
	cv=fail;
	b=pzAfRYV64zueQsmKS2XK2HoRs8jRozZeNLKh8R3r90cjOLrob83E0cVieXX7dBi3FS/toW
	I55UpPSDUgia/SPUQN71T4snh2FdUx0ehH5dQPTKHbg/NYPUhnnRQIWogtq3gwB9M9PXRd
	NmwImtm6LaCcYFBSSXV0vF9RK/95MgQ=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QRn4LuoQ;
	spf=pass (imf07.hostedemail.com: domain of apopple@nvidia.com designates 52.101.61.52 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YL5s+1G5W9v6ufBcRe8rdBixMAfQ258m97tZpDlbMHS3l5l+TvCU/zCrFtbVZJtbPVqmZ3XgxxSRWUw0i3j5ORniIDqQrVZpU2wna4ETN0e6/XUl4yl3zFqyL+CrK5yLV0D7qxkH0feoibLFbHRtNdLth9+ir6EAgtSIfpZkhF5I5g1HiVgdNTLtsINY5iP3j7BSW5ghzZxlWRT3rI5yP8zjnAtLp7bUkf5eN4sSjo0xBKDO35hu/9ea9kH4TffcUQQW8u+LgLpCr8JZLJJ73SDdWHPLyurbNzO+Ghlh41lHpLKgVUo5tewStdMl2EZLLBaK6T0v06zG3ULE3sbomQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U5uhkaIBbCWGctWdWDWYOZQ2W4jkf4mQcfxoPNUQPoM=;
 b=G7gBoER+G+p1YA7SXLIl8vbSkZY44hz6ycLEN9Bi3RclBwFAO1w0/qeVCUyBz8P9UMrdYZHBPrcFIc6vxwHz59QvHSUOZmRJHGvNIKXumKEj0r3HtCZWOPcb3Cc15IcU7e9xYm84MCrI5dn6yd2YrPcOGoJpW6BpNjswbeEwudnRPAZD/cSjVWBMKmhoLy2ihQnYN/1dahC5JKYL6Gq+4Ax7l6il3lkNfvE2W1pH9z+mXCvknJS2G2YjCxzgJUySpKRE7a0pQrFBc8LStQKhYc8CajdyfuRpQ2I7oEyJJ7noAHDqlyN9H2+L/jLXw2f/guR5K6Jr2hQ3Ctayhz7KGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U5uhkaIBbCWGctWdWDWYOZQ2W4jkf4mQcfxoPNUQPoM=;
 b=QRn4LuoQeEafeSy0DDjgcbCX1E89B9lj5O3t6CXbj/lhhI3/9HvIP07hIv3RYmKtJmLQ+gc5MaU/UEynwMTX/pA08wsWfIqs6r22CGKTSF55i1j8aZj/BwywYpxJhoYbgvuHc7z2bERyCYl7bb+002eofdvC495kiIUhhzTVW9cwljct1p9HC8AIld06suhyCCkJRAT2BsDF9Epde9mNVXafMSOT98GES84BXl9Li11Yj0wz0JNmPJzke0XNh8a1bdGEjWFzeh00McpERA6IvnN4lxdu+gXAhFwV6RIIK0HLCkj/kH0V3eu4M3Qwb+rUrBtQ+cMtxftKZcrLqpp4Fw==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 LV8PR12MB9084.namprd12.prod.outlook.com (2603:10b6:408:18e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Thu, 21 May
 2026 23:50:53 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.21.0048.016; Thu, 21 May 2026
 23:50:53 +0000
Date: Fri, 22 May 2026 09:50:48 +1000
From: Alistair Popple <apopple@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, catalin.marinas@arm.com, will@kernel.org, david@kernel.org
Subject: Re: [PATCH] arm64: mm: call pagetable dtor when freeing hot-removed
 page tables
Message-ID: <ag-Z4rLdPSLat1Ho@nvdebian.thelocal>
References: <20260521032730.2104017-1-apopple@nvidia.com>
 <20260521153130.d7d5cd060f7522f894252333@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521153130.d7d5cd060f7522f894252333@linux-foundation.org>
X-ClientProxiedBy: SY6PR01CA0107.ausprd01.prod.outlook.com
 (2603:10c6:10:111::22) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|LV8PR12MB9084:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fb28d3c-b749-4428-67f8-08deb793cb87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|18002099003|56012099003|22082099003|11063799006|4143699003|6133799003;
X-Microsoft-Antispam-Message-Info:
	OwQ/6JVMiI1jK3wluyPWjxxSDRUsM2qAN7IGmE1P7gX2Bj/1z4oebjA2mJMs0c20gv4RS9ZW+2gvYkQscYeQVBsfPusOHYj93LHdzMkJj7znWiGp5qpUDXDgGesFXLRYzq1QvqZqIkbFJaHMk1tqOENCGmeDD5I7WkQx5kHi/bij0qrVA1f3FuOy/qKpKLCdxcwvENQkld/FHmSB+WDjlsMOvkX9Md5YXm5NDzUNU9Nwk1siseS8QYp8X64zGDJBLI10UYuEXlGpW5eB08n5AfZabzyyjLz5dAYptILmQCMl05juUaafwykSlTqHYzzEQ0kQnMvlnpYjDkMLsGgoiOTYC0YBlnIIHu/uCXkvQCfIwaBrDpvCzOK3zFuXPvUeMC8mZubI8GsO4tARkQUZc72vF3OfxwOr5PIpkIX5W0+DCaFrTS0XAb/MnmsSGB80H85PHKJG2ViA5bqj+WYy0nVAlxVEQrfBbzXXRInkP3swvCHeTrZhZqUyCdnpquyNUSq28DTPdKEMCDdoGEO6VObzhuQISrCeDqL+DY7Dgc7K/vUdusqVONsmYJl5BGFmxD6KnwPxPy5kqQEv7dUSRpMqpnw6LvgGl0o8AQ1ihmMFWcK/VhH1OgzhyhtCivhBHZB0fOZA4CNHQxLwnQO5FWAb0fxjQi83xA1NBdEr0FfMtUIUDyvNc+uUp4mzRIiY
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(18002099003)(56012099003)(22082099003)(11063799006)(4143699003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3/PP/tBFIQenDrkL5+f0kDhk+9uq3drdDZD2i8ql665Fv64Ts9Nb2sBstwU4?=
 =?us-ascii?Q?0o8JbNZQMhUlymFR5iJMrFgXp/Gzj5Kc/SThp7XPAmIoZZ7MlsBZeSFrk6Ft?=
 =?us-ascii?Q?a/xKgmY9HuaIKBY8qD6l+x/x5pDjA3TOTP8vshG5QXMLoup7XLlWnbBbrt5+?=
 =?us-ascii?Q?jR+rkgTphorO4OkFEuQSLZDvUM49z/easKQU2M+nQVOZtv0DHazoT0TK4zY7?=
 =?us-ascii?Q?3qrIhWXflpk5LxL/H6xMRM/9vGuyXUPnh3QO86JLrFysHLPzn5Fo10t5rYa1?=
 =?us-ascii?Q?AU0OOpuOwJ7Binfh6x4NdyiWaIMMJNtDa2DWtG5NFku/zCcTINsE2Yz5NLt7?=
 =?us-ascii?Q?GJtTBCZee9JZTGIxSucjPN7LUGrZkXUWQJnRI1y8HWj5PkSLXQExXzzWX0xU?=
 =?us-ascii?Q?Js+C3g0Vi0748mKRgnsESw4SceRk7Ua9nTCAZ0MzGOL7Lx82t1vJo3BSDqKW?=
 =?us-ascii?Q?y6VO8NMLl1XSHyCNdF7oMHmIc3ZRXFdPA1uNWZzVkRbNwk+6DDLCIQ0umEl8?=
 =?us-ascii?Q?DlimtRgpgvsTIIDKfyPgolWhIO5WdotGK6c/oh+lZgCgVoa9p7uXrSatNArJ?=
 =?us-ascii?Q?zgRM0Yr0yVhInq5uISDRylpMUtPE4qrbqlfpaTEPJcGwWVkZO3sRjs+tog40?=
 =?us-ascii?Q?E1XR1WAEoOwiWNV+tLD/W/ywY9sNWon3YYAlBE4aHH3yFbfIGRYhMRNW6E1y?=
 =?us-ascii?Q?jNdFkqOZI3+KJi1ExE9buZE915WS+gha/uUDIloyGz9XFS+/BzNFOEsZUW7L?=
 =?us-ascii?Q?jRhzuoUNGrk9UrixpvXW099lDW9z3jGesPA2nk1od/9L3BHWCciqvuF+XdTP?=
 =?us-ascii?Q?kxaWEJUthTn2//S+PkCU81nNeTFjDvBhMsgUOdhrFtgHSV6UY1yzKq94Nu0u?=
 =?us-ascii?Q?vJ2ldHzGNmSSR3ugPOQgOq65SGIzFuVYQilC9sNg05FsgmNzODWbVYpA5nTc?=
 =?us-ascii?Q?xC7iKHHGVoMqqVQM+KUK86+bxSEGgrtgLSSGyCM/zj5P231pleozHD0ltPZB?=
 =?us-ascii?Q?k3LEAP1LI3s5nHKY4uJ5wKkcE4FOwaYM16jXhG02Va1+ZxuX+EI/RpHXn5r4?=
 =?us-ascii?Q?7TyjRI+IEo8WdgtMSKYgxvFTVfKYbzAoCAnEn3bW28/lfEShz2+fFvb2CIOz?=
 =?us-ascii?Q?SSIB0UBHg7S9Qrve+mGgtJZt3eribf0w34WL0u8zLLPUk4qlk1cjA6zmp2Ru?=
 =?us-ascii?Q?67jBTi/1sn1EYCUfolT/2Y+SWbGVyTf1Ot8cBFpC5YXU0YYyZxTgrmJKbNo6?=
 =?us-ascii?Q?6D19fLtK5Yz6v7naBSm8lrSrtWpGPAI20cZpihbV+gDic2Sm0gjXTH8+BSa1?=
 =?us-ascii?Q?HkTsrH2rD2HtfFQUW77sIAtXGHaboWEqPMPDAcucPkCFYccX8JW+5TTVATzO?=
 =?us-ascii?Q?t8yM4Wvv5SReXgtrxgcwoZjBL2czbUUpVkXAYBG1OJc25++5O3RDt1uJ88db?=
 =?us-ascii?Q?CoiaiEmPzNgrViDivxrKNME+OGiwcIMBscW9UsVy4PiMcX/KhSRhQROFPZVB?=
 =?us-ascii?Q?Or0o3xKL33FA1CaFiDPxodTiCr964DCGShEbAVTYCHFxnu0FRKnyevQC5xEx?=
 =?us-ascii?Q?Gsu60t76rHJJ3xs4b1LtE1qY6nyNqjg0epeJhm36HJ9JxDQizRjtERriUGDX?=
 =?us-ascii?Q?Vsl/WtkiTd9c05Sa0qbJ84uGO4bEyZ2syH2L/cVsADvUTcD5nI5jLDv+kLc4?=
 =?us-ascii?Q?1BZ+v7ENl5E4Dm54RW7bs7kyxpwo4GqfXA6IAIH9oFVUbF1OXQ/QwIk6oR15?=
 =?us-ascii?Q?xWLV3k0wDA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fb28d3c-b749-4428-67f8-08deb793cb87
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 23:50:53.7299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bj79hYj6ik5devYI4hiPU7YxnwXt5dzZoRi9gOBpQJvQVIwMb4Q/0q9BLyxBqotQaBhc0nRTojj5GqqCokoTxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9084
X-Rspam-User: 
X-Rspamd-Queue-Id: 3EE054000D
X-Stat-Signature: 7grpbtjhea53fejg7g3rwu3ejhcggkhq
X-Rspamd-Server: rspam06
X-HE-Tag: 1779407460-498384
X-HE-Meta: U2FsdGVkX19Hdjk1GWx/zffuwO5cJxTHaBPeywKsmi6DzKC0F46egV0yE/BUXp+ys+/1ZI99nHjtSpB9/aU7XcWVu1AJfq+CxQnFBltu9ueTDtTCqW6vCXCwtCbdv0SNQ07bXiRek9Lj2Fj75aUfN29MGmwavUBdvz89ug6GBsAdafDAdcH2EwAxX78fqdkPjvwlMca0cAJuCEeEHXCeuHKF21OVJC4f9OF1SimcSMx4A4Yvgw7ev/jox84OXaFgO0MuFSRQdGZShIyfBmxBPkocHJ4C1ZJq9ELpbUFY9/AbSt1omoAyjBIePc4iXOefz3CsUaDgfuWeG5GzXZXWB9QexD09yUvWB5TJ5ZPaU+vKr+ZBw2p4n906y0zO6m12wFXN6KHOj6zRQUy2MlfS/5i625uASld73292CEDzA4QU4QWQCwageR4VXURi8b4UN4DUOhcx1mH31nKNx8qe5eh2sNUIGXsD4UW+6T+NwYVOv4ht+WJxHj9FdgLWScNnv7H4O1IGAS8gsE3pLZIFSnlz6nomvDfFOCSVSyDamRhOKUlY7l1duHzQKZc687IKnlpjJ60EPiZIrYQwa8w8uvu91zDimew9gj+I7nutrAh0urwg+AogZHD3DDUV0/FsJmWCVxpRkIxvuh9/eWv3Q8RQL9YsMis/Ev1Bit52RPsyQr+xFkFyeUpCkx+5xXaAWrzaXAnjN3oVspHVvuImZPBbnlFLldC/atENidHbmqMybOhGQSFwYh/fwksam1qvB2FJwTcTOYsETbJLu4Q9bt3gt/Nyw9mbFvNDJjW7BMiNbnT/SM5dT7uygTA8FqKzvxVa//syb3nXB+NbGdTb/04uYmXql/dDLor86Krf0KVFmXjUmkuUVDCtLZpJBIM3I4mQ37JH+/t/6J64BSmz5u7rHta/97Ylhpruo0Un5DlDK+XhMYINvKl8tvSapFYomi3+YJTt7C9MnrJF+MQ
 V9FvrIYG
 rMo/7nMQX9J9pJg1j1IHaRtBO+XqUh8ptG+mioKrlGTuh38nDNV0n4vtljaHt7SyZe7I/1o5YeaySVHjqubFzLfBT8k8whzk9FE54KedGfXvMwGivRlHlfaVAJdsyTX3mQgH/V898OBeC9sYH2J35s9Yc9JsClX0XNEyncAPRcDXMthHQ6CiZUjxXsuLR4o/3Yq3m9DjJva4Hqne/BXpBYPgP6MR2fxDWcAAEKsxZi16QkMjELadxSC+KU1ICvv9MuJojUSLPmmzscN68L8dnNRFfnHpELFofZ9cp4Q83S2rpIhMKmBgvGNy+lI0zxYSIIjPITUpexaWBh5mBMIiglDgiTs+ZSLEoPci/4yIRrXnI11JtXZt8g/AZE1X4qHHulPcrzNAbaWTNaGzBCy5WEEWRGs+MfqK/BReo9PAc2+stCwH6jHg54hfQGZr7I7gQXP+MzFKYLW71kxXO1e3c8/OcpQCQLcgldOZL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-22 at 08:31 +1000, Andrew Morton <akpm@linux-foundation.org> wrote...
> On Thu, 21 May 2026 13:27:30 +1000 Alistair Popple <apopple@nvidia.com> wrote:
> 
> > Since 5e8eb9aeeda3 ("arm64: mm: always call PTE/PMD ctor in
> > __create_pgd_mapping()") page-table allocation on ARM64 always
> > calls pagetable_{pte,pmd,pud,p4d}_ctor(). This sets the page_type
> > to PGTY_table, increments NR_PAGETABLE and possible allocates a PTL.
> > However the matching pagetable_dtor() calls were never added.
> > 
> > With DEBUG_VM enabled on kernel versions prior to v6.17 without
> > 2dfcd1608f3a9 ("mm/page_alloc: let page freeing clear any set page
> > type") this leads to the following warning when freeing these pages due
> > to page->page_type sharing page->_mapcount:
> > 
> >   BUG: Bad page state in process ... pfn:284fbb
> >   page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x284fbb
> >   flags: 0x17fffc000000000(node=0|zone=2|lastcpupid=0x1ffff)
> >   page_type: f2(table)
> >   page dumped because: nonzero mapcount
> >   Call trace:
> >    bad_page+0x13c/0x160
> >    __free_frozen_pages+0x6cc/0x860
> >    ___free_pages+0xf4/0x180
> >    free_pages+0x54/0x80
> >    free_hotplug_page_range.part.0+0x58/0x90
> >    free_empty_tables+0x438/0x500
> >    __remove_pgd_mapping.constprop.0+0x60/0xa8
> >    arch_remove_memory+0x48/0x80
> >    try_remove_memory+0x158/0x1d8
> >    offline_and_remove_memory+0x138/0x180
> > 
> > It can also lead to leaking the ptl allocation if ALLOC_SPLIT_PTLOCKS
> > is defined and incorrect NR_PAGETABLE stats. Fix this by calling
> > pagetable_dtor() in free_hotplug_pgtable_page() prior to freeing the
> > page to undo the effects of calling pagetable_*_ctor().
> > 
> > Fixes: 5e8eb9aeeda3 ("arm64: mm: always call PTE/PMD ctor in __create_pgd_mapping()")
> 
> 6.16+, so I assume we want cc:stable here.

Yes indeed. Sorry I forgot to do that but I can see you added it so thanks for
that.

 - Alistair

> >  arch/arm64/mm/mmu.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> > index 8e1d80a7033e..0c24fe650e95 100644
> > --- a/arch/arm64/mm/mmu.c
> > +++ b/arch/arm64/mm/mmu.c
> > @@ -1422,6 +1422,7 @@ static void free_hotplug_page_range(struct page *page, size_t size,
> >  
> >  static void free_hotplug_pgtable_page(struct page *page)
> >  {
> > +	pagetable_dtor(page_ptdesc(page));
> >  	free_hotplug_page_range(page, PAGE_SIZE, NULL);
> >  }
> 
> I'd of course prefer that arm maintainers handle this.  But
> 5e8eb9aeeda3 came via myself so convention kinda-dictates that I get to
> fix it.
> 

