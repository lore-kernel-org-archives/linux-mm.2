Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AB24C87FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 13:25:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A94156B008A; Wed, 30 Jul 2025 09:25:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6B386B008C; Wed, 30 Jul 2025 09:25:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 932F56B0092; Wed, 30 Jul 2025 09:25:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8185D6B008A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:25:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 353A11DB0CE
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 13:25:19 +0000 (UTC)
X-FDA: 83721002358.17.5552236
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 97D0E14000C
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 13:25:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RaPSuKOf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ck1giGBL;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753881915; a=rsa-sha256;
	cv=pass;
	b=joNNbjc01r9+q2bvMYrckvuE+3J3gzH1S6pX9vyaZDpqJooIUjRubG7SdwhS0mDS1aHF3s
	4zMo0vcYgbFuqUJ1Oz5xA/wCUSZ8na0o0nBOUTQSbvuJs1w2ECch9WvwU/onfDbaHzAors
	qLQJGrE9EpB/94yssMLv1z/1qZYxsJQ=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RaPSuKOf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ck1giGBL;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753881915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z5VU5MUAr8LPs0N0U+mM828wd2cnDjRHEGSy/C6Whw0=;
	b=2qLV34KauZl2Ep2YhLIL2QwQbUb+1+ErKfUvSSP4sqYMEuqbwpGkA9ARYXihn0EwOmbY+D
	RAfGcptqXGrapASCDYwFFBFmt6ew4XClLZ4ECtDlGABS9ZtFJQaLEixXHdts27B4GVJSq+
	LFxG+dUWrpaX1g/32jCqnb3aKr3b/ws=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56UDMv40017003;
	Wed, 30 Jul 2025 13:25:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Z5VU5MUAr8LPs0N0U+
	mM828wd2cnDjRHEGSy/C6Whw0=; b=RaPSuKOfI9bA42aoccPwTElplnG1kDH8zg
	s7wplnwq0rBTuTP/snXGb5uYLXRkQEs9lgRYH1N9ij4M/wPvxMCIyI8tFG/NRFyu
	K2kTLvYLWWU20bo9dv9cNJL9l82y+Ff0A6MoErmt26USjgVKBb3q4Q/ac/kcjxZm
	1Flun2rV36D9TF1Ks24H1x8S698/Upwe0KrbOYTXAF+bHV520HAXEX5+N7vym7S/
	+CSu+6V7smGbayDDFb27/ycrLLhDAnI0T/RcjHbwhGaFj2OFG2clTxzMfUvjD+xC
	oYWF9YQDdsIz9nt9uIrSw9UwmJgVZiV9KznI8bbbuDLlzyFTw0/g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q5x1r1r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Jul 2025 13:25:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56UDNN3C016838;
	Wed, 30 Jul 2025 13:25:00 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2082.outbound.protection.outlook.com [40.107.93.82])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 484nfhgqx6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Jul 2025 13:25:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VTGhH3wFfQrnjWjdd8/dDi0yfLROc3jHRae6Rj/CPy4fZEDdjP5eAFMgjweCoSXGh1WldNFspBlpDehIuCrIencFztTJ2+e/R44gBwXqgbyv/zbaCqNcn2Fwy7wSAWow0XIPa+YQsQRrYFUl+k5Pe2wfgiWBwpaZahepy3I2WdBHVndu4hncOt+vHlsZARkgkfKfP44t0GwgmobcHKdqPzC9pG5qcr9pNu+KvRjJO7j0S5drs/E2+GX7tJ3pOD1WFm5T/r6HceSjO6e73Bd83yldJAntJq+DMSY37lY2jpd6b/1tPPIhER66IAVuT7LWVlo7AszY0wCx8Q9G+fo93w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z5VU5MUAr8LPs0N0U+mM828wd2cnDjRHEGSy/C6Whw0=;
 b=kLVsb8gn8ddn6c5WYa3h3Ue3n7+85nLG6aTl7b9H0UVBFhO2fyChfI7bLCHCy6KN+BPVUFPogKmSLbWWqmZg8HixMWTyYBRqcWwhfHHvBH8/h+HUxWCUNdxNV51HbSIOx1fkxNO6F1YIbGHpdnO5p7xJQ7KLCBwGIsgfY+p8BHoJDa+4zQEVE12MW5qLs4BLyfXOxX898agcLboqDvtzGgAZ4FCGsPcWaB3akKmx1wxN9GOUzfnPONT2SVNXw4CIJ83cVwHkSsVedu6x6mmNXe0BqeoxgsnkUufrH6L8BXvd4BhwDL1ojhAaO3hLHinMtV7ydb9mOpXvM2P5fZho+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z5VU5MUAr8LPs0N0U+mM828wd2cnDjRHEGSy/C6Whw0=;
 b=ck1giGBL8MLLN58/9EQAwXso+Ne+j4jSVnS6yNLRU0uT6FNAR7Qb2Dr3zupG8qCtiUfYLAMm8u1j99qvkQ8BH4GlY1C5Zufbp8E2f7wmNUS/wJDI49m+rB+jqdnBCtqPG4nLxNKR5kjfd78bXZQOp77spBsfa/OXyWVbgPeG+FM=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB6365.namprd10.prod.outlook.com (2603:10b6:806:255::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.27; Wed, 30 Jul
 2025 13:24:56 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8989.010; Wed, 30 Jul 2025
 13:24:56 +0000
Date: Wed, 30 Jul 2025 14:24:52 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        xen-devel@lists.xenproject.org, linux-fsdevel@vger.kernel.org,
        nvdimm@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Hugh Dickins <hughd@google.com>, Oscar Salvador <osalvador@suse.de>,
        Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v2 7/9] mm/memory: factor out common code from
 vm_normal_page_*()
