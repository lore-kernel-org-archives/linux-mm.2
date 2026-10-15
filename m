Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD3F5CC6B33
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 15:11:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 806756B0092; Thu, 15 Oct 2026 11:11:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B71D6B0095; Thu, 15 Oct 2026 11:11:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67EEC6B0096; Thu, 15 Oct 2026 11:11:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3A6C96B0092
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:11:35 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A92D9C0A35
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:11:34 +0000 (UTC)
X-FDA: 85325199708.06.6453E13
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11023079.outbound.protection.outlook.com [52.101.72.79])
	by imf14.hostedemail.com (Postfix) with ESMTP id 894FD10000E
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:11:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=codasip.com header.s=selector1 header.b=joeVbOsw;
	spf=pass (imf14.hostedemail.com: domain of florian.schmaus@codasip.com designates 52.101.72.79 as permitted sender) smtp.mailfrom=florian.schmaus@codasip.com;
	dmarc=pass (policy=quarantine) header.from=codasip.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792077091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Es2KudS+mAiIqmGu8ceJ9+T142EovYE0XZxXDHE4oUE=;
	b=e5JrkuuoolnoDfg/7IwWRYoE/rt0eZ+Wir/k9yhX1vkmGxMeoyLIrPzyn9zPZ6LZ8bUeAh
	oc9SpHAHsZIxEGG1ZIvg/4cpwwqvepOXPq8Eef5PnUdTkDXNxUqPNBINeIFUSprCgF8/g1
	+pTGtM4WYPIvGy6pou8GNxj6oV2i1Ds=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792077091;
	b=F6lgx26m/C4il5auoEmIASPylMwyNVRTUdJvLO3xhxuavP2WRgbUtwwaMvYG0dqAR0eFWv
	aK7O7lwHmUC8M/W0RzRPBIcda3Jo/mMdKGo3GcvZ8Kr/MF0iuDVPmGuciofk8avj2ni3KZ
	ykWOBfFpjvTI6758tnncSVUahsMkz6c=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=codasip.com header.s=selector1 header.b=joeVbOsw;
	spf=pass (imf14.hostedemail.com: domain of florian.schmaus@codasip.com designates 52.101.72.79 as permitted sender) smtp.mailfrom=florian.schmaus@codasip.com;
	dmarc=pass (policy=quarantine) header.from=codasip.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KbR/lwLa1p2IFbOgGEdQOAfvkPZ/mpleWc2fY6x5q0vPWhK+dhEdt3Z8JeB9YFBGLEUAXbV0p8DqETpQGTMLbph9KAV64oQgwCOBVmygEmaeMZCFO46qiBKxJEz5S4LpNdIGugojPSxHNKYVx5gr/PO6z99ewLmJN/AUjAcOs+AqptTE3KW1KpAfi5hJrjDcdlyHzD8EmFu1DbqizhHnnGp9WWDJPK2dOlp+3qMK8VkRdt95vkcKUiddS65xoX+ka5xR4Qyl/HSYXIvHlDwo9nRMehImO3gT15JZkrD7AcXzPK3MjkCi2j3iDMScp7okTwapzeXNzlzeamV30UG5Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Es2KudS+mAiIqmGu8ceJ9+T142EovYE0XZxXDHE4oUE=;
 b=JAXfpdqvHatXmuK2Aib5pFoKbbzG2qpFtiUHrQgWHxGMczqRgXVwFKZCNm4mvfrJW5ODaGbvgSkP1m1bDpk2KjRG+ddvbzee0UqzsKMn0hwwhEK6ppIc4W/fl+lRJ7HuKT+j1GAzST/m3QfelvYRAhaMSO3PL+shdel+mkRLu4+YReHSmcV0hnxK0A4p0JEh5s+m9f8QoK14YobK7FMgT4r37/FAwJ/5qlrytvdMB+i5QqgBNQtEyiGgIJyLb5saA8EPwMkx0wGX/ju/zYazdOUKqfPkBzRucbRnZi3884UMjtPqcz1hajKQGVja7u5eRnzniLCpA320drPtqvLQBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=codasip.com; dmarc=pass action=none header.from=codasip.com;
 dkim=pass header.d=codasip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codasip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Es2KudS+mAiIqmGu8ceJ9+T142EovYE0XZxXDHE4oUE=;
 b=joeVbOswV3ZCBXRvnViyRmM2lHO7k0LjEQL0xlHPW7QC6YIaqOI+On+AAA558mG47EnCC0j5WE43aZDGgKZq8lkKLbJNAZXgmf8B2tYqq8CiqEyJpQWGlsuWYzQqwEGKQxGrKCCjhgA6EB0fcTgkA9Vi8qKUiNFRvxEgXTHyfpHOt6DzSCB93tCM9gZEaSX70Br+qTaW+H1J8sr7Y0hDFg1Bt6LJFoYb5wQYsrUCD1DOv+q1Z0dbe2KUHchHguDklsgbe9dX2U0FxaBGPKKQ4IX104TJ48auFeakQ/iv8wQdqzbFhFvwLHojhPNxwwn7veqvwVFzfxthzuvv/L51EA==
