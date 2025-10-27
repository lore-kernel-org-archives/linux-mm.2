Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28C95CCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 20:21:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E968880096; Mon, 27 Oct 2025 16:21:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6EAB80099; Mon, 27 Oct 2025 16:21:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4BFC80096; Mon, 27 Oct 2025 16:21:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2FB080099
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:21:41 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6175F13A131
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:21:41 +0000 (UTC)
X-FDA: 84045014802.15.D1268AD
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 04D104000E
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:21:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Wye9JyO2;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=olL14uH6;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761596498; a=rsa-sha256;
	cv=pass;
	b=3XvfG7dv+HVTuzQA+tcSFZ6YcrKjXZ4H0UMUrftGWpVMg6c8J+aOCFRh1tJGdshHwqqulT
	RXeBHvo4/sJ17lJ3O+zpv93u3ydmZLMnYPxJ/9pgV2v1ptwDEe0kGE2ROieSpdYn20QyNj
	mCSXpPHecw20uyU84lUR9SQ3RIcfGrs=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Wye9JyO2;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=olL14uH6;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761596498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fqVP9TSjc9cCCR7+3kQdoZrtz1lIXUB4JSoOzb4YuZw=;
	b=dRE6P0yBLRs7NVZY5CZbffbWfIZT3zEGPqrOAs1w0BKT/JyJyoU1lXPLfgLae7WBZG8lgy
	FjG+gYSiWluRvBvs1Ouo11n1hV2/x7lks/3KfohAiufkJcbNdBmfFnSWdu9npk1HFROaR2
	gJheQhji9fE+HLEATE1sysQBZyan/+4=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59RKCIC6012114;
	Mon, 27 Oct 2025 20:21:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=fqVP9TSjc9cCCR7+3kQdoZrtz1lIXUB4JSoOzb4YuZw=; b=
	Wye9JyO21ZIeVZ1fHRERWGCSljCxWy2B6G0oNVmYuzQRoz6COZEXDYCpzC63xY0S
	/IUEWADKJX/WBwEEgIxdPXYcCxUKcOIXaZGpMFXhW5H713sRXO2LO4oUh/M6qgnc
	YSJnXACIRkDXKmpX5co8sayNJnllN2Pcf9sVp8e+FZR98dYLnNll2rjCOC8tpRZ8
	y9WO/eN/Dz3S6TeR57J78S6MFn8lCY0ntMJL0sL27acqpioZH/2eYhDGMu1595sU
	4B8pRjnLUDKWvW2tGopmAp30XvxE+ga50rlynxECLzl4a+W/o53/M0XKCP+UWnqP
	ljC+FKCBniH/cUZUWhMvkA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a22uu9wr9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Oct 2025 20:21:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59RKEB4t034835;
	Mon, 27 Oct 2025 20:21:24 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010038.outbound.protection.outlook.com [52.101.61.38])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a19pep3jm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Oct 2025 20:21:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=juUE9vmpuJNvKcf5yn9EOaXabSziJlPqTJanp6FprbgE6KQskL2CzuZNDiy/pPyOLYlIuviJZX2O+KpKpenHCVvm47yNK5NzFzrDuHUJ9HbL4hPNimujXu/vZ90WsUi3+Gm+ijnr6bGUkpJDM22kx1ZAKWWBUClg6VV58Zc8823MMCCe87iyXf8I020pvUxtS5eoPFnH2eqmqX3cVjeAhn9QE6I3xBE3iGLUWXtYg1C0/hf4k1ZDYB7t+15fEVBtx2HhfqP1LlKo8pB2DB44N8u23ou6X8CILEJtY1l7NnSz57FkmZMjSCPj5ovxx8Y33JF65ZLouWVxo2I61uJ7Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fqVP9TSjc9cCCR7+3kQdoZrtz1lIXUB4JSoOzb4YuZw=;
 b=qTFTVueNt+ydCzJN5brzrLEm3LxVcxuixse4ToV3ZU4/QHg2dyKttSxTf65QeSWDl96m72IzTcqGK0ZV4WAzbb8l40Z9WaS7cOVb3YAY3GS8uM2C7ayqetIfQilxLC5gfVCxJlaqZIxEX0N/DIt0hx/cWSvSWyTtOQzJwSlxh+J+RcrGO8xiDI0MkpcL3s2YfiG6hu8hwTyUeFceLotf+vQCbqg+sCyakKWmNUUh8eLg9VcEV7o3KLaIaDl1qZBfD5V2eMqq6Grg0kCFB4bjJi+fXV298UaTSXDgGA7UxC5q8i5Z+laVvADpqEKU9EbEGSkMSGfUFJiiIuprqg3Vhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fqVP9TSjc9cCCR7+3kQdoZrtz1lIXUB4JSoOzb4YuZw=;
 b=olL14uH6XMqZsykAIqzte4zP/ohdYX/A8aIOE8ji1rBD/av6y4rFOz2huc0JrdLJNpbI2d4eCQLJqKnpdady6+phdtelTznX+muKyXvG+UhVwcFep9OcbnXwx2iN3YmxdrOLDm2ViPPxe8GVvB9j9RwuiS2ASCYH8uJBVoKLRgg=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by DM3PPF1A29160CF.namprd10.prod.outlook.com (2603:10b6:f:fc00::c0d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Mon, 27 Oct
 2025 20:21:20 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9253.017; Mon, 27 Oct 2025
 20:21:20 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        acme@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
        willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v8 5/7] x86/clear_page: Introduce clear_pages()
