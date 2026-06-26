Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D96B3C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 13:43:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A67516B008A; Fri, 26 Jun 2026 09:43:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F11C6B0092; Fri, 26 Jun 2026 09:43:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8915C6B0093; Fri, 26 Jun 2026 09:43:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A48E6B008A
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:43:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C9D888DEBA
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 13:43:04 +0000 (UTC)
X-FDA: 84922179888.28.ABA87EC
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010008.outbound.protection.outlook.com [52.101.69.8])
	by imf03.hostedemail.com (Postfix) with ESMTP id A2B4C20010
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 13:43:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kuka.com header.s=selector2 header.b="NZUtMs/g";
	dmarc=pass (policy=quarantine) header.from=kuka.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of Alexander.Krabler@kuka.com designates 52.101.69.8 as permitted sender) smtp.mailfrom=Alexander.Krabler@kuka.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782481381;
	b=Mc8MaI/7vBbZpyLfCLraLlmlTcFGMuqbY3lRHa6+27lPL/alt1eO2IwjvWjmjVLLmo28RS
	I7ADieuXTwYbWXlbbTNlzPJ2v3TsENkpX1BBQ8R7nONNsxE2IKZ1mHcqDdKKeT00ZlR7jk
	ZmQ7O39uaO3H8AlAfwCFyAHd/8Pff7I=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782481381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DhjfHRkIf3517tVmDO540fbMJ+KlLZSCmh4lihZgtO0=;
	b=hfEAI17brS+AGm3YHH+SAjPVf8EvbiwKUQIkkXL+6cRa8/Rgo73b8mCcMVCjNUUdtNB9qW
	Cnrfw1x4Z8GXcF1WgFkLeQRwpynmtDKwfnaT/5vphvtvO7pzMoX99KhzYwqQq+otPbGwq2
	jnNfrFkp6J1dOlwvy35BLigxU6MWbtg=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=kuka.com header.s=selector2 header.b="NZUtMs/g";
	dmarc=pass (policy=quarantine) header.from=kuka.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of Alexander.Krabler@kuka.com designates 52.101.69.8 as permitted sender) smtp.mailfrom=Alexander.Krabler@kuka.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=txrpnqgirYlpA1OE9RKUptgsKAlC9B1QyDOAUllDGbXvgAxv1afBWmeeeQWx3INPD0Rz6wa67bZd3oOQ62ijU1UvG3NJeq2MpWN5JT/ITIyYivBL+Cjp1IL+oqMkpKnWfsdBldWF/eCbBo2J7XTUViLoF6tuiMsmStEU27CYcTzCu4VO/Cpc/Y0Ip7ETPmCPVuQIhvyH9/hCCNMQroskpsUiSWcGxPHACtyg7882ehKIKA2zn2p3QUGOwtB8IArtUH3bjYDE5c1h/8zLT16hq83VQ18tFhiy8Wn49qpuyqgQGFBGYCvRMbDSgdF38h+pWOvBvfXea5HEIvKB34qcgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DhjfHRkIf3517tVmDO540fbMJ+KlLZSCmh4lihZgtO0=;
 b=Zl4JhHpYGqEf2Dowm5u7OoS0UotIJ4xDbhpmm8TLKxKEuinkcnmsj9OHkXmjGIru/N4T+AnQKWd2hpXoqyNr0H/YsEaDFdFIWspjQa5EHT5yNrUZrBGdQAdZ9M3h20PirqfmNjHFZL85utRJmMe7trKHC0pegART5xJbWk7s1hbvE+pynb3GnBQBa0/00wwIRAAOeaJnUhICBci+PJ7E8eEu/GQV0/60z2IIQZ3aoQLFG5dgcj0Nq7lRigbtsVzbReou4tZjopvQeChY6lJILzdvQjgHsHycG+IkykmJOe70HLYfCshtvM+mq+Ldpnz6NKDF5OC5myHwsGvhaNf14A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kuka.com; dmarc=pass action=none header.from=kuka.com;
 dkim=pass header.d=kuka.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kuka.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DhjfHRkIf3517tVmDO540fbMJ+KlLZSCmh4lihZgtO0=;
 b=NZUtMs/gTwosP1orlpZFV9MYCZEXCbScQbJsb0Xs0S0czfmye0zlZHmpHydJW3yuYP/RhomxWnxmfIzIWKUeKKUMimsGXD4DWJFMHopITE/Yrw4A6FEdDHutqeya9epimR4ar6/VcTwgeasC/BmTrIE3BdDgLGV7NnxBjIpWzrm1K5iCgLTWSSjOZBngbmmh5aIPgvrKyY9OH8URTWBPaeYpvLAPsYGRlxJYYZKFvT3UHzqbWb/PHhh+8Aog5B/qf2NjwRiwc/sLeoP0wxSbsbtgOMeB6nq+TpRr0arV3gvET1cp3TPP1IkwEah19f9gpouqX3QfQGeNcND1teT3WA==