Message-ID: <879fa591-5915-41e4-b439-be0228340aab@lucifer.local>
References: <20250717115212.1825089-1-david@redhat.com>
 <20250717115212.1825089-8-david@redhat.com>
 <1aef6483-18e6-463b-a197-34dd32dd6fbd@lucifer.local>
 <50190a14-78fb-4a4a-82fa-d7b887aa4754@lucifer.local>
 <b7457b96-2b78-4202-8380-4c7cd70767b9@redhat.com>
 <eab1eb16-b99b-4d6b-9539-545d62ed1d5d@lucifer.local>
 <ee6ff4d7-8e48-487b-9685-ce5363f6b615@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee6ff4d7-8e48-487b-9685-ce5363f6b615@redhat.com>
X-ClientProxiedBy: MM0P280CA0062.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:8::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB6365:EE_
X-MS-Office365-Filtering-Correlation-Id: 8862b021-7821-4cc7-66a4-08ddcf6c79b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UY/ngH6F8Lm522uZndrj8GmVxFRpF4x1xgBLNYvLZW54UBOTZtelkkjiRuVE?=
 =?us-ascii?Q?31Kcl1h59bDIyRj4orO4D/cwkrixGg36vIXYm0qAWJpbOWCpNa1Dol41Xz/+?=
 =?us-ascii?Q?zKPOtVPXXwkJr14WeN0pewDPiKnKpg29qITM4yhKIcXnlSVubhOm3rZt2g++?=
 =?us-ascii?Q?MIf/6CV93Bw6img3jalUkBo/282g4BLsVdY8CbZ7xubvaDA1AZzK/afhZdMR?=
 =?us-ascii?Q?XsWtJPCDjHJD2nr9VUZV5/RCgOr7PAjyZGOG7Q+fmKeA4FkRXihEtNQPYqZV?=
 =?us-ascii?Q?7DduCaJofiLC/SgfDW1EDjKXLYuuUFuw3KZmn7jduei0L4qHNGSG+l86j1BO?=
 =?us-ascii?Q?yjaBneZG0O6CW0fAmpQ9upf+vwIJP+4xme/GLbmwjXcxMup6u2L0xBmklIvd?=
 =?us-ascii?Q?YKmHhMQyW9t6/l/643DMObYgtRLavn+6TbSJ/eOPpSRilFMtnR9xaYDX7dlK?=
 =?us-ascii?Q?BZW7nSRo4CUpGeRAoKbGoz6KO0XKDGOVjlEdxRpkAQLqDTevv5vZQPCczY2x?=
 =?us-ascii?Q?3RoWdCwen7c3bwCLLY19X7jLcGDOR4wg2kaS9XnP2INP0kenmAl5eUyGhUFY?=
 =?us-ascii?Q?7P+mRn0YOGrBonBNgF+EFyzocHixLF4ZxMQggBguD8xh1AsLyKArug0IMge/?=
 =?us-ascii?Q?97x451zGpU7FjO0Pd8tREdXblhyi5L3r3XdUAV8WxF3i4nL+NBsT+1h0SZv/?=
 =?us-ascii?Q?zf2GzNO2zX+3LDuxlfJUd5q+tAhk6Gq6B0s7KfMSpgO9F4iuwCAiTHr+epbK?=
 =?us-ascii?Q?xtIbjuschd1tQ9fvlzVXptQlNxBKChrWZxcioe1/qocbLhrAUKKJQjzF326q?=
 =?us-ascii?Q?AzukchAAdxX5m5G9PabnrfG/yZgQ81gIER1PKD1rIyqzGG+JBQrrQZcCxy+R?=
 =?us-ascii?Q?7DWinaFsGmaA2gJ2Qx0WjkkO5P5bABDoQD8wRM94MFJqB8lfyF7tWymPvvXt?=
 =?us-ascii?Q?GA2/zBx6cQ+rdV+8c1V5/O+0fSiW8eOxo3Zj3crvSKcU8oRlCfgQrM57R4ab?=
 =?us-ascii?Q?Ww3s7HITK1gQqY12yXqeDPEqamMseSdywwXWCwJ0IOb3l2Jyc/YAs0P0jwzJ?=
 =?us-ascii?Q?CWneXhr5LtgI0LFNYOgXydX1OSfanmiI+uXap943zdOZjvhFsoB2+V1hssg/?=
 =?us-ascii?Q?p9J68aTUshwq65mAawR56RN/XESAsZcS/46UyLKRZygQ1U9cuv1hxUqqiJ60?=
 =?us-ascii?Q?wiydWqaoar2L4pxb0KITMCoZwz+PMf2Tp4Ohqy3sCmxp1hkluHv6fAYrKgnN?=
 =?us-ascii?Q?68naJerqrp1bmCOQjCkYuTF4hsTIfa3PyI1+TVTkGG1jG3brIhP7bLGwqTEO?=
 =?us-ascii?Q?zooc7wPQ7boO1ZvOoYs9wJBqRRBmt+IoQgMevS6W99/jdAtTQ+JSzL4ENshF?=
 =?us-ascii?Q?BxIEuaO6X5nJdRMsg9ccNd6s37otOgVT/eVgmnj7xpjaYyVfIQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NfY3LkR2GxL/lsZZF6igCDGGu6zbuVBatdvgYKjsVzKlQIG22GxKp2lsQSj/?=
 =?us-ascii?Q?+L9xTS2yYdnGjB+I5C+DZuCmdcjeHMXR3+cGPDSC1cjInYMh3W/C0FrNlZYJ?=
 =?us-ascii?Q?UQnVZrBh5uSJ4uQDOnIzNXbDiZiNP3SZNCRE8nYn1b+a8Q5lcZ8jE7TdioR2?=
 =?us-ascii?Q?s/bRyE9k9TnFEUTxBoDKnbam/k0u5zydcqkV2FuG6IPxZqdKw39KGHXXTXAb?=
 =?us-ascii?Q?hL8GDYQUHovk+na/S40krq8GaVyZ2s5xSqiZ+4XFhRILfgRFIbPDAJ4dLBTL?=
 =?us-ascii?Q?hbkR2EBHpNGIKlRY+YlZ0R1yoSAdfrtG+kSDm21f2Xmzb3P8H0+Eo40Nq/D1?=
 =?us-ascii?Q?SgZxKa4bD77YamD4AHjIvOCBpzrHSzIUtp6X24sMF0APnxBnIjiCZn+YPKe9?=
 =?us-ascii?Q?D/B/y01U4z4Rznw4zpo2c/yKTUCCOHMiOt/RkeWt8g3j/Om6SThW5kl88FsC?=
 =?us-ascii?Q?jPzNuHTdOiirB/O7ogylJOfgo0DbSQ7oGurxmpuhnU/8lmst3HIKTN74hSRB?=
 =?us-ascii?Q?g52HVndMUnzFmPq28qqCjLsxaGjzfYABPDexp63Ripe6u7bCcFBoPxvpI6TY?=
 =?us-ascii?Q?V0JOzVJhYqWIAMQ/jDst+0Po5I9MlIkknhNgGbCWKNaO0qxFdlHueGn4n+yD?=
 =?us-ascii?Q?0TnZIi0M2jZoxh/FfNtlYoSrt718toAVt+9bOgl9pHKIYWADUNbHC2O7UEbq?=
 =?us-ascii?Q?EJhjgernEonQEceuUl/KQkhBp9jAU3GMU77V96I9zKewjiEztvxEBUhatCTw?=
 =?us-ascii?Q?EIT8KkOZK3aq9IdGAUbVcqfhMovkRJ1JU9EUOmpbofG4BvDK5ioA47Asi5zN?=
 =?us-ascii?Q?pxdRfn4ZbA12DqOCjkuzif2jPSuudWwJhrS5efdVB7Ws1POmArrlYnp0qpLP?=
 =?us-ascii?Q?DkVDauqwoykexdCTebHWu86XqyMatditH83xmGn58uabuUr7Fcb3H/BFlbZD?=
 =?us-ascii?Q?CaF7j2Zushp1M2VWhvaKKTTvQAOqEJZtaS12jtsuKKrVjlTJL5orQqqxeRbv?=
 =?us-ascii?Q?2i5V9TMKg0wq/r60xqRTWUVSWcUtAPcOLF5aKvU3FscNresLPjMsItauvC5E?=
 =?us-ascii?Q?/f2569yHOnbAY4yx1HjpY6r3b84/iQ/fMZnTIvKzBgcVZ3XR60CKrw3lrOYJ?=
 =?us-ascii?Q?yyUlUIFMztT9pyqVfLeGvnQoHNTXFFO9/gC015N5n1bwFLhiZKrQGKfozhcJ?=
 =?us-ascii?Q?Yi8COM0z6RrQZxPwGxAYcSnPA9xyZ0mOHfMp8nP53+3R3TLdztjduWzHlXSm?=
 =?us-ascii?Q?wvdlVnfJNRdN6/HP1gtlp6GQ8NvnfMDeJ3kgVkRtpZum29Eqk2TXiNmSCA5F?=
 =?us-ascii?Q?Lmya9DuyH/P+bIS4QuRSBUxSFQSf56irdfNEM1vqPf9lsiNZxUfSsbbLmkgm?=
 =?us-ascii?Q?smnlGzeoPt5RqvCaduo3QmFTV0GTHJwyGHECnEJAoyFwv3qQ9U1jr46mQHb1?=
 =?us-ascii?Q?dOFLwi4WtTimObUSRAOOpsISx2Iyq/OJ8sVMQv82LYzrrYU4RrovlrLgTE+C?=
 =?us-ascii?Q?8Xfp5ZeyGSRJZyjyS2/hCqkktDT4YO9oj2aLwJ1Lpe39UD8TkP50Pmg66guN?=
 =?us-ascii?Q?l1V/DMJrJbbj/gwIlIIQjMqHDBrdyNiFT2khxMZ088+afhcuq9Y0AI9cCLEB?=
 =?us-ascii?Q?ng=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4mmIOEiftAv/iw9Qnq3iEEpei3Nx3hNiNK8m4ysPpkjWRp7YER1sTjh93aIhYHz4SzrT46XpdBYJSS60gDISrMnV7OPTSY+IB3JHijf9qdjey4LOduQsmdS8EK1FPn7FRzKywSQi1rTC46o3HPQTLJK4vPXeJVMNP74QDe6CjOLl+TxuO+OWDOOxF0Mp9++j9W3TOZimktcFvC7Y/ZdPz1KvD2pCaO6o0m4xHoWs32OAlMFxJLGLtck/IPwnGpX+VI4pjSCAnFSftDFKWtwOFv2SyMb9O3Fp0s7mfAkaecrVa3q9k8a9cshWVrU+8PQhFym17GnEKBSpi+deGO2acDoOkRExvL53NKkZBNhYudvf7NxjAZblW8aHCE7/7tP7aMT+pHScgEry0RWcImtBdWLYndcYMZzNNL13klHdgbzAw86PsEeDBvrt4KJ51mda9XoTrt7cxKWrc0dO5KH8Bp8XEp0ZdROpCR8exyCZV5tqtZ7TjKT2IW9flTEfEjRzCkXWWZwnVwJ3g92ZqQ6hB9NHDi+qZhuhcoJ7Ij+6G1NyDZs2o5WxrKFWjUm5SvAvymWrc7ehmeiHVARerUB/cCXm4JAkCoG9tVhOXUQT4qg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8862b021-7821-4cc7-66a4-08ddcf6c79b8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 13:24:56.3077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l1E2KmxAUYQRwLmd741ZK1xrJtPeyPNd042wzr4cErNPhnT0T7jkjD37EkpVEZfqmrlmldj5i9L8AeiJJ9wJpmQ26b366d/DCGoteKLbqaM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6365
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-30_04,2025-07-30_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=898 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507300096
X-Authority-Analysis: v=2.4 cv=X+lSKHTe c=1 sm=1 tr=0 ts=688a1d2d b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=iaUHQv8qpNzbDgxXv_AA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12070
X-Proofpoint-GUID: qecsZKbkgWww6VTqRmD3xnl-uMfC3s17
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMwMDA5NiBTYWx0ZWRfX/5Zw4RB7CV5m
 xsqvbs6enTcZ9VBVsYv/vCb5lKvGVzR2pZGnlTYPZofWbY3+02YRPxeaV76geAwIwzZAGwLi0LC
 S1GRu08uesCzvsWrInNIajvUmcn2hJs8p290PLy6vCuRbOKgh1fnzwaiAYwK5w1hxPDVxuG2AJr
 75BDCKHEAnuSsbAOOUeMCRo4/bt+GT+int1eRUQrSeFMuNXHWdzjg7g5wo+FTaJcCb2dAN13+dy
 MLT+cb9fCKqjh1KOf+B3K/iHuZjUoTypBTt16p09mSr5BPKhs8bnx/PmIdThCVB1+PpCHba8Ud5
 LV1tsZus3QH6yp8DWsqwESSJRz6F8P36pMUkSS1KbHrEI0DWR74SsTYP3j052ID9drmYhJw+TqE
 xEIWAwr00HraathHjrOLC7kCKDdhv0Q/hLK2X8YlmVwZJEIRmuo/D4YWSbjdTOlckhForrJX
