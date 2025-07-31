Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D39E5C87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 10:21:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45D666B007B; Thu, 31 Jul 2025 06:21:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40E416B0088; Thu, 31 Jul 2025 06:21:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AEC16B008A; Thu, 31 Jul 2025 06:21:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 16A026B007B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 06:21:32 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 817541DB9C6
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 10:21:31 +0000 (UTC)
X-FDA: 83724167982.18.3D02E73
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id E1F601C0008
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 10:21:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SB4y3OBZ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=w6ZRRl0u;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753957288; a=rsa-sha256;
	cv=pass;
	b=RRN6HF2A66XroR1rfmwbCE6dv0bSiAF8lI8VuQv2kOFnii38vZDjfBHNdVHc7L8mggX14r
	VlRccQbwhnfVCnMMuSdSYGL6PsOukxjCt27kQOQSvgwC9uk0NACKYVjsRSSaOIg677y6uj
	hnk+E9G1Om/MiZOojqo4jUF9G1ila5Y=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SB4y3OBZ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=w6ZRRl0u;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753957288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DnMCMwvYdmuvkHKTYWeZsgtBZoZRZM0qwVtQ56ww+8g=;
	b=MkIBysoXLcMVfH+VF77O+QAMJOdvPcJGjeMZncf5zKyF+/1rPHmiqJkB2O0O75sG+JVmYp
	hmZl+OZ16kQ6IhS11GqllkansQLqbSdj6ZABXBlFFLAZhtxMrAAEJCeV0/lmDSyIdiO1Mm
	UdxTg62p9w9IE2c+7yL+7HUKMGjpUBM=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56V7C4eC008507;
	Thu, 31 Jul 2025 10:21:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=DnMCMwvYdmuvkHKTYW
	eZsgtBZoZRZM0qwVtQ56ww+8g=; b=SB4y3OBZpCMeeI1Edc3DM84e53q1kfD1mD
	ZRPTKsjEHMLNv+VjURaAUSVLEBxYL/J/yTXnwbrUMTKClkZNrqhBXDqTUxoa2doR
	D2S9/rbjjb40y6sfq4sJQQL7YelhHknNxA+bnLN6PeHJIRRifM/86rzhtR0mC9Po
	UNy1PzQ4UuvjZTuhFD39bv3gRaitoJPc42RMtEgzCbevOdEW2WhM4mqJQsdVF9s1
	48nVMfccZ9U/30RZBgXybksaVtUQikxaKEMUU6Bs5aUhx6ydTtsvMzhmk1U6T2qb
	31wPTj6WqSZLdyHH2U8JZBZO12+kr3o8IEvpUZqw1Kl6I437OH3A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q5x3n92-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 10:21:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56V8hVbp038709;
	Thu, 31 Jul 2025 10:20:58 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2041.outbound.protection.outlook.com [40.107.93.41])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 484nfc250d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 10:20:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BN3kd0fEfKPNOUU2YyINC1akiu3ccCvNKn//vfUZAQ0yoVTGd4T/PiNosCvdrearr34pCESYbtNVyYsxjRCjvflCOh+BvRqfBjBEddotXgx4UBB6frYoU6JFSBr0APX0c74SUA/bg1Nth3gR2hwAmtyhZvvTuOi3wtarBZqKNX1RuW1UlODKZJVwEwlMUsFFpNFV7r4DyZvXo5dmQTgwytLPiM6VwX7Wvs/HlAjIG0OoSClcSjkvJ5OTXC8MGjnh0ikHaXcSDgZ87KPVxHPpfTVk4xPENkh/FxmzdvXOidkNtTXBGNZQzp7oY8+x+cmTatyuEHkuFV63ypQpBR+X2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DnMCMwvYdmuvkHKTYWeZsgtBZoZRZM0qwVtQ56ww+8g=;
 b=b2W0ZboZlPKioaUQz3byxAB9Ac3lY33CPjux4vTREAKWAfWgWdTqpIcNXuTfZgwmITeEDM9p4eg74oMyyZ4e7gdSkRji+ljqEMSTeFqipDLmltpvDp+GJpxDzML6+VR+cZPFhCN59LvUlLrWTtpX61jrN+UwHruxQEtPCHCIHk8ui8zVjFCNdiI9j9uFZtq/u+zDiIjUdXgf1OcZK9v9dNceFCkcu0J6wHFmSsRxMOw8wWSb28AlymJsIjK6ZAmNShV4tu/K8spotSY8tO8iA8VTDzsnaEaxoztrr1Wnw4Ggm00X/neTTQ9u0vn7RGDEb7g3DUukbmtBreUG9OiJIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DnMCMwvYdmuvkHKTYWeZsgtBZoZRZM0qwVtQ56ww+8g=;
 b=w6ZRRl0u6+ZYQnS4BIV+GpLwUdLg9tDWDOfb5J4u8fXxm4fCIdJHD+7FMQ0W7uR0X0aPRq5qF/MspTPn56PJet/c2Oi5kGyiEZQRJxoFYsfQrtnmqwmG3D526glAEemqzQqLAYbNdR0MEgI3I2iRZaDC9ublIgr/1HT6ZpCbMDY=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA2PR10MB4793.namprd10.prod.outlook.com (2603:10b6:806:110::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.14; Thu, 31 Jul
 2025 10:20:55 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8989.013; Thu, 31 Jul 2025
 10:20:55 +0000
Date: Thu, 31 Jul 2025 11:20:52 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Zhang Qilong <zhangqilong3@huawei.com>
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
        David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v3] /dev/zero: try to align PMD_SIZE for private mapping
