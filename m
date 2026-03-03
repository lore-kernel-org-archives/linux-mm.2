Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EF28EC0482
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 09:55:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 309926B009B; Tue,  3 Mar 2026 04:55:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28C796B00A8; Tue,  3 Mar 2026 04:55:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16EDA6B00A9; Tue,  3 Mar 2026 04:55:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 007E76B009B
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 04:55:21 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 91902B90A9
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:55:21 +0000 (UTC)
X-FDA: 84504294042.11.9EE53C4
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3D880100006
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:55:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LKvUoapb;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=udPH9Y4f;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772531718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rSH1E2JIrIv9DorYilHpSdgg+m/YIWuwSOLe4kyGWI0=;
	b=5e4zonc1iqgpJKk4ZNLPksXljZNAkKtDXOp8X/a9KNnpOE15uGVBkSqxigSLkNA312RYKi
	CFE6ulhFrYEsFz7gH+xHqt0R/MF/aEyoVnGi4SGmehMaPFoSWisX2p22wWAUplIn3SQm0Q
	E6tCcjLO8Ra1pkZOprk+iGlnpT2zfho=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772531718; a=rsa-sha256;
	cv=pass;
	b=VYhcf6p4PP4EEy6rwI7ZRZIDMnr98UK05iiuMLpzOZ/DaV6KSmQ5XI+VtC352c0HM3alml
	sMV5Gi0wjICueetsOIgLOl9/CtpGnNWRQ0wTvyoMh4aYI8kZxmwnTKpqehrz+/y2YKTd7v
	SujF47UvoJBMacNVDsNNVBvHGw1VCNE=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LKvUoapb;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=udPH9Y4f;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62392H3B046360;
	Tue, 3 Mar 2026 09:54:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=rSH1E2JIrIv9DorYil
	HpSdgg+m/YIWuwSOLe4kyGWI0=; b=LKvUoapb2TTRLeV6eInKk1u3cFy0FkiuRP
	UBU99J6aUUM5/Uk8J/JhWKMPimoiU4b0pH9Adj4fKjPVqv8sdTscVLaqzq1KhQa8
	6E/U7Zq6aQaj6ms9BriNL9LnCsiH+qrmzWfbeqyOnX6q3rFyK4WcG4oQe5tTOCtE
	O9KRAn2jgSpgOF7IbR2l4pPQgFyRy+ouUdQdX3KRC5Ee2rLFHDFJBIIVHsqExyux
	pv20Ob0wJ/fqvUPTZaZbDPmmqf14iqcmxEuo9CoZg1NUqgyg5IUEdaK/RZL79oS8
	BmgUJ7iblPHlRAKpBY5OphCuoxDVSQ0aBeI4dcnf4oSA3rDn2w+A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cnvnn82p7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 09:54:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62388PdY029685;
	Tue, 3 Mar 2026 09:54:06 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011024.outbound.protection.outlook.com [40.107.208.24])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpta4298-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 09:54:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z8upTNb190vMSCA+/Zzx9AtEht3RKCITf3w1GF1Y13agQ439rLDYvYtF6W2XA1F4eevPSQOUoQbXEnZqcgXO7TucvqYmzvx3YzGiYrUYgt4BcL/ijuzZ5u4n2SVNa/0ljDJ15iGsvXYc/RRdx489quRdVpsHZ44MKAJHSKQeOw5/gf5wirWlJlti71Xplga516GlzOSV44gHj9xjeySjZXdFZfONznTKQonxk4fFeYFVwmTsmOSsXcjdPid2WjA6LeaRocxc6tUIC5EPzGY6VR6QHOzC1UTJbb+sTvRwsJgI25bXn/SvyTm+RIEVW7fiaCmVUdZyenjgWUhKDkrdEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rSH1E2JIrIv9DorYilHpSdgg+m/YIWuwSOLe4kyGWI0=;
 b=uytRm6wazknq0wVB5S12BAWdToUThyn5A9BuyT5sQ8CbmI82XQ/jrOhsB0VR+4woHNI6QYdxcMwPQqWvOuaUsgBwRznGbGxmyiVMwa+WAteRhrIZemCoE0WYUVgDOea5JB9UwArmFvGMqESTsloJ9iyagoLcn3Gqw1fH4gADivnbspbL8Hgqz+kemD2pJvOnmoSATlzu3LThgHvaDcxkkWXOxXXUS3t7aMagOSxD4xa+qRqG2l2nSOKM4i8gHXXViBl/wZygBGJ7f+zRCDAOWSoGWVgoSddYeRuaZ3QaAjVuLIIyYZQzkcoXDgmK2tQpqPjtHtNStZcLDxe41cxoKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rSH1E2JIrIv9DorYilHpSdgg+m/YIWuwSOLe4kyGWI0=;
 b=udPH9Y4fu/9wYWWZZMEXgOcRc/njfiEMVArWDHY5qR5S9nn6ooO4wUfqFTsmWLiupSyelKPyJA0FEgWJIVxfT/pDMYPBxRBN4C4hpFmlGjLVjUlYVHgzvzK2isshyPQE8zfEKoj194tQEs+fNasmdOlFnmt1LlNQhkVy6skK+Ec=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CO1PR10MB4564.namprd10.prod.outlook.com (2603:10b6:303:6f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Tue, 3 Mar
 2026 09:54:03 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9632.010; Tue, 3 Mar 2026
 09:54:03 +0000
Date: Tue, 3 Mar 2026 09:54:00 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, riel@surriel.com,
        Liam.Howlett@oracle.com, vbabka@kernel.org, harry.yoo@oracle.com,
        jannh@google.com, baohua@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
        anshuman.khandual@arm.com, stable <stable@kernel.org>
Subject: Re: [PATCH v3] mm/rmap: fix incorrect pte restoration for lazyfree
 folios
Message-ID: <01a12197-73fb-4e4e-8d8c-85de5cd2c9f5@lucifer.local>
References: <20260303061528.2429162-1-dev.jain@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303061528.2429162-1-dev.jain@arm.com>
X-ClientProxiedBy: LO2P265CA0497.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::22) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CO1PR10MB4564:EE_
X-MS-Office365-Filtering-Correlation-Id: c3469ab5-3d99-426d-641a-08de790acd6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	DZ3SSak0luinILZS2jGDJ6Xy4rhf/KTz/U9XiBVITCABKabEH6Z14Eck9WWHN+6/LVTvxwokeaoMsxzuBkcwOC/ANJhe2qZ2KpcoCHsaK1P1vy8hRQE6yPRXz+UUdLVT+1hfTBVmaDZXzCcdP1zbwdtUoVXHLJ58Zpv460VAT4j4zR6+j6De/5G+UKIBX8U/7HKmNsIw1YF0c8iOAxnt7Ti1azRZC3pAWkT4UDLfK0PadFwaPSgqWW124PCQ8VhO+FfBofwmSfpgR7ieZ0prxEC0wLRLBTs4rIxzqtHNJPKhzvW2g6TvPd4gd9KykSa8gV3geb/63VvcjhtXcFf7+eS/GH1okq2aaQfFCcPCbG2X4qDSExQ+AD+PUaEtBvjVZ/NkRAKnLAocylndccganMdAFniTbw3fRyf1zwkAKjGMrIF7YP1lOHfxlohZcOmw7rweahUq1YdR436eYVrafVZL6+QeUAN0Bmr10HSTNqZRKVYuic7OaAPzFxlDoSv+jj96lvFj9M6gh0YJh7OQ88aTF1PsvQBy0wVb59cE9BG+ke8+HE9LHYiLXritNE10k+5na5wx0P4HI1OrM/v5MfR8mxnY0R6TfyXCZGZFjRMMfFWOTD2U3+HSH5Q3yCK5uB6tBuiF3Nae7nyWPqot8EtuCWAZ8fSUr2jZ5FjqNwJ4c7K8noFZ37HVXup2oDOmengb1FQXCfqmW75mVR6RJQ12lPgpbiHKfRUUQ9nnyDU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cmMA/NvR0yOuJmAo/WBNjHi+oRd9V7gJ9bQlMZaeIwP/oKIDMRmKRTDGe3Kz?=
 =?us-ascii?Q?18olNhuKx4A12pbm3xaIn9z0vlKaD4RZjJ7POKgAytu6KokLtgSR8qjYQoP2?=
 =?us-ascii?Q?ZVZITS3mUyodzn13rpQ2CaSBzaAR4S9oOl4qPsgpdA66CRZBXheQOf2JKB5Y?=
 =?us-ascii?Q?fvs8U5k0O+8AOC7MLhHF6kVIXnaZtiwxoC8otBX4w6KH+NpJaO9HZATMVpzj?=
 =?us-ascii?Q?IAUd2ou7i+HvhZS2UHcqmoNjyz21KFR6JXuTZ15Z7YBVwB1mghEU2BZDSKfv?=
 =?us-ascii?Q?wYIHDTHEccRo+MXqXXdacB9pKW2DJ5PwfTlO+lFupP7CCOcqCNd8pUBR9flE?=
 =?us-ascii?Q?NIfGKAK1pPmeua1ijH3Zy40i43Zup0nBT9+Grubk4qSWgihoGZvUgxoFOhNh?=
 =?us-ascii?Q?WByTNGfAG9FzG3g54kQNLxZEhTn+LfU2d9MtWr8eLBMVd7QRhtcjxGUpxEke?=
 =?us-ascii?Q?7qn2qmWtzJhPVqTSJAajNW35A4SZZAFyM2WVV2gXfyXXMn4cck32LY6XOILb?=
 =?us-ascii?Q?kG5ZpQQ0uaL66LzbVTfTGxA6eMcemzN8rRn416jQZFvqOSw+3oejIxtESXSl?=
 =?us-ascii?Q?LOLxN308gyGQqoypre/TeY5rck8zS/f8uEtp8zGVomQE5pgzM0uXBifd1Cef?=
 =?us-ascii?Q?mXLi9KOUItqG9qCzWiKgNRjlab7Z2Zod02glfd4mfryom5zdiskce5SJLEFk?=
 =?us-ascii?Q?xf63sLROaoX8ZXH0d7DCh4UgNCFyXxfroJQDHS/CCje0TVyU85cWWvGlbNiE?=
 =?us-ascii?Q?Q8okaoi0AXGnQpQQuIBPzc46mZyMBxLN7trlh9qEd0SWqlK+pR6YDBXYvupm?=
 =?us-ascii?Q?Htcso2SQSgTzi8b3ZG9hkfQw2U2mK3Vz2VdYnIdiNV6OQ++sXfSaatrzhEYF?=
 =?us-ascii?Q?TQWWnWevj0oOB7n28LfNZi6mGdDoweiWXa5mxe9aWSxj3j6+5CQ+IVnphN5A?=
 =?us-ascii?Q?rc1+F/L0HFjwJHlt57EEfJzfJd+33l4IiUtXh5o6v34F3e1KzN6wLvu+O9qB?=
 =?us-ascii?Q?JMugFAftqwSm1y9iUitKGMcKO2JchYIr0GsmVdDl/Ce558OCAP7d5eHq2vd4?=
 =?us-ascii?Q?t18pm+hV1cPynE5UzkYXi7gjt9mhy5yzgjATO+4WxAT5dM5ucHC8IaP4ZPau?=
 =?us-ascii?Q?8TP8prpEeQieY0vOI2iZ6TqKEHi8rGpoPUZMYK09QhoGyFLJR2wwhcOVrULE?=
 =?us-ascii?Q?Kmf90k6crcLAwJATNtyfYVscGEKmkuCKp2NqytePy24OLqIaUgaw9/CLOIMb?=
 =?us-ascii?Q?wuFuLcpZMcbiM/i3T1lxwwPKUqGydcoY5ZjXM39SU5E26AK5uML5+I18PVLH?=
 =?us-ascii?Q?fzoKSiBYLM5HbKfhetkAXfQLimYwTwOWVt4rgNfBk3fOglKhEGDjKiihCW1e?=
 =?us-ascii?Q?6Mwz69eIujMM330aoZvQMBZugtQx5GbLF10vRIcd9/ZmoS4VEIyLM/BLrNfs?=
 =?us-ascii?Q?WiO9aEmtn4fSRd+eVONbFecU/VhLyHUrGgFazrY7xi4+1/fBGC6yRx3un+ed?=
 =?us-ascii?Q?EqKgo/NTjdmfHxQQAHQ0G2KfkxPX6JwqKCBKkAtXGCa06yaShVLKwis4V3Rr?=
 =?us-ascii?Q?B+TyZdaLDoAWAaBLo7hmQTzEt6aEjgnFXPnZZGdg3DqW3BaIONeljt5gRyY3?=
 =?us-ascii?Q?1vkT/b2xy7N33L/0cQE4NN2bsJqk3Cn3jsfzuhSJxMRVZN/HeukJ/LtccAva?=
 =?us-ascii?Q?jWBpwRcKavJVqtJhk1fmMUumNRSsAFkgP9Mm4rkj5fYRy8k+C4Hz9IDnOXwP?=
 =?us-ascii?Q?s5NhUnvVcIeNLIqKqKNFFGm68jUwh04=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ambMWH/v3Mk2avzX0M9znbSZQ0n6GOS428zbGjW+r929DH/vzVqmcOOFCoOTe2eAkqgb9DCv7hcbbis2FeYIK9WtOP3wawGa4yw+mPFp7F4sjV9CDPkS2o/wHmnfdFTYBZdJyRgd4+RfBga1cDWaYQXTpJGr2xk7wE5wXFBZzrexyYZuk5SN3ye7dz89axqCKt+xBkz+81nKKvq2PImwI6W+BAuniGFbTajneX9Ac1j+TQdpK6xY4nZkX3dUG/h9kVU4GqFfGpmfR7m3OCFhXXS3o5+Cak53K0rIFZgTg/yrcNp22XxvoSAhV9YfODuJJUKkHmA0Zb/s8ClZOwray717xlTOAzrPTugE84fIunP8UR1FgQEAkG6MszxaRseiy00dvOdw4sH5tBVlF9zmdyuBdxh4kSco2XF7Z/mVDekQ6pGyBUChrLVwxBGg8Iv7CTa7ublZUGunYazUInKXKB+hxtoDGxzebQfesz13ErGnv2yzSi4CU+QZbLzrTISdk2A7VivMKgkUbka3FMI3HKudkdDdCnE58Nzk4ug1eaAA7g4Soh+o36uG6x4mjWMRJAAgUZOz1QGo9xzjYjcxPvEnKZTqdkOzXaWPfuH4WjE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3469ab5-3d99-426d-641a-08de790acd6a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 09:54:03.7293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bZOM7Wj+9170MfJqKjV6QaZOngJMa0rpM452T78TI8d9jclngh72uIfwBC6oUk5FUdL6/PWp3Kr8DMCbydr6biNLZdDUfF0ZQcLPxAriWJc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4564
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2603030075
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDA3NCBTYWx0ZWRfXwWVRtcHhnv3y
 yJX2J9gI1PN8KhH9RpR0C2EpkFhAl4SBxJMkc7k4an2sUJwIQKXgq78BnUGUmO6UEghVs5kwTM/
 c5Ez2Jjp5061+9k47/blpKIUI+cjPiPs4wDgyXFdAv049KJZygsQHjBdod0SZAy6ex/2l+Etz+K
 xxRvlC7AyGN106O/mcqHA9K4vaFXzbR0Tha0lP1puj6KdII7f6C6TcXmalV2fUcwSHdpwcaoUBg
 iH/cl8NXdyDY9n3mRpxVF7pmsTGHLhJHI5hL3hUuLnuxlqqZEwXkxTLp2gyLm/IOJ/I4Fa6m6jL
 2pk/9kcJbqfPhn3HisA0duOF8kZ6Ij3LYxh0CkS+1akbGMIYwyVsqaEjm/X6QfaBf/7T8C1UiJg
 5h9MS9I31edvXt5gM5oDPfu1qkj4bhTrmyeasiRW/3pG9HEKCPGD+J2sKexw95wUBUIE64YD03I
 i5htybcR88eP/ae2jwA==
