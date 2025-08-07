Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25BB9C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 15:49:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE66F8E0002; Thu,  7 Aug 2025 11:49:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A96B68E0001; Thu,  7 Aug 2025 11:49:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 937FB8E0002; Thu,  7 Aug 2025 11:49:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 821EF8E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 11:49:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0F620137473
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 15:49:22 +0000 (UTC)
X-FDA: 83750395764.09.840A330
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013019.outbound.protection.outlook.com [40.107.159.19])
	by imf23.hostedemail.com (Postfix) with ESMTP id DDE8E140005
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 15:49:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kuka.com header.s=selector2 header.b=X8dDoCWW;
	spf=pass (imf23.hostedemail.com: domain of Alexander.Krabler@kuka.com designates 40.107.159.19 as permitted sender) smtp.mailfrom=Alexander.Krabler@kuka.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=kuka.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754581759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JH2+vvveX1TmNO3qx8kiRYAjwqP8T+HkdHGc8fqdgU0=;
	b=G6PfeMtWRhbM4Bz0MLOQpAVTWoBGxAJ3L31gjm/mN8f4QjGvEbHX0qC1JkVFV3v3d3THaL
	vpdiHdRb9Wmd2Ay3LB1TYvrZo7Q//sGtH5Yq8dZJAywPHjDTG6F4NMeOaOJRRdZkjgA+p1
	HgvVKNl1CJ8Vl2oFozpxVadOO/8D4MU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754581759; a=rsa-sha256;
	cv=pass;
	b=U8B6E/uOebjeadd52LbJLsVjdF++kxrwXbpI18YFeTCan7qwQqftL2oXeereX8nuceKolT
	8be01Hq4F9tzMYBcLhBeL07iMoIw70ERyerE4d0k907EYZbIg+3aoIySNTXeQ4VakydnZN
	jaDbBnrSCubignfx3JhatTm4wgnKCVE=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=kuka.com header.s=selector2 header.b=X8dDoCWW;
	spf=pass (imf23.hostedemail.com: domain of Alexander.Krabler@kuka.com designates 40.107.159.19 as permitted sender) smtp.mailfrom=Alexander.Krabler@kuka.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=kuka.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L+fXaTZmaOiGgpmDRecJHhHll4cXky0Kb47SngSEALBf5IrvX+pP1C+1JsHvUGUqQebedVIAqwCXEKFlipiyE0cmZ/vp+tJjRLpXTXsGXBV9bJlkjoEVKxhpvle8ZzPhSponhcWmks0hEnkgLJzys9v21xu0t1nonS7l1VWZtaJdPv4AMabePGOp2S1aGqn+Da0ugsX6mcVgYy3erNDU0gwegVaKZragmqnWINZUXfOzKtEVsDN8UV9k/7hiv7HA1Dzun4pLl4hGqrmIQauBICmYaR4hd9Wb9wk5ttBMF7xVZmjskIo3n7XuOxMPp5CXygieINSZw1gholgx04m6LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JH2+vvveX1TmNO3qx8kiRYAjwqP8T+HkdHGc8fqdgU0=;
 b=vNAyNR8G/mGfllCt0Hzt5E/5APSRFSR6waXfWmOZl8gPF3pOCxf14ndtdM1sszsWVneOXB9FguGtHKWZdHwzkhgkwQeRSCshwbV8QdjCEcwqFH7D6Vkb/cCoO9CfH+egKJFkJf/4E4LVI7W7Qjcmpyrtvc3dqr8/ILPm88IgqIBWiBZXRvqsgZ7LfVJP/d3tqKMCRT8rjMkcvxXDX1OFm6bh5ETAotd3/fEG82iosGVTj6JENTOZpuLD8Kr4CACkNRE1SallFstsZQFZ+lJwIYEOMWZO163HAmgjhQEoEy3kkutmanq5EXm8hKTVLm3eMnfedLEah9DoScGTZPJuUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kuka.com; dmarc=pass action=none header.from=kuka.com;
 dkim=pass header.d=kuka.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kuka.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JH2+vvveX1TmNO3qx8kiRYAjwqP8T+HkdHGc8fqdgU0=;
 b=X8dDoCWWEONYir/gCIeu5i+Yl2JViLXQoYZOCk6GRFGF0PkOrrvIb87tHlyjjIASho7tib+HcJlgmFdNL0lKqZBml/fRNuF42dVS28vE48gZXeHs2kBj011Dee2d62LMVn//xVkIhpkuU/2ime8j2ykZyc9GkLKMf7oanJuFwZLiB+qpiBfvwI/y+8LgIYOYO7LPUwDEUHne1EhxlTeuvHFHfh3KzcjtoUMjb6WXdoG+tQ4a3pUtAC/fSlSr1koKEuRPFRhPVbUUiRwtol/TcHtI6psRfd+BWk01tJoDIxIcVdT8VW2h2vVdVZtCZ9CuT7g8rwryOuvsf2d1bJattQ==
