Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4171DEA7946
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 21:09:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A344C6B008A; Wed,  4 Feb 2026 16:09:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DE636B0092; Wed,  4 Feb 2026 16:09:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 861D66B0093; Wed,  4 Feb 2026 16:09:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 74BF86B008A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:09:05 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2358558601
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 21:09:05 +0000 (UTC)
X-FDA: 84408014250.27.406BD00
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013052.outbound.protection.outlook.com [40.93.196.52])
	by imf10.hostedemail.com (Postfix) with ESMTP id 16D4DC000F
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 21:09:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="DSH4CTY/";
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770239342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uu8led/ac7PmT6OTj2F1z9GElWcTa32FtS1BX67KHcc=;
	b=4f5UHErA0sqhmLmTgMKVmKhuQ1JLeO2FkRIcKoqd23lypt+klW1hzgGAWBmx7xkwSgnu7n
	WYmhhCoifR/+MDEUABJadoXz/DI+ewbLEZqGpSXBLfaiXQpSmubSKLo/sxfgKqZyCcbR2w
	Rfks/6ej6q1COTXO+ydsp7dwGoEBaGo=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="DSH4CTY/";
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770239342; a=rsa-sha256;
	cv=pass;
	b=lw+P9i9Evso7RWUGP4RBZzWb0NPLAbrnxu58mnVR0uxK/K1J+J1vjlsKNQanpRpzpAV+OE
	39c9izOcepnDODjg3FPW/AAvcHEThLAESEoOAblvav5dRnroNU59CoNUxPQsSq8EmRNg2L
	VF4a9LqOkALOTGvyOQqd5QO/LyGil8c=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W4qvMjGzC+sENxnDFYgxEmXs2PZoNyexh5tvoYUTzzduvRqACgI6Y/js4HyYtn+MDxYWZTVV9Zpo/MocoBX6u/2Xp7k5e/bLobTRHqsTKbd4Q+OHQ8XiE4X0bJ9gQIpvZBIh+3pr2JUbqO9jJkYIsdlMscz1xdOlProQBMBEyA0sTw/LVSWhr+1doSEEtko00J+2bgTrBhIR24cvo2wk7VTel1KX31Yy70XLDFGAFrfNyJnClFHPPIS7JZeILltTHhnIy/W4ufgXTiBYHIMI/uugPRfYnZSoOvGAAF3VxV8P29Kdc3OCVioC2vuUdOwy5wevTvRtgkAjm/B8md/s0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uu8led/ac7PmT6OTj2F1z9GElWcTa32FtS1BX67KHcc=;
 b=YXcrZLNslAogT6fj33G/3y3MNjWEK2dnD6Ie9rHjumQnyzRh3tGKPUD0GSDIvw3BkvAE/GF6UXj0Kcukq5vpBQeq0SUqJhC7cs1QAdHQy5Iuov8xPAhLnF1aSOoC3FtBrUG20+R4N1S6pYSuTURBN+9KzCXkWD/BmkuxaMZ2kDPqmsw9+jbZLngtLNZa658goHSQCvOqYPjxuXcXIVlPWb1biCA3ppfDWXSuVOS6nwhnzVk8/eM1mKJaYwh+VjnYm8TdlyiM4crW02Sf3p6QT4vVoZPIsEheeagNh768KMTMn18Q/BEaUneemPAV4IBjRcTT9mFp0laUhsvrY+GM4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uu8led/ac7PmT6OTj2F1z9GElWcTa32FtS1BX67KHcc=;
 b=DSH4CTY/aiGqUFOsxVXlUEnAjw1oj5j/y3A6MPTJx8Ymku3JdykH25D68zzD/jTOfk4YbG9viRzf+sMmhEr9lKPdqeFUqfcGbcmHmvO1wNSEOyIqIqee3uG2ptngD+FAJ7MXXOHWgeh/7Ih0yLDyxthwxqq8PbQxC4pQTUeuY/zf2n3cIHCDHAo5JAYe3nMeCnvBUv1wcH2xgrWo8QwyfPAKeHOhDvgQonGNqSB3nh6gXrO5kBjJLvRaT2k4x1Ze5Rl5k/INwLC5AvkwNQrgsEccIaOuKUjFEQfIBPYffN7MlDdP7I913q+8zDw4zyjBmkyDyTH9ECQ0HJFgiXpABQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB8484.namprd12.prod.outlook.com (2603:10b6:610:158::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.13; Wed, 4 Feb 2026 21:08:56 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9587.013; Wed, 4 Feb 2026
 21:08:56 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (arm)" <david@kernel.org>,
 =?utf-8?b?5piv5Y+C5beu?= <shicenci@gmail.com>
Cc: linux-mm@kvack.org, linmiaohe@huawei.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>
Subject: Re: WARNING in memory_failure() at include/linux/huge_mm.h:635
 triggered
Date: Wed, 04 Feb 2026 16:08:50 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <61BBEF63-20D6-4671-B7F7-F015D49B2080@nvidia.com>
In-Reply-To: <e97d5c0c-b8ec-4da4-b838-7a308f8a6327@kernel.org>
References: <PS1PPF7E1D7501F1E4F4441E7ECD056DEADAB98A@PS1PPF7E1D7501F.apcprd02.prod.outlook.com>
 <b9e89c85-807c-4a8b-aa5c-8c1325e75445@kernel.org>
 <1db245a8-f9ab-42e4-8cc6-cc7562961921@kernel.org>
 <48978612-6933-4897-85DD-6740B6C8570B@nvidia.com>
 <25CA4D90-A24E-49C6-92D2-08080EC81466@nvidia.com>
 <032058DC-CD8D-406A-B986-740E41C834B2@nvidia.com>
 <e97d5c0c-b8ec-4da4-b838-7a308f8a6327@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BY5PR16CA0035.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::48) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB8484:EE_
