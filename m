Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BAC6106FD9A
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 08:47:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2B806B0005; Fri, 13 Mar 2026 04:47:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD8926B0088; Fri, 13 Mar 2026 04:47:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8FBB6B0089; Fri, 13 Mar 2026 04:47:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 94B4D6B0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 04:47:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3E91E8C578
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 08:47:37 +0000 (UTC)
X-FDA: 84540411354.24.AA34937
Received: from OS0P286CU010.outbound.protection.outlook.com (mail-japanwestazon11011046.outbound.protection.outlook.com [40.107.74.46])
	by imf21.hostedemail.com (Postfix) with ESMTP id B94601C0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 08:47:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bp.renesas.com header.s=selector1 header.b=LCzLg49u;
	spf=pass (imf21.hostedemail.com: domain of biju.das.jz@bp.renesas.com designates 40.107.74.46 as permitted sender) smtp.mailfrom=biju.das.jz@bp.renesas.com;
	dmarc=pass (policy=none) header.from=renesas.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773391654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LHtXRgAXSt5HcEnLoie2IZVYTRC/j2ouD3f+GYdZakE=;
	b=Rv7okmFiW435/XVuNW5yeJDyemxDKc9qwzURFYAQxw2amhnYaslkAnmUNEdgGzGlps2+sW
	3bBAogHhTYQiP3LWLj/rhlX8ZdxFzevca3M07D8rVkE8uTi5Ixd4OWVdZDzioTfaQ3jTor
	aIhpt+tZIg6rHpOAd68FeddSpi80AzY=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=bp.renesas.com header.s=selector1 header.b=LCzLg49u;
	spf=pass (imf21.hostedemail.com: domain of biju.das.jz@bp.renesas.com designates 40.107.74.46 as permitted sender) smtp.mailfrom=biju.das.jz@bp.renesas.com;
	dmarc=pass (policy=none) header.from=renesas.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773391654; a=rsa-sha256;
	cv=pass;
	b=YsPUa7ENOnML/pNdo8kxa5FM/2TVRBhuYA7GPy/YlBSySNPAEjgjb02/1xcFt5dlilJw7t
	oUsUMa7a7r4ra0E+vtWMPI1nFSDUL+FBASBHAyMKcx1SwS8guBsMFFUuH6rnM+asBnV1Op
	mS4E1cuj3e+g+fRj4jCGBVjaJLAZ5QY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S/LVoZXsDHrR6cF9JUNE0t9Peh5vVyKXbSWZuwSMTzixk/6uz/Fg4jk3X+cT2iCJYKjQJFCNQOONe9nO1wgxAeG8apn7K/W9sC0inSijiUCJFhclqAPecMnRUr/U7CKMNDaWKYlEXG1q0Yi9FayLwZiNgz6ZeamnvnlV14Pdu8dDR/UlkKz+SJJJyCkHwXGSWCMeVXWZktyWsZTuCHrdPfzRhipo0RWFOsN4Z/+Xr1jbzqfzrUxqERpV3Q80wOT/8wMCti1jUaGIoee0rg7OsvhSsGuW+EnlR5Hx3Kb4SGsN9y4FKMLIq5McnKUNV2RSG15037ezwbXeyyyxht6JtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LHtXRgAXSt5HcEnLoie2IZVYTRC/j2ouD3f+GYdZakE=;
 b=ODocDlHwNNeb+Q3UrKraTwGmH5VOzRnk/Qq3OKVSKas1jjGmogBs0ZH8y+mmT1NRD5MQwMN7dNxxBa12qAfFx7oxNqGCdlwupde0VaJ2pVVECdrToLWCzuvTOPkZyOdz386nwcr06zbWS3P80/l5dtqaBBAjvkKuSsPEQIytzf+XyH3wQ2r0yaKCwWCyoYSG/MSIeZ493LSGnmc50JWm+Qu5qECvcp65bKcRc1JgwTkVBvufRtN2EEPVY99VjblJzg8X2mX2b33dbevqashDjYmMIa04TYnaEooegnThXYfFS+kn078siQcP+hqLXl6VZlPpo1M2lN7EXwGclKAebw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LHtXRgAXSt5HcEnLoie2IZVYTRC/j2ouD3f+GYdZakE=;
 b=LCzLg49u2z+3SjXaeHYd5OwCXlsowaM2akpbjsDHRSC3phXJ7ebfqz0+/ngflYe3Dfi4uDkcRuFKdMvWwnMzALVGmRuUeJb0nlx6fD8zgeD/YwguC0iY3VYeHYIlNs+flrR3wMJmQIDHUlMp8dIoyOqNXLeyTLhhdIe+qa3SMnU=
