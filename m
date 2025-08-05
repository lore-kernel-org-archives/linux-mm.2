Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45254C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 14:11:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 778746B009D; Tue,  5 Aug 2025 10:11:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 729536B009F; Tue,  5 Aug 2025 10:11:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C9E46B00A0; Tue,  5 Aug 2025 10:11:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 49E366B009D
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:11:47 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1F6081DCFCA
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:11:47 +0000 (UTC)
X-FDA: 83742892254.03.BF6516E
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013029.outbound.protection.outlook.com [40.107.159.29])
	by imf28.hostedemail.com (Postfix) with ESMTP id A88D5C0019
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:11:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kuka.com header.s=selector2 header.b=q3d0dKz2;
	dmarc=pass (policy=quarantine) header.from=kuka.com;
	spf=pass (imf28.hostedemail.com: domain of Alexander.Krabler@kuka.com designates 40.107.159.29 as permitted sender) smtp.mailfrom=Alexander.Krabler@kuka.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754403104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uqeRAagf4ddVZQFJztfaXlWX0lyPCsxTvD8rKkjBOLw=;
	b=knG7BHRsV3FXsQzwVQ/89ataY7O1FgCj9WL/OC7x4gMri13ErS6EVBymXtPzOUOttAyLrG
	WDLRJnOXI0XZzYRXdkxglXw6O2vTi7yKKiezyIXPNf9zL4855nj2LSgFUkqOVrWQuNJ7br
	DmpI9NDKIDGqlviLMsahqALxNrPX6y8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754403104; a=rsa-sha256;
	cv=pass;
	b=1RoBrsWuE4RIJjIsD5x4mTOUCMAQMs46Mz9edyI+21ybZw/fhrUfY0hUMVm9FL98nMqByE
	YRJ6ceXOIKiRhbfkTzQ9dyE8kKOIYsg5XxiAnoHVvrFzR1WYTR18O4XnZRSSVto4QAdTIU
	5g49t8bADJYbn4QBjJ8n/3qJSevBkLw=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=kuka.com header.s=selector2 header.b=q3d0dKz2;
	dmarc=pass (policy=quarantine) header.from=kuka.com;
	spf=pass (imf28.hostedemail.com: domain of Alexander.Krabler@kuka.com designates 40.107.159.29 as permitted sender) smtp.mailfrom=Alexander.Krabler@kuka.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y3iB7IiaCJtOLiPk4P5vtIxYRytFsnt7Q7hestoNSAowjeuyMhWKkHERlrggkYWF9EjzlRwCMEbgztpA57i0d7QaA+2MLGEGF0GM+Lua2Lfc0sLVNOEgq9EAtlQbZxJR1i/GdoYcdOuUfGbHHM1yKYlgOimFhnf4HMzSdmCwg5G86JKowTmBmiage2u5yI5nouS6nPaTmYIjzQ+3S07sTdauksRqe3q81IpZSMFNuNNqQTqa0hxoQbuILAB/oMRHGptN6bbbfQDXmM7zIo0LSUYregzZtSbWdIxF+sBT1f2ItS/CBPZdO7nzCy86esotyMoXd6/yJ2Jxpp/vRXGnYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uqeRAagf4ddVZQFJztfaXlWX0lyPCsxTvD8rKkjBOLw=;
 b=jmKVHyiIGwfUsEZ44BQum9tcZ1v044XzuUdGE1xGo+DTzw9KPoS9wcXFxH9ccP/4szScHKa/iKoakg/uKNd3CT+UcJReFbm+sK2qt4e/OOU8CLHgAaa0TR1q8q+XmgBmBm569AS8AqCB9WgVC3kSmMjgFwRG39rayP9RWF4vuBCmcLHtc6n7M8VTegFNoyvBw/jyRqtwK8GYi+HuJ61i6FH6+EvOYymhJgCTX1sOTGDgbQORtmo/UDHAs5lnl0I4M6GsxYLYtQ78BERzPjJHUpzd6x3yS76RtuKPQpISXrBT0rZRhUYWxEhR7AF8thi8KSyTuWGY5HfxPBeSHDWceg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kuka.com; dmarc=pass action=none header.from=kuka.com;
 dkim=pass header.d=kuka.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kuka.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uqeRAagf4ddVZQFJztfaXlWX0lyPCsxTvD8rKkjBOLw=;
 b=q3d0dKz2lFUFoC0GedP0WZUjZoMeRZetENhULo0g/g3YUd0Bxgij/t+MfVzYM5AEucFigqPATCp8OTkSA0AZsZo90gcnRCX7Xy3uuFb7BiZZb2kvUgmS1Hj83+TgCPXG5KeU4kX3V9oKUO+Huhpd0GnV5r1Fu3GY7qh9r76YnwEziFHK9Df41QjPtPjNP2R29V2CnWTbcx58e2etG26h9DkXvNNX+KVLevMLICRnHGgXmN5OSkYdDGFEbDb6mkQeAQdq/giFLAX3oeCCKaPyLKesfQ7zQNzr4ICHazU2W2B5CqWgeLivn/T4PoIynzKXro/Sgk4CCqrgHNiN8IHYIw==
