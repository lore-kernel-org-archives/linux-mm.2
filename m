Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEB8E606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 17:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=LcUw2dkr
Received: by kanga.kvack.org (Postfix)
	id CE28B6B0A94; Wed, 25 Nov 2026 12:59:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6C856B0A95; Wed, 25 Nov 2026 12:59:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0C136B0A96; Wed, 25 Nov 2026 12:59:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 76B016B0A94
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:59:04 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D2D83C1042
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:59:03 +0000 (UTC)
X-FDA: 85474402566.23.A5CE000
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013022.outbound.protection.outlook.com [40.93.196.22])
	by imf25.hostedemail.com (Postfix) with ESMTP id 97DD0A000C
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:59:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=LcUw2dkr;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf25.hostedemail.com: domain of shivankg@amd.com designates 40.93.196.22 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795629541;
	b=vCCBe8kQEVqDWzFncrI53H8nkSMjXWPotL6L8gt1tiiwyt6vrUnK+EpxfAtwduuALmigCc
	wGBo/EV9n4ZpXwA2j/phXFFRNNL0UnKoxLxWuKnVsJUklbi/SoPpAurMyuVwiL5bJrQrGZ
	toDICoLuBbl9dNV0jD4XFnb31xCuuvc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795629541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=80XGgFWnkqmBrF641Cz40GJKly1KhGjAF1+1mKd5+GI=;
	b=p7xLvEfEAxPwJsHM4OKcWRfLmhFsc1kVG0Tbz0fljBc3Jsf1Tdc3ubzBNw6zWalr6JcFi+
	Ba6Hf0q4ZhegXdxqKx18a1BZzP8iITgsBRwqsQgzAguARwNEvKdgA47tTqIAlwD/fXz/Bl
	3QVAaqacb1uB9kvx1ZJ7b7zfa2sAfow=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=LcUw2dkr;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf25.hostedemail.com: domain of shivankg@amd.com designates 40.93.196.22 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gMljYQC2FqnWSyr7DasNyAtfohNx++eLLn6GY/SLFnAj4iI8RGtkEoDOEtCpCBjukkfjWYRFyNv61jOJD61V/XgplYRQ0DncU5jUYRYJK6jl+5S07QLrmyv4pIxQAjPrLhTzGVUEflrWsXa5WoN/nvjN8wzQCgg84hAfcPU6kt4ujKv+ClbPXoGNXfHkQfGzlJL9LxX1owa/Gf0Jseh98bd7Pg8C/WqXcxzHClAmUuT7cf38NpcEcIbsjS98Nmh3VeC/ZfLD8btBlCWQB3Kyhq2JoPe8bk3ZysL+KIZ1M2soIo2haYU6lVChqBpajiazAHKWLu1niW2S7GomByWdLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=80XGgFWnkqmBrF641Cz40GJKly1KhGjAF1+1mKd5+GI=;
 b=uf5CFlcif2zHso8QbEx/ixqxEkn3Qi/d1KbZnu6yoOaSjBy1R691bWHupEUS7W2kytB3I21SYNFU3c1uKX/r7XODwp2c6nTcF0XWkhLaOWKWzqU5K9w88D1EMEeVxH51RxtEHeH6+GJC53gpYcaUvc4FaTZ+dhEk7sdQJmDzNcVc44AmuT/X+GhBCDQc6i2TJY6EZZfcGO+7iub2BJ2DOOz8SD0S6MH6ZbKbiigAg7z8zFFoCHHQ1MauvEqnIvSVB3gS3WveP8IjB1OfmMdcvGn/CS4Nbu1JxByxROqVhNAEqcqeahYaCRxgdC6a48rs2ShA4FHIAJAFE4gvC91VjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=80XGgFWnkqmBrF641Cz40GJKly1KhGjAF1+1mKd5+GI=;
 b=LcUw2dkrzMVgElYeibrxkhq6b4BwdWOIJVPs9QV9tSqe0wxhDgQYBZ9nPVXba+qnjnMthWbsuU8jB7OYMbTFNWHlGFxkEuJkhApv1L6cqJAdb4K1UCNwMvJyXObpRclNzNXf6oYoIxxSHZLclGAU/Q6+OB9rRmSrkZWB8aQTqSY=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by DM3PR12MB9389.namprd12.prod.outlook.com (2603:10b6:0:46::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.6; Wed, 25 Nov 2026 17:58:45 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%6]) with mapi id 15.21.0662.001; Wed, 25 Nov 2026
 17:58:45 +0000