Received: from PR3PR01MB6666.eurprd01.prod.exchangelabs.com
 (2603:10a6:102:63::22) by AM8PR01MB7930.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:3d9::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.17; Fri, 26 Jun
 2026 13:42:56 +0000
Received: from PR3PR01MB6666.eurprd01.prod.exchangelabs.com
 ([fe80::7c4:3143:57b7:cc04]) by PR3PR01MB6666.eurprd01.prod.exchangelabs.com
 ([fe80::7c4:3143:57b7:cc04%6]) with mapi id 15.21.0159.016; Fri, 26 Jun 2026
 13:42:56 +0000
From: Alexander Krabler <Alexander.Krabler@kuka.com>
To: Wandun <chenwandun1@gmail.com>, "Vlastimil Babka (SUSE)"
	<vbabka@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
	"linux-rt-devel@lists.linux.dev" <linux-rt-devel@lists.linux.dev>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>,
	"jackmanb@google.com" <jackmanb@google.com>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "ziy@nvidia.com" <ziy@nvidia.com>,
	"rostedt@goodmis.org" <rostedt@goodmis.org>, "mhiramat@kernel.org"
	<mhiramat@kernel.org>, "mathieu.desnoyers@efficios.com"
	<mathieu.desnoyers@efficios.com>, "david@kernel.org" <david@kernel.org>,
	"ljs@kernel.org" <ljs@kernel.org>, "liam@infradead.org" <liam@infradead.org>,
	"rppt@kernel.org" <rppt@kernel.org>, "bigeasy@linutronix.de"
	<bigeasy@linutronix.de>, "clrkwllms@kernel.org" <clrkwllms@kernel.org>, Hugh
 Dickins <hughd@google.com>
Subject: Re: [RFC PATCH 1/3] mm/compaction: skip isolate mlocked folios when
 compact_unevictable_allowed=0
Thread-Topic: [RFC PATCH 1/3] mm/compaction: skip isolate mlocked folios when
 compact_unevictable_allowed=0
Thread-Index:
 AQHc88tI1dDVY1j8J02KOQzrNPN747ZDLUoAgAEaZICABitEAIADOO4AgAL622mAABC2gIAAQ82L
Date: Fri, 26 Jun 2026 13:42:55 +0000
Message-ID:
 <PR3PR01MB6666EC8D53E75F742B37270282EB2@PR3PR01MB6666.eurprd01.prod.exchangelabs.com>
References: <20260604023812.3700316-1-chenwandun1@gmail.com>
 <20260604023812.3700316-2-chenwandun1@gmail.com>
 <969cb14b-5b8b-48e6-add6-4dd13101dd89@kernel.org>
 <040788a9-e0d5-478e-bb48-3d22b8b41020@gmail.com>
 <c8793c0f-7156-4cb7-9e6e-7909397e2fff@kernel.org>
 <ca1115c0-1509-453a-8235-08e381a3da6f@gmail.com>
 <PR3PR01MB6666C11E08516555C153D4FD82EB2@PR3PR01MB6666.eurprd01.prod.exchangelabs.com>
 <a96b0b24-c405-43c4-96ef-605bacd17cad@gmail.com>
