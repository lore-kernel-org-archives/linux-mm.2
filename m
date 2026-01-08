Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 136C3D14882
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 00:54:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53F3D6B0092; Wed,  7 Jan 2026 19:54:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EDF66B0093; Wed,  7 Jan 2026 19:54:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A79A6B0095; Wed,  7 Jan 2026 19:54:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 27BC06B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 19:54:18 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 921CF58AE7
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 00:54:17 +0000 (UTC)
X-FDA: 84306975354.05.8D4118C
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id 45C7B40008
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 00:54:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=a+AomMHj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=F89zLWkY;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767833654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OOIeklP6B6+KADMLO0HdEpAwyafAfHnBOH7kw6mHs8o=;
	b=XSj+SUoeroRKHaMyq+TRuUkGVT5RbkGceYy1kobbQjeWfuNHZBLZx9x5qqg7fQc7rxXR0R
	L28Z7fH0n8q1ziHbKnh42FDWlrfw+S7FgymhlfNn1oKQwnltYypo8qBo8cYcDuzpE09nF3
	clKnoOQtrVlB2BLYcVfniqWxNA6MPJg=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=a+AomMHj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=F89zLWkY;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767833654; a=rsa-sha256;
	cv=pass;
	b=sOMCT0hqIgBHXYXrR2Vu9Mdf3FZznGHQNMaR1NXCVGte/4vT9CPvvwxCBylN0w/GP2bbJM
	nOIXqejcS22zvRV5FRTvu00s4poI2a0DhzA90OEWLUV6uL/F99R/8ykJOItuQ9j1okmqa7
	okHpOKClivGnqamZFm8vHOve74SSB0E=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 607NQCCD3583598;
	Thu, 8 Jan 2026 00:53:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=OOIeklP6B6+KADMLO0
	HdEpAwyafAfHnBOH7kw6mHs8o=; b=a+AomMHjc4IZl7arASKIO6FhE+T4K2BIOt
	eCKBnZN4ljnlMb0/xYn7gTg6mSwwLODfz3KiY09OPdawrVzGU6jR+B7bB54M5Ti1
	i5WkxAlqA/o6fcuISFw1vQC29DU8WLCMu1d1nKGGTZ777u5bc3Mfk7m33zyhMHcW
	6L9pKZVN/g+jyJBOIPzFu2i81Al01Y838IJGZF5IEvk6S6MTniap84SQjqw/6RIN
	Kkq07qhlcJU6fvggcGPhxoilfXYMhlQk/K7PoSEMn3COe9M62Y4LloQrQs2XD/kI
	eK9NPzJt+3Yo5wXz0hMYkHcBiiiNkLYMyEa7SNAjHjSZQKF+ukyw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bj158g3at-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 00:53:44 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 607MBJ7C033935;
	Thu, 8 Jan 2026 00:53:43 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012052.outbound.protection.outlook.com [52.101.48.52])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besjag3ae-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 00:53:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OM2a1dnVQWnLEi+x4zMz36zkDiK+dmUqVA60G5X/L4hWfcH+/KzH32dcJ4B4bgoQXtHPf3RPEuN0I9IyGGF/EbS47K676gfcdYfHSaoQ4zP0jYOCHGY53ayj6/RQrpmkxJsROQP51rhA5ssPi4sBf3+39ccja15X91S30rsnsQsKOmLzB50kI1bjz1k/bYkt+/mxdRDXOtJoew/ehfOF/PPctcgokEAxXwmfrQxLr3owYJJEU2BACe94tHv9WCxEa+0Z7n9gjEUFEzdRbARAVwqjCbhNHM5U3TxFkpFhZM4ntdO+pzH+sm9hYtdMhJsDNy63GiAbkZak5H+KsTyUQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OOIeklP6B6+KADMLO0HdEpAwyafAfHnBOH7kw6mHs8o=;
 b=vBPJjBm+eVd2DBGaZiHGsqGmxSwz3U3JBHtMMXRuP7f6uXV1WD6d/Ff7NVlCQbe9O1mjbNcBngzdYOLtOBs3gA9s1A3PS4EtfWmsVuK80djazUOCwfjemj7DlbVMjppIhWbOWobsWisSMhgT1H9n8uumGc6CAQaQ5fwy85hZqwPb7/R6vVKx+wkT6DTYdujV59HsnAeYpCvOTcGSAvyEjh1IP+YxRCmiViOyVyl2FJPHvcRk6g/FPCDaisUlDEay08FksQ+kVJq5kE5PufiZzWACrNlu0H36hApg2cK8tE7edc9WDI1CBtyBgygb62P9j1HFIDP5k+Li9MwZbALBpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OOIeklP6B6+KADMLO0HdEpAwyafAfHnBOH7kw6mHs8o=;
 b=F89zLWkYK9pkUHIPnfcY5fwDf8WaSWZSJ5Ja0aH015g+hwJrsfbqTiy9CQjv9MgIiau0233y0dqzkRxjFNLF/MlXXoU6WAVANrj860lgDEKsOQJu8+HUOnEvapk+Yz9vfnDEcAt4n+BChiHrSYRT8jX/QMO7F7K/UupOMwdTjEI=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by IA0PR10MB7621.namprd10.prod.outlook.com (2603:10b6:208:484::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 00:53:39 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9478.004; Thu, 8 Jan 2026
 00:53:38 +0000
References: <20260107072009.1615991-8-ankur.a.arora@oracle.com>
 <20260108004346.1652207-1-ankur.a.arora@oracle.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
        akpm@linux-foundation.org, david@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        chleroy@kernel.org, ioworker0@gmail.com, lizhe.67@bytedance.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH] mm: folio_zero_user: (fixup) cache neighbouring pages
