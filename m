Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01630CD4F25
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 15:34:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 142066B0088; Fri, 15 May 2026 11:34:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CC676B0093; Fri, 15 May 2026 11:34:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E60AE6B0095; Fri, 15 May 2026 11:34:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C885A6B0088
	for <linux-mm@kvack.org>; Fri, 15 May 2026 11:34:43 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 65212120108
	for <linux-mm@kvack.org>; Fri, 15 May 2026 15:34:43 +0000 (UTC)
X-FDA: 84770051646.27.AE6BA3B
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azolkn19010094.outbound.protection.outlook.com [52.103.10.94])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5C75940013
	for <linux-mm@kvack.org>; Fri, 15 May 2026 15:34:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=outlook.com header.s=selector1 header.b=bKd7CDX4;
	spf=pass (imf11.hostedemail.com: domain of Forrest021@outlook.com designates 52.103.10.94 as permitted sender) smtp.mailfrom=Forrest021@outlook.com;
	dmarc=pass (policy=none) header.from=outlook.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778859280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=pmXiB4KgQuUii94BRfhqeORt7TVpD5Ji8TIiedmFcu8=;
	b=yU2Pca+LOBdgUWHh3D7Oknv0LJcG0oV4cfvXNOz/MHh5nyLBOMxdm58h0dzh0UZ+4aW23F
	1WlaU2dEkBUXsGA95BFcUIRzJoeOQVghcn4sGgEKQxbpmIsZdB2hnzhjIUhrWm1speAzRs
	fSFkIIAZdI8rl5SxT95KYsyAQyV6Ero=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=outlook.com header.s=selector1 header.b=bKd7CDX4;
	spf=pass (imf11.hostedemail.com: domain of Forrest021@outlook.com designates 52.103.10.94 as permitted sender) smtp.mailfrom=Forrest021@outlook.com;
	dmarc=pass (policy=none) header.from=outlook.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778859280; a=rsa-sha256;
	cv=pass;
	b=X9Aa6Elns9po3xau+w7C2FAB80RPqKJkMCIr+2xyNycbAgjKefyIBDG2fLKMktBBalQpy0
	UwNyIp08RtvTGB0oBwHmpYmfLGVE7j01ReKxiXs8IHMRhPCZEUbCeXvNaWQlvj4t4tvNs2
	AUscytuN4mi+B2iw7tyYAnQzsOikMfI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oTihyrYIB1Q8+m9YwniZmAhxc1VRwpJSa+aJjiKNMc8T7lD9Tx2gS6cpnLkzoekGMRrlx/pl0E05z0KDDVJBuPe4QEqBk18HeTkqywW66II8nYJJDxZvjQpB0F8NnXiOP2dtbVoupWKeLc1t1i3IDr1zSHG9FXtefZ2Esg5EYlwmf6luVE8MRBHD61PJ1815Gl5KU9xN8Nlru8AlXugfBAl6ql9Oj9tgGSs3Tq+n09RH+92IVksp0mcTMm9gjrhgWd+xmZSQpcGtbGCLXmd6aVQyubugWCvFHH8g5TjXMc7P73qagLW8BwfntN7lHWngq9rRjctKmw9I63rtzpJo0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pmXiB4KgQuUii94BRfhqeORt7TVpD5Ji8TIiedmFcu8=;
 b=LgzkmvCOD4+XBsYvGwkNNTdS9C4PNvw2FguHCaxNIwtBc468NDNgmK25xF5Y26lmEmStKGEsmXZKKtPHSLCNg9hvxcDoWnEzkffsU3UHW7y5V9GM4NYgqZPBHlv4TnBF28eXtLlXOkLMfk3GS3B+b4C79RI1UH+qi79TRoXiTt8VB3Dh9klpuCsUE7uLS9Fkz3n6/c52YLAhgmZB2XrplpPg3dGFFxa/fmJ59Hm7PBVOZeVhKX4KtaoqM+Q5xvdKsqQey6QrRM4D5+/LgivhJtPfRBAAiBtZNCvj1FZvIfMXjwktD23nMxLQ3Nvyq4WEggBW0/NkWl/Ov3pqVJkymg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pmXiB4KgQuUii94BRfhqeORt7TVpD5Ji8TIiedmFcu8=;
 b=bKd7CDX479+4ukQBH8XjyuRubaKSKPY7G4yZk/B1moU5a8fIoJ8VnDlj12wcXI2rRLKiiQvnAo3ckiyJvkYXCk3xO22OXuGuWwUCZ1Et6KVhXegm6H1H9HxCyncwb/+cXbTO0ocZS7Kiq9BtV+ZIQRNXhzyy75ulNnoXVCvqFOdDoYjoybc0gQo7ih1/HBKDPny39iWUeu6ZyHpGsrLAzstOWwaNQrNRd3dcAk1ZfJ8b4Wuyv+uWAdb+PaFlPDTskVznwTVd34aSUsGhHMHxJcDpKS5ICencd5QKYi5R3d3XxglgktUpysVwOXtrRytp/0PjeSocIul6Bfv4y3BpXw==