Received: from AM9P192MB0983.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:1f4::5)
 by DB9P192MB1898.EURP192.PROD.OUTLOOK.COM (2603:10a6:10:39d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Thu, 15 Oct
 2026 15:11:20 +0000
Received: from AM9P192MB0983.EURP192.PROD.OUTLOOK.COM
 ([fe80::f0e5:8465:302:9a9c]) by AM9P192MB0983.EURP192.PROD.OUTLOOK.COM
 ([fe80::f0e5:8465:302:9a9c%4]) with mapi id 15.21.0522.013; Thu, 15 Oct 2026
 15:11:20 +0000
From: Florian Schmaus <florian.schmaus@codasip.com>
Date: Thu, 15 Oct 2026 17:11:16 +0200
Subject: [PATCH 2/3] maple_tree: do not clear the metadata of a full dead
 node
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-maple-tree-fix-slab-corruption-v1-2-160d97f7304c@codasip.com>
References: <20261015-maple-tree-fix-slab-corruption-v1-0-160d97f7304c@codasip.com>
In-Reply-To: <20261015-maple-tree-fix-slab-corruption-v1-0-160d97f7304c@codasip.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Alice Ryhl <aliceryhl@google.com>, 
 Andrew Ballance <andrewjballance@gmail.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>
Cc: linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org, 
 linux-mm@kvack.org, Florian Schmaus <florian.schmaus@codasip.com>, 
 "Liam R. Howlett" <liam@infradead.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2610;
 i=florian.schmaus@codasip.com; h=from:subject:message-id;
 bh=p5cdx9TyVboI+C5NBgaiiP9CNjXM07mQNP4ssG28Jgw=;
 b=owGbwMvMwMWoZLn8xddWhSDG02pJDFkX3orosO4wyS+5NWPzuzcWtuqTJnJuY5uxNCQwY7H7Z
 mbLExsaOxnXszAwcjHMFFNkmV7KOt9K8c7D7Ce/18EMYmUCmSIt0sAABCwMfLmJeaVGOkZ6ptqG
 eoZAho5RPEROj0Ejs7i4NLVIN62gyCEvvySxJDM/r1gvvyA1ryC9QC8tM60kIyO/qDgVaIReXmq
 Jpbm5qYGppZuxo5Ghi7OroZmTq4mbk6OrkZGxpaO5q4WbqYWpkYGpEQMXpwDMNZIFHAxT08sXLg
 0Rmz21JTVzpsxEJZM9HUnhW7wl1hz+E3jEhpVP1PuxgfURafN9udInPwXNt5lqzHFEZm+buIzyw
 ds7l3htvnJ4id798OuzZ90OKHycvSlWkFXtAUegvKWGqMK09zs3xuy+eUFhW5o/9+Njc9x8w1ty
 IwoXa63cJ/VG77j+tpcisUfe7yjZ4OiUdyF20W1O0fsnxWQ2pMwpruCznKDFmR5Z2Tm1Sbd+vcz
 P5csmPk52u3ZnRvYj0wOL7Ob9CO+9xlKi3aKwq3L3p08Kf5Y9nTe7OXjXhq+82mL/gr+47ZyZZs
 AY+KVJ+2fWdOF3B+SWix+duihgaeLiR7s6NK54yURnNizff5M9ZI46AA==
X-Developer-Key: i=florian.schmaus@codasip.com; a=openpgp;
 fpr=1357B01865B2503C18453D208CAC2A9678548E35
X-ClientProxiedBy: FR2P281CA0020.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::7) To AM9P192MB0983.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:1f4::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9P192MB0983:EE_|DB9P192MB1898:EE_
X-MS-Office365-Filtering-Correlation-Id: 484a2d7f-4ad6-4547-c50c-08df2ace9179
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|10070799003|23010399003|56012099006|18002099003|10067099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	APLJlrjpTTJs+pEWC5opGKloRIOPVUNa1xvfxBsmUm9X1w/5JakChoHiw6vLayOSy6pouLKLGWJFmrdyWO23FX/IPZs+aAjmMCHkZUODBkLQ4PozmAJSHWG5WLkTCvkK0n7AfDjDen1rJzFUF2mxbJs1usNTJwvRvrOmAiOXAWx9EeLwUDdS+5QvRN1zL13iGDkA3gyprDLmSucjaAvZ9j29qQVmdXnll35ihv7plQjV7i3MmG54GnPt2g/+QflbljHzbwL8uxfegPQ3V5s7nezuoonN3kFz+J0cCsyEOcO9PORXDF3UvNd4aPu8Q4bPx9HPVSFCyzsYt2UI7fUiFCnhgJeqpUIRE30s8/ufzlzhjY1CyWfMf6YKRwcdjLRbdNrmoHKlOc4INqNnnUcn1WmfDMmfLQtEt8aCOUQHyXGx26ygk6R+QfeZT627bwN2km4OvqD/rT8sjL2aolhMoZWBCEgQXszxc1kdCWl8RK7dw5I8udbb/wIf2auYNbmSp+P/qO8HdtdDmTE0egeN8Lfa8+AMBgg0mK0igZ7+uMEL9c9e31xmfiSlgSCQmzegFYOQxU/zpfiAuzBm9qdn9n4N36pUFeVBT/uRXYCo5JtXJFyKzej5Jaj2kTEJtBp0IbpOIYnJk0t+F6fZc34XDXajK9ig6k+GOzXipG0UmN0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P192MB0983.EURP192.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(10070799003)(23010399003)(56012099006)(18002099003)(10067099003)(22082099003)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M0NPSTNVa0tlM0ZGV0dEd3NYUUhpQlZvcERJRUcyblllVWl4SXFSN1FoYy9H?=
 =?utf-8?B?ZXBnd3A2bVUyMldzZjRCaGZrL1ZxYiswL3gzQkR3MzEvQytiajlVVmk1NWs0?=
 =?utf-8?B?djFiVFc4ejFUdEY3U0RZaTBLR1NKMko3ajJ4THNaem5sOWtqZ2tWdkRDOHZl?=
 =?utf-8?B?aitaL3F6SUdyYlBuM3V5TTduTU96clJocHpKZUdVRWJOOWRzUFpQQkNlSGJp?=
 =?utf-8?B?NWVta29JajJnZW1PVTRPK1JVSVBKLzhHbmNnVHhUQm5GQnFSc0FuS1BFN0Ji?=
 =?utf-8?B?K3ZSWTNSaHVheGpEZzQ5eVptWlFwVVlLREtKUzJ4U0J2S1M5dFNCVSsvbzYx?=
 =?utf-8?B?YWhKaGgwZzVzckVzNHhJOWZHRFI1RkFtWU0zak9OaVo4Q3cvOVEwbU5qLzJ6?=
 =?utf-8?B?RWlQamZ0MllDKzJPcmRJL3JZY1dTM1hNYndhTk1mL1NOR0QwUHk5Q01keFlo?=
 =?utf-8?B?U3dlL0JBRXZXS2JMTDhLS1V4L3UrRTY2N3p0cXFkdUZsTjNzR2FPUGVYNDRr?=
 =?utf-8?B?cVpaT3VLU0xyRVlEWXJIVnU4YWhrM09MMnMyalF6N3NYY0tOQmRsaGQ3RkRT?=
 =?utf-8?B?eDNlb3pXQ0I0VlBVMWtaWTk5SythNVhDMzliQ0hWbHQxRmdVZlRiYUdhb2sw?=
 =?utf-8?B?RCswTThtQ0liOWY0WmcvU25lOTNSZkdzVzNoVDFwcHk3aUFGWnE2MXhSVFM0?=
 =?utf-8?B?TGJpZERpSTRKSTJnd29CTjNvaDlWdS95R0tjemdrZmpBTnFIMGtBNWs2RERr?=
 =?utf-8?B?YkRIQTkwYzlodFpqV3A5QXhpRy9sQjc4RUV6MUZKd2FtRzNkbGdmS3IrOWhn?=
 =?utf-8?B?UkRORjBWeVliaktNRzZIMGhRbk9CVTZ5emYyTUVtMEJmVWpMZnNoQjIybVBy?=
 =?utf-8?B?QjlVdTU1ZEhoTk5UVVhIYTBVL24xWnBsL1ZFNEROZTFNVDF6cHBHN01RYmtL?=
 =?utf-8?B?VzRMd2xyRFhRa3NNaisyZGVvRkU5OEFKVFZMdUxzWmZReWdGV1JES3phYTFm?=
 =?utf-8?B?VTdmZVdBTGdQNHpBOVRqampxSDFNMjAwWHRZZHVWdE1iaHFmS21EV3FFYmNI?=
 =?utf-8?B?b3YwWFNCQkdzUWV3VVMyZlB5ZnFoN1BiaUd3YjZ2NkJPcG16SG1RQzVGRlVh?=
 =?utf-8?B?ODYyTnprYmJPNjhZOCtuRTVBNWg4dWliQWxMaktIVVVza2dGY1k1V2FuNXhY?=
 =?utf-8?B?RTFZZVBWKzhLL1FrQnQxNXhIUjNMcUE0a05ia24xNlBqUGlVbWtKMXYxQWlp?=
 =?utf-8?B?M0FKVGJETXRld0RBZFVucXU1cHllSkJJQWNac2tTNjR5RXJlbVg5Nm93aFlu?=
 =?utf-8?B?M2JiQXZLOUNibzJtWmZEY09oQUYzalovUm0wekpOR3M3NjluL2grTjF3ZXlW?=
 =?utf-8?B?RDZPSTNoN21JckwzalQ3eUwweW4vTUpXUTFmMEY1ZjN6MlRkUkhVcWtHWjhS?=
 =?utf-8?B?MXN4TDVJVVRud0tyazQ5WTZ6bjUzZ0YxSDgvc3V2cGRHTVBVckZnby9TUkdP?=
 =?utf-8?B?Q3BjRmx6M04yRGJ3MXd6N1NOa2Y3NVliNTZUWlRWMzZpM2ZDZHBacXY1S0Z3?=
 =?utf-8?B?SURxTTYvblhhNXJHOFdBOFJNTHRaUlNpOHlXMjg4YXoxZHdLNWJxU0RsTmhi?=
 =?utf-8?B?SnJLL0tvQmNPNktiRVdwNmROVzRJU0dtWThaMndZdXVXenpPbWFCaDNPK28v?=
 =?utf-8?B?WE1qYWR1Z2FUamttY2xSdDBPK0U5UHFKT1dnUDVZSlR5WmFtYjB4UnpxOTZr?=
 =?utf-8?B?V2ZzeUZ0cjljelV0RFlpbE14cDNuSEE2Z1JkZDVsV0xIbFNGTk1nZEl5N1l4?=
 =?utf-8?B?bDU0QTFLTlgvT2x1S2U4eVk2NUlXMUhMeTc1ODB5ckZ0MnlLc3lUemUrQ0dP?=
 =?utf-8?B?RXlacmovNS8vckFkUGh0aG51WTB5blZYanFpM285dEVzQUVOeWRyTEUvNkEw?=
 =?utf-8?B?RVV6OUljVWE2YWpUWUtsckpIdW5aZ2hmYlN2eUczaVpzZHl1elJRZXVuOWQw?=
 =?utf-8?B?cDJVODJwZHRlTGZncmo2OWpaZDY2TjZ6aUVwRTNUdTcxZ25pQklIUFFOSm5D?=
 =?utf-8?B?RDR0aktVV1Z5MHVVNlBTaGxnVmhMMWswK1pZR1gzcXJTOGd5QU1BQWRpSW5z?=
 =?utf-8?B?UWNnSThLUElPUFBhdnV2OW1SSU1tTlRiVkJHakh6TzFrYzkxQW9ncVJnNkhi?=
 =?utf-8?B?QTJEMXFXNGxvUnFxT2RzUmtQY3MydXB0ZXVySlRGZFBLeFg5dStDcW1yNG02?=
 =?utf-8?B?c1VDMFJRMEFyNTFocFlxYTVZRjFSNVozTW1ZQk1Mc0dCeHU4UkJvcWxBMU95?=
 =?utf-8?B?c0FreVZMZXFiRndBZkRneE9udkV3eHdmZ0YrNVgzc3NHZmJoUnkrVUpRc2Q1?=
 =?utf-8?Q?tzQVyBY7SmH8K4gAPWHuP3WMFTXDFrWxAEtLxDoO8ttOd?=
