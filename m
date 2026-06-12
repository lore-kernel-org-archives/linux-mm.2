Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A727CD98D2
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 19:06:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 598706B0005; Fri, 12 Jun 2026 15:06:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 548C06B0088; Fri, 12 Jun 2026 15:06:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4109A6B008C; Fri, 12 Jun 2026 15:06:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2C4BD6B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:06:07 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C770CC105C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 19:06:06 +0000 (UTC)
X-FDA: 84872190732.06.97A8615
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazolkn19010002.outbound.protection.outlook.com [52.103.2.2])
	by imf14.hostedemail.com (Postfix) with ESMTP id EB4F010000A
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 19:06:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=outlook.com header.s=selector1 header.b="kB7k9S/5";
	dmarc=pass (policy=none) header.from=outlook.com;
	spf=pass (imf14.hostedemail.com: domain of mhklinux@outlook.com designates 52.103.2.2 as permitted sender) smtp.mailfrom=mhklinux@outlook.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781291164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pvs9D/PNAC1ozSynxEuMp0d3LSNAbcXq2Wj5ljTGWQs=;
	b=wm0TmpsFNqkmQ2UFxrAD1t1KCDRQjbhuOpaI3+Y0zUO4V1kx0C/QwYAK2tGua3/mg43OMf
	QfSF2qtrWONJvpW0g81DC/OiP568+gMiyJvnRdoJr4QfopnMwxGCL08ai7+X6+VjeYqFKg
	WK0ICSd+keVAy7SGYNAfbxumsiJhtD8=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=outlook.com header.s=selector1 header.b="kB7k9S/5";
	dmarc=pass (policy=none) header.from=outlook.com;
	spf=pass (imf14.hostedemail.com: domain of mhklinux@outlook.com designates 52.103.2.2 as permitted sender) smtp.mailfrom=mhklinux@outlook.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781291164;
	b=BSO9/o1HGl8cQ2FVfl+oBz+oJkBTZffQYUuLgVg00ADmmRz17IjAx5JZkvNoGLJofAqJe3
	/QNDplQEZa4st6g6tk6bQEnt1y5bJfGp1kPnyGg/q70GidVTpLjFH1fsdhoW9GKRSY57qH
	qDEvG+vXFYLq6HR8w7B49wYFSfSzkkc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tb4jcJbHvV1fwCtnd0BG7KFd/oNTFyc5RMuAH53FipzmESKaH+kglbJb+x2OFZ7E90hwKmp6AbSMsFaqmM7Fw/sBoGvXSMd24dYd15QGWCAT/ICE185WTsW2HKAgTnAIWl6v6986AY/sI0fc77u9gX5Z2NYtN2Xw5GIVo4JmbTduf3HQL6lBkm0DyzMtB2h0hzyOAr6j0K5sWFyvWwe+M5YtjwWod1UzcnlL7bM4haYMIr3yjV/lJYwVaCeCvMpnj0zn+/nJS6tIxo5rcjVBwoKGb2FjXcnVk1smHILywO+qhbsrKu4YbYeisNlav6NXviMuAVfNjcc4m9dCOOmvQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pvs9D/PNAC1ozSynxEuMp0d3LSNAbcXq2Wj5ljTGWQs=;
 b=kzimTeF2MhbuUOGooj/kX0YnOMaJ2le+EfoGsO2r/XfnkB0iykpkK4GlPR5t7xHcqjTsabP14DpiUtL1OMQBqhIymyfEGx0YKWnKnXVX1jZS7uLuhAlH7b6YL3g86/M8Xao7tH5507LZhPA1jogYEnrKUP/4I9yMjTdqbZIo8HJMbJX9Hk8/1u0X9at7uWIXKLrSn0Rp9DF1xTtPExwCKLooumbZv0YyCcnZBq35OkfALIq+eFB7wCfSOaNrbxXxAd1dswTJH198aELxVKLOiGO3ibucm7jgOuBHv4chKQJKmkoXIvFOnwRfcbrWcOdre+Wz27qmAT/vZ/4rZf1c1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pvs9D/PNAC1ozSynxEuMp0d3LSNAbcXq2Wj5ljTGWQs=;
 b=kB7k9S/5cufHR+eHgFFQR2Bmr/0d93vxR+UOOcFU0UUFeI78ZLVuVzYZd8KFv/2xw2+Le6pX3tD7uOGsY18TAASkTlEflvzEhlXUAAoXL6Akfdf5EO9xtwliLcHKIMrIEPNeuCY0z+MRcQz6+RAR/yjnqPTHrfh9j7RIHCzz1ne+INpdG5YN2CRNlKsvutUz8jC+oSmbe66uJz4KsfqQfxhNp9VbDf4YaYN0H8d1vINAHRWkSARpJuyf6L13KhMU8HPQnoqQt0818WayM/1DpCjlA25UagTL8oROvbFAZ9cHbRUzqL7m0tZ0SpAZgFBMqU8Zr3ANcwmEVur3DdnPtw==
