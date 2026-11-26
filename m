Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6039A606A326
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 10:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=xHCosdNR
Received: by kanga.kvack.org (Postfix)
	id 63F686B05B0; Thu, 26 Nov 2026 05:16:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C7A66B05B1; Thu, 26 Nov 2026 05:16:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4681F6B05B2; Thu, 26 Nov 2026 05:16:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C5C2C6B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 05:16:54 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 42A69C03B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 10:16:54 +0000 (UTC)
X-FDA: 85476866748.11.17F4E4A
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012049.outbound.protection.outlook.com [52.101.48.49])
	by imf20.hostedemail.com (Postfix) with ESMTP id 056071C0004
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 10:16:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=xHCosdNR;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf20.hostedemail.com: domain of shivankg@amd.com designates 52.101.48.49 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795688211;
	b=nvIpsaH5E6Kzya1iaNQhbepHgJAuiVBHOmHkpvlEVMaCRaQhULR8fh/Ak16MVMvUuvVLDR
	SFtOxUO8Sowf9RFCuzgra886VcAKfpF3I0xbRyEysxnYUahwJcKRoC/u0HLXqEZ/Osiflg
	uGakqJMl6bvbgthfV4Y7WTI7Qcinffo=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795688211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CzqyAn1hWCgWb1WLjhHKabQbW18PpOdumb8fKCUBzqw=;
	b=kFgSOq9pq7BgJS3G5MwYGz3kM6Zmnzl6ewo4zsN4ixxWGjhckCc3NiaTwNxZRS4fYzUfLY
	aChup/uTRe5TA9ma/HYJMi1gkfOdSJT/XxiReGpxuiSmMRekLedbiFVYar9hHjqWDUrsp9
	fkrp9t3GZobo268+c3bSyeNLpBVL2Cc=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=xHCosdNR;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf20.hostedemail.com: domain of shivankg@amd.com designates 52.101.48.49 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iv7JpG52PaHKJO+ogyz72dvEB0s9Ogq29mXWGtIDvDmQFFQpSX7hVEATLV6AhHzKQ7mQCIpNWW1ljKqHh7YZJKM+xPIwfqTB+IPCJyLS54Red4ZMFJWUN8YjO7+MvKlbUV9Vu1s5hBLdTjIpkgyF0ju3zqVhK4xPXvx5DnVN5Vj4g4QfQAyJtP7yv8YjY/H+nhDM/fKg1wdIHLpcmXrQYIeetdjNv/vHS7Km1Awu5cQBtrkK5LHxSqxvLeLxqVqH9YZzhKN7eg9zm5SkkeAUYGEWdA1Ra8vBKbAAn09ozRazcDRWbexnDoQOq0BnML0a50y46XaA3vHlIiZERckXRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CzqyAn1hWCgWb1WLjhHKabQbW18PpOdumb8fKCUBzqw=;
 b=pEc8G21/J55/K5IgU5WRtPsrfiX9wHpOl7DyaESL/dZItkGXqi67pGW8FYefqQgjeC7RQ/phHi1MaL1aQ6IfZ50Tti/ammuyg2RdGuSXlWvBdLyr4PlknKgm47foKF90KImJmbUpGLgNR2UOYdAr4jWW2WhC0/tvrF5l9MZBacMDzmBaNfwpQ1+bdOqqqp7qP16v157cYYH3nZaajlEEXy+6Tb2fjpTSME//Qxv/5Aeaed7JBUiaWwOxssYNKkbjVOYaNxiVlzwSWWWIJSMHzZhcKahqolMpCY8ziYsweGzOCF4742na6ipqe5c04UMpl/3/5V4JY/jjNspGbagBTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CzqyAn1hWCgWb1WLjhHKabQbW18PpOdumb8fKCUBzqw=;
 b=xHCosdNRnjQWFQV6UULTEj8q1rcfpXcyVKHlD5L+mIStqEkMCt6NAReKzvuFkd16ZGWVazMbLOPaoi1BnsXjvLxLOYE5LdSAiVbxvu46cpvUa/2w5z+/eYALirnshMgbyXhLK8knKyfbZGwmdTZxbB/OBZO9lL51Djvnb4KcVp0=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by BN5PR12MB9486.namprd12.prod.outlook.com (2603:10b6:408:2ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 10:16:46 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%6]) with mapi id 15.21.0662.001; Thu, 26 Nov 2026
 10:16:46 +0000
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
Subject: Re: [PATCH v5 1/8] mm/swapfile: add batched version of folio_dup_swap
Thread-Topic: [PATCH v5 1/8] mm/swapfile: add batched version of
 folio_dup_swap