Received: from DU0PR01MB10385.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:322::12) by AS8PR01MB7639.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:289::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.14; Thu, 7 Aug
 2025 15:49:15 +0000
Received: from DU0PR01MB10385.eurprd01.prod.exchangelabs.com
 ([fe80::27a:7a68:5d97:fae3]) by DU0PR01MB10385.eurprd01.prod.exchangelabs.com
 ([fe80::27a:7a68:5d97:fae3%5]) with mapi id 15.20.8964.019; Thu, 7 Aug 2025
 15:49:15 +0000
From: Alexander Krabler <Alexander.Krabler@kuka.com>
To: Hugh Dickins <hughd@google.com>, Vlastimil Babka <vbabka@suse.cz>
CC: Frank van der Linden <fvdl@google.com>, Mike Galbraith <efault@gmx.de>,
	"linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, Dennis Schimmel
	<Dennis.Schimmel@kuka.com>, Daniel Braunwarth <Daniel.Braunwarth@kuka.com>
Subject: Re: Realtime threads delayed due to kcompactd0
Thread-Topic: Realtime threads delayed due to kcompactd0
Thread-Index:
 AQHb/SUMECAAoxVz1UW75TJas4YXXLRMmU4AgAABygCAAIeOAIAAeK4AgAAXRlmAABqvAIAACbGHgAlAa4CAABnrgIAAKIG6
Date: Thu, 7 Aug 2025 15:49:15 +0000
Message-ID:
 <DU0PR01MB10385C55AEAFEBCA2575EAA77822CA@DU0PR01MB10385.eurprd01.prod.exchangelabs.com>
References:
 <DU0PR01MB10385345F7153F334100981888259A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com>
 <CAPTztWYf82p6hq=Q2mVq6_9WTjRaQiH81z4idZL6MZ1PXufPwQ@mail.gmail.com>
 <71df781c-3ef3-4b26-9ba8-93fc7d4f9eec@suse.cz>
 <026de9fcd4f0ed17c2df95c4f7c56b878a844012.camel@gmx.de>
 <25ba0d77-eb61-4efc-b2fc-73878cbd85c1@suse.cz>
 <DU0PR01MB103857873A56FD121984568148226A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com>
 <c48f2877-4d37-4310-995e-fc5c2ae9a366@suse.cz>
 <DU0PR01MB10385C08C119276D99A234D978226A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com>
 <33275585-f2db-4779-89f0-3ae24b455a67@suse.cz>
 <771a8fc0-8195-44cc-55ed-c3573d497d2d@google.com>
