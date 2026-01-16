Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30DF0C982DB
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 17:18:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76A016B0005; Fri, 16 Jan 2026 12:18:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 717116B0088; Fri, 16 Jan 2026 12:18:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A4216B0089; Fri, 16 Jan 2026 12:18:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 495C66B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 12:18:46 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1543BB6D06
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 17:18:46 +0000 (UTC)
X-FDA: 84338486652.19.3F50AFB
Received: from mx0a-0014ca01.pphosted.com (mx0a-0014ca01.pphosted.com [208.84.65.235])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3867E140008
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 17:18:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=cadence.com header.s=proofpoint header.b=cMqPTwfA;
	dkim=pass header.d=cadence.com header.s=selector2 header.b=sM4UMojZ;
	spf=pass (imf23.hostedemail.com: domain of williamt@cadence.com designates 208.84.65.235 as permitted sender) smtp.mailfrom=williamt@cadence.com;
	dmarc=pass (policy=reject) header.from=cadence.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768583921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=U6FkvIwdiQiRKiavtxVAJ4qK3Qm4epnGsDRdQ+/twIg=;
	b=syXFw2IUHKqya2dwU92DW3j6Wcoa16IUehq8xZHDgQrAZ+MBbCBE6+VOw4NkqtnCYx0rp/
	VSU9+4UH4fy57tLJAcfLYX3LpYXaCUJe2HFbeQQhGB5iWCDrxWbkMzSfFDtLRaJQb666gT
	XxhryD4hIJaNeoTPyED+QMnzGJUziI4=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=cadence.com header.s=proofpoint header.b=cMqPTwfA;
	dkim=pass header.d=cadence.com header.s=selector2 header.b=sM4UMojZ;
	spf=pass (imf23.hostedemail.com: domain of williamt@cadence.com designates 208.84.65.235 as permitted sender) smtp.mailfrom=williamt@cadence.com;
	dmarc=pass (policy=reject) header.from=cadence.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768583921; a=rsa-sha256;
	cv=pass;
	b=uHM2qBSpIff7oAFkbyafUKUTevvlxtc+lyVaS1m3TnAHjZr/teuvO4GNFIvUna+KaODKg9
	a7t5QxwC9P0pMVrndYXKa+Nc2Bdm2yoZZfnbaeFHkaqxBOivePQpMDOqm03MIpd7FeDsqI
	3sL8uttOmXV+W5Rpz6n/76bZb4hTl8o=
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
	by mx0a-0014ca01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60GDbFWC2089006;
	Fri, 16 Jan 2026 09:18:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint; bh=U6FkvIwdiQiRKiavtxVAJ
	4qK3Qm4epnGsDRdQ+/twIg=; b=cMqPTwfAa36HfDEuYOxLWDviQCIoHJDeYZQqN
	/kscjDBTAN+0LGBdPxDGHPd6pguGBz0dsPAA/CoRMH7U7foNGGNCwBnxS39La7Pr
	3vLyw2k8ArY04bhs82Z0Eq3PAfkZaNbUUscXOiY9XATC6QNEnR+xJfEyqFq4WemC
	Dq1ulF/9G9hcmx8V7jOXzPL8TPMcxcq1vqfiKBqxtGXRjOKawDtMrKGnfJaZQcWk
	w8wF7M7AXec02Bi7OWgJmwjagBC2Yx/9CriR9FsQPvfcgkbIKQDlQByI3Wceihw/
	QrrP3G8T9+1gEyHs/JPj0Rximect7/J5uhxS+wZz8sxvQJesA==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010026.outbound.protection.outlook.com [52.101.193.26])
	by mx0a-0014ca01.pphosted.com (PPS) with ESMTPS id 4bqpcd0tun-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Jan 2026 09:18:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WNu5dDi97ELzSqiKS1rEfEUFYMvd3RKYKofirvtcSPhDLNTLvMCPOZmPWq9lTmFIB49uNIf1AN7tHf7rq/WwL9QMJUN/Fc2AQQiEaMgEkqN3V5P86vBwMewcC/wytf5s7is0fW/3gYFdnPJKWkBV31w/r62Q1ZCSgd9jjVS7FlLbQtGzpO4l8IQAAbgY7/WHoDhxQg7s3YVn6b5KLxUxhOrRbGN32zTffPKFfUkNONVpDYYqXlJ7zRlMx9RYqvW3RVtfCthuk8upDC6BqgtIzuF51999il7Z4SsuYsjrkfxbF+ihVhD3c1HUv+3SRv81WkiCKrb5pStMGKWHJ1FlxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U6FkvIwdiQiRKiavtxVAJ4qK3Qm4epnGsDRdQ+/twIg=;
 b=oJwnOIFoLzTImvByYq4uEMROna9yrICm2rlBHQFlteWkCA41yrNIJz1AttzBRs2rPqZTs/xZwGuTrFKvjv7zYUQXHNAXrpygWR6jKQF7rA7zIHlF+Fch5ZlvTVDJJFOuQy7g+qvFWJahlIy4AaG4sPHCev5BSlJXSzDujqwZW8fUpmbCIElSIuZpCkwb4qbhWtmrfKYY/gckbuQ6XQ1nSnGiQSppJQrGRg/0Jgr6+4WjpElf8DffuoI4PG/qxChtz2K3OZelHRZW3IhmWrVR6y33lvpXPRTT7wPnXqk6gEo1JaCJc4ApjdfnDbqcHcj2YZhGvw+niTLVKJVaVWiaxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U6FkvIwdiQiRKiavtxVAJ4qK3Qm4epnGsDRdQ+/twIg=;
 b=sM4UMojZUxlCrIG3qSb7vm/Z0p7YlLbPsQay8cggd6t4bhAevjbXfVpn0cxBY0IhmdnAuGvoxnSqitxmHVPR9yDmHoZfhwyPpEJCZlauXHfpBRn6SU+SWIREjzw9JmdtmfokspYji5eajE++ZBdiZoKCPCn1GBzrM9DathRpOlM=
