Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC411D34097
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 16:17:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4B5B6B0089; Tue, 27 Jan 2026 11:17:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF81E6B008A; Tue, 27 Jan 2026 11:17:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA9FB6B008C; Tue, 27 Jan 2026 11:17:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 959716B0089
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 11:17:31 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5C27E8AD0B
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 16:17:31 +0000 (UTC)
X-FDA: 84378249102.05.A38A1CC
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id B8B9D40009
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 16:17:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TXOmsv3l;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=opTNLmen;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769530648; a=rsa-sha256;
	cv=pass;
	b=CNPLcT5GNaFz6Yvn9Ir2SpdaUfHimVXfIU/jRuRhMRSDl8FVo/3tjJXuReAFU0SgJT2O8d
	6F2z9fGeV/O89/orbfDHhCC7A/p7sVRIF60YfWDRrK0ZaQQO73zk5MAxLZzzSuuPvI5kts
	Q+s19bqBqzyb5bOWFzkV7Sd/7Gak4Wk=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TXOmsv3l;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=opTNLmen;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769530648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OKHSLDxRoTP0O21CGrHG30PQSZORZgUK3s69kGq/Nq8=;
	b=4mgygXD+ydF6Ui19YLx+i3/0/Y980zN74MvtMSsuFxzRsdLqdHJogfZKrUpWcXs6TArIFY
	4QLCD+kiFR7RQ4wkIvlgaW7laAU2V/toMBdSUUw2uZJzAYcjUkUa0BKwUG/4O8gmaMcsXO
	c9ftXc+eMfUMOXf2oMbARuKJsb57Dko=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60RBELSw3280520;
	Tue, 27 Jan 2026 16:17:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=OKHSLDxRoTP0O21CGr
	HG30PQSZORZgUK3s69kGq/Nq8=; b=TXOmsv3lIjuwSByiKJUWOTBUI9QSX1ryHs
	sVIrV4KZETm/5YDsU+7guwzc3tMngN4Bwt4OzwM0DM0BozcIVCYItUYECqauF0JR
	X/xxhDBmnqTxv4P6hBHYPaop8QHoghJlrRDF/s7eH4hoAKBOIaJ3CWhuZKhYbyI4
	KTM1AiXhodxMY1+LXJRNO3nrwxvA4SM+QSLI+O0vt/vDPTbfrscoucy0EGeSmiWu
	cCsxB5DW9q1LzzpAfQgJWczCs5/rrwCS0mI3ThfZw6aGgAlf23OFUgIHpx194FRJ
	EbYiQSYwsw/j1iRP6sBdkCtKo/nCqjAPyIYTeesr7kRZzHM1fZ8g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvpmrc9vs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 16:17:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60RExua7036177;
	Tue, 27 Jan 2026 16:17:18 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010063.outbound.protection.outlook.com [52.101.193.63])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhnwgde-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 16:17:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YawpJ07oEZ8w4HQLCIh2LJGHr+EGQK5YHUKU3UjpKV4U1GM/H0bZpWOb/Dj7yWEIyxKCCC43D7a14i5WcS+bLLMyYNoLRJAkbuT3HpjhY5GTAVXAnEBrnNwumw3hcWTtVXIHETPmwCf24hhigbDyvEX2vMPjgEbCxXYQZGILNyOGqDHhUxS/7c+1vWMdeoMn9hk/fsWfHri2zGqVRB9aACEs8myPARVUOuuPxiJqUkxeMQaRg5U1awpn5iidDbobgSPqD8JGx+Lk6HQWi/cHZvBCg4yF8XNgGzBcmQY+Nu7N1Dg0+Raf/sw2AzidllOsiwehMD7nRANw8ZCYHie0+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OKHSLDxRoTP0O21CGrHG30PQSZORZgUK3s69kGq/Nq8=;
 b=Lk25NjNaFfDOYdHFQldPIwXm83WwATULBV2NK8cFZOVzCfCBo3UHkREblIenqJzB3M9m7yLquaP6E0fnnXsnHnbyBkp+kfLNGWmh+fELolCZetdKJHu9dNvXbwrSNaRKVR4J/STH1rDJSBF5KxytvubUGJs0xr7jtu/qH/8wMEXiH0+r4UIyXAxOoyMiEt3wpS/nv35/fAMCtUtAm0Ol6qLI7/x3wR4CSBKn27fcKPRcJlwRtse8Q30wt0j4grCF79o5eLPjdVoTi5NWdvEFKj15LaLvCgUSFTexn0w1VfbFopN24cP1EL803LrlCQ2Zg/zotr+Z4xAQp1+x6dTKsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OKHSLDxRoTP0O21CGrHG30PQSZORZgUK3s69kGq/Nq8=;
 b=opTNLmen3QahGL5zBV3o0hvEcHFu+gReF8hjgzeCiejbD3VsJazTeSH49MbFIUmo3noxLEfsJCuM54AB4uqE7KHgLCuADtwyQKQYZH0szYL981nZ/XbwohBSja4zCa0vsqAI/YTgsHbibtYK4sGMr0AZTT/CcW9O2tZc2aPMBAE=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by IA3PR10MB8300.namprd10.prod.outlook.com (2603:10b6:208:582::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Tue, 27 Jan
 2026 16:17:15 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.015; Tue, 27 Jan 2026
 16:17:14 +0000
Date: Tue, 27 Jan 2026 11:17:11 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
        bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH v4 04/22] mm/slab: move and refactor __kmem_cache_alias()