In-Reply-To: <771a8fc0-8195-44cc-55ed-c3573d497d2d@google.com>
Accept-Language: en-DE, de-DE, en-US
Content-Language: aa
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_717b8430-11b4-47ed-b1b2-7ef5cdca0b43_Enabled=True;MSIP_Label_717b8430-11b4-47ed-b1b2-7ef5cdca0b43_SiteId=5a5c4bcf-d285-44af-8f19-ca72d454f6f7;MSIP_Label_717b8430-11b4-47ed-b1b2-7ef5cdca0b43_SetDate=2025-08-07T15:49:14.790Z;MSIP_Label_717b8430-11b4-47ed-b1b2-7ef5cdca0b43_Name=Public;MSIP_Label_717b8430-11b4-47ed-b1b2-7ef5cdca0b43_ContentBits=0;MSIP_Label_717b8430-11b4-47ed-b1b2-7ef5cdca0b43_Method=Privileged;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU0PR01MB10385:EE_|AS8PR01MB7639:EE_
x-ms-office365-filtering-correlation-id: eedd101e-88b1-462c-1e53-08ddd5c9f642
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?YkZzbTI4Q253OWFBQ1VZK2twWmJQNXh0alVSU1l0bmREUlIrQ0FLcDA5TDU5?=
 =?utf-8?B?NEErWi9iWHJSTnRJUEZpMkxDcDl2VDJyVEkwK0RDdm1QOUlmQ1FoZHZ6Z0VL?=
 =?utf-8?B?SG1DN2FLWG1sWXd6NitJYVVzVFp0blJlMUlKVks0M3JmQXc2ZDU4YkI0eEQ3?=
 =?utf-8?B?ZXBmTHVnUGpXTVpJMW9xMlpHc3FYcFN5MGJISldJcUZIZkZ3NVpNMWdDam9o?=
 =?utf-8?B?WWVTZVcrMm9nR1QzZnI0ZHpwSDJxYW96NmpyWmFsRnlGak5abFZjQmFhK1J4?=
 =?utf-8?B?Qi9lME5vOE8wZGw1TlI5bVkzUUFVRDhsUE5hSENZSEgrSGlGU1FlckdHcG1m?=
 =?utf-8?B?VjBvcENaL1pVQU5nNnNROTlBZW9tcmRVWDFnamhwc1BuTEN1RkJURnJ1TDNx?=
 =?utf-8?B?eU50N3dMYkRITC9KREpNbWhQUTJaTHFyQ0Fockd0Wmwwd3ZwQU02U1JhZnls?=
 =?utf-8?B?czVHeUJCZklQZjVJZlcxUXlWUmZleHU2SkhCWmRpYzMrczlWUEFYMjVHNHJU?=
 =?utf-8?B?b3h4Q2V2Q1kyaElNTmd5OCtjVHBJYzZ1bUVJNzVOZzRiRG8rcW5TSmlSa0l4?=
 =?utf-8?B?WVNBWmxvdHZMTkhRTDNDZVN6bXRCQzVDSWhaQjc3bWFzUzEwR0l4WHQ4RTVI?=
 =?utf-8?B?a0tudGtwNmRZUFNsZDFZTlpOTWdsa2pmOVNpemU5SHFic09aWm5BRnlKa1NX?=
 =?utf-8?B?MndrclNJTnpFMEJBNmg4QWJrZDRPVVJaeTluMFk4U3F2UlVzTjJ6cmo0azA4?=
 =?utf-8?B?Zm02QkVDNis4Z05aZFpDVDBWYXIvN3dzeXZiK3EzRC9rUWZGems0N01DeENk?=
 =?utf-8?B?a2NRTXlLcEFjVzIwMm85Slo1SkYweXpEZWNia2JWMm5ueld6UWtYcXYxd095?=
 =?utf-8?B?enpVeERJYW94SUJyQzRvd0xBdGhyajU2K0VMQXUyN3JYcjFKUzBBSmJZcldH?=
 =?utf-8?B?d0MyK0Q2NVpLazVWeDR5Z0J2SnpiMW9pakUycjVrUnF6Q2tjZ3BmOVBVZmxs?=
 =?utf-8?B?TUNIN2I3czQyZk9PeEc4VFV3M2lmUzBTa3R0MzBnV1c5SURhTVc1cVpQMEJj?=
 =?utf-8?B?dVlzdlBxaE11QU44eXAwZ3hsRldPMTM3MENvbnpSaGd4VkZvSGthWk8waklJ?=
 =?utf-8?B?Mlkza1RiNmZhQmptMVlOUHhUcUo4ZStVbkRvNW9RK1Q0RDk4SDl1c0tVQmt4?=
 =?utf-8?B?YjZFVlpMY0RqNmIxeVJkSzQ0RWZkZG13cUtoNU5mU1BsVHBMQ2sxeGpTdlJN?=
 =?utf-8?B?OS9UVEZiaGtkQTZBUTB4d1ZDY255ZVJVUmFvODg2Q3k5NDI0dnIzTEl4dDR1?=
 =?utf-8?B?Vm1GUnQvQ1hQTElFMkdhaTB2RWlxVDg5SUwzcXdNU3RsVTZmdzR2Mm44TjVC?=
 =?utf-8?B?R2N5Z2VJUVZFQ1NLVElrSThRR0w1SmFNTnZWRDR6cHZ3QmtMcCtMdnlMWHVO?=
 =?utf-8?B?QURHY1RSNVFJSlo4OTAxUUNYOUtFNmo0bGFTdGVSWGRUUnZ6aG9JbGd4cXZv?=
 =?utf-8?B?b1dTWGJrMHMvOGFwTVMzazJEQW41dzAvQXB2ekQ0SUdJVlN1eUpnQlR6WTFl?=
 =?utf-8?B?VTZYNFcxd2p1dlFCNktLbnQ2ZEhFQWg0Z3BVeGROaU9DVEhVQWhRRm5wV1dw?=
 =?utf-8?B?YTA3QmJkQTJNZXVrb3lRdDV5V003Mnk5ZkJza0ljTk4xampWMWxGSklFNnhn?=
 =?utf-8?B?SG9LS21hbkJNMmhRRDR0cFNMT1J6a1o1ZXdiVGpDZ0ltWE5scWc2VHVPTTFL?=
 =?utf-8?B?VUI3aEowR25VeFRsZU1FY0RlZy91OUVoRUxybmhkb3E4bXdmdmhiRG0xVjV6?=
 =?utf-8?B?VTdJNEVUSEYrSkNrWmE4YVlLdFBaL3JyUEVjNVdHUjdwWUxSK3lZZ0tKdUVx?=
 =?utf-8?B?a3E1MWMvMzZ4N0xPNW1ua2pKRWNBMHVqTmp3ckR6U0U5VG5aL0NITmRicjhS?=
 =?utf-8?Q?hW6n7QqYULA=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR01MB10385.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RWVmREZKV2JJUTJBSjRyaTVocVBEUmh2dkZXRGtub25sRWJ1cmhHdGwzcXV0?=
 =?utf-8?B?Umc2ZExNejkxMytHcXhCa0VVNEREd3JaS0VuZkVGU3FJdVNyTzUyTzFCS3ky?=
 =?utf-8?B?VWRXaFR1elkyOVNheGtGK3pDcUhGYWVydHJEd3pwWjBzaGdaakN5dEp1SGtK?=
 =?utf-8?B?ZE5XZzRqdkdtUWVVaXJmMWNYZjd1UEM1M3pHN3NZNHZtWjFZcU10ZW5Kdm5m?=
 =?utf-8?B?Zm5pelBWYzJxWnExN1ZYbXJoK0d0M0RQUVRhdkZhemt1dTBkK0E1WnFKd3l4?=
 =?utf-8?B?NE9ycVYxeWN3VXNxSG5hU3hIRVZoVXBFalhBQndST2RFUmxCS1dPU0dWWHkr?=
 =?utf-8?B?eHhIaytaYW5sZ0VobFBFVnZYc2hpSlI3RkdEM2hSNjdJWm9YV1k2aDBrV01q?=
 =?utf-8?B?ZFpRRGpiTHlZeVRsbG9BNkRIZ0Q0RW9uUFNheThtKzg1QVRibXU3VGR0Kzcr?=
 =?utf-8?B?S1QvVG10SVRBMksyQkZPLzJTQXBzTGVOOTVlUnpoTzBDQjU4RC9yMEozRXZS?=
 =?utf-8?B?dFNNSW1SNlVSamNHai9tZzVKbzV5cXpRa1hTRnBHNzk0Sm1iNm9JVEF5Z3dw?=
 =?utf-8?B?bWlHQ3pDcVFBS21XYUgvb3dLRFFNUGlhakVROFlwYU9zY2w1cWlMWlh5VFRp?=
 =?utf-8?B?Z2p6cThMd1Vma2pqUjh6aW5zYTBRTjZKb3NkMy9xaTBocEt2cVFCak5rSVFi?=
 =?utf-8?B?ajJ3M29pUEJqRTU4dkIyNHNhc2U3cTBVTWRxZHNOS2poSjMzOVhsWkJCS0Fr?=
 =?utf-8?B?WVg5cFJQbFp1TjM0Yi80Rml4elV0MDBwSEVCVGdxOUJBdkpNb2xLS2t2Y0xN?=
 =?utf-8?B?TGJvWlFkRGhyTmJsNWxhZFl4cU5Yd0g0ZEdoTDE2bXpEWG10Qmc0T091U25D?=
 =?utf-8?B?R25VSVpic1R0RDN1TmJXKzRsZUlGN3REbDRudmFIbDlyY0U5M3FYWEVHckNo?=
 =?utf-8?B?RkVyRE0xcXdmdGYxcU9jU1J6ek1rSVRCeEd0azhXWXVzN0tQRVlMU2U0Wm5I?=
 =?utf-8?B?VGVlT0MyWHpkQXFoZ0Uzb01mZ21rZDlRb0QrU1NCL3BPNjMyOTRWNVRUWndp?=
 =?utf-8?B?M3NEemkxSU9ZcWV5VS91TW4ycHkxT3YyMlNJU0VySkJKNDRQalQ5Nk5NekIx?=
 =?utf-8?B?Rk41R1FpU3dmSEtwWjJCaGsrMnJwTE9ydHVxbnN2M0wzL2JQNFZTRTY1akNT?=
 =?utf-8?B?ajNHR2UzTUVJbnJkaG94aUQ4Z3hId25YOWdxYklyRWdHRjFBa3p5MmMyVmVB?=
 =?utf-8?B?Mytodk5OdnpER3cyc0w0bTYrL256VGZPUFZ1VWlTZlVZZlg4U0dsdmo5UENr?=
 =?utf-8?B?aVlOM0x3UmFyR2JSVUJ6MWhDLy93SFNWU0cvWHBDb2dWRng2RC9uekNyaFhS?=
 =?utf-8?B?dHJncU1LNmp1eU5LOVdvckNQMnNacUt4cTArR3Q5bGlORWVKMC9VeTRqWW1Y?=
 =?utf-8?B?REx1emV4akF3TFQ1MlhRT3BLSkllc2xsZ1M3OUE2NXFQcHU2bUlySHczaHMz?=
 =?utf-8?B?QzdJSk9QZmRzU0ZQbGp5eWNWc3ozUTh2NTVOSUlkR2VPUXdyajhRODR3Y0E4?=
 =?utf-8?B?cGxMZktHY0o3VUlxanFOdmsxUHBGZTg4eGpDbVBTME53Q2RvbTNodzAxNVJX?=
 =?utf-8?B?a0ZCaWZUR3loZTBmR1VCaUhJUzJHMVZMRWFRSzhZNC9xejNNdnNrOTl5WXVx?=
 =?utf-8?B?Nzd2VVhQb1NaZytjVS84ZTY4ZzRuaUJadTBBdTkvdnNUVVFDZWxHOEhpWkZl?=
 =?utf-8?B?SGNiY1hBaVlGU2ljY3Y5SEhTUXZ5eFo0TVV6c09PbFNOS1VBU1BBQ2pEMk1t?=
 =?utf-8?B?TktpYkNUd3pjWGduTE53TGQ2MnZLTzkyb0lvc1BKYUt5N05KQ2NuYldhV3JK?=
 =?utf-8?B?THE3bTdhRk40RWhiektyS2xXdllRZXdVWVlHQVkyb1dyL3pSNk56dXVpeXJK?=
 =?utf-8?B?cGJybDJLT1gwL3hUWjZLUmtLOVpjaFpMYS9zd0JoNzlLdTVZQS9ERHkveTg5?=
 =?utf-8?B?aW5JdmE0ZHBuS2UvTFRmL0VVekY3SDdLdlpXNjQwNzNHM1lFYVFsdU13dTNv?=
 =?utf-8?B?eG12eTVxdWtYVUhiLzQ1UUVxRkdzdlN0M3VZNmVJSUNyblZyMW5qLzV6aEVu?=
 =?utf-8?Q?FwMCc00OsFecxxt8GtBBEu2dY?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: kuka.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU0PR01MB10385.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eedd101e-88b1-462c-1e53-08ddd5c9f642
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2025 15:49:15.2716
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5a5c4bcf-d285-44af-8f19-ca72d454f6f7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wqc/qibKN4P4QsUY+Hs4fpKQvirCcRpblOLzePe+oIKvh3tE8yw7RgTgqDVf1acdepvmnHKgAIZ+AnVsR/EQPIuAH7rpS/IztF9JT9hONx8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR01MB7639
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DDE8E140005
X-Stat-Signature: cyzm8c7zny7obxz5qoegtsizzpt4sa81
X-Rspam-User: 
X-HE-Tag: 1754581758-985194
X-HE-Meta: U2FsdGVkX18IZLH5dpCvfNRGyGXlA3vyrdPLOyO//dOZ6nFv+LHVe8a9tRSa3sJhRR34iclUi6Zv3Iu7YWXxMJocKsgtjmqMpgZPRmbHKSqybEzctdH9t0lfjIrh58/D32ovJ1txlpVeXRMM5c0Qi50gDUjS1Jfd5Df49Xnk3UiYTx3M0RMwiVBWpggFMld9kY6MT1PwL754yVGamvSpPs32Ts3eWU6gLP3+L2HgXqJCs7ccaGwWGdK8frW7f0O6Il5IZuCzJtufXw8kXHgBOg7qqZfKYbu2/c2GPgc4OFNiqtuzfa0FXNkj0hGxknnZbZMQigbkvWqFdDvNUhu06LCh/G99UqaVxMJztAkXknIT1nCn5EZG6tbvChvkN+Ktjpl7uwhVkhojgqEPWE5EBi8BejLtgln9cT/6vNVLJlOqLvmfYiQGc4m6zVHVmuRJ8ipkYp+IWSVflTyse+9gtiqoi1468eQ922xfWVk2rLU7jm8Zad4TlTt/4Q4QEHP8aAtLBEZsDQnS+pyaUZsbKXmfZTz9YP6PLMJupKxPxPcHJwn2a998x5spzqAh6yOaE5bSuHZrynEiK9lktuZR7ZJ838Yh3H6qvs/9lFPLMJG5CgOOw1fy+CZzyBFsupxKTf9hHT3hAnC1jzINaCQUgYYyBJ6oX09fmplbJ6r96wfnFOtliuagS/Q3B2PgKcBkSGYCxqUQEtMJl38xAolP8GwkDxz3zdaiZHI/yFNwfc5bOIJzKHJHYpoxR1zSbw3KgKE/f2solY2JerPOR4DN2rc0yQhEANXb7Fzoqg29LpWTVKryhdPU8Vj+JAr+SBx6Wqr6G8rGvlZYAEVmK5SErAlQmyL09HuEDUoaRJkuT9PU19zkSXIIDtxXTLxIMwcZQ4J9k7VVnHqK+OvU4bxs4VtBvvETfCqtxLzYe4wzUYdT0WIPOcCMN9mrmNbf+vTviRqwUTsOhxAn70IfKPG
 +FGA4c7t
 KEQpCjeUFRUfxVtZMh5hMdVnrnSDIDjk+dUA/uNEpquSdm4plCkL5s5X9WMeOKSAAuq+w4jDhukx3lJkdk0x9HiJHFivw42sAkgdR+6P+Xz21LrK+bMTiUu4SZnxyzF2bwBA9bEBkAOhzSvOSh/3NtF9qGkhjs8nz3pZIwbU7hTsPedV+7Ls0bgIFS08+/GUpilFsdg+LSKf86r6ff462ORo1bHaZotFQCdXKJKFCjdhAoPoKo5YVmgB2GusYlO/hm+ZpRuC/cd7+UmcuENjFA2kH1i9sqjmy36VmotD9aPIVoJ29NM++4FZ9XGBqOxRLItvk41+RmXXNOZhu2GSuxg+lguNJpDiwgwFi4kjVLgtb20irtrbgmhWL0VBK+ngffAoMHleOVl2w8aQdJonW/mOZy0Yjyl2SpVMqhWgWF7lQwmJ5iRGKF+M+lqd/fcsrx6ScrMFba+FLiJk+TOlN+jqCMEy8mGU2Dm3pdBZDB+aglE1nqkmOrQU1Pd1tVG2KbRFUDTjDsiy4UEK7X95nimrV6S3bMc91kAAusuWscjIRgmYIMyL9cmgyuFv9kzdtcaI9N+L1lJS7NLSWnQFctcDZCMK4RbxVsjMAzuZ85FoJEA317C/zGXpd5RI7dlMlGgC1UC4NQkcvGmJjKGRlcANBaEATMQKi4mMp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000015, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gVGh1LCA3IEF1ZyAyMDI1IDE0OjIxLCBIdWdoIERpY2tpbnMgd3JvdGU6DQo+IEJ1dCBhbm90
