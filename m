Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDEA3CA100C
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 08:14:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2D248E0010; Tue,  2 Sep 2025 04:14:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98F248E000D; Tue,  2 Sep 2025 04:14:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B8408E0010; Tue,  2 Sep 2025 04:14:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 634D18E000D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:14:20 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DA82A140B3E
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:09:01 +0000 (UTC)
X-FDA: 83843584482.28.4C10720
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id 935C180006
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:08:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=C0A9bFCM;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=unpWl2zE;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf30.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756800538; a=rsa-sha256;
	cv=pass;
	b=mPg5V0mULurttPxbv9MSidUr55maVJQcnXTCCiVVz0Oj1nK2pcMz8EUFxyJkLTF4yfmpmV
	UUnI5fXbefcOsp6IYFIq2APBRkaw3+NA4wO1xIIGtGCxfKQwtdNVAvRtrgx1XMCTIq5aGk
	mZy6Z7UPcFOKyjnJgF75SJX2h7f9+lU=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=C0A9bFCM;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=unpWl2zE;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf30.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756800538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xicpOFAr+e2EsHDxSJ04hSkMODZ2i0BTPMfpUbSSRFM=;
	b=kLlbvC7N69JRCieW4pCzCuni4IXnkVWF9TyNrgaxj7sFjjMhspslKk+A9Tnoc2ysDrZpd5
	Yemqzj0pTVFWKsaUr2GMIh99/A84IAC52oCsaw5C4YvnRaTw0UL2+jo8kB+2rrR5HCH4Fx
	rFOO2klUo33rtqHehvHs0lZ/RkvV3GU=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5826gb7I016481;
	Tue, 2 Sep 2025 08:08:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=xicpOFAr+e2EsHDxSJ04hSkMODZ2i0BTPMfpUbSSRFM=; b=
	C0A9bFCMJ1aQkXvK1Y2xi8nI7c/nX/GJrA4+YGROg50XSc78DRV7+QMPB8wJ4zBa
	4E1zOIXcpWGLd93LtVxQBL9q0gVP7J8+LP5NVXalOmkzn6fmwv5N/vLcxsD+xpQj
	7A0HlR5Ft9nvYYOKfnHHoZV5WdgHGux8QMDIE39BfV+DcpM53fKu87OqsU5c/6MX
	+NLa/N0yp6+LXTIatVS2zI56Y7BmSofNOP5egQuA+79voQSsA2pBVNeycQTSPKX3
	KRM5NlTdcAIFQb+O5YK3vg36Wn4u036X80fQEj0I0zB+5iYANjxTFS/s6JJaVICf
	imxkgk+awxeHOal8v8vgQg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48usmnbg79-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Sep 2025 08:08:44 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5826Kl9a024898;
	Tue, 2 Sep 2025 08:08:44 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2077.outbound.protection.outlook.com [40.107.93.77])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48uqr8j6x2-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Sep 2025 08:08:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PyLIO5MYLT/7+2BCvxqi4oGlnI8OI2U6je+dPKlbDt1XWMEh4KjbiMYrw7U+NlNl1DI6eILYPsYKL1wIeaj+vQux9q1hjkddLKVxymMgVWVYyKfVTeWYadxAR3ieNGJr0x78NfvgDMxA28LlJYSrYaxTRpoYDRVlXPwuHJVFq5xKr0cBOoaOIiQCm/AXG39s84WkKS/3yHE3pruOYS6Yhd58r0ylsFiI6L9FzD3PHKjUQFj7QZMh3KfNDItNvnQX7QPzJc6BQ1q1/0OYiJQCaC4YQ4j9dHFrE+tP9/m5T9cyQX4EY3Iwqq8gyYTsjFcufLhaGm1O7M3c3/eWkvNsjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xicpOFAr+e2EsHDxSJ04hSkMODZ2i0BTPMfpUbSSRFM=;
 b=vY3zEbrjxx2UmSEpVNzh26dyAtEn2BpbJqHkZA6RU1JJRx8rj9uOYivmKV5blBnK7E0Ls2LD/XsAqvaG8CkdYgCM1Wkeyg1Djp5HShvGecQCYHFAn64NZ0knHIy/6Gguio3BQLDPqU24KPgjGEgtnL6u6dSNZsEKCQFkuIuZ6sYaEZwsmefHzwm7n/8YEAT9aFGjism88z6eu/LtRbXBtWthqpQCp9qs2BHXiIEjmVpKXgd6V2sHN9fhJ0tx2rPl6HVtmBd17GBz/8LZ/6TK42EaCWPt2Djbb2qGNLTmyU6ALRSPsXXeYg9v+ipd/DuY9DRDirfAx8W+E5+KlT9jKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xicpOFAr+e2EsHDxSJ04hSkMODZ2i0BTPMfpUbSSRFM=;
 b=unpWl2zEd3stUuyCxRo16TdLOdgLN4Sn8hLdKsaV+FG3KsiDRbZqNnPIrJO32pw48WjWmuUKknT3LXs4/KAktAvQThPXqnS5peAnqqJZFPTyAA1MOzysSbIPsy3nGz7L//cxLA916/ntZHtMFvv475KMsITDwuRV+5JqI9e2P7o=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by BLAPR10MB5139.namprd10.prod.outlook.com (2603:10b6:208:307::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.16; Tue, 2 Sep
 2025 08:08:41 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9052.013; Tue, 2 Sep 2025
 08:08:41 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        acme@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
        willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v6 10/15] x86/mm: Simplify clear_page_*
