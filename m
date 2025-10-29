Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2FB9CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 23:27:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1415E8E0117; Wed, 29 Oct 2025 19:27:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 119918E0106; Wed, 29 Oct 2025 19:27:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 007538E0117; Wed, 29 Oct 2025 19:27:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E37EA8E0106
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:27:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 869BC140936
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 23:27:09 +0000 (UTC)
X-FDA: 84052739778.27.481673B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2D4F6C0009
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 23:27:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RxfLjHin;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=N+s1UnXh;
	spf=pass (imf22.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761780426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8FHKKor0g3pxkstZdk1jtP1d9u1SoRJ68Y1k1jmAA8A=;
	b=sDwIPUgm/UbJLTl8qkN8FmojL9wJLUcj0EXGyHY3joXDdENrCk2nyoAg+YXJbox/kxBDSK
	GgM61rAv7wKF7+Y689sjldsEp727QL6jo0HWCwI4r7GPWYOX7nHKM5fC3aFDpbexi03+kY
	2njkBHCQfp1zpNyu3qgisX6lRoG8fVw=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RxfLjHin;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=N+s1UnXh;
	spf=pass (imf22.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761780426; a=rsa-sha256;
	cv=pass;
	b=excUN12Yc/3Ek2TCAy4flfnlH0dJXu6j81R3vgVcdfwA6HzqhtmV7Acmx4KIg0FYyapZVI
	Y4LkzTfwTSCoJGFRQSv6jhMJs7cHAHmqdDwy1tQV5rKV4Ee0R08IvoKMZMrjaIHSjcmJ7g
	UrBF3brvCb1jEzaw878JFyHRWkuu+ko=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59TKKCdp001340;
	Wed, 29 Oct 2025 23:26:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=8FHKKor0g3pxkstZdk
	1jtP1d9u1SoRJ68Y1k1jmAA8A=; b=RxfLjHinYXNwcV38A1MZ+rmqjCFXOGefQ3
	nxcOqhFuyf4hsmu7Mr7z/gX5318tN0yJ9sgb4TaAxaFiYjw3PUTnlOAWv2nmMZfZ
	RfbnYeQGrh6EdykCp78ciEGWKMzVD1W8eI21xZ30GIyxw3T7znC2z+ZT1LSwFeEp
	ZxjWtXXnRE5NyQvYn2ty03nAUoy9ZwZOdD+HFNfx05CcOtAVUVyQvH4Iu273QGCp
	7OnqrGkxq1EV/jNeJooVhXK+7Em0+kzfnwlH9s/WbF91tCLZN0fjJSLjjEqw2YEf
	WYOFRc5tjI9UeMjhr2m9RnnoGaWNwjiN5352/rVvTdqvGgkt1BVw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a33vvkc45-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Oct 2025 23:26:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59TKtSwZ007644;
	Wed, 29 Oct 2025 23:26:44 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012056.outbound.protection.outlook.com [52.101.53.56])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a33wkvauj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Oct 2025 23:26:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tQZ1zakZxcar0MVZ+6nmMwc7hBfMonE02pQbn6AMObgu2dTwokPxf6scIs/Lqz19CypygHvxN8LOFPUXty6IrShEqH8uIsyQ8qrKGOn7FzLszN6UDEINOxAvM0uXnG5FOzqVOWOIGiR+EgTNdyWJg3JVsCEg7I2OvPlPUMlvm/zWfpmoBHgz3aluY/1HYU+RJnQKqekG1dQzWVDnXQuOuZr5e6sPhG4/X/A9uvQ0ffz+OEUIPdLolPbWxoFWNa7JlXv/oi3hMLIksZEIYzwfaLDQNC6ONd+TSpAPCoaRbwek1Pe5m+X+reen4e7aMC66MUMd6/TbA/szzSvAm3AzzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8FHKKor0g3pxkstZdk1jtP1d9u1SoRJ68Y1k1jmAA8A=;
 b=iz9uucfSj2eD/TeS2j5Cdq6lwludnFz7MdVcc+SFwgkgQZ1ofhw9AyRP84XyeKc13yWo8m51HLHRgoYHCmD3OMGY+4kEcys31E93yZe7KIV/EzFFSGh9cClJvy7qK7a/7noAVv+pwr/5AbFro+yoXmdrEvxZtJFN3rMpL/x4apoJTN3ms2UH9n6wH+QYytonxyX3wMMehplefU50xm3TxcMuOc7ohR991dg5XS+csAaCH9qGlT7G1z2x61HWkimEy2916TWasWxHyOrmu4LQYOBuuHMEQ0vyMpGG3GDqIpENwQzF0BxnSk44L2hpV85B5OFXQ0t+oqJbg8Loo2qm5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8FHKKor0g3pxkstZdk1jtP1d9u1SoRJ68Y1k1jmAA8A=;
 b=N+s1UnXhvyeteWkrsMkeEmLclDIKf5mOIk6InsW7kmJiMA8NRzRi59EW9RAenCFW+gb0SBoSYsSC5PCYLSCB8aoz9U+mFwSx79j0/sNHvIIkkx9eBZ2OLp4XRoO3VyYTDKVQ1h5qIAubXrdBbvBwqnSHhXRrWKv9BlaEhJ7uSOk=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by PH3PPF87283933B.namprd10.prod.outlook.com (2603:10b6:518:1::7b4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.12; Wed, 29 Oct
 2025 23:26:41 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9275.011; Wed, 29 Oct 2025
 23:26:41 +0000
References: <20251027202109.678022-1-ankur.a.arora@oracle.com>
 <20251027202109.678022-5-ankur.a.arora@oracle.com>
 <20251028133648.GAaQDG8PfOwrSiHYuk@fat_crate.local>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, akpm@linux-foundation.org,
        david@redhat.com, dave.hansen@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
        peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v8 4/7] x86/mm: Simplify clear_page_*
In-reply-to: <20251028133648.GAaQDG8PfOwrSiHYuk@fat_crate.local>
Date: Wed, 29 Oct 2025 16:26:38 -0700
Message-ID: <87ikfxguhd.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0168.namprd03.prod.outlook.com
 (2603:10b6:303:8d::23) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|PH3PPF87283933B:EE_
X-MS-Office365-Filtering-Correlation-Id: 98eae847-a230-4044-6bdf-08de17429d76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2o8IoGKAwiu/4m7hGqixuTzMLshjFQEFK2QWgCVoxbKJkTDPz4spuILx1yli?=
 =?us-ascii?Q?WlhmbP+vU7XbBnJtP5pkE1qPLYx2gL7BGr4WDm90Jb0MAMyq4CmcKjFcVu9j?=
 =?us-ascii?Q?4ItpalzcGaOvHJ/zb/vmRnIceJcgJWZSvQCULlBAgYdQIkjrs4bt4P4rCHCC?=
 =?us-ascii?Q?hbwehJLDLHibmjjo3KwER0usZDCR0vEEiuwVo+h6eWgdkAz1I9rjZdy6/IWV?=
 =?us-ascii?Q?EHb6y4ODnCSfJ2d2SYtSxB/WgMP8PqOYEuipl2yIqfdmh5Z7JVbrRe6yV+Jz?=
 =?us-ascii?Q?FurXdG2PoF17mpsxPWrWBShMQDhdQUsXA40C8Ip8FFttgYKEMHo2FNHXZc2a?=
 =?us-ascii?Q?+0LZuJQNd2adITr+ZfNI7N7CUej+TtYBlSGqdtJ2j4NU0qY+pdh+GOEdneZH?=
 =?us-ascii?Q?u/Fs9h/pFbnZwI4gg0vUkyp5PPn3FFZYAPruHP88fXzr/PUMBi+X8SUxV6bs?=
 =?us-ascii?Q?UbOAdjz0QvUYbzeSB0VCbnt/RyYa/y4Gq+JLuP3rGsu8glFQ8LmzmN4k8utj?=
 =?us-ascii?Q?Ze4X6jltoOUiJsUdBcT6i5k+eVAA2rsd3IooWUxlrMsyn1+uBHP9Evj/QyB3?=
 =?us-ascii?Q?COSGDGVXsomMki+1bexxWbqvVSePJABZe6AxfmXWYkKRhM75HDtE3OHpr3sT?=
 =?us-ascii?Q?MR3QFjVuaHEjjXIOTkthMsjvA6aqUct3M+lwCg0Si0yLhO5NayNiZDK3RYtW?=
 =?us-ascii?Q?lpTBXSNn2z0KA1aN6E/Kr54qAVz+5K1IUVeYH3nEbj06HSOXT2T9mNKUQAGX?=
 =?us-ascii?Q?c7BFGhLDnasBFToJm5Fkdj0VxMk+TDylEyyaRpyoRY3mchh21o/Amg/UtGQ/?=
 =?us-ascii?Q?BXOeSEMrUvLHQgsGDKX5qyd6TWP0KMuHu3kqj5JQuPBNOQPN1vhXWHNOBHx1?=
 =?us-ascii?Q?rJeH/E6DPP/Kb0x9VVfFf6JmAV6dg0eUmOJ6apb/Rzk8K+aojRysUr31xOrG?=
 =?us-ascii?Q?dXyvnRRtpBseSP0Nbezg62kPSuu8quf0yoU0zUu8p/AanZWZf/9QjuhqfnG7?=
 =?us-ascii?Q?EXw/PvIb4gYRPI5LW9nkFRT3GVvKZVcXd2IjnSnea1di6CCPYIPveVLApX3/?=
 =?us-ascii?Q?rek2juawo4NKMQJFjgCuInzCWXKi2Lgp4+Y2S6BYZioBaTCMQ0Uqu7gjO07B?=
 =?us-ascii?Q?nwXroyuUatm+CUB04Yu+3eSmnFNKDJdPBr2tqhBRIfxz6EKZ26Jqq7mIJ3Zx?=
 =?us-ascii?Q?oh0nIPCRv7xVrjxqMTHXbkS/LrEP87IK7aQ66hQefH6EPDygcrkWrZGCygld?=
 =?us-ascii?Q?hIlkeySOdjSGlK4jybJ97JEvbhmzpqAVukd7T3K7+rqdx88PFO1pkxMJMPMD?=
 =?us-ascii?Q?BHK+W3OleEQEO+tkfPZLgjxDitPwfG8wjdveIjz/s8i4qYT3SlShr+WjxQ4k?=
 =?us-ascii?Q?gd1H0vtkEuYoh1HAUxLx5uEZBmBPfWjHwjQw1ODa4YrTWMxwhb9wte0E9QWz?=
 =?us-ascii?Q?qFff92rtH0JGpGyU2zOtzf41XHTDM/Lj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TWZBp61UuR8/ky8Ygr0L0TxWLxdwX7qIv1ZOLjRJyTd1WF61Mqn663lbqKda?=
 =?us-ascii?Q?VhYrn1XSBeeYyU6arenGa1Jwc1IofFif+9sIN/ni8+3+cZNhflxhLrFSLRC3?=
 =?us-ascii?Q?mQSy4YZNGJpQqsKk/9Gn/XW6JnsMUX8/yBX0+C+h+YQTbdpHE9U8U74W0K+Q?=
 =?us-ascii?Q?h8Sjpej1405m2flI4Bhe78wf/tzB87e/TJFGOniNZmDOzGEriZHJr5NCzwCy?=
 =?us-ascii?Q?YW/pj/uF1izRkQS0AQoMtEA3XR0Y7bohqIWAP7NyGaxNbR9GwVZrocikcjce?=
 =?us-ascii?Q?MJdesRsnxeuim4qUPa36PTtmo0PxCwphbNHiO9jrCHkaYLVDy01Z6xnezoyF?=
 =?us-ascii?Q?X5YZTNUpcjgN2V6Eq8JWVWhXVAgTYufllSzHPj9pLOYkEixcO9NUEZStF3Os?=
 =?us-ascii?Q?FeUYLjwvk0TUbkL8ulV7rpg/VEiLi2M7qlva2Z0jVOOtCmNLNHDznN4a+ZfV?=
 =?us-ascii?Q?UJJj/GcYV9kYMbOg1qwXe4OdzkwmbXZP7g7n9/6BrCfcMNiwEcpBh7VaKZZA?=
 =?us-ascii?Q?Z9xqgOT0PqmfDkmrmS3qPSuxN8P4QVB1Gt1MAyH/LA6z98uvcKD17sPMHrdz?=
 =?us-ascii?Q?71MWDBPkKHey8EII0o/T8aogNd2ND3lD6riJqz5PLWhdTNNFA518jAV1SFQR?=
 =?us-ascii?Q?D3QOGgQYTx9UpmTTrlY2fAmrj/HMghNM7TUIn06QcEEV0uRvqvXUnKwbAh46?=
 =?us-ascii?Q?ttfOcdt2oyoemnimHb1zVh23TG9eLAkRKBsYR7JCb2IrTjovjm6pkS7cN4Mw?=
 =?us-ascii?Q?Y5SLW44Ahc2CzUAicP56AStr3puKcDxae6ZOrdXIm1j2QFKktHu7MfH5QwlA?=
 =?us-ascii?Q?yC7Ntiu3FK0T18RRketh4MXXTI9ELsdzsXeGeylYM9xa+SCBFnlNk0XdkDPq?=
 =?us-ascii?Q?v3Z+aZtgrDZMmr1N5nOlYDDnVrSJkL6/cg7UnyJUWbhYLJAJ3r174ymTHugG?=
 =?us-ascii?Q?dpmkWGMt/MiY16ISrMeSmGHVdKv9M1JtcqCmve9KYLjH7JrCZDu5ZJhePDyT?=
 =?us-ascii?Q?8gdNphXSc4fOixAUQd/Oywi5M+S3WjDgUDWc2feuR6+ul9p7EHgWfEX+5xsa?=
 =?us-ascii?Q?7APeaMc5sVbUNZNOFsy4KHulqVclVFWMAoqagxW8rz6QhpN0yvi8DQzDtn8a?=
 =?us-ascii?Q?r6nlWjEwKaPR6f0B/guvv/SEVI7oRDgDuyTRpObNFwdnfK//DW9Wo1ZuS68a?=
 =?us-ascii?Q?7VW5j2mddhhGWu1SJ+Fe1Z1+USmd+HjAEQj1ehqRWNnho/SFlLfUmTU07Pym?=
 =?us-ascii?Q?7TaC96GOh/MJSsfYYYwtjhtindbOcIMAGmQoq+K2RrhFh0Ypn04qfcNTj3yJ?=
 =?us-ascii?Q?I8wYdvMUvq7k7i4PkY4/cT8+2aya3srs33YHYl/lonzUKM1+Ym2P9Fi1Unbf?=
 =?us-ascii?Q?4y0/vYmfm7tqqs7mtapL/C7Fh/tLVX9DzTawV1DAiIWojYK1ovGmB9nJHitE?=
 =?us-ascii?Q?cEq7vVO+uFRdye9YF/hTSXMA2Dp8ldTusmQK3CyaKVUe5PLJQ3IyeMdM3lRu?=
 =?us-ascii?Q?dtLKRXg+ypvfb6zXEyxGjDD386ZMVKptLQF8pTCHeLwqmBtnhCewNis0yd82?=
 =?us-ascii?Q?UQzIu9qXR8mpy3IfxKJmTRoY5ZvzBBALJEoSpKp2tonBBfOROTTwWbH72gIG?=
 =?us-ascii?Q?OA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nwqLZZo2Y4m6gjQkIAi+99lmgUVI0IpNM/V92RNyVqSuyKrYCiMi+4aYiOV5VRFJsxDsoMYVHaQVRAMzsG6RL29kZJY88DHDyEAuRVScMHWeBvjVxdC8ZGHaMJ63e78q9sCewAWgFDNLcefaml9oUqBj18Z5ECbUZsDBr/H6MBxDiaa59tAjPbFnUHEmdHazckw/7Ik6j8yPpAjw0SMubT7b31E+fTd79Uenc1qRT9CkAGbzLylUdl2pzvyqRrsnmuoAHBjJgdm1J5ClhB/sbasfw4SwtrOwVPndCMcalZDxnBxirYusF4/e4Bkun5IsoNNW+tZcKgqCfnxq4DItLOuXNEt+JyjPGEzk695YTUg9+0FUioQQ0DS1jAzFkElBNmYecBGrNGNN63dHwFcpwwb5bfp6AQuMR8q2JMtRIb6Ui2eVcp3xVtjTeUu1eZ2R5Z3IIb3cUymT1yL5qBSE/jrpPryZ2mkbapgImldDSlYxb5jCFL3lMIqFv9X1OQWOcVfOjmobCo5zUNl3qXz9WN0DNxHYEoTczeqA8WtmiP1/GwuLeC5EKWNRcK/UU3/VFZpOP5taW477mo1/G73SKoIOkyo6yA1GApCQAECk85k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98eae847-a230-4044-6bdf-08de17429d76
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2025 23:26:41.2545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wj+S4ByrOGSmj/0u9Bdh1CeHFjrLe6IkbSNQcfxyZ3ook53/sjR1RFfv8XTbH6LhSsdVThGRBm3welpJdBVwrF07KOZiSs+C0KmxKP0spN8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF87283933B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-29_08,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2510290189
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI4MDE2MiBTYWx0ZWRfX82I8nigA3mcF
 c7wkH6LcQqA6CgqmHpH4d7wcTd9Fl3Q/+b6DCIEIoxcNDkqyD9BcyxSz58ykGrIfRqt0ND3+FEK
 EnOrSs6OmRlPbZnhAP+CDpyu3vFLpVmqRKGx0YPDqRV5oNuwhbFhuzMtYws2IMnDIHsk1oHq+Mc
 ldAvm4VJ7cGO/tqRKLE2Ad37nJSobKUKwTY2XiOh6LQzg1ZKyQ2VSPCztoGDKDBWm2qSxA9dZ8d
 vchEEk2Ema7PIDSKat76G2PbJDb6Jrh1l+xcyg+SURdwDkse3fUYytrTk9FFAEmbOOXj5PC4IQ0
 Jj3dhx4qM3YojwTCPobuJ5dJpW3tzFPexO2S7t3ByUujbJ5ibS8qsdNDzRZBfQaCVic0xZeSQuz
 91ia+GNG7lfiXf9Z/oV23tDnpf0GAQ==
X-Proofpoint-ORIG-GUID: XyR1xAuiYec1oYzUXkPsyJloWIfm2z8y
X-Proofpoint-GUID: XyR1xAuiYec1oYzUXkPsyJloWIfm2z8y
X-Authority-Analysis: v=2.4 cv=SJ1PlevH c=1 sm=1 tr=0 ts=6902a2b5 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=JjgolBlLATmbp1io9k8A:9
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2D4F6C0009
X-Stat-Signature: c94ynh1ragwkfteisnf1ymdigdnni9ns
X-Rspam-User: 
X-HE-Tag: 1761780425-992494
X-HE-Meta: U2FsdGVkX1+OdQzmBtvHzdXF3vmFGVv6vZcKOOXVaqcaz9nGz4o08FrHfe5dJL/q/fPx7IFRes02aKrcUJv5jRqfJxMkAz+LubwaaHZt8PfL8jNvGIhAo3GU7oe2jNDpnMefa/HMv3vRUZSC2T3DJkbw3mwxe4i1oL9kndl9LPQwGYBpbHjHpdbRFQ6i7FvRGwY9ISDIYzBJoABvtOgHuxPyJmJWjg8b4McCftW9pdha/vJuY0VyQ2ETS4+WnpYjwqHGIZr1duhXesTGGF72JtyYn0DlLzWFKL3vZAfqN3IVy2jDwP7LSkHH6M36VXMJUwZ8JHhDQbEfCSU6bhqDS/Brj/mla8vyoPVKr1bKspZfivOjCiGcpnm5b+BEUjXMJPBRLOAOkRYEo92Jh27+CpdwJKjqD5w8h1i6+4LZhutZ8mEZ+Cdqxul+rJB2Dw5TKVFzqw5NAOWxC4NMIkwoo79OIS/ZKV2mAih+B0qJOED+w+i/GEwSQermtOpMmrm5eVSJIbg2qCFMJgzx9TRkIs60uxXmWvwksxhBpDTmunCszKyph4eiNUhXM/H9txJLlTLN52Ef66eH7Lo6z+bFzzl4yl3sDKybyYwxA8/mITeWhbS6Ke28hxalDg5CTbNw5bncNL+xQ3jg12QzzLBJqPygJ9cEZK9f/P6+8ZNZLBA1eT0F3rYBXB+PRGd5PSMdwwQeeDdS5Oioh6GPWoPLfsZ4vvxJRqPgXmq9qq06KTL6lEVj9VrkYE4S9DLCDk8Cobwfr/Ub/gFqzH5aKZyGMpWx9FmzWEKoFKJURkGrgftOBrISAlPONvoOuT2WvWotMB7puhqdWi6emi7B5wyxx1gpA1gQaKjnE61gqdnR8fD5CFux6KHubuQvvBimpXxC/rWNllFxVms11l1/J9LSrVpnlkoYLw1A+3UA9UqtwZaPvIs5DiuhTrzXKleef0SNF2ww5KMW70aRtYvsRtU
 A6rITfAV
 kRPqwnRRQwaawJDgsFbc5xFvWt9pUOgb0uuKe4w3ay0oWqzDMAvsPP9+qPT/JVnV2iyXubCXhXzhkAfcVVkYslgve8ccnrvosO5O2tnJ1mGsQ+c6e43qPxskgwnBJMDazrETPX7iMQj4pcDX+j3TDnf1Sv6fGB85NQ6eY1hjMLxUJGA4N3jdj8ykP2olroKHFHiPd55BM+jGUrT5n9nNIXlawMQbqg8E4kc1DQ6Cnhe0pCllA8TLBmXLHT54LjW/BJSeaphbtL9RKt3/8DXDZwWhJQYKHS+NF6sqD7ZtCN+e1FhptbtYsHAZkn/EIIn3WJ/X3TCwIPkETD5FOJByTVFZVTk4jXbJvtSYtlihqYQewcYN5bYm/nueXKOypY3pozWqpqFbYisaVix2DLmR7dufHts5mKdLKakVaU/XBPGCUC0UVVxW1gJZlTI+huRPbAWz0Myu7YweyU/xDQoLhMd/TMgBHOIXII5OWyaFo32nIOHl8Ji+mslPiROzMEU9qgjlgfXB8Pk6cDU8DKp+SMQVt6T1jJ89s8GJRWKXmmtPSTKU2TCr9CI9eXg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Borislav Petkov <bp@alien8.de> writes:

> On Mon, Oct 27, 2025 at 01:21:06PM -0700, Ankur Arora wrote:
>> +/**
>> + * clear_page() - clear a page using a kernel virtual address.
>> + * @addr: address of kernel page
>> + *
>> + * Switch between three implementations of page clearing based on CPU
>> + * capabilities:
>> + *
>> + *  - memzero_page_aligned_unrolled(): the oldest, slowest and universally
>
> So I don't see how a memzero_<bla> name shows that it belongs to the
> clear_page "stack" of functions? clear_page_orig() kinda conveys better what
> this thing is. In any case, having "clear_page" somewhere there in the name
> should stay.

After this change the only remaining functions in x86/lib/clear_page_64.S are
this one and rep_stos_alternative.

And so the _orig suffix seemed to be a little confusing. That's why the
change to the more functional name.

>> + *    supported method. Zeroes via 8-byte MOV instructions unrolled 8x
>> + *    to write a 64-byte cacheline in each loop iteration..
> 							    ^
>
> one fullstop is enough.
>
>> + *
>> + *  - "rep stosq": really old CPUs had crummy REP implementations.
>
> We spell all x86 insns in ALL CAPS. Like you've almost done.
>
> Also, it is
>
> 	REP; STOSQ
>
> with a ;
>
> Otherwise the idea for the cleanup makes sense.

Thanks. Will fix the above.

--
ankur

