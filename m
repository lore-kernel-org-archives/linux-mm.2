Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59A03606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 04:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=iRANH9bW
Received: by kanga.kvack.org (Postfix)
	id 708296B05B0; Sun, 22 Nov 2026 23:45:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B8C56B05B1; Sun, 22 Nov 2026 23:45:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 580BA6B05B2; Sun, 22 Nov 2026 23:45:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2CED96B05B0
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 23:45:03 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A8D0A1407C2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:45:02 +0000 (UTC)
X-FDA: 85465144044.06.6F7526D
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013058.outbound.protection.outlook.com [40.107.201.58])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7E11B160005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:44:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=iRANH9bW;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf08.hostedemail.com: domain of shivankg@amd.com designates 40.107.201.58 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795409099;
	b=H2TIdflGe4zIGsfXw4NutTk6/ucoeNUHcG+GRYSvqL/WIePh3lqSyqUThoHYHOY9RYrMV5
	SEw2jQ5NW14xIa65DhxIpWFBJi4nGnys15V+vXaSAxuezPWIxPSFidDmgPHeXA/2uNl6n5
	zM60lUBoW2lRMRr7YCEBzHnp9iKas8k=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795409099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uqkfB/NenOq8/EaFm7kKyAa/8vbe/38K/aTM2Ksj1c8=;
	b=rs7KdFwDr1ojZlCSHFuhqdc4tQ5/S/wHgxwjA8qVrhhZBuLJ4Is6yJN3vbZJYh4dphygxf
	nIWmymnXxfUsphcPOqfLCVbHyadoSpkCO6xZRrkm/fAHsD4DZqbtr3x4CMrbwd/3cWz4wu
	aK0eDHY5Po3o7NntxTH2XNGgWrqE4Vw=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=iRANH9bW;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf08.hostedemail.com: domain of shivankg@amd.com designates 40.107.201.58 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yhaiSTHTtqhg9X5lVsC+gf/+NFHWaPlALMt7Gm9/G0BUCdl1B3GRmHAjat4b+Hd5esaV1T37DoVSOEmtMWUDxVt9qxYTs4vPfQxtGsCz0Vlx5XRL8HoXg7GTzaCPHYv6cYSzupoces4YXS1b79SXKouwGO6dkFBKycu96U7emNKXSu4zHbp+aOCuJ/gpbKpGkmioUfK96pckxBzcWPdu6U2r1v+YziVUlRkCU/OMQ7yGKkQEnTmZcr+clK6wL0Kuqzf8Qqjx1kpyfvZRLq399JHxatuH3tBg7A3CveFtPJvWHDXoQok6MSlUO50onpQHuGbRCPMjoYzweI4n0fTflg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uqkfB/NenOq8/EaFm7kKyAa/8vbe/38K/aTM2Ksj1c8=;
 b=okLF/ZPjm8AnRcmxtZNFm3iEuhA/l+/bWku5aVfyfa9er9RxOFBEdPbSa7rJu9EOOhc6JEd4VGHYwnVdcpQXbz4qc/tjCG6Z3+Q+WbWIcR+FpQB4L5MG4grxpgYKNZ24Ml0Arf8kNtqyWmMRxBrFv3iras1/I5jSP46txJimyKtvUvevsThiuM03lL4lpnkjulZ+xaL9ejgR37skZ6zWX0ttS6Y6tZBlbnlEPS/ZG7z+tEUQulUJdKQdignR5rq80AIEJFNTMN+43IsT7y9IyVUNORWhriWpR3GGTWm0QkiDHYY/ZvCCUEkn3YnPK+joyJp6BbL9XBRJ5SA++j9eug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uqkfB/NenOq8/EaFm7kKyAa/8vbe/38K/aTM2Ksj1c8=;
 b=iRANH9bW7KC4CQ6JWDGH4yqPuNvD89nK7rS3pMn5XF7SA85EFE+dbEJ/0eZpfCy5zTGd/v9SBxaGfIPigpnyzjoTBaeFleYzaxC6+vva6uzEV50V4lPpmNVHLtQpqBB8ij3so1e4IDxh18cnUNMHnQfk6NRBVS45KedXNQX1rPQ=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by MW4PR12MB7143.namprd12.prod.outlook.com (2603:10b6:303:222::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Mon, 23 Nov
 2026 04:44:52 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%6]) with mapi id 15.21.0615.013; Mon, 23 Nov 2026
 04:44:51 +0000
