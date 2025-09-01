Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C4DDCA1000
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 14:50:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E11A8E001A; Mon,  1 Sep 2025 10:49:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 741DA8E0070; Mon,  1 Sep 2025 10:49:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 592D18E001A; Mon,  1 Sep 2025 10:49:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 28B638E001A
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:49:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CA814C08AC
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 14:48:59 +0000 (UTC)
X-FDA: 83840963598.23.EF4547E
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id 76E0E100007
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 14:48:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=m5uBKnNA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=t139Nu8J;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756738136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ilWWQc6WyCcSAe9T+uWygMqe1L/9zr8YKRUNIh5dQJg=;
	b=H1zIhmPvHOWpvBxrIkJjpF/AM5YFbZq+2fC6kLO8o80zVtCbloolRitIQ1e6ToXB/zzfLq
	Z9TV0RsCT+thYBMmVo1Be3f6WtD6eV0ZCPME2F1rPb3CFyrVERB2muStZZtOUXIUEovwDg
	svZxYL5rySJDJUDetFg1NB5MWIqUX0w=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=m5uBKnNA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=t139Nu8J;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756738136; a=rsa-sha256;
	cv=pass;
	b=2Wto9qj/OBu3dTAmsAR7TTqUmctiu8BwDPIpTOmP/m5thEpoMz68dSaFC9eZVg7KRhx/mb
	tz71OUgqKJzINqpmeotZxV0p4RWAdCTBA8Ci1R4OoL8mlBdXFxETg4vykMNPo36iK8y29J
	4XZxXusOSntVAh3XuO1GRqskdbxsa9k=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5815gP8Y026990;
	Mon, 1 Sep 2025 14:48:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ilWWQc6WyCcSAe9T+u
	WygMqe1L/9zr8YKRUNIh5dQJg=; b=m5uBKnNAJS+PcFVGgQfGYK/PgB134IsvWZ
	XWKjWoAXQSu9TbIErJ3e5UEyHXMpgDRNPqHEg9iwjpmRmEpUn30Ai8vc9m4QvtH2
	2oqKaH7kM0rjQuyKjtl9322TtZqMVghLO8nacDvRl3IUq1Ax3OXFBzj96+54CIN6
	+ghHqe4x36yVA/u+nCY1VEqPBeHGPDXFm1VHjXJhnrl8cT79tdvaNF9WwRJmNruc
	qSM+Q6zgmLpf/YjjPL9ARWmHwag/OjOiVV6eIrspg+OgdGmr3KJho+km3rt2MV09
	dneLwrVjXbtIzxTHHuSmJe00gFXqojhltLOPCIL9g4u1GLr7bSRA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ushgtjq2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Sep 2025 14:48:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 581E0J7B011665;
	Mon, 1 Sep 2025 14:48:24 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010046.outbound.protection.outlook.com [52.101.201.46])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqre8006-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Sep 2025 14:48:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=atrqN6bBafP5ELBffgJps/4uV59QDlwKrhloKf8tQUr+Xkb3IfNSwbHpJBxM8iWp1/bmuUbUscL3Rr3ejrJ6kSbast1JO5JUb/VmnnynXi7Ep8hY3dVL40Tu7e2Jwqsq5MfGVwSgTJUjHSF9B70N0PqVSE2CsheylHDjQTxbD4GF2p2o6FNMKXOZf4FSEbf3rMzG6CBRifMxjAa6aaRMzvBi3prysoy8WksrxBGmgNklZEp9/eY1h6cQw+5p7LQ0+xyWsE16H7eilK7Vl7BREDa4Ai102UekTK30j17lxcapuDuLh94B/kFZ1ASaCZbw7WZ2ki5kvPh/bF3sHi6Hbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ilWWQc6WyCcSAe9T+uWygMqe1L/9zr8YKRUNIh5dQJg=;
 b=ZAhdXd2QeinyXu779wvFVghVZqEjaI6vMEdeERYdSmUx8wFpceFGK5zwMb154EZb/sPBe9t1PxYzYEv/nDuj6Xly5Z/IlC8YL++M6OWNGLXqx8UCeSh4wSi8HIjfQOhTleSjG3v6AMtzCdyX2526qW8++pceEWAbg4WDYItWt06nREYHzsruMKNB+SZLDYW70zpOfGF9IAbP9PNmGz2u31fMuuBlWAEq7k4Uq1TbGdcK3r5EK76vjzSSScjc1KemsMzaJAI9xSiSOYwEQqBP7jM3cI7ZIKdbpqDq1e5ZSUlHnF4XblxbrD7w8ZKK5rUU84Ug7B+Ewb083k2EMMvzLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ilWWQc6WyCcSAe9T+uWygMqe1L/9zr8YKRUNIh5dQJg=;
 b=t139Nu8JBozTIFqC3moXWq6waswQcFS7b9cwrmnbqUJ2lDWE9h6NUzzqMHJDXieF8f8hu4OfY4YjdHzwDlTkl6JCBkPLJ2xvMPTB+xyNQs9VLUsVsCoS3BlGsgT2v8l5CFCnrm2lNf9M6S4kEKG67eS21YhflGR5d/VSQ85d21c=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by IA4PR10MB8709.namprd10.prod.outlook.com (2603:10b6:208:56d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.22; Mon, 1 Sep
 2025 14:48:08 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%3]) with mapi id 15.20.9073.026; Mon, 1 Sep 2025
 14:48:08 +0000