Date: Tue,  2 Sep 2025 01:08:11 -0700
Message-Id: <20250902080816.3715913-11-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250902080816.3715913-1-ankur.a.arora@oracle.com>
References: <20250902080816.3715913-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0373.namprd04.prod.outlook.com
 (2603:10b6:303:81::18) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|BLAPR10MB5139:EE_
X-MS-Office365-Filtering-Correlation-Id: 5840954a-8cb8-47ae-85dc-08dde9f7ee0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hROnxQ3iNOMQTeTRb/UO5vGhSDNBWdENoKUJtbUIDJ4efOEeO28oeC7v60Qn?=
 =?us-ascii?Q?ptcOHrQwZ4jquCvJV/DrIUIYB97k9vUOMdY/+D7PqfyS901DtHLYe653rBwm?=
 =?us-ascii?Q?R9DulFr7Q89XP8Ju4jrOEM6GniwsjkkHBOJ8WbHpuQVgegMq3n6BZnM7ahl8?=
 =?us-ascii?Q?KDLIdxtDN/uQM/pZHrZG62jCX1IAy7fD/ugnlVg4lFw3pSHcgIp6E1Tsn6Ko?=
 =?us-ascii?Q?dy6tmMvVcTn8AHBIhV8sZcWmAdYPMkKGAGa39YiT09QfuEKT/NmC7VT96fQ3?=
 =?us-ascii?Q?CFPMEjzPyLsnit1zHqq1OMHLHYvZmZAcxy65Pj53mYfiUscWujKFdaCtt5MJ?=
 =?us-ascii?Q?HC3ebL2ghHI0QxoNBUsE6dQabhgfl8zW/8zSjxnXUiBtX5m9Y67aFXEe/3+F?=
 =?us-ascii?Q?vgb7td7XZwmjU0rcbzATNNh5kNuQVRTumwkicHwMeBIeQUvU242lFKCKcwBj?=
 =?us-ascii?Q?nbGcf98NGMWOEZ8l4Q6CMQjn9auta9Cy99Ko3DouSccYiGmGXV1P23NPMRRt?=
 =?us-ascii?Q?Mmu3Wj94ZI/3gxqmHR6sxs3rCf+SyyNGwlUzVl5m1rAgZLduCyCjD106+eXS?=
 =?us-ascii?Q?YWc3grrdJx/C64wm5a661UwaUamdyMZdxIvEkV20RcEstxQKoJFX3brETCIH?=
 =?us-ascii?Q?CPRmYF9MFQziFiPCxmoiyiaEMwsy8WaUpoaabPL78RvtDT9wA3jt8oV+YdhX?=
 =?us-ascii?Q?YjuCWqRvwr64WCwI7iq6ujeGHKM89ykV6aJT5eQrhwa5yshdsH2ibtYHeZeV?=
 =?us-ascii?Q?2US3vvf08pFSA3iH+h/bSZJEXFze1hED3bCi4NQQIXJPWaLAGGAYD3mDha3c?=
 =?us-ascii?Q?/Ugv2VSOkVHOEjf2bcA28Cl2m0cOOeId0mrT+JyvcGqtTn889SUO2btxiIkt?=
 =?us-ascii?Q?2p8GgytHyRp6M4Nq868hWXIVEQtucsOtXSqBUZHdSpCexusp563FdZCNYg7b?=
 =?us-ascii?Q?Dvbcfuqsh8Qnq6jl1YAViCNp2x/MZVPmJE3w5k7VOoHMuzTiI97muygQIdTq?=
 =?us-ascii?Q?DpOow9wCxeR+MP+ceYzLTa5TNbxJpPq2fvz87URdH+M2jLV7e6JbWcfcb3oR?=
 =?us-ascii?Q?FJsozJUB30Ugwn8ayZkrST+4nj5HSmoJD7wYm4q/wdWQn88S8rBxDARxdlvA?=
 =?us-ascii?Q?gu3BY2nVrvd/cWWWoyNXTa7KLNiNxOBTNEW8RFnPN0SjpqDvYNgmsaA1l1Xh?=
 =?us-ascii?Q?6fwHV6joefzOl9a08hXmMpDPmAD59UjAxzgF4INptqaYmPnhZQeey5dScbdt?=
 =?us-ascii?Q?TKg4F0M2rNmIBrXUHA0zeBW6/yM3MSR3YipNe5eiHmL/FYv43YkHXVQh/LE7?=
 =?us-ascii?Q?yC0jnrZTSzszz/79JYV7MGXN8MFi+/Ojz+aMTx3obKK1A4OVMlsVIh//2+PN?=
 =?us-ascii?Q?lJcAdROBiwS8Omqv53U/FYtsCcO7qczkEVoG1xVDI/vJwqquNQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NYF1CAACvGOx3dmKMui5HwEhXTRr9bc8RoKLbxJJ/SzBT99bErvBebrBVj9I?=
 =?us-ascii?Q?+jOqd2soalrmR4MnkDfrCs5aY46UExkPN+F6CxTiEWYjoXKNxmoaAPABXDqF?=
 =?us-ascii?Q?WOZsLkY/HecMVVVsk3A5fWPKcSo8qG7rxovF9vp9uvv++ro2V3RQYSxLUndG?=
 =?us-ascii?Q?V++f8kJvYko+LJu41ksPUH68xBsvXsc05a42Tl7bXUuYCFz7KTrpGXEAZ05w?=
 =?us-ascii?Q?X16udyUgpbwd5/dlrNohcYq2iobEgGeN5hj/QaGaU5QCP+y/9qFvuaoDS7ZE?=
 =?us-ascii?Q?Vt7dnpRSuqq+m6DWeisMTZiQ1AKEfzBPW/E9e1AJ38RV6evhlG1gacuuq0kU?=
 =?us-ascii?Q?uBDrXzus+6OR4XJCcyKHRjH49ZF40lRRUYq+YQr2Yb36bX3DvZEc+tpLQOiy?=
 =?us-ascii?Q?HM9Y9Px8q2ZY8pYcuo9UuE/mGXPlaLTsmAJbh7+A1sIIWRhz341u21yHo/Nv?=
 =?us-ascii?Q?DluLGjpGRUzINjfQScBwgik91/RMj2jEdIg/QISShiUkg98MISkOh6yF2y5G?=
 =?us-ascii?Q?MJ2foWWmF43r+P6tSEpc4uV1/0YcG/ThsTL+SxFob5YBdZjE3OWoPtztlDCE?=
 =?us-ascii?Q?ypsHBBWizx0lGdFjUO+OeLHPYOBQGIuOSK7gcqBK/gm1Gxs542W64eZBcoGt?=
 =?us-ascii?Q?SwhaGTxJL1UDCfEySJpGW6LAnyQAzMcnOYpqRaEejC1bQe8T4yrAuTeGi8hi?=
 =?us-ascii?Q?QcMVvo7epBx1vVRZioXMoLBTOtdJ1U7hVPQLQeug/g/18Y9zjLLs13HevqUG?=
 =?us-ascii?Q?5c3Dsxu9238hZP4hX71lGVBdkwSD2PCBNsTjW7hpP9HrjjOzCBoT/n2eAHgO?=
 =?us-ascii?Q?FqSBRvmtRLTaZUL1O0BJcPKjpC09Ym7kC0C9KuTAbCduGIe/wK9MRp4/gFeX?=
 =?us-ascii?Q?XdWyvrlwSyGa5wnyGVfHKmteEzU9UhkYQFU4V5Wy5JoKR82U6hrsNi+gXEtQ?=
 =?us-ascii?Q?fgDq/cm0UzHAKlm+DvqBN6Q0ZV7gMcch1ANnFfWL430lXKnvcmKcupxuVSmC?=
 =?us-ascii?Q?PIPBYQryA0rBtVm9kDdROZRAH2jHmuuG+YtrgXTaO4GNqwK12ioWuKvYNcBl?=
 =?us-ascii?Q?rE84p0yajy2MQ6l7h8iOiXMe+Cxm27WbR/jG6aNAS/UjicrEf2JxxVlMi8YV?=
 =?us-ascii?Q?cD0CdMRzoRTuLDfXnu+ykv68+aTFf5rZO6Vpr+HJNPt317cnvFdprXXIwLEW?=
 =?us-ascii?Q?5zpXMQIR21VNyF7Ate5OV9X48B38hJnNyntwuDcvmSgyRlfeQGedmNeuoUiE?=
 =?us-ascii?Q?twYp0yg0gBHC9SeBZYMEiPGfVpH90gdQ9cC0NF8DQmeIk6gmM14d9z6S15on?=
 =?us-ascii?Q?nOEOUQTPByC+qmjKEDy3vBu5dSzETZhiUJ+7uQQAVnWB27PqbGjfaK2yssJm?=
 =?us-ascii?Q?TJqpPkOW2XUe/ZnBzEF3OB0eFrmw5j5LrXZqOVLcClsrJopai5X3uZyfva3j?=
 =?us-ascii?Q?qEHL5Gp40o9HnQT/blgMkUkadLRz3DDvS/y4VMI6K9MZnUSBwi6vzGycLo8v?=
 =?us-ascii?Q?Q/kzEA0E9/Pz9A+dog/nRt1ZSuBMyRZuQ2RzAczy6+lZ4J9dVOp48azEXP42?=
 =?us-ascii?Q?WNDraZf6eo4HP/QsHn0oeMfdM7i8GrDcwRxLAFoBiRKFaD+R9dNbIv4U5tHn?=
 =?us-ascii?Q?Pg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bw6eXLxf2j7QVup1CCrm9V3oMDvQ9Z3//eM/BPTtxtyiZh/rsdxQkMEsFX8JfwzTZj3QjIIVRQN9+luHGDjf3L/scXUEWlj2lJz5S8cUn6z4/KIFYjFYwYUc8fXMpI//9K/qpe/cOOJBL/xhY5Xa9l8V7qh7dzclrXCEfyUo/mrpV6p1pFz1pz6h/MonRAEvPYkU8NHP75MtMizhvfyje0ICuf4aXERpDsWea2Ph0y0yGiUAjoejNNzCdaVb/0ww8MSej5YVEsE6++bYrrbKPZ8C2HtCrXklDTM/ABqmlE4oK0Mz1vFJW5lzjmsiux+gF3EYuhJ75rLqx0F28XTE7Tx3xBU6kYPP787cjlhcr7okCu9MqgSvrNIkyBtCh0QAPXoG+GIPwObeZKR5ewY3PkglD3J+eeVu5GdOSJXpAFQOSUUGbRH3DnfiBiCzZ4emi/7d0pchoU3oaHuQPjEfkuRO6GXT/5bOrYfgpJHaWu3RYQv4cdnwJLKNtxQbvKcw7ixr8EaKz66ms2OJrxG/VJVf/xUzgcySwMr96y6Z8hQNaT8S4W09VUmLmYhZbhSpsCFsJMEeoPuM4CVoicb7JOHeOyoKLH91hSR3vekMYqg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5840954a-8cb8-47ae-85dc-08dde9f7ee0d
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 08:08:41.7441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yjg+RL/z9Djlpk7E6rcUjyxNmmTa+1/5hv2BLsS3dxyFcTQFdcC4L/J2tMMT3xoowghgGAzFSvLP+Vpx8Psig7M3ecIk1tpElLoenXrKjcM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5139
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-02_02,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509020081
X-Proofpoint-GUID: OdKMkfHwlY4OZGUVUyIroH327yQ3gZwQ
X-Proofpoint-ORIG-GUID: OdKMkfHwlY4OZGUVUyIroH327yQ3gZwQ
X-Authority-Analysis: v=2.4 cv=Of2YDgTY c=1 sm=1 tr=0 ts=68b6a60c cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=3VxSRnZmKhVynjaijvUA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMiBTYWx0ZWRfX2pIfkodYUXcg
 HIQR+Tlek4XDnDCycaFgEKaa9fKLskDQQivypXawNbcE//68WweMmt4yGokX1hbZZrmReL0nCyJ
 X0NOTZxXBqmFXiYewEiuC1pfvinOPn+Oss2c4T9dUTmpcaXAYp+lrFrmMc04VMge2gskqL9S2jf
 QFNiEverBGXpxLvLPqOeaG35xgb25NkWFQWckV9TGkzp4/ByfMgbG2SBWbDmJMkr493VXomHV01
 u8YtOVsA2OBmo3uonhGfP17tokjKlD9CGK98vJxmYwcEr0Fb3RH6qYuAewDMpCsLily/mvlYbe9
 eBy13/5H3agqWnWmVzuR3MZF6tWuPGQnOjCalzk2vLjByrmMAdZB95EGEErbPso7IOrd1TJgG97
 M3wrxtVf
