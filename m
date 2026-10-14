Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2A29CC6B27
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 08:16:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD16E6B008C; Wed, 14 Oct 2026 04:16:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA8876B0096; Wed, 14 Oct 2026 04:16:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B717B6B0099; Wed, 14 Oct 2026 04:16:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 82A676B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 04:16:52 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F3CD7C047C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:16:51 +0000 (UTC)
X-FDA: 85320525822.29.8E6E073
Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11022114.outbound.protection.outlook.com [52.101.126.114])
	by imf24.hostedemail.com (Postfix) with ESMTP id D3E1918000C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:16:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=transsion.com header.s=selector1 header.b=IoFLgMX8;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of qiwu.chen@transsion.com designates 52.101.126.114 as permitted sender) smtp.mailfrom=qiwu.chen@transsion.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791965809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=LiFKJMjs9PwYvrGGsCKmhkf8QouqgvpllfN7f2oix/Y=;
	b=yr8hYBaxQymT1ozNQClNCjIr3eP042bUTux+yNCZHv6n1sax9WixQmcgNHqHAbBtb98fRd
	h4v32tl9jmRUeqCyeEfYWLzx3JiAfxYwcKZqdkuSSS57v5dpFDR+D13aSNb9EOMqKH6WVd
	7agj7Je/2eryOaX7BrsTQLEghcj5xkQ=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=transsion.com header.s=selector1 header.b=IoFLgMX8;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of qiwu.chen@transsion.com designates 52.101.126.114 as permitted sender) smtp.mailfrom=qiwu.chen@transsion.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791965809;
	b=EzYSYI0mqyFRAdrsC++5xzEYzhwT+DvIZzkVPGJQAPqPtnvLD0kZM4ScvcgYK9Yt/odinB
	oX0WHrB9nh2t6yPMO/4CZcwno8h13q4MLGfJXMVdm9gNFY8fC+Wo2l/cg304Jt1qZyi1tl
	jZytWGI3T9KEp0EdxZirkc6cLeQfgME=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p6F1N/7+EQxR418KslpcypJDsmLK6JxeUvRNhO8PDQR+In71wVlK/R5T17DHSUCCTIpJksTyT+hF20Cpr5XYgNsZHyFepMFNoHfEb/svbVpwxcwGniHoAHS539pKPPrnxIOZXYENihgYy2V51lodlvV8iiy11znBu4Swh7/v4/XNcq0GmwyOkf8p7ha3hzUO+Pt8KtNA5+1KyoETVpBeORPdsv41Sn9uj++DoJlYxel7cqy3G9iNIPq4sh3rRXurFF2oy28xnINOtNiIe7Y9ZkzBPyArFqTET2G+sO4DZgbkBKtLFq0YFKxxRfdZPEvnP0iyixiG+M70WsYEq84osA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LiFKJMjs9PwYvrGGsCKmhkf8QouqgvpllfN7f2oix/Y=;
 b=ZJPCqff07kQzokFLNfwBe5OpTyJfJRIhtdjDaAFzwIdDBgKAlpHjgLcsJrGXpnw5BLg0y+++TUbU19+qWGLHSFMay5GWuEF5ZxyYFkLf4sKx6yotOobHc6vCPFzeIPnHeZiOjf/WiCQGj6U0cEK4Ypau9t5aOpferp9fOx610DDyD76Ao4fGMMI8GU8rQMXrdgrn2vqlz1/nUBwVrNZOayo/XfnsXLd0Znsr5GSFlrI6wM09mPQgmV2zkt4av/fcC1kPX4Hd8EZtevDzA4eu5XGfcZwZ8/GsFCO6yTpSZiSsXDEcG1UrxPyREIoaXCEdbSSV/8i7UcQkDv50Bq7QUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=transsion.com; dmarc=pass action=none
 header.from=transsion.com; dkim=pass header.d=transsion.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=transsion.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LiFKJMjs9PwYvrGGsCKmhkf8QouqgvpllfN7f2oix/Y=;
 b=IoFLgMX8kdS/slmuexpOZEAjmcMIwmmjZnZt8Shc8AtbmhGBOfhZdLVgMkHQvnffU3Fr4gXpKyN55pF7vwI/TN6oFylun6+cgnGL5pK4gPq9/XnXMF8rhj4c1o4e/K7ox0nIG817T8U3hDx+vXByR5xiLc7K8a087tvY6YpJvEQ=
