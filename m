Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E10AC87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 21:02:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1E648E0002; Thu,  7 Aug 2025 17:02:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F5FF8E0001; Thu,  7 Aug 2025 17:02:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 895F98E0002; Thu,  7 Aug 2025 17:02:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7A4498E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 17:02:03 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 08D8D116B0B
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 21:02:03 +0000 (UTC)
X-FDA: 83751183726.25.5202CD8
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7AB4B1C0015
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 21:01:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XNW+Ywmd;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rzspb6U0;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754600519; a=rsa-sha256;
	cv=pass;
	b=YOxLYWGfiQ7y/fMUqwsnRbvd6Baji9ujYQv95I8QsLfEBJVuqSv6q++ukxrMrO7tuSWfxd
	igi8VPpjCBOc+ggQKfT8Dwp5T3z6hOkSoy3a9wSpEYIBeFxxiiQJJLeWTfStnddD63rXxe
	sOujw0L52hHNZSryXC1EBDATW0QU5bw=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XNW+Ywmd;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rzspb6U0;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754600519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FfW8J2NqDRpWPPpRXrYN/vP7TcAmXKADjFZCO7WIXg4=;
	b=vmj9UvMMna8hXCHpBmTZKxNUUp3dc19AjNpmG6/SXQKmbXZgCWY7/fkNsH+lxmMypJOkgi
	u2jDwpNtRkJ5l7Gb7cSCPkoHYL7wGtrl7mHhLZdo+uc6ReOm4MJrRlVsr4yumzK3eC1As2
	5ZYHw9o2lZZ8DoJc7CjIhzJq85WJNbQ=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 577KNAH8024859;
	Thu, 7 Aug 2025 21:01:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=FfW8J2NqDRpWPPpRXr
	YN/vP7TcAmXKADjFZCO7WIXg4=; b=XNW+YwmdYHH/EbeD9Don8QXBMKRDFXN31B
	h9+jDVXep/bAJy1UzYo0JXLaNGkZEnbQvp/wFNVsDsZ+Q+87SKPuIatiAvulKbdM
	Y73IEOSAlRvJ5IZv35T5mM2tOVwbzvKQj4IuV47uXguVm/kIhBya1DbC6rHuwGJw
	aPDGZOgxQGUkHxyu/NXpKE/Lmu11BJU1yIuXFVV4eYo9YjuvARDOaAZVGpFGOpmc
	Ghxpj8HPkOeWF3lVhKmDy5TBe9RcgHib+JA76maKphTNlelQk6osd5N5y9vOpCMC
	ftqG2D2q8rzy5pVek3rP5+qryKwG8Mp9OMN/OVKL8Wgfo+/Czhig==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvg52h1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Aug 2025 21:01:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 577KHLRf009726;
	Thu, 7 Aug 2025 21:01:51 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2085.outbound.protection.outlook.com [40.107.244.85])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwnxsdn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Aug 2025 21:01:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SHknIQWUM4aQMwB/oNhuzMxsKEeYrBgc6WwrNIHmJ8wX3uSX4C3zw0SclLOT57psl9+26/xEme6LUp6cO2rkcx1rGXWy3DSPR92Xq5459G2lNyN3dzIbvP6rr90UIvhZoQsFJRcaIXW84XY8n1X86jHojMQ3iXsoUv9/UGSzy6hmSDOiROKuojyzr+CQNeaYAfy8fe7//zODGU2gjAkHTOfjpnoWa5TmMwKiTJGbP72hRQSgcCixrUGSn1o/z1gc5EdbV+R6+Vac+yPuHnpAAmKyWo3BYlqjx9McQtrUQ3YG2H5WWpPSndO3dABH/yGOEqwv5LZ6PcLl13HcbUVGTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FfW8J2NqDRpWPPpRXrYN/vP7TcAmXKADjFZCO7WIXg4=;
 b=opHGXT5IjWGRSPeKhnfA6em8WFrmu3S49HdE3fYVk11MbxWafa8eT23onO8V8CVrnk+cPXTbBaSqK0GwqZyYQhXY1u9+JuSjgDqwhnTvQ3Hjjoa6z2GGpkL0rcN14x/6bBgFcFTQPRPQmZeOTDmwHHRlfFSA4islyNS1gdj/Sgw31p9nPEb5WDvL2GFmuEid9EJIhoZ5H+tSc8secrTxLBRQH95Ikjj2qIzVTNYw6jNt2X7M8aQlWvSyFRp12eDEYrdKzv+TRyG3RY6Np59BWVe7Q9cAwzsGEq+iz98XtHmC5OEzIV5HDt5CxjANIkuhO/ux/UWm8R9q0vKyWbAoZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FfW8J2NqDRpWPPpRXrYN/vP7TcAmXKADjFZCO7WIXg4=;
 b=rzspb6U0ExcIY3XqVY9be7pJgv+rwy7z0aHDSCxMAm1EChvRFtU/S+Q3ucVADjyM+YWRIms2bdNHfn73zlvuWuLMV2BGaPlf1EGiB+SnW7C2bAlXyIyeilU4iJaItYHnFrsjHSXiybpCWaFyzDb6fdjmkplyY2FB7H5HCUqvlyM=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH8PR10MB6597.namprd10.prod.outlook.com (2603:10b6:510:226::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.14; Thu, 7 Aug
 2025 21:01:48 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.013; Thu, 7 Aug 2025
 21:01:48 +0000
Date: Thu, 7 Aug 2025 22:01:45 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Barry Song <baohua@kernel.org>,
        Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH HOTFIX 6.17] mm/mremap: avoid expensive folio lookup on
 mremap folio pte batch
