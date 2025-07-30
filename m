Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAF09C87FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 13:00:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44BFA6B008A; Wed, 30 Jul 2025 09:00:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FB0D6B0098; Wed, 30 Jul 2025 09:00:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29BCB6B0099; Wed, 30 Jul 2025 09:00:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1A3846B0098
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:00:20 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CBBFD1A03D1
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 13:00:19 +0000 (UTC)
X-FDA: 83720939358.05.012B5B0
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6ECA8C0002
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 13:00:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rzxbByau;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ube9vPf+;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753880416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UNVg5dMWe3BoNvxedXWtKXpTemxosbKKD7JBPTs500o=;
	b=wsGh2RR+tdkoqept1LeKwwFaKQm7J0ujRGAjFwe1xMIUDhMmbs/Y68JCVcGN87lYO5tfeh
	9lz2yHxHcVVn5kJENV1BwjiqD/1B0EUZ8t1B9nwITkWZMb2y1wE8Sa1rAgLDpQL+V+oXNv
	+9zf1vK1PFYAnk6+mY2YQbKFVZNinyw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753880416; a=rsa-sha256;
	cv=pass;
	b=rUuEx4qtIJin22xRpjPHKvM83I5bHq0IS5GS+1vWYyJFUB/dvExiz7obY7HYQ10dI4tafe
	nfw/Kn+bX12pmyFCBlV8RHra6g7kwHrWfOh//PKNLAEDlZtjHQNZjtmCTykuNPHRGLtVuo
	b62a3RSA1JMkXDAnIhclLCuSxRy0Y4s=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rzxbByau;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ube9vPf+;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56UCuBK0001173;
	Wed, 30 Jul 2025 12:59:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=UNVg5dMWe3BoNvxedXWtKXpTemxosbKKD7JBPTs500o=; b=
	rzxbByauYydpj7gxbJyAJsmBw8jk2uPG48XmhFGzE4VYgl+HE73sS09c3ImS1sTb
	3IES+mXp+5xILJt+xL29/QPAaFlnH6Vn5GkdzNbNCY/Bn8NdXqrGx0Jfp1styZPi
	zlNj5AVYO6K6oynBJbiUcFb7u3I8EBhCq66fc/KDRCKCYSRNE65ZOZotF2OQMryl
	fhQ7alQeyXBGOQJuckh+9jKOcJODI2z6o2Qhki9fVMmxXE7DZ9j2qDGvr4DQ+79K
	OnbdfAEhPOoR+Zypskg2ocYxa56ZI4VEG5mAlDSZUKvvzpCd7/5mGqbmJK1rMtz2
	LDe7uc/KnisDugWsIYizcw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q2e212v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Jul 2025 12:59:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56UCi3RA002984;
	Wed, 30 Jul 2025 12:59:50 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02on2049.outbound.protection.outlook.com [40.107.212.49])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 484nfb6kdu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Jul 2025 12:59:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qYmGR6xX8Qb6omT/jOhqkiOr5CGWB7zQyamZvsi72UUdtvg0YkFs+m4w0XY0R9JBaZCwjpL97jALXnle8VhanoHjlGy20G1FQIKNb+9pyBJOpnEcvcaNvx5kqCq/XDwPNtRlvF2FR375VW8DnLRCjLHBdI+/DN0rn3ihJ+WFd7pcRHggnce9YJv41l97uDELXRhSKiyCnZKpT6aFat8hT2DMquLcXxmkkAINUqSMTc+oGNSzMOoirlUBXmzM2LDa4E4CTRKTFocCLTWhovSKOVgRo258/08xfdhcRXbIA4WCoiOFXd4F4OFHEW0/3OmjQMmq/sVrCFsF1XOPgL29MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UNVg5dMWe3BoNvxedXWtKXpTemxosbKKD7JBPTs500o=;
 b=iI0zny+kF/vjPCvu+ml15WpnIET4QIrHG8DH/dhqM5Bajg8jhSHZd2PeIsivigBkuwz15mdHfGn6Zi4reLW5blBxx7+BSbBF58DBrR9MwbQXwkkU177Y8lHHcq99fugWQwEt+Lq6dfUzwMu2iScMVkgSDfoV3owummQLoOTKuON+OsipgUGXWhctJT4VzX5Wr7exQI6G4hoBFQ08yXC3Ox9Tvk+0OePYtMHFEYRqZH/1qhv+gekhQ2PSQ7djLdjyKGbGT1UqGrAmgNkq2U+7zgwzudAvizRT2h45pd7slbQcVF2XiXmhL/X7BENR0CdlcWdwptm2bIdVnGOaGTHw2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UNVg5dMWe3BoNvxedXWtKXpTemxosbKKD7JBPTs500o=;
 b=ube9vPf+C8s7YPe9WfgFCiD+WlFRBN3m9yZy6mq9G+RCM7qCKyPtu4B+CgdC9QOCN6qEVlVYu0Xxj1tj037f9OIC2VvMsb71An4uR0IXiQHc8HVw279eZ8WlaY80caanMMTMjz5vVG9dicGlKajSibeB9HwoJNr7aypbjcRwpyc=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH4PR10MB8004.namprd10.prod.outlook.com (2603:10b6:610:242::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Wed, 30 Jul
 2025 12:59:42 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8989.010; Wed, 30 Jul 2025
 12:59:42 +0000
Date: Wed, 30 Jul 2025 13:59:40 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Zhang Qilong <zhangqilong3@huawei.com>, arnd@arndb.de,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, david@redhat.com, wangkefeng.wang@huawei.com,
        sunnanyong@huawei.com
Subject: Re: [PATCH resend v2] /dev/zero: try to align PMD_SIZE for private
 mapping
Message-ID: <01f6f594-8fc0-44b3-8bbe-7dc35cfb7299@lucifer.local>
References: <20250730091905.383353-1-zhangqilong3@huawei.com>
 <aIoU3hO9JBAyuTcy@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aIoU3hO9JBAyuTcy@casper.infradead.org>
X-ClientProxiedBy: LO4P123CA0492.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1ab::11) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH4PR10MB8004:EE_
X-MS-Office365-Filtering-Correlation-Id: f759c807-21b6-4427-bd77-08ddcf68f37d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aUkray9yQTRtUXdpdy9EYjdJT3Z6cks3VVFpRitEbTJWelZNQlNCSmk4Y0xm?=
 =?utf-8?B?YVFJSEZPWjU1UkdWVVZaY29yMzNiM081U1p3aGd6c1V5Rmhtclp0OUxpWktq?=
 =?utf-8?B?NVNZa0tPK2o1eFdYREVMckZTQWkxOERZZ2Mvb2EyNXYyZzNkMHlLaWptb0hq?=
 =?utf-8?B?SmVTcnVqd1c0bGJPZ2JkZ3k2cU94Q25rQVQxQUZIZVpvVlI4U3UweEpZR2J4?=
 =?utf-8?B?cmNkbEIrRDB0bVZ5a054R2JUZ1FHVTZ5QjNrMmtOekdjWGJqVG9JdzNZb0xX?=
 =?utf-8?B?OGJxbnRxUERVRXRCSHdTY3RDdlY1T1hUd0dQS1JEcElQSzVXdW0zU29ESk54?=
 =?utf-8?B?UUdhNEtyR0pIQ3hSNUVpODRPWHZOQ2FiOEU5eWdQNFNzdXZ3TXdZNFpHL3Zy?=
 =?utf-8?B?aWNEa3NsdHArY1NJRDFzMGdvVTdSTlFyMGM2VVVrRkc0Z0N6VDBUaTRNOVFq?=
 =?utf-8?B?dGFoTUpxbUtpUUF4Z1lXdjBidVJEdHpoeURVY1Z1d3E3Skh1WWxINlFGV2t2?=
 =?utf-8?B?dHRMNXdncmhwZGlLU0xTcHdTZm9iWTg5R3hMUmZDVDFQZmdhYjlydHllQ3Mv?=
 =?utf-8?B?eVJybkxobXM3WkNSMWVTUHdqM3FDdnFWU0ViakY3Y3VaL1ZDd3JLdzMvVXE5?=
 =?utf-8?B?QjZlUUdKdjV5Qk4vMWJTbGNEazViUy9QR1BJa3V3N0RrV3k5L1p2VXduajRU?=
 =?utf-8?B?Ty9WcHROcml1dUwxTEh4Q2IzQmJ5RVJqS0V3Z0JOeSsyZHE0emZoSlY5dm5U?=
 =?utf-8?B?ZHdzaDB2SzBxajhzZnVRbFJxdWtqeC9xRm9zR29LV2RGWi80K2M2NFpkMlhX?=
 =?utf-8?B?T0liUDJiWFJVQ0tobUcrL0lQVEJKREtVQXo1UStpZDJHaVNsRWk5d1krUDJ2?=
 =?utf-8?B?VitRRVpuZkcwMjErRmJ4ZmNMYk82TkxJYnRNOXFsUUFJV3lrb2ZoTWNna2I2?=
 =?utf-8?B?L0l6VWFZREp6aTkzMmYzaUREV0NPbG82TnJUaUdqVUpicVpUb3VXcGZFUjhl?=
 =?utf-8?B?bG5RUHRTZzhHaHlsd0dDL281S2VmSXFRVTlFSHR4SXNia3F6ZHliZExrcCtt?=
 =?utf-8?B?b2tZOSs5dDg0eWxGWHR1VFRKTWhVT2RoMGNXVTByWllrZUxQNlBsRW4vK3hv?=
 =?utf-8?B?NSs2M2NKTlMyenk2OC8wQ090Y21uZGdPQi9Fb0pVSHdpaHpsVy9qeHFLenJN?=
 =?utf-8?B?K2IwRmlIdlR4Y0VHZXlpeU1WSnhYdXJlZ25hS3ZBdFk5VTVWdUJ1dDJZZG0x?=
 =?utf-8?B?RWV2M3VxMUlZWU9Tb3NmMC9JZlZabkFqemZZZC9hazlucnFrWE1aTDJ5UDRM?=
 =?utf-8?B?bHlBVU5uYkdiZjRoejlqL3hDOWxldVZQSk5uN0NoY3V0SVp2OWxqRUNCcis3?=
 =?utf-8?B?NmgzOW95KzRUSHNxdWxzRFpvWGxyZEt6bEY3M3cvWFpraXJXNm5Rc3N6ZkRO?=
 =?utf-8?B?V3g1SERkZmc3M01qUVlRbGh4R1lYSzhQa3ZEMjlLZ0lkcFd0VEdva1hZTWR1?=
 =?utf-8?B?aXpPemJGc25BMzh0UnpSOVRrV1E3SkQ4U2c4d2pTZ0NTVE85UEFUbWdZYVg0?=
 =?utf-8?B?MldvQ3hLQ2NlZXo0QjFWb2VjKzd0cUxpR1FqK2NLbUNrcVZmTkp3YUM4Y25O?=
 =?utf-8?B?TlZSZVNwajI3K2FoeWx4UFJvZWQ0cC9kL3ZqdU5sR1FteFRVZmJob2FIckcr?=
 =?utf-8?B?dWdZUGU1bnJqODlveWI2YXRuaEFLWGhxbStvYlRBTHpiT0Y2NFlpYS9uNlJ2?=
 =?utf-8?B?WjlJQW04N2FNN05IT2JkcXdiNmZ3MHdNMExDa1l1Ujh5Q2RxT0RhNHZIV2ZG?=
 =?utf-8?B?QmJoR2NwTC9zMk5IRkxTdUgzRjEzTUxaTEVTOVZhSHRKM3VocXU4UUNqVDc2?=
 =?utf-8?B?Q2pnQ1VRMkFMZXZnUGplMzZScndTajBEbzhRT0g1alVZQUs4Nm1VSkVHa1hi?=
 =?utf-8?Q?azO1x5ng3zs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bGpFNHJJRE5OMVg3U2NqV0paNGdkVGJEWWpzUW9zdFhKZUY5a000SFNWK05a?=
 =?utf-8?B?VDZOMkhnSTFKd0VXMTdtbmphSURRYjJuYzVCdkMyRnJOT1hoNWVuamFUVlVR?=
 =?utf-8?B?NlE0Mlk4L2tkaDJIT2F3M3E3QyswZUhRWWdUMmFNVlhYbGtoa0QwY2hhbEl0?=
 =?utf-8?B?WEFzbVZlM0p1WktRODl4dGFtdnpvQy9kelpybzVXaFV6b1psTEdDZGU4a0l3?=
 =?utf-8?B?RU9OSlNVNnp1M1dXQVBmVU5DQVVzT3M5QlE0ZVFnZzFMcEtUcjdlaDNFU21r?=
 =?utf-8?B?MkhHYUJJV05FajU2QlJ5QTg4ZnBJYTFWeVk0SjJxVEppSHBUdDhGYnJ3djda?=
 =?utf-8?B?TFdyYkNDTm9wUVoxc2k3enY2NjFwY2hNTzRXOXdCL0ZlT1hVUXh0OUY1dkd2?=
 =?utf-8?B?a0hFQ0I1NmNOaE9PeVdDeDM1NW91VmdGRGZpNENLRGZ0Mmp4VEx1QWxoTFN2?=
 =?utf-8?B?bHB6dGs4dmNjVHlvYm1wNnNqUGdaV1NYQ3BGOTNuU3lLOGhFM1UwdlBUYit3?=
 =?utf-8?B?WFk4R25JTzh6WXJxN1Z3SkFzUWVGK2N0Q3RvazlPWGNWcFdmRkwxK3o0WXFm?=
 =?utf-8?B?elZGZE1CcHI1NC9VTGQrcFJpUCswVWlXeVJnRi9UWTNEdlBZMFA1aTE4SUM1?=
 =?utf-8?B?WFVmR1hXOHRTY0NtcGNHZ0hrU2ZJS0R4dHJaVzNYT2NWVUZJRWtPYmt0OEp5?=
 =?utf-8?B?Tm81dFBwOXczRDIxSVZSdTZqaG1WWlBxUGgvbHF2MlVvNW5VWmdKUkhOWW5I?=
 =?utf-8?B?WlBLUG8zZ1VLVTlJOC9IR0xQVXp6TGdGZk9XOGt3V0dKdlZvVFVidTRJWXFM?=
 =?utf-8?B?NXVZU3kwMldicFB4UWRFeUowMTBzOS81OE1laldBblF1dW1oTTFGb2xNMncv?=
 =?utf-8?B?N1BPcGNMUFlGSWxSM0V1VFhrOUhWVTgzb3FwM1k3MEQzckVXUHY5Sm0vQmV1?=
 =?utf-8?B?Wm9EZHpJYUtxZ25MdWd2R1l2UWhCMXFjbWdzNDY4YUlKcjJFaFBkMHRYRHpH?=
 =?utf-8?B?MStOSTZqTEg1dTdLMzZNaTB0alpKbFJES1V3ckN1MkdkVmdTNHMrSkM5UDJL?=
 =?utf-8?B?VzRmUzJJQlJ2aXc0M0k0Z01Bbkx4SnAralBYcDdWRVRKMURMb2ZUd2QzYUZH?=
 =?utf-8?B?T3ZlS2s2YjNwMW5IemwvbmNBMXppUFhFQy9PaVQ4bFRHdEdXUDI0cCtqYVhQ?=
 =?utf-8?B?UlFyaTF6Vk43M1VjQjAwL0xydWZHNkhqcGJidm1qd1R0dkhVd1hOYWpmYXRw?=
 =?utf-8?B?bW8xdWpRNmdxc0xiZllQaE52K3IzQmhzYU5XckRCOUNLMEQvZUdpVlVZK3Qx?=
 =?utf-8?B?M0JIMFEzZXZVZFR4SWdjeklHUW0yL21XK2t1RGYrNmJrSGxKVlB2TFIrZEI0?=
 =?utf-8?B?bnppRVhkbmtTRndUUytWeGxFY1dZcWxDRVBPbEtiQlVxQ0xCbHFobUZXcmhH?=
 =?utf-8?B?SnMrZE1HNi9aZWF0REpjTkNPeVZLKzFkYzZuVXR4UmR0VzVNSG4yL2FuTklK?=
 =?utf-8?B?SGpBeXkrRGJFTENlUWQxOUdlZnUwVFBNTldoQzdybnVZbDhZRjMvQ1NNQkls?=
 =?utf-8?B?SnJ3SnA4NXZQQ2ZrcGNBOVZmQVJMUnNMQnFQd0NMY0VaVGRpbFZ3L2YzRGlo?=
 =?utf-8?B?TFNneFZXSE5NWFo5YTZ5eWhGaGp4WjV2KzhEUWZEV1ZHVGxod0g0L09MUWlG?=
 =?utf-8?B?TEJZYWJkdFplcWpEeVFNSVd5T0Rlald4cmQvOTQ3dVlyZ0k4aGpQcnJCZTBv?=
 =?utf-8?B?dFRzN0hNcDZVT1RHTWVNWHB1M0lsblRZSFZncUJ0SGc1UTFuSlJDSERzb3Ji?=
 =?utf-8?B?aUF2OWZ5K1hTdlF4WUVSeFF2UVdvMjE0ZU5HRisrVlF0Zk5GdEw1KzFGb1NM?=
 =?utf-8?B?WmEyeTl0aVdCbGcwSDJNVDlUNGhSc1NWeWdWYXd0RmRtUUZZeG9uNlFIQmhs?=
 =?utf-8?B?enFoWlQrVm1wN25mR0pDZU9NUnBDZlEzYjFzTG5uS3prNXREbmR4dXM4V0RZ?=
 =?utf-8?B?U1VtQmdaVkJxM1U4UHd5OUNlem5ya3VwdEh5NnRlQ2pOYWxtTE9OSFA0V0Yv?=
 =?utf-8?B?L0xXcnVpNDcyYlNOcUtPN3BkWkFhcWxxakFkand5b3pVa2pXenpHTnN2TUhT?=
 =?utf-8?B?VFl0Qm5WUlZ5aVlRWWIrY2syNFVaeU01VTAzMEJPRXE5UzU2WkxzUFppa05o?=
 =?utf-8?B?eXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hIlefFB9u4N3brWrZnN6OKmu+43l8eLbqryOi5MQY4sd2jINOOBuV2Mtzn1OcuxYZnwd2E8JGlbl9e4vDhiNtHBYQgkJMnnUq3RMx02W+gCpIIMAkLBsalT8az8TLXpilZQf+qRQkzu5U0HjhoNFYIHZH0pyNtONN4kyBCig9098Dq+ozhxl1+yxP2MFGfGrlY2GMnCdWESE+/x6rMqUEQVcaJuXURgONylfoAkv2iGrAX54rvSO5ldY2ZM+IMbh7B08w9YFXi2ssqqvsPIsvWD6qx36b+Y1ra0vJ/Vta1zDNIksi4njq8Oi1+nST2sKOXR8SSooFEmGKcYHaRbXwdAmh5CvGSQhjN+MpeGs+oyH8LDgbtMNPIb2wjdeLxByHJjTrz/6xOZMm57MO771FF2Ni8LH+QusmRa1h4vwjcrFQVE6YNdNtejRU6jhL038KjzCFCoxsMbXKPX/RYKZp73yKU/1b199uq+1PV6BqGtdseY7WQzU35AzBNlwlf/dS7JjvyzPNmmH1wBG5xp8zFYYsK1PVF/TCQxYOqtenepU0krkyQwl4NmiOZtRNfQaZD3EUlemwiLXa7+Q4T9yFCYKMY/1oRESNuM78+qBS10=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f759c807-21b6-4427-bd77-08ddcf68f37d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 12:59:42.5830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UYef7AIVSg/BnxYnsLWr5mMIit4m1K1/erwzAECVRTpsJXw580q2EniAcwWcX4XjbWiVVYA3hYi5Liwk9y3T1BIm5feTAOkPQvbjFgsW6j0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8004
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-30_04,2025-07-30_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0 mlxlogscore=517
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507300093
X-Proofpoint-GUID: K-awu7wGXB69aARsJxxYWjxxjxvhgWi0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMwMDA5MiBTYWx0ZWRfXzUDG4YmokvDF
 fR1+OMHpEjMa6pug2MIkXZh6H3BeVAMDyCOZxXl37t4HFTBKhGE13WWuIWre0j+OYD64EneBV7f
 qigR5yV3vxJxnHQj92Wv8r2dAEWNfpHuSQ+Y2qXBmR2Dd6QjKPIwNBe/p7ZjmHzDm9D9lbtuaAb
 T6/rMY8rTR8Z00ToR1cDAzsoIWuxeyVK8UcLVTCf1eFRGG9+JYkrWQ3QpmdTJ+Cvrf1rz7xAOYU
 UMjQhyxf2WCU4l7wbZC3DDa1P37mrKekhoIeON28gEupGY1HK06NiNPIVoZUJnUz7N8dYFg/PZD
 S/mQCMFrU4kSMfVQuzNaCTSwIMsWGcdsyr73vV8K7YYKjRDJlWMsn27q5MDM5Hw3aLaohMNX5bw
 WQnfI9a2KhwYkx76C79BVzOorBNkp7kGd2/tF1bjBFkC02BT14hJdGXGrRy4vOQHgGeKS83t
