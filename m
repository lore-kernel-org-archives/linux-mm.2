Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E1C8CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 09:47:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 853DC8E003C; Fri, 17 Oct 2025 05:47:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 804C58E0016; Fri, 17 Oct 2025 05:47:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A5F28E003C; Fri, 17 Oct 2025 05:47:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 560A48E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:47:01 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EAE968843E
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:47:00 +0000 (UTC)
X-FDA: 84007127400.28.DAD4CB0
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id A0BB14000B
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:46:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GJf5UnH0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=DEksCKEH;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760694417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IJ++FRGZFaVl3/ayKMBmpO/2oDT7/+1Pvc7iLBNkcOU=;
	b=Y7OroTMYM7oQGK2NKmmee1lxEZHX5eVZvROviiQAshCEGH5GEUtkIx5g5kOiaQkRLFCm3r
	icD+j2QdgEJ9DQfeCrX93EuvFlvpMErGRLT4P1zDJIbP5ytAdFo0cUeDe92WMUMENR+sTZ
	dxsoWqaYGUwyCMhv5E5Ia5F8K9xq/8U=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760694417; a=rsa-sha256;
	cv=pass;
	b=HtIp8cKKleMKkLD744UNFBFUD7f4IMNClONJVTFvmTO9bok5ya4mbIm21tNbh6MiN2Q9Ky
	DitZzwmI15m545wwOHCNoDB6XzphVvSJIPcPne3C9Kb2cCtrE2DzG3ZIseXKpc9Oc2Osc4
	yxDHg09X7Huzk4XzLXJNCZDP8QhUizo=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GJf5UnH0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=DEksCKEH;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59H7uCMD007977;
	Fri, 17 Oct 2025 09:46:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=IJ++FRGZFaVl3/ayKM
	BmpO/2oDT7/+1Pvc7iLBNkcOU=; b=GJf5UnH0v1yUJVxPNWKtUSlSC8CGenZYA7
	wVuBjVOVp1znvhzViKl71kWI7fagdkpLBiDcUvaKY3BMaYxPkxrlSPrt93A+UDEY
	aZ/1+coyHK09EJ7ee/1ERDdKMKhqkdJUoMEoHUAwGfMyPhRhjdeudI7hAzN+DsMz
	TmRT7uTTNqb9bkZeWKK93dJh8OhpiBZNIDYKHrjR2yVgdCT9j0H8GhlJsrMnRlvB
	qudkP4ykeEpnXWxZzF6Y1wzCwT4TNTtMcrFrPK0f79j1GHal2AR6J0YVOyORuyYD
	ASapxdOa+v3r5HDskqw8px3VnK4OUNGAiysS5UkIaEdrR683RkuA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qdtytp7h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 09:46:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59H9Xh1L025823;
	Fri, 17 Oct 2025 09:46:49 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011052.outbound.protection.outlook.com [40.93.194.52])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49qdpjvfsk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 09:46:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ARLCMUBL+foyFHy67/68NPf0kvU4bb9/WEVCeIu7eo8Q+Hi6RWfIBIdRSFS4rvrnevqcLSZZM8AxyRyLOWI42O/Lg8Sho4NJ9C2U5Z7wl3u+tOunfMLXsAYZVAXcLuUD38ttbCak6QyD1BtD7kU4W6JEr+zjWskA2HkI4oqpWhh5Oa5FcJ69NRCkLnIb9gAPihJbsjK62HX5XzHXilcCZF1zqw/k3/IN77r9oXbuM2zTuy/3W8rs4xirrD2GVhJHHtkTbQEle2WNmCJe0riD5n5hfjXPqNh88J4uIPCrxQZZPDN+m69/T+hcoMXljmt72IW+NN8lhe2o32qbZPMXfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IJ++FRGZFaVl3/ayKMBmpO/2oDT7/+1Pvc7iLBNkcOU=;
 b=NsjcZOf8s8I3ftFTqiY8pWUcOiB8ojQsJGL+eLNU4zb8LeQNIDl4rCDZThHAsbW+xngGrp+mY3B2xbXJZFE7b+2I+jnqMpr8YVtFwMMTwJXd5HruzRCvtR6+tq3Sf4T/BcI3z4pbGgP8NEYVMM5sR6Q1rbAJIsFFfnMUdUj1181hH4c3Y43e1Djob5Vm43f3wljA0NrUH4ltz1gKk/8pb/w1CVg40m+9vj5p2Hh1zk5ZPJU9hpGMxQVEQxllBTbbcwKuwiKfWh1rpDrsVvccjW1rBfUWT0AwBEn/yA7RpSE/L1iE+tDQri4Csi9rO/AUlY06ssbkL24M/RQDpE8Xbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IJ++FRGZFaVl3/ayKMBmpO/2oDT7/+1Pvc7iLBNkcOU=;
 b=DEksCKEH3ZjpRYUkOe8Vw9PZiwYCSX5FaNbj8vQmtE4wEgdi6BNEPZ9hyi26ySqpneVN06bZZel7Bin5sKyNFCs8yqti6TEbmIaq788jHvqV7/Wy0Tm4siRncnZY0aIzG7oIEFRzPFGlE584DS5feS8vbrMUy3VkCz42EjGlho4=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MW4PR10MB5677.namprd10.prod.outlook.com (2603:10b6:303:18e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.13; Fri, 17 Oct
 2025 09:46:46 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 09:46:46 +0000
Date: Fri, 17 Oct 2025 10:46:43 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v2 1/2] mm/huge_memory: cache folio attribute in
 __split_unmapped_folio()