In-Reply-To: <a96b0b24-c405-43c4-96ef-605bacd17cad@gmail.com>
Accept-Language: de-DE, en-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_717b8430-11b4-47ed-b1b2-7ef5cdca0b43_Enabled=True;MSIP_Label_717b8430-11b4-47ed-b1b2-7ef5cdca0b43_SiteId=5a5c4bcf-d285-44af-8f19-ca72d454f6f7;MSIP_Label_717b8430-11b4-47ed-b1b2-7ef5cdca0b43_SetDate=2026-06-26T13:42:54.929Z;MSIP_Label_717b8430-11b4-47ed-b1b2-7ef5cdca0b43_Name=Public;MSIP_Label_717b8430-11b4-47ed-b1b2-7ef5cdca0b43_ContentBits=1;MSIP_Label_717b8430-11b4-47ed-b1b2-7ef5cdca0b43_Method=Privileged;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PR3PR01MB6666:EE_|AM8PR01MB7930:EE_
x-ms-office365-filtering-correlation-id: 19c92112-1a6a-4309-e674-08ded388d40a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|3023799007|38070700021|6133799003|11063799006|5023799004|56012099006|4143699003|22082099003|18002099003;
x-microsoft-antispam-message-info:
 4nl0H7r7TBdlZXmWo+6lcu25N/HSiQ7JJguVc1AeOtAYK4T/FTCnjHiC7CyO+6LgLT3mFgxHWBRmAjvInStzdfobzBdZbVXTZuhY90+BJPLq4sergYPV7kY/XcKbHkQ+foELpHllq1VkZf095s4AatV8QN6SL3mCRfr4iZVJVKRRmbKyJ2a4lQlOOJ7kgkZ0kTFGCpkU4pi+IqaXh4Y0msBdqDEvfz7vymRf//9bSK2wElAIuRnSLhscg30IZ605auWeI3Yh4hi5FGDgMZoiBbS314HHCIwg0RPsOeDjv3p+LxcYK66Ob4knla5GplFoXdRUSf9STOEzfnQjukUjo6efO1CDqKsYvOhyTXKoi/Xq6x8IgHxZBkwTA8CtgDfey2AG97Wo31/cWXu8VRGTSl/MW3kwgsq92oknrEHrUwocEOQLiZD0Ng5BfD40AHsz9OsGrn5oHmYQQxJoucKksPD1E9RLfOp6QNRBROKc8S/kzX03bFgOoFTA3qFHWdKCV6BWEcJJVwG/gNtbrDI34P19vdCYuCBb4T59XWqL3PQzr5XmHMQhrwrT2KRUHoE46HH0RgyjzDbww6r3uOW7VygtGpB1C4LinNIvrBjlWGpI+hguPkPl8UiowTR6lTFYXjCJNYiMrsS5rlA48ZnF6NC+OS6IYM62Z8O56m1E0lkN+rDfpkxl1a8eLRDfednTxYUcNTTwIWguImQpjZUtmnx2ORovvYw7dJbA5R2ChM0=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3PR01MB6666.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(3023799007)(38070700021)(6133799003)(11063799006)(5023799004)(56012099006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?+PxdPxwWaBQoyFlxeZslL9Urq+oD6N4IVNRYTxDSx69Rnalt4bACsqQkok?=
 =?iso-8859-1?Q?/kbHAIlg9X5hc/zve1m2S5AoXmklo9JMbIWn3sRZbo8S3jSGVjy3Al+doV?=
 =?iso-8859-1?Q?/KlV45qn/e/ScT5bU0OwpjGE1+AqGV0b3tn3Lntfp+2HxfF9ixIB5WL085?=
 =?iso-8859-1?Q?F7+1k1eBemeqQmRKEOkQcbGw94o7yQbNyU9UpODSMA0x3HUFFeVUjRi312?=
 =?iso-8859-1?Q?leHSKTpm3L54yolU3atr1DmwZ0gKjhzUsc0JQnclKP67LH9Z5hTNMFSRF/?=
 =?iso-8859-1?Q?XOQl6ikJWZG/f5CBdPwicTNPVEf/ryV+3h3HVyiGeEuhyTsySEyXs6+v9/?=
 =?iso-8859-1?Q?GXjqAujdKkPpJmLIL+bLIFdedPU3IYszSBrNDdZX6XYj0vazcM+g/dIVQA?=
 =?iso-8859-1?Q?CB5GpzM8owi9r2jWaji7pDe7jstbQvXnBV8zZGsFf0RjFx1QaSXYZbuyAX?=
 =?iso-8859-1?Q?Ce0v2sh77NF4zmH4+70eCuhfOlhzCdEXGzkeQTuZL8DIajshOz8O+jX1P5?=
 =?iso-8859-1?Q?cfO9/hjY4NvKec4+woewUbgIGjmfVGYFAzkPe/I3pEpwfcyiIaBR2a3pYF?=
 =?iso-8859-1?Q?+BkJY9c/Fo+FczdE4cLvOsho7xhXXRJq3YxTEIEuqOsJ3n3/N5JF+AIriH?=
 =?iso-8859-1?Q?opsbfaySiCukBgzj9Rk6863j7+a/5JFl8Lg74s9xVTqhHfg+7K0X0uhFVE?=
 =?iso-8859-1?Q?7z+3ZS2jg5DQubIf8QFf+AHJEp6gU5vP50d/nG1QedDqOaSIXTJc4zCMzY?=
 =?iso-8859-1?Q?8frj56e7TsmeK4PxCvmLMJ66RP+I+f1ki+5F5EHvGKqmxfpVnvKbMss97x?=
 =?iso-8859-1?Q?ijdPpVrPSznemoZ4OnUH5A5Y/be/LRPTu77Y0T4XUhjtpRCLABQ2UkVG0X?=
 =?iso-8859-1?Q?jK8F2zFsQc8YpgBvo/yQuwgwCSdw2WQpNKNa7qsEf7QP4Ofv1kDBgKu4kL?=
 =?iso-8859-1?Q?S/gsKFN+ggbiXtF/tO1RmOYFFFP5+XdxGgNx107Y9o9SC7tKh4gtjQlg96?=
 =?iso-8859-1?Q?Wh0LB5jIwuYIIvXXIW1ypF1J6fkqBRMyqTJKC8FjYXxf8cWvfOfZK69503?=
 =?iso-8859-1?Q?6gKxps6bY6FcfPc4/Sg9B1M8J9n2HwV73327ZZTkukS3VkCPc9Rfcc3gKG?=
 =?iso-8859-1?Q?7/n8T95lAEfTeQhJ7/u5t4mH7rqD4ClnvjKDKQ4VoVHXKVbSK2nk6nhIr7?=
 =?iso-8859-1?Q?6WKterJ9f+NUctbIZOAFRbTZDiv+saHhl1JUMQJNtMBEbMD4d/+1kEu9L5?=
 =?iso-8859-1?Q?DK7/qetSgJYSkLcF0HbwyBr48wFJbwvWcNi5N5MVMDPMDC+Da+S+UhqnDg?=
 =?iso-8859-1?Q?9IDlV/oSzWF9Fnuw18PS6zQhhjcCYypy/YTVBv3iYVnaiViSH8581Ek5iH?=
 =?iso-8859-1?Q?QehfRWl/LMZkOUN5y65RhsnZ/4AaH1YjfSBcFCR1eccmp+s3R9LhXXVexs?=
 =?iso-8859-1?Q?2a0A100e8UBaV1SKxj9//cu9V0+UcTB65WjRtEDTIrxHRrzy9GEfdNSQTS?=
 =?iso-8859-1?Q?dbLuPlSg+vg+VIrQbCSb4Jw7NuJ7mw2ETuALBC39xuZuXabN+AKJq1ecvx?=
 =?iso-8859-1?Q?GEAZtIKKgL+6AAX6+phfVz4Mv0R1QbQLd6lp5J7Dr+HOXcDsSzMJutYknE?=
 =?iso-8859-1?Q?5QjltuQvt6UF9u8fpSuA/4nWWJcijducf9efkpzOHBk2aUrVhgvLl8NeQK?=
 =?iso-8859-1?Q?w8ckyKAcQ0tYCKhx5ZL3ff4+C/rFVOUvEMR9yXLosAaVFMrAeu2EzFkT7K?=
 =?iso-8859-1?Q?b3BoAufZkD9GR6FVA3PjJa0lHUhSNkXij3O6nUnAIQ39fsqWZyGUbRZ9OG?=
 =?iso-8859-1?Q?KUheZ/4fIA=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: kuka.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PR3PR01MB6666.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19c92112-1a6a-4309-e674-08ded388d40a
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2026 13:42:55.9383
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5a5c4bcf-d285-44af-8f19-ca72d454f6f7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2m66vkxbWtsKFI4tvY3BwCj3yZ31AeQkPImlw2bVCCpZqYqhxp5SD6dBm5bPHvKuDQ8TwZ6UdJoUgTGmGZ1tqJEVDEbjiQ9gTtKhyw75Q4M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR01MB7930
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A2B4C20010
X-Rspam-User: 
X-Stat-Signature: pbk9s4ri6wha9bjghxc8e1e6ksqk8gpg
X-HE-Tag: 1782481381-752244
X-HE-Meta: U2FsdGVkX1/gH7bz8aKcpyzCv6XBo0y11m14+h4L6GdgXPRb5SeICNOspshtABvkIJzRbPlvcj9wEXwoefAxdZZsgLu2nTA+uAUWgGK1flQeFPHamcB4XO8fdI3aXDkHx7yczAL0YYeYwQFghE6y5NudYizu8yMTWUwaT+bu/aj7+LWPAZvVeIO6Mb3b9Wd79tj/l3Kdp1RIABk+hPWgnEPSFr6mHGAhITqsCsLKHHxMtmv1cNgZsQldeMRJWMuF7jqxCp5v35wurzTNmaE9CE2fHX/yxhTabZ5uZ4jVUWns8yeCqZ6JMgBRVnwbS0vraGA1z3THvznMtCAEuElR406guSmMT2zemfhp0mhCR/th25vbKqe9nOcmntu1D2xxx3DIiUK2GUoUAym3FOXYYzWxGMyRc+yy1IVLzYsB7QvgZ/4FABGkrO2zGBnf1fGi1aqiM553CccuVOEMv0BPN9M3UbdraStr9G4xroR7R4H5weKyOWOcOqNVlfkzOYW2cR8gkYSwUNwzkLvsYrJce6lJTQekCTrwHI3En7JMUlzKhQCy7GrFiEL2z6iAexYvdaQOhWcLPIHfDqtZ+3U4Z0TWbOso3H34NDwTyfwDw/62OX9QKU6kLdxNcWxrn8LC33solQfAKPJfVmrKqR8KOCORSSUQQg0/mbQ+0DstvCI5EFK8/WwCD8UtyJFn65eAkwBpEWzqHclR/kXeLvJZ5QOean57TYapsI+LdEU69DSdGhYlgxqwULLSUnDa4TysVMagbGqBEujsvA2ri6J9eGxwy1/DYp0VeppQ4ZQEjWElXgCfvUQrutzHd3lq1DFM9XsfchoUv3YnVhqUjphBo4sPArfvJRk/7Z1X5j7vywoq/n5yZD6jMoRgNEkhKbtLZTGjNoj0+AKT8emPcPvIxVqNUjMlqCR4q2uuBz1RljCo5gpv8b07Q08Jv91SpO/IC+Dn2S1yIXNAdzOwAPC
 /GVPbPYX
 +K5OAnMp2rWx4G0ZTQ4Visye6Y6WJ1TIV0zyUB1A4gl/FIcCq/Jd0TIirbtPedUuijjVOma4uAKcvAZ30wuve79YPiZXlzbAxfsuzeNSUYrYP+T0V4bZmiZwLwey75wAKdYPX41VoreWnIYKer1TfhbhtKGs+AxiBFrCDSXjY16zq9SS4ZjVUn6ExBtX02afJ7FMbUky8YlcF0c2X9BpvC4y2PaVuN5oLwS5bXqi80sxeMyqEbxd6r6XNL/QugxjiX3dN/UWnxzn+kAL0a+pdgA814UxqMKAYXnTRI6xLW0H3FRocnhhHXlf9GrV87Dd2+QSBl1DRO0VtVgl/6FnAiAoBihHVOth39hSBSbHEhkplXoheO9OPUM25PByMtA5E4s83XJN3IKn8LiBZIT13p1uXaGKaC4hG6ugzVcOU7bt+XlDPX+iD+wfRo8+PZP1EZCsGJtVOGvgRdvOhBiJtl+FgFRzzXeewLoGI7+EKgmav0SL58rxmOmyqLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/26/26 11:38, Wandun wrote:
