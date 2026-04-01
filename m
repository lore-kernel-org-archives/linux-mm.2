Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 504F4107639C
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 19:21:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 926E86B0093; Wed,  1 Apr 2026 15:21:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D7D16B0096; Wed,  1 Apr 2026 15:21:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79EE46B0098; Wed,  1 Apr 2026 15:21:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 67CF16B0093
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:21:22 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 105A8E03AA
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 19:21:22 +0000 (UTC)
X-FDA: 84610955604.29.EBA2A30
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012065.outbound.protection.outlook.com [40.107.200.65])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3236D40014
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 19:21:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IjrXSunC;
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775071279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AySzku+xt5/zNZTjs6vJquwA23ZpdC604HkIRblMbRw=;
	b=147OtrDFt8Qr57I/riRy8tfc414NT+RhOXNfxVDtEQW8/JgdrPMQ+lTuZ8jUZZ0S2q4eOd
	p+iPqfhiHHFBQpEbjweVLVLSFHH7s0ePa+b9fyf8uZSUQ0zaVE9WqYCIX/P6aJFn3LvtYL
	CmXFexdIpYDlJe/TX0bOhJ/+quA6Iq4=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IjrXSunC;
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775071279; a=rsa-sha256;
	cv=pass;
	b=gT0CpgkDWHY7Npu6Jqz2BzEgoW9TRpURCahckElFYVAYkDuTzJp8U1xdgQeyb0Iv+EHh9J
	qE+CXy1BikkBrkjgIBWi77/BhmwQSLA7SofLjX79PF4lx7tDxeLPnLJukkmcQprXvA5pTa
	sDpDBnDa0BLEtX6n02S/R6lphGWlYIw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A2AKJoZiiVKwIo5oN3lwWfmp8A4GA4Kw0VEc87n79FkUML25r06LwNeDrveFv2eRu9YT9PZB5+R0njS5U4GkL2xJNYT4k5MfUIeltjim4H46FutAA6SZ1xMYQVBEdgXlUDyDgDz21l2m8rmFfuofLL0a6X1yRa+SY3kD+fAPjoIsXqqnDwn0Qp6agM1Aet9DoxwpgZmjH4eRT7Kx9remNQesk0o0faVt//EzSk+oc4uI5XUvpqhAuMcv7d/xOht+9BWEDYxfVUDFD8urmzr//2DkYy/NbYV9zgXKAY8S5sHNWn4MfRKkhUAbgGYezaLDOU9Jbc3Hg3YeXpK8rBgZZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AySzku+xt5/zNZTjs6vJquwA23ZpdC604HkIRblMbRw=;
 b=XrAG/9IA9uaPGPxR/Mxbia03GBak2FA4fnoukDk3cxb3Un6YLQmLdGXzKqnGmZbhAwCgUL6y0EPhMIzhlZUoLKd8TLuTZU/fTTtFm9FwrKlp6jhHGw8sbq9dSASvKlzfhftCMWWf3Uv5ppUr+89S5lPxcJt3YV9nHCbjy3LRC0x/0ePrdn3zN/zMpAPAKbsvGcIs6RPOvDCsq6KZyxiWNFwpbwq9veIjPWphrhj7k34xB3KHsnSdr4N9USTXd1va6GKdM5QJtEfQZo9IVIaoDdY93qWEYWeUtM8E051skF4ObxoLoMQLkTbdVtmLHD9O0RskFZCa910qtW0g4j0TMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AySzku+xt5/zNZTjs6vJquwA23ZpdC604HkIRblMbRw=;
 b=IjrXSunCOhxfQpOOyHTyI5u9Kj1weWr+V121iLeKZs09YmKnsGGQMXD6eMK+2rBaMLrwth/FckV1REEpuFL9cKIabZImMxPjImj8b2vlQ/a425HELfUz1AeVHDEvSFASOFm+lZIMbnBf4lfiuBOrxojg/U6uXLBcxilW0dVzOO6T5TOVdA3ccOeHkTYKoI3z0/OgJ8EIb+J6NAs2D11ZwN+wmj7MD03KvEFrsMnrhLYQGje9tMluQCBWh15UAiiIPKm8F5UjrGtJHpF5pj56QIPqbDh5IgWiuinyY8X7D7XlgKXSbTWEDtVwa2nE+JRTZ+zQ2hTkupv8K1Wp9JsKtA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB7426.namprd12.prod.outlook.com (2603:10b6:510:201::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.14; Wed, 1 Apr
 2026 19:21:14 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.014; Wed, 1 Apr 2026
 19:21:13 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, richard.weiyang@gmail.com, usama.arif@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kartikey406@gmail.com,
 syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com, stable@vger.kernel.org
Subject: Re: [PATCH mm-unstable 1/1] mm: fix deferred split queue races during
 migration
Date: Wed, 01 Apr 2026 15:21:10 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <C4A8301D-C76B-430B-A6A6-8B642B80FE2E@nvidia.com>
In-Reply-To: <20260401131032.13011-1-lance.yang@linux.dev>
References: <20260401131032.13011-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0062.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::7) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB7426:EE_
X-MS-Office365-Filtering-Correlation-Id: 46f57cd3-7468-4ba0-14f0-08de9023d6eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	xVxlGVZxux2CrBVEKJi4m3jUXekXjyzA9LHdpf8YdBtn781FfhMhFggWR/PZKyO1rxqeiQhso8SMpa/cIZ9iyH3uxBKhmst0Ptbh4NH0G5nWZ+LjQea0v9XHgFEZIqX7Ik8t0J9rwHdWC4GgS1G+HyvByh75dj9XU36oNS0wfCJZhtYwhLpU2doK8DzUxmS9/NBeIuJmuE4KvUeocKktWjDAK66yhFbdJF+MRQSrTRBfxl3G6VnnnnrFh8FIYjmy2QhNt4UGodfaCRsWCo2jwmdMYgn5pS0EJmJpw87EIMIg6vyj1JL+Ao+PJo+M0V5VTqAWcE701ycROuVoYzDLgCx12tM+JADnose9RJwZaSyYAhp5lHJfklNeS/g/xC2D9k7ETmhQ2t9eawA/nU/339M8D+1u2DWdqUKUiFYhYIQGZH64OzPfCaAu+4c7BoY7BWU/56uXPCm3uAj2pC9QQp4b/7RAdN5KxntuSzKYWUsPdzcuGqBq0r+AdVmpyvA1g2MC87kSfYQP9fv6DgrbuuPjzs3x7Hx5bYCjc2SZkyYhpezWxk9QYEGsCQ0/36QdnYSIpzYqnBGegzPsXnMRgPGMH01Jb1Vn84T8RnsN09BeyRmWDVSupRzxFJ5a6Pz2eGhBUZscUww67HFjiz8VhIjtq2LTqX4blFE08Q5mf/QT7VygclrUL5aRCNp0JyzntOXNGQn3wF/PAbZsfs6kjg/wlxkADPuwla5PPTaXOGk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MjU1ajNJeUZmM1NqYTFvOTVSNzVyOHJxSlZXT0JlVUhvaEtUNUZUaTRCK05H?=
 =?utf-8?B?SjVOeW9SVEd6N3dIc0U5b2FmOEJ6MnY3OHluUUxnZm1nNGhITk94MU11OEZE?=
 =?utf-8?B?UTh3cHpzMUN0QlB5V050cGVpczc1b0w3dWNYUDN3eCtTWlpPd1dKS0JKRk53?=
 =?utf-8?B?eVdaWExWSVg5WFphZUoyWklTbW9acjdweDFTSDJzTHNaSVdJUmFOR1R3eGQz?=
 =?utf-8?B?eENRL1UydHB0NG80OWpqMW4vcXNFalgxZ3pZN053Rk5DYkVHaDJwRFdZVE84?=
 =?utf-8?B?SUJwWC96YzFPMTg3QTBuVnBEU25nOENYNkJFZjEyNzQ4L0ZFbVRocElMME9p?=
 =?utf-8?B?YVIrRW92ZUZObFhvU2NNK09XM1p0bmRQWmZDS0tkMlJwOCtvbzlFVUJueFoz?=
 =?utf-8?B?a29RZGltajRRdzBYZG1uQlNxeVJKU3Y0dUwxWlpESzZ4TWNCMXJ1by9SQXZq?=
 =?utf-8?B?ZHNmVmZZVUZ6a21TRTBqVjdVUGMzZXBjOGphallFT3EySWpaTG5ENlVnNnRp?=
 =?utf-8?B?dmdndWs5Sk56WWNWRk5IalV4K2gzMFJkQ3FxYUFXN1NGTFNLTlhXUzRkS1hV?=
 =?utf-8?B?ZlJOS2J2NlVtRmJybFdpOUtJKyt2MTRTMjlZeis5TDlheTEwVTZIQVY2L3pY?=
 =?utf-8?B?NlIzRmdRNVllUXZjVTkvMjR3NElVRy9WbU5FOXAwVjJ6dTQyUzRmOVlFNGx3?=
 =?utf-8?B?OVlaQ1JlTUo3ZzdXeUpwdkNHU2ZxUGpFMUI5alFGdXFscU1SOEEyaklFM01I?=
 =?utf-8?B?Nm93eGRNMkppMUpkd3pFaG9kb0ZvYThja2VYTk80a3FoVDBpS01tRmlzM0FE?=
 =?utf-8?B?WStnNGJrSlluUXZyYWZZeUo5ZVNQM0x4VHIxMzQzcmoydFU4N0hwVWdGS0ZG?=
 =?utf-8?B?MFBhaHZ4eWlhTldJRWdvMGE1dHpSckhqaGNFVUxQaFYxV2pFMDRUVjdoVng0?=
 =?utf-8?B?V2xsbkZpbHRxc3QwTXI2ZEdBejNEd1BVUzcvVFVkOGY5MkNrVWpIcUY1V2NP?=
 =?utf-8?B?Ly9PWGlOaVhNQmV5NDVqbzVrNHZQVUpQMWJ3OWtHZy9xRkg5c3VhRWxlcUJL?=
 =?utf-8?B?c2lNM0FsSkd0UVRaVHhNWFZad2JNcHgvM2pYZ1JqbE9pYmdYNVhRM1FDUWhD?=
 =?utf-8?B?cDNzc0RiaWdnQy9QQ25GTXA4b2RoVElXWlNnTWhkZUVXQW44bEQ4YmpKTXdx?=
 =?utf-8?B?aUM1cm1id0hZeFpUT2N0TFI1N05KQ1VoZGtuMERiUHhEZUsrakxzYVlPekNZ?=
 =?utf-8?B?em1QcWR4M2h6L050NXFmcVhwQlhpbjRzUy8rVEc4VFh3RFJMMFN2SmRwdmw2?=
 =?utf-8?B?L1Z1SHBidDRSeDFRdmplVk9uUThGYjFPRk91bVpMUFM1MUIyUkpZTFFEUzAw?=
 =?utf-8?B?VWtWOWlhanFjSGtwTndqSkZBOURWU2lFWVJ3dndHNFkzdW5udjg2cFFlYzNs?=
 =?utf-8?B?N0xUUXhDUXArdllEeWNMTFE5dS9hQUwzQTdJMTR3aE5admgwSzUwd08zb01F?=
 =?utf-8?B?a0djenNzUFZTbmcwN3VYelFlNVhMQjBEaWNMYjlMVlBwQVZpK0kzcWs2VlAv?=
 =?utf-8?B?THRmV3V4bU5vaUtQejhrenpxVUFGcGhJcTh0anJsbTZaVGxmUHQwSEpXS2xn?=
 =?utf-8?B?MXRvMHErRVVFSExFSE9WUE5MR2ordXNPMmk3SGdFZWMrYmZqRlRZOGw4dGZk?=
 =?utf-8?B?TWQxQzR1aHJNNVdNTzdkMHVJS095RHJiV00wd3lDQmt5VUlrNHhidkk5MWYx?=
 =?utf-8?B?NHZmQmlBbzRoYVlJanlMblNIYm5VdmtMWTQ4clk3WEYxWXlWK0ZoQnU3cHdq?=
 =?utf-8?B?MDZmSFNHemNXODlFVzlkdXlkTmUyajNpeXFQVStDaFlRZWNuK1J2OEZTNEpW?=
 =?utf-8?B?OEkvMExadGFzSXNmL01QUEkwTmc2WWVrdUpFcldXOHR0QnUrQ2J1eGg5VmNn?=
 =?utf-8?B?bDN5cWhVakNSWjRPWkpieTJ5MGoycDBrRW9GNEErS3FCTmpJMU96SUI1SVN4?=
 =?utf-8?B?R0JtMFFLaEE0VjhPa0MvUUlpMU00MXp2ZWNnT0RkZmtmZWhQSjUxUHhhN3c1?=
 =?utf-8?B?N0xUQUg1VHpQeXBTM2ZJNG9qc0lsWmJyUGsyMzdZSThRSHRBektEQnJLa0xu?=
 =?utf-8?B?djlyTmxieFM4ZGFteEtpS0xqeFI0UDA2YmgxY2J4L2xndnlXRUJicEFFZjF5?=
 =?utf-8?B?ZGFFQ1FmKzd1N0dGZ1ZqbGhuMjJJY25ocndRTEp5RkpQaDVKWEdyZlhvbUxL?=
 =?utf-8?B?aDQwSTdpYUdFWjV6SzZvLzFqNldCdXhyUDF0elVmek5UZGFOak1YWkp6MXp3?=
 =?utf-8?Q?/TMMCJo7IEAqXi9a2e?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46f57cd3-7468-4ba0-14f0-08de9023d6eb
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 19:21:13.8697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qomdTmiilO/YRl1Wyy1Lboj3uTxoHgvZoXyuUTTrMVurpv86PABPtBFtSL3iwuP3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7426
X-Rspam-User: 
X-Rspamd-Queue-Id: 3236D40014
X-Stat-Signature: tzox155gzojrh9eb39e86wp5jh6uwkzo
X-Rspamd-Server: rspam06
X-HE-Tag: 1775071278-107153
X-HE-Meta: U2FsdGVkX19ZRJnIdhdn8iKfm2KDugDpbW4Ez1sgS91sVOd/UHdSNne6QFxwvoSJAfTJLgyVXh8EkpPzyBkcE2b2O7xuSbSG7Kjw0pZbvfkBdvAXV8g6R8RWUMzMXt1QBheMay5vhVsfwp0v7zGzznNdz/ZTVu+5t8wHlMs5JB8/xkDJXIuRBc/7lqVDNU7o9VWpLGtkXAukHhU7t42XOXMRNY0jj2QG0H4x9HPP0aUp/IhBf6Nf12kJ/lcH7fw3RSDnQc2Ajd8ca0ylxtYhxdd8vBwUEPwbzsbedRsTzQZPUAMCC+lZm6YNxgQIt0YHOPbxHzjrdw0pi/csQL34I3dAqqZilMYSaujNjJ1Xwuw3orqtyW3lqHbE9hU6fva5Sgj1Dzvd9EHcCGQvjHt6JVkbEF99GXnmWrg3SxyVSvX43OXNGptFUNaHgPGFuG/xd/iU181lr7XEJyqHuMgSATmapAEZKs5nwKnAagSdfiw7tfb67befQgVfDvggyPc1/ygFH/xzPgirE4P9PmD/BcCph8qvnEZYWjJOCC8dG3ucHFeq2z4eTv1glvka/FowyB+azZbCPlRQIMXU+i/9YkgVKZZ9GzsL0upCKQxTTKdaRb3zw8Dz5DjxRi6vDe1qf+eRjusFBzOeLxkIVF6z4ZhDQsBBdTUoHp/nSpI5lthdZ52SnbIrZIiskb3n3AAcwrRbki/hV1ftb0S9NMxyIAgH7++NwpcqTrzn4pWm6UInqRSDG6a3/KbArikkAqWXZePgSuy5Vm1ftmIhpavS0KkfCpNrci70Ez7m6xoP2ZjxQ0/IhbHqIkw2QCvbqvJbpdTGUhJqEV5+BSJMv1v/L1jEUF0otTvX9jvbhi1btmaLUnWoCGVx9hCo+HpmwgH9uMnoMKbqPB2FF1XeUee0LQoaX80qgMNpqS4vewPxihiZ19vxV5mleraG6fW9cuhiWl7q/UryLMoqKpe2Iik
 ZBwXCd5d
 0idPW4+Bs1RgL+bhzHL1GCrxSv83EoWsmzdh1X50PBAa6auF6iamUczRPguAFVje+SzBTfCOXLLUpnB1A+0xILbV8Fh1QIjxXKWAj0SdlsaVasvqQGwBy3WBT3WGlGj+1bCg2HnOnLgt9fKpgN1BnJYW/YHx906TyGOkjQORxt0wPeuCRjtTVeB2nyI1tSNf1kwv8DfqMYvn9GBxHxSw9dRiIAUuIZ8/cTIHHh+2u2Ge4YplqF5VsK1GcJASRKH2IbXEYvFSMpxLrl4ITaugR5NMXRDZK5yTuvPp0DLwptmk8EMxfwWCT900uKHZVxE6B3tghBhCv4pPgOOJURHW3ktmAQodfvk6EARePNGm7NKKnJMBGS5HF9EGGCifgoTl4sQESI8Ftdm84YANdo/kSKS1tv6gsUrfs/RzFV/DGoNUqX1K3Tto+/Q94SFv3wYimXPtzADX4pKsfXLIH3dkRuG5/Rc0OPpjtND6qcRs0OGg/0pm6WK3fSp7cTtxevrLD6h1jvtH3VTQ1RhyBbAckxG2gVqfRNK/lmaqOrpxAhpJTAgNAnN28YwLZayrD53QGViDlcRXIAAMSMCz325uXa98zuLU0lePQThiidyLhNsoCYktAdDybFPCUCOVp6hg4dK0oRMBJTEvgP11NLcL1YBpWcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1 Apr 2026, at 9:10, Lance Yang wrote:

> From: Lance Yang <lance.yang@linux.dev>
>
> migrate_folio_move() records the deferred split queue state from src and
> replays it on dst. Replaying it after remove_migration_ptes(src, dst, 0)
> makes dst visible before it is requeued, so a concurrent rmap-removal pat=
h
> can mark dst partially mapped and trip the WARN in deferred_split_folio()=
.
>
> Move the requeue before remove_migration_ptes() so dst is back on the
> deferred split queue before it becomes visible again.
>
> Because migration still holds dst locked at that point, teach
> deferred_split_scan() to requeue a folio when folio_trylock() fails.
> Otherwise a fully mapped underused folio can be dequeued by the shrinker
> and silently lost from split_queue.
>
> Link: https://syzkaller.appspot.com/bug?extid=3Da7067a757858ac8eb085
> Fixes: 8a8ca142a488 ("mm: migrate: requeue destination folio on deferred =
split queue")
> Reported-by: syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/linux-mm/69ccb65b.050a0220.183828.003a.GA=
E@google.com/
> Cc: <stable@vger.kernel.org>
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>
> [ Backport note ]
> This patch is a follow-up fix for 8a8ca142a488 ("mm: migrate: requeue
> destination folio on deferred split queue"), which is currently only in
> mm-stable, and should be backported together with it.
>
> Credit for this fix goes to David, thanks!
>
>  mm/huge_memory.c | 12 +++++++-----
>  mm/migrate.c     | 18 +++++++++---------
>  2 files changed, 16 insertions(+), 14 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index ff9a42abd1b6..ac6d823e351f 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4558,7 +4558,7 @@ static unsigned long deferred_split_scan(struct shr=
inker *shrink,
>  				goto next;
>  		}
>  		if (!folio_trylock(folio))
> -			goto next;
> +			goto requeue;
>  		if (!split_folio(folio)) {
>  			did_split =3D true;
>  			if (underused)
> @@ -4569,11 +4569,13 @@ static unsigned long deferred_split_scan(struct s=
hrinker *shrink,
>  next:
>  		if (did_split || !folio_test_partially_mapped(folio))
>  			continue;
> +requeue:
>  		/*
> -		 * Only add back to the queue if folio is partially mapped.
> -		 * If thp_underused returns false, or if split_folio fails
> -		 * in the case it was underused, then consider it used and
> -		 * don't add it back to split_queue.
> +		 * Add back partially mapped folios, or underused folios
> +		 * that we could not lock this round.  If thp_underused()
> +		 * returns false, or if split_folio() succeeds, or if
> +		 * split_folio() fails in the case it was underused, then
> +		 * consider it used and don't add it back to split_queue.
>  		 */

Should the sentence
=E2=80=9CIf thp_underused() returns false, or if split_folio() succeeds, or=
 if
split_folio() fails in the case it was underused, then
consider it used and don't add it back to split_queue.=E2=80=9D
be moved to below label next?

Since =E2=80=9Cthp_underused() returns false=E2=80=9D is describing =E2=80=
=9Cif (!underused) goto next=E2=80=9D,
=E2=80=9Csplit_folio() succeeds=E2=80=9D is describing =E2=80=9Cdid_split =
=3D=3D true in the if=E2=80=9D,
=E2=80=9Csplit_folio() fails in the case it was underused=E2=80=9D is descr=
ibing
=E2=80=9Cdid_split =3D=3D false and !folio_test_partially_mapped(folio) in =
the if=E2=80=9D.

The first sentence matches the goto requeue for folio_trylock().

Otherwise, LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>

>  		fqueue =3D folio_split_queue_lock_irqsave(folio, &flags);
>  		if (list_empty(&folio->_deferred_list)) {
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 05cb408846f2..8a64291ab5b4 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1385,6 +1385,15 @@ static int migrate_folio_move(free_folio_t put_new=
_folio, unsigned long private,
>  	if (rc)
>  		goto out;
>
> +	/*
> +	 * Requeue the destination folio on the deferred split queue if
> +	 * the source was on the queue.  The source is unqueued in
> +	 * __folio_migrate_mapping(), so we recorded the state from
> +	 * before move_to_new_folio().
> +	 */
> +	if (src_deferred_split)
> +		deferred_split_folio(dst, src_partially_mapped);
> +
>  	/*
>  	 * When successful, push dst to LRU immediately: so that if it
>  	 * turns out to be an mlocked page, remove_migration_ptes() will
> @@ -1401,15 +1410,6 @@ static int migrate_folio_move(free_folio_t put_new=
_folio, unsigned long private,
>  	if (old_page_state & PAGE_WAS_MAPPED)
>  		remove_migration_ptes(src, dst, 0);
>
> -	/*
> -	 * Requeue the destination folio on the deferred split queue if
> -	 * the source was on the queue.  The source is unqueued in
> -	 * __folio_migrate_mapping(), so we recorded the state from
> -	 * before move_to_new_folio().
> -	 */
> -	if (src_deferred_split)
> -		deferred_split_folio(dst, src_partially_mapped);
> -
>  out_unlock_both:
>  	folio_unlock(dst);
>  	folio_set_owner_migrate_reason(dst, reason);
> --=20
> 2.49.0


Best Regards,
Yan, Zi