From: "Garg, Shivank" <shivankg@amd.com>
To: "david@kernel.org" <david@kernel.org>, "nilayvaish@google.com"
	<nilayvaish@google.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>
CC: "luizcap@redhat.com" <luizcap@redhat.com>, "mhocko@suse.com"
	<mhocko@suse.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"surenb@google.com" <surenb@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "rppt@kernel.org" <rppt@kernel.org>,
	"vbabka@kernel.org" <vbabka@kernel.org>, "liam@infradead.org"
	<liam@infradead.org>
Subject: Re: [PATCH] mm/util: fix off-by-one in snapshot_page() retry check
Thread-Topic: [PATCH] mm/util: fix off-by-one in snapshot_page() retry check
Thread-Index: AQHdewDWqr8xafG5eEWXyaOUp7UMwbc7FL0A
Date: Mon, 23 Nov 2026 04:44:51 +0000
Message-ID: <00417754d72202c9032b793d40af7486d00a9979.camel@amd.com>
References: <20261123041200.3239570-1-nilayvaish@google.com>
In-Reply-To: <20261123041200.3239570-1-nilayvaish@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5259:EE_|MW4PR12MB7143:EE_
x-ms-office365-filtering-correlation-id: 59aa24e2-144f-4744-6850-08df491c82ec
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|22082099003|18002099003|261009223027099003|10067099003|5023799004|11063799006|56012099006|261102123227099003|261028144727099003|261026121527099003|261026135527099003|261026130827099003|261026140227099003|261022105027099003|261022075727099003|261022115727099003|261022113327099003|261021133027099003|261021135927099003|261021121427099003|261021130227099003|261021123027099003|38070700021;
x-microsoft-antispam-message-info:
 4zyrB4Hs1ET0OS+qINmu7AWS1ofqNqyJyxphoch27TquQmxw/Kof1s9DXHk+ctCN8+dZ+7K7HjwlfxSV/GtRcdyxxTgW0Md0/jbFyirJ6wySi94eHb2GRHd0JdJlybTRHzwwzhILNnpUluBQAsIuBGhqhb6+VGZN//mQ8a4j8FGo24wqG8P9gISJURnCVbPB4D0yr6FMRdbNVw0wFKGo6t7THE03Ipf7BctYJ6MjZ7IT4hK66Iwu/r6FyyyDr9odprF/XHJ8qGFJmq7KciwNla1nhF7uHax2ZDJ1OfYQsbJNtf/6cvpuJOkYbt/Ie2RezCpQZyQNpiyJdHz9hGkgULizNeGF+fd6786dTGtXEr7E27hvyInXcxoBPiMqlbOZJ/kKd08pCJzL/7zXc0g03dmsoZcvBcaAtRPuknoXj1pa4cIw2LUPyCan1n6WNScE4Y5Xn4JQOCreL5vqPoffXpWyf3Qbtn9s2SnXxjcx/CWaOFfrcV0s3Pu+vP7GSjDC+sIi1nL7fYNjQRpnlYMe4k2/0r54D1t4frxubSlk+I4xyZblPkOT05AtOPXN8KONcrO+Cav7h+hDCUdkT3PIHPIucOi5bRImjO88X1b6mP8CqboUVDKzFYr6d1W9uJZ5Vddc0ogxVuDb/SwekSIbImRqd9dKNct7te4uR/NIzuc=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(22082099003)(18002099003)(261009223027099003)(10067099003)(5023799004)(11063799006)(56012099006)(261102123227099003)(261028144727099003)(261026121527099003)(261026135527099003)(261026130827099003)(261026140227099003)(261022105027099003)(261022075727099003)(261022115727099003)(261022113327099003)(261021133027099003)(261021135927099003)(261021121427099003)(261021130227099003)(261021123027099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WjU3QnpySDRUMkpjNlhRdkJTN1ZPaDdWRGxCSzVUM2M3OThDZHFmTkgwWkli?=
 =?utf-8?B?UUpLRkdXSEVHNGVNMkhVdGl1ell5Mitsb1U0ZHNqb3M1TDZEcUMwTUtZMzNw?=
 =?utf-8?B?TXFXc2xRTmQ5bFNXMmZIWmRmMzJXb1hkN3pNaTh6UGVhUTUvWVQwOVNzU256?=
 =?utf-8?B?RnBUR0t1dG9nSlA5S244Zm1DT2hCWUdqZEVNMC90SXc2UDdwZTdweEZvNlBC?=
 =?utf-8?B?aEsyTWd3dloyMnhiOTNzV0R4dThVTGlPVm94Q2prMktKbEZmNWRSSHVUVEVs?=
 =?utf-8?B?bEgxVHE1ZlpSbHRRQVdKbUFHTnl1SXVlczRldlVXL2tOZit5MUhySTlWTjds?=
 =?utf-8?B?a2RQdHhuTVc2UXpxNUtaUEVwTUR4NWkrTFgzajZ1RU56dE53dDFBSUZOWU9C?=
 =?utf-8?B?bkNybitrS0NkU04wTmc4UnVMMGlIVFVaT3BTdGh3Y1NsWS9zKzhlaG1yc0Nn?=
 =?utf-8?B?SitQeU5oTlhNU1luRUk5U1dmWUQvOHdEbjFIQ0VEYnZyN21OTWl2MzVhL2x3?=
 =?utf-8?B?N290V0ZRTDduSHp5cVAzSGVnUDFJS1dFUjJJK0F4WUt6S2ZLK3MrREI1WEFM?=
 =?utf-8?B?Vk02RzhUVEJkQk91UWJoOXY3YlluNkVkLzIzNzhoM09BYjlnYVVSSTFOQkFv?=
 =?utf-8?B?NmdhMUZyNHlPaDFkOVVWajhZZkdkaW4ycFhBWmZCbHRSMHlYbWdEV29DZjNh?=
 =?utf-8?B?dGlvM0VCNGZraGpCbU9HQTRzSGxZRWNldzZnY2owT3RldFR0VnEyZ2taS2o3?=
 =?utf-8?B?R2N1ckY0WGtoSThPdUVRWGkyMDJlY2c2NEJ1eUJkRFA4aWpkVWlVZGNlaGU4?=
 =?utf-8?B?SVJlcGdQbzROZDMwNHg3bnBtYTVKT0hOMHFrZ3Jzb3B1WFhyd1o1eGliclJr?=
 =?utf-8?B?amlsTTdXVFR4VmVGeGNzVlhIOURqaGo2Y1JhME9TK1dxV2xXNU14L3ptd1Ny?=
 =?utf-8?B?NzVTaEpyTDBtR1NWcUZkT3FIYzg4UVhoc1hGRnFVQksvVlZtYmUzREZZRFFH?=
 =?utf-8?B?WlFVVmNwcDh6a3U2MVFSRU95RU02VkdlTUZkZEdzcjZVS24rNXZoTlluOHNC?=
 =?utf-8?B?cUlpMFZ5NmtvRVA0MndDZ0FTVlZaY2s1clZLeG1hczdBelk3VmE0ci9qZlM3?=
 =?utf-8?B?bE01SVd0Z3BwNWdHaEtycU1uc3F3ejF1a09YSENXZFpYNDd3Vm5uS1FzbnYz?=
 =?utf-8?B?VWoyN2hUUFJncVZjc2JFY1lZTmFjckxQOVJJYUdXSm9scU1pM2F6SzVKTS9t?=
 =?utf-8?B?NzRIbWJLeUJUeFpUSFMwcnFTVnVzSnNiTU9mL25XL1REZE9HTk03RHpYRTZ0?=
 =?utf-8?B?VzkvQU9rRklHdXovSDdZYk05K0dhNmxtT09rYkNZMHZqK0NhRkZhY3N2NlR5?=
 =?utf-8?B?eE8rSHpaaFN0TitRQzdTYkZUeU1TMEhMVVNsZGJBamduSElzdVpMVkZFZEgw?=
 =?utf-8?B?aGc2eURNdjc3L1ltQ3ZXeVdYRDRZQmZJVGwxMmUrdmJhcmVYaVo3WGw2ZU5G?=
 =?utf-8?B?TFN4QUVPaWtEeTNBNWJURlI4N1p0d0ZiT3BzdGxJbnVQd0NMeWFZRHFKTWpw?=
 =?utf-8?B?NXFLTnZQMUZQdXNudnhKMGZ2d1pVME9ZYkdPY3JjOExmL0NtaTJxMWhiMDJn?=
 =?utf-8?B?UVl2d2Vab3RPMy9nKzFLNm03aElydEhGd0FOakhaZURvcVF1bXpDRDJkbE11?=
 =?utf-8?B?aytYN210ZGVXZ3UycGYvUmN6WjRtUlpEbXJLdk9ESnErZ2FyRzljVE1VZStG?=
 =?utf-8?B?QU1SU2M5L2kxRjU3YVdqMmFXbjNSRURzZ0RJck1CWkhqK2Y5alhyL0dmS1JL?=
 =?utf-8?B?YXVaL3ZJMk10cE9uMG5ZOTJheVpLUERkdndkTnhXUWRjRzRHVGpBZUFsLzZr?=
 =?utf-8?B?TU13SnpBdGY1UDdtTjVoWitVUWdudzhVMi9Qbm1kVnNuUlJkQWhJWVF6ODVU?=
 =?utf-8?B?dDl1SkRkSENGbmI0WURrUitlaGlHQ3VxUCtKTCtGUWVxMUZ4dXZSNHNOOWcx?=
 =?utf-8?B?c1ZnTzBzeUVHWjN0bFpWaXY3WUUvbHBzd1VqVGdDSHhCVmFFK01IU3FvSnNH?=
 =?utf-8?B?WnhIeFhERnV4N0NmY1JKSkRoc3l3cjVnZTNPemlGa0JoaldpSU1MU1lWbXdE?=
 =?utf-8?B?K2tPU2FSVDh1NjNKWUJ5NnhkR21jUGJKVHY1Zm1RSGl1dWsxc3gvYVF5a0VF?=
 =?utf-8?B?Ny9CcXdISFdKd1Q0ZDVTVHFvY3FFVFZtN0VJT1JsdEVCeHQxeER0NEgxeEhr?=
 =?utf-8?B?VFRjWWx2d25Db05QcElpTWkyazJ3SFVGMTY2UlpqaDY0b3JLRG5SODlaZFRC?=
 =?utf-8?B?MG5seGxQUmJwL1BZZDFVa0hrb3MzN2prRzh4ZS9Sdnc5U0FicUVMUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C86D052EB50F314EB06B1D3B85CF0755@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59aa24e2-144f-4744-6850-08df491c82ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2026 04:44:51.4124
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r/iMPsrYpYJ9TI7AZtHCA1zSlCKxpP/UPfYjsoJB89yLZVRKNXTLOpXxo3cynd7eCUGdcGgnfj88Q+FDBcq9vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7143
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7E11B160005
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: ych77f9gypo59a97s5e4i9puq7johj54
X-HE-Tag: 1795409099-518471
X-HE-Meta: U2FsdGVkX1/yhphUzfbpZPvkelcH/F2ZOd0nSTxvJosTiiRCqcaHJGlfrf3vwg1GuwJWuO9lK58vEKRPKVslUi7yzEizZ9EoBIrvXt+XK7bLcWXa9yBMaxocNNnB55mWNoJjEvA6WsedPrSS9+sSbB2qG33iGZerBctfpN3LzYZok/5DOsTsicV5rchHfimOYvXhrJZyMQIupSKRuFO5Ixmt/RAsWuzNY/RJBgriLVUp6n6iigeEcAGET4tGay2OVdfZLJ+VQmQgHlqIompZJKidhzNtDPL0expY/PjOEBCHnA6L2opW8vrDCQdQU6qZ2qEXULjXnPBAhKEFFadL8sWw2B0eNLyNJ0RREyvHTXFb9R9HbI+kTLe57ixf9AvjgqpWA0mgIwuIiarFTib5GfuX4ulbg68PxLsZrtAJQRmuaathSClFOWdOrSNwKEsR5G8HlXcbuGC0oVi7jLv2Df4JrBigTSHUwLIHD0ax+CtmDYq2lONKLVWwiC+HziiXzfqkWkxwaNrNyNNDQ1Oz0qQyhwNxl240Cbx11H30Ns/40zbCBNs/38bCfsWdC62PxXj89LtIv1xabmeF3+WA+6M7Mg+vb8cZMf9hKVAz5WDBh3MdwS9bp7cbBpoEEQ9vQLDXvHcC8JYZIRcMW4buJi36TUTU7qtb42EN0QglzNci7GxPN3Z8nfOBtbPs2WnJ0wSrN++pireavdaA2jvFqDJNt9Nf0grTq3+N8vWMP8mVzLvlFdvm6OLG8zJFoKDMsRSTjpzhRzHAMll9he/k+QlAFaRRV+o3PD+ttsYVMmSoCeymLNJNwi4phYEhOwrePA79ImLRQ13Ce04hxLjJm5jnp9+AkCciJ1QAqpep0oKUOX9EUmyaC+M/QZRAcbNEXnagPfPRXKEKqxp9eY5gvpdPBVBd1j+FpANvkJUxHV+qZif5WeDOz9QG0WFXlWoIHPneyU8aCvp4hxth9mf
 hNT/Ggsp
 ukngIVCZORmUvey22pZR3CuY9DuGF+rcpAsbYpl+uUSqGNpMhSa2okwYNBlqkLIjwEm7W9RuVfls3szZS+8tONf+0d8HsxS3AidSmgR5PXkb60YySbVfyyXj2nd9ISDQg5euGiQVoe/hKP3CnHgoJ3c0tHLYNWWjTZAZaVaBIaI5/V62kUmk4oTLzUUc6wJbKwq1VjcJTtJ8+cAdh5nCzA5Sv6tHj/V3U0GxJnh557PWhUUE7UuDgZv+PQCxro5+gA+ymIBidCAR264cxN+RlzRYWQuXKDzjF+5CjTIVwN6olXZbwUTOEramsyWznYYcup0jFGSFiHPbA2fRvpspnUMCEQsVf2gIwCAVPjK0py+NORWYLFco67lGIPJPsSqre/7k0HJkFTWeLmELPeHrAkkW9OYHLSdV+kkD1TZ1KkeNANBd5ZHDggqKtALwj5njCG/IOeUgWl0TD9zVKguao/45ndRcKZniM+Ahq5Az9xlEut6y8l2r5t/EvG1U5EwjcoVX4c6TmxNZgLaCbfPV7LrlQX+VjqxdeqiuX4DvPoL9sG0crc4lsb6KXtjGppOrocIjFvwbs6fTiYAr0Fnsda/ZOcqgwE1NtZ9Gb+K06DsvTK90aMFnMnP/t4AoW8gqsgnLvg//n4eCQ3jI8nibTMlYkjBlmO/Ptn5MhPjJ9Utwnc3F1ncJj2H/CrdlZA8YBeBE6/QwUhwOlyN75yh+tha2NN8Rhk3xtOubNQdUEbgx1rOyxktni7jPWEgiOAoF3gZPUipnp3FJuwJmdBJLYVN7mRI/LGAnHvSf51mX8z2c7Nt9DDJQAizA/YYHtT75YKPzr2dxCcqtITE5YwE42V6kiVAe+m8UEpVanV3Qx5MreooWevWj9yO3hO76uX46v5bGBPJo3llYdaz09WJ2kGXjEtg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

