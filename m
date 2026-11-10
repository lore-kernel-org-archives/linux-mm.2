Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B636606A325
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 18:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wisc.edu header.i=@wisc.edu header.a=rsa-sha256 header.s=pps1 header.b=AapnsIdo;
	dkim=pass (2048-bit key, unprotected) header.d=wisc.edu header.i=@wisc.edu header.a=rsa-sha256 header.s=selector1 header.b=P7/nizPc
Received: by kanga.kvack.org (Postfix)
	id C13AD6B05CC; Tue, 10 Nov 2026 13:03:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC4A56B05CD; Tue, 10 Nov 2026 13:03:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A64706B05CE; Tue, 10 Nov 2026 13:03:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7717B6B05CC
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:03:39 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4FB9A1A0A68
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:03:38 +0000 (UTC)
X-FDA: 85419982116.08.B675FE9
Received: from mx0b-007b0c01.pphosted.com (mx0b-007b0c01.pphosted.com [205.220.177.71])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5F6C1C000A
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:03:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=wisc.edu header.s=pps1 header.b=AapnsIdo;
	dkim=pass header.d=wisc.edu header.s=selector1 header.b="P7/nizPc";
	spf=pass (imf10.hostedemail.com: domain of san55@wisc.edu designates 205.220.177.71 as permitted sender) smtp.mailfrom=san55@wisc.edu;
	dmarc=pass (policy=quarantine) header.from=wisc.edu;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794333814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7FbfkItq11n51ET1OuYu/xx8+5FaUacErpErayZ3fcI=;
	b=jzJNSd7dL+S3LLO9p3CCQKTbn7j/wjyHaGiJVd/U0DaipsZTdBFAleS1qO0647KU7tvevV
	+SEQvqoMnD4A0yAuI56WlcDnTvxR1q55ne/MyGDDu8hyLdgHM6EozpSnrkmw81h7l7Mp8o
	Fxtg9z6lk3NFbtXfTvLZtZ9NyrVJdAE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794333814;
	b=qGoB1MgckkTeHP2Bo8dR07T0lgVHelW4ip98GnxnxyA/q2n+/j4/YGQauOvIa2plvcIo+A
	roXXDW/AEuCalLE+6sPOH6c+S0Yvt0JgebJLtNGqdWqnic2ayxUpjgq7rGKKZgxnGTP0eS
	vOtfYjLvDCGs5w5VLAeRRYM/yAkACzE=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=wisc.edu header.s=pps1 header.b=AapnsIdo;
	dkim=pass header.d=wisc.edu header.s=selector1 header.b="P7/nizPc";
	spf=pass (imf10.hostedemail.com: domain of san55@wisc.edu designates 205.220.177.71 as permitted sender) smtp.mailfrom=san55@wisc.edu;
	dmarc=pass (policy=quarantine) header.from=wisc.edu;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0316046.ppops.net [127.0.0.1])
	by mx0b-007b0c01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AAEvUxY1310624;
	Tue, 10 Nov 2026 12:03:21 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wisc.edu; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps1; bh=7Fbfk
	Itq11n51ET1OuYu/xx8+5FaUacErpErayZ3fcI=; b=AapnsIdovFuIyl6dEFEGB
	+BkpyRBlcJ6BIHiRvaC4/yTFeeyGTKgZ5JcKV91Yf9i+u++Gxx+4XT87/TiYc4RA
	0RqrTGYOrH1IvtqLjzYB5GF7qfHIjeHEsXsQkGRNE73JozAMSDTVMHPyNZsqo4/T
	8W/4LoI3vi7OkSSBZJcVb9y+0D09S4l2ZM1amiqhGAfXSHg0TWWfCpwiRZ5pMmWt
	jDCPeclaqFcRGJVgXPqlWKMjCFsMeDXgEEP6cu3UsiqGaw6GYga9nVdShVSj/adY
	StPves8eC74U0CGg5KHBO7awcSQawRqMYj5OLhCTGoHPNLC2RiqivZtpppMBhfRe
	A==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011050.outbound.protection.outlook.com [40.93.194.50])
	by mx0b-007b0c01.pphosted.com (PPS) with ESMTPS id 4hv4r7jejm-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 10 Nov 2026 12:03:21 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XHZEJqk7HVPXw8bsJUmmK0zZKR9bMf/y8n938j2eTOOhEUrCG5IfO2GgqdOmNvH6TgKyX0QYRCj4zUeuLgWW+QXJiFmqF/ERLkUGflXT7sOtlgtbArdjkuaJP3ewu6v9xY8RkFcC1pfbgsG2H/7Taw5T8e/u+rIMMclFtjX0IzdvL9SWaPLzB9hq8lMmoVEY0DcqScHjH0fJe3DuITAC6SQlTVazmaVhg28OiOyfvCg5CT/qE2uQGRSJrX8e2QFMk8cXE2yC5NwTBEmrnz4msivBTCPlPrFpcOTGSSe8yNfy8Kegti96Mkq44JDiSvVZ8QK1f0R7OlkBloIay0G5sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7FbfkItq11n51ET1OuYu/xx8+5FaUacErpErayZ3fcI=;
 b=OJ0W3UmgW+QxxZTurlMw2MHmpjTt7jVVX6/Pvies0B14dq8Zj5c5EIn8d2M2kev3WGL/F3bdz3N0g7fgdOu9rjdLyCiagrnITDCSuWrRP+76n4vkbJEoe1pFdXJ7Lz19PHacqDQNp5iOiEX6PJ850OyqvnHyb+9KIYYoxv+7Xd9ByL+4CRl+0NsAOCTSngADluT1kPb3z6dGBfM1rvMwmTa0HgCGYhDyi586CIv/gfFBZax/IsgSsVXjxwZkIDgDrJN86pkrzP4ZfY/a60jf+6jmEvvkqztITEc0xp60aiZj185IM4PCSlfkQ7OJg0ctivFYINK8pxwPKXzosc6jmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wisc.edu; dmarc=pass action=none header.from=wisc.edu;
 dkim=pass header.d=wisc.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wisc.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7FbfkItq11n51ET1OuYu/xx8+5FaUacErpErayZ3fcI=;
 b=P7/nizPcaeEUyzoBhR+zhUCfqGOFlDupX9luaPTRLjXJBEzA+AxASAKKmnpYdkFw7lCsf7VOJv1KgRP+O9z0d9hpbcjU88xI3SXp30cWKZb5kLljZNEifO5hLV3UPP+oTCmKogCFWIExV3ygi5Y/tMkgx3e17XX6GwRHmIJI+t9Ub+xHheJHSQA74shNUwu90q0Y+YilN0yl4Rh3Zl8I7Q0iqwsBMK87vstyavqyvI2RMJHiSKY7xxGVJMz8URo+T9ytgZS1lE4pTmoqFJGkjg0wrZZ+auEROxlLOpd1xoQZsCZT67dDIzNC4LxSQ8ZfhU+ZO0oE3KcgXmGc0PpdAQ==