X-Rspamd-Queue-Id: 935C180006
X-Stat-Signature: mb1xrd8nzshngn6opjbnz4t9sbzrtemp
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756800538-464102
X-HE-Meta: U2FsdGVkX1+cbWtxZDNciLjD3fntzCnMoxA1BS/Dv1WJDfGHL0oUqIKuBD7JxH6toro2PaES8FjVS2rh3v3SZFOQOxgKILaUc1rLHIpcJl0Nu+gTNj5skJLmjxW6k/NfVQ2GcqsBPYkGpCy0MDv7grK6HIqKpUyaIw+m0pwJlzCAIEAbdSEXPycr864DsrTdeHdxCvXMCarjAVkLIJM/2X9LoTJv65AiSw9+N3J0JAVhdV1BKW2Qc5S9BMar3K+66pGJyVHSTJt7TCq96XAgHHH6Kt82a+J/5n/rlwk4IWu56RLHpOfq1L6dDBbh2Iv8GZ1Un+DN9zGhKcNChZLmP8DopaVhiyuv19ECjqvTHMbdTfcn5tfe3dEhGRsmaowqYA8H6gPNkArEFRA1fLVbuPCjdLBr1AH7l9nZL1bm3TkaaZEKimlO5r2NMmg6a0Ku7M8QlyEbw8YWB2QueIw8Mkfl7yFzJ395NwjbIqvYLhoIT8cbs3Ev6WBBEYP2ufA+rZ5/lo+wlwST9JzQd2gQP/Ga6PI9OVJRf+50nizh2OfeocnivxfnVfmyMg5GsGlFb/O/a5Df2hKQ7nRWg2FoFHo1nlkxgo/swlx92PrSCslTZkbhuk0FFyzuEqV+J953Eh/722/6xZ8ld3ZIA0U8Keei3+kXb7V7O8JxXlZEzeGogIORFfbzQESdeNUGZLEnkYJ3Her2B88mam3qrVms6iWwdJFZtUrAy0Ew3kL37a/55LUPUldg3xMEU6SH7PeMwACE09s13o3AZNyFKdneW2y+UyBtzogHLvKgoBTM/wqjQYDpiv05WhAeWoxSJE+cGnBlXuBPqmkp9xFKbn2T+ObtQOlLJWTQ5f0O4imFJdP5wNCapJzVw94TnFdfTsrOQ02CapqBHlyVQezxyLmFLsY+4rjAF4ZKemNb7KMvWD/kDAEjRCaMIBkGO+16BslW1+7rfQhYiSFkEtH16WL
 08bwkHgJ
 OsmQ5g4eqcmxO1LYdBSbYSmrRSGPdYOSr50uP0+6DAfVQqpZlmQnEiJNlnmkZ1K+Vo3zHlN9TTJo1xvXkdIKvbmLGVFZzbqDYMztuD1TKpGeutjJ3LywsaaJA0Eb5+dbIb4xhEWy8p0Fbqag=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