Message-ID: <3d4b9f1d-a420-4961-ada5-355b60909d4a@lucifer.local>
References: <20251016004613.514-1-richard.weiyang@gmail.com>
 <20251016004613.514-2-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251016004613.514-2-richard.weiyang@gmail.com>
X-ClientProxiedBy: LO6P265CA0027.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ff::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MW4PR10MB5677:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ccac911-b025-4d70-4f58-08de0d621605
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CBfgQOz2kj+EAh6HcLCodpdMq6bKmCxeHZAhbQ92bK3NoRW1zLoiHGlyOufp?=
 =?us-ascii?Q?qAEki8AxfwWUSvS+X6O9doY0kTL0nmbtD1fnLElyLMR5aGqnZ7MgXtipsdFg?=
 =?us-ascii?Q?OHvfteB2UeE6eQEH3Y+JlsfMMylHe0RCUVMkemg4+X1muQ6RTOrFHGmGfgG7?=
 =?us-ascii?Q?PgIKRl4nFauJ+JBdgUHZTtZNHdDJePUPE+GP6De4eXvsCryoS88n7qqjTp4F?=
 =?us-ascii?Q?rJ8CYpdrwgcWQqOuL/a7R0sBb3tWmHfmTPn4V9I3iuvosnx7eMBKDT9wn/bB?=
 =?us-ascii?Q?gD3i9cUCuMRhN6nS2GNaR/Gl5IImmKjSGYCR7LA+JhryRJHY7gxclEQQ+gkf?=
 =?us-ascii?Q?4yTJVUQ51mih9kqYDnvMOoVD1SV+Xd/UwEvG9zIR8Kb8UhzT6BU5LGz9KuMM?=
 =?us-ascii?Q?ead+lWt6nkYZBZHj2nYMvZqpFY/sN49/KA/0kC3dKSrjQ7vmgDOpcznJFxQ2?=
 =?us-ascii?Q?kc97ckfwjb1TL4XVbXj0Jkrp0yR1YtVoEthNvtiIs+CdoV59xoJD3w7m5Nr5?=
 =?us-ascii?Q?kTdr2an6MQCXQ6XIfu0QLfn1ywXT/zE+J1eW3nFLOuAsCjAnkyJj6pczkVep?=
 =?us-ascii?Q?IiLKEEbz4OHTjfAujtMOQ96p2T0r3nUfjSjDU6Fm3QVzNR9UfIperXFOT9Cg?=
 =?us-ascii?Q?OWcMv+Fx9snnBqXGHST/XVmUtiQBscyg65pp5Ogg1Cqdepm9Q0wJIXdtMxiM?=
 =?us-ascii?Q?McFi7Qlp21wG4LGgejrcYLnNVCTielXlVn5yl7NQ1g+IO3W2iCH5N3nBsKAB?=
 =?us-ascii?Q?32yD+B8LCjblmLE8eyj4RdUvwp4/hJx2nhITLUROdzoEbGdlaEAtQX0Y/aho?=
 =?us-ascii?Q?GDyX+bXpcNdxosxnzq2Lf92sl8U7wiNew4DvynTbHM4eD2lNQNQb5By15qAv?=
 =?us-ascii?Q?mjDu7aiDYTj7i54Jzt83npbgTkiTJlqKNnoXKEy4RPHfcQZNy70ALI2hPlOL?=
 =?us-ascii?Q?HXuhPIki/+9HVavfWroPiz20ijFXDtBoVRVbIb+obb51H9X8VEn++0fTdwkU?=
 =?us-ascii?Q?WbrcvDAaYM4hO370D960woXPcVTDVIBKDfXSETXrygBDlsCvjhyGI4LwQ9Y2?=
 =?us-ascii?Q?4GiD7/vKTJ/K1EwKruqzYj4DYYQwt9J9bXvGpWdzvDjCUsRPFheO/aD3a2ra?=
 =?us-ascii?Q?40iKorgEpUqZm70NQaelyQy+PJLaJ2XjwMKIfwdOV7b/MowOfQBLGqhtS2tA?=
 =?us-ascii?Q?l1j5bMI4SjOobXVrcSPSytLjDsSWbJLWCFMtWsTwpYkVLnHEgbqpHTdy0ZfC?=
 =?us-ascii?Q?9JeUoOphGmUp61magkMZqRgQNdct6a2W7lXO3CXdEb0aOPE5YxxkvjXFFdeU?=
 =?us-ascii?Q?Hnie/nJEaTP8QOynSSkswBto9cYKn/4YZpoTEjulPDjFOOwMBdsohqcasBvC?=
 =?us-ascii?Q?S5MxJ+Nuuh/8ZbO1IWqT5UMDHESWad7aRJgEEkN0pOYaiDfR6ImucjZXbpws?=
 =?us-ascii?Q?JOa2TbMxwn7A9+1sFIK8ymXaXPxXg+lu?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2CE8Kjv35H67y23KILB+LDCByWqttUknH+POxXH6zVtJipILb2NH7qdTHj+F?=
 =?us-ascii?Q?QkBTOKoxOF6OcigQDHaH3IZFgsoKCtZzawgrWp90CW1/+qQIcdwNqslGbIWX?=
 =?us-ascii?Q?mzTc82RtSqjWZbSLNZdDGTjUek34/c0QCkrHMscFIP5z22CK7Hqi+pCWNTcA?=
 =?us-ascii?Q?DMHQruja9hXB37mhv11eofnZTcCVf3lZY0id6h3uaEfm317uduXbR/8HBvqH?=
 =?us-ascii?Q?KLqjDXf/sTxLv4fYU47nODxt43CgFafYlmjTdMxvRl5u3j+AlPbcMQSGu6yb?=
 =?us-ascii?Q?CU0rXkTZYP+1n58ZJ7HDINv8W8y//q0tEEmK5av9wKEsEYf2CMxygchyorO0?=
 =?us-ascii?Q?scSAAi1L8A+QfczLrs/9QW9jYF4X+09CSUvoryuoD7OcyS/yQuAZT7hkA+ou?=
 =?us-ascii?Q?LLsqbe6tt7gsLLomtnm1GsqdxFRVofNZb/npZlscSINsNeOM8vVCp73NP6aE?=
 =?us-ascii?Q?Ja6En8Rc0QoJelXWf3ET3ksyPaJ5NwaF9X6nScLYp4wp8b+uXTMUKvcX9+Lx?=
 =?us-ascii?Q?vz60Vvi8axPCD8Nrq/Ve4Sb/0Rv9hMiKI0glf9oaZlc4TFN+F7WqJaHA9ikF?=
 =?us-ascii?Q?swd0lOpjS0IRwsF3YSyVuBsKSVAdwBnVVPhE6JyCDyVLUzpMNAfNIhU4qoYe?=
 =?us-ascii?Q?zdd4+Uc369OVgLtrjFzujfEAgOfEl2yRsE99YRgry8QGPC2Rn1kGmURVqDyN?=
 =?us-ascii?Q?3Cs1BOEOAzUjJgBNY1HUBw+n+ZkzqWdyWiOPCrwbAGvn6iQ7MoC/chPflFT5?=
 =?us-ascii?Q?ySPtebdHCn+ZAVwKnGbXED4InCAECxtVWXwgvk5JkWoKilDKAcQzX4v1v+Md?=
 =?us-ascii?Q?wa4I0Sue9bI6AZPW2oBnZAB1rrhkCOKOWfZCzHWbBJlEyCeJav/1mfKxqBQh?=
 =?us-ascii?Q?Ir7gje16NiOoddr8VvH5vt+I2bLdBMNanO6vJUDbfIUfsNPYEbVD3nnESFvs?=
 =?us-ascii?Q?JfRWSQdD+LI97rjRiN9A/zUSo/RzD+zpppPIf33WK2djF7PxA29188xEVs5l?=
 =?us-ascii?Q?j+ahoPD1wSIrPaWRyEimnjRlSz8x3xF1rtL/3XGezmx6oqP0bTkKQYBdF20u?=
 =?us-ascii?Q?JiN+z4PKe8uEnOTeNS46JYjG5hl97gw8kqjBVzb2UJvrDLgR3OMGRzSycWBc?=
 =?us-ascii?Q?K0qQ8neCgyVViRqwEPveTFXPtgTyHbOonbBq7zqElE2/f1G4qnjYPxw3AO8j?=
 =?us-ascii?Q?KavnEFhv1nT7F4XMbEGcXtHIaFc3UgqZ+KR7uFpth9UzdvE3iI+dMf6XUL36?=
 =?us-ascii?Q?iKAsWv2JXnF1VwrOm7tblxDoNuaVVw9ikuX0dROPiRnODc6orPn6nB6Zr97n?=
 =?us-ascii?Q?Q2ppTpNTUJ118XE3oDe3GcbTXg92FGDilQ7DMXIMWWs92DlTMav6g/kSoG8Z?=
 =?us-ascii?Q?1g8L2XJSXDlGK7uHADlggN6xXt466RjvsifLxDAyYfmQw745yP0BZAh/RGZ6?=
 =?us-ascii?Q?w8BADu9YltMmE7hFP0Nq1ZIcvXUCKdHscnUqn+HDiyaSe5WdtjieZE5jECTx?=
 =?us-ascii?Q?aLLHfAIhwdp8HeK18Uq05poM9Bh9oriMdBfg1Rod4BNRlEY9R+96UXP0TJy1?=
 =?us-ascii?Q?NYQEfIj7/M+Ce0RItSaLRwcPyrdxRgXXwk7WRRcp0G1CBu8vNCplykkMWdU/?=
 =?us-ascii?Q?dg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	46EpzzZ30aFf0dFjK0KvhyAO0yHrSzHkYLbWaoXNl0en/74nseToTewQs5N5D6Wx7sRNrBcdw5CLJMHx+KJ0ICxYPETvOb6G1Z3m75z+1ViZiJ1h1q0HyxGBDWQzn1+iV00T5Ca7Co+pWe2NB3ERauA1EO/bOFDHhc0Og4lx/9K1VLXL91fgR9j3B4cV6518q+RkkFtWofkJVGgnrq7ovFPTaRqQ0Cp2bFrM8xEqrlZ9LhBQscTYFKL0tivckCW7Eqk7VYTdFfPiWQJY7DglO1cCDKhemfWWscwet7KllwrutwjqUh3n9T2XRGzIYeHI36exhprPYx3nUMzJCu/aiBkPYncDKPq2z7wrckAmFu6xA22b6vqbU1vV/BvQk5YaRRFHcY+YpBKA7Mg+cxSVwWKA86kIEO6BqCnDlHnT7c0TfJqCIU8eF4HGV+vqMR0R6AeJKM7x9bQxJ0hbdjkVEHEWbfUWeTU7fn74iNkclutyZj8LmpZ/p+MBOtL6HQPQsJAj4yJ6VFG+AmFdfRZz4iIXy9h09rm64eMkLbvPraibf4q3XvZdMRoItnbJ8xYmazT3TZrXbkC1hWKmRJaEYychyS7q4L6RVIEbuZVgtR8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ccac911-b025-4d70-4f58-08de0d621605
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 09:46:46.1268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ruv2fL9rL8Vz7P4mj6aIqmru9+iLc5MvMpZHIUhbB2wcXr3/tXRrBgPJjAteXzDFB7oCUdw+DrpSDozpSR3Y8rf9VOMW75gnZChiFTBLmtk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5677
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-17_04,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510170072
X-Proofpoint-GUID: sUZUqdPDKy-_9QKg4M95FNN_Ru5fA4Xo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAwNyBTYWx0ZWRfXwGdoABoD5/KM
 AcF0TKRTUt3jvDz73rstOp8Y+V7Bgm5k0Va/DsLtsE1L535lLotudIUdv2Kp+i0q89iZ21bEKQn
 b+pjw5NGLDUx/YvYGFx++dM1qkvtWdP7i4jQA7ptCcxdV81sBrSk8TnOX272MyZHjF04MKmjdOM
 DT/fz9viiPm0SEeAbcRb0H+2qni1oKgakCooovnBO2d+qgfymlFFefNISlxC11axgdlI436bf66
 +aKM9zzMTAbbbRZqARnggjbom+UfER8N4EhC/1XLc/1rUmdirJU6hwEyACowLoTvDu52kQySiaV
 AG0AAXRijhEPmhOP6Hzct91JvA/aR7NYrHnYFQYT0zzCYLR8Ql7LO6I4ap8QwkYiKDfht0JJT7M
 nLDs5frmabLzTIlwUUuBLkqdCsUoIhEufctHQ5GGPOew2HXZt9Q=