Message-ID: <5dd6063a-4b67-4345-bd89-32085bb5923f@lucifer.local>
References: <20250731083655.1558076-1-zhangqilong3@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250731083655.1558076-1-zhangqilong3@huawei.com>
X-ClientProxiedBy: GVZP280CA0055.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:271::12) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA2PR10MB4793:EE_
X-MS-Office365-Filtering-Correlation-Id: 856de995-0b82-4d62-aedb-08ddd01bef6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?03A+gZtui7GLZZZ6h+fzYu1r5VjT/sWPixAj78L2a0KeEfTd/sOFqNXpXH2s?=
 =?us-ascii?Q?rbLBXD72pVX6yQ3WtXF8Dlbty3+U+NDduueA+IZC8YSyCQ5zxPCKmbEor1hO?=
 =?us-ascii?Q?LWLqXbg7xF6yuIjAG3xZaNiWGg8uzRY94nwrVtiwc5s69O0Df3LjBp+tyI/O?=
 =?us-ascii?Q?EFDkN5OSx9jt2+T1vc948LekxYn7LbQTSJqr/rILGF2jKE8Wh8BDTfzT4cuE?=
 =?us-ascii?Q?o8Uw4ib3Gvz+JANO6+H7SEQyn/h2v7QGO8LYqaFI4+x3zXV5iPi8znLGA67j?=
 =?us-ascii?Q?1ny95C3YKNglVbFYntTKX+DTNpXqA+BwgkjceEtnoj9apUHd/+mfBrF/zfG/?=
 =?us-ascii?Q?cIrnpQVfgKNGp74v5KwvXecg+T8ZlZo2bMTwAmqcso8ghJ2/QGH5L8KD94/7?=
 =?us-ascii?Q?RTT2iv/a4HDssuz0dSsv5h9XKZ7Dbo9C922a+lv/i+lFBIIGMOQYWC1q3R5C?=
 =?us-ascii?Q?E2eY1IfEvNsm4AR3liozjNLCCzXQ47bQ8SKoub1P69dnYGhGms/ATeyxgpjK?=
 =?us-ascii?Q?hfcFFehOuQEOWgC5lEqh6ROhpSzcMg+RYlZK2N3sxbUqYD5elhVvzetZElwe?=
 =?us-ascii?Q?7HkQYGCCFJkiiPBwiGsQtXFTcJ6IyTivGjVfGleKrBiJNcGfCRdCXo3GxQTP?=
 =?us-ascii?Q?cXJFiq3gJ6cucKw2tjQCRQuFz+Rlbr1d1P6J+Y6vfesTrIsgAMRf+RXyYIIV?=
 =?us-ascii?Q?BvgAk1bGZQn75ocjdxGZGSUs+/rZDfOoFVIO2DXCQFCC3ZPapK9psMZuRjce?=
 =?us-ascii?Q?1BGabrtDKmYYHYzCgwLVpobuqTlOPI/qAcDITwdKMX+MQ2GKdKUJKUaNvia8?=
 =?us-ascii?Q?KtwvIrqR3G5m3fH97XnVdwjoko+lPfW6h40DSSczR93G8Zu+9NIFn0w/6WSh?=
 =?us-ascii?Q?hWK6N0Ya7MRxvrU/GlvQnYaE3+pupvmfFPntWg3114HKf0mvos5d+bgHPwky?=
 =?us-ascii?Q?6/xRnle1lRNOeLgiSKuNC53RC9XhW5kZSMfpQwpjqPyYYc9JIlR8VrYzyz6V?=
 =?us-ascii?Q?nL/V9bL1+Ek08iPQIUNZ5hOMCqfEoM8/h8mzVgb9RH8kmZ5OlKy5S8RzfJ5+?=
 =?us-ascii?Q?cRQx/TIEJbcGiPj7CcLHn7EIlukz+Rj/2acJIEdSemULBlfbLeGGMHURdZ8C?=
 =?us-ascii?Q?6QKLWCEShO6hSPjpYnO1wbaWxvv/PP7cYXRunXH/r2NuV4yuSBpD6/pHkW2I?=
 =?us-ascii?Q?c1dQVR00B3vze9PhyACcIaumRFoxMmX0vQ1slmyvCHchzXflZpERJ5gYJMDP?=
 =?us-ascii?Q?53poUdYwhTDmnlxLYGHAeMv9bniNNjd5xL0TpURBxChgF/meR9bg3c2XrJmV?=
 =?us-ascii?Q?4GWABZ8NjZ1VuWTOD1jSJIxBnBUoD2fA4mhD9HlZqMHw6ig8xYOsVEiN7Lgv?=
 =?us-ascii?Q?o13ERV0p+3YIqrvOXnZ/2+5n8auVZ+ys7R6Pg/H54VzHnY+I9oX43Wv7TCGr?=
 =?us-ascii?Q?hT2SXw6FOio=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?a6LQY3sEGnjEbmL/I2Ei4lUDVQ1QhGk+e1h/2gkkhkCAkWhGbjxGTPT3/vzH?=
 =?us-ascii?Q?f/iBUpRfd6A3jTjpTlnBYYzclxn5281DFuA/frMZHhYnJTv284FzTwb0rN7D?=
 =?us-ascii?Q?xdXNxZ0tF9PYPVd3oGjqbHNLG/CWbfiykIf9vU9ZLTQatnfLJ1Wk2Ad7Lin1?=
 =?us-ascii?Q?tVsLbt4eA7jJ3V7FyPpesxqfcG30Ay9FVBMUmMwIMNvyVah2K2X+Ax906pXU?=
 =?us-ascii?Q?g8FdMSAJutnNLbKyxHCj7PLr+o5UoJa2ZpsVfmRtq4qJqOLF8KT4HBxu5BwW?=
 =?us-ascii?Q?iGFplcesDd/I//BGPbgC83pD/kvs0CIFQh/cjfjeekMsbWUGJRXvm5S9PkiO?=
 =?us-ascii?Q?NVM7mVrm3uAMKsu2J+FXI3HWV+TiLvZo65tcRSpMTCpiblhRzyyKAVApxQWV?=
 =?us-ascii?Q?oG6BGyWBN4G+xD/VKHv+0Bbm3eQxYkWQ+4MvFn7sZgm+nTWSsKak3qB0oMYI?=
 =?us-ascii?Q?HdT8gZ/O9s/JgbathEvLr578BU+vg5UZnl4tzXiGzBCQk4D7Oqwj2Foyz59S?=
 =?us-ascii?Q?8cBisycVYkw6d1RbscmYFsviesxJ/CMFfVsg6O8qPCIAWSmZt9dBtmu/ekL7?=
 =?us-ascii?Q?uNwQiYx83AHDQiaTbPTGFHiXjyqpeyQGHUDhQqAewubWs/N91/LYzSJZV0Js?=
 =?us-ascii?Q?88DYk9s4kjCuZTezlsUKiSjLoZhGTaSAPlbwZYMQQuhvaSbQmzfWGaaxTrT0?=
 =?us-ascii?Q?XfVUSqwUJ/SZ4n6FiVIYqVu7C8SfgPsSRX/pd7GljmSaF+ivg+y7yc05irND?=
 =?us-ascii?Q?oq7XyLDCaL6Iatvr7br1QkpkhFdOopCb9A1FYkI6pYmtVUQsVN2W5nDMKD8c?=
 =?us-ascii?Q?gt1eqSNR6e8Z0v2OMo2Y2Yjxc8DmZWTIA6Wx4CuTB8rnZE1rkVyyDEw7G8gV?=
 =?us-ascii?Q?uQK4XG62uR9KfnRROdET3TjJAYpU8K5lIlX5wCnLJcabEkCYQE9rVwhkPTcD?=
 =?us-ascii?Q?Mj7e9OXi3gUvQsGaTHAokF3cAwP7PPz9w+REpMLCI56Bdge7EoaVASPz/1AT?=
 =?us-ascii?Q?JzlTZGvD/bwO2iBit77S7t9euLc82znSwf1AMuj7WOFeZOeq7M71lkkYv8Wp?=
 =?us-ascii?Q?lG5KdDWRDBajaxYMEX4q2+pF08R2Rastxeb/DJlXmvzvxbdQGtkgStd6uCVk?=
 =?us-ascii?Q?ZfhWo4OgtCAuNAwnpoQ+SvaUqsSlVpki9N7Nx9LDwtKt+MlDTLFByliK9It4?=
 =?us-ascii?Q?3glhE4FAbE9kX9VAq+YYun1qX5TQSrS3cEz2KIR/7KykMA97Y8aoKv+AQsmq?=
 =?us-ascii?Q?cR7PgU5XsBcRAl/HhcpP6g492Kzn/zr/CnaNGmS1egjwr0vDZd7WZHmTphlX?=
 =?us-ascii?Q?RRIiKTrmZbvd1ZsP/AWQmo55VDxnm3Wgn3v9HE7wVwtYLsbiTCPscz0I75Xo?=
 =?us-ascii?Q?4MISJBRSGL+3K1jERUxaMTphu6A9gDm1GPDiF1Cz+6pF4cpee+MH6s5pbGYZ?=
 =?us-ascii?Q?VjzY2po/JaJJvtAlqr9rKncQpDKxCCjmHEfbCUQLNyYkezVstjb4IeCM0NdL?=
 =?us-ascii?Q?AtISVcu+cenppedyqdaA3HiGtT21nx7iQUakXtapTF+xpUBiejS8nQGy6FYI?=
 =?us-ascii?Q?gouXUnzmWMvrtB+Niit2Fa2HkTqxpbQ9nu9DAlLCEibTQ5gxkEAdxbl7+Glt?=
 =?us-ascii?Q?wA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TIlSRkbiD0qHDJmdtzYzP66U6rsCgSy1zQyWaT+HBIt+D2gKgLtD10IPo/O640/uvp/N5buTlBpi7/6DtEcG4S8Vh34gMgvl/X5Xev4h38jFSJV5/ZnSc9DuHkvQdsYgRsYd8SBuLcTgOGWy78mLuJfeT75NZBoIBcTn+aAkCm1SQs2N86+frKdwaymEjp9sYw9G/nCIR3Obz0jFSn72gGV86W+bDanbqQFBIbPf3VnL+Lg5RRcObhDZRZj1SOT8SXf/9uSv+4pE++v4Nq3LUvDDdJkO2OWlIrExD7OhMAzrhuUSPZmbroIPrqE6MF8XYPw7WJJyktci6WtA9e95pi11I6mj4g37655vM+SJ7SAuWZf8dE2sbioxm9KzC82i44HGM3czPKuuIyUco3FPVJce8WfLENTXrw9p07MSKkBD3f0Imji+OXnav6tK6I3beOpF7uj3BqQeLA3jFaxhI7L/RaGsKI9bHUwr/p4FdUIq+Y8acEPdwI2hnLB5JWfdqV76Ss9XtkvZaMq3sr4AV/apDlGjrKHMOd+kBa3zo3LPYfwzAt3L6z0nBlSH4GZE85Cr3g4VINiZdHQue2XH3FPh/I+T9nCBrK6lel8JhRE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 856de995-0b82-4d62-aedb-08ddd01bef6f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2025 10:20:55.6927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f918CiXgMeONzcdNh1GmsK5ctkJLck8pQLkXq7hnn9+PZNd2mRNXvY1PnQLH1TYkHqEFnv+WL969Xg1Pou9CuWNZpDS6b5mLbwrd6JcZhGQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4793
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-31_01,2025-07-31_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507310070
X-Authority-Analysis: v=2.4 cv=X+lSKHTe c=1 sm=1 tr=0 ts=688b4394 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=i0EeH86SAAAA:8
 a=yPCof4ZbAAAA:8 a=GchUzKuH8IJvYVf1HKYA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: g_0wJNSZzqEyjCqQ3mvYfIk-Lpa2Jc-S
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMxMDA3MSBTYWx0ZWRfX4qvThrWZruH3
 wsyJipQy0Y6uZh2Ci+rofpbSElF3xHYbyAlzlMK5yKLf5N3HgAB9cOGsm1T3p1KUrWXl4/zWpkR
 1pKl99S68yeAzJHwrVlGxjCv1QTKcA3/Zq8eZVm1Ou2Fjf0x9/FK/L4Tb45b/AuQl+vXqun189d
 b2OBxNSxJyl+BNbqIzJjeNGNZua9zoNX0mUW2iTDNNNy6ZYSMVijXgBBJRZQL3j9VkbtujTS7Jg
 gNferdRIzbJegzdTKGOlYbvZwrzeQ6z6QuOJnXuNfuq7vUPyx3GpmqB/BoC7LoaPp+iMdw9Yitj
 LJx+LXFewWJ9GDrptYzzMVFksNwtMl2ZxRtrd8LX8w39B21z8Gqw7TTQNjiLV5XBWAwqsG4WXFa
 yL4k5Rom+izAX0mihDUN4ogCMqaRzzSuveW8TYtHd5ZW8NwfBvRb5hQ+awm+A/aeHLgscsob