Received: from MN2PR06MB6639.namprd06.prod.outlook.com (2603:10b6:208:20a::22)
 by SJ0PR06MB7359.namprd06.prod.outlook.com (2603:10b6:a03:32f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 18:03:18 +0000
Received: from MN2PR06MB6639.namprd06.prod.outlook.com
 ([fe80::c7c1:6e17:5f9d:1245]) by MN2PR06MB6639.namprd06.prod.outlook.com
 ([fe80::c7c1:6e17:5f9d:1245%4]) with mapi id 15.21.0615.007; Tue, 10 Nov 2026
 18:03:17 +0000
From: Seunghyun An <san55@wisc.edu>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Suren Baghdasaryan
	<surenb@google.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka
	<vbabka@kernel.org>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn
	<jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Lance Yang
	<lance.yang@linux.dev>,
        "David Hildenbrand (Arm)" <david@kernel.org>,
        "Kiryl
 Shutsemau (Meta)" <kas@kernel.org>,
        "linux-mm@kvack.org"
	<linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] mm/vma: predicate vma_assert_stabilised() on
 CONFIG_DEBUG_VM
Thread-Topic: [PATCH] mm/vma: predicate vma_assert_stabilised() on
 CONFIG_DEBUG_VM
Thread-Index: AQHdcSWzotCHaF9rK02pQ1Q2O6oOobcnkJA6gAABcoCAAAc5kg==
Date: Tue, 10 Nov 2026 18:03:17 +0000
Message-ID:
 <MN2PR06MB6639F6E25313545636DC89CCD2722@MN2PR06MB6639.namprd06.prod.outlook.com>