T24gU3VuLCAyMDI2LTExLTIyIGF0IDIwOjEyIC0wODAwLCBOaWxheSBWYWlzaCB3cm90ZToNCj4g
W1lvdSBkb24ndCBvZnRlbiBnZXQgZW1haWwgZnJvbSBuaWxheXZhaXNoQGdvb2dsZS5jb20uIExl
YXJuIHdoeSB0aGlzIGlzIGltcG9ydGFudCBhdCBodHRwczovL2FrYS5tcy9MZWFybkFib3V0U2Vu
ZGVySWRlbnRpZmljYXRpb24gXQ0KPiANCj4gc25hcHNob3RfcGFnZSgpIGNvbXB1dGVzIHBzLT5p
ZHgsIHRoZSBpbmRleCBvZiBAcGFnZSB3aXRoaW4gdGhlIGZvbGlvDQo+IGl0IGFwcGVhcmVkIHRv
IGJlbG9uZyB0bywgYW5kIG5yX3BhZ2VzLCB0aGUgc2l6ZSBvZiB0aGF0IGZvbGlvIGFzIHJlYWQN
Cj4gZnJvbSBhIGNvcHkgb2YgaXRzIGhlYWQgcGFnZS4gQmVjYXVzZSB0aGUgZm9saW8gY2FuIGJl
IHNwbGl0DQo+IGNvbmN1cnJlbnRseSwgdGhlIHR3byBjYW4gZGlzYWdyZWUsIGluIHdoaWNoIGNh
c2UgdGhlIHNuYXBzaG90IGlzDQo+IHJldHJpZWQgYW5kIGZpbmFsbHkgbWFya2VkIGFzIHVuZmFp
dGhmdWwuDQo+IA0KPiBWYWxpZCBpbmRpY2VzIGFyZSAwIHRvIG5yX3BhZ2VzIC0gMSwgYnV0IHRo
ZSBjaGVjayBvbmx5IGNhdGNoZXMNCj4gcHMtPmlkeCA+IG5yX3BhZ2VzLiBJZiB0aGUgZm9saW8g
aXMgc3BsaXQgc3VjaCB0aGF0IHBzLT5pZHggZXF1YWxzDQo+IG5yX3BhZ2VzLCBAcGFnZSBpcyBu
byBsb25nZXIgcGFydCBvZiB0aGUgZm9saW8gdGhhdCB3YXMgY29waWVkLCB5ZXQgdGhlDQo+IHNu
YXBzaG90IGlzIHJldHVybmVkIGFzIGZhaXRoZnVsIHdpdGggYW4gb3V0LW9mLXJhbmdlIGluZGV4
Lg0KPiANCj4gVXNlID49IHNvIHRoYXQgdGhpcyBjYXNlIGlzIHJldHJpZWQgYXMgd2VsbC4NCj4g
DQo+IFRoZSByYWNlIGNhbiBiZSBoaXQgZnJvbSB1c2Vyc3BhY2UuIE9uIGEga2VybmVsIHdpdGgg
YSBkZWJ1Zy1vbmx5IGNoZWNrDQo+IGZvciB0aGlzIGNvbmRpdGlvbiwgb25lIHRocmVhZCByZXBl
YXRlZGx5IGZhdWx0ZWQgaW4gYSBQTUQtc2l6ZWQgVEhQIGFuZA0KPiBzcGxpdCBpdCB0byBvcmRl
ciAwIHRocm91Z2ggdGhlIHNwbGl0X2h1Z2VfcGFnZXMgZGVidWdmcyBmaWxlLCB3aGlsZQ0KPiB0
aHJlZSB0aHJlYWRzIHJlYWQgdGhlIC9wcm9jL2twYWdlZmxhZ3MgZW50cnkgb2YgdGhlIFRIUCdz
IHNlY29uZCBwYWdlLg0KPiBJbiA5MCBzZWNvbmRzIChhYm91dCAxODEsMDAwIHNwbGl0cyksIDE0
IHNuYXBzaG90cyBvZiB0aGF0IHBhZ2Ugd2VyZQ0KPiByZXR1cm5lZCBhcyBmYWl0aGZ1bCB3aXRo
IGlkeCAxIGFuZCBucl9wYWdlcyAxLiBXaXRoIHRoaXMgY2hhbmdlLCBhDQo+IHNlY29uZCA5MC1z
ZWNvbmQgcnVuIChhYm91dCAxMzgsMDAwIHNwbGl0cykgaGl0IHRoZSBpZHggPT0gbnJfcGFnZXMg
Y2FzZQ0KPiA0MSB0aW1lczsgZWFjaCBvbmUgd2FzIHJldHJpZWQsIGFuZCBubyBzbmFwc2hvdCB3
YXMgcmV0dXJuZWQgd2l0aCBhbg0KPiBvdXQtb2YtcmFuZ2UgaW5kZXguDQoNCkhpIE5pbGF5LA0K
DQpUaGlzIG9uZSBpcyBhbHJlYWR5IHBvc3RlZCBbMV0gYW5kIGFwcGxpZWQgaW4gbW0gdHJlZS4N
Cg0KPiANCj4gVGhpcyBpc3N1ZSB3YXMgZm91bmQgYnkgYW4gQUkgY29kaW5nIGFzc2lzdGFudCAo
R2VtaW5pKSB3aGlsZSByZXZpZXdpbmcNCj4gc25hcHNob3RfcGFnZSgpLiBUaGUgZml4IGFuZCB0
aGUgcmVwcm9kdWNlciB3ZXJlIHdyaXR0ZW4gd2l0aCBpdHMgaGVscC4NCj4gDQoNCkFzIGEgdGlw
IGZvciBBSS1hc3Npc3RlZCByZXZpZXdzOiBzZW1jb2RlIFsyXSBoYXMgYW4gTUNQIHNlcnZlciB3
aXRoDQpsb3JlIHNlYXJjaCwgd2hpY2ggbWFrZXMgaXQgZWFzeSB0byBjaGVjayB3aGV0aGVyIGEg
Zml4IGhhcyBhbHJlYWR5DQpiZWVuIHBvc3RlZCBiZWZvcmUgc2VuZGluZy4gSXQgaGFzIHNhdmVk
IG1lIGZyb20gZHVwbGljYXRlcyBhIGZldw0KdGltZXMuDQoNClsxXSBodHRwczovL2xvcmUua2Vy
bmVsLm9yZy9hbGwvMjAyNjExMTYtc25hcHNob3RfcGFnZV9maXgtdjEtMS04ZTQyNTk4NGU4ZDFA
a2VybmVsLm9yZw0KWzJdIGh0dHBzOi8vZ2l0aHViLmNvbS9mYWNlYm9va2V4cGVyaW1lbnRhbC9z
ZW1jb2RlDQoNClRoYW5rcywNClNoaXZhbmsNCg0KDQo+IEZpeGVzOiBkODYzYTEyMTA4ZjIgKCJt
bS91dGlsOiBpbnRyb2R1Y2Ugc25hcHNob3RfcGFnZSgpIikNCj4gU2lnbmVkLW9mZi1ieTogTmls
YXkgVmFpc2ggPG5pbGF5dmFpc2hAZ29vZ2xlLmNvbT4NCj4gLS0tDQo+ICBtbS91dGlsLmMgfCAy
ICstDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4g
DQo+IGRpZmYgLS1naXQgYS9tbS91dGlsLmMgYi9tbS91dGlsLmMNCj4gaW5kZXggODBmNmM3MTQ4
NDRmLi5mMmMyM2U0NTUxYTggMTAwNjQ0DQo+IC0tLSBhL21tL3V0aWwuYw0KPiArKysgYi9tbS91
dGlsLmMNCj4gQEAgLTE0NDQsNyArMTQ0NCw3IEBAIHZvaWQgc25hcHNob3RfcGFnZShzdHJ1Y3Qg
cGFnZV9zbmFwc2hvdCAqcHMsIGNvbnN0IHN0cnVjdCBwYWdlICpwYWdlKQ0KPiAgICAgICAgICAg
ICAgICAgc2V0X3BzX2ZsYWdzKHBzLCBmb2xpb3AsIHBhZ2UpOw0KPiAgICAgICAgIH0NCj4gDQo+
IC0gICAgICAgaWYgKHBzLT5pZHggPiBucl9wYWdlcykgew0KPiArICAgICAgIGlmIChwcy0+aWR4
ID49IG5yX3BhZ2VzKSB7DQo+ICAgICAgICAgICAgICAgICBpZiAobG9vcHMtLSA+IDApDQo+ICAg
ICAgICAgICAgICAgICAgICAgICAgIGdvdG8gYWdhaW47DQo+ICAgICAgICAgICAgICAgICBjbGVh
cl9jb21wb3VuZF9oZWFkKCZwcy0+cGFnZV9zbmFwc2hvdCk7DQo+IC0tDQo+IDIuNTYuMS43NTAu
Z2Y3MGRjNjgyY2YtZ29vZw0KDQoNCg==