Received: from DU0PR01MB10385.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:322::12) by GVX0PF5391DB7D1.eurprd01.prod.exchangelabs.com
 (2603:10a6:158:401::84d) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.13; Tue, 5 Aug
 2025 14:11:37 +0000
Received: from DU0PR01MB10385.eurprd01.prod.exchangelabs.com
 ([fe80::27a:7a68:5d97:fae3]) by DU0PR01MB10385.eurprd01.prod.exchangelabs.com
 ([fe80::27a:7a68:5d97:fae3%5]) with mapi id 15.20.8964.019; Tue, 5 Aug 2025
 14:11:37 +0000
From: Alexander Krabler <Alexander.Krabler@kuka.com>
To: Frank van der Linden <fvdl@google.com>, Vlastimil Babka <vbabka@suse.cz>
CC: Mike Galbraith <efault@gmx.de>, "linux-rt-users@vger.kernel.org"
	<linux-rt-users@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	Dennis Schimmel <Dennis.Schimmel@kuka.com>, Daniel Braunwarth
	<Daniel.Braunwarth@kuka.com>, Hugh Dickins <hughd@google.com>
Subject: Re: Realtime threads delayed due to kcompactd0
Thread-Topic: Realtime threads delayed due to kcompactd0
Thread-Index:
 AQHb/SUMECAAoxVz1UW75TJas4YXXLRMmU4AgAABygCAAIeOAIAAeK4AgACe+ACABe3aag==
Date: Tue, 5 Aug 2025 14:11:37 +0000
Message-ID:
 <DU0PR01MB103853936E7A3476080F411BF8222A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com>
References:
 <DU0PR01MB10385345F7153F334100981888259A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com>
 <CAPTztWYf82p6hq=Q2mVq6_9WTjRaQiH81z4idZL6MZ1PXufPwQ@mail.gmail.com>
 <71df781c-3ef3-4b26-9ba8-93fc7d4f9eec@suse.cz>
 <026de9fcd4f0ed17c2df95c4f7c56b878a844012.camel@gmx.de>
 <25ba0d77-eb61-4efc-b2fc-73878cbd85c1@suse.cz>
 <CAPTztWZpnX1j8-7yeppVUsxE=O9hbVeqricDjZt8_pnN7a-kBQ@mail.gmail.com>
In-Reply-To:
 <CAPTztWZpnX1j8-7yeppVUsxE=O9hbVeqricDjZt8_pnN7a-kBQ@mail.gmail.com>