Message-ID: <44956337-9162-4831-8f59-e4abd80cc683@lucifer.local>
References: <20250807185819.199865-1-lorenzo.stoakes@oracle.com>
 <158e6422-fc82-4d6c-a442-2ebe956a66da@redhat.com>
 <3fc75720-8da7-4f6c-bdce-1e1280b8e28f@lucifer.local>
 <ee3d7b32-af47-42b7-bd27-0675c065d736@redhat.com>
 <adf7603e-418b-4f84-b49a-9e784fa7efb3@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adf7603e-418b-4f84-b49a-9e784fa7efb3@lucifer.local>
X-ClientProxiedBy: AM0PR02CA0090.eurprd02.prod.outlook.com
 (2603:10a6:208:154::31) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH8PR10MB6597:EE_
X-MS-Office365-Filtering-Correlation-Id: d714c382-2037-467a-c9e9-08ddd5f5a024
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uWGbPyB3nAL7sQSJJHlsUU68rsy2Yiy/xkDy+MRr79ahQZpz84gtTvEZlltu?=
 =?us-ascii?Q?tiSu+HJNZw2ykWzWFIi7gTyVb0TAwHY9uHiehiyJc4eEmtwNMcYPGTRKw0Ng?=
 =?us-ascii?Q?Fnh60hJeFMWBdX5gTsHLLMy2TXPFA60TMnT0jacSS4r5uId9Oh115adoZkUj?=
 =?us-ascii?Q?eCeCdxOVLX4P86+30DZ/57Ft22rfPutfgMn0qY2lQfI+x4u6C0NTF0GvRieL?=
 =?us-ascii?Q?treXQLiYivXeRoNwJJXcAf599GF+Uqk2fS/uuVrZtTt1IrYx/eo6frmBaKBx?=
 =?us-ascii?Q?l36JZlZ8jzHFZLFc6pb8SjYgG+32mD4eF+dQi/LTdZ3nqOL75UAI8V0xBE8/?=
 =?us-ascii?Q?12Oa/UfwbS6rO+hXe5aSLeUMeCasaWFBeRnPIfmqqpaLaqSA0zIm/R6rqT86?=
 =?us-ascii?Q?NShy8DvWKGjtO2our6t9qNPekVrM9GP2o6RdEURq8GFu832Y6sWPcZXXX5pu?=
 =?us-ascii?Q?P3D8xEYrE6Coe/g7x4GTIUdhYCdDB/bbsP0+A/IygbZONk9hi7FSBC5mMd+I?=
 =?us-ascii?Q?f5MYicwXkt/a9wkkBgemb42+10kUIyz/jdaR6tUzE0C0RWlcWW3y6nqQ30pn?=
 =?us-ascii?Q?kO1ro1gZ4Sk6C/IDwXp6PuDXB105/keukhD8R1bPAjhuROE3ZGDROb1WtCaa?=
 =?us-ascii?Q?hqVIl3hk6GYJYX/x4cYei2mpC7OqqdsGrqwdY/kz3K/pBeUVdwki69IhJr0v?=
 =?us-ascii?Q?RJ1motywDu7/OKZvneoTLzOWPCaNKSLU41befK2S5nsKgO3YwtId7IaYo89R?=
 =?us-ascii?Q?aHz4EO52XRnu0Ki2NSpPJp4FSL1DdzmBkmrSXTWHhTFRozUlLz88OMzVDE11?=
 =?us-ascii?Q?BGVIz1yiq15A1qduH/UvwwSYUUy250xViPzGoMtBz/XRSyGBRFIkuJOoyJIO?=
 =?us-ascii?Q?QuwDxAr027rSGF+FdRRJ5mBE62wyXk4ujedwSMOMraS/31skBhfKm3CTpf0J?=
 =?us-ascii?Q?cqPKKUfJP2S9CTPNC6vIj4NPLVG7AotbtTsepoVsrDE2cSRiRDIQCfwek8uW?=
 =?us-ascii?Q?pN6SqyApQsn5sTDctM9uJSXoKQ0+KuPDtbnJPrxZYzHYcL8bZgIwRCZ7xYll?=
 =?us-ascii?Q?aUJZTxDnbXKVMiv5oSQYzxJ7lqYuuttM+0xaSTIVLoZ8wLZ7tvONwG1fwN6Q?=
 =?us-ascii?Q?2PFeHYKFbpcFEth9zN+VCiG0zuDay9iQaOeb7t3hmgsTOHc4rUFU9z3HTxw+?=
 =?us-ascii?Q?AXVZCnpxYUc3CVvH4jCa4tqYQUeVBRZDWRPl6GNOO/l5sBBBfzsOspMH//y3?=
 =?us-ascii?Q?Yx59pWXH+pV7WS/J7fLrvuVZxzTqHedxaJB/J2T04vCLFa7n8rTV0H+n3Qcz?=
 =?us-ascii?Q?a2cLQ7KPO+7N7jTXNfxwv1mAzaRsZ11XcGVFG/eeilrCaN4Zl3xnYEZZCEis?=
 =?us-ascii?Q?2+DC7Fg/jjENiFkl66G4OgjAsEI5DGeO2yQf2i6fY7RhZ9WmVmbTi0CAMgwj?=
 =?us-ascii?Q?eqjYjWMMcmE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wsqfXjuNM61FuHe4HqaPz/vzQYftypk7/b0lBQWKYolPunrIoiMUaDEwE1MC?=
 =?us-ascii?Q?aJO1STDcxtgaMKCfnTTeWj27ZKcDFGQn+/f+qRlrpK8Mdc4i0qrRJ4d035ZR?=
 =?us-ascii?Q?ReUYqzqiFs5MZMDtejKvAo26PHacV/MyVqIbMGiaWOcXp6qZj30rj8VLeltw?=
 =?us-ascii?Q?apqozOTZd1wEnFeuF6W4rEmZNN3X5EKkRe1GzFHt7H8m1GsckE9MMKUrwFxh?=
 =?us-ascii?Q?wVchE2UXFx/9JkyvTjWOAl5AXYdFcKyilCf3e9PAFahrmDwmJKTBythvvsjV?=
 =?us-ascii?Q?f3AT/a8IYiBhmJcicoXd+IQl46i1HfG7LnLbZnG+rfK6VkO8LnbChHxNlSUr?=
 =?us-ascii?Q?IC5yuaSVvuBeuA5pUkKUZmjrtnGSG4jS+PUmT/RU7IRfJr6lC7suX+X2uQoD?=
 =?us-ascii?Q?rD2JrsLRYNBNn7b/mfsnsM/ugMM9DiPnHWbCPggFinoNLpyOHI/ugr2D2a6F?=
 =?us-ascii?Q?Ch494p0RLWNngvlf7RPURYQ/rw49+cn/z5SkASMUZxWCcHBn3atmfNBhuB5H?=
 =?us-ascii?Q?AGDnTrFs+QQIxqoc18N+myXw0ZfwtwOiDNTMTXsVwp9SspFopUNoxCuAzy5I?=
 =?us-ascii?Q?Ha9rVgbFodVf7M8P5aNEW6QHVLTqj5MDoYVTVpzoU9cPSz0+1pw1QMBxzuYe?=
 =?us-ascii?Q?rx8josFsDNrv8YtRuPCKU161sYqKjAdtoxRFMPhrqLL2o0vD9+lo2J24LBiC?=
 =?us-ascii?Q?glIIE4cnbAWnk5sbseE9lw7jXyc5LlbMhbRuiCTYKGgki9wMxnznmXUuxqxO?=
 =?us-ascii?Q?+h/s21sqa5/ZO8hRFxn8qwkHEIeAunZ9XpI8z0prHKOnMI2j5/o/qj+ZxDTL?=
 =?us-ascii?Q?6dy0smg9665lDFm9K0oaFpkfOGnIuFw8eL1vEJBASSlaGJoB4w9UvD/rUr1v?=
 =?us-ascii?Q?R0gmxCzSIUO6qMnBbSYBqmuTHvPrB/WBAuPU3L/IMLTwmuAbd1FTZts2ZSBu?=
 =?us-ascii?Q?NxqAICtTzp2PxF+LuBeI/NNq/cHMP+v9/k86tfA97JzMqrPNtfo9SpGCqffC?=
 =?us-ascii?Q?ouOtQQeGZ/XNieVR2uobAgwoaATHr/KaJ+In4JTP+g4QZaifkDpItlRwrrGj?=
 =?us-ascii?Q?plKULi5lTv8ic17lKNfetEg6U+wOJdPslbBhNFXn2YGjoVrlIqsvsj/+E1mu?=
 =?us-ascii?Q?+CJujAyCCHRlX6+Lr/AGWznnXlSS2bqx2XEXLdSZCRq+XsAY2BWClu6pEtAi?=
 =?us-ascii?Q?mVA0rSKsmLzKLd0WX8+RHw5iWvfOUea+7oD+gMJ05FWJF3l08ovMPm7hsD8y?=
 =?us-ascii?Q?9YOTNW1ogIDYRk621H1jh+Ageu46EODVVE1Z3AuFAdklvK99dSzEaNc0ofWV?=
 =?us-ascii?Q?RwsrcjtCAf2uUGvQSpD0CF6jShqjHcBB0v36/FhiUQuMViYm25yUJw8Rv0Zb?=
 =?us-ascii?Q?lKLo6rakEud59PCGd/7R4x/krwvacLsDom4yfR1mmySLVbaP/kBxsHxCxS3k?=
 =?us-ascii?Q?gmkJf7nB/fEMg1IS6W6pyIXbZ1EsDrqVbrs2ccz3cG0bw9RJW9zTZQu/CHg3?=
 =?us-ascii?Q?0+dpkv/XMRwEFrIyS0QkIaoR3WVDIgLtMOTwhdbgj9x7DjzlFuw+loZ9B1Co?=
 =?us-ascii?Q?XqMcATnA0Dcjr8UNa3GsLfpqRzWauIDiwfGo7PpdgLjv3puc8YBM6j6W68FO?=
 =?us-ascii?Q?zQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9o5IUvEM3JqF6RhdkSJlUL72JSWXHC5ygjEBZuE7fgolNyJ/6S1eCvd3oONj912TTqBRgJmV00zBtz0E+PKJqVf/IZm/ymauOnJo3bD9Z5woM2ZTqFVN6fyPvY2xuJZggw0xYBAB7WGl8+lIEBsH/+Ap1L8/or8twuYnnqsQv11u43nWvegIy4T309tOpPTyjpsu0+o3fBCLlh8U5Zc3MlyyY+HMX3RLkRjXg9Z+lm5VUjybpHIDDMNckI+mUPqxbweXtToVvCqyCX6iqNH7EG2N4q8QVG4hMFl7A7Kv+Aj1V+uUO0UHoLq7RWCk/BcFXksNJ2jD+e8QbaIv6Tzdtn3nKmUKJJ5iZefldfz4MLLuvgB/YoSqm8DRCmmJmE3SHxqbegpEqk/Wll9VxdOqWYE5laNs4R64htFscH64Hlrk5f2SHMr1j9LQOUC9YDt3OGo5R3OQi3ErLWoeNfHxQzP4BlSwJzZNsgDD1gWx/04cn4oQjvhWML7/wQdjwITNlcmCyP8IKOJMgbUkqw3NOjydmZ9SN1WeoJWD6/Oe7rJy5tOwNwBW2n9cGOWu8SE+GDTmV2XB1M2MV7u19aREEr0sMDS7KKDhn4AjBUwC7fM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d714c382-2037-467a-c9e9-08ddd5f5a024
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2025 21:01:48.7517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b+566cdoXDPR9Iidl8/S+V8Mqx86iAhNXW0W7/3TX6OmvocKBaekl7TX8AJTXZki8NIMnfm5gRpVXwafPgNDJUxbyFSl5Rg/1siou7GL7VE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6597
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-07_05,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 mlxscore=0
 phishscore=0 mlxlogscore=682 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508070172