Received: from TY3PR01MB11346.jpnprd01.prod.outlook.com (2603:1096:400:3d0::7)
 by TYRPR01MB13071.jpnprd01.prod.outlook.com (2603:1096:405:1ce::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.15; Fri, 13 Mar
 2026 08:47:04 +0000
Received: from TY3PR01MB11346.jpnprd01.prod.outlook.com
 ([fe80::87d1:4928:d55:97de]) by TY3PR01MB11346.jpnprd01.prod.outlook.com
 ([fe80::87d1:4928:d55:97de%4]) with mapi id 15.20.9700.015; Fri, 13 Mar 2026
 08:47:17 +0000
From: Biju Das <biju.das.jz@bp.renesas.com>
To: Thomas Zimmermann <tzimmermann@suse.de>, Tommaso Merciai
	<tommaso.merciai.xr@bp.renesas.com>
CC: "boris.brezillon@collabora.com" <boris.brezillon@collabora.com>,
	"loic.molinari@collabora.com" <loic.molinari@collabora.com>,
	"willy@infradead.org" <willy@infradead.org>, "frank.binns@imgtec.com"
	<frank.binns@imgtec.com>, "matt.coster@imgtec.com" <matt.coster@imgtec.com>,
	"maarten.lankhorst@linux.intel.com" <maarten.lankhorst@linux.intel.com>,
	"mripard@kernel.org" <mripard@kernel.org>, "airlied@gmail.com"
	<airlied@gmail.com>, "simona@ffwll.ch" <simona@ffwll.ch>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "dri-devel@lists.freedesktop.org"
	<dri-devel@lists.freedesktop.org>
Subject: RE: [PATCH v4 5/6] drm/gem-shmem: Track folio accessed/dirty status
 in mmap
Thread-Topic: [PATCH v4 5/6] drm/gem-shmem: Track folio accessed/dirty status
 in mmap
Thread-Index: AQHcp96eSUoAacjqcU2c+U96UWFVr7WrPdqAgAAB0YCAAPjHAIAAA3bg
Date: Fri, 13 Mar 2026 08:47:17 +0000
Message-ID:
 <TY3PR01MB11346BC4CA799C6435959FE0B8645A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
References: <20260227114509.165572-1-tzimmermann@suse.de>
 <20260227114509.165572-6-tzimmermann@suse.de> <abL5rcYIaFFO3GW2@tom-desktop>
 <TY3PR01MB113460CA616D3576DA0C3FC698644A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
 <d3818663-2673-4de4-b483-557602f6e8b9@suse.de>
In-Reply-To: <d3818663-2673-4de4-b483-557602f6e8b9@suse.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY3PR01MB11346:EE_|TYRPR01MB13071:EE_
x-ms-office365-filtering-correlation-id: 5d2c2056-b67c-4238-489e-08de80dd21d1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|1800799024|366016|376014|38070700021|18002099003|56012099003|22082099003;
x-microsoft-antispam-message-info:
 US3rYuHrwut+uRH9xjbR/ay0OyMTk31XOqMtoo7gzlGb3unsxcH89vz2SfdHALsCVEVZwgImjFBfenTuwhMceHGbJCnIx6/siDRbBrNqwpUyYbniviaBx8Zm6w/aaGMpjfmjt5FV7xC6jE5btUGBuaxGUF2FOE8qJPMkzr6LpHGVcIjUfwAgT8uU6NVliCrmj4YTQ67LjQkFfmprIwM+mM12005gZRDdqmi6kl1M7jz5X79PVG9v2AQTKTtBA4YLdRc3sJ+/dh7f8Cagl9s4wris/l2BLHCY7VqH8O6RoX5QyYv3p7bMxbiiR4cyoBfZoDpOr+aHGEa+2axvQQmdRlgk4e7lol2Nqo2N2Dm6Wk/4NkZvqEBq4hLtvFT9HcugV6CDF1n1/1A1PilEpat+0lHE/8pFvNRCXot9qqS/gh9fxItWv83hI3MyT+KNbendcwAtPs6HjgVuB94YybL5FxsaVS/478Y6oBQpOHHfpUfCRLaZN3BRW8k3fG9q9F+2qReOxYPh7BADVSDgLYgj7UBedbzngzlAEvGyaNIJ7D4xI6ZZ1swa7Rt6XduDxXuDACLX8n9dCnqSs17RqqNfdi/v7MUkAhEDBPK3hUxgKH0vys1/SVc2LX14mXand4eF8XTRv0tdOv25YLQp9gkt5zO4IwECO7KJvAvStGOhkwA5HXZ2c0Cnelge1pYQE7QOkH6ly4LApp5EsWvN3KrXPxUwOeV9pa6BlhbdZdWwADo=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY3PR01MB11346.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(38070700021)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Y2FZUGJqaG51YVYyR29DNW4yWlhYZHNTTmdya3hmbXlBbldyZ09VRjJJaUhv?=
 =?utf-8?B?NnFYcStrTTV0VWZ3ejZ6R1ZseWtseU5xejRTU1AwT3ozN0F0ZnNoK3VhNXcy?=
 =?utf-8?B?RkpVekVmL3lBR05XUlZPclZBM29zaElxVENKK25wZVNIdis0NC9lb2hXVXNS?=
 =?utf-8?B?ZUgxN3JtYTFjVXFLZ3BISUJwOWUyK3ZPTjdGSk9kbFZOWmRIajNjMjl2YTRj?=
 =?utf-8?B?czdUWFZoVmpQUURBNy8xS0NRR3JYZUtCT2hKQm9BdGZlK21KQzlDNElWRDl3?=
 =?utf-8?B?ZVZYMm1xbEtxNDVLZ21HOUUrVEVwbVN0U0NoTE95R1pzeC9LVUcxOG0vSHhw?=
 =?utf-8?B?RlhRU25Ea25DbHh6NVNSS3RaTzlkSnI3UDFXOFl6di84UjlkaE1zbXV3Ukk1?=
 =?utf-8?B?c3JMRW5GOGVZUndBaUZIZ2tqRVE2b0xJOWN6VWJwTE9pR3FpRkd3eXVEdm9D?=
 =?utf-8?B?SkxKazR1cHZnb3BYZUNvWmFMUVdNYm1aTDhFWm4vTkZxNHNEUGo5aXJNNWpL?=
 =?utf-8?B?ZFRCZDM0bUZKWDJkeFFxWmRramFsRDBKTmN4dUdhRUpIVStLOE5oMDM2Qzda?=
 =?utf-8?B?V0NsUWJOMXJZWjZySEh3VWZqT3EydmVrNDlwQlQyWmFNWkVWUFdGWmxLUy9l?=
 =?utf-8?B?dmNiMVdQR0tNMk03bVE4WFg2QVZJMTBSbks5SVcwT1FLdEdhN3RGb0RoYXNZ?=
 =?utf-8?B?S2pZVnBDSVRSL3d0QkxwMWVBL3JGMnVjdzRKT1VBaEZ3cFVHdzgzbE0xU0Js?=
 =?utf-8?B?M3lOVDNnZmNidGM2VVNRSjFMazE3c2NWV3R2blJzUTNTaGFyb3dmcm96eENC?=
 =?utf-8?B?U3NqRmhWaDJDUGJWa1BCMkZDOVAzZ3BPamZyMnF3cW8xOHJLMXg2VFNzVzlw?=
 =?utf-8?B?eUpnbXpTeC8xRmVzc3JVVEtKak5McmlPTm5tbzJVNFF0Sy9vUDFCaWtoVzA0?=
 =?utf-8?B?ZXBiRDJqd24vV0ZNZnZoZ3pmaDM2eCtxV0pEMG54aHRRNmN1QkZ5RGRFemM3?=
 =?utf-8?B?Rjk3RWhPdWRnSnZVWTlvTi9QZUVuU05pVElFZDhNbFV6emtUWi92S0hTdDZ0?=
 =?utf-8?B?M3JEVGpqQUtYeWRFZkdkYWxLWjMyaTRjN3lqVUJyZ2pDeEdQV3ZwMjMrbkRh?=
 =?utf-8?B?ak5BOW5YZWlobjdlQVF6bHYvaDJTMVFlbS9QeHQyRUYwTHMvZHlWdjhwWVVC?=
 =?utf-8?B?M203WmtoV3hpOTFIditXYnYrODBQKzJPYitpRStBazd2VmdsZyswdUhBS3VC?=
 =?utf-8?B?MlBpTWtUa2E2VWlMSXZoWHFram1JYXFjWXVwc0xJVzVjcjVEUnFDTE5GaDhG?=
 =?utf-8?B?YnVQMlB5T2pCT2tGcWtCS0V5a1ByVnRhVkpnbExkZEpUVmYwa1hxbm1SMjZp?=
 =?utf-8?B?ZmxPd0JnUWliaWtKVE5HTW5FYjhETkRSSkM0b1lXTFVxNU9qdkRuUXowcWMx?=
 =?utf-8?B?bzVoK0pzcHFrZDBRNEowdG5Qd0w0dkhDY05uT2w5dmdnUWR0UWpLRFJXazd2?=
 =?utf-8?B?OU5QY1Y4WDdqKzRxMEY3amI5Nmxxalo3TmNsM3h0N2R2QTNRUWVNNkI5bHlm?=
 =?utf-8?B?R0NtWWFldW10eHhqczdEQjh5amdFUWd4d3ZueFZNUjVZRURNVDVNem9EL0R4?=
 =?utf-8?B?SlZVaUZ6ZW1qZmdGVDNmTGplTER1WFdoUnkzWlcvNDZlNTNGT3k4QjFaS3kr?=
 =?utf-8?B?Vm9oTE1lSFdubndvMldEUEowd1Nid1UxR1hsRVM5L25nU0Y2ZUwxTUJhQlJQ?=
 =?utf-8?B?ZEx6M2ZXbVpNSjl1ckw0L3BiUUVpOGt2cHFWVHhDcFpyU0gxVkVMNkhPVXJQ?=
 =?utf-8?B?VzhUZ2xOZjRhWVB0NW01aUloWlFZKy9QVlJNSlJzM0N5MTAreG1aTy8rU1RP?=
 =?utf-8?B?ajgvQzlHbmJzVEZweFlqcmZ1QmZLMXVEUFYrd1BPbVFsTVE4TDI3dzd4K3hC?=
 =?utf-8?B?cU1DL1Y1bjRFVFBHU3B3ODdiNXJsNUMweTNiUWRGLzArdW52WkxIdTNpRWJP?=
 =?utf-8?B?a2JRQXFlVjFzNENDMTVpeDhpTWtzYmlhRVZJR1oyMGtNWElpMXhvdTU0Zito?=
 =?utf-8?B?cGJaZVgwWnZjaXBSVEdlNkhhVTRMbENrRmUwaDZZMkVUTk9XWDVzYWVSRU5w?=
 =?utf-8?B?MmJzZW81QlduMTZ2QWxvRXhWNzRpSTFKTVhIVlZJV1M4ZWN6V2xZVzI5cFg4?=
 =?utf-8?B?aWxrTmIxcEo1TlNsbWYrZG5ibXZEcGlnUGZ5OHQzLzFEK2xoQmlhbkx0Wm54?=
 =?utf-8?B?ZHV3U25tbU16bkYwNGJpNTRpeHZvbkFYMlRlYkUyVEIySk85elJuNlFxamhR?=
 =?utf-8?B?d2dpY0o2b1JLc2loWGtFa25kMTNpVU9yY3BkMWNnaDZoVE9EMzlFUT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY3PR01MB11346.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d2c2056-b67c-4238-489e-08de80dd21d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2026 08:47:17.6056
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ucx1L3m/ZGRzeo7MWTAUTZ8e49wjuSvpv0OgnnrnuKBkZTpK4sZ1hTYtIAJsbNf1LrlWJckG99BsV+lhnT34uAsnf3Ld5gg27lUMuujG1Tc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYRPR01MB13071
X-Rspamd-Queue-Id: B94601C0005
X-Stat-Signature: k1hng5eckef1derxxkruuyru6h1338db
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773391652-154400
X-HE-Meta: U2FsdGVkX18i6qITRp6lxZt0QcOUe4IGNCKbAXdsp0FLNvf9QSHsFkgkkcoqng6QyTYQthFH34kiyEPtbXJy4AuZMK74Fm6xzosJQW+fUjJ0lrPM3Tn1GcFwbNsyFA0myma6Mo9+ElfkvVIEdJN3BkeXfLL9wKpGeNg6hZqk3lVyD/LCBGeklBzqEQt1PBLONwOAVXrWYr/L6NMARp2pVQbdvKOnZxj5S00SvCIobstCdfUtvW7pPdU+Eyv/G3cCrWR1LwVZ0k4tmikmeFtgyg4N6fnr2dLXR9xNRvwVADM0ueMvbAkQtYx1M6YBMQ3PLNalXUx1jS1pE1ffw2itYnZ/pUYyNKeOShx7QeDT0aoF7ceXFqFY75xMzuy1eAycwR5ukn+2U502uPbkcHkCOV2SXYyYf/CqL/P8CM4RhBZVNIfgh28HGgqRnMsSKbh+sCNNzABJMBHiuMjUV8hRAmUPUots6uQi0aglq+zxIREz+1NSORdLabtjln0plyOPZjE65f49wUiU/HY/vuGEgh7TslGIT1JhrBdLSCskwXJL+uydMryNDmQtvd7a+zEDaeq4P9N95lO7gggrHX6brBLJz3thjpLpysyN58ZjFlMrqbhezMcCwpSzBi5iuQtH3SMTWUVhMx3RZNbVZaCOK3wyWXDF2F3TF0A2vqB8aWPyRDT/npfM/zq3Z/a6eMeOattf7xSCXYFNbrcLF7vHvZs4dwjVnLXvAxdZDk4ek1JEUq4hlfJ4oEGQsE98MZUESIRNIoLzUaZO8BBGlEafjUAc0H6DrmQyvM/EscI0pHy35Zho/vLP4GqDBZ59BrbHgZuvm54YlWbJTWcPI1ApOOPTmXyE0aQfWPoH/WcX1AKfUERtUJYPOILV6EWze7azkeWW5QOIcfPJILuj5QvmOlsPH6jztCr7QB+GDA9UewehwgYR/lLbFFOpt8BRFk/j2quiyrzjiJMtGUVLty+
 bvswIR9a
 9GVa3vcrjhVHiy71HuwffDI/zZNi4L5qqh1m8JBkjRByTjuAuITFnTrbRxt8mDWCOp7NJll0Sv9hKHIbTGrxxiWU9/zhIPNIzQd2Jqqa6k+OOlmYaRkUcva+UIaC0/8HbAssn6/0e/XEVR02Ss9BaelkKpMdtBx75bZMC7qsc2QE2KyX6ow0khnWg+hFwQHNM1S3PYI8p4vKKjKCYxFAawQ3MW9aqXxREmof08Nibr4GcLoibC58T2JUcXNdevwGeWrouiKdAMgxbrhk3bM3YqpIa0fV8RYoDLLMCp5SojEnqW0dPEnNcOe13mN7fK6q0vU1QL1IGo6yhjz7jYDpsUwB51T3ozjPNuwoIXCvcId51s9Uda0ayfi5zKK8Yy9emCAGn0wW2hYTaQZoACC9wgDBsvZC0oK6DM5sp5qk4ZdxUXVKGydWDvnJPLfS8FDsr0MCo8OVFNGvOK+6PwfemlkRlf5lu9I8afBtNSOmb+EKW9Mjayh4gfwdL44Zojvq4dcwAFcKq3O5w3Nvp55fdXCbLVTVCynkN7eJSfXuKnJTav1JWKbfTn/J62IgMYM59/2F7sdnWiOE2dK7MVX3tV6UHDmYbA0mrKiNPX8x/p37foFRf/N3Fz3x4Oi3O90ELBwUtZMKPJ8kgSlezIQro1NMziGFMQxP4VrIk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFRob21hcyBaaW1tZXJtYW5u
IDx0emltbWVybWFubkBzdXNlLmRlPg0KPiBTZW50OiAxMyBNYXJjaCAyMDI2IDA4OjM0DQo+IFN1
YmplY3Q6IFJlOiBbUEFUQ0ggdjQgNS82XSBkcm0vZ2VtLXNobWVtOiBUcmFjayBmb2xpbyBhY2Nl
c3NlZC9kaXJ0eSBzdGF0dXMgaW4gbW1hcA0KPiANCj4gSGkNCj4gDQo+IEFtIDEyLjAzLjI2IHVt
IDE4OjQ2IHNjaHJpZWIgQmlqdSBEYXM6DQo+ID4gSGkgVG9tbWFzbywNCj4gPg0KPiA+PiAtLS0t
LU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+PiBGcm9tOiBUb21tYXNvIE1lcmNpYWkgPHRvbW1h
c28ubWVyY2lhaS54ckBicC5yZW5lc2FzLmNvbT4NCj4gPj4gU2VudDogMTIgTWFyY2ggMjAyNiAx
NzozNw0KPiA+PiBTdWJqZWN0OiBSZTogW1BBVENIIHY0IDUvNl0gZHJtL2dlbS1zaG1lbTogVHJh
Y2sgZm9saW8gYWNjZXNzZWQvZGlydHkNCj4gPj4gc3RhdHVzIGluIG1tYXANCj4gPj4NCj4gPj4g
SGkgVGhvbWFzLA0KPiA+PiBUaGFua3MgZm9yIHlvdXIgcGF0Y2guDQo+ID4+DQo+ID4+IEknbSB3
b3JraW5nIG9uIERTSSBzdXBwb3J0IGZvciBSWi9HM0UgZnJvbSB0aGlzIG1vcm5pbmcgcmViYXNp
bmcgb24NCj4gPj4gdG9wIG9mIG5leHQtMjAyNjAzMTEgSSdtIHNlZWluZyB0aGF0IHdlc3RvbiBo
YW5nIG9uIG15IHNpZGU6DQo+ID4+DQo+ID4+IFJldmVydGluZyB0aGlzIHBhdGNoIGZpeCB0aGUg
aXNzdWUuDQo+ID4+IChnaXQgcmV2ZXJ0IDI4ZTM5MTgxNzlhYSkNCj4gDQo+IEp1c3QgYSBndWVz
cywgYnV0IG1heWJlIHZtX2ZpbGUgaXMgTlVMTC4gVGhlIGF0dGFjaGVkIHBhdGNoIHNob3VsZCBo
YW5kbGUgdGhpcy4gQ291bGQgZWl0aGVyIG9mIHlvdQ0KPiBwbGVhc2UgdGVzdD8NCg0KTm8gTHVj
ay4gSSB3aWxsIHRyeSB0byBlbmFibGUgc29tZSBwcmludCBpbiBwYW5mcm9zdCBkcml2ZXIuDQoN
Cm9vdEBzbWFyYy1yenYybDp+IyBzeXN0ZW1jdGwgc3RhdHVzIHdlc3Rvbg0KKiB3ZXN0b24uc2Vy
dmljZSAtIFdlc3RvbiwgYSBXYXlsYW5kIGNvbXBvc2l0b3IsIGFzIGEgc3lzdGVtIHNlcnZpY2UN
CiAgICAgTG9hZGVkOiBsb2FkZWQgKC91c3IvbGliL3N5c3RlbWQvc3lzdGVtL3dlc3Rvbi5zZXJ2
aWNlOyBlbmFibGVkOyBwcmVzZXQ6IGVuYWJsZWQpDQogICAgIEFjdGl2ZTogYWN0aXZlIChydW5u
aW5nKSBzaW5jZSBTYXQgMjAwMC0wMS0wMSAwMDowMDowNiBVVEM7IDU2cyBhZ28NClRyaWdnZXJl
ZEJ5OiAqIHdlc3Rvbi5zb2NrZXQNCiAgICAgICBEb2NzOiBtYW46d2VzdG9uKDEpDQogICAgICAg
ICAgICAgbWFuOndlc3Rvbi5pbmkoNSkNCiAgICAgICAgICAgICBodHRwOi8vd2F5bGFuZC5mcmVl
ZGVza3RvcC5vcmcvDQogICBNYWluIFBJRDogMjM4ICh3ZXN0b24pDQogICAgICBUYXNrczogMCAo
bGltaXQ6IDE3OTYpDQogICAgIE1lbW9yeTogMi40TSAocGVhazogMi45TSkNCiAgICAgICAgQ1BV
OiAxNDBtcw0KICAgICBDR3JvdXA6IC9zeXN0ZW0uc2xpY2Uvd2VzdG9uLnNlcnZpY2UNCiAgICAg
ICAgICAgICA+IDIzOCAvdXNyL2Jpbi93ZXN0b24gLS1tb2R1bGVzPXN5c3RlbWQtbm90aWZ5LnNv
DQoNCkphbiAwMSAwMDowMDowMSBzbWFyYy1yenYybCBzeXN0ZW1kWzFdOiBTdGFydGluZyBXZXN0
b24sIGEgV2F5bGFuZCBjb21wb3NpdG9yLCBhcyBhIHN5c3RlbSBzZXJ2aWNlLi4uDQpKYW4gMDEg
MDA6MDA6MDYgc21hcmMtcnp2Mmwgc3lzdGVtZFsxXTogU3RhcnRlZCBXZXN0b24sIGEgV2F5bGFu
ZCBjb21wb3NpdG9yLCBhcyBhIHN5c3RlbSBzZXJ2aWNlLg0Kcm9vdEBzbWFyYy1yenYybDp+Iw0K