In-reply-to: <20260108004346.1652207-1-ankur.a.arora@oracle.com>
Date: Wed, 07 Jan 2026 16:53:36 -0800
Message-ID: <877btssz5b.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0060.namprd04.prod.outlook.com
 (2603:10b6:303:6a::35) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|IA0PR10MB7621:EE_
X-MS-Office365-Filtering-Correlation-Id: 3080993a-07cf-47fd-5d30-08de4e505c64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VVNxENFrOHpCLr1vmNHOzBwQbd1SyqVo5ykqal02ZKNrzHyiT6qV5O9ENmZp?=
 =?us-ascii?Q?Pvi6glLNQXuwiAui0h0+s6blMVOvz0lmYeUjBNfDcQXzYt+qhT3s4nUt/nCO?=
 =?us-ascii?Q?AvIUtf9Py4IdE57SptRTRbocCRm8MMf6XhcqYwYKUkSf5iPSoaK09Iq01Z56?=
 =?us-ascii?Q?Y0e5WM5fDPs2n/knGWlsYtkzVPJB112eUs6DSa/yAdTdGV5YPxtYSz12xNRo?=
 =?us-ascii?Q?LSrhtGaas9ONWcN873YiH7D3YhVKn0dz2DB7pSZZcngctKyET4yjEY0gkUVj?=
 =?us-ascii?Q?hPYt2/mSTm/4WN0xPFyabFE2vL7N6m5XJdaWzQ0Vz7Kb53pTZ5eHQ8TuraCL?=
 =?us-ascii?Q?Mga+vyOJO10+LKXE9TPNseCbU7zE7CfzOSoS579yDvFG/uitVZ08SwG9CkAx?=
 =?us-ascii?Q?Mvrt87xDc815INpNgoouU9ueC1wtQ08/3st+zEMPOLOF9DYnc8XT/FtAW1XL?=
 =?us-ascii?Q?9bU+BA8mUj+F4PwD7NLJIh1uysSB8uJZrv3aAx5XMtEeJSfhKw5UA1GPyxu8?=
 =?us-ascii?Q?8fttoSm3XRboH183imx8KRBOQRxabe0wDkc8Hce1/s7XQkv6k5dwJqOYTnb1?=
 =?us-ascii?Q?TZt314BFY1qePXOe9E0h0XNUJ+i6lZs2rSuPs6WcJeE2g17EY4OMp5EjQuwi?=
 =?us-ascii?Q?qs+goRqULO9TjG2ILoKg5PuiV31ydBeYV01M2gY+JGWVItVyN2yXNlSql0B1?=
 =?us-ascii?Q?2CK44coFvRIyqraWKLTpEqUEQwB22MZCqiMcSBppS5AjETLYc8uT4zyZ4O46?=
 =?us-ascii?Q?/o8RJnd54K90Q4dWSiqYUHJPd/qAIpDL78fdUYHndMCvuCTAWEykaisKRRWN?=
 =?us-ascii?Q?+MNvRlwPeo/HDiZeeG4bTHIcli450kG3sTIEM8Ocd8DnrbLTd+BkqeVL3ulM?=
 =?us-ascii?Q?jZlPNQ1AnHVL0Wk2gnuwITMatFi1RO56WxRMiscmbRKjgks/9VH10PayNIqD?=
 =?us-ascii?Q?Nr4i82oij6B2d3s9y0DjVfn7zhSUua8itnHhtz6M6S19ISKKVYfaRXWWlsoq?=
 =?us-ascii?Q?1UcyBM1keCOulvNiIFz9eIiaG4XGJesdH85+EefcBF3xrlotyql8QZMlOGcO?=
 =?us-ascii?Q?PXw5vQbIymffaC8a/mvBjM7obUhknVor2Lu5KNAW537k7pBm04zLzHon4X+W?=
 =?us-ascii?Q?IyJ6+KmE7lUHtxI9LgwByUPQ2P319HBEQxAgjsl460gqgnPMG7nLReE0arx7?=
 =?us-ascii?Q?ZtWI/Mp3aeR0rH94A3r88RTnuqxB+3MLsu21a5y+C1W8Px31vpWrlLeTl4Ng?=
 =?us-ascii?Q?EowtB1skpkVgGHWYGybOFGKwa6l/0J/n/QCy2ysGvs5kUfSeUxRJAouIP61/?=
 =?us-ascii?Q?2TJcwF+e8NxHZRdAI8370e/Ox9iUqoxcSqt42NgT5aCdtoQ1OPPRE93mcFuJ?=
 =?us-ascii?Q?qlcmEr0T69vFoXSC7KCqviKzi39vszyX2+NxAhvIV7Tx/RjzbijTcUxMYAOu?=
 =?us-ascii?Q?Rbn8xz7QXzxmPPbOucyZ4/xQV9AdCVNC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rvOuXeSoegWEN9l8gRnzdgVFsGO2DUrtB9tfjs7fMe19Oove+nf5PXsAunrR?=
 =?us-ascii?Q?j5+CoDv/299HWmpeToTomU0vm9KrjprbHVu7Zvz3XQjPeErRoidOYVAl8NQD?=
 =?us-ascii?Q?8xHfqaGkjKSSsyMbWRfTBrxGoBf+xJtaK1ZIPfNE7kUcbOUMRzODRzOShi9q?=
 =?us-ascii?Q?0Q4jpUxl4TJssoE/JADCHu+BHvuMK1S1FbrKe7qyGy/idSDenx/6zCEMyBcF?=
 =?us-ascii?Q?cLXW3cQpijxw+MBvnu/nfZFQwJNKv7a1HsXfKi4nxjthhB11nMepbWF6Zn2s?=
 =?us-ascii?Q?dDT6MNsfNQNvx9qpQtz/wrgyZdNI66nSpp4ejrrRkPcaaR7zyZ2QbYmYfaMg?=
 =?us-ascii?Q?j8jdBg4//jTFmxwHWSE92UBJrE72lZMprqltGZbV0tw4i6sQIvB2ZiuoDeWK?=
 =?us-ascii?Q?Xv/rlI259OQNnrdYXvI8mg9hxBtVqr28jln2anZlNiMF1K0OkFObLZCrbx9o?=
 =?us-ascii?Q?1UE0Ubdz+rT33Iqgcfx6E94updqsIIyWsGnoPUPrjZWsvKCRTXYtDyGvqTMm?=
 =?us-ascii?Q?cgBezy/FHtV3Fp2/adlex8p9u2W7LfCSWlIV7ytmnmA39GDxurJ3wPgARCfA?=
 =?us-ascii?Q?w7FWMWcoVjVWnja5qPmGMkEO5GiqKDbM6vE7XN/+g1dxRJLqIV9AXRzIoZMO?=
 =?us-ascii?Q?PzLVhXLLzyRCtuG1EwdDctYVrlnKn6LyCpH1zdlmfooQEASH1GzBtoKS+n4u?=
 =?us-ascii?Q?LQ3Brep40nWh/7sby3B/lmwSpUzJp/RyICvGqWWp7yvZDpufGtlbdcTIU/8L?=
 =?us-ascii?Q?OhqheeA1U0Du+xZpH6HSGEQ9DUGwa3Fdv5Mk15uJtgZ9Z4Z6+VWpxicxWsIr?=
 =?us-ascii?Q?ZuUjlXQqzgPwysWQCYYIPsA/4FPTWfyneLEL++OqrOKS9NQ9uGKpOZw9Vvj3?=
 =?us-ascii?Q?Ud5GxswH6iKB4ZLgmdv6qwSo5vAlB4FWjKwnH5GlQU0BAw/yGEDVuD0797pj?=
 =?us-ascii?Q?gZ+VY7r79xmsuLYqLqIXYRvYO4DpuyvzO9eU95HOaYL8VN64JXCchwksBkok?=
 =?us-ascii?Q?sizhKQ3bIczHxzdbMS8zg/PCE0E8me4PTQch0yIa4btbwTlobYgmcw6SDjk8?=
 =?us-ascii?Q?xEBeQzko6BwMZV7uEBaY3QusGE+AMcKtes5qcMMLCs0gjDm9zr77dhn1VCnK?=
 =?us-ascii?Q?dhVawyGe01PCog5CM2O+ZFlpwXd1ZsnmmXxmRD4uUoOjdA60z+PjUY533R3f?=
 =?us-ascii?Q?X3TzNBPPGDhsn3NO8kPH0hkzssBquN+X2AOMpKxWP8sK5X3nGFD3An1Hq5zT?=
 =?us-ascii?Q?29vcBqQqFfa++OZ+3x2nJmIgacs8BhiayJRGjp/exDc0JgyC4yC4il7ghfaK?=
 =?us-ascii?Q?msEwTvWmmded3Igk/tLxtED1j2V9lyAXoLAWyzghgWdsb0dVvVvREJx/nn9p?=
 =?us-ascii?Q?GQ0FiiBwbVwQ3e/A4DLoEryv6evLkhxalqYCGGO97kICUFx52Ym1gjWJx1eK?=
 =?us-ascii?Q?GFHXXbcxF9D4/pipATpjaWobC1gsqXv80FHnAvoBE0ojX8CbYhIGoETRf27z?=
 =?us-ascii?Q?M9IOhEuKDiL0GtQ60gKs9It6bASZweuf8waBsfuF/EfrGq0WX7BAech+vZjB?=
 =?us-ascii?Q?YeQfsCobUs+EN7cBnfVHN2ILFP0tpAFRwsatHa+9qjp2xNUYbhTfpjQKaz9S?=
 =?us-ascii?Q?QzTh6zcrxHKdeCNm1VhcQQ3vSG/wSnQWvOfus2x6BYGD/xMWF10+moBjvo9O?=
 =?us-ascii?Q?Q+w4+MuwJ+isYHZMIBsOsn0lIFbQucdEeGo7X2Jk0XTOYS90Tp2Sk3DqgRvs?=
 =?us-ascii?Q?E54zOqB4qx/+wPhNQKZXWIDwKSZcAOw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	O0gOSkLoaUgPAoq5Og3r1LnSEGINSPlqUWL8FSlNQ6/GNejiJrJOsk/nuCLiPi6XIdLR9ysKOsMPBwsEe/32OCYiI8ELtX04+oKLwux1HT2eb3YIrAvHLgxW+xwEAVSqg6GpyLzUGB9OAeedKdSWt1/YTWXHeneAbwX7xDqdoLOu6ncgsQgWqUAsEX8URx/mbAL+XRomvhiikRVumWeCN3nNySGvL1otUAvH9i8EipUwmbcmxgx9jAXp2nsuHtqqi4QYp2K1zdMDVyatwY63AKSLS81MV+yvQKfabfF1CU/jZxLG4gTd4V+VzAgubXE+hJaL+VMieeQdTgu6A9LRw1YFxqhPX1GgZfCE1ihPOIjX/k0ES4R+HMaMe/vAVGaBk4wuaeF0JlgfLZMaWI1W+WA8shguGfmgd0DZESrvljJSVs1T2uH45BO52nUos8aLblE0tsH0AAQKhpY1ZvbcqIU6erL+91ZacLo+cXee5IWHPyXHCdvopFY4oZkJgRltEFaq/To8CE8zHfe+QaPT6PeMsHvE/Xspm5+vds6pgWNo6lIfhUjZzOyOZ9EFaVtkrpDeFw1efHVVxe3/1raN8+Mv2QEAWTSxiavdgfLr6Fg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3080993a-07cf-47fd-5d30-08de4e505c64
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 00:53:38.8626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UZ3zVpD4TOLvFVc7rIq11I2ehRue+thnOpnMtRz4tVZG4qf1HNjJSO3u7MZQt8occduA9Sm07EgtiXTHlreJG+cBnt3W4KfoNfuoIAtyLv8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7621
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-07_05,2026-01-07_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601080004
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA4MDAwNCBTYWx0ZWRfX6Yud63wj1cFw
 EGhDjwJcNGxPT4aXNOGrfdTSx1LpsCJldCk3t/uOdNyDGdqwMlPrnG+AXpclXto2RnkWEA2O6qb
 BRmTw/RzFFySg6KKq0lOfdkJFqlzZOKjDwnPSBBDTIeerP4X93nWD2jltuW0LsI4P1qIh8m5pF7
 APg4/fJH5K9X1sGc/HvHYcJXX0Xnm7QgnXDwpNjRGCtEcVmJx3wQ6hEK3lLDRVqv8xyrfm7c/ml
 5vXAjvojmE1Ad3phj0bBzXFB0WwGCztikwXjRm1AlcDgiycqJfRaTPiXSolGp77oOvzgiJGjGP9
 iG7TRAOxp2dcGVf3SyZ4WREPfGRf4bYnDnMdF82E67c9z6N6w/GA9lsPlobfOD0AR2KsIT7OK6Z
 ivlahiLh7E7IEJtdCxt75K2YyutQcWsXboxIMGyVibv2n7lPnrg4TxQbIysCdkoX6Ps0reO7kTz
 cHOvOaFFNsRAqYPkW+Q==