Date: Mon, 1 Sep 2025 15:48:05 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Max Kellermann <max.kellermann@ionos.com>, akpm@linux-foundation.org,
        axelrasmussen@google.com, yuanchu@google.com, willy@infradead.org,
        hughd@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Liam.Howlett@oracle.com, vbabka@suse.cz,
        rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com,
        linux@armlinux.org.uk, James.Bottomley@hansenpartnership.com,
        deller@gmx.de, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, davem@davemloft.net, andreas@gaisler.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, chris@zankel.net, jcmvbkbc@gmail.com,
        viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
        weixugc@google.com, baolin.wang@linux.alibaba.com, rientjes@google.com,
        shakeel.butt@linux.dev, thuth@redhat.com, broonie@kernel.org,
        osalvador@suse.de, jfalempe@redhat.com, mpe@ellerman.id.au,
        nysal@linux.ibm.com, linux-arm-kernel@lists.infradead.org,
        linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v5 07/12] parisc: constify mmap_upper_limit() parameter
 for improved const-correctness
Message-ID: <1c279446-23f9-46a4-bec2-6390c212dff7@lucifer.local>
References: <20250901123028.3383461-1-max.kellermann@ionos.com>
 <20250901123028.3383461-8-max.kellermann@ionos.com>
 <e695b279-0540-494c-99a8-987179979d58@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e695b279-0540-494c-99a8-987179979d58@redhat.com>
