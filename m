Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F8FCCCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 19:47:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B5EE8008F; Mon, 27 Oct 2025 15:47:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98CED8000A; Mon, 27 Oct 2025 15:47:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 854BF8008F; Mon, 27 Oct 2025 15:47:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 70BE98000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 15:47:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1C9731DFF3E
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:47:04 +0000 (UTC)
X-FDA: 84044927568.11.DDEEA7E
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id B0DE61C0011
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:47:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XcDwxTop;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OmViznQZ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761594420; a=rsa-sha256;
	cv=pass;
	b=GJSLTwuW65qmHl2FUI0UDCnzW74KUucBvYeJh596saktmO2JbWTYXuVUEVRVyOw5g5hvT0
	DoOJv04I9URtwpi8gU8j0ncqFGUG3qAapadSWJKMz+lUg4DRsApASGccaY6lBsXC7lE4U+
	2Qc20mvZZSvoiKNc7NudBtmVAPtBwZo=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XcDwxTop;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OmViznQZ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761594420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NEOpglkz47mNlItP0BQiiPkA0sLKce4Q7GdJRaNLKNE=;
	b=pZEV+76MErGEjGOTtONDL+0iWcbfQLh6R0RwX9I5BsUyVJa6Xl/DfM7S8foZxs/Dqhph2c
	ygEtU4gxq53X8tYi4K11OoK/b+SbSnEgXdJVnXgzyh05ADECuJ7AZBuD29LaGqZriQ0CqC
	nZXAXhfZyhjtqDkTuypFimXQwmUat/o=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59RJXCiZ019640;
	Mon, 27 Oct 2025 19:46:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=NEOpglkz47mNlItP0B
	QiiPkA0sLKce4Q7GdJRaNLKNE=; b=XcDwxTopbsdxuonyz1hvQI6Zd3CLjka/rB
	1LN/AdA98S7wKlblofcCDXS5wL6FPjFW0qK2yKgPKaE9IeYqeq1kUznxX3m0Ut+D
	f+GRktqE+YiSBITM/OT99/h/i98YFuKzazSnJdt2INEvWaJNiaxxHU2+C1v5nQYg
	h6Vm5bMtwzcqzMmS92jXIN9kQGobw8Qny3BVKfdRQZfzlQV7OoydTxKOZ3qI2gbw
	AD1v3s5JfU6uy51NGhkVMTNpyYLDNMkqOrst+l7iMe4MqsVD/bZ40OrTAZGBMnXe
	6t8aAbR5h/eAV24+fVv3G7w1eXi9yYZ4vgv5dN+VcrHhs+wV0MNQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a23gvht05-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Oct 2025 19:46:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59RJDp8N025676;
	Mon, 27 Oct 2025 19:46:50 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013000.outbound.protection.outlook.com [40.93.201.0])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a0n07g3js-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Oct 2025 19:46:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wxGC32Hla+7FFKlkix7hTIKykKcRsV48Inqvta36N9V+cHpV8jJaqq++5gthD4jlMr2w0IpToVq0dTErkbE3MIszRpENJ9a2IqYkQsPwUrDKGJXj3LFwOlLL/IxSx1xl32YrWoPsNUhZ2LqdGZuxNFOpcK3EfhCpIvdOkDc32v3QQAectvhqF0KHAdX3CuaGDoUvzXgqwo2tjnMonsfmswS7Lmz6pLBcTNvT4MJ+2gIkaWyok1StZMpXVk2hNc5dNAHQA37pqjcem+O9cVAqhO1JidRR7kIXctsKpq7CIVpkpgghbtwnlRdbjHWB21hWkA1p1ln5dotR+HbWIMdl9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NEOpglkz47mNlItP0BQiiPkA0sLKce4Q7GdJRaNLKNE=;
 b=SLW8VgcLwwzgEQuTbfY44PK6g+PJQjiO34E+zmdQj5uzaTh2YmERPK1cjCHe0rx1azkSipdJD2lRPlNnDC2g0qMhRiouvaSfeiuL2RkudN8SB70JsrgpvxmTnyRoxKpMQU7vVgjTYr5R9v2b7glFznnnuOm+FyrgH4STA4GayDMpLy4geP2/AE5JntGTGrYjz6R9q5rKBEMGiF1HPrnjM8A0qZGO+sXcpcbud5urWgl+9I7pEgC2ykrsWyq2p2v5O5z2rncVQE2JiV0chG4PaRuCZnUGKoD0LaIBNDbEnxRV3O+doPvua3n3b1req605V4IPt2y25IpYNHWKJLNOQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NEOpglkz47mNlItP0BQiiPkA0sLKce4Q7GdJRaNLKNE=;
 b=OmViznQZw4yQL6aC4Z+YXiQPEMM6slGspOsrkrjlHIIxxvGarwHTkWNjH2XZu7dh4hdluX741Ci5dAVUSZJwGqy8xqAFcplMdNuckKFbq+Jsb/66QVLEy4MxBoL/Ecp1W3jjbqB47d0WPEgPVWW2OHTAdADHnl5N5dbNZ5YpD94=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH7PR10MB6156.namprd10.prod.outlook.com (2603:10b6:510:1f3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Mon, 27 Oct
 2025 19:46:46 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.018; Mon, 27 Oct 2025
 19:46:46 +0000
Date: Mon, 27 Oct 2025 19:46:43 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: David Hildenbrand <david@redhat.com>,
        Israel Batista <linux@israelbatista.dev.br>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-debuggers@vger.kernel.org
Subject: Re: [PATCH] mm: Convert memory block states (MEM_*) macros to enum
Message-ID: <3d3bfa52-3e13-4d23-8ef7-6cb8b1ab7d79@lucifer.local>
References: <20251026162156.12141-1-linux@israelbatista.dev.br>
 <811fd675-b231-45e4-b9d5-636fe63bde6b@redhat.com>
 <aP-2x314BKks2_N9@telecaster>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aP-2x314BKks2_N9@telecaster>
X-ClientProxiedBy: LO4P123CA0284.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:195::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH7PR10MB6156:EE_
X-MS-Office365-Filtering-Correlation-Id: 78bd6bd7-82a7-422a-09a8-08de15918fb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qLZDXo4FWdJfEXDBy1EwM8EUykmP+rEv3nZ2Y20HoM9pNNO6EeBrDAlwrLsa?=
 =?us-ascii?Q?0h8CwgA9GAXabzP5OEtrWNWwSyd3erEbVgTETczVjcBzZY+fE0YXdLTAsYn3?=
 =?us-ascii?Q?xyeyB0dwomH2fx78aGec34cff/erl2IU6zUuI25K96blMj25Dqtxf6ws71E/?=
 =?us-ascii?Q?0MPDZCjpGIu2m1SMQpn8EUAQzFhvNjHiyjaHUnoIMsN3XWsX0NIbziN+VZda?=
 =?us-ascii?Q?MgWvNau6m4VIYs90UYY1M5yIARjJmiQuT+Gn75V5qYLADiOMLTL+1FaXDQwT?=
 =?us-ascii?Q?Hr5XBpAPXup0S4Cz4hHRIO6TU8oEFvWgK1pRGAMzJBzhEHSOE5Q9RQAUL3Bu?=
 =?us-ascii?Q?ih0b82prOMJIgt7MwbOvdNiWkYypOOQsCXQ7VMhq/oJNLQ6UDNbX+NqPpb5B?=
 =?us-ascii?Q?cJ841CdufxCXYn77qaBJkYFonqZ9mitwQie8WmCTIeM1rDhRpyX77pdxxYVN?=
 =?us-ascii?Q?fBLrVxvQBDAVugTPaEi3eTbE4Gy+Cl8STCo2C77moWR72kEiwzmQ9BLx8NhH?=
 =?us-ascii?Q?29haTrc2vkOeAl04uZqGZwBp40PT0yn7x5ODallLkGy4+vxZ517MoFjcUn9j?=
 =?us-ascii?Q?ojs15rg4sNVZEx6pLp6AZtDjRQov3PVJ1zgQ7Kjkm63ZAP1pvNSDXNmgzwtd?=
 =?us-ascii?Q?E9dzYkF6CUvrt41+4ko0SwyRtIQWkiwJ1Ii8O43odUhHAJ/OJ7TaVyvP4MHs?=
 =?us-ascii?Q?Mu7EzxUlYPUhX0/WtuacIx6fUNebLX0sgd0N8CJfwJwGmXKmcqUCfVVwe6kN?=
 =?us-ascii?Q?7YBeVwaLVEgm9LlsX3OT8omdAc3/iOaU/5MCYCiXgDxqX09W1gReYb4IOaf0?=
 =?us-ascii?Q?9jwcfzfnMVS01z4rHcxpsfCWqBoJjv1NCCr0EWzHY4moBjdTUltaEs7CcQAC?=
 =?us-ascii?Q?vOGPlA8bcmubloadC5cFFunAWErTaWkIZmyLUBRVxgXdc1rWHoDugsWopXQG?=
 =?us-ascii?Q?luy6SBY5VRdNocqmlf3kNWuGRsPcWAYyS/puAAp+SixmbjiLaDSm1p3jQwX3?=
 =?us-ascii?Q?Qc5MOespwx08xwvInpLVSLdwNPuvJ4DPZhYeUgc/wNu9XB4/H9/9L/+zJknO?=
 =?us-ascii?Q?m3VqDgRB9ZE3F1LVJBOK9YjDUYwqZL8SoxTpAJFx12eKZVUrpcVR5sRv6yGY?=
 =?us-ascii?Q?zMKul5zyvDCWRNHhKk+jnCWbbeoM57i4wUwcsR97PrhBpJxC6I51Fxq38+Q5?=
 =?us-ascii?Q?tMIHou8Cylwp4J88lvt3ru152/jyCwsaP0+E7EEdv513ZrxfOrdDvTvHQvO0?=
 =?us-ascii?Q?qKBKM0WaKVtGouQYuuHSRypsAlf9+YP+IiHmEOlT7MOkAxVKZJvH9Picx3Yy?=
 =?us-ascii?Q?bYIYj8MAFIPexV0eexKUCNRVkImZzZ+Vf4y/uFdMr/xYbAstOIdrZqcKgYOH?=
 =?us-ascii?Q?IEkmYxGeQrVciLBeAly8BeCVVQi7JHnL6POvUVeNKi7nMkZm6tFCEPMalsLu?=
 =?us-ascii?Q?jdsfcEpchAZqEshBDP7+XoVfUy/TolZy?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kZEpl1ZwYKcteEsqPuuh1+Ddb7Vv5CZjpTygpQBQtzPo10pWhdVVUgVhKXoM?=
 =?us-ascii?Q?NuXz7Oro0Ni5MhLbFq4Qyky+zJ7bPL4MYHyFWBz+Bv7mxjyPd1KxvsRvVb1/?=
 =?us-ascii?Q?gkugSHfNv58q/796a4TjBj5LooEsD649hpwHwzcFsbf3SnI7ueo51xXU3M6H?=
 =?us-ascii?Q?4eIQZdOg1oN2uJwH6ZAzRJ6IOucZtVSTkg9kcTjXP321yqllGl6tXKhzW+yB?=
 =?us-ascii?Q?+5o+hdBh2soI5JqzqT3lnQxQqTM62kjJHC6sYfpipV9OQZA4rdE9iHk2S/dd?=
 =?us-ascii?Q?4Gg1NckfMfhdSoLqaNzqEHKi+tePFkUAVdpmx8jGGUfLMVv/h9JJ1Z+Bh8NN?=
 =?us-ascii?Q?JOtqtxcfkNe88KdsxnnzIMh1OcCBxrV/+lvLgHQKkjTC5lAx7ZqnSqjmERdT?=
 =?us-ascii?Q?X7qtc+ADc0R04ah0LfkEf9ujaFRc5KFXnd5EP+HsU7Dh9geXEAtfrs10affU?=
 =?us-ascii?Q?9iiZQz4xCgB6tmc82F9S9tl2Bmbmt9XeZ/ZjE8ZVZH7GNBLnSap9yKP+Jmdb?=
 =?us-ascii?Q?EnmBtba1Zp2sJc/dRiW+wcQLxjmWuiCkGzKa8SJKa8fcMyvTHMnOWHguUs3G?=
 =?us-ascii?Q?WLnjLysGsf7yhrVb+3VyPJD6Z8uHV/+/9vblyq908E/ZbsHsS+U/19vVNxan?=
 =?us-ascii?Q?7pG9A96PUTxNtLd5jhRRv2LWRUR7n2M0kC/je35zOux5Y1il/BqaH8vnemQy?=
 =?us-ascii?Q?Io2QIhzIs2lmDURnjfBazTT+dmtcwuGVT8KhlnBzw9jvV/U3tvLlwubvGLsb?=
 =?us-ascii?Q?ivhwoLYHOxCjpCXFvbkFABdEid6Kxz2Cd5rzOkTSA5CHP0FloDIv2R7NxhzD?=
 =?us-ascii?Q?41+WNQNYY6cVGa1rHzbtBLNGHU29HQADClvSwzAuO4hHSh3LLWh+0wlGf+L0?=
 =?us-ascii?Q?auwGcercwvGNRTUH0TP3LMG+Us4k0kVU7ZUuSyTqWLS81MuP2k4OjN0Ey+od?=
 =?us-ascii?Q?lv2pFLeqQVjwboXMsKAZocqWcO/QojVCfuhzeFO0H59cVYQUoIHPuT4k6Pw0?=
 =?us-ascii?Q?LSwAOlg7d5dl0YX7zxztwo604pPgIMoaAAX+Z84jJDtB65hGOxMWWpBkm7cb?=
 =?us-ascii?Q?M7GR1MEDtXjFSW5q2QzOKB5FJ/1LD8416E8huHm9OATugJOpJvh7QOCtyu7/?=
 =?us-ascii?Q?s/JX+b2KTsaxg4luyGT+GCDqMeniF80V68KIeIN+4fF4wtKDtZNvCvVKryto?=
 =?us-ascii?Q?q2Y1OXBeOpnhaT5dn7wRwZS/WAVsQvLruVhPIFcRO2HbiGbqYA9cSAByUezJ?=
 =?us-ascii?Q?w0dqzHuW/EH+c+o371yi8ksspyq1PRrHvV/rVHNC4eCHEt9PGg2KEVBW0l/V?=
 =?us-ascii?Q?XBXU+GH2oyDm31EzZEjho7QOcezY9oeYXN1bYDRfY0/vwCT83NHoV75PQhpN?=
 =?us-ascii?Q?Xq0pvdK7tS14lCW5BwC8zELb7FbO2p2escXdJcjWw88o40gJ3Qc4KwPx6b4x?=
 =?us-ascii?Q?lot5pF7Sq5iab8yAm90NSS2CsC5Y2HoZAj25ML/gLzID7aKcPWGn011wuIzE?=
 =?us-ascii?Q?nLolvr30dy0o0ZTk7Jl5ArBzcuaumSS/bQgP9vD5Ysv1L5yjGyD8nTA+iLeo?=
 =?us-ascii?Q?5bxb72u61DspAyRbv6le5/kyXgsFoGX9JlALFryclcm7JUxgQJZpiY1Rqmi1?=
 =?us-ascii?Q?Zg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zi+yEhRXGdVfpYbiaRfRJhQHDcW8haXHVVI4VewpFbWZzzbIhyZZGM2b3DsZoi4nPIYngjltKFTyZ+nxB6pmHle5klO85ws++7hMWjRnTf8EI6hZTwyLuQ8Th70bhysqMllFuxvRzFIAcYG7nkW0tJuSzga3AugmwhSfJYzuv+VRy7fQbo7zmrf2TRaQ9R/AHcP/SSiP9a5DrdO3pRIV09W7OwTC9PlX0vO9eq1j6UEQuDLmxR8/8zlhahoJJ6Qnw7MMBgbQb6/P4VAqr7ixuaFyPpVBqwrUbKx3MxU8Rlm9JpwZPfL/i1yDWVQ70WJsOH2kUVoaxVckxhn+w9G3vHeudg6OFZuY2KJH+UACxLy4i3cnvDi9wqR5vKNyxZ6cICpoVRoPB2wnlLExM+cI70rpXZIDA2IGtdYEhhYLw2msuc3tBJopj+/ChtnheaaVtKdqbZpxdPNKbNE1M+tUrQZvlsGujREyGSy3mNaCqdyaNPEKN2esYwWAZUYPGPCFIq3OHIr5ac/D3jvrqxA3hXksxQtKodDazjskHZ/vdxqcpvGcx639vEWasiLW2deEMCmcISMb1Vt92bhNm15Q47mgemXhMU2O8TlzrYP9CFY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78bd6bd7-82a7-422a-09a8-08de15918fb0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2025 19:46:45.9786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TyA7H1RiwHf9lOprg+iYhOmtJCfSF4HqzWTeid7lWeCQYdcNFnyZZAwhzKNz5L7sDlFQZSX/rCMOVMOFE6qtvyeFlOYBFwSFIHs9O+5yTGU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6156
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-27_08,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=960 adultscore=0 mlxscore=0
 phishscore=0 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510270181
X-Proofpoint-GUID: CdHS3MrE3pfYVqHvhIS1vBzXl82GS3bw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDA1OCBTYWx0ZWRfXzB0vSzU3aeFx
 w1tKoZmKV309A2MuxA3IlJM5EVVMWjR76kWzyiQrWy+wKKJs+KPf7tMiQ2tVzkiNhoRAfzy8sjt
 aciThhd6Ducp23/F0jRLibwVg/nEecppUvBMDUSM8ilK8yZuPdDiTm4wUMaF3BSORIbUe3HGBMw
 QEuqlyIavruGYtTleYUst1V+9M6+HCQbViTp9csLBLFxkebPBVTrhhwmkbmLvg5w32VpvjgMrDL
 J0r/lnngUM6M5XSLIFttfUzpzCJkCmf/bHe2kWbNDK5ZA5+QyrIZRckyapFlF8pClCoem8QDiuu
 SLPClrJS+jnxFzWJZNB/ZTSJeDKALbhLty/cYIyS7XF2fvxDIvp6uWNWcYxT5gv/Befgu4pgrV3
 i+zsXi1gfIUA1m0SRrocE7LJzs7J2g==
X-Authority-Analysis: v=2.4 cv=HsN72kTS c=1 sm=1 tr=0 ts=68ffcc2a b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=YMJ4S7zjzT1Txv9Q5fcA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: CdHS3MrE3pfYVqHvhIS1vBzXl82GS3bw
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B0DE61C0011
X-Stat-Signature: ybf1m6omehzxmng4c1z4p9om1ato8yk9
X-HE-Tag: 1761594420-974863
X-HE-Meta: U2FsdGVkX1/PBlOxCt0eNCRgKcKSY0NIlV2o/fYTKk7RX6RCs0zh1eD3XYCAhoZqBGbat7yWDA7ScAzcInOn4HlH8TdfNswkuqSuUaw83MuDp/2/32+V3vUbt7jIssrDvId0biIaQ6NHaDna1qsDYGqr62jFNcL1l31WZ5G4ZcQOh9/fPHry4saJqjI+WrtoYmB3epBKW9nBnmqMAZkB3WDPcBQcCBCzkVT3R2ypNZUrXdU5PdJr4V+aDFQpPpnfm7CZEH+t9TMm5CqHiPOfnAuTEX7PWp3x919nSDaXpUkUu3NgcuMw9GRqtYzJt7V4dwPzoBRJTPQJgaVcu4x5Iix4uD9o6ZUnx0cgcoC47XbZTna9pcE2YEnnMMv47Mwz5tz6qqCHM+iUzvzTgcy0NtKy4WiYkSa4KhBOjGAZHHvnzKwvzmLD/g/Ifi5ggc6DhJ3jk27d38k1fk+tLJYXIbbtnLWDj/XKGX01hXu11CSRs3JVLo/PkDdTBBTPLb5k3SDUwI23yd2/DI9NeoPzqLvoVTZ/gjZWqipGDDvzXyDBqkblylLddsvS+Vy4zXiz2HEGULN9zkG181iU6pZTt9sgaCqF1uRX9wk/PiFX46xXwJcHUxYYzoFLw//bWGYcLj1YACmEwwpJcG1OOxUcX20d5+WSw8VPgUsUiMg5HdTA+4ux6fYHRPupP6BhKPDAvDbNfPtDLhWGuWSaM/a5WjHSyFOEv1Ufi9tN/Sw92bGfJNBzBrav6Md7n8l2ErWJ+XtGITg3SmuhKuHhnwVpzfdQ69LD2R8rpzdJgyjJJDT8Z+fic3CJ0OR5EB9Qpd6R35M8Zf1jezD2WF+FYv5MYVivPsNs77UY4lrDFBoUIoMcpP8yZT3SKITct1QZ20FCCwahE8GJ5o3HHKnEpcsrnaWyznyAgHkSjQPa16WIwVKjHqLRtuuqQDTWSh2eOCxn2hZ+eluYG5hLSrnD+T8
 7R06WSKG
 wVc+3xKXiIGUiM0xWc/Q2pF5bEmXGGWtgCGcgwZRb9J5TjseLV0ylv5uEC1wbfDanRc20cPVrMOsurg4RNWX2WAbVJt4zLWvnZaPY8mJgtvdcGNZddaFNSEj46sAHZl9dE+4ZZJ1xaG4gnwdsJOY6UYSym0CQ9xsHlXXBTGtFA1RWm3yt0pQ7O+xz26wtR11Q+ohKJiQ1P24kz/Z0KqA4JGl6wcMadq/Ork6hKWIHcURkkbgQNduxRisf6qNUmOLP1YiFkXwe1EeGL/CC0rVv/QibCuvgf1mUZ5UxLQg1/+E5iJH75WR1+24do/hgb3xnSvLXCBP3zLWXP5rmKQNj5D9UCnf0yeFy9GX7Ip+OXOkc6T1Qjzwc1YqScQsefCuwe7QdNgjmQCVSUefBfNsq542wNdjW8Zq2zJbtmEjGJMjjZrnYVlkEMhdYXetlB3URxVb1Ct9xyseAwggpf5ERnTzFin868e95M0bI395VWpx/wy1fowDOzMorQ4Kfjav7bQ9daZta2XWddLfvHhL34PsooJ+t2vAzfliS2/UQmwljduQUWM+qJc0viU+PmNj9Wwk9sJwOf27bXcUeA5JSsac5qhSfsaSDcWM7QbLlTqCyebYnTqDOxI2flhkIeI13B38GS8Q7JUCqHepLA7mRVhzBnHuVdKiiAUj0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 11:15:35AM -0700, Omar Sandoval wrote:
> On Mon, Oct 27, 2025 at 10:29:15AM +0100, David Hildenbrand wrote:
> > On 26.10.25 17:22, Israel Batista wrote:
> > > The MEM_* constants indicating the state of the memory block are
> > > currently defined as macros, meaning their definitions will be omitted
> > > from the debuginfo on most kernel builds. This makes it harder for
> > > debuggers to correctly map the block state at runtime, which can be
> > > quite useful when analysing errors related to memory hot plugging and
> > > unplugging with tools such as drgn and eBPF.
> > >
> > > Converting the constants to an enum will ensure the correct information
> > > is emitted by the compiler and available for the debugger, without needing
> > > to hard-code them into the debugger and track their changes.
> > >
> > > Signed-off-by: Israel Batista <linux@israelbatista.dev.br>
> > > ---
> > >   include/linux/memory.h | 16 +++++++++-------
> > >   1 file changed, 9 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/include/linux/memory.h b/include/linux/memory.h
> > > index ba1515160894..8feba3bfcd18 100644
> > > --- a/include/linux/memory.h
> > > +++ b/include/linux/memory.h
> > > @@ -89,13 +89,15 @@ int arch_get_memory_phys_device(unsigned long start_pfn);
> > >   unsigned long memory_block_size_bytes(void);
> > >   int set_memory_block_size_order(unsigned int order);
> > > -/* These states are exposed to userspace as text strings in sysfs */
> > > -#define	MEM_ONLINE		(1<<0) /* exposed to userspace */
> > > -#define	MEM_GOING_OFFLINE	(1<<1) /* exposed to userspace */
> > > -#define	MEM_OFFLINE		(1<<2) /* exposed to userspace */
> > > -#define	MEM_GOING_ONLINE	(1<<3)
> > > -#define	MEM_CANCEL_ONLINE	(1<<4)
> > > -#define	MEM_CANCEL_OFFLINE	(1<<5)
> > > +enum mem_states {

Why are we naming a type we never use...

> > > +	/* These states are exposed to userspace as text strings in sysfs */
> > > +	MEM_ONLINE		 = (1<<0), /* exposed to userspace */
> > > +	MEM_GOING_OFFLINE	 = (1<<1), /* exposed to userspace */
> > > +	MEM_OFFLINE		 = (1<<2), /* exposed to userspace */
> > > +	MEM_GOING_ONLINE	 = (1<<3),
> > > +	MEM_CANCEL_ONLINE	 = (1<<4),
> > > +	MEM_CANCEL_OFFLINE	 = (1<<5),
> > > +};

If it has to be named, can we just expose the bits as an enum and the values as
BIT(...)?

> > >   struct memory_notify {
> > >   	unsigned long start_pfn;
> >
> > CCing Lorenzo, we recently had a discussion about such conversions.
>
> Yeah, I've been asking people to send out these conversions as we
> encounter them in drgn, but ONLY when the absence of a value in the
> kernel debugging symbols causes actual problems for drgn. I want it to
> be clear that we're not spamming these just to cause churn. This is an
> unfortunate corner case of debug info that leaves us with no other
> option.

Right. That really sucks, but I like drgn so if reasonable I do want us to
make life easier there... :)

>
> > The states are mutually exclusive (so no flags), so I wonder if we can just
> > drop the (1<< X) setting completely.
>
> FWIW, putting my C standard committee hat on, there is nothing wrong
> with combining flags in an enum. C11 is silent on the matter, but C23
> made this explicit. Quoting 6.7.3.3, paragraph 16: "After possible
> lvalue conversion a value of the enumerated type behaves the same as the
> value with the underlying type, in particular with all aspects of
> promotion, conversion, and arithmetic." Lorenzo may have been thinking
> of the stricter rules in C++.

I don't really understand the argument being made there.

That's just saying the enum behaves as if it's the underlying type? I'm not
arguing otherwise.

Consider:

enum some_name {
	X,
	Y
};

void some_func(enum some_name val)
{
	switch (val) {
	case X:
		...
	case Y:
		...
	}

	// compiler doesn't warn about missing cases.
}

This is already giving some sense as to the intuition that enums specify
all the values as declared specific enumeration values.

But intuitively, with the enum as a _named_ type, it's _weird_ for there to
be possible values for it that are not listed.

The problem here for me is the type being _named_.

If it's unnamed, then it doesn't really matter, it's just another way of
declaring the values.

If drgn needs it named, then just name bit values and use BIT(...).

>
> Of course, semantically, it makes more sense to use distinct values in
> cases like this where the values are not actually flags.

enum's are kinda defined by being distinct values...

>
> > IIRC, these values are not exposed to
> > user space, only the corresponding names are, see state_show().
> >
> >
> > Won't the compiler now complain that e.g., kcore_callback() does snot handle
> > all cases? (no default statement)
>
> Only if the controlling expression of the switch statement actually has
> the enum type. All existing code uses unsigned long, so the compiler
> doesn't care.

So why are we naming the type... does drgn require it?

Thanks, Lorenzo