References: <20261110-vma-fixup-debug-asserts-v1-1-0b2e0680cd7e@kernel.org>
 <MN2PR06MB6639D846B30A3357B01BC61DD2722@MN2PR06MB6639.namprd06.prod.outlook.com>
 <avNVoCWBhVQea7Vq@gremlin>
In-Reply-To: <avNVoCWBhVQea7Vq@gremlin>
Accept-Language: en-US, ko-KR
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR06MB6639:EE_|SJ0PR06MB7359:EE_
x-ms-office365-filtering-correlation-id: 13e9df42-91e6-4cd3-96fc-08df3f54e5ed
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|23010399003|376014|7416014|366016|786006|10067099003|3023799007|261028144727099003|261102123227099003|261026140227099003|261026121527099003|261021135927099003|261022105027099003|261021121427099003|11063799006|38070700021|4143699003|56012099006|22082099003|18002099003;
x-microsoft-antispam-message-info:
 h5SARs27u+PKOrVBWnk+9ZsX1zj4iAXC4Z6L3G8GDmqEiSnYwWs7kKG+PddUAeK3D/CgF2bxlswCo3SONRBGetZaeraS1CrakcHwegSYQsUPxoC5gPzbJdA5FqySFBUrbPgAca1xao1alAGykIhnRox7Wz8STgUByr/2b5moROsSJPcA47bTOPtHPM0yZ0Ch/wMnl7Tvdm2Y9O9a02inV+s9GzorN0jCSok+URBsPQsAElG2eFECf9iWB93rc7KU03Mh78Xkb6eLquoJ0vqNO7GUAjTE3d79T8twXHsZ/sV2NvQmLaeD1wo2yVIPioB64xikcdShOEdCFHJsuQ+dD4au/UWh+jOUIehEAoDuWOLgc6+HAvdS+8NTnMrHNa7kd+ZhoSiPjbRI5Fj/h/wC9nWO7n4VWA71hqKBrMaMkLIdg27CTwsVkWuYtkLWFa5PKG4y9xoV8soU2ZiZtNMOXmVGfwfIgpsD8XnQF4eYedPCCuPEr+Crj9x4dNVW8l8BbEgBApx/FW4uKj7DMyLlC2R9YEsrZD/U9bW+9b+pPc5OQ9ydPL8pDVbPEkOeLrw56nIC94pkEvYIUdzqEzMFWcvFTeM7cFmv/vr3lqLCuwVRfksgvrv0h2beTcaA4aXub1zeP6ZBeNs2SKklA1aCn5erMlb5TxS0ajTDxP8tm9YVu0fhsRbqE3ZBsezVGDSGqbNGtL5YJ8D9pX59SyrlhN2Xy5c8ENE9ZOhUlhNZ2vA=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR06MB6639.namprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(7416014)(366016)(786006)(10067099003)(3023799007)(261028144727099003)(261102123227099003)(261026140227099003)(261026121527099003)(261021135927099003)(261022105027099003)(261021121427099003)(11063799006)(38070700021)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?K+E7DoyeT9TjksyffmYmgCstScjzfVpORwSEaW0iM7YdkI+nfzU4VA5KeNs1?=
 =?us-ascii?Q?8aNm86phvsdk0KjTYxEL0y6ZBcqKOA0eSsvpqHPqu5MaWE1ck8rsNRtkYFpv?=
 =?us-ascii?Q?e8CigK+WJE71fQOvTJJHl9JCfUM4UqHdTjzQzrV3xmmeloUUSfB1/OJZ2UIC?=
 =?us-ascii?Q?+tsPrIvW+WLTQe+j6bu2hx0Z4GBppa6nmxDR04fg2H+5GQQZs84GC6/vNuUo?=
 =?us-ascii?Q?aOnl9uPVsir/AmRabFXHevyLosx9JSCqd8lSSfybHJVgZUPARXotOtjVXUvi?=
 =?us-ascii?Q?RlWXZT0Wu/VIcBN2nzwegHXPF6SuHixhxDiMlidCDCvCpSf1QN/R1tOW0vUr?=
 =?us-ascii?Q?j6x+N9Hf+cBf0EnWYRHlAd22ispznRyhxZ3PyYaXtwstU6foIT/RAh/MyjsZ?=
 =?us-ascii?Q?9td1h/LX9789UaMl4o/FuzLGf9yBaanb3UShgbIvz5mTUTO8D6/6s1WFJGqu?=
 =?us-ascii?Q?A3rMcrzg1U5wk8DOeNYGaLvFxAESwbFv7q+M95TaieJlIWXXnOPWsHIXm40+?=
 =?us-ascii?Q?Ccq/YjDOYdOgyE4DTK7SG2GOLL8nB+kdsxIgkR8U/tU85lCmPA3s4mFHrAoU?=
 =?us-ascii?Q?zIIn6dNo8gH8jMHYkCbXHwHZAe5QQAi8i6MxEQx4EerItE8b6hNAQhf3YMDT?=
 =?us-ascii?Q?9x5zc17IuRNwSLYvT5Dk+R8V0DFteDnnG97Sb13M2kcoi+cdpo767tJE9LlU?=
 =?us-ascii?Q?wopGgiiAbJiUscrxrGYbNfEKcaNjUAgJhPOsXQnyJVta70P6Khc1IzBuIKyV?=
 =?us-ascii?Q?f8DtJI34uKryNlKNakhXd9X2lv16P235BA7co925PsVN5Tm1YER/jxWTVZlg?=
 =?us-ascii?Q?R8Ty9Oe33s812FS93XybYcafDj7aOLidADB1AytqmHbY8ApZ7ctKT/zL7Ixa?=
 =?us-ascii?Q?o8bbmnZ00HBndaDUZBPyK8dxB6iBXJea+WzcBMPu8V/2Osaml2jG/hIG156g?=
 =?us-ascii?Q?7YklEohlT1ymonnQrMQiFAUdtbxzhM0hetSl7ZpGUE3hh9wLphjDKVHY2FqI?=
 =?us-ascii?Q?U5qTSX8lV8CzBjknCC8RFl4rN/iJSnlZ+XmMOXPk/lhDkkEfA+aLUs1EYUi4?=
 =?us-ascii?Q?2a8JwZ8a0WANkPrU/Ucabgvot9C5cQjxeqWptE/PF0pveQN3IVCE4z0ONw2A?=
 =?us-ascii?Q?yuo5F6lF8WOR2r4+Gfebh+RWAd6ZfmIS+4Ez3A9Lpq5/NEc8Yi+/EkjC8S3A?=
 =?us-ascii?Q?IevjWIItLX9MRTgwzfwvso/SV/B0Sjv9F3bNBJ+lB9Af6RBfcV1IZ3HnQXdB?=
 =?us-ascii?Q?jpP4VpGFCniKWU4W+YPl+FAE+lIHlcEqlxC2/ndMcsBfMwuB645zSSOdyMCt?=
 =?us-ascii?Q?dUgP2yRbOvmygFHvA9i1Cim44LL/jVa8/n5Nx2YQlKy406XrV63l7KEIJ9/Z?=
 =?us-ascii?Q?mljaEshCrstHwIIRdxJynBFIHBOkiW09F7ePm4PZqTAGcIBkiEiHJTDvskgX?=
 =?us-ascii?Q?JhA7U/OLeBYP9F1fGeXKUdjz8Ajm5W26tvva74DczR+pug0+/035PtXZnc6k?=
 =?us-ascii?Q?fFmy6/Yz3ZlhNTXNvRgA42WTjrVEP50C0mHuPWBzcRoPGBqRNDacsJQDEf2z?=
 =?us-ascii?Q?qcMHwH/0yqbRvTf9r+vOAIvBcWO1YAZjgwkk8OsbJFsBqLXA0YdgWcTioAz2?=
 =?us-ascii?Q?GBY8U1qOkfCdNso87L3dEiyOUn7zvtUTYRHq0aZFh1VXT4x7EJfKmbQDP5u+?=
 =?us-ascii?Q?hlkZ4sg4rhHKESbD0amQ+gM0yH4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	aizExropP3m6EV+CAUsQEhJxOKDk1do6NaaOjFhG0rc9jU9L/gedeSDz/q3nfiZUPglUtc7tsEu9JZ10rvY6mjrXTp5qK/AxYpYrkG95lHMpmkGo1dRZJwWXYWHDIXoTGExCucliBJFNlzzIsGa4eLxxgVuqYtF0NymDu7c4f0Ztv+m8GoYnhErYUsOfgYkY6oiD37Fkopta9PVpF5uyDH8211SNCa5IygflpfOJOBIkCgjZmxPW1dStvzfnUX6q42e+ylTUXC9fwW3whqXa8cxL9GviJe7ywXTVU/yKoqXovdgHuSaYQPs54yLhSn+DxfX1qXYGUfM+weJyuFxFaw==
