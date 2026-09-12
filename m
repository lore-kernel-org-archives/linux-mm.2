Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AB60C79FB6
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 09:59:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 341D66B0088; Sat, 12 Sep 2026 05:59:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EBE96B008C; Sat, 12 Sep 2026 05:59:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B45F6B0092; Sat, 12 Sep 2026 05:59:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E30836B0088
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 05:58:59 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B796BA04A2
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 09:58:58 +0000 (UTC)
X-FDA: 85204661556.23.279CF37
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011038.outbound.protection.outlook.com [52.101.52.38])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9726A120008
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 09:58:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=XCawliH5;
	spf=pass (imf29.hostedemail.com: domain of shivankg@amd.com designates 52.101.52.38 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789207135;
	b=Kwfsxo+jLIuuCR5V+M6qCPQnNtDEXUZdsDTJPh8ItVeUVWp8SXuT6IYN90k8NLjiKoxX20
	y91z439tUNVU3ykyGWlFts3KezHaQmqM9FHhbTUZyw0Q5V/LDiZojC+So2M/TPv/kapf0x
	81VDXSDtLbcyyXR6S7IE8PdmSWEwe5U=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=XCawliH5;
	spf=pass (imf29.hostedemail.com: domain of shivankg@amd.com designates 52.101.52.38 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789207135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i2ZA14WBYFZQOe46QW2tXrcezc9HWMdcJVOTQCueX7s=;
	b=20pT50wo/a2wgFxkch8X9IEEHMTeIOZqQi5+MegcrgWVEE8MuRFZQXcGDXHSobsvVdrBa6
	40G2jKWTRMq9ZdFjnYjT1JfZXz6Ek08cBjxt2XLirnqkoVQTZTooI1/+S4q6RNhNbB0Cmo
	mzxpQIIF2AIWqZCZd/A0fcarWJYsFCI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BJqQJgKsytdAuUtA/kG3lU2rcXVVcILonbzvr0qy/4g74R0381eXtHjYCPcm8Fra3+PlJebviBHTmQ3wP1keQUSztIctP1MJ6wKPUJUR6x70EM2iV/Z4It8Ld2R6t70xRQt8drRF3tNmirRDEmUiJJpUSw6tQNxxSZ9X5uk+QEXOw9AZCaCChcxHyZU6aUinrj83kdQYPrUt/qsGx2TO/gp6EpXQgoXQr+rjvAX4Sp9k6Vl6QP5wdVozu5SPzRlx+iTYQsi1il+Qt3cRf7Z5uB7Eavc9OVw5IGcbK62SQ7IITo0L7Sc2eM1LmCyk0OCzObR2xkSMeyqebsSom+NU+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i2ZA14WBYFZQOe46QW2tXrcezc9HWMdcJVOTQCueX7s=;
 b=Umo/FsUX11Jlc1AZk2xRSHmAWBe2cyctM3tE3GGKicWGxUAYjsLmE09+/xxrEztZqn5U8Cor743L/F35Rj9bx1O8b3LEAdE344lrxhMBAtbZVxUJi/gXiz0HtUNrmF1n7C6v6scGDFZT1wJF5FQnt6dCUecLpA0nxrKOdkxyttqJDI/pJfhnu9NiPdv13DXmp/zWMG4X43kluoui68NZAzSPjzc6jfLc99Giliq0Z+sig2xyUV1tjWksFssnWiGnQolIxMOwQEYewDrmjRx+Qu0PnsohZlrhezl0OwoC+YBXOHjz/4/ZyftMJjjp49NbwIMsEQEQqdstZb5HAGQcMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i2ZA14WBYFZQOe46QW2tXrcezc9HWMdcJVOTQCueX7s=;
 b=XCawliH5c3jw51Xls1Ub0gp4HcbdTfCBoemNcBujM7D4xO/EYxEGwnx2zlM8sDlFggm8mra81/s7Ufteih7UeFnVJW9EO7FGuhntRyWSMVaA5hGeqpqF1Yk1cYcmpk/WW9FDedgZU7TR/cUc+Z6vEoRMnLZPUVNwgUcqazrVafY=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by CY8PR12MB7244.namprd12.prod.outlook.com (2603:10b6:930:57::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.8; Sat, 12 Sep
 2026 09:58:49 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%2]) with mapi id 15.21.0406.007; Sat, 12 Sep 2026
 09:58:48 +0000
From: "Garg, Shivank" <shivankg@amd.com>
To: "baohua@kernel.org" <baohua@kernel.org>
CC: "hughd@google.com" <hughd@google.com>, "npache@redhat.com"
	<npache@redhat.com>, "rppt@kernel.org" <rppt@kernel.org>, "vbabka@kernel.org"
	<vbabka@kernel.org>, "david@kernel.org" <david@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "dev.jain@arm.com"
	<dev.jain@arm.com>, "surenb@google.com" <surenb@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "usama.arif@linux.dev"
	<usama.arif@linux.dev>, "ackerleytng@google.com" <ackerleytng@google.com>,
	"ziy@nvidia.com" <ziy@nvidia.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "liam@infradead.org" <liam@infradead.org>,
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
	"joannelkoong@gmail.com" <joannelkoong@gmail.com>, "mhocko@suse.com"
	<mhocko@suse.com>, "ljs@kernel.org" <ljs@kernel.org>, "lance.yang@linux.dev"
	<lance.yang@linux.dev>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Subject: Re: [RFC PATCH v3 0/4] mm: enable lru cache for smaller large folios
Thread-Topic: [RFC PATCH v3 0/4] mm: enable lru cache for smaller large folios
Thread-Index: AQHdQf3fICyyO0LhU0GvisAZrBhdzbbJg1QAgABfgICAANPJgA==
Date: Sat, 12 Sep 2026 09:58:48 +0000
Message-ID: <966a7f6a4cd941bdab7161ad28fa5f8578225518.camel@amd.com>
References: <20260818225904.55236-1-baohua@kernel.org>
		 <08f63301a58f0e0c38480553295ad9af95928da6.camel@amd.com>
	 <CAGsJ_4yjHqSFtmHrRKgE1JrJpQKw5oBs1cuX1_mQ_r0wKdMdYw@mail.gmail.com>
In-Reply-To:
 <CAGsJ_4yjHqSFtmHrRKgE1JrJpQKw5oBs1cuX1_mQ_r0wKdMdYw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5259:EE_|CY8PR12MB7244:EE_
x-ms-office365-filtering-correlation-id: bdc58ab1-3b16-4091-4415-08df10b47128
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|23010399003|38070700021|56012099006|11063799006|4143699003|5023799004|10067099003|22082099003|18002099003;
x-microsoft-antispam-message-info:
 QL+WmF3oRjAIGC6Bd1QJ8CB4LvQO+iOMJmQxWlJ2cGeoP/8qpghevmpwr/4u3SGZ684Z8N66kOC+Re24KHTXiqCqNJzI6OuzdfJ1LhDb3jTc8IrEvTuoyR8cPQmTqTdGvYvjVLJV6Aj9ZlCXhM5WBxBtWLvVu0rCxUFFRfDNIQn2DWATrcEMSc7DBrPaKg8yRLTNheI+GPXDksrbhESkhr8O3bhUP3LVxrn18uuVTBCwRWSuJ8MR9ewHbS3DsSznJBHKOM7wt5w1/kNSieHGxZTRa/qXoTxtQcmbARvWhXdoUz1sNKJeDgP8xvxbyg8iu6w3rkDVEEEQz3DjH7sHMjc6DtS4Sk9wh4NsvRs+YAplnKhaHd8WjfPKCTteABjYHKIsFEYLhQ9IvpqaJaGSpNvvfH4cAKJq7snhksD1YwT7R2LOJZ5txW2J0bIMDKWjNrj+msiVWOUJIFASS8phMtHUVY9alt+7v5JEK2A7IBBMu5ld6t8wLxsl4+CFCXGCzQ/HOpj4N+c3mwLXhbU5drSQO05kjZfPsOl0wTZ1nE1+BE42wwPjL5ZJ3ow/aUDdkKAp8uySCVwts+xuyk6u9oEcY3GiR5+rVr55XNs7zlOoAIJgeeIqC8ZljrsQo25SAMaCv/3Ijde8sK586khqm0leIs8HXqdT1X8zebuC3+qHWDQ1gVA6s7diF92o6z1O2AIgAu206v+kH63WjCx2Wn5vEViOporRt5tbUI1dbi8=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(23010399003)(38070700021)(56012099006)(11063799006)(4143699003)(5023799004)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?b3hFaHhVNTRpbU5taVdyZTJOc2FNL1JtOHBacHk0b2JkR1RpL1hTQ0x2cnow?=
 =?utf-8?B?Vlk1NlZnY3llN2QxSitudUxSU25CRHBIVDRONkdDb3ZlMStFNEdTbGVreWxD?=
 =?utf-8?B?cmRBa3dMblVnOC9NaVVPS2plSmRJUExKTG8yNml3VDg1bk00V2tuWFB3Q2lo?=
 =?utf-8?B?RndWb0Fvc0N2bFJwOVBERWxIMXVUMWcxYnpuY05ZVUNKdnZkWFk1RlhJV2Jk?=
 =?utf-8?B?YkxiNFVlMmNCdit2ZlArUkNQNEI2eXJBMFBsa0UyNkV0ZFZqWHJ6b0dvUEsx?=
 =?utf-8?B?Nko3UTlsY0pGUjNGc2dkQmJPSTVNdEY4VWp0eXZMZU1WQWxiMVY3bzg2Yzhi?=
 =?utf-8?B?SDRwVG0zdU1FNDdYOThub0VVWm5xaG1xdXdZM3o3dVBEbmRrbmxENGk2amlM?=
 =?utf-8?B?TzNubGk0ZS9RSXdnK2hzdjFzMWNxKzZMd2loZUNiY3lFMWYxVE4ycm0yYWNl?=
 =?utf-8?B?WWVKZEVMTmVnN3RRcEF4amhoUXpqd08vTnlOMFJNczYxM2lFSVhQTlhuekI1?=
 =?utf-8?B?ZklwR0dFS1RlZXlyaVh2TnJVUVprVUl4L0tFK2UzeTRBTGZOOGdGQjlZcWZC?=
 =?utf-8?B?SjVhbzJ3TldxUHV1VkV1V3lqNGEyY1JVQ29lUzFueXpFb1R0NWFpWFc4Wnl1?=
 =?utf-8?B?VG42eXlzK3RhMW0remFjT0kxemhqYUc4N2dGQ3JWcTR6c0xPVmpwZ0FTZzl3?=
 =?utf-8?B?cVNKMk5MQzc5c1Z4d1lmM0FQaDRQa1M3bkdBU21WWllCeFRGblRBT0F4N1M2?=
 =?utf-8?B?eVhSZG5zZnhxZytsZUZmYXNtSGVra1hVMFFmSXkxN3dGd0REOFg5M1dVRnRx?=
 =?utf-8?B?aWVsWnZ3cTJWbGNPbmI1U0lhY3NLYURHVEs3MUZHd0hBNnBoM0xZVTIxd1hF?=
 =?utf-8?B?NDFXRkhBZkRVenpqZTd4VkduNGI3QW5XblFmcE9VTVY5QnkyVW5TU3BwRjFM?=
 =?utf-8?B?ektEVGs1TzR2ZFdLemNqcmlTNkZVdlhITWZtN0I0d1g4VFFwUGgxaFAycHhn?=
 =?utf-8?B?RmpYUVRLWEdEUGpGUGFyTDFuY0xkdG4yYzh4OTZ5VXVwNzVKNTVIbXdobW9Z?=
 =?utf-8?B?V1NwMDZoaU8xblJhODIxeDE1UW1kcTlQQ2pQd3RVcHd2SGJJUU1ZNVBwbVk0?=
 =?utf-8?B?MDV2NmU3MUZ6RVFaUGNZempHWTk5U3FIckNIVnAyM2hISXBYM1AxMzZqTWVH?=
 =?utf-8?B?cjdBcUxIQlc2YmRGK2M0b3d2a1p2OUt1SjVXZk0yQzViNUF2TXhNUStuOUVj?=
 =?utf-8?B?YTE0ODVsSCt5em9GVSt5L1F6R3JYSlN1VVdBQzdRKzI2SjRydCs3dk1mTS9j?=
 =?utf-8?B?TlR5M2NiVGlGZGQ5WmRQRHNrSnB2d2Y0YWpOd2w3TFVnQlNCUy9GK3VKWU5C?=
 =?utf-8?B?TFdmMUVLQWNEMW5TSG1VemNKTTBCb1hSOWFURU81VWtNZ2hMU3ZxQ0xuTVVx?=
 =?utf-8?B?VzJncy9FYlRZSXZWVXQ5azBKazVPRjNudVpJdk5RNzVZOHlUTUpNaEtldVBy?=
 =?utf-8?B?UExDTEhGZ3JhUjkraXhYMm5oWitpYXIwVGNFd0phMWVjUC9WaFNxcWtGWVlW?=
 =?utf-8?B?Q3pQMjMwWklMMCt3Y2hLNWZBRDE1VWhEcERhQmNoYXZiazEva1lMd1pnSndk?=
 =?utf-8?B?bFpXeC9TWVJPVW5XcEw0M3VHYm15UHZkY0FITDZjS1R6VStJZFF0bUwzQTk4?=
 =?utf-8?B?YVpXajU3NUZicWpEVDB3b1Bva1cwN2w3UmJuQXJVbmsvSWVnZ0xhOHp5RGEy?=
 =?utf-8?B?NlptcVVLOGdnTERUSzY0MHFqamszZENiTXZmaG1qcUFlczJ1OVFNSzVEdEIw?=
 =?utf-8?B?MkJKY01paVhlVEdheHlXSVVDZXFMREJmTVljQnhIeHBJcVlIbmN3RDZmQUdM?=
 =?utf-8?B?SXA1TlZwb0t6ZkJSNi9DR0MycWpDUW5Xek15cURqc1BHOHAxc1lud215cWI5?=
 =?utf-8?B?Ujl3d0tPR3dQNzE0MlJtNDhNa044eEdMOUlRdmFhZGxHSWw3MDJ0RlNMTXpl?=
 =?utf-8?B?anVLQmdYVXVqRzY0MGFuL3g1S2FLK3BWWVIxSE1PWCtIcUFaN3QvellIREZG?=
 =?utf-8?B?YjJ6dkR2VDlzc0lsdGNlL1E4MVZISmtESkh3a0hjY2NTT2ZJRHBackcydTIw?=
 =?utf-8?B?aVcrTzRSVVFhOGY0TndyUmZsQWNrUzJLb1FhZWxYbHkreDV0Nmo3U05vQ1kw?=
 =?utf-8?B?VUFyOWhZL3ZNYnl5RFhhdmQreWxOS1BvekViN2RlS01RWGFEbzB1SDlhdTFQ?=
 =?utf-8?B?T2ZqWVlmS3pFTUFnc1dvcFNEUGxiSmFQQit1MUZtYWpFY1BqNHNZcHNqWUxn?=
 =?utf-8?B?NExYUDgrTXEvQmluQ1ZvNlZEVG9EM3FQbnpsNFJmWENQRVZEdVpUQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <223CCF527548B648A95C4E9CE6D797A8@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdc58ab1-3b16-4091-4415-08df10b47128
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2026 09:58:48.8048
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3UREknF62uCexWzOPewIfhGkkWykjCa98yqRKtKlCq1aozPwgAc3sfD0/GceHuEgGLE9z56h98RWTZqnF0pFQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7244
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9726A120008
X-Rspam-User: 
X-Stat-Signature: dmzd9daohm1wtzdhooxff3itye5rbbcs
X-HE-Tag: 1789207135-56619
X-HE-Meta: U2FsdGVkX19PXkolQJ8aFZR82Bg606IEeQgA7EtksCvUTjFvLmL1NkzWN8gN3An8FErJC/OPAFRQFd6EqTqPCBiCqZCI5DHQw1v7r+wKrFDtJosI6xdRHVqNVvNSA8uO7J6TtGyJRwByUXxySzdwCOMXcNeuSqrBGez1ov6REvLNRXDsphGh3z/WC1MpE1h6OywuW4fLeMY7PvbxEwhQW4V888m18zEV6Py4Cw367WulEixKxs9qxs25enCfn9Y3V1gWzEPbI06okh+xeIM9ufi2yBY+caFGgOoH8Y4QtKR/YdMlHr7L9L6ZQDnSVpH0NxLxZbzDGotjqzEW8ywNNAPhRI2B+QNnnw0AH39XhtUCAYxLXV5W4yOhndxbClM3JcaaUz9DebOTrO5vTwFLJtuNMN/QZUp0rQVfpIUIrtFr+dMLZIju3y3XJUKOO5DlrRRCxvqBpz5CLV+Yp2fbOZU4aeJj+QIRGUtE+CVVx+SzQcpm4SPaRmao9xDAgeMnvRx8rs5+zy6hCGTrUWwGEww9mEx5oov7JBq1FXuW7WuKrcszYVABHKBJR1doF413I+QrjUXnxuV/fmswnZDsW5p6aMNU1A8qc2LmmRwqizJyh9ZvQmyhque29xNIlp6VY5terzgSsq98GZ9juAqs32dxuTeFj3MEWFCcWojNPpJRhtLZiGy6dTKpSHh9wi5wpKzJ/5LphorQgY3fU25c34arBh0NlGq4uGuco076QJ6euWpuNJEH0N+lBu2yJf1jyUS6B4x0A4tiQyAbavWzRo+P9X8fL8CcQ6+Or4rPU7GAfQnvf6guQmtN4Nx+zzQ1U3/zAA94tWzJ+yAkxCXIPoBpN6/TVTcQ3b8r8dNRNu/op4juAD8j2hckpR0Z9htD3xsgLj77tMAvOO54tgiJpx3UW41fm+goxoQkzANCapzVPtY+wneOMl3A4mBVoDIdEUjD8ynu+kqSyrrkD/3
 3m6q8k33
 Y0pHVIWtkKrA+9s1+UIC7uCwBLMG8vBjVzw9vKaiAzxOHGRiug+SymmBEqnESUL3MWWrnUyq3WbU581YYpwqqCWuxicMPymV2386MdEG64U+pBMVRxamvz7l1mWzvMg/GQ30YAEXkqxzUzvOZV9lXlnH7GhkK6Ib8yXUgqI9V1EyzkELYYYnCrqf/AMEqfGTmJ1KL4pW3H4O23QO7UzRvMfVCo68lHD9gZo6UjOQuH8ZtBBiwYVrzDUf1eGGax2Y7ls1DU9m91XsazmVKROFnong3eabBYM9y6uOaP6djt5RhaBNcqb2bhyJE8TDUtZqCmLWWo+uSpJN39qfgcVhriJSykivb/c1TkkgVdi2K7ZtgznXt4vlQuvWsc64j4agigPfeCmajrjVEPH2uXL7yJTVDNxxUM6XIFYCJppvGr/sdVmhaft3LGZgm6/h/bf41bwpgu9JaWCSfM0AfXhV217dXpkU11IaDRdek
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gU2F0LCAyMDI2LTA5LTEyIGF0IDA1OjIwICswODAwLCBCYXJyeSBTb25nIHdyb3RlOg0KPiBP
biBGcmksIFNlcCAxMSwgMjAyNiBhdCAxMTozOeKAr1BNIEdhcmcsIFNoaXZhbmsgPHNoaXZhbmtn
QGFtZC5jb20+IHdyb3RlOg0KPiBbLi4uXQ0KPiA+IA0KPiA+IFRoYW5rcyBmb3IgdGhpcyBzZXJp
ZXMuDQo+ID4gSSB0ZXN0ZWQgdGhpcyBhZ2FpbnN0IGEgR3JhcGg1MDAgcmVncmVzc2lvbiB3aXRo
IDE2SyBtVEhQLg0KPiA+IFRoZSBzZXJpZXMgcmVtb3ZlcyB0aGUgcmVncmVzc2lvbiBhbmQgcmVk
dWNlcyBmb2xpb19scnV2ZWNfbG9ja19pcnFzYXZlIGNvbnRlbnRpb24gdG8gYXBwcm94aW1hdGVs
eSB0aGUgNEsgcmF0ZS4NCj4gPiANCj4gPiANCj4gPiBUZXN0ZWQtYnk6IFNoaXZhbmsgR2FyZyA8
c2hpdmFua2dAYW1kLmNvbT4NCj4gPiANCj4gDQo+IFRoYW5rcyB2ZXJ5IG11Y2gsIFNoaXZhbmsu
IEnigJltIHZlcnkgaGFwcHkgdG8gc2VlIHRoYXQNCj4gbVRIUCBMUlVDQUNIRSBub3Qgb25seSBy
ZXNvbHZlcyB5b3VyIHJlZ3Jlc3Npb24gYnV0IGFsc28NCj4gaW1wcm92ZXMgdGhlIHBlcmZvcm1h
bmNlIG9mIHlvdXIgY2FzZS4NCj4gDQo+IEFzIGRpc2N1c3NlZCB3aXRoIERhdmlkLCB0aGlzIHNl
cmllcyB3aWxsIGJlIHJlc3B1biBhZnRlciBIdWdo4oCZcw0KPiB3b3JrWzFdIGlzIG1lcmdlZC4N
Cj4gDQo+IEluIHRoZSBtZWFudGltZSwgSeKAmWQgcmVhbGx5IGFwcHJlY2lhdGUgaXQgaWYgeW91
IGNvdWxkIHRlc3QgYW4NCj4gdXBkYXRlZCB2ZXJzaW9uIHRoYXQgSSBoYXZlbuKAmXQgc2VudCBv
dXQgYmVmb3JlOg0KPiANCj4gaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tl
cm5lbC9naXQvYmFvaHVhL2xpbnV4LmdpdC9sb2cvP2g9bXRocF9scnVjYWNoZQ0KPiANCj4gSXQg
aW5jbHVkZXMgc29tZSBtb2RpZmljYXRpb25zIGJhc2VkIG9uIFNhc2hpa2/igJlzIHJldmlldyBj
b21tZW50cw0KPiBvbiB0aGUgdmVyc2lvbiB5b3UgdGVzdGVkLiBJ4oCZZCBsaWtlIHRvIGtub3cg
d2hldGhlciBpdCBzdGlsbCBwcm92aWRlcw0KPiB0aGUgc2FtZSBwZXJmb3JtYW5jZSBnYWlucyB5
b3Ugc2F3IHdpdGggdGhhdCB2ZXJzaW9uLg0KPiANCj4gWzFdIGh0dHBzOi8vbG9yZS5rZXJuZWwu
b3JnL2xpbnV4LW1tL2UyOGY5YTk0LTQzMzktZjhhYy04MzAxLTZiZTNjOWI1YjdjZUBnb29nbGUu
Y29tLw0KPiANCg0KSSB0ZXN0ZWQgdGhpcyBicmFuY2guDQoNCiAgQmFzZTogICAgIDRiNjU2ODNm
ZCAoIm1tL3N3YXAsIFBNOiBoaWJlcm5hdGU6IGF0b21pY2FsbHkgcmVwbGFjZQ0KICAgICAgICAg
ICAgaGliZXJuYXRpb24gcGluIikNCiAgUGF0Y2hlZCAoQmFzZStzZXJpZXMpOiAgNWRmZGY4N2Vl
IChicmFuY2ggdGlwLCB0aGUgNCBscnVfY2FjaGUgcGF0Y2hlcykNCg0KICAgICAgICAgICAgICAg
ICAgICAgICBCYXNlICAgICAgICAgICAgICBQYXRjaGVkICAgICAgICAgICByZWR1Y3Rpb24NCiAg
ICA0SyAgICAgICAgICAgIDgzOTI4MSAgIDIuMzAgbSAgICAgIDg0MjQzNSAgIDIuOTEgbSAgICAN
CiAgICBtVEhQLTE2SyAgICAgNzAzMjc5NyAgMjguNzkgbSAgICAgIDgzOTMwMSAgIDQuNTMgbSAg
ICA4LjR4IC8gNi40eA0KICAgIG1USFAtNjRLICAgICAgMjY3OTQ4ICAgMS4xOSBzICAgICAgIDM2
MDczICA5My40OCBtcyAgIDcuNHggLyAxMi43eA0KDQpOdW1iZXJzIGFyZSBhbG1vc3QgdW5jaGFu
Z2VkLCBleGNlcHQgc29tZSBydW4tdG8tcnVuIHZhcmlhdGlvbnMuDQoNClRoYW5rcw0KU2hpdmFu
aw0KDQoNCj4gPiANCj4gPiBTeXN0ZW0gYW5kIFdvcmtsb2FkDQo+ID4gPT09PT09PT09PT09PT09
PT09PQ0KPiA+IA0KPiA+IEFNRCBFUFlDIFplbiA1IFN5c3RlbSwgMiBzb2NrZXRzLCAxNjAgY29y
ZXMvc29ja2V0LA0KPiA+IFNNVCBvbiAtPiAzMjAgY29yZXMgLyA2NDAgdGhyZWFkcw0KPiA+IDIg
TlVNQSBub2RlcywgfjUxMiBHQi9ub2RlDQo+ID4gbm9kZSAwIENQVXM6IDAtMTU5LDMyMC00NzkN
Cj4gPiANCj4gPiBCYXNlOiB2Ny4zLXJjMisgKDUwZDA1YzdjNzZjOSkNCj4gPiBSdW50aW1lOiBw
ZXJmb3JtYW5jZSBnb3Zlcm5vciwgcHJlZW1wdD1mdWxsIChsYXp5KQ0KPiA+IA0KPiA+IFdvcmts
b2FkOiBHcmFwaDUwMCwgU2NhbGUgMjcsIGVkZ2VmYWN0b3IgMTYNCj4gPiBNZXRyaWM6IG1lZGlh
bl90aW1lIGluIG1zIChsb3dlciBpcyBiZXR0ZXIpDQo+ID4gDQo+ID4gQmluZCB0byBub2RlIDAg
d2l0aCBudW1hY3RsIC1DIDAtMTU5LDMyMC00NzkgLW0gMA0KPiA+IA0KPiA+IA0KPiA+IFBlcmZv
cm1hbmNlDQo+ID4gPT09PT09PT09PT0NCj4gPiANCj4gPiAgICAgICAgICAgICAgICAgICBCYXNl
ICAgICAgIFBhdGNoZWQgICAgZGVsdGENCj4gPiA0SyAgICAgICAgICAgICAgICAxMDkuNjAgICAg
IDEwOS4xMSAgICAgLTAuNCUNCj4gPiBtVEhQLTE2SyAgICAgICAgICAxNDQuMTAgICAgICA5OS4w
MCAgICAtMzEuMyUNCj4gPiBtVEhQLTY0SyAgICAgICAgICAxMDQuNzUgICAgIDEwNC4yNSAgICAg
LTAuNSUNCj4gPiANCj4gPiBtVEhQLTE2SyB3YXMgfjMxJSBzbG93ZXIgdGhhbiBUSFAtbmV2ZXIs
IGR1ZSB0byBsb2NrIGNvbnRlbnRpb25zLg0KPiA+IFdpdGggeW91ciBzZXJpZXMsIG1USFAtMTYg
cGVyZm9ybXMgfjklIGZhc3RlciB0aGFuIFRIUC1uZXZlci4NCj4gPiANCj4gPiANCj4gPiBUaGUg
ZG9taW5hbnQgZm9saW9fbHJ1dmVjX2xvY2tfaXJxc2F2ZSBlbnRyaWVzIHdlcmU6DQo+ID4gDQo+
ID4gICAgICAgICAgICAgICAgICAgIEJhc2UgICAgICAgICAgICAgICAgICBQYXRjaGVkDQo+ID4g
ICAgICAgICAgICAgICAgY29udGVuZGVkICB3YWl0ICAgICAgICAgY29udGVuZGVkICB3YWl0DQo+
ID4gNEsgICAgICAgICAgICAgICA4MzQ2MDMgICAyLjQxIG0gICAgICAgICA4NDQxOTMgICAyLjYx
IG0NCj4gPiBtVEhQLTE2SyAgICAgICAgNzAwODgzNCAgIDI4Ljg4IG0gICAgICAgIDg0MDY5NSAg
IDQuODcgbQ0KPiA+IG1USFAtNjRLICAgICAgICAgMTg4MTQ0ICAgNzUyIG1zICAgICAgICAgNDA4
NzQgICAgOTMuNDYgbXMNCj4gPiANCj4gPiANCj4gDQoNCg==