Thread-Index: AQHdfYyLfMw97YCt3ke6mD9MVIcuYbdAI18A
Date: Thu, 26 Nov 2026 10:16:46 +0000
Message-ID: <6793e4948e2d5cd70de3f68224b34dbf931c0054.camel@amd.com>
References: <20261123053543.295467-1-dev.jain@arm.com>
	 <20261123053543.295467-2-dev.jain@arm.com>
In-Reply-To: <20261123053543.295467-2-dev.jain@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5259:EE_|BN5PR12MB9486:EE_
x-ms-office365-filtering-correlation-id: 510baf04-1243-4718-31a0-08df4ba66085
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|4143699003|6133799003|261009223027099003|22082099003|18002099003|56012099006|10067099003|5023799004|11063799006|261028144727099003|261102123227099003|261026121527099003|261026140227099003|261021135927099003|261022075727099003|261022105027099003|261021123027099003|261021121427099003|38070700021;
x-microsoft-antispam-message-info:
 rL2uFXZb3q5gMwyS0PnFq6QOZ3h0qKIs3DBK6o0BDvKWBIIAsstCrOTLCCEe2xesxRvPT/x6okxQ/LmLi9eLXG3aLx7FZOp885pQvOWIHeHOgX4vTmTF65v6F5rpfU6HO908ClQpOo2f7kHLiy9G0G/g8T5KYmSKjpbdegB/PIQVod5LxsEAs4fV1vl2VKd4GzN66LELqIP06RbqrTeZ8tEtcCAsMjCwNJShYcS1Q9sTs7QVM+0oEh+5vKfWvUmu+oXw99/T8E2PnjZ2fIAm91CZdEB3XFG9MJglTaZ7ReBqobbZkM8Ba5dyxTGo/hN7RIZjE46SZHP6QSYdcHOP+pSomNSeXdDiPX4lAx2u6aGhqc9n4BOnIRzYpcE3+Lj2CNqlZT+Xf+OFiMBrxS+BOlabPSwgmRqr+cSg7Ypz5MdXyvGz+9KANh+fo8VUoqYitVM5BlJN2Jb/bXWga/QgJ6499G7PIvLhRsgz7LQjro17mZLqk7FwRTwbjOv7ig6rWLO4xSDEcwm+hBI/unl/96xClU3xoCSF4HeBcxLZnWaaFv4/mRD4ENd4T4dqW90ZTn2m4oGUL25UP33C1Spg0GQOWte1LFH4vO16lYcmMrpWZ6bkCPRcuoC0gSoS5UrQrylCbMG83s+/zTLQuPN6+PgpvkhQw1xXwNTt2I7PqeRxEqbUD89ECbQtaVkDO2Y3gAZNp6HK4wCyDKef8zVFXA4q69FQ5BwwQjIQ1/DqLQo=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(4143699003)(6133799003)(261009223027099003)(22082099003)(18002099003)(56012099006)(10067099003)(5023799004)(11063799006)(261028144727099003)(261102123227099003)(261026121527099003)(261026140227099003)(261021135927099003)(261022075727099003)(261022105027099003)(261021123027099003)(261021121427099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RGpVQzhmTmUxNUFPaGtlbG1lU09GdnJ2WlVZK1JYQWdudEhVK3ZSVS9XTDM0?=
 =?utf-8?B?ZllHYWU3T3lubkVXT0VPMFhwNnFXb200MGQ2aVNFWkx4d1VpNVlOd0xISWtG?=
 =?utf-8?B?TGlSaVpLL2hraEZZNzF6TGd3Q2Jzb0VRS3o2YVg0UFVzNUVJeS9jQVQ3U2NZ?=
 =?utf-8?B?WkFrM2hZaHpaamIrdG4rOFRXcFJzeHZpS3BRZ0VNak1yQ1pSeG9ESFR5VFNw?=
 =?utf-8?B?Q2hZdDR1Q0pNbGJqOEl1K2hyNDhIS1BZVS90NGNCY0hKZlJrRXB6N0JHbE14?=
 =?utf-8?B?WU5HKzl5OGd5RHdacENKTTRuYVdndDFWZ1lKMkVIVVRLd3JUQUJjOEJ0N3lm?=
 =?utf-8?B?a09hZERzMlFSdDJXMERkWXVvTFF1bUJxM0Rla3FoUVNacE1kSURRekxCTWZo?=
 =?utf-8?B?Q2sxSk4yWEZ3dTdTbitTazFHU2pwd3dUKytHcnRtTFM5TmRuc0UxNWFnMG1n?=
 =?utf-8?B?VWlJWUgrdUVmRVY4NC94LzA1djFEN2pLTHN3OVM3UUUxY29wTThnaWFWblBU?=
 =?utf-8?B?WUdYWlE2ZGd2L0xNaXhjT2x5a2NVMFJQRnkxQnJDdzhDbHJVQmExR2RBbEIr?=
 =?utf-8?B?ZjVQVFVMUWdkcVJzbW5wQ2xyVnNJbFBsR0U3eHFzVmxGSFpvV0JuekxCQ0dp?=
 =?utf-8?B?NmNtWUdtbGhPTU5na1V5ZU96a1p0K1ZDVURyM2QxQVJWNURwNGQ3Zkdnak8x?=
 =?utf-8?B?NTZDL1ZZcUlWWk1uMnAzbHBkNk9ZR2dWcGJYc2lGbnh3U05xUVVTZFlHd1Ev?=
 =?utf-8?B?NW12dFRBNmNFeGlQdFUvQnZDTGtjUUtqd3FPQTgveDJiZVF1QkRmd2cwMUdi?=
 =?utf-8?B?OER3YXNnbThWRlVIUUJDSmxDZGNPaUdRQnNsazI3NHFuckNuYUtyZkZqUGo3?=
 =?utf-8?B?ZFEwZlNjU21Za2FPOEJyT2RIK0xMNHUwZHhsMUlWOUtiMnFQajhOWnlNK3No?=
 =?utf-8?B?NHFsYzdjNldYL2pCN2l6SFVSVmJqU1VjblM3d09zaTNQaDQzZVpKa0hFWWt6?=
 =?utf-8?B?bW1ZOWllQTcvS1hiUUtOcVRuSmJRelZ4cTVBYVlSSVZaMFNISFJWYytnQ0Ex?=
 =?utf-8?B?bjZ3MWhpc2V1MktSRWFxUEtIZnJPOXhLMHVqYTg2TThuUXMwNXZmeXFCbW41?=
 =?utf-8?B?M3VyN1pnQ0MxMlBHMElhSmNJQXREc0RaMWMrY0swWFR6UkVkMHA1cmtjMVpZ?=
 =?utf-8?B?TTU2UzQzWGZ1UWlmQ2NmYXhSUW4rTlJWK2NsS251blNQeDlEb29GdXpxcjFm?=
 =?utf-8?B?V2pNYlV2VHVaRkt6SUwweXB4QXIvUWxyeFlTVG9lQitjZ3ZSNkFDRHU1cHRv?=
 =?utf-8?B?QXA3MDNMbkFrNDlHZG9DQ1RLQjI3aThuQWc5YU9oeSs5U1hmWnV4ZHdkemoy?=
 =?utf-8?B?WEdkWWl5UUl5MWpFREtyM3FMMEdmNXFlMXA0ajR2NVhNY2RtdWRWeUVYNEx2?=
 =?utf-8?B?Q1huWXg4UFlvMjhOeGsyOG80OVJ2RkJKU1g4dWFEeVBmRDk0T29tWGMzZWJE?=
 =?utf-8?B?M1ZXZzIxTGprU3FpOXQ3TXBrV083aHhSM2Z5Yy9mVFlHazNjaXVXdDdBelRv?=
 =?utf-8?B?eVpQb3RPNzI0WVVHeWhlclpld2dnYkkxbmNudFhJOHRQR0x3MnJCU2kydEFI?=
 =?utf-8?B?QjdDaC9lbHVUdmc1VGJua25RdXZ4R3ZTS3kzNEJpMjFNcmZHYVNLNjdYdGp0?=
 =?utf-8?B?dHNHRzVHcEprY1hKR21oTzEzVExWMXg4aFpSQlUzSS9rZXVMSUhPdjJpVndr?=
 =?utf-8?B?bDVCSGdSVW9TU2M3UG5mOWgvMW1QV1U1WjAySC9WOTArMTQ3L01KQWJnbmJF?=
 =?utf-8?B?b01MTHJkRWhRQTcwWkU4c2ozMGR4TjVGWHdPaGpoWWhNSklzZGxta29ITHVJ?=
 =?utf-8?B?eHVUODBsMzg3OTVVQTBFWGhMckZpaURJMW0wZm9wL0o2RXJaanAxSDZyU1Ba?=
 =?utf-8?B?Mkk0aWcyYlo4cXg3cTNSbFlBY2hZcjlkYndTYlZGR1piS1paQ2xxNXhyRnE5?=
 =?utf-8?B?cEtvbHRQOGRlU0svWUdTM012WFFCM3NWRmRpUVM3NkVaL1FSVWNCUksrc3ZT?=
 =?utf-8?B?TDlDSG9QUVFyODNXaGNMUWtBNE1qZGNGeEhuNHVjTTJUSTUwcDFnNy9QUUky?=
 =?utf-8?B?YS9wZEpWZkMwMXV1am1NM0tCc0NUSDVuams3bFhCcjNmQUxqdzZDTlZBenNo?=
 =?utf-8?B?Q3dLRVFaYjE0dXNhcXN5cFIwUUdaVUpWbHlsVmI4WFBlWjZvL2U1cVZ5aEJP?=
 =?utf-8?B?aTZLdStWNDdUOHZucHo3SHE0OThHb3dUQUs2dWN2MlhUelE3V1JGYkxWTW5t?=
 =?utf-8?B?c0dmL01uWlhoUWpoK3U1cjlZMW1SSXJKdHQ5Nzdoell0ZWpQQ2VNdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <06F18A248379D340B1152B0A83C1BD97@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 510baf04-1243-4718-31a0-08df4ba66085
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2026 10:16:46.5801
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Gc+qF8aOn3fRIxgMgx9kIvDwRSZ+fHIezHzzjq72eP5qZfXytW4C10UKnh9cWyQTAcNk1LACFXXmQZyAxd80MQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR12MB9486
X-Stat-Signature: frwd6usnm8a9i9i3ayrdkzpdbhpt47h7
X-Rspamd-Queue-Id: 056071C0004
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795688210-338226
X-HE-Meta: U2FsdGVkX19tQTJ4ViDtUQnHNhT8ixyaSYQONHWSalL/pAhCNUlu+98RxfgSjTWr6Le5hJiushI/dL9xSzppD80wMSVEF5G3e5RSUSQo/NcjcLUiz9RLfJDw1x+UnmqSLxLGL5mKD3UHsvyFX4lfVtMUMFxrCeTLedBt1bIyDRBkSxvvcE/OHIBhVVN+xAswv5rUNp9Qbjy6/wRLoy0wnwArZOfsOBSSwG6MkQEBEqC2r2OiQkvqA+V+KtwUmaUFCrNKXhXmq15s1RKkf+IsShaPe/Ra49iB+fgmfN59/TabcuFdncmPajB+UUosd0jIWnrYThh/qhJKS4B9qU2zUCY/zBjyoMubXPVouZCc8XslEvDUOruNY+RFyPlEHkIJnm2DujTTxaHTMXaWm3lHByJyDIz4Uzzz7b4lVoQy4uQR91Lgr5J6aPR5/n2fg4qJ5WhAr9nPVNw29iwlJag3M26OSYJF9M5udcGzn6chxsivI/q3tTvJRVPKqax1OlVsFILGxp3c9SvAjsF7MmDC0GhZKNSZQ3jJl/gmxky8CJAmcW/4FgJkrebM6e1MO57OZ4dFhihMVRqNm/Wopa1mCdaTpn92xIpOxnqBT3J2hsBntMVOHUFQt1FLhBlrkxKRZXIXkR10RKjVM4mpEZlH/pCZ3LDRoSEXLJVJcAzZxx82J6E9DYcOagw4L7mOvappjhTxaW6lwHchFNF4vMITyRZJyDpb3aZoJe6sjv6ZgnP7QCoP/+JZ8iagnMy/Eb9kWG6/y2mEDfJabWBF73va3p5cPFrGAyNAerNFT2LpXbT9xSgMihAFlZFTCc76K3l/4qF6eLCBbthBQ0EyxOEohK/B4dsIqtcrhAl8En2GCUYrFr2yRzp9pqxO1Y4QZB8qg7FzwDGbVaSDSB+TysO9uBB2nssj3YGJYq6tIeJqXrC8uNi0lGku17+EG40Ai6vJBXO3rAdSrzqgSW2i7j+
 DMdGybOY
 33vmqjvv50HUQcPl1Y/0vB/r7wnGCuP8Xp3epWQGW24r8ERh+Pgpbtbv7ukTW5cxPbyxXHqaRoM33ScbJphD6DjB0JVdDaLQx9BI2eMEyYI2glDYaaEnXKYmtNRO5xrg8wpV1JlL7FW1cTfyPl6FeOe6taUk0LQxZyuKAfN7N9flUdlCYbJgoatcLFNUtWt9Q+7w8rSpg9qqA1xFhoXNe4a5M2CPAOLIlZOb4S62SI+t4SHgmBQy551OLYYGdOw+3kdV24jJ+ORHb9NckSzu73/OlYadmAM7jnHAwzUnftC95pIjpbagap3OOhohk5XZ4AEDgJPB5pRBhWAcf+TPHwlRotJTFku9+A1fwwUTACP0u5/6zIXpeZjnjN+rPmceeKLz9bxHZAiULMw5rIDMYffMuiwvgBXtwwxqMnFsoSeg3TtyZwixzmz6jI/4+rCyrPtT7WDqaAsa8Tib+KGwgoKYu1fyCp7gFvPC1xNh37icrTFibGspPGg53ZMr7Gg5EuxH+QL6fFRa6f/UtHE51e8o8+tIW9UjTDovgliTDXiUDa2N8ejtYnaxW6v9gTQsO/K/UxOVnuWOU1eUSWK8C8F8G6Y1DyCfw6OfNkuxusE+QUOidedmRrzhFk2LS0Pf68sYt0vfWCRz+n2Jp9CNRrtqJ2nLnLnCrSZUM5VusrgWyokO2IkEhLU2DNNGgXkryIcp+txCqRPMgs/Rb3xK7T6MgwwZ3H+/pGcEgZiFUfi+G2s8dDuCLa8CzTSEPzpfyQ8l1HM64/3StGQFx0SnDxucYPektbwTgCx+qvPRywq9fIf4RBVHqlUfupDrCSlgUvNiQDMfkRFxdnrQaDeZF2+k5VptLvlqHwT5lVDROGVBFw0U5H1gfJaDV36kXjThaYFAS6NtgQCzXyGv428hfJzjfR19D1HVNIcsn8+GYUAGfLgF/UmGCwutv/B55WLEyKXHE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

T24gTW9uLCAyMDI2LTExLTIzIGF0IDA1OjM1ICswMDAwLCBEZXYgSmFpbiB3cm90ZToNCj4gQWRk
IGZvbGlvX2R1cF9zd2FwX3BhZ2VzIHRvIGhhbmRsZSBhIGJhdGNoIG9mIGNvbnNlY3V0aXZlIHBh
Z2VzLiBOb3RlDQo+IHRoYXQgZm9saW9fZHVwX3N3YXAgYWxyZWFkeSBjYW4gaGFuZGxlIGEgc3Vi
c2V0IG9mIHRoaXM6IG5yX3BhZ2VzID09IDEgYW5kDQo+IG5yX3BhZ2VzID09IGZvbGlvX25yX3Bh
Z2VzKGZvbGlvKS4gR2VuZXJhbGl6ZSB0aGlzIHRvIGFueSBucl9wYWdlcy4NCj4gDQo+IEN1cnJl
bnRseSB3ZSBoYXZlIGEgbm90LXNvLW5pY2UgbG9naWMgb2YgcGFzc2luZyBpbiBzdWJwYWdlID09
IE5VTEwgaWYNCj4gd2UgbWVhbiB0byBleGVyY2lzZSB0aGUgbG9naWMgb24gdGhlIGVudGlyZSBm
b2xpbywgYW5kIHN1YnBhZ2UgIT0gTlVMTCBpZg0KPiB3ZSB3YW50IHRvIGV4ZXJjaXNlIHRoZSBs
b2dpYyBvbiBvbmx5IHRoYXQgc3VicGFnZS4gUmVtb3ZlIHRoaXMNCj4gaW5kaXJlY3Rpb246IHRo
ZSBjYWxsZXIgaW52b2tlcyBmb2xpb19kdXBfc3dhcF9wYWdlcygpIGlmIGl0IHdhbnRzIHRvDQo+
IG9wZXJhdGUgb24gYSByYW5nZSBvZiBwYWdlcyBpbiB0aGUgZm9saW8gKGkuZSBucl9wYWdlcyBt
YXkgYmUgYW55dGhpbmcNCj4gYmV0d2VlbiAxIGFuZCBmb2xpb19ucl9wYWdlcygpKSwgYW5kIGlu
dm9rZXMgZm9saW9fZHVwX3N3YXAoKSBpZiBpdA0KPiB3YW50cyB0byBvcGVyYXRlIG9uIHRoZSBl
bnRpcmUgZm9saW8uDQo+IA0KPiBBY2tlZC1ieTogRGF2aWQgSGlsZGVuYnJhbmQgKEFybSkgPGRh
dmlkQGtlcm5lbC5vcmc+DQo+IFJldmlld2VkLWJ5OiBLYWlydWkgU29uZyA8a2Fzb25nQHRlbmNl
bnQuY29tPg0KPiBSZXZpZXdlZC1ieTogQmFycnkgU29uZyA8YmFvaHVhQGtlcm5lbC5vcmc+DQo+
IFNpZ25lZC1vZmYtYnk6IERldiBKYWluIDxkZXYuamFpbkBhcm0uY29tPg0KPiAtLS0NCj4gIG1t
L3JtYXAuYyAgICAgfCAgMiArLQ0KPiAgbW0vc2htZW0uYyAgICB8ICAyICstDQo+ICBtbS9zd2Fw
LmggICAgIHwgMTggKysrKysrKysrKysrKysrKy0tDQo+ICBtbS9zd2FwZmlsZS5jIHwgMTggKysr
KysrKystLS0tLS0tLS0tDQo+ICA0IGZpbGVzIGNoYW5nZWQsIDI2IGluc2VydGlvbnMoKyksIDE0
IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL21tL3JtYXAuYyBiL21tL3JtYXAuYw0K
PiBpbmRleCAwOWMzM2I5ZWM1ODUuLmVhOTRlNjkwMTBkYSAxMDA2NDQNCj4gLS0tIGEvbW0vcm1h
cC5jDQo+ICsrKyBiL21tL3JtYXAuYw0KPiBAQCAtMjE2Nyw3ICsyMTY3LDcgQEAgc3RhdGljIGJv
b2wgdHR1X2Fub25fc3dhcGJhY2tlZF9mb2xpbyhzdHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZtYSwN
Cj4gIAlzd3BfZW50cnlfdCBlbnRyeSA9IGZvbGlvX3BhZ2Vfc3dhcF9lbnRyeShmb2xpbywgcGFn
ZSk7DQo+ICAJc3RydWN0IG1tX3N0cnVjdCAqbW0gPSB2bWEtPnZtX21tOw0KPiAgDQo+IC0JaWYg
KGZvbGlvX2R1cF9zd2FwKGZvbGlvLCBwYWdlKSA8IDApDQo+ICsJaWYgKGZvbGlvX2R1cF9zd2Fw
X3BhZ2VzKGZvbGlvLCBwYWdlLCAxKSA8IDApDQo+ICAJCXJldHVybiBmYWxzZTsNCj4gIA0KPiAg
CS8qDQo+IGRpZmYgLS1naXQgYS9tbS9zaG1lbS5jIGIvbW0vc2htZW0uYw0KPiBpbmRleCA4MWMx
ZDYzZGUzMzQuLmFmZjQ2YjI1MDhhNyAxMDA2NDQNCj4gLS0tIGEvbW0vc2htZW0uYw0KPiArKysg
Yi9tbS9zaG1lbS5jDQo+IEBAIC0xOTg2LDcgKzE5ODYsNyBAQCBpbnQgc2htZW1fd3JpdGVvdXQo
c3RydWN0IHN3YXBfaW9fY3R4ICpjdHgsIHN0cnVjdCBmb2xpbyAqZm9saW8sDQo+ICAJCSAqLw0K
PiAgCQlzaG1lbV9kaXNhbGxvd19ldmljdGlvbihpbmZvKTsNCj4gIA0KPiAtCQlmb2xpb19kdXBf
c3dhcChmb2xpbywgTlVMTCk7DQo+ICsJCWZvbGlvX2R1cF9zd2FwKGZvbGlvKTsNCj4gIAkJc2ht
ZW1fZGVsZXRlX2Zyb21fcGFnZV9jYWNoZShmb2xpbywgc3dwX3RvX3JhZGl4X2VudHJ5KGZvbGlv
LT5zd2FwKSk7DQo+ICANCj4gIAkJQlVHX09OKGZvbGlvX21hcHBlZChmb2xpbykpOw0KPiBkaWZm
IC0tZ2l0IGEvbW0vc3dhcC5oIGIvbW0vc3dhcC5oDQo+IGluZGV4IGQ1YmYyMWY1MTdkYy4uZWE3
MTBjZWM5ODZjIDEwMDY0NA0KPiAtLS0gYS9tbS9zd2FwLmgNCj4gKysrIGIvbW0vc3dhcC5oDQo+
IEBAIC0yNDQsNyArMjQ0LDggQEAgZXh0ZXJuIGludCBzd2FwX3JldHJ5X3RhYmxlX2FsbG9jKHN3
cF9lbnRyeV90IGVudHJ5LCBnZnBfdCBnZnApOw0KPiAgICogZm9saW9fcHV0X3N3YXAoKTogZG9l
cyB0aGUgb3Bwb3NpdGUgdGhpbmcgb2YgZm9saW9fZHVwX3N3YXAoKS4NCj4gICAqLw0KPiAgaW50
IGZvbGlvX2FsbG9jX3N3YXAoc3RydWN0IGZvbGlvICpmb2xpbyk7DQo+IC1pbnQgZm9saW9fZHVw
X3N3YXAoc3RydWN0IGZvbGlvICpmb2xpbywgc3RydWN0IHBhZ2UgKnBhZ2UpOw0KPiAraW50IGZv
bGlvX2R1cF9zd2FwX3BhZ2VzKHN0cnVjdCBmb2xpbyAqZm9saW8sIHN0cnVjdCBwYWdlICpwYWdl
LA0KPiArCQl1bnNpZ25lZCBsb25nIG5yX3BhZ2VzKTsNCj4gIHZvaWQgZm9saW9fcHV0X3N3YXAo
c3RydWN0IGZvbGlvICpmb2xpbywgc3RydWN0IHBhZ2UgKnBhZ2UpOw0KPiAgDQo+ICAvKiBGb3Ig
aW50ZXJuYWwgdXNlICovDQo+IEBAIC0zNjgsNyArMzY5LDggQEAgc3RhdGljIGlubGluZSBpbnQg
Zm9saW9fYWxsb2Nfc3dhcChzdHJ1Y3QgZm9saW8gKmZvbGlvKQ0KPiAgCXJldHVybiAtRUlOVkFM
Ow0KPiAgfQ0KPiAgDQo+IC1zdGF0aWMgaW5saW5lIGludCBmb2xpb19kdXBfc3dhcChzdHJ1Y3Qg
Zm9saW8gKmZvbGlvLCBzdHJ1Y3QgcGFnZSAqcGFnZSkNCj4gK3N0YXRpYyBpbmxpbmUgaW50IGZv
bGlvX2R1cF9zd2FwX3BhZ2VzKHN0cnVjdCBmb2xpbyAqZm9saW8sIHN0cnVjdCBwYWdlICpwYWdl
LA0KPiArCQl1bnNpZ25lZCBsb25nIG5yX3BhZ2VzKQ0KPiAgew0KPiAgCXJldHVybiAtRUlOVkFM
Ow0KPiAgfQ0KPiBAQCAtNDY0LDYgKzQ2NiwxOCBAQCBzdGF0aWMgaW5saW5lIHZvaWQgX19zd2Fw
X2NhY2hlX3JlcGxhY2VfZm9saW8oc3RydWN0IHN3YXBfY2x1c3Rlcl9pbmZvICpjaSwNCj4gIH0N
Cj4gICNlbmRpZiAvKiBDT05GSUdfU1dBUCAqLw0KPiAgDQo+ICsvKioNCj4gKyAqIGZvbGlvX2R1
cF9zd2FwKCkgLSBJbmNyZWFzZSBzd2FwIGNvdW50IG9mIGFsbCBzd2FwIGVudHJpZXMgb2YgYSBm
b2xpby4NCj4gKyAqIEBmb2xpbzogZm9saW8gd2l0aCBzd2FwIGVudHJpZXMgYm91bmQuDQo+ICsg
Kg0KPiArICogU2VlIGZvbGlvX2R1cF9zd2FwX3BhZ2VzKCkgZm9yIG1vcmUgaW5mb3JtYXRpb24u
DQo+ICsgKi8NCj4gK3N0YXRpYyBpbmxpbmUgaW50IGZvbGlvX2R1cF9zd2FwKHN0cnVjdCBmb2xp
byAqZm9saW8pDQo+ICt7DQo+ICsJcmV0dXJuIGZvbGlvX2R1cF9zd2FwX3BhZ2VzKGZvbGlvLCBm
b2xpb19wYWdlKGZvbGlvLCAwKSwNCj4gKwkJCQkgICAgZm9saW9fbnJfcGFnZXMoZm9saW8pKTsN
Cj4gK30NCj4gKw0KPiAgZXh0ZXJuIGNvbnN0IHN0cnVjdCBzd2FwX29wcyBzd2FwX2JkZXZfb3Bz
Ow0KPiAgDQo+ICBpbnQgc2htZW1fd3JpdGVvdXQoc3RydWN0IHN3YXBfaW9fY3R4ICpjdHgsIHN0
cnVjdCBmb2xpbyAqZm9saW8sDQo+IGRpZmYgLS1naXQgYS9tbS9zd2FwZmlsZS5jIGIvbW0vc3dh
cGZpbGUuYw0KPiBpbmRleCBjMmFmMTNlYjE1YjMuLmE3ZDdlMWY4MWM3OSAxMDA2NDQNCj4gLS0t
IGEvbW0vc3dhcGZpbGUuYw0KPiArKysgYi9tbS9zd2FwZmlsZS5jDQo+IEBAIC0xODA0LDkgKzE4
MDQsMTAgQEAgaW50IGZvbGlvX2FsbG9jX3N3YXAoc3RydWN0IGZvbGlvICpmb2xpbykNCj4gIH0N
Cj4gIA0KPiAgLyoqDQo+IC0gKiBmb2xpb19kdXBfc3dhcCgpIC0gSW5jcmVhc2Ugc3dhcCBjb3Vu
dCBvZiBzd2FwIGVudHJpZXMgb2YgYSBmb2xpby4NCj4gKyAqIGZvbGlvX2R1cF9zd2FwX3BhZ2Vz
KCkgLSBJbmNyZWFzZSBzd2FwIGNvdW50IG9mIHN3YXAgZW50cmllcyBvZiBhIGZvbGlvLg0KPiAg
ICogQGZvbGlvOiBmb2xpbyB3aXRoIHN3YXAgZW50cmllcyBib3VuZGVkLg0KPiAtICogQHBhZ2U6
IGlmIG5vdCBOVUxMLCBvbmx5IGluY3JlYXNlIHRoZSBzd2FwIGNvdW50IG9mIHRoaXMgcGFnZS4N
Cj4gKyAqIEBwYWdlOiB0aGUgZmlyc3QgcGFnZSBpbiB0aGUgZm9saW8gdG8gaW5jcmVhc2UgdGhl
IHN3YXAgY291bnQgZm9yLg0KPiArICogQG5yX3BhZ2VzOiB0aGUgbnVtYmVyIG9mIHBhZ2VzIGlu
IHRoZSBmb2xpbyB0byBpbmNyZWFzZSB0aGUgc3dhcCBjb3VudCBmb3IuDQo+ICAgKg0KPiAgICog
VHlwaWNhbGx5IGNhbGxlZCB3aGVuIHRoZSBmb2xpbyBpcyB1bm1hcHBlZCBhbmQgaGF2ZSBpdHMg
c3dhcCBlbnRyeSB0bw0KPiAgICogdGFrZSBpdHMgcGxhY2U6IFN3YXAgZW50cmllcyBhbGxvY2F0
ZWQgdG8gYSBmb2xpbyBoYXMgY291bnQgPT0gMCBhbmQgcGlubmVkDQo+IEBAIC0xODIwLDE4ICsx
ODIxLDE1IEBAIGludCBmb2xpb19hbGxvY19zd2FwKHN0cnVjdCBmb2xpbyAqZm9saW8pDQo+ICAg
KiBzd2FwX3B1dF9lbnRyaWVzX2RpcmVjdCBvbiBpdHMgc3dhcCBlbnRyeSBiZWZvcmUgdGhpcyBo
ZWxwZXIgcmV0dXJucywgb3INCj4gICAqIHRoZSBzd2FwIGNvdW50IG1heSB1bmRlcmZsb3cuDQo+
ICAgKi8NCj4gLWludCBmb2xpb19kdXBfc3dhcChzdHJ1Y3QgZm9saW8gKmZvbGlvLCBzdHJ1Y3Qg
cGFnZSAqcGFnZSkNCj4gK2ludCBmb2xpb19kdXBfc3dhcF9wYWdlcyhzdHJ1Y3QgZm9saW8gKmZv
bGlvLCBzdHJ1Y3QgcGFnZSAqcGFnZSwNCj4gKwkJdW5zaWduZWQgbG9uZyBucl9wYWdlcykNCj4g
IHsNCj4gLQlzd3BfZW50cnlfdCBlbnRyeSA9IGZvbGlvLT5zd2FwOw0KPiAtCXVuc2lnbmVkIGxv
bmcgbnJfcGFnZXMgPSBmb2xpb19ucl9wYWdlcyhmb2xpbyk7DQo+ICsJc3dwX2VudHJ5X3QgZW50
cnkgPSBmb2xpb19wYWdlX3N3YXBfZW50cnkoZm9saW8sIHBhZ2UpOw0KPiArCXVuc2lnbmVkIGxv
bmcgaWR4ID0gZm9saW9fcGFnZV9pZHgoZm9saW8sIHBhZ2UpOw0KPiAgDQo+ICAJVk1fV0FSTl9P
Tl9GT0xJTyghZm9saW9fdGVzdF9sb2NrZWQoZm9saW8pLCBmb2xpbyk7DQo+ICAJVk1fV0FSTl9P
Tl9GT0xJTyghZm9saW9fdGVzdF9zd2FwY2FjaGUoZm9saW8pLCBmb2xpbyk7DQo+IC0NCj4gLQlp
ZiAocGFnZSkgew0KPiAtCQllbnRyeSA9IGZvbGlvX3BhZ2Vfc3dhcF9lbnRyeShmb2xpbywgcGFn
ZSk7DQo+IC0JCW5yX3BhZ2VzID0gMTsNCj4gLQl9DQo+ICsJVk1fV0FSTl9PTl9GT0xJTyhpZHgg
KyBucl9wYWdlcyA+IGZvbGlvX25yX3BhZ2VzKGZvbGlvKSwgZm9saW8pOw0KPiAgDQo+ICAJcmV0
dXJuIHN3YXBfZHVwX2VudHJpZXNfY2x1c3Rlcihzd2FwX2VudHJ5X3RvX2luZm8oZW50cnkpLA0K
PiAgCQkJCQlzd3Bfb2Zmc2V0KGVudHJ5KSwgbnJfcGFnZXMpOw0KDQpMb29rcyBnb29kIQ0KDQpS
ZXZpZXdlZC1ieTogU2hpdmFuayBHYXJnIDxzaGl2YW5rZ0BhbWQuY29tPg0KDQpUaGFua3MsDQpT
aGl2YW5rDQo=