X-Proofpoint-ORIG-GUID: g_0wJNSZzqEyjCqQ3mvYfIk-Lpa2Jc-S
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E1F601C0008
X-Stat-Signature: xu37tho9yins7qte4z19nrrnxt9caa9j
X-Rspam-User: 
X-HE-Tag: 1753957287-600295
X-HE-Meta: U2FsdGVkX19k+Qbyd+uj21KzekmpWUTcBaUiQa+qUwXDVyqWEJY+FevbVS0wY+ZBhVlS7f6Xx1tdg1uUJYrd1wH+9LDOq6+J5nNvABXEv6Ea83kZ9CraHcXDEak2jQxObH4WH++fTK8HBOxrBRtt6wNMxXjE+3eBWBdQQRfwII7J1uQQL8BQDz6W+qrB+iJYmbsRhDuzTzR43VFL5ieDuY9RcMlFUOwFWdBViEr43iJwFCtVeEVN/LEvPgBCG9Es6duRyCex3Vom5pPP8GGXgqIEZDqkX89k7Ok8P0Meii633l05EvHGqQVPcRRivzyCSIYjZq7XxqvX7uZBeYdgnA7s9yS3RfG3pNSaoIb91blVSlTS/5oXbv0300c5Vb9in77jQA847F8CeKr55EhUHGIo108rk/wvVGIj9cJD/vM8ncpdJzZTgjKiIhXytenvL/KKi9M6+NyFGbnB1sjcksXHXjiKZhKbCEUgt/Midr8EIH04hFuLd2ICzKldQf9gyBw62WNbdjaVGzXrsuSXuOzMCtPDEqhqDPQUial7dWt5E4TwrKGUGKQ64l/4WbBEQKxTPlZkihob3M3PCPptmIpBX6XP86EGnposi+oMLE4keJYfSs4U94pOFT5efDGcawPdo+QatulE4hTpefbmz97Q71+tEA8bQXAM0AxYraypc5sGo0RF/UaeF9674Dm5mULV5/Sk8LPqmyfqr1aawD5DpCwNIbP/2jytdkg+cOY5GglD/R2UCN4Rv7BGjABnnQazPUAcm8YdjpWLBQA/jBNortmmkaZepapxyDhP02YSOO8fbPLFWCFY5KQDq/HWEH6lcNZbJM1uP+mI0JHTTaj4IBnEyRY4A1FmzOKp6002sb9CuxeekOimxTpHbMkpBRABkvomUIi4SV3o6awIvnNei2aqf/IYyiBXQpKSRVG1IxZzORbmDDL4L/Dp/V22kqoy084UHkv2oou/rFB
 LaWcwhkn
 +FwIiefaAyzuDOLyYRB2MNxuJNG3QuW77B797JqlhvhM0qW6VTopiCOBqzGFHB8PPR990Pa0kzo/NR7vRLUKaovOiHOVgbXFpD3UKTnlws+pYMeOW8AX9l0JYzCWDlH7e1s1nIuGAsM5N3BGbEw5rkb9v/c5jCtrwpf2mAIrQRH0npq9Qv2Af8bCiAmnE7qFjf0nyHt80jeBAJtUg2sZ9Y84mnOyJzp7BGH+d5kc1R9yIk2V+3boibOEWQ+aXFt0VZCWe8pw+iCJXnVohLVFQuFi+4YWltmnfHFKCOfX4n97J6AikQRCMriFwAfrHSoVNab4wdYxAzmrCsybr73v97c8LANVBkucWKlpWdKPKaQec2tEMS+CxDTkadKhnlN2AiFlxg1Alqb2mb6ubyoCHnrDYdnJ+I8ms6JJGUlZ5zWBNyNmsn1a03QQ6zyQt1TFZmP2Ex5tVedde/7SGzPW4ryDomMJ7M7MAFdyACPf6v9zUuxZVs3wtNtmd0SHvFFTy3tgHg1bi3gm1fMGGTSWO+QQU1yZF3+fDwoCyXcs6nxxBo6/x8SF++C017/pA5N81vMU5FYsDfo71lS+D6Wl6MVL1S2GQNz9aeriF4/0lccnENUsq7TsIHsOAnFOkdcSfSCsdpfv4TrYWPGRZWSMHOPCgG0CrRBH7LlBotSQAUBDQwLawKRZ1vzcZ/GeBDmPUxbFiek+FN7HR4irOqH6Ix4EASVgyzDhVMvEc2okuG2bCNfgNSVKV002mubDYmHj46os58qWdZ5a2ZLjYITOXh+nftzXr6G/V/0aS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 31, 2025 at 04:36:55PM +0800, Zhang Qilong wrote:
> Attempt to map aligned to huge page size for private mapping which
> could achieve performance gains, the mprot_tw4m in libMicro average
> execution time on arm64:
>   - Test case:        mprot_tw4m
>   - Before the patch:   22 us
>   - After the patch:    17 us
>
> If THP config is not set, we fall back to system page size mappings.
>
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

I did some rudimentary testing on this with a simple MAP_PRIVATE thing
which caused no issues and I observed a 20 MB mapping getting aligned and
thus benefitting from 10 x huge PMD mappings vs. mainline benefitting from
9 due to misalignment.

So feel free to add:

Tested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Cheers, Lorenzo

> ---
> v3:
> - collect Acked-by
> - factor out the #ifdef CONFIG_MMU in get_unmapped_area_zero(), per Lorenzo
> - explicitly use #ifdef CONFIG_TRANSPARENT_HUGEPAGE, per Lorenzo and Matthew
>
> v2:
> - add comments on code suggested by Lorenzo
> - use IS_ENABLED to check THP config
>
>  drivers/char/mem.c | 21 +++++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> index 48839958b0b1..b7c4dbe4d2c1 100644
> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -510,31 +510,44 @@ static int mmap_zero(struct file *file, struct vm_area_struct *vma)
>  		return shmem_zero_setup(vma);
>  	vma_set_anonymous(vma);
>  	return 0;
>  }
>
> +#ifndef CONFIG_MMU

