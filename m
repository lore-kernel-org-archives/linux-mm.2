Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA238D31A3C
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 10:01:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7E696B0005; Wed, 14 Jan 2026 05:01:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E56E56B0088; Wed, 14 Jan 2026 05:01:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2E166B0089; Wed, 14 Jan 2026 05:01:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C202A6B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 05:01:50 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 75BE51ADECE
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 10:01:50 +0000 (UTC)
X-FDA: 84330127980.15.04B3C36
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 171F5A0011
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 10:01:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Rz22Kqiy;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JrRwoiYy;
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768384907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IB/sJL76ZwqT4jDeBG/OfXY9eFDs46LxkTJOt/1kVeI=;
	b=rRGd3K6cHzK4gfW55S6EuBMfwp1uftPgyVDOKOuK/tQFGIZU/yp3x4azEslfC0liggDwGX
	yGak1AjsB9ahmjIeF8qkZ9qYUj3QE91JaENDJtn3KzGQ3dU11mFoXtjm1q7F/SABPD/4Bb
	m2NqJ9alxbEOJrXiLOWXrKFeJamLBic=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Rz22Kqiy;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JrRwoiYy;
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768384907; a=rsa-sha256;
	cv=pass;
	b=OlqKBkyFOQdXzJMS/z1DzGt+AgQvH6R6M+4Il4zbu+qRqWq6fFVcdbL5Ht+DEQ2RxZDRsf
	eG3m7Fw5/UuBQvc5MlIluLq86SeDN5bLTOrC/Hc9+g97gGAdIrk7mBAMFc1O017E1WFvQa
	cO7lDFN/l+Pzimzd5DRF7Pp+/fkc9aM=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60E6M2To1296001;
	Wed, 14 Jan 2026 10:01:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=IB/sJL76ZwqT4jDeBG
	/OfXY9eFDs46LxkTJOt/1kVeI=; b=Rz22KqiyFNNDuGlMv7l+F8KM7ggkr7saL7
	8gDR00I4rPBjYN6h4j12t7tOinPKUMt0fxHKFXvuIpLpbIZCEs1hwXeNOln89Y3U
	LkBzrFsnJurQ5QztILXijWWF4xR3QvtsbB0Fg/zOLZkbEquMaxhx6V6t8jzcTDzD
	ThVXtbsMg9bQFQE2/+zHfDWw4RjFrVFfNkFbAYmJ1K+5h0Hj+jyXo5vHKBwHsX5c
	SU6FqPKKS/sQfCjTuBo/F+Ot6XeiU6BRuElm3dG3QbdVbNvKxmFatiGsWx6jqILj
	q3uyW/yer8eRv1T3/VqNUnCHYWnDvavujwpCZ5AUX20gwkyR5KqA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5tc07u6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 10:01:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60E9q9iJ008151;
	Wed, 14 Jan 2026 10:01:38 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011040.outbound.protection.outlook.com [40.107.208.40])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd79ku94-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 10:01:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zGg06di1r6b0uXJsU94+o0pY1Cs6plNYkZ1md83cfKkg2js9kR4dpEkO5WjC15LWrf5hs3bZ189upr4vYKp2RJbuB6MkZf+PaDIGgmLoS32OdK5V8Na7+OelUj22IZMiy9zkmwjkxxzRQS0UNiiAhFbzZ7dmmV4zVQhMjdT2Yw4aLEE8mnuIQ+LXxhu70rwkPh9diSA/pP9VdoHf0ddIgZ0xGb409AQeIqND26Y9SB6pjEamrpTYdysNAevOan1PsKRaCeR0DFaGqBvhtNNx0YQJKYThgnhlj6MRfTS5RoG24NiXvfHBjDUs0tj/2kva3B7cazTdc+sh7FqAu7UoMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IB/sJL76ZwqT4jDeBG/OfXY9eFDs46LxkTJOt/1kVeI=;
 b=UtNi9ejcMzAcQIoqPx6toP1LJqHgDip2ySQqJtevXxqLLKAG3yymlRsvWgWUv3QMEUmhdJ3fo9FTcSEaNh0mwzeGb1HUh8yoZFYlbrJ+j5SfPXAH3jN2YDT1I8nP0URLanpF4Cx6zX7EeHHIIvIm0OzUmcQ2gYg8vtU1JcNX8pIwzaNTKHIWG8uShb4Aha8PNhNw98zURsrSEHCARitl433HHYAkOw1+pVPNf8tzOuAppYfiZzsMaiXg5uqiETGc9EB9bMWWvFRbucvA3kgZJ2MiMqTxLYYqiuLqGhCGv6bn8K/ufGP9mUdZYOrHvlCTuEGDtx9B4nXitqmPFlNS0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IB/sJL76ZwqT4jDeBG/OfXY9eFDs46LxkTJOt/1kVeI=;
 b=JrRwoiYyHDk2V8unMOr54YsaO4TmX7H9aFMM40tG3Tb6Xgsed8Vfb3H0O4Vek7fvfTOe+L0s5/fvo9AU8ZFF5PbfN/RFeGfRKo3exfZxVMgdAQcVCdtaxt/Y0nqHmFNfGRud6oraILYso8JAkg0oz8k+bigtS1Dt2jgPSyNpom4=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH3PR10MB7930.namprd10.prod.outlook.com (2603:10b6:610:1c5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Wed, 14 Jan
 2026 10:01:35 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.005; Wed, 14 Jan 2026
 10:01:35 +0000
Date: Wed, 14 Jan 2026 10:01:39 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Chris Mason <clm@meta.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm/madvise: allow guard page install/remove under
 VMA lock
Message-ID: <27a07825-5dc0-449d-99fa-e1d49f9c5be2@lucifer.local>
References: <cca1edbd99cd1386ad20556d08ebdb356c45ef91.1762795245.git.lorenzo.stoakes@oracle.com>
 <20260113220856.2358195-1-clm@meta.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260113220856.2358195-1-clm@meta.com>
X-ClientProxiedBy: LO4P123CA0522.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:272::8) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH3PR10MB7930:EE_
X-MS-Office365-Filtering-Correlation-Id: c4599f46-ebb3-47eb-8d9b-08de5353e68f
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
 =?us-ascii?Q?A5tydlUuHqdtA9SdO342uxxJaMVno40PMs+EgL5frJKwxxGARH3K4BEUj5Xx?=
 =?us-ascii?Q?1XmViKWBKpS0wPThn4A5yNH2zy0wzOhP0ltz5JPTp5Ya1Qe1Waak9sk1YuMI?=
 =?us-ascii?Q?bWsYU+SDW02ToRoMENbLIBjainr6dEumoAxE8Zh7tH9FT3jbBhkTuzWy9yV4?=
 =?us-ascii?Q?TESt5twiVZmFaTwtTBDeIeV3jX0P7kWBobIJSUSjAG1iTQV/JcJjmhryeUem?=
 =?us-ascii?Q?AfipZOJLz5QgYx6bOlgKQ2siISB4hZCrGfuHHtmFrpye2fYjDfx/mi0ys6Mq?=
 =?us-ascii?Q?EzVU1AZt+KIMzMBIgoHi/dg8g6Rl5fdzOe2zezR3W2OShNDez+vGmb6ocj7W?=
 =?us-ascii?Q?gCilaRic2qfv7ReUoR0XqmtzBSbhWkjDIiNZ1oFADHcmzRt6E5otu6xeNanJ?=
 =?us-ascii?Q?Z8Lv9uYWUotNH5slfgpW+7bXmqqPxyrS6nRIFJ+923UjAOFLAWCr/dABQc5N?=
 =?us-ascii?Q?aTp/d1FiV4MrZ4qA2U8RQAvdQAW68W/FMZMa08bweqKCeQrtbMUb5/KUyKiL?=
 =?us-ascii?Q?T6jwjf+TdLS5B/g/JbLNRbe58ZXj3bCmyDirFAZf4qE7GS11QK4Imn8OS7xo?=
 =?us-ascii?Q?hNsU/0PQScS4f/j9uPKj+u8xBljt6c++5evp1EDZYpihLxhxeVWdFkxNE4dw?=
 =?us-ascii?Q?2qjoHG2aLafRX+vdSN949Qe+JrvCWQgidW11RuY2xgePN2DrAKF92r/a5MiS?=
 =?us-ascii?Q?dJEpp6ZGKsWDOo0azQQL9JYAP06Zx5MX3M3sgi4arAd7Hj2r65/+0NLB3zOl?=
 =?us-ascii?Q?nskFXplOqWgJrtX8dT9n6vg6r4Z4c1hS8o6KlzSMxzCWMun4JJ8Ksyk8rNmy?=
 =?us-ascii?Q?W2Ro+5RB8TFitL9aMe1ITVGictUKCOif9UgpM093jXy9gHqxCAGI1PtEGXUv?=
 =?us-ascii?Q?l/0ydFuUpDBT3G/aluhLkd9s2VJG8iKuz+bHOM0H78XYx4jPfY7bi1AzavnX?=
 =?us-ascii?Q?pi6GikEUmiHRXP/agmuAUf9Qi3uHThyiCbLLIt99gALZ4OnaWIRS8GajSCJP?=
 =?us-ascii?Q?Vw2E9UNjhDWge9oDHbfM5inXF1Mz3Uv/65gGnzVEcajfRXbDhH1cT/0D65qB?=
 =?us-ascii?Q?TwNQCFytEexbfSlpGxdyn0vn7eHokPVmGD2UEDQYEEXbzJ8GHslzEuBqx6Ic?=
 =?us-ascii?Q?T+2n2JfpsnzE0aQtU//4GoQF74/xn5OeXPlrCnquWv/dn6piUiTx80exeJ+6?=
 =?us-ascii?Q?IE+4xwt8Ywu8Q2TfGXhRhWqciHwcb/BirqOhbROYE28m34EnLeApISj4OqKh?=
 =?us-ascii?Q?3xOIpWqV4z1zPhVJBM2q8ab1nuv9oHvtN6NlOB+OA7ZO2yriyRN81UvzVV/E?=
 =?us-ascii?Q?VrQhGZMEreIekdNZRw4D2sV9evJm74lDEWDNCZTtHSlX1OEv0IPYHL9ady6H?=
 =?us-ascii?Q?sm9yYo37Bs5eRnZR/43ZS9LA6eamce2V/HIvnBSMw0m+qysWqnOzMfjzHBph?=
 =?us-ascii?Q?VPDEBMcCECaNKJFLG83OXzBOfS/BaAcS?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?bnt9MQwvEeEV2/uZHPY+yzQO9KW74Yc6r699ldtCHzQkUCfNtDkQlGfu8ZoT?=
 =?us-ascii?Q?Xib8pAlGsPQt4Hk6DuS1JtoIj2woJDmdQcKDvltHabv5Z+uhuqbl0To0ZxoV?=
 =?us-ascii?Q?iiOBqu1OGlCO/4Kih97wyyRaECld0X0ob6VSvp/URHLtIaYXg6Eg3OHx7vMt?=
 =?us-ascii?Q?mq5MGW8FXuTcOVlRK1rDAqIGTDHor67w6mZTMxcN9dNyB7xAH0vyfq1qipea?=
 =?us-ascii?Q?CthWULM+vQx2gPy3tdxqESbvamk8JVJKkq+w2IgpE82BXIN2VHKO3SeKs89U?=
 =?us-ascii?Q?L9AeCCLEITcEx2QrarBK5vXIfTuOnwxDR/UD+jAMrmuS7IiQiAnSlRf53sfH?=
 =?us-ascii?Q?ISI376drjurPg0znJbGzHBQjB+JgIVe09Zrc/Ev0lYXeHisExl4ylkhwjVlo?=
 =?us-ascii?Q?oEhLucRYa0vVSVs1TtErfIizRg9OxywD6aN+fABkOFFl/CSRqfaj7UUSjwIx?=
 =?us-ascii?Q?sQLcBk6Iyd8dYxyNhseanf5HLKGFP/cg4S716MmWHGavYiW+IxElrN65GKie?=
 =?us-ascii?Q?wcjw+9KVRye6oRODrgDGkt0c71xNKYMh/CGcMEI6+cW8NJw+ZLdwQGxt4IlW?=
 =?us-ascii?Q?tuimMIT7+UkgVCLmWRnLrPzjHPDqKZORwMHAPIwEPxm5WELuePdbZZwG6HOK?=
 =?us-ascii?Q?Tbv7bcrPNdlMeDKSG+ZCuMy65QU1PtE6qKOBylanYiBFiSp2Sc89pe1NjmZB?=
 =?us-ascii?Q?DPnuoCInJzdML7L+E/RF8eeauSvSppm1KHggnk+ExdAt2zSvQc8QYccA/pZb?=
 =?us-ascii?Q?Aba5JN7pDDXZeH77sz2aJL+nNA7CLBOYzQEWB2Jg5/lYhs/uwDbkvocD1Fco?=
 =?us-ascii?Q?YWmGaK54joIAp/HBRmBcgcUc2YPZR9ao8rAabFjMhWHPY91GM7Iy/MHwxWu8?=
 =?us-ascii?Q?yoFpXgxzYe6ZOI8tDyqKsqdheQlHVnl81C25SMK8be9eURiL+/3NiGbWbOGB?=
 =?us-ascii?Q?jP0k2Y1I7eRxdJ29/urXFNEWL4XQdrUAfErHJD+p0Z3dxxuV3tmHM4/hE4QJ?=
 =?us-ascii?Q?N0awha0dK2Sil1TqbuNpWeD+LtDeHYZpDepUJWkvxfAgeQxECF2UaTynkdlL?=
 =?us-ascii?Q?2HGNhWOTuejVcngLLPP/DZTgJAOqKsnZ9iXVDVDYA3KEi6od4p1rVMIiDmv3?=
 =?us-ascii?Q?xnqQIEUcku/PHqpD+p2lkvPi/kwl8PXIKoLp49PlpfhUJVcs6KAsdokeXbvM?=
 =?us-ascii?Q?qWIWQEfKbQcLwQ9fSB49KXJms7igun4+Yz7B4ok7KtN9Dwv6XTXcpC7c1RH7?=
 =?us-ascii?Q?CRnaIGjpmBIQvj72Q8B2tg09gp8C9S5V2GXzfS8BWpSaXWXZfEN4M6w/4Vtm?=
 =?us-ascii?Q?OLv5hC32ldSt+h0vRpDGgZFUR0MX3nJJ8Yv6ls/shdYWud2z2x1qivHmdlQT?=
 =?us-ascii?Q?wYHR9OmDpYwwqOlJyyNpNiXqU0tuH+h2re3rt7k6aPCh2yvotVTzfpunwn82?=
 =?us-ascii?Q?FU5/eqBmPhCkXaeeYhxD4uYtaFrcDU7vUl0RgpVaVdju0UmVBwakoFC/9rc4?=
 =?us-ascii?Q?LHu0DJvFHkAo//nNCWj1KwdvZESg3F7L/trn5RAKfHkT6ybwqZCjEoVCznkt?=
 =?us-ascii?Q?wMSbPXZOi8Q7/77+HsHIORxAsPLq/bDdSzBrlrBQcuNScIo15UWNhNQWMuZO?=
 =?us-ascii?Q?DYkQlpZQeu+ceL+Lz9gQgEwLAMX9yUpHn1MLMXA2ne4YVBfKTkw21sGXk4/K?=
 =?us-ascii?Q?HaCKGnjidMTSgmhf/NqFiWggNv2oWplw5gl7VKM75/xw+fdHOvntDj+eZzKe?=
 =?us-ascii?Q?2MbUQzEX1bIJso7f/zp2ZeziwUfYldI=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JWdMsMVI4meWu4SKnfFFjEYmM22SyxOZQBxhru2NyVE5b1wQcc4z326ZelY9pV/qwYy6NcVbdaNqTzb2XfIVym2jolQsxjaHIbKJdiehQ1ffXlIibqQPrOCSmBb4IHCkfcahF7AWCwZ2htbO6ZOnCNvvLbFsOg2z/b2JpzKHvP9HGplWP5in+Q+PM6Yyhbgzt8IHaj2iIQAjDHyi0sTzWmTU+N/jYyO2CnIiwBHPyeCG2Ivca+hjA2ZNAjEOC+K2WUiirBPVSlu0dKaygMDATSPBfM+2UGjurBjNT/Jbu48wq71DOp5BaAsmxYv0VqJmJr8LbWNYJOgeBkHR1CLqIoQuNQin5i2uRMbUL5xPpCa5zxGJRRuBJa1p0q8/xQ1QKF3xyusVRUzR8rOLCErxS7r2PqEZbn9y0eUjZhvCKzesNGXgPvqpN1UUYQnYMjki5iRvb6Yp0dbCyXYtm69KpSP4qQ3LyUqESUdHSSaX1hJxXoo1H8zydKyAcAX5YQGuYxB50pAOKmzV6nNWlAGDBQPHdCxmz2exh+Rqsi+UQX5Th6cae0J67xrfkNhroR7UBcrR8rPl58HxzZ3Kp0xMkYttwcv1nF3woTXhu09XCck=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4599f46-ebb3-47eb-8d9b-08de5353e68f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 10:01:34.9790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vYY8Oq0pPRrnztvd2sxdjuL7ZZK14xjbxp1Rc8Ox0nQQecJVw+LVvFiSXgQG8Wj2iiYdgpo4m8rnpXyF+4oJsFDBJJq3DllVzdXCuLGiP9U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7930
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-14_03,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601140081
X-Authority-Analysis: v=2.4 cv=XP09iAhE c=1 sm=1 tr=0 ts=69676982 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=fwCTt19ZY0avrvX1JkcA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: tCUJ40QyN54XzFFCH7TOzvYTdvVOPRU2
X-Proofpoint-ORIG-GUID: tCUJ40QyN54XzFFCH7TOzvYTdvVOPRU2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDA4MiBTYWx0ZWRfX2XNQEqt3zEqQ
 AokWLugVwaNqaQ45hsmFxSh0JGruHJ8loBPPZbkvRgi4VTsKvOMcjF0BfKNpTmdiN9qsRufHeYP
 Uu0b2KgCJZ2f5ULfIJNzQGo/PpqNqypuRDYCw7nGoOIW9XrjOfMAnmwGZq3n3wUJ1ztzjsYOa32
 VM1Fr46vteeM2rzOFjYVpCn4kRIN6qtO9CKDjHokCVb1sxda773ZA/paDfbrovvtKT+4c39U8gf
 lCJVbKj3OE+79En2vSzUhjXfVLfuJutJp8B9Kk/75Uuv78YG4BPgmAlBXs0USzExi9DNNCUfiNy
 PUhtn06i5H+0iRGgcTDwTmhKPbTCaBQY1luuhRKDUrMdrClyHRZSSr9JbsC0DmGZYjhRIP+oYtv
 LkN0PLRxMF4ekvBgpugREJHEUstFPf7FIPXo3TZmQDZThF8LQFkpqYwKFGcO4usOvesx3l2rJ4+
 zFMe0jox9MixVUwQTAA==
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 171F5A0011
X-Stat-Signature: fef773951pqjs31e6zrbw7hxkonrxiji
X-HE-Tag: 1768384906-816744
X-HE-Meta: U2FsdGVkX19WiyatXVnzJnHNdkIvReNP1PwhL4r+d43XKk+XiaRNfTUu9TjEOjZJgKs+vCY1h6h9h3L8V4kfsQj+dIuWDGttJDlmNQSv3s684AXLiMkJpzU/pxzCNSxX5UclW5MIE2mE4Xh7gDWc8aporQLqcqIWl25FwANOrCO3PlqaBwqTie4DAL3S9cEODTb+vO47h32+VPVffnPEpRD+QuLYlRaoTA4RoJirA6Z1KqQw64sEZ8t5w3JzoQC32DmIR7pEzNIsLTzouIk/Ua3/HnXNx16VfLv9peEnr+guiSTSOuFb3tr0RZIOccwK2gLwDIBns8Si1jGW7B98424HUq9rEF9wRGdsY5xmRThVAN/TxD0QPUjskiB87a/J4ztL2UXvv8oeoFMpyax2MYAQL3O2aDI3OACv1AlNCwL/x1tPMfj/y32ZwHiCBw6y9BPKzlG/almuMtdSz5BS+qKNWX8TFLfap90vvXec55IcWk7EnUKA8fg/NiR/BEmL06MfHSVb+yeuZNFCXzyvhBeWVVB5EoVNWceXt4cKc+DQdyzwlX3Php5IVTXTIOvYes8bCGKoneiKQV19fTncCpmS4cVMejv1DmnhK9tYNiYTZeGTj4VtvL+yGqcRBmmQlJQpp48MG4PvWoDc5o2OUIwQA+GwtwDxadhkOMLmbNyz0O605nDa5rZ61AAhy5uHDsMfZN9MDHG8tiD2H+mOe6HdLqTbauVP3vjR49M/SwdBK91JyWyeR3vVdh8TepRALXntNPDCTnsZl1pCOn0+ACwQnfLIpdNPtBfhwM5zO3eiAdms3aY5IL3ilZIonBzvGH7enu7OTfIG7OCVKezA3zFsrKKcQcptYrBf63Lhv1X+OG+XQSFEneFewam7m+Rz/EsLx6x49jEWEfIPGbNXOSmdleMW79OgnJETYMlizS8+pXr5Vs8q+cPSo+6vDyOMGwqIU77JFlWgMJPfHbn
 CAWgCS4P
 CVM9howj5mBuEJ7nRVoUSu4oYoYh8GKrq/Rtr8T7eI2b7kX4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 02:08:51PM -0800, Chris Mason wrote:
> On Mon, 10 Nov 2025 17:22:58 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
>
> > We only need to keep the page table stable so we can perform this operation
> > under the VMA lock. PTE installation is stabilised via the PTE lock.
> >
> > One caveat is that, if we prepare vma->anon_vma we must hold the mmap read
> > lock. We can account for this by adapting the VMA locking logic to
> > explicitly check for this case and prevent a VMA lock from being acquired
> > should it be the case.
> >
> > This check is safe, as while we might be raced on anon_vma installation,
> > this would simply make the check conservative, there's no way for us to see
> > an anon_vma and then for it to be cleared, as doing so requires the
> > mmap/VMA write lock.
> >
> > We abstract the VMA lock validity logic to is_vma_lock_sufficient() for
> > this purpose, and add prepares_anon_vma() to abstract the anon_vma logic.
> >
> > In order to do this we need to have a way of installing page tables
> > explicitly for an identified VMA, so we export walk_page_range_vma() in an
> > unsafe variant - walk_page_range_vma_unsafe() and use this should the VMA
> > read lock be taken.
> >
> > We additionally update the comments in madvise_guard_install() to more
> > accurately reflect the cases in which the logic may be reattempted,
> > specifically THP huge pages being present.
> >
>
> Hi Lorenzo, one more flagged by AI:
>
> > diff --git a/mm/madvise.c b/mm/madvise.c
> > index 7ed5bedb8f8ef..2a165e9beb5bb 100644
>
> [ ... ]
>
> > @@ -1173,8 +1180,13 @@ static long madvise_guard_install(struct madvise_behavior *madv_behavior)
> >  		unsigned long nr_pages = 0;
> >
> >  		/* Returns < 0 on error, == 0 if success, > 0 if zap needed. */
> > -		err = walk_page_range_mm_unsafe(vma->vm_mm, range->start,
> > -				range->end, &guard_install_walk_ops, &nr_pages);
> > +		if (madv_behavior->lock_mode == MADVISE_VMA_READ_LOCK)
> > +			err = walk_page_range_vma_unsafe(madv_behavior->vma,
> > +					range->start, range->end, &walk_ops,
> > +					&nr_pages);
> > +		else
> > +			err = walk_page_range_mm_unsafe(vma->vm_mm, range->start,
> > +					range->end, &walk_ops, &nr_pages);
> >  		if (err < 0)
> >  			return err;
> >
> > @@ -1195,8 +1207,7 @@ static long madvise_guard_install(struct madvise_behavior *madv_behavior)
> >  	}
>
> When err > 0 (zap needed), zap_page_range_single() is called below
> regardless of lock_mode.  If lock_mode == MADVISE_VMA_READ_LOCK (only VMA
> lock is held), and the zap range contains a THP PUD mapping that requires
> splitting, the call chain:
>
>   madvise_guard_install()
>     -> zap_page_range_single()
>       -> zap_page_range_single_batched()
>         -> unmap_single_vma()
>           -> unmap_page_range()
>             -> zap_p4d_range()
>               -> zap_pud_range()
>
> will hit mmap_assert_locked() in zap_pud_range() (mm/memory.c) when
> pud_trans_huge() is true and partial PUD splitting is required.