Received: from SN6PR02MB4157.namprd02.prod.outlook.com (2603:10b6:805:33::23)
 by BY5PR02MB6737.namprd02.prod.outlook.com (2603:10b6:a03:209::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Fri, 12 Jun
 2026 19:06:00 +0000
Received: from SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::900:1ccf:2b1e:52b6]) by SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::900:1ccf:2b1e:52b6%3]) with mapi id 15.21.0113.013; Fri, 12 Jun 2026
 19:06:00 +0000
From: Michael Kelley <mhklinux@outlook.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Catalin Marinas <catalin.marinas@arm.com>,
	Christoph Hellwig <hch@infradead.org>
CC: Kameron Carr <kameroncarr@linux.microsoft.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "urezki@gmail.com"
	<urezki@gmail.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"rppt@kernel.org" <rppt@kernel.org>, Michael Kelley <mhklinux@outlook.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, Suzuki K Poulose
	<Suzuki.Poulose@arm.com>
Subject: RE: [RFC PATCH] mm/vmalloc: add vmalloc_decrypted() and
 vzalloc_decrypted()
Thread-Topic: [RFC PATCH] mm/vmalloc: add vmalloc_decrypted() and
 vzalloc_decrypted()
Thread-Index: AQHc6WSumnpdHcVAhkCbedtX5zwOu7Y05oQAgAR3iACAAfbLAIAACAGAgAANX8A=
Date: Fri, 12 Jun 2026 19:06:00 +0000
Message-ID:
 <SN6PR02MB4157EC032AD55D182FBC1318D4182@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <20260521205834.1012925-1-kameroncarr@linux.microsoft.com>
 <aibhnnDFQTHWMEFe@arm.com> <20260611114954.GC1066031@ziepe.ca>
 <aixGqCqKkQeDfUST@arm.com> <20260612181807.GP1066031@ziepe.ca>