aGVyIGlkZWEgaGFzIGp1c3QgdGhpcyBtb21lbnQgb2NjdXJyZWQgdG8gbWU6IGFub24gVEhQIHNw
bGl0dGluZw0KPiBpcyBhbm90aGVyIHVzZXIgb2YgbWlncmF0aW9uIGVudHJpZXMuICBJcyBpdCBw
b3NzaWJsZSB0aGF0IGtjb21wYWN0ZCBpcw0KPiBub3QgYWN0dWFsbHkgdGhlIGNhdXNlIG9mIEFs
ZXhhbmRlcidzIGlzc3VlLCBidXQgdGhhdCBoaXMgUlQgdGFza3MgaGF2ZQ0KPiAoYmFkIG5ld3Mh
IHNob3VsZG4ndCBiZSBhbGxvd2VkKSBnb3QgYW5vbiBUSFBzIGluIHRoZW0/DQoNCk5vLCB3ZSBk
b24ndCBoYXZlIHRyYW5zcGFyZW50IGh1Z2VwYWdlcyBlbmFibGVkLg0KKEZyb20gS2NvbmZpZywg
dGhpcyBzZWVtcyBub3QgZXZlbiBwb3NzaWJsZSB0b2dldGhlciB3aXRoIFBSRUVNUFRfUlQuKQ0K
DQpGcm9tIGZ0cmFjZSBldmVudHMgKGZpcnN0IG1lc3NhZ2UgaW4gdGhpcyB0aHJlYWQpLCB3ZSBr
bm93IHRoYXQga2NvbXBhY3RkMA0KZmluYWxseSB3YWtlcyBvdXIgcmVhbHRpbWUgdGhyZWFkKHMp
Lg0KDQpHaXZlbiB0aGUgaW5mb3JtYXRpb24gSSBnb3QgZnJvbSBoZXJlLCB0aGUgY29tbWVudCBv
biB0aGUgY29kZSBbMV0NCmFuZCBhbiBvbGRlciBjb21taXQgbWVzc2FnZSBbMl0sIEkgc3VzcGVj
dCBDTUEgc29tZWhvdyBpbmZsdWVuY2VzIG91ciBwcm9ibGVtLg0KDQpJZiB0aGVyZSBpcyBhbnl0
aGluZyB3ZSBzaG91bGQgZW5hYmxlIGZvciBiZXR0ZXIgZGlhZ25vc2lzIChlLmcuIG1vcmUgZnRy
YWNlIGV2ZW50cyksDQp3ZSB3b3VsZCBiZSB3aWxsaW5nIHRvIHRyeSB0aGF0IG91dC4NCg0KWzFd
IGh0dHBzOi8vZWxpeGlyLmJvb3RsaW4uY29tL2xpbnV4L3Y2LjE2L3NvdXJjZS9tbS9jb21wYWN0
aW9uLmMjTDExMzYNClsyXSBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2Vy
bmVsL2dpdC9zdGFibGUvbGludXguZ2l0L2NvbW1pdC8/aWQ9ZTQ2YTI4NzkwZTU5NGMwODc2ZDFh
ODQyNzA5MjZhYmY3NTQ2MGY2MQ0KDQpUaGFua3MsDQpBbGV4YW5kZXINCg0KLS0NCktVS0EgRGV1
dHNjaGxhbmQgR21iSCAgIEJvYXJkIG9mIERpcmVjdG9yczogTWljaGFlbCBKw7xyZ2VucyAoQ2hh
aXJtYW4pLCBEaXJrIEJ1c2NoLCBKb2hhbiBOYXRlbiwgSHVpIFpoYW5nICAgUmVnaXN0ZXJlZCBP
ZmZpY2U6IEF1Z3NidXJnIEhSQiAxNDkxNA0KDQpUaGlzIGUtbWFpbCBtYXkgY29udGFpbiBjb25m
aWRlbnRpYWwgYW5kL29yIHByaXZpbGVnZWQgaW5mb3JtYXRpb24uIElmIHlvdSBhcmUgbm90IHRo
ZSBpbnRlbmRlZCByZWNpcGllbnQgKG9yIGhhdmUgcmVjZWl2ZWQgdGhpcyBlLW1haWwgaW4gZXJy
b3IpIHBsZWFzZSBub3RpZnkgdGhlIHNlbmRlciBpbW1lZGlhdGVseSBhbmQgZGVzdHJveSB0aGlz
IGUtbWFpbC4gQW55IHVuYXV0aG9yaXplZCBjb3B5aW5nLCBkaXNjbG9zdXJlIG9yIGRpc3RyaWJ1
dGlvbiBvZiBjb250ZW50cyBvZiB0aGlzIGUtbWFpbCBpcyBzdHJpY3RseSBmb3JiaWRkZW4uDQoN
ClBsZWFzZSBjb25zaWRlciB0aGUgZW52aXJvbm1lbnQgYmVmb3JlIHByaW50aW5nIHRoaXMgZS1t
YWlsLg0K