X-Authority-Analysis: v=2.4 cv=P+k3RyAu c=1 sm=1 tr=0 ts=69a6afbf b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=7CQSdrXTAAAA:8 a=yPCof4ZbAAAA:8 a=Flgi17xP5Tv-PpZM63cA:9 a=CjuIK1q_8ugA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-GUID: yLrlhXlJ-Zq3u8qIPbGsJrCDWM3fYM2v
X-Proofpoint-ORIG-GUID: yLrlhXlJ-Zq3u8qIPbGsJrCDWM3fYM2v
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3D880100006
X-Stat-Signature: 6z54r4e85cmiby9jyhxp6z1fw858nc5w
X-HE-Tag: 1772531718-75535
X-HE-Meta: U2FsdGVkX18eJbipGcb3pABFIRJmbUC1FHy5C10NYJMbq//LLBJUbfXprgYWmxxR430y3gK0SNwaZsRSkHVSyhMkDVUbzElaEgwFlxXPHmLM/0Ejr8P088tndwDqHFEq8buR06TL1f2JaRVGRhwQuy1pBFs7XM0qakxwxyYTgpHMD9B9CVtM4AZgWQx/wti6MP0+GJ+M1FY/aei+qee/MrT/Rwbak0MJgZ/1BgVD7t/IAXecAPmlhYvacFfJRvymX/qjb9W6hSutHW7t3YjGceTmnx/+FXDGf8T9Aodfwa/epj1eLF5ygIyh/dFeuGbHm8Ra6SbzLfB1mhQ4ShKF7427UbK0z0zDXoA7y3dsrIXZH8oukwIz5FfhyvEvKQ1hDZdSfed5VRs6dekTQwxK4WrlY6fzNCy4j3fM+lkAd3OBxGc1uJzJgeMh0vPzTQBkUaYiW0MOwfFTXVY5GiNO1o6DQzU1kERCh4RULhVcGPbwt7CgBqmPng1yW1ILm6Btbh1xdg/5Ou93qJR6tvFsTLoh0prxwPh0YS6HINQjrI6WLrpeSl5z/tcaRNByJDgtRmbJv3OJh7jXMp4QR3fC2fTBuGT6UHK7TZGUUkP0qmuv6vw1nCAEndOydOWHf3DM5vBIoSCxVzNB6XabYZKFmxGE5SNT+mKZMY3Oj5j7Ek/u3d8umIYrf/O3iDVNnFRyWcEe76iMF0oergRtxrWHhrX2hN0yp0hVOxLmo015gjaO/LoYPg9Wmp8SrWwsJ1jsKQx4x5+m8cCgc7KPFGa77/psES9HCZfrxKDCzk23O02ezkDnnI9ZUd3HmFmqHYzn2UY7fm14fd4zZgeL2tjAaZChdgvTPoP5TB6MJsx5xUNDoyiLFXNhE7lAwJmxwfUeZywo77F46rQOJGgGj0HLUeePwnM3PaYlJgLOsSlG7Q+i3LkFUnRsopGr1xkzXwubzVWiDcrNBCke/qSsWMc
 IPdj3tT9
 YDDwtd1p6nCe+fOHgj3IzzCWBBOr4ApjoqWc6jh9+J033VJ49x0WHXWeeB8QF2/R5yf2EnRBXBAEfmn+RnT08fKAZbCWZgLiK7qmziA2p4lM8sjRYFmiOnGN1VMw7TL29M+ZnlmWyEUMlvUKtf0LrLX6ZOX/RfAZCNZpfpJnzfXRqegGRommuZIjQLVI82sspCijnJxPdY+ZPlWwkMGu06Wpob86mMsQV/7kK1pA3GZArJtcB18OEnipLm4hitZzKCn15xkR0itVCtuBTFLM83aaMj5QfFwo6vFN9CZ75+wOkhwUakQsFCppL40SP+FKhuGBEUhH0ED+S6dOc7Y8xZ9A6SEq0YbHjpg4fZbGQuap67AJNLTRPFbwofkpR6q5/DgUKIJKeiwlFs22cokv9m0zartoJ6CjwHvlruWPoUK6RIsq97RcR5lDhkQfxlWlmXXERNKeBqpZTF5VZ21pIvLysQrGEOhrf3YfXbLBi1xmxn16NZ6Tvyg8muFeLHLmvCE+DOc6yYMLgUyYDqZ16tmJ6eP2q8VUL3ALyhhSrJUUWOqlqG+ALATkJh1ARvnnsUW5WxUZ1Xg2SQ6Oc1/iYjJ9lnqyTfHSpxM8JMptIaMatRdsx48DdQAAAYmVQuWt3XuuWzxflUjRWxLgGNwq5NwP9B4QaH48BeTgLyvSyX14rE/WyVm0rj2/KungdCbax843Rvvvyt2AZjyiXQkZDoVpyqnm7YdCY2drm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 11:45:28AM +0530, Dev Jain wrote:
> We batch unmap anonymous lazyfree folios by folio_unmap_pte_batch.
> If the batch has a mix of writable and non-writable bits, we may end up
> setting the entire batch writable. Fix this by respecting writable bit
> during batching.
> Although on a successful unmap of a lazyfree folio, the soft-dirty bit is
> lost, preserve it on pte restoration by respecting the bit during batching,
> to make the fix consistent w.r.t both writable bit and soft-dirty bit.
>
> I was able to write the below reproducer and crash the kernel.
> Explanation of reproducer (set 64K mTHP to always):
>
> Fault in a 64K large folio. Split the VMA at mid-point with MADV_DONTFORK.
> fork() - parent points to the folio with 8 writable ptes and 8 non-writable
> ptes. Merge the VMAs with MADV_DOFORK so that folio_unmap_pte_batch() can
> determine all the 16 ptes as a batch. Do MADV_FREE on the range to mark
> the folio as lazyfree. Write to the memory to dirty the pte, eventually
> rmap will dirty the folio. Then trigger reclaim, we will hit the pte
> restoration path, and the kernel will crash with the following trace:
>
> [   21.134473] kernel BUG at mm/page_table_check.c:118!

Presumably:

			BUG_ON(atomic_inc_return(&ptc->anon_map_count) > 1 && rw);