Accept-Language: en-DE, de-DE, en-US
Content-Language: aa
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_717b8430-11b4-47ed-b1b2-7ef5cdca0b43_Enabled=True;MSIP_Label_717b8430-11b4-47ed-b1b2-7ef5cdca0b43_SiteId=5a5c4bcf-d285-44af-8f19-ca72d454f6f7;MSIP_Label_717b8430-11b4-47ed-b1b2-7ef5cdca0b43_SetDate=2025-08-05T14:11:37.006Z;MSIP_Label_717b8430-11b4-47ed-b1b2-7ef5cdca0b43_Name=Public;MSIP_Label_717b8430-11b4-47ed-b1b2-7ef5cdca0b43_ContentBits=0;MSIP_Label_717b8430-11b4-47ed-b1b2-7ef5cdca0b43_Method=Privileged;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU0PR01MB10385:EE_|GVX0PF5391DB7D1:EE_
x-ms-office365-filtering-correlation-id: ad07e3c5-a6ab-4ef8-fcde-08ddd429fddd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?bTc1aG5tUkthZkJQZkhwYTBlYlZiOVNaYlRsS0Z2Sm9HREVIMkpuTkxUWmxz?=
 =?utf-8?B?TUVGUzBTMUNvVGtjWTFSNm5pNmpRQ1NpR2xCUHZsVnB0ajRPdC9mOWZMQjhw?=
 =?utf-8?B?UEpkUEl4a2pqM2k2Qy9uc3VHTWJiVDBxRFV3Y0I5bGo4TVE2WmNnaTJ4OHlE?=
 =?utf-8?B?RzhBdFJpVzVKNFE0eFA4R2xUQlpMM2lGMCtmTDdIa3BHS05EY2dFdzd3Yk1N?=
 =?utf-8?B?a2hCSGxncE1rT3pBcHIzeWV4MkFPUFFEa1ZESnYvSlh5QjhqUTZQR2ljbVBw?=
 =?utf-8?B?Q2pLYnFBTXVNT0t3Y0oyMGxaR0ZqamhjQjNmd05HMmNWeVFqM295RU1YaFFw?=
 =?utf-8?B?YUJQazhua0Y0YlJpbVdHMnBzWHNhbGhUUUtEajdqaFJGMWxtM2EzcmdEbVFU?=
 =?utf-8?B?dGlMWEcrZ09obXdTZzFmaTZmVmVLMjB4OWN6L2VCNi9wYkVnM3pzMUQ5WGJT?=
 =?utf-8?B?Wkt1bU1ZQ0g0dkxQUmNId3N0dmZ0dUh2Y1k1ZGJSSGJKdEMrZ2Fya1pWMGsz?=
 =?utf-8?B?Q3lpSGtEaHdONFFLYVg4Mi9tTDVUWHBiT2ZGdWg3WmVGVmlYa1N5V3dwMnQy?=
 =?utf-8?B?akRON21zcnd3RmNjdlRvY1grMkVMSWdwd1p1STR5N0txeTBSMWo2NUw1YnVF?=
 =?utf-8?B?SHRSeUFzaTVkRHo5a3Fwb294VlVIdW0zRW9xeFlCRGN5cVRNODF1Rm54cE9S?=
 =?utf-8?B?ZFR2NnZsNFBnRGE0L0ppU2FQK0xvdXlYL2h1LzA1MGkwRkdCYmhzY1ZCUllv?=
 =?utf-8?B?VVhzaU5KT2FRMC9JaUswcUZyVlJpWlZ2Ym9IMDIyQWtvazh3MnNQUGpnN2Jk?=
 =?utf-8?B?RGd4WnFnOW1penhWVzZpUkgwZ2VCa0hHMFdOWFcvOXdzTkpGN1ZuMDUzMTZS?=
 =?utf-8?B?QWpuczhNZzgySGR0NkphSFZyNjkwSnhvcktBOFFOeXV3L0JQM3NBOWtwSXIz?=
 =?utf-8?B?ekttQ2JUV0drZEJjQ1hxdWVseUNVRFZudUF3SGlLQWRxc3k4WVlwdTlZYnBG?=
 =?utf-8?B?K3JpVE5DVjNDcC9ZdlM1OVFOME1ZbjNPV3NWRVpHUzV1R3lxK3V0Sk45cTVD?=
 =?utf-8?B?ZkRPWUVBK3Rya1BmZzNmOGIrUEE5VjFLcURnT0tQbktQdWhiellaNTdUTkxO?=
 =?utf-8?B?dXNjMmFsSXZQTWJpTmwwcEV1TXdBM1J4VUZOL1VxWCtOazFJTVQxaDRVM2dr?=
 =?utf-8?B?QTFvWEhzanAzNXI1MVJWZFd6Z1NJUnFSOThZNzdTMHJFZ2NoUXBVbk0rV1R2?=
 =?utf-8?B?OVBqdTY0NmRraU9jTTlaMU9XeEhDQlE3emx3a2s3VGJxaFhOeWZFZWxsSXF2?=
 =?utf-8?B?dG5JQ3dQUVNLOUIvbDcrbTNyckRjb1o3UnV5cE13c2o2OHZsUzZjSEMzbHFk?=
 =?utf-8?B?NDJLWEo4NFl6L1N4bU1kL1VENms0bnMvaEZvS1U4RnNHYW1FUlpmWkJJQWt1?=
 =?utf-8?B?eE1KdGIxMHFJS29rR3N3eGV5djVDRHBVb0cycTcrWWI1b3QwR1YzUmhFd0M5?=
 =?utf-8?B?U3BhTnQxa2l5aEpQazFITUw3YUoxQnV5aHNYajl0SFFydEtMT0xCQmRNUnlh?=
 =?utf-8?B?cjY2NjVFQVlqSERuLzRiRUFSWmV0OGoyenh3YjJEaDRJTUhtaUdhUGJQMnZx?=
 =?utf-8?B?bkxJU1QwRWtYejdSSmxwR2dJbS8yVVBUWGlrNENQWDBOQ1FuSnEvdWI5WnRo?=
 =?utf-8?B?QUJDVFY2UExiakUzSUtiVmVDU3VYRSswL1lhaEhoY09wYkROd2owdjNlcGY3?=
 =?utf-8?B?Q1Z4NXN2dFVyRWVhSWY2WCtTVmJVRDg1S3d2OWVOa1lXRDFJQmkyR3JxRFFh?=
 =?utf-8?B?TkplNDR0ZS9SRENPTkJiTnNWSFdUb2cxUWNoZEVSMXpMRHJKWWZoMTNOYnJM?=
 =?utf-8?B?QmN3dlVuQWNmcHFOK09IbHc3bGxYS09Za1hhL0ZnVEc0N0lLUjFpenFUdzhu?=
 =?utf-8?B?SjlrZTBYc3NGb25TVUhUUVhXRTVkSWE0S2IwS0V5Y1pIelVsanljbm84S2g0?=
 =?utf-8?B?UEdycHFpcUVnPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR01MB10385.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WlJaWnJ3dmRvRFAvQmRVY0RBMGxwM3k4NzZrNm1welBJb0RGQmtUNlRDUkl5?=
 =?utf-8?B?MUo0USt2c1I0SFM0SlVUaFMrdU9YTnNFVSsxTXRkbjI3ZHdObHFRMHk0aGpW?=
 =?utf-8?B?RXBjS3FHOHJoRjlwbXRQR2JxNWQ5dkF4d2Q0RXBBM3FEbHliTjk0YVU4YXFl?=
 =?utf-8?B?d0twQzR5b21mM1o5dVU4b3UrMlp0M0xqbGlHekNOSSt0eFg1S1ZNQnJ3bFUy?=
 =?utf-8?B?U2NvVllGd1d6bTJoNHFNKzlDOUpWV0FRSGRESlZzWWJjNXRGNnl2TmFBTk9h?=
 =?utf-8?B?Y0NXcmJQRnU4T2d5MEF3ekFFenBJYXd4bnVEb3ZXZWtwV1hmWXdtOE0zREhl?=
 =?utf-8?B?NzBuQko0ckhoTXEraEhlYUQ5MWNBd3d5b1czYWJCZXVKVnorZmJ2MXdnRkpm?=
 =?utf-8?B?dWNudWR3RTk4WS81Zm5sN1YvOUlyWkJNRG9KNE5MVjNTRXJMYzBZb0JONjAw?=
 =?utf-8?B?MVhTQVNROEVzbFNRWVhmN1Yxa040allCOENVcE43dERQY2hNajZ6WnlUQzAw?=
 =?utf-8?B?VzhDbk1xOWRHRFU5SThGbWdwSjJscW8xRkRHa2hsc29IakwyTS85aTRyNXJy?=
 =?utf-8?B?YmxPRkRzb0FPU2pXaWY0ZTVKb1lpcWZEV21wc2tJTDhNK2o2TkVTQVluOWNX?=
 =?utf-8?B?aGcwMld1Y2o1OUxiZUhQR3RQTEtqVldzbVVVLy9KeVB4RlZ4YW0zZGM4NXdC?=
 =?utf-8?B?MTY3WXBkUVF0T0lPYSsvSXA3by9xb2NDVGVrdEUzNG0zc21wYjZ5ZkxGblZh?=
 =?utf-8?B?Y2pQZHkwYVFSeWJkQUI1YUdvTUlhOUZpRW8wdEk4K3hnRHpBWkZ2bk12V2lF?=
 =?utf-8?B?d1UvSU95dERodU13UGg2TjF0V1lWbDFNQnpVSnJmOE8rK2RPYlhNSEQrMUo3?=
 =?utf-8?B?Rks5SHFmQk12blo4Z0dBQ3ZpajBDRVZPK3NpVEMwMWxOK1huVCt3WTlMK0FJ?=
 =?utf-8?B?eTJVMzNNSitpQk81OVJTR3dwd3A3MjhoVGhEYWg3VmRNU1RRS1VQRy8yNVFa?=
 =?utf-8?B?bjdTRXYza2RzVWhKMUFmZFhTNWhlYWdaRDZLUkNpRHpOVkJYazJqRS8yMzZM?=
 =?utf-8?B?QU1nVnZ1QTg0VHVRS21HejVkcFVUSlBuMlRwbElXc1VLeU1HaWNSZE5mdmxQ?=
 =?utf-8?B?TmxvTzhReWt0eFQyT1JGRDhQS0tOclhHZGdhUzAxQXFZaU4wQ3ZTbDVsWTRC?=
 =?utf-8?B?T0h0TXpBQXF2TzM5cUJkZVRLSjBiOWdYYkFPaVR2SDJ4THdwMHQzaUdqVm12?=
 =?utf-8?B?OWxQNGxLSVY0dWg0RnhhV0ZvWXBuV2poMEhLUmFXWTltanJBR21hZytqWUdk?=
 =?utf-8?B?bXVqbjY3OGlRL3RLbERYM0lHT3VzRU1kWGsvM2lTNUkxV2F1ZVFOcTZCMkhR?=
 =?utf-8?B?TzA5S0pqYlE2akUxTUFGZzh3U1VIdlFSK3pRbDFmaTF2Mm5WQk1INVdkTmdv?=
 =?utf-8?B?L2hEY05XeHp6RXptTUFNTzJBY2Q1WGJ5UFZDcWU1alJnbG9LL3pvbXZ4RGVB?=
 =?utf-8?B?aUxiMEU1WW1xOSthR2hVeDlYSmhYTU1uTDUwZEtLcXh0dEYwMHpaSThWc1py?=
 =?utf-8?B?YU1nNjEwNmFGaFJDalBHNVpFcHA4UnZHWThyOFIvTjJPbjFSRjRhR3ZwR0lQ?=
 =?utf-8?B?REVOVEJZbUQ0MThJT05aZjRhQ3NiMTlrNHJWRWlBd0p6MTJvSm5zU1lPUFVV?=
 =?utf-8?B?ajJlMmtHUFg1YnZmTlB1ZWMwZ0dUWThqYnFEOTBHTTNpbk1IR3Nyckt2U3dn?=
 =?utf-8?B?dXZzOGx6WTB2YmxOU3BPRDZ5V095YkNFMG1ybVFjM2dhWGkvQkdNL1h2eTIr?=
 =?utf-8?B?VndwYnhCaWx2cnRERS93RE5Ha2JESERLZ2cwK29MVFV6aU5JQTYzczM5a09j?=
 =?utf-8?B?eVorOU05bVhqN0dDSDBBUFdWaGpMcndSR0ZHWk9xekhKNjlXZ0I2K1Q2dVJE?=
 =?utf-8?B?RDVSQ29nL3Y5QVBMdFhxRXREZDdCdjl4U2xCellVY0pDN2xzRzQyUmNnd2Iy?=
 =?utf-8?B?T2FEenVyYStSanZMUlp5M3MxcmQ5Wkt2b3h1cWlrN0JTZmJ5ZkNUbkVXc1Q3?=
 =?utf-8?B?L3ZZRDRkeDk1TFVDYnZXNEg2OHljWWw2TG9kNWNweFZKbDZOS1dQNlJIcWlC?=
 =?utf-8?B?Z004ZUlaTkdwTGc3dWtCZ0M2Z0pka3RHYXZ4citmTTBoSnVPeG0wMGVjbDJ3?=
 =?utf-8?B?SGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: kuka.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU0PR01MB10385.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad07e3c5-a6ab-4ef8-fcde-08ddd429fddd
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2025 14:11:37.4195
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5a5c4bcf-d285-44af-8f19-ca72d454f6f7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 678cPUccyo4v+vWBP1rCQZZlhjMM6odQe93tCZkztaSR6Fq3kVeyLHayiC89pTBm6mH3fVkqpOTjEm9ZmBmvXLBLW7JT0aYogNLwiUd/1sA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVX0PF5391DB7D1
X-Stat-Signature: 67thhin85oute9hia6sgdhwrtj6aejbn
X-Rspamd-Queue-Id: A88D5C0019
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754403103-706970
X-HE-Meta: U2FsdGVkX1897XVvwSITko/5Ld3e4s5/q+/26RwgiqCV/NHvetygKsL7Vb+sAPTjPIXkPQHNAYm2Apg9C6+ZPBEAJTrdOm6L6KjK7qujj45IUgJBdMHPaXtSNqFP43LvXNuTj7t5OSOueXw1mC3sThanRxJZxegMdjfj83m6VGgiYWll6FpVG2Ec6Af9/ukii6AxnX/nj9HNHSPuKti3xuhVjxF99jrviOznyE4XsK2JHg0GEm+XOVxX9ZevnGRikStYAe2VjVGhgCjOg/k8APk0n+qLfbsWwIMMIxG6btSL98aqzMHmK+7tvsbZCN2G07c1ax0OHrgVE1G5lZb1B4ivxcihHlwpjrOhFavOesb1+bbcmvVPxSUtPLo0RSCuWdrEua4aElCcNltaPpylZ4UMN+XXpx8ejO/b1wy7I3P24EsoRRcEiR2Us9FQFbDEnxEgi5Dz9VgZO2VfSbTD1ND2Pk2QtkHAtdjealcjUF6WZtCK8MvdGCULbK8wrIsb86qCKgz15wazBPoQvgrvp5o9wYJNPNLGUP8N3DKnZ/eSYTLh+KX5Dr5B7T6xkLmetGyo6fIJxutghtKifCTUQWRP3ororSRd2/EEfyBXsomiex6GGEeGzmIldKJmMzTYuDFxK8jH1ldOBkOdFWkrZTkNNe8RiKYBd+71pQTJK1McKw5DhXAlCZ/Po80FKC3FUytdpgvgzsQzoXY70WNKKiddzO/yPioQ4vH+YONN4KBcVI7E1RQ7RT2JXBnyNxBzShQhvcRMgh34yE1IA/0P4PN2cHUx8cvrsXA30uYNNIC9ns5lXHUoSbfTPKebbrvr3/IqQGI1iiO45csEyIqG2T7RSQT2kLSWLpPhcJxzYRCABTitVKjN3EK1htJ57VNkwfL9r89GrMtpXKaNkqzsaRNEwsfC/r3vSBBhaR0JGegXJSKQSABk0kKf4YpAIQ1fpHnFBz0jadaJHtdByCh
 0kDKYAtM
 JxzRJvmWG1AUJ5pnxAERDgDlOWHbqGPDXZIrH7ZNJpDkiGwesL69dqN4MQbk9lsAheQAW6bcJSfyOL46X5lSfqpNROcbvzzW5Wyb2bKnJcrITTIeRH0vGJC45kvs3t3CgfARkbD1A7ZetQmHD2ifI/5fgLVsgFPjvXNt7tEjbcYy+4dKxTdi8PZBXYEXYyrtn/5d8ZAtM/edVB6KtHiwypIa1PjbG5cGjNnlNq9MaCv4vgd+0/vss015vw6v5mMpQt2bh96tYSqRPf8b9YHtdX+Kn4SBG0WGEQdYQGlhq6FO0i12a/kFnY7H0AFoLOoi/MwDGcgLg8l+tct5prqaPn4abNkDkpTn0FuoNyeG6jL7IdTTTbpawARf3h+qTCEXGoSF2HyowZyiGx1FP05cbUF0lnoQqSbqKhIqCPzeS4KyA2tP32s/IFTse5plD1JuGXpbbWUR7Dpj5gWghSlnI82v6MvB5IQOsPi5p1ihBLjXld7OA2SUCgbrEuAn+LV7yoYrbDdtKbA3bFhk4K0lSFJcwDD/27PX6h3kvUmbxr6OzthrFqvRr9dfwteWLLl8uFjcDsv3AtJtwNPXn9enx7ZsLxfWswqXbkxJY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000012, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gRnJpLCBBdWcgMSwgMjAyNSBhdCA5OjI34oCvUE0gRnJhbmsgdmFuIGRlciBMaW5kZW4gPGZ2