X-Authority-Analysis: v=2.4 cv=OolCCi/t c=1 sm=1 tr=0 ts=68f2108a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=pGLkceISAAAA:8 a=Ikd4Dj_1AAAA:8 a=Z-mIGi032IADxg1Ml9MA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:12091
X-Proofpoint-ORIG-GUID: sUZUqdPDKy-_9QKg4M95FNN_Ru5fA4Xo
X-Rspamd-Server: rspam01
X-Stat-Signature: gezi5c5daz7d8rakbox3mnm6t46ziy5o
X-Rspam-User: 
X-Rspamd-Queue-Id: A0BB14000B
X-HE-Tag: 1760694417-400345
X-HE-Meta: U2FsdGVkX18S1hJyx9nGh2y37Ooeb6TnabFnnC7wTxqaLSy94vvMFiEPdRW962JrzNgmUx4IAqj6zoECr400Rzk6quVUdmYiYkp12as1DXPUWVTqKz83F9uPBsB/Ni/Dx1unD+WbaT/fFRYK53chfe6Sg99g5s5+Bic8BaIaS+h0QqZ5G35ACDTjjTloIstQYFPMcBg8LDV95n9keAmAKIo6hOX24YwxJeIJN4JYR1imb/Vy2H/jxvyJm5QgsK7sK5FyzJKyiuXMItqWlnTE43pkiJNvadcdfPMxWhN2gKEhofpXSTD/XLqCn7WbkgPdDA9SvveUiighDlo9+EhdnnepKKdixw9FKg5oF4x1r6dvp8yQdM1xUH2h8I85QU5kZdXolbjP2X6q9Yl/lWuFlfNsrLIi3uy6MYiae1qPnFmLQS9ZLoDjlVAmdKabpxFydlMMySZzuDJUDDTnUlV8PHxoA8NOXr7Ip1yATZ4gCUB1eDdoZeQ4U9Sy7p1LEn5pI6vzLK4N7eyPHBM2sYVEpUQv3sysrVOU3uko4rJBDYSxODE3i8XkUgDp+6Z/hkyZJIkulrjquRVFlTOUYnnsfvKjkeusYd7W8Q/IfXOQr3XWG/3KMXrdTctPMfWTxbNJTGfe+ElnEtZr1gHWNeAakXbBCYUJiM5tRh9roKyKnIKsuI2a6fkIBODVTMSpdQiGNFplWZJ0GdTP8ox5YdnuvFQPrPp9qqQcLLbLFoxW/Csndiry0fQ25UtYv+OLAvu8amVVXic5soVbKuu6Vdpbz6hkTnUbSY14yPutOygxzXR0lRdaWNfMKIubxk33+PnyHwAe6BYa0yslyE6fxnJ2rm2kTw6BLbEkXrqLMkIsQ43Q4hDLBA61f0kwcpry3fTJYNX4al0CHfcAkLN2cy5iJgQBzkC8xjo+dvWqm6NFhfzWxn7A656scIPu8A2wKSPol3IAYpNU/beekrmf9G3
 h28jfQ1+
 hCtqY5HOqix7vqa9H3/HfiJc1WVcQE+Nbpl1dzBXLQ/lNbnTV5IScMQd1Ejj7tZowidaQZzfLJFYlj2g8TmvXuO0x11Ni4kEV5XoRqtBRU0F3RcxiClFzFW3t8gNa3+pALkr/tIEzNsygwpVWc8LKIpgaYVT7x9xSdeoH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I don't like 'cache' here. You're not cache-ing anything, you're relying on an