X-Proofpoint-ORIG-GUID: K-awu7wGXB69aARsJxxYWjxxjxvhgWi0
X-Authority-Analysis: v=2.4 cv=A+5sP7WG c=1 sm=1 tr=0 ts=688a1747 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=4XWDoy3f8Fg3diK7IGIA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6ECA8C0002
X-Stat-Signature: sebhj4yfuooxno54hpo73bnfpcufwr4e
X-Rspam-User: 
X-HE-Tag: 1753880416-225108
X-HE-Meta: U2FsdGVkX1/gpBmeJpN2VFBVNR1JnWNqHHUmUsein6q0eGpUQlB6bzegejwhl4hGQIbjHsza5OOsLVkfYcLkBGFWkFb6QT3S0ydAK2itprClWnSeMbcEG3A6PEebdGnTf18nhg63IvJFI/3qL4WJ8XkMsgODps7+5+9FXhzZdwn/Dmb+mkE/YX6Bh5movk3mYEXrpyLiAZ8jgpjV+iVxtPG0UeH9yMvr5x+u1wZfIOFFAj6eiVEfQWYKaRySz7/hESzeTtQwzboEr0PSd5B55jlKYDrVd5KEaMuwm8aCvcsA+ik6v2dLYIqI0moJeZ/I+4Qnk5srXeX/lft6oGYfwjRqT+JDEdERdXRANcLN2JIoTF4BeD74IJ4qJQzXtqyI8hl7gEHpJB+pbzSVVTo2i2TnQDq4/E0ZaFe93PjUUVsdRHChpkNWQkrraOpRgaNNW2vU9EQzvQu7RhuiUPtMPwLEczPQl72Fkg/Fj4UdBwYNv3xwu6Uxs2GPEQiWKp3LxxZmfJq/O2KgrS36zYUqjY/D+0CExnS2yqDwUn2ic6U3vfK7l+9rdmO0SIp81dtvvdTI320rfLKMMmXNG7v12ZPUvWB+AEoWz2/x27cI3RjP+50fLviXnlOscXRfRUdo7cGdJoAlRCtEgVrlHr6A5J43NUPeTueMBN2c8Jc6zg2N+hRM9J6SvwY6Y7EQTNDC9uOb1qvkntJQO7kyR+S/8F9YBZ8SipmxJWVwNKT/PmLxQY59piCSbtyYv6E1NmDhbeC3gm42yAqd9eLHbcgO2ynhmAtoDM5y9D13cju/JDoYPWn0NWgrgdD44BBT3+dBFCCyLBOTv1kOgsNtt7U5AyOgQwaT7VvjpdBL2W30zTcQz2OOlkMRf7UQlEjvyLt6OSkNhNmlj5kqigIYOQp5zI2iTmBFAN56d+qamIX2v7t1T3j1yYokyfSpPJwuN9uPoHIlSeejbIDrDnm1aD5
 lwbJuC1W
 OkKmA4jQoPUwNnbAkRKjMTOoPs0utE1iUiz3xyEAps+2OmNUiJuo816QsXfrdRhQX0R8r/YcT7/Xhd7RKfzjTKchNmw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 30, 2025 at 01:49:34PM +0100, Matthew Wilcox wrote:
> On Wed, Jul 30, 2025 at 05:19:05PM +0800, Zhang Qilong wrote:
> > +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> > +		return thp_get_unmapped_area(file, addr, len, pgoff, flags);
> > +
> >  	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);
>
> I'm sure the build bots will give us a compiler error.
> If CONFIG_TRANSPARENT_HUGEPAGE is not enabled, we get:
> include/linux/huge_mm.h:#define thp_get_unmapped_area   NULL
>
> and we chose that so that various filesystems can unconditionally set
> their .get_unmapped_area method to it.
>
> Which means the cpp will turn this into:
>
> 	if (0)
> 		return NULL(file, addr, len, pgoff, flags);
>
> and the compiler will say:
>
> error: implicit declaration of function ‘NULL’ [-Wimplicit-function-declaration]
>

Yeah I did ask explicitly for #ifdef here :)