X-Proofpoint-ORIG-GUID: N87WnlzrgihVVCEAOeg8mkyuXIul3qWz
X-Proofpoint-GUID: N87WnlzrgihVVCEAOeg8mkyuXIul3qWz
X-Authority-Analysis: v=2.4 cv=A4Fh/qWG c=1 sm=1 tr=0 ts=695f0018 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=7Kn0EbdcCaXlz2bTslgA:9
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 45C7B40008
X-Stat-Signature: prf1qrcs5sixt33x7p8dwhhr98pbrsn1
X-Rspam-User: 
X-HE-Tag: 1767833654-396802
X-HE-Meta: U2FsdGVkX18gVqmbvasC+F9qE1x0znWYvzhON/NeS7A+MDLBawXpwnksxd8MEahKqcfv4DdWE8VqKpmYFvUnYhTtplEG0Sl8LylidR3DxfdAW8B1cxrJpJpNu39w8C+90JNyjg8TaHcGvxcYvRacyHtHLgPCyTaSM1ucdq8IzNelrmzuxQGqY1d6gn7xQ9jCaj7qJdBW/sko4YqNG/OeUR6NGvp4lA2noLPcMcG6CayTC25ePrtOQk+oq06WPryuzQ7Um+69gVOr8Hanr7/utklczOq+F1CKkm3lgfR2uDE3jjuWkUuL8uMbNO/YD1pU5F3eLjQbF6mbfFQ2Jz8rX4KSmi4JYyex1ffqu1c4+46zv8wqh+dajbkiEb8FT2SUboiwyCxnXK7B3hsSyayFUQP4dj+kRmmLeRF6cAaJsBZ79cyOAFD4uE9lRQXVrv/orDQ1S4SsUX0rDw7PE8mADNPrMvjrnud5pAOgnbaPUBlVaCXmpYYjDUjKxtyaLfKLj+sgz987n61dbjhrd1E1a6V7HETmtvusUKzUISzV9/o25yz4X3O6xIUqX6Khpn1GjUjbifGH3xndxMaMwnZyTDpnIcE9YFH+EkoqzbFEw4y7tbZvWcOjDWP3y32poTMNj8HGyrViKcz1eFh8BqpH0bMIyf31F0nvvEhHGuFd9iCahH2tBr1xZCiNtl1MZvMAmRZ7bfOhoH9zKp2sqsKa1IpJo93N+50bdPoaXIH9D1/YUbFdiXvSwo9seZ0m6letES9pj1qzzplfvF6EeoYtwomEFMpAcSOvaV0thAgf+VYHk9SH1DjkzO38RTE4hNdXsFSrtbgkO01dPfge0acPixcnTIO7Lvlp6mJAP2wTv6+KUbDlXdmA2sFmWscxxu8jKW1GiZcdHGcCRjeHcsX0nP2gWEah1VaDiyY7WEPpdPxVYh2DCHL2oO8Tt2a/r+/nhT8uQDm8JxIJNq2tHfl
 r4ZIuBf3
 jKKkxI8ZnIIapQVt/ml211CKHdXrDt/n854QctEBdMcQtOiGz3wcN7hG9OlaHozckywBMlCA45ymu8NCN7s20RBajRyvbpuItFC01XuusCV9H9iu36BkRplubxYncfVkp5bTVj2Lm8i6txpGRYJd96MkESwMOhvOe+TCNAo9qzjmzRYn6IiZy7S6aYHDadecDme9/C3q+xDjXbDjWckAgRlfv2i4MDeC7quMUPmqt+YWI6zexqBbj4qlcfw3jzGYzDTKAo9y7GF4jfdJVk3/6+LgVkuCYB/1L6pcmO0hzj+0BlIqSbGeKL52NcOJvXlQXpb7n0VMKpUSjrMKfv639OqOd9FY3dwgOTsC6sxj30YZZy6F49ZleR50kw72gJI41+W7khD0AizYnGMEKEN/585imv4M+vUms2YsNuehGhXe9bY8b/8x1wCh6jE5DODwP9x4YsF37jMTD3IHZMB0Yy0dFYlJIS9w6sRnb8sE/JH+3AirPChq7dJtOvDyJcAl3nfQ1Zax/aj55qMrF2vGQmcEjcq8NWZKL8/Oin6/lNzgpx/eJbxBpeqlgvyWfySW3VrmyBwTGhpu+GimeXRCsuPD6+MfInapsvfu7dorxhEuzRhtaDwuvOSxvNY8BpE8U1+g2TC+ZDO3B9zxagvyUa1lmdA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hi Andrew,

