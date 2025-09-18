Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2F5ACAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 10:06:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 184E38E00D7; Thu, 18 Sep 2025 06:06:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12EFB8E0093; Thu, 18 Sep 2025 06:06:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F11418E00D7; Thu, 18 Sep 2025 06:06:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D92FC8E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 06:06:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 854251A074E
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:06:31 +0000 (UTC)
X-FDA: 83901941382.24.A70FA69
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id D354E80012
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:06:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=anR487+w;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=b354y7tO;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758189988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XFOXz/xTjgqLONMReZ5g8OURo/8igeqvm3YPNAQ5Kz0=;
	b=B1XagGnZsECTdpchkBUQLW1WrDKymD36K2htmqZKu4mEFXFdR4DvV4iduMPQrLGi8ALZpb
	9J4jUmi9xJsUZ9vLFrDAT9V8BVCwwg9uylTeO6/gEXaaCOQjphh84RkobMCKdjVCTFBYYr
	A6DIKEKcOl68ZrzEqHWKeZL4CvYwYzU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758189988; a=rsa-sha256;
	cv=fail;
	b=uhv3O1OfQmgrQ2Zf6dnKdhzhZvRyEJf7n5tsRJZZt7f5TrA9AbKYh2eO+FPan6jx9zMYEm
	ZUSqBg6ez+7iSV+Y1QpTrsGDNNK+5JJwpnz8RB4y7w2Y2dXM+ZNYz8QOcap8VtLUZmmIE8
	9SrBLDVSvttdWB3JWUzjrFLyxR1Zwq4=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=anR487+w;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=b354y7tO;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58I7fv9m007030;
	Thu, 18 Sep 2025 10:06:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=XFOXz/xTjgqLONMReZ5g8OURo/8igeqvm3YPNAQ5Kz0=; b=
	anR487+wLNoGr9kiCp91QNanDEZWH45BuXG3n28yyLNRk9QXoIuiZZC3mZkXaduX
	XFBEDA6XElLWdY1QqPCbxh+9q3f815DsWgCW4Z2loooXlFPPkI9ePX7ZoWp4vHSn
	ULjk91MBN9Sgt5PF+Z17slkunWiQR8ywaUp1pbAYn56+EKuyZYSQNlrsFVXMxvuR
	/SPAQf/WP5FamT58nrK8JgrSSsbUXRnZwOVQsNzTjzTa+fKNOsNGZRuJ7r8/ad6G
	vb1oVXFGo4G3RdZEG7xqQm3Ck4yfuCum8YICYRGRRadjwB1z3XXRxzLB3TLODdMN
	K+VR5rRJx3NlLwHVUdmDxA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497g0kb6pk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 10:06:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58I8WGZ6027324;
	Thu, 18 Sep 2025 10:06:18 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012042.outbound.protection.outlook.com [52.101.48.42])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2n6pg1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 10:06:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sG8FyX6B7p2cLUYAG+kv2gAMwkaF4LKXi8mKVtt6jWxwmPqKbKctYon+9fR5SzpQdYI2csGumGamC5xib8VpdQJieBpZED0LzTBk2/Hxm+KMrbfITzBLXR9VNAEKFQr2PR9v8/WN57huBy1E0yp/W4+cV3qXrD9RPEwAUtewLodIOyyAcHlMSW7Iq/mBfgV8rTm+gc77Ee4MIf1EYlI+5c2VXVVWXb9HnbAliaJ1eVWlps8N6l/nUEKAi2qwSZu+061giQfYoA1AAFGzqTAcVHgJzd6m8yqVdUwQhxQg/5KR//T0vT+rq9aiuKqYrJOJ5LqflrNNIbSFpE4HHt0hag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=logTQ1fhkVHfWHdwNBJiHFccd8PR5BTAhHSFg5M9iKg=;
 b=KLS6EOofk11uDeZKyOoRmxtDZxQsL3FUuy+3KWJIULhNCW/gQ0ewFqR/G3Xvl/eh2wDFRaflRphryfYCUcTF4AdElcBQFKh1Q81uKNoNVQbgH+jTX1LlgOI0VA67GlfH3NIJYPeYBrVa+MBGjnJAFPK++2TJXPoFRE1PqgdcpY6v6nCmOQfU+jv0E/chgeE9NFzblrljWZMMpXKdnjlRI/aOuHDG5SvBzAemPhUvYKl+M429leYLBckyKoJSmG2Bfe3rg1LVj89Cr/O2eiVd/lH2bzjMZzeb/2IO5sbP3XXJQ+3coGJndFlGPwN1+4FxVIr2oqyRWkxxqkcyNKq89A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=logTQ1fhkVHfWHdwNBJiHFccd8PR5BTAhHSFg5M9iKg=;
 b=b354y7tOsWSGnkbDAe3QrMZWdPa07Ory2qCYClUJsiGtIruZZh6UE1w3ZS8BcOqXQwlyZrEeNwiXHNq+cKtUZ9h9N11Qa8gPT0GCHIFQ8cbtGfij1Rls7+AXpNJgZ7+QWYODQjtdkritB3z/Q1QpzPKK46VaNhuE2aYA19958+8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH7PR10MB6379.namprd10.prod.outlook.com (2603:10b6:510:1a9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Thu, 18 Sep
 2025 10:06:15 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 10:06:15 +0000
Date: Thu, 18 Sep 2025 11:06:12 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, david@redhat.com,
        ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
        ioworker0@gmail.com, kirill@shutemov.name, hughd@google.com,
        mpenttil@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH mm-new v2 2/2] mm/khugepaged: abort collapse scan on
 guard PTEs
