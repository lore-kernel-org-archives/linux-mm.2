Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48293C79F9D
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 15:28:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEA976B015E; Mon,  5 Jan 2026 10:28:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABABD6B0162; Mon,  5 Jan 2026 10:28:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98F1D6B0164; Mon,  5 Jan 2026 10:28:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8275C6B015E
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 10:28:32 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 579B613965B
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 15:28:32 +0000 (UTC)
X-FDA: 84298292064.04.B683E79
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id DB4D8A0012
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 15:28:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Pwm8PY0X;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=y96Hcxmo;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767626909; a=rsa-sha256;
	cv=pass;
	b=XjqjIKccFH7q3wpFnwdQjuWfvjikUYLcmy79Zy9UMffZCSZgKwUf2HljNWGoxO80CV7Gtp
	BagQJK+6FvcqzQGL4LOxCg7eTraRvySsO72Ii6Xce9cmeoAlvc+uRCgirSDWnUqtN/OOyI
	5aERzajeplRUfrIbd4PnSOdAd+4jt00=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Pwm8PY0X;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=y96Hcxmo;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767626909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pqHioT5cwROgwbZPFg2xVWHxI3r4edgWk6xtHui1Yhw=;
	b=thyFeZsyLYgpkcVTcnAjiRYKg89vEhZQ20WHpLECn8/nusTFtQRNdHHc60aG9thJO0IEaT
	6PS63ulGDbaHqHxtvCLy5XQym9uTXrad4qckknx+perUQ1vbUvaQw8d5nPc5iTZ0V6d1GO
	KWTWOFH+fypfGKybX6rdpesabXejnc8=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 605FEcLq1671102;
	Mon, 5 Jan 2026 15:28:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=pqHioT5cwROgwbZPFg
	2xVWHxI3r4edgWk6xtHui1Yhw=; b=Pwm8PY0XneYG6yLLNnvQn0ndtoMcQ869SZ
	vCWFCsD+on5St6IomSz17KiiZccX7hLDt5XYUDOcwbYemR7QXomAsIgzVZz4fjPq
	pgidd9dWBjUUbQfpO4Tge80TYoBbSz6DtM5C2Ipm5lA+uQoQSn41L/jSelB8HZ9M
	fbgvSAn/vYalP6Yf4IfFF+FKRbg98CGnXQTX+wrwEpBvgiyGT1pvmkDapVX+3FUu
	jbI2cpIMZdOy/8H6+xe3eZpvQHo0KVztx/Sr4akdeixFE8QSCG6nfaRszBkmU4BZ
	CWXv31KOu6H+Ii3esMI2//44TXOja1991raKnAFe2Fw1XM/5E1Cw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bev37swhh-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 15:28:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 605EuXjw037105;
	Mon, 5 Jan 2026 15:22:48 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010049.outbound.protection.outlook.com [52.101.56.49])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjhg685-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 15:22:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KbsdXntlhKdqH+iFxNS+iK5FfV8DiMrr5PJx7G625b92B7rtYXduc/YOXujdFJhi3rVqnb7zvTlmRpbeN/gognSDv826vFBRBc87XltxsJLaW3VLQoAhJagJjNyVICybk5I6VJTY1wG9huEALLtlWzGEr6OJelUqVW3yemKIce6dSbUgVOr372Xsu6EB7F36llk5wZeanWcdycGdI0r1qpBGrwq7VMwrZ2s9GN0iVx7EyHCHVcJxSb1BuI5suzCpyOjguh8O7vGT5f6m0HZJcJtMMtld++stsWjMl77p0cFbaz7h0zFNQpodrr8VlsaW9yk+NxMkI1iS75IRfFOlvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pqHioT5cwROgwbZPFg2xVWHxI3r4edgWk6xtHui1Yhw=;
 b=i2lcc3E+MbMl9+uKwNAGKTyzuB2zebGZSy7jK6KHgq4cTpG4Yn7pBMrQEGQ3n2HzW9erbl9RFhosUkwOZQCqnViROi3/GTYpK67kF/m6Uj5PEV7y+5rdL6KojJlO2GH+u8czwk+R3oTEd5Hg+Z8RfS8eDSqcGzfJTfA9+RAC/dPjVWav1hazqjoquQ8sDdIHbtuGO+noWYc73ZGDPTNGwh+8N7KqwrBk/a3i3MIsdl8Odr0Xu2wUEWaZ9apVo/GohShV87wsgzjZPCN7+Frzzd7aSCsI9q7ylDw/y+gzmhHxKtxLVvUKbUhcf5LusHXiIW+9zrZHxE7oKigDd//nOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pqHioT5cwROgwbZPFg2xVWHxI3r4edgWk6xtHui1Yhw=;
 b=y96Hcxmo+oyqk4rB5MDRq4TsYz6GuL5XrnwQQqmOrKoVMd/tlMZ/DBcDUjNjJwGHorASd4WitAWvk1iswpTKawk5Bc+ETQ7m0O75bzZy+dUKc5+mQOhZnX1qtM/7z8HbPuOM5yW4tq7k6Her8hK1jYFXd4jq3ptWciu7fdYwANg=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH0PR10MB5132.namprd10.prod.outlook.com (2603:10b6:610:c2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 15:22:44 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 15:22:44 +0000
Date: Mon, 5 Jan 2026 15:22:45 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org,
        linux-kernel@vger.kernel.org, Boqun Feng <boqun.feng@gmail.com>,
        Gary Guo <gary@garyguo.net>, Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Vitaly Wool <vitaly.wool@konsulko.se>, linux-mm@kvack.org
Subject: Re: [PATCH v2 11/27] rust: mm: add __rust_helper to helpers
Message-ID: <094134da-d7a0-4634-9045-5dec1e464ba4@lucifer.local>
References: <20260105-define-rust-helper-v2-0-51da5f454a67@google.com>
 <20260105-define-rust-helper-v2-11-51da5f454a67@google.com>
 <is6imcmf5dj6hfmmxdi2mtphodz67mvdprkuvbrcsm4ab3udl7@fbwcmsescdu4>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <is6imcmf5dj6hfmmxdi2mtphodz67mvdprkuvbrcsm4ab3udl7@fbwcmsescdu4>
X-ClientProxiedBy: LO2P265CA0491.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH0PR10MB5132:EE_
X-MS-Office365-Filtering-Correlation-Id: 838884f2-8b81-44bc-2f73-08de4c6e4650
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Eb9+lnwtyaaduj4IPC+cR0d2j1K2S/6vS4OsaJfuaKGP2FzMFPqE1V8ecUEl?=
 =?us-ascii?Q?dqrBNHmz932sClOu4iHMgExJV7WfujxfX3INFO6VU8RJDkxbRwvcqhMFmq9P?=
 =?us-ascii?Q?y0dCtXk2PqetTTY6akZOHvD/rk0SMBJbA2X6FafFuJTobdDEicuiunnRPYF3?=
 =?us-ascii?Q?XrF2F2vOTRpLPYjPgE14V1tGV5h5dAbL9C3fh8jz6OraHZSwx2lrUIcsZRQt?=
 =?us-ascii?Q?zrTkq1okmgUDRG2vPrAV+am0kViFtZ6Vxt9yZ8/wxe1rxOPQwA2pM+ULEGRO?=
 =?us-ascii?Q?5dgNp6D5eu8QYTFWhoCLuw0J4d2ymEa0ny02KpisYzEM0F8PeqYDmq1VAleF?=
 =?us-ascii?Q?Jw+dQb9OQg9hjLMA6tKaOXf3HMfX6toNPFahtHf5A0Ou88Juag/UXe86fpev?=
 =?us-ascii?Q?J3wg2g+uOKf+RGj/8fZKyrVqsMpPWzP3I36AyH/IoWqdACE7o9StF7qKKrCw?=
 =?us-ascii?Q?ZU+IiyO97SliWSU7YIiF5H9ZDwdmNYrAM5lZFQ7s31uP3mwMdEx/CdVL7cFB?=
 =?us-ascii?Q?w/hjoX7clZ1c+jgSkVLmN8erhxBon80G0e3wwcVhy4ND9756orPHLWSC/I46?=
 =?us-ascii?Q?feP7CdKxa982F3HZw/+O4z7Wt8j02PA0dL/YMZ0voEc9bfjpcinZM9dUjIZs?=
 =?us-ascii?Q?76/1Nr566MbO2nHXv0muJYo74k+QDzy8cV9XkUlLIIhJuWV5lPZ2lwVQbHiV?=
 =?us-ascii?Q?iIDYB1d7wB9xiXIMavxDekCsP+8UUA6yc3pac5PdRvBgIPkOSjnQsnqQ9JyI?=
 =?us-ascii?Q?ZxP1io3XgFgHBQ2abF5JoGABEUhngzX/4v5sind5lS+KeQ8m9k3S4TyIGB2A?=
 =?us-ascii?Q?I4zo5Bem5IbIeQRmwOAQybMNrz9WBZX8oTK49dHtk5oYaG6Y4DjrL+1ZepcJ?=
 =?us-ascii?Q?i4uzYPsFNMTIixiHf2/vEOPGM6t8zvy/h4zcO35pGisA0RhDS/dCaASPsFRD?=
 =?us-ascii?Q?50Rm8Mvqig1TTrN5PKY4Bp8Q04RMkYCPnizgckQESpAEB3B11ouz0GKJMquk?=
 =?us-ascii?Q?VV0Lh9G1NGdi0C34klFoX9YqlUvx7nqLPYNNR08TW9hry4C3gyqmq0xD/7H/?=
 =?us-ascii?Q?q7EvyXqTS1/hpULrGt3sQLjV8JcvSdDJdZMr2W9g2RlVBfMcf24s+QomDn7Z?=
 =?us-ascii?Q?5wVT0chF/LaSC+ryT1FJ5s+35zy8H39aisqaclec1lGWtINpiW8rdLC2ogbb?=
 =?us-ascii?Q?MvtHxncI+qH/KXqWQg/YXzqXHQCd125DHK16xdIiuSE42tiEhFiFTtgPsytN?=
 =?us-ascii?Q?1jRGE98H10T9CfgkiqqSf5cEZmEwrTfXsXILqH+DegdM11BSFw5T3fzT9+gR?=
 =?us-ascii?Q?Asab30ApAxxeuCAZkpHwzoV+ZFNuM8JaCL2j3AGXDRWzLADi0fSkGWFKgXSf?=
 =?us-ascii?Q?vbEk54wFycqWw7F3DToE2B6UMtB0pi9/LOuhIFQZ5cDtN9ylJIyODRfwKJWE?=
 =?us-ascii?Q?/ZG8YIOszKrLsXnGOEQihq0SwkGyHBCqZapY/ARhNmhYQa1wvrYj4Vwh6+gB?=
 =?us-ascii?Q?Jh/lCwD7NHfsjoc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SE2grEyZ96/4grxMIxyfDjDJ2MIxujjP9IawD7cMQklG3PSMNR6fXt1XNZ6X?=
 =?us-ascii?Q?2uFs5f8WnTEd4eYeMlLxp49ws75fhbekGkAYl0oXugshEdhGKBWzEMHGeK2w?=
 =?us-ascii?Q?DSlTAE2hvz0B9QxNaW53mPo+rlt5oRG41JSrjCyFj50ojU+vipBUQEcuYM9g?=
 =?us-ascii?Q?dXJWfl+MHnm5ikRvjKm7npaDU4knGV9Plluo0j55kiHAi+PYwAJ9HF66Ht5L?=
 =?us-ascii?Q?bjvgiSKqt0X9aKz1rguoyxkaOfUtc9SCgXuGLLRL2kDXIH66zWaNEnIT5zF3?=
 =?us-ascii?Q?Lr5erGEThXZyyWNEuh+5v5PY1ssfyCrc/kosZDnflgSyVBNnpEs0yeOMtYEc?=
 =?us-ascii?Q?Rw5yo0MzkyQTzbBRmY/22eO3/aIWd+WwrqSE2qdF0Moj1Vqbpq9j196NR7HA?=
 =?us-ascii?Q?MnTacQ7xmaTjWcVhqWt1tj5a/GKWLJp6GRoXrfdY/8/jTyfa1vpQ5w5slqyD?=
 =?us-ascii?Q?qWzcSqpptZaiMKiFEElL64INUORNFYozxbhOQu+NXYgnr4qsZ+XKF/Tk9DWU?=
 =?us-ascii?Q?/djAS4YaxXZkqF01ani0Y1y4Rl1U67+QgwfMQ6HKfZfG0vSzAC0FEYAbQiIC?=
 =?us-ascii?Q?5Ya0xqv36JCKGDiiCy5DfYhCneHRqP+oAJs/mFRTt/UMZ8UBcM9XKLL4U6a/?=
 =?us-ascii?Q?BzQ6L/njGqSnmMZIW4vMwUoALfLLgdGfskRa2xy5gYikkp/Va+ZJQGL437lw?=
 =?us-ascii?Q?IUnSUThrPp0HIJZDA41R33ncuS0t2GB2QovTQ7rCaSvfOopyxQI9M3zuAi+8?=
 =?us-ascii?Q?MwzYsNNaxRIb/a1ldJlBBhp8fFio+grHfZo/6raFB3wUw+MS4i9rolBl1jqZ?=
 =?us-ascii?Q?jQGX1j3yLim9eOndObeAsBm6Yle+9HkzEv7CMpid0rrHLmWPrsMH5PhpJ65c?=
 =?us-ascii?Q?Jq8Cq318oZICPl6JulLS2a75puf2U7/o0XcFHcaJVeFFuy7YEE6/x03yGE2Z?=
 =?us-ascii?Q?50nLuBWTr3Sj77/EYYUJLxiTue9xbg2//vOqrcSstt1gwEG6my4Y+BKotmKv?=
 =?us-ascii?Q?qQs/lTP1rVVTsBRgiwwPgwTPRbkiczGaTsw6BLonPp35Q4tRAp+y0Y3YyA6u?=
 =?us-ascii?Q?1XfYH3a1S1vMBYgZFMmOEoHLR/kzklv5uHptGi//anvPiYbZ/jPzCI7zBQk4?=
 =?us-ascii?Q?cgS5y9fk7BGsZLwnm1WsHH7DKToQvbmQim2ThH0Vy051Gaau+5OEumro13TS?=
 =?us-ascii?Q?4Kwo8a1KjAHPB4ryb3qi5kFY5KnbQfRaXv3JXKer6AiD2cIb+GMB6r1zB3vT?=
 =?us-ascii?Q?Wpc29yxtmXYikUlxnf+cwqeWP/m4lGKBUK2/U4FFLahsNVfdH2NHgteFXCmo?=
 =?us-ascii?Q?783f8As/AwVSxs8N+dVQPYwBgSaTQj0ymyHOvdYpK4+2RAm+o2FvhtOze2Kw?=
 =?us-ascii?Q?DzsuTREoAOWuz+xlgk69WBKQAfnpuV4TxEeDzrdDTL/btRj/1dDeBVt6Ni5X?=
 =?us-ascii?Q?nXouFaRjZTPXIBKRB8rrfHT4Zyf7fOCC38UaqgzCePHZaW+ekC9QIBDDbQ5M?=
 =?us-ascii?Q?6f+uWC+dkbpRmMh5YXoFsblh2FDsF80fu9UXJ+ZEM+Ig9grWmiDaMFVIqg1K?=
 =?us-ascii?Q?7eEVuXdjK9DL/PrsHZrOIDLKhZ5dMJVG+TAKPq6rn6TMXqTd8FTJIhBwMsfL?=
 =?us-ascii?Q?Nz5+Qv1SKbxzGx7llrfETPkxdqttywdGdtLKNezvFFE59Bq4XTXAHlraxDj0?=
 =?us-ascii?Q?ZsKOZte1f2yF9l6HPEX1Bm38DcxoNtljXkw81RO6uSG9Ieg31/TPjR1PROQc?=
 =?us-ascii?Q?/hC6TAlGCaOMcmuwfAr6bCTRv9diSmY=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	J9U4+8VkbPDqrwtLMDRFebHEAp4rHWLJMWQKUsTUcsnK5iEEFZVInkWN4PgFabE5Amjz7PVSkQILOhdNFt0WG/WFq45cZ7CUDG60c3Ttwvp/4H8b5E5dgF1SsYvW/jogLmyPhIJSrbaQmIGXguV/RSIv5fZKliNOhN1Dm4pP7LyweATQeoYqlbHgEKiwRMJJGrDOVT/654CqjryEeKXjaUU0V8xpgthgJL4CDOdZGSrvRoPH21EoKyjfLu01GsIqo5lCBLJni8uRPWOGoKvJ9a2MYFl8Qbcx0Xkg7b+0HOy6tXfL8usJhaeynL59YIhfLNQ/gcSTF1b2BzZHDI0X9B4SY5DzXfkpLmvgEornfdqczlVao8gUV1bNVADunCqkeXeuoY2A7h1Rhd0TMYturMYAYmev9+/kLJ62kCSFBMyxTE8ctsdPYuheWfRztujWP9wyI/0ho6W2Fa5N7IgLVeWUgeqgRG+gs+kQbawBRR0w2zd0A/ynItoZ+eZ2LSOArj0h6d809ENWFjpzGvLbs1pDWgGIpafLjCQ7N1P9jsfEYk1sz4wLYcUG213DJTEMcxNCS45zH1O1ykzMVFHpm3RrsVRhya7mII1sT0jvqcE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 838884f2-8b81-44bc-2f73-08de4c6e4650
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 15:22:44.3976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AsHeRv6rblfPFUvpefyXj5n9GUcy9v9kady+sYOSUxlxUFwHee2/za8PEzTjnFpwodykwjwxuSacDauIgtVRVFOlqMPrvaeilqwPy9MtXLo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5132
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_01,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=864 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601050134
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDEzNSBTYWx0ZWRfX6Jy5LC5g0LuI
 Q3UU1AVgmX2pG+d0wMP+JJ7gkB0Y1xY5mnaF41E7qu72YF2VV2KZHdPUIFj5ZtNc8/+SAiX4g4E
 e0Cui7Adfj87KNAL62rkjuajknNXZCiZcqCNAr7TSW9JTL+luk5AOT4dMrAmUfcqxvUwi3BfwmP
 XXsNLAu63IcaKzWi2qeGsD1msvkz5BBAI9x1kXy5gz48rpPDf3By22xTI5kUVJnP89DxtGHVM6E
 dg92IXWZj/34PKRozBtNVtt8n0aKi0odF8GuLQsPWe2cKhIX9c+bCv4RtGAwBblJmNuVu16o3NC
 XfS1qh+9XQEIQX950WwBHjBN4JO3ikf8NbbF9+7ZvGUgobTFAeoKnUo/q7Kbs9uTobpX4Qmj9Qt
 uKLflzp6rqxklU6qmI/f2STV1Wl0gS9+LxiEMkdmyQz2uOcs9KPv+OcYkQlXEor7sEv3Y96Cr+6
 6wMYtFeyWgR/4ePQcE3n+UoUIGVqqTPFNnRk1k4A=
X-Proofpoint-GUID: JbCsfMH39VMiMS7dPhIR6sH3FtJMhYrz
X-Proofpoint-ORIG-GUID: JbCsfMH39VMiMS7dPhIR6sH3FtJMhYrz
X-Authority-Analysis: v=2.4 cv=F89at6hN c=1 sm=1 tr=0 ts=695bd896 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=pGLkceISAAAA:8 a=_2yia0w1AAAA:8 a=yPCof4ZbAAAA:8
 a=Z4Rwk6OoAAAA:8 a=37rDS-QxAAAA:8 a=6HTOOvjmIgsThJMj79cA:9 a=CjuIK1q_8ugA:10
 a=4yAS8WwzZ1jAEY03B-5r:22 a=HkZW87K1Qel5hWWM3VKY:22 a=k1Nq6YrhK2t884LQW06G:22
 cc=ntf awl=host:12109
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DB4D8A0012
X-Stat-Signature: kt58kkjhrynwmcxatgfbd1srpwjrrgdp
X-Rspam-User: 
X-HE-Tag: 1767626908-712552
X-HE-Meta: U2FsdGVkX19QPrmlyYVuyKiGGCtOOPl1U/l1aWYcNHAXLyA+L8iOIeqWmmvbz5QHWMYxNadRqnkMhsocnOY/zppXs6G64/7a4KxfgvR1vlJZa5YoWfUI7djh48z6ac/ZLszfe6DIRLAdcHfw8ekT68J7V+CvPh7TjD8gb86ptmIRQEqF4SLn1/VRGMClUh9/naG9/okIYkKeXbr8hIEdEo9+WTSMxnuJw3IB3lvh7HPX2meqZVqyaoqZTHSshsX0RDDbCKIRGn0xw5PBa/+iFvPY/S5RRMkM0TjdKo+logQRdWpWxApvAmFINhalA+Nq+o1/omXWiOdyNZcB6aVu4yZidBsebCYOl2s0vyxWi7M5T53pgcBOqpnRIgT4agU/sbrGUOWp+YcOpWKwmEAASG30lP489Zm1MUJRy1D8NfE26H8NQ8p3Yiif9wTYA6r0qFeU0ghNfXsYaafHocIhoJA9H9pJ/1kSJ2XquU+qeUVuEltpWVdRF40Otw4/FYAPuUhIIs985Us8qoYZ7w+EahYzhBalV57fXD+H1skXlgoyxXW8+fhWOACOq9ak6XXVwTrkl5B4aZ3RNXUMYkFUqB1CR5phRJnx9PNq5HnxgGIGIvaIHXiHsKrrTYUv/mWQLTkpz6BuipgQbbRDmVh2TtzR6L88T473WJIScjoxkmirXqD5JemuUm23RqCYcCEM2d7cBxz8wPaLjZ0bIkR5JTAd5PGz8B3i/PIhc5DOaRbYwRxlqyf39PZ1CoQpvV9bq9PkWKND8lUnDjMig6RxERsw5OUjqrqqNwD67LgMeJNO7sGeCtfUA3eiIcmV9OTs6KgOO6qfoBojLiSq/L8igk1Gb0lj0bmyk9MiEpdYsLmenJtv0HaT+TCTGmY3nkIQsMFt6IDcdrbaZKTWJSC7+PXNBc3xckckMacNVLC+F09h49kWvNFffiG9xplUNdOY6rDeCxi6h45eEPqwdkH
 ICYrlODl
 bVPSDmx2eMaIfSPLlpUw8/1Qpkn7KZwcqa1qPoxSUM0KnaPrfyjFfEGzk5FocJH234E9qt0+4q7/hFnpw+Cgsf9dyT8+qZP1N9/LXPr7zWU6LVZ5lqRzgvWMgbKrLD8wgRl0haLxwSajidrn5YH6lru9XWdXavKvJPrJwQI/L0tVGhXvZt2NJVunAb8los/p2oyfDZ0co3LVQF41rxyO9/Sng15slPMBo+Fi/QCvYU8XMq7L/pLnJyKG7NKd81eFfix8s4roaqf3gDvNamCAvmPJJ9MStnV+YvqbbsbPnX4Y24st9kxPq/MSun/8DIMtZIvXNE3MJG2aHXtjZicW51V2GTR+fVVbDjRThf3l4ei0WwhW2fjhQuoB/ux/M5ndgNKbMEHDDqML0vWs18SMprLcL47SbXwXwsFY70YvI2wQvUmYzUN73S4HpYn0G4NgBp5NZkjl3Mf8coSRAI60+t4LHu5zd7fuMFc7VoZXmxVWejwXyqESQHmsDlrQnbVMwOPxeQj8pYKEgq9yCVNoTqM2Te0mxzkHk6AhgfHQNqsmV/ISZ6corHEslCFnRL1UoMSTUra7PX97QExQB8wfAMVf7i7eytTm2bmimiiTTTNy2dkCR/LsEyeHDKKWxeEZ3hA/G6XoRIuZysvuAMfa6SMUDxFNS+KWLp5ugJdEarR4MKeCMc9n5ZMiQwlgSXB/T/TmsCRSd0IKiUwl7M3m85eRjI0C3Qk1VD4M7RJkrBmY2clRlrWIj259mj6en8TGW95UAQd/N0cB1mMU3tPsbmcCaeqgj6wvgAOkfi0SumsL12AEu+AWlNw57kXWqOsNDza7D+dyeN7+zXLV3bz6J+VE2U/3A1Eu2j8uF7rGUYsO/j/cs0D4Z6DPxpJPkbjuyMR10Ry5eFzYbEjQ1AN2xvY5bllRygGqfKCOk3aR0/CgnqROLeYBV7KoCT3UuW3M5ZUgrlhVuXCr4nRZwjJSLK1VrDEsf
 Ce94EG9n
 o3N3qPNjFnHgwtnOva1iGkQl1b9a8ja5ql/KreDQQzg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 10:10:03AM -0500, Liam R. Howlett wrote:
> * Alice Ryhl <aliceryhl@google.com> [260105 07:42]:
> > This is needed to inline these helpers into Rust code.
> >
> > Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
> > Reviewed-by: Gary Guo <gary@garyguo.net>
> > Signed-off-by: Alice Ryhl <aliceryhl@google.com>
>
> Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>

Seems straightforward enough so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

>
> > ---
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > Cc: Uladzislau Rezki <urezki@gmail.com>
> > Cc: Vitaly Wool <vitaly.wool@konsulko.se>
> > Cc: linux-mm@kvack.org
> > ---
> >  rust/helpers/mm.c      | 20 ++++++++++----------
> >  rust/helpers/page.c    |  9 +++++----
> >  rust/helpers/vmalloc.c |  2 +-
> >  3 files changed, 16 insertions(+), 15 deletions(-)
> >
> > diff --git a/rust/helpers/mm.c b/rust/helpers/mm.c
> > index 81b510c96fd2692dcb7ab4705f790bd3a41a630e..b5540997bd20d4398e2838956ed70b2fb61c5661 100644
> > --- a/rust/helpers/mm.c
> > +++ b/rust/helpers/mm.c
> > @@ -3,48 +3,48 @@
> >  #include <linux/mm.h>
> >  #include <linux/sched/mm.h>
> >
> > -void rust_helper_mmgrab(struct mm_struct *mm)
> > +__rust_helper void rust_helper_mmgrab(struct mm_struct *mm)
> >  {
> >  	mmgrab(mm);
> >  }
> >
> > -void rust_helper_mmdrop(struct mm_struct *mm)
> > +__rust_helper void rust_helper_mmdrop(struct mm_struct *mm)
> >  {
> >  	mmdrop(mm);
> >  }
> >
> > -void rust_helper_mmget(struct mm_struct *mm)
> > +__rust_helper void rust_helper_mmget(struct mm_struct *mm)
> >  {
> >  	mmget(mm);
> >  }
> >
> > -bool rust_helper_mmget_not_zero(struct mm_struct *mm)
> > +__rust_helper bool rust_helper_mmget_not_zero(struct mm_struct *mm)
> >  {
> >  	return mmget_not_zero(mm);
> >  }
> >
> > -void rust_helper_mmap_read_lock(struct mm_struct *mm)
> > +__rust_helper void rust_helper_mmap_read_lock(struct mm_struct *mm)
> >  {
> >  	mmap_read_lock(mm);
> >  }
> >
> > -bool rust_helper_mmap_read_trylock(struct mm_struct *mm)
> > +__rust_helper bool rust_helper_mmap_read_trylock(struct mm_struct *mm)
> >  {
> >  	return mmap_read_trylock(mm);
> >  }
> >
> > -void rust_helper_mmap_read_unlock(struct mm_struct *mm)
> > +__rust_helper void rust_helper_mmap_read_unlock(struct mm_struct *mm)
> >  {
> >  	mmap_read_unlock(mm);
> >  }
> >
> > -struct vm_area_struct *rust_helper_vma_lookup(struct mm_struct *mm,
> > -					      unsigned long addr)
> > +__rust_helper struct vm_area_struct *
> > +rust_helper_vma_lookup(struct mm_struct *mm, unsigned long addr)
> >  {
> >  	return vma_lookup(mm, addr);
> >  }
> >
> > -void rust_helper_vma_end_read(struct vm_area_struct *vma)
> > +__rust_helper void rust_helper_vma_end_read(struct vm_area_struct *vma)
> >  {
> >  	vma_end_read(vma);
> >  }
> > diff --git a/rust/helpers/page.c b/rust/helpers/page.c
> > index 7144de5a61dbdb3006a668961cd1b09440e74908..f8463fbed2a2670ddfd4c23dc922b46b0913c3a2 100644
> > --- a/rust/helpers/page.c
> > +++ b/rust/helpers/page.c
> > @@ -4,23 +4,24 @@
> >  #include <linux/highmem.h>
> >  #include <linux/mm.h>
> >
> > -struct page *rust_helper_alloc_pages(gfp_t gfp_mask, unsigned int order)
> > +__rust_helper struct page *rust_helper_alloc_pages(gfp_t gfp_mask,
> > +						   unsigned int order)
> >  {
> >  	return alloc_pages(gfp_mask, order);
> >  }
> >
> > -void *rust_helper_kmap_local_page(struct page *page)
> > +__rust_helper void *rust_helper_kmap_local_page(struct page *page)
> >  {
> >  	return kmap_local_page(page);
> >  }
> >
> > -void rust_helper_kunmap_local(const void *addr)
> > +__rust_helper void rust_helper_kunmap_local(const void *addr)
> >  {
> >  	kunmap_local(addr);
> >  }
> >
> >  #ifndef NODE_NOT_IN_PAGE_FLAGS
> > -int rust_helper_page_to_nid(const struct page *page)
> > +__rust_helper int rust_helper_page_to_nid(const struct page *page)
> >  {
> >  	return page_to_nid(page);
> >  }
> > diff --git a/rust/helpers/vmalloc.c b/rust/helpers/vmalloc.c
> > index 7d7f7336b3d2f5a32e6a2b6cf8407da37775cfd9..326b030487a2b2199283b64b3b427e57cf5fb14a 100644
> > --- a/rust/helpers/vmalloc.c
> > +++ b/rust/helpers/vmalloc.c
> > @@ -2,7 +2,7 @@
> >
> >  #include <linux/vmalloc.h>
> >
> > -void * __must_check __realloc_size(2)
> > +__rust_helper void *__must_check __realloc_size(2)
> >  rust_helper_vrealloc_node_align(const void *p, size_t size, unsigned long align,
> >  				gfp_t flags, int node)
> >  {
> >
> > --
> > 2.52.0.351.gbe84eed79e-goog
> >