X-Proofpoint-ORIG-GUID: DXtUaf1E0t-juh_dPrV_jTLWTuOiiI2R
X-Proofpoint-GUID: DXtUaf1E0t-juh_dPrV_jTLWTuOiiI2R
X-Authority-Analysis: v=2.4 cv=QORoRhLL c=1 sm=1 tr=0 ts=68951440 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=xb9F4aG2vMNr8ShIN60A:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA3MDE3MyBTYWx0ZWRfX+VBPFcbwu2+9
 SFHTPiiI8lE8EbgvDtawkJW2WQO1CHwG0zHkWUgRd4eg0Cl3WVj25CKcEWrasmtvxbDtuvrO6U8
 xGbf0o/Z21hhb6e8l3uxjPAIFHiLDPNP4f7Yma1cgxKh/cbE/9AAgZJTvQRSMMqCxQ6y69RtnHM
 uCMgwbKZQkDbVGzOlGZhd/bDvYK1NhHKlMoh9izJcllWVRDnwkS1tiNdvW+IGfov/gKIvEIsxnK
 ETEiapJB63RWcudAtyl03wRITmk8um4oJg/r3S0yNbZ8cb367exLHKoTObInfrKT6aFpNnoF3/I
 Yj6ii9WUME4eARbSW2xGoUJr5pIGGYMtNGEzJ9ppY3nL01nm8LOsRTejzx0wg3c07/1c89+h8go
 VH1LWa8p/P25j/S399UGTVHWZb5kCUVAYwEWY+RgjQaOWtMXEG4jd7TQR1N0g+V3FlhkPJ4S
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7AB4B1C0015
X-Stat-Signature: z7bx17asaysb5hwunz7k9uacca9jmorm
X-HE-Tag: 1754600519-524848
X-HE-Meta: U2FsdGVkX18Tt+uZ3v7juXQEXhOJ3Ffxx/TwdPBqW+tjLaPq7fRop5FiFmLvXNGWJ3JFnDKRplw8b5bdAzFibdkH2L+pVuVTLmFzB88THT9UnTlaX81PXxnP/asIZcYKd0lFrpFfKfMnQrOhxUidbwweXF3ocjDj9ICwynYWWcG9SmXG+qRjXhT+QRBde4LAa8qiAa4qxvHRC+6znHO1NXOa1mTYMTq809nKTajTRjQbovV55CcJY+K0MC7EFhL7a5nE4z2DcE3Bid3jbVIVVL2j1cep7TM9Ubn5AjV7DIeO5q1wdZTk1N1wgf5jrIXCPLxUzFteLwZshaHA7XsfBoVsGo2OL22vXUJAbdco7olg8TANnSvB7F6U/5Xn3uQe1BHz/0bdo+NZlFvHQUSI7C0pIU1iewkH7G0BBsOoPg8Ls5Kd/RdqJnPwSVm4tNjlMRF8c7I5MIzfQeFmxs78sldlt43HWy4mkKM3VRKSHiZQ+v79zWoLOkr0I6vc8GvcwdFTmfxX0DI48AxwgAH13BOpyWSYg93lHzOR3Sp3UdJdd+HRO3alKG4tXES+UJ9k65C9kI9vEwMxMGtZUsKXII5ovErNF+uCt4w1t32x9KbuDEUFSyxXpPEoicy/DYz4rU71FGbPR4wgU9oqHgqPgUCGFAiOWM9QGoEJaP3QGZuSu4gmCKYWE2xZrnAzmhOdstmvzS7QaTzjqIGD1DamrGaOj1HQy95LbjHrvPVXSXlfw63xYHE3U2QCJbszaep9G/ctrAs/D7gIyAzIKU8W2kK9EvKut4jbJPplleVr8nA2f/iapXNRg0l3lQacCQDMOtdsGJDfSKqgTFYk9zu1aPp2S0GH+WEpndIcrb62buZDwtOKJPiVUAQzINEOvGZPmom5H1QHPMGuf3a5QBVnLPBJboUZJAsfRobxFOJ4nQyD0So5sj6xDIvHpPVB8JRiKMQczaXF9JwDEFD3CPU
 EArTbGL4
 +F33QpNT4Ap7DFmjgfY5+/11LWtJtZxRLfxHSq6196k/1IuEUyMEC1SJorvsrPSk0cn4CGBGcwq5f6eATxhrNqEYiBUrJmCVekset98IP7e7HguvR4cuIw1tjiXGHUtVkIAk24hB1Ym7dKkA67uHvGdYVQDFVcIBf0+NQAUaRdcGuPU+6bvSa778CEWP6MB8H1dNnySeYYa88OH+HPz0FXJ2ssyOw3dKSr7L8YW1L+XwXGFwMTMNbFkKpmrjGZOq8vmn5TeQSLstLrCZP7Jf0+bFAXTYyVzia/GNh4V0C0nB3M0ABoU6qzQJhQJc4nLcSJO9aaCQqpWCgfWOYsK3lJC5GaT8uAt7o33kLrt2gi9s9cRGgG7KcpBoLNJKjfkZ0OkZOUX1p3AOk7lTIo3Y3MJj88L+MDRjD7++Im1MxsgBhr+AukzWqKV7YDe5FE0yQZreL8A3UpSQC4VVxU7Pye25L9zjhffB7QZruPX8a+98/9QPp2em4yEni51BzAlAU87Iml3bc84iXEnLskYyTU+ykVtTEZ9uKTIHGkGo4sp8uVtXbQ513vp4UIIa8g49Ro9mgAS4Wf5+A3oHt+lbPzy5N2qTpFL2E50hn6rZ4okD+q4/SrMkH1SPiCh2SHdtoCJckDjXcWdttrm1viV0NT8jO6rmNbTUXVNOSNy7BLnTEN+0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 09:11:12PM +0100, Lorenzo Stoakes wrote:
> Right except you're ignoring A/D bits no? Or what's the point of
> folio_pte_batch()?
>
> Why don't they matter here? I thought they did?

(Discussed with David off-list - it turns out get_and_clear_ptes() handles this
anyway, so it's not a concern).