Date: Mon, 27 Oct 2025 13:21:07 -0700
Message-Id: <20251027202109.678022-6-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20251027202109.678022-1-ankur.a.arora@oracle.com>
References: <20251027202109.678022-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0084.namprd03.prod.outlook.com
 (2603:10b6:303:b6::29) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|DM3PPF1A29160CF:EE_
X-MS-Office365-Filtering-Correlation-Id: 433eb16f-0c6b-4e65-46ef-08de15966454
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qmDDCtS0V/eeLyJKdczr40AMcupGwUZHipQDpoh1Usc5y37OV7rTC/XepQ6G?=
 =?us-ascii?Q?c/Ng15VnrL8zxPSI2ECDW2tlOB29WEDb8Xnj6jrMPCIclIYzvrJUWTaROCOD?=
 =?us-ascii?Q?qJ10V2RUP+/6iwwwKNhDXxBUDVBO9JEK4S4WTSN0nvigeAiEUn1r7Cun+v8m?=
 =?us-ascii?Q?E/00oyRdk4liXzL2e53zIXm4QEGO6k2BiRXrw0v1ALD+LWVF5hrwX6FmQrI0?=
 =?us-ascii?Q?iuLp3ElKcMAwrM1AbeH66/tE6YxLeLMxB6x/jK0c/r4AYMnIQX7iq+5/2gk+?=
 =?us-ascii?Q?68ho/59Hsoa0QGbOzQ1wGwa/e8W8qpyudMBO/t1axuBecXBMD5fk6CGTAP0T?=
 =?us-ascii?Q?Sraq14Bk68xlp2U3ojOvOmDvExl2LacM/6ftg6eNbexsf2Yc20VTdmWLhpES?=
 =?us-ascii?Q?Bw6WD3lnFghVOhBI2Hh8oT1K6ItURRiptKVyTr/TeCG0c8K1Vj1XTXNLVLrQ?=
 =?us-ascii?Q?y+GNLpDJBMexXwL8KS2J8YMuwoFfDvAyuCoq97lFBOcvJBBs6XO2dNaS5amS?=
 =?us-ascii?Q?EeAGxtgmfgl0XKJJdNMF1XrDmCqtqAh0oYOlGfHRolIVluFdt7yVOrXMaWW+?=
 =?us-ascii?Q?hxAYVXg5eDVIuWGG/N9s5+X0TkG+Nd5L+b3a4JJ4rvv7RXQwONmKzEHWQt9K?=
 =?us-ascii?Q?8/tvezcaW0hbd/g3IuMBA4D8BFdypk5mNxPJyiaXIhrAeKFeGDEBU4DymWoH?=
 =?us-ascii?Q?4OBoxIlrot1Bm2Ni0IhKAjwvdjruvHX8+nqCbsKO47FJ1uDComAMtu+YJgsH?=
 =?us-ascii?Q?J/H0rFbavX7X7UqNJqtb1FOo2CQkejru8WhW8SSCJBoJW9G7QxQjQ2GCpeFQ?=
 =?us-ascii?Q?4xl4/rlVXjnFm9lrF8+nXN4sujW0rzdvQvaYoMrs5d104xwHMqP9JHuxYK7T?=
 =?us-ascii?Q?S8aXP5GLUTOV/nYnd0VEmGScCBWtrK8YCtQFKELCHUVqpbUJCt3KtgP3glYz?=
 =?us-ascii?Q?jKsT8w7fjpNjd80sZKBrwCkgNmU0r0qmXVsB8/I/D/lLwo/Pn8lUfoT83X0T?=
 =?us-ascii?Q?MYJZflfinSyJFHX5u/pZgZFEJGkxw8pgdJUED1RBgp+ND/AhLmRj8Rz5LbEz?=
 =?us-ascii?Q?9r6kSIl1TpOCuYzNFVqkLgAJYH6wzHrXbu9Z6292j9R6Fvzmw//9d/1HbmGq?=
 =?us-ascii?Q?F1gDMfZ4IcOn4lCuS/9iSrEwgFDEzRe/9hs80VWkIe0zd6/Q70T1DkfzaXk5?=
 =?us-ascii?Q?Afk7dAixwBS4OvY9QbDld2lu+RVKyz1NzgAVVJ7ZFmbXoqFMGPUvKTT49TRZ?=
 =?us-ascii?Q?7XU9mseYG0n8pcPgrGu+n9PyUHsAqfcSLbWsXafRvlKO+HDcVX+IxxG0/+Fk?=
 =?us-ascii?Q?PbA8wZbBI9VA2JK8nCpitdBw+zQvAR7MyrBIq82zuLBqmxqi8ZpCx6opTZuk?=
 =?us-ascii?Q?T89z2uibRZ9DuuyG54Rx2oS6HFoxPW2jPapYSL9i6DYNysbMN/zo8o7z8rdj?=
 =?us-ascii?Q?nlVejGwQ5bHLwMJAjByRFyF7N6yslKpV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jqmiJceCapZC09dPKnmtxqE0PkhyFIB5aAEenBO484w8shbIANRHwrWQWtlP?=
 =?us-ascii?Q?R+HTuWpP+Py/45oca61e2nO+2QngxOwsSFTXWCHgjxqA5Z2deHE3EKCiHGL3?=
 =?us-ascii?Q?vu4ErdPtWqPaO08hPVtp3GK3/lL3E0ZFIx0enDpzvF0ADXOjFc9nVrnnpaPM?=
 =?us-ascii?Q?x6AqhUDhkj85mWKW0J/e3SIl7vJJ3aixoc+JQ/GyG2NltPuBPjI0zBD+dDEF?=
 =?us-ascii?Q?64CWrQHnG6VFBGbcZ+ZIpWTvpZZKkbwx0flwie2V3oPgevR5ksuaSMmOrcbW?=
 =?us-ascii?Q?JgHzkEia7onFFmNv9NtofcTFVshD50cqbwsfFsCz+SEVStfZeEjVgWkIe/Gb?=
 =?us-ascii?Q?S7TnzJpj4MPVST34mO6crusNyFmspx+EDS9HPyDSUkTFU0MMYByrJ662nPeC?=
 =?us-ascii?Q?ihGJfi4fF4OfcT3I+ypX1G4xBaFqxWST2kgOLJakyf6ySzHfBhCN5BZienoI?=
 =?us-ascii?Q?VFIes48zeOYIwayiWqXaGKRArk24K/0p4snhJWrHe2YC9UBOcynBJQS7uom2?=
 =?us-ascii?Q?V3JGIaMKz1LfXxCJSsPLHyO+KKgAo2ACJ/KTtfReDjTvQAYRl8hKX7nTjPDe?=
 =?us-ascii?Q?FM7crSgwYzeKFpgUsw43Lv53SuO+7Z/yHvqMxNWekbRT4Lixm0eCDCOs+nrm?=
 =?us-ascii?Q?mM/HlqJY6GZpjyWozw8FhUjU5HgS/5yBfJP5sQDDQDXa1HgiDPI8mLZwaJeT?=
 =?us-ascii?Q?QsCwuhiiRcsn/dREkXhNtoKQQaeJyYqob9pBRfqXfmbZaBGzqwiLTXCu9wyT?=
 =?us-ascii?Q?3fhJF2ccKEtvA1+dh0woQGVEJRwDLn877JdaDCqZigeMryHbVMCGSuSKzs07?=
 =?us-ascii?Q?ejGzxGPfxKwF+Hsewha4NSjG4Nuik5Mxq6IkOapXwfVhDx2xJxkAv2/IXEGu?=
 =?us-ascii?Q?iubOMjzxnVbQmA6awjGQ0xX0es/USuFIiLD/w9mhUonxPWHJK+LLF6PDrlLt?=
 =?us-ascii?Q?UMHl3VCkSlRI89hGjmU8ChJtodhyTF58LhTVyyJEv/Qcp4UtIKEhiD0XoQSj?=
 =?us-ascii?Q?d+n4MruZ2ROdiQFJ+jEIQuk1PomusuI2iCJuQ+1+06u50u54hVASnzQ+muTh?=
 =?us-ascii?Q?itsVKrc5FWn6Gctlf1/1UO9wX/AoF4eeGmrSI+mc7LRuUTYP9N9YobZhaQ6U?=
 =?us-ascii?Q?PNFHvDPxWe+htjuLoVefgw2E6itERM6ZaVvpqHHoUfM13Qly97WtX28iqHNY?=
 =?us-ascii?Q?gAWHBF1gEpTsaa3OKq/jxCMnPgBtS5Rf0vUetNlaG+CvBS6CDKyIWvK6veIE?=
 =?us-ascii?Q?UXLCBiUqh+GnJQcMhem2zOfe4icYaSOzklXnYytEf4QT+HZh6oIJWj5KKhym?=
 =?us-ascii?Q?n1zBZ+mlenDVhOkVw5b1nLOufOaywypFUKPw9IsgjBBTLiRZ8qQQZosYQPuD?=
 =?us-ascii?Q?rYL3tI5TI3LYYDtkF/G5f6VSE8whW/I+kw/tkrsIQjN5bac6SFtIvCE6jfT1?=
 =?us-ascii?Q?TLE/FHHjevGp0UwvkOsz5bI266/OSn1CUHyH4/e07PRNdU6j+6HvAXNlWu8a?=
 =?us-ascii?Q?HO1sd0N9cbcP9xshsTTKMStGh5NG0Rz2vcYaJ34D/exDwc5PECw0o8e7B+lr?=
 =?us-ascii?Q?ot/EdH/krBlcDMmIqxNBdGHuqunBJn9OdIRsRV3pzSoz/sFxquNNjIWMjBIp?=
 =?us-ascii?Q?0g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WdGkUidvS+oKMR9iSppiB4xFAt9gICaYs0qdJE7lh4t/mXwHFJxXVyFS70ofn/12fWPztYUAR/+KN4wRNRWXFh4+dh2UhTbXr3a76hu1FrgJE6/87qKxrRKjBkPjtSLNwc0pXWg/b1p+LV28CwkVzpQ1wz81/ZPJJwirYNNvxFGPIQ/chQNu8N6/yRYfSQFe5ZvhyIZvzggMAJMTOOIONLe9J1XMyiRgth+Hk4/u6r/lWNmBZQr7TE9Qi2hn2F4Vuzr1t6i1ZIuIAsRjPd7zjQ3PvXurrUeGsioazkJokdGXn3FPajdm2XEktyPTbXgHuniAImAvxZi6s+E7rYo3qlUBw9q2fyYH4BsojieAps7Xv9bw5VMysWYUYLi7I7B/VdADkETbuygUWu5xGL8PJ+opo2MzBQgNNTYMaGGLuhNLI0AljmfdEDVtp/S3EWk5gF50vAFlT1XCGuf7KTzw52ZoEkRGx+v2AyXMO4XAiFAefgtkZbjNK/7DDUj7Zpqqz4MmMNl4kQ/3vEJSZJBvn/cLWmsCvMw//oK41xjBUC1oYjPq5WocDGNdT7B/pNGBwU5phWVWd3VdNvV3/+haYGcENFRdwyT8W3KhdBkGZGM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 433eb16f-0c6b-4e65-46ef-08de15966454
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2025 20:21:20.7559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UkT86DKobpBCw9wCaWPld7JMCN4/QSIXBnJslyOuaV8b+8xgVRRELu0OsTrSVtSBdkwmHTkl2FBKo+30AFrkW0Gy+ejfhu0rS2lJi8ph+9Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF1A29160CF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-27_08,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510270187
X-Proofpoint-GUID: iirDTvVgxsRraHB_YqLOHOVsTMO9wL7f
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDA1MSBTYWx0ZWRfX+tbSV6MJbaeY
 C4s1vWXvPXq1qOmlj5af20cJLOxwez0TIeU0UOkS2pYpt5x1GPsRZManBQtOoxIhT4bYzaBOf8Q
 bfB8VC3UMCATPoqG7Qnras9tC3V3+x3X96NDJKfRCn1pj7XTG5udWQjYfvy3mlmiPCb2GsKCsJj
 BQW+nhEo54yuX1X5NqKRB9Fdcya3Ue1q1z7y/YClCRFpH9JUVjnk6u+1Y1EZ7izvW2nH3tBan8m
 r3AzRyUFl90k8gDx4NKw9YPOYeE36c6kNb2szLIDxUkO1ty3PltLocIt4a8k8rU8nbv5HDN2KVS
 kPS5q3LwDL3/Y0Jj8GPctJM/qm7ziP+OngpwMUTPhZrz174Wp8j0N0E5JLrJ4jYx7YKg9jT3drr
 lkTkZi3euZAa/EWVxqG48Jl9FLJRQAH25ezepnpu6FptXt3YS20=