Message-ID: <xvdhietnpfl6ait3kjwxu3nrrzdpwvt3zp5ui4l6o7t7yps55g@wygbtepochfg>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, 
	Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Suren Baghdasaryan <surenb@google.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, 
	kasan-dev@googlegroups.com
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <20260123-sheaves-for-all-v4-4-041323d506f7@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123-sheaves-for-all-v4-4-041323d506f7@suse.cz>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT1PR01CA0140.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::19) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|IA3PR10MB8300:EE_
X-MS-Office365-Filtering-Correlation-Id: b904aac4-cdf7-4ecd-54d0-08de5dbf88be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007|27256017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CLSm88rvjDbI8AFOM0VzqMW63wzQOouBYfEXFt5YxHMT9mrdtb2Vq2grXDJq?=
 =?us-ascii?Q?Adb/YSB6jpP7S+1nJLsIkXILETD5ubxDb/Sybi+FVHaScALTdHpUWon4eac9?=
 =?us-ascii?Q?ntEKlKzOsPzhJyy/+KKE1p7p/v/BtHakQWO+unpJuwtcMg0Oy+X1MDcKM4rp?=
 =?us-ascii?Q?Cj1Gxqni0iDCeaVBZ//WohTeP5Z6Wsu3kx/9pFp0mNF2en0kvZa8patWTO9N?=
 =?us-ascii?Q?2w4qqCfR1M08MJaxFjqKaBHsPeLGhiQRHpfH1JAhbdYrnSASxjNurj8uVnlt?=
 =?us-ascii?Q?D9wVZC94QOZrIw3d+OqqWRtrL9kMLItZLzc6j3ncu+sknsuwm8DEi1lxxA7t?=
 =?us-ascii?Q?YpVq7cZeqX+Q1+zQYITQWx8FCr7JMl/iJ5BAbWl6Ib6IL2ekCfTptEz2qwxs?=
 =?us-ascii?Q?GbkvBTZTA3ELRK6XRAoGKhcebz8eMaL9evEOHdV18DDikkgxXmYeZd/zBFtS?=
 =?us-ascii?Q?l0Jtu5yhUiwmAj8sdKkGR/fh6MLVbl1E/BXsaR2rNjNEhbWl2JcL8+bymnrv?=
 =?us-ascii?Q?DsiDLZse5wp24G+ljncCwUYtUSRay42k1exyKgVeVDJi9eoB5IyHPknz7KFF?=
 =?us-ascii?Q?+u7lzE/vGtnOM39hQnMeYGvV2kE+NmL3Xra6BfS0hCtxo641Fhm+f7FuKWYO?=
 =?us-ascii?Q?NNaDLpcWhtbW83MNC9qm6oiFLtkWWbJaHzHZinIXYaipcXdsvlVu6sE5XqtW?=
 =?us-ascii?Q?+U601R3yi4bRDQNB6NL98Y342NS0etSCCYSckPAdf2G4hBeB4ZWBvf7PyVWc?=
 =?us-ascii?Q?JfrAdkSInREh/D8ZMzMQDzRqllXCf5L5+18XrUkSbe06ZXI7T5wQI6/yzvAz?=
 =?us-ascii?Q?+i7XDiyQ/9adsdt0KhMiSL4UXWkwCOW3YmjOvVgXK3AhbSCLY4UoQVPQR/sh?=
 =?us-ascii?Q?iZ0bZwfThTEYLYB3CimGgCkP6Uf0K7RNB0qOygvOCLWJ1neu4PZ1WgSf1v96?=
 =?us-ascii?Q?v3qHbC/oqMO3gxHExbEKl8Uik42VTVfKvmumilFGA3GT5DYTwAgdk9mkZH2Q?=
 =?us-ascii?Q?V+Al1w0BbfJj7HOxtmthEQWF1kIsQUYQxJiVOgop/Y8dQm/x/+tQwc6IJ/xa?=
 =?us-ascii?Q?tbsLWxk4XjSjG5fn2mkKKvNRDNVmWXqZqv+89vezB2Z5QYY7LbBG1BbOPx+T?=
 =?us-ascii?Q?IhG1wrI/HdPnLSGJhEyOTEB4a54VttY/gBqjXNR+pa30ZrTPZjEZxzBGfJcW?=
 =?us-ascii?Q?Ra0QCiS6m7cV3yD32qQ5mm3/ehBF8gvpCiLop3y3stwCEcVRZPIANzH9vhqX?=
 =?us-ascii?Q?c89e4XK1h1fPHWnh50UOn/i41D+RExY+JsgjnyYcsiuknLWYZKWn11Pw7dM/?=
 =?us-ascii?Q?Ct9ElXqJV7S0VqKisbWJomCFq5ke4Iafnuo80vXoW/5kY4ZYIEeI70ZvDz58?=
 =?us-ascii?Q?gFGy5b+tuxxQ+yG3sXPB8Yw1rYwmbU6fCbuDr5+MaOwqc+df0TkkClHE6S8k?=
 =?us-ascii?Q?X4mHkCi6+1LbLX/AqIVwiGmks1Q8X/fwq85Ej+DbQQF56T7SrtvCD+ucFLI0?=
 =?us-ascii?Q?ejiqC2eCK8FvvJeIOwy1vwceq28WbQPq4IkvSebYyj5NPYm4t/bJSW0dRifW?=
 =?us-ascii?Q?tzIVwxCLIVwuuHifC0eLff2gYxkUB5hLaHL+WvErkMlpaJt7V74LgZrpy5DK?=
 =?us-ascii?Q?Pk33ZijlWrVRw0R/FxMBMHg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007)(27256017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?X1DIaSVUmv7JaTRLD24gJKabYAzTwIotewX+s8R4CY+R/8z3WkLORvyDhwuz?=
 =?us-ascii?Q?M/LRGebkOpu4p2ENPq7CCtkLsgwOCfb+O+sPoDBuxpkME0+5YPOMg6D4lZc8?=
 =?us-ascii?Q?7gMsM/z+rXbqU69BsgPcLt+t7YQRr4IyRwlU4/rYNqCwAABhkGbKWe/2+7hc?=
 =?us-ascii?Q?6umT+lU6p+yy4p51Xn+oU+csxCiFoiIf1baZecU1TXSyQLNuFxHzBGKU/83Q?=
 =?us-ascii?Q?eMbrKQV5IwMiE3P+ip/4SevrLSlMuJMuDIJNucnrTlfzO83e3Qoa9CbQCMF5?=
 =?us-ascii?Q?VSPhtjJh6Cip4nmFo1FjQ7G3L+jw3dXziVUyM/arMv6as192ggPgZjWypS5k?=
 =?us-ascii?Q?8cPawipWOVkx7yMAs37KiY1Oo7GD/H1MiCkWh3W1iPhP8BfZaqv5KSQGUh+g?=
 =?us-ascii?Q?LNkskiz+TLD0gm6/g1dxSJob0OdPQo6qUeQXK1nAEqAYJxadDXhP6Zj6a6Kt?=
 =?us-ascii?Q?MzGF0kEnrt16OCV0qz4RDABJ3qlimkhE8PipuQdzTbyHs/xjknE/LlFcykli?=
 =?us-ascii?Q?rX8w5vsh8ke6luE/Yim9wZHz8PiJmKrY6ZdEjCNvx7OFRfsVym5mLlRiUz2K?=
 =?us-ascii?Q?7wqRKCcnU0idATfNHB7LMFX68oV+U2W4eCuqEvZOyjjD/cXEyUkqPrlyY5Wg?=
 =?us-ascii?Q?sUtRuIjO57fVZsAam+9RgdkPgDeTjw5WOGeMj08t0EUfjznVpDnQwQGJpAyV?=
 =?us-ascii?Q?tT65KC2cQYqb7JmCX6ByLNqcJXw3Wsr0ONOjRHxZNlgDT115HYzDeXAlLzgA?=
 =?us-ascii?Q?KsVz5XIhxFCo+/kj48LbShI2kg5zgT/f/Sw5QXjO0BGDyLxY0V6VZtS+bVEO?=
 =?us-ascii?Q?VolgQyob/7uS4dDO9Z8da4xSg7N+CkN9LeV/CYyvdENav7/SbcF/Ks07o2Q0?=
 =?us-ascii?Q?zcPc9Yq8G61dM+rssyC+xZTBYNrxzEMtMMmMH4p2JVOgiWZJPpVRTGYVFYcs?=
 =?us-ascii?Q?CT3rHfxCtogMw0K9CqlMeVrR7GkzaDgnJPnG98IGOl5alZ5XKRhAQci4P/OT?=
 =?us-ascii?Q?25rNxeW6q2Gi+/xIt9V1bvx4fMsO8OpBE9qZQwpwz1elSwXez6UMmGe9uIqt?=
 =?us-ascii?Q?swWjXTS5ac3jun+LoGCV81V8AmVPeXfIaxEN+C9xyExjmEIAKYtBUlZqclHK?=
 =?us-ascii?Q?zE9Xxe7YWJ5XvP2D3an7FxqtAv43LVNk9as0WIZ7sCn3H8WGjAmXYskTMLqv?=
 =?us-ascii?Q?8WmeqLNfNshwfmQnIY7wA7cEWBUJLjjLlP82B7DaV97UnHeXUu+Md7A+p2xQ?=
 =?us-ascii?Q?yZRSjyEVHcdPngV06PdE1Y/YoNGpgeiFnMNyYMDnpVT9YEAFwKx+VMEJYgEC?=
 =?us-ascii?Q?iBrymvHG3cOXeMcvBbYQDYPVkMcv7tojkvmK/6q8RBOBRiN6zUX0k2z5HEgm?=
 =?us-ascii?Q?SRzJ1YTWmgC1ISFh/8yqNFTLxPXYkFeBFp6jhOCPtggcMrvHKkIZsZI9oJvF?=
 =?us-ascii?Q?NdGednQlVoP+HCvsBrUAxcgF+TqvtMl76+0jhLydwmznExECGyYGlKkfPLY2?=
 =?us-ascii?Q?B/HKeJnirW9S215bsEKORDarJ/gxdWNceD13LX97RvxIfSh0gOdMWbSUrXI3?=
 =?us-ascii?Q?0D/b/t4nenuBTMKZ/UzHBttdu8J1zZ+Ytq+XpgeE4cIP3OW3L36DakPqLnwZ?=
 =?us-ascii?Q?dl/AZaUC4+94hHIMKMEkkfaI4xplZaNpGxruOdb2WMSKfpGIx7B99poTEPKt?=
 =?us-ascii?Q?farINXQgG40mik1r41L8OZZBhSiG9QA+hIfZEBvWlbEc/PTo87cU0l8hPh4p?=
 =?us-ascii?Q?kfzZXmO8zA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	79E2T0mM17ycWCBlF0Xo0nUyvC1BkoldEZUc26/JapnMghSE4BwzXein76GT03DM57pP0FK8XfiFZmXTlKf9wULU2NqO8PPo/egNu6bGJUOEr5zY4P13uxLFNNLoMNQDjuN5PWQFzpuVZaGxUxHnX7UiNRb+M2teHkjju19bHHQ6Sm/LER6HUTRbWfB2nwf+RON4UvEL+pnJyT9oVFBkqKwbDlgoNsMKv6eDD98+PZsa0RmKJj4Ik3H04ssM97PuD0uP3Y0lT4sUsSxcRqtbndF1DX/1w6lEhKq76PdMCWxbfp3FSQ0jVJ5GdcJq5P03uWYgNR0TUfS10YDT/eYJHMF2WOIHohztrG749JWZHfwfNQ8Hycq13ZvpE0v6MBkW0WKFMquyJAV8+3HeBz7tt+/mYisfKicT2Aja1NvAJcfNUCA034Tqt3NnlMRcKBQJZ7cgdGeHf3X0lGpPFzuSp9Q0yY29NfSL29RiQRzXoQpnkdH9yj6VRwPGnFEebLzxuNsw6Tw3SDb+6f8F7Sdh5DxZdIZYKeIOlKyMRcgQDMKltss2PUx3SW4LaG9HMVmTwVLFuXfbCx9q5LYHMJkpYPRb+9efmYXmKVcH4Vy/YJA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b904aac4-cdf7-4ecd-54d0-08de5dbf88be
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 16:17:14.9336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8hVZiDPtViPjN1GvBat+NZIBCeHviwCGPxmXAyRI9KM3f8vpEh1vihz9x5XS76S4GiYT6ChFpTUNZabm78Fxsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8300
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-27_03,2026-01-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601270132
X-Authority-Analysis: v=2.4 cv=Q//fIo2a c=1 sm=1 tr=0 ts=6978e510 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=vatuI3SuysR0fGYlY6kA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:12104
X-Proofpoint-ORIG-GUID: HnipPC-KP78po4qnQT616jaAQ50kq0R8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDEzMyBTYWx0ZWRfX6koh6F11Aai4
 8UjWztBHQ0oUzszz+nIKgKUGPJhrWNDcRvZIFcJiMTA39owXPW2v0pVkv2NtVvS41/uDeFxKaOO
 VjSK9QwElWLUjcA/3NZIh/rnBB0vJATKj+uCbdDUcXvLEogVfBxFeuDipUHeJK5qtxJpzU63uKn
 FWrhOqU0z60OHX5pwtot9C0IAEsyPrfWeve+wFLAnj+bZ3xMOeorLXyF58+yDTWr4IFrkV6dspY
 G7wkHhiI4VpREdQuhoMh975/qN3R4Fy1TVnuNj9tb7i8NbBYsBnR+zsU9ZRlsMF1Yi6swlUb4h1
 2VKy4mf3BpFEKvh0ecT7FYI2Tlglv23eWukrv1eT5M31NuDkF4YNT3A8O+AYN/4mDy9P5+6hC3B
 QyVgyswmCq8pEcGe5IvGI/C1uJ1t38zFMRb73BYSp/cPDnsklhjT77HMgJxc1jZzakQclhiCZk7
 OeRBnki1KPzKEIImxMAtGDGelgL2jdXPF5cUgWyA=
X-Proofpoint-GUID: HnipPC-KP78po4qnQT616jaAQ50kq0R8
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B8B9D40009
X-Stat-Signature: sdc8ziua5pgi4amgt61sc9qp59x45m1r
X-HE-Tag: 1769530647-50967
X-HE-Meta: U2FsdGVkX1+4iCXv6B565ne5+J2YmF90WNbnT7URgH9RGgWx1pUWvymFg8rmaQk6efNMlZKD4/Izr4mhob3zkHAPCiPQisdr/M9kZV9kXbIsUsS/fXg3943HiRByTz97Tk1dAtAWmXxEHmJfVgsc2Y4IXr4VELIHFBNr3vUU5WGfZBwvrw3e8MRIQamDhJ4dQ+Y+2qcDxOzj9GWBtmD8FIy2GMLUT/MfV94bY2Do/6b0r/UBzBg2gFVmMcIKGuqUMW3nHiOWUM6UuibLJp4uzrUeihLrzELa2uxkO8txwPAV0t1gQ9eZcKiniHK2ZUumbbFiHEmcLr07V9puUbSsvcvqwdidMQ4yTrDoggKjugjsDr5fKHhTwsF7z1iden67JVeiAUrWb9bnLkPtLP5zAQmYXaTaAEEQ6RRMFuHNO/Uem8ZV3X+NyfmFxwpCw7PrqrI2/8gmEqB5Q+aybUrspBrnVWk9XC4mDvjOriNxXLbsrD7ISuSbmoT4qqBErPENClZd1bywqK539SLp8hU6NDGR5lDb5hqlDResdLD8VoU/rhX1/j1lBZIYEe3YdekxiRctc7ViAHCItU0SL/HR3JeT9ZTCkCyqKHT3DSmFPKAA/dNxR/aP9GiBDxVA3ZlL7V5gqMVBGauu0Z40YhkUlzeZEDStQ543j+sl9ZxymKvXf+dkJ22C7sdJxl2h1uFHfUcA0LWTPc7f/UIw7+pt290eAKo7EczOFMOQEVMBpRgA51drlVrgkMa5HuRUo0dDk9E3mDJP4V0D4QnY5tzqHvMCGtUCqux4LSYS+eqcIN072eOf6EGVEinoe9ojB/bQ2U3ecGleZb39jewjPRJNrzVbOyOKeHpzsC38+imxLiRLGss8PtmQL0KHUekWb0zue4y8L9/nEY0Bdye2aR+Kl7FuCV6tu5e2C/v5Z/u45FBeNvMn2nws5yslrD6GzWvIIFSgnzf89oNd65re2Nv
 St0vFf/H
 R07DsqKzapjyeNXPSs+K2V1xYx9kdOxxSwXD869XsXzFUPuAv/rEIx2YYN2YcGtG2M7lecLFZgYAx++4zrumwmm5qhRWewZSFCbv0yIgUPWZkIH7B56egnvL2ZTu2iY+lSCw0MCeEcYLP8RbecLJVefS8eG6P8eHdK/eRLTuJdK9drLKTZDPwGgt8HH1deH3oijrniQRn5i0pPfhO466ew/+ke0XYU+HHwDPpbjBkEJ/Ud1MB2pX/8/F8h6qzam515AM+7eCB7667ElUz7LJo93nvCbtYnAmD/eNGLlhrqYU/gBi41R4R5R2cQmaHQqjBt9e7YKkL/qkhnUmS03wcLZFjnMAn64K21TZXVtHeGab9hSHMh9vp2w845Y16WPEANRcBIn5YII8W4cgGYy1P01OtUaGOupEfaDqMT+wejLSak3V1S6PUvCEju/235C2ag/JqgbqA/L6EHa8b3vLdSTGmXrjJsia4AYadvH1y8cSvLqEqhF3RUgzQFPqcqd8Z547FHHh0o/1AlUjU+zZ9bYMkdmHMWA5yvd8/9zu/jUHy0rlp7gGWZ0DQY6PNsFNxkKkDCg1y+VIr84pMrst1cQT/OuiJoXOkhqTrMuxZpicf7ie3btn1DSsDQkmJc76+LbRivPqi2FNW/USOjYRQfaA0Utp3sFBlPQBr823RnsS+b4GK9ElRd1cUDGB/OKm0LKbdsARsP7rdhRFdCugvdkrkWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Vlastimil Babka <vbabka@suse.cz> [260123 01:53]:
> Move __kmem_cache_alias() to slab_common.c since it's called by
> __kmem_cache_create_args() and calls find_mergeable() that both
> are in this file. We can remove two slab.h declarations and make
> them static. Instead declare sysfs_slab_alias() from slub.c so
> that __kmem_cache_alias() can keep calling it.
> 
> Add args parameter to __kmem_cache_alias() and find_mergeable() instead
> of align and ctor. With that we can also move the checks for usersize
> and sheaf_capacity there from __kmem_cache_create_args() and make the
> result more symmetric with slab_unmergeable().
> 
> No functional changes intended.
> 
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

One nit.

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  mm/slab.h        |  8 +++-----
>  mm/slab_common.c | 44 +++++++++++++++++++++++++++++++++++++-------
>  mm/slub.c        | 30 +-----------------------------
>  3 files changed, 41 insertions(+), 41 deletions(-)
> 
> diff --git a/mm/slab.h b/mm/slab.h
> index e767aa7e91b0..cb48ce5014ba 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -281,9 +281,12 @@ struct kmem_cache {
>  #define SLAB_SUPPORTS_SYSFS 1
>  void sysfs_slab_unlink(struct kmem_cache *s);
>  void sysfs_slab_release(struct kmem_cache *s);
> +int sysfs_slab_alias(struct kmem_cache *, const char *);

nit: the names of the variables are missing.  I guess because they were
missing before.  *s and *name,  I guess, although they are *s and *p
in the other declaration.

>  #else
>  static inline void sysfs_slab_unlink(struct kmem_cache *s) { }
>  static inline void sysfs_slab_release(struct kmem_cache *s) { }
> +static inline int sysfs_slab_alias(struct kmem_cache *s, const char *p)
> +							{ return 0; }
>  #endif
>  
>  void *fixup_red_left(struct kmem_cache *s, void *p);
> @@ -400,11 +403,6 @@ extern void create_boot_cache(struct kmem_cache *, const char *name,
>  			unsigned int useroffset, unsigned int usersize);
>  
>  int slab_unmergeable(struct kmem_cache *s);
> -struct kmem_cache *find_mergeable(unsigned size, unsigned align,
> -		slab_flags_t flags, const char *name, void (*ctor)(void *));
> -struct kmem_cache *
> -__kmem_cache_alias(const char *name, unsigned int size, unsigned int align,
> -		   slab_flags_t flags, void (*ctor)(void *));
>  
>  slab_flags_t kmem_cache_flags(slab_flags_t flags, const char *name);
>  
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index e691ede0e6a8..ee245a880603 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -174,15 +174,22 @@ int slab_unmergeable(struct kmem_cache *s)
>  	return 0;
>  }
>  
> -struct kmem_cache *find_mergeable(unsigned int size, unsigned int align,
> -		slab_flags_t flags, const char *name, void (*ctor)(void *))
> +static struct kmem_cache *find_mergeable(unsigned int size, slab_flags_t flags,
> +		const char *name, struct kmem_cache_args *args)
>  {
>  	struct kmem_cache *s;
> +	unsigned int align;
>  
>  	if (slab_nomerge)
>  		return NULL;
>  
> -	if (ctor)
> +	if (args->ctor)
> +		return NULL;
> +
> +	if (IS_ENABLED(CONFIG_HARDENED_USERCOPY) && args->usersize)
> +		return NULL;
> +
> +	if (args->sheaf_capacity)
>  		return NULL;
>  
>  	flags = kmem_cache_flags(flags, name);
> @@ -191,7 +198,7 @@ struct kmem_cache *find_mergeable(unsigned int size, unsigned int align,
>  		return NULL;
>  
>  	size = ALIGN(size, sizeof(void *));
> -	align = calculate_alignment(flags, align, size);
> +	align = calculate_alignment(flags, args->align, size);
>  	size = ALIGN(size, align);
>  
>  	list_for_each_entry_reverse(s, &slab_caches, list) {
> @@ -252,6 +259,31 @@ static struct kmem_cache *create_cache(const char *name,
>  	return ERR_PTR(err);
>  }
>  
> +static struct kmem_cache *
> +__kmem_cache_alias(const char *name, unsigned int size, slab_flags_t flags,
> +		   struct kmem_cache_args *args)
> +{
> +	struct kmem_cache *s;
> +
> +	s = find_mergeable(size, flags, name, args);
> +	if (s) {
> +		if (sysfs_slab_alias(s, name))
> +			pr_err("SLUB: Unable to add cache alias %s to sysfs\n",
> +			       name);
> +
> +		s->refcount++;
> +
> +		/*
> +		 * Adjust the object sizes so that we clear
> +		 * the complete object on kzalloc.
> +		 */
> +		s->object_size = max(s->object_size, size);
> +		s->inuse = max(s->inuse, ALIGN(size, sizeof(void *)));
> +	}
> +
> +	return s;
> +}
> +
>  /**
>   * __kmem_cache_create_args - Create a kmem cache.
>   * @name: A string which is used in /proc/slabinfo to identify this cache.
> @@ -323,9 +355,7 @@ struct kmem_cache *__kmem_cache_create_args(const char *name,
>  		    object_size - args->usersize < args->useroffset))
>  		args->usersize = args->useroffset = 0;
>  
> -	if (!args->usersize && !args->sheaf_capacity)
> -		s = __kmem_cache_alias(name, object_size, args->align, flags,
> -				       args->ctor);
> +	s = __kmem_cache_alias(name, object_size, flags, args);
>  	if (s)
>  		goto out_unlock;
>  
> diff --git a/mm/slub.c b/mm/slub.c
> index 4eb60e99abd7..9d86c0505dcd 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -350,11 +350,8 @@ enum track_item { TRACK_ALLOC, TRACK_FREE };
>  
>  #ifdef SLAB_SUPPORTS_SYSFS
>  static int sysfs_slab_add(struct kmem_cache *);
> -static int sysfs_slab_alias(struct kmem_cache *, const char *);
>  #else
>  static inline int sysfs_slab_add(struct kmem_cache *s) { return 0; }
> -static inline int sysfs_slab_alias(struct kmem_cache *s, const char *p)
> -							{ return 0; }
>  #endif
>  
>  #if defined(CONFIG_DEBUG_FS) && defined(CONFIG_SLUB_DEBUG)
> @@ -8570,31 +8567,6 @@ void __init kmem_cache_init_late(void)
>  	WARN_ON(!flushwq);
>  }
>  
> -struct kmem_cache *
> -__kmem_cache_alias(const char *name, unsigned int size, unsigned int align,
> -		   slab_flags_t flags, void (*ctor)(void *))
> -{
> -	struct kmem_cache *s;
> -
> -	s = find_mergeable(size, align, flags, name, ctor);
> -	if (s) {
> -		if (sysfs_slab_alias(s, name))
> -			pr_err("SLUB: Unable to add cache alias %s to sysfs\n",
> -			       name);
> -
> -		s->refcount++;
> -
> -		/*
> -		 * Adjust the object sizes so that we clear
> -		 * the complete object on kzalloc.
> -		 */
> -		s->object_size = max(s->object_size, size);
> -		s->inuse = max(s->inuse, ALIGN(size, sizeof(void *)));
> -	}
> -
> -	return s;
> -}
> -
>  int do_kmem_cache_create(struct kmem_cache *s, const char *name,
>  			 unsigned int size, struct kmem_cache_args *args,
>  			 slab_flags_t flags)
> @@ -9827,7 +9799,7 @@ struct saved_alias {
>  
>  static struct saved_alias *alias_list;
>  
> -static int sysfs_slab_alias(struct kmem_cache *s, const char *name)
> +int sysfs_slab_alias(struct kmem_cache *s, const char *name)
>  {
>  	struct saved_alias *al;
>  
> 
> -- 
> 2.52.0
> 