X-ClientProxiedBy: GVX0EPF00011B5D.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:144:1:0:8:0:15) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|IA4PR10MB8709:EE_
X-MS-Office365-Filtering-Correlation-Id: 944c4ab3-2dac-4e3b-1436-08dde96690cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?00XxB/O3P3/YBkXBN9y0KqH+9jHZbf1l8qVVxR5XGt0vMVduDvWc5mms7zXw?=
 =?us-ascii?Q?TziTPWw7SjipMyZqoVg7O6vpectTMrOiJ6mWbmT+PfQ37Pb7ZKgUMdffC7i8?=
 =?us-ascii?Q?XKQFYz3oJqJxSgwpL9XMU32FXJ5gG0Pt8slBk2rbYyDQpfPgfkMBbwo29Kop?=
 =?us-ascii?Q?CxtXhtPkkNMzCFuIrW0ps2BUcOadJwDPZbjAw18XvwUqThWJfPk5O5Hn2uNP?=
 =?us-ascii?Q?llk2N3N8NdlNTn3pp5kbVAtWJyNItpOi6ACwB+PYg/F7uVyL9PwvPiIQC3mI?=
 =?us-ascii?Q?4KlT3yDlba3Fbu1xty+GdFJ4DORb8oyL9JU+BcAX48qQLF2iFiGNlVfMvstj?=
 =?us-ascii?Q?CdPiwCRtN1va03H0gT1hjv5itdS/Sr2ez6K8MKLeaz5H4s1HWtqaZlramCOD?=
 =?us-ascii?Q?IXW17/bv+4FK1HUOdNk7fbekqOC+jNaPdE9diw8+danXalvolfSQPlBjdmy1?=
 =?us-ascii?Q?NJhp4BiCxiBOiRbyGrQQk308BvD7NngusPgG7X1gNcNPrKM4Kzvvw9RuY3Yz?=
 =?us-ascii?Q?IiV0ap91+S6kQq85NNsnNFc9hyJnay+xaZy2DdAnXIAaQSIX6GKg20Th4wBm?=
 =?us-ascii?Q?afZ8nRLPF7nPuZq+Dn11k0LqlFO6FDQ6qrI2K4AF9ItK7J4tB2QYJ6xNKMt2?=
 =?us-ascii?Q?ZdnhpA9HjUwHZenA0IWJpwIZDze47x8TIDiW44C9CrUSmT2W3nY7P3lCTSYT?=
 =?us-ascii?Q?cktc1eOXMqZmnIy4wrdhumypYVDxSpwuLd4a3pbYUUD0i4PkvIKrWNEKAdYZ?=
 =?us-ascii?Q?mpYWTlhd6qprTN/b6tKhscHrB1YND56mr0WTaNaGZXNW+WCIed1Tq8h1qOPc?=
 =?us-ascii?Q?tnvTn3QLyafRxWjTMv+HJwBoCysXYag39IEzU0o7dIxd0WomyQHdIeeLl7o5?=
 =?us-ascii?Q?Gz0ydOWuCf94e2xh5Oq8Lae9Gth0qMoqUTqBx5E2zKw4DuYChgCI67TCV+wV?=
 =?us-ascii?Q?D/lkIv1DkE++ImTReKwPvb1auuTLVD5s9vbsADesUI6hHl3Dvl9ELAaq+9iK?=
 =?us-ascii?Q?mgQfcOOdgZiWzfbRbyVonHLadsvR/A++o9ENPV17zKxy3x18TCC2SnilX2Py?=
 =?us-ascii?Q?joSwP/ZysUtYRdw2IbLj/vePvODZHXUwY0fPxQa5E1X2AG5Nkb1i0yrLC6wA?=
 =?us-ascii?Q?KIBelm6eYwgo9+kf6qgY0ZupmZXbBMa08Iwt6mAS9Wt6ERJCs98+p5yHK22X?=
 =?us-ascii?Q?zuAh7LcOXai95cwjzgWKgkRM8+pv18Kk2rgsf7rZgdvLSSpiqk9/RQ4cmH+b?=
 =?us-ascii?Q?GubZK3h25BQbwro9HrwNxdnNxxyvvjdLSi+V0YLY0vgJG/YnVhhB+/4bnJ3s?=
 =?us-ascii?Q?Y7rTvH24lsCs+f3QgTXC6RNfF2Gflcg6NqZaSsjZwSCmmRkoNnZxWafu332A?=
 =?us-ascii?Q?HPksFFQQveMHCQkc/qSuxHM0ARGz7cE9JkkHmre9qOYNtSgYKUkKDZkPkpP9?=
 =?us-ascii?Q?24FcxAEITZw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jw+U0Y0i+tcu8H8hz1vyMsgW91lz2c5NOkK+biWNqIJIwihnPzIku1kcuzgg?=
 =?us-ascii?Q?wOuAvSXVMF6OjnDc6IQ3K1KErecBFuEidEIUn5ask7o2xpTRxinqzj7EHtV7?=
 =?us-ascii?Q?CfTsf3/OaenTX0msvrQdQbP4Gr0CbjB1hWwgoCz6YAbFkT0aOHLda8FqOqzL?=
 =?us-ascii?Q?p5UDgqRVOstwlU1zjd3xMsZnrTa2m97UOfqDgAi3cTODGb32YlKv9YTd8YsT?=
 =?us-ascii?Q?LvhLBG+nm2ivZABtx9PiSHmqPHfgd6AOf5xIhJsVkQq1h8m7XTad7nt9Ff+x?=
 =?us-ascii?Q?zQKohND66onJ4eizCxyCSbZdL8nsDeeOFGMnZXzF+V8bLrYgVVYaBKgjJ7jR?=
 =?us-ascii?Q?vFNzrRAdrrCD0eSGxV00R5AUc9SJqD9AY/sojQyj5FyVvHT8xt7u2xYNFEy7?=
 =?us-ascii?Q?32TRG2NjoNPPPT8cH0MI/ikB/1DzKc6zI+ZYQiRjuxBiSYm/zCL1wtiWRUZ5?=
 =?us-ascii?Q?PqbrZkfaclAmB7+I4a12iS+NWOGHmbO8bwNEMh9IAGMarNzn4DWzAoruv6ub?=
 =?us-ascii?Q?H9XPBw6cf7JdzkZdX/iIteJbqHfhPGjSBBdum1SH5zw/d6FmBHJHwbnWJuNY?=
 =?us-ascii?Q?+6qZk2glpy6uOteBX0uB0JvaAfa+q8aCMuS402I4p7RcydNa+2M2XaN5iyM5?=
 =?us-ascii?Q?xV6X179LOo99Ujl3hv3GugyhU/j7nt7u9ZJK9bVy7DkqcVIyteE/mAAurrdn?=
 =?us-ascii?Q?ZKYhf19LhQufVR7jPGcKK2tbSrjnsv8Sun4YsJ/XJe/9WhwA8/j2MU5q3sel?=
 =?us-ascii?Q?DeONdH9w+B+1NDY+LBZ9exz8kHGeMckJTCc27yFMplIcbkMK87WL6+6YcJ4B?=
 =?us-ascii?Q?jukqEY4nlH6WwL2+BkXm9rYxRxfkzAD4W/3PjGnZ3wtLV9Vx2efF/3fd8Jqc?=
 =?us-ascii?Q?W6KmguIpOwhD64FvXfT7podwWpHFDnLFHfjx6TBBwJzzZrlaSQTdY3zi1jTy?=
 =?us-ascii?Q?Nb3J9kTumjki6XcKuUEE/8tHvMztVljC0TDJtLwRkmLENTDxcNV//E6AILqb?=
 =?us-ascii?Q?Cuv0vncAZqY4x29pHHUIW4ehnCu3eX6L9uTe0oCMNkJjjhfQOgQP6tQMEhtk?=
 =?us-ascii?Q?iS1v05H9oC4vKXJy7uM5W0BNxPDk1L5tpQHper14JdHRRpJuSTMLPihYG32D?=
 =?us-ascii?Q?1tdiMdpA5URwdODzecCM9Hc1Zeh4E23CUNCyM/xoYgYuAVbVPH/Kl07SyT5s?=
 =?us-ascii?Q?hqlzCR3EJOWW19CvFakwbX2CdDYaHDtbbwrPImQlK7nN71bK4nsB4OgYYqA6?=
 =?us-ascii?Q?96TonD0rozSP9sRVeoyIDUCS8nU9puyP4HQ+fq3V9Cz9MdMcqmA2Ra9Qzg5Y?=
 =?us-ascii?Q?r1ri+HVcywzGoHaMLRQN6j3WbWQbwsk4Qo/z8Jf8hgxBmjAvzWEcFDCTZ5uq?=
 =?us-ascii?Q?sjYvx3WrNWCdshaDce/WS31ZEp26Rc0grUso0IkYYUZDOsQ140ZPPWrKtH+k?=
 =?us-ascii?Q?yW+c+IpfUbyHwekcvAoKMLrujDZ0qrFzjqg/fVsHI3qME2zwbtyTZtuegsTv?=
 =?us-ascii?Q?ugaam8/Zm1RpMTeZQfZW1fPvDU9S8CHNnXrrMKBpEJEd/kKIrW4uGvQViBtz?=
 =?us-ascii?Q?qOZjggp99wIs6zpRoZmpTErWmP3w1v11Hn9HkKy4k1CIj1fVMPKwxH00adPA?=
 =?us-ascii?Q?cw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OVVhT+3ulGPc6kshG4U1tSLqtANXh/aCnenfDwVyMrahHnGXen63TrCFSDZoEFoSyUIojmA6f5wPjJmtEtvw6xW8kah52yxE0HatdknHVsnDdC+h6Hoss7qoW15Y7n9LlWs2xSiDZK1oXjtKrkOh7RumRkN8jfOxzoATbYTcT7W8JFp3UOkq0qSPSgPYRkBlF0RrX7W3dr7VJjE1V8FLJPXOIBWlPMH1BrQ+6u1eIoSq49BjEOZGY7LcvRwdO9GrUuPJgahwUxyv+JFJ9DYBILz36PzwfYRwO9qXvYjyNJotwtdDg4FYMld+9x5ZjArsn6WP4ZvbzD5nNAmbIbpixNMI/4fQg+OFAPim+DQ3hxUZO3n1Z0f4NTIDZJTHSYx1dloSq6IFApCF+laXvQvocmms968OJSB5AJS9iYeAwB1WLgUCGcvBUHXnfN97mGR77Slz6m1By9F5MtYy63u8ZuKeGEG4GL2TWr5Qz/kYmOio+htCLZ3vm9brMO8Iq8yB5qgxFZcmSVKnGP9OGPojt5T3J4mejeOzyn78GogFj9AH6KRE9UF6m/zsskYjWnXjKv0OwtVZ6B9qjJocXoC2V08GeVPe3CKayKTTjNT9JGU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 944c4ab3-2dac-4e3b-1436-08dde96690cd
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 14:48:08.2369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7IzpmJjmpCgVk8121gZPdayQPMHPqlfo6+5k7qXwf/0KfjDhxcomsIBR+1Ol4ah1X7jKXm7WMW1lfBfvW38JE0FNxQBLYeShvLyiwi8nzWk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8709
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-01_06,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=974 malwarescore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509010157
X-Proofpoint-ORIG-GUID: D4WA8wpmU5uO6juLoIaXyiQZXVKGoBJp
X-Authority-Analysis: v=2.4 cv=YKifyQGx c=1 sm=1 tr=0 ts=68b5b239 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=UgJECxHJAAAA:8 a=pGLkceISAAAA:8
 a=sXzRxonBVRT1uE2SJDYA:9 a=CjuIK1q_8ugA:10 a=-El7cUbtino8hM1DCn8D:22 cc=ntf
 awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMiBTYWx0ZWRfXyAKYjxr88wGk
 N4LdGL9Jv7Suv3PC/GwVKvWyVCYbjQEtaEW9bxV1Z6UyEbDW0w2fdJF7rMIG+LQVA7HlTWDcwta
 dXh88IJusjtzH1mM2seVPivT7acxifX55pKJ9j8N/IwRZ3VO0CHaMXFPogfMLqeE+c7v13//avk
 Rrm8jp9XlGlGgqd2cFivV1TU+rfDzDHxPahG3EyoRl82JjeeauY9R87qPH5fV1HLFtens0pHB8m
 wQ5gvjTtOFxFKazV4XnmG1Q8YSXZoXFSBVUzs835IsX3oXd6avoE5HUcmIagjS5MXYpjpmPBHyQ
 GnMseYyPMQSnj/tq3vijxvxhbCykJporYKXUpoS3zU20TeZMPqALGyxDoR0xOp5CAyJLpnbmxwW
 qAe+rwXZIF1ded7TGCpnJfRjkBIaLw==
