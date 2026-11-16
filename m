Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43A7C606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 08:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=n9wJ9V26
Received: by kanga.kvack.org (Postfix)
	id 6AE6E6B00EF; Mon, 16 Nov 2026 03:21:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65F406B05BB; Mon, 16 Nov 2026 03:21:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52CA66B00EF; Mon, 16 Nov 2026 03:21:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 24DCF6B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:21:00 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A7A0D408DA
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:20:59 +0000 (UTC)
X-FDA: 85440286638.09.41EB06A
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azolkn19012052.outbound.protection.outlook.com [52.103.10.52])
	by imf13.hostedemail.com (Postfix) with ESMTP id C40C020007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:20:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=outlook.com header.s=selector1 header.b=n9wJ9V26;
	spf=pass (imf13.hostedemail.com: domain of x-professor@outlook.com designates 52.103.10.52 as permitted sender) smtp.mailfrom=x-professor@outlook.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=outlook.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794817257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LV75gPEq/TFRQa8+5SqUEjip1P/9VCGH8F9Te3QlPIg=;
	b=nMl09crswMvBo2IN6wUOCyHVKlWQc82IkzK1rXA/yGSpIw9LR5+IR2sOlO4144dcGL6Ljj
	vLloY/zprZtpNUBTZc92bLA4zRnJrZKXSWXR6rMGm+V2gaMJnElKJd+I1rgCPTKar8NppN
	FBuFgKcJr957Y7K52CrkusobtrWCdSo=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794817257;
	b=Oi8xFpbpj4zktzDDLRsHB5MAKj1sj9NKPrB0QyDkqy1qH1PabRmszdKkzEoMJY2TTCcL5f
	zL6JOEKnDFBAUXMjXtY9e98rpBw70mH0HdoMIsJ+TjdOVUe8Qw/xoKpVRfVU5W59EniFEN
	s4fvYf8a7JpjiinYHtxr71cyaV89gS4=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=outlook.com header.s=selector1 header.b=n9wJ9V26;
	spf=pass (imf13.hostedemail.com: domain of x-professor@outlook.com designates 52.103.10.52 as permitted sender) smtp.mailfrom=x-professor@outlook.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QUI0gGm6crwXRsN9YpO6lt1h1EA5uO9dQKNRbj62jHub9wFNQ4+y9BdZqdftGzqejMu+6UhL7aMvvZBuNcrZ34I0KnaCdBarqADAVzYBZj+FovWXoMdQhAqn9NeZmrCZZqfburH3afdk51BwQP6ko7x+vKr0Vk65TZCkmpE8DSN4ffhW9dNTCGmI29aZibqAEJd8imneD5WRBjhkUktfkyGMRfYVwKZ53SQZxTNI7kJYNZJaw2ei5XZetO1M4zP71tqUDil2+OaNAZaC+r04/G719j/AgulkxTzWPq9xodrAq2KBPh7YuIfZ3EJgiBEvZ8wEDDwGdRxKvugjiblByw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=LV75gPEq/TFRQa8+5SqUEjip1P/9VCGH8F9Te3QlPIg=;
 b=OwwZ/dm7vRVMQK3y4p5coidWTqjtLt91fShGQKxCRTKkXuQnWUH+Le/UA06wAgjnp99L7yp3rX2iXWRBQ5ZvQhHvsgBO0JO/MBrkJyV6ZOw+AFfcuLEWITHEh/nj1F+eC+MIQhBkVlYxlp2XB3As/EKlV4SMNPxt/NvPVZ7JVNrhES3QvCKCHApAvuoj0SBCqkxJFc9rvuLXM/AXas5SE3QNyboxe6lmpN9YJk1lJQR3dVTyvwa1MM/pRaQe9x/q+VymguilAoYFcoEJZQl57/xSu35xRAPEXu/euAWogMlSF2rWA1i/ow9/yE1gjLncoMzM3JsLi6aZgvDyHdwf9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LV75gPEq/TFRQa8+5SqUEjip1P/9VCGH8F9Te3QlPIg=;
 b=n9wJ9V26ZLAKogD8Cuuir0e4cfljb2PzS/Ukc3zTzpgxm9FO8cJ+FCLj6t1hDdChzAj2J2BcV3CWvOygPr8+twYlF3N3MN0XQbAQdHwfXP/tq5YKWa/6ZJs8scgBqt3REFYwrhD6u9PM358HZEdfnlIqnbEuZZs2wnPqEbbNZj9VmcrkzmXF4TGtpaBxhXsrWol2h5xSD330sn0y/K3nH6CXJc8fQPKOxeW8b65jh8PxvvD8MLjhljnzBXx3dRhnkc7nCbtTHQLS5Jo8+TxhtOaRyL9/xZcmhfFrjHJ+LKu0NhhfvwTsBC3leif1wGc+lwndqbVKw+RvTG2Ob68W6w==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by PH0PR05MB7948.namprd05.prod.outlook.com
 (2603:10b6:510:75::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 08:20:51 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0615.013; Mon, 16 Nov 2026
 08:20:51 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "manfred@colorfullife.com" <manfred@colorfullife.com>, "legion@kernel.org"
	<legion@kernel.org>, "ebiederm@xmission.com" <ebiederm@xmission.com>,
	"vasily.averin@linux.dev" <vasily.averin@linux.dev>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "mkoutny@suse.com" <mkoutny@suse.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "alx@kernel.org" <alx@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org"
	<cgroups@vger.kernel.org>, "linux-api@vger.kernel.org"
	<linux-api@vger.kernel.org>, "linux-man@vger.kernel.org"
	<linux-man@vger.kernel.org>, "linux-hardening@vger.kernel.org"
	<linux-hardening@vger.kernel.org>, "shakeel.butt@linux.dev"
	<shakeel.butt@linux.dev>, "dave@stgolabs.net" <dave@stgolabs.net>
Subject: Re: [PATCH v5 0/3] ipc/sem: account dynamic sops arrays and validate
 SEMOPM
Thread-Topic: [PATCH v5 0/3] ipc/sem: account dynamic sops arrays and validate
 SEMOPM
Thread-Index: AQHdZ2LT/+5o4bKjo02vICQcsvNQYg==
Date: Mon, 16 Nov 2026 08:20:51 +0000
Message-ID:
 <179481695440.274194.12546320832881142047.semopm-andrew@outlook.com>
References: <cover.1793250194.git.x-professor@outlook.com>
 <20261115141206.920bdc8c5a84073712bb5c3b@linux-foundation.org>
In-Reply-To: <20261115141206.920bdc8c5a84073712bb5c3b@linux-foundation.org>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|PH0PR05MB7948:EE_
x-ms-office365-filtering-correlation-id: b9232794-801c-44d3-a651-08df43ba86c1
x-microsoft-antispam:
 BCL:0;ARA:14566002|22091999003|24121999003|15080799012|24021099003|11091999009|21061999006|38102599003|31061999003|8062599012|8060799015|12121999013|19110799012|4140399003|25010399006|102099032|3412199025|440099028|40105399003|53005399003|26121999007;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?C6pG2AgYRCzn9fF7EBX6yTv3okPOW9wguCmpOFW+A9HmIcJHCw5z/XRhvyHP?=
 =?us-ascii?Q?23oylwdVmZoXoPdQIjsh1yOzIHRBI3N05xM5C6TXxV72RTlJ2Va/I2Ov2pMB?=
 =?us-ascii?Q?ErGmYBK7tB1iwcRp6ffwCq04+zN0sFlA0nCZttqIIH+R+f0a0Hb1TGAcP3NV?=
 =?us-ascii?Q?EPBheFz8lni0l1FoHW9TbyVl4PxmVbOh2IxOGF2tNjIu+YxvKKmTHeJD4+hC?=
 =?us-ascii?Q?5hpI/3I33uyIcw19r+Ux2PSXzui+Gd6mhrZqwic4vAgonjUTV+WsONNDIJTu?=
 =?us-ascii?Q?lH5Ter5Bzm61tOZCg+2MVC9Clu0uc3S0mc02ARNvNG/tL6v3hzKCkbat+7Le?=
 =?us-ascii?Q?bBWV839Y+gCp1W16LNAnuM40mjsyabzygeBAr1908yujCCBORiwfYisnPhYU?=
 =?us-ascii?Q?aBAQvjZ8S+Jp2jfKiqNeDgpjmkOgBzJ8m+8ZCGq3m0Zze/hFpm6Th49ZG4HU?=
 =?us-ascii?Q?fo5R5WsLgk0HfR3XQduBsXecE64h0h4jzdoajLkmSYVB8KH7QWuSOLwPbfr7?=
 =?us-ascii?Q?X555zUf62rSHCP9ycIwnJKmDSkIfLUnbyG7MxdMmDFD0yPfgYVG9hHgC+ADb?=
 =?us-ascii?Q?ZH4cuWbCK30Z+Vql1sGcaf8Xrrj1Aaqpkqvbj1wOJSala89A4R/wfEG24Te4?=
 =?us-ascii?Q?nT9n/JmlDyYzefFvcAx6/RB4J/0FJ94dThfX5lOgTqqw055Wii0wSgVRA9zl?=
 =?us-ascii?Q?TnmMpR/IPSLc4OV1TMMVrNmvAuU4YraVBlCngj6JLqIhWJLGYrFCNOP85K2H?=
 =?us-ascii?Q?3jv7eVqDSu+79DcG3EK3ay8dW52Xo/Km50Mqk9JVQmiov2AjMYTQdvKonIi6?=
 =?us-ascii?Q?G/RtR+1zUa3Q9yR5Rit8BNYtxHXks14+i04+bQJpkpW0kba96rt1+wbaUO6B?=
 =?us-ascii?Q?TeLWAGgB7yrikAfmUyMK2xLmD/ruoK4F2QyJ42DndX8FHwCc+BHf5mp559dw?=
 =?us-ascii?Q?omwF7ylRrZP7HMYe3dkwX1k7DmAlD6aWrw279+XoQaBcplyeQZm+43pgUkSE?=
 =?us-ascii?Q?MboVa9/mI/pddaJ9aYt4gqs5nVWI5hHpdslZsqI8vEB7IkpAw5UrJvD5H15a?=
 =?us-ascii?Q?gxQVo3dzCAYBxt0/aQ45sCjXX2Q7Qvii/iBdxY1CE5ncNGGAsJ/rLArZLA2f?=
 =?us-ascii?Q?FTaADfzgglU77TPp0tsfyG8wU7UmfWzJst9t5RJTx8kf8UhoZVq+CH0=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?ACMExILoYiHqcisHxPKY///l26R2K/ZDCxEVBKdDA5iB0J/Zb+L1tNtGXKEY?=
 =?us-ascii?Q?QxQUqDj/OMjUJ82WBKSxw3mf6ynEn6WIl4qZyc22VQ/zjXDaWVkxiC7s+EYr?=
 =?us-ascii?Q?lK20/FOMH1jKoPoaYUlAP5eaa2PRxjxQb9XcFqrZCdCLcOVdPFO3/Vs/JCZD?=
 =?us-ascii?Q?PLboLTUCDehEFByBakwQyzWOt2w4PDQxQYH6QOjpl9sS6ReDiLMkNJNnqBhd?=
 =?us-ascii?Q?xJexYdxRK2jYM5jIZaVIaxKfH+LFaEaO2uRyJCfo0GGW+YIRzH80jmzgTdbq?=
 =?us-ascii?Q?xoqQzNR7E4OKm8zgTTpjAazRv+GukAaa9H2TAI9OzzmlsRfW/0RLxOchmFh8?=
 =?us-ascii?Q?mJRu4Kjah0kBVVNwKR7qGZ+Fd+w/HMu8QAAuqDbpIq3eBBZg3fcVq0lJGMRV?=
 =?us-ascii?Q?aKHP/O9S0E6NedKI9aDHg30tBs6rl+y2Bl6sW5C/houSEbriFb78aqAkeJA9?=
 =?us-ascii?Q?LZBPm40Et5mtwI51Zeqh4HFzk/ZEClsenIkZ/CTGQ1hSdFmuIVI5tRqIgMCy?=
 =?us-ascii?Q?UvTLXfEVI8WCK/ZLxt18RPjomwK/zV6AhxsupHh+uuDkF9VHVnx9SMvFp0/P?=
 =?us-ascii?Q?JCZJ5OirEzJ6p7BXvMCK/g5f6cDVCtvarHRlBzfL6z0yOUrx74L/JYMjQH7i?=
 =?us-ascii?Q?6j4SwebeGQ/+e7dgwe4gZaQUeaJprJUYdLqvFZiqbmpi6adbrYwFSwa8Rix2?=
 =?us-ascii?Q?RbBpWxAUoIdwOSxeMxGUu8Bo89xJi1Lp6lXx/iINH04PHqyZbZr4viRtixl7?=
 =?us-ascii?Q?LgdDH2ahzyRQglK8J/vFniAkeS2hXb1pt0pwpWgNCu7yMV4RkfED6peG+xBI?=
 =?us-ascii?Q?EqkUV2sXKH3QpiP4jkoeLGOwRxpe6qhOgaQc+lX+CL+fRfLtmewll/jWyF+S?=
 =?us-ascii?Q?WnRjsjK8eaLPptfd45ocpkJFHqcpo4liJldTyF7rZPd3hCJZtrcdOZLDCbib?=
 =?us-ascii?Q?C3taLtdGIs4240Aj2PXtsaUisEHwRxkRKKg0IL8Qyh/P1YAX6SqlwVIAavAY?=
 =?us-ascii?Q?srS2FfKVVBzKPtee8W1AATi2r7UJe8mbIos9Ba9UXEkEkwWdMBX77KptzWvr?=
 =?us-ascii?Q?cWv/GwGsr7A/QeXF47F7LVdQ52mf+p+VsLePoS6YuvyQVeQHDGPlZLWA1vdc?=
 =?us-ascii?Q?0IQHaKFHWOLXIIJxIeTyuPzuh9UTLAiw5trBWHhSGoTupoVQwa+jPSBEUCZJ?=
 =?us-ascii?Q?IbXUs7EY1oPcenjyVRwrPoq87jbO2c3MouXhw4J4W+bCweoTbDLUxf06TSTk?=
 =?us-ascii?Q?wFyBFbzB5+X1qiLpnllIRATm9Ys5SUTxx5S2kXh3i3BndeTZHyE7Z9AyShrt?=
 =?us-ascii?Q?lLo1qFsQgIf6jUedN/pp+SLiMpNhCYryJHZZGGlcFyvnpDdcn3u7OnFzrpiJ?=
 =?us-ascii?Q?MAWV9k+smi15DC37hhum1mIH1ZCc?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CF59DE4BDEA1B54DA6E9E3B47BB4259F@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR05MB10385.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: b9232794-801c-44d3-a651-08df43ba86c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2026 08:20:51.3612
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR05MB7948
X-Stat-Signature: fkdbppbcniwrzm13oix4oz3b9mkq185u
X-Rspamd-Queue-Id: C40C020007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794817256-219935
X-HE-Meta: U2FsdGVkX1/JzbNpxtaa6T1Y1m+Auu/vQZ1s7NYDt+Dws+JVdCwCdZXbfZ29ltqE7qOCn0NVch+SvRGXXP9IDCOEUqSFM+9UyuRExKtV2qjaesFYqkGuaf2w8tjsE6x7DLgjzsRNYoaLqmM6Xb22eZKNJauHuNHYp4e9ElEyV/Gomu/C+4URqJphX0jPeIqYnRHOBNlBORjEFTf8f6k4i5IQjy9DSFOpxpKshBmbYyxuv7IZwk7WecXQs9Z85iOurODu6fZS7vfcqHEABU40W0NsWFLiB4CG4eRj6Ya6VRlVkCZT46vAbKHv/HafaHdGa68oA1PTPTWNX/QWZt9XUTEPt6adXq8Qqh/e3DPTZwiF7Ux1SCXOR8LPYXmZ8dCiRM6VdD1NogxScwOxtZ7bRnNLLqbDNIbSSTKQ0ExNFMOf+k2RQaWLgGNLCZwISjSimDgBcEBEkdbv/PyagtrIBzlk3hqR8xQOIhFM5KR054SIs6/1wGpzOoHKjkr1rPmosZHYqMLTOivEZW75PkmPJSSYs4bQBdItFbryFCdG5nptDYogpySdtqjJRMMXUK90ed66E09S2964FLDG7lMcq94lbBQ6d6G9mjLU6zzBxkSojaYBTv0EmTW2xGKhrBinVWFV4SXBKCaNmvrsl+frOYQwAviQblW6uiQDy0X4Gi6vHjNIFzzMEzTmedfQyieMNvCKzkwVwOTTCgQ+HgTVkIXM4Qp1gaLu9px/rNCvZL3ct9wVu/nVCbEvqNp7dfaRtT2z8SE5WpuzO+DT887sQH5y4ZunG/P9bYPjMPvGLGXb7urVUO/7yezCAwoLQl4ZJ+hihbc1FNIdXiBuastG4DWHil39v6PWmJIrOl1ckiiW6cLrmF6S+o/HdBpGPK0ayjFPKq5XfH9GplbyvI4vysnk1iiADB41aGnPAemJOR08hpfsY+A3Br/jpa1R72+y+lWx5NeCX2ez4U0m7ko
 9wvr+Dge
 N5dVvHL3VYlYou9pVKkNJXzyftL11apfK3t4cXwGTsELmLdJeJdWrPqK+RzMeqh0CH28NcoyFDGSbH98Ys5YwGgWBMaRQmXBkihtWD984jdh/9lNaLfGSrdMBd/uoHaCCnPRQ2ambsz3YvzWHJvFN0OK4AM/Bhu2bIyBH1GxxBXWxSK5laLhFMP9ua777Rc6rZgsTh3HQBoxNOOeNePkhyDBsL3eAREEXM9pLGZuS8DVUA6sLoxh271DqgnGgfNHrBgaiifmulIod5ZPxerYYVRVl6MCoq1j82JS/6Ip5nvQny1VHyyfH9heMN69P744TNnLubnRcgH9RtGTCc6zvWYwV7WutD8L0gyq3wYb6I/JHO8LXFpNqZ5V4ROMRBrZbbBXETPNQzo3/B010ZxMFiNPHpSr/VvZSgls84Oy8f/ro36WoF/xSQpPjVTqpkYU3k7PG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Andrew,=0A=
=0A=
> I had LLM suggest a replacement [0/N].  wdyt?=0A=
=0A=
Looks good. One small clarification: in "The series does not impose a=0A=
maximum on positive SEMOPM values", please change "a maximum" to "a new=0A=
upper bound", since the existing INT_MAX bound still applies.=0A=
=0A=
> Please check these also.=0A=
=0A=
The additions to [1/3] and [2/3] both accurately describe the=0A=
user-visible consequences.=0A=
=0A=
Thanks,=0A=
Yingjie=0A=