Yeah I was already aware of this, and I thought it was handled via
is_valid_guard_vma().

You only get huge PUD THP for DAX or VFIO. VFIO is covered off as that's
VM_SPECIAL but yeah, maybe not dev-dax...

It's a stupid situation really, I don't think we should be asserting that
there but I don't necessarily want to unravel some locking horror show at
this point, will put on TODO to come back to that.

>
> The assertion will trigger a WARN_ON because only the VMA lock is held,
> not the mmap lock.
>
> Is there an additional check needed before calling zap_page_range_single()
> when in VMA lock mode, or should this path fall back to mmap lock when THP
> is possible?

is_valid_guard_vma() is the appropriate place.

I'll add a !vma_is_dax() check there for now and send a patch out.

>
> > @@ -1715,9 +1763,9 @@ static enum madvise_lock_mode get_lock_mode(struct madvise_behavior *madv_behavi
> >  	case MADV_POPULATE_READ:
> >  	case MADV_POPULATE_WRITE:
> >  	case MADV_COLLAPSE:
> > +		return MADVISE_MMAP_READ_LOCK;
> >  	case MADV_GUARD_INSTALL:
> >  	case MADV_GUARD_REMOVE:
> > -		return MADVISE_MMAP_READ_LOCK;
> >  	case MADV_DONTNEED:
> >  	case MADV_DONTNEED_LOCKED:
> >  	case MADV_FREE:
>
> This change moves MADV_GUARD_INSTALL to use MADVISE_VMA_READ_LOCK, but
> zap_page_range_single() called later in madvise_guard_install() may
> require the mmap lock for THP PUD splitting as noted above.

Clever little machine ;)

>
>

Cheers, Lorenzo