X-MS-Exchange-AntiSpam-MessageData-1: LEKK+Ae+7ZDN37kNGGoYjFi/fw1oLu5AcwQ=
X-OriginatorOrg: codasip.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 484a2d7f-4ad6-4547-c50c-08df2ace9179
X-MS-Exchange-CrossTenant-AuthSource: AM9P192MB0983.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 15:11:20.3533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0d91ffef-bb81-4cbd-b9b8-552583685f20
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZoGmrjz/AtrXG1KET9fj3CcpOXtPFyJpQt0l9wbbwqebcbPVQWXN3SWMcloLmgk0RLRH+JsDueEfgj9Lfm5VDVD8zWkdsbc1IuIlQh1d05A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9P192MB1898
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 894FD10000E
X-Rspam-User: 
X-Stat-Signature: x666fde3f3ojgwp6wdqry9nz1ngee66z
X-HE-Tag: 1792077091-954073
X-HE-Meta: U2FsdGVkX1+3A20Ud3LNVpr0Dzwjnlva7umY5FHDpwzmBhssj6Qyt0QnOyvtisuEeHpgMvKiczVLQNAxD6UO8ywu+FH+iQo0+4z9jewO4m1uCONbpyA4m/t6UgJWnT39pUt0gzeUGO8UoU1hWGQNUsblOEZGjXRCspzaZkPYbnEmy5mqok3/451fDFPRFHKqbs7LP52/znic25xxC0Q/tqjBppjkIqSuUypOhKh/ivNSbWyVSkVISKh+V/dQvpec/f8ncBZVXXtoZuyLmHtHHJpu2DpEddReumP68EwmL5okGRVdpZcM33L07RksnCQtyui6vjQCkWouayKviSp838NgtqYiuVM2fmIT34PrbbaCFZfeVIjkoTsx3Oc9ryqWd80RLdiV9740NzRRCJznyJw3V36EF+lpJA6P4I/DelltTLJ5iGo4Ij/Jhx7OgDRLURkQ4IRCsEXX008fJzxEI6jX3TJZw2MBrjsGGWU71wuAlwu4KZLrawqdr539vQk2IWfMUnNiAluOUWhZ+Y+fVu+d1wSjNq93H8c8oMowvdqjB5zpCLd1FxZ8OXC7xziQC/aM8R/YGo6ryWYYBl7RZfqlfYwR3OOtuvl2/K4KerQvazoqh9wAqh9pfxXuK6AWRNaWMMUeYcs3YyxVaPUIcxsx+vZwIHeG48sXEN3qvEw29Ho3nYvMAcsCAjkrQfDtaW/wVC9nH8tj1Fw5EMKFDZ1rYBTFhfZcCin1D9jh/MXBb269bqYf5f61FlhqPoaA0/8DZHVnob+VNrS0zOTanfg46VQHO8MlRv2HJejGtW6UWE12FCgfAM0AUCnjvOdQx1+VD51QADHQBfl2IaNO5Fx5l6oXKmzj+HOchShDemnKbxNd8o6S1R62huBtNOahWaCmjXU2kFeYZbv6ktU8+t8k76/m+q1M+ytk881anQ/KUDZzxPyxp+Wy3PFGypyS/tM7BcLlQ3wZdXON18a
 UST/3I78
 dpKKxlqgfTpb3ImL0GVChi7K0usyImEQVtJsxM2q2yDfZHBry6A8IiCLELRl0DtOuYkLTvxMp5M4+yFUggx/xgznXomJNCG0l1bpjmymGYl3jzBtPAO6dyL7fxCIN85YPCjaneg4BTcKhE6rEhVum43gH6bszjb4CcHe4/DiC6gPlP/gVXwVU82x3pGGaSRkkPjOkWIu/lEC7LGwRu5TULlwX77JEzr9UzexfspdFwPzN/k7TIc+3daXvw39pET5WgMfxyCrhZzNDY/cJjpT/RZUzW1RAqBvwEAu0t1ijZgBxYoDfAvJ9f1lgio1gC6ZF3gKbQcA1I6gCDP2YGZSwFiK78FInWWeFqrM6i9h7QNhlEvyRem87oS43kXM6Qfje/0vKBJ7qDRzS8mKy2IfmAuQK/ymIBbEULvIFR+Gue361rRHhBLMWyJBBzQBYgE/1U9QZbZXr/D0XjUXr58/ezOSpH04Gbb3hdInpnDg5aocBREjcDz8cYDh/pAqskDQGTreF6ky+z1VpVNKJn0iZHbZttU1m/Ivyc7zsfXmOI34QZD497bs+jt7+7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When an RCU-mode tree that is not an allocation tree is destroyed, or a