X-Authority-Analysis: v=2.4 cv=Xe+EDY55 c=1 sm=1 tr=0 ts=68ffd445 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=zd2uoN0lAAAA:8
 a=7Bca2qynrVgGe8lQwsUA:9 cc=ntf awl=host:12124
X-Proofpoint-ORIG-GUID: iirDTvVgxsRraHB_YqLOHOVsTMO9wL7f
X-Rspam-User: 
X-Stat-Signature: kqxqrsroyruc5jfopame9wefmwn6hh7g
X-Rspamd-Queue-Id: 04D104000E
X-Rspamd-Server: rspam09
X-HE-Tag: 1761596497-168073
X-HE-Meta: U2FsdGVkX19y+BiyREe9CtphmJMMwMnIPrt+EhBweq7lO6SHKHwUY1iHf2obBsixjGGbZLe9iQJuuRu6644WyQHzIBvu6vZdsGm1g2l0ySINlJOiS4wH02TKv+7jV68nwcHkWPJ14KBkd/AO1MWHgF259W5ipijoSc5hjiZ+1MVRltJTHHwR7oSa2Fwm9YT268KkAFTzFakQn59DB+lPVosFKKhixlZ7FtfAAhuCgejZY30rjE5IjVp5oEybEyWghcpemfC7Ol6cWUmQbse8JOt7Ns2FknZDW3wzWg2Pn8z87BYZVOdhtv4DLO7cTylaHF1gGGRWnOY6xxLKOITPu4KB42NwRPC60oOMEzxr+i1CqXs9cmT84VYCDHGVysVZ6FnpnNrSHeyx5xbK7O0BZmARLw3DuvH7wBYUGKjeaLL0D2YfUI3AATy6YkAhf6fYtbGVXkKF4DqW2h6YG1WXfWpGhaexMqTXbeFwe+nz9Cphhgs9yGLpKVzWXnWmg9XdsVEIjIvk2iNTE+HtzEcm47YXcgyom3gWZ7bHlx+Fzs40OIvpdEg5/yw+WJPohzTz+SxbMJxqQCQPg0/aFJRupLpyN1ssQnzBzQ/8pKQan/oVbplx9cuTN27DcYoB1ov5fa+kULlNiUieT+bx+RCYoca+WUBk7uCxART+6zZy3IfgosKrz8dgKrXb8Pe+41hO0DyTZAbQSSZhdJArQKhQuWnbP+68BCjiP/QdsXS43FXTC1kO2saFMvaGcq3FYZARAPTFDLAOEGBEaLaRvBkg3sRztHph3Mcob9nO+7WKL1f5QwjfrklyAdoFl6K58zKHX8vA2sdUHdeW9A4mpx+bA5+kG9oLM63zCTDVWlOX0FtEwiA8F2OOTqZLOUw3nWjjrWsutwHnIwSK+xMyiEfg9asykfuOUqTdiRKTvW/uKQYcQD6rIHcnz0YxG2uOnqq5cA+tZS9w1pptiyeoiTE
 U7Fpq5gs
 7r2YQXeRg9fj1ReF4tyjA4xCNpRMyyTekApjyB4o7JI09nYMjrgtaYymytfsheWCNFfZTOReb2eG+TWAl54yR8ASA5uLu5YUTbHnLmrBcVesuedxSWjvjQWvGpkFaUiAbct5bpn+Jkk1fyPwsN28CnYpHi/6GmJDbbLW5UETR8PZtQJKDulBLauVDrqTsvwseOg5t5eX6ut6XTTBn8HmphL9fayyFodyJ21htmWKlx8QOnEvpVi7EVukCOqhVxS33ea5K0ozk+OuB5Z83XkP2SlYnNpsf7CT6BY5QW2NGSduo29NtoX04VMlRX6ozvyofAyGj4MYN9rLVdm3sAX64rYeaf2fzCK1/qkWoUTR4Zyh/PqbX/HYkQk539UNlr7CFIX5qGdPqKwt6HRwJKWVGmeQA4dYGw1izb8JYQSm4sZJ/LjKYawUrSxAzGoFqD6wmHGPh8kY7AvtOzEvdzBqM/1ufJc0Uxf3O/L8Ldtc3UvNb8t7Jph94JmN1DnP6c9XsoWlwYPe5eZHkyJ7dCFpV+uxjCHsxTLRu5bQPvFUOff8CZawuJUHEppGYZiFH/b7POHeXmoOcQvgyiZ9Paxqf6mK5kfgiP/YDW+4cc7gwf/ni9Re+r8C3M7SUIAm6/O6GOoj5Lq9MAevJOnd54mV1xpRpHH0r9e8ZPgkTxWkfCmF71ICjD7zjr0FKiDXaajWn6iUKpV9UD7mPPQz4r7FboRs0pg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Performance when clearing with string instructions (x86-64-stosq and
similar) can vary significantly based on the chunk-size used.

  $ perf bench mem memset -k 4KB -s 4GB -f x86-64-stosq
  # Running 'mem/memset' benchmark:
  # function 'x86-64-stosq' (movsq-based memset() in arch/x86/lib/memset_64.S)
  # Copying 4GB bytes ...

      13.748208 GB/sec

  $ perf bench mem memset -k 2MB -s 4GB -f x86-64-stosq
  # Running 'mem/memset' benchmark:
  # function 'x86-64-stosq' (movsq-based memset() in
  # arch/x86/lib/memset_64.S)
  # Copying 4GB bytes ...

      15.067900 GB/sec

  $ perf bench mem memset -k 1GB -s 4GB -f x86-64-stosq
  # Running 'mem/memset' benchmark:
  # function 'x86-64-stosq' (movsq-based memset() in arch/x86/lib/memset_64.S)
  # Copying 4GB bytes ...

      38.104311 GB/sec