Received: from SN6PR03MB4223.namprd03.prod.outlook.com (2603:10b6:805:c8::19)
 by PH8PR03MB7174.namprd03.prod.outlook.com (2603:10b6:510:259::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.23; Fri, 15 May
 2026 15:34:36 +0000
Received: from SN6PR03MB4223.namprd03.prod.outlook.com
 ([fe80::ead2:5d04:171b:f3b1]) by SN6PR03MB4223.namprd03.prod.outlook.com
 ([fe80::ead2:5d04:171b:f3b1%5]) with mapi id 15.20.9913.009; Fri, 15 May 2026
 15:34:36 +0000
From: Huang Forrest <Forrest021@outlook.com>
To: "mingo@redhat.com" <mingo@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: [BUG] KASAN: slab-use-after-free Write in __schedule
Thread-Topic: [BUG] KASAN: slab-use-after-free Write in __schedule
Thread-Index: AQHc5IAIhhzBh0gX10uy6kAz+Bi/oA==
Date: Fri, 15 May 2026 15:34:36 +0000
Message-ID:
 <SN6PR03MB42236942ABF012EBFF3DAAE684042@SN6PR03MB4223.namprd03.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR03MB4223:EE_|PH8PR03MB7174:EE_
x-ms-office365-filtering-correlation-id: a0d2c6a8-6f50-4cd0-d1af-08deb2977869
x-microsoft-antispam:
 BCL:0;ARA:14566002|2604031031799003|24121999003|22091999003|9112599006|31061999003|41001999006|8062599012|8060799015|15080799012|15030799006|12121999013|19110799012|3430499032|1602099012|40105399003|52005399003|3420499032|440099028|3412199025|26121999007|4302099013|10035399007|102099032|12091999003|11031999003;
x-microsoft-antispam-message-info:
 =?gb2312?B?VDVBTEE4R2RRNmVtV01RbTF6UTF2d0VPWUJjdHFQbUwwU1ErQzg3RkhibUNX?=
 =?gb2312?B?YzlWTVdJQU1GMG5uTGpKMlZzRmtWTThoWFoxQXlCRjMyV3RYWVF0V3FOMnBC?=
 =?gb2312?B?d2g2V0wxOTZDZmNTeVNHRW1NWGlUUWdMZTJaZTg5R0htRWlIbnRqYzRPVzFM?=
 =?gb2312?B?OGVGK0lDMUdxc2RuRm11dTVLMHVPeElsSmFBQlVHQkVodVhDYXZsbFpxTVcz?=
 =?gb2312?B?VW9aQzFKc0RkNUtwNWd4UGo0b2NUeHhHU1dkZjdwRkZaeE1ITmxLWjlpSmFP?=
 =?gb2312?B?cTZHMVhmQm1DdUlOVzRWNWVUcmxyZVlYRHFlREhaamF1cXBENERHSnZFL0x0?=
 =?gb2312?B?VEtDdDk2eU1ZZlB1OGJ1cWg2N3Vaa20rNEtsanphNlRUUUZOQlNUaVlYaXdF?=
 =?gb2312?B?cWhkaDFjMkRSYlZ0SzV0a0FUSlZNRHlyV1ZiVk56QlA5V1pCckxnVHQxaVd1?=
 =?gb2312?B?OXhldWttNkNacDk3Z2FkbGZaS2lKOXkvWUs4U2RpYTRZUDNUbC9lUXlZbmdU?=
 =?gb2312?B?QzNJc3FzaUh6dGc4U01xNUFHZ0ZHSHlmbjBpQ3pYVzNkN2pJZ0Jwb0ExNktD?=
 =?gb2312?B?ZGxrS1QxN3JFbW5JUFNwUHRSUlpXaTVvZXcwSU1acDZHVEFxcXBWRTE1WTVp?=
 =?gb2312?B?Ukx0aWprZVFiTUY2Uzh3T2cyWjY4bG5DbTZEMGNTVnphbTVXbGZjalRlYk5P?=
 =?gb2312?B?blVkZUpka3hxRDhGdFNMQmZxWmN6bWVlbkd3MGhUTU1nKzkwYnN2WWZCT3hH?=
 =?gb2312?B?TXhkWlJ4TURWdStDMjVPOWlTR3cxYk9CbXhaSEx0Q0QvdUFaRHhha04rdVpE?=
 =?gb2312?B?aXE3UVI0dEF2LytqRzVwSlBuVmtNRFZCQXNkMlZNL1ZxS3hOcC9Fcy9OTGVo?=
 =?gb2312?B?ZVlsV01nRnFCTGFYenRad1o4Smw3TWlkMVF0cC9VNUZzc1d2UC92eDloQmxq?=
 =?gb2312?B?TkxtdjRqSitKdnN0cHJkUHhERDFBZXpQNkIvRWh4aW1zOWFHcnZzM2YyWFhy?=
 =?gb2312?B?WDM3bThCdFUwZnhweFBJd0tvUVQwQTJSNWVOK2I4cTJWYUpXSkVjTDI5ci9V?=
 =?gb2312?B?S1Z6YzZZOE9HTmQrdlR2ODUxZGhRRzl4NTBmeWovMTU1L0Z3WlBqc0w5dkJ0?=
 =?gb2312?B?cmRrNGVJU3dXaC9RcGVpSTcxZjlwSmxXZElLWnlNZUVCK2NhN1YvWjFTMi9H?=
 =?gb2312?B?TmlXQ0toZnpoa1BvS1RrQXNoUVk3cTYrUy9sTVJTSmJSbXd1UUpobGNjTWwz?=
 =?gb2312?B?RFR1eU9pQVlIUXlQQ0xwMC9VMmtyb0NtM0pYazJZMUNmMk1sTGExU1ZMY1hM?=
 =?gb2312?B?ZHhML1hnZEx1Wno3NjZCeVExYXltS2xVbVVjNmU1bDJuUVlwRzRxSE1QWFV1?=
 =?gb2312?B?S2c1ZXA1ZEd6RkN2NklndjYwZ0NlRE9tcmJYUnQwNEJBalNIdWxVaFdISmpO?=
 =?gb2312?B?RytZL2RoL0NPR1NUeHV1T29OQ0xMK2hoS3g5STlMTXBhQ1NXM2plRDJsRFUy?=
 =?gb2312?B?ZzRHOEZwZGc3WjBReUh5UlRFekxOWnJCcE9oQi84R0lyRExFQ3dMa1BDeXly?=
 =?gb2312?B?RFpkQ21VLzg0QTM1a0JwTWVVR1pYcDN1YWw0NHVvMk1uNVgzeFluN3pyb1c5?=
 =?gb2312?B?ZGlCU2MxRWZBYklMYmJ2WEpMQjQ2eFp1QXNJc25wKzV3UW1RRnRFSk9CbVd6?=
 =?gb2312?B?dGdaQ0NncWw2QkViZU9VQ1FoRGFuWm5MaDM2dnd4Z2RVWEk0YzAyQXJ3PT0=?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?gb2312?B?OTZZbjZmRWVEejVsV1NDRmhVUk1acndpREpXOEcyQ1I0WXRuMGlJWjVXcU5h?=
 =?gb2312?B?NURSeCtUUTdxNDRoTGhhYzY2R1dpdXZMYWlvcTFaMnMvWUZWU1MzNjVZSkhq?=
 =?gb2312?B?RTcxV1VIM2p4SnpxZEd2T0MxazVqaGs1VHJqMHJzdUxmcnAyeDdZa2NCNVFa?=
 =?gb2312?B?WVdWaGE1dXV1RkhLcUlKMVNibmFESW5BWjlJamN4dVdEMzRrV2VzbE5WdVAx?=
 =?gb2312?B?V0RabkhEM1lPaXAzWDV6RVNCNmlSM0ZHUjhIRWtNeElrSDBZaG9GOTZ5c2w1?=
 =?gb2312?B?WURiQjJWWHpsdTRTVFlWUjZMZzZiMjlFL3ZFNjVYR0xjWFRuY3FiczZNSVFp?=
 =?gb2312?B?cVh1ZENlbGxKU0YzRFFSdEF2ZXdwa1VzSDdUVWZ5WVA0YXNSbTV5eXQybjJJ?=
 =?gb2312?B?bDlIbmx0N3NwTlpCdGhvdlhFaVZWWlVZOW1QN1E4djM2RXJDZVRXQngxVlUw?=
 =?gb2312?B?Q3p3aCtZQitUVnI2UjhCNWZkaU42OVlDOFdFck9aRGt0UDd1MnYvdG1rMkFR?=
 =?gb2312?B?eEg4SnlDd0pVQndpOTNlZW01aWI1N3BsL2ZrUWVHNGk2NGhhdy9RUDdza0hH?=
 =?gb2312?B?NVlnRTV6TEFwRW1NVDVuV2V3U1VJUE9LdEZBeGlVbkJieUd6ZTk1R0hjOEEw?=
 =?gb2312?B?Z0pJakdCQnFuenl5N3dmU0FpczYxSXBkVldJZHdXMEJlMzhtekFmcHJqeDVJ?=
 =?gb2312?B?N1JTSnM0U2lLejIyTHZWYVA1L2E3UkdWSlpQVUVuTzUwWjNYRnRIVnJBZ2Vq?=
 =?gb2312?B?bkpLU1YzWStHOEgwcjV3OFE4SkFEcWRtc1VHbXArdU55ZVZQWEtYUGRET0JP?=
 =?gb2312?B?U29GMms5QThudEdneGM4U3hRMGgxSDRpRzgrQWpWSHJ0TXdWZGwxU0ZYQzF4?=
 =?gb2312?B?WVI1MVlueVNldWxSRDZObytxaTdZR3NXNFNabGdKK1RmUUJmN25CT3pYbEpo?=
 =?gb2312?B?SzB0elY5U254ejlhVkpWclh4QXoxT3dlWnZLR3BZU2M0WGNqeEc5M3pnY29w?=
 =?gb2312?B?QzV6N1ViMHA0V0Z4TllQM0szendoU08rYXZYZ3d2MFVHelhVUmZSbk5Zdm8x?=
 =?gb2312?B?Ti9BWkZaT1JubDB5ZFV1YlFrTFlkNHFMZk45YTRzMW16S3BMNE41bjN0NlFS?=
 =?gb2312?B?dG5YSGFrZzRmWVBTR0xobGhaVmJCT2ZhNDM2Y0FVRDYyK2JWeDVaTjJFM0lk?=
 =?gb2312?B?bkkreC9VWkdVNDZuV1ViZy8rSzdRVVl3bVFraS9kSnJFUTFRaVpLZ3V1T1VH?=
 =?gb2312?B?WG9SbmhadnhlaUhNQk5vQllKbmlkdkdObWRYeThaZ0cxWk1JOVQxNk96aTV3?=
 =?gb2312?B?SGtxTUJFTXBzT01oV0R1MWFLblNFY3M5aGVHQjFsYW54ZEVFL0ZqdkJ5UHNR?=
 =?gb2312?B?ZkthVjJtcmdLVmdGamx3ZUJpcEg1d3h0VVkwc3picnJzQlRBbnpvbytFcVdY?=
 =?gb2312?B?aGdxWHpXUVpUcVJVQVphcUcrdGVrVmlORzRVWTUxbUcyaDM2M0t4aFBHU2No?=
 =?gb2312?B?RHN6YWE5MFlSbjllUkw2clRFZmI0TzA5RVRjeTRLTEZjM04rTkNsdHJaNWlq?=
 =?gb2312?B?ZE10R2txTWlQbE1GVUF3a0labUlpbEMxSkN2eWJPaTZtZkZwVHVqQVlpeTV0?=
 =?gb2312?B?STBuWmFrZkJQdTlxMGZ6WldCZHlZU2xwS3R1MG4rajl4NkJlaHBFcUhYZFhP?=
 =?gb2312?B?RDdONTVUbFl2dDFwOGJUcG5EWVBzVW9yWWd3ZEpoVFV3VGlnL3VhU3JNNngr?=
 =?gb2312?B?S3B1ZVhRTTM1ZnlDdFBSVGtoTmlVOEp1WDcwSlJLNUdXdHQ2STJob0IxbDQr?=
 =?gb2312?B?UG11N3RvUDVBeGorNmRpMEZuRlEwTHg3MnAxL1FoWmt2anRySEtjRkVuZUV5?=
 =?gb2312?Q?L5i5Hx4XHOpv8?=
Content-Type: multipart/alternative;
	boundary="_000_SN6PR03MB42236942ABF012EBFF3DAAE684042SN6PR03MB4223namp_"
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR03MB4223.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: a0d2c6a8-6f50-4cd0-d1af-08deb2977869
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2026 15:34:36.3167
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR03MB7174
X-Stat-Signature: wcp9zbfxh4gf5d54kytsy3fttry4qeeu
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5C75940013
X-Rspam-User: 
X-HE-Tag: 1778859280-47849
X-HE-Meta: U2FsdGVkX181gt8vJI1QAqmInYTj5EjqNLJA+4DJjp8DV1IM1v+b5qo6lWHuocsJpDn9IE01gYKcjHbZ6zR6YjzyKzhTL0EV09aZznK3aJ5+5o277NvGpISawnuL/PQrw4TkrKXcOIcH7Q8zmKl4HkPaZ2ejhSOJkfc/Dl+OEcHx4/2eJPYiedHd8y2+S7u5eFGV7NIYEijGIqcuM3iYo2GJJaQPz5+o5NTDl20Qd4Q5osKiragBTztL9EnDiQxWUmEj5hH49kkw+99JNUjbqxL6qb16bn2mDVQiXOctbSEiGqUe/3XgiPL6pzx43IAQm7xB3Qge/70hg6v0kxWYmtOeDT/GHlBN4pZnM9Uwr06ialMCdkV/+sjd/47LrQCF4JazYEKFXTndPghpUYt7OqPAX87AwrebCSohGHQb0qAzYHm0xuyIWFKdg3+cklqye4DZHrCOsJM8458UkRqyEyzOv2YASrAvrzOURoKXS6ekid2Cv3FE3wotfidJ74BfnD+VZVPyj504r4cVw31R2XrRLe0hPPAUWnNaiQsas42e5L4wgKprL5rB3OuOcmOxssOX4gPo1j7kCqGusXriVEQ95l5MGoOlmzwJ6KawyUyVFMFTAzm2kIaUT+mnC/6+FLGYpPkURu9p5zsiSaIVmw6CwQ0LXVcV/fJd3daFUzZ/0qHQBKLD+VNCuSif1iIbxwfc1L3WfVhG/d98fyE+PatRxmP4DfliFWkb4GKAYtVzXwq63QnoELfUOf/6hwAjCp5V31BOHqWATnmjOZtn80L/L69xhUmqrNkGpr+e9FpJ1ho7vUami02ktVazGR6fvbtVckmRMEBlNu/i7WO0BuSpw8XDe7HgeQfdMWlwawRb75BfUiwcuMruByWVEjyDzFNA8WtgNHozFs8Ih+WqSV+m4Ykk5jnBUlDd1tyQuIeNZWbDKjA373hnHcwR6Nn4/vqB1MGcBVFUMhyWw/P
 rW1FrtnV
 2pYp7LyHaZdoygyNXLt2KxkMbA9RXg/DtY312VfHO7C7xhN9sr9xzF9+e+HQ/tQZkuNC1Dxul2LFCQGQffp+d7W/qqlQxEBVMaA1jhTSQyBfPnG6hRnnUpKefYZyggjCblFBZH2oQchbf5szgTBRoFnMQy13dP5BaKpt0Ig0Z+psmh4zSL9VKUMsVqjCvTiAWNoZpEHZiPHuyUEpf0w4NOYYKqJ1AGcnRgdTcHl5BAOSPPurIYPBEQm6KEVP/ABHOLf0cz/9boCJFO43ZnR9xN7qdCF4xCKNw57AuaZtM8elhnzmY5aXZQcvRKX9H0OJQj+yg7zHKCLvp4Iw+vyvcFNbJ7YqHHrvyb4uRNk+BcVw6WhhO9rycZSQJNgjMgQUmPHHAoMR86dRYdZ6l9kBHTQ3QJRHwoTQRmTzsyrQKryzR06O61Ib0ATJMArqJesPiACcDDtE8oaqI9+odyZvw0jJorVteq2s+PdTsngPFsRqVKEAJkyobdI9XfzjTzSGhOZrEW6/tT/jR/gHZEGUxi03UOl1ML0beQFlN9XvoAkwRycrNPgPoKie+ZR2WjHRrINjjQ5mT4+tEpbPD5CxUufYTHDl6hIocZfu7qztk8jnB5TFlro9JnaHkzVxNDlNgjugKpZciNhTYtzmtLPO39J9sL2HMHx+JpFkO991vnu4Ku32PC/qFXTYPkcuXLSD93RdanD+jExQkixByIxgfdaASdaMVapWEJ8Q6J7Qpy1gdss+kHuFEHZ1S+oQDSt8HtgQf2M0kLIMekYjLTbfOWbzCEBroLhP18z0wFz+K08ehiOj0g8aypsXDiI4kZQZZQVH3K0/FlPeM3V8PEo7Lo3OZsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--_000_SN6PR03MB42236942ABF012EBFF3DAAE684042SN6PR03MB4223namp_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64

SGVsbG8sDQoNCkkgZm91bmQgdGhlIGZvbGxvd2luZyBpc3N1ZSB3aXRoIHN5emthbGxlciBvbjoN
Cg0KSEVBRCBjb21taXQ6ICAgIDdhYWE4MDQ3ZWFmZCAoSEVBRCAtPiBtYXN0ZXIsIHRhZzogdjcu
MC1yYzYsIG9yaWdpbi9tYXN0ZXIsIG9yaWdpbi9IRUFEKSBMaW51eCA3LjAtcmM2Lg0KZ2l0IHRy
ZWU6ICAgICAgIGh0dHBzOi8vZ2l0aHViLmNvbS90b3J2YWxkcy9saW51eC5naXQgbWFzdGVyDQpj
b25zb2xlIG91dHB1dDogaHR0cHM6Ly9naXN0LmdpdGh1YnVzZXJjb250ZW50LmNvbS9Gb3Jlc3Qt
a2VybmVsLzU2YjU4ZDI0MmY2MWI1OGQ0MjM2NWFlOWUwMjQ4MTA4L3Jhdy85NmVhNjVhYmQ2Yjhk
YzUzYTI2OWI3NDMyM2UyZjk3NzIyOWJkZTAzL2dpc3RmaWxlMS50eHQNCmtlcm5lbCBjb25maWc6
ICBodHRwczovL2dpc3QuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0ZvcmVzdC1rZXJuZWwvMzU0ZTdj
NTY1MjJhYjYwZjI5YzhiOTZlNzQyOWUyZTMvcmF3Lzk3YmIxZTdkNmY5NDA2ZGE1YmQwN2U5OTlj
MzYzNGYyNTBhNWRiMGMvY29uZmlnLnR4dA0KZGFzaGJvYXJkIGxpbms6IE4vQSBmb3IgbG9jYWwg
ZGFzaGJvYXJkDQpjb21waWxlcjogICAgICAgZ2NjIChVYnVudHUgMTIuMy4wLTF1YnVudHUxfjIy
LjA0KSAxMi4zLjANCnVzZXJzcGFjZSBhcmNoOiB4ODZfNjQNCg0KDQpJIGRvbid0IGhhdmUgYW55
IHJlcHJvZHVjZXIgZm9yIHRoaXMgaXNzdWUgeWV0Lg0KDQpTdXNwZWN0ZWQgcm9vdCBjYXVzZToN
Cg0KSSBzdXNwZWN0IHRoaXMgaXMgbWFpbmx5IGEgbGlmZXRpbWUgLyB0ZWFyZG93biBvcmRlcmlu
ZyBpc3N1ZSBiZXR3ZWVuIHByb2Nlc3MgZXhpdCBhbmQgdGhlIHNjaGVkdWxlcqGvcyBtbV9jaWQg
cGF0aCwgd2l0aCBpb191cmluZyBleGl0IG1ha2luZyB0aGUgcmFjZSBlYXNpZXIgdG8gaGl0Lg0K
DQpUaGUgZmF1bHRpbmcgdGFzayBpcyBpbiBzY2hlZHVsZV90aW1lb3V0IC0+d2FpdF9mb3JfY29t
bW9uLCB3YWl0aW5nIG9uIGlvX3dxX3B1dF9hbmRfZXhpdCAvIGlvX3VyaW5nX2NsZWFuX3RjdHgg
YXMgcGFydCBvZiBkb19leGl0LiBUaGUgZnJlZWQgb2JqZWN0IHdhcyByZWxlYXNlZCBlYXJsaWVy
IHZpYSBleGl0X21tYXAgofogdGVhcl9kb3duX3ZtYXMsIHRoZW4ga2ZyZWUgdGhyb3VnaCBSQ1Ug
KHRpbWVyIHNvZnRpcnEpLCB3aGlsZSBhbm90aGVyIHBhdGggd2FzIHN0aWxsIHRlYXJpbmcgZG93
biB0aGUgc2FtZSBtbSBhcm91bmQgZXhpdF9ncm91cCAvIG1tcHV0Lg0KDQpUaGUgcm9vdCBjYXVz
ZSBtYXkgYmUgdGhhdCBWTUEvbW0gdGVhcmRvd24gKGluY2x1ZGluZyBSQ1UtZGVmZXJyZWQgZnJl
ZSkgYW5kIG1tX2NpZCB0ZWFyLWRvd24gaW4gY29udGV4dF9zd2l0Y2ggYXJlIG5vdCBwcm9wZXJs
eSBzeW5jaHJvbml6ZWShqnNvIHdoZW4gaW9fdXJpbmcgd2FpdHMgZm9yIHdvcmtlcnMgZHVyaW5n
IGV4aXQgYW5kIHRoZSB0YXNrIHNjaGVkdWxlcywgbW1fY2lkIHN0aWxsIHRvdWNoZXMgbWVtb3J5
IHRoYXQgdGVhcl9kb3duX3ZtYXMgaGFzIGFscmVhZHkgZnJlZWQuDQoNCg0KVGhlIGZvbGxvd2lu
ZyBmdWxsIHJlcG9ydCBhbHNvIGluIGh0dHBzOi8vZ2lzdC5naXRodWJ1c2VyY29udGVudC5jb20v
Rm9yZXN0LWtlcm5lbC85YjlhMWYxMTdkZmNkNTQ1OWJhN2QwZGZhODg2OGM5MC9yYXcvYTc1YWQ0
ZDc5ZDQ0NTgyNDVhOWNmMjU5YTkzNDM0NWZhYWM5ZDdlYy9yZXBvcnQNCg0KPT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQpC
VUc6IEtBU0FOOiBzbGFiLXVzZS1hZnRlci1mcmVlIGluIGluc3RydW1lbnRfYXRvbWljX3dyaXRl
IGluY2x1ZGUvbGludXgvaW5zdHJ1bWVudGVkLmg6OTcgW2lubGluZV0NCkJVRzogS0FTQU46IHNs
YWItdXNlLWFmdGVyLWZyZWUgaW4gY2xlYXJfYml0IGluY2x1ZGUvYXNtLWdlbmVyaWMvYml0b3Bz
L2luc3RydW1lbnRlZC1hdG9taWMuaDo0MSBbaW5saW5lXQ0KQlVHOiBLQVNBTjogc2xhYi11c2Ut
YWZ0ZXItZnJlZSBpbiBtbV9kcm9wX2NpZCBrZXJuZWwvc2NoZWQvc2NoZWQuaDozODEyIFtpbmxp
bmVdDQpCVUc6IEtBU0FOOiBzbGFiLXVzZS1hZnRlci1mcmVlIGluIG1tX2NpZF9zY2hlZG91dCBr
ZXJuZWwvc2NoZWQvc2NoZWQuaDozOTk1IFtpbmxpbmVdDQpCVUc6IEtBU0FOOiBzbGFiLXVzZS1h
ZnRlci1mcmVlIGluIG1tX2NpZF9zd2l0Y2hfdG8ga2VybmVsL3NjaGVkL3NjaGVkLmg6NDAwMiBb
aW5saW5lXQ0KQlVHOiBLQVNBTjogc2xhYi11c2UtYWZ0ZXItZnJlZSBpbiBjb250ZXh0X3N3aXRj
aCBrZXJuZWwvc2NoZWQvY29yZS5jOjUyODcgW2lubGluZV0NCkJVRzogS0FTQU46IHNsYWItdXNl
LWFmdGVyLWZyZWUgaW4gX19zY2hlZHVsZSsweDIyZmEvMHgzZWUwIGtlcm5lbC9zY2hlZC9jb3Jl
LmM6NjkxMQ0KV3JpdGUgb2Ygc2l6ZSA4IGF0IGFkZHIgZmZmZjg4ODExYmI2Y2YxMCBieSB0YXNr
IHN5ei42Ljg4Ni8xNDQ0MQ0KDQpDUFU6IDQgVUlEOiAwIFBJRDogMTQ0NDEgQ29tbTogc3l6LjYu
ODg2IE5vdCB0YWludGVkIDcuMC4wLXJjNiAjMSBQUkVFTVBUKGxhenkpDQpIYXJkd2FyZSBuYW1l
OiBRRU1VIFN0YW5kYXJkIFBDIChpNDQwRlggKyBQSUlYLCAxOTk2KSwgQklPUyAxLjE1LjAtMSAw
NC8wMS8yMDE0DQpDYWxsIFRyYWNlOg0KIDxUQVNLPg0KIF9fZHVtcF9zdGFjayBsaWIvZHVtcF9z
dGFjay5jOjk0IFtpbmxpbmVdDQogZHVtcF9zdGFja19sdmwrMHhhYi8weGUwIGxpYi9kdW1wX3N0
YWNrLmM6MTIwDQogcHJpbnRfYWRkcmVzc19kZXNjcmlwdGlvbiBtbS9rYXNhbi9yZXBvcnQuYzoz
NzggW2lubGluZV0NCiBwcmludF9yZXBvcnQrMHhjZS8weDYxMCBtbS9rYXNhbi9yZXBvcnQuYzo0
ODINCiBrYXNhbl9yZXBvcnQrMHhjZS8weDEwMCBtbS9rYXNhbi9yZXBvcnQuYzo1OTUNCiBjaGVj
a19yZWdpb25faW5saW5lIG1tL2thc2FuL2dlbmVyaWMuYzoxOTQgW2lubGluZV0NCiBrYXNhbl9j
aGVja19yYW5nZSsweDEwMC8weDFiMCBtbS9rYXNhbi9nZW5lcmljLmM6MjAwDQogaW5zdHJ1bWVu
dF9hdG9taWNfd3JpdGUgaW5jbHVkZS9saW51eC9pbnN0cnVtZW50ZWQuaDo5NyBbaW5saW5lXQ0K
IGNsZWFyX2JpdCBpbmNsdWRlL2FzbS1nZW5lcmljL2JpdG9wcy9pbnN0cnVtZW50ZWQtYXRvbWlj
Lmg6NDEgW2lubGluZV0NCiBtbV9kcm9wX2NpZCBrZXJuZWwvc2NoZWQvc2NoZWQuaDozODEyIFtp
bmxpbmVdDQogbW1fY2lkX3NjaGVkb3V0IGtlcm5lbC9zY2hlZC9zY2hlZC5oOjM5OTUgW2lubGlu
ZV0NCiBtbV9jaWRfc3dpdGNoX3RvIGtlcm5lbC9zY2hlZC9zY2hlZC5oOjQwMDIgW2lubGluZV0N
CiBjb250ZXh0X3N3aXRjaCBrZXJuZWwvc2NoZWQvY29yZS5jOjUyODcgW2lubGluZV0NCiBfX3Nj
aGVkdWxlKzB4MjJmYS8weDNlZTAga2VybmVsL3NjaGVkL2NvcmUuYzo2OTExDQogX19zY2hlZHVs
ZV9sb29wIGtlcm5lbC9zY2hlZC9jb3JlLmM6Njk5MyBbaW5saW5lXQ0KIHNjaGVkdWxlKzB4Nzkv
MHgyZTAga2VybmVsL3NjaGVkL2NvcmUuYzo3MDA4DQogc2NoZWR1bGVfdGltZW91dCsweDIxNy8w
eDI1MCBrZXJuZWwvdGltZS9zbGVlcF90aW1lb3V0LmM6NzUNCiBkb193YWl0X2Zvcl9jb21tb24g
a2VybmVsL3NjaGVkL2NvbXBsZXRpb24uYzoxMDAgW2lubGluZV0NCiBfX3dhaXRfZm9yX2NvbW1v
bisweDJhYi8weDNlMCBrZXJuZWwvc2NoZWQvY29tcGxldGlvbi5jOjEyMQ0KIGlvX3dxX2V4aXRf
d29ya2VycyBpb191cmluZy9pby13cS5jOjEzNjcgW2lubGluZV0NCiBpb193cV9wdXRfYW5kX2V4
aXQrMHgyNGQvMHg3MjAgaW9fdXJpbmcvaW8td3EuYzoxMzk4DQogaW9fdXJpbmdfY2xlYW5fdGN0
eCsweGZhLzB4MTcwIGlvX3VyaW5nL3RjdHguYzoyMjINCiBpb191cmluZ19jYW5jZWxfZ2VuZXJp
YysweDY1ZC8weDhjMCBpb191cmluZy9jYW5jZWwuYzo2NTANCiBpb191cmluZ19maWxlc19jYW5j
ZWwgaW5jbHVkZS9saW51eC9pb191cmluZy5oOjIwIFtpbmxpbmVdDQogZG9fZXhpdCsweDM0Yy8w
eDI4ZTAga2VybmVsL2V4aXQuYzo5MTYNCiBkb19ncm91cF9leGl0KzB4YzcvMHgyODAga2VybmVs
L2V4aXQuYzoxMTE4DQogZ2V0X3NpZ25hbCsweDIwZDIvMHgyMTUwIGtlcm5lbC9zaWduYWwuYzoz
MDM0DQogYXJjaF9kb19zaWduYWxfb3JfcmVzdGFydCsweDhmLzB4N2EwIGFyY2gveDg2L2tlcm5l
bC9zaWduYWwuYzozMzcNCiBfX2V4aXRfdG9fdXNlcl9tb2RlX2xvb3Aga2VybmVsL2VudHJ5L2Nv
bW1vbi5jOjY0IFtpbmxpbmVdDQogZXhpdF90b191c2VyX21vZGVfbG9vcCsweDZiLzB4NGMwIGtl
cm5lbC9lbnRyeS9jb21tb24uYzo5OA0KIF9fZXhpdF90b191c2VyX21vZGVfcHJlcGFyZSBpbmNs
dWRlL2xpbnV4L2lycS1lbnRyeS1jb21tb24uaDoyMjYgW2lubGluZV0NCiBzeXNjYWxsX2V4aXRf
dG9fdXNlcl9tb2RlX3ByZXBhcmUgaW5jbHVkZS9saW51eC9pcnEtZW50cnktY29tbW9uLmg6MjU2
IFtpbmxpbmVdDQogc3lzY2FsbF9leGl0X3RvX3VzZXJfbW9kZSBpbmNsdWRlL2xpbnV4L2VudHJ5
LWNvbW1vbi5oOjMyNSBbaW5saW5lXQ0KIGRvX3N5c2NhbGxfNjQrMHg0NmQvMHg1ODAgYXJjaC94
ODYvZW50cnkvc3lzY2FsbF82NC5jOjEwMA0KIGVudHJ5X1NZU0NBTExfNjRfYWZ0ZXJfaHdmcmFt
ZSsweDc3LzB4N2YNClJJUDogMDAzMzoweDdmMDEyNWE0Nzc3ZA0KQ29kZTogMDIgYjggZmYgZmYg
ZmYgZmYgYzMgNjYgMGYgMWYgNDQgMDAgMDAgZjMgMGYgMWUgZmEgNDggODkgZjggNDggODkgZjcg
NDggODkgZDYgNDggODkgY2EgNGQgODkgYzIgNGQgODkgYzggNGMgOGIgNGMgMjQgMDggMGYgMDUg
PDQ4PiAzZCAwMSBmMCBmZiBmZiA3MyAwMSBjMyA0OCBjNyBjMSBhOCBmZiBmZiBmZiBmNyBkOCA2
NCA4OSAwMSA0OA0KUlNQOiAwMDJiOjAwMDA3ZjAxMjQ0ODZmYTggRUZMQUdTOiAwMDAwMDI0NiBP
UklHX1JBWDogMDAwMDAwMDAwMDAwMDE0Mg0KUkFYOiBmZmZmZmZmZmZmZmZmZmY4IFJCWDogMDAw
MDdmMDEyNWNkNWZhMCBSQ1g6IDAwMDA3ZjAxMjVhNDc3N2QNClJEWDogMDAwMDAwMDAwMDAwMDAw
MCBSU0k6IDAwMDAyMDAwMDAwMDAwMDAgUkRJOiAwMDAwMDAwMDAwMDAwMDA1DQpSQlA6IDAwMDA3
ZjAxMjVhZTRkNzQgUjA4OiAwMDAwMDAwMDAwMDAxMTAwIFIwOTogMDAwMDAwMDAwMDAwMDAwMA0K
UjEwOiAwMDAwMDAwMDAwMDAwMDAwIFIxMTogMDAwMDAwMDAwMDAwMDI0NiBSMTI6IDAwMDAwMDAw
MDAwMDAwMDANClIxMzogMDAwMDdmMDEyNWNkNjAzOCBSMTQ6IDAwMDA3ZjAxMjVjZDVmYTAgUjE1
OiAwMDAwN2YwMTI0NDY3MDAwDQogPC9UQVNLPg0KDQpBbGxvY2F0ZWQgYnkgdGFzayAxNDE5MCBv
biBjcHUgMSBhdCA2Mi44OTA3NjJzOg0KIGthc2FuX3NhdmVfc3RhY2srMHgzMy8weDYwIG1tL2th
c2FuL2NvbW1vbi5jOjU3DQoga2FzYW5fc2F2ZV90cmFjaysweDE3LzB4NjAgbW0va2FzYW4vY29t
bW9uLmM6NzgNCiBwb2lzb25fa21hbGxvY19yZWR6b25lIG1tL2thc2FuL2NvbW1vbi5jOjM5OCBb
aW5saW5lXQ0KIF9fa2FzYW5fa21hbGxvYysweDhmLzB4YTAgbW0va2FzYW4vY29tbW9uLmM6NDE1
DQoga21hbGxvY19ub3Byb2YgaW5jbHVkZS9saW51eC9zbGFiLmg6OTUwIFtpbmxpbmVdDQogc2xh
Yl9mcmVlX2hvb2sgbW0vc2x1Yi5jOjI2MzcgW2lubGluZV0NCiBzbGFiX2ZyZWUgbW0vc2x1Yi5j
OjYxNjUgW2lubGluZV0NCiBrbWVtX2NhY2hlX2ZyZWUrMHgyNDUvMHgzZDAgbW0vc2x1Yi5jOjYy
OTUNCiB0ZWFyX2Rvd25fdm1hcysweDE4Mi8weDNhMCBtbS9tbWFwLmM6MTI2NA0KIGV4aXRfbW1h
cCsweDM3Zi8weDgwMCBtbS9tbWFwLmM6MTMyMg0KIF9fbW1wdXQga2VybmVsL2ZvcmsuYzoxMTc1
IFtpbmxpbmVdDQogbW1wdXQrMHg2Yy8weDMyMCBrZXJuZWwvZm9yay5jOjExOTgNCiBleGl0X21t
IGtlcm5lbC9leGl0LmM6NTgxIFtpbmxpbmVdDQogZG9fZXhpdCsweDdjMS8weDI4ZTAga2VybmVs
L2V4aXQuYzo5NjQNCiBkb19ncm91cF9leGl0KzB4YzcvMHgyODAga2VybmVsL2V4aXQuYzoxMTE4
DQogX19kb19zeXNfZXhpdF9ncm91cCBrZXJuZWwvZXhpdC5jOjExMjkgW2lubGluZV0NCiBfX3Nl
X3N5c19leGl0X2dyb3VwIGtlcm5lbC9leGl0LmM6MTEyNyBbaW5saW5lXQ0KIF9feDY0X3N5c19l
eGl0X2dyb3VwKzB4M2UvMHg1MCBrZXJuZWwvZXhpdC5jOjExMjcNCiB4NjRfc3lzX2NhbGwrMHgx
NmNkLzB4MTc2MCBhcmNoL3g4Ni9pbmNsdWRlL2dlbmVyYXRlZC9hc20vc3lzY2FsbHNfNjQuaDoy
MzINCiBkb19zeXNjYWxsX3g2NCBhcmNoL3g4Ni9lbnRyeS9zeXNjYWxsXzY0LmM6NjMgW2lubGlu
ZV0NCiBkb19zeXNjYWxsXzY0KzB4ZmMvMHg1ODAgYXJjaC94ODYvZW50cnkvc3lzY2FsbF82NC5j
Ojk0DQogZW50cnlfU1lTQ0FMTF82NF9hZnRlcl9od2ZyYW1lKzB4NzcvMHg3Zg0KDQpGcmVlZCBi
eSB0YXNrIDE0NCBvbiBjcHUgMSBhdCA2Mi44OTk1NjJzOg0KIGthc2FuX3NhdmVfc3RhY2srMHgz
My8weDYwIG1tL2thc2FuL2NvbW1vbi5jOjU3DQoga2FzYW5fc2F2ZV90cmFjaysweDE3LzB4NjAg
bW0va2FzYW4vY29tbW9uLmM6NzgNCiBrYXNhbl9zYXZlX2ZyZWVfaW5mbysweDNiLzB4NjAgbW0v
a2FzYW4vZ2VuZXJpYy5jOjU4NA0KIHBvaXNvbl9zbGFiX29iamVjdCBtbS9rYXNhbi9jb21tb24u
YzoyNTMgW2lubGluZV0NCiBfX2thc2FuX3NsYWJfZnJlZSsweDQzLzB4NzAgbW0va2FzYW4vY29t
bW9uLmM6Mjg1DQoga2FzYW5fc2xhYl9mcmVlIGluY2x1ZGUvbGludXgva2FzYW4uaDoyMzUgW2lu
bGluZV0NCiBzbGFiX2ZyZWVfaG9vayBtbS9zbHViLmM6MjY4NSBbaW5saW5lXQ0KIHNsYWJfZnJl
ZSBtbS9zbHViLmM6NjE2NSBbaW5saW5lXQ0KIGtmcmVlKzB4MTM3LzB4M2IwIG1tL3NsdWIuYzo2
NDgzDQogc2xhYl9mcmVlX2FmdGVyX3JjdV9kZWJ1ZysweDVkLzB4MWYwIG1tL3NsdWIuYzo2MjE3
DQogcmN1X2RvX2JhdGNoIGtlcm5lbC9yY3UvdHJlZS5jOjI2MTcgW2lubGluZV0NCiByY3VfY29y
ZSsweDUyMS8weDE4MjAga2VybmVsL3JjdS90cmVlLmM6Mjg2OQ0KIGhhbmRsZV9zb2Z0aXJxcysw
eDFiOC8weDY0MCBrZXJuZWwvc29mdGlycS5jOjYyMg0KIF9fZG9fc29mdGlycSBrZXJuZWwvc29m
dGlycS5jOjY1NiBbaW5saW5lXQ0KIGludm9rZV9zb2Z0aXJxIGtlcm5lbC9zb2Z0aXJxLmM6NDk2
IFtpbmxpbmVdDQogX19pcnFfZXhpdF9yY3UrMHhhYi8weGUwIGtlcm5lbC9zb2Z0aXJxLmM6NzIz
DQogaW5zdHJfc3lzdmVjX2FwaWNfdGltZXJfaW50ZXJydXB0IGFyY2gveDg2L2tlcm5lbC9hcGlj
L2FwaWMuYzoxMDU2IFtpbmxpbmVdDQogc3lzdmVjX2FwaWNfdGltZXJfaW50ZXJydXB0KzB4NmMv
MHg4MCBhcmNoL3g4Ni9rZXJuZWwvYXBpYy9hcGljLmM6MTA1Ng0KIGFzbV9zeXN2ZWNfYXBpY190
aW1lcl9pbnRlcnJ1cHQrMHgxYS8weDIwIGFyY2gveDg2L2luY2x1ZGUvYXNtL2lkdGVudHJ5Lmg6
Njk3DQoNCkxhc3QgcG90ZW50aWFsbHkgcmVsYXRlZCB3b3JrIGNyZWF0aW9uOg0KIGthc2FuX3Nh
dmVfc3RhY2srMHgzMy8weDYwIG1tL2thc2FuL2NvbW1vbi5jOjU3DQoga2FzYW5fcmVjb3JkX2F1
eF9zdGFjaysweDhjLzB4YTAgbW0va2FzYW4vZ2VuZXJpYy5jOjU1Ng0KIF9fY2FsbF9yY3VfY29t
bW9uLmNvbnN0cHJvcC4wKzB4NzEvMHg5ZjAga2VybmVsL3JjdS90cmVlLmM6MzEzMQ0KIHRlYXJf
ZG93bl92bWFzKzB4MTgyLzB4M2EwIG1tL21tYXAuYzoxMjY0DQogZXhpdF9tbWFwKzB4MzdmLzB4
ODAwIG1tL21tYXAuYzoxMzIyDQogX19tbXB1dCBrZXJuZWwvZm9yay5jOjExNzUgW2lubGluZV0N
CiBtbXB1dCsweDZjLzB4MzIwIGtlcm5lbC9mb3JrLmM6MTE5OA0KIGV4aXRfbW0ga2VybmVsL2V4
aXQuYzo1ODEgW2lubGluZV0NCiBkb19leGl0KzB4N2MxLzB4MjhlMCBrZXJuZWwvZXhpdC5jOjk2
NA0KIGRvX2dyb3VwX2V4aXQrMHhjNy8weDI4MCBrZXJuZWwvZXhpdC5jOjExMTgNCiBfX2RvX3N5
c19leGl0X2dyb3VwIGtlcm5lbC9leGl0LmM6MTEyOSBbaW5saW5lXQ0KIF9fc2Vfc3lzX2V4aXRf
Z3JvdXAga2VybmVsL2V4aXQuYzoxMTI3IFtpbmxpbmVdDQogX194NjRfc3lzX2V4aXRfZ3JvdXAr
MHgzZS8weDUwIGtlcm5lbC9leGl0LmM6MTEyNw0KIHg2NF9zeXNfY2FsbCsweDE2Y2QvMHgxNzYw
IGFyY2gveDg2L2luY2x1ZGUvZ2VuZXJhdGVkL2FzbS9zeXNjYWxsc182NC5oOjIzMg0KIGRvX3N5
c2NhbGxfeDY0IGFyY2gveDg2L2VudHJ5L3N5c2NhbGxfNjQuYzo2MyBbaW5saW5lXQ0KIGRvX3N5
c2NhbGxfNjQrMHhmYy8weDU4MCBhcmNoL3g4Ni9lbnRyeS9zeXNjYWxsXzY0LmM6OTQNCiBlbnRy
eV9TWVNDQUxMXzY0X2FmdGVyX2h3ZnJhbWUrMHg3Ny8weDdmDQoNClRoZSBidWdneSBhZGRyZXNz
IGJlbG9uZ3MgdG8gdGhlIG9iamVjdCBhdCBmZmZmODg4MTFiYjZjZjAwDQogd2hpY2ggYmVsb25n
cyB0byB0aGUgY2FjaGUga21hbGxvYy0zMiBvZiBzaXplIDMyDQpUaGUgYnVnZ3kgYWRkcmVzcyBp
cyBsb2NhdGVkIDE2IGJ5dGVzIGluc2lkZSBvZg0KIGZyZWVkIDMyLWJ5dGUgcmVnaW9uIFtmZmZm
ODg4MTFiYjZjZjAwLCBmZmZmODg4MTFiYjZjZjIwKQ0KDQpUaGUgYnVnZ3kgYWRkcmVzcyBiZWxv
bmdzIHRvIHRoZSBwaHlzaWNhbCBwYWdlOg0KcGFnZTogcmVmY291bnQ6MCBtYXBjb3VudDowIG1h
cHBpbmc6MDAwMDAwMDAwMDAwMDAwMCBpbmRleDoweDAgcGZuOjB4MTFiYjZjDQpmbGFnczogMHgy
MDAwMDAwMDAwMDAwMDAobm9kZT0wfHpvbmU9MikNCnBhZ2VfdHlwZTogZjUoc2xhYikNCnJhdzog
MDIwMDAwMDAwMDAwMDAwMCBmZmZmODg4MTAwMDQyNzgwIGRlYWQwMDAwMDAwMDAxMDAgZGVhZDAw
MDAwMDAwMDEyMg0KcmF3OiAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDA0MDAwNDAgMDAwMDAw
MDBmNTAwMDAwMCAwMDAwMDAwMDAwMDAwMDAwDQpwYWdlIGR1bXBlZCBiZWNhdXNlOiBrYXNhbjog
YmFkIGFjY2VzcyBkZXRlY3RlZA0KDQpNZW1vcnkgc3RhdGUgYXJvdW5kIHRoZSBidWdneSBhZGRy
ZXNzOg0KIGZmZmY4ODgxMWJiNmNlMDA6IGZhIGZiIGZiIGZiIGZjIGZjIGZjIGZjIGZhIGZiIGZi
IGZiIGZjIGZjIGZjIGZjDQogZmZmZjg4ODExYmI2Y2U4MDogZmEgZmIgZmIgZmIgZmMgZmMgZmMg
ZmMgZmEgZmIgZmIgZmIgZmMgZmMgZmMgZmMNCj5mZmZmODg4MTFiYjZjZjAwOiBmYSBmYiBmYiBm
YiBmYyBmYyBmYyBmYyBmYSBmYiBmYiBmYiBmYyBmYyBmYyBmYw0KICAgICAgICAgICAgICAgICAg
ICAgICAgIF4NCiBmZmZmODg4MTFiYjZjZjgwOiBmYSBmYiBmYiBmYiBmYyBmYyBmYyBmYyBmYSBm
YiBmYiBmYiBmYyBmYyBmYyBmYw0KIGZmZmY4ODgxMWJiNmQwMDA6IGZhIGZiIGZiIGZiIGZiIGZi
IGZiIGZiIGZiIGZiIGZiIGZiIGZiIGZiIGZiIGZiDQo9PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCm5ldGxpbms6ICdzeXou
OC44ODcnOiBhdHRyaWJ1dGUgdHlwZSAzMiBoYXMgYW4gaW52YWxpZCBsZW5ndGguDQpGQVQtZnMg
KGxvb3AwKTogZXJyb3IsIGZhdF9mcmVlX2NsdXN0ZXJzOiBkZWxldGluZyBGQVQgZW50cnkgYmV5
b25kIEVPRg0KRkFULWZzIChsb29wMCk6IEZpbGVzeXN0ZW0gaGFzIGJlZW4gc2V0IHJlYWQtb25s
eQ0KRkFULWZzIChsb29wMCk6IGVycm9yLCBmYXRfZ2V0X2NsdXN0ZXI6IGludmFsaWQgc3RhcnQg
Y2x1c3RlciAoaV9wb3MgMCwgc3RhcnQgMDAwMDZjNmMpDQpGQVQtZnMgKGxvb3AwKTogZXJyb3Is
IGZhdF9nZXRfY2x1c3RlcjogaW52YWxpZCBzdGFydCBjbHVzdGVyIChpX3BvcyAwLCBzdGFydCAw
MDAwNmM2YykNCg0KVGhhbmtzLA0KRm9ycmVzdDAyMQ0KDQo=

--_000_SN6PR03MB42236942ABF012EBFF3DAAE684042SN6PR03MB4223namp_
Content-Type: text/html; charset="gb2312"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dgb2312">
<style type=3D"text/css" style=3D"display:none;"> P {margin-top:0;margin-bo=
ttom:0;} </style>
</head>
<body dir=3D"ltr">
<div style=3D"font-family: Aptos, Aptos_EmbeddedFont, Aptos_MSFontService, =
Calibri, Helvetica, sans-serif; font-size: 12pt; color: rgb(0, 0, 0);">
Hello,</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
<br>
</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
I found the following issue with syzkaller on:</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
<br>
</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
HEAD commit: &nbsp; &nbsp;7aaa8047eafd (HEAD -&gt; master, tag: v7.0-rc6, o=
rigin/master, origin/HEAD) Linux 7.0-rc6.</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
git tree: &nbsp; &nbsp; &nbsp; https://github.com/torvalds/linux.git master=
</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
console output: https://gist.githubusercontent.com/Forest-kernel/56b58d242f=
61b58d42365ae9e0248108/raw/96ea65abd6b8dc53a269b74323e2f977229bde03/gistfil=
e1.txt</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
kernel config: &nbsp;https://gist.githubusercontent.com/Forest-kernel/354e7=
c56522ab60f29c8b96e7429e2e3/raw/97bb1e7d6f9406da5bd07e999c3634f250a5db0c/co=
nfig.txt</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
dashboard link: N/A for local dashboard</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
compiler: &nbsp; &nbsp; &nbsp; gcc (Ubuntu 12.3.0-1ubuntu1~22.04) 12.3.0</d=
iv>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
userspace arch: x86_64</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
<br>
</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
<br>
</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
I don't have any reproducer for this issue yet.</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
<br>
</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
Suspected root cause:</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
<br>
</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
I suspect this is mainly a lifetime / teardown ordering issue between proce=
ss exit and the scheduler=A1=AFs mm_cid path, with io_uring exit making the=
 race easier to hit.</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
<br>
</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
The faulting task is in schedule_timeout -&gt;wait_for_common, waiting on i=
o_wq_put_and_exit / io_uring_clean_tctx as part of do_exit. The freed objec=
t was released earlier via exit_mmap =A1=FA tear_down_vmas, then kfree thro=
ugh RCU (timer softirq), while another path
 was still tearing down the same mm around exit_group / mmput.</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
<br>
</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
The root cause may be that VMA/mm teardown (including RCU-deferred free) an=
d mm_cid tear-down in context_switch are not properly synchronized=A1=AAso =
when io_uring waits for workers during exit and the task schedules, mm_cid =
still touches memory that tear_down_vmas
 has already freed.</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
<br>
</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
<br>
</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
The following full report also in https://gist.githubusercontent.com/Forest=
-kernel/9b9a1f117dfcd5459ba7d0dfa8868c90/raw/a75ad4d79d4458245a9cf259a93434=
5faac9d7ec/report</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
<br>
</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
BUG: KASAN: slab-use-after-free in instrument_atomic_write include/linux/in=
strumented.h:97 [inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
BUG: KASAN: slab-use-after-free in clear_bit include/asm-generic/bitops/ins=
trumented-atomic.h:41 [inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
BUG: KASAN: slab-use-after-free in mm_drop_cid kernel/sched/sched.h:3812 [i=
nline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
BUG: KASAN: slab-use-after-free in mm_cid_schedout kernel/sched/sched.h:399=
5 [inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
BUG: KASAN: slab-use-after-free in mm_cid_switch_to kernel/sched/sched.h:40=
02 [inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
BUG: KASAN: slab-use-after-free in context_switch kernel/sched/core.c:5287 =
[inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
BUG: KASAN: slab-use-after-free in __schedule+0x22fa/0x3ee0 kernel/sched/co=
re.c:6911</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
Write of size 8 at addr ffff88811bb6cf10 by task syz.6.886/14441</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
<br>
</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
CPU: 4 UID: 0 PID: 14441 Comm: syz.6.886 Not tainted 7.0.0-rc6 #1 PREEMPT(l=
azy)</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/=
2014</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
Call Trace:</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;&lt;TASK&gt;</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;__dump_stack lib/dump_stack.c:94 [inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;dump_stack_lvl+0xab/0xe0 lib/dump_stack.c:120</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;print_address_description mm/kasan/report.c:378 [inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;print_report+0xce/0x610 mm/kasan/report.c:482</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;kasan_report+0xce/0x100 mm/kasan/report.c:595</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;check_region_inline mm/kasan/generic.c:194 [inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;kasan_check_range+0x100/0x1b0 mm/kasan/generic.c:200</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;instrument_atomic_write include/linux/instrumented.h:97 [inline]</div=
>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;clear_bit include/asm-generic/bitops/instrumented-atomic.h:41 [inline=
]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;mm_drop_cid kernel/sched/sched.h:3812 [inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;mm_cid_schedout kernel/sched/sched.h:3995 [inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;mm_cid_switch_to kernel/sched/sched.h:4002 [inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;context_switch kernel/sched/core.c:5287 [inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;__schedule+0x22fa/0x3ee0 kernel/sched/core.c:6911</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;__schedule_loop kernel/sched/core.c:6993 [inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;schedule+0x79/0x2e0 kernel/sched/core.c:7008</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;schedule_timeout+0x217/0x250 kernel/time/sleep_timeout.c:75</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;do_wait_for_common kernel/sched/completion.c:100 [inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;__wait_for_common+0x2ab/0x3e0 kernel/sched/completion.c:121</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;io_wq_exit_workers io_uring/io-wq.c:1367 [inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;io_wq_put_and_exit+0x24d/0x720 io_uring/io-wq.c:1398</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;io_uring_clean_tctx+0xfa/0x170 io_uring/tctx.c:222</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;io_uring_cancel_generic+0x65d/0x8c0 io_uring/cancel.c:650</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;io_uring_files_cancel include/linux/io_uring.h:20 [inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;do_exit+0x34c/0x28e0 kernel/exit.c:916</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;do_group_exit+0xc7/0x280 kernel/exit.c:1118</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;get_signal+0x20d2/0x2150 kernel/signal.c:3034</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;arch_do_signal_or_restart+0x8f/0x7a0 arch/x86/kernel/signal.c:337</di=
v>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;__exit_to_user_mode_loop kernel/entry/common.c:64 [inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;exit_to_user_mode_loop+0x6b/0x4c0 kernel/entry/common.c:98</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;__exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inl=
ine]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:25=
6 [inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;syscall_exit_to_user_mode include/linux/entry-common.h:325 [inline]</=
div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;do_syscall_64+0x46d/0x580 arch/x86/entry/syscall_64.c:100</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;entry_SYSCALL_64_after_hwframe+0x77/0x7f</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
RIP: 0033:0x7f0125a4777d</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 &lt;48&gt; 3d 01 f=
0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
RSP: 002b:00007f0124486fa8 EFLAGS: 00000246 ORIG_RAX: 0000000000000142</div=
>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
RAX: fffffffffffffff8 RBX: 00007f0125cd5fa0 RCX: 00007f0125a4777d</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
RDX: 0000000000000000 RSI: 0000200000000000 RDI: 0000000000000005</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
RBP: 00007f0125ae4d74 R08: 0000000000001100 R09: 0000000000000000</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
R13: 00007f0125cd6038 R14: 00007f0125cd5fa0 R15: 00007f0124467000</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;&lt;/TASK&gt;</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
<br>
</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
Allocated by task 14190 on cpu 1 at 62.890762s:</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;kasan_save_stack+0x33/0x60 mm/kasan/common.c:57</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;kasan_save_track+0x17/0x60 mm/kasan/common.c:78</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;poison_kmalloc_redzone mm/kasan/common.c:398 [inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;__kasan_kmalloc+0x8f/0xa0 mm/kasan/common.c:415</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;kmalloc_noprof include/linux/slab.h:950 [inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;slab_free_hook mm/slub.c:2637 [inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;slab_free mm/slub.c:6165 [inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;kmem_cache_free+0x245/0x3d0 mm/slub.c:6295</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;tear_down_vmas+0x182/0x3a0 mm/mmap.c:1264</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;exit_mmap+0x37f/0x800 mm/mmap.c:1322</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;__mmput kernel/fork.c:1175 [inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;mmput+0x6c/0x320 kernel/fork.c:1198</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;exit_mm kernel/exit.c:581 [inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;do_exit+0x7c1/0x28e0 kernel/exit.c:964</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;do_group_exit+0xc7/0x280 kernel/exit.c:1118</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;__do_sys_exit_group kernel/exit.c:1129 [inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;__se_sys_exit_group kernel/exit.c:1127 [inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;__x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1127</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;x64_sys_call+0x16cd/0x1760 arch/x86/include/generated/asm/syscalls_64=
.h:232</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;do_syscall_64+0xfc/0x580 arch/x86/entry/syscall_64.c:94</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;entry_SYSCALL_64_after_hwframe+0x77/0x7f</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
<br>
</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
Freed by task 144 on cpu 1 at 62.899562s:</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;kasan_save_stack+0x33/0x60 mm/kasan/common.c:57</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;kasan_save_track+0x17/0x60 mm/kasan/common.c:78</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;kasan_save_free_info+0x3b/0x60 mm/kasan/generic.c:584</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;poison_slab_object mm/kasan/common.c:253 [inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;__kasan_slab_free+0x43/0x70 mm/kasan/common.c:285</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;kasan_slab_free include/linux/kasan.h:235 [inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;slab_free_hook mm/slub.c:2685 [inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;slab_free mm/slub.c:6165 [inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;kfree+0x137/0x3b0 mm/slub.c:6483</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;slab_free_after_rcu_debug+0x5d/0x1f0 mm/slub.c:6217</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;rcu_do_batch kernel/rcu/tree.c:2617 [inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;rcu_core+0x521/0x1820 kernel/rcu/tree.c:2869</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;handle_softirqs+0x1b8/0x640 kernel/softirq.c:622</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;__do_softirq kernel/softirq.c:656 [inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;invoke_softirq kernel/softirq.c:496 [inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;__irq_exit_rcu+0xab/0xe0 kernel/softirq.c:723</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1056 [i=
nline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;sysvec_apic_timer_interrupt+0x6c/0x80 arch/x86/kernel/apic/apic.c:105=
6</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtent=
ry.h:697</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
<br>
</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
Last potentially related work creation:</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;kasan_save_stack+0x33/0x60 mm/kasan/common.c:57</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;kasan_record_aux_stack+0x8c/0xa0 mm/kasan/generic.c:556</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;__call_rcu_common.constprop.0+0x71/0x9f0 kernel/rcu/tree.c:3131</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;tear_down_vmas+0x182/0x3a0 mm/mmap.c:1264</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;exit_mmap+0x37f/0x800 mm/mmap.c:1322</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;__mmput kernel/fork.c:1175 [inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;mmput+0x6c/0x320 kernel/fork.c:1198</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;exit_mm kernel/exit.c:581 [inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;do_exit+0x7c1/0x28e0 kernel/exit.c:964</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;do_group_exit+0xc7/0x280 kernel/exit.c:1118</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;__do_sys_exit_group kernel/exit.c:1129 [inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;__se_sys_exit_group kernel/exit.c:1127 [inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;__x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1127</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;x64_sys_call+0x16cd/0x1760 arch/x86/include/generated/asm/syscalls_64=
.h:232</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;do_syscall_64+0xfc/0x580 arch/x86/entry/syscall_64.c:94</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;entry_SYSCALL_64_after_hwframe+0x77/0x7f</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
<br>
</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
The buggy address belongs to the object at ffff88811bb6cf00</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;which belongs to the cache kmalloc-32 of size 32</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
The buggy address is located 16 bytes inside of</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;freed 32-byte region [ffff88811bb6cf00, ffff88811bb6cf20)</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
<br>
</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
The buggy address belongs to the physical page:</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x11bb6c=
</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
flags: 0x200000000000000(node=3D0|zone=3D2)</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
page_type: f5(slab)</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
raw: 0200000000000000 ffff888100042780 dead000000000100 dead000000000122</d=
iv>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
raw: 0000000000000000 0000000000400040 00000000f5000000 0000000000000000</d=
iv>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
page dumped because: kasan: bad access detected</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
<br>
</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
Memory state around the buggy address:</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;ffff88811bb6ce00: fa fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc</di=
v>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;ffff88811bb6ce80: fa fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc</di=
v>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&gt;ffff88811bb6cf00: fa fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp;^</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;ffff88811bb6cf80: fa fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc</di=
v>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp;ffff88811bb6d000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb</di=
v>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
netlink: 'syz.8.887': attribute type 32 has an invalid length.</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
FAT-fs (loop0): error, fat_free_clusters: deleting FAT entry beyond EOF</di=
v>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
FAT-fs (loop0): Filesystem has been set read-only</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
FAT-fs (loop0): error, fat_get_cluster: invalid start cluster (i_pos 0, sta=
rt 00006c6c)</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
FAT-fs (loop0): error, fat_get_cluster: invalid start cluster (i_pos 0, sta=
rt 00006c6c)</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
<br>
</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
Thanks,</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 11pt; c=
olor: rgb(0, 0, 0);">
Forrest021</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
<br>
</div>
</body>
</html>

--_000_SN6PR03MB42236942ABF012EBFF3DAAE684042SN6PR03MB4223namp_--