Received: from SG2PR04MB5793.apcprd04.prod.outlook.com (2603:1096:4:1d8::12)
 by KU4PR04MB9366.apcprd04.prod.outlook.com (2603:1096:d10:7a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Wed, 14 Oct
 2026 08:16:42 +0000
Received: from SG2PR04MB5793.apcprd04.prod.outlook.com
 ([fe80::abf8:75eb:d156:fc91]) by SG2PR04MB5793.apcprd04.prod.outlook.com
 ([fe80::abf8:75eb:d156:fc91%5]) with mapi id 15.21.0522.012; Wed, 14 Oct 2026
 08:16:42 +0000
From: =?gb2312?B?cWl3dS5jaGVuKLPCxvTO5Ck=?= <qiwu.chen@transsion.com>
To: Matthew Wilcox <willy@infradead.org>
CC: "rostedt@goodmis.org" <rostedt@goodmis.org>, "mhiramat@kernel.org"
	<mhiramat@kernel.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"david@kernel.org" <david@kernel.org>, "mhocko@kernel.org"
	<mhocko@kernel.org>, "linux-trace-kernel@vger.kernel.org"
	<linux-trace-kernel@vger.kernel.org>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>
Subject: Re: [PATCH v3] mm: vmscan: rework lru_shrink and write_folio
 tracepoints
Thread-Topic: [PATCH v3] mm: vmscan: rework lru_shrink and write_folio
 tracepoints
Thread-Index: Ad1bjGLUp+Z+OGAwSZ+bI6WKkdz/jg==
Date: Wed, 14 Oct 2026 08:16:41 +0000
Message-ID:
 <SG2PR04MB57932F1499B14F729D3BF7BFE09D2@SG2PR04MB5793.apcprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SG2PR04MB5793:EE_|KU4PR04MB9366:EE_
x-ms-office365-filtering-correlation-id: 6b802093-db24-46b1-9883-08df29cb7a70
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|38070700021|56012099006|11063799006|261009223027099003|10067099003|18002099003;
x-microsoft-antispam-message-info:
 pVlZ/JJdXqJxlYIFyGojR9JuTLtYDHwjVTyUqR7Dd/zx4wec6eB8XD0Jj0G5kanhuKpq2/DdRBShcLCiFERHlXIpF8Mvw9a5Hn4yqBLpjyOZw9XwyK2sc8evw6wls6APCsjn5eC6hViPJx6jrHHS03OepiUaBls9JXT/YmpUsLxy7dtg2ENf1gG/W7KJcQT/3i2SyFDeEnpZJpHz3LwQE3DbzdhzwOVgAoJRN8vWOTpeAC4QX3JYGs2fqeDu2eAhfE5ttfzogbGvAEYxc0rYkH9DkWbT/w30X7nRapnHnqBF3Bv23VcJCwyIgDosNQlx/pt4ACzB2mlBbI72skl5vB4IIDG0/T0KzfGcdYmsKEGec6NQKkUCQLvHTPI+ihMBYet4hP2v+10Hs2rUW+d03lPss4SEYtdtl7rGHP7J7NH+mMRIEH9VclM/UsGo2EG96mHzz+5mlY7NApwmjjOSasCPbIWoxwW/kV/jEfcXyfyBtoxEF7f0O/yX2sCEv9C3nEaS5vvosbrrJQIJRWdCoTEevxEou8NpXghSMzDP1RR4tpoTXDmdoXjUwITlergoBb7Nav/8Lx/YGDalMBwu5LAq6qY4vbdhUJfVMH/6rMvkKuAAYf+QN+bycHkZnBkltba+1qamDst1Cfh2l7DdQkn69brUZlKWJ2mOa6DMEWA=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-cn;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR04MB5793.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(38070700021)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?gb2312?B?RG9EVU9HZ2RhSVdRekh4NU5hQUhybkNKQTdNT2g3RC9sY1lUWnR3elJEaElJ?=
 =?gb2312?B?a1RmY2h1UVhBVGJ2dVgybU5QbE50em1FbkluSnFpcUNLNkFSQVJIcG1LejM1?=
 =?gb2312?B?U3hqT0tKVGNTQis1YUVxSzZYemp3WTJuQ0paK2drNWcvYjMyQzczM1RIbkhY?=
 =?gb2312?B?eGNkeDdRRGY0RDRBdVIxUU83elVGVkNSVmhUWnRFN3B0RDZCZVpYam1YVWNO?=
 =?gb2312?B?SzNEM3RkUVVXYVl2MzRKRSswTjhWQnA3K1NJeFJ0RlhaMjcvVjBsdTdyekhw?=
 =?gb2312?B?bWlzZGhBS1BZR3BZYW5MeEJwSi9ZOHM3bXN5REp5ajNpUWc5ekVnYkVPZjlW?=
 =?gb2312?B?K0dwNmYwaVF4QktLTkt0VTFCc1NNMGlxeloxenErM1l5emVCY00yK0YxdVFu?=
 =?gb2312?B?RjhZQ3MxOWNkR1lSWkp1cUVrV1dhMm1BdDVUMGxTQVNsLytraTZ2WlEwOHpV?=
 =?gb2312?B?U2dqNEpsakF6NWVKaFNFNmswb1Uvc29zalpMVlBtUTNpTjM0SVd5dXlUNTRs?=
 =?gb2312?B?a0p2aitwSDUxeDNRODVMSXgvcVB1UTUrZ0d6QUZSelhMaGdJMDR1WmZMNEUy?=
 =?gb2312?B?WkV3WlpPK1NCUUcxZlczZm1RdTUzM2pZSkdmSVBwWEQzVFhhdlJCeWs1OGJB?=
 =?gb2312?B?Y1NESWNjeEg3TEhicE1SVk95RDYzVHFYc2NTTSs3NkxwT2lKVVZFMmlNTGpK?=
 =?gb2312?B?V2tNeFFEMjdQdU40MkdRbEV0UXkzcFdBMjBFVXc4ZGxKTm5oNGQrOC9YQ1d3?=
 =?gb2312?B?bXIyK3EyU3BLUExQYVhBaTMwTi9PZmZ3MS9tT2VvUkNxbGh3KzJFVjN6d1Z3?=
 =?gb2312?B?Q044YVZLZFlBVmZQcDFEZ3RHYVZiL0x3K0I3eElzb0pEWE83ZldWN1NkZFlE?=
 =?gb2312?B?b1B0WENRZTIrYUZGTXpuVlBaSndsbExkdlorK05VTkxjNit1WVhTazdZN1l6?=
 =?gb2312?B?MFJyYllFVEFMRTVuellZNHZkOUc1WFllMm41bFBkek5LdXB6UFlTQ2djaDZ4?=
 =?gb2312?B?QmhiVG9tMWFsTFovcXcyd0xYVGZiSHNjWWNCQ1hvM2ZPNERGWEhvUnZ4N3VJ?=
 =?gb2312?B?OS9IcXdrYm9QU2N0K2xmakw5L3VabTgvc2htbzNreUREbFlnL3VLWUJ0OUpM?=
 =?gb2312?B?MVM1eEMzK3NlbDBUMlNaSUgxakVVdFg1c2RYU3VJbUxuN1pjLys1WkxjMDdr?=
 =?gb2312?B?UGRhWW10K0JZTmtJZkJVVTduM1VOejJ2c2JGdXRzcGVRMklxaHhySEhJckhq?=
 =?gb2312?B?M1VxSmNMcFRPdmFDQUpGSDdrRU5iWE1pZmNkSUVBbnYrZ29mVDcvK2EvUlZp?=
 =?gb2312?B?ZGZzaTdNNEJ6Zkp1ejBjMVRTM0hROFZsbHZkaVlFdzJPZ3ZMNmxZOVhreFZ0?=
 =?gb2312?B?UlhJbTlCTUtlcndBMWp0cFJQU1BWSitxZHdDRVU0RjkzN2tUN1lXRjBOdThB?=
 =?gb2312?B?UUlpeG9CTForT1VVUzluNVFTbnpOK3EzRUNjU1dZTHNET09vVC9tU3MzSW1z?=
 =?gb2312?B?WXNrVVg4U3VUd1JvNmZrNTdEYzMvK1d1UzIxc3JmUmpjSHZVRyt4YnBpNkx1?=
 =?gb2312?B?QkFheHNyOXpGZjg0VDFCNTdydFU5RzdrSzRzT1dTSFdlV2VVaktvaWFRK3Nn?=
 =?gb2312?B?dTZQbW5DSnJTMHA1eVNPak1BbG1NY2w5cVpCN2JCamM4d3pkY3dYa0NkY0lN?=
 =?gb2312?B?Vlh0Wnczek1zbmxVMDJaRE9ONEtmK3JVNGdZTkZIc0FQTWdmaFU3cVF4aWdz?=
 =?gb2312?B?K2Fsa3FTNkJRUjRwNW1XazRZR2IyeFNDQkc2eGpSdDlsUzM0Q1l2Y0cyTVVE?=
 =?gb2312?B?eWc2UWV4aUxhaVlMRG5sdHRRdkh2Z0hPR0tqZnJGVG9RNGxWdFJkaUczdHp4?=
 =?gb2312?B?SDV1U2NHaVlJd05pSDI4RkF4Znp6RkFheGltOEcyQ1ZHMXNBM29WeXVPdFB3?=
 =?gb2312?B?V3pVUS9HQWZENzlobXJrYW1mY2ZtK0VJNmxFYWk5Wm8zT2tuSUkrS0RzY1Fr?=
 =?gb2312?B?NVRtZ1hKVVNQZjQrSk5wakF1R3VaSzdMU1ptQzQ5OFZ5bUNGY3UvRmxOK3Rr?=
 =?gb2312?B?QkUwYytOZ21Oam1qbWxrM0ZUWE9kS0xTaDhvL2RkTm5HaVpNT2dTZDUrVWJJ?=
 =?gb2312?B?QnRZRXZJSEFXR2hqdzd4azQ1WFp6U0MrK1JBcmxqU3U1OFJvc3N1NTJMaFNW?=
 =?gb2312?B?d1VaMCtXeUpmOHNwVkhTQk9PM2dYNXp5d0RwdGNUQXBMU3lEMWxmWGljUlJi?=
 =?gb2312?B?VUxuNzdwMnBpVGw0d3l1ZmZic2c2Q1lTRS9rVW91dEZwVk5hdmZjZ1ZPNVA3?=
 =?gb2312?B?Q1F0eWUrazhZS29oRkh3VkprQ244VGRWWWM4SVVKbFJsbjlvTURZZz09?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: transsion.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SG2PR04MB5793.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b802093-db24-46b1-9883-08df29cb7a70
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2026 08:16:41.8561
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 2e8503a6-2d01-4333-8e36-6ab7c8cd7ae2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wexUfAw3dcbtroeBWGIFyGAnfJJv+GkJI8qlhvcEZ9MfggD5nVhWP4/09Jmlv59wkYYss26oJ0K958RGj5DR0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KU4PR04MB9366
X-Stat-Signature: ggk8dbjq5ecq9fmhbedgn4k8x8zojrg7
X-Rspam-User: 
X-Rspamd-Queue-Id: D3E1918000C
X-Rspamd-Server: rspam08
X-HE-Tag: 1791965808-337126
X-HE-Meta: U2FsdGVkX18TtDXaJF+EiMK0lRDmobJeV03WRy0date7Ikl42IQLLaIta2LQt0VebrjgvWvPx6qErVu4hMYeLUI8DxDXo7tAUpMAEp8L2IALax0bzoGfWolR56ppY5JSnRGmVaTb6O9mSSudnj+G2LqQvOJrQvLKEeORvW39dZIvdbVnFrQdoTy2BYl34qq48+silwHIjfLw6fYdXxM0uoOafM+5OYZMa0Am5H+9xTGr5azaw0ARSp6+XQaOBZdx5NKN4FvqATmivKWtOdKBJgr84YNg2qr7KF81CQcfFiIGanr79rffB9yaMC7V4/XOMj3CwhCtNPesT4OT56/mvW1aCS9VEK+TcgN4/xZF/le3vRmXW4pOhpWf6uEOugCSaA53vFigLho4HQrV7TwvHzvli+r2xM8neLRQZp+z+cxSC9N70uJcWwr1ewa/l+LSG7H1ty3Y2R38EAz7emiMKIv1K3SQOxVpiIQGj+Trd8UeKlnIc5IWrpH60dRDaEDnGNV6Lyskwcfb4PELn8Ls6431ORM/nEyHnbSuNAJEMsif4pgtTTW40AySe9DYDekOtjSljfgQexOCqTapxuIUZ/ZxxIKhNBrh4LjCK524TKD+9+kLY+pYe8WMCnDFX0o1mXzjf+hCaxns2rzH1IAXIoPWqJFGHdntQhFp7GIR4zwbhI4qVZpwaK+Q/Ev0xZz5HD9DC6chqXmVw21qrACLn/aXNpO898J437UTIupY8vgNEGyvRUqUj/Q9D2FGpg5WuTU/V7BBseZI6V3JjAtfmt2MSspdT7OX+uxpIT39UcCmYW3n//tI4EwovJLcl+982wheiwCbMX52q5DDVZnfnW55FHSLm+rfmNo0YFjPQG0oYFimCQY/3672PivRF25UzINMOXZH+twv6adFoy8TTiLLVzoPEBN/mat7cOkQOzYigwIPJKvrmXTio6COVcUDRSfxuv+FOc4YuPnxlDD
 urNkH5zB
 dosS6Jy3A8jrGTkBFv2gFSqSJgogiuoDUzVQc0mThc561GQ3Vm2vCzP2b+WCiru+YvqpBs0Wbv5tq9OqR69/V5hXApfEPZGGweLEfXLAMNeTOKFm90B2uEw7nRxWaE+ROtWrqcAhu01peT4e7QbnjFyOOJhHpqh3E9qb3fhpkHAKrvuVg6dlnoYyYpdBelR7Oor8kiZb6HehuGd51jYa4aX8zno9JtUVJ55uCKWmoCfMJd/ZbYHNbNuL83Xx7ezJlCycRZ7CU6Uakm9F4o0uGZLBzEhNQj4oZDDC0dDGC8dZ/zL1WsTkN9n5D5h8MUgRw9OMFrFnjPmFLuHDiD5U5+8/Gb11BZVfTj/Cqk6FEEM0y41aDduAOO323lqCocMGzeBGiBfZJU1f4f0lqfglXK00ATcs9tdN1aqFslQsQbIxGQNWZWv0XO/ZbEHVqMgOvlBkijdeAZyC6LZCczOrXHHXET2i26O+SxwftrV2eYD+dDUj0hRQa8nANWeRM/EGsl1yjRCw3keczJkEmvJkj2CtjGCA8hzPavatNS/ualObQISKepF0vrFxs7VnWZ4iBRY3F48/PvfjH9cgxnC9qMJfi2u98y5uvMkl9lNfx60BsMCEeOE0Ha9ot00x0UAaaWk209BoZJHkHZDgrFtzrQ1uXpNlBuCkIab+j5X2VNLQujxjTrhAVWxKl9if6fN+5dpNiBwJ8pFfqelE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pg0KPiAtICAgICBUUF9wcmludGsoInBhZ2U9JXAgcGZuPTB4JWx4IGZsYWdzPSVzIiwNCj4gLSAg
ICAgICAgICAgICBwZm5fdG9fcGFnZShfX2VudHJ5LT5wZm4pLA0KPiAtICAgICAgICAgICAgIF9f
ZW50cnktPnBmbiwNCj4gLSAgICAgICAgICAgICBzaG93X3JlY2xhaW1fZmxhZ3MoX19lbnRyeS0+
cmVjbGFpbV9mbGFncykpDQo+ICsgICAgIFRQX3ByaW50aygiZm9saW89JXAgbHJ1PSVzIiwNCj4g
KyAgICAgICAgICAgICBfX2VudHJ5LT5mb2xpbywNCj4gKyAgICAgICAgICAgICBfX3ByaW50X3N5
bWJvbGljKF9fZW50cnktPmxydSwgTFJVX05BTUVTKSkNCj4gICk7DQoNCj4gV2h5IGlzIGl0IHVz
ZWZ1bCB0byBwcmludCBvdXQgdGhlIGZvbGlvIHBvaW50ZXI/ICBQcmludGluZyBvdXQgdGhlIFBG
TiBtYWRlIG1vcmUgc2Vuc2UgdG8gbWUuDQpUcmFja2luZyBhIGZvbGlvIHBvaW50ZXIgZ2l2ZXMg
ZGV2ZWxvcGVycyBhbiBpbW1lZGlhdGUsIHVuYW1iaWd1b3VzIHZpZXcgb2Ygd2hpY2ggbWVtb3J5
IG9iamVjdCBpcyBiZWluZyBzY2FubmVkIG9yIHJlY2xhaW1lZA0KYW5kIHdoZXJlIGl0IGxpdmVz
IGluIHRoZSBMUlUgbGlzdHMsIHJhdGhlciB0aGFuIGRlYWxpbmcgd2l0aCBwYWdlIGZyYW1lIG51
bWJlci4NCkFzIHlvdSBtZW50aW9uZWQgaW4gcGF0Y2ggdjE6IGh0dHBzOi8vbG9yZS5rZXJuZWwu
b3JnL2FsbC9hZmRCQ1dvcGtmRjJvdy1aQGNhc3Blci5pbmZyYWRlYWQub3JnLywNCnRoZSBvcmln
aW5hbCBjb2RlIGNob29zZXMgdG8gc2F2ZSB0aGUgcGZuLCBhbmQgdGhlbiBmb3JjaWJseSBjb252
ZXJ0cyBpdCBiYWNrIHRvIGEgcG9pbnRlciB2aWEgcGZuX3RvX3BhZ2UoKSBkdXJpbmcgcHJpbnRp
bmcuDQpUaGlzIGlzIGFuIHVubmVjZXNzYXJ5IGluZGlyZWN0aW9uIHRoYXQgYWRkcyBjb2RlIGNv
bXBsZXhpdHkgd2l0aG91dCBwcm92aWRpbmcgYW55IGV4dHJhIGJlbmVmaXQuDQpQcmludGluZyBv
dXQgdGhlIFBGTiBzdXJlbHkgcHJvdmlkZXMgYSBkaXJlY3QgdmlldyBvZiB0aGUgcGh5c2ljYWwg
YWRkcmVzcyBpbmZvcm1hdGlvbiwgaWYgcGZuIGlzIG5lZWRlZCwganVzdCBwcmludCBpdCBieSBm
b2xpb19wZm4oKQ0KYXMgc2hvd2VkIGJlbG93Og0KVFJBQ0VfRVZFTlQobW1fdm1zY2FuX3dyaXRl
X2ZvbGlvLA0KDQogICAgICAgIFRQX1BST1RPKHN0cnVjdCBmb2xpbyAqZm9saW8pLA0KDQogICAg
ICAgIFRQX0FSR1MoZm9saW8pLA0KDQogICAgICAgIFRQX1NUUlVDVF9fZW50cnkoDQogICAgICAg
ICAgICAgICAgX19maWVsZChzdHJ1Y3QgZm9saW8gKiwgZm9saW8pDQogICAgICAgICAgICAgICAg
X19maWVsZChpbnQsIGxydSkNCiAgICAgICAgKSwNCg0KICAgICAgICBUUF9mYXN0X2Fzc2lnbigN
CiAgICAgICAgICAgICAgICBfX2VudHJ5LT5mb2xpbyA9IGZvbGlvOw0KICAgICAgICAgICAgICAg
IF9fZW50cnktPmxydSA9IGZvbGlvX2xydV9saXN0KGZvbGlvKTsNCiAgICAgICAgKSwNCg0KICAg
ICAgICBUUF9wcmludGsoImZvbGlvPSVwIHBmbj09MHglbHggbHJ1PSVzIiwNCiAgICAgICAgICAg
ICAgICBfX2VudHJ5LT5mb2xpbywNCiAgICAgICAgICAgICAgICBmb2xpb19wZm4oX19lbnRyeS0+
Zm9saW8pLA0KICAgICAgICAgICAgICAgIF9fcHJpbnRfc3ltYm9saWMoX19lbnRyeS0+bHJ1LCBM
UlVfTkFNRVMpKQ0KKTsNCg==