Sorry, please ignore this patch.

Thanks
Ankur

Ankur Arora <ankur.a.arora@oracle.com> writes:

> Constify the unit computation. Also, cleans up the comment
> a little bit.
>
> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
> ---
>  mm/memory.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 11ad1db61929..95dc21ca120f 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -7240,19 +7240,19 @@ static inline int process_huge_page(
>  static void clear_contig_highpages(struct page *page, unsigned long addr,
>  				   unsigned int nr_pages)
>  {
> -	unsigned int i, unit, count;
> -
> -	might_sleep();
> +	unsigned int i, count;
>  	/*
> -	 * When clearing we want to operate on the largest extent possible since
> -	 * that allows for extent based architecture specific optimizations.
> +	 * When clearing we want to operate on the largest extent possible to
> +	 * allow for for architecture specific extent based optimizations.
>  	 *
> -	 * However, since the clearing interfaces (clear_user_highpages(),
> -	 * clear_user_pages(), clear_pages()), do not call cond_resched(), we
> -	 * limit the batch size when running under non-preemptible scheduling
> -	 * models.
> +	 * However, since clear_user_highpages() (and primitives clear_user_pages(),
> +	 * clear_pages()), do not call cond_resched(), limit the unit size when
> +	 * running under non-preemptible scheduling models.
>  	 */
> -	unit = preempt_model_preemptible() ? nr_pages : PROCESS_PAGES_NON_PREEMPT_BATCH;
> +	const unsigned int unit = preempt_model_preemptible() ?
> +				   nr_pages : PROCESS_PAGES_NON_PREEMPT_BATCH;
> +
> +	might_sleep();
>
>  	for (i = 0; i < nr_pages; i += count) {
>  		cond_resched();


--
ankur

