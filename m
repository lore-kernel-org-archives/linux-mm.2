Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9D5BD0EE14
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 19:01:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 111776B00A1; Tue, 25 Nov 2025 14:01:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C2256B00A2; Tue, 25 Nov 2025 14:01:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA4D46B00A5; Tue, 25 Nov 2025 14:01:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D1F1C6B00A1
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 14:01:31 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7BCB213AB2D
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 19:01:31 +0000 (UTC)
X-FDA: 84150047982.14.8A645CC
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id F138240022
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 19:01:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ROBNJGAB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="qbRPJfL/";
	spf=pass (imf01.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764097288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JSgmqabSK4hdntoL1biypMYLxEs38b39AyyVvsAUaqM=;
	b=g96P00RhmTORv6BdXKdq69c2DDIF3a0VuLQTsi4N/S6TbnsvT4TBNfJ+QhNVP222DusgXO
	bgOVo20WezsOPRmqIwqnCqsZ6a6OmyhhkJFpU83A+/O0rDf/cdiHneG94YeFnjMKbexcUL
	w2QlM51F2ltPMeM4VrQgfND8cQCYDUY=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ROBNJGAB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="qbRPJfL/";
	spf=pass (imf01.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764097288; a=rsa-sha256;
	cv=pass;
	b=sgG7JWnoRthvTHVjrmxO9mhvC4M+s75KXQjYAaq1sUTv2DtvZ+FPLLVssaGLFNOkn+0e7c
	h3p2hzXnQcNEXFwLtQUCTjThezFvaC9RFWJn8fnOomaeL8rBbLwlOEQ91nDJ9HwgB2heQP
	v2mjavVWa2PH8xHUx9mvq+vSGVE8bwU=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5APHf8lV4050942;
	Tue, 25 Nov 2025 19:01:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=JSgmqabSK4hdntoL1b
	iypMYLxEs38b39AyyVvsAUaqM=; b=ROBNJGAB2/Xo08iBChCNf/ORihsJszoSCW
	MHs5hEd0QDuPAFqhhQvReIAqnymr8/7G/zeQlJFMHagjTdgryP3CrxtYEGjzJFH9
	gzoPlsgPp+E8f0a9yYAMr/Ah/RZu+KGj55dG20lMWwt1vT1jwLAyuk01WNfD7p5a
	t3YxDJsFIuLKl9ww5MSm/sJbCRy9YBOcWdgWkfW6sL1zjGWCviegnbXnN6OGdHYF
	Ilf8SaNPWD126UhSdN3l6JbC13mlmnPVFkzRErP9eHXgMEVF91wNTkX1tNCmcdZH
	nj03zlcWnNoCty+pC9+Dnave1tVHSZs03YepYnmHTajl5/yW4rMw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak811qett-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Nov 2025 19:01:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5APIMagp029626;
	Tue, 25 Nov 2025 19:01:06 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010004.outbound.protection.outlook.com [52.101.56.4])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mdf506-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Nov 2025 19:01:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n1Lmsar0NKTn7KtfjMhFQCFzrV/zaCkaeasZb+HRUlxGT1Aqt7/5H8B4XZssioVK0D7BiCwAWE46q+3CFUt6HQ08MYKZaOMh7VwQdJy6xfG6Xqtp3AKLIKRyE7WbpJgfcTgQnb9Gv2oKTmRB3xhz6u1t5OoGZPKrpHwfNgqnVU9HJakghaLi9N3zadIkYOOTKgwEdoVAQxUZ+Z5wCP2wsCMstFLhhQDIc0FlVXfmmkytcvpjGY7o6dr67Dg6OQqNzkjKJsNdVQkMqpQzX/iggS3eIxNE8Bs356HLY/0X6VyVQLK3F1OJdWGDf4jxmoOSXemfhMCOSCm6TddLAQYpJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JSgmqabSK4hdntoL1biypMYLxEs38b39AyyVvsAUaqM=;
 b=ym9VJGwGWNFl+McHmgxooOKyuia5aL7X+JM5vFyYOIeBa3D4e9995N7xPUfAUqoOm6h5G6xT3HUQl9PEH8IEHpRIm3uw4yxouQmvr1ZXzikd9S292mB/BcUNLxAU1MQiS3Wi3xndXto0nYXtybOI/o4VkIgylsIAJOcDceIZKtwTZbxhAgA2P0NbhkyDT4j9ZM6reaIzdBMw3nX6mxjPz9YALzP4yr/hrj0G+2f7I5b06WN68UxyP2coV8d/V3nLdnxmStKlWPNmZR+E8VKeRf5nuPIrNS/ljZud4rkMCMdVhgUSxw9aLJXmsCO17DzlFIBYupE29YyQ+X99J+sqiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JSgmqabSK4hdntoL1biypMYLxEs38b39AyyVvsAUaqM=;
 b=qbRPJfL/jVoK2ywFsC76gSflZx+z+f2eblfN0wJgmNmW0XQwuSNI9mm4Etsi215uRAwyB1m4fMlYBmexGa0mN1cuE7nQ+HwHMcm13pQwAqu9XohlGqGMYqKjNOK0Z+Vh3cb6mVHQZ/rDblzE08ks3KpzEkFnDVIdPyo9XfeTvio=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CY8PR10MB6586.namprd10.prod.outlook.com (2603:10b6:930:59::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Tue, 25 Nov
 2025 19:01:02 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9343.011; Tue, 25 Nov 2025
 19:01:02 +0000
References: <20251121202352.494700-1-ankur.a.arora@oracle.com>
 <20251121202352.494700-5-ankur.a.arora@oracle.com>
 <20251125134755.GMaSWzi-_vZwdkFcdp@fat_crate.local>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, akpm@linux-foundation.org,
        david@kernel.org, dave.hansen@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, willy@infradead.org,
        raghavendra.kt@amd.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com
Subject: Re: [PATCH v9 4/7] x86/mm: Simplify clear_page_*
In-reply-to: <20251125134755.GMaSWzi-_vZwdkFcdp@fat_crate.local>
Date: Tue, 25 Nov 2025 11:01:01 -0800
Message-ID: <87v7iy6ioi.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0169.namprd04.prod.outlook.com
 (2603:10b6:303:85::24) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|CY8PR10MB6586:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ba41d9c-ab8b-4434-f72e-08de2c54fa79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?R8iuju95j87m65HaPS67BO3wy39w50vfYoF1UZzHkcDjcvZF77OiM88mutrS?=
 =?us-ascii?Q?z3764yCMeBsdYhtlhkX5t0oIL6NB03ahlWyXkUPzyhomnYMno9wOooZI6Wpv?=
 =?us-ascii?Q?+vKWBR3Mjep/BzZDBtJdj96iz/yHIUMd0EMZhLGbj9q6kiCbOdQFg9GYY4Iq?=
 =?us-ascii?Q?LgcZ1d+ksZsMbXmsuf/sGlM7PkSRSaU6kihLMogAMAywPh9byU4UzZ8aYhsD?=
 =?us-ascii?Q?uLsnxatuucj55bTg/g5oIb8SVMCJGVGcKCWT5dmf2bxT3n/zvf+Io/OVzelI?=
 =?us-ascii?Q?xpgv3Ns+pzcG9tC21+7VOi3yXp5y3tbS+LuaD6scPQDqeFmLB2Jur3GLj4ML?=
 =?us-ascii?Q?lLOTI+TVW+/BfZ5G2h7NKxu7reWQBbltOLlgFkElU1WGTqp+JCGKU3stlLi8?=
 =?us-ascii?Q?IxgkxfJ0MWOoz6KeHiped4WT+dGFUpd7BAEKMOAgsg87xZr/dORZvLIPpeDr?=
 =?us-ascii?Q?KiuTj3T83EPx4Qc4qnd7OEHuZdBc+MKgakEC8gN1VyY3HA5uK7GwlF75a5pd?=
 =?us-ascii?Q?Iyrm+PAH9QhHYvML8eIa9lA9S1S+OjMUOP2o/sfPbpNcF0nOnWgeCEqrHN2T?=
 =?us-ascii?Q?RGQMPXwljYPpvfiDqZQ4Bf5iEhuabgoCCGsRjRAhcrTEfaexwm5nlqVsukKP?=
 =?us-ascii?Q?YK0KFDjer2zz8L0qiuHWaWcEPbAI3yynFaR6sxAhqbeCKGa7Z/dtg0+S5yGt?=
 =?us-ascii?Q?kqG3NAaRA838AEF1RcM1WGyFfU5PuKpXZ33DefR6DRCKKhcaP60o9eAev2P8?=
 =?us-ascii?Q?DhUfuvCZQoZ2sdX0+I14rdA+5Ll0Lgt+iQv9ZFeFOc04TSAN3PhtfmNl28je?=
 =?us-ascii?Q?a9VifDSVbNOoPQWgXXZlIDYxqlrym6tCse9z7M88Ov4KkmUcIVV+0Jx+Sqwr?=
 =?us-ascii?Q?AqhPFy/f8RxDBRihfOzF3rmUQAGPss4PxVM7N3JwYAFXZARfB9c1HCDY6Wsg?=
 =?us-ascii?Q?K8yYwAsj4WEvvhoRQve7LkdMUBLYM8pjVPrclWTekNcfYCyh5YsyPxIaOmtY?=
 =?us-ascii?Q?40v0VaKmGuyIA+6hrT30lYmEu/30bQz/QtyxWgsfc5VxUzr0DvY4d3/hnfNf?=
 =?us-ascii?Q?w92SzsY433dTGrc3TFPXv6Ohd+XM0KV9q6diehpXutr/8agfHKgUDKg/sA4O?=
 =?us-ascii?Q?qp3/UK7eyngO9WpF47hv/eDE3MugvVxrmANWKtBDjYsqJqv3n7sS0SlX960+?=
 =?us-ascii?Q?rUU3uSD2149Nlp7Wap/H6IBP6c6prMndOnGCLN6F1ULjDwoyP/ax0Q1ctnO+?=
 =?us-ascii?Q?e2x0AECgOlrEOeMfWXYD2eHFmHL9ITUVkRLSSvjeOGTPWPrjnZDFgdgB16Lc?=
 =?us-ascii?Q?pWac6MiDLaA0h58SaBsczIRrQ4JCmi7t0pRrLyM5xo9nFdonJdGknOcsLNOn?=
 =?us-ascii?Q?styrs6GvyVAefgplHf0dFTtblYcyeN8CyFk0QPsQChTaDwoyqAcuHfF61mbj?=
 =?us-ascii?Q?opBNugFsP1MTA7LSal0ZupSTxh1wiCxj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XIoLZp8HRHgHcz8RqAzkwAZ4KtDWWycwFEYqvR9NNFoPS1tLPvIWxDjqH1c3?=
 =?us-ascii?Q?s7BsmU6BKErtI2UYQg0us87MKparb6gvrTTJ+dBAxo2cwHDVk3X5rUixh494?=
 =?us-ascii?Q?v9J7YJOMTW3h08iO2RGSpJQzZFxwmAg46x3eA5mHCjd8W6gznWq3ooFsr14x?=
 =?us-ascii?Q?PBAPS2hln90fof5xcw4tD0k4c5WIpEB8jgsi83wq1H0p769sSMX4JQT5LOF5?=
 =?us-ascii?Q?BP8ielMbDSN20cAWul93Hv1hJAEJzjkzLyW4Ejber6W7yQKRw3pxTJ0yh3ZU?=
 =?us-ascii?Q?vQ/CAly6Mhs97HyJoK1T2joF6zdAhByCe2gt3kbFXIWId1fpW4AOmZYoM4tx?=
 =?us-ascii?Q?SNW+KWGtyFQGPlC3BndihXQCja24kx1PsyBL8WajHi233mwTuFDEAMmJxkun?=
 =?us-ascii?Q?SpTgf8ypIQ2xe0betQbCpXPk33jdGjanoDgioISO8RInRJaTvdiIakgsBZLi?=
 =?us-ascii?Q?MdFj8uof50+vVqdhxaW+Vi/CNqgaK0MQoPE7/65S8uXQGHs8SocJ9P1Z2Q7u?=
 =?us-ascii?Q?IWFbp86b3Sh7iI+A+qSi/3+q6+RFniF9VyQbNXaGDO+Q1QMyrzxaucAOIKoV?=
 =?us-ascii?Q?7ve6mA66N0beccqpNRpCsAH8FXvgdY3ZFiEAQFlE+fyi6z24aKvv6e+7Smmt?=
 =?us-ascii?Q?/T6qYafCXsXHqrF+w8B1ZhUp3wB61k2GJSP4IfNcY6OKMWXNwsYgHzhjkx+Q?=
 =?us-ascii?Q?2GRvRuKpp2j1Szo4KULtXppYh/e7pO2fm/XNtH7yMNjyZdV1gtb8cM8u/QbG?=
 =?us-ascii?Q?YynZ59PYIYfGJyXa8t5VY/0b8bzKf3D1a23LL1RVfneUdvi//hIbEYX1N2my?=
 =?us-ascii?Q?f79mU7lUJ+sR6P8ylC345AkH3IZqQtTOZi8qWJnDoqk2XE+llDQU5VCtxBvA?=
 =?us-ascii?Q?vz9/Oqmcqk2DefuOwXfXdM81cgUvg7ByABexD6q6jOCj4YnMM41kvl7jxtxM?=
 =?us-ascii?Q?D+wALzViwiMZ60ZznJHQdeHFpWQZuopQ8z+miSK93Fzq8sA1RDeJfcjbz8NM?=
 =?us-ascii?Q?64qdRrum5avZF6OI060N1nsGK66O12m6UgT86QNK/ZnRAPhqV0CQwsYJsBjj?=
 =?us-ascii?Q?jIBAnX4XzrkEmBg/9RfJsgHR4nxQD/zkckKLUFR7X0mK/Y6H9+5NbJ1g2VWP?=
 =?us-ascii?Q?veMW+HePFsRVLjCDGg4orn1kVOeiWXhNyoLyfhz8J1tPBBgFapDVz0w7/4+d?=
 =?us-ascii?Q?6rd/GSqzv8jdfd71FYr11SOQpOpZulQ9QHbU83klIhtZDxjMXr60epzJ0gdG?=
 =?us-ascii?Q?HxROIt182svHe+yHSoTfPpBG4ESOsHZLBmqNDbyfp8RtVMzUA6uT9ZrG/Jlg?=
 =?us-ascii?Q?q6R2tjE3b9A/UT2Umi7xQscpOP+EetMH17hAvG5n0APNyxdpmJ3VnhIrAjpP?=
 =?us-ascii?Q?J8mD1Bd7Y3LbNtU+v6hZDCViJsHlY7wJCLt/obXgD17Z9Snmq1a1CvcKbjWi?=
 =?us-ascii?Q?ZAAmyTzlVnrezLBqezk1P4J0zdtigCaUfPafZJzO3ze1qN48j+PF7IeO7zU7?=
 =?us-ascii?Q?K3VZ5cWACySoBW1wXHASAv6PWqko99NoOwzCc4jm8yMBZxUDpFUigX2BXEOC?=
 =?us-ascii?Q?9u6+Got8v+9Sg5qGVHt2p45jNEUok4KU4rVdWfem7Sj43QqZX61U4hhDvupz?=
 =?us-ascii?Q?PA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RfviDBPCJ+fRTtxPMYFWlj7Gan50549mIncZN4aptUuYBKKV0jDiO89qbL4gXsKCcypTXI+Iho/LbmapyNjTLS/6F8mE77Nl2xFP/FLrr/SY4jFJqkd3YRfPSd/Dza8DWeuEGR5Xo+z8Wg/WgZ5ge7w0ADj5OXge9YMEgwzlIkd78VPRYM4z+OcK/jNvQ2H3fZI1IJXKW6UFoeahhweym0yA3j14aFZaW+cmeyDTbJc+nYt2wn0ymDN4/5Z1Xzm8PNViKJxUQp4j1eZcqmiBUdaPIrPDil/Bro8FtzuE3oQWNcJiv7Zvx/wqvtgTne6vIzljg2ULXQHmivfXmgPCmx8l61Pr2l25ErV7opUHQNK2wLsFKTbJISCYSB4WBfNq1/+YwZq+wcghJDwi4WcZYA9q9w21NZ8w6lKyDtcJsIjPF7C/6aihQoD6uqJNK26+WsBl+Muh1NDFFUFHJzPcdjmkz8Wm7+0MN47AAnPo7pPAEd2ERV1zdXEOR9q5Ol9drKoaJF8G8rjKbReuBUa3qLKCPgapZ13i7eGJyTW3TlOdxUQapclE3nvjODAqKhjjXya+mqLn9CzgGBt7DN0Ujq6y47CsCWcEir+IfUwaOnA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ba41d9c-ab8b-4434-f72e-08de2c54fa79
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 19:01:02.7439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GMGsIKRYLU8rn38FJVxB1HbXjDQD8lVvQyCKfvT1PD0IPeoqyC0j7DGi6HOR/dQCpBe/ylNT9MXzEKXQtqzQn4MLOvLykL5t1TzYGhxqK0E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6586
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511250158
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI1MDE1OCBTYWx0ZWRfX+QduKhYj5hLy
 wqeMvCG7XVjYyodu20t0YWyDlMpfSiL7V6dgJ7PMkYJllPazqdQHlFoE1Nj/IFYNbulj1OFsVPB
 7t/oAxmB2aq43fMnBJh3HunG4ddaSu7001E11/++ugPB17C/rxCS+K+StpG9tkO1QDhNVjaAU6B
 4/WmhDTg6fuHhdzz0R/jkk0TWiwz5d3IaoOm0iF+u+1L85sHgnpi5v1pU9AoTbLc7nRyqfFbWVy
 f0HUZepwlc9OONrmVKAbRiwzZ4gu2q1OrAVg+1Rh9NmuKBg1q+7k6FcDpAx4h2GTInQ/2NwHmLO
 F2eh1kKpF2OPTBxYlN4/pd6Ftyf+dkr7HpMFsOzrC7ZlUbb4NufHC9rzzw+H0B1Xz+wYkAxS7Zy
 22ZMisYHer9yQQQOz2GhaD8sv9jAE20KTo/gN1SIcMuXHKExUXg=
X-Proofpoint-GUID: mO4a1ZvumXazANKW9s_lTMiZD3qrJ7uX
X-Proofpoint-ORIG-GUID: mO4a1ZvumXazANKW9s_lTMiZD3qrJ7uX
X-Authority-Analysis: v=2.4 cv=KKpXzVFo c=1 sm=1 tr=0 ts=6925fcf3 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=rDust-YmccaIDkHphkMA:9 cc=ntf
 awl=host:12099
X-Stat-Signature: 1e1n848comz5qem8bou99ge68ewhs856
X-Rspam-User: 
X-Rspamd-Queue-Id: F138240022
X-Rspamd-Server: rspam09
X-HE-Tag: 1764097287-329266
X-HE-Meta: U2FsdGVkX1/k4Fb4qH6vzh/8nALkw5wM5ENwe+Fp3eiCtEiTs5UmFifFH3Tlodeqdb25LLIikpq12Vh1+0POXLrMVSAaKvd2b3XxV59/BLvceX+neHHNr+Ush79keroa6Y4tRgVkVn9hW5foLlw5GAe86+2dX4NgNJz1/eWluXtSQOZej+O2MTBP13GgRyXQP6m1lIcKIdgmUvY2CIhUoJC9ckOFGj30nuQo0XRRrWTpl2TZ+tO9lsSeMUJ2Wp7158Fc05dyFK5T0xZGanNOaHMCwZwotFdQaMuOnnYpBsZhEQXpm7GIfoWIZ2xtZvtbqIGRbTh959hPOuG0J+p05R5aSvmTAIlu7mzulc+1M3MpuaPwatWNFq9ZQxegPQxyo7bww55reCtX+lxN7dsCPic3RlnKd1Ss5yfk8JXEcgaZAFGh8Y7FLxWxkm30S+XGc6zeBXUfZjeco6uw0NIVQ7XKRxOGxvOw3q98lNeSnjdWuTtkziTvVzYMf6DSN6ZYj5y0iWlpZfZY9JQnDFLK1P6ejCQYtnpjjpdKkvHZ1lmJMIlsK7WLVGNNE7OzyGRt5xTEuCsziAkdHHonJ8iA8biU1ID1NU3XK8rDOA40A6p8MISR0AQ0Pi5yrnj3etmZETJM/+FPaXVVVk87EVdWf1QtJnky1cWG38NxmUqoZ+o5oI3BLSkXY9pfq2oDfGYOLDROuR1/fMBYeNfQd5F6+CPDthDobgvr7SD8B4PAno+AgYsbJF36Ah9R2ToiboPiFISZDGD3WjTF1OCh49ICHhmWmXlPtUG0dLEQMfs5O1/dWC0ARsbvxvB+VY9OsKSchwnsJIDRncbora8yBwsGMUgeNPoudlzhwx9fzi9AN0E5b3BebbXfl9qxCUyW3vEX4QPS51j/B6e3yrocxQ3GO7fZrH0TRHskkQXaJPZM5h70Z4vQlYyRlgFavgt0RUD8oD7dnwYX2MiCnDFamUp
 4v0UQqhm
 hFKBiLQWWU3Y1RNOIQgAKuaouLSzqW119eXrnqcSgxqFF+ouvrDCw7tAeZ0L+UKdVLSM0QP6oRakHYxQEW1MDIsQtGqqIohNNUqWNPEKXO6HG2+DvTIlC4UYLcCyqTWyU6k15pvXZCHMWiujvvjI1bKvSWpLvzR2ExfQYZbruEaWl4DFHK0VbVPGyfU1MlSRmVRthlVEAbVWe2vfSPdZg1oX0f4BacCoeHmG/s/ttbQHhw0xpKhNagonBlETNuh3rQWDAUfCCqfY3FQFC70vXgY2uYyYf2P6Z54pjhGNlqRmMhmIY6nfIUTT87YgOJYTz71MJ0hXLSefgok25ZsXXWDUSm4lALc1bY1O7VwfwwQZBqjVG/u57I3fyw/TaExXeNQ2IHOVafrFt/ia65buqcJ2McI34NE6tFUKEdDWEHFtBs2t9g8XJeIUktXrSkpgDWVBwfRg1WywWsPvsuUw28p8YI0JFJscrsUuGFStAKxWQcstMs0mvbvAU/5Mq4PYBJdfG7Nnlti/SdzwTC5j/RaX5P6MqG7qbeSEloeBEa12kozP4GkF2Q2/2JkPUI+4TS7UEWEsCGToRcP8ph9sPDcTpSJ9PId6pVO43vMAgQ7XNZRzJJ5vP5utnEkWEYJ4vXlcK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Borislav Petkov <bp@alien8.de> writes:

> On Fri, Nov 21, 2025 at 12:23:49PM -0800, Ankur Arora wrote:
>> +/**
>> + * clear_page() - clear a page using a kernel virtual address.
>> + * @addr: address of kernel page
>> + *
>> + * Switch between three implementations of page clearing based on CPU
>> + * capabilities:
>> + *
>> + *  - __clear_pages_unrolled(): the oldest, slowest and universally
>> + *    supported method. Zeroes via 8-byte MOV instructions unrolled 8x
>> + *    to write a 64-byte cacheline in each loop iteration.
>> + *
>> + *  - "REP; STOSQ": really old CPUs had crummy REP implementations.
>> + *    Vendor CPU setup code sets 'REP_GOOD' on CPUs where REP can be
>> + *    trusted. The instruction writes 8-byte per REP iteration but
>> + *    CPUs can internally batch these together and do larger writes.
>> + *
>> + *  - "REP; STOSB": CPUs that enumerate 'ERMS' have an improved STOS
>> + *    implementation that is less picky about alignment and where
>> + *    STOSB (1-byte at a time) is actually faster than STOSQ (8-bytes
>> + *    at a time.)
>
> Please put here in BIG RED LETTERS something along the lines of:
>
> "The inline asm has a CALL instruction and usually that is a no-no due to the
> compiler not knowing that there's a CALL inside the asm and thus won't track
> callee-clobbered registers but in this case, all the callee clobbereds by
> __clear_pages_unrolled() are part of the inline asm register specification so
> that is fine.
>
> Just don't assume that you can call *any* function from inside asm due to the
> above."

Will add something clarifying this.

>> + *
>> + * Does absolutely no exception handling.
>> + */
>> +static inline void clear_page(void *addr)
>>  {
>> +	u64 len = PAGE_SIZE;
>>  	/*
>>  	 * Clean up KMSAN metadata for the page being cleared. The assembly call
>> -	 * below clobbers @page, so we perform unpoisoning before it.
>> +	 * below clobbers @addr, so we perform unpoisoning before it.
>
> s/we //
>
>>  	 */
>> -	kmsan_unpoison_memory(page, PAGE_SIZE);
>> -	alternative_call_2(clear_page_orig,
>> -			   clear_page_rep, X86_FEATURE_REP_GOOD,
>> -			   clear_page_erms, X86_FEATURE_ERMS,
>> -			   "=D" (page),
>> -			   "D" (page),
>> -			   "cc", "memory", "rax", "rcx");
>> +	kmsan_unpoison_memory(addr, len);
>> +	asm volatile(ALTERNATIVE_2("call __clear_pages_unrolled",
>> +				   "shrq $3, %%rcx; rep stosq", X86_FEATURE_REP_GOOD,
>> +				   "rep stosb", X86_FEATURE_ERMS)
>> +			: "+c" (len), "+D" (addr), ASM_CALL_CONSTRAINT
>> +			: "a" (0)
>> +			: "cc", "memory");
>>  }
>
> With that:
>
> Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>

Thanks!

--
ankur

