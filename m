Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87AF5CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 08:17:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA45D8E001E; Tue,  2 Sep 2025 04:17:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB9308E0015; Tue,  2 Sep 2025 04:17:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0ACF8E001E; Tue,  2 Sep 2025 04:17:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8CC998E0015
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:17:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C76621DF37C
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:08:48 +0000 (UTC)
X-FDA: 83843583936.07.6A79176
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6F033140003
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:08:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=danEa9OY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SA7d2LUB;
	spf=pass (imf23.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756800525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6YVTGGq2FLvwinbOLSkkICDj89J8PJIp6LmT3fG0IUQ=;
	b=STdRjz8q5obXvFrezsLL1bPZXA9CgwPoZK8aktnriyBsmN3s7VAED0XNT7pwI44ko9iOvu
	RNFfbyKGH0Sa8F+PSQOrSO/EXpF8cpJczjjnnWtmWn/sUIDDHVSsOjcy4eR3WIdYPIPQFJ
	0F5VaDyVnZl+olrLLGH3K9ELMdMvZN4=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=danEa9OY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SA7d2LUB;
	spf=pass (imf23.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756800525; a=rsa-sha256;
	cv=pass;
	b=ixn+E3qNYDJqDsPsO41V9QVwnlmFdo/8kKm/dYy7WjTpvvkC8SkDgnsMTM8S9maVOD2nOL
	nHwMSMGQuAy/FqURpKY1r4GlHtpslQqPPFvKCvjwlTskzD2R0AFoOP8d2SAp1h6P1CFdJl
	Z7V9tRDd5SkQj1j6g1x459ndKwt+3qs=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5826fvZx016337;
	Tue, 2 Sep 2025 08:08:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=6YVTGGq2FLvwinbOLSkkICDj89J8PJIp6LmT3fG0IUQ=; b=
	danEa9OYIwchwMSXwjn12Cp+RTnw2irdDKzk4YRvDGyOSXM0nHxUDPDL0jEJsZPP
	kVfu2PBmJ0nc3szQAWL2e0Wn+RT5KKBZzW8pOLXMHq2+X1rhgeFDwJI3IRZshFGM
	arSWEq/iSSdjfNnfWkhxcbb0uNFkxb+KcDHBLdhxhizBAZ2YeFrprbIMRayjdPHU
	Bpzp1BJRxrhzluqXBrZUCdQ2u7pzOHKeyy5LdMViDigBKzOyQF6rbqDoTMw6MmIh
	ukqu3EliWmCQbYlWl/+AtfS3zbbFkGxTbhp5xF48pDFHvfqSndnC3iXldShmtOY6
	NXwSf1WibphS3FKz7MMPrg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ushvufxs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Sep 2025 08:08:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 582607kv011781;
	Tue, 2 Sep 2025 08:08:29 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2040.outbound.protection.outlook.com [40.107.94.40])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqreukhn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Sep 2025 08:08:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RAtEndfSeVUw572tkn7NJVYveCcfS6aRNwhdgOr1CA5QSs6IUWAUMLG7AoQzWfhkfqLz4gDkw2NQ5pmbXKlSHjHg/Dlrks7+pR8Q3mvgRpht7oTddvj8nMPZwg6XKoIhhi97D1vjXEo4y23jqjhXMVDJu8/e/nLKODO4tJo2qcWXTynC981gJOG9dW/MJiSm0cjYKSRCoEtJRz/QWYhA3fAdYCPkzD3a+7R/74jyKxE24TqjvUHj1zt3xXFlEDkb6ZpyvyV2uo1jP4Kd1RPWI/d9EqpZsgAFAV0Y3eQ7E3HoI9OaB/EbpjizcGfTV9z1zbz8aUa98m+gqJDOoYEQ5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6YVTGGq2FLvwinbOLSkkICDj89J8PJIp6LmT3fG0IUQ=;
 b=clX+UhBFT21Yj388j3Et82PA9UdYNZUV86+VaEZDhS9QTIQFX626Tu3GOlcp9dwO6M/wsR7m4mAufD30XRttu67KjwqT13VHtqE1RasHEU89uOk8m+yS4i50lBHaY7iW7af02CouKLkeRYFgFSunGty8vmnHly2dGL30bSJ9Pi0fXFfMSvYZ4ptCpQ+9GgIaN2Lf416jf2xZImmb+OcxiblLlbXL5D3CZ3O/9Xz9hZffd77hh1EnRo/S/xFUfo754FNkSruV5THx2JC5zRXlk9rY2gxXzVW8TMvQBh3cmMQ3QWCU5xQ9S4XKOMpU4+KfuyoiwxFXpS77l3FX+1J+Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6YVTGGq2FLvwinbOLSkkICDj89J8PJIp6LmT3fG0IUQ=;
 b=SA7d2LUBtSp0xjd2ZBjHVPUhe1+1WzjdDCylhI/NylmSFgDJ/0J1hqFe4cgJZeJBMh+vNPfuqNhR4Ue3XFyA5G2yD/V2m12O0VPsJQIZaZ8ouq6EMcMxkSS3pNIZX6yFbbVzrcGPrK/GH4Jx3Q9k/9w30Lx4cQE2r2k5xqR6K+Y=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by BLAPR10MB5139.namprd10.prod.outlook.com (2603:10b6:208:307::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.16; Tue, 2 Sep
 2025 08:08:25 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9052.013; Tue, 2 Sep 2025
 08:08:25 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        acme@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
        willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v6 03/15] perf bench mem: Move mem op parameters into a structure
Date: Tue,  2 Sep 2025 01:08:04 -0700
Message-Id: <20250902080816.3715913-4-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250902080816.3715913-1-ankur.a.arora@oracle.com>
References: <20250902080816.3715913-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0370.namprd04.prod.outlook.com
 (2603:10b6:303:81::15) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|BLAPR10MB5139:EE_
X-MS-Office365-Filtering-Correlation-Id: c0bf2c72-162d-43a9-1779-08dde9f7e44a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DsOLyuaCBJiwj1aPZVLLFbDjO5yKeTeO+YRcVK5bxPHH3fusWm5Op2IBHhDp?=
 =?us-ascii?Q?EOaBTaGQaMRdW/zaZ51+vBo1CoL+X7LTYYbYVUcm1dY/t5WYSWEz9Aqcjj+f?=
 =?us-ascii?Q?IniHy5Mo7LTt/ZgvY7wMUMoERoDS+2Kzt1buIM7TKeJwN0uoDk6MqAGRbIzl?=
 =?us-ascii?Q?TUkXfDzUxHt+mp0/rkjxy3bBb2f0c5Od6oT2c/KRQVIyWKaCuC4cq7YLcnZM?=
 =?us-ascii?Q?Y9ndd8dHhDgy7no0ftmj8LWEMh5peCedk/twVvEYrReF/QPpi+24aqXEpw1U?=
 =?us-ascii?Q?hItsQRSbddecnEEE0pwAZqjxaORg6m+e3TM9gct5BmPr3++YsUpuznV6aMrw?=
 =?us-ascii?Q?1RgCTgm2dX39ZoyIxKIN8QZKWliisPZ/yJWxTkQ1qjY3vsc2iZkDL++JzkwE?=
 =?us-ascii?Q?RRYyklyYgvab7Vp5LCbSQllUUGGov+LJnc0gQ2uw+MaNXLTjvvMJGpF1jRuj?=
 =?us-ascii?Q?fUtwA9V6L2Qbq8zzZnZeL/fCCbKeVqDNdghJaueQu1fIx3hK8t9ViPxseghX?=
 =?us-ascii?Q?q06y6GMOIkPc99B8N9nNQNNa1KNrbv53K6nhuUmCdFN6nRKJN8PUxhwojumm?=
 =?us-ascii?Q?ufur7259fYeJSgmLLrYa/BhbpknlX+r5Qtmybkw+5Nf6Ji5cUQKCrOqyxH2x?=
 =?us-ascii?Q?kcY52K3CF8K37hhO4zrbeKzQ6ApVffAB1rv2ziL1+m+c7QYEkR3fIOwKkKGf?=
 =?us-ascii?Q?U/RpHYp0+cNyo8Rk55Y7lbD72rQ41NwEszKNZADNbUlhppa0cnAJIArPhxl/?=
 =?us-ascii?Q?kp0YUGIpOT0dV5KDo+cMuDrya6TtUOa2vwpZbzpY7cDv6JT8cenTGHsfPdS9?=
 =?us-ascii?Q?eQVxvU2wfnWmhLsoNVyIvE8HtnYCEUlKzOGcmq4nDGr8xwlYS3AfrNN31IqC?=
 =?us-ascii?Q?B9cKJef7kHUX5O4OCL7T4EwNToZWdiwJJKQrVsPikn11zkzR7omPd/UwFr/D?=
 =?us-ascii?Q?CN/iYxG+Me5SG6IOYBIDhhRgKlVwBLEpR87/FjXUV4tzhbcAS6KkU2YU9eq9?=
 =?us-ascii?Q?2apj2qbzQ4MKe24NSxNvoHlAe+XYKWD/mkGLkORUjW4WR3ytDauS5iN41U19?=
 =?us-ascii?Q?SMDnQKBwYDNNkExtXW9Tw7v/g7uBKAGMqp7n67e+GJMRIkbmcRx06fLD98bS?=
 =?us-ascii?Q?OACaZK93eK21JM8I/XfOb8Nr9iXz7YDjCP4q4srvY/jG7fP50S64RnjZgOBa?=
 =?us-ascii?Q?pLpL1dSbmPsnY2/ZxR3PfTXI3Y3EzVooFQm4B2hlxewSEZvEc3GtJBTMRHW3?=
 =?us-ascii?Q?7X9da/cU39NVK9pBff5P5AS/H6J8BJMaIFCsi6EO1cxxNWELeO3LezjqjHXO?=
 =?us-ascii?Q?7ZGFab1lQilTE44n4A/N7uwWGv0xY0UtQj3hWluK+YP1BWvej2s8CvvS2EgT?=
 =?us-ascii?Q?uq2IzVgGxCV+i5ATwBBn86ULxs2TTyybDVbACLulatnTYlsIoQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bgW3Y4HkIPhAkiVXh1CZf2scEEoZCeH8kit6DXvokxbjvDQrDlHxk0x4jHA/?=
 =?us-ascii?Q?PY3msRcbUUjTkikgMDRZU42gVYbPTEPSCxAue3q5e7CgvxFjXL7AhPigec3r?=
 =?us-ascii?Q?ksTAORP5IWA5xBd93qqL22HwBXHdjm5mK1RDAyJr4wREePkPGGm8eDXyXg5V?=
 =?us-ascii?Q?sUOCEg82B9/xEANcy7TYaQxls9MV1Mp8R7tXQRkgHZJ+AHY4r9xjce4Jn8Nm?=
 =?us-ascii?Q?2AV+5QX5noeA+KfsE5g/dyPRsqPwwxkoT7wC1eo2pavQSRFFz/MHa8KRE569?=
 =?us-ascii?Q?IIQ3ZS0qzU/ybZd/qnO4znmQNx98f4lKoGe1waKR7uvbCSW+nkk4TzmtaPP3?=
 =?us-ascii?Q?2O/CRZ7l3HnW11ZZzFbkn3S4wVOh+T8Neef951OvMpTER7NxQHQo5YrRRaQF?=
 =?us-ascii?Q?VE/e0q4hJuX/QxraBSKDXUvLZsT4krJdVPg+U6QpKqT5gOuFYgC06KgPBJRw?=
 =?us-ascii?Q?Mp/U85mpRWIBADzzLq+P0kzfqnl2mKFtd0PJOHpdMAYH3XbTlfX8crSwdZH5?=
 =?us-ascii?Q?AexAlh12Fd9fAXG31Ovsq4xiYyW+vy/PYBAgcucNZFDsDvUPxoZihXwi5Zjt?=
 =?us-ascii?Q?qWmaVZ9Q43OMyQoMiC0mVpO+mMAqMXcv6Cwb+v6K8ijRoZjuhFmS1yRaj9Oz?=
 =?us-ascii?Q?9VwJpsyhVfV76vkU3tI/DB2DeYXRJD06+RUnJm5uMIxpT7GFh/RKXUhb+el0?=
 =?us-ascii?Q?1VbhKvZ/QYAzsoSKvpmfIlI+PWz7bGwpZshr91KoDJDoH67YGiVFpHp0R/ye?=
 =?us-ascii?Q?3xi01dlmOl9bpAG8nRXuUhSTDbKLG3OKO4gWPVIJiKyfvrR4OaoWOy6BISoa?=
 =?us-ascii?Q?KbPXAXPfvGWFb6JVwGwIhktJLbdMA2TjshpIm7HfDtyTRqCmNhTIyTkHfSHG?=
 =?us-ascii?Q?mfluQ4t5P/DcjvpboQgaelj7FxZiZMD5ZhLekShB9qxaUoz5pInrVrgIU8Ph?=
 =?us-ascii?Q?dctI3zjuJ2x83/KEmSVFPbzcoYCvXaXZooXfmKYagK62aDyOBvBjMXKzHiMP?=
 =?us-ascii?Q?2RkVmxM/fUa9bLYfExm7TRnwoxt8XSQfoDw34Bt246rjSr/wZ6V9ZfPBOrWU?=
 =?us-ascii?Q?DLSydlKTP8MOWu8nWFNRWLwlrr847fFn/ewWM+9OhYP1Fn+O20I+4SGES7pE?=
 =?us-ascii?Q?D9ROSLkDWZItjkqKitZMnUEe8nAurb8Xcz4IT/7xuVuqS27TY7EVSsQp0FKX?=
 =?us-ascii?Q?f5fmjy/HdZcghTnI3K9TA6gKbEnXx+Yvv/jw4XSXlKU2sTVVTYkskFXsxPES?=
 =?us-ascii?Q?ks2Ui9vWkSPjSshYcRDXHru5NH2urs+bfENMgztBd8VO1alakwjz2OVtpXVe?=
 =?us-ascii?Q?+Wp+8TTFEsLbSxXucsP44BV1/HQsNAA4X7SU2oe6Ryx8y8oeRV+u7jJHw3nk?=
 =?us-ascii?Q?N8NYNKxTGY5NwnlYqTLVc+bP9YGf7jkuwaq2+N/803KvMAkO8/Azsb79tT7n?=
 =?us-ascii?Q?I7McGpyW9RxTW5+sypLs8LE6Fii7q0eO16u6Mm8EZTzrMPIsNtr1YrI1au9z?=
 =?us-ascii?Q?Uu88TdVHJ1zDj86YBn+EaNBPd60a9QjP1fTPWtcjMXzjXp1d0bQvxb5XI3iL?=
 =?us-ascii?Q?yb0o5s7NY/kKNx4vvWUOQNjNkDJtTfF+6EX+qZJUhJ46s0iprjsDF1LtAd0Y?=
 =?us-ascii?Q?Ig=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6BhtKoM3r9mjmncjXi+fePWGFD/pgYdkDTDbUG1X9MAhA3GIPe5CHzOtwTb2jwyYfs1qj4EOzb76OeN/7/M9Fu3J65OTar9NFmOZqbAc/ZpWoZcvGCjl1LB82L6Y0d9Q0/YtlkfP4V+qh2Aq8AQ68pLMh2ANNEwNUGEXdMpub546ynq+PmJEt3pZSVXQAdOKAChW8fwRz3kw/+8I3QPM46MSdkAwB65Qr7JYWxyjPYAa8M1gP/wmTnfjGKKYU1pU2kH7G+vv1X4Z3iHRS1e7fCkRbTRm43axbP97LacM9JqKXIpsBbrVysw4qWKDsEgFNii78GM6ovkdw8ldwGJajDqhgqpSVw/QHAziR5NaY7QE+vP/pJMFsRj3br0aVrqJSaS/AMDb+t5b1bGhGSVKlruFUna7KeiZd6NUsWIsqSSryRUkC3kessVA+mvj3MPe/vr3IFCfcdUWH2H35rY0acklfGAy1FkN3PP4kUS6nIsOJs/nHuNcnk9C+++Y3cLk3nLraCUktTJ2xHlswBDWrMIi3dK27H9kAS06uNWqt6vNKeFIGPmFLRny/IQ4ScxeX8VwUkB2BUShd0GNyZkQudVKjFKVmcb7gtA0o3KDJzo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0bf2c72-162d-43a9-1779-08dde9f7e44a
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 08:08:25.4155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DYe+Ynm3pwCz0Nst6OTcH+TOdqjZ/Z+JmoLFT2TDxpJaItaiRi0wI3Q29C9g9kC3I1hohqzd2d4kz5KF26b3XdYw6H4QZ5VZY+ZjmqUuwYI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5139
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-02_02,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509020081
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMiBTYWx0ZWRfX/knzNynWWCmT
 BXAhZ87g1XjFCdpA9jUdyRSkzlaZwiphhddXh6W8lkyl4zfQipUI8rHPQQW/44c/pFvejOjCMRS
 d5t5td+kH/nNUUudKTKKhhWKLEOWY04sMWPYF3IyrqWpiBrRh1AV2Q00Jk2R41zzXUcoigolJWb
 +d9DUyGmus8j8ekXA5l7Fv/UOmlibwMfWr/QDxQIy5ipOCTBLf49d02HoUJaDL2tPztyFLmudQL
 lXLBgpz+txTRZmNMDoze4lJf1tCG5JtCchyU/V0cUPqgA+nVb7YWt96bVUj2B7zs1HL4c+uLEWT
 77GkHDi75RCsZMpfPItY2Bezp8GrgotbFhi09S9p92rPpTqalnXOAKao2EbARcgzOfMoNK4K7NU
 cBiUJXbzTCloFTsfn1+az3Ma+QnMxw==
X-Authority-Analysis: v=2.4 cv=fZaty1QF c=1 sm=1 tr=0 ts=68b6a5fd b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=_WLpKjk4XQ775Vi3V00A:9
 cc=ntf awl=host:12068
X-Proofpoint-ORIG-GUID: zP2mjS-mYqYoDk969m5HhSCNjzfPQvRM
X-Proofpoint-GUID: zP2mjS-mYqYoDk969m5HhSCNjzfPQvRM
X-Rspamd-Queue-Id: 6F033140003
X-Rspam-User: 
X-Stat-Signature: nwp4sds9ui3h63zjzmefx53bjumyjrfk
X-Rspamd-Server: rspam09
X-HE-Tag: 1756800525-668801
X-HE-Meta: U2FsdGVkX18HSigDiNvro3zDrHTXc+Kt0oAZfETyLAg+3lODsaRUFK9eKGNU5Fr0JnBPvdX/eUzWutC11oqmck1NnpvwGGnQzDsphXNCb3WVgYONrbxrrlJgUgp/ExFYL0Aw/R4xrxB3IFIMnZJ3Q7iy7gtVoz51doQqZFoSb/gXL0Igw4UsTANMHlgOpsg8t+3L2sc02kC5yCpfoo3l7SMW8jGm0b1C5wwTN/rry/1DIFaZaQs+WYs6tZ9iZbOLUituQ2a/1n+/g1SsjVD3RxiBflITz6XbEJQs9elzl/8JqiGwdM8PSL3UvAP6Qrp9YGLgF0sqRfMU/rQ4NkJDXYa/48UoghDn5b710m9iz9n2ZXJ/pDIMIV6dSuZgaf4OHwa5Q5fu/GMkEdjH2AeBiaeCMhlFF6dTeDCjjxWBw/q6y0UvTamGrSYFLfYqQokVR7iXItfL3bLLR/cwBeIRtQE7V631NaPNPQcLJuS12Za0Evh1/CFoGpZKnKkMDExNOOxO5cJLa6bFQibtDXL/QMONUPO3kpRcw6MTTygvQNBwONRKJPmTHDxRUs+kHV+Xh3k2KZraMOKm6O9mxCqN6wzjdN+X7vwGsBAHBht7wPTnhzr8+HO0QMbni9YavizgJPUuD/MGAuXNrMkcuipGsj2/5u0DZVgrZT/sOUREZX/W45HqBNJVd81KxT7IdRrw3KLzgNS9HCg+PQlzpJMba1r70LW3qCm2LfAFw3w41RKMeK6nEgRryS5kONnpo74FkDNhKGRfQfZpPplrJqEh4nPTGEyzC+q8xXXihsGdHbOwhwJROF0poaf8v3eIEErYUQc+MZdvXp7FJmkpNOF9+9aEh06p/6bwWpi41/twgAijZa6ZHlmY91Oh9gCBuGXymxIqDAWJOXtNJRSmaUc0ReVoIbaiHNc/oWdIq27kkkbwVa8OFdyuMurK8qwRtQCPj/8dna3infLlxIPzoem
 2YeNsGU4
 N72dwRQZkjqSsQClXp256ytvnLsRfZdWotSwZbUGesdCmU5skoQ2Zs+8v5pOu1f/4aI82cYRSnJFQEq/E6TA/5Bbz0NpMBI6SYkXpA9txNGu1jQqn/l+KUtycvzXLZaD8nGT8LZdfO14U8qldztwxXdvfeODul79G+7s4SeatPOK+YGIh/PjA44b9jcA7qWjJGzZygXux50f7aXauTfQrJIHHulsvUCNYYOInGSLz6dMW7cW82zFrGhKYXF5hdhd7rz/crIRjeJH/HQMuJ+ABMUp3jA3txN9JOQeJx35TIE8CgkEnD9aAf6ylerc7oVSr+ZBbZa7swcuIjGMTX4jxlyVxJfAP6fOy940jpLAOCGGulKhER0Obwnn+UAuURY4BOWarOw0TGQ3rClk5HgtFXNy+XKb7plh2WmY0H4Oog0J/jYKG3a3I56bo/ylbpDan2e0F5I3fAZmg4lo/FdFdRe4W/GXW4YIMMSqhjX1UUOuK3m8UtqOKmY70hRvZ2Q3qbVEQUiw+jhoPwwW8NHA/CdfZhTuZw/AdVznY2L3AdofzvZx86fK6g1PJ05wDPtqcCSSz27xU4DXwZaYpQVf8EfoY80gWgFc2S9p14kQedH1+neftpGnnquMTLC8Gf33445FJAEUVWHTo47XYSHyDNR9bqAjqZvNvXVPYL7DI1GmSWv6yrU1/ETLEe5154q7MGj0K5QPkvnoeVPgJdEQ9vdaZgDUUYs2tugwtRynha7ahbMOQC23vDKdcs7Vbcv9Rlq4b
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move benchmark function parameters in struct bench_params.

Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 tools/perf/bench/mem-functions.c | 62 +++++++++++++++++---------------
 1 file changed, 34 insertions(+), 28 deletions(-)

diff --git a/tools/perf/bench/mem-functions.c b/tools/perf/bench/mem-functions.c
index fddb2acd2d3a..4d723774c1b3 100644
--- a/tools/perf/bench/mem-functions.c
+++ b/tools/perf/bench/mem-functions.c
@@ -30,7 +30,7 @@
 
 static const char	*size_str	= "1MB";
 static const char	*function_str	= "all";
-static int		nr_loops	= 1;
+static unsigned int	nr_loops	= 1;
 static bool		use_cycles;
 static int		cycles_fd;
 
@@ -42,7 +42,7 @@ static const struct option options[] = {
 	OPT_STRING('f', "function", &function_str, "all",
 		    "Specify the function to run, \"all\" runs all available functions, \"help\" lists them"),
 
-	OPT_INTEGER('l', "nr_loops", &nr_loops,
+	OPT_UINTEGER('l', "nr_loops", &nr_loops,
 		    "Specify the number of loops to run. (default: 1)"),
 
 	OPT_BOOLEAN('c', "cycles", &use_cycles,
@@ -56,6 +56,12 @@ union bench_clock {
 	struct timeval	tv;
 };
 
+struct bench_params {
+	size_t		size;
+	size_t		size_total;
+	unsigned int	nr_loops;
+};
+
 typedef void *(*memcpy_t)(void *, const void *, size_t);
 typedef void *(*memset_t)(void *, int, size_t);
 
@@ -134,17 +140,19 @@ static double timeval2double(struct timeval *ts)
 
 struct bench_mem_info {
 	const struct function *functions;
-	union bench_clock (*do_op)(const struct function *r, size_t size, void *src, void *dst);
+	union bench_clock (*do_op)(const struct function *r, struct bench_params *p,
+				   void *src, void *dst);
 	const char *const *usage;
 	bool alloc_src;
 };
 
-static void __bench_mem_function(struct bench_mem_info *info, int r_idx, size_t size, size_t size_total)
+static void __bench_mem_function(struct bench_mem_info *info, struct bench_params *p,
+				 int r_idx)
 {
 	const struct function *r = &info->functions[r_idx];
 	double result_bps = 0.0;
 	union bench_clock rt = { 0 };
-	void *src = NULL, *dst = zalloc(size);
+	void *src = NULL, *dst = zalloc(p->size);
 
 	printf("# function '%s' (%s)\n", r->name, r->desc);
 
@@ -152,7 +160,7 @@ static void __bench_mem_function(struct bench_mem_info *info, int r_idx, size_t
 		goto out_alloc_failed;
 
 	if (info->alloc_src) {
-		src = zalloc(size);
+		src = zalloc(p->size);
 		if (src == NULL)
 			goto out_alloc_failed;
 	}
@@ -160,23 +168,23 @@ static void __bench_mem_function(struct bench_mem_info *info, int r_idx, size_t
 	if (bench_format == BENCH_FORMAT_DEFAULT)
 		printf("# Copying %s bytes ...\n\n", size_str);
 
-	rt = info->do_op(r, size, src, dst);
+	rt = info->do_op(r, p, src, dst);
 
 	switch (bench_format) {
 	case BENCH_FORMAT_DEFAULT:
 		if (use_cycles) {
-			printf(" %14lf cycles/byte\n", (double)rt.cycles/(double)size_total);
+			printf(" %14lf cycles/byte\n", (double)rt.cycles/(double)p->size_total);
 		} else {
-			result_bps = (double)size_total/timeval2double(&rt.tv);
+			result_bps = (double)p->size_total/timeval2double(&rt.tv);
 			print_bps(result_bps);
 		}
 		break;
 
 	case BENCH_FORMAT_SIMPLE:
 		if (use_cycles) {
-			printf("%lf\n", (double)rt.cycles/(double)size_total);
+			printf("%lf\n", (double)rt.cycles/(double)p->size_total);
 		} else {
-			result_bps = (double)size_total/timeval2double(&rt.tv);
+			result_bps = (double)p->size_total/timeval2double(&rt.tv);
 			printf("%lf\n", result_bps);
 		}
 		break;
@@ -198,8 +206,7 @@ static void __bench_mem_function(struct bench_mem_info *info, int r_idx, size_t
 static int bench_mem_common(int argc, const char **argv, struct bench_mem_info *info)
 {
 	int i;
-	size_t size;
-	size_t size_total;
+	struct bench_params p = { 0 };
 
 	argc = parse_options(argc, argv, options, info->usage, 0);
 
@@ -211,17 +218,18 @@ static int bench_mem_common(int argc, const char **argv, struct bench_mem_info *
 		}
 	}
 
-	size = (size_t)perf_atoll((char *)size_str);
-	size_total = size * nr_loops;
+	p.nr_loops = nr_loops;
+	p.size = (size_t)perf_atoll((char *)size_str);
 
-	if ((s64)size <= 0) {
+	if ((s64)p.size <= 0) {
 		fprintf(stderr, "Invalid size:%s\n", size_str);
 		return 1;
 	}
+	p.size_total = p.size * p.nr_loops;
 
 	if (!strncmp(function_str, "all", 3)) {
 		for (i = 0; info->functions[i].name; i++)
-			__bench_mem_function(info, i, size, size_total);
+			__bench_mem_function(info, &p, i);
 		return 0;
 	}
 
@@ -240,7 +248,7 @@ static int bench_mem_common(int argc, const char **argv, struct bench_mem_info *
 		return 1;
 	}
 
-	__bench_mem_function(info, i, size, size_total);
+	__bench_mem_function(info, &p, i);
 
 	return 0;
 }
@@ -257,18 +265,17 @@ static void memcpy_prefault(memcpy_t fn, size_t size, void *src, void *dst)
 	fn(dst, src, size);
 }
 
-static union bench_clock do_memcpy(const struct function *r, size_t size,
+static union bench_clock do_memcpy(const struct function *r, struct bench_params *p,
 				   void *src, void *dst)
 {
 	union bench_clock start, end;
 	memcpy_t fn = r->fn.memcpy;
-	int i;
 
-	memcpy_prefault(fn, size, src, dst);
+	memcpy_prefault(fn, p->size, src, dst);
 
 	clock_get(&start);
-	for (i = 0; i < nr_loops; ++i)
-		fn(dst, src, size);
+	for (unsigned int i = 0; i < p->nr_loops; ++i)
+		fn(dst, src, p->size);
 	clock_get(&end);
 
 	return clock_diff(&start, &end);
@@ -305,22 +312,21 @@ int bench_mem_memcpy(int argc, const char **argv)
 	return bench_mem_common(argc, argv, &info);
 }
 
-static union bench_clock do_memset(const struct function *r, size_t size,
+static union bench_clock do_memset(const struct function *r, struct bench_params *p,
 				   void *src __maybe_unused, void *dst)
 {
 	union bench_clock start, end;
 	memset_t fn = r->fn.memset;
-	int i;
 
 	/*
 	 * We prefault the freshly allocated memory range here,
 	 * to not measure page fault overhead:
 	 */
-	fn(dst, -1, size);
+	fn(dst, -1, p->size);
 
 	clock_get(&start);
-	for (i = 0; i < nr_loops; ++i)
-		fn(dst, i, size);
+	for (unsigned int i = 0; i < p->nr_loops; ++i)
+		fn(dst, i, p->size);
 	clock_get(&end);
 
 	return clock_diff(&start, &end);
-- 
2.31.1


