Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAF02CAC58E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 09:49:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1F688E000D; Mon, 15 Sep 2025 05:49:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED04C8E0001; Mon, 15 Sep 2025 05:49:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBE498E000D; Mon, 15 Sep 2025 05:49:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C5E368E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 05:49:42 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6FC325944F
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:49:42 +0000 (UTC)
X-FDA: 83891012604.18.9C2944A
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011005.outbound.protection.outlook.com [52.101.62.5])
	by imf03.hostedemail.com (Postfix) with ESMTP id 73ACC20008
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:49:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UqyHXQaW;
	spf=pass (imf03.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.62.5 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757929779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1WHKP9J+fMqABa2gH/pPp/gcBmWNXMXGKFgVxSUA2ps=;
	b=mwa26HuqIzfa0Gw6PSxOvKO8QFaiiGyNUWpOUByecUUk+k+OcEKFbVSayRs4FRV0Tlgr8c
	Fl/GQ2PwTIpvb5heh69gW+3vW0ITMHPP54lZ07set24XVtvDmXox2MUkkf3LM7cdJaCRCE
	EYGuETQu+ztPMpV6WvtTfXSt94GNgZ8=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UqyHXQaW;
	spf=pass (imf03.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.62.5 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757929779; a=rsa-sha256;
	cv=pass;
	b=bB4z3W+c4tOVFFEgKMjRg5E+4g289dXdnxqdXmSA9jKPa5ldsGp6L9tayafHlT8OeK4TSs
	TTybrd4RXiRRmXBGWzG/LXTI/pdD5Hs/y29p9uhua9xtskIB8Qkk2dpZxE6EctvI5MJ8nP
	hwxQt6MMKUvv4YKPJj8mn4jkFWrxzHg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vkuorQR4KiV3eqvkelIsFDUOl9vzx2aaKa5ynuAGDYBmL1Z8I2387U8qI4uGf1WUKVhLC1nU8vT+NbMOfYkQ1e/7XpS8Yo6z8iT/s/+WFX1WEhvo35f6F6raiN8Y5mQ8HBONkWg4KoA4ShhpLteYrA2EKo/v3ojb/6wxIJmDPQUW9ZxSM/Z2sQn0K3uTthzXNaZ1fRfuNda+zUc/h/anUDykJAMtNKrjrT6SONetjWUJaoRKG4kVWaYE9NL0g6VMB5kH/I9qBYyUfWZM3bFNfDPn0iVWD5LICh7dHTzH8Fnk+6mxZ9gHP+O9MT0fH4QKKYvGJI+5L6EpAiR4BFGcLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1WHKP9J+fMqABa2gH/pPp/gcBmWNXMXGKFgVxSUA2ps=;
 b=fwM3+8KaGiu4PwEa3YXSsC745Ur/7cRalJrlS9jzQ3PXGMGQQBOwtZRC44Kv9Qt5WybSl+SaaQVGfbg3ud4+m3VM5G1kY3adT6plPas0g0CyEiCBJDFzYhm0NNmFSP7kEZdkSnirXEN7gwzDk9NvZHYqwc1vbpPX3ovGB2BLW/wqOXj13zKDHSiPUT9pzs8j9dZOD8/XvEE3n4bmjWwexRYa5d8o0Ug+oRox95cRkpr2JErghYBlSKFSFX3ypkdjZA2ehGtacZfJBCcKTPbrQnRHYx3hvTncGXaYi3Rl2OQuciBIVzhlCdIMFADNAU4ixAb78DEYJkmFuXM23sy68w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1WHKP9J+fMqABa2gH/pPp/gcBmWNXMXGKFgVxSUA2ps=;
 b=UqyHXQaWQCbWuvFEy8/h2WrWDC/wsiHvpR670qbBhDgDAbhYNpXg+ho3X7PSKpjLffUWIIwWhaWAddzCkrLITjxVRt5piwSa+nPn5bFLUUAf6mc+MQuYzR9qtALtGKsk6Dy22YM5Ap/CLRSofyNd8lCbjvJzj8YIrI63FBHF+FcFyHrOo5hqTb3mXPW+KespbMrmVrsfWBHkFomWqiEHMdP5Ws2gO0bTmJlIC2sCO+XTT8tMb6m8aJYv+APVveecDpVYP49t7kXn9B8Ttpg02Ec5TCF+utV20T32Y5Yi8KuuCyKuuUywDEeQXqJUzkyP2gozQr7hjKq1PcYHI0FbWA==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by SJ2PR12MB8979.namprd12.prod.outlook.com (2603:10b6:a03:548::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Mon, 15 Sep
 2025 09:49:36 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9115.018; Mon, 15 Sep 2025
 09:49:36 +0000
Message-ID: <d792f1c0-f393-4e16-97f0-36b4028c46e4@nvidia.com>
Date: Mon, 15 Sep 2025 19:49:33 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] lib/test_hmm: add zone device private THP test
 infrastructure
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: linux-mm@kvack.org
References: <aMepD1FRu-2DfBwo@stanley.mountain>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <aMepD1FRu-2DfBwo@stanley.mountain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0036.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::49) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|SJ2PR12MB8979:EE_
X-MS-Office365-Filtering-Correlation-Id: 57a4e850-dde9-4fea-375d-08ddf43d2e6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QTU4akUvUy91VE5TY0M5cmpLSnNsMUs0Vkw5aGE2dHNyOHJWSzhuTGtMbldK?=
 =?utf-8?B?K0JGZy9hRnR5WGgrT002Qk05czJ0N0JsVGJVNlVQUkZjU0E0aEVzdWxKWTdu?=
 =?utf-8?B?dnd5Tm1zV1h3TkVQaVJ4Zy9GQkxqOWcxT0U0YW94M3lmWjJNSitoQmRyWFdK?=
 =?utf-8?B?eWpwaytlOUQ3UEpHNHEyckdleXJEdHcySk4zRkh6VHE0YStJczN3ck9Pd3dw?=
 =?utf-8?B?TVVuZForaWQzaTJlaHBOTTlOUGF6WnN3dHFEYWZuVlAweHgyTjlzZXFFN0N4?=
 =?utf-8?B?SWdIblUwOTExZVJkRitzZ0o1d0dIY0pPOFpuSVQ2bVI3d1lDK0xOV1JIQlRN?=
 =?utf-8?B?UGRSdFZkdC83c2c3L2JxUFYwNmJVZjdUZkNvY0k2QWh6cGR3QnZUYWlJUGJB?=
 =?utf-8?B?bGhzS2wwbzhvK3I5Wks5K2h5MTQzeXhVd1JqTU4xSVRxaXFKTEUwYm1EQnFm?=
 =?utf-8?B?RG8zdFNINUFsTjhLZUt6QkN2VUhqOUtMT1QxVy9mUVoxeitTdytBMEhDN1dE?=
 =?utf-8?B?UFRnQ21xQzRoMFgrRHh0VHVTYVIvcjFyc2hybGdBY2d5ZHVvS0RwdDJXMy9I?=
 =?utf-8?B?UFFoYlRrbTlNdUFDNmIya0VGd1BHZUR0UkZkL3Y0aHpyMnhWaWZCZFdCcFFG?=
 =?utf-8?B?aTFMUnFRUzAzZ2hSUndjK1U3WEU4d3BTR3c4dVR3WG84L2dyREFLelcrTnht?=
 =?utf-8?B?YVA1Vy80ZEl3alpLTCtZTTVPSmxlR2FzZENVaklqTW5sYUU1bm1JUjFYVzli?=
 =?utf-8?B?S1d2NWZ3RXlGYk8ycVVzVVVTVGt4MGR6dmIrdDNZU0kxZnloekgvOTZjbTRK?=
 =?utf-8?B?NTZXdkcwZE5MQjRZT2xONnBtdUpWYTYzY29jMXFpSVM3U0JnbnN4TkgrOEJn?=
 =?utf-8?B?bTZ2bUNTNEpUaUQ2WnlZUmlnNUQ2bzJnZHZHQUQvUVlaSi83anF2K0x5ZXpS?=
 =?utf-8?B?S2U5MUpjaUZhblBoYm83TWFWOWQ1SXVLdjVkQldSTE9kblRXOEcyZy9CN3FG?=
 =?utf-8?B?c0Y2Y3FMakJqZlRGelo5VnUycXZIa2I2b2IvemZjSW1wREpJcllqMXY4NUdx?=
 =?utf-8?B?MVlybTkvSzNDY09ocDd4OFZaUEJWN0x6MDc2ei8zY05BVWF3QzN4b2N2VmJi?=
 =?utf-8?B?Q3lFVzhvcDBWQzREem1vNlFOSGVGbStyM2NMU0p0WXhTbG85VE15N2luNElI?=
 =?utf-8?B?M0hwOVNJZ3J5SXhDQTJDVEl6OVBIdFpza1p0Rmh5YTBpNUZJNnEwVnFBcWVj?=
 =?utf-8?B?SjhqZUMrNkp4cmhPOCt3NU0xc2V2aWowMURUcmlCQUFhVituekxlVjlNUnJn?=
 =?utf-8?B?UUNnNngwOWUzYkVHbStqYyt2djdVQy8vNjZNTTk1bXg5b0hDc1FXMWJqMmlY?=
 =?utf-8?B?T2VpVXUvZXhubW1ZMkdLUktTZkQyK3lNMFUyWGVMNENGOFF2S1VGeFBzRHNI?=
 =?utf-8?B?amg5QTFkb2lmcytWblU5R2NKRGlkRlZoRW1RMi9STjZiQ0lmTGlSWHhQZS92?=
 =?utf-8?B?QWI5Qmp6K0UxdmwrYVBucDhJSmZGblFaRkJiU3QvSkI5bFlGY2FTT0pwdGda?=
 =?utf-8?B?dE4raXRCdy9pNlJlemRhN1VVTHpVZ2ZuOTNSdkVGNTVXWFJhWWRyUWMzeDZ3?=
 =?utf-8?B?YWJrQ1BBSm5BVDMwV2Vwdyt0ZjN6cWFJZmlSbnZKZndQTm5pZ01ZdFNySnRW?=
 =?utf-8?B?ZFh3TU5vTDBSTVBIdVhhbVEwSkpRT1FGZEI3cnhORUhUcTNML3p2bnM5VDRj?=
 =?utf-8?B?Znc2alJRZFRNbE11NUhXTmtFc3JYUVl0YWF2cWJDTEtWK0RRV1U5YmpVQ3F3?=
 =?utf-8?B?QU5qQTRFWDhIN2VnSkI1SFdkME1ydTRDNitsOE4xZlZGRURac09Nb0hHQkRX?=
 =?utf-8?B?L3BOaWt4RXZiWTNmdmtsWGtQK1piUWJKeFVXU2x1Rm0zalNyZytnN2F3OWw5?=
 =?utf-8?Q?snCyJ/XrPi4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZG54YWFNZ0d6ekE5bFJaYnB2blllYlE2MVI5cG4xMGtHb3o2NlRlL0VvamRj?=
 =?utf-8?B?YnBlR05Tc1htWmNxbGdaNWUvWk9nbXdUMlNqTC9IMDdENEFNNFJUdmJqYnJo?=
 =?utf-8?B?V1hQYk1HTVF1UVRXNnZxUmtEb1ZHRW8yNmpZWjRVUW5ubnRuN3FmZ0pBQjc3?=
 =?utf-8?B?OCsvYmxXWWlMMk1hclVnMnkwc2NEVU01dzdkeG5URlgxTHovN0xvQ2d1Uks4?=
 =?utf-8?B?ZmFXVzhza2d5Rmp0N0V5ZHp6TGxPS2MwSlAvcFF6Q0JOSFV0cGdFK3I2aU9v?=
 =?utf-8?B?NkprQjNtUW1EMTA0RGVqMVhkSml5VXI3andQSGEvZlFoRWdUQ1o1elVvVFYx?=
 =?utf-8?B?TUl4VUhRY1g1MnFic2ZWQ3QycVhFVnBuSnVQN0M0YkpCRzNpSk51dFZNVFY1?=
 =?utf-8?B?eGpxaDd5RTVsY3VXd21wa3B6VTB2dzB1MFhYTmVzSGVIQk1jME00ZmRnOUNO?=
 =?utf-8?B?bFVjTmxFSXpjWWF2YmNRWWUzLzZ6OURnUmFoc3NqZjN2SXhEZDVjV1BUclJV?=
 =?utf-8?B?cmtHMUMvYXBIOU9abmVzUHJNbHJXRVYxMFBMcG10NTN2MDNJSWZob2w5RVl2?=
 =?utf-8?B?WEVxNVNVM29QTWRPUWQzZThpQitvQmRDV3JlNTJ4VFJEa1NySzlINmdYQnBp?=
 =?utf-8?B?SjdTRk5EVTBvdTB6cERING82NS8xbERaUU8zRHpxN1RrZXR3VVJyTjQ5a1da?=
 =?utf-8?B?UWZBZXIrUnBESFNMRUkxY05rMW1QWG43QmpVdzBzZGdnTEcydVl1bldyV1pT?=
 =?utf-8?B?NitZRGZGZEpaYkRxSHV0aVI2MU41cUIyTXFqVEF6ejdybTRReEtLY0o4cTYx?=
 =?utf-8?B?dm9VZ08yWVkrQ3FjcDdwNFlzTUZRY21vRFF4bm5kV0lBVUo3bDZYT3BpeGhY?=
 =?utf-8?B?R0Rpa1dxM2E1dmdubzV3KytzSGsyd3FLSjBCQjlveXlNSS84Nk1DKzJnVGdD?=
 =?utf-8?B?TjJIMHZ0ZUV1UnUwYUV0WVQzZjBDaG5YTjZFS2tpbWNicDNKaElEZ1JRaGhB?=
 =?utf-8?B?a05jN3ZNZ1NMYy8vMkhIMENzekc4dEJadVVURVI1UGJxNUZ0cDdCVG1uSWxE?=
 =?utf-8?B?SGZ0eFVjWVYwVlBIeVhVU0J1ejJCRnJ0UkY5a3NUR2hjaHR1RHNPbEVDWFBG?=
 =?utf-8?B?Y0FxekU0SExXcGhmRVoyTTNqdXA1UWVKNVdJVGxweXNXM1FxTlhVTkQ1aWVp?=
 =?utf-8?B?VDhPM2dZOXhxV3hYYzNOb3R6VVE1cWlodzRLVnZob3VlTkFsU0RkMG1wUjl6?=
 =?utf-8?B?RUhWT09vNHpLVUFLVWNJSHFFbWdiQk9jeEQzckV0dTBFVWZ2d3dwVnYzZCta?=
 =?utf-8?B?ZmhMcGNBRmRUWXZORVRBMkRIcnFzUFNiNmQwRlJWTEpWSU94VVVsTmU1Ukp3?=
 =?utf-8?B?bDc4VFh6MnB4MG1aSlJ2N3hiZ3ZHcjdUSHNLOEhZVUQxYTFsK3g4SlcxKzJk?=
 =?utf-8?B?OVFGV3ZsZnhRMGlmRjJFZmdoc210ZWRnQUw1RTdoT2pYQ1NNdElQTUdTeUtl?=
 =?utf-8?B?N2ZEclB4b3BHNjRYcFFmWDloOURodEMreG81TFl5MmFFVTVnem5lUis0OFQv?=
 =?utf-8?B?cUhCdng1b3dzMndPbVpBWnJBMlVveks1NWpDQys5WU8zcUwvN1VZSEJLN01z?=
 =?utf-8?B?Y2p0bHg1NituTW8rZDNEWkJXQUpFRDYvWDJsVTJKRTZPM1BuU0Y4aDlGUnBl?=
 =?utf-8?B?LzJFVWpiclB2RmxJeEN2MVgwRGtadmlia0F4Skt5N1lxd1BYUXk3OVRXNi9Z?=
 =?utf-8?B?bnJkSHNoNVozWGtNVlFJdnRldlM1eEFEYzZUQWJQazRvOVVORGJVK1pJbHpJ?=
 =?utf-8?B?TlBxU2E1WGZHZG9obnd0UXNzOXJwWDlZYTZ6Z2JacTZSMm1VVzUyNDE3ems3?=
 =?utf-8?B?WFVrR085eHVpeUpzelQrZ3Z2UEdvdUhpMSs1WEd5TkpBcnoxMVdTWXg2a1Fs?=
 =?utf-8?B?cHVOTFQ0aFpKK3ZsTzRBRTdvd1R0Y1o4NVBGWFNBamF4OG0wSzllc0hGRXpU?=
 =?utf-8?B?U1lEQWozN045UUVHRXYvSGFRampUL1RkMWZUOGZuMFZ5MW15MytUM2V1NWpX?=
 =?utf-8?B?L0RHelJ5b0FuckxrNHo3MDdKR0FoRXVFNlptQkF0MnZJcm4xOXpaNHZrSzlk?=
 =?utf-8?B?ajZsNmZSZ3dPYk1oUU02UnoxUkNvbGhMWVgwUVI2MHdQUjVOQ2pKNXJnQ2ha?=
 =?utf-8?Q?opfeXO92cZbSUA2fqEMEIryWUxNHHdoafiGNIqHAETgU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57a4e850-dde9-4fea-375d-08ddf43d2e6f
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 09:49:36.7375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4kj+XkdkpOldn4aK/8GFZs7fN2ILAWAZC1D4FglXc0aYqYVjmvnCTxfKS4R/zgNOzJTsIenEZyxFaEOtQVSusg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8979
X-Rspamd-Queue-Id: 73ACC20008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: duff9oumkzfnw9ie5eyob5boo8y8dgta
X-HE-Tag: 1757929779-302854
X-HE-Meta: U2FsdGVkX1/AIAXjz/CzHGs9Hc+JYwMCnNBT/E6jgk2wazGqd3CI6nerbgypL6T4aUUPAXGaFSKBfNBJbDuSuVumLPhK0mVjIzWFc3G9NfdZqn/7rUpRvonhRmeHGBoDpTNOhQN0GY3VSXEIcbziz7QTSqIygCcnC8jNVQiHBAabssxcA6ogKVNDF/jxps3a2xOV3dI1WNg2vj2CgsOJex6lCBr+OvKf1v3jnlSp9jJI6kJX4cFfVvZavxAyrE3doHKwHO0R+1E/Hs9lAP16NogMwNHUvR+pJSAwZcRI4LHlIgyxTJnWZ05sW9jlv+oogvBxljmVMiIdV2pwHBRgZwbekvpLUf6n+ohxdzEIDfAbzIDncrOCzeMlQUGUWcD8ibqunkYvQF7YLdKFKrssU4IC5aaBQa8q/5WRLMQ0R5EC2vi2mSmuuD0DR1/E9/rdNiFQItLh3gG4YPBEU4zI0mtNBsV4ouYp9HRYjfvz6Jv4CYGMHVJVu562QwXlShlgxtHmIvWZFucTfDvJ9UZZns8QrXLk1URA5lOI6rlz/JMJ1Oy78t5xf/sbaGkeJOwNeB/1po+Yv4ZCEyvyEIVuwTyrUWkNi+3VU5idKfnWqR+Xg4yKUJ76GSR+jBPNwiIDU+mggXwaNJlOnlNRH72cWfmZhDFmaqY3CsX5Ff+4h0Tka3ZfZ1uO/ywSSXcAHsv8hQwnd6Jtw+x5QH3sh914HnJLkxhU4c2fuWDKOMNjjgQhl+xFbEiTmCgq4Mid7F36iShODTKz1gJScHRCrDRY9GUhqitC5xb5EU5HjYYXJ+x3EO7JEieNgQN4Z+k3qJFqdIcxk8fiO0nhTSxx7Ke5vtQZkQlJmb8nQ8bFRtOMShcpsfgK2WYKJhno2lLh8cwAzLi4wpdn2RVUI8K0d64pJ21xE8l2dco00qi2/p1r0cSAe2lgm2x8j7oQJvPxh6k1+WP/+OjG3IWcyCrhd4T
 lFbnEAT5
 q9LVmIFzhzTTAgqKVdUF0NAm+3r9MSovnYhzYJhGKXUWudE/fgRmpNOsa+WNgfVxp+uLxHFlzVidkD2yciRGuu861cS+N5NGWkk5T9lcuvIslZZMYFP+dn8SluNpPxNKsBiOh0XsRYuhU3ODz0oYfDa71lAPcdC9/IS4Smsx5dZC/KGcli4Y3pAXCfCc4eX8/7BP3mEobYYssXyNOfZMZLiEzxvUzN9UB0frK+s7dnmdx78PClP95ojFnVIGZVIb6oTxLGePhA8X3xL04ttTgIzqLfeHryck/0PmNWGmh1+8QiBdpJgg8zdGZVvpktg/4KGKl+kmAAvj54x9/hR/TUEaDFT+TAl3JkbOTkDHJmZ1DSzUrt64e+6x49mNapAgS2PrIxuiKoS3Qs7hWdGq2GaWSC0CNEhS9v2Y2XUtBmk6JMtP0o2XSooIId7QbfwJrsrkSRsH7V2qXjYY1pjjBNgR8TdnHsfkVHC8NoMwLbI4DFF09Zv9Ka6m6N/1POivRzsjT9Ilux7MinMkYgWhE4wfMYhZRxu1IcXCmoBb4GTP806I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/15/25 15:50, Dan Carpenter wrote:
> Hello Balbir Singh,
> 
> Commit 6098c878b175 ("lib/test_hmm: add zone device private THP test
> infrastructure") from Sep 8, 2025 (linux-next), leads to the
> following Smatch static checker warning:
> 
> 	lib/test_hmm.c:721 dmirror_migrate_alloc_and_copy()
> 	error: we previously assumed 'spage' could be null (see line 718)
> 
> lib/test_hmm.c
>     675 static void dmirror_migrate_alloc_and_copy(struct migrate_vma *args,
>     676                                            struct dmirror *dmirror)
>     677 {
>     678         const unsigned long *src = args->src;
>     679         unsigned long *dst = args->dst;
>     680         unsigned long addr;
>     681 
>     682         for (addr = args->start; addr < args->end; ) {
>     683                 struct page *spage;
>     684                 struct page *dpage;
>     685                 struct page *rpage;
>     686                 bool is_large = *src & MIGRATE_PFN_COMPOUND;
>     687                 int write = (*src & MIGRATE_PFN_WRITE) ? MIGRATE_PFN_WRITE : 0;
>     688                 unsigned long nr = 1;
>     689 
>     690                 if (!(*src & MIGRATE_PFN_MIGRATE))
>     691                         goto next;
>     692 
>     693                 /*
>     694                  * Note that spage might be NULL which is OK since it is an
>     695                  * unallocated pte_none() or read-only zero page.
>     696                  */
>     697                 spage = migrate_pfn_to_page(*src);
>     698                 if (WARN(spage && is_zone_device_page(spage),
>     699                      "page already in device spage pfn: 0x%lx\n",
>     700                      page_to_pfn(spage)))
>     701                         goto next;
>     702 
>     703                 if (dmirror->flags & HMM_DMIRROR_FLAG_FAIL_ALLOC) {
>     704                         dmirror->flags &= ~HMM_DMIRROR_FLAG_FAIL_ALLOC;
>     705                         dpage = NULL;
>     706                 } else
>     707                         dpage = dmirror_devmem_alloc_page(dmirror, is_large);
>     708 
>     709                 if (!dpage) {
>     710                         struct folio *folio;
>     711                         unsigned long i;
>     712                         unsigned long spfn = *src >> MIGRATE_PFN_SHIFT;
>     713                         struct page *src_page;
>     714 
>     715                         if (!is_large)
>     716                                 goto next;
>     717 
>     718                         if (!spage && is_large) {
>                                     ^^^^^^    ^^^^^^^^
> If spage is NULL but is_large is false

Isn't is_large being false ruled out two lines above?

> 
>     719                                 nr = HPAGE_PMD_NR;
>     720                         } else {
> --> 721                                 folio = page_folio(spage);
>                                                            ^^^^^
> the this will crash.
> 
>     722                                 nr = folio_nr_pages(folio);
>     723                         }
>     724 
>     725                         for (i = 0; i < nr && addr < args->end; i++) {
> 
> regards,
> dan carpenter

Thanks,
Balbir