In-Reply-To: <20260612181807.GP1066031@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR02MB4157:EE_|BY5PR02MB6737:EE_
x-ms-office365-filtering-correlation-id: 53798691-c47a-4ad0-7249-08dec8b5a480
x-microsoft-antispam:
 BCL:0;ARA:14566002|15080799012|12121999013|31061999003|13091999003|8060799015|41001999006|19110799012|37011999003|51005399006|8062599012|19101099003|440099028|3412199025|102099032|40105399003|1710799026;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?pvO5TkJD1ZQ+XZj3MAPVxRgnDkvItZZJ81frbJysKN1IKg5v41LxQ+vJH5lU?=
 =?us-ascii?Q?7h4Ds9+Fnhr28tZftvGrtmEBTinT4nZWKLOVhpvjavl8tNYUkB8vxgxJg2Fj?=
 =?us-ascii?Q?gHrsS75f3Oeywo0A8fcpgIiwDIJ+AN/uNu6ixrZK7nUcyEwYJtSklcYNtxW0?=
 =?us-ascii?Q?iVk8hN/S7VYsFLni1bd7umkx2vdoyYpHBsj2hWc7TsSPidh5NUhYZdsva3WG?=
 =?us-ascii?Q?guXtVnT64PM4xfJwU7HsGZ3VHwPCxj7kxfLZfAXnk2XrnrYdgZRAFIkPPU6q?=
 =?us-ascii?Q?LlRzlMy36Bt9n/89tBOIW8yZeaJBlIY+I9T51YnPtnuwrXCtInfhYRorgSrH?=
 =?us-ascii?Q?fGdagKmtg0BhsMwMy0RLmbq68K/uw5diZlzzRTLjDr3A/drFNdBgAO4ZRZrS?=
 =?us-ascii?Q?4nsBcJhrqRDAVBBu4McqMRWLo+3Sq+g+5hytG7vlrNZ3gTsxYqAq52MlRxSd?=
 =?us-ascii?Q?CJGXeKlbvlOUbU11Vsab8J/MNXe8R1DnkMaOp+rO8yS95Ae8luV13J2BwtS7?=
 =?us-ascii?Q?wqhmvVBe1uQ2sBZo8Ox/t6JrJ6GxTp4P+62j+rxguoCR6xhG72b2qkdsYq1z?=
 =?us-ascii?Q?qFqL+6OgRY9PXwHv8X3/jFyxMKrJHkADCsg+D6B5q+IC8jVoLP5LjXxMUI6p?=
 =?us-ascii?Q?A7wR8tfrivmJLPZvJx+XZ8dYyuDnh4ZDu3AXZkI7kLzj6CHQ7ClcPeN8ajPj?=
 =?us-ascii?Q?oEqsWPCB681l1y4tANN1gMcj3yPLdVqB3WxJMo9sNLNGChELwWA3QVjj5/93?=
 =?us-ascii?Q?NtymgH4DDucbs9ecG8I5W1EACsCb33IBAmzgewvFcMpAxk4Wg9wcf/BKndK/?=
 =?us-ascii?Q?QXMf3L2wRZ64rtxBU2RpyWCK6Ld5GLLBzCAFpR/dR801+K5XpU19QStT5Dk9?=
 =?us-ascii?Q?xVYFh/XM2QoKbwMZhMoJvSiICosjKTvIyAQn9mhge7eP5pj2eo6jlYp7Z6b0?=
 =?us-ascii?Q?5veakU74AtA+CEWIqPGM3Dy9DHGD9+GaSutxH9PTlNg0SoULq1mJpmavWGKZ?=
 =?us-ascii?Q?1EPXaB637ENoLkbV0PSMk6SL5eMS8fLt2GYZr6RCkXkR1atI2bmbO4eopLd1?=
 =?us-ascii?Q?cBqTqAjZcOB0k/rmYy96vp6xeJraDA=3D=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?BSiqlCX9zCg0JKJ+nzTGKaZ/4qlQvxn+tdpNwhXP8OxbNnTwI9Z45vGL7ihh?=
 =?us-ascii?Q?8p/NOFGaGN4XzSqwAnYneqzxQrQRyPlig+eUIF8hY9gitwd/0oG/0cbjA9bx?=
 =?us-ascii?Q?+U0clcd/Bt2WO3j3WY9+S7eYMH8j1M112ou6v+HKpH4/61ETD/TxrbDY4Aad?=
 =?us-ascii?Q?4GkY0NqJR+ltXDpmYZCSr9KGK75oYdJ7q0Lrq3VgF6C4q+F1P4HQHW6MbWz4?=
 =?us-ascii?Q?MyL3H8XyiOvZz4AP4erWH2LSuEKHVvQEke0ibFW29b11bvdeWkVKzg6g7GPx?=
 =?us-ascii?Q?qh4b1fbLHVkCvet/uZBGVulfF7NZpzMsrCebLT5r0bUOO+nDGR0zrOnpxtWy?=
 =?us-ascii?Q?xOnLqP3fEK3vLx+NgeHCkGvhr6bGBCsAD4AjBbGPJyIzxxW5Zu0hKj59z/PV?=
 =?us-ascii?Q?QH9hm2LqRggCO9jOsAqynf+tsPe7OW7MRHi2o30Gv1UhV74KeSbcEyv2xziV?=
 =?us-ascii?Q?4qINMauYmr8knX8P7WyaiGdxljRCdofFNmzrsxPwlSSP4EtnHzDFnNQjuUom?=
 =?us-ascii?Q?AGrDGZSfElOnv5EUtJPSBCeE05YWQ1V6mzUcw8GfRWB4ehvpEPd/BWQpIkHu?=
 =?us-ascii?Q?hMIxMlS+XVx/RMWyFWofQRsdjZ61Qsh57xQZLt3o15K4Ldyv5uq8Qu58xzg6?=
 =?us-ascii?Q?v4mon/+63mQYxOMXkv3sC2n6X84N3/p1EfPfSjNptMr5K1JR4UvzXOmlZ7yS?=
 =?us-ascii?Q?JzGuEDpoPU5YhH58ssmvlLFtUSJ6ELF2e0f6PMCNI8ynCqyfohg5V3Rgrxgs?=
 =?us-ascii?Q?PFYBwKcWkikTMS19hRUK3g8/hsQaUUhErQYdn9KzEHgWIkaO3/+iaU1a6udQ?=
 =?us-ascii?Q?djcgcINxo2ccIMesajxWbBeqGxcYtfO4JDX5ttcckcznzZd09caUhxO91H9c?=
 =?us-ascii?Q?QKT2PW6qMCk+TmeP7jsYbsoiR/XKAzIPIP/2HCbqbG3bxRInzC61w/V6E2iX?=
 =?us-ascii?Q?xBGcSIOA2pyOjTJm0s1RcKTAMVeBaGa2h+6OZyX5ddbgssUyadqR8GxG889y?=
 =?us-ascii?Q?oe2RRCrmUd3pMvKLRdZk48TLvToZJ4enOHfS/P6c1cAw3PowsG6p8ryTkjLq?=
 =?us-ascii?Q?mwpDzmahbLpcon6dhoo8kn/Y2BCiDJxQEHlrgpjuhp+WB0UJzpAkc4iPM3J8?=
 =?us-ascii?Q?unLETsV/gjlqRebcDfbRKx1TxhDzssa/u9aL402vV5yA38tQa3Se3B2lCFoP?=
 =?us-ascii?Q?ElHLWVbVa41MdYSHZtsOjExOGbkRJAkuesDrIHtPrLgaRWsD4YamafAPlheQ?=
 =?us-ascii?Q?aL8Ri2eKgjd4pA9vwwfzQSw9Yy4MJyJNu9YXL8/AXyD3Se6MOsTHEa3eeUBh?=
 =?us-ascii?Q?ld3RDTVV0UAFMdHZxrQ3h38dajuJnfA+RGUuyP2/yKToQxnNciLMXRiOC+8H?=
 =?us-ascii?Q?VxPlewc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR02MB4157.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 53798691-c47a-4ad0-7249-08dec8b5a480
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2026 19:06:00.7539
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6737
X-Rspamd-Queue-Id: EB4F010000A
X-Rspam-User: 
X-Stat-Signature: 5187o5m7pfdj3j8qat88k8mhaxgxgsde
X-Rspamd-Server: rspam09
X-HE-Tag: 1781291163-317145
X-HE-Meta: U2FsdGVkX18aTlEr/vrbYFaXUclI7pD3kISj6g4+2ayWiUqFq83GJpLh4lLbx2bENrgc8ZkoDVEjrAJumQiJxLChAazu4yMCIiQHHLo+q34BgXk7WYKXAcdfvWo5hMfBpDzUypZ4Si5xQtaLUgKbtd4wOlQBWYUNiM3MewxKq6a3HaJjXTTwEVtPs2UoI6uJ5rKUGV0yWnbb4Fp82k3mgfFCekYRIpMHY9N1zrqNVpTJWZ/igU5aRwn5tcU1rGhWewVXCcaoj79chicA4T58u96YCU8YOu7PT+8m5bbrEaOO6T0ojErOsLvrpOTaLOS87wtuN+/lqGVTLJqafaDxmRlkZjZsPTMtULv4kjMKJyhQnP9cshVsh3Ugum/XdQy7jUlayAY7KsMrxo6nTm2Wq62AJUjqtVLYHb6k+BVoTRY27otkhJwq4t2WF1XUgwuRDzJuA4ZyFy+xux50AACOaFKbO3Mdz18KqULOeSudopgKX8ezWlBVUYAwUsOzExntwXWnxTYJbSUrUR5NMI4LP79ZwguQFhsx0yyW5s7sqWKYuLNXPc7HU5LvqSrvm2JnxVmnexZIk/zU3+eR0vU1n8gqurY2goI6WpZWq2siM1bDPDr/ZmrRki4hoGS+2gRhlQzoqebKFTa8Vey0lyfDbw16COdtp5D8sqAPbo8GJMPMHTHDXoa2qXz6ovaUFW+9/totwtQBn9L2v23wzZtPpP0U4EEujJo6xhHdHL9fAFk+9lr+eiKf3BEE15VYMNJrMnkUeBCtaV9ty3XxI0xLCGwMiU5iCrlmdPH0SjEWHoHunsC/vlQAFyaCm6alTPnjnPWIh2rc0Z4IhCh8z8Z62ZRYFbDsdL8cMIhA6BuQUXXM17N8rwknTw6PB9561CmW71blLBgoz8Uwb7lNXQuweMTP9vQANUYUCrZ6e9BOSPqgeO/vpRpRNhGN+qWZ+hiQTf1JQw/N2asDt3dgbIF
 idCRh1hy
 ColfXcTSQNhhhbJB6bvFc0Ygm9d4FKzeyUHUT1Auj62qyXpuZ+vBhTIT6RRLmA7ZXB6ot1w4LE1mQnevmv+uWPmw3RBVlk85xu2T/0eoU5Po34TIH4Er7p34uOn9ubg6t8jSO8XLpQUaLLJzCujgNbs80r0Gn/FZgwyhEVvMnys3iq/UKDQSFZox/NWmSEzUG1HzAqUQLrlrPv2HNTCyYPJs0bSB55sCh0fyVuQr1CglTZhkRMJQA3K/8xLa7lreAm/6mS4YkP8yuuxBcXpT/CeWpDb+njZTkZ/SO+NkeU6Fmr0+JEJJziA6CcwLOxWcLK6afoGoB0ddZ4w2eYOlrYvUBFFOjT4tjm3bNdEN7oZ67fSXcTZOwCu8U0x0MNPAGoRyEB3/KRP0rPGb987Z2KAdjM+qIhCCO5N3IAp4vl9nV5shjGv6oiK8a7agy0QxkbvQWiPLxszWZvf9ajJz5gVRnc3a2zSTkuhKwd7oGaoLB9RJgOCYt7OqSHQVH/BW/KSnGnysKMjt7pja0DVVHs27yTVsvZgbzxqA6+uqTW+yNYpFqaLLjIqecdgQ0sOHmCOpL5b/DFzgE4t8ZclrDwunO4jwGzoJyNvC1+/sIM39ylX4qZl1Ef94l4N1XROhpICqnaWdHchf8g4F8KJ+/XpRfPBJ6r9szJaZ6i1HSX1L93TyynD9MEJkmPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jason Gunthorpe <jgg@ziepe.ca> Sent: Friday, June 12, 2026 11:18 AM