X-Proofpoint-ORIG-GUID: qecsZKbkgWww6VTqRmD3xnl-uMfC3s17
X-Rspamd-Queue-Id: 97D0E14000C
X-Stat-Signature: bs49gbco1frot6j4kdq4987gjxzxfpzu
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753881915-859105
X-HE-Meta: U2FsdGVkX1+rMEkgofmrKxHBqNOjsnEbskJjR1fq+fvd4aJbEKzHOvzcpJOlDfGOFlsHCVx2rpb/s95UsB9vk4UwoOjVttcNnsvpGmVr7U8AUgTpXUX459RKAW11wG8PI7zTgarbqnuafODcViiHHylvHrDNyruayQFG+gFoJaUadyYQ0kA3ChVhqVxmRX/PwIhZhvPmYsYRefYsFHFpo9eWKz2EPWul7hlpJKByS5TpEUJVucNQpuuypYjJH2Bbjqt5UiqmJ8SRmTpF3z4ICQOwS5w7ZamisssWBsreFet5VOVVgayN3Ue7wR4Vx8L7eWuGkg2Z9ZgiueAHbXPs7vpmGlr/gpxQcwxwRFSbdLBNXW1qKnXiPHGlSWaZUgjxkuoX8fmfwnPNecD8zhFy70cKJfqY6l5J6EZ28G4qc5E05pkz/DH5meVofSDs3VVgBztbD2pjctlOpBztZwgzLYRI/C+znCiwis7rvtOfulm0ngoNQNlGkggJW2idDBiBTHcasPoRj3DDQLrkItGvO9V62gOXIEjJkRQi3HERF9O/PV0Ubht0J/Lm45c/z6D6PugCSdc/9C5prJhBGeuHrxuKNZdEBmzkttrtOAtr1Moatzbs4QoUyhtzBOPkoPlEoKZkHKy188cAKc82KTjXjyEi3DXxFnXkPHT4ZwTmIV9kkbsONRdW37nuAbJ2E4xnylqBUaQyc7dJJjDX16gztq6thgP1Am0GdJwEbOk4nIs4FXKjmyYkSaz43owlTVvgMSv8TOYJRsCusrFZJVGM+DePohLNCeaiA5IBD8wsDws3Oj3kZH/UlRwJq+t29erRrVtxeOy8oJ/WC3l+XXEdX0tzM0nmZehRV55oF5kfd8HJX5WiXoNyC+ftYQlIlBSblqL3Vcn+TIjv9pBuysaHbHgaQW9wb8Aj6JgEwbr6m3/E5TfAgvtwHBFhzkGZpd7vP1mewo0/NbXyHLQs2B6
 +u7AwN3r
 u9EwJzgA3IrzfGQomvuUlmxg1SVZVoqvZv83E9hwBT2Q/+RjjU7Lwef9fI0WGDlE4tG2XVwmB7kPx+LvTrCb/jq9rv2XCuaJBDDk75dyjymWy45n4SfcZ4cWbp5pRCsf8GJZDy92kFxYqxoRKh7zNAvd7zibeBaWRz9foj6oZB8hO0VzEvFKc56z2005QUjXQQjbPO5+RGDtB6AJ9bTcawtFXzuHN/Jx9lodIXjp2+OYNWdfGHo4EnRZP+y5r8hM/G/6d5PU75ozzr4Em+iYIPWmSivf8iIdXDFzDk1NGUkM5g9mJI3AhAHp4FOZDY7NbPspdKH7WfcDGlkw5Q5/ei03xQGzmDYF6EmUqwxaHXWaYLOZ++/yoXY3vdOjuvl3/grMAJ+xu25/TsGGj4HpvNH73usrZfs+nGrQxvD/ZC15NPU9pVsCzVRzEqL+GbdWPAfn9sgO2OFgB2upZxR+fJjKOuV/Ro4fGWKm4KruZNQVAx+ZMsFELNqVOxKBLd+DGgEzJuXHSlIVPtqzmDHUD6KAMPQw4cvLqQbXtP5DVlnqmCCfAuVLdYXjlfQvvrdc8k+yVuXcUC8Vg9baCSunPcTsldRNsqWNHZEHfdv+S4wQ63tT07BqzqmjSAC78KQxFhMVEL0MjrfYtwEz3J2eRiaybRej5ilwgNq1HQA77EKlbrzJj3vD0NO9UNVqrltSdmAS7hz12xF9zFNkh5JqaxMXcXhFaL8uBuVfCWepDCH9DNEkIljiYKh8JIz2aj99c1GRkCOcGndWtJBA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 30, 2025 at 02:54:46PM +0200, David Hildenbrand wrote:
> On 18.07.25 14:43, Lorenzo Stoakes wrote:
> > On Thu, Jul 17, 2025 at 10:03:44PM +0200, David Hildenbrand wrote:
> > > On 17.07.25 21:55, Lorenzo Stoakes wrote:
> > > > On Thu, Jul 17, 2025 at 08:51:51PM +0100, Lorenzo Stoakes wrote:
> > > > > > @@ -721,37 +772,21 @@ struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
> > > > > >    		print_bad_page_map(vma, addr, pmd_val(pmd), NULL);
> > > > > >    		return NULL;
> > > > > >    	}
> > > > > > -
> > > > > > -	if (unlikely(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP))) {
> > > > > > -		if (vma->vm_flags & VM_MIXEDMAP) {
> > > > > > -			if (!pfn_valid(pfn))
> > > > > > -				return NULL;
> > > > > > -			goto out;
> > > > > > -		} else {
> > > > > > -			unsigned long off;
> > > > > > -			off = (addr - vma->vm_start) >> PAGE_SHIFT;
> > > > > > -			if (pfn == vma->vm_pgoff + off)
> > > > > > -				return NULL;
> > > > > > -			if (!is_cow_mapping(vma->vm_flags))
> > > > > > -				return NULL;
> > > > > > -		}
> > > > > > -	}
> > > > > > -
> > > > > > -	if (is_huge_zero_pfn(pfn))
> > > > > > -		return NULL;
> > > > > > -	if (unlikely(pfn > highest_memmap_pfn)) {
> > > > > > -		print_bad_page_map(vma, addr, pmd_val(pmd), NULL);
> > > > > > -		return NULL;
> > > > > > -	}
> > > > > > -
> > > > > > -	/*
> > > > > > -	 * NOTE! We still have PageReserved() pages in the page tables.
> > > > > > -	 * eg. VDSO mappings can cause them to exist.
> > > > > > -	 */
> > > > > > -out:
> > > > > > -	return pfn_to_page(pfn);
> > > > > > +	return vm_normal_page_pfn(vma, addr, pfn, pmd_val(pmd));
> > > > >
> > > > > Hmm this seems broken, because you're now making these special on arches with
> > > > > pte_special() right? But then you're invoking the not-special function?
> > > > >
> > > > > Also for non-pte_special() arches you're kind of implying they _maybe_ could be
> > > > > special.
> > > >
> > > > OK sorry the diff caught me out here, you explicitly handle the pmd_special()
> > > > case here, duplicatively (yuck).
> > > >
> > > > Maybe you fix this up in a later patch :)
> > >
> > > I had that, but the conditions depend on the level, meaning: unnecessary
> > > checks for pte/pmd/pud level.
> > >
> > > I had a variant where I would pass "bool special" into vm_normal_page_pfn(),
> > > but I didn't like it.
> > >
> > > To optimize out, I would have to provide a "level" argument, and did not
> > > convince myself yet that that is a good idea at this point.
> >
> > Yeah fair enough. That probably isn't worth it or might end up making things
> > even more ugly.
>
> So, I decided to add the level arguments, but not use them to optimize the checks,
> only to forward it to the new print_bad_pte().
>
> So the new helper will be
>
> /**
>   * __vm_normal_page() - Get the "struct page" associated with a page table entry.
>   * @vma: The VMA mapping the page table entry.
>   * @addr: The address where the page table entry is mapped.
>   * @pfn: The PFN stored in the page table entry.
>   * @special: Whether the page table entry is marked "special".
>   * @level: The page table level for error reporting purposes only.
>   * @entry: The page table entry value for error reporting purposes only.
> ...
>   */
> static inline struct page *__vm_normal_page(struct vm_area_struct *vma,
>                unsigned long addr, unsigned long pfn, bool special,
>                unsigned long long entry, enum pgtable_level level)
> ...
>
>
> And vm_nomal_page() will for example be
>
> /**
>  * vm_normal_page() - Get the "struct page" associated with a PTE
>  * @vma: The VMA mapping the @pte.
>  * @addr: The address where the @pte is mapped.
>  * @pte: The PTE.
>  *
>  * Get the "struct page" associated with a PTE. See __vm_normal_page()
>  * for details on "normal" and "special" mappings.
>  *
>  * Return: Returns the "struct page" if this is a "normal" mapping. Returns
>  *        NULL if this is a "special" mapping.
>  */
> struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
>                             pte_t pte)
> {
>        return __vm_normal_page(vma, addr, pte_pfn(pte), pte_special(pte),
>                                pte_val(pte), PGTABLE_LEVEL_PTE);
> }
>

OK that could work out well actually, cool thank you!

