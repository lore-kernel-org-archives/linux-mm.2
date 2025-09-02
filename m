Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5111CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 08:14:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A7D78E0013; Tue,  2 Sep 2025 04:14:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 806EA6B0023; Tue,  2 Sep 2025 04:14:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54A838E0013; Tue,  2 Sep 2025 04:14:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3DC386B0022
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:14:37 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9BF1E13B72F
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:08:50 +0000 (UTC)
X-FDA: 83843584020.02.99B2570
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id 53CFB180006
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:08:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FWqNseY7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=bZuHarJX;
	spf=pass (imf16.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756800527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=azTceIqgjwj4ZcKUMaKoPrBAjhuvh7GE5bYwg0XiO/Q=;
	b=cosusfHiZQfc0Mgptj31e0L/o1dILgBTXnVqbteqJcaS8ce2H72I2lOXTqe4RP/+amP4GE
	/KrnMFkfR+wnX6Kxy3FaRluzV4SgNk1wfVDAyzQMmF3jWofUSxf6LGWFUr0m1dt69rbaJD
	rhOCGsAqKVLC0fo+AOAOGJS2Vqi72mw=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FWqNseY7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=bZuHarJX;
	spf=pass (imf16.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756800527; a=rsa-sha256;
	cv=pass;
	b=Wgpf1El2r5xHLuycmzrmsqR2172P5OqSJjcXzpUG6YapYEKHrfNvGEu96xx2AVlUCeOl5j
	H6xczPLqaUepP8zXpcGKhXyTsA7Jag5+mxzD3tf7pCkm5suk5wkZmTyYPXhlnKt/NIv8YL
	2+jla13cZx/mEO3tMHJfYHekE375Ouk=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5826ftLv026897;
	Tue, 2 Sep 2025 08:08:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=azTceIqgjwj4ZcKUMaKoPrBAjhuvh7GE5bYwg0XiO/Q=; b=
	FWqNseY7y6+n7NszmSQCMQEGoEHlh+eiryg8MbZlOpSa/NTzuFskU73+UTrFMV4F
	nrW1AXGNCkp+A06aUzr6PWN/54zcpb3vFIFSQbxSklhbhkiVBdNxBrIvF26Qdv3W
	t1zm2uU23NayyRVgAgHInC/kHasXqzg1QQWsarr9g83Q/ooWLkJErwJMGAqnHGDG
	Jc1tlv7Tqdo32NzDU6TMArycljzMtTHRtb3t86oSqmn77v6WCejpypZypQ0VwcZ0
	CTJwqmC79SL2dNZi8z5+hObRQdIj347YaGBbXbx66SpmMPaGHP5eVUCvBWxr1znI
	jIET85ZUcqPtMDfhmZJAbg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ushguf8c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Sep 2025 08:08:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 582607kw011781;
	Tue, 2 Sep 2025 08:08:29 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2040.outbound.protection.outlook.com [40.107.94.40])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqreukhn-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Sep 2025 08:08:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MVWPLt7a3tajMHRexfLl2mqDcw8dtybxe1sUtnSdOcmzoYcnzpMfHVil1Coj/b5xYAcLm/tXJ/Gzs5JmidPIC7wec4tBsdranILxbuTjQqXkaWghshGM+H0fFJ9LtBxQDXSl6O+jiXAGpLPjIOP24OIwLd3AruRNKH8wVDvx10xv8kAQRGcqufusTYAWgHJ7caP/fZTaw4oZC+o02EbNmCEF8J8BTwTSdnK+iEZMGN3+4mSnHUEtn28PEhaSoqwcJ/bTI9JVU2Cp6173pkwKos0kxsKahsZccDSrb2lnzc2wOYvLIdktr9CN3GRBYeIGGxJCrdT7PqwdeUmbYlw6sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=azTceIqgjwj4ZcKUMaKoPrBAjhuvh7GE5bYwg0XiO/Q=;
 b=VZHGdNw79cFpW9FGwIYvPves2rFUlhTnoUGd+Aq1QgvhXXKIg18Se4vrixxQYgV08YraYpA/aqr56Bzex8UaBRXgoOuDAoTusU0uZgoxCcudcPG+TCnjl+IkmzEjPq47kY6QqIreB0LgX7KkVmH/wdXF0nMm7JYkO4oRfGLxxik9GYBaPGuudRVHM29J98Y5ZQNOL65EihthrB3/mhCiSIwNsCjVZUQ+UYu4weeFExPB7NIlFwG8c6vZoHEDHUPDR1e1Y3FM/iqzglbf2GAqmjRlvn3Y0HY1b6lkDCFJB6W4kRrkeJLEcbt6h5YlvfV3Z3rinA7hNcLc/3kpxG6hrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=azTceIqgjwj4ZcKUMaKoPrBAjhuvh7GE5bYwg0XiO/Q=;
 b=bZuHarJXH2bw4M0VOtEpPt4MmiC5otY9nvEymiCj6f7RAOUt/9mZ6UsS6S3TMIcs3MHeIrVgcGihVpuOxpXGNK3cFiLXES6WUrL+X1jJYx1mWNOox6EfMIfmg84mihHzn563EwDCJmGwGAR+tIDSDsBHXbLKUd/a9wSo7junaS8=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by BLAPR10MB5139.namprd10.prod.outlook.com (2603:10b6:208:307::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.16; Tue, 2 Sep
 2025 08:08:27 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9052.013; Tue, 2 Sep 2025
 08:08:27 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        acme@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
        willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v6 04/15] perf bench mem: Pull out init/fini logic
Date: Tue,  2 Sep 2025 01:08:05 -0700
Message-Id: <20250902080816.3715913-5-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250902080816.3715913-1-ankur.a.arora@oracle.com>
References: <20250902080816.3715913-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0203.namprd04.prod.outlook.com
 (2603:10b6:303:86::28) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|BLAPR10MB5139:EE_
X-MS-Office365-Filtering-Correlation-Id: fa6c2bb3-01f2-44a7-e001-08dde9f7e54e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cfCT1vY5msMkUTTqJ/IEroqJ5ykfT8Kh1o2XOK5YPT2nqxQp9SfrstYWL+QL?=
 =?us-ascii?Q?tBT1nfpNoKw6WqrtSuK9swWjUd706rA0+go1yJaQVCIBH5p4CMsUJK4Yqynq?=
 =?us-ascii?Q?fiPsgHgvl/oJOz4gd6NC0o9Xsimsj3HxOr9ll9Kb09yaPAFCC0lxX0mzL8QU?=
 =?us-ascii?Q?wuqQwQUZj2AhYpH80VPqwB2bKOdKEXiUhPmccgW5JuVIvwiZCMUOihNxh/C3?=
 =?us-ascii?Q?aQv1v82G3mtkn262OEp7vPo/0Dg00MFr0fln/yfTp96zMhhzc7WA/WfqafRv?=
 =?us-ascii?Q?rA9kKlK1YlZutKlfyGOvMozn4vEpAOJo5x5anoL//SC07/kjIBaDaY76eYO1?=
 =?us-ascii?Q?BJTGnit4Vly/EImN6cRkNFeRnYbKNDjqYrLdfCptY9rbbX3/BzrewIfKYJ1S?=
 =?us-ascii?Q?wlfqnLolRjeAJeXKo9CsULxn7zMw2LaZtlCOoFEAfnht65+bo10/Zqpqom4i?=
 =?us-ascii?Q?n39YaA81XPVg5HGd4rb29BX12DdsCqdqtQGo6xsGuMTSdcXDLkApBCspGWVS?=
 =?us-ascii?Q?wQRF4GeHVbrqdB4SLVZNLz6eUtpOrt1FltmiafnsTbzvVOcs7vdQVEkVJYFv?=
 =?us-ascii?Q?T2k5rgTj501FUBHe4VGseRhEgLh+17Dz+nRAFLiLIuQTOdAnaJbgFqMWGc5x?=
 =?us-ascii?Q?43DklKPsJu9rMIr1teA2uJ8GoLjK0trsTnOpOwwFrHWN0G1+ANmjP6Rf3xCc?=
 =?us-ascii?Q?JmhyFGq2Y/j1iEz9B1S57wB0YexZOSWGfaOq/85GtTgTkjJ+Ss76rPPDRDMj?=
 =?us-ascii?Q?1uK7O6srF6Y6CNoZxW1Rd/qTKlhuBua+ySECjM7i43gDMgEGmOXw17zu6ErV?=
 =?us-ascii?Q?I1P0cDfnCpdAIQx+8iUq3PUX2AGQmjWvw2Bi0qnu4AS2nkh2T/iThUr6ZaQM?=
 =?us-ascii?Q?PJwPhKIS9sMcT0s4vHvJsUtW4gojBHNf3EbhYdgN3qItzViU7XKp0q7toOhD?=
 =?us-ascii?Q?NJ4vGEmifUBrs0anpaK1CUcJl0tfpqz1KQt4B0mwKVaQqNyirkIEdZfNV8CG?=
 =?us-ascii?Q?pV41J3ZAfxFgFpC2lI0NG7jgyV14Y/NZ2Z1zI5cLvORa4gZb9wbrKbr0wckC?=
 =?us-ascii?Q?3Z3+olgHGeB7JE92pB45zzd0JlF8Ywxlm0F0ekakux7cG2LFA35TkcvoMTID?=
 =?us-ascii?Q?Tqc8mY1EIytewAxHkjxK+DjSg3JorGuEUq8Uz6YC+baGJIYiwVHEevCXBP06?=
 =?us-ascii?Q?N0Yt/1SI1juwpuFrs14G0qEm/QiOgNPs+kebv+2lUI7n/UBDOD2O61RikpGD?=
 =?us-ascii?Q?jK1m0YMgapFKPjezYSuEet0zikNaGQUKCfGBPuJrC5YS59KpsWqSdt8nOOuT?=
 =?us-ascii?Q?4ZKlEkONl1NAVL//VnYUyD1agRqUEVB08uT6UhAWrETd70QXSd5Ro2QwiN+0?=
 =?us-ascii?Q?txJiD4gUxkqQWq2WDJBqK0DOsrkkdrnBNvAjBQCIg57iY444j/veXRHM2N0k?=
 =?us-ascii?Q?BhrqnhjNtxo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aU3F5BU8+92VDGRRw+rb57EbUQqW+KEtGlBWAmCBb2QDa6Yj+FbuB+FPbwlf?=
 =?us-ascii?Q?m92ZqayuriixpRz9RRh7ehrUkTgkyGewP7FZ9m796B71ZMSkXG0Sc/43IFFV?=
 =?us-ascii?Q?Kc5KL46+O8br/ZvaxFMzlywRh6sMFFIosDiWUpsNQk1On0nRb/H7pO5+HRrz?=
 =?us-ascii?Q?71v8Jpj5fj9hLNrAIE0cWr4reAhKKGQA0hRNu/o5qDntOaptHmMt310+EGMw?=
 =?us-ascii?Q?8TKACAivbmoeJyFf+CKJ8Da1/gLhjMjpE/tC+iH9zEyiAgSPx85rTWTbtASH?=
 =?us-ascii?Q?h38zn7PqP1USfSMXleH/lUboxQ1lUOMX9kgtookNiPStkWECkXtXrWdGCzoN?=
 =?us-ascii?Q?BKenRKj2OZ3C3Ns4whva1RGhNjyIVaRyj+DIc5CTUZFFZlzj0YBWFC9bCv+R?=
 =?us-ascii?Q?p41bZ9z7RRo5+0fZEkv70RqOjQ4+Z2iHNDkFQAaSD3OWHQPP1Vcgh1ypFjDV?=
 =?us-ascii?Q?qgC29IKlApmfbFotlPz9e0JPVZ4wrTLplVup4eCPpi7RKJOuVpq1N0prFSuz?=
 =?us-ascii?Q?P2c92WjPvZMBaZg0fOCkCaNJFp9sdYYgcMO0crXlgh2fJk69bWcYzeSsMhQO?=
 =?us-ascii?Q?NDsAZV5ozhPvj0dkFwHhAxg/LXIHarPj8Vd3Lc418rLeHHgml2SP7lHrkUIc?=
 =?us-ascii?Q?PjOMLEoOr4MdlGFNvTYrGfFfahh8y5LtTHOjxKJSoiKw0pFrIa5uJf8A3p6l?=
 =?us-ascii?Q?1RVC9adbWlcBfh169I2BqKDSM+/AtwFRewo9q7PZECQN5z6VU+1EPOfD4+WM?=
 =?us-ascii?Q?pkmoD8LM7r0h2Y+W5+HHuiQQTWl+9k3yN+waRzV1vgiACoK8Pul6VRrnrh/m?=
 =?us-ascii?Q?owZZ/1Jd7eUGGXMUURGj+6TmPSzfZzqOjqvtXrnXVZ+ASl3UU30ZT+PHRA1l?=
 =?us-ascii?Q?8PPXMR6WdG33a+66rN0yvfNF3/sDLAMNA5dpjEfvWETRGdLOnhNsjbI/tiHu?=
 =?us-ascii?Q?DXJ2xmnT+Agx4FdOx1Rq4slxecw869BfI9CxFKKwte5ep3lUjWVpq4N2Jh2x?=
 =?us-ascii?Q?kqaSDl6+PfdkHm9rWFR78xuI1LcunpmK4hyBCxTVx4uFElCw6XhnbEIibhvJ?=
 =?us-ascii?Q?Ecv0QAQLI5O7QSw/QJpalIKzuBobbrktRKqRz/UU/rhUbXJp8kRLTi3JDDYQ?=
 =?us-ascii?Q?JC1BcX+3Si5WDjl+xsu3KOkcNJYGg0rqdhKKPfIXOgL47yDK1C3RvLC7jzZJ?=
 =?us-ascii?Q?tsJRxVkAWW3JTS+BlNlCZ8boLiOaP0En7ybKOxZeiQhlWgcto091rKO8/kCY?=
 =?us-ascii?Q?Le3DUIkzErjPUobbOqMzvIA0wVtEtEDXYL6nAtgFCupMw16PpT2ySQataAaz?=
 =?us-ascii?Q?x75r1fsGiLyyaAPbOOuFECQa4oiUF6FRVLHwvK4jl2dGjYKMWZ9iDVeMDUNc?=
 =?us-ascii?Q?YXaxSkgv5bMaNshiUvtj9tbO2w4TVOXLI8azUCSXhyGRfh3FmhOcoLDNn4RW?=
 =?us-ascii?Q?btnApJJi0rf6nDI2X5VqzhFDLwaw0UyJ0iGH2HyhPUHtRo8muf6C8NN/7acF?=
 =?us-ascii?Q?TjA4tnGgG/nBFdbghb+VkgD3a+mLMAiJR6Djz7VymvqYyRg36xsVJD8NN7Ds?=
 =?us-ascii?Q?HlNdi07gj9uhFjxEvGyufmxnhrZadKdg6pt1PFBCImUG2WoKBtMjq0glTFhc?=
 =?us-ascii?Q?gA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hcDtfrry3GfRdMgHPA0FaTGajkhlLuiVszpK1HTStrgFG3oMAUHWxYFZIhaL9MWdXOE1nOX2ym44GfeNez8MavpWtEml1yLP2ejYGQa0XGL/tRU9aXfvu1sI1Tmsz7fv95CN+YhAWgltQKvwe3OJCu17gSTXfPko5FcoeAuLIZV9LIRhH90yjg3zjy2QoOKISQztDcqvdxaVvlK9rbdym7a7oos2L7hcU6LNj8zspJWf3o8TvR7BUDsByDRVtpQ9r2vtCerZeNeSdTeE+Bldqzw8w6OM0FyGDD/Xcc/yJsSNC7/wlCcyQf7y5ZIQFxNoIjFMzdlKtab+LfBl9YwaEA4e6Sn1mWMY6ky7gzuGf1ym9Hjl3/6crSMwNYh/+dkU2+xOka78x4WiZjCrDCXROOEIZkoz9h1MTd0t7oSzrWIsJZkZ9FUI2HEg2+FM/0OVYV4Xk5myk1yAw/Bm7w395oh/zfq5L55hKySwlG4vjfaPXgHrzQt/R9R1V50mkdPq0b35AIJ4seiUnXyz0vcAyECImZCzPI68lfwv+Xf/2/BzUuXXP8vRib0iw4gR9HGdQkLgon2cgiCeUIt5qQEj8bWWOl7CVCIyihbSn3wIlOg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa6c2bb3-01f2-44a7-e001-08dde9f7e54e
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 08:08:27.1452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Nu2zHtHkG8qqQxccAUm9W8F/q/T+OxwOPnJgsxlLfHKEFDUHokCraeeNEQh6dOoG2qcri2ZG9+njyxnTZwAz+RxdlRTCs9UriGHcUh5+rQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5139
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-02_02,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509020081
X-Proofpoint-ORIG-GUID: al_V84N1RspK5BuaIzOzWELa5ZcpZtTu
X-Authority-Analysis: v=2.4 cv=YKifyQGx c=1 sm=1 tr=0 ts=68b6a5fe b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=TbKJQeBsitzCtKh9844A:9 cc=ntf
 awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMiBTYWx0ZWRfX9NjrZObz1sxh
 sqpOjpUutnvokgSZ9NHSPz+mWRPGU9JRTJYV6nZdKz5BbNbhzAf5Ok64QOSkS5X/iZrWb5TKfjk
 w4RaqEZ4Byjs/+i+rHeShy60XmXy50XoTDNJ/RLq6WXHLYX3iOaMx0HegEAEqEXspcag2Gvr6hb
 tFAFSZnlsx3Rq+yYeWR7vDeVEsVyAbqpEVqJeEd0C1ri95MAWzaQnBrDuuN3Bn6VAd5AOo4mkad
 Fg/6XAHANUbmO4zIL4CtjoPVdx69jty8OkOd8Zzg7/xW+ZtfYf8dxo3U+FRjCAxzSUae4GEIAm6
 JtpKszuedY8XRF4smiMMK43cbSAyJSeawerDIRav/zXteHE47HbAj+0zsgEymq311iGxENXC3G1
 lorkqvsXGAtFq2orAbFuZKPdI5xuoA==
X-Proofpoint-GUID: al_V84N1RspK5BuaIzOzWELa5ZcpZtTu
X-Rspamd-Queue-Id: 53CFB180006
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: euwm3yfbr6yw87jg8s31t1cjwbzp7c64
X-HE-Tag: 1756800527-893498
X-HE-Meta: U2FsdGVkX1+8jI12I1wE4tmYbXezFZ880CFufA7x8Iu2d+GEWGcgt4MYGyCxruXstZTeplEBbizoNO869WGKtxefLq33N17aDDDGCle8dOGZdps9ei0TNLioFeeWsVLyvUEehV3cEpoab/a2rj0ypyJZSfW4WE7+X/TVEm2PNdV4zoU6BB0bxrVYjCJuGzwcH6oDbUrywVaMBrhcFIWI91iR5gLrjMSsePiuICSBt9pCLu5z7kA8tfHPrhswWl1sPZs3nv4UWRjnkdysWvs2MPLaxOpbMqoRZTzOb8Tm/iPpwpOiPYeH2g5K3zn8lVw3ZcezsO66YSOx2hpVaw7LfmuSm6RwDoJxR2yFEsr4cmr64aPowQ1sLKJ+bqBKI+30uKQiv7JqpAT8HrayvKNQTGzvbwJSDMu1E+dRc6Wx18c38+F5dQqcmszV8gZ2NW+RF0xzx3Ry9Aqwdox3Rf6EI3qqgZP1N0jynQ+RGAFdd+Igc5YjjvCoGFO7YPab9ZZwlvTGZblLBeIlL7smOi6XXSxqmBi8O7FA+J45AlMQiN6DxdTmqujyh9s2OXKB9IfyaGRWWPB/mMcApUdDnQnY2Py/dmZJe4VSIMBehwqwfpPh9DGPhWQIunWpCsIoOHvXeQXaUyTvzp3jMNa/VtAZuKn3RHKKp1QU5S5MIDYv+GeVZu059/zvVygPLWWrVnKT9+JMp94EEXNePjwsLvu6H0DJ9pHwHWGsU3L2LhPZLmRpezsaEFc0W7KlybUV+WawcFPIj4cqwtjZPdkTIIjjt3wjZLSBJjmyiBHXPtZpZ+JxejI5J5Y/myCGXEu7p6gLaPMDh6YCjLIRfaNLnDJnyofD32mm2TN2ybPzOzfs3KDFYjkouihmjHI0Bu7TJboDNS0yu4j+qKRAp6R0XLm+HoqO6o/SHf4Y0WV+L7XcjYSyRK7vk/J+ykXkKTcIEULdhK+U7rjyReEovBVlza0
 odqZTzGm
 vmMm5hrktZUZn9SDWRNQTJnWJtqgLaESksXw+rgfi1o6R8+B/2k+VTdm18F0YfEOCrOQsYjXxy4bZpfKmMRbsvlaQwtmF0uSEL878fIYGbudKyfBLk/bBqRZaV4m5SsAYAdra1HX2UENBMIDNaICoM96yAAp8R+czhICi2iJLY7tio/t4utb3vzBebiZsSR6AHzzsdjHkikBqdvyjXxKSR5tc3v+pfBEFOhxYgJ5UdeGWN/9/ftNKu9+IOVS3rRsJawhMiyD9AFsAxxOwLSzR0p9Fol6rb2y4WkcV6n9+GvKjOpb8y+0j2BysUi51VdTffIUO+4g1UidepGdRjVTAH3yQD3xgLRX5wkcC9fwA+dGWomTWmGIUPdhQMj4FLfvMrmt85i1/xdHtaA6DP2Oi78zTTk/lGgjM4TkAW2UiSUmBus7xSsibAVFxO6AlZWzMJ4Y4g96dR6NLJxKx/CLmLSqzhXpt3xHio5h/l1WAFTwpHh8hnFnihtZu84TCdBCgaGaWl6hUQyZbWB2j9LooKIKl5NcwRR7yjERet/N7u6VlFRX/Yda5Zn2PX2WftdjjNvbtqup/ImXMPoBG9cvTwnaeQumNxrqAbRC/nIQuBoJQz/8VNP9yPQJ2QR/KBKsLqlrgQgor+++mu8tMNPZuvEcnbkgduGSof2VCz3TReNznY049YyqHiOuI0Pp4AVw4bYkCGuOx8IpALjeVTcsnRoTR9HT+XUpjBpGlp9eb+WrydqY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

No functional change.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 tools/perf/bench/mem-functions.c             | 103 +++++++++++++------
 tools/perf/bench/mem-memcpy-arch.h           |   2 +-
 tools/perf/bench/mem-memcpy-x86-64-asm-def.h |   4 +
 tools/perf/bench/mem-memset-arch.h           |   2 +-
 tools/perf/bench/mem-memset-x86-64-asm-def.h |   4 +
 5 files changed, 81 insertions(+), 34 deletions(-)

diff --git a/tools/perf/bench/mem-functions.c b/tools/perf/bench/mem-functions.c
index 4d723774c1b3..60ea20277507 100644
--- a/tools/perf/bench/mem-functions.c
+++ b/tools/perf/bench/mem-functions.c
@@ -62,15 +62,31 @@ struct bench_params {
 	unsigned int	nr_loops;
 };
 
+struct bench_mem_info {
+	const struct function *functions;
+	int (*do_op)(const struct function *r, struct bench_params *p,
+		     void *src, void *dst, union bench_clock *rt);
+	const char *const *usage;
+	bool alloc_src;
+};
+
+typedef bool (*mem_init_t)(struct bench_mem_info *, struct bench_params *,
+			   void **, void **);
+typedef void (*mem_fini_t)(struct bench_mem_info *, struct bench_params *,
+			   void **, void **);
 typedef void *(*memcpy_t)(void *, const void *, size_t);
 typedef void *(*memset_t)(void *, int, size_t);
 
 struct function {
 	const char *name;
 	const char *desc;
-	union {
-		memcpy_t memcpy;
-		memset_t memset;
+	struct {
+		mem_init_t init;
+		mem_fini_t fini;
+		union {
+			memcpy_t memcpy;
+			memset_t memset;
+		};
 	} fn;
 };
 
@@ -138,37 +154,24 @@ static double timeval2double(struct timeval *ts)
 			printf(" %14lf GB/sec\n", x / K / K / K);	\
 	} while (0)
 
-struct bench_mem_info {
-	const struct function *functions;
-	union bench_clock (*do_op)(const struct function *r, struct bench_params *p,
-				   void *src, void *dst);
-	const char *const *usage;
-	bool alloc_src;
-};
-
 static void __bench_mem_function(struct bench_mem_info *info, struct bench_params *p,
 				 int r_idx)
 {
 	const struct function *r = &info->functions[r_idx];
 	double result_bps = 0.0;
 	union bench_clock rt = { 0 };
-	void *src = NULL, *dst = zalloc(p->size);
+	void *src = NULL, *dst = NULL;
 
 	printf("# function '%s' (%s)\n", r->name, r->desc);
 
-	if (dst == NULL)
-		goto out_alloc_failed;
-
-	if (info->alloc_src) {
-		src = zalloc(p->size);
-		if (src == NULL)
-			goto out_alloc_failed;
-	}
+	if (r->fn.init && r->fn.init(info, p, &src, &dst))
+		goto out_init_failed;
 
 	if (bench_format == BENCH_FORMAT_DEFAULT)
 		printf("# Copying %s bytes ...\n\n", size_str);
 
-	rt = info->do_op(r, p, src, dst);
+	if (info->do_op(r, p, src, dst, &rt))
+		goto out_test_failed;
 
 	switch (bench_format) {
 	case BENCH_FORMAT_DEFAULT:
@@ -194,11 +197,11 @@ static void __bench_mem_function(struct bench_mem_info *info, struct bench_param
 		break;
 	}
 
+out_test_failed:
 out_free:
-	free(src);
-	free(dst);
+	if (r->fn.fini) r->fn.fini(info, p, &src, &dst);
 	return;
-out_alloc_failed:
+out_init_failed:
 	printf("# Memory allocation failed - maybe size (%s) is too large?\n", size_str);
 	goto out_free;
 }
@@ -265,8 +268,8 @@ static void memcpy_prefault(memcpy_t fn, size_t size, void *src, void *dst)
 	fn(dst, src, size);
 }
 
-static union bench_clock do_memcpy(const struct function *r, struct bench_params *p,
-				   void *src, void *dst)
+static int do_memcpy(const struct function *r, struct bench_params *p,
+		     void *src, void *dst, union bench_clock *rt)
 {
 	union bench_clock start, end;
 	memcpy_t fn = r->fn.memcpy;
@@ -278,16 +281,47 @@ static union bench_clock do_memcpy(const struct function *r, struct bench_params
 		fn(dst, src, p->size);
 	clock_get(&end);
 
-	return clock_diff(&start, &end);
+	*rt = clock_diff(&start, &end);
+
+	return 0;
+}
+
+static bool mem_alloc(struct bench_mem_info *info, struct bench_params *p,
+		      void **src, void **dst)
+{
+	bool failed;
+
+	*dst = zalloc(p->size);
+	failed = *dst == NULL;
+
+	if (info->alloc_src) {
+		*src = zalloc(p->size);
+		failed = failed || *src == NULL;
+	}
+
+	return failed;
+}
+
+static void mem_free(struct bench_mem_info *info __maybe_unused,
+		     struct bench_params *p __maybe_unused,
+		     void **src, void **dst)
+{
+	free(*dst);
+	free(*src);
+
+	*dst = *src = NULL;
 }
 
 struct function memcpy_functions[] = {
 	{ .name		= "default",
 	  .desc		= "Default memcpy() provided by glibc",
+	  .fn.init	= mem_alloc,
+	  .fn.fini	= mem_free,
 	  .fn.memcpy	= memcpy },
 
 #ifdef HAVE_ARCH_X86_64_SUPPORT
-# define MEMCPY_FN(_fn, _name, _desc) {.name = _name, .desc = _desc, .fn.memcpy = _fn},
+# define MEMCPY_FN(_fn, _init, _fini, _name, _desc)	\
+	{.name = _name, .desc = _desc, .fn.memcpy = _fn, .fn.init = _init, .fn.fini = _fini },
 # include "mem-memcpy-x86-64-asm-def.h"
 # undef MEMCPY_FN
 #endif
@@ -312,8 +346,8 @@ int bench_mem_memcpy(int argc, const char **argv)
 	return bench_mem_common(argc, argv, &info);
 }
 
-static union bench_clock do_memset(const struct function *r, struct bench_params *p,
-				   void *src __maybe_unused, void *dst)
+static int do_memset(const struct function *r, struct bench_params *p,
+		     void *src __maybe_unused, void *dst, union bench_clock *rt)
 {
 	union bench_clock start, end;
 	memset_t fn = r->fn.memset;
@@ -329,7 +363,9 @@ static union bench_clock do_memset(const struct function *r, struct bench_params
 		fn(dst, i, p->size);
 	clock_get(&end);
 
-	return clock_diff(&start, &end);
+	*rt = clock_diff(&start, &end);
+
+	return 0;
 }
 
 static const char * const bench_mem_memset_usage[] = {
@@ -340,10 +376,13 @@ static const char * const bench_mem_memset_usage[] = {
 static const struct function memset_functions[] = {
 	{ .name		= "default",
 	  .desc		= "Default memset() provided by glibc",
+	  .fn.init	= mem_alloc,
+	  .fn.fini	= mem_free,
 	  .fn.memset	= memset },
 
 #ifdef HAVE_ARCH_X86_64_SUPPORT
-# define MEMSET_FN(_fn, _name, _desc) { .name = _name, .desc = _desc, .fn.memset = _fn },
+# define MEMSET_FN(_fn, _init, _fini, _name, _desc) \
+	{.name = _name, .desc = _desc, .fn.memset = _fn, .fn.init = _init, .fn.fini = _fini },
 # include "mem-memset-x86-64-asm-def.h"
 # undef MEMSET_FN
 #endif
diff --git a/tools/perf/bench/mem-memcpy-arch.h b/tools/perf/bench/mem-memcpy-arch.h
index 5bcaec5601a8..852e48cfd8fe 100644
--- a/tools/perf/bench/mem-memcpy-arch.h
+++ b/tools/perf/bench/mem-memcpy-arch.h
@@ -2,7 +2,7 @@
 
 #ifdef HAVE_ARCH_X86_64_SUPPORT
 
-#define MEMCPY_FN(fn, name, desc)		\
+#define MEMCPY_FN(fn, init, fini, name, desc)		\
 	void *fn(void *, const void *, size_t);
 
 #include "mem-memcpy-x86-64-asm-def.h"
diff --git a/tools/perf/bench/mem-memcpy-x86-64-asm-def.h b/tools/perf/bench/mem-memcpy-x86-64-asm-def.h
index 6188e19d3129..f43038f4448b 100644
--- a/tools/perf/bench/mem-memcpy-x86-64-asm-def.h
+++ b/tools/perf/bench/mem-memcpy-x86-64-asm-def.h
@@ -1,9 +1,13 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
 MEMCPY_FN(memcpy_orig,
+	mem_alloc,
+	mem_free,
 	"x86-64-unrolled",
 	"unrolled memcpy() in arch/x86/lib/memcpy_64.S")
 
 MEMCPY_FN(__memcpy,
+	mem_alloc,
+	mem_free,
 	"x86-64-movsq",
 	"movsq-based memcpy() in arch/x86/lib/memcpy_64.S")
diff --git a/tools/perf/bench/mem-memset-arch.h b/tools/perf/bench/mem-memset-arch.h
index 53f45482663f..278c5da12d63 100644
--- a/tools/perf/bench/mem-memset-arch.h
+++ b/tools/perf/bench/mem-memset-arch.h
@@ -2,7 +2,7 @@
 
 #ifdef HAVE_ARCH_X86_64_SUPPORT
 
-#define MEMSET_FN(fn, name, desc)		\
+#define MEMSET_FN(fn, init, fini, name, desc)	\
 	void *fn(void *, int, size_t);
 
 #include "mem-memset-x86-64-asm-def.h"
diff --git a/tools/perf/bench/mem-memset-x86-64-asm-def.h b/tools/perf/bench/mem-memset-x86-64-asm-def.h
index 247c72fdfb9d..80ad1b7ea770 100644
--- a/tools/perf/bench/mem-memset-x86-64-asm-def.h
+++ b/tools/perf/bench/mem-memset-x86-64-asm-def.h
@@ -1,9 +1,13 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
 MEMSET_FN(memset_orig,
+	mem_alloc,
+	mem_free,
 	"x86-64-unrolled",
 	"unrolled memset() in arch/x86/lib/memset_64.S")
 
 MEMSET_FN(__memset,
+	mem_alloc,
+	mem_free,
 	"x86-64-stosq",
 	"movsq-based memset() in arch/x86/lib/memset_64.S")
-- 
2.31.1