>=20
> On Fri, Jun 12, 2026 at 06:49:28PM +0100, Catalin Marinas wrote:
> > On Thu, Jun 11, 2026 at 08:49:54AM -0300, Jason Gunthorpe wrote:
> > > On Mon, Jun 08, 2026 at 04:37:02PM +0100, Catalin Marinas wrote:
> > > > > +/**
> > > > > + * vzalloc_decrypted - allocate zeroed virtually contiguous decr=
ypted memory
> > > > > + * @size:    allocation size
> > > > > + *
> > > > > + * Like vmalloc_decrypted(), but the memory is set to zero.
> > > > > + *
> > > > > + * Return: pointer to the allocated memory or %NULL on error
> > > > > + */
> > > > > +void *vzalloc_decrypted_noprof(unsigned long size)
> > > > > +{
> > > > > +	void *addr;
> > > > > +
> > > > > +	addr =3D __vmalloc_node_range_noprof(size, 1, VMALLOC_START, VM=
ALLOC_END,
> > > > > +					   GFP_KERNEL,
> > > > > +					   pgprot_decrypted(PAGE_KERNEL),
> > > > > +					   VM_DECRYPTED, NUMA_NO_NODE,
> > > > > +					   __builtin_return_address(0));
> > > > > +	if (addr)
> > > > > +		memset(addr, 0, size);
> > > >
> > > > Talking to Suzuki, the small window between set_memory_decrypted() =
and
> > > > memset() potentially exposing stale data is safe, at least for Arm =
CCA
> > > > as the memory would be scrubbed (there are other places in the kern=
el
> > > > where we do something similar). I assume that's also the case for o=
ther
> > > > architectures, although not sure what pKVM does.
> > >
> > > It seems like a poor practice though, this should probably be
> > > re-organized to use __GFP_ZERO so things are ordered sensibly.
> >
> > __GFP_ZERO doesn't work if the intermediate set_memory_decrypted()
> > mangles the data (e.g. changes encryption keys) and it no longer reads
> > as zeros.
>=20
> I thought arches are either preserving the memory content or zeroing
> it, you are saying some arch leaves it as garbage? I'd argue that's an
> arch bug and they should clear it in their path.

AMD SEV-SNP leaves the memory contents as garbage after an encryption
or decryption state change. On the flip side, my understanding has been
that TDX zeroes the memory (or at least has an option to do so) after
such a state change, though a couple of AI chats say TDX also leaves
garbage. To be sure, I'd have to run an experiment to check in a TDX
guest on Hyper-V.

>=20
> Otherwise this sharp edge is not documented and we have many other
> places getting it wrong, eg system_heap_allocate() doesn't re-zero the
> memory after decrypting it.

In the Hyper-V code that uses set_memory_decrypted()/encrypted(),
there's always an explicit call to set the memory to zero afterwards.

Michael

>=20
> > > But what is the purpose of this? I guess some hyperv thing - but
> > > shouldn't we have a more structured way to "DMA map" things for the
> > > hypervisor instead of stuff like this? Why can't you use
> > > dma_alloc_coherent() which actually gives you an address that is
> > > sensible to pass to the hypervisor?
> >
> > IIRC netvsc_init_buf() uses vzalloc() to allocate some memory and that
> > buffer ends up in set_memory_decrypted() via vmbus_establish_gpadl().
> > arm64 does not support changing the decrypted/shared attributed of
> > vmalloc mappings and I don't think we should add it. Better to just
> > allocate it properly upfront.
>=20
> Sure
>=20
> > We might be able to use the DMA API but we won't get something like
> > vmalloc() - physically non-contiguous.
>=20
> The entry point is dma_alloc_noncontiguous() and you get a scatterlist
> back.
>=20
> > I think dma_alloc_noncontiguous() just falls back to
> > dma_direct_alloc_pages() in the absence of an iommu.
>=20
> In all cases you get a scatterlist with a CPU list and a DMA
> list. iommu gives a smaller DMA list.
>=20
> If you want a vmap then you can feed that CPU page list from the sgl
> into vmap().
>=20
> A dma_alloc_noncontiguous_vmap() helper would not be hard to make, and
> IMHO, would make alot more sense for hyperv to treat the memory access
> from the hypervisor as "DMA" instead of trying to re-invent the DMA
> API.. :\
>=20
> HCH was already saying we should not be allowing drivers to use
> set_memory_decrypted() at all, and hyperv is the biggest non-core user
> right now...
>=20
> Jason