(Both on AMD Milan.)

With a change in chunk-size of 4KB to 1GB, we see the performance go
from 13.7 GB/sec to 38.1 GB/sec. For a chunk-size of 2MB the change isn't
quite as drastic but it is worth adding a clear_page() variant that can
handle contiguous page-extents.

Also define ARCH_PAGE_CONTIG_NR to specify the maximum contiguous page
range that can be zeroed when running under cooperative preemption
models. This limits the worst case preemption latency.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Tested-by: Raghavendra K T <raghavendra.kt@amd.com>
---
 arch/x86/include/asm/page_64.h | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
index df528cff90ef..efab5dc26e3e 100644
--- a/arch/x86/include/asm/page_64.h
+++ b/arch/x86/include/asm/page_64.h
@@ -43,8 +43,9 @@ extern unsigned long __phys_addr_symbol(unsigned long);
 void memzero_page_aligned_unrolled(void *addr, u64 len);
 
 /**
- * clear_page() - clear a page using a kernel virtual address.
- * @addr: address of kernel page
+ * clear_pages() - clear a page range using a kernel virtual address.
+ * @addr: start address of kernel page range
+ * @npages: number of pages
  *
  * Switch between three implementations of page clearing based on CPU
  * capabilities:
@@ -65,11 +66,11 @@ void memzero_page_aligned_unrolled(void *addr, u64 len);
  *
  * Does absolutely no exception handling.
  */