X-OriginatorOrg: wisc.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR06MB6639.namprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13e9df42-91e6-4cd3-96fc-08df3f54e5ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2026 18:03:17.6958
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 2ca68321-0eda-4908-88b2-424a8cb4b0f9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XBE22JVKM9NyL/NNE24KkQJvm+U5WOYswiNVO6uYt5FLZizFxLbUwe+LNVxIUR1q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR06MB7359
X-Proofpoint-ORIG-GUID: jICXPAX9SWKX7FmrRW8xYM2GFQwaZOxw
X-Authority-Analysis: v=2.4 cv=C9p8WgP+ c=1 sm=1 tr=0 ts=6af35c69 cx=c_pps
 a=UNZgSj2+zgRPHH//f1mBVA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=U-hppK1rdbEA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=ZyELlZqCvD1aXIDzc3I-:22 a=XiWqTFSM81oo9FNMAQdw:22
 a=NEAV23lmAAAA:8 a=3KRBmGZhLxgMu0xwNAAA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEwMDA3MSBTYWx0ZWRfXzeF0cQDk96Eq
 w+L0Q1oPQr/s0ZV9fOYSObbDlyZng6HQpQxF+A23dmu3pksMCja0mKPepGE+2oxXyj7wFl6cvjY
 VqU1wmagxMD8DCBBwwnFyQY0ZLnJMGs=