X-Proofpoint-GUID: D4WA8wpmU5uO6juLoIaXyiQZXVKGoBJp
X-Rspamd-Queue-Id: 76E0E100007
X-Rspam-User: 
X-Stat-Signature: d5dyxx3e6yoqmefap3t61tczjzqf38fn
X-Rspamd-Server: rspam09
X-HE-Tag: 1756738136-259962
X-HE-Meta: U2FsdGVkX18klCtmcTCIMP1a3O1+dBdAewxleeh1wRkiApDpYR/WDoG1C7ifLQh2IRYmvnUuweIcUdL0852OeCHDaS/1B7bdqgEQC3hd6IotYRCrFJ8evb66fNCul8KCIlMmz06itlpo6rypKxn2BvtKGK50HdzuIGt3Y4zNflLp65iZFHCbSI5b2ztHkDAhOgwk0C5HHzWIGpSbAn3rvjCxJkgJtmMYr5YPVvoTwCLgWfLrZIoPpsGfCNIhTqWDxq/byu0zmOgH12JZxoFdXG8uDkNV4HPUFrF6fJtDB7LNBgsm6MwVz3Q5fbwa+inWJhvHcArXJ3P4D7x6bLKT12fYd0UobfQO8a4UWmg3BWgAuRys56AahT3jrnxtOQnfiSyJNur2oMFeyjKCC7SEffXK4Eu+oChyCbugi1hDPivwmecfIk/y6KTpHY9sZ8OjTp4R/fkvXt+yQQjWWbzCyRAUxhZSP7QkUkoHokx9SVTGFWEGfYDnryLRiX8c7rpwey+HiaRMGui+sIjtFbVgfS7SNWmKzh5sRgmTe5cqK/3TeN4ZqWh9hA4wYhlQAs5gkulKFuCbGpBYdXB2Bof/1Dtj6lQDzoRPFwL4/Dus23dFxo1WKcE8v8NJ4d7yiQSZl1BGU5IfEywus0+UmhJHyfhx/k9VvXQbyC2R89FHPg6Su4nwz+wmutsV9ZAUkvsWuWZRNY5PQM4tyu6wP6uvTUWNE3uHT6a2LCKfF4uMgM5rRU/8c8PyBBpqoOUyDBwZ7hRAmE8Bui6MohgIbb86ErV4dPMDd7gDTRfXUmm9hbtzqaxerpN8B5qj2hX2uKeQv7AkgYvVKfdMSSaX+OCQKd+mMVdEGF2n3DCDU0DZcDTCvSDoIQjgdwSTNEGIEdOvKuAnz6VPwMo8azF/gbHXe3W/kYrMKMSrzR1dRXqvWrfuJAmRZ5A1FpfF2EFbFjBJ6tEgQf7OcGFkKev0iue
 kcrFCjkS
 d96clQtk0LdcIyWuDwRAxhgoCTgTyMILQiYnHoV7YmVCNv7qQccd7mTgh31ASMXZ6ZFQbTecHtqLXvTln/4sVN1DunIcDCkvvGy9CIezImHP97mfXIvi+INim0wixbvkPpa3DzyYu/ZOYRkPBrghS1qC5h9h0i0iskV5QGFsv7Y6HxRMb0VrjNcp4tsyycNlNhgA8JzF5OX1Eeudg1mdceRM6i3uVpI380a+1cwgu0PXQFEDCpvEoaZuq07J/w4qefFOlZX848ai0IjCMq1rEnOlHcYbmytG+5cyM4ZmauPRZkczAPRlEHSfxPH1TwNfL61kMDeygmmD5HRag1tfXhQ/fr/s3/M27MHVnobNsYD7Pu7dAjQKNmsIC8bsX/LhDB3wchB80rTfPxCJjX+XyV6Gytp1cW5+YTBpWZAz0O2yGa/ym4Mn56AbfeYuTKjYQUMJCM2RdYFtW0vQTa86i2K2umHOL6wv0eUdFYQ7s/J6KroSEVB8LxnRXF1X/0TDIOGP+sWHlkdA/5ys2sMucKigxrmFcRha8fPUn7vF6Pz6H0HuFJeiYfDFXFHVF1mnWYt6f9hHRjnKta70dIUSp9NHWm1qktcjEpfcFVU71QYpdJ9pZf6Gdf389NXB15B1zNLIe26DPO/MrVnD79bmow8VT0ppk8d3FO6KDYPse6iYgRf6vETli8zh5Hb11/CI2y5HOnMPNNRigPhAm9VvKinoGAG2klarvoxVRYSQ6/x0vHswWbXzu8ovjLJSQhfgLtUua4k5K+uwI+FLx3x4v5wE7GQ8et5TqqI0qWeidcOGo/wd+vuXLNjvWikhslH+PagZ7Y+sjWq3xpyeNgKrSc03UbqrpI9N4KySbVp/fD0aEPQNvGxNHmHxFva1rbIen9E9uHmTh+feE7UdjICOm8Y2dyhQLyTVmpPrb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 01, 2025 at 03:55:00PM +0200, David Hildenbrand wrote:
> On 01.09.25 14:30, Max Kellermann wrote:
> > This piece is necessary to make the `rlim_stack` parameter to
> > mmap_base() const.
> >
> > Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> > Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> > ---
> >   arch/parisc/include/asm/processor.h | 2 +-
> >   arch/parisc/kernel/sys_parisc.c     | 2 +-
> >   2 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/parisc/include/asm/processor.h b/arch/parisc/include/asm/processor.h
> > index 4c14bde39aac..dd0b5e199559 100644
> > --- a/arch/parisc/include/asm/processor.h
> > +++ b/arch/parisc/include/asm/processor.h
> > @@ -48,7 +48,7 @@
> >   #ifndef __ASSEMBLER__
> >   struct rlimit;
> > -unsigned long mmap_upper_limit(struct rlimit *rlim_stack);
> > +unsigned long mmap_upper_limit(const struct rlimit *rlim_stack);
> >   unsigned long calc_max_stack_size(unsigned long stack_max);
>
> *const like in the other case?

Ditto :>)

>
> --
> Cheers
>
> David / dhildenb
>