From: "Garg, Shivank" <shivankg@amd.com>
To: "dev.jain@arm.com" <dev.jain@arm.com>, "chrisl@kernel.org"
	<chrisl@kernel.org>, "david@kernel.org" <david@kernel.org>, "ljs@kernel.org"
	<ljs@kernel.org>, "hughd@google.com" <hughd@google.com>, "kasong@tencent.com"
	<kasong@tencent.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "baohua@kernel.org" <baohua@kernel.org>, "rppt@kernel.org"
	<rppt@kernel.org>, "nphamcs@gmail.com" <nphamcs@gmail.com>,
	"shikemeng@huaweicloud.com" <shikemeng@huaweicloud.com>, "vbabka@kernel.org"
	<vbabka@kernel.org>, "harry@kernel.org" <harry@kernel.org>,
	"riel@surriel.com" <riel@surriel.com>, "anshuman.khandual@arm.com"
	<anshuman.khandual@arm.com>, "surenb@google.com" <surenb@google.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "youngjun.park@lge.com"
	<youngjun.park@lge.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"jannh@google.com" <jannh@google.com>, "liam@infradead.org"
	<liam@infradead.org>, "mhocko@suse.com" <mhocko@suse.com>,
	"lance.yang@linux.dev" <lance.yang@linux.dev>,
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
	"baoquan.he@linux.dev" <baoquan.he@linux.dev>, "pfalcato@suse.de"
	<pfalcato@suse.de>
Subject: Re: [PATCH v5 0/8] Optimize anonymous swapbacked large folio
 unmapping
Thread-Topic: [PATCH v5 0/8] Optimize anonymous swapbacked large folio
 unmapping