X-Proofpoint-GUID: jICXPAX9SWKX7FmrRW8xYM2GFQwaZOxw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEwMDA3MSBTYWx0ZWRfX/BEcS6a+E1if
 1qMsxqkL9NoaHAH4SmEv4GGTXS+BYAgfytowEeyqSLKkKWVu19Yc6EKx1Ql30JUg7A01aQaxQW0
 qLXs78DAwPzYjq53UfjZq00IiGxypwXDlAZx8UPocAKqdYy/vgaUlIB1/jyEd6ItSmwh4Imbgb7
 t6VLArd1AATCjx2w+GPNQuracR05qo8s5zRbh7uJdsSLdcXUeCjx63gWRtg0U//k9c5VmIC+USr
 vs1gdLBgKWxPvgVU21PIDjcbVbmd+mXXGhAEFgLv5Bi8y2Ia3vsEX00dZ62NKgXRF2ksZDhra/H
 eNOeMS6jU7SmEj1ukDs5PIZX9gfcWU/xBKPyJAwqHEe/MJdCGxodo2YrJU+rGVGPwHEIyuSiV0y
 LmkG7hHjs0fCYBeneDhJAeNNG+T5fWsc//ZGUR1AQZD54ZRwN0BNoMSomL9Hj8vl/aT4Y+IL26P
 2uZP1S5eI0JRnkQbPcw==