Received: from SJ0PR07MB8631.namprd07.prod.outlook.com (2603:10b6:a03:374::6)
 by DS0PR07MB9847.namprd07.prod.outlook.com (2603:10b6:8:15c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 17:18:22 +0000
Received: from SJ0PR07MB8631.namprd07.prod.outlook.com
 ([fe80::2d48:b901:24d5:579b]) by SJ0PR07MB8631.namprd07.prod.outlook.com
 ([fe80::2d48:b901:24d5:579b%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 17:18:21 +0000
From: William Tambe <williamt@cadence.com>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "jcmvbkbc@gmail.com" <jcmvbkbc@gmail.com>
Subject: [PATCH] mm/highmem: fix __kmap_to_page() build error
Thread-Topic: [PATCH] mm/highmem: fix __kmap_to_page() build error
Thread-Index: AdyHC1OkiPDohF22QQyH6dK7J5Ynrw==
Date: Fri, 16 Jan 2026 17:18:21 +0000
Message-ID:
 <SJ0PR07MB86317E00EC0C59DA60935FDCD18DA@SJ0PR07MB8631.namprd07.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR07MB8631:EE_|DS0PR07MB9847:EE_
x-ms-office365-filtering-correlation-id: d5112935-ac58-4a50-169b-08de55234005
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?DGmT80KnhR1z3KGKCTmWiPWWBwJSTVxauPcxb7Qk38MfgG5MHGgf5hcKaRWO?=
 =?us-ascii?Q?Po3fWpejRJgyhZ3R7oNNybVLIjQlNoRtYcW8X9GHnTMrUmithwvirpudNH0d?=
 =?us-ascii?Q?sE9giwUPLp9S+7ogbPf/kYg8REt6Blpg1nDwTahE1GULbhjwjnE0PdMODJXD?=
 =?us-ascii?Q?Q8VmSnAR24c3m6qq6Xg5z/metyLcA6ggkn0Ckgxyf+1pzSRI5WIBitmeUUS9?=
 =?us-ascii?Q?S4jcEXgYQZFR4t3NauPrqEYvoRU2a25yLWGVzvdaDX/S8QhPpnlYDWxH7skq?=
 =?us-ascii?Q?en0H2CubYuNyzDpST6fsavhIDiVWA/2lSFAIB4l+scazVRalbxaRvBbTgceH?=
 =?us-ascii?Q?iYwYYxxlW7x2uvaNw4f96oLfiodWPMOflWnQUAJsfY3k6tmBRem4UNEsIwWv?=
 =?us-ascii?Q?uOTd+lsgABcte8DwIdf/kNVwcdzdCVZJ0eUcXuTgK/wIBQ8ATE5zdftXed/j?=
 =?us-ascii?Q?KXYfnv+ge11Woc2WGa6KduRJ+OQsDaD46JdeaKY9EniGf19yvI7lDghOhVO8?=
 =?us-ascii?Q?xyflfF/zcDvX9ZAj5slu3i6PeeuScK8xhjk2gHyNgGA5aBu7oLd3LmidXdMf?=
 =?us-ascii?Q?QqKndGMWTlEkqL2hQyGOwQYZc+xtsbXNubHR1LapxaA2Ax7kHc6jyBFxKUU3?=
 =?us-ascii?Q?x6dx8pn8uLQ6p6ai9msHVeiDuqAuYSSaVzz6K2LOoHe+kONxnRuYIzqZ4Rjd?=
 =?us-ascii?Q?MTru+HM6TUd6s7eoOMHOOIsIOp2BErf29WScZcfaF9OKIqsY6LAeDDgp/wMe?=
 =?us-ascii?Q?O9l9ULItf+TuFXFedA1+i4p5k39q19IskG5MV8izAPnwEcDreGZrUPnd5/5M?=
 =?us-ascii?Q?XJ87wubOl8OdQ/OC2Cp/FWlBz8fl7IfBathEK1m1t4zYIpudmu8y/02oGWOW?=
 =?us-ascii?Q?xosxPzb/eehmleJPaSEhzlLo1yKuG5csOzWYU9MeSNn+7X3qtgx9LRXE4y1z?=
 =?us-ascii?Q?TzySD80g+NIUHN2j7P8MGlSSisGdeK5zso1/gejrHqRbzFU6nIpDBMgmiogK?=
 =?us-ascii?Q?onawdWGJvzzhw8I8A1NF/Z/IxX9JhzghuPCqGdkzneNGTHSUSlDcDXZrsYxw?=
 =?us-ascii?Q?B0pxZwJGKTyoTlQyeWDF7teYy2R1ZUQpPJ+b4BC8L2v72hg2VZfsDyaU2JVr?=
 =?us-ascii?Q?KFqSlRYDVAYql++QPgat36RI3MPYWeqMlYup2/9xV6kK/6DnLivebjV91pE6?=
 =?us-ascii?Q?giX28aU+u1srtXS8AcsqQ0VjjIVOsAb4NannlRKGax3LZkymuncc8oKX0X+v?=
 =?us-ascii?Q?tvLRmAUap0AzN0iYh54k6s7I6fmQvuog1oVbdzSy0Wo/9/eoJHlSGSCuOVRh?=
 =?us-ascii?Q?uNjju703c6VBd7/5DRlKv1dLCBnffBlg0lzHfeJAv1D4Ye4+QnS+IujdkbkE?=
 =?us-ascii?Q?zTBESg5tJ0wAyKE7XqkK/s9heIhJQ/FYRrByniCGl4DOl9xpjIdqh078NkS3?=
 =?us-ascii?Q?eEWBwHKNQjHieprm7Kmxlb/p0Alo4/3mp4ZbXYbje5I4MLZif4a7usa3S+qX?=
 =?us-ascii?Q?Yf3VFoRT9oGhN2T3t/exYk/FhlfWOGPFisc0ZWo0vqm+0pcNF4nWNOPQ5jQD?=
 =?us-ascii?Q?F22LdXMSpYYmFo4OKh1OC5CqQZT8hLIElMOKiPb1MVGx0o72GtQ+jMWfclPV?=
 =?us-ascii?Q?2F0DgaZgq84llxnN9fwiaCM=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR07MB8631.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?RrYYvwyyjXvLngNG6DYV3YNnHh2sPSRU4Jjd65NSCTDGGj+nJMkqJSdMFXBi?=
 =?us-ascii?Q?smAUrCLxIpK8k2IcRygzhB+fFzwEIWsDBJkJJEfqDm+TbBlnb/ojDpYZ4REY?=
 =?us-ascii?Q?FBdpwLDXzoejS+IAIyInJCoSTz8wJ/sf0G296rhDFzlhGb+p9DosCCUf0tPV?=
 =?us-ascii?Q?nRKjlzbCW2fIxaO2mZyNJhGkYUCPD3T0mnXW10eW5dwm04QHlZJ+daapnzzr?=
 =?us-ascii?Q?DxlZHvegXJof9a+p5P63fhOigKW6t+ndYlLjteDKuLOFvFXnJA6Gm4S/MBnD?=
 =?us-ascii?Q?TwmXg5gsjX8boQYlqqHMU43rBF7JKPS8+Uyveu60z0iqr3GG6ySHoZCiVxHI?=
 =?us-ascii?Q?60eZOzlpFuqm0m/DsnYboXf2VhMIi5+4qPR2jRtdE02AtF1tziGsmVJcFVKa?=
 =?us-ascii?Q?ORuB3SBHQTe46wcJXnwCQ8ovLwp+CEag1CTvocr2M+9Eu0/sZKvORaEfzwsm?=
 =?us-ascii?Q?yecFM0GHAbJdpYZDS9R/xcJBxKplLYdcDF6QmGKOhYNT3/r3eZG2k9lF4Eaj?=
 =?us-ascii?Q?u8RcbQTAAgoZT6kEL4MpgCqwDOfyuUEp63mj0fiKMP81RuK/gdDY5KMfnzf7?=
 =?us-ascii?Q?VLnA3wDOi58vJbFX7T4s8KV2cHfXuKpwclOpSKaPXVc49NxTWHjgmrA+rsK1?=
 =?us-ascii?Q?kannxUTcONDQC0bSJjDr94d/rfMUe37AIE7/aL75iS76pb1FTiYDvr2mHuxT?=
 =?us-ascii?Q?FL7VA0D7Cicgq5TxulK20Hzb13zfgRPlx+4ExWu3pB6IeykS6jMIaZtXtr1l?=
 =?us-ascii?Q?EhZU9WE3CGzgdaClZqsUIC54U2I9tGXwBW5QSOSXV2dOk6lFJFNS4rPL4VTs?=
 =?us-ascii?Q?0F2XTvLz+CDP9RVg4Gkc2ZLp5kXKhj6jKC8cvN1SGXn/4NoThJKTQCYnfdmA?=
 =?us-ascii?Q?pLBeutcGNfC+IJdRTAdON9irZAydHxKj4RlvnUqvMI6U3G+dHBVnEQPsCCPC?=
 =?us-ascii?Q?m087MT8C2/txXp+GL8sT08Bwk1+vv0HgVq9ztV4sG88CsWCSjc25ks7h8TDC?=
 =?us-ascii?Q?AHo8zz4S1Y5ZbIinaftyavQjcVwWCY7P0pSitl+MXlb2MJohEBSmcE6HuF8+?=
 =?us-ascii?Q?tNHAv/5X/dkrveUP5YgIdgBS/gTP15SVGF9MJ08/J6lUNMQmwonBAiKZ7Shb?=
 =?us-ascii?Q?aMIf0MO9sGICXxZgUMpXt9erJroJqO6/EBfF4fqEB5Gww8zdtUGwEG/dbBTa?=
 =?us-ascii?Q?IJnrqSzLYySRypIrdav9tFY3wUcbotm1zSdcxJWgvDYFUO+zg1FnpAFgjpa8?=
 =?us-ascii?Q?SushsN4MX2UP7S/PftkGxEWEF8p5GmRnMEQhTvi1u0uuWmp7Y9eNnGdvIv3m?=
 =?us-ascii?Q?6Ui4+KvlCsfCDwS65XqTyodsEpK1d5w20+Xn0n0mPev8Z22ym11NqfHyo/YC?=
 =?us-ascii?Q?UDsEyy0pyDBx8IWXSGN6lg4Pbm4GDsy3cfNpP8LzQGVio1fTSlwQ1Y2crEKK?=
 =?us-ascii?Q?HilqLjyTZPE2LW/aHS8DCk0nYEpfMlvpZ45krLJ3Y1drvuJz6FCIGH5/SVK2?=
 =?us-ascii?Q?Y7W+dgNPomi4PY7hodgBQ32fVLJyHg3M5bQzAB1PNjMw3qVYjk+C09gOK6g+?=
 =?us-ascii?Q?TAobI0YXRjef7a2DLrPLsWQPAemTcDmBiC1ICd8E0gxoabui6fWYV31y2//F?=
 =?us-ascii?Q?tnO+A5R7mp+ADjLfrMOAXrZGtfXZpEhZHEl5tmEuolWsazMrCprQt972mMBk?=
 =?us-ascii?Q?5bY2f5X/J43YeM3SWBqy0cqeiwgzjUxQ18SkGJoVdZjKKn40rzpwQK3sd/3z?=
 =?us-ascii?Q?1bA4o6Skwg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR07MB8631.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5112935-ac58-4a50-169b-08de55234005
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2026 17:18:21.9399
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +iz+h7jjxmKdXRlWPOGFpLYSUEgSlSP1m2yXhxvrar4am5q0s/bN6pSriXIVvjwzGJ9LoBuDBiwGz0KAA95RXYUY1mRB4fhQ1/R9P5WloWA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR07MB9847
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDEyNiBTYWx0ZWRfX3wzdgBgaCwXZ
 hhHzWbF0oYOA49y8nfMPpQbkjidv+ZDWw+2V6sGdAwE6afv81tMJa2+SjH7jPXha/tkJZ7saZ4M
 ft8nnLXXJuHpHKW7T5SA0suIor45E32JDDZEsfZaax3tx3cSBAkBSji3LSXkxKcEnKxyqegjxc3
 Gs961MERbkFKwvETMnLc3cV5PH/ol1eJ9uBhj0bZGiPfc0KJmqlAeMihyF01xnMAVMgf8ybBwso
 w7C8l8cGulB3hsdA+aWAtHnOWm6GD4Bu+4VWei0C1b0Cn+jpmgmWUwfeL5be86fDWx0lKO+aJda
 6deiw2Eko1jUHU49gvXtjYUmdiNYjgGDc16zlWRaR79CH1io1Y8TRzT11QcW2QMBtN63R2qw/Jr
 iujRhhr2sBW1qIN6Nrdh++dMiG/xAMcvol7aK7GsKYOPn6BTIP2zbrJ1NdZ/k6hDG/4Ijib1xwD
 cNJN8CsmJm4EiwDznag==
X-Authority-Analysis: v=2.4 cv=U52fzOru c=1 sm=1 tr=0 ts=696a72e0 cx=c_pps
 a=3NFNipLq04N0pvkhkOyhzw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=Zpq2whiEiuAA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Br2UW1UjAAAA:8 a=pGLkceISAAAA:8 a=4LyL1pmJC_DA-RUbeZIA:9 a=CjuIK1q_8ugA:10
 a=WmXOPjafLNExVIMTj843:22
X-Proofpoint-GUID: wHnRen09hEsVfda8vWLLY9uuHg0AqFtA
X-Proofpoint-ORIG-GUID: wHnRen09hEsVfda8vWLLY9uuHg0AqFtA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_06,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check
 score=0 clxscore=1011 suspectscore=0 spamscore=0 phishscore=0 malwarescore=0
 bulkscore=0 priorityscore=1501 adultscore=0 impostorscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2512120000
 definitions=main-2601160126
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3867E140008
X-Stat-Signature: a76unczhmwet93pggw8e3pbshxdwygus
X-HE-Tag: 1768583920-460411
X-HE-Meta: U2FsdGVkX1/0FBt9RqyzGfg7D1Pim1MDLUDgVoJeqVY8pJerBgRq7LkR7Dcmo4z/jFUComVXKBaSMH9SPWqkVj7SjG4HMFzqDhxdOOEoWhekOApsc5xfYNzMos9mTwA+jsWmdSEyvu16g3vVM/XkY+9FWmqqCRCNh8lcWOwHbwS9MskN+b6nuJYtTxzJMQiJSDnX7xNBW9YRLXGJzBWIxcFP2XKnR0ncW3uOeV8OfgFbcDNqdB5yHV+6Kl1A/IhDzjPNbO0Clm3gtgBvNnO3FBvDlHecoCIyMJaPGjT5x8uyGpCOTteQMOIABwdGuiA4XvSP001TahV5HPqLHw1tljq1P5i7aePZvTHPeCxfiIqrm2Ml2d/ShY0Dd/uzYd/Yzu2MtRJb+KzBVM0s2s5UbI8/mJ7VOi29EDEhqqQFZtkhYo67Lj+aDAGIg2vJ7/Q8rdW/HV/HHgz3pTQ/EUQnDxwcI+mMq3BeXp/uxCnNTi/RrHcj7jXP2JZa7HKD/ym807Tu1QDLt+G1X6/Rqq7vfMBJm6LCp7jJS/tu1j14Zjts2dXcxZSIF8mC6x27/GE5XBEOoddcmII1MKTWYkr/qmYwYrWPS8QYltMGgedoLJn0xs5GI3y0+GGq84uLAi7PzTC95qX+GT4+/8cGuT5WZZPYzdKA2nKkKBKiVci9xZtJQ+ivaIzCeym9RlUF08EPTWNd3OVT9zNm1lSxs/ZB9Ofb87MOrHGPYwmlIGRzpFahdUs8tv+CVaYFnO9DWwa7iEdkVxEmMQW5HrTQIV1gkzbmRqSy5xjNwhwH9BtMo2xkoxYuGfeCdt4GDCSSuXyQZqu1A2g3IFJ8JiusGa2G6XtLYBqNkdrIA/4/zQ3fIrqOoJeBHQVbx4PxmlixAbQEA4ilsVPJyVcNC+sg23ADgaNRQO4ROVIijL4SQeX2PzFOQs0BhqO/t59q//tSzKQuBDBrdl6snL9w8XPHNsW
 3pERfu+V
 K5UVsooJvaXb23maxVMVExcXTMQxdU+vzbf0i21etu4Hjb9dVcedGYKOqitArFUQ6nQ3/ya2MsWwzYDVmbfLFJrkMGLYkooMsaa05BgUwLd4H/VQ6KTctBgleb2CXplF+7QFk6yHOiGp2qXFYol7CUmK2C7xus/HV5wQlngbfOTdWVMBw9aIzMaGkyZoNzHSL8pZrI+s3/qLDFKPDJXoU41BbfId62CIlJirgA3BQfmoXSLjfd6c7mMiFUuGE/YSFakQeu8+pmvVYM730C0wa+f89QwBvZKYpID8/d9afcvMPzSjCMth48u3/0NdRqlc2HDWes30gwr4eKTJK7ckuJkI5Dr7X/H6kyv6Al8JeIOjETbu7cIdh7WMsAzkmDNHEKafVtCTO69/fSG4yEojMdDd5IZS2NfyGwK1S2JsvIx8+CfRoD/QexbMGEBXj91TTWjKWJKEEkj8nPCx2SVJzgJ+v9Qw+s3ri8r23r/JZzDSVrqDfXyZqv+q06MA1tAj7acNZ1QoQuPG2wd2lAre6yWc9JfpPX0q68AaD7evvPtpErGZCTmlbwUlyDnKEwr7Ckl/rPeqx6lAgUWWtIIRKdB1pevuZpwWF5/Xvx475EKL9ZBnmcSsVQ1sqbQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From 706fa431358390713c47667f6bcaecce56d071cc Mon Sep 17 00:00:00 2001
From: William Tambe <williamt@cadence.com>
Date: Thu, 11 Dec 2025 12:38:19 -0800
Subject: [PATCH] mm/highmem: fix __kmap_to_page() build error

This changes fixes following build error which is probably a miss from:
ef6e06b2ef87 highmem: fix kmap_to_page() for kmap_local_page() addresses

mm/highmem.c:184:66: error: 'pteval' undeclared (first use in this
function); did you mean 'pte_val'?
184 | idx =3D arch_kmap_local_map_idx(i, pte_pfn(pteval));

In __kmap_to_page(), pteval is used but does not exist in the function.

Reviewed-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: William Tambe <williamt@cadence.com>
---
 mm/highmem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/highmem.c b/mm/highmem.c
index b5c8e4c2d5d4..a33e41183951 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -180,12 +180,13 @@ struct page *__kmap_to_page(void *vaddr)
 		for (i =3D 0; i < kctrl->idx; i++) {
 			unsigned long base_addr;
 			int idx;
+			pte_t pteval =3D kctrl->pteval[i];
=20
 			idx =3D arch_kmap_local_map_idx(i, pte_pfn(pteval));
 			base_addr =3D __fix_to_virt(FIX_KMAP_BEGIN + idx);
=20
 			if (base_addr =3D=3D base)
-				return pte_page(kctrl->pteval[i]);
+				return pte_page(pteval);
 		}
 	}
=20
--=20
2.43.0