Message-ID: <7df49fe7-c6b7-426a-8680-dcd55219c8bd@lucifer.local>
References: <20250918050431.36855-1-lance.yang@linux.dev>
 <20250918050431.36855-3-lance.yang@linux.dev>
 <f6073afe-a604-485a-8cea-7aa08e46a0cf@arm.com>
 <db182c88-04d6-408a-b36e-a708dc7eb3de@linux.dev>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <db182c88-04d6-408a-b36e-a708dc7eb3de@linux.dev>
X-ClientProxiedBy: LO2P123CA0105.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:139::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH7PR10MB6379:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e65b719-3841-4a0f-b082-08ddf69b00af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?kk7sqHEpFy+pNMwoZ3EqDozUWS31tNBIhv/3rYaKjmd0u6scybV3/ARmK0?=
 =?iso-8859-1?Q?4IAR3V77ojq45cjdpqk2zVB9RAQBE3JN8/V2F/2mqOyGe9QlFRS3oRkltH?=
 =?iso-8859-1?Q?K7XtqMj6QHqPStdkRyqM29Y77aRcbexsRCKnRwPMYeKwQ0MPPEG0LL9w1Y?=
 =?iso-8859-1?Q?lzQaALVvghTmpO6bgS5uiGKMZs85PH7ww9dHoztV2sbkyfSLTXjqopAlIQ?=
 =?iso-8859-1?Q?YK9q3yQuxP+tLYbrcNxmVQm4tdggyjKyNF3SXlHkm8lUHQy5mJlO7eUZC6?=
 =?iso-8859-1?Q?LGkImriWvf+Y/p+Htk9iOs/rRlSAJqerFyIuN25qCV5H/q7oc1nhIPfYBj?=
 =?iso-8859-1?Q?AGmYC5yxeVmg7YuUfR+8ZVGlqauAjIJxtF31i3aKKYWTswIovBWVC3yKrg?=
 =?iso-8859-1?Q?3kY3gdSj8uTaGNK1U/lDK4m0Dp97OnoIEaphkzpCiLOlgkrqFrlYz7ghFz?=
 =?iso-8859-1?Q?OfsbVqFL7zIUWkjJkzq5e7DzuSLuTkYoQFtE34ow+zrmlFl0dz3BmP7fRy?=
 =?iso-8859-1?Q?1Hc+EShx2MV6+mcgmyeSsP+qjBNmlbuUwlubT9O6LNOwYrqelqSS5k/TlH?=
 =?iso-8859-1?Q?mR3bhDzcbUpfz5IrlE97l8tlfyNHZx3mzUX8RW0IacGnS09Rm4/tmhHW71?=
 =?iso-8859-1?Q?Al59V53uxNn1SarM3iiELcRWK8YfL62ja9et7mgQMeyyXIpa7WbCL9BpLW?=
 =?iso-8859-1?Q?DGmDYJlOI7et6ALyxY5vbab3YxAz2nQcZwOLocF8Q0xzrzkS8POTp//5sr?=
 =?iso-8859-1?Q?Qmw0+7zbfcDz/LmICweyuDTM0l1usdhfvIEgUtySkqMPSNAJ2jVgJ7Y0TI?=
 =?iso-8859-1?Q?AbURKVrOTAnUtT6JeQzaLBGCyYuUSga33kJ3TVVtCZyCoekPaXGA3jzyZ6?=
 =?iso-8859-1?Q?ja7r/xLR7L620+jHiggZSncwTL+EHcABxwHmwiYKI/j+l1IjaEBzkgHFv7?=
 =?iso-8859-1?Q?BOZgfjPDd4Lu5zhFAgn/J+lGcG2WynABF3vJ+ByAOyUwvIDzODq/mhs2RJ?=
 =?iso-8859-1?Q?i5QSBDZX7uYleuhu1xWad/QzTNTw9MS2Mn32k+LPiByt9TO5oKMddW2AwI?=
 =?iso-8859-1?Q?ObGEX+24+1510k2TXcak57towVmhrbdj3TtAgvZyX7NK3/0VhJtncQcKej?=
 =?iso-8859-1?Q?4dg9Bruh4fAJlS+X0iZTEARS1ZCZ86x1r0/EqNpFnCZ/iwehYqSRWQMTnQ?=
 =?iso-8859-1?Q?oel/ny4AnHvOLSYjJxxXh6fNx9rTNJGKOdscK+M+jBYCP/cSMIdqhZxX9s?=
 =?iso-8859-1?Q?nYTx2Rb3aKYZQEy95WjhjnVN6WmVMATj9szYL6XszM+cORwJN2MKAbRQ5L?=
 =?iso-8859-1?Q?CN9012X9uYDNQjMp4IZkKZ6jcA1cND/ISUf3m/LuhDOOZweAMvQBULOE0E?=
 =?iso-8859-1?Q?6GdE99J8bGhQ3kB+hsn6GEMxdk8jJq89yj9+7jku4SxHYdAHBYcm16I3Pk?=
 =?iso-8859-1?Q?gbUwYTftma72QNPjRXIVxG8Opq9KplGW24pLhBbH5o0TtE25Ue+wf58jJe?=
 =?iso-8859-1?Q?c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?c/ZSHGcH5rGCH6mKaONxjU7IEE9/q1w56MOu4g9Ikd2q3nT4NIJ40fWJzQ?=
 =?iso-8859-1?Q?EkK8dboUO46l1HZvsYMkG1u08R6KXv5I3jRbjjFbojf2T17xaVZDMW5O4U?=
 =?iso-8859-1?Q?b7ymi3FtkXV15szyq3sAOeaRUaadeL4E7t7I7+YWi64bipzfaNmG/r7y+O?=
 =?iso-8859-1?Q?oENSbDeYoeubcLT4Uz2oeGnDu3EGBxd7QhezEKmls9nwv1WB5EnXt/EutJ?=
 =?iso-8859-1?Q?gxzcUFLiiKU7WZ4C5uhoYvqtP5WX61C1t4VDNTxal9e8BpRzgvRrtbk1RD?=
 =?iso-8859-1?Q?Xp7UFyXOdIH74mn/AZO0i4BfjQKLVDQoAh+4x/HJrzVJKlSxAGnW6awhA5?=
 =?iso-8859-1?Q?zApDPkFZ0Q7URKTlen2WgqkCYelkm1T1wM0YakvkVh890f7BrzpFVUrSiS?=
 =?iso-8859-1?Q?zcraal/eyKZtlLDxaFgklsBpAgvqvs0SJa8NSxIxdOqY91iafWjwooLIea?=
 =?iso-8859-1?Q?OjNcoQohs7CzEalctrVr0WBs66j6s7K53P7ZuYgUpGk6bP02isNxj8sUBX?=
 =?iso-8859-1?Q?83qM3cwRR0WmSywl6QUCF5cOSA/IvlEPCFzIGyJunuLK/cl+gr7pY74CKw?=
 =?iso-8859-1?Q?kCru/ispg5QkNRu1kkbcGgzTccInx1uSJN/4MtKQWlfx6P36VNKYHyLsBu?=
 =?iso-8859-1?Q?NlT0s1neMjg9n+8JAPLZSX18QeRiivZDQKXgM1iikI8AW7fRIIUq1oU5B7?=
 =?iso-8859-1?Q?mTc6KJsqpNKKKwVd46thRHX3mLM7xMFR/W83SrmQS/SSdJ1rwlre1PFfYX?=
 =?iso-8859-1?Q?adAebadF0NwmMU8TRSSRNa+CLYkr1rjyG9lSqZCeAh58vEFV8qThtxHeFN?=
 =?iso-8859-1?Q?nmSYycm135E6MbVDmRcmZIYrJ6vMvEieK8o580unm7Wp2W+4eDJW3szyVZ?=
 =?iso-8859-1?Q?UKmEfa7eRnJCRXbGvsRLsWiZoeUFOYqoQY14Wkcha+ywiBmieuaHV9Erv4?=
 =?iso-8859-1?Q?x2xt+3eQzv1DPSNeMxP4EuWHTsvToCup23WAN6KTc8GaL9bOE9MU2jeBKV?=
 =?iso-8859-1?Q?hwn8k1SHtXpnLYyDAakMFGdoPobYvxG4ySoOlXU3SJsEx1NAbYw/Z+G5/U?=
 =?iso-8859-1?Q?qBBVgvSpIyZ66CWmLPEuWhd3tZndz5STebMNmHE4PwEwQL4zucy1AMolh2?=
 =?iso-8859-1?Q?LXZaTt5HLQvY1Z1D9qe8NCwUYKAm6Wf/okPG8Y6GzY656QAlpPBcLsXJTu?=
 =?iso-8859-1?Q?QsYxdXTmGx1ZBj0a3ACR05wQ7tlJbhs4he0DWSSdP7B+jiWw9t1n7pRWsv?=
 =?iso-8859-1?Q?3hHKvcKVUz2cBBZ8gwGGf1cPlbYtCMEYHPZDijkwiSJHcwrb5xqtZZop0f?=
 =?iso-8859-1?Q?joH5aT612lJXYjiS47yjPzHzPmPdavwtT+Cl8gYywzvHhwEZA1z3asY6zY?=
 =?iso-8859-1?Q?CLW+6vvaXbSh7mMKYvQ5bw+eYVQKbOZ5nEtRl6j1cksEFuWY9wfNDCALdv?=
 =?iso-8859-1?Q?thoW/3CRBcVpVieDMmtbOlSV/c2besmgiHEMfKpZcAu3vy4ChCC20p9dtU?=
 =?iso-8859-1?Q?Rdr3URkB+rtyR8I+gqDOfVf/TSt9JYfx+0pzGTXsO6s1A8Eo/Pi2vMSki5?=
 =?iso-8859-1?Q?KyxiAUN1zsbvRo61X8yBdMwF9g/EXpI0tyUe9nEZ5mVlwBVzlL+h4yw+N3?=
 =?iso-8859-1?Q?RTlEDBw9tSEqBY6kTef+8ZpEEdxhYmdVkwUAWu8Vidkgq0WEJ3lSZXEA?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	o4MBeORR2unsH9QKCaQkzY2nrOx+bfucg7Y6GqVS56TVyE82SiYz8GCpxfF17XRv4Do878BysaLneU8BUxNmczvSrGJDww5IgBh+AGtjAbnzCFkgrBAhMWUzeihXYNNBgppAuoWLydwf5jgmw2PaUcMze9X7y/p6GNlAbJ9d7guuP9UuFh4MzKLqj4sk63rA9P1jnZgC14twzSIlTzpgVz06MYpcNi70UNjaI4LSmfPdh3TrD6x6WNyo+UXi6qIG2qsO71rsdQFP+9jrUs8xvdt+WRY9JD3bYP+bvfZ62/6NPz1H1sJBDgGGSL9maEsfwVlVTjlz1ukFEbr0xSijOc9SN92jc+PESEXNWfx4/TsssbwoRqj9VbkfCezqAD3UayXWRQZFMgzVI7pjwmoBv2UijsOt643tw5N7yfPTGafv9KxSRswCVBqvpYecmk2OK9lia3qV3IlAdVoQEzH3YA18zcNkReQgp3GeWYXmJ6j8tgVvXquB+Urjm5vpx8QLVGcPswY0ciGQWRloTxW7uWwqB21yuh8hyCqBcwhW9Vzklg8mqMPAPkgk4K0ZdxjRp51EhSddQz7dk3BQH8YMUJexV8923nV8st6E4gWpi48=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e65b719-3841-4a0f-b082-08ddf69b00af
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 10:06:15.0188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g/4o0fEvTO9DhNMX4qGIB6FsAABqj/FSCBATrP5VIbdsOYr8PTBIzMujet3p809kPGiJ7PwyuTwOQGMR/9ilrqe4KSqdO1KCCU4gq1w3hk4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6379
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-18_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509180093
X-Authority-Analysis: v=2.4 cv=b9Oy4sGx c=1 sm=1 tr=0 ts=68cbd99c b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=7CQSdrXTAAAA:8 a=PfG_9dqRh3ySf4n7azgA:9 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22 cc=ntf awl=host:12083
X-Proofpoint-GUID: AohkwM5pesYS5yPJdD-7M5iIXD5g7Mso
X-Proofpoint-ORIG-GUID: AohkwM5pesYS5yPJdD-7M5iIXD5g7Mso
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMyBTYWx0ZWRfX4UR4WBAG+C37
 uojDrWfMxiuppXJu3M0rn8rTVkhe5dxY0Exu/i/YAi7DCxHhNQOrhS3F44sQXs4acpoSKS12Gah
 UM28WjUmKFQNTKUWb66KJgZ0UhpaxUi/A699v8OOVEWtvTkkzbehVYk8sQAwFh57fjJp7Bi+Gh2
 GaEw73n6u2aQ/jVYrNUByEe3QM6DB1XxxAPOpCEcs7kxNqB74STsN+c0MKNWspAJFCKAL+wC6gb
 ZBIb9DFRE2VbGPZUY8YZ5oy9uajM8bn2+AyJHIbJeB4R+3AHOUPLvsBbB0WGDcpWqQvYwn+f24r
 SDR7EHfjbh9n5Qwq/MlWbKJCyNrTVuhy4wgPM5tflqksSgTX2zHymK6ioed2Lx9s4VBT5lTNUnZ
 uhh8hqIoljmfz67y5PxBOZxK6/PoQA==