X-Wisc_ValidFrom: true
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-10_05,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 impostorscore=0 spamscore=0 adultscore=0 phishscore=0 bulkscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611100071
X-Rspamd-Server: rspam06
X-Stat-Signature: wpumouknmniodawbgdrja65utjj5q7g3
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5F6C1C000A
X-Rspam-User: 
X-HE-Tag: 1794333814-200984
X-HE-Meta: U2FsdGVkX19KakIaDXqtbADQve/gfL7fuwdD0mse31z2rGOuM9wtfzp9XHUWBcSo/3qBXY133Ku7IANv7V9ffTZgsMslzRZVSzmVt1fo8HSfARQhDtfCF5xRhJfvLUcEiKTAStQMNBhOnpToc88gOnq+IFhE8cd95WAa5FfXsTjGcBpjFuAl1vXXSVgevRG9zstog6e/9goKhWALX2P2d3BfUUNgVJCmQy2CMZPtvFntPWqFOHnoCJY0K97sW3VwoiCtmXJdAJ/OssV2tnqkF6mIoPWPkVFXME3ooJUx8e3BLeaVgn+dFSAaeqNKetXpNtSqOFqpyxGZv3oaIa6f9Ubtvw1AdDIetHt1mVC+TMrp0jozXn0fgjwErARAVjBRVPCU2OKfPfrWLs0Nn7GLa6GGrupBbiBosj4s/gGhO886p0ZBDRdS1B3cT3ecz+BC9HTy87mf5u5ezWugCcV5KklGeP9G0P8SAVYlM1jAP9C5Ex7W2R86rPevspCCLrbirUtgt+rpNTJfne/Y8US4GsrhHZFQoXcX9Fx0RLTM0jywkbyLObdrBmIrvU3IWb4pksFHUOah7LB19GqpfUX8aiL861SGvWy0E9TeYtWIivDTo80duleq7d39dfm5GFNPn2oGeYOzLIzEEfGyUecnlvEZEGE65YsgcTqnC/1dzoHFEPn1WYCSfQh7KkPAaWRoUNXZXgf6tDIn/bTJ+vTByytzXDaRyo5sU84/+hqv18yfjAfk2x+UkBa6f0wZxzM0RpdLojaEbsQIQEJ8O/XfujC6VKL1c48JJZwadTIpzbLNWjvUKsr0jjTKPICvOMPO1WYTjwXIE32MLnwXC8Nyksx+KIKcfvBANpk/C01/9lQK5yltK34DY0Qn1ZH67SFx6hnIKmJB3SnVxoDYcGF8qKdD5On6kcM1VaJDoF3OiMc6fmEBSUOU+wxRWoF5cjxD0Y/KEx04EHrMb31dSJI
 O17X7450
 aXwK6iKeK8Xs2JaGHEBvg8LfgvqoTngKT+U2ji3LFpmFwqae8ItV+JekXY0xfSObEARI2Hcf/SGst+TnNSXAGrpPIiyLnzjct7EwznxOP/sHuaEL+trmEsv08WLveJWC8nFqATe5642XrSlq3bOl61/p2h2CLi0tPw4lholu/ZUOvmW4COMJba3v+r0SDl5inStS1bTmdQcfDNFk+XElR8NK+4U0/l7r1wqwaGVkUL4XXO73th5YGtXO83Rr548LLxOfEloBnHzdV2/JwALnCziFa0cUO1eMydafSlZhNIOW2GW28zoqV/gQGsORJsp0plS9q8cViLiseuXw6UlyB5wp0/a8gWf5xcySdBiG+hZT7KDZd6QfP8g2mI4GHM7+ilNBxGrWYdJex5Y4tmlZYzGZqC46SFgPC4C+V8eBCsvHKCDwjxA3rLY9INJugR4N+xvsiXzy068qhgYsSjezmBAR0GkkWa119Ohj63lqQj9MdMjRkWI0ff4GZYpvCSNextlSzRWzz1EXYHdAmnCLSq+vc1OKsclN4iHuG9S5YqXGwhqJesz3RDfWIc7rzrWtKTA4/GnR08ipN2Lj45D2zAhZfq+t/mEOzRbjSSW6fm4yibrg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026, Lorenzo Stoakes (ARM) wrote:=0A=