Thread-Index: AQHdfQadV05CbM2dUE+N91SB0PqcxQ==
Date: Wed, 25 Nov 2026 17:58:45 +0000
Message-ID: <3cee4b04dc7364321e1e8f8a98cfddd7f0082f03.camel@amd.com>
References: <20261123053543.295467-1-dev.jain@arm.com>
In-Reply-To: <20261123053543.295467-1-dev.jain@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5259:EE_|DM3PR12MB9389:EE_
x-ms-office365-filtering-correlation-id: df754997-b778-4b06-1b64-08df4b1dbffa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|376014|261026140227099003|261022105027099003|261022115727099003|10067099003|261026121527099003|261022075727099003|261021123027099003|261102123227099003|261021121427099003|261021135927099003|261028144727099003|261009223027099003|38070700021|22082099003|18002099003|56012099006|11063799006;
x-microsoft-antispam-message-info:
 BFA+ymuzge1dmfnuuiz4mmSrWG22fxc/xkBveW22i1UWe4RmqDPOZ3s8E1ybcBgcxLNab6H7sVeluy3HTsVewMpnjQXp0MTycFFKqxz3GPhhLxuU4kCWxJ60rBcx782PEmJjTrBtZxDo7GjAoEXeFAg0k4ZmIAavJp0adMKzKkxGg+ecMCu9enm9SyuQ7w0hsq51oBj5qgGpkwjNWegUg6NGkxrLBfhcO2NZldQofqeUIQnjkJIhbitYn0P7Af0jBdZWf0zERx6dMpiD5xJR1DwxrK1U1iVKT+V+rB/8f/lUS9qOHyyuMYRQCnpT+pMS1V2WFLjn26KE4XcikL3hQ+QL6at/qmdoJrlw12+hJwXxjDqRJ/V/Sj3qS6OIawecjU8uGgJHxq1Xw+RgFJI9k+1vdluPzr7wdhVd8apa380j0/1zQKBscYbl42vmJHbCHUTK31D0jvtixIP0XiFgCVH7ecb9rxqSc4PwdIriv4fir0GxcxFJZoaXn1I6vp4uyz0UP4VtXpdHe63UhRS1XQZpEKcGnHGhQBCKP9Nb8CzEgxfrZgc/3FTj1iu5CmVp46eMGSv+dMvWjTZaXkwWgvm4e+ZU0joxIOD7U/kgms80SwM44CZn2LyFJgNTyA86vLOYsFGTavot9+Wjx+xO4IZSfHDc7L+7X+MSCLcFu1I=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(376014)(261026140227099003)(261022105027099003)(261022115727099003)(10067099003)(261026121527099003)(261022075727099003)(261021123027099003)(261102123227099003)(261021121427099003)(261021135927099003)(261028144727099003)(261009223027099003)(38070700021)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VkU4c1ZuOFZkNWUxc1FXWXlsMUZjRjdPeTl1YlFDc0V0cDMrS0MvMzR5ZHdR?=
 =?utf-8?B?TDFwd2Q2TFdPelNEUUJZN0kvdmlsQ2ZDdGtTaDdWOG1sU2dad1VoTTJXYzZM?=
 =?utf-8?B?YTBuVkVFRVg4aDFwK2xiSld6ZUQ5YWxxZmgrMmI0VGNNUEgydDhPR3E3SUZS?=
 =?utf-8?B?cWcvMmhMb3FPRERqb0NCMEhBd3NyYmdqOFZVSk9Id2o4b3IzOW9ZSURrS0ZH?=
 =?utf-8?B?SUQ4azhYMlJxaG9naVkyYjdGMnUrTVBGWGRKNnJlWUZLUEN4UTQzempUZXVy?=
 =?utf-8?B?clRRcHY1UVVLcVRIL1VqOWRxNXFlWW9NZG9LdExIVzNYVllGcVZBOE1PL2g4?=
 =?utf-8?B?enNQa1VVUFdmRkNSUW90aU5TeWtuam8wS3ZvbnFNSXltOGNLQXVqRm1yRktt?=
 =?utf-8?B?TWs1V3VnM0k0anNFOWN3cTB6d1ptVk9uVCtidW13L0cwNGZ0R0d0S2NXWDd1?=
 =?utf-8?B?Tjk0Y1NkVEpZQ2ViU2NIRjJ0MHNuVmQ5RWlubXBiOUxpQXI5S29VOHpQWkYr?=
 =?utf-8?B?dnpHNFBZcHluQnVQL3E4SVNocDRJRnlsZTVqUklXZUhES1MxdGFnbXlwVmVx?=
 =?utf-8?B?azNEZ2FLdUZjMzE3ZWd4RXRHTjkwWk02YnJzcEhsWmF1dDRNRkNtZy8xVHhG?=
 =?utf-8?B?TER0eGlTL3MwelZMWHFRZXhqQ3g5TjQ4eFA5Z2krSkFERjIzMXRUZmtWRGVk?=
 =?utf-8?B?ZDEwTHNpNENyeDgxTFFseUF1b0xVWFVDZExEVFpHNHFmSHB1RUhYcHJ1Tlgr?=
 =?utf-8?B?UHpSaFh4RzBpT3E0dGNlYUtESTc4UXhKMXhPS2hBUWh1V2JTSkJPVFoxUW01?=
 =?utf-8?B?WjVuUHYzTVVBTkhDODY5c1R0eU1pWGREVE03d0FpVk5INEFJdkUrdmkvL2xq?=
 =?utf-8?B?Q2VFa3BoRjZaRGNoRkpjenZTQ2ZJZ3QvVjFwaGc0UFg0ZGE4dWs4ZnZPRk9o?=
 =?utf-8?B?QVFqTk43ZVRJUnI5ckFMS1dFMk5NeHBpRjJvR1Y4enRHM0J3djhWbC9EQkdn?=
 =?utf-8?B?aEpWME5PMW1GZTFrdERQNVNxcHhhTndvbGpOTXVUa0tEbHhTMHBiczN3aXIz?=
 =?utf-8?B?TlYyUk9vZitieTJ2eVArS2hVSm5GOEtQOVpaQURCQWszMmhsZktDL21zcXlv?=
 =?utf-8?B?S09IT2RSRFN0S0h4VU5weVpxSVlqY0hPcEVLQzhEaWZnc3NEdlpsSDJhMm4w?=
 =?utf-8?B?WTVtREFFVTV3eGQ4a3lkVGZ4OFB3bytJZlRmTUxuQmUxMEk3R1hqeUVmKyta?=
 =?utf-8?B?akNnN2Y1dzMyMzVsUGx1WTdsYWhzYUthdHI2NW53M2FtK0lNaDlGMEFTdTJ5?=
 =?utf-8?B?OFVQOGR1QXZIbGJVZlJWYjN5NXdxRktxckJsdEpmK1FwZUlPV0R0VWZMSmpw?=
 =?utf-8?B?bE4yeENPV0syc20yY1dDRlRTL0FrUUJSVWJzNWM2V0dNWHRua0tNYkx2akJR?=
 =?utf-8?B?OWR1U3RTNDF4TUNkY3NYTjFjbHY0UFpydDE0eWl3dXo4dnRFQkt5ZU1maGV3?=
 =?utf-8?B?enFQTkl1dXhjQ1pVendqQVNMb1lXalR3azJ6aTY1b1FUUHNJOUdqSGtXZVh1?=
 =?utf-8?B?NWlNR1ptSGZJSkFHTldKODF6YmtDVzRVSkIvam5lZjcvYUdnL0EwOTcxSldz?=
 =?utf-8?B?dUV2QkE5MUQ4RHFBNnc1MFVPanEveHR0Y0ZVejVsUUxHc1hrcmFvSW4yaGhi?=
 =?utf-8?B?Mk9GYjhwc00rQ2F3ZWFIMFdXSllXUnZMb0V2ZGhQcDNRNVNNOGpxRjFCYzRS?=
 =?utf-8?B?b1pqT1R3QXB2V3FIY3A3TTFORWNTUHQ2c202V0hsWXg1MFFNWmtFZWRYQm5X?=
 =?utf-8?B?QjdvWUJvQzJNYjVKUHVvc0UvT3EvNlNYaGcxT0xRbmVBRDdDU3puWG15UGVT?=
 =?utf-8?B?WXRFblJ6bGFOSHF4SjB4L3JrNVlMRkdtckNjSlpHMmxhRDBVLy9YcFJra05i?=
 =?utf-8?B?Y1V0d3ZnWlNmRHhMVmpxMDg5dEpmT2FxNHdhV1RmSDB0TzJZL1dXNjVFVzk3?=
 =?utf-8?B?TWErY3pyWEpHYXZUT3ovM0QyQkNDaG80Rmk2YWMwL1hXYjYzRHV3UzQ0SEcw?=
 =?utf-8?B?VlAxWTExQUt3bUNtWFZ4K245cGVRODhNd2JFeFpKbFdiNFFMVUlCT2RPWmpE?=
 =?utf-8?B?RHhoWTUrWCtmS1pRZm1DSzBESmZuRTdtKzQvdkNzRERjS2N1cjVJRDRPNVM4?=
 =?utf-8?B?dHpZcGg0djNGZXFWZWNEY2pOOTZVb28zVmExQm1salA1ODg4YnBJc1FOOEE0?=
 =?utf-8?B?c25hVlJ3b0w1UzFPN01FSEFYTUhxTXMxZWFaR1ZzUHhOUHJHUkh3M1ZmTmpV?=
 =?utf-8?B?NWxvbGN0RHBCUkR4Uyt1Z09UcVlGMHd5OEpqa0VGb2FiZXYrT1liZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <27056233A993784F8D976874B36E7B0F@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df754997-b778-4b06-1b64-08df4b1dbffa
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2026 17:58:45.6538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xXo2bXHmNsoBBWMjlLNNsKGN79L/hqQzeUWiGy1aqabO9wiPbgPpUhJ8BY/Ocszu/qiTgveJECrdNc524hUK/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9389
X-Stat-Signature: zobb8wuszp4yfe5kd4hjyke1ud8tnksf
X-Rspamd-Queue-Id: 97DD0A000C
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795629540-55788
X-HE-Meta: U2FsdGVkX1+smcSyLOlIxMP+hQklVr1S9QSRABR4bkHSZsOdJXfrBG6sdEbAChbve3t1HPYtZoQQoMZFyuk0U+MGwKmKlpMa4vdcuOg7ORxC+7JnNrIEFEvhkqNT+YZpeJmAkdkM5HP0EDw3rbWkd/4eGuAGhEja/KtiNfS1yycxfx6jGsV6wJh0/5UHpSJ4w870zHg/JAbHfBnTbBoVJHz0Hvs0jdNvgpVV6P90V0U+14T2ZpSi+BdfFCMMti54LtnWHTMvTAdABTbOj2rKD8aOswKo6Em3L/lNCx0pl/PBjtxKuRm0wwohYXMOdq8Dhkxu0OlY1MdwcrzZI6dMKZaIg1nO5LmAs3BSEcAuFZu1PIzee8mxLy6GwvX1s7ajo7ElEM6jiHbOuCB4i1zcLfWOUW2W9JCi5TdyVWouBK1H61970J3+6/SGwMnPIQv0M87+msJ7ovMj0aIDwVy9VOSd4DUqE/fGtcwfk6QJAfVtLTE+/ZCbos4FdvQZvdo+6OEUzLD33y6BqSKwULU64nVP6cBv8oUOHieyc59G8N3mdgFpecZu0I015MNlc0FGv81LhcrEOMvkrvGRC8ZBF0QOrNiYG7Zh8HN2docUf4woqQXQQcXL7nLKQlYO570ssQl6GjiFTbz4Byw3if493Ju/ooS++FI5CXjmiw+WiUdqjQ0PuTBRxcHwNxcuh1KrLMwpeP9RmCnyCWHYZwDEuA9qEWqP7BYdU9UMZyt2o1r5uNKRhwRRcefmtQ2olYK+/IrfPxT7b44fOJArB09ud+aC9jfDdPChYZh3lkHw2Z9ZzOM6TOlvxZRjNlyKHZu3/jZ6B/NRMlYdw5pXQwU2pB9U5xgEqMrlXuU0F396cpJmpROWSQQFw9T6i2qFlp8bKAMEvEriye32aa0Bdu7KmbbMLkkSvPRV+Qos+7DJlnzhf8NBuRIVP81eMjEXHKCv8Mytf2n/6ep4Ym44mbF
 sR7LZZZG
 N0XClVtGqjb/3Y5+yiN0bdchKkih7Mo7ZQYUo2NAMF9wVwnYzQW740WoNKyHaw5Dk0/l3XXT/Mq6LXvR4gl7hy+R3fDG6YmY6ZyE6p9N6ymYNKfZ/rbYTubWlfmfGPcnzUQNLKYUkzQ4Zr3Y2TVjPxrXfAV99v6ZYpQpaBVN2ZNIx1e3hFYc7lwlA+4iva9Y4auj4AKYcIcG1nYAZ1JY2h4upkrktHWzZ0ysLqbc6aQHqJSQKSdMhu5Sduhk11m59neOtp1gbL0THhGUCkIHaRD95zzhwCU6kOfGg619djVt0NjNMTGlvw6PkcxTqwQSzlRnSKITJFq78D8TQwV8B/igsa+IsLxTIpRXZGcFasbc7RNCc0kjgmoorfN8qLJ4OIVuUWrmeXtNAEzxiG3eDvpHcKKekfZ5kLPbtkbz5XY4eKeGA9ptkMV7nPXrm+z0BAqDPjn9alOiqsxqtYFOGjeD7XVJtJTiYtXTkxAwzQVVKZKTK4LcFAlL//Xm1EJnNBwX74MD3NBlTiyTp0usGRcy/2n7vJlPmQLSbosFiLF42LG5V1wAQRehzVdhXbprhPoNmuqDNVuKp4B0h3pGV/EEl+teO/ak4CAy0uaWREaMeyGPQaOZvlW2r0a4zHGks7jiqWKk21+eHrrGyDIYPZRJ3gxPGCGFb7BaG3Ys5ob/WQqhw7yCz2C/m7fAqGHSWsCnREVsdbUpN9XzuWgV0QGAhwvq2KDTSRGlO+AcJEny3rwxXolELXR8cFARn+I7I6c+epSRRyP0ipj1+pTot/vzbW7j6SIjTzQUrAV8Be/6Mw9oFK0LEfgxjfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