X-Stat-Signature: xd5ggygx95ggwbebpnt93p34cr7fcuda
X-Rspamd-Queue-Id: D354E80012
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758189987-98834
X-HE-Meta: U2FsdGVkX1/9UYD6xfiRGIRidn4DWmwupAdWdSspcMyhO7jC06IKEeQ8s3SzwLGA25sprDFktcW0BpZIarQzdnICyt0/WpK7R8CbFoj0Iu5HBYZoPF6mhy/3cXAJH+i5EFA5StFD6NZYkXX4lvWZzuAp3TAVZP30iR4DdExRNiKtzAxM6Ky3e9sQ6aMgSxT1p94Dh2MZtCs+41BEAtkS3iMhBGcV8TN0KPwHyfV4zzPVlluDQWV/4UAcMLX/I0c/wkeBANkyIqKTG+B1ETPhiqGaMnHlBI8mUO3aYBlkUCXxOQvZdvyHvwFWfO/8+5H2vpZIyDkxn1QNCuFLY6rkqZ+EEhQYsH905WbZ2EeLlomd1kGI2GmAbICg9PfUyjZCI7btwssEjJTFSW8rMSczQilQLVyba2L0j6au1Suvozxp+H5z05zoXxLpl5482lB59x/joRqRaxh0Ckk0UNBJLKat+DcDYtBxE6ZQx+jy00eo+28flCHqaJO+dz+/3vvPDhoWTHNQV27CzLSlAFHyZVvGVVXUGd/8UX/ZouoV2k9f7Su7mK4874bWVO8dxULdg9e5toMV514vzAQnFSY91Ii0r2/t8Z9WrBsfJdSpfk73mW3ZdW1/wo8qKmjyU2cjBF4xnhOvmrctdUP3P8UtoDJOM/31ISlqNsGzEbYN05MY7WrRm6Fb5/9H6mjF5BrkECyQtFMZ01TWiGVthd+K6PcGU/Glxh/HLd2a2mOJGocv5IyAUnG1g3rwFLcLJ8jDpCs3jhQaeuoMXKXRxDGtDjzEIZKUDRWBnFM+M0XqY2CYN+psD0YeAOBM6nqxxjEXFZjslpzzXFOqxh4tEInt2bqelsRH7El9oSVbDBVe/yuUdIpcjpES6vPhDA403r5psOJGT9Mojkp6M3t9WvnAY7CW1TntDR7DUHuKI+Kc3Di1ux9+W9LoNCOL07R8YcR2goAM6nHnrXDe9zhZL08
 rTjImltC
 RpFRjVMZLXKtzTed77SqeNxAryLJIazsjm9iY+o4JPzS57Q2LmSaqJYFrzscdrYWAr60gADwKW2J0po2O775e/V/sbvw98TGgnjdWRlLBK179IkMRTpV0JU96phTNzJ1wLHoRF5MKTm0dwaWcrPy3s1Bmj3CbCg2IUQHFAMRxZQhQUh4bp8/AJYtV8xgmQaqKhh+mATVpAECCuoDb1kPESZs+aFKwWehUMANYdhmyhTM9l3QrEu5oqmSB98OrVSTE+HJTz5fYWSbFVC5JpuASpxvOSBMjMMApflH2MKJaBEt0op9ujGVC9yxP6BG9W5+ZlQ4Kq/JteidMtsuSTHMpi2vJjroWAelFyCPWXgqgqgIkiVP7YrTbChKRCJ0STGwO2QEEQTpY9gVt7lmOfOFj/NL7NKZ2VjKLBKf6MsnxHNbPEDJn3h4n2CGYeGL6Q1glQry6oW7onS7ueIO9LaeVHwPnAXvYeulTQyoHsixd4CID1r6HibQMpkaCRjgxDppMVj28eplb2rRNvqVrUzC82cKLmsrlq7H9QC9WGX4klCUL2IdxqIyJrk757Xv7s0jqxo6MzO15tZURtsQoUc5Zz7ZwY9Ee/xBYZu40d9eCoweqJIEW+HTmOFbSS4UmjF5zdnJVB2lJAZ3ULky7VbeA5OfJLx2jVIbqEKUUaWVCCCP/s/M402a3yPEB65udCzhovdMHl9A/Gceh3o3HbddKFQh1VQSbkN/V1XYm6TYmhKoIhXswbc/nGnKvZj65KXhc5FrPScQSFQh0DWBodI2uLC+r8Cf6mgwAeNYCIMWMwecC10CMofn7hTwyNNcUDvsHpZf6OsJWinQexmJ8IqiTeellbqXAuElnvINCY6EdQ7VCPGvq/9VTOEFyFJxIJxvGNZF5BKwHU06eEFsumSiGBek34db4tUF6ZSfUXejkfuNuygp8pcVxyJvxXcC2VZp6EdgrqmqzEp2FRnE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 04:11:21PM +0800, Lance Yang wrote:
>
>
> On 2025/9/18 15:37, Dev Jain wrote:
> >
> > On 18/09/25 10:34 am, Lance Yang wrote:
> > > From: Lance Yang <lance.yang@linux.dev>
> > >
> > > Guard PTE markers are installed via MADV_GUARD_INSTALL to create
> > > lightweight guard regions.
> > >
> > > Currently, any collapse path (khugepaged or MADV_COLLAPSE) will fail when
> > > encountering such a range.
> > >
> > > MADV_COLLAPSE fails deep inside the collapse logic when trying to swap-in
> > > the special marker in __collapse_huge_page_swapin().
> > >
> > > hpage_collapse_scan_pmd()
> > >   `- collapse_huge_page()
> > >       `- __collapse_huge_page_swapin() -> fails!
> > >
> > > khugepaged's behavior is slightly different due to its max_ptes_swap
> > > limit
> > > (default 64). It won't fail as deep, but it will still needlessly scan up
> > > to 64 swap entries before bailing out.
> > >
> > > IMHO, we can and should detect this much earlier.
> > >
> > > This patch adds a check directly inside the PTE scan loop. If a guard
> > > marker is found, the scan is aborted immediately with
> > > SCAN_PTE_NON_PRESENT,
> > > avoiding wasted work.
> > >
> > > Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > Signed-off-by: Lance Yang <lance.yang@linux.dev>
> > > ---
> > >   mm/khugepaged.c | 10 ++++++++++
> > >   1 file changed, 10 insertions(+)
> > >
> > > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > > index 9ed1af2b5c38..70ebfc7c1f3e 100644
> > > --- a/mm/khugepaged.c
> > > +++ b/mm/khugepaged.c
> > > @@ -1306,6 +1306,16 @@ static int hpage_collapse_scan_pmd(struct
> > > mm_struct *mm,
> > >                       result = SCAN_PTE_UFFD_WP;
> > >                       goto out_unmap;
> > >                   }
> > > +                /*
> > > +                 * Guard PTE markers are installed by
> > > +                 * MADV_GUARD_INSTALL. Any collapse path must
> > > +                 * not touch them, so abort the scan immediately
> > > +                 * if one is found.
> > > +                 */
> > > +                if (is_guard_pte_marker(pteval)) {
> > > +                    result = SCAN_PTE_NON_PRESENT;
> > > +                    goto out_unmap;
> > > +                }
> > >                   continue;
> > >               } else {
> > >                   result = SCAN_EXCEED_SWAP_PTE;
> > >
> > >
> >
> > I would like to hear everyone else's thoughts on
> > https://lore.kernel.org/linux-mm/750a06dc-db3d-43c6-
> > b234-95efb393a9df@arm.com/
> > wherein I suggest that we should not continue to try collapsing other
> > regions
> > but immediately exit. The SCAN_PTE_NON_PRESENT case does not exit.
>
> Yes! Let's hear what other folks think on that[1].
>
> [1] https://lore.kernel.org/linux-mm/c9d4d761-202f-48ce-8e3d-fb9075671ff3@linux.dev

Since the code has changed let's discuss on this thread.

Dev - You can have guard regions in a range that prevent one PMD from being
collapsed, I'm struggling to understand why you'd want to abort the whole
thing?

Your reasoning there isn't clear at all, so if I had a guard region in one
page in a giant range I was trying to collapse, you're saying we should
just abort the whole thing?

I really don't understand why we would do that? You just skip over what you
can't collapse right?

There's no reason at all to assume that overlapping regions here matter, we
can't predict how users will use this.

As Lance says, it's best effort. And also note we already do this with UFFD
WP. And note this is also a non-present, PTE marker.

And also this would change existing behaviour which treats this as a swap
entry then just fails later down the line right?

So yeah I don't agree, I think it's fine as is, unless I'm missing
something here.

Cheers, Lorenzo