clear_page_rep() and clear_page_erms() are wrappers around "REP; STOS"
variations. Inlining gets rid of an unnecessary CALL/RET (which isn't
free when using RETHUNK speculative execution mitigations.)
Fixup and rename clear_page_orig() to adapt to the changed calling
convention.

Also add a comment from Dave Hansen detailing various clearing mechanisms
used in clear_page().

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/x86/include/asm/page_32.h |  6 +++++
 arch/x86/include/asm/page_64.h | 42 ++++++++++++++++++++++++++--------
 arch/x86/lib/clear_page_64.S   | 39 +++++++------------------------
 3 files changed, 46 insertions(+), 41 deletions(-)

diff --git a/arch/x86/include/asm/page_32.h b/arch/x86/include/asm/page_32.h
index 0c623706cb7e..19fddb002cc9 100644
--- a/arch/x86/include/asm/page_32.h
+++ b/arch/x86/include/asm/page_32.h
@@ -17,6 +17,12 @@ extern unsigned long __phys_addr(unsigned long);
 
 #include <linux/string.h>
 
+/**
+ * clear_page() - clear a page using a kernel virtual address.
+ * @page: address of kernel page
+ *
+ * Does absolutely no exception handling.
+ */
 static inline void clear_page(void *page)
 {
 	memset(page, 0, PAGE_SIZE);
diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
index 015d23f3e01f..17b6ae89e211 100644
--- a/arch/x86/include/asm/page_64.h
+++ b/arch/x86/include/asm/page_64.h
@@ -40,23 +40,45 @@ extern unsigned long __phys_addr_symbol(unsigned long);
 
 #define __phys_reloc_hide(x)	(x)
 
-void clear_page_orig(void *page);
-void clear_page_rep(void *page);
-void clear_page_erms(void *page);
+void memzero_page_aligned_unrolled(void *addr, u64 len);
 
+/**
+ * clear_page() - clear a page using a kernel virtual address.
+ * @page: address of kernel page
+ *
+ * Switch between three implementations of page clearing based on CPU
+ * capabilities:
+ *
+ *  - memzero_page_aligned_unrolled(): the oldest, slowest and universally
+ *    supported method. Zeroes via 8-byte MOV instructions unrolled 8x
+ *    to write a 64-byte cacheline in each loop iteration..
+ *
+ *  - "rep stosq": really old CPUs had crummy REP implementations.
+ *    Vendor CPU setup code sets 'REP_GOOD' on CPUs where REP can be
+ *    trusted. The instruction writes 8-byte per REP iteration but
+ *    CPUs can internally batch these together and do larger writes.
+ *
+ *  - "rep stosb": CPUs that enumerate 'ERMS' have an improved STOS
+ *    implementation that is less picky about alignment and where
+ *    STOSB (1-byte at a time) is actually faster than STOSQ (8-bytes
+ *    at a time.)
+ *
+ * Does absolutely no exception handling.
+ */
 static inline void clear_page(void *page)
 {
+	u64 len = PAGE_SIZE;
 	/*
 	 * Clean up KMSAN metadata for the page being cleared. The assembly call
 	 * below clobbers @page, so we perform unpoisoning before it.
 	 */
-	kmsan_unpoison_memory(page, PAGE_SIZE);
-	alternative_call_2(clear_page_orig,
-			   clear_page_rep, X86_FEATURE_REP_GOOD,
-			   clear_page_erms, X86_FEATURE_ERMS,
-			   "=D" (page),
-			   "D" (page),
-			   "cc", "memory", "rax", "rcx");
+	kmsan_unpoison_memory(page, len);
+	asm volatile(ALTERNATIVE_2("call memzero_page_aligned_unrolled",
+				   "shrq $3, %%rcx; rep stosq", X86_FEATURE_REP_GOOD,
+				   "rep stosb", X86_FEATURE_ERMS)
+			: "+c" (len), "+D" (page), ASM_CALL_CONSTRAINT
+			: "a" (0)
+			: "cc", "memory");
 }
 
 void copy_page(void *to, void *from);
diff --git a/arch/x86/lib/clear_page_64.S b/arch/x86/lib/clear_page_64.S
index a508e4a8c66a..27debe0c018c 100644
--- a/arch/x86/lib/clear_page_64.S
+++ b/arch/x86/lib/clear_page_64.S
@@ -6,30 +6,15 @@
 #include <asm/asm.h>
 
 /*
- * Most CPUs support enhanced REP MOVSB/STOSB instructions. It is
- * recommended to use this when possible and we do use them by default.
- * If enhanced REP MOVSB/STOSB is not available, try to use fast string.
- * Otherwise, use original.
+ * Zero page aligned region.
+ * %rdi	- dest
+ * %rcx	- length
  */
-
-/*
- * Zero a page.
- * %rdi	- page
- */
-SYM_TYPED_FUNC_START(clear_page_rep)
-	movl $4096/8,%ecx
-	xorl %eax,%eax
-	rep stosq
-	RET
-SYM_FUNC_END(clear_page_rep)
-EXPORT_SYMBOL_GPL(clear_page_rep)
-
-SYM_TYPED_FUNC_START(clear_page_orig)
-	xorl   %eax,%eax
-	movl   $4096/64,%ecx
+SYM_TYPED_FUNC_START(memzero_page_aligned_unrolled)
+	shrq   $6, %rcx
 	.p2align 4
 .Lloop:
-	decl	%ecx
+	decq	%rcx
 #define PUT(x) movq %rax,x*8(%rdi)
 	movq %rax,(%rdi)
 	PUT(1)
@@ -43,16 +28,8 @@ SYM_TYPED_FUNC_START(clear_page_orig)
 	jnz	.Lloop
 	nop
 	RET
-SYM_FUNC_END(clear_page_orig)
-EXPORT_SYMBOL_GPL(clear_page_orig)
-
-SYM_TYPED_FUNC_START(clear_page_erms)
-	movl $4096,%ecx
-	xorl %eax,%eax
-	rep stosb
-	RET
-SYM_FUNC_END(clear_page_erms)
-EXPORT_SYMBOL_GPL(clear_page_erms)
+SYM_FUNC_END(memzero_page_aligned_unrolled)
+EXPORT_SYMBOL_GPL(memzero_page_aligned_unrolled)
 
 /*
  * Default clear user-space.
-- 
2.31.1