attribute remaining constant.

Something like 'avoid reinvoking folio_test_anon()' would be simpler.

On Thu, Oct 16, 2025 at 12:46:12AM +0000, Wei Yang wrote:
> During the execution of __split_unmapped_folio(), the folio's anon/!anon
> attribute is invariant (not expected to change).
>
> Therefore, it is safe and more efficient to retrieve this attribute once
> at the start and reuse it throughout the function.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: wang lian <lianux.mm@gmail.com>
> ---
>  mm/huge_memory.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 3c74227cc847..4b2d5a7e5c8e 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3527,6 +3527,7 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>  		struct page *split_at, struct xa_state *xas,
>  		struct address_space *mapping, bool uniform_split)
>  {
> +	bool is_anon = folio_test_anon(folio);

As David said, make this const please.

>  	int order = folio_order(folio);
>  	int start_order = uniform_split ? new_order : order - 1;
>  	bool stop_split = false;
> @@ -3534,7 +3535,7 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>  	int split_order;
>  	int ret = 0;
>
> -	if (folio_test_anon(folio))
> +	if (is_anon)
>  		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
>
>  	folio_clear_has_hwpoisoned(folio);
> @@ -3551,7 +3552,7 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>  		struct folio *new_folio;
>
>  		/* order-1 anonymous folio is not supported */
> -		if (folio_test_anon(folio) && split_order == 1)
> +		if (is_anon && split_order == 1)
>  			continue;
>  		if (uniform_split && split_order != new_order)
>  			continue;
> @@ -3603,7 +3604,7 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>  				if (split_order != new_order && !stop_split)
>  					continue;
>  			}
> -			if (folio_test_anon(new_folio))
> +			if (is_anon)
>  				mod_mthp_stat(folio_order(new_folio),
>  					      MTHP_STAT_NR_ANON, 1);
>  		}
> --
> 2.34.1
>
>