OK, the convention in this file is to invert this check so this is fine.

> +static unsigned long get_unmapped_area_zero(struct file *file,
> +				unsigned long addr, unsigned long len,
> +				unsigned long pgoff, unsigned long flags)
> +{
> +	return -ENOSYS;
> +}
> +#else
>  static unsigned long get_unmapped_area_zero(struct file *file,
>  				unsigned long addr, unsigned long len,
>  				unsigned long pgoff, unsigned long flags)
>  {
> -#ifdef CONFIG_MMU
>  	if (flags & MAP_SHARED) {
>  		/*
>  		 * mmap_zero() will call shmem_zero_setup() to create a file,
>  		 * so use shmem's get_unmapped_area in case it can be huge;
>  		 * and pass NULL for file as in mmap.c's get_unmapped_area(),
>  		 * so as not to confuse shmem with our handle on "/dev/zero".
>  		 */
>  		return shmem_get_unmapped_area(NULL, addr, len, pgoff, flags);
>  	}
>
> -	/* Otherwise flags & MAP_PRIVATE: with no shmem object beneath it */
> -	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);
> +	/*
> +	 * Otherwise flags & MAP_PRIVATE: with no shmem object beneath it,
> +	 * attempt to map aligned to huge page size if possible, otherwise we
> +	 * fall back to system page size mappings.
> +	 */
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +	return thp_get_unmapped_area(file, addr, len, pgoff, flags);
>  #else
> -	return -ENOSYS;
> +	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);
>  #endif
>  }
> +#endif

Nit, but can we add a /* CONFIG_MMU */ here please since we have a bunch of
ifdef's and it's noisy.

>
>  static ssize_t write_full(struct file *file, const char __user *buf,
>  			  size_t count, loff_t *ppos)
>  {
>  	return -ENOSPC;
> --
> 2.43.0
>

