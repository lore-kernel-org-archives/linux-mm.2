Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4660CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 08:14:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DDD88E000F; Tue,  2 Sep 2025 04:14:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B5388E000D; Tue,  2 Sep 2025 04:14:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBF3D8E000F; Tue,  2 Sep 2025 04:14:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D386A8E000D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:14:19 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DA630140B66
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:09:14 +0000 (UTC)
X-FDA: 83843585028.05.B9AB626
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 90D0C1C000B
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:09:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=EXDsYR0a;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VM8ACx3R;
	spf=pass (imf21.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756800551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UPWg8IaLCGkrS/X2oPVs17aaNpSGv/rcwYn5unoSWaY=;
	b=SNa7qtAjvXpm2Q0yBR4epJeV6DfYOqz3eyvY0kZkydSceVIqAdgt5aFU41AoyKTgT2oY0Y
	Yt7RcJLvxvGY5AOzoG5sV1N8L9oBk4C1ZfnvWcuTt1qL+3s1sjJOE1svmkaMPs8GbORgwi
	2IIJPc4P34UYSSBpXp74Dr0HwZaYaZY=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=EXDsYR0a;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VM8ACx3R;
	spf=pass (imf21.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756800551; a=rsa-sha256;
	cv=pass;
	b=FXuHFK2viX0Wd7SoEQPcPMHyt/HomFFjFCOHGsPLDTCsxx19/nqbAusLQUzuuXfcPTUQHS
	NmpbVy47DHXirs6w6/WEt9NPfD96ZM+C3+qtP8ZeQ0ii49vRFdNOiJAQTqA0oXE6bjRzUI
	jfaUEPVgcAoyRLSKHli90PBohGra9Io=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5826fjWn026302;
	Tue, 2 Sep 2025 08:08:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=UPWg8IaLCGkrS/X2oPVs17aaNpSGv/rcwYn5unoSWaY=; b=
	EXDsYR0ai9yGc6iO77O9gb/wgPGQF8X0pCeEHoIM5Adz84wuVz2RgHpyubCS2lQ4
	0x5CnZ8dGmWOCXmbEanX9RXRI6nGihLpHYWbtjDp02Lgd3yLE1Al87fY5v6amh04
	yqena3daW8jsd84W7XCea+TT90l/1poyLczzdxojdiMF+JuphPaV2scX78JcUKqc
	WUitsMnbVHqM4i8YTWdzNBlcQ0kh6DPF03O0+pwu5SNRyrFRipdHrdxe7cGTTTQh
	gYkuuBUhEuZe9Y/A/jLrOtDQadf8UkbSQMULO63CdSMBY23Q2ILq3Q4iDQ49ZD86
	/OflufU9hGRWwItKVF9Nwg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ushguf98-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Sep 2025 08:08:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58265DfX024980;
	Tue, 2 Sep 2025 08:08:53 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02on2084.outbound.protection.outlook.com [40.107.95.84])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48uqr8j726-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Sep 2025 08:08:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vHCkEHwTestNeljwhXuLD1pxm22BAyhTfTBxEV6+NoNfkO71S5qxzWFd3KbIogZvrTwQRnTJEIth+WQT7lCcY5wiEAgoPkOEtfqntJPVVTPHcUzONQXSSHNskvprtGvKGKbXi4Qlckh9AOfYFD/UF7WAmHnGh8DZVdmtzFUtHNyYhqhBthpDoQSX41/AUiHgNG+Yz+May7YVLepmbPWHJdlv85HYOVnzpLNl8qmZgcg/Pa8ReuMuyAmqGvJL6gSqEzKecARWvUO/6ZVItQ7P68tcjr3dCIOihJCbT86eV3+YHxeE3MFHaPcvtQMbCUx82Eej6vDUVPsHEgQ/65AQNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UPWg8IaLCGkrS/X2oPVs17aaNpSGv/rcwYn5unoSWaY=;
 b=EHY+EMkiLK2EOC6BoWpaJ/gUTM09eQgl9ZqZnOR65V+uwK33BCi5b6nv4CkclGSFDBNyJ4m31tdKCP144JyjLDGXgzOl46PJ7XIHxzsStUuD9DGjyStcK8DdZUacd2/0FVe4qDGCAUPd3L2ML39/O3iPstf9QIv+c9lAkr7nHnw/3LCrGsB0KfPl7q8//vsgUbmHXknO1yArI5aFwueRhseakS7ICCW9Yb99KoPVuvv3f4VbXrEI++irFMyKjHRaglpAEYOu8HFb5wNqbdGFBxFGcqlke5yi8DMB+NRhUILMwhxbnuskTGwrL2QoSETMm4jfbFjpjnOS85Rpzr6ttg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UPWg8IaLCGkrS/X2oPVs17aaNpSGv/rcwYn5unoSWaY=;
 b=VM8ACx3RqR+J1bKgvQmm6uGoZgqwCRO/uieZeAf/vYAYFWerrTvfE1IZWjaiWWhqXajOALunH2eyxuUMN397eCEp1yZZw8DJ0I7F58IOYwzyUooDSVnDpNoDA9qvc+iVL/di7rXfvVlWLua/87IOl2/W1uNi13Kvn9uoGE8TfkU=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by DS4PPF6ABE13187.namprd10.prod.outlook.com (2603:10b6:f:fc00::d24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.26; Tue, 2 Sep
 2025 08:08:50 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9052.013; Tue, 2 Sep 2025
 08:08:50 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        acme@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
        willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v6 14/15] x86/clear_page: Introduce clear_pages()
Date: Tue,  2 Sep 2025 01:08:15 -0700
Message-Id: <20250902080816.3715913-15-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250902080816.3715913-1-ankur.a.arora@oracle.com>
References: <20250902080816.3715913-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0127.namprd04.prod.outlook.com
 (2603:10b6:303:84::12) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|DS4PPF6ABE13187:EE_
X-MS-Office365-Filtering-Correlation-Id: f4d11626-9ff9-4828-816c-08dde9f7f32b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gGwwijXGUn3eYjMml29nfOq8RiWQ1h/Jll3kM2jvyFrsFif6+4ZDntkergqR?=
 =?us-ascii?Q?kkjFASmggHKQxCARbOwOAXOxBhDSRorlMaouxn6wtKFWH2ade04MBCS+cbz2?=
 =?us-ascii?Q?yBotEbZYLT1d6HWvt7AzZiXSOgh9f5/aECya61pP5S9f5JmeQo/zrgmb3ebr?=
 =?us-ascii?Q?BSlNeL2AyXYYIHa2JQ3my+2RKBMbg+xKScIYlRNf6BOOJJ6JC0p8irYAyzf2?=
 =?us-ascii?Q?+2l/GnEtXi0PoX9Ncy2YjDo8nQdTGVfmCrOjSw9MbEThVPZEDa117OWYdpHn?=
 =?us-ascii?Q?5MJOEWRQY7D0lIdhVdKmcFGTPr11eE4WF3xyUMWHKYerO12KlG5egpsE602k?=
 =?us-ascii?Q?MWGS7ZdjH0pZ5mnDOHid45PMMYxKQZ0PAv9LPFmaj10heCMyEFUhRUvHZP5v?=
 =?us-ascii?Q?ZRZjRML/JJ1SGy8WW3pXgwwbg+KEYVig3p11lNLbanXg7U1yr9qbmqpXazGB?=
 =?us-ascii?Q?DFlt1ftkyDTTvzz8aEW/KMp8ydmg/2E/1/YcEPNss4agTvAUQX42//BBNQ39?=
 =?us-ascii?Q?dzM7Dhw6etSefrboo6xaFxy3U8Hm/CHZGzvX6n+Zk2n9BLBUSWNPm4Hi+WY2?=
 =?us-ascii?Q?JJgOxZiFvlwqsTJzseKVs3cz0B1aJh8/0QbMFHYTqDZCP/9Mw3r1R2TIuHBZ?=
 =?us-ascii?Q?AIvkk9ThT27Mrb50ePtM30HISjAdQWKJh5XgDdkPZVt7NjqFek00+46O8UeG?=
 =?us-ascii?Q?RgR2xYaOnjAFFDoyWcwlj4gtXjgsWunQAN1HR2GoWvoIXFT0L58dh7e6qxna?=
 =?us-ascii?Q?jMMzXO9tXXyO/vdJQMYO8/qnevOFB0zdBUZzsAQmHc2v60rP1xznggNti+hq?=
 =?us-ascii?Q?DMaeGqYQSIe9Kx7cF84Swz0EggyzwGr5oG2Bs3FsebxY5En9AklJzewZGBA3?=
 =?us-ascii?Q?cvzMhvxpeMPySfAvPA/h0K88qWb6QQBw/gfXmXodTvg/69W8GY4cfMTvvsOB?=
 =?us-ascii?Q?SKhhKAvj0xCv7xjCHa2oBNzyQyEJcd3QCRi/r6g5Fp8+yDwtone4ma5so5Bq?=
 =?us-ascii?Q?J7OH33BKhw1yNkUL4nDpeF6x+O+MMMG5TVh7LrFaxkx737HhgN2f8uIVMJ2z?=
 =?us-ascii?Q?4vG6uQF8aEFXmSCQ8X+JSqwL0KTunN6ccQmHxwR6EVbyReW+hAhXtQXrOrLL?=
 =?us-ascii?Q?a1b9JdJVfT13/uKNbm4JiISY0RLH7+yjxaL9230sfwy3fm7z5rjMBWna+EzI?=
 =?us-ascii?Q?7jC3s+McWDgmrIEmZhghHabvtXjtWg+818AM7TP724XxC6saHnqVD5KRdib7?=
 =?us-ascii?Q?oCaRnue6wkAZG020t6Pu6/9ghN+FcmtSAPH5WmsJ4ZZGOjBKjhMG3eLsV/sm?=
 =?us-ascii?Q?gPveRLZX/+FbUKBqdj2JVejtixquAWqKTPsIOReig+12nwSZ2AJ2ooD+ehM3?=
 =?us-ascii?Q?6u0LABvVGQDZUe7tCit2QrCR1017tC79bYbiUqCbszU32fh/PGOhk1eBkukv?=
 =?us-ascii?Q?samrrkli6uI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2rHG/Pv7blcdoawDYfiGInclL3+BllQxm/vq7oXIFnpkyWT/e7vGzWnjelPQ?=
 =?us-ascii?Q?+8PJBdfl2lxa2NIS556Edxy8x0C6FjQh4jFVqXVfBfYVK/UNHVttoWsnEazN?=
 =?us-ascii?Q?Nrk/9QQxtFLxdpI6zsFKhgXdmMSmKSQU2bkZhZ4HUskv+en5YTvFeRD0Pm+Z?=
 =?us-ascii?Q?CSF5qgpz6ZwpyeKxQ+g2pa3fSJSiqvfYqkGNmFU4t9WwpH0TgXZdKycJ2QPe?=
 =?us-ascii?Q?7yLwfQ6WaTxpcFULakUlD/suW0EeJr2QL4zcDAfuEjMNTinQOetj2QXJrLNN?=
 =?us-ascii?Q?YGiJLkwv+TZHMDGp40mNRpWGy3kXfUhY/cEc+unjDn7BoTOimrs7uMWewwq2?=
 =?us-ascii?Q?4wARCORNIJJFbGdad8I6jXQI14YaYE1Yr0tDoJH6XGyksCOY3daAchgYM72P?=
 =?us-ascii?Q?zLbVJX+Tgwi5RMg7aGsfg8Hm9LOB0vnxMVktsnrw037o4UNjesa5Pn4kefcX?=
 =?us-ascii?Q?DCBLLM9h0w2C7hfpOvgtO3mHUX1e38tv6ypearT+qXPpftuDhqrC65hfg1kb?=
 =?us-ascii?Q?whLoGzZHN2ElCdCrLPjiqJxU88W/GWJMhhb5XNv78pdwvuX/C6fH0YKk+SrY?=
 =?us-ascii?Q?fFosfNWHY8NOUz69WfOCDDtA5gK6/iudEokUHHjn1jg36ZpIlxwCLp0O3hwt?=
 =?us-ascii?Q?4ZFBwXD1JeFJc9KTLzD4AGqEjha2Abgq8SzB2mJLVqHLaan0ueRnMnri4q4D?=
 =?us-ascii?Q?SbUMKUn0b1cBgBGwEKzXe3IunDxd+D8ovUrMv2UQvX23CtdbqZsXiq5Zf/qe?=
 =?us-ascii?Q?KhwhjYVhgtYJm5tQddYuRO51glxRRzY/qa0eWsbFDROXW1cDZ124u84MBgWO?=
 =?us-ascii?Q?zVXapzQqMNZgxBHGIgBgKHBYBvykCX8CcYd7p9MY1pJ8skX8RRiAjanauord?=
 =?us-ascii?Q?uae58mv4Ec59xGZG5hjOSVrYSkn9bEo8Ti051RP3MBUm3VGUpDEDPmuZ6g5i?=
 =?us-ascii?Q?37QNdrtH/HzbokG6uDQEQSo8zlR05P4ug8UjVzGm/tYGjU37jpSWp8O8Ft/7?=
 =?us-ascii?Q?fF/FidnZMGwKoigfXXCaYDRl0Xyk414aYXj7+q8+PUHpeSYNbL3dWPHU25Uh?=
 =?us-ascii?Q?qwzXZIcK/F8EVZ9MV9YqPyFXCR4hpyHBUgIwPCyLwuzqCx3eInxhUm2PFTZY?=
 =?us-ascii?Q?2t55gF14ti609K5ZYdaz4Ydjse+qGUUcQRP/ZGkamP856wLY+I4HIb4NE26B?=
 =?us-ascii?Q?xKFsn5eLnqoWkBW8eTpesFkqN67RxtpOYWvXHbuq4/W4bjy7BhxuhrHY1DYF?=
 =?us-ascii?Q?LMNYq8y4FsgPiwNZr887lGkHR0b9b3SOvnKzHULKmglWy0FSGJwS46NMf/0B?=
 =?us-ascii?Q?IR0p5TAWHUgA8oIzzitXBLT6Y+r/NA8h8MCzxx9RSM2mwBr5kO5MdoDqOAqU?=
 =?us-ascii?Q?xjr47JTghgeD4NBSh6ejA/dLArHJax5B1SwmyvebeIzMEZIhuyCYdkVUqHRs?=
 =?us-ascii?Q?kqpRXLaThWJXG2pFHcDSCn2UFgqLWONgG9fyXhJCTubHUOjzMYCXM+08Vxh1?=
 =?us-ascii?Q?8JuG5O+dE89+00UuI6NG8ZnDdH4GKhAcTuI20kb/3RQvmcZaeZ6001tTgO4N?=
 =?us-ascii?Q?fu8kQam5BlTPsnZqIj3DdlzXZ41f0MnizwjQr6nbSef6DdSG9F7WMWVtDBCW?=
 =?us-ascii?Q?BA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZKM+0t7SJkN33AFlPazllPWwe4N0SUBtQwJrkmfgnDzlqH33NW9lbqR2a1+VU0CuSSXCtiFQEHSm8LwcSEG7dUUGn3ih1i12orJsz8C9STTbBIMJu1I5cCPKpwwerECYAczfIxSm+JxHwvAvuRKXJJm9kKpbQSdsorgt7Ig+D1XDEoLLMULGsIhb8Z2NQCKZPawUpFRfj0HnwZLFFfQT2+0ItDbsGbo2Z4e/U61bpwFD95NPj3RbL2x+bVBW9Z6RHpPxT3kgy1SlCCfFho1N/vtUsxjI6WY3gPZnrivmviLav41ZuEmV9+VkiZw6vCB+ctOlruZ93eNRQTIPj5b3IP803zdPDLqjqQPqWSjyt7EglAoJkWMLAo+uu4eRYx5eJM2WN4ZPQ0nWXG+WHB+apvSdTxqwsydkMTRnxoRnzuQix3hkPqComEFx1H9N2Nh5oqxehEgA9zLRQObpP4rQIFZ1wxKmU3bEFcPJrMMrHf0ovLYEMW4UTv2jUxTFEcX7JPXCdH0pfWV3bUn3M2wJzEWCiqgkNlik3qnsDgUdTBge2yFrKUnJtVjGPdf7oV/0wFlgftOPLAJRc82iDrjtkRU9BIAgOAPUctXRthyvnQA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4d11626-9ff9-4828-816c-08dde9f7f32b
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 08:08:50.4465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o0ERLBidQCVNs/EeCQevuRr307Fs7F3feJnVDQKoXhItSlw90xhHPKyidG58Itm7YiPEYNHbc+NJnwBlV2BaMA66KZ/Ty3QRj+0xN+p7zbY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF6ABE13187
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-02_02,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509020081
X-Proofpoint-ORIG-GUID: 6XKz3F9jXQKGpDaEYCmH6LmzLsRXaNg0
X-Authority-Analysis: v=2.4 cv=YKifyQGx c=1 sm=1 tr=0 ts=68b6a61b cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=M8a9pf4_m8jl-BS7tPkA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMiBTYWx0ZWRfXxbJnkYuJeinl
 hRDUyK3oWlACv+VxT2YsWFwFtco/zmQ8YZJZA2ClpV4xDs/CP2gyGpG22ecWdSdNYpRzB4ejj2G
 0FOV+lcVzx7++BN4kuhgGbISETdRNcxT5cNMjeVxpQH15vTCwmio7yLnNDyZ5WdYEI+tgriZuQO
 t26Ld/fBOZydhNoq1jTvqpHaIcjjZj9SLw1UJtZzjI742ertb4/xfgJtZJoH4KsRP96HW1xsI1h
 7XgT83uzrAPHK++HN8hOtSQZ1HqLrH1fNwycXjKEvFqhS8BwOJKx3MJHZX3bO09453BPCcxLuWt
 gmYJrAUQlfk8kIVQ1QD/XJBNhBqLw9DTAWIQVeQEqwSZRMxO2hh1O8JA1FbCjolboTLGKMgLVum
 qaeMAIe2
X-Proofpoint-GUID: 6XKz3F9jXQKGpDaEYCmH6LmzLsRXaNg0
X-Rspamd-Queue-Id: 90D0C1C000B
X-Rspam-User: 
X-Stat-Signature: xb5nx6xwrepw756tf11ai3irzedqfh73
X-Rspamd-Server: rspam09
X-HE-Tag: 1756800551-290687
X-HE-Meta: U2FsdGVkX1/KTMVs3/mhmVM8efnbXCbjhHVd8b3hxE9OG5QqHVcL/SjZoQtktA7j0nluCAoSlOaiHB+r+s6X3WeToLSipQ1b5qFoGpHFfR9Zcvgwir5JfpVNE21dhPlixAbmiAbasEFKGwI9B/BARfynyTSzQ8P3A80YXPwwOmzmJ5haaEXgoFAeT8OWHZ6tgFiguws+fSCUfw4vGpZdED9+qFBs2ImyLPQZx/2VPGyRJMF9H7stWg/YSEOOywMk3VBFWV9LFUyQqEiga4mOx/pS+9hlnkUMq3HYnUrfxINsAYDfbPLIJQVx8pcZvWYnEz31080gzg3Lh8YtN47s+9nkW28ydP85ma8zCaZq3kIdEttEWRS/tXgci9+mAf+9Wk5llrBMlHDg82GSZ1mKQpveUcoF47UQLN1eiAORCO+XOa6u0CR6cslr2SvE5+ato4V+T75vZYQLCmWJILRiXY6UIrO6P3KDszEVR7cHou+5FkWGD1Zo22Z1sQa3clhah0lr+SWI4R/8JK4C2gbtA37GNk/ZlexH2g6upDRNzIOyjlUZt/iLT50cdcQ9+Agg6rVM45RwnhIbND3VRVzhx04+nveWl/NzQZzunJHM/B4/YJgfuqs5y/tHyeMi4re+yBl7TFBNlExgYN+ZAf9qvZu2pm5Xi2PynD4kUTCLMhtXdP+1+uadLOnhFrK8TbGeX+GBkwMlvv94ZXTfOCkNIQYWVfnSHLih286zwfubMJpm+SMUEB9OjpztfOZia0OFg+EYvmJedKPgjM9c/xZfKvOvhJtEUgkSWI7ZlqBf8g12F3FQ7VvSUG+6hpGusO2wQSCGROZ4z4KY35UrzFeNcllOyHTa/tpIjTqBssup8g40gqsa+BWXpF+t1GvT2Wr3ivfC/To0vMT9jJ1japbYsOdlBIwVX6JCKgultdbtjljfgNeqDY4piKlq9hyajEw1JRz6E+MvfqXxvcn1URW
 beJKI4kn
 hC3IBwVExZYWdM6YLOjaTVY08t/fUKYUqXwYx1HxKS8C21/D/OllynA0RKXgprl/iDhCZfzcrpPmULLd283bk2Xdw48sPKH0Vm0OFnRlN35lT2gdd4CkHcG+pfChiRSYb0nT00rS+QvfUmsR64icMgQi2xkOm8svdgjjNZsdiJh/UTD7NN4181oYVWNi+PLUm0emEMLpFMZyRt6YxALAjZaY2x/kedkO0wMGEdVX6ZkH7X5Xh/tjgYKfJEJEfY+zSKv05nA8/Gux5eaY3GGR91LQUPQi11r+nREIpxEihU3QZdGuVe/p5W1M0QzyeyO/uSWCK3Ov9FjuwTnBcsvfRSORdWAnjfu/vcXIN+3aWfarSLUjt8oup2zu2RJXsAuRiXtsp/iOlF6HfsPK8qfq27YJEfv8aZpNcavDm9JKRsQESb7+c6Kh2m9pZrwJ1UKTmB2RL36lXinD08JB5uIGUHuQmhZqX3pEp2cPSEdEqoRjUEBGGIIF+zz0Wg6OCQNaV18YOE6XQcU2pzyz4fYPL8EzSVTBrD/C203QSNdK7aDK2OFh1iL3/F5/Xdz/0F6gRUZG55D5TCM2gJf8tOAo1XihEEHk711IioAok3TRBu5O1BEoNmebzeGWbW55lp5PcU9p8RK3k2BzoTCCtXVGBneYTEafmKWkEzbmVC/P619M4dTM9xaBeff/4aDTSZpWE/jKriCHNNZjTtqu+oAukzNUXNQZWFswnwMNjB+6X/QSKa+tr8ZgDk75/Eg==
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

Define clear_user_pages() while at it.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/x86/include/asm/page_64.h | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
index 17b6ae89e211..289b31a4c910 100644
--- a/arch/x86/include/asm/page_64.h
+++ b/arch/x86/include/asm/page_64.h
@@ -43,8 +43,11 @@ extern unsigned long __phys_addr_symbol(unsigned long);
 void memzero_page_aligned_unrolled(void *addr, u64 len);
 
 /**
- * clear_page() - clear a page using a kernel virtual address.
- * @page: address of kernel page
+ * clear_page() - clear a page range using a kernel virtual address.
+ * @addr: start address
+ * @npages: number of pages
+ *
+ * Assumes that (@addr, +@npages) references a kernel region.
  *
  * Switch between three implementations of page clearing based on CPU
  * capabilities:
@@ -65,21 +68,35 @@ void memzero_page_aligned_unrolled(void *addr, u64 len);
  *
  * Does absolutely no exception handling.
  */
-static inline void clear_page(void *page)
+static inline void clear_pages(void *addr, unsigned int npages)
 {
-	u64 len = PAGE_SIZE;
+	u64 len = npages * PAGE_SIZE;
 	/*
-	 * Clean up KMSAN metadata for the page being cleared. The assembly call
-	 * below clobbers @page, so we perform unpoisoning before it.
+	 * Clean up KMSAN metadata for the pages being cleared. The assembly call
+	 * below clobbers @addr, so we perform unpoisoning before it.
 	 */
-	kmsan_unpoison_memory(page, len);
+	kmsan_unpoison_memory(addr, len);
 	asm volatile(ALTERNATIVE_2("call memzero_page_aligned_unrolled",
 				   "shrq $3, %%rcx; rep stosq", X86_FEATURE_REP_GOOD,
 				   "rep stosb", X86_FEATURE_ERMS)
-			: "+c" (len), "+D" (page), ASM_CALL_CONSTRAINT
+			: "+c" (len), "+D" (addr), ASM_CALL_CONSTRAINT
 			: "a" (0)
 			: "cc", "memory");
 }
+#define clear_pages clear_pages
+
+struct page;
+static inline void clear_user_pages(void *page, unsigned long vaddr,
+				    struct page *pg, unsigned int npages)
+{
+	clear_pages(page, npages);
+}
+#define clear_user_pages clear_user_pages
+
+static inline void clear_page(void *addr)
+{
+	clear_pages(addr, 1);
+}
 
 void copy_page(void *to, void *from);
 KCFI_REFERENCE(copy_page);
-- 
2.31.1