It'd be useful to be explicit about this in the commit msg.

It's also probably worth saying explicitly that this is about a
non-AnonExclusive mapping being mapping read/write as a result of this.

I'm not sure the stack trace is really that useful beyond that, as by the time
somebody comes to read this later it's probably going to be fairly inaccurate :)

Maybe worth just spelling out e.g. try_to_unmap_one() -> ... rest of code path ...

I mean the stack already misses stuff due to inlining so that'd be more useful,
otherwise I'd drop it.


> [   21.134497] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
> [   21.135917] Modules linked in:
> [   21.136085] CPU: 1 UID: 0 PID: 1735 Comm: dup-lazyfree Not tainted 7.0.0-rc1-00116-g018018a17770 #1028 PREEMPT
> [   21.136858] Hardware name: linux,dummy-virt (DT)
> [   21.137019] pstate: 21400005 (nzCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
> [   21.137308] pc : page_table_check_set+0x28c/0x2a8
> [   21.137607] lr : page_table_check_set+0x134/0x2a8
> [   21.137885] sp : ffff80008a3b3340
> [   21.138124] x29: ffff80008a3b3340 x28: fffffdffc3d14400 x27: ffffd1a55e03d000
> [   21.138623] x26: 0040000000000040 x25: ffffd1a55f7dd000 x24: 0000000000000001
> [   21.139045] x23: 0000000000000001 x22: 0000000000000001 x21: ffffd1a55f217f30
> [   21.139629] x20: 0000000000134521 x19: 0000000000134519 x18: 005c43e000040000
> [   21.140027] x17: 0001400000000000 x16: 0001700000000000 x15: 000000000000ffff
> [   21.140578] x14: 000000000000000c x13: 005c006000000000 x12: 0000000000000020
> [   21.140828] x11: 0000000000000000 x10: 005c000000000000 x9 : ffffd1a55c079ee0
> [   21.141077] x8 : 0000000000000001 x7 : 005c03e000040000 x6 : 000000004000ffff
> [   21.141490] x5 : ffff00017fffce00 x4 : 0000000000000001 x3 : 0000000000000002
> [   21.141741] x2 : 0000000000134510 x1 : 0000000000000000 x0 : ffff0000c08228c0
> [   21.141991] Call trace:
> [   21.142093]  page_table_check_set+0x28c/0x2a8 (P)
> [   21.142265]  __page_table_check_ptes_set+0x144/0x1e8
> [   21.142441]  __set_ptes_anysz.constprop.0+0x160/0x1a8
> [   21.142766]  contpte_set_ptes+0xe8/0x140
> [   21.142907]  try_to_unmap_one+0x10c4/0x10d0
> [   21.143177]  rmap_walk_anon+0x100/0x250
> [   21.143315]  try_to_unmap+0xa0/0xc8
> [   21.143441]  shrink_folio_list+0x59c/0x18a8
> [   21.143759]  shrink_lruvec+0x664/0xbf0
> [   21.144043]  shrink_node+0x218/0x878
> [   21.144285]  __node_reclaim.constprop.0+0x98/0x338
> [   21.144763]  user_proactive_reclaim+0x2a4/0x340
> [   21.145056]  reclaim_store+0x3c/0x60
> [   21.145216]  dev_attr_store+0x20/0x40
> [   21.145585]  sysfs_kf_write+0x84/0xa8
> [   21.145835]  kernfs_fop_write_iter+0x130/0x1c8
> [   21.145994]  vfs_write+0x2b8/0x368
> [   21.146119]  ksys_write+0x70/0x110
> [   21.146240]  __arm64_sys_write+0x24/0x38
> [   21.146380]  invoke_syscall+0x50/0x120
> [   21.146513]  el0_svc_common.constprop.0+0x48/0xf8
> [   21.146679]  do_el0_svc+0x28/0x40
> [   21.146798]  el0_svc+0x34/0x110
> [   21.146926]  el0t_64_sync_handler+0xa0/0xe8
> [   21.147074]  el0t_64_sync+0x198/0x1a0
> [   21.147225] Code: f9400441 b4fff241 17ffff94 d4210000 (d4210000)
> [   21.147440] ---[ end trace 0000000000000000 ]---
>
>
> #define _GNU_SOURCE
> #include <stdio.h>
> #include <unistd.h>
> #include <stdlib.h>
> #include <sys/mman.h>
> #include <string.h>
> #include <sys/wait.h>
> #include <sched.h>
> #include <fcntl.h>
>
> void write_to_reclaim() {
>     const char *path = "/sys/devices/system/node/node0/reclaim";
>     const char *value = "409600000000";
>     int fd = open(path, O_WRONLY);
>     if (fd == -1) {
>         perror("open");
>         exit(EXIT_FAILURE);
>     }
>
>     if (write(fd, value, sizeof("409600000000") - 1) == -1) {
>         perror("write");
>         close(fd);
>         exit(EXIT_FAILURE);
>     }
>
>     printf("Successfully wrote %s to %s\n", value, path);
>     close(fd);
> }
>
> int main()
> {
> 	char *ptr = mmap((void *)(1UL << 30), 1UL << 16, PROT_READ | PROT_WRITE,
> 			 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> 	if ((unsigned long)ptr != (1UL << 30)) {
> 		perror("mmap");
> 		return 1;
> 	}
>
> 	/* a 64K folio gets faulted in */
> 	memset(ptr, 0, 1UL << 16);
>
> 	/* 32K half will not be shared into child */
> 	if (madvise(ptr, 1UL << 15, MADV_DONTFORK)) {
> 		perror("madvise madv dontfork");
> 		return 1;
> 	}
>
> 	pid_t pid = fork();
>
> 	if (pid < 0) {
> 		perror("fork");
> 		return 1;
> 	} else if (pid == 0) {
> 		sleep(15);
> 	} else {
> 		/* merge VMAs. now first half of the 16 ptes are writable, the other half not. */
> 		if (madvise(ptr, 1UL << 15, MADV_DOFORK)) {
> 			perror("madvise madv fork");
> 			return 1;
> 		}
> 		if (madvise(ptr, (1UL << 16), MADV_FREE)) {
> 			perror("madvise madv free");
> 			return 1;
> 		}
>
> 		/* dirty the large folio */
> 		(*ptr) += 10;
>
> 		write_to_reclaim();
> 		// sleep(10);
> 		waitpid(pid, NULL, 0);
>
> 	}
> }

Thanks, having the repro code here is really useful!

>
> Fixes: 354dffd29575 ("mm: support batched unmap for lazyfree large folios during reclamation")
> Cc: stable <stable@kernel.org>
> Signed-off-by: Dev Jain <dev.jain@arm.com>

This looks correct to me, so other than nits around commit msg above:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
> Patch applies on mm-unstable (9af4957ef127).
>
> v2->v3:
>  - Don't special case for anon folios
>
> v1->v2:
>  - Just respect the writable bit instead of hacking in a pte_wrprotect() in
>    failure path
>  - Also handle soft-dirty bit
>
>  mm/rmap.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index bff8f222004e4..5a3e408e3f179 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1955,7 +1955,14 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>  	if (userfaultfd_wp(vma))
>  		return 1;
>
> -	return folio_pte_batch(folio, pvmw->pte, pte, max_nr);
> +	/*
> +	 * If unmap fails, we need to restore the ptes. To avoid accidentally
> +	 * upgrading write permissions for ptes that were not originally
> +	 * writable, and to avoid losing the soft-dirty bit, use the
> +	 * appropriate FPB flags.
> +	 */
> +	return folio_pte_batch_flags(folio, vma, pvmw->pte, &pte, max_nr,
> +				     FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
>  }
>
>  /*
> --
> 2.34.1
>