-static inline void clear_page(void *addr)
+static inline void clear_pages(void *addr, unsigned int npages)
 {
-	u64 len = PAGE_SIZE;
+	u64 len = npages * PAGE_SIZE;
 	/*
-	 * Clean up KMSAN metadata for the page being cleared. The assembly call
+	 * Clean up KMSAN metadata for the pages being cleared. The assembly call
 	 * below clobbers @addr, so we perform unpoisoning before it.
 	 */
 	kmsan_unpoison_memory(addr, len);
@@ -80,6 +81,21 @@ static inline void clear_page(void *addr)
 			: "a" (0)
 			: "cc", "memory");
 }
+#define __HAVE_ARCH_CLEAR_PAGES
+
+/*
+ * When running under cooperatively scheduled preemption models limit the
+ * maximum contiguous extent that can be cleared to pages worth 8MB.
+ *
+ * With a clearing BW of ~10GBps, this should result in worst case scheduling
+ * latency of ~1ms.
+ */
+#define ARCH_PAGE_CONTIG_NR (8 << (20 - PAGE_SHIFT))
+
+static inline void clear_page(void *addr)
+{
+	clear_pages(addr, 1);
+}
 
 void copy_page(void *to, void *from);
 KCFI_REFERENCE(copy_page);
-- 
2.43.5