> On 6/26/26 16:45, Alexander Krabler wrote:
>> However, we were not able to reproduce the actual race
>> (mlockall() process waiting on a migration PTE),
>> not in the past, not now. Might be hard to trigger that race.
>
> Not hard to trigger that case, I added a debug message, such as below,
> lots of messages occur in a few second.
>
> diff --cc mm/memory.c
> index ff338c2abe92,ff338c2abe92..6552b3b14f78
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@@ -4768,6 -4768,6 +4768,8 @@@ vm_fault_t do_swap_page(struct vm_faul
>                 if (softleaf_is_migration(entry)) {
>                         migration_entry_wait(vma->vm_mm, vmf->pmd,
>                                              vmf->address);
> +                       if (!strcmp(current->comm, "repro"))
> +                               pr_err("=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D hit =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D\n");
>                 } else if (softleaf_is_device_exclusive(entry)) {
>                         vmf->page =3D softleaf_to_page(entry);
>                         ret =3D remove_device_exclusive_entry(vmf);

I have a kprobe on migration_entry_wait set and logged into a ftrace buffer
(including kernel stacktrace).
Yes, this function is hit, but only inside the mmap-syscall, which is okay,
memory allocation is not realtime-safe.

           repro-2090    [002] d....   811.129549: frt_migration_entry_wait=
: (migration_entry_wait+0x0/0x100)
           repro-2090    [002] d....   811.129553: <stack trace>
 =3D> migration_entry_wait
 =3D> __handle_mm_fault
 =3D> handle_mm_fault
 =3D> __get_user_pages
 =3D> populate_vma_page_range
 =3D> __mm_populate
 =3D> vm_mmap_pgoff
 =3D> ksys_mmap_pgoff
 =3D> __arm64_sys_mmap
 =3D> el0_svc_common.constprop.0
 =3D> do_el0_svc
 =3D> el0_svc
 =3D> el0t_64_sync_handler
 =3D> el0t_64_sync

The original race was an instruction abort interrupt out of nothing due
to the migration PTE set by kcompactd.
And these kind of races I see quite often on non mlockall()-processes,
but can't reproduce on memory locked processes.

Example:
          podman-832     [000] d....   812.447820: frt_migration_entry_wait=
: (migration_entry_wait+0x0/0x100)
          podman-832     [000] d....   812.447823: <stack trace>
 =3D> migration_entry_wait
 =3D> __handle_mm_fault
 =3D> handle_mm_fault
 =3D> do_page_fault
 =3D> do_translation_fault
 =3D> do_mem_abort
 =3D> el0_da
 =3D> el0t_64_sync_handler
 =3D> el0t_64_sync

Thanks,
Alexander

--

KUKA Deutschland GmbH   Board of Directors: Michael J=FCrgens (Chairman), J=
ohan Naten, Hui Zhang   Registered Office: Augsburg HRB 14914

This e-mail may contain confidential and/or privileged information. If you =
are not the intended recipient (or have received this e-mail in error) plea=
se notify the sender immediately and destroy this e-mail. Any unauthorized =
copying, disclosure or distribution of contents of this e-mail is strictly =
forbidden.

Please consider the environment before printing this e-mail.