T24gTW9uLCAyMDI2LTExLTIzIGF0IDA1OjM1ICswMDAwLCBEZXYgSmFpbiB3cm90ZToNCj4gU3Bl
ZWQgdXAgdW5tYXBwaW5nIG9mIGFub255bW91cyBzd2FwYmFja2VkIGxhcmdlIGZvbGlvcyBieSBj
bGVhcmluZw0KPiB0aGUgcHRlcywgYW5kIHNldHRpbmcgc3dhcCBwdGVzLCBpbiBvbmUgZ28uDQo+
IA0KPiBUaGUgZm9sbG93aW5nIGJlbmNobWFyayAoc3RvbGVuIGZyb20gQmFycnkpIGlzIHVzZWQg
dG8gbWVhc3VyZSB0aGUNCj4gdGltZSB0YWtlbiB0byBzd2Fwb3V0IDI1Nk0gd29ydGggb2YgbWVt
b3J5IGJhY2tlZCBieSA2NEsgbGFyZ2UgZm9saW9zOg0KPiANCj4gICNkZWZpbmUgX0dOVV9TT1VS
Q0UNCj4gICNpbmNsdWRlIDxzdGRpby5oPg0KPiAgI2luY2x1ZGUgPHN0ZGxpYi5oPg0KPiAgI2lu
Y2x1ZGUgPHN5cy9tbWFuLmg+DQo+ICAjaW5jbHVkZSA8c3RyaW5nLmg+DQo+ICAjaW5jbHVkZSA8
dGltZS5oPg0KPiAgI2luY2x1ZGUgPHVuaXN0ZC5oPg0KPiAgI2luY2x1ZGUgPGVycm5vLmg+DQo+
IA0KPiAgI2RlZmluZSBTSVpFX01CIDI1Ng0KPiAgI2RlZmluZSBTSVpFX0JZVEVTIChTSVpFX01C
ICogMTAyNCAqIDEwMjQpDQo+IA0KPiAgaW50IG1haW4oKSB7DQo+ICAgICAgdm9pZCAqYWRkciA9
IG1tYXAoTlVMTCwgU0laRV9CWVRFUywgUFJPVF9SRUFEIHwgUFJPVF9XUklURSwNCj4gICAgICAg
ICAgICAgICAgICAgICAgICBNQVBfUFJJVkFURSB8IE1BUF9BTk9OWU1PVVMsIC0xLCAwKTsNCj4g
ICAgICBpZiAoYWRkciA9PSBNQVBfRkFJTEVEKSB7DQo+ICAgICAgICAgIHBlcnJvcigibW1hcCBm
YWlsZWQiKTsNCj4gICAgICAgICAgcmV0dXJuIDE7DQo+ICAgICAgfQ0KPiANCj4gICAgICBtZW1z
ZXQoYWRkciwgMCwgU0laRV9CWVRFUyk7DQo+IA0KPiAgICAgIHN0cnVjdCB0aW1lc3BlYyBzdGFy
dCwgZW5kOw0KPiAgICAgIGNsb2NrX2dldHRpbWUoQ0xPQ0tfTU9OT1RPTklDLCAmc3RhcnQpOw0K
PiANCj4gICAgICBpZiAobWFkdmlzZShhZGRyLCBTSVpFX0JZVEVTLCBNQURWX1BBR0VPVVQpICE9
IDApIHsNCj4gICAgICAgICAgcGVycm9yKCJtYWR2aXNlKE1BRFZfUEFHRU9VVCkgZmFpbGVkIik7
DQo+ICAgICAgICAgIG11bm1hcChhZGRyLCBTSVpFX0JZVEVTKTsNCj4gICAgICAgICAgcmV0dXJu
IDE7DQo+ICAgICAgfQ0KPiANCj4gICAgICBjbG9ja19nZXR0aW1lKENMT0NLX01PTk9UT05JQywg
JmVuZCk7DQo+IA0KPiAgICAgIGxvbmcgZHVyYXRpb25fbnMgPSAoZW5kLnR2X3NlYyAtIHN0YXJ0
LnR2X3NlYykgKiAxZTkgKw0KPiAgICAgICAgICAgICAgICAgICAgICAgICAoZW5kLnR2X25zZWMg
LSBzdGFydC50dl9uc2VjKTsNCj4gICAgICBwcmludGYoIm1hZHZpc2UoTUFEVl9QQUdFT1VUKSB0
b29rICVsZCBucyAoJS4zZiBtcylcbiIsDQo+ICAgICAgICAgICAgIGR1cmF0aW9uX25zLCBkdXJh
dGlvbl9ucyAvIDFlNik7DQo+IA0KPiAgICAgIG11bm1hcChhZGRyLCBTSVpFX0JZVEVTKTsNCj4g
ICAgICByZXR1cm4gMDsNCj4gIH0NCj4gDQo+IFBlcmZvcm1hbmNlIGFzIG1lYXN1cmVkIG9uIGEg
TGludXggVk0gb24gQXBwbGUgTTMgKGFybTY0KToNCj4gDQo+IFZhbmlsbGEgLSBNZWFuOiAzNzQw
MTkxMyBucywgc3RkIGRldjogMTIlDQo+IFBhdGNoZWQgLSBNZWFuOiAxNzQyMDI4MiBucywgc3Rk
IGRldjogMTElDQo+IA0KPiByZXN1bHRpbmcgaW4gbW9yZSB0aGFuIDJ4IHNwZWVkdXAuDQo+IA0K
PiBObyByZWdyZXNzaW9uIG9ic2VydmVkIG9uIDRLIGZvbGlvcy4NCj4gDQo+IFBlcmZvcm1hbmNl
IGFzIG1lYXN1cmVkIG9uIGJhcmUgbWV0YWwgeDg2Og0KPiANCj4gVmFuaWxsYSAtIG1lYW46IDU0
OTg2Mjg2IG5zLCBzdGQgZGV2OiAxLjUlDQo+IFBhdGNoZWQgLSBtZWFuOiA1MTkzMDc5NSBucywg
c3RkIGRldjogMyUNCj4gDQo+IEkgdHJpZWQgbWFnbmlmeWluZyB0aGUgZGlmZmVyZW5jZSBvbiB4
ODYgYnkgdXNpbmcgMU0gbGFyZ2UgZm9saW9zLCBidXQNCj4gY2FuJ3Qgc3BvdCBhbiBvYnZpb3Vz
IGltcHJvdmVtZW50IChsb29rcyBsaWtlIG15IHN5c3RlbSBpcyB0b28gZmFzdCB0bw0KPiBiZW5l
Zml0IGZyb20gYmF0Y2hlZCBhdG9taWMgb3BlcmF0aW9ucyEpLCBoaW50aW5nIHRoYXQgdGhlIGJl
bmVmaXQgbGllcw0KPiBtYWlubHkgaW4gdGhlIHJlZHVjdGlvbiBvZiBwdGVwX2dldCgpIGNhbGxz
IGFuZCB0aGUgcmVkdWN0aW9uIG9mIFRMQg0KPiBmbHVzaGVzIGR1cmluZyBjb250cHRlLXVuZm9s
ZGluZywgb24gYXJtNjQuDQo+IA0KPiBObyByZWdyZXNzaW9uIGlzIG9ic2VydmVkIG9uIDRLIGZv
bGlvcyBvbiB4ODYgdG9vLg0KDQoNCkkgcmFuIHRoaXMgb24gYmFyZS1tZXRhbCBBTUQgRVBZQyBa
ZW41ICgyIHNvY2tldHMpDQpzd2FwcGluZyB0byB6cmFtLCBNQURWX1BBR0VPVVQgb2YgMjU2TWlC
LCB3aXRoDQp6ZXJvLWZpbGxlZCBhbmQgd2l0aCBub24temVybyBkYXRhLg0KDQpNZWFuIG9mIDIw
IHJ1bnMsIChpbiBtcyk6DQoNCm10aHAgICAgICAgIGJhc2UgICAgIHY1ICAgICAgZGVsdGEgICAg
ICAgYmFzZSAgICAgdjUgICAgICBkZWx0YQ0KICAgICAgICAgICAgemVybyAgICAgemVybyAgICAg
ICAgICAgICAgICBkYXRhICAgICBkYXRhDQogIDRLICAgICAgICA2My42ICAgICA2MS4xICAgIG5v
aXNlICAgICAgIDEyOC4xICAgIDEyNi4yICAgbm9pc2UNCiAgMTZLICAgICAgIDM3LjEgICAgIDMy
LjYgICAgLTEyJSAgICAgICAgIDkzLjMgICAgIDg5LjIgICAtNCUNCiAgNjRLICAgICAgIDI3LjMg
ICAgIDIxLjggICAgLTIwJSAgICAgICAgIDc0LjUgICAgIDY4LjggICAtOCUNCiAgMjU2SyAgICAg
IDIzLjQgICAgIDE0LjkgICAgLTM2JSAgICAgICAgIDcwLjkgICAgIDYyLjUgICAtMTIlDQogIDFN
ICAgICAgICAyMy4yICAgICAxNC42ICAgIC0zNyUgICAgICAgICA2OS40ICAgICA2MC40ICAgLTEz
JQ0KDQoNCkknbSBzZWVpbmcgZ29vZCBpbXByb3ZlbWVudHMgd2l0aCB0aGlzIHNlcmllcyBvbiB4
ODYgOikNCg0KQ2FuIHlvdSBjaGVjayB3aXRoIHZtc3RhdCBvbiB3aGF0J3MgaGFwcGVuaW5nIG9u
IHlvdXIgc3lzdGVtPw0KDQpGdW5jdGlvbmFsbHksIG15IHN3YXAvbWlncmF0aW9uIHN0cmVzcyBz
dWl0ZSBhbmQgY29uY3VycmVudCByYWNlIHRlc3QNCnBhc3Mgb24gWmVuNSBhbmQgaW4gYSBLQVNB
TiArIFBBR0VfVEFCTEVfQ0hFQ0sgVk0gd2l0aCBubyB3YXJuaW5ncywgYW5kDQp0aGUgbW0gc2Vs
ZnRlc3RzIHBhc3Mgd2l0aCB0aGlzLg0KDQpUaGUgb25seSBkaWZmZXJlbmNlIEkgc2VlIGlzIHNv
ZnQtZGlydHk6DQp3aXRoIHBhdGNoIDgsIHN3cF9wdGVfcHJlcGFyZSgpIHRha2VzIHNvZnQtZGly
dHkgZnJvbSB0aGUgUFRFIHJldHVybmVkIGJ5DQpnZXRfYW5kX2NsZWFyX3B0ZXMoKSwgd2hpY2gg
bWVyZ2VzIHRoZSBkaXJ0eSBiaXRzIHdpdGggcHRlX21rZGlydHkoKQ0KYW5kIHNvIGFsc28gc2V0
cyBzb2Z0LWRpcnR5IG9uIHg4Ni4NCg0KQWZ0ZXIgY2xlYXJfcmVmcyBhbmQgTUFEVl9QQUdFT1VU
LCA4MTkyIG9mIDEwOTIyIHVud3JpdHRlbiBwYWdlcyBpbiA2NE1pQg0KYXJlIHJlcG9ydGVkIHNv
ZnQtZGlydHkgd2l0aCAxNksgbVRIUCAoMTA4ODAgd2l0aCAxTSksIHdoZXJlIGJhc2UgcmVwb3J0
cw0Kbm9uZS4gbXByb3RlY3QoKSBvdmVyLWluZGljYXRlcyB0aGUgc2FtZSB3YXkgdXBzdHJlYW0s
IGFuZCBEYXZpZCBzYWlkIHRoYXQNCmlzIGZpbmUgWzFdLCBzbyBJIGRvbid0IGhhdmUgYW55IGNv
bmNlcm4gb24gdGhpcy4NCg0KWzFdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8zODBlMDI5
YS0yZDlhLTQzZWUtOTA0OC1jNGI0OTBjMTFmNDFAa2VybmVsLm9yZw0KDQpUZXN0ZWQtYnk6IFNo
aXZhbmsgR2FyZyA8c2hpdmFua2dAYW1kLmNvbT4NCg0KVGhhbmtzLA0KU2hpdmFuaw0KDQoNCg==