X-MS-Office365-Filtering-Correlation-Id: d9b77138-addd-4022-b269-08de64319bcc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eldRQWExYWRudjhPRW1qWTRXd1hiWDFTQlpSYTJRd25GMzN3VmdmUUJVcmdX?=
 =?utf-8?B?N0lhOFhaTXRKWFNOcy9uTmVXQzI2Yzg5MThzNzJiMGc3MlFOZGNNTGxaVWMx?=
 =?utf-8?B?MEYvYjVRQytsZk00anRzdk43cDFZMlZ3VEduNmF5c0xHWU1abEl6YTFpeXda?=
 =?utf-8?B?WW91aE9ldTBmVzl3ZElrWG4wcmFuaFhOTVEweWlpZ3NlUTRjdmFCaUpjZ29v?=
 =?utf-8?B?aU0yQTFRNVU5Q2wzQzhCM1h1V0Y2T21IK21qQm82MDVjcFlzekdqSGxjZTBq?=
 =?utf-8?B?dXJ3bFYybURFRkJVWWY2ZUtOY1RxNjZhdkVFclZST0pMRGxWM3k2b09PRUhJ?=
 =?utf-8?B?OTEvWEtJdjE2YlRHdWkrVjREbHVudTlsU3orVDZnYW1kRWtaN2V5MWhXaFlk?=
 =?utf-8?B?S3dzcEQ3ME4vQlNuVHhzL3R4Q1JKdFZHZ2h2Z1VTYjdmVzBmSUl3UTdjOTVH?=
 =?utf-8?B?OUFPRW5nRFF6Z0JZMUxUV2Fya0JYMVZ2R2NzTGtUYUtFcENBTm1ZNWYvQmhu?=
 =?utf-8?B?VkIwN01HV1NjSTE0SWJOczkxbndzeDYvU0E4SmplSnZXVG1kUGtpNkZHbFFy?=
 =?utf-8?B?TnozM2Y2RVAyT0hydDhDdEJpRis3NS9zdUpQU0RKM0hMUzdGMUtWQVU0bVlU?=
 =?utf-8?B?TisrNXVXTEVYanNUeVdaeWJaSmZrTlJwNDRWZVRCQU0vTTJVL3pRY0RTTEc0?=
 =?utf-8?B?Y1ZDcTJaM1NRSitkUXdLL050Z0trRjhNSkxBalFjZi95cGIyYTR5ckVXaEdX?=
 =?utf-8?B?b2tHaXBRenZxZE50WWVjSUFLTmxoZmZGcXRyQit6NTRHVjdMZXNoNFd4aXJE?=
 =?utf-8?B?dHpBd2RSL1RqT1lEUDFHOEkya21UWFU4SG1ibTMzWi9NNG1UNHBQR3lVN09r?=
 =?utf-8?B?bWNaTXNTM1NYTGhidFBhTlI4bjllSnpLaEFqWENJVExxOC9IczM4dkNONDdz?=
 =?utf-8?B?eW42bUx2UGUvbmpZWjZyRHVocXg1ZTd4ZWgzL2pXSWJpa3JCRWhJa3A4am5I?=
 =?utf-8?B?Y2tTMmdiNGRNb3YyenRwTnQ4azh5UkhKd2FsdlYxL2oraUt0cHNLVVk1ZzR5?=
 =?utf-8?B?cy94U1RGMXprcStvYTZmVTZpVm9DbWllTlFhR3hNb0dZbmFPVXBaVjZobU1Q?=
 =?utf-8?B?ZzZiaDJsaG5jWkZaVEwvZEFxeTFoWGpQdms5RmJoSkMyYWpPcnp2VWJsRXpB?=
 =?utf-8?B?R084MkEvWkw2VmFlUDhLQkxVK2FRa3V4bVN0MUJ1aElhS21QWWVsRm1tSmhJ?=
 =?utf-8?B?bnNnc1JzcnM2SGxkUmxKZCt2ejlRYlpvOHlHUmhkSzh2QWRaeEF3UytTcUNR?=
 =?utf-8?B?UHhMdDJ4RDk0TWZmcDVXRGFwTUFzSHJaQmNUV1pORGdvZ05lS2hqZm9qUmZx?=
 =?utf-8?B?ZCtZaXYxaDYrNzN2SUJNSEk1NTFhSHVESzhwVjJ6RmhIdm1HZzUzeWQ0VEpD?=
 =?utf-8?B?UGoycGlGWi8rbnpLbmhOaEhubk5EVUgrY3dUV1Z6ZUdrMDZNSE5naTBKelJr?=
 =?utf-8?B?N1RDZExLd1JIK1ZMVkdaOEJNMk5SVGs5ZkdDVUdzcjlTSjA5ZUhtN2txYzFt?=
 =?utf-8?B?RFBUYW1qK1hQc2lmUmcvaDhGaXZXbFA3UHlRbHBkcXZYOXBsWGN3RU5zY3Qy?=
 =?utf-8?B?ckZaVHl6Qnd2eHRBc0Q2Q0xsM0x0WDc1V01FYkEwN0FyMUhmNU0zM09sd1Rs?=
 =?utf-8?B?dE1uNGdQeHRxc3k2ckhhdzUxWG9jTTRTSUxoUHZJdEhLYmw5S1FUbSs3T2Ry?=
 =?utf-8?B?TnpXb0Vud2ZOMWIybDdKTFN1WU9VR1J3VjNQRTA4SWJwamcwRnJSd2hQVFhO?=
 =?utf-8?B?Y2t3WUdseG5WOXlGOUVVSkQwbVZ2SkprQkRORW9MSU9yUWhzMFBEdFFvbVh3?=
 =?utf-8?B?eDVBaGU4cm5LcjBtRUROcnpyRm1jRHArc3RGMmFQZmRhQlp1eERoWlo0YmMr?=
 =?utf-8?B?VWI5YmdFb2dOVzRnd3YreWFoMkhoT3dnMG1nRnBGY3Y1cGpsK3R5ZWtNaWF5?=
 =?utf-8?B?SGIwYlpLbXNabUI2cUxNOUFuVlhIcndrSFdINTBPaFZ4RG16UDIxRXFKRHR6?=
 =?utf-8?B?MFVhVFJ1MGZmUENKQVpSS0l2R0dqSFdLbG9ib0V1YU55WFo2NDB2eW43VnBW?=
 =?utf-8?Q?9DOI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZVc4cWIzdC9hbllHWUFkUU1DZkRkQVdZbTJNTGtGWFdiaXhFVkZyT0hnZ24r?=
 =?utf-8?B?Q2hObkhwdVJVenJYaXd6UVg5YWkrMUhIaGxXZCtVVnA4QzR1LzRFcFNYOGh2?=
 =?utf-8?B?QmJqWi9ocHk1QVFaZytSR0hZZHZZQnk1VUNYVC80c0loQ2MxUjFnYUJNTktn?=
 =?utf-8?B?OGJRQ3lHK3l5RGFFWEZONk0rQWxIN0NoQjRTTHZCSFoyREJYa0x6Y2FLMVJp?=
 =?utf-8?B?WnZpUlhKay9tNHdWYXlSSU56c3h4SXNnanBkVEpTWVpVYk8wdEhPSzlYcEJJ?=
 =?utf-8?B?K25va1paQy93aGg4VXdXMVJsWVp2dHl1UmY2cjNaZC8wWnQ2SXFEVlV6eVBO?=
 =?utf-8?B?TmJzV3ZBRUtReVlUcnNia0JTTjlaNVpaNElURmZ2aFUyRlpXbWFUMm9LbGtS?=
 =?utf-8?B?Z0NmdFY0Q2xmYzNLUm5XTGVOK2MxcjFQaTJhNFJpRXhlV29lSnIyRGJuSHMx?=
 =?utf-8?B?VXpVbjlWSGk2c1lWbmozRW03UDNHa250VVFnSWdVcWdkM1ZKN1EydjNROE8v?=
 =?utf-8?B?NjZTNWpoOTgxSXliTnRwRG1GeXJLS3FsWnVnbXBxYVNkdE5SMC83TWhqZUVM?=
 =?utf-8?B?cmY5OFl5dTRGNVU2cWlCdXdiNy9PaWxlc2VvTjBxWElFTGNOdDNpRXNTdTNt?=
 =?utf-8?B?Uzh3cjJyRXpiMzFxdFk1cGdQTU1odmR4Y3lrc0J6T3lDamlnWkNoK1Rna0E5?=
 =?utf-8?B?OFpCbjFxTnd4dmVSNWsrTFZndE5NaGpTMnFnL21oOHMwTktCL2haN1JoQkRP?=
 =?utf-8?B?MVJCMlJDTDgxL3pRQzBMcDE4OXlaSE9jOVJwTW9LSGdWRTBXbTdiZ0VrSG85?=
 =?utf-8?B?VWFIQnlqZEVGR2NLM01iZjJwUzVpWXRVeG5Helh6WGtYTVNCOVZjRERTNEZj?=
 =?utf-8?B?di9jdzZBVjg3Y1E1dW94RWRMY3VjcVladE44ZXE1K01HK1QrRTVZRWJkSU9n?=
 =?utf-8?B?emRpTEdhZVZ0SlNqeWZBeGNhTWJvdStWbUlFcW80TEZwaDFGTy9IT3dMblNS?=
 =?utf-8?B?WC9qYVFhTTJhUVhpZUQ3V1FLSlczM1dQT1YwUHVvbHZKTFBsb3Z6eTh1NW5Z?=
 =?utf-8?B?WXBxWCtscU90dnljcEhudTNxVWpvTHF6Mlg2N2tHcEgzTDFZcTF1dnFsNExL?=
 =?utf-8?B?QUVxYTV2OHZlQ290VVdMT1UzeGEvUWtjVzVIVllCdWlvU2x5UU1mR2hkdzJo?=
 =?utf-8?B?N25vdmh6eUlQeC84MmV5SDRoT2x0SE1xYXRXZVJvdUNOTE9VOWNSRHl4U2Zs?=
 =?utf-8?B?MHQrRW1COFB6RVNWUGdBWGtFSGtjZW5SYll0VFBYeko0aysxbHZzT1ZITVNG?=
 =?utf-8?B?b3dxY2FHYWNCZjQrTWZCWjRoYlV4bXY4NGxmQWVlMkZxQW5wMyt5SzFMSkpx?=
 =?utf-8?B?Nmpxc1duRGhqVmtnYlF1RE0rRXVpSDUrTC9LbHdhZ2ZoTFhzR0xsNnlHOWQ4?=
 =?utf-8?B?RUNwdTNaa0xmYitkTmR4TG9FYktFdGVTOTVVOVBudm54MEFJUlRlaUpyVTI1?=
 =?utf-8?B?dW95c1JCOWxUSllPdENoWnFiT0RuUG9RcEhPb2dacUFPL0ttM1JqczVGbUNq?=
 =?utf-8?B?aHdGWG5sK3o3K3J3RDNCaHVjckFUeUY0RG52bXdHbDB4Tm91R3pNZHpWaUl3?=
 =?utf-8?B?MGhPTkczVVUweDd5TExkZ3ZrcnNiYzRJcENiUStlMHo4KzJaait2R2VxOW9B?=
 =?utf-8?B?OGlLeDViVkh3akREbkk5SjBzZmgrYnBoSElpQUFTVHd4RUhJSVh5bEF0a1Az?=
 =?utf-8?B?STUyQWdjb0xST1o2L1pPWU1WZ3V3SEd1OUJxSVB4K2tlc1Y2a2o3UEdxSDBz?=
 =?utf-8?B?Wm44UENSNDl0TzM3b0JReGprVWNsUFBqZkhqSzBOU0ZJbFFOQjJUcERMR0JZ?=
 =?utf-8?B?V3pKMHBxb0hzTEtuZko0YmFjeTkrbi85TTRSL2hSYTg1R284bUxXYXROSnkx?=
 =?utf-8?B?VE02YS90WGZTL2YyZWJlZUdGS0N5NG9JTzdiaVU4dGZEV3VRY3hueTMwdmRm?=
 =?utf-8?B?djFoRTkxN0paeUtNNGN1VDVHS0Rod2s2RHRHSWVYV0FJdVNha09uZjJWQWZj?=
 =?utf-8?B?djNwNnFBWldyZSs0N1dOZDJLNVBRYU0xenZ0NDczWVkzRS9zdldmOEFUVlQ4?=
 =?utf-8?B?TWcwV3drYzBBRGJ3TTcrZnVsbnljUVhxaWlPMjRkem84QWNBbkVqdGVHRU9s?=
 =?utf-8?B?anBvclA3cmExdHh3SUZXZW9pVWZvWGM1VUwrTFpSRVdzSGQ2WkJtbEpvQkVa?=
 =?utf-8?B?MnJKYldlZVQ5ejB4TDhrT0cvOXZYTmIrTjd4c0NRTmVPc0duMmIvNlVaMjNo?=
 =?utf-8?B?NTVZS3NERmczQmtiNGVjeXZ4SXBPdE1hdnNsbzJYMlpzY2VoSncydz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9b77138-addd-4022-b269-08de64319bcc
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 21:08:56.4750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mk0nHNpz2KxPrwwPnrwr16F/iVXli1AMTcipfUz75muFfWRii51l6ChmaOv4CKfu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8484
X-Stat-Signature: wx3syfurc4t3bdyz9zmjq3ks54hstacw
X-Rspamd-Queue-Id: 16D4DC000F
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770239341-528639
X-HE-Meta: U2FsdGVkX19uiGFEW0rEx7lyA/RrMLqD/ZCQn82Uwea15kn0FKofUMR0yOKVgA3974wXMZTdnM95qrDbXl78eMMfiW8mEoQQ6L+0LdkcvhPmZ/midJW/tXeXE0/X9id+px0V9ioJb7KYH003SMxmk98TFjKvOAo9bho9r84UnsppdEpW98wb4lDDVbj3zGOziWyp4uvgHJi8cXC0Joz8Bo7vZUATzd1qWT5Q4rOtRxVyI1fCVlO0AqWMOdKr0cz/8Mjnm0L35c8SyUjt8ErAfMZV///4TYEZZLvbkTG+6CimvoRgUFvp8kfC4yBhi5tLldGlBH48RILezOcqA1g0w+QoTsrCTd5Oy17MCbsay/CarIGjnAVgtZUt55EeaCkmadViedxYkMaQ0o6uqpnxqjLQ72XpIOUmRKQ6zW2iPrMrpji+i4WpTcEGI/LWPA934ZNEmDJfY/X0GOtNK3rMLZ/hal4lTZdoOz4IuFe07G3EXghbhQjfhe9vRMDLbUUXO1YZoV6EQ0tyDccCv6v7GxR/X5dXlOm5KonxeOsmq153a9+3RyZWmo8YbEeOlfI430N7WToO2OMmQ4TtUgBTNJUnOUoPwPelieQGcD+jGPA4V9K68Ce3G5K8mMBnqNU+03on/Q9KadyOXZSZs+2evicQvJRoEiPpJSpJ5hXsPrK9S0rSrj+mRtvtazarOjrABJK2HW7eq/+ivOn8xYxRdvXgUUJ0VLc1AqHZJJPt1R6xhgLApr7vlDG6DfRRtyxSrWf+cJj1waWQkicLZud0xf4mixd4azkIevVsJaiA7ux6+N2lVOK0DjDUcQTyypFCQmR9aW1bybBY/NpvU5tMNlw/mR0rylZYVR7kpL/FERiTZEuITmXqCxbmDpCH6JhCjYLJ74yuuEAV9wU++7MaEmqEUCmE53vCMmRu9zRmfL0S+GOE404hpaYWWvn5NBlKvuSlsysnzw90DkFDZ4N
 hXSFFtWj
 lMsj/exEHi/JQvXqqJ0RHOY7CRCVN43HVpS6KJobIEBqY2aHGK0Dqa0x2b69ry4P3wBIwLi63SVe67vl8sgOUtvV1NhfXPEIuG9AbebHeVRqu5EhkMO2cz13+bkbdcf2tZxTrYsjzj3Txt0oe1sNfcYaLlovPGEPUfWAWZiXju+EHgCoijiVdfxn/l+Q6SymcCwoDx7w/HEu7DT9qcQjJ+fzm/qLGJBN8/En9X/h45oRm3mpppAueflpF+0nNeuywlerE8n8BYmAGneeyz/EKtdkj+iMzD99YPFckFAkHRaL7vzhhrnKxUhWPndKf6CG2NKfxqPb/GyXWbv1EWI2V9BKkIQzgo0FUAph62bvko6k2cHe32pkz5DXpnB+OnoIZjLrhJoKRW5kYOeqoEl4ERY0upQSnMNMvTW3qG7F8t7RPGobzsFGhhydMn7QV9ErMu8Ak
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4 Feb 2026, at 14:18, David Hildenbrand (arm) wrote:

> On 2/4/26 18:41, Zi Yan wrote:
>> On 4 Feb 2026, at 12:34, Zi Yan wrote:
>>
>>> On 4 Feb 2026, at 12:23, Zi Yan wrote:
>>>
>>>>
>>>>
>>>>  From the C repro above, syzbot opened a dev "/dev/sg#" and did mmap o=
n it.
>>>> Is it a device driver issue?
>>>
>>> OK, it is CONFIG_CHR_DEV_SG. And the driver allocates a compound page a=
t[1].
>>> Since we initialize folio fields in prep_compound_page(), it becomes a =
folio
>>> when it is inserted into a VMA.
>>
>> More details:
>> later at sg_vma_fault(), the driver just handles a page fault by supplyi=
ng
>> a subpage from a pre-allocated compound page[3]. We then get a large fol=
io
>> without !CONFIG_TRANSPARENT_HUGEPAGE.
>
> We can identify such non-folio (but compound) things by looking at PG_lar=
ge_rmappable IIRC.

OK, back to the issue. The patch below should fix the issue?

Hi =E6=98=AF=E5=8F=82=E5=B7=AE,

Can you test it?

From fa4a900e027a0c7365a9f786840943990d5da971 Mon Sep 17 00:00:00 2001
From: Zi Yan <ziy@nvidia.com>
Date: Wed, 4 Feb 2026 16:04:19 -0500
Subject: [PATCH] mm/memory_failure: reject unsupported non-folio compound p=
age

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/memory-failure.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 825c706ac576..4ed903de9a0e 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2440,9 +2440,12 @@ int memory_failure(unsigned long pfn, int flags)

 	folio =3D page_folio(p);

-	/* filter pages that are protected from hwpoison test by users */
+	/*
+	 * filter pages that are protected from hwpoison test by users
+	 * or unsupported non folio compound pages
+	 */
 	folio_lock(folio);
-	if (hwpoison_filter(p)) {
+	if (hwpoison_filter(p) || !folio_test_large_rmappable(folio)) {
 		ClearPageHWPoison(p);
 		folio_unlock(folio);
 		folio_put(folio);
--=20
2.51.0



Best Regards,
Yan, Zi