ZGxAZ29vZ2xlLmNvbT4gd3JvdGU6DQo+IEFub3RoZXIgaWRlYSBpcyB0byBtaW5pbWl6ZSB0aGUg
dGltZSB0aGF0IGEgbWlncmF0aW9uIFBURSBpcyBpbiBwbGFjZQ0KPiBmb3IgYW4gbWxvY2tlZCBw
YWdlLCBIdWdoIChjYy1lZCkgbWVudGlvbmVkIHRoaXMgaW4gYW4gb2ZmbGluZQ0KPiBkaXNjdXNz
aW9uLiBFLmcuIHNraXAgYW55IG1sb2NrZWQgcGFnZXMgaW4gdGhlIGZpcnN0IHBhc3MsIGFuZCBq
dXN0DQo+IGFkZCB0aGVtIHRvIGEgbGlzdC4gVGhlbiwgZG8gdGhhdCBsaXN0IHNlcGFyYXRlbHks
IGJ1dCBkbyB0aGVtIG9uZSBieQ0KPiBvbmUuIFRoZXJlIGlzIHNvbWV3aGF0IHNpbWlsYXIgbG9n
aWMgaW4gbWlncmF0ZV9wYWdlc19zeW5jIGZvciBwYWdlcw0KPiB0aGF0IG1pZ2h0IG5lZWQgZXh0
cmEgd29yayAvIGxvY2tpbmcuDQoNCkFub3RoZXIgaWRlYSBtaWdodCBiZSwgdGhhdCB0aGUgYmxv
Y2tlZCB0YXNrIG1pZ3JhdGVzIHRoZSBwYWdlIGl0IGlzIGJsb2NrZWQgb24NCmJ5IGl0c2VsZiwg
cmVtb3ZlcyB0aGUgbWlncmF0aW9uIFBURSBhbmQgY29udGludWVzPw0KRG9pbmcgdGhlIHdvcmsg
aXRzZWxmIGluc3RlYWQgb2Ygd2FpdGluZyBmb3IgYW5vdGhlciB0aHJlYWQgdG8gZG8gdGhlIHdv
cmsuDQpXb3VsZCB0aGF0IGJlIHBvc3NpYmxlPw0KDQpUaGlzIHdvdWxkIHNvbHZlIHRoZSBwcmlv
cml0eSBpbnZlcnNpb24gcHJvYmxlbSBhbmQgc2hvdWxkIGJlIHdheSBtb3JlDQpkZXRlcm1pbmlz
dGljIHRoYW4gdGhlIGN1cnJlbnQgc2l0dWF0aW9uLg0KDQpBbGV4YW5kZXINCg0KS1VLQSBEZXV0
c2NobGFuZCBHbWJIICAgQm9hcmQgb2YgRGlyZWN0b3JzOiBNaWNoYWVsIErDvHJnZW5zIChDaGFp
cm1hbiksIERpcmsgQnVzY2gsIEpvaGFuIE5hdGVuLCBIdWkgWmhhbmcgICBSZWdpc3RlcmVkIE9m
ZmljZTogQXVnc2J1cmcgSFJCIDE0OTE0DQoNClRoaXMgZS1tYWlsIG1heSBjb250YWluIGNvbmZp
ZGVudGlhbCBhbmQvb3IgcHJpdmlsZWdlZCBpbmZvcm1hdGlvbi4gSWYgeW91IGFyZSBub3QgdGhl
IGludGVuZGVkIHJlY2lwaWVudCAob3IgaGF2ZSByZWNlaXZlZCB0aGlzIGUtbWFpbCBpbiBlcnJv
cikgcGxlYXNlIG5vdGlmeSB0aGUgc2VuZGVyIGltbWVkaWF0ZWx5IGFuZCBkZXN0cm95IHRoaXMg
ZS1tYWlsLiBBbnkgdW5hdXRob3JpemVkIGNvcHlpbmcsIGRpc2Nsb3N1cmUgb3IgZGlzdHJpYnV0
aW9uIG9mIGNvbnRlbnRzIG9mIHRoaXMgZS1tYWlsIGlzIHN0cmljdGx5IGZvcmJpZGRlbi4NCg0K
UGxlYXNlIGNvbnNpZGVyIHRoZSBlbnZpcm9ubWVudCBiZWZvcmUgcHJpbnRpbmcgdGhpcyBlLW1h
aWwuDQo=