subtree of such a tree is replaced by a spanning store, mt_destroy_walk()
runs with free == false and the nodes are freed later by mt_free_walk().
mte_dead_leaves() replaces the slots of each dead node with plain node
pointers, which lack the type bits of an encoded node. Afterwards,
mt_clear_meta() clears the metadata of the start node.

A maple_range_64 node keeps its metadata in the last slot, unless that
slot holds a child. mt_clear_meta() recognizes a child only by its type
bits. For a full node (16 children), it therefore takes the last child
for metadata and zeroes two bytes of the pointer (the low bytes on
little-endian). mt_free_walk() then frees the resulting address, which
usually points into another node, live or already freed, and corrupts
the slab.

Storing 120 disjoint ranges into an MT_FLAGS_USE_RCU tree (a full root
of height 2) and then calling mtree_destroy() and rcu_barrier() in the
userspace test harness under ASan gives:

  ERROR: AddressSanitizer: heap-buffer-overflow on address 0x7c64552f0000
  WRITE of size 256 at 0x7c64552f0000 thread T1
    #3 kmem_cache_free_bulk ../shared/linux.c:149
    #4 mt_free_bulk ../shared/../../../lib/maple_tree.c:144
    #5 mt_free_walk ../shared/../../../lib/maple_tree.c:4784

A full maple_range_64 node has no metadata, so do not clear it.

Allocation trees, such as mm_mt, are not affected because their
maple_arange_64 nodes keep the metadata in a separate field.

Fixes: 2e5b4921f8ef ("maple_tree: fix freeing of nodes in rcu mode")
Signed-off-by: Florian Schmaus <florian.schmaus@codasip.com>
---
 lib/maple_tree.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index e5c0eeda0bd7..05546aa53871 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -4886,9 +4886,17 @@ static void mt_destroy_walk(struct maple_enode *enode, struct maple_tree *mt,
 		mt_free_bulk(node->slot_len, slots);
 
 free_leaf:
+	/*
+	 * A full maple_range_64 node has no metadata: its last slot holds a
+	 * child.  mt_clear_meta() cannot tell, because mte_dead_leaves() has
+	 * stripped the type bits from the child pointers, and would zero part
+	 * of that child pointer.  slot_len, the child count returned by
+	 * mte_dead_leaves(), says whether the node is full.
+	 */
 	if (free)
 		kfree(node);
-	else
+	else if (node->type != maple_range_64 ||
+		 node->slot_len < MAPLE_RANGE64_SLOTS)
 		mt_clear_meta(mt, node, node->type);
 }
 

-- 
2.55.0