> I'm disinclined to do something like that patch, as it's rather a hack.=
=0A=
=0A=
I agree on this point. I used it here as a probe to measure the =0A=
cost of that read.=0A=
=0A=
> Cna you give me the workload you're actually exercising here? Ideally=0A=
> something that's easy for me to run + analyse locally.=0A=
=0A=
Sure. The "shared-VMA faults" numbers come from a small test that boils=0A=
down to the program below: one anonymous mapping (a single VMA), one=0A=
thread per CPU given on the command line, each thread writing one byte=0A=
per page of its own 128M slice and then MADV_DONTNEED'ing the slice, in=0A=
a loop.=0A=
=0A=
On your Zen 5 I'd compare one thread per CCD (8 threads, one CPU from=0A=
each L3 domain) against 8 threads in a single CCD. perf c2c record on =0A=
the cross-CCD run should show the vm_refcnt line and the loads on it.=0A=
=0A=
For pft, e.g. on the 9634 (7 cores per CCD), one CPU per CCD:=0A=
=0A=
  taskset -c 4,11,18,25,32,39,46,53,60,67,74,81 ./pft -a -m 48G -t 12=0A=
=0A=
(shared_vma_faults takes the same CPUs as arguments). This pft revision=0A=
does not enumerate sparse CPU masks correctly, so I used this fix=0A=
(against b5cfe1b in https://github.com/gormanm/pft):=0A=
=0A=
diff --git a/pft.c b/pft.c=0A=
--- a/pft.c=0A=
+++ b/pft.c=0A=
@@ -317,11 +317,11 @@ cpus_allowed_init(void)=0A=
 	 * Populate cpus_allowed[] dense array.=0A=
 	 */=0A=
 	nr_cpus_allowed =3D 0;=0A=
-	cpus_allowed =3D calloc(sizeof(int), max_cpus_allowed);=0A=
+	cpus_allowed =3D calloc(sizeof(int), numa_num_possible_cpus());=0A=
 	if (!cpus_allowed)=0A=
 		perrorx("Can't allocate cpus_allowed array");=0A=
 =0A=
-	for (i=3D0; i < max_cpus_allowed; ++i) {=0A=
+	for (i=3D0; i < numa_num_possible_cpus(); ++i) {=0A=
 		if (cpu_allowed(i)) {=0A=
 			max_cpu_allowed =3D i;=0A=
 			cpus_allowed[nr_cpus_allowed++] =3D i;=0A=
=0A=
--- shared_vma_faults.c ---=0A=
// Threads fault disjoint slices of ONE anonymous VMA concurrently.=0A=
// Thread i is pinned to the i-th CPU given and loops: write one byte per=
=0A=
// 4K page of its slice, then MADV_DONTNEED the slice. THP is disabled on=
=0A=
// the mapping, so every write to a fresh page is one 4K fault.=0A=
// Prints faults/s.=0A=
//=0A=
// Build: gcc -O2 -pthread -o shared_vma_faults shared_vma_faults.c=0A=
// Run:   ./shared_vma_faults <seconds> <cpu> [<cpu> ...]=0A=
#define _GNU_SOURCE=0A=
#include <pthread.h>=0A=
#include <sched.h>=0A=
#include <stdatomic.h>=0A=
#include <stdio.h>=0A=
#include <stdlib.h>=0A=
#include <string.h>=0A=
#include <sys/mman.h>=0A=
#include <time.h>=0A=
#include <unistd.h>=0A=
=0A=
#define SLICE (128UL << 20)	/* per-thread slice */=0A=
#define MAXT 512=0A=
=0A=
static char *base;=0A=
static long pgsz;=0A=
static atomic_int go, stop;=0A=
static pthread_barrier_t ready;=0A=
static unsigned long faults[MAXT];=0A=
=0A=
struct arg { int idx, cpu, nthreads; };=0A=
=0A=
static void *worker(void *p)=0A=
{=0A=
	struct arg *a =3D p;=0A=
	cpu_set_t set;=0A=
	char *s =3D base + (unsigned long)a->idx * SLICE;=0A=
	/* stagger the first pass so threads do not fault and zap in lockstep */=
=0A=
	unsigned long off =3D SLICE / pgsz * a->idx / a->nthreads * pgsz;=0A=
	unsigned long n =3D 0;=0A=
	int err;=0A=
=0A=
	CPU_ZERO(&set);=0A=
	CPU_SET(a->cpu, &set);=0A=
	err =3D pthread_setaffinity_np(pthread_self(), sizeof(set), &set);=0A=
	if (err) {=0A=
		fprintf(stderr, "pthread_setaffinity_np(cpu %d): %s\n",=0A=
			a->cpu, strerror(err));=0A=
		exit(1);=0A=
	}=0A=
	pthread_barrier_wait(&ready);=0A=
	while (!atomic_load_explicit(&go, memory_order_acquire))=0A=
		;=0A=
	while (!atomic_load_explicit(&stop, memory_order_relaxed)) {=0A=
		for (; off < SLICE; off +=3D pgsz, n++)=0A=
			s[off] =3D 1;=0A=
		if (madvise(s, SLICE, MADV_DONTNEED)) {=0A=
			perror("madvise(MADV_DONTNEED)");=0A=
			exit(1);=0A=
		}=0A=
		off =3D 0;=0A=
	}=0A=
	faults[a->idx] =3D n;	/* all faults, including the last pass */=0A=
	return NULL;=0A=
}=0A=
=0A=
int main(int argc, char **argv)=0A=
{=0A=
	int nthreads =3D argc - 2, secs, err;=0A=
	pthread_t th[MAXT];=0A=
	struct arg args[MAXT];=0A=
	struct timespec t0, t1;=0A=
	unsigned long total =3D 0;=0A=
=0A=
	if (argc < 3 || nthreads > MAXT) {=0A=
		fprintf(stderr, "usage: %s <seconds> <cpu> [<cpu> ...]\n",=0A=
			argv[0]);=0A=
		return 2;=0A=
	}=0A=
	secs =3D atoi(argv[1]);=0A=
	if (secs <=3D 0) {=0A=
		fprintf(stderr, "seconds must be > 0\n");=0A=
		return 2;=0A=
	}=0A=
	for (int i =3D 0; i < nthreads; i++) {=0A=
		int cpu =3D atoi(argv[i + 2]);=0A=
=0A=
		if (cpu < 0 || cpu >=3D CPU_SETSIZE) {=0A=
			fprintf(stderr, "bad cpu %s\n", argv[i + 2]);=0A=
			return 2;=0A=
		}=0A=
	}=0A=
	pgsz =3D sysconf(_SC_PAGESIZE);=0A=
	base =3D mmap(NULL, nthreads * SLICE, PROT_READ | PROT_WRITE,=0A=
		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);=0A=
	if (base =3D=3D MAP_FAILED) {=0A=
		perror("mmap");=0A=
		return 1;=0A=
	}=0A=
	if (madvise(base, nthreads * SLICE, MADV_NOHUGEPAGE)) {=0A=
		perror("madvise(MADV_NOHUGEPAGE)");=0A=
		return 1;=0A=
	}=0A=
	pthread_barrier_init(&ready, NULL, nthreads + 1);=0A=
	for (int i =3D 0; i < nthreads; i++) {=0A=
		args[i] =3D (struct arg){ .idx =3D i, .cpu =3D atoi(argv[i + 2]),=0A=
					.nthreads =3D nthreads };=0A=
		err =3D pthread_create(&th[i], NULL, worker, &args[i]);=0A=
		if (err) {=0A=
			fprintf(stderr, "pthread_create: %s\n", strerror(err));=0A=
			return 1;=0A=
		}=0A=
	}=0A=
	pthread_barrier_wait(&ready);	/* all workers pinned */=0A=
	clock_gettime(CLOCK_MONOTONIC, &t0);=0A=
	atomic_store_explicit(&go, 1, memory_order_release);=0A=
	sleep(secs);=0A=
	atomic_store(&stop, 1);=0A=
	for (int i =3D 0; i < nthreads; i++)=0A=
		pthread_join(th[i], NULL);=0A=
	clock_gettime(CLOCK_MONOTONIC, &t1);	/* includes the last pass */=0A=
	for (int i =3D 0; i < nthreads; i++)=0A=
		total +=3D faults[i];=0A=
	printf("%d threads: %.3f M faults/s\n", nthreads,=0A=
	       total / ((t1.tv_sec - t0.tv_sec) +=0A=
			(t1.tv_nsec - t0.tv_nsec) / 1e9) / 1e6);=0A=
	return 0;=0A=
}=0A=
=0A=
Thanks,=0A=
Seunghyun=

